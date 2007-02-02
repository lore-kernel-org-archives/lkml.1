Return-Path: <linux-kernel-owner+w=401wt.eu-S1423200AbXBBIkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423200AbXBBIkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423216AbXBBIkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:40:11 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52340 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423200AbXBBIkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:40:09 -0500
Date: Fri, 2 Feb 2007 10:40:08 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: lirc@bartelmus.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lirc: use GFP_ATOMIC instead of the now gone SLAB_ATOMIC
Message-ID: <Pine.LNX.4.64.0702021039340.21422@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The duplicate SLAB_xxx flags are now removed from the mainline. Use the GFP
equivalent instead.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 drivers/lirc_atiusb/lirc_atiusb.c           |   10 +++++-----
 drivers/lirc_igorplugusb/lirc_igorplugusb.c |    2 +-
 drivers/lirc_mceusb/lirc_mceusb.c           |    4 ++--
 drivers/lirc_mceusb2/lirc_mceusb2.c         |    6 +++---
 drivers/lirc_streamzap/lirc_streamzap.c     |    8 ++++----
 5 files changed, 15 insertions(+), 15 deletions(-)

Index: lirc-0.8.1/drivers/lirc_atiusb/lirc_atiusb.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_atiusb/lirc_atiusb.c
+++ lirc-0.8.1/drivers/lirc_atiusb/lirc_atiusb.c
@@ -241,7 +241,7 @@ static void send_packet(struct out_endpt
 	set_current_state(TASK_INTERRUPTIBLE);
 	add_wait_queue(&oep->wait, &wait);
 
-	if (usb_submit_urb(oep->urb, SLAB_ATOMIC)) {
+	if (usb_submit_urb(oep->urb, GFP_ATOMIC)) {
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&oep->wait, &wait);
 		IRUNLOCK;
@@ -307,7 +307,7 @@ static int set_use_inc(void *data)
 			iep = get_iep_from_link(pos);
 			iep->urb->dev = ir->usbdev;
 			dprintk(DRIVER_NAME "[%d]: linking iep 0x%02x (%p)\n", ir->devnum, iep->ep->bEndpointAddress, iep);
-			if ((rtn = usb_submit_urb(iep->urb, SLAB_ATOMIC)) < 0) {
+			if ((rtn = usb_submit_urb(iep->urb, GFP_ATOMIC)) < 0) {
 				printk(DRIVER_NAME "[%d]: open result = %d error "
 					"submitting urb\n", ir->devnum, rtn);
 				IRUNLOCK;
@@ -631,7 +631,7 @@ static void usb_remote_recv(struct urb *
 	}
 
 	/* resubmit urb */
-	usb_submit_urb(urb, SLAB_ATOMIC);
+	usb_submit_urb(urb, GFP_ATOMIC);
 }
 
 static void usb_remote_send(struct urb *urb, struct pt_regs *regs)
@@ -733,7 +733,7 @@ static struct in_endpt *new_in_endpt(str
 		iep->ep = ep;
 		iep->len = len;
 
-		if ( !(iep->buf = usb_buffer_alloc(dev, len, SLAB_ATOMIC, &iep->dma)) ) {
+		if ( !(iep->buf = usb_buffer_alloc(dev, len, GFP_ATOMIC, &iep->dma)) ) {
 			mem_failure = 2;
 		} else if ( !(iep->urb = usb_alloc_urb(0, GFP_KERNEL)) ) {
 			mem_failure = 3;
@@ -800,7 +800,7 @@ static struct out_endpt *new_out_endpt(s
 		oep->ep = ep;
 		init_waitqueue_head(&oep->wait);
 
-		if ( !(oep->buf = usb_buffer_alloc(dev, USB_OUTLEN, SLAB_ATOMIC, &oep->dma)) ) {
+		if ( !(oep->buf = usb_buffer_alloc(dev, USB_OUTLEN, GFP_ATOMIC, &oep->dma)) ) {
 			mem_failure = 2;
 		} else if ( !(oep->urb = usb_alloc_urb(0, GFP_KERNEL)) ) {
 			mem_failure = 3;
Index: lirc-0.8.1/drivers/lirc_igorplugusb/lirc_igorplugusb.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_igorplugusb/lirc_igorplugusb.c
+++ lirc-0.8.1/drivers/lirc_igorplugusb/lirc_igorplugusb.c
@@ -446,7 +446,7 @@ static int usb_remote_probe(struct usb_i
 			mem_failure = 4;
 		} else if (!(ir->buf_in = usb_buffer_alloc(dev, 
 				DEVICE_BUFLEN+DEVICE_HEADERLEN, 
-                                SLAB_ATOMIC, &ir->dma_in))) {
+                                GFP_ATOMIC, &ir->dma_in))) {
 			mem_failure = 5;
 		} else {
 
Index: lirc-0.8.1/drivers/lirc_mceusb/lirc_mceusb.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_mceusb/lirc_mceusb.c
+++ lirc-0.8.1/drivers/lirc_mceusb/lirc_mceusb.c
@@ -718,7 +718,7 @@ static int mceusb_probe(struct usb_inter
 			dev->bulk_in_size = buffer_size;
 			dev->bulk_in_endpointAddr = endpoint->bEndpointAddress;
 			dev->bulk_in_buffer = usb_buffer_alloc
-				(udev, buffer_size, SLAB_ATOMIC, &dev->dma_in);
+				(udev, buffer_size, GFP_ATOMIC, &dev->dma_in);
 			if (!dev->bulk_in_buffer) {
 				err("Couldn't allocate bulk_in_buffer");
 				goto error;
@@ -737,7 +737,7 @@ static int mceusb_probe(struct usb_inter
 			buffer_size = endpoint->wMaxPacketSize;
 			dev->bulk_out_size = buffer_size;
 			dev->bulk_out_endpointAddr = endpoint->bEndpointAddress;
-			dev->bulk_out_buffer = usb_buffer_alloc(udev, buffer_size, SLAB_ATOMIC, &dev->dma_out);
+			dev->bulk_out_buffer = usb_buffer_alloc(udev, buffer_size, GFP_ATOMIC, &dev->dma_out);
 			if (!dev->bulk_out_buffer) {
 				err("Couldn't allocate bulk_out_buffer");
 				goto error;
Index: lirc-0.8.1/drivers/lirc_mceusb2/lirc_mceusb2.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_mceusb2/lirc_mceusb2.c
+++ lirc-0.8.1/drivers/lirc_mceusb2/lirc_mceusb2.c
@@ -242,7 +242,7 @@ static void request_packet_async(struct 
 	async_urb->transfer_buffer_length = size;
 	async_urb->dev = ir->usbdev;
 
-	if ((res=usb_submit_urb(async_urb, SLAB_ATOMIC))) {
+	if ((res=usb_submit_urb(async_urb, GFP_ATOMIC))) {
 	    dprintk(DRIVER_NAME "[%d]: receive request FAILED! (res=%d)\n", ir->devnum, res);
 	    return;
 	}
@@ -445,7 +445,7 @@ static void usb_remote_recv(struct urb *
 	}
 
 	/* resubmit urb */
-	usb_submit_urb(urb, SLAB_ATOMIC);
+	usb_submit_urb(urb, GFP_ATOMIC);
 }
 
 
@@ -681,7 +681,7 @@ static int usb_remote_probe(struct usb_i
 			mem_failure = 3;
 		} else if (lirc_buffer_init(rbuf, sizeof(lirc_t), LIRCBUF_SIZE)) {
 			mem_failure = 4;
-		} else if (!(ir->buf_in = usb_buffer_alloc(dev, maxp, SLAB_ATOMIC, &ir->dma_in))) {
+		} else if (!(ir->buf_in = usb_buffer_alloc(dev, maxp, GFP_ATOMIC, &ir->dma_in))) {
 			mem_failure = 5;
 		} else if (!(ir->urb_in = usb_alloc_urb(0, GFP_KERNEL))) {
 			mem_failure = 7;
Index: lirc-0.8.1/drivers/lirc_streamzap/lirc_streamzap.c
===================================================================
--- lirc-0.8.1.orig/drivers/lirc_streamzap/lirc_streamzap.c
+++ lirc-0.8.1/drivers/lirc_streamzap/lirc_streamzap.c
@@ -436,7 +436,7 @@ static void usb_streamzap_irq(struct urb
 		}
 	}
 
-	usb_submit_urb( urb, SLAB_ATOMIC );
+	usb_submit_urb( urb, GFP_ATOMIC );
 
 	return;
 }
@@ -507,7 +507,7 @@ static int streamzap_probe( struct usb_i
 
 	sz->buf_in_len = sz->endpoint->wMaxPacketSize;
         if((sz->buf_in = usb_buffer_alloc(sz->udev, sz->buf_in_len,
-					  SLAB_ATOMIC, &sz->dma_in)) == NULL )
+					  GFP_ATOMIC, &sz->dma_in)) == NULL )
 	{
                 goto error;
 	}
@@ -641,7 +641,7 @@ static int streamzap_use_inc(void *data)
 	add_timer(&sz->flush_timer);
 
 	sz->urb_in->dev = sz->udev;
-	if (usb_submit_urb(sz->urb_in, SLAB_ATOMIC))
+	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
 	{
 		dprintk("open result = -EIO error submitting urb",
 			sz->plugin.minor);
@@ -775,7 +775,7 @@ static int streamzap_resume(struct usb_i
 		add_timer(&sz->flush_timer);
 
 		sz->urb_in->dev = sz->udev;
-		if (usb_submit_urb(sz->urb_in, SLAB_ATOMIC))
+		if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
 		{
 			dprintk("open result = -EIO error submitting urb",
 				sz->plugin.minor);
