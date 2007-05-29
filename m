Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbXE2VLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbXE2VLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXE2VLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:11:34 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50555 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXE2VLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:11:33 -0400
Date: Tue, 29 May 2007 23:11:26 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: rpurdie@rpsys.net, dtor@mail.ru
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Support for controlling leds on xbox 360 pad.
Message-ID: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  this patch is against current input tree.

Xbox360 pad has four leds, which forms a circle. Unfortunately the leds itself 
are not independent, and we can't control them directle, but rather through 
sending commands which have predefined meaning (like turn first on, others off)
This patch allows us to send these commands via leds subsystem. Commands itself 
are described here: http://www.free60.org/wiki/Gamepad.

Led subsystem allows us to set brightness, but there is nothing like brightness 
on this device. So brightness is actually interpreted as the command (only 
values between 0 and 14 are accepted).

So this patch uses led subystem in such way that it makes led in
/sys/class/leds/xpad:[0-9][0-9]/ for each attached xbox 360 pad.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>

---
  drivers/input/joystick/xpad.c |   34 ++++-------
  drivers/input/joystick/xpad.h |   35 ++++++++++++
  drivers/leds/Kconfig          |    7 ++
  drivers/leds/Makefile         |    1 +
  drivers/leds/leds-xpad.c      |  123 +++++++++++++++++++++++++++++++++++++++++
  5 files changed, 179 insertions(+), 21 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 664c765..4322ec9 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -79,6 +79,8 @@
  #include <linux/smp_lock.h>
  #include <linux/usb/input.h>

+#include "xpad.h"
+
  #define DRIVER_VERSION "v0.0.6"
  #define DRIVER_AUTHOR "Marko Friedemann <mfr@bmx-chemnitz.de>"
  #define DRIVER_DESC "X-Box pad driver"
@@ -184,26 +186,6 @@ static struct usb_device_id xpad_table [

  MODULE_DEVICE_TABLE (usb, xpad_table);

-struct usb_xpad {
-	struct input_dev *dev;		/* input device interface */
-	struct usb_device *udev;	/* usb device */
-
-	struct urb *irq_in;		/* urb for interrupt in report */
-	unsigned char *idata;		/* input data */
-	dma_addr_t idata_dma;
-
-#ifdef CONFIG_JOYSTICK_XPAD_FF
-	struct urb *irq_out;		/* urb for interrupt out report */
-	unsigned char *odata;		/* output data */
-	dma_addr_t odata_dma;
-#endif
-
-	char phys[65];			/* physical device path */
-
-	int dpad_mapping;		/* map d-pad to buttons or to axes */
-	int xtype;			/* type of xbox device */
-};
-
  /*
   *	xpad_process_packet
   *
@@ -384,6 +366,7 @@ int xpad_play_effect(struct input_dev *d
  	if (effect->type == FF_RUMBLE) {
  		__u16 strong = effect->u.rumble.strong_magnitude;
  		__u16 weak = effect->u.rumble.weak_magnitude;
+		mutex_lock(&xpad->odata_mutex);
  		xpad->odata[0] = 0x00;
  		xpad->odata[1] = 0x08;
  		xpad->odata[2] = 0x00;
@@ -393,6 +376,7 @@ int xpad_play_effect(struct input_dev *d
  		xpad->odata[6] = 0x00;
  		xpad->odata[7] = 0x00;
  		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+		mutex_unlock(&xpad->odata_mutex);
  	}

  	return 0;
@@ -408,8 +392,10 @@ static int xpad_init_ff(struct usb_inter

  	xpad->odata = usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
  				       GFP_ATOMIC, &xpad->odata_dma );
-	if (!xpad->idata)
+	if (!xpad->odata)
  		goto fail1;
+ 
+	mutex_init(&xpad->odata_mutex);

  	xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
  	if (!xpad->irq_out)
@@ -568,6 +554,9 @@ static int xpad_probe(struct usb_interfa
  	if (error)
  		goto fail2;

+	if (xpad->xtype == XTYPE_XBOX360)
+		xpad_led_probe(xpad);
+
  	ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
  	usb_fill_int_urb(xpad->irq_in, udev,
  			 usb_rcvintpipe(udev, ep_irq_in->bEndpointAddress),
@@ -597,6 +586,9 @@ static void xpad_disconnect(struct usb_i

  	usb_set_intfdata(intf, NULL);
  	if (xpad) {
+		if (xpad->xtype == XTYPE_XBOX360)
+			xpad_led_disconnect(xpad);
+
  		input_unregister_device(xpad->dev);
  		xpad_deinit_ff(xpad);
  		usb_free_urb(xpad->irq_in);
diff --git a/drivers/input/joystick/xpad.h b/drivers/input/joystick/xpad.h
new file mode 100644
index 0000000..487a129
--- /dev/null
+++ b/drivers/input/joystick/xpad.h
@@ -0,0 +1,35 @@
+#ifndef __INPUT_XPAD_H_INCLUDED
+#define __INPUT_XPAD_H_INCLUDED
+
+#include <linux/usb/input.h>
+
+struct usb_xpad {
+	struct input_dev *dev;		/* input device interface */
+	struct usb_device *udev;	/* usb device */
+
+	struct urb *irq_in;		/* urb for interrupt in report */
+	unsigned char *idata;		/* input data */
+	dma_addr_t idata_dma;
+
+#ifdef CONFIG_JOYSTICK_XPAD_FF
+	struct urb *irq_out;		/* urb for interrupt out report */
+	unsigned char *odata;		/* output data */
+	dma_addr_t odata_dma;
+	struct mutex odata_mutex;
+#endif
+
+	char phys[65];			/* physical device path */
+
+	int dpad_mapping;		/* map d-pad to buttons or to axes */
+	int xtype;			/* type of xbox device */
+};
+
+#if defined(CONFIG_LEDS_XBOX360) || defined(CONFIG_LEDS_XBOX360_MODULE)
+int xpad_led_probe(struct usb_xpad *xpad); 
+int xpad_led_disconnect(struct usb_xpad *xpad);
+#else
+inline int xpad_led_probe(struct usb_xpad *) { return 0; }
+inline int xpad_led_disconnect(struct usb_xpad *) { return 0; }
+#endif
+
+#endif /* __INPUT_XPAD_H_INCLUDED */
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 80acd08..c82b233 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -94,6 +94,13 @@ config LEDS_COBALT
  	help
  	  This option enables support for the front LED on Cobalt Server

