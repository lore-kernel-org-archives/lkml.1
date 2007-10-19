Return-Path: <linux-kernel-owner+w=401wt.eu-S968413AbXJSWFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968413AbXJSWFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968361AbXJSWFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:05:30 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60561 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968362AbXJSWF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:05:29 -0400
Date: Sat, 20 Oct 2007 00:05:19 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Larry Finger <larry.finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Locking problem in usbserial with 2.6.23-git 5a34417f
In-Reply-To: <4719235E.9030507@lwfinger.net>
Message-ID: <Pine.LNX.4.64.0710200001520.18815@twin.jikos.cz>
References: <4718D469.2080606@lwfinger.net> <Pine.LNX.4.64.0710192304590.18815@twin.jikos.cz>
 <4719235E.9030507@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Larry Finger wrote:

> As I said earlier, the lock problem went away; however, I get the 
> following two kernel warnings:

That's because I messed up the patch, sorry. The one below should work 
better.



From: Jiri Kosina <jkosina@suse.cz>

USB: usbserial - fix potential deadlock between write() and IRQ

usb_serial_generic_write() doesn't disable interrupts when taking port->lock,
and could therefore deadlock with usb_serial_generic_read_bulk_callback()
being called from interrupt, taking the same lock. Fix it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 88a2c7d..9eb4a65 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -208,14 +208,15 @@ int usb_serial_generic_write(struct usb_serial_port *port, const unsigned char *
 
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
 
