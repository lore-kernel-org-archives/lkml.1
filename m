Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbXFOFG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbXFOFG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXFOFGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:06:49 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:25991 "EHLO
	asav12.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXFOFGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:06:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXAIy7cUZKhRO4UGdsb2JhbACPNAEBGw0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jan Kratochvil <honza@jikos.cz>
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
Date: Fri, 15 Jun 2007 01:06:40 -0400
User-Agent: KMail/1.9.3
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz> <alpine.LRH.0.98.0706031959170.22353@twin.jikos.cz> <200706150015.29568.dtor@insightbb.com>
In-Reply-To: <200706150015.29568.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150106.42315.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 00:15, Dmitry Torokhov wrote:
> How about the patch below instead?
> 

And one more time without warnings...

-- 
Dmitry

Subject: Input: xpad - add support for leds on xbox 360 pad
From: Jan Kratochvil <honza@jikos.cz>

Input: xpad - add support for leds on xbox 360 pad

Export LEDs on Xbox360 pad via led subsystem as a single device in
/sys/class/leds/xpad[0-9]+.

Xbox360 pad has four leds, which form a circle. Unfortunately the leds
can't be controlled independently and can only display a predefined
set of patterns (for example one is turned on wile others are off or
a rotating pattern - 1-2-3-4). To activate a pattern one needs to send
a specific command to the device (see http://www.free60.org/wiki/Gamepad).

Led subsystem allows us to set brightness, but there is nothing like
brightness on this device. So brightness is actually interpreted as
the command (only values between 0 and 14 are accepted).

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/joystick/Kconfig |    7 +
 drivers/input/joystick/xpad.c  |  190 +++++++++++++++++++++++++++++++----------
 2 files changed, 155 insertions(+), 42 deletions(-)

Index: work/drivers/input/joystick/Kconfig
===================================================================
--- work.orig/drivers/input/joystick/Kconfig
+++ work/drivers/input/joystick/Kconfig
@@ -275,4 +275,11 @@ config JOYSTICK_XPAD_FF
 	---help---
 	  Say Y here if you want to take advantage of xbox 360 rumble features.
 
+config JOYSTICK_XPAD_LEDS
+	bool "LED Support for Xbox360 controller 'BigX' LED"
+	depends on LEDS_CLASS && JOYSTICK_XPAD
+	---help---
+	  This option enables support for the LED which surrounds the Big X on
+	  XBox 360 controller.
+
 endif
Index: work/drivers/input/joystick/xpad.c
===================================================================
--- work.orig/drivers/input/joystick/xpad.c
+++ work/drivers/input/joystick/xpad.c
@@ -191,13 +191,18 @@ struct usb_xpad {
 	unsigned char *idata;		/* input data */
 	dma_addr_t idata_dma;
 
-#ifdef CONFIG_JOYSTICK_XPAD_FF
+#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 	struct urb *irq_out;		/* urb for interrupt out report */
 	unsigned char *odata;		/* output data */
 	dma_addr_t odata_dma;
+	struct mutex odata_mutex;
+#endif
+
+#if defined(CONFIG_JOYSTICK_XPAD_LEDS)
+	struct xpad_led *led;
 #endif
 
-	char phys[65];			/* physical device path */
+	char phys[64];			/* physical device path */
 
 	int dpad_mapping;		/* map d-pad to buttons or to axes */
 	int xtype;			/* type of xbox device */
@@ -349,7 +354,7 @@ exit:
 		     __FUNCTION__, retval);
 }
 
-#ifdef CONFIG_JOYSTICK_XPAD_FF
+#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 static void xpad_irq_out(struct urb *urb)
 {
 	int retval;
@@ -376,29 +381,7 @@ exit:
 		   __FUNCTION__, retval);
 }
 
-static int xpad_play_effect(struct input_dev *dev, void *data,
-			    struct ff_effect *effect)
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
@@ -411,6 +394,8 @@ static int xpad_init_ff(struct usb_inter
 	if (!xpad->odata)
 		goto fail1;
 
+	mutex_init(&xpad->odata_mutex);
+
 	xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
 	if (!xpad->irq_out)
 		goto fail2;
@@ -423,25 +408,19 @@ static int xpad_init_ff(struct usb_inter
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
@@ -449,13 +428,130 @@ static void xpad_deinit_ff(struct usb_xp
 				xpad->odata, xpad->odata_dma);
 	}
 }
+#else
+static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
+static void xpad_deinit_output(struct usb_xpad *xpad) {}
+static void xpad_stop_output(struct usb_xpad *xpad) {}
+#endif
 
