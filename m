Return-Path: <linux-kernel-owner+w=401wt.eu-S1765588AbXEVM2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765588AbXEVM2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXEVM21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:28:27 -0400
Received: from mail.bn-online.net ([217.76.96.46]:33129 "EHLO
	blatz006.blatzheim.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbXEVM21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:28:27 -0400
Message-ID: <4652E1E6.8020004@colognechip.com>
Date: Tue, 22 May 2007 14:28:22 +0200
From: Martin Bachem <info@colognechip.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH 2.6.21.2] hfcs_usb / st5481_usb : improves the USB API usage
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as876) improves the USB API usage in the HiSax drivers:

	Use usb_kill_urb() rather than usb_unlink_urb() when
	shutting down.

	Remove unnecessary checks for NULL pointers.

	Don't initialize urb->lock, because it is private to usbcore.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Martin Bachem <info@colognechip.com>
Acked-by: Karsten Keil <kkeil@suse.de>

---

Index: usb-2.6/drivers/isdn/hisax/hfc_usb.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/hfc_usb.c
+++ usb-2.6/drivers/isdn/hisax/hfc_usb.c
@@ -486,7 +486,6 @@ fill_isoc_urb(struct urb *urb, struct us
 {
 	int k;

-	spin_lock_init(&urb->lock);
 	urb->dev = dev;
 	urb->pipe = pipe;
 	urb->complete = complete;
@@ -579,16 +578,14 @@ stop_isoc_chain(usb_fifo * fifo)
 			    "HFC-S USB: Stopping iso chain for fifo %i.%i",
 			    fifo->fifonum, i);
 #endif
-			usb_unlink_urb(fifo->iso[i].purb);
+			usb_kill_urb(fifo->iso[i].purb);
 			usb_free_urb(fifo->iso[i].purb);
 			fifo->iso[i].purb = NULL;
 		}
 	}
-	if (fifo->urb) {
-		usb_unlink_urb(fifo->urb);
-		usb_free_urb(fifo->urb);
-		fifo->urb = NULL;
-	}
+	usb_kill_urb(fifo->urb);
+	usb_free_urb(fifo->urb);
+	fifo->urb = NULL;
 	fifo->active = 0;
 }

@@ -1631,11 +1628,9 @@ hfc_usb_probe(struct usb_interface *intf
 #endif
 			/* init the chip and register the driver */
 			if (usb_init(context)) {
-				if (context->ctrl_urb) {
-				usb_unlink_urb(context->ctrl_urb);
-					usb_free_urb(context->ctrl_urb);
-					context->ctrl_urb = NULL;
-				}
+				usb_kill_urb(context->ctrl_urb);
+				usb_free_urb(context->ctrl_urb);
+				context->ctrl_urb = NULL;
 				kfree(context);
 				return (-EIO);
 			}
@@ -1687,21 +1682,15 @@ hfc_usb_disconnect(struct usb_interface
 				    i);
 #endif
 			}
-			if (context->fifos[i].urb) {
-				usb_unlink_urb(context->fifos[i].urb);
-				usb_free_urb(context->fifos[i].urb);
-				context->fifos[i].urb = NULL;
-			}
+			usb_kill_urb(context->fifos[i].urb);
+			usb_free_urb(context->fifos[i].urb);
+			context->fifos[i].urb = NULL;
 		}
 		context->fifos[i].active = 0;
 	}
-	/* wait for all URBS to terminate */
-	mdelay(10);
-	if (context->ctrl_urb) {
-		usb_unlink_urb(context->ctrl_urb);
-		usb_free_urb(context->ctrl_urb);
-		context->ctrl_urb = NULL;
-	}
+	usb_kill_urb(context->ctrl_urb);
+	usb_free_urb(context->ctrl_urb);
+	context->ctrl_urb = NULL;
 	hisax_unregister(&context->d_if);
 	kfree(context);		/* free our structure again */
 }				/* hfc_usb_disconnect */
Index: usb-2.6/drivers/isdn/hisax/st5481_usb.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/st5481_usb.c
+++ usb-2.6/drivers/isdn/hisax/st5481_usb.c
@@ -407,7 +407,6 @@ fill_isoc_urb(struct urb *urb, struct us
 {
 	int k;

-	spin_lock_init(&urb->lock);
 	urb->dev=dev;
 	urb->pipe=pipe;
 	urb->interval = 1;

