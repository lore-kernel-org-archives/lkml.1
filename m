Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbXJXViV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbXJXViV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXJXViH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:38:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:50757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbXJXViF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:38:05 -0400
Subject: patch usb-usbserial-fix-potential-deadlock-between-write-and-irq.patch added to gregkh-2.6 tree
To: jikos@jikos.cz, gregkh@suse.de, jkosina@suse.cz, larry.finger@lwfinger.net,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 24 Oct 2007 14:37:36 -0700
In-Reply-To: <Pine.LNX.4.64.0710200001520.18815@twin.jikos.cz>
Message-Id: <20071024213801.A296014543E5@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: usbserial - fix potential deadlock between write() and IRQ

to my gregkh-2.6 tree.  Its filename is

     usb-usbserial-fix-potential-deadlock-between-write-and-irq.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From jikos@jikos.cz  Wed Oct 24 14:28:04 2007
From: Jiri Kosina <jikos@jikos.cz>
Date: Sat, 20 Oct 2007 00:05:19 +0200 (CEST)
Subject: USB: usbserial - fix potential deadlock between write() and IRQ
To: Larry Finger <larry.finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net
Message-ID: <Pine.LNX.4.64.0710200001520.18815@twin.jikos.cz>


From: Jiri Kosina <jkosina@suse.cz>

USB: usbserial - fix potential deadlock between write() and IRQ

usb_serial_generic_write() doesn't disable interrupts when taking port->lock,
and could therefore deadlock with usb_serial_generic_read_bulk_callback()
being called from interrupt, taking the same lock. Fix it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Larry Finger <larry.finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/generic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -208,14 +208,15 @@ int usb_serial_generic_write(struct usb_
 
 	/* only do something if we have a bulk out endpoint */
 	if (serial->num_bulk_out) {
-		spin_lock_bh(&port->lock);
+		unsigned long flags;
+		spin_lock_irqsave(&port->lock, flags);
 		if (port->write_urb_busy) {
-			spin_unlock_bh(&port->lock);
+			spin_unlock_irqrestore(&port->lock, flags);
 			dbg("%s - already writing", __FUNCTION__);
 			return 0;
 		}
 		port->write_urb_busy = 1;
-		spin_unlock_bh(&port->lock);
+		spin_unlock_irqrestore(&port->lock, flags);
 
 		count = (count > port->bulk_out_size) ? port->bulk_out_size : count;
 


Patches currently in gregkh-2.6 which might be from jikos@jikos.cz are

usb/usb-usbserial-fix-potential-deadlock-between-write-and-irq.patch
