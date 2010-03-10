Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0CJNaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:30:10 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:53451
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935Ab0CJNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:30:07 -0500
X-IronPort-AV: E=Sophos;i="4.49,614,1262559600"; 
   d="scan'208";a="58505701"
Date: Wed, 10 Mar 2010 14:30:04 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl, linux-input@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] Route kbd LEDs through the generic LEDs layer (5th version)
Message-ID: <20100310133004.GM5127@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
	mgarski@post.pl, linux-input@vger.kernel.org,
	Vojtech Pavlik <vojtech@suse.cz>,
	Richard Purdie <rpurdie@rpsys.net>
References: <20100307200250.GA9340@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100307200250.GA9340@const.famille.thibault.fr>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Route keyboard LEDs through the generic LEDs layer.

This permits to reassign keyboard LEDs to something else than keyboard "leds"
state, by adding keyboard led and modifier triggers connected to a series
of global input LEDs, themselves connected to global input triggers, which
per-input device LEDs use by default.  Userland can thus easily change the LED
behavior of (a priori) all input devices, or of particular input devices.

This also permits to fix #7063 from userland by using a modifier to implement
proper CapsLock behavior and have the keyboard caps lock led show that modifier
state.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
---

Hello,

Here is a fifth version

Differences from the fourth version:
- use the platform_data field of the device struct instead of adding a
  private field to struct led_classdev.
- fix using input led triggers for non-input leds.

Difference from the third version:
- creates LEDs for each input device.
- creates a global LED trigger connected to the global LED, that
  per-device LEDs use by default.
- properly initializes LED state on trigger and input device connection.

Difference between third and second:
- only input LEDs actually available on devices are registered.

Difference between second and first:
- rebase on 2.6.33, fix locking issues.

Samuel

diff -ur linux-2.6.33-orig/Documentation/leds-class.txt linux-2.6.33-perso/Documentation/leds-class.txt
--- linux-2.6.33-orig/Documentation/leds-class.txt	2009-12-03 13:41:42.000000000 +0100
+++ linux-2.6.33-perso/Documentation/leds-class.txt	2010-02-25 01:45:28.000000000 +0100
@@ -2,9 +2,6 @@
 LED handling under Linux
 ========================
 
-If you're reading this and thinking about keyboard leds, these are
-handled by the input subsystem and the led class is *not* needed.
-
 In its simplest form, the LED class just allows control of LEDs from
 userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
 LED is defined in max_brightness file. The brightness file will set the brightness
diff -ur linux-2.6.33-orig/drivers/char/keyboard.c linux-2.6.33-perso/drivers/char/keyboard.c
--- linux-2.6.33-orig/drivers/char/keyboard.c	2010-02-25 01:41:19.000000000 +0100
+++ linux-2.6.33-perso/drivers/char/keyboard.c	2010-03-07 20:03:37.000000000 +0100
@@ -34,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/leds.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -139,6 +140,9 @@
 static char rep;					/* flag telling character repeat */
 
 static unsigned char ledstate = 0xff;			/* undefined */
+#ifdef CONFIG_LEDS_INPUT
+static unsigned char lockstate = 0xff;			/* undefined */
+#endif
 static unsigned char ledioctl;
 
 static struct ledptr {
@@ -971,6 +975,35 @@
 	}
 }
 
+#ifdef CONFIG_LEDS_INPUT
+/* When input-based leds are enabled, we route keyboard "leds" through triggers
+ */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev);
+static struct led_trigger ledtrig_ledstate[] = {
+#define DEFINE_LEDSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { .name = nam, .activate = kbd_ledstate_trigger_activate, }
+	DEFINE_LEDSTATE_TRIGGER(VC_SCROLLOCK, "scrollock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_NUMLOCK,   "numlock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_CAPSLOCK,  "capslock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_KANALOCK,  "kanalock"),
+#undef DEFINE_LEDSTATE_TRIGGER
+};
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev);
+static struct led_trigger ledtrig_lockstate[] = {
+#define DEFINE_LOCKSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { .name = nam, .activate = kbd_lockstate_trigger_activate, }
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "shiftlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTGRLOCK,  "altgrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLOCK,   "ctrllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTLOCK,    "altlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLLOCK, "shiftllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTRLOCK, "shiftrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLLOCK,  "ctrlllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLRLOCK,  "ctrlrlock"),
+#undef DEFINE_LOCKSTATE_TRIGGER
+};
+#endif
+
 /*
  * The leds display either (i) the status of NumLock, CapsLock, ScrollLock,
  * or (ii) whatever pattern of lights people want to show using KDSETLED,
@@ -1014,19 +1047,44 @@
 	return leds;
 }
 
+#ifdef CONFIG_LEDS_INPUT
+/* Called on trigger connection, to set initial state */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_ledstate;
+
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, ledstate & (1 << led) ? INT_MAX : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_lockstate;
+
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, lockstate & (1 << led) ? INT_MAX : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
+#else
 static int kbd_update_leds_helper(struct input_handle *handle, void *data)
 {
 	unsigned char leds = *(unsigned char *)data;
 
 	if (test_bit(EV_LED, handle->dev->evbit)) {
-		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
+		input_inject_event(handle, EV_LED, LED_SCROLLL,
+				!!(leds & VC_SCROLLOCK));
+		input_inject_event(handle, EV_LED, LED_NUML,
+				!!(leds & VC_NUMLOCK));
+		input_inject_event(handle, EV_LED, LED_CAPSL,
+				!!(leds & VC_CAPSLOCK));
 		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
 	}
 
 	return 0;
 }