+config LEDS_XBOX360
+	tristate "LED Support for Xbox360 controller 'BigX' LED"
+	depends on LEDS_CLASS && JOYSTICK_XPAD_FF
+	help
+	  This option enables support for the LED which surrounds the Big X on 
+	  XBox 360 controller.
+
  comment "LED Triggers"

  config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index aa2c18e..1219df0 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net4
  obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
  obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
  obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
+obj-$(CONFIG_LEDS_XBOX360)		+= leds-xpad.o

  # LED Triggers
  obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff --git a/drivers/leds/leds-xpad.c b/drivers/leds/leds-xpad.c
new file mode 100644
index 0000000..8dcda4a
--- /dev/null
+++ b/drivers/leds/leds-xpad.c
@@ -0,0 +1,123 @@
+/*
+ * LEDs driver for Xbox360 controller
+ *
+ * Copyright (C) 2007 Jan Kratochvil <honza@jikos.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include "../input/joystick/xpad.h"
+
+struct xpad_led {
+	struct led_classdev	cdev;
+
+	unsigned int 		id;
+	struct usb_xpad *	xpad;
+	struct list_head 	node;
+};
+
+static LIST_HEAD(xpad_led_list);
+
+static void xpad_send_command(int command, struct usb_xpad *xpad)
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
+		enum led_brightness value)
+{
+	struct xpad_led *led_dev =
+		container_of(led_cdev, struct xpad_led, cdev);
+
+	xpad_send_command(value, led_dev->xpad);
+}
+
+int xpad_led_probe(struct usb_xpad *xpad)
+{
+	int i = 0;
+	struct xpad_led *pos_led;
+	struct xpad_led *new_led; 
+	int error = -ENOMEM;
+	char *name;
+
+	list_for_each_entry(pos_led, &xpad_led_list, node) {
+		if (pos_led->id == i) 
+			i++;
+		else
+			break;
+	}
+ 
+	if (i > 99)
+		goto fail1;
+
+	new_led = kzalloc(sizeof(struct xpad_led), GFP_KERNEL);
+	if (!new_led)
+		goto fail1;
+
+	new_led->id = i;
+
+	name = kzalloc(sizeof(char)*8, GFP_KERNEL);
+	if (!name)
+		goto fail2;
+
+	strcpy(name, "xpad:");
+	name[5] = '0' + i / 10;
+	name[6] = '0' + i % 10;
+	name[7] = 0;
+ 
+	new_led->cdev.name = name;
+	new_led->cdev.brightness_set = xpad_led_set;
+	new_led->xpad = xpad;
+
+	list_add_tail(&new_led->node, &pos_led->node);
+ 
+	if (led_classdev_register(&xpad->udev->dev, &new_led->cdev))
+		goto fail3;
+
+
+	xpad_send_command( (i % 4) + 2, xpad);
+
+	return 0;
+
+fail3: 
+	kfree(new_led->cdev.name);
+fail2:
+	kfree(new_led); 
+fail1: 
+	return error; 
+}
+EXPORT_SYMBOL_GPL(xpad_led_probe);
+
+int xpad_led_disconnect(struct usb_xpad *xpad)
+{
+	struct xpad_led *led;
+	struct list_head *pos, *tmp;
+	list_for_each_safe(pos, tmp, &xpad_led_list) {
+		led = list_entry(pos, struct xpad_led, node);
+		if (led->xpad == xpad) {
+			led_classdev_unregister(&led->cdev);
+			list_del(pos);
+			kfree(led->cdev.name);
+			kfree(led);
+			break;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xpad_led_disconnect);
+
+MODULE_AUTHOR("Jan Kratochvil <honza@jikos.cz>");
+MODULE_DESCRIPTION("Xbox 360 LED driver");
+MODULE_LICENSE("GPL");
-- 
1.4.3.4


