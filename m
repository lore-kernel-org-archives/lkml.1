Return-Path: <linux-kernel-owner+w=401wt.eu-S968445AbXFHLSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968445AbXFHLSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966579AbXFHLSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:18:30 -0400
Received: from p1178-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.96.161.178]:60910
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966367AbXFHLS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:18:29 -0400
X-Greylist: delayed 1904 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2007 07:18:28 EDT
Message-ID: <1094.192.168.1.10.1181299602.squirrel@eggplant.ddo.jp>
Date: Fri, 8 Jun 2007 19:46:42 +0900 (JST)
Subject: [PATCH 1/1] leds: LED Bitpattern Trigger
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, lethal@linux-sh.org
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

LED trigger "bitpat" continuously turns LED on and off
according to the value directed "bitdata".
"bitdata" is composed of three characters of '0', '1', and 'R'.
'0' turn off LED. '1' turn on LED.
'R' is repeated from the head of the "bitdata".

  ex.1) LED off
  # echo 0   > /sys/class/leds/LED/bitdata

  ex.2) LED on
  # echo 1   > /sys/class/leds/LED/bitdata

  ex.3) LED is blinked simply.
  # echo 10R > /sys/class/leds/LED/bitdata

  ex.4) LED is blinked twice and stop. It is repeated forever.
  # echo 10100000R > /sys/class/leds/LED/bitdata

In addition, string of "on", "off", and "blink"
can be set to "bitdata".
The transition time of "bitdata" is set by "delay".

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
---
diff -urpN OLD/drivers/leds/Kconfig NEW/drivers/leds/Kconfig
--- OLD/drivers/leds/Kconfig	2007-05-13 10:45:56.000000000 +0900
+++ NEW/drivers/leds/Kconfig	2007-06-08 18:36:37.000000000 +0900
@@ -128,5 +128,32 @@ config LEDS_TRIGGER_HEARTBEAT
 	  load average.
 	  If unsure, say Y.

+config LEDS_TRIGGER_BITPAT
+	tristate "LED Bitpattern Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  LED trigger "bitpat"  continuously turns LED on and off
+          according to the value directed "bitdata".
+          "bitdata" is composed of three characters of '0', '1', and 'R'.
+          '0' turn off LED. '1' turn on LED.
+          'R' is repeated from the head of the "bitdata".
+
+	    ex.1) LED off
+            # echo 0   > /sys/class/leds/LED/bitdata
+
+	    ex.2) LED on
+            # echo 1   > /sys/class/leds/LED/bitdata
+
+	    ex.3) LED is blinked simply.
+            # echo 10R > /sys/class/leds/LED/bitdata
+
+	    ex.4) LED is blinked twice and stop. It is repeated forever.
+            # echo 10100000R > /sys/class/leds/LED/bitdata
+
+	  In addition, string of "on", "off", and "blink"
+	  can be set to "bitdata".
+	  The transition time of "bitdata" is set by "delay".
+	  If unsure, say Y.
+
 endmenu