+#ifdef CONFIG_JOYSTICK_XPAD_FF
+static int xpad_play_effect(struct input_dev *dev, void *data,
+			    struct ff_effect *effect)
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
+
+#else
+static int xpad_init_ff(struct usb_xpad *xpad) { return 0; }
+#endif
+
+#if defined(CONFIG_JOYSTICK_XPAD_LEDS)
+#include <linux/leds.h>
+
+struct xpad_led {
+	char name[16];
+	struct led_classdev led_cdev;
+	struct usb_xpad *xpad;
+};
+
+static void xpad_send_led_command(struct usb_xpad *xpad, int command)
+{
+	if (command >= 0 && command < 14) {
+		mutex_lock(&xpad->odata_mutex);
+		xpad->odata[0] = 0x01;
+		xpad->odata[1] = 0x03;
+		xpad->odata[2] = command;
+		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+		mutex_unlock(&xpad->odata_mutex);
+	}
+}
+
+static void xpad_led_set(struct led_classdev *led_cdev,
+			 enum led_brightness value)
+{
+	struct xpad_led *xpad_led = container_of(led_cdev,
+						 struct xpad_led, led_cdev);
+
+	xpad_send_led_command(xpad_led->xpad, value);
+}
+
+static int xpad_led_probe(struct usb_xpad *xpad)
+{
+	static atomic_t led_seq	= ATOMIC_INIT(0);
+	long led_no;
+	struct xpad_led *led;
+	struct led_classdev *led_cdev;
+	int error;
+
+	if (xpad->xtype != XTYPE_XBOX360)
+		return 0;
+
+	xpad->led = led = kzalloc(sizeof(struct xpad_led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led_no = (long)atomic_inc_return(&led_seq) - 1;
+
+	snprintf(led->name, sizeof(led->name), "xpad%ld", led_no);
+	led->xpad = xpad;
+
+	led_cdev = &led->led_cdev;
+	led_cdev->name = led->name;
+	led_cdev->brightness_set = xpad_led_set;
+
+	error = led_classdev_register(&xpad->udev->dev, led_cdev);
+	if (error) {
+		kfree(led);
+		xpad->led = NULL;
+		return error;
+	}
+
+	/*
+	 * Light up the segment corresponding to controller number
+	 */
+	xpad_send_led_command(xpad, (led_no % 4) + 2);
+
+	return 0;
+}
+
+static void xpad_led_disconnect(struct usb_xpad *xpad)
+{
+	struct xpad_led *xpad_led = xpad->led;
+
+	if (xpad_led) {
+		led_classdev_unregister(&xpad_led->led_cdev);
+		kfree(xpad_led->name);
+	}
+}
 #else
-static int xpad_init_ff(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
-static void xpad_stop_ff(struct usb_xpad *xpad) { }
-static void xpad_deinit_ff(struct usb_xpad *xpad) { }
+static int xpad_led_probe(struct usb_xpad *xpad) { return 0; }
+static void xpad_led_disconnect(struct usb_xpad *xpad) { }
 #endif
 
+
 static int xpad_open(struct input_dev *dev)
 {
 	struct usb_xpad *xpad = input_get_drvdata(dev);
@@ -472,7 +568,7 @@ static void xpad_close(struct input_dev 
 	struct usb_xpad *xpad = input_get_drvdata(dev);
 
 	usb_kill_urb(xpad->irq_in);
-	xpad_stop_ff(xpad);
+	xpad_stop_output(xpad);
 }
 
 static void xpad_set_up_abs(struct input_dev *input_dev, signed short abs)
@@ -564,10 +660,18 @@ static int xpad_probe(struct usb_interfa
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
+	error = xpad_led_probe(xpad);
+	if (error)
+		goto fail3;
+
 	ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
 	usb_fill_int_urb(xpad->irq_in, udev,
 			 usb_rcvintpipe(udev, ep_irq_in->bEndpointAddress),
@@ -578,12 +682,13 @@ static int xpad_probe(struct usb_interfa
 
 	error = input_register_device(xpad->dev);
 	if (error)
-		goto fail3;
+		goto fail4;
 
 	usb_set_intfdata(intf, xpad);
 	return 0;
 
- fail3:	usb_free_urb(xpad->irq_in);
+ fail4:	usb_free_urb(xpad->irq_in);
+ fail3:	xpad_deinit_output(xpad);
  fail2:	usb_buffer_free(udev, XPAD_PKT_LEN, xpad->idata, xpad->idata_dma);
  fail1:	input_free_device(input_dev);
 	kfree(xpad);
@@ -597,8 +702,9 @@ static void xpad_disconnect(struct usb_i
 
 	usb_set_intfdata(intf, NULL);
 	if (xpad) {
+		xpad_led_disconnect(xpad);
 		input_unregister_device(xpad->dev);
-		xpad_deinit_ff(xpad);
+		xpad_deinit_output(xpad);
 		usb_free_urb(xpad->irq_in);
 		usb_buffer_free(xpad->udev, XPAD_PKT_LEN,
 				xpad->idata, xpad->idata_dma);
