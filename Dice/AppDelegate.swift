//
//  AppDelegate.swift
//  Dice
//
//  Created by Not A Kitteh on 15.12.18.
//  Copyright © 2018 Not A Kitteh. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var diceImageView: NSButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var sparklesImageView: NSImageView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        diceImageView.sendAction(on: [.leftMouseDown])
		self.sparklesImageView.alphaValue = 0.0
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func diceClicked(_ sender: Any) {
        if let mouseDownEvent = NSApplication.shared.currentEvent {
            var startPosition = mouseDownEvent.locationInWindow
            var keepTracking = true
            while (keepTracking) {
                if let mouseEvent = NSApplication.shared.nextEvent(matching: [.leftMouseDragged, .leftMouseUp], until: Date.distantFuture, inMode: .eventTracking, dequeue: true) {
                    if mouseEvent.type == .leftMouseUp {
                        keepTracking = false
                    } else {
                        let currentPosition = mouseEvent.locationInWindow
                        leftConstraint.constant = CGFloat(Double(leftConstraint.constant) + (Double(currentPosition.x) - Double(startPosition.x)))
                        topConstraint.constant = CGFloat(Double(topConstraint.constant) - (Double(currentPosition.y) - Double(startPosition.y)))
                        startPosition = currentPosition
                    }
                }
            }
        }
    }
    
    @IBAction func rollDice(_ sender: Any) {
        diceImageView.image = NSImage(named: "dice0")
		CATransaction.begin()
		CATransaction.setAnimationDuration(1.0)
		sparklesImageView.isHidden = false
        sparklesImageView.animator().alphaValue = 1.0
		CATransaction.commit()

		// Can shorten the following to deadline: .now() + 2 if you want:
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
			CATransaction.begin()
			CATransaction.setAnimationDuration(1.0)
			self.sparklesImageView.animator().alphaValue = 0.0
			CATransaction.setCompletionBlock {
				self.sparklesImageView.isHidden = true
			}
			
            let numberRolled = Int.random(in: 1...6)
            let imageName = "dice\(numberRolled)"
            let image = NSImage(named: imageName)
            self.diceImageView.animator().image = image
			CATransaction.commit()
        }
    }
}