diff -urpN OLD/drivers/leds/Makefile NEW/drivers/leds/Makefile
--- OLD/drivers/leds/Makefile	2007-05-13 10:45:56.000000000 +0900
+++ NEW/drivers/leds/Makefile	2007-06-08 18:36:24.000000000 +0900
@@ -21,3 +21,4 @@ obj-$(CONFIG_LEDS_COBALT)		+= leds-cobal
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
+obj-$(CONFIG_LEDS_TRIGGER_BITPAT)	+= ledtrig-bitpat.o
diff -urpN OLD/drivers/leds/ledtrig-bitpat.c NEW/drivers/leds/ledtrig-bitpat.c
--- OLD/drivers/leds/ledtrig-bitpat.c	1970-01-01 09:00:00.000000000 +0900
+++ NEW/drivers/leds/ledtrig-bitpat.c	2007-06-08 18:35:08.000000000 +0900
@@ -0,0 +1,253 @@
+/*
+ * LED Bitpattern Trigger
+ *
+ * Copyright (C) 2007 kogiidena
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/*
+ * LED trigger "bitpat"  continuously turns LED on and off
+ * according to the value directed "bitdata".
+ * "bitdata" is composed of three characters of '0', '1', and 'R'.
+ * '0' turn off LED. '1' turn on LED.
+ * 'R' is repeated from the head of the "bitdata".
+ *
+ *   ex.1) LED off
+ *   # echo 0   > /sys/class/leds/LED/bitdata
+ *
+ *   ex.2) LED on
+ *   # echo 1   > /sys/class/leds/LED/bitdata
+ *
+ *   ex.3) LED is blinked simply.
+ *   # echo 10R > /sys/class/leds/LED/bitdata
+ *
+ *   ex.4) LED is blinked twice and stop. It is repeated forever.
+ *   # echo 10100000R > /sys/class/leds/LED/bitdata
+ *
+ * In addition, string of "on", "off", and "blink"
+ * can be set to "bitdata".
+ * The transition time of "bitdata" is set by "delay".
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
+#define BITDATA_LEN 20
+
+struct bitpat_trig_data {
+	unsigned long delay;
+	unsigned long bitdata;
+	int bitdata_len;   /* bitdata length */
+	int bitdata_rep;   /* bitdata repeat flag */
+	int cnt;
+	struct timer_list timer;
+};
+
+void __attribute__ ((weak))
+    ledtrig_bitpat_default(struct led_classdev *led_cdev,
+		       unsigned long *delay, char *bitdata_str)
+{
+	/* Nothing to do. */
+}
+
+static void led_bitpat_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *)data;
+	struct bitpat_trig_data *bitpat_data = led_cdev->trigger_data;
+	unsigned long delay = bitpat_data->delay;
+	unsigned long bitpat;
+
+	bitpat = (bitpat_data->bitdata >> bitpat_data->cnt++) & 0x1;
+	led_set_brightness(led_cdev, (bitpat) ? LED_FULL : LED_OFF);
+
+	if (bitpat_data->cnt >= bitpat_data->bitdata_len) {
+		bitpat_data->cnt = 0;
+		if (bitpat_data->bitdata_rep == 0)
+			return;
+	}
+
+	mod_timer(&bitpat_data->timer, jiffies + msecs_to_jiffies(delay));
+}
+
+static ssize_t led_delay_show(struct class_device *dev, char *buf)
+{
+	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct bitpat_trig_data *bitpat_data = led_cdev->trigger_data;
+
+	sprintf(buf, "%lu\n", bitpat_data->delay);
+
+	return strlen(buf) + 1;
+}
+
+static ssize_t led_delay_store(struct class_device *dev, const char *buf,
+			       size_t size)
+{
+	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct bitpat_trig_data *bitpat_data = led_cdev->trigger_data;
+	int ret = -EINVAL;
+	unsigned long state = simple_strtoul(buf, NULL, 10);
+
+	if (state > 0) {
+		bitpat_data->delay = state;
+		ret = size;
+	}
+	return ret;
+}
+
+static int led_bitdata_update(struct bitpat_trig_data *bitpat_data,
+			      const char *bitdata_str)
+{
+	int i;
+	const char *s;
+	unsigned long bitdata;
+
+	if (!strncmp("on", bitdata_str, 2)) {
+		s = "1";
+	} else if (!strncmp("off", bitdata_str, 3)) {
+		s = "0";
+	} else if (!strncmp("blink", bitdata_str, 5)) {
+		s = "01R";
+	} else {
+		s = bitdata_str;
+	}
+
+	for (i = 0, bitdata = 0; i < BITDATA_LEN; i++) {
+		if ((s[i] == '0') || (s[i] == '1')) {
+			bitdata |= (((unsigned long)(s[i] - '0')) << i);
+		} else {
+			break;
+		}
+	}
+
+	if (i > 0) {
+		bitpat_data->bitdata = bitdata;
+		bitpat_data->bitdata_len = i;
+		bitpat_data->bitdata_rep = ((s[i] == 'R') || (s[i] == 'r'));
+		bitpat_data->cnt = 0;
+	}
+	return i;
+}
+
+static ssize_t led_bitdata_show(struct class_device *dev, char *buf)
+{
+	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct bitpat_trig_data *bitpat_data = led_cdev->trigger_data;
+	int i;
+
+	for (i = 0; i < bitpat_data->bitdata_len; i++) {
+		buf[i] = ((bitpat_data->bitdata >> i) & 0x1) ? '1' : '0';
+	}
+	if (bitpat_data->bitdata_rep)
+		buf[i++] = 'R';
+	buf[i++] = '\n';
+	buf[i++] = '\0';
+
+	return strlen(buf) + 1;
+}
+
+static ssize_t led_bitdata_store(struct class_device *dev, const char *buf,
+				 size_t size)
+{
+	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct bitpat_trig_data *bitpat_data = led_cdev->trigger_data;
+
+	if (led_bitdata_update(bitpat_data, buf)) {
+		mod_timer(&bitpat_data->timer, jiffies + 1);
+		return size;
+	}
+	return -EINVAL;
+}
+
+static CLASS_DEVICE_ATTR(delay, 0644, led_delay_show, led_delay_store);
+static CLASS_DEVICE_ATTR(bitdata, 0644, led_bitdata_show, led_bitdata_store);
+
+static void bitpat_trig_activate(struct led_classdev *led_cdev)
+{
+	struct bitpat_trig_data *bitpat_data;
+	int rc;
+	char bitdata_str[BITDATA_LEN + 2];
+
+	bitpat_data = kzalloc(sizeof(*bitpat_data), GFP_KERNEL);
+	if (!bitpat_data)
+		return;
+
+	led_cdev->trigger_data = bitpat_data;
+
+	/* initial value */
+	bitpat_data->delay = 500;
+	bitdata_str[0] = '0';
+	bitdata_str[1] = '\0';
+
+	ledtrig_bitpat_default(led_cdev, &bitpat_data->delay, bitdata_str);
+	led_bitdata_update(bitpat_data, bitdata_str);
+
+	rc = class_device_create_file(led_cdev->class_dev,
+				      &class_device_attr_delay);
+	if (rc)
+		goto err_out;
+	rc = class_device_create_file(led_cdev->class_dev,
+				      &class_device_attr_bitdata);
+	if (rc)
+		goto err_out_delay;
+
+	setup_timer(&bitpat_data->timer,
+		    led_bitpat_function, (unsigned long)led_cdev);
+	led_bitpat_function(bitpat_data->timer.data);
+
+	return;
+
+err_out_delay:
+	class_device_remove_file(led_cdev->class_dev, &class_device_attr_delay);
+err_out:
+	led_cdev->trigger_data = NULL;
+	kfree(bitpat_data);
+}
+
+static void bitpat_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct bitpat_trig_data *bitpat_data = led_cdev->trigger_data;
+
+	if (bitpat_data) {
+		class_device_remove_file(led_cdev->class_dev,
+					 &class_device_attr_delay);
+		class_device_remove_file(led_cdev->class_dev,
+					 &class_device_attr_bitdata);
+		del_timer_sync(&bitpat_data->timer);
+		kfree(bitpat_data);
+	}
+}
+
+static struct led_trigger bitpat_led_trigger = {
+	.name = "bitpat",
+	.activate = bitpat_trig_activate,
+	.deactivate = bitpat_trig_deactivate,
+};
+
+static int __init bitpat_trig_init(void)
+{
+	led_trigger_register(&bitpat_led_trigger);
+	return 0;
+}
+
+static void __exit bitpat_trig_exit(void)
+{
+	led_trigger_unregister(&bitpat_led_trigger);
+}
+
+module_init(bitpat_trig_init);
+module_exit(bitpat_trig_exit);
+
+MODULE_AUTHOR("kogiidena <kogiidena@eggplant.ddo.jp>");
+MODULE_DESCRIPTION("Bitpattern LED trigger");
+MODULE_LICENSE("GPL");



