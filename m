Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYJGKLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYJGKLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYJGKKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:10:38 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:56195 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYJGKKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:10:37 -0400
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Rodolfo Giometti <giometti@linux.it>
Date: Tue,  7 Oct 2008 12:10:30 +0200
Message-Id: <1223374230-18413-2-git-send-email-giometti@enneenne.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223374230-18413-1-git-send-email-giometti@enneenne.com>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 1/1] led: add a backlight emulation trigger.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodolfo Giometti <giometti@linux.it>

This allows LEDs to be controlled as a backlight device: they turn off
and on when the display is blanked and unblanked.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/leds/Kconfig             |    9 +++
 drivers/leds/Makefile            |    1 +
 drivers/leds/ledtrig-backlight.c |  110 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-backlight.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9556262..7f2294c 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -199,6 +199,15 @@ config LEDS_TRIGGER_HEARTBEAT
 	  load average.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_BACKLIGHT
+	tristate "LED backlight Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to be controlled as a backlight device: they
+	  turn off and on when the display is blanked and unblanked.
+
+	  If unsure, say N.
+
 config LEDS_TRIGGER_DEFAULT_ON
 	tristate "LED Default ON Trigger"
 	depends on LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index ff7982b..78d07ba 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -28,4 +28,5 @@ obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
+obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
diff --git a/drivers/leds/ledtrig-backlight.c b/drivers/leds/ledtrig-backlight.c
new file mode 100644
index 0000000..d3dfcfb
--- /dev/null
+++ b/drivers/leds/ledtrig-backlight.c
@@ -0,0 +1,110 @@
+/*
+ * Backlight emulation LED trigger
+ *
+ * Copyright 2008 (C) Rodolfo Giometti <giometti@linux.it>
+ * Copyright 2008 (C) Eurotech S.p.A. <info@eurotech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/fb.h>
+#include <linux/leds.h>
+#include "leds.h"
+
+#define BLANK		1
+#define UNBLANK		0
+
+struct bl_trig_notifier {
+	struct led_classdev *led;
+	int brightness;
+	int old_status;
+	struct notifier_block notifier;
+};
+
+static int fb_notifier_callback(struct notifier_block *p,
+				unsigned long event, void *data)
+{
+	struct bl_trig_notifier *n = container_of(p,
+					struct bl_trig_notifier, notifier);
+	struct led_classdev *led = n->led;
+	struct fb_event *fb_event = data;
+	int *blank = fb_event->data;
+
+	switch (event) {
+	case FB_EVENT_BLANK :
+		if (*blank && n->old_status == UNBLANK) {
+			n->brightness = led->brightness;
+			led_set_brightness(led, LED_OFF);
+			n->old_status = BLANK;
+		} else if (!*blank && n->old_status == BLANK) {
+			led_set_brightness(led, n->brightness);
+			n->old_status = UNBLANK;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+static void bl_trig_activate(struct led_classdev *led)
+{
+	int ret;
+
+	struct bl_trig_notifier *n;
+
+	n = kzalloc(sizeof(struct bl_trig_notifier), GFP_KERNEL);
+	led->trigger_data = n;
+	if (!n) {
+		dev_err(led->dev, "unable to allocate backlight trigger\n");
+		return;
+	}
+
+	n->led = led;
+	n->brightness = led->brightness;
+	n->old_status = UNBLANK;
+	n->notifier.notifier_call = fb_notifier_callback;
+
+	ret = fb_register_client(&n->notifier);
+	if (ret)
+		dev_err(led->dev, "unable to register backlight trigger\n");
+}
+
+static void bl_trig_deactivate(struct led_classdev *led)
+{
+	struct bl_trig_notifier *n =
+		(struct bl_trig_notifier *) led->trigger_data;
+
+	if (n) {
+		fb_unregister_client(&n->notifier);
+		kfree(n);
+	}
+}
+
+static struct led_trigger bl_led_trigger = {
+	.name		= "backlight",
+	.activate	= bl_trig_activate,
+	.deactivate	= bl_trig_deactivate
+};
+
+static int __init bl_trig_init(void)
+{
+	return led_trigger_register(&bl_led_trigger);
+}
+
+static void __exit bl_trig_exit(void)
+{
+	led_trigger_unregister(&bl_led_trigger);
+}
+
+module_init(bl_trig_init);
+module_exit(bl_trig_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("Backlight emulation LED trigger");
+MODULE_LICENSE("GPL v2");
-- 
1.5.4.3

