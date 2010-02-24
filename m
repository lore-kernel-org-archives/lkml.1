Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab0BXBUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:20:17 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:50762 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab0BXBUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:20:15 -0500
Date: Wed, 24 Feb 2010 02:20:10 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl,
       linux-input@vger.kernel.org
Subject: [PATCH] Route kbd leds through the generic leds layer
Message-ID: <20100224012010.GA4062@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
	mgarski@post.pl, linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Route keyboard leds through the generic leds layer.

This permits to reassign keyboard LEDs to something else than keyboard
"leds" state, and also permits to fix #7063 from userland by using a
modifier to implement proper CapsLock behavior and have the keyboard
caps lock led show that caps lock state.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
---

Hello,

Here is a second version of the patch and should now be fine for
inclusion e.g. in the mm tree and eventually pushed to 2.6.34. The main
difference with the first version is that now only input leds actually
available on some device are registered.

The first version was acked by Pavel Machek.

Samuel

diff -ur linux-2.6.32-orig/Documentation/leds-class.txt linux-2.6.32-perso/Documentation/leds-class.txt
--- linux-2.6.32-orig/Documentation/leds-class.txt	2009-12-03 13:41:42.000000000 +0100
+++ linux-2.6.32-perso/Documentation/leds-class.txt	2010-02-21 04:12:59.000000000 +0100
@@ -2,9 +2,6 @@
 LED handling under Linux
 ========================
 
-If you're reading this and thinking about keyboard leds, these are
-handled by the input subsystem and the led class is *not* needed.
-
 In its simplest form, the LED class just allows control of LEDs from
 userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
 LED is defined in max_brightness file. The brightness file will set the brightness
diff -ur linux-2.6.32-orig/drivers/char/keyboard.c linux-2.6.32-perso/drivers/char/keyboard.c
--- linux-2.6.32-orig/drivers/char/keyboard.c	2009-12-03 13:42:46.000000000 +0100
+++ linux-2.6.32-perso/drivers/char/keyboard.c	2010-02-23 20:41:07.000000000 +0100
@@ -34,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/leds.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -140,6 +141,9 @@
 static char rep;					/* flag telling character repeat */
 
 static unsigned char ledstate = 0xff;			/* undefined */
+#ifdef CONFIG_LEDS_INPUT
+static unsigned char lockstate = 0xff;			/* undefined */
+#endif
 static unsigned char ledioctl;
 
 static struct ledptr {
@@ -997,6 +1001,23 @@
 	return leds;
 }
 
