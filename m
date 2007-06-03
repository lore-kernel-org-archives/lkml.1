Return-Path: <linux-kernel-owner+w=401wt.eu-S1751173AbXFCSH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbXFCSH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXFCSHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:07:18 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60563 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbXFCSHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:07:16 -0400
Date: Sun, 3 Jun 2007 20:07:08 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
In-Reply-To: <alpine.LRH.0.98.0706031959170.22353@twin.jikos.cz>
Message-ID: <alpine.LRH.0.98.0706032004070.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz> 
 <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz> 
 <1180474885.5822.94.camel@localhost.localdomain> 
 <d120d5000705300756t24d4a58ey1f4130bef22f8309@mail.gmail.com>
 <1180542740.5835.135.camel@localhost.localdomain>
 <alpine.LRH.0.98.0705302334580.22353@twin.jikos.cz>
 <alpine.LRH.0.98.0706031959170.22353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  the previous patch made led support dependent on force feedback. Which 
doesn't make sense from user point of view. So this patch removes this odd 
dependency. I made it in separate patch to make my changes easier to 
review.

Led support of xbox 360 now doesn't depend on force feedback.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
  drivers/input/joystick/Kconfig |    2 +-
  drivers/input/joystick/xpad.c  |   87 ++++++++++++++++++++++------------------
  2 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 2098ab6..e6c7560 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -276,7 +276,7 @@ config JOYSTICK_XPAD_FF

  config JOYSTICK_XPAD_LEDS
  	bool "LED Support for Xbox360 controller 'BigX' LED"
-	depends on LEDS_CLASS && JOYSTICK_XPAD_FF
+	depends on LEDS_CLASS && JOYSTICK_XPAD
  	---help---
  	  This option enables support for the LED which surrounds the Big X on
  	  XBox 360 controller.
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 4a51d6f..b51229f 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -194,7 +194,7 @@ struct usb_xpad {
  	unsigned char *idata;		/* input data */
  	dma_addr_t idata_dma;

-#ifdef CONFIG_JOYSTICK_XPAD_FF
+#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
  	struct urb *irq_out;		/* urb for interrupt out report */
  	unsigned char *odata;		/* output data */
  	dma_addr_t odata_dma;
@@ -358,7 +358,7 @@ exit:
  		     __FUNCTION__, retval);
  }

-#ifdef CONFIG_JOYSTICK_XPAD_FF
+#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
  static void xpad_irq_out(struct urb *urb)
  {
  	int retval;
@@ -385,28 +385,7 @@ exit:
  		   __FUNCTION__, retval);
  }

-int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
-{
-	struct usb_xpad *xpad = input_get_drvdata(dev);
-
-	if (effect->type == FF_RUMBLE) {
-		__u16 strong = effect->u.rumble.strong_magnitude;
-		__u16 weak = effect->u.rumble.weak_magnitude;
-		xpad->odata[0] = 0x00;
-		xpad->odata[1] = 0x08;
-		xpad->odata[2] = 0x00;
-		xpad->odata[3] = strong / 256;
-		xpad->odata[4] = weak / 256;
-		xpad->odata[5] = 0x00;
-		xpad->odata[6] = 0x00;
-		xpad->odata[7] = 0x00;
-		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
-	}
-
-	return 0;
-}
-
-static int xpad_init_ff(struct usb_interface *intf, struct usb_xpad *xpad)
+static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
  {
  	struct usb_endpoint_descriptor *ep_irq_out;
  	int error = -ENOMEM;
@@ -433,25 +412,19 @@ static int xpad_init_ff(struct usb_inter
  	xpad->irq_out->transfer_dma = xpad->odata_dma;
  	xpad->irq_out->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

-	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);
-
-	error = input_ff_create_memless(xpad->dev, NULL, xpad_play_effect);
-	if (error)
-		goto fail2;
-
  	return 0;

   fail2:	usb_buffer_free(xpad->udev, XPAD_PKT_LEN, xpad->odata, xpad->odata_dma);
   fail1:	return error;
  }

-static void xpad_stop_ff(struct usb_xpad *xpad)
+static void xpad_stop_output(struct usb_xpad *xpad)
  {
  	if (xpad->xtype == XTYPE_XBOX360)
  		usb_kill_urb(xpad->irq_out);
  }

-static void xpad_deinit_ff(struct usb_xpad *xpad)
+static void xpad_deinit_output(struct usb_xpad *xpad)
  {
  	if (xpad->xtype == XTYPE_XBOX360) {
  		usb_free_urb(xpad->irq_out);
@@ -459,11 +432,43 @@ static void xpad_deinit_ff(struct usb_xp
  				xpad->odata, xpad->odata_dma);
  	}
  }
+#else
+static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
+static void xpad_deinit_output(struct usb_xpad *xpad) {}
+static void xpad_stop_output(struct usb_xpad *xpad) {}
+#endif
+
+#ifdef CONFIG_JOYSTICK_XPAD_FF
+int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
+{
+	struct usb_xpad *xpad = input_get_drvdata(dev);
+
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
+static int xpad_init_ff(struct usb_xpad *xpad)
+{
+	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);
+
+	return input_ff_create_memless(xpad->dev, NULL, xpad_play_effect);
+}

  #else
-static int xpad_init_ff(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
-static void xpad_stop_ff(struct usb_xpad *xpad) { }
-static void xpad_deinit_ff(struct usb_xpad *xpad) { }
+static int xpad_init_ff(struct usb_xpad *xpad) { return 0; }
  #endif

  #if defined(CONFIG_JOYSTICK_XPAD_LEDS) 
@@ -599,7 +604,7 @@ static void xpad_close(struct input_dev
  	struct usb_xpad *xpad = input_get_drvdata(dev);

  	usb_kill_urb(xpad->irq_in);
-	xpad_stop_ff(xpad);
+	xpad_stop_output(xpad);
  }

  static void xpad_set_up_abs(struct input_dev *input_dev, signed short abs)
@@ -691,10 +696,14 @@ static int xpad_probe(struct usb_interfa
  		for (i = 0; xpad_abs_pad[i] >= 0; i++)
  		    xpad_set_up_abs(input_dev, xpad_abs_pad[i]);

-	error = xpad_init_ff(intf, xpad);
+	error = xpad_init_output(intf, xpad);
  	if (error)
  		goto fail2;

+	error = xpad_init_ff(xpad);
+	if (error)
+		goto fail3;
+
  	error = xpad_led_probe(xpad);
  	if (error)
  		goto fail3;
@@ -715,7 +724,7 @@ static int xpad_probe(struct usb_interfa
  	return 0;

  fail4:	usb_free_urb(xpad->irq_in);
-fail3:	xpad_deinit_ff(xpad);
+fail3:	xpad_deinit_output(xpad);
  fail2:	usb_buffer_free(udev, XPAD_PKT_LEN, xpad->idata, xpad->idata_dma);
  fail1:	input_free_device(input_dev);
  	kfree(xpad);
@@ -731,7 +740,7 @@ static void xpad_disconnect(struct usb_i
  	if (xpad) {
  		xpad_led_disconnect(xpad);
  		input_unregister_device(xpad->dev);
-		xpad_deinit_ff(xpad);
+		xpad_deinit_output(xpad);
  		usb_free_urb(xpad->irq_in);
  		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,
  				xpad->idata, xpad->idata_dma);
-- 
1.4.3.4



