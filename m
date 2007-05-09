Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbXEIO0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbXEIO0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbXEIO0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:26:23 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:62142
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbXEIO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:26:22 -0400
Message-ID: <2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp>
Date: Wed, 9 May 2007 23:26:20 +0900 (JST)
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: "Richard Purdie" <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp><1178628889.6061.33.camel@localhost.localdomain>
In-Reply-To: <1178628889.6061.33.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard-san

The following three points were corrected.

1.
> You can't do this since the trigger will appear for all LEDs and it only
> applies to a single LED. There has been previous discussion of LED
> specific triggers and we'll need that support before you can make
> something like this work. Nobody has sent me a patch for that yet and I
> haven't had time to write one...
The trigger name past "disk" was changed to the name "hard".
This is to mean the hardware of LANDISK controls LED.
The problem of "LED specific triggers" is solved.

2.
> Broken error handling - you should check the return code of
> led_trigger_register().

3.
> void functions don't return.
it is fixed.

I think that I want to reflect the correction of BLINK, when the policy is decided.

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
---
diff -urpN OLD/drivers/leds/Kconfig NEW/drivers/leds/Kconfig
--- OLD/drivers/leds/Kconfig	2007-04-28 06:49:26.000000000 +0900
+++ NEW/drivers/leds/Kconfig	2007-05-09 20:25:06.000000000 +0900
@@ -94,6 +94,13 @@ config LEDS_COBALT
 	help
 	  This option enables support for the front LED on Cobalt Server

+config LEDS_LANDISK
+        tristate "LED Support for LANDISK Series"
+        depends on LEDS_CLASS && SH_LANDISK
+        select LEDS_TRIGGERS
+        help
+          This option enables support for the LED on LANDISK Series
+
 comment "LED Triggers"

 config LEDS_TRIGGERS
diff -urpN OLD/drivers/leds/Makefile NEW/drivers/leds/Makefile
--- OLD/drivers/leds/Makefile	2007-04-28 06:49:26.000000000 +0900
+++ NEW/drivers/leds/Makefile	2007-05-09 20:24:38.000000000 +0900
@@ -16,6 +16,7 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net4
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
+obj-$(CONFIG_LEDS_LANDISK)		+= leds-landisk.o

 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff -urpN OLD/drivers/leds/leds-landisk.c NEW/drivers/leds/leds-landisk.c