+#ifdef CONFIG_LEDS_INPUT
+/* When input-based leds are enabled, we route keyboard "leds" through triggers
+ */
+DEFINE_LED_TRIGGER(ledtrig_scrolllock);
+DEFINE_LED_TRIGGER(ledtrig_numlock);
+DEFINE_LED_TRIGGER(ledtrig_capslock);
+DEFINE_LED_TRIGGER(ledtrig_kanalock);
+DEFINE_LED_TRIGGER(ledtrig_shiftlock);
+DEFINE_LED_TRIGGER(ledtrig_altgrlock);
+DEFINE_LED_TRIGGER(ledtrig_ctrllock);
+DEFINE_LED_TRIGGER(ledtrig_altlock);
+DEFINE_LED_TRIGGER(ledtrig_shiftllock);
+DEFINE_LED_TRIGGER(ledtrig_shiftrlock);
+DEFINE_LED_TRIGGER(ledtrig_ctrlllock);
+DEFINE_LED_TRIGGER(ledtrig_ctrlrlock);
+#endif
+
 /*
  * This routine is the bottom half of the keyboard interrupt
  * routine, and runs with all interrupts enabled. It does
@@ -1013,19 +1034,63 @@
 
 static void kbd_bh(unsigned long dummy)
 {
-	struct list_head *node;
 	unsigned char leds = getleds();
 
 	if (leds != ledstate) {
+#ifdef CONFIG_LEDS_INPUT
+		led_trigger_event(ledtrig_scrolllock,
+				leds & (1 << VC_SCROLLOCK) ? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_numlock,
+				leds & (1 << VC_NUMLOCK)   ? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_capslock,
+				leds & (1 << VC_CAPSLOCK)  ? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_kanalock,
+				leds & (1 << VC_KANALOCK)  ? INT_MAX : LED_OFF);
+#else
+		struct list_head *node;
 		list_for_each(node, &kbd_handler.h_list) {
 			struct input_handle *handle = to_handle_h(node);
-			input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-			input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-			input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
+			input_inject_event(handle, EV_LED, LED_SCROLLL,
+					!!(leds & (1 << VC_SCROLLOCK)));
+			input_inject_event(handle, EV_LED, LED_NUML,
+					!!(leds & (1 << VC_NUMLOCK)));
+			input_inject_event(handle, EV_LED, LED_CAPSL,
+					!!(leds & (1 << VC_CAPSLOCK)));
 			input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
 		}
+#endif
 	}
 
+#ifdef CONFIG_LEDS_INPUT
+	if (kbd->lockstate != lockstate) {
+		led_trigger_event(ledtrig_shiftlock,
+			kbd->lockstate & (1<<VC_SHIFTLOCK)
+				? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_altgrlock,
+			kbd->lockstate & (1<<VC_ALTGRLOCK)
+				? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_ctrllock,
+			kbd->lockstate & (1<<VC_CTRLLOCK)
+				? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_altlock,
+			kbd->lockstate & (1<<VC_ALTLOCK)
+				? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_shiftllock,
+			kbd->lockstate & (1<<VC_SHIFTLLOCK)
+				? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_shiftrlock,
+			kbd->lockstate & (1<<VC_SHIFTRLOCK)
+				? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_ctrlllock,
+			kbd->lockstate & (1<<VC_CTRLLLOCK)
+				? INT_MAX : LED_OFF);
+		led_trigger_event(ledtrig_ctrlrlock,
+			kbd->lockstate & (1<<VC_CTRLRLOCK)
+				? INT_MAX : LED_OFF);
+	}
+	lockstate = kbd->lockstate;
+#endif
+
 	ledstate = leds;
 }
 
@@ -1357,6 +1422,7 @@
 	kfree(handle);
 }
 
+#ifndef CONFIG_LEDS_INPUT
 /*
  * Start keyboard handler on the new keyboard by refreshing LED state to
  * match the rest of the system.
@@ -1367,13 +1433,17 @@
 
 	tasklet_disable(&keyboard_tasklet);
 	if (leds != 0xff) {
-		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
+		input_inject_event(handle, EV_LED, LED_SCROLLL,
+				!!(leds & (1 << VC_SCROLLOCK)));
+		input_inject_event(handle, EV_LED, LED_NUML,
+				!!(leds & (1 << VC_NUMLOCK)));
+		input_inject_event(handle, EV_LED, LED_CAPSL,
+				!!(leds & (1 << VC_CAPSLOCK)));
 		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
 	}
 	tasklet_enable(&keyboard_tasklet);
 }
+#endif
 
 static const struct input_device_id kbd_ids[] = {
 	{
@@ -1395,7 +1465,9 @@
 	.event		= kbd_event,
 	.connect	= kbd_connect,
 	.disconnect	= kbd_disconnect,
+#ifndef CONFIG_LEDS_INPUT
 	.start		= kbd_start,
+#endif
 	.name		= "kbd",
 	.id_table	= kbd_ids,
 };
@@ -1419,6 +1491,21 @@
 	if (error)
 		return error;
 
+#ifdef CONFIG_LEDS_INPUT
+	led_trigger_register_simple("scrolllock", &ledtrig_scrolllock);
+	led_trigger_register_simple("numlock", &ledtrig_numlock);
+	led_trigger_register_simple("capslock", &ledtrig_capslock);
+	led_trigger_register_simple("kanalock", &ledtrig_kanalock);
+	led_trigger_register_simple("shiftlock", &ledtrig_shiftlock);
+	led_trigger_register_simple("altgrlock", &ledtrig_altgrlock);
+	led_trigger_register_simple("ctrllock", &ledtrig_ctrllock);
+	led_trigger_register_simple("altlock", &ledtrig_altlock);
+	led_trigger_register_simple("shiftllock", &ledtrig_shiftllock);
+	led_trigger_register_simple("shiftrlock", &ledtrig_shiftrlock);
+	led_trigger_register_simple("ctrlllock", &ledtrig_ctrlllock);
+	led_trigger_register_simple("ctrlrlock", &ledtrig_ctrlrlock);
+#endif
+
 	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 
diff -ur linux-2.6.32-orig/drivers/leds/Kconfig linux-2.6.32-perso/drivers/leds/Kconfig
--- linux-2.6.32-orig/drivers/leds/Kconfig	2009-12-03 13:42:57.000000000 +0100
+++ linux-2.6.32-perso/drivers/leds/Kconfig	2010-02-24 00:52:55.000000000 +0100
@@ -4,9 +4,6 @@
 	  Say Y to enable Linux LED support.  This allows control of supported
 	  LEDs from both userspace and optionally, by kernel events (triggers).
 
-	  This is not related to standard keyboard LEDs which are controlled
-	  via the input system.
-
 if NEW_LEDS
 
 config LEDS_CLASS
@@ -17,6 +14,13 @@
 
 comment "LED drivers"
 
+config LEDS_INPUT
+	tristate "LED Support using input keyboards"
+	depends on LEDS_CLASS
+	help
+	  This option enables support for the LEDs on keyboard managed
+	  by the input layer.
+
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
 	depends on LEDS_CLASS && ATMEL_PWM
diff -ur linux-2.6.32-orig/drivers/leds/leds-input.c linux-2.6.32-perso/drivers/leds/leds-input.c
--- linux-2.6.32-orig/drivers/leds/leds-input.c	2010-02-21 04:13:41.000000000 +0100
+++ linux-2.6.32-perso/drivers/leds/leds-input.c	2010-02-24 01:04:09.000000000 +0100
@@ -0,0 +1,186 @@
+/*
+ * LED support for the input layer
+ *
+ * Copyright 2010 Samuel Thibault <samuel.thibault@ens-lyon.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/input.h>
+
+/* Protects concurrency of led state and registration */
+static DEFINE_SPINLOCK(input_led_lock);
+/* Current state */
+static unsigned long input_led_leds[BITS_TO_LONGS(LED_CNT)];
+/* array of all led classes */
+static struct led_classdev input_leds[LED_CNT];
+/* which led classes are registered */
+static unsigned long input_led_registered[BITS_TO_LONGS(LED_CNT)];
+/* our handler */
+static struct input_handler input_led_handler;
+
+/* Led state change, update all keyboards */
+static void input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	int led = cdev - input_leds;
+	unsigned long flags;
+	struct input_handle *handle;
+
+	spin_lock_irqsave(&input_led_lock, flags);
+	list_for_each_entry(handle, &input_led_handler.h_list, h_node) {
+		input_inject_event(handle, EV_LED, led, !!brightness);
+		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
+	}
+	if (brightness)
+		set_bit(led, input_led_leds);
+	else
+		clear_bit(led, input_led_leds);
+	spin_unlock_irqrestore(&input_led_lock, flags);
+}
+
+static struct led_classdev input_leds[LED_CNT] = {
+#define DEFINE_INPUT_LED(input_led, nam, deftrig) \
+	[input_led] = { \
+		.name = "input::"nam, \
+		.max_brightness = 1, \
+		.brightness_set = input_led_set, \
+		.default_trigger = deftrig, \
+	}
+DEFINE_INPUT_LED(LED_NUML, "numlock", "numlock"),
+DEFINE_INPUT_LED(LED_CAPSL, "capslock", "capslock"),
+DEFINE_INPUT_LED(LED_SCROLLL, "scrolllock", "scrolllock"),
+DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
+DEFINE_INPUT_LED(LED_KANA, "kana", "kanalock"),
+DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
+DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
+DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
+DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
+DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
+DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
+};
+
+static int input_led_connect(struct input_handler *handler,
+			      struct input_dev *dev,
+			      const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int i, error;
+	unsigned long flags;
+
+	if (!test_bit(EV_LED, dev->keybit))
+		return -ENODEV;
+
+	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "input leds";
+
+	error = input_register_handle(handle);
+	if (error) {
+		kfree(handle);
+		return error;
+	}
+
+	spin_lock_irqsave(&input_led_lock, flags);
+	for (i = 0; i < LED_CNT; i++)
+		if (input_leds[i].name
+				&& !test_bit(i, input_led_registered)
+				&& test_bit(i, dev->ledbit))
+			/* This keyboard has led i, try to register it */
+			if (!led_classdev_register(NULL, &input_leds[i]))
+				set_bit(i, input_led_registered);
+	spin_unlock_irqrestore(&input_led_lock, flags);
+
+	return 0;
+}
+
+static void input_led_disconnect(struct input_handle *handle)
+{
+	int unregister,i;
+	input_unregister_handle(handle);
+	kfree(handle);
+
+	for (i = 0; i < LED_CNT; i++) {
+		if (!test_bit(i, input_led_registered))
+			continue;
+
+		unregister = 1;
+		list_for_each_entry(handle, &input_led_handler.h_list, h_node) {
+			if (test_bit(i, handle->dev->ledbit)) {
+				unregister = 0;
+				break;
+			}
+		}
+		if (!unregister)
+			continue;
+
+		led_classdev_unregister(&input_leds[i]);
+		clear_bit(i, input_led_registered);
+	}
+}
+
+/* New keyboard, update its leds */
+static void input_led_start(struct input_handle *handle)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&input_led_lock, flags);
+	for (i = 0; i < LED_CNT; i++)
+		if (input_leds[i].name && test_bit(i, handle->dev->ledbit))
+			input_inject_event(handle, EV_LED, i,
+					test_bit(i, input_led_leds));
+	input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
+	spin_unlock_irqrestore(&input_led_lock, flags);
+}
+
+static const struct input_device_id input_led_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_LED) },
+	},
+
+	{ },	/* Terminating entry */
+};
+
+static struct input_handler input_led_handler = {
+	.connect	= input_led_connect,
+	.disconnect	= input_led_disconnect,
+	.start		= input_led_start,
+	.name		= "input leds",
+	.id_table	= input_led_ids,
+};
+
+static int __init input_led_init(void)
+{
+	return input_register_handler(&input_led_handler);
+}
+
+static void __exit input_led_exit(void)
+{
+	int i;
+
+	input_unregister_handler(&input_led_handler);
+
+	for (i = 0; i < LED_CNT; i++)
+		if (test_bit(i, input_led_registered)) {
+			led_classdev_unregister(&input_leds[i]);
+			clear_bit(i, input_led_registered);
+		}
+}
+
+module_init(input_led_init);
+module_exit(input_led_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("User LED support for input layer");
+MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
diff -ur linux-2.6.32-orig/drivers/leds/Makefile linux-2.6.32-perso/drivers/leds/Makefile
--- linux-2.6.32-orig/drivers/leds/Makefile	2009-12-03 13:42:57.000000000 +0100
+++ linux-2.6.32-perso/drivers/leds/Makefile	2010-02-21 03:37:08.000000000 +0100
@@ -5,6 +5,7 @@
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
+obj-$(CONFIG_LEDS_INPUT)		+= leds-input.o
 obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
