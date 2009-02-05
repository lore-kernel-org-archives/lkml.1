Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZBEPKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZBEPKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZBEPKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:10:13 -0500
Received: from mx0.towertech.it ([213.215.222.73]:35294 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750885AbZBEPKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:10:11 -0500
Date: Thu, 5 Feb 2009 16:10:07 +0100
From: Alessandro Zummo <azummo-lists@towertech.it>
Cc: jordan@cosmicpenguin.net, "David Brownell" <david-b@pacbell.net>,
       jordan@cosmicpenguin.net, linux-geode@lists.infradead.org,
       dilinger@queued.net, dsaxena@laptop.org,
       "=?ISO-8859-1?Q?Martin-=C9ric?= Racine" <q-funk@iki.fi>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] AMD Geode CS5535/5536 GPIO driver
Message-ID: <20090205161007.4d121cbf@i1501.lan.towertech.it>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



A GPIO driver for the AMD Geode CS5535/5536 Companion Devices.

In the release 2 I've addressed all the concerns expressed by the
various subsys maintainers involved.

---
 arch/x86/Kconfig           |   10 ++++
 arch/x86/kernel/geode_32.c |   91 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

--- linux-2.6.28.orig/arch/x86/Kconfig	2009-02-03 19:38:43.000000000 +0100
+++ linux-2.6.28/arch/x86/Kconfig	2009-02-03 20:15:25.000000000 +0100
@@ -1911,6 +1911,16 @@ config GEODE_MFGPT_TIMER
 	  MFGPTs have a better resolution and max interval than the
 	  generic PIT, and are suitable for use as high-res timers.
 
+config GEODE_GPIO
+	bool "Geode GPIO support"
+	depends on MGEODE_LX && !CS5535_GPIO
+	default n
+	help
+          Say yes here to provide support for the 28 GPIO pins on
+          the AMD CS5535 and CS5536 Geode Companion Devices.
+
+          If unsure, say N.
+
 config OLPC
 	bool "One Laptop Per Child support"
 	default n
--- linux-2.6.28.orig/arch/x86/kernel/geode_32.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/arch/x86/kernel/geode_32.c	2009-02-03 20:22:32.000000000 +0100
@@ -2,6 +2,7 @@
  * AMD Geode southbridge support code
  * Copyright (C) 2006, Advanced Micro Devices, Inc.
  * Copyright (C) 2007, Andres Salomon <dilinger@debian.org>
+ * Copyright (C) 2009, Tower Technologies
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of version 2 of the GNU General Public License
@@ -12,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
 #include <asm/msr.h>
 #include <asm/geode.h>
 
@@ -183,6 +186,89 @@ int geode_has_vsa2(void)
 }
 EXPORT_SYMBOL_GPL(geode_has_vsa2);
 
+/* GPIO subsystem functions */
+#ifdef CONFIG_GEODE_GPIO
+static void cs5535_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	if (value)
+		geode_gpio_set(geode_gpio(offset), GPIO_OUTPUT_VAL);
+	else
+		geode_gpio_clear(geode_gpio(offset), GPIO_OUTPUT_VAL);
+}
+
+static int cs5535_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	return geode_gpio_isset(geode_gpio(offset), GPIO_READ_BACK);
+}
+
+static int cs5535_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	geode_gpio_clear(geode_gpio(offset), GPIO_OUTPUT_ENABLE);
+	geode_gpio_set(geode_gpio(offset), GPIO_INPUT_ENABLE);
+
+	return 0;
+}
+
+static int cs5535_direction_output(struct gpio_chip *chip, unsigned offset,
+					int value)
+{
+	cs5535_gpio_set(chip, offset, value);
+
+	geode_gpio_set(geode_gpio(offset), GPIO_OUTPUT_ENABLE);
+	geode_gpio_clear(geode_gpio(offset), GPIO_INPUT_ENABLE);
+
+	return 0;
+}
+
+static struct gpio_chip cs5535 = {
+	.owner	= THIS_MODULE,
+	.label	= "cs5535-gpio",
+
+	.base	= 0,
+	.ngpio	= 28,
+
+	.get	= cs5535_gpio_get,
+	.set	= cs5535_gpio_set,
+
+	.direction_input = cs5535_direction_input,
+	.direction_output = cs5535_direction_output,
+};
+
+static int __init cs5535_gpio_probe(struct platform_device *pdev)
+{
+	int rc;
+
+	if (!request_region(geode_gpio_base(), LBAR_GPIO_SIZE, "cs5535-gpio")) {
+		dev_err(&pdev->dev, "cannot allocate I/O region at %x\n",
+				geode_gpio_base());
+		return -ENODEV;
+	}
+
+	rc = gpiochip_add(&cs5535);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "cannot add GPIO\n");
+		goto fail_release;
+	}
+
+	dev_info(&pdev->dev, "registered at 0x%x, GPIO base %d\n",
+			geode_gpio_base(), cs5535.base);
+
+	return 0;
+
+fail_release:
+	release_region(geode_gpio_base(), LBAR_GPIO_SIZE);
+
+	return rc;
+}
+
+static struct platform_driver cs5535_gpio_driver = {
+	.driver	 = {
+		.name   = "cs5535-gpio",
+		.owner  = THIS_MODULE,
+	},
+};
+#endif
+
 static int __init geode_southbridge_init(void)
 {
 	if (!is_geode())
@@ -190,6 +276,11 @@ static int __init geode_southbridge_init
 
 	init_lbars();
 	(void) mfgpt_timer_setup();
+
+#ifdef CONFIG_GEODE_GPIO
+	platform_device_register_simple("cs5535-gpio", 0, NULL, 0);
+	platform_driver_probe(&cs5535_gpio_driver, cs5535_gpio_probe);
+#endif
 	return 0;
 }
 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

