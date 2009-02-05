Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZBEPNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZBEPNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZBEPNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:13:22 -0500
Received: from mx0.towertech.it ([213.215.222.73]:55377 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751423AbZBEPNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:13:21 -0500
Date: Thu, 5 Feb 2009 16:13:19 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rpurdie@rpsys.net, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Soekris net5501 board support code
Message-ID: <20090205161319.32219d93@i1501.lan.towertech.it>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Board support code for the Soekris net5501. 

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>

---
 drivers/platform/x86/Kconfig   |   14 ++++++
 drivers/platform/x86/Makefile  |    1 
 drivers/platform/x86/soekris.c |   92 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.28/drivers/platform/x86/soekris.c	2009-02-03 22:45:16.000000000 +0100
@@ -0,0 +1,92 @@
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
+	if (!is_geode() || geode_has_vsa2())
+		return 0;
+
+	rombase = ioremap(0xffff0000, 0xffff);
+	if (!rombase)
+		return 0;
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
--- linux-2.6.28.orig/drivers/platform/x86/Kconfig	2009-02-03 19:30:25.000000000 +0100
+++ linux-2.6.28/drivers/platform/x86/Kconfig	2009-02-03 22:39:28.000000000 +0100
@@ -395,4 +395,18 @@ config ACPI_TOSHIBA
 
 	  If you have a legacy free Toshiba laptop (such as the Libretto L1
 	  series), say Y.
+
+config SOEKRIS
+	bool "Soekris net5501 support"
+	depends on MGEODE_LX
+	select GPIOLIB
+	select GEODE_GPIO
+	select LEDS_CLASS
+	select LEDS_GPIO
+	select LEDS_TRIGGER_DEFAULT_ON
+	default n
+	help
+	  Add support for the Soekris net5501 board (detection, error led
+	  and GPIO).
+
 endif # X86_PLATFORM_DEVICES
--- linux-2.6.28.orig/drivers/platform/x86/Makefile	2009-02-03 19:30:25.000000000 +0100
+++ linux-2.6.28/drivers/platform/x86/Makefile	2009-02-03 20:26:33.000000000 +0100
@@ -18,3 +18,4 @@ obj-$(CONFIG_INTEL_MENLOW)	+= intel_menl
 obj-$(CONFIG_ACPI_WMI)		+= wmi.o
 obj-$(CONFIG_ACPI_ASUS)		+= asus_acpi.o
 obj-$(CONFIG_ACPI_TOSHIBA)	+= toshiba_acpi.o
+obj-$(CONFIG_SOEKRIS)		+= soekris.o


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

