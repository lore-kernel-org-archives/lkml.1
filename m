Return-Path: <linux-kernel-owner+w=401wt.eu-S967342AbXEHNAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967342AbXEHNAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967289AbXEHNAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:00:39 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:61865
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967054AbXEHNAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:00:36 -0400
Message-ID: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp>
Date: Tue, 8 May 2007 21:27:05 +0900 (JST)
Subject: [PATCH 2/2] leds:arch/sh/boards/landisk LEDs supports
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

I wrote LED Blink Trigger. Pleas apply if there is no problem.

This allows LEDs to be controlled by a programmable timer.
"blink" blinks LED at a constant cycle.
"bitshift" turns LED or Buzzer on and off by the value of pattern.

Kernel version: linux-2.6.21-rc4
Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>

---
diff -urpN OLD/drivers/leds/Kconfig NEW/drivers/leds/Kconfig
--- OLD/drivers/leds/Kconfig        2007-03-27 18:30:44.000000000 +0900
+++ NEW/drivers/leds/Kconfig        2007-03-27 18:52:42.000000000 +0900
@@ -134,5 +134,14 @@ config LEDS_TRIGGER_HEARTBEAT
           load average.
           If unsure, say Y.

+config LEDS_TRIGGER_BLINK
+        tristate "LED Blink Trigger"
+        depends on LEDS_TRIGGERS
+        help
+          This allows LEDs to be controlled by a programmable timer.
+          "blink" blinks LED at a constant cycle.
+          "bitshift" turns LED on and off by the value of pattern.
+          If unsure, say Y.
+
 endmenu

