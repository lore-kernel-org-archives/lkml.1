Return-Path: <linux-kernel-owner+w=401wt.eu-S1762053AbXEKPD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762053AbXEKPD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 11:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760652AbXEKPDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:03:13 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:63928
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533AbXEKPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:03:11 -0400
Message-ID: <1185.192.168.1.10.1178895789.squirrel@eggplant.ddo.jp>
Date: Sat, 12 May 2007 00:03:09 +0900 (JST)
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: cbou@mail.ru, rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
References: <20070509160328.GA13640@zarina><1249.192.168.1.10.1178797933.squirrel@eggplant.ddo.jp><20070510140415.GA19167@linux-sh.org>
In-Reply-To: <20070510140415.GA19167@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To: Paul-san
The following three points were corrected.
thank you for you check.

1.
> DEFINE_SPINLOCK(), please.

2.
> If you're going to do this, enums are probably the cleaner way to go.
> Checking landisk_arch == 0 all over the place is non-obvious without
> seeing this comment.

3.
> You may also want some sanity checking here, while PA_LED is only 8-bits,
> your bitmask is not.

To: Richard-san
Please apply.

LED driver of I-O DATA LANDISK and USL-5P

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
---
diff -urpN OLD/drivers/leds/Kconfig NEW/drivers/leds/Kconfig
--- OLD/drivers/leds/Kconfig	2007-04-28 06:49:26.000000000 +0900
+++ NEW/drivers/leds/Kconfig	2007-05-11 21:15:28.000000000 +0900
@@ -94,6 +94,12 @@ config LEDS_COBALT
 	help
 	  This option enables support for the front LED on Cobalt Server

+config LEDS_LANDISK
+	tristate "LED Support for LANDISK Series"
+	depends on LEDS_CLASS && SH_LANDISK
+	help
+	  This option enables support for the LED on LANDISK Series
+
 comment "LED Triggers"

 config LEDS_TRIGGERS
diff -urpN OLD/drivers/leds/Makefile NEW/drivers/leds/Makefile
--- OLD/drivers/leds/Makefile	2007-04-28 06:49:26.000000000 +0900
+++ NEW/drivers/leds/Makefile	2007-05-11 23:34:07.000000000 +0900
@@ -16,6 +16,7 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net4
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
+obj-$(CONFIG_LEDS_LANDISK)		+= leds-landisk.o

 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff -urpN OLD/drivers/leds/leds-landisk.c NEW/drivers/leds/leds-landisk.c
--- OLD/drivers/leds/leds-landisk.c	1970-01-01 09:00:00.000000000 +0900
+++ NEW/drivers/leds/leds-landisk.c	2007-05-11 23:12:16.000000000 +0900
@@ -0,0 +1,214 @@
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
+static enum {
+	LANDISK = 0,
+	USL_5P  = 1,
+} landisk_product;
+
+static DEFINE_SPINLOCK(landisk_led_lock);
+
+static void landisk_led_set(struct led_classdev *led_cdev,
+			    enum led_brightness value);
+
+static struct led_classdev landisk_leds[] = {
+	[0] = {
+	       .name = "power",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "bitpat",
+	       },
+	[1] = {
+	       .name = "status",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "bitpat",
+	       },
+	[2] = {
+	       .name = "led1",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "bitpat",
+	       },
+	[3] = {
+	       .name = "led2",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "bitpat",
+	       },
+	[4] = {
+	       .name = "led3",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "bitpat",
+	       },
+	[5] = {
+	       .name = "led4",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "bitpat",
+	       },
+	[6] = {
+	       .name = "led5",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "bitpat",
+	       },
+	[7] = {
+	       .name = "buzzer",
+	       .brightness_set = landisk_led_set,
+	       .default_trigger = "bitpat",
+	       },
+};
+
+void ledtrig_bitpat_default(struct led_classdev *led_cdev,
+			    unsigned long *interval, char *bitdata)
+{
+	int led;
+
+	*interval  = 250;
+	bitdata[0] = '\0';
+
+	led = (led_cdev - &landisk_leds[0]);
+	if ((led == 0) || (led == 1)) {
+		strcpy(bitdata, "blink");
+	}
+}
+
+static void landisk_led_set(struct led_classdev *led_cdev,
+			    enum led_brightness value)
+{
+	u8 tmp, bitmask;
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
+	nr_leds = (landisk_product == LANDISK) ? 2 : 8;
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
+	return ret;
+}
+
+static int landisk_led_remove(struct platform_device *pdev)
+{
+	int i, nr_leds;
+
+	nr_leds = (landisk_product == LANDISK) ? 2 : 8;
+
+	for (i = 0; i < nr_leds; i++) {
+		led_classdev_unregister(&landisk_leds[i]);
+	}
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
+/* HDD-access-LED setting at landisk status LED */
+static void landisk_disk_trig_activate(struct led_classdev *led_cdev)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&landisk_led_lock, flags);
+	ctrl_outb((ctrl_inb(PA_LED) & ~0x0c) | 0x04, PA_LED);
+	spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static void landisk_disk_trig_deactivate(struct led_classdev *led_cdev)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&landisk_led_lock, flags);
+	ctrl_outb((ctrl_inb(PA_LED) & ~0x0c) | 0x0c, PA_LED);
+	spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static int landisk_disk_trig_is_led_supported(struct led_classdev *led_cdev)
+{
+	int led;
+
+	led = (led_cdev - &landisk_leds[0]);
+	return ((landisk_product == LANDISK) && (led == 1));
+}
+
+static struct led_trigger landisk_disk_led_trigger = {
+	.name = "disk",
+	.activate = landisk_disk_trig_activate,
+	.deactivate = landisk_disk_trig_deactivate,
+	.is_led_supported = landisk_disk_trig_is_led_supported,
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
+	if (test != 0x40) {
+		landisk_product = LANDISK;
+		ctrl_outb(orig | 0x07, PA_LED);
+		landisk_leds[1].default_trigger = "disk";
+	} else {
+		landisk_product = USL_5P;
+		ctrl_outb(orig | 0x03, PA_LED);
+	}
+
+	err = led_trigger_register(&landisk_disk_led_trigger);
+	if (err)
+		return err;
+
+	return platform_driver_register(&landisk_led_driver);
+}
+
+static void __exit landisk_led_exit(void)
+{
+	led_trigger_unregister(&landisk_disk_led_trigger);
+	platform_driver_unregister(&landisk_led_driver);
+}
+
+module_init(landisk_led_init);
+module_exit(landisk_led_exit);
+
+MODULE_AUTHOR("kogiidena <kogiidena@eggplant.ddo.jp>");
+MODULE_DESCRIPTION("landisk LED driver");
+MODULE_LICENSE("GPL");





