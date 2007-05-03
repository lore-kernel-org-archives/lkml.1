Return-Path: <linux-kernel-owner+w=401wt.eu-S1161900AbXECNFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161900AbXECNFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161901AbXECNFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:05:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60463 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161900AbXECNFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:05:02 -0400
Date: Thu, 3 May 2007 15:04:54 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] xpad.c: Added Xbox360 gamepad rumble support.
In-Reply-To: <Pine.LNX.4.64.0705021704180.13550@twin.jikos.cz>
Message-ID: <alpine.LRH.0.98.0705031504280.22353@twin.jikos.cz>
References: <Pine.LNX.4.64.0705021704180.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,
   thanks for feedback. Improved version of this patch follows:

It is enabled only if CONFIG_XPAD_FF is set to y.

Implementation is using force feedback support for memoryless devices.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
  drivers/usb/input/Kconfig |    7 +++
  drivers/usb/input/xpad.c  |  116 ++++++++++++++++++++++++++++++++++++++++++++-
  2 files changed, 122 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/input/Kconfig b/drivers/usb/input/Kconfig
index a792e42..8963522 100644
--- a/drivers/usb/input/Kconfig
+++ b/drivers/usb/input/Kconfig
@@ -149,6 +149,13 @@ config USB_XPAD
  	  To compile this driver as a module, choose M here: the
  	  module will be called xpad.

+config XPAD_FF
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
index 75d1a62..d117e71 100644
--- a/drivers/usb/input/xpad.c
+++ b/drivers/usb/input/xpad.c
@@ -192,6 +192,12 @@ struct usb_xpad {
  	unsigned char *idata;		/* input data */
  	dma_addr_t idata_dma;

+#ifdef CONFIG_XPAD_FF
+	struct urb *irq_out;		/* urb for interrupt out report */
+	unsigned char *odata;		/* output data */
+	dma_addr_t odata_dma;
+#endif
+
  	char phys[65];			/* physical device path */

  	int dpad_mapping;		/* map d-pad to buttons or to axes */
@@ -344,6 +350,106 @@ exit:
  		     __FUNCTION__, retval);
  }

+#ifdef CONFIG_XPAD_FF
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
+	if (xpad->xtype == XTYPE_XBOX360) {
+		struct usb_endpoint_descriptor *ep_irq_out;
+		int rv;
+
+		xpad->dev->evbit[0] |= BIT(EV_FF);
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
+		ep_irq_out = &intf->cur_altsetting->endpoint[1].desc;
+		usb_fill_int_urb(xpad->irq_out, xpad->udev,
+				 usb_sndintpipe(xpad->udev, ep_irq_out->bEndpointAddress),
+				 xpad->odata, XPAD_PKT_LEN,
+				 xpad_irq_out, xpad, ep_irq_out->bInterval);
+		xpad->irq_out->transfer_dma = xpad->odata_dma;
+		xpad->irq_out->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+		set_bit( FF_RUMBLE, xpad->dev->ffbit );
+		if (input_ff_create_memless(xpad->dev, NULL, xpad_play_effect)) {
+			goto fail2; 
+		}
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
+	if (xpad->xtype == XTYPE_XBOX360) {
+		usb_free_urb(xpad->irq_out);
+		usb_buffer_free(interface_to_usbdev(intf), XPAD_PKT_LEN,
+				xpad->odata, xpad->odata_dma);
+	}
+}
+#else
+static int xpad_init_ff(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
+static void xpad_deinit_ff(struct usb_interface *intf, struct usb_xpad *xpad) {};
+#endif
+
+
  static int xpad_open (struct input_dev *dev)
  {
  	struct usb_xpad *xpad = dev->private;
@@ -360,6 +466,11 @@ static void xpad_close (struct input_dev *dev)
  	struct usb_xpad *xpad = dev->private;

  	usb_kill_urb(xpad->irq_in);
+#ifdef CONFIG_XPAD_FF
+	if (xpad->xtype == XTYPE_XBOX360) {
+		usb_kill_urb(xpad->irq_out);
+	}
+#endif
  }

  static void xpad_set_up_abs(struct input_dev *input_dev, signed short abs)
@@ -448,6 +559,9 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
  		for (i = 0; xpad_abs_pad[i] >= 0; i++)
  		    xpad_set_up_abs(input_dev, xpad_abs_pad[i]);

+	if (xpad_init_ff(intf, xpad))
+		goto fail2;
+
  	ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
  	usb_fill_int_urb(xpad->irq_in, udev,
  			 usb_rcvintpipe(udev, ep_irq_in->bEndpointAddress),
@@ -474,8 +588,8 @@ static void xpad_disconnect(struct usb_interface *intf)

  	usb_set_intfdata(intf, NULL);
  	if (xpad) {
-		usb_kill_urb(xpad->irq_in);
  		input_unregister_device(xpad->dev);
+		xpad_deinit_ff(intf, xpad);
  		usb_free_urb(xpad->irq_in);
  		usb_buffer_free(interface_to_usbdev(intf), XPAD_PKT_LEN,
  				xpad->idata, xpad->idata_dma);
-- 
1.5.0.6



