Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbZBYJfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbZBYJfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZBYJfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:35:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24108 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZBYJe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:34:57 -0500
Date: Wed, 25 Feb 2009 18:34:40 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] LED key trigger support
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, soni.trilok@gmail.com, rpurdie@rpsys.net
Message-id: <20090225093440.GA5414@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 25 Feb 2009 09:34:47.0888 (UTC)
 FILETIME=[4CC19500:01C9972C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When key button is pressed or released, it turns on or off LED.

It's depends on input notifier support patch.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 1b2a491..256f883 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -248,4 +248,11 @@ config LEDS_TRIGGER_DEFAULT_ON
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_KEY
+	tristate "LED Key input Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled by key input.
+	  If unsure, say Y.
+
 endif # NEW_LEDS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 89526ad..f31417d 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
+obj-$(CONFIG_LEDS_TRIGGER_KEY)		+= ledtrig-key.o
diff --git a/drivers/leds/ledtrig-key.c b/drivers/leds/ledtrig-key.c
new file mode 100644
index 0000000..2e62663
--- /dev/null
+++ b/drivers/leds/ledtrig-key.c
@@ -0,0 +1,93 @@
+/*
+ * LED key trigger
+ *
+ * Copyright (C) 2009 Samsung Electronics
+ * Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/input.h>
+#include "leds.h"
+
+struct key_trigger_notifier {
+	struct led_classdev	*led;
+	struct notifier_block	notifier;
+};
+
+static int key_notifier_callback(struct notifier_block *nb,
+				unsigned long event, void *data)
+{
+	struct key_trigger_notifier *kn = container_of(nb,
+					struct key_trigger_notifier, notifier);
+	struct led_classdev *led = kn->led;
+	unsigned int *key_value = (unsigned int *) data;
+
+	/* In case of touchscreen, just skip it */
+	if (*key_value == BTN_TOUCH)
+		return 0;
+
+	led_set_brightness(led, event);
+	return 0;
+
+}
+
+static void key_led_activate(struct led_classdev *led)
+{
+	struct key_trigger_notifier *kn;
+	int ret;
+
+	kn = kzalloc(sizeof(struct key_trigger_notifier), GFP_KERNEL);
+	if (!kn) {
+		dev_err(led->dev, "unable to allocatate key trigger\n");
+		return;
+	}
+
+	led->trigger_data = kn;
+
+	kn->led = led;
+	kn->notifier.notifier_call = key_notifier_callback;
+
+	ret = input_register_client(&kn->notifier);
+	if (ret)
+		dev_err(led->dev, "unable to register key trigger\n");
+}
+
+static void key_led_deactivate(struct led_classdev *led)
+{
+	struct key_trigger_notifier *kn = led->trigger_data;
+
+	if (kn) {
+		input_unregister_client(&kn->notifier);
+		kfree(kn);
+	}
+}
+
+static struct led_trigger key_led_trigger = {
+	.name		= "key",
+	.activate	= key_led_activate,
+	.deactivate	= key_led_deactivate,
+};
+
+static int __init key_led_trigger_init(void)
+{
+	return led_trigger_register(&key_led_trigger);
+}
+
+static void __exit key_led_trigger_exit(void)
+{
+	led_trigger_unregister(&key_led_trigger);
+}
+
+module_init(key_led_trigger_init);
+module_exit(key_led_trigger_exit);
+
+MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
+MODULE_DESCRIPTION("Key LED trigger");
+MODULE_LICENSE("GPL");