--- OLD/drivers/leds/leds-landisk.c	1970-01-01 09:00:00.000000000 +0900
+++ NEW/drivers/leds/leds-landisk.c	2007-05-09 23:08:15.000000000 +0900
@@ -0,0 +1,203 @@
+/*
+ * LEDs driver for I-O DATA DEVICE, INC. "LANDISK Series" support.
+ *
+ * Copyright (C) 2007 kogiidena
+ *
+ * Based on the drivers/leds/leds-ams-delta.c by:
+ * Copyright (C) 2006 Jonathan McDowell <noodles@earth.li>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/leds.h>
+#include <asm/io.h>
+#include <asm/landisk/iodata_landisk.h>
+
+spinlock_t landisk_led_lock;
+static int landisk_arch;	/* 0:LANDISK, LANTank 1:USL-5P */
+
+static void landisk_led_set(struct led_classdev *led_cdev,
+			    enum led_brightness value);
+
+static struct led_classdev landisk_leds[] = {
+	[0] = {
+	       .name = "power",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "blink",
+	       },
+	[1] = {
+	       .name = "status",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "blink",
+	       },
+	[2] = {
+	       .name = "led1",
+	       .brightness_set = landisk_led_set,
+	       },
+	[3] = {
+	       .name = "led2",
+	       .brightness_set = landisk_led_set,
+	       },
+	[4] = {
+	       .name = "led3",
+	       .brightness_set = landisk_led_set,
+	       },
+	[5] = {
+	       .name = "led4",
+	       .brightness_set = landisk_led_set,
+	       },
+	[6] = {
+	       .name = "led5",
+	       .brightness_set = landisk_led_set,
+	       },
+	[7] = {
+	       .name = "buzzer",
+	       .default_trigger = "bitshift",
+	       .brightness_set = landisk_led_set,
+	       },
+};
+
+static void landisk_led_set(struct led_classdev *led_cdev,
+			    enum led_brightness value)
+{
+	u8 tmp;
+	int bitmask;
+	unsigned long flags;
+
+	bitmask = 0x01 << (led_cdev - &landisk_leds[0]);
+
+	spin_lock_irqsave(&landisk_led_lock, flags);
+	tmp = ctrl_inb(PA_LED);
+	if (value)
+		tmp |= bitmask;
+	else
+		tmp &= ~bitmask;
+	ctrl_outb(tmp, PA_LED);
+	spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static int landisk_led_probe(struct platform_device *pdev)
+{
+	int i, nr_leds;
+	int ret;
+
+	nr_leds = landisk_arch ? 8 : 2;
+
+	for (i = ret = 0; ret >= 0 && i < nr_leds; i++) {
+		ret = led_classdev_register(&pdev->dev, &landisk_leds[i]);
+	}
+
+	if (ret < 0 && i > 1) {
+		nr_leds = i - 1;
+		for (i = 0; i < nr_leds; i++)
+			led_classdev_unregister(&landisk_leds[i]);
+	}
+
+	return ret;
+}
+
+static int landisk_led_remove(struct platform_device *pdev)
+{
+	int i, nr_leds;
+
+	nr_leds = landisk_arch ? 8 : 2;
+
+	for (i = 0; i < nr_leds; i++) {
+		led_classdev_unregister(&landisk_leds[i]);
+	}
+
+	return 0;
+}
+
+static struct platform_driver landisk_led_driver = {
+	.probe = landisk_led_probe,
+	.remove = landisk_led_remove,
+	.driver = {
+		   .name = "landisk-led",
+		   },
+};
+
+/*
+ * LANDISK hardware controled LED trigger
+ *
+ *  bit[3:0] = x0xx : power-led  is allways ON.
+ *  bit[3:0] = x1x0 : power-led  is ON.
+ *  bit[3:0] = x1x1 : power-led  is OFF.
+ *  bit[3:0] = 0xxx : status-led is HDD access-LED.
+ *  bit[3:0] = 1x0x : status-led is ON
+ *  bit[3:0] = 1x1x : status-led is OFF
+ */
+static void landisk_hard_trig_activate(struct led_classdev *led_cdev)
+{
+	unsigned long flags;
+	int bitmask;
+
+	bitmask = 0x04 << (led_cdev - &landisk_leds[0]);
+
+	spin_lock_irqsave(&landisk_led_lock, flags);
+	ctrl_outb(ctrl_inb(PA_LED) & ~bitmask, PA_LED);
+	spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static void landisk_hard_trig_deactivate(struct led_classdev *led_cdev)
+{
+	unsigned long flags;
+	int bitmask;
+
+	bitmask = 0x04 << (led_cdev - &landisk_leds[0]);
+
+	spin_lock_irqsave(&landisk_led_lock, flags);
+	ctrl_outb(ctrl_inb(PA_LED) | bitmask, PA_LED);
+	spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static struct led_trigger landisk_hard_led_trigger = {
+	.name = "hard",
+	.activate = landisk_hard_trig_activate,
+	.deactivate = landisk_hard_trig_deactivate,
+};
+
+static int __init landisk_led_init(void)
+{
+	u8 orig, test;
+	int err = 0;
+
+	orig = ctrl_inb(PA_LED);
+	ctrl_outb(0x40, PA_LED);
+
+	test = ctrl_inb(PA_LED);
+	ctrl_outb(orig, PA_LED);
+
+	landisk_arch = (test == 0x40);
+
+	if (landisk_arch == 0) {
+		/* arch == landisk */
+		ctrl_outb(orig | 0x07, PA_LED);
+		landisk_leds[1].default_trigger = "hard";
+		err = led_trigger_register(&landisk_hard_led_trigger);
+		if (err)
+			return err;
+	} else {
+		/* arch == usl-5p */
+		ctrl_outb(orig | 0x03, PA_LED);
+	}
+	return platform_driver_register(&landisk_led_driver);
+}
+
+static void __exit landisk_led_exit(void)
+{
+	if (landisk_arch == 0)
+		led_trigger_unregister(&landisk_hard_led_trigger);
+	platform_driver_unregister(&landisk_led_driver);
+}
+
+module_init(landisk_led_init);
+module_exit(landisk_led_exit);
+
+MODULE_AUTHOR("kogiidena <kogiidena@eggplant.ddo.jp>");
+MODULE_DESCRIPTION("landisk LED driver");
+MODULE_LICENSE("GPL");




