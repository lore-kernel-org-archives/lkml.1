Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYKDSnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYKDSnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYKDSno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:43:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:28057 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYKDSnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:43:43 -0500
Message-ID: <491097D7.4030800@mimas.ru>
Date: Tue, 04 Nov 2008 22:43:35 +0400
From: Constantin Baranov <const@mimas.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080930 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2.6.28-rc3] led: ALIX.2 LEDs driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for PC Engines ALIX.2 and ALIX.3 LEDs.

Signed-off-by: Constantin Baranov <const@mimas.ru>
---
Changes from previous version:
 - rename from LEDS_ALIX to LEDS_ALIX2, because driver may not work
   with possible future ALIX boards
 - scan BIOS area (000f0000:000fffff) to ensure that current system
   is ALIX.2/3
 - add module parameter 'force' to allow registering LEDs without
   BIOS test (e.g. if stock BIOS was upgraded)

 drivers/leds/Kconfig      |    6 +
 drivers/leds/Makefile     |    1 
 drivers/leds/leds-alix2.c |  209 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 216 insertions(+)

diff -uprN linux-2.6.28-rc3/drivers/leds/Kconfig linux-2.6.28-rc3-alix/drivers/leds/Kconfig
--- linux-2.6.28-rc3/drivers/leds/Kconfig	2008-11-04 22:14:17.010898407 +0400
+++ linux-2.6.28-rc3-alix/drivers/leds/Kconfig	2008-11-04 22:25:15.560889534 +0400
@@ -63,6 +63,12 @@ config LEDS_WRAP
 	help
 	  This option enables support for the PCEngines WRAP programmable LEDs.
 
+config LEDS_ALIX2
+	tristate "LED Support for ALIX.2 and ALIX.3 series"
+	depends on LEDS_CLASS && X86 && EXPERIMENTAL
+	help
+	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
+
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
 	depends on LEDS_CLASS && ARCH_H1940
diff -uprN linux-2.6.28-rc3/drivers/leds/leds-alix2.c linux-2.6.28-rc3-alix/drivers/leds/leds-alix2.c
--- linux-2.6.28-rc3/drivers/leds/leds-alix2.c	1970-01-01 04:00:00.000000000 +0400
+++ linux-2.6.28-rc3-alix/drivers/leds/leds-alix2.c	2008-11-04 22:25:15.560889534 +0400
@@ -0,0 +1,209 @@
+/*
+ * LEDs driver for PCEngines ALIX.2 and ALIX.3
+ *
+ * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
+ */
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/string.h>
+
+static int force = 0;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Assume system has ALIX.2 style LEDs");
+
+struct alix_led {
+	struct led_classdev cdev;
+	unsigned short port;
+	unsigned int on_value;
+	unsigned int off_value;
+};
+
+static void alix_led_set(struct led_classdev *led_cdev,
+			 enum led_brightness brightness)
+{
+	struct alix_led *led_dev =
+		container_of(led_cdev, struct alix_led, cdev);
+
+	if (brightness)
+		outl(led_dev->on_value, led_dev->port);
+	else
+		outl(led_dev->off_value, led_dev->port);
+}
+
+static struct alix_led alix_leds[] = {
+	{
+		.cdev = {
+			.name = "alix:1",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6100,
+		.on_value = 1 << 22,
+		.off_value = 1 << 6,
+	},
+	{
+		.cdev = {
+			.name = "alix:2",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6180,
+		.on_value = 1 << 25,
+		.off_value = 1 << 9,
+	},
+	{
+		.cdev = {
+			.name = "alix:3",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6180,
+		.on_value = 1 << 27,
+		.off_value = 1 << 11,
+	},
+};
+
+#ifdef CONFIG_PM
+
+static int alix_led_suspend(struct platform_device *dev, pm_message_t state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_suspend(&alix_leds[i].cdev);
+	return 0;
+}
+
+static int alix_led_resume(struct platform_device *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_resume(&alix_leds[i].cdev);
+	return 0;
+}
+
+#else
+
+#define alix_led_suspend NULL
+#define alix_led_resume NULL
+
+#endif
+
+static int __init alix_led_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
+		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
+		if (ret < 0)
+			goto fail;
+	}
+	return 0;
+
+fail:
+	while (--i >= 0)
+		led_classdev_unregister(&alix_leds[i].cdev);
+	return ret;
+}
+
+static int alix_led_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_unregister(&alix_leds[i].cdev);
+	return 0;
+}
+
+static struct platform_driver alix_led_driver = {
+	.remove = alix_led_remove,
+	.suspend = alix_led_suspend,
+	.resume = alix_led_resume,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init alix_present(void)
+{
+	const unsigned long bios_phys = 0x000f0000;
+	const size_t bios_len = 0x00010000;
+	const char alix_sig[] = "PC Engines ALIX.";
+	const size_t alix_sig_len = sizeof(alix_sig) - 1;
+
+	const char *bios_virt;
+	const char *scan_end;
+	const char *p;
+	int ret = 0;
+
+	if (force) {
+		printk(KERN_NOTICE "%s: forced to skip BIOS test, "
+		       "assume system has ALIX.2 style LEDs\n",
+		       KBUILD_MODNAME);
+		ret = 1;
+		goto out;
+	}
+
+	bios_virt = phys_to_virt(bios_phys);
+	scan_end = bios_virt + bios_len - (alix_sig_len + 2);
+	for (p = bios_virt; p < scan_end; p++) {
+		const char *tail;
+
+		if (memcmp(p, alix_sig, alix_sig_len) != 0) {
+			continue;
+		}
+
+		tail = p + alix_sig_len;
+		if ((tail[0] == '2' || tail[0] == '3') && tail[1] == '\0') {
+			printk(KERN_INFO
+			       "%s: system is recognized as \"%s\"\n",
+			       KBUILD_MODNAME, p);
+			ret = 1;
+			break;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static struct platform_device *pdev;
+
+static int __init alix_led_init(void)
+{
+	int ret;
+
+	if (!alix_present()) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
+	if (!IS_ERR(pdev)) {
+		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
+		if (ret)
+			platform_device_unregister(pdev);
+	} else
+		ret = PTR_ERR(pdev);
+
+out:
+	return ret;
+}
+
+static void __exit alix_led_exit(void)
+{
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&alix_led_driver);
+}
+
+module_init(alix_led_init);
+module_exit(alix_led_exit);
+
+MODULE_AUTHOR("Constantin Baranov <const@mimas.ru>");
+MODULE_DESCRIPTION("PCEngines ALIX.2 and ALIX.3 LED driver");
+MODULE_LICENSE("GPL");
diff -uprN linux-2.6.28-rc3/drivers/leds/Makefile linux-2.6.28-rc3-alix/drivers/leds/Makefile
--- linux-2.6.28-rc3/drivers/leds/Makefile	2008-11-04 22:14:17.010898407 +0400
+++ linux-2.6.28-rc3-alix/drivers/leds/Makefile	2008-11-04 22:25:15.560889534 +0400
@@ -11,6 +11,7 @@ obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c2
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
+obj-$(CONFIG_LEDS_ALIX2)		+= leds-alix2.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o

