Return-Path: <linux-kernel-owner+w=401wt.eu-S967285AbXEHNAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967285AbXEHNAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967063AbXEHNAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:00:37 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:61866
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966124AbXEHNAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:00:36 -0400
X-Greylist: delayed 2023 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 09:00:35 EDT
Message-ID: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp>
Date: Tue, 8 May 2007 21:26:50 +0900 (JST)
Subject: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To:Richard-san
CC:all

LED driver of I-O DATA LANDISK and USL-5P
Please apply following patch

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>

---
diff -urpN linux-2.6.21-rc4.orig/drivers/leds/Kconfig NEW/drivers/leds/Kconfig
--- linux-2.6.21-rc4.orig/drivers/leds/Kconfig        2007-03-16 09:20:01.000000000 +0900
+++ NEW/drivers/leds/Kconfig        2007-03-27 18:30:44.000000000 +0900
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
diff -urpN linux-2.6.21-rc4.orig/drivers/leds/Makefile NEW/drivers/leds/Makefile
--- linux-2.6.21-rc4.orig/drivers/leds/Makefile        2007-03-16 09:20:01.000000000 +0900
+++ NEW/drivers/leds/Makefile        2007-03-27 18:27:18.000000000 +0900
@@ -16,6 +16,7 @@ obj-$(CONFIG_LEDS_NET48XX)                += leds-net4
 obj-$(CONFIG_LEDS_WRAP)                        += leds-wrap.o
 obj-$(CONFIG_LEDS_H1940)                += leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT)                += leds-cobalt.o
+obj-$(CONFIG_LEDS_LANDISK)                += leds-landisk.o

 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)        += ledtrig-timer.o
diff -urpN linux-2.6.21-rc4.orig/drivers/leds/leds-landisk.c NEW/drivers/leds/leds-landisk.c
--- linux-2.6.21-rc4.orig/drivers/leds/leds-landisk.c        1970-01-01 09:00:00.000000000 +0900
+++ NEW/drivers/leds/leds-landisk.c        2007-03-27 18:16:48.000000000 +0900
@@ -0,0 +1,183 @@
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
+static int landisk_arch;                /* 0:LANDISK, LANTank 1:USL-5P */
+
+static void landisk_led_set(struct led_classdev *led_cdev,
+                            enum led_brightness value);
+
+static struct led_classdev landisk_leds[] = {
+        [0] = {
+                        .name = "power",
+                        .brightness_set = landisk_led_set,
+                        .default_trigger = "blink",
+               },
+        [1] = {
+                        .name = "status",
+                        .brightness_set = landisk_led_set,
+                        .default_trigger = "blink",
+               },
+        [2] = {
+                        .name = "led1",
+                        .brightness_set = landisk_led_set,
+               },
+        [3] = {
+                        .name = "led2",
+                        .brightness_set = landisk_led_set,
+               },
+        [4] = {
+                        .name = "led3",
+                        .brightness_set = landisk_led_set,
+               },
+        [5] = {
+                        .name = "led4",
+                        .brightness_set = landisk_led_set,
+               },
+        [6] = {
+                        .name = "led5",
+                        .brightness_set = landisk_led_set,
+               },
+        [7] = {
+                        .name = "buzzer",
+                        .default_trigger = "bitshift",
+                        .brightness_set = landisk_led_set,
+               },
+};
+
+static void landisk_led_set(struct led_classdev *led_cdev,
+                            enum led_brightness value)
+{
+        u8 tmp;
+        int bitmask;
+        unsigned long flags;
+
+        bitmask = 0x01 << (led_cdev - &landisk_leds[0]);
+
+        spin_lock_irqsave(&landisk_led_lock, flags);
+        tmp = ctrl_inb(PA_LED);
+        if (value)
+                tmp |=  bitmask;
+        else
+                tmp &= ~bitmask;
+        ctrl_outb(tmp, PA_LED);
+        spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static int landisk_led_probe(struct platform_device *pdev)
+{
+        int i, nr_leds;
+        int ret;
+
+        nr_leds = landisk_arch ? 8 : 2;
+
+        for (i = ret = 0; ret >= 0 && i < nr_leds; i++) {
+                ret = led_classdev_register(&pdev->dev, &landisk_leds[i]);
+        }
+
+        if (ret < 0 && i > 1) {
+                nr_leds = i - 1;
+                for (i = 0; i < nr_leds; i++)
+                        led_classdev_unregister(&landisk_leds[i]);
+        }
+
+        return ret;
+}
+
+static int landisk_led_remove(struct platform_device *pdev)
+{
+        int i, nr_leds;
+
+        nr_leds = landisk_arch ? 8 : 2;
+
+        for (i = 0; i < nr_leds; i++) {
+                   led_classdev_unregister(&landisk_leds[i]);
+        }
+
+        return 0;
+}
+
+static struct platform_driver landisk_led_driver = {
+        .probe         = landisk_led_probe,
+        .remove = landisk_led_remove,
+        .driver = {
+                   .name = "landisk-led",
+                   },
+};
+
+/* HDD-access-LED setting at landisk status LED */
+static void landisk_disk_trig_activate(struct led_classdev *led_cdev)
+{
+        unsigned long flags;
+        spin_lock_irqsave(&landisk_led_lock, flags);
+        ctrl_outb((ctrl_inb(PA_LED) & ~0x0c) | 0x04, PA_LED);
+        spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static void landisk_disk_trig_deactivate(struct led_classdev *led_cdev)
+{
+        unsigned long flags;
+        spin_lock_irqsave(&landisk_led_lock, flags);
+        ctrl_outb((ctrl_inb(PA_LED) & ~0x0c) | 0x0c, PA_LED);
+        spin_unlock_irqrestore(&landisk_led_lock, flags);
+}
+
+static struct led_trigger landisk_disk_led_trigger = {
+        .name = "disk",
+        .activate = landisk_disk_trig_activate,
+        .deactivate = landisk_disk_trig_deactivate,
+};
+
+static int __init landisk_led_init(void)
+{
+        u8 orig, test;
+
+        orig = ctrl_inb(PA_LED);
+        ctrl_outb(0x40, PA_LED);
+
+        test = ctrl_inb(PA_LED);
+        ctrl_outb(orig, PA_LED);
+
+        landisk_arch = (test == 0x40);
+
+        if (landisk_arch == 0) {
+                /* arch == landisk */
+                ctrl_outb(orig | 0x07, PA_LED);
+                landisk_leds[1].default_trigger = "disk";
+                led_trigger_register(&landisk_disk_led_trigger);
+        } else {
+                /* arch == usl-5p */
+                ctrl_outb(orig | 0x03, PA_LED);
+        }
+        return platform_driver_register(&landisk_led_driver);
+}
+
+static void __exit landisk_led_exit(void)
+{
+        if (landisk_arch == 0)
+                led_trigger_unregister(&landisk_disk_led_trigger);
+        return platform_driver_unregister(&landisk_led_driver);
+}
+
+module_init(landisk_led_init);
+module_exit(landisk_led_exit);
+
+MODULE_AUTHOR("kogiidena <kogiidena@eggplant.ddo.jp>");
+MODULE_DESCRIPTION("landisk LED driver");
+MODULE_LICENSE("GPL");












