Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbXELEB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbXELEB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 00:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbXELEBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 00:01:49 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:63579
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbXELEBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 00:01:48 -0400
Message-ID: <1283.192.168.1.10.1178942507.squirrel@eggplant.ddo.jp>
Date: Sat, 12 May 2007 13:01:47 +0900 (JST)
Subject: Re: [PATCH 2/2] leds:arch/sh/boards/landisk LEDs supports
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
References: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp><1178628407.6061.24.camel@localhost.localdomain><1638.192.168.1.10.1178710979.squirrel@eggplant.ddo.jp><1178712861.6291.5.camel@localhost.localdomain><2329.192.168.1.10.1178718316.squirrel@eggplant.ddo.jp><1178723184.6291.16.camel@localhost.localdomain><1445.192.168.1.10.1178749125.squirrel@eggplant.ddo.jp><1185.192.168.1.10.1178895776.squirrel@eggplant.ddo.jp>
In-Reply-To: <1185.192.168.1.10.1178895776.squirrel@eggplant.ddo.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To: Richard-san

I'm sorry. The patch sent yesterday is corrected, too.
Because the source had not been read easily, it cleaned it.
There is no change for the basic function.

Add Bitpattern Trigger.
Bitpattern continuously turns LED on and off according to
the value directed "bitdata". "bitdata" is composed of
the character string that consists of the following three
characters. '0' turn off LED. '1' turn on  LED. 'R' is
repeated from the head of the "bitdata".
In addition, the character string of "on", "off", and "blink"
can be set to "bitdata".
The transition time of "bitdata" is set by "delay".

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
---
diff -urpN OLD/drivers/leds/Kconfig NEW/drivers/leds/Kconfig
--- OLD/drivers/leds/Kconfig	2007-04-28 06:49:26.000000000 +0900
+++ NEW/drivers/leds/Kconfig	2007-05-11 21:15:28.000000000 +0900
@@ -127,5 +133,19 @@ config LEDS_TRIGGER_HEARTBEAT
 	  load average.
 	  If unsure, say Y.

+config LEDS_TRIGGER_BITPAT
+	tristate "LED Bitpattern Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  Bitpattern continuously turns LED on and off according to
+	  the value directed "bitdata". "bitdata" is composed of
+	  the character string that consists of the following three
+	  characters. '0' turn off LED. '1' turn on  LED. 'R' is
+	  repeated from the head of the "bitdata".
+	  In addition, the character string of "on", "off", and "blink"
+	  can be set to "bitdata".
+	  The transition time of "bitdata" is set by "delay".
+	  If unsure, say Y.
+
 endmenu

diff -urpN OLD/drivers/leds/Makefile NEW/drivers/leds/Makefile
--- OLD/drivers/leds/Makefile	2007-05-11 23:44:12.000000000 +0900
+++ NEW/drivers/leds/Makefile	2007-05-11 23:46:47.000000000 +0900
@@ -22,3 +22,4 @@ obj-$(CONFIG_LEDS_LANDISK)		+= leds-land
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
+obj-$(CONFIG_LEDS_TRIGGER_BITPAT)	+= ledtrig-bitpat.o
diff -urpN OLD/drivers/leds/ledtrig-bitpat.c NEW/drivers/leds/ledtrig-bitpat.c
--- OLD/drivers/leds/ledtrig-bitpat.c	1970-01-01 09:00:00.000000000 +0900
+++ NEW/drivers/leds/ledtrig-bitpat.c	2007-05-12 11:29:34.000000000 +0900
@@ -0,0 +1,231 @@
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
+#define BITDATA_LEN 18
+
+struct bitpat_trig_data {
+	char bitdata[BITDATA_LEN + 2];
+	int cnt;
+	unsigned long delay;
+	struct timer_list timer;
+};
+
+void __attribute__ ((weak))
+ledtrig_bitpat_default(struct led_classdev *led_cdev,
+		       unsigned long *delay, char *bitdata)
+{
+	/* Nothing to do. */
+}
+
+static void led_bitpat_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *)data;
+	struct bitpat_trig_data *bitpat_data = led_cdev->trigger_data;
+	unsigned long delay = bitpat_data->delay;
+	char bitpat;
+
+	bitpat = bitpat_data->bitdata[bitpat_data->cnt++];
+
+	if (bitpat == '0' || bitpat == '1') {
+		led_set_brightness(led_cdev,
+				   (bitpat == '1') ? LED_FULL : LED_OFF);
+	} else {
+		bitpat_data->cnt = 0;
+		return;
+	}
+
+	if (bitpat_data->bitdata[bitpat_data->cnt] == 'R')
+		bitpat_data->cnt = 0;
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
+	char *after;
+	unsigned long state = simple_strtoul(buf, &after, 10);
+	size_t count = after - buf;
+
+	if (*after && isspace(*after))
+		count++;
+
+	if (count == size) {
+		bitpat_data->delay = state;
+		mod_timer(&bitpat_data->timer, jiffies + 1);
+		ret = count;
+	}
+	return ret;
+}
+
+static void led_bitdata_update(struct bitpat_trig_data *bitpat_data,
+			       const char *buf)
+{
+	int i;
+	const char *s;
+
+	if (!strncmp("on", buf, 2)) {
+		s = "1";
+	} else if (!strncmp("off", buf, 2)) {
+		s = "0";
+	} else if (!strncmp("blink", buf, 5)) {
+		s = "01R";
+	} else {
+		s = buf;
+	}
+
+	for (i = 0; i < BITDATA_LEN; i++) {
+		if ((s[i] == '0') || (s[i] == '1')) {
+			bitpat_data->bitdata[i] = s[i];
+		} else if ((i != 0) && ((s[i] == 'R') || (s[i] == 'r'))) {
+			bitpat_data->bitdata[i] = 'R';
+			bitpat_data->bitdata[i + 1] = '\0';
+			break;
+		} else {
+			bitpat_data->bitdata[i] = '\0';
+			break;
+		}
+	}
+	bitpat_data->cnt = 0;
+}
+
+static ssize_t led_bitdata_show(struct class_device *dev, char *buf)
+{
+	struct led_classdev *led_cdev = class_get_devdata(dev);
+	struct bitpat_trig_data *bitpat_data = led_cdev->trigger_data;
+
+	sprintf(buf,
+		"bitdata : %s\n"
+		"meaning : 0=OFF, 1=ON, R=Repeat\n",
+		(bitpat_data->bitdata[0]) ? bitpat_data->bitdata : "(null)");
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
+	if (size > BITDATA_LEN)
+		return -EINVAL;
+
+	led_bitdata_update(bitpat_data, buf);
+	mod_timer(&bitpat_data->timer, jiffies + 1);
+
+	return size;
+}
+
+static CLASS_DEVICE_ATTR(delay,   0644, led_delay_show,   led_delay_store);
+static CLASS_DEVICE_ATTR(bitdata, 0644, led_bitdata_show, led_bitdata_store);
+
+static void bitpat_trig_activate(struct led_classdev *led_cdev)
+{
+	struct bitpat_trig_data *bitpat_data;
+	int rc;
+
+	bitpat_data = kzalloc(sizeof(*bitpat_data), GFP_KERNEL);
+	if (!bitpat_data)
+		return;
+
+	led_cdev->trigger_data = bitpat_data;
+
+	/* initial value */
+	bitpat_data->delay      = 500;
+	bitpat_data->bitdata[0] = '\0';
+
+	ledtrig_bitpat_default(led_cdev,
+			       &bitpat_data->delay, &bitpat_data->bitdata[0]);
+	led_bitdata_update(bitpat_data, bitpat_data->bitdata);
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




