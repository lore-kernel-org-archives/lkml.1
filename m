Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab0BUFKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 00:10:04 -0500
Received: from toccata.ens-lyon.org ([140.77.166.68]:44240 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0BUFKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 00:10:00 -0500
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 00:09:59 EST
Date: Sun, 21 Feb 2010 06:01:07 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: [RFC,PATCH] Route kbd leds through the generic leds layer (Was: [PATCH] kbd: (#7063) make CapsLock work as expected even for non-ASCII)
Message-ID: <20100221050107.GG6133@const.homenet.telecomitalia.it>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
	mgarski@post.pl
References: <20091116231520.GD4764@const.famille.thibault.fr> <20091117115503.GB1657@x200> <20091117132358.GJ12736@const.bordeaux.inria.fr> <20091119131854.GA1628@x200.localdomain> <20091119132828.GA31025@const.bordeaux.inria.fr> <20091119133737.GE31025@const.bordeaux.inria.fr> <4B055F24.8030307@zytor.com> <20091120190730.GB1434@ucw.cz> <20091120204612.GA31728@elf.ucw.cz> <4B0709D4.6010305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B0709D4.6010305@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Route keyboard leds through the generic leds layer.

This permits to reassign keyboard LEDs to something else than keyboard
"leds" state, and also permits to fix #7063 by using a modifier to
implement proper CapsLock behavior and have the keyboard caps lock led
show that caps lock state.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
---

Hello,

H. Peter Anvin, le Fri 20 Nov 2009 13:27:48 -0800, a écrit :
> On 11/20/2009 12:46 PM, Pavel Machek wrote:
> > Like this... But it should probably be slightly more complex -- like
> > making numlock/capslock/scrollock leds into trigers, and then
> > move input LED lowlevels into drivers/led...
> > 
> 
> In particular, all keyboard modifiers should be available triggers.

Here is a patch to be commented on.  It does work for me, and the very
nice thing I like is

echo phy0assoc > /sys/class/leds/input::scrolllock/trigger

because I don't have a wifi led on my laptop.

The thing I like less is that dmesg now always contains

Registered led device: input::numlock
etc.

I could perhaps inspect the set of leds supported by all the connected
input devices and only register triggers for those?  Not so easy, but
should be doable.  In the meanwhile, please comment on the attached
patch.

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
+++ linux-2.6.32-perso/drivers/char/keyboard.c	2010-02-21 05:59:26.000000000 +0100
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
 
diff -ur linux-2.6.32-orig/drivers/char/vt.c linux-2.6.32-perso/drivers/char/vt.c
--- linux-2.6.32-orig/drivers/char/vt.c	2009-12-03 13:42:47.000000000 +0100
+++ linux-2.6.32-perso/drivers/char/vt.c	2010-02-20 17:21:58.000000000 +0100
@@ -1625,6 +1625,7 @@
 	clr_kbd(vc, lnm);
 	kbd_table[vc->vc_num].lockstate = 0;
 	kbd_table[vc->vc_num].slockstate = 0;
+	/* FIXME */
 	kbd_table[vc->vc_num].ledmode = LED_SHOW_FLAGS;
 	kbd_table[vc->vc_num].ledflagstate = kbd_table[vc->vc_num].default_ledflagstate;
 	/* do not do set_leds here because this causes an endless tasklet loop
diff -ur linux-2.6.32-orig/drivers/leds/Kconfig linux-2.6.32-perso/drivers/leds/Kconfig
--- linux-2.6.32-orig/drivers/leds/Kconfig	2009-12-03 13:42:57.000000000 +0100
+++ linux-2.6.32-perso/drivers/leds/Kconfig	2010-02-21 04:17:07.000000000 +0100
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
+++ linux-2.6.32-perso/drivers/leds/leds-input.c	2010-02-21 05:59:58.000000000 +0100
@@ -0,0 +1,172 @@
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
+static DEFINE_SPINLOCK(input_led_lock);
+static int input_led_leds = -1;
+static struct led_classdev input_leds[];
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
+		input_led_leds |= 1 << led;
+	else
+		input_led_leds &= ~(1 << led);
+	spin_unlock_irqrestore(&input_led_lock, flags);
+}
+
+/* Array of all the input leds */
+static struct led_classdev input_leds[] = {
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
+DEFINE_INPUT_LED(LED_KANA, "kana", NULL),
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
+	int error;
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
+	return 0;
+}
+
+static void input_led_disconnect(struct input_handle *handle)
+{
+	input_unregister_handle(handle);
+	kfree(handle);
+}
+
+/* New keyboard, update its leds */
+static void input_led_start(struct input_handle *handle)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&input_led_lock, flags);
+	if (input_led_leds != -1) {
+		int i;
+		for (i = 0; i < sizeof(input_leds) / sizeof(input_leds[0]); i++)
+			if (input_leds[i].name)
+				input_inject_event(handle, EV_LED, i,
+						!!(input_led_leds & (1 << i)));
+		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
+	}
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
+	int i;
+	int error;
+
+	error = input_register_handler(&input_led_handler);
+	if (error)
+		return error;
+
+	for (i = 0; i < sizeof(input_leds) / sizeof(input_leds[0]); i++)
+		if (input_leds[i].name) {
+			error = led_classdev_register(NULL, &input_leds[i]);
+			if (error)
+				break;
+		}
+
+	if (error) {
+		for (i--; i >= 0; i--)
+			if (input_leds[i].name)
+				led_classdev_unregister(&input_leds[i]);
+		return error;
+	}
+
+	return 0;
+}
+
+static void __exit input_led_exit(void)
+{
+	int i;
+
+	input_unregister_handler(&input_led_handler);
+
+	for (i = 0; i < sizeof(input_leds) / sizeof(input_leds[0]); i++)
+		if (input_leds[i].name)
+			led_classdev_unregister(&input_leds[i]);
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
diff -ur linux-2.6.32-orig/lib/Kconfig.debug linux-2.6.32-perso/lib/Kconfig.debug
--- linux-2.6.32-orig/lib/Kconfig.debug	2009-12-03 13:44:04.000000000 +0100
+++ linux-2.6.32-perso/lib/Kconfig.debug	2010-02-21 04:36:23.000000000 +0100
@@ -103,7 +103,7 @@
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	depends on UNDEFINED
+	#depends on UNDEFINED
 	# This option is on purpose disabled for now.
 	# It will be enabled when we are down to a resonable number
 	# of section mismatch warnings (< 10 for an allyesconfig build)