+#endif
 
 /*
  * This is the tasklet that updates LED state on all keyboards
@@ -1040,10 +1098,31 @@
 	unsigned char leds = getleds();
 
 	if (leds != ledstate) {
+#ifdef CONFIG_LEDS_INPUT
+		int i;
+		for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+			if ((leds ^ ledstate) & (1 << i))
+				led_trigger_event(&ledtrig_ledstate[i],
+						leds & (1 << i)
+						? INT_MAX : LED_OFF);
+#else
 		input_handler_for_each_handle(&kbd_handler, &leds,
 					      kbd_update_leds_helper);
+#endif
 		ledstate = leds;
 	}
+
+#ifdef CONFIG_LEDS_INPUT
+	if (kbd->lockstate != lockstate) {
+		int i;
+		for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+			if ((kbd->lockstate ^ lockstate) & (1 << i))
+				led_trigger_event(&ledtrig_lockstate[i],
+						kbd->lockstate & (1 << i)
+						? INT_MAX : LED_OFF);
+		lockstate = kbd->lockstate;
+	}
+#endif
 }
 
 DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
@@ -1380,6 +1459,7 @@
 	kfree(handle);
 }
 
+#ifndef CONFIG_LEDS_INPUT
 /*
  * Start keyboard handler on the new keyboard by refreshing LED state to
  * match the rest of the system.
@@ -1393,6 +1473,7 @@
 
 	tasklet_enable(&keyboard_tasklet);
 }
+#endif
 
 static const struct input_device_id kbd_ids[] = {
 	{
@@ -1414,7 +1495,9 @@
 	.event		= kbd_event,
 	.connect	= kbd_connect,
 	.disconnect	= kbd_disconnect,
+#ifndef CONFIG_LEDS_INPUT
 	.start		= kbd_start,
+#endif
 	.name		= "kbd",
 	.id_table	= kbd_ids,
 };
@@ -1441,5 +1524,12 @@
 	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 
+#ifdef CONFIG_LEDS_INPUT
+	for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+		led_trigger_register(&ledtrig_ledstate[i]);
+	for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+		led_trigger_register(&ledtrig_lockstate[i]);
+#endif
+
 	return 0;
 }
diff -ur linux-2.6.33-orig/drivers/leds/Kconfig linux-2.6.33-perso/drivers/leds/Kconfig
--- linux-2.6.33-orig/drivers/leds/Kconfig	2010-02-25 01:41:27.000000000 +0100
+++ linux-2.6.33-perso/drivers/leds/Kconfig	2010-03-07 15:38:11.000000000 +0100
@@ -4,9 +4,6 @@
 	  Say Y to enable Linux LED support.  This allows control of supported
 	  LEDs from both userspace and optionally, by kernel events (triggers).
 
-	  This is not related to standard keyboard LEDs which are controlled
-	  via the input system.
-
 if NEW_LEDS
 
 config LEDS_CLASS
@@ -17,6 +14,14 @@
 
 comment "LED drivers"
 
+config LEDS_INPUT
+	tristate "LED Support using input keyboards"
+	depends on LEDS_CLASS
+	select LEDS_TRIGGERS
+	help
+	  This option enables support for the LEDs on keyboard managed
+	  by the input layer.
+
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
 	depends on LEDS_CLASS && ATMEL_PWM
diff -ur linux-2.6.33-orig/drivers/leds/leds-input.c linux-2.6.33-perso/drivers/leds/leds-input.c
--- linux-2.6.33-orig/drivers/leds/leds-input.c	2010-02-21 04:13:41.000000000 +0100
+++ linux-2.6.33-perso/drivers/leds/leds-input.c	2010-03-10 11:59:12.000000000 +0100
@@ -0,0 +1,307 @@
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
+#include "leds.h"
+
+/*
+ * Keyboard LEDs are propagated by default like the following example:
+ *
+ * keyboard numlock trigger
+ * -> input::numl global input LED
+ * -> input-numl global input trigger
+ * -> per-device <device>-input::numl LED
+ *
+ * Userland can however choose the trigger for the input::numl LED, or
+ * independently choose the trigger for any input-<device>::numl LED.
+ */
+
+/* Global LED classes and triggers are registered on-demand according to
+ * existing devices */
+
+/* Handler for global input LEDs, just triggers the corresponding global input
+ * trigger. */
+static void input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness);
+static struct led_classdev input_leds[LED_CNT] = {
+#define DEFINE_INPUT_LED(input_led, nam, deftrig) \
+	[input_led] = { \
+		.name = "input::"nam, \
+		.max_brightness = 1, \
+		.brightness_set = input_led_set, \
+		.default_trigger = deftrig, \
+	}
+/* Default triggers for the global input LEDs just correspond to the legacy
+ * usage. */
+	DEFINE_INPUT_LED(LED_NUML, "numl", "numlock"),
+	DEFINE_INPUT_LED(LED_CAPSL, "capsl", "capslock"),
+	DEFINE_INPUT_LED(LED_SCROLLL, "scrolll", "scrollock"),
+	DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
+	DEFINE_INPUT_LED(LED_KANA, "kana", "kanalock"),
+	DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
+	DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
+	DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
+	DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
+	DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
+	DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
+};
+static const char *const input_led_names[LED_CNT] = {
+	[LED_NUML] = "numl",
+	[LED_CAPSL] = "capsl",
+	[LED_SCROLLL] = "scrolll",
+	[LED_COMPOSE] = "compose",
+	[LED_KANA] = "kana",
+	[LED_SLEEP] = "sleep",
+	[LED_SUSPEND] = "suspend",
+	[LED_MUTE] = "mute",
+	[LED_MISC] = "misc",
+	[LED_MAIL] = "mail",
+	[LED_CHARGING] = "charging",
+};
+/* Handler for hotplug initialization */
+static void input_led_trigger_activate(struct led_classdev *cdev);
+/* Global input triggers */
+static struct led_trigger input_led_triggers[LED_CNT] = {
+#define DEFINE_INPUT_LED_TRIGGER(input_led, nam) \
+	[input_led] = { \
+		.name = "input-"nam, \
+		.activate = input_led_trigger_activate, \
+	}
+	DEFINE_INPUT_LED_TRIGGER(LED_NUML, "numl"),
+	DEFINE_INPUT_LED_TRIGGER(LED_CAPSL, "capsl"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SCROLLL, "scrolll"),
+	DEFINE_INPUT_LED_TRIGGER(LED_COMPOSE, "compose"),
+	DEFINE_INPUT_LED_TRIGGER(LED_KANA, "kana"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SLEEP, "sleep"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SUSPEND, "suspend"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MUTE, "mute"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MISC, "misc"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MAIL, "mail"),
+	DEFINE_INPUT_LED_TRIGGER(LED_CHARGING, "charging"),
+};
+/* Lock for registration coherency */
+static DEFINE_SPINLOCK(input_led_registered_lock);
+/* Which global LED classes and triggers are registered */
+static unsigned long input_led_registered[BITS_TO_LONGS(LED_CNT)];
+
+/* Our input handler to catch connect/disconnect */
+static struct input_handler input_led_handler;
+
+/* Global input LED state change, tell the global input trigger.  */
+static void input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	int led = cdev - input_leds;
+
+	led_trigger_event(&input_led_triggers[led], !!brightness);
+}
+
+/* LED state change for some keyboard, notify that keyboard.  */
+static void perdevice_input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct input_handle *handle;
+	struct led_classdev *leds;
+	int led;
+
+	handle = cdev->dev->platform_data;
+	if (!handle)
+		/* Still initializing */
+		return;
+	leds = handle->private;
+	led = cdev - leds;
+
+	input_inject_event(handle, EV_LED, led, !!brightness);
+	input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
+}
+
+/* Keyboard hotplug, initialize its LED status */
+static void input_led_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - input_led_triggers;
+
+	if (cdev->brightness_set)
+		cdev->brightness_set(cdev, input_leds[led].brightness);
+}
+
+/* Free an input handle, used at abortion and disconnection.  */
+static void input_led_delete_handle(struct input_handle *handle)
+{
+	if (handle) {
+		struct led_classdev *leds = handle->private;
+		if (leds) {
+			int i;
+			for (i = 0; i < LED_CNT; i++)
+				kfree(leds[i].name);
+			kfree(leds);
+		}
+		kfree(handle);
+	}
+}
+
+/* A new input device with potential LEDs to connect.  */
+static int input_led_connect(struct input_handler *handler,
+			      struct input_dev *dev,
+			      const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int i, error = 0;
+	unsigned long flags;
+	struct led_classdev *leds;
+
+	if (!test_bit(EV_LED, dev->keybit))
+		return -ENODEV;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	handle->private = leds = kzalloc(sizeof(*leds) * LED_CNT,
+						GFP_KERNEL);
+	if (!handle->private) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "input leds";
+
+	error = input_register_handle(handle);
+	if (error)
+		goto err;
+
+	/* lazily register missing global input LEDs */
+	spin_lock_irqsave(&input_led_registered_lock, flags);
+	for (i = 0; i < LED_CNT; i++)
+		if (input_leds[i].name
+				&& !test_bit(i, input_led_registered)
+				&& test_bit(i, dev->ledbit)) {
+			led_trigger_register(&input_led_triggers[i]);
+			/* This keyboard has led i, try to register it */
+			if (!led_classdev_register(NULL, &input_leds[i]))
+				set_bit(i, input_led_registered);
+			else
+				led_trigger_unregister(&input_led_triggers[i]);
+		}
+	spin_unlock_irqrestore(&input_led_registered_lock, flags);
+
+	/* and register this device's LEDs */
+	for (i = 0; i < LED_CNT; i++)
+		if (input_leds[i].name && test_bit(i, dev->ledbit)) {
+			leds[i].name = kasprintf(GFP_KERNEL, "%s::%s",
+						dev_name(&dev->dev),
+						input_led_names[i]);
+			if (!leds[i].name) {
+				error = -ENOMEM;
+				goto err_handler;
+			}
+			leds[i].max_brightness = 1;
+			leds[i].brightness_set = perdevice_input_led_set;
+			leds[i].default_trigger = input_led_triggers[i].name;
+		}
+
+	/* No issue so far, we can register for real.  */
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name) {
+			led_classdev_register(&dev->dev, &leds[i]);
+			leds[i].dev->platform_data = handle;
+			perdevice_input_led_set(&leds[i],
+					input_leds[i].brightness);
+		}
+
+	return 0;
+
+err_handler:
+	input_unregister_handler(&input_led_handler);
+err:
+	input_led_delete_handle(handle);
+	return error;
+}
+
+/* Disconnected input device. Clean it, and deregister now-useless global LEDs
+ * and triggers.  */
+static void input_led_disconnect(struct input_handle *handle)
+{
+	int unregister, i;
+	unsigned long flags;
+	struct led_classdev *leds = handle->private;
+
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name)
+			led_classdev_unregister(&leds[i]);
+
+	input_unregister_handle(handle);
+	input_led_delete_handle(handle);
+
+	spin_lock_irqsave(&input_led_registered_lock, flags);
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
+		led_trigger_unregister(&input_led_triggers[i]);
+		clear_bit(i, input_led_registered);
+	}
+	spin_unlock_irqrestore(&input_led_registered_lock, flags);
+}
+
+/* Only handle input devices which have LEDs */
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
+	/* This also disconnects all devices and thus unregisters LEDs and
+	 * triggers */
+	input_unregister_handler(&input_led_handler);
+}
+
+module_init(input_led_init);
+module_exit(input_led_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("User LED support for input layer");
+MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
diff -ur linux-2.6.33-orig/drivers/leds/Makefile linux-2.6.33-perso/drivers/leds/Makefile
--- linux-2.6.33-orig/drivers/leds/Makefile	2010-02-25 01:41:27.000000000 +0100
+++ linux-2.6.33-perso/drivers/leds/Makefile	2010-02-25 01:45:28.000000000 +0100
@@ -5,6 +5,7 @@
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
+obj-$(CONFIG_LEDS_INPUT)		+= leds-input.o
 obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
