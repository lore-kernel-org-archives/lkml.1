Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0BIUrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:47:35 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:57612 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0BIUqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:46:36 -0500
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-embedded@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bill Gatliff <bgat@billgatliff.com>
Subject: [PWM PATCH 5/7] LED "dim" trigger based on PWM control of the LED
Date: Tue,  9 Feb 2010 14:46:32 -0600
Message-Id: <e5f3ecb7c7220a75184525a71ca668f91e5667c7.1265748264.git.bgat@billgatliff.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <0b1e9d2f93d366f003348f4d31fdfbf8da4594b2.1265748264.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
 <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com>
 <7178097a5a8af15f61656f11b6bef68b0da71498.1265748264.git.bgat@billgatliff.com>
 <6ba8043e7749806f88b685ecd5ad7c4e1062bc91.1265748264.git.bgat@billgatliff.com>
 <0b1e9d2f93d366f003348f4d31fdfbf8da4594b2.1265748264.git.bgat@billgatliff.com>
In-Reply-To: <cover.1265748263.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
---
 drivers/leds/ledtrig-dim.c |   95 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-dim.c

diff --git a/drivers/leds/ledtrig-dim.c b/drivers/leds/ledtrig-dim.c
new file mode 100644
index 0000000..299865b
--- /dev/null
+++ b/drivers/leds/ledtrig-dim.c
@@ -0,0 +1,95 @@
+/*
+ * LED Dim Trigger
+ *
+ * Copyright (C) 2008 Bill Gatliff <bgat@billgatliff.com>
+ *
+ * "Dims" an LED based on system load.  Derived from Atsushi Nemoto's
+ * ledtrig-heartbeat.c.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/leds.h>
+
+#include "leds.h"
+
+struct dim_trig_data {
+	struct timer_list timer;
+};
+
+
+static void
+led_dim_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *)data;
+	struct dim_trig_data *dim_data = led_cdev->trigger_data;
+	unsigned int brightness;
+
+	brightness = ((LED_FULL - LED_OFF) * avenrun[0]) / EXP_1;
+	if (brightness > LED_FULL)
+		brightness = LED_FULL;
+
+	led_set_brightness(led_cdev, brightness);
+	mod_timer(&dim_data->timer, jiffies + msecs_to_jiffies(500));
+}
+
+
+static void
+dim_trig_activate(struct led_classdev *led_cdev)
+{
+	struct dim_trig_data *dim_data;
+
+	dim_data = kzalloc(sizeof(*dim_data), GFP_KERNEL);
+	if (!dim_data)
+		return;
+
+	led_cdev->trigger_data = dim_data;
+	setup_timer(&dim_data->timer,
+		    led_dim_function, (unsigned long)led_cdev);
+	led_dim_function(dim_data->timer.data);
+}
+
+
+static void
+dim_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct dim_trig_data *dim_data = led_cdev->trigger_data;
+
+	if (dim_data) {
+		del_timer_sync(&dim_data->timer);
+		kfree(dim_data);
+	}
+}
+
+
+static struct led_trigger dim_led_trigger = {
+	.name     = "dim",
+	.activate = dim_trig_activate,
+	.deactivate = dim_trig_deactivate,
+};
+
+
+static int __init dim_trig_init(void)
+{
+	return led_trigger_register(&dim_led_trigger);
+}
+module_init(dim_trig_init);
+
+
+static void __exit dim_trig_exit(void)
+{
+	led_trigger_unregister(&dim_led_trigger);
+}
+module_exit(dim_trig_exit);
+
+
+MODULE_AUTHOR("Bill Gatliff <bgat@billgatliff.com>");
+MODULE_DESCRIPTION("Dim LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.6.5

