Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbYLXWnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbYLXWnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 17:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYLXWn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 17:43:29 -0500
Received: from mx0.towertech.it ([213.215.222.73]:46320 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751222AbYLXWn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 17:43:28 -0500
Date: Wed, 24 Dec 2008 23:43:21 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-geode@lists.infradead.org
Subject: [PATCH] AMD Geode CS553X GPIO driver
Message-ID: <20081224234321.0890274e@i1501.lan.towertech.it>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 A GPIO driver for the AMD Geode CS5535/5536 Companion Devices.

 It uses the gpio framework and the gpio api as defined in
 arch/x86/kernel/geode_32.c

 Patch is against 2.6.28-rc9.

 Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>


---
 arch/x86/include/asm/geode.h |   18 ++++
 drivers/gpio/Kconfig         |   14 +++
 drivers/gpio/Makefile        |    1 
 drivers/gpio/cs553x-gpio.c   |  172 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 205 insertions(+)

--- linux-tuxrouter-2.6.28-rc9.orig/drivers/gpio/Kconfig	2008-12-24 23:34:02.000000000 +0100
+++ linux-tuxrouter-2.6.28-rc9/drivers/gpio/Kconfig	2008-12-24 23:34:44.000000000 +0100
@@ -175,4 +175,18 @@ config GPIO_MCP23S08
 	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
 	  a GPIO interface supporting inputs and outputs.
 
+comment "Other GPIO expanders:"
+
+config GPIO_CS553X
+	tristate "AMD CS5535/CS5536 Geode Companion Devices"
+	depends on MGEODE_LX && !CS5535_GPIO
+	help
+	  Say yes here to provide support for the 28 GPIO pins on
+	  the AMD CS5535 and CS5536 Geode Companion Devices.
+
+	  Your board setup code will have to declare an appropriate
+	  platform device for this driver to work.
+
+	  If unsure, say N.
+
 endif
--- linux-tuxrouter-2.6.28-rc9.orig/drivers/gpio/Makefile	2008-12-24 23:34:02.000000000 +0100
+++ linux-tuxrouter-2.6.28-rc9/drivers/gpio/Makefile	2008-12-24 23:34:44.000000000 +0100
@@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
+obj-$(CONFIG_GPIO_CS553X)	+= cs553x-gpio.o
 obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
--- linux-tuxrouter-2.6.28-rc9.orig/arch/x86/include/asm/geode.h	2008-12-24 23:34:02.000000000 +0100
+++ linux-tuxrouter-2.6.28-rc9/arch/x86/include/asm/geode.h	2008-12-24 23:34:44.000000000 +0100
@@ -12,6 +12,7 @@
 
 #include <asm/processor.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 
 /* Generic southbridge functions */
 
@@ -165,6 +166,23 @@ static inline void geode_gpio_event_pme(
 	geode_gpio_setup_event(gpio, pair, 1);
 }
 
+struct cs553x_gpio_platform_data {
+
+	unsigned	gpio_base; /* number of the first GPIO */
+
+	resource_size_t	io_base;
+
+	void		*context; /* param to setup/teardown */
+
+	int		(*setup)(struct platform_device *pdev,
+				unsigned base, unsigned ngpio,
+				void *context);
+
+	int		(*teardown)(struct platform_device *pdev,
+				unsigned base, unsigned ngpio,
+				void *context);
+};
+
 /* Specific geode tests */
 
 static inline int is_geode_gx(void)
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-tuxrouter-2.6.28-rc9/drivers/gpio/cs553x-gpio.c	2008-12-24 23:35:41.000000000 +0100
@@ -0,0 +1,172 @@
+/*
+ * AMD CS5535/CS5536 Geode Companion Devices GPIO driver
+ *
+ * Copyright (C) 2008 Tower Technologies
+ * Written by Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+
+#include <asm/geode.h>
+
+#define DRIVER_NAME "cs553x-gpio"
+#define DRIVER_VERSION "1.0"
+
+static void cs553x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	if (value)
+		geode_gpio_set(geode_gpio(offset), GPIO_OUTPUT_VAL);
+	else
+		geode_gpio_clear(geode_gpio(offset), GPIO_OUTPUT_VAL);
+}
+
+static int cs553x_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	return geode_gpio_isset(geode_gpio(offset), GPIO_READ_BACK);
+}
+
+static int cs553x_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	geode_gpio_clear(geode_gpio(offset), GPIO_OUTPUT_ENABLE);
+	geode_gpio_set(geode_gpio(offset), GPIO_INPUT_ENABLE);
+
+	return 0;
+}
+
+static int cs553x_direction_output(struct gpio_chip *chip, unsigned offset,
+					int value)
+{
+	cs553x_gpio_set(chip, offset, value);
+
+	geode_gpio_set(geode_gpio(offset), GPIO_OUTPUT_ENABLE);
+	geode_gpio_clear(geode_gpio(offset), GPIO_INPUT_ENABLE);
+
+	return 0;
+}
+
+static struct gpio_chip cs553x = {
+	.owner	= THIS_MODULE,
+	.label	= DRIVER_NAME,
+	.ngpio	= 28,
+
+	.get	= cs553x_gpio_get,
+	.set	= cs553x_gpio_set,
+
+	.direction_input = cs553x_direction_input,
+	.direction_output = cs553x_direction_output,
+};
+
+
+static int __init cs553x_gpio_probe(struct platform_device *pdev)
+{
+	int rc;
+	struct cs553x_gpio_platform_data *pdata = pdev->dev.platform_data;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing CS553X platform data\n");
+		return -ENODEV;
+	}
+
+	if (!pdata->io_base) {
+		dev_err(&pdev->dev, "platform data has no GPIO base region\n");
+		return -ENODEV;
+	}
+
+	if (!request_region(pdata->io_base, LBAR_GPIO_SIZE, DRIVER_NAME)) {
+		dev_err(&pdev->dev, "cannot allocate I/O region at %x\n",
+				pdata->io_base);
+		return -ENODEV;
+	}
+
+	cs553x.dev = &pdev->dev;
+	cs553x.base = pdata->gpio_base;
+
+	rc = gpiochip_add(&cs553x);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "cannot add GPIO\n");
+		goto fail_release;
+	}
+
+	dev_info(&pdev->dev, "registered at 0x%x, GPIO base %d\n",
+			pdata->io_base, cs553x.base);
+
+	if (pdata->setup) {
+		rc = pdata->setup(pdev, cs553x.base,
+				cs553x.ngpio, pdata->context);
+
+		if (rc < 0) {
+			dev_err(&pdev->dev, "setup failed, %d\n", rc);
+			goto fail_remove;
+		}
+	}
+
+	return 0;
+
+fail_remove:
+	gpiochip_remove(&cs553x);
+
+fail_release:
+	release_region(pdata->io_base, LBAR_GPIO_SIZE);
+
+	return rc;
+}
+
+static int __exit cs553x_gpio_remove(struct platform_device *pdev)
+{
+	struct cs553x_gpio_platform_data *pdata = pdev->dev.platform_data;
+
+	if (pdata->teardown) {
+		int rc = pdata->teardown(pdev, cs553x.base,
+				cs553x.ngpio, pdata->context);
+		if (rc < 0) {
+			dev_err(&pdev->dev, "teardown failed, %d\n", rc);
+			return rc;
+		}
+	}
+
+	gpiochip_remove(&cs553x);
+	release_region(pdata->io_base, LBAR_GPIO_SIZE);
+
+	return 0;
+}
+
+static struct platform_driver cs553x_gpio_driver = {
+	.driver	 = {
+		.name   = DRIVER_NAME,
+		.owner  = THIS_MODULE,
+	},
+	.remove	 = __exit_p(cs553x_gpio_remove),
+};
+
+static int __init cs553x_gpio_init(void)
+{
+	if (!is_geode())
+		return -ENODEV;
+
+	return platform_driver_probe(&cs553x_gpio_driver, cs553x_gpio_probe);
+}
+
+static void __exit cs553x_gpio_exit(void)
+{
+	platform_driver_unregister(&cs553x_gpio_driver);
+}
+
+module_init(cs553x_gpio_init);
+module_exit(cs553x_gpio_exit);
+
+
+MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
+MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_ALIAS("platform:cs553x-gpio");

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