diff -urpN OLD/drivers/leds/Makefile NEW/drivers/leds/Makefile
--- OLD/drivers/leds/Makefile        2007-03-27 18:27:18.000000000 +0900
+++ NEW/drivers/leds/Makefile        2007-03-27 18:36:02.000000000 +0900
@@ -22,3 +22,4 @@ obj-$(CONFIG_LEDS_LANDISK)                += leds-land
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)        += ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)        += ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)        += ledtrig-heartbeat.o
+obj-$(CONFIG_LEDS_TRIGGER_BLINK)        += ledtrig-blink.o
diff -urpN OLD/drivers/leds/ledtrig-blink.c NEW/drivers/leds/ledtrig-blink.c
--- OLD/drivers/leds/ledtrig-blink.c        1970-01-01 09:00:00.000000000 +0900
+++ NEW/drivers/leds/ledtrig-blink.c        2007-03-27 18:16:55.000000000 +0900
@@ -0,0 +1,235 @@
+/*
+ * LED Blink Trigger
+ *
+ * Copyright (C) 2007 kogiidena
+ *
+ * Based on drivers/leds/ledtrig-heartbeat.c by:
+ * Copyright (C) 2006 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/leds.h>
+#include <linux/device.h>
+#include <linux/ctype.h>
+#include "leds.h"
+
+struct blink_trig_data {
+        unsigned int mode;
+        signed int phase;
+        unsigned long interval;
+        struct timer_list timer;
+};
+
+static void led_blink_function(unsigned long data)
+{
+        struct led_classdev *led_cdev = (struct led_classdev *)data;
+        struct blink_trig_data *blink_data = led_cdev->trigger_data;
+        unsigned long delay = blink_data->interval;
+
+        led_set_brightness(led_cdev,
+                           blink_data->phase & 0x1 ? LED_FULL : LED_OFF);
+
+        if ((blink_data->mode != 0) ||
+            ((blink_data->phase != 0) && (blink_data->phase != 0xffffffff))) {
+                mod_timer(&blink_data->timer,
+                          jiffies + msecs_to_jiffies(delay));
+        }
+        if (blink_data->mode != 0)
+                blink_data->phase++;
+        else
+                blink_data->phase >>= 1;
+}
+
+static ssize_t led_interval_show(struct class_device *dev, char *buf)
+{
+        struct led_classdev *led_cdev = class_get_devdata(dev);
+        struct blink_trig_data *blink_data = led_cdev->trigger_data;
+
+        sprintf(buf, "%lu\n", blink_data->interval);
+
+        return strlen(buf) + 1;
+}
+
+static ssize_t led_interval_store(struct class_device *dev, const char *buf,
+                                  size_t size)
+{
+        struct led_classdev *led_cdev = class_get_devdata(dev);
+        struct blink_trig_data *blink_data = led_cdev->trigger_data;
+        int ret = -EINVAL;
+        char *after;
+        unsigned long state = simple_strtoul(buf, &after, 10);
+        size_t count = after - buf;
+
+        if (*after && isspace(*after))
+                count++;
+
+        if (count == size) {
+                blink_data->interval = state;
+                mod_timer(&blink_data->timer, jiffies + 1);
+                ret = count;
+        }
+        return ret;
+}
+
+static ssize_t led_pattern_show(struct class_device *dev, char *buf)
+{
+        struct led_classdev *led_cdev = class_get_devdata(dev);
+        struct blink_trig_data *blink_data = led_cdev->trigger_data;
+
+        sprintf(buf, "0x%08x\n", blink_data->phase);
+
+        return strlen(buf) + 1;
+}
+
+static ssize_t led_pattern_store(struct class_device *dev, const char *buf,
+                                 size_t size)
+{
+        struct led_classdev *led_cdev = class_get_devdata(dev);
+        struct blink_trig_data *blink_data = led_cdev->trigger_data;
+        int ret = -EINVAL;
+        char *after;
+        unsigned long state = simple_strtoul(buf, &after, 16);
+        size_t count = after - buf;
+
+        if (*after && isspace(*after))
+                count++;
+
+        if (count == size) {
+                blink_data->phase = state;
+                mod_timer(&blink_data->timer, jiffies + 1);
+                ret = count;
+        }
+        return ret;
+}
+
+static CLASS_DEVICE_ATTR(interval, 0644, led_interval_show, led_interval_store);
+static CLASS_DEVICE_ATTR(pattern, 0644, led_pattern_show, led_pattern_store);
+
+static void blink_trig_activate(struct led_classdev *led_cdev)
+{
+        struct blink_trig_data *blink_data;
+        int rc;
+
+        blink_data = kzalloc(sizeof(*blink_data), GFP_KERNEL);
+        if (!blink_data)
+                return;
+
+        led_cdev->trigger_data = blink_data;
+
+        blink_data->mode = 1;
+        blink_data->phase = 1;
+        blink_data->interval = 250;
+
+        rc = class_device_create_file(led_cdev->class_dev,
+                                      &class_device_attr_interval);
+        if (rc)
+                goto err_out;
+
+        setup_timer(&blink_data->timer,
+                    led_blink_function, (unsigned long)led_cdev);
+
+        led_blink_function(blink_data->timer.data);
+
+        return;
+
+err_out:
+        led_cdev->trigger_data = NULL;
+        kfree(blink_data);
+}
+
+static void bitshift_trig_activate(struct led_classdev *led_cdev)
+{
+        struct blink_trig_data *blink_data;
+        int rc;
+
+        blink_data = kzalloc(sizeof(*blink_data), GFP_KERNEL);
+        if (!blink_data)
+                return;
+
+        led_cdev->trigger_data = blink_data;
+
+        blink_data->mode = 0;
+        blink_data->phase = 0;
+        blink_data->interval = 250;
+
+        rc = class_device_create_file(led_cdev->class_dev,
+                                      &class_device_attr_interval);
+        if (rc)
+                goto err_out;
+
+        rc = class_device_create_file(led_cdev->class_dev,
+                                      &class_device_attr_pattern);
+        if (rc)
+                goto err_out_interval;
+
+        setup_timer(&blink_data->timer,
+                    led_blink_function, (unsigned long)led_cdev);
+
+        led_blink_function(blink_data->timer.data);
+
+        return;
+
+err_out_interval:
+        class_device_remove_file(led_cdev->class_dev,
+                                 &class_device_attr_interval);
+err_out:
+        led_cdev->trigger_data = NULL;
+        kfree(blink_data);
+}
+
+static void blink_trig_deactivate(struct led_classdev *led_cdev)
+{
+        struct blink_trig_data *blink_data = led_cdev->trigger_data;
+
+        if (blink_data) {
+                class_device_remove_file(led_cdev->class_dev,
+                                         &class_device_attr_interval);
+                if (blink_data->mode == 0) {
+                        class_device_remove_file(led_cdev->class_dev,
+                                                 &class_device_attr_pattern);
+                }
+                del_timer_sync(&blink_data->timer);
+                kfree(blink_data);
+        }
+}
+
+static struct led_trigger blink_led_trigger = {
+        .name                 = "blink",
+        .activate         = blink_trig_activate,
+        .deactivate         = blink_trig_deactivate,
+};
+
+static struct led_trigger bitshift_led_trigger = {
+        .name                 = "bitshift",
+        .activate         = bitshift_trig_activate,
+        .deactivate         = blink_trig_deactivate,
+};
+
+static int __init blink_trig_init(void)
+{
+        led_trigger_register(&blink_led_trigger);
+        led_trigger_register(&bitshift_led_trigger);
+        return 0;
+}
+
+static void __exit blink_trig_exit(void)
+{
+        led_trigger_unregister(&blink_led_trigger);
+        led_trigger_unregister(&bitshift_led_trigger);
+}
+
+module_init(blink_trig_init);
+module_exit(blink_trig_exit);
+
+MODULE_AUTHOR("kogiidena <kogiidena@eggplant.ddo.jp>");
+MODULE_DESCRIPTION("Blink LED trigger");
+MODULE_LICENSE("GPL");






