Return-Path: <linux-kernel-owner+w=401wt.eu-S2993314AbXEBPGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993314AbXEBPGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993315AbXEBPGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:06:19 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37468 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993314AbXEBPGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:06:18 -0400
Date: Wed, 2 May 2007 17:05:15 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3/3] xpad.c: Added Xbox360 gamepad rumble support.
Message-ID: <Pine.LNX.4.64.0705021704180.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is enabled only if CONFIG_XPAD_FF is set to y.

Implementation is using force feedback support for memoryless devices.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
 drivers/usb/input/Kconfig |    8 +++
 drivers/usb/input/xpad.c  |  116 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/input/Kconfig b/drivers/usb/input/Kconfig
index a792e42..2066200 100644
--- a/drivers/usb/input/Kconfig
+++ b/drivers/usb/input/Kconfig
@@ -149,6 +149,14 @@ config USB_XPAD
 	  To compile this driver as a module, choose M here: the
 	  module will be called xpad.
 	  
+config XPAD_FF
+	default n
+	bool "X-Box gamepad rumble support"
+	depends on USB_XPAD && INPUT
+	select INPUT_FF_MEMLESS
+	---help---
+	  Say Y here if you want to take advantage of xbox 360 rumble features. 
+
 config USB_ATI_REMOTE
 	tristate "ATI / X10 USB RF remote control"
 	depends on USB && INPUT
diff --git a/drivers/usb/input/xpad.c b/drivers/usb/input/xpad.c
index bac9ec2..2dabde5 100644
--- a/drivers/usb/input/xpad.c
+++ b/drivers/usb/input/xpad.c
@@ -189,6 +189,12 @@ struct usb_xpad {
 	unsigned char *idata;		/* input data */
 	dma_addr_t idata_dma;
 
+#ifdef CONFIG_XPAD_FF
+	struct urb *irq_out;		/* urb for interrupt out report */
+	unsigned char *odata;		/* output data */
+	dma_addr_t odata_dma;
+#endif
+
 	char phys[65];			/* physical device path */
 
 	u8 flags;			/* combination of XPAD_FLAGS_* */
@@ -340,6 +346,103 @@ exit:
 		     __FUNCTION__, retval);
 }
 
+#ifdef CONFIG_XPAD_FF
+/**
+ * xpad_irq_out
+ */
+static void xpad_irq_out(struct urb *urb)
+{
+	int retval;
+
+	switch (urb->status) {
+		case 0:
+		/* success */
+		break;
+		case -ECONNRESET:
+		case -ENOENT:
+		case -ESHUTDOWN:
+			/* this urb is terminated, clean up */
+			dbg("%s - urb shutting down with status: %d",  __FUNCTION__, urb->status);
+			return;
+		default:
+			dbg("%s - nonzero urb status received: %d",  __FUNCTION__, urb->status);
+			goto exit;
+	}
+
+exit:
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	if (retval)
+		err("%s - usb_submit_urb failed with result %d",
+		   __FUNCTION__, retval);
+} 
+
+int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
+{
+	struct usb_xpad *xpad = dev->private;
+	if (effect->type == FF_RUMBLE) {
+		__u16 strong = effect->u.rumble.strong_magnitude;
+		__u16 weak = effect->u.rumble.weak_magnitude;
+		xpad->odata[0] = 0x00; 
+		xpad->odata[1] = 0x08; 
+		xpad->odata[2] = 0x00; 
+		xpad->odata[3] = strong / 256;
+		xpad->odata[4] = weak / 256; 
+		xpad->odata[5] = 0x00;
+		xpad->odata[6] = 0x00;
+		xpad->odata[7] = 0x00;
+		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+	}
+
+	return 0;
+}
+
+static int xpad_init_ff(struct usb_interface *intf, struct usb_xpad *xpad)
+{
+	if (xpad->flags & XPAD_FLAGS_XBOX360) {
+		struct usb_endpoint_descriptor *ep_irq_out;
+		int rv;
+
+		xpad->odata = usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN, 
+					       GFP_ATOMIC, &xpad->odata_dma );
+		if (!xpad->idata)
+			goto fail1;
+
+		xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
+		if (!xpad->irq_out)
+			goto fail2;
+
+
+		ep_irq_out = &intf->cur_altsetting->endpoint[1].desc;
+		usb_fill_int_urb(xpad->irq_out, xpad->udev,
+				 usb_sndintpipe(xpad->udev, ep_irq_out->bEndpointAddress),
+				 xpad->odata, XPAD_PKT_LEN,
+				 xpad_irq_out, xpad, ep_irq_out->bInterval);
+		xpad->irq_out->transfer_dma = xpad->odata_dma;
+		xpad->irq_out->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+		set_bit( FF_RUMBLE, xpad->dev->ffbit );
+		rv = input_ff_create_memless(xpad->dev, NULL, xpad_play_effect);
+
+		return 0;
+
+fail2:		usb_buffer_free(xpad->udev, XPAD_PKT_LEN, xpad->odata, xpad->odata_dma);
+fail1:		
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void xpad_deinit_ff(struct usb_interface *intf, struct usb_xpad *xpad)
+{
+	if (xpad->flags & XPAD_FLAGS_XBOX360) {
+		usb_kill_urb(xpad->irq_out);
+		usb_free_urb(xpad->irq_out);
+		usb_buffer_free(interface_to_usbdev(intf), XPAD_PKT_LEN,
+				xpad->odata, xpad->odata_dma);
+	}
+}
+#endif
+
 static int xpad_open (struct input_dev *dev)
 {
 	struct usb_xpad *xpad = dev->private;
@@ -432,6 +535,11 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
 
+#ifdef CONFIG_XPAD_FF
+	if (xpad->flags & XPAD_FLAGS_XBOX360)
+		input_dev->evbit[0] |= BIT(EV_FF);
+#endif
+
 	/* set up buttons */
 	for (i = 0; xpad_btn[i] >= 0; i++)
 		set_bit(xpad_btn[i], input_dev->keybit);
@@ -449,6 +557,11 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		for (i = 0; xpad_abs_pad[i] >= 0; i++)
 		    xpad_set_up_abs(input_dev, xpad_abs_pad[i]);
 
+#ifdef CONFIG_XPAD_FF
+	if (xpad_init_ff(intf, xpad))
+		goto fail2;
+#endif
+
 	ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
 	usb_fill_int_urb(xpad->irq_in, udev,
 			 usb_rcvintpipe(udev, ep_irq_in->bEndpointAddress),
@@ -476,6 +589,9 @@ static void xpad_disconnect(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 	if (xpad) {
 		usb_kill_urb(xpad->irq_in);
+#ifdef CONFIG_XPAD_FF
+		xpad_deinit_ff(intf, xpad);
+#endif
 		input_unregister_device(xpad->dev);
 		usb_free_urb(xpad->irq_in);
 		usb_buffer_free(interface_to_usbdev(intf), XPAD_PKT_LEN,
-- 
1.5.0.6


