//
//  FBMailboxViewController.swift
//  FB Mailbox
//
//  Created by Tracy Chu on 10/18/15.
//  Copyright © 2015 Tracy Chu. All rights reserved.
//

import UIKit

class FBMailboxViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var MessageContainerView: UIView!
    @IBOutlet weak var LaterImageView: UIImageView!
    @IBOutlet weak var ListImageView: UIImageView!
    @IBOutlet weak var ArchiveImageView: UIImageView!
    @IBOutlet weak var DeleteImageView: UIImageView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MailboxView: UIView!
    
    var messageInitialFrame: CGPoint!
    var laterInitialFrame: CGPoint!
    var listInitialFrame: CGPoint!
    var archiveInitialFrame: CGPoint!
    var deleteInitialFrame: CGPoint!
    var mailboxInitialFrame: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: 320, height: 1300)
        
        LaterImageView.hidden = true
        ListImageView.hidden = true
        ArchiveImageView.hidden = true
        DeleteImageView.hidden = true
        
        // The onCustomPan: method will be defined in Step 3 below.
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        messageImageView.addGestureRecognizer(panGestureRecognizer)
        
        
        messageInitialFrame = messageImageView.frame.origin
        laterInitialFrame = LaterImageView.frame.origin
        listInitialFrame = ListImageView.frame.origin
        archiveInitialFrame = ArchiveImageView.frame.origin
        deleteInitialFrame = DeleteImageView.frame.origin
        mailboxInitialFrame = MailboxView.frame.origin
        
        
        MailboxView.userInteractionEnabled = true
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onPanMenu:")
        edgeGesture.edges = UIRectEdge.Left
        MailboxView.addGestureRecognizer(edgeGesture)

        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Reset all Icons to be hidden
        LaterImageView.hidden = true
        ListImageView.hidden = true
        ArchiveImageView.hidden = true
        DeleteImageView.hidden = true
      
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        var translation = panGestureRecognizer.translationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            // print("Gesture began at: \(point)")
            // print("Translation: \(translation)")
            // print("Velocity: \(velocity)")

            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Translation: \(translation)")
            // print("Gesture changed at: \(point)")
            // print("Velocity: \(velocity)")
            
            
            messageImageView.frame.origin.x = CGFloat(messageInitialFrame.x + translation.x)
            
            /* when I comment this out, the icons appear */
            ArchiveImageView.frame.origin.x = CGFloat(archiveInitialFrame.x + translation.x - 40)
            DeleteImageView.frame.origin.x = CGFloat(deleteInitialFrame.x + translation.x - 40)
            LaterImageView.frame.origin.x = CGFloat(laterInitialFrame.x + translation.x + 40)
            ListImageView.frame.origin.x = CGFloat(listInitialFrame.x + translation.x + 40)

            
            if translation.x > 0 && translation.x <= 60 {
                MessageContainerView.backgroundColor = UIColorFromHex(0xDCDFE0, alpha:1.0)
                if translation.x > 30 {ArchiveImageView.hidden = false}
  
            } else if translation.x > 60 && translation.x <= 260 {
                MessageContainerView.backgroundColor = UIColorFromHex(0x55D959, alpha: 1.0)
                ArchiveImageView.hidden = false
    
            } else if translation.x > 260 {
                MessageContainerView.backgroundColor = UIColorFromHex(0xF24D44, alpha: 1.0)
                DeleteImageView.hidden = false

            
            } else if translation.x > -60 && translation.x < 0 {
                MessageContainerView.backgroundColor = UIColorFromHex(0xDCDFE0, alpha: 1.0)
                if translation.x < -30 {LaterImageView.hidden = false}

            } else if translation.x > -260 && translation.x < -60 {
                MessageContainerView.backgroundColor = UIColorFromHex(0xFFE066, alpha: 1.0)
                LaterImageView.hidden = false
            
            } else if translation.x < -260 {
                MessageContainerView.backgroundColor = UIColorFromHex(0xBF9F7E, alpha: 1.0)
                ListImageView.hidden = false
                
            }

            /* 
            yellow FFE066; brown BF9F7E; green 55D959; red  F24D44; grey DCDFE0
            */
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            // print ("Gesture ended at: \(point)")
            // print("Translation: \(translation)")
            // print("Velocity: \(velocity)")
            if translation.x > -260 && translation.x < 260 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageImageView.frame.origin.x = self.messageInitialFrame.x
                })
             
            }
        }
        
        
    }
    
    @IBAction func onPanMenu(sender: UIPanGestureRecognizer) {
        print("You panned the menu")
        var translation = sender.translationInView(view)
        MailboxView.frame.origin.x = mailboxInitialFrame.x + translation.x
        
        if sender.state == UIGestureRecognizerState.Ended && translation.x > -260 && translation.x < 100 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.MailboxView.frame.origin.x = self.mailboxInitialFrame.x
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
