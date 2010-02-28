Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476Ab0B1RBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 12:01:19 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:55099 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964812Ab0B1RBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 12:01:17 -0500
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Subject: [PATCH] LED driver for the Soekris net5501 board.
Date: Sun, 28 Feb 2010 17:01:13 +0000
Message-Id: <1267376473-9204-1-git-send-email-gurligebis@gentoo.org>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED driver for the Soekris net5501 board.
It is based on the previously submitted code by Alessandro Zummo, but is changed to use the new GPIO driver with 2.6.33, and the driver has been moved to drivers/leds where it belongs.

Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
---
 drivers/leds/Kconfig        |    9 ++++
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-net5501.c |   95 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-net5501.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 8a0e1ec..fa12ab5 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -58,6 +58,15 @@ config LEDS_NET48XX
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
+config LEDS_NET5501
+	tristate "LED Support for Soekris net5501 series Error LED"
+	depends on LEDS_CLASS && LEDS_GPIO_PLATFORM && GPIO_CS5535
+	select LEDS_TRIGGER_DEFAULT_ON
+	default n
+	help
+	  Add support for the Soekris net5501 board (detection, error led
+	  and GPIO).
+
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
 	depends on LEDS_CLASS && MACH_FSG
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 9e63869..123609a 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
+obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_ALIX2)		+= leds-alix2.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
diff --git a/drivers/leds/leds-net5501.c b/drivers/leds/leds-net5501.c
new file mode 100644
index 0000000..90f82bf
--- /dev/null
+++ b/drivers/leds/leds-net5501.c
@@ -0,0 +1,95 @@
+/*
+ * Soekris board support code
+ *
+ * Copyright (C) 2008-2009 Tower Technologies
+ * Written by Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/string.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+
+#include <asm/geode.h>
+
+static struct gpio_led net5501_leds[] = {
+	{
+		.name = "error",
+		.gpio = 6,
+		.default_trigger = "default-on",
+	},
+};
+
+static struct gpio_led_platform_data net5501_leds_data = {
+	.num_leds = ARRAY_SIZE(net5501_leds),
+	.leds = net5501_leds,
+};
+
+static struct platform_device net5501_leds_dev = {
+	.name = "leds-gpio",
+	.id = -1,
+	.dev.platform_data = &net5501_leds_data,
+};
+
+static void __init init_net5501(void)
+{
+	platform_device_register(&net5501_leds_dev);
+}
+
+struct soekris_board {
+	u16	offset;
+	char	*sig;
+	u8	len;
+	void	(*init)(void);
+};
+
+static struct soekris_board __initdata boards[] = {
+	{ 0xb7b, "net5501", 7, init_net5501 },	/* net5501 v1.33/1.33c */
+	{ 0xb1f, "net5501", 7, init_net5501 },	/* net5501 v1.32i */
+};
+
+static int __init soekris_init(void)
+{
+	int i;
+	unsigned char *rombase, *bios;
+
+	if (!is_geode())
+		return 0;
+
+	rombase = ioremap(0xffff0000, 0xffff);
+	if (!rombase)
+	{
+		printk(KERN_INFO "Soekris net5501 LED driver failed to get rombase");
+		return 0;
+	}
+
+	bios = rombase + 0x20;	/* null terminated */
+
+	if (strncmp(bios, "comBIOS", 7))
+		goto unmap;
+
+	for (i = 0; i < ARRAY_SIZE(boards); i++) {
+		unsigned char *model = rombase + boards[i].offset;
+
+		if (strncmp(model, boards[i].sig, boards[i].len) == 0) {
+			printk(KERN_INFO "Soekris %s: %s\n", model, bios);
+
+			if (boards[i].init)
+				boards[i].init();
+			break;
+		}
+	}
+
+unmap:
+	iounmap(rombase);
+	return 0;
+}
+
+arch_initcall(soekris_init);
-- 
1.7.0

