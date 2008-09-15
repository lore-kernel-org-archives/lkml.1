Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYIORrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYIORrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYIORqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:46:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36437 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYIORqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:46:51 -0400
Date: Mon, 15 Sep 2008 19:42:36 +0200
From: Pavel Machek <pavel@suse.cz>
To: oneukum@suse.de, kernel list <linux-kernel@vger.kernel.org>,
       Linux usb mailing list 
	<linux-usb-devel@lists.sourceforge.net>
Subject: btusb autosuspend + usb core problems
Message-ID: <20080915174236.GA1647@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

With usb bluetooth autosuspend, I get infinite loop in
unlink_anchored_urbs(), called from btusb_flush().

Loop is infinite, because usb_kill_urb can fail

@@ -547,13 +548,16 @@ void usb_kill_urb(struct urb *urb)
        static DEFINE_MUTEX(reject_mutex);

        might_sleep();
-       if (!(urb && urb->dev && urb->ep))
+       if (!(urb && urb->dev && urb->ep)) {
+               printk("killing_urb unsuccessful\n");
                return;
+       }
        mutex_lock(&reject_mutex);
        ++urb->reject;
        mutex_unlock(&reject_mutex);

(and indeed fails in my case), but does not return value.

usb_kill_anchored_urbs() relies on kill_urb() unlinking it...

        spin_lock_irq(&anchor->lock);
        while (!list_empty(&anchor->urb_list)) {
                victim = list_entry(anchor->urb_list.prev, struct urb,
                                    anchor_list);
+
+               if (complain++ < 10)
+                       printk("kill_anchored: victim %lx (prev
%lx)\n", victim, prev_victim);
                /* we must make sure the URB isn't freed before we
kill it*/
                usb_get_urb(victim);
                spin_unlock_irq(&anchor->lock);
@@ -584,8 +594,10 @@ void usb_kill_anchored_urbs(struct usb_a
                usb_kill_urb(victim);
                usb_put_urb(victim);
                spin_lock_irq(&anchor->lock);
+               prev_victim = victim;

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
