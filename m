Return-Path: <linux-kernel-owner+w=401wt.eu-S966696AbXJSVG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966696AbXJSVG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966586AbXJSVGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:06:35 -0400
Received: from twin.jikos.cz ([213.151.79.26]:54692 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765206AbXJSVGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:06:34 -0400
Date: Fri, 19 Oct 2007 23:06:18 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Locking problem in usbserial with 2.6.23-git 5a34417f
In-Reply-To: <4718D469.2080606@lwfinger.net>
Message-ID: <Pine.LNX.4.64.0710192304590.18815@twin.jikos.cz>
References: <4718D469.2080606@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Larry Finger wrote:

> While attempting to configure a new USB modem, the following locking 
> problem occurred. In addition, shortly after this problem occurred, the 
> computer froze. The log data starts at the point that usbserial was 
> loaded and contains everything that was written to disk before the 
> machine locked up. Some info may be missing from the end of the stack 
> dump.

I guess this one is needed.


From: Jiri Kosina <jkosina@suse.cz>

USB: usbserial - fix potential deadlock between write() and irq

usb_serial_generic_write() doesn't disable interrupts when taking port->lock,
and could therefore deadlock with usb_serial_generic_read_bulk_callback()
being called from interrupt, taking the same lock. Fix it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 88a2c7d..6f8d712 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -208,14 +208,15 @@ int usb_serial_generic_write(struct usb_serial_port *port, const unsigned char *
 
 	/* only do something if we have a bulk out endpoint */
 	if (serial->num_bulk_out) {
-		spin_lock_bh(&port->lock);
+		unsigned long flags;
+		spin_lock_irqsave(&port->lock, flags);
 		if (port->write_urb_busy) {
 			spin_unlock_bh(&port->lock);
 			dbg("%s - already writing", __FUNCTION__);
 			return 0;
 		}
 		port->write_urb_busy = 1;
-		spin_unlock_bh(&port->lock);
+		spin_unlock_irqrestore(&port->lock, flags);
 
 		count = (count > port->bulk_out_size) ? port->bulk_out_size : count;
 
