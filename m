Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYLZB0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYLZB0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 20:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYLZB0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 20:26:08 -0500
Received: from mx0.towertech.it ([213.215.222.73]:36357 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752171AbYLZB0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 20:26:08 -0500
Date: Fri, 26 Dec 2008 02:26:02 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rpurdie@rpsys.net
Subject: [PATCH] Soekris net5501 board support code
Message-ID: <20081226022602.342db591@i1501.lan.towertech.it>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 This patch detects the net5501 board and instantiates the
 correct platform devices (GPIO and leds).

 Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>

---
 arch/x86/Kconfig          |    9 +++
 arch/x86/kernel/Makefile  |    1 
 arch/x86/kernel/soekris.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 138 insertions(+)

--- linux-tuxrouter-2.6.28-isdn.orig/arch/x86/Kconfig	2008-12-25 16:55:23.000000000 +0100
+++ linux-tuxrouter-2.6.28-isdn/arch/x86/Kconfig	2008-12-25 16:55:24.000000000 +0100
@@ -1850,6 +1850,15 @@ config OLPC
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
+config SOEKRIS
+	bool "Soekris net5501 support"
+	depends on MGEODE_LX
+	default n
+	help
+	  Add support for the Soekris net5501 board. You might also want
+	  to enable support for the AMD CS553X GPIOs (CONFIG_GPIO_CS553X)
+	  and leds.
+
 endif # X86_32
 
 config K8_NB
--- linux-tuxrouter-2.6.28-isdn.orig/arch/x86/kernel/Makefile	2008-12-25 16:55:23.000000000 +0100
+++ linux-tuxrouter-2.6.28-isdn/arch/x86/kernel/Makefile	2008-12-25 16:55:24.000000000 +0100
@@ -99,6 +99,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_SOEKRIS)		+= soekris.o
 
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-tuxrouter-2.6.28-isdn/arch/x86/kernel/soekris.c	2008-12-25 16:55:45.000000000 +0100
@@ -0,0 +1,128 @@
+/*
+ * Soekris board support code
+ *
+ * Copyright (c) 2008 Tower Technologies
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
+#if defined(CONFIG_GPIO_CS553X) || defined(CONFIG_GPIO_CS553X_MODULE)
+#ifdef CONFIG_LEDS_CLASS
+static struct gpio_led net5501_leds[] = {
+	{ .name = "error", .gpio = -1 }, /* filled later */
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
+#endif /* CONFIG_LEDS_CLASS */
+
+static int cs553x_gpio_setup(struct platform_device *pdev, unsigned base,
+				unsigned ngpio, void *context)
+{
+#ifdef CONFIG_LEDS_CLASS
+	net5501_leds[0].gpio = base + 6; /* "error" led */
+	return platform_device_register(&net5501_leds_dev);
+#else
+	return 0;
+#endif
+}
+
+static int cs553x_gpio_teardown(struct platform_device *pdev, unsigned base,
+				unsigned ngpio, void *context)
+{
+#ifdef CONFIG_LEDS_CLASS
+	platform_device_unregister(&net5501_leds_dev);
+#endif
+	return 0;
+}
+
+struct cs553x_gpio_platform_data net5501_gpio_data = {
+	.gpio_base	= -1,
+	.io_base	= 0, /* filled later */
+	.setup		= cs553x_gpio_setup,
+	.teardown	= cs553x_gpio_teardown,
+};
+
+static struct platform_device net5501_gpio = {
+	.name = "cs553x-gpio",
+	.id = -1,
+	.dev.platform_data = &net5501_gpio_data,
+};
+#endif /* CONFIG_GPIO_CS553X */
+
+static void __init init_net5501(void)
+{
+#if defined(CONFIG_GPIO_CS553X) || defined(CONFIG_GPIO_CS553X_MODULE)
+	net5501_gpio_data.io_base = geode_gpio_base();
+	platform_device_register(&net5501_gpio);
+#endif
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


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

