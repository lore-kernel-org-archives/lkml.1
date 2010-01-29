Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583Ab0A2SUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0A2SUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108Ab0A2SUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:20:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47027 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751254Ab0A2SUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:20:39 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] gpiolib: Add WM8994 GPIO support
Date: Fri, 29 Jan 2010 18:20:30 +0000
Message-Id: <1264789230-8398-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264789230-8398-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1264789230-8398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1264789230-8398-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8994 has 11 GPIO lines.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/Kconfig       |    7 ++
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/wm8994-gpio.c |  204 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 212 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/wm8994-gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e1fa0ab..10310dc 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -169,6 +169,13 @@ config GPIO_WM8350
 	  Say yes here to access the GPIO signals of WM8350 power management
 	  chips from Wolfson Microelectronics.
 
+config GPIO_WM8994
+	tristate "WM8994 GPIOs"
+	depends on MFD_WM8994
+	help
+	  Say yes here to access the GPIO signals of WM8994 audio hub
+	  CODECs from Wolfson Microelectronics.
+
 config GPIO_ADP5520
 	tristate "GPIO Support for ADP5520 PMIC"
 	depends on PMIC_ADP5520
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index bf5515d..1140e47 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
 obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
 obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
+obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
diff --git a/drivers/gpio/wm8994-gpio.c b/drivers/gpio/wm8994-gpio.c
new file mode 100644
index 0000000..de28b4a
--- /dev/null
+++ b/drivers/gpio/wm8994-gpio.c
@@ -0,0 +1,204 @@
+/*
+ * wm8994-gpio.c  --  gpiolib support for Wolfson WM8994
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/mfd/core.h>
+#include <linux/platform_device.h>
+#include <linux/seq_file.h>
+
+#include <linux/mfd/wm8994/core.h>
+#include <linux/mfd/wm8994/pdata.h>
+#include <linux/mfd/wm8994/gpio.h>
+#include <linux/mfd/wm8994/registers.h>
+
+struct wm8994_gpio {
+	struct wm8994 *wm8994;
+	struct gpio_chip gpio_chip;
+};
+
+static inline struct wm8994_gpio *to_wm8994_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct wm8994_gpio, gpio_chip);
+}
+
+static int wm8994_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
+	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
+
+	return wm8994_set_bits(wm8994, WM8994_GPIO_1 + offset,
+			       WM8994_GPN_DIR, WM8994_GPN_DIR);
+}
+
+static int wm8994_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
+	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
+	int ret;
+
+	ret = wm8994_reg_read(wm8994, WM8994_GPIO_1 + offset);
+	if (ret < 0)
+		return ret;
+
+	if (ret & WM8994_GPN_LVL)
+		return 1;
+	else
+		return 0;
+}
+
+static int wm8994_gpio_direction_out(struct gpio_chip *chip,
+				     unsigned offset, int value)
+{
+	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
+	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
+
+	return wm8994_set_bits(wm8994, WM8994_GPIO_1 + offset,
+			       WM8994_GPN_DIR, 0);
+}
+
+static void wm8994_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
+	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
+
+	if (value)
+		value = WM8994_GPN_LVL;
+
+	wm8994_set_bits(wm8994, WM8994_GPIO_1 + offset, WM8994_GPN_LVL, value);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void wm8994_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
+	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
+	int i;
+
+	for (i = 0; i < chip->ngpio; i++) {
+		int gpio = i + chip->base;
+		int reg;
+		const char *label;
+
+		/* We report the GPIO even if it's not requested since
+		 * we're also reporting things like alternate
+		 * functions which apply even when the GPIO is not in
+		 * use as a GPIO.
+		 */
+		label = gpiochip_is_requested(chip, i);
+		if (!label)
+			label = "Unrequested";
+
+		seq_printf(s, " gpio-%-3d (%-20.20s) ", gpio, label);
+
+		reg = wm8994_reg_read(wm8994, WM8994_GPIO_1 + i);
+		if (reg < 0) {
+			dev_err(wm8994->dev,
+				"GPIO control %d read failed: %d\n",
+				gpio, reg);
+			seq_printf(s, "\n");
+			continue;
+		}
+
+		/* No decode yet; note that GPIO2 is special */
+		seq_printf(s, "(%x)\n", reg);
+	}
+}
+#else
+#define wm8994_gpio_dbg_show NULL
+#endif
+
+static struct gpio_chip template_chip = {
+	.label			= "wm8994",
+	.owner			= THIS_MODULE,
+	.direction_input	= wm8994_gpio_direction_in,
+	.get			= wm8994_gpio_get,
+	.direction_output	= wm8994_gpio_direction_out,
+	.set			= wm8994_gpio_set,
+	.dbg_show		= wm8994_gpio_dbg_show,
+	.can_sleep		= 1,
+};
+
+static int __devinit wm8994_gpio_probe(struct platform_device *pdev)
+{
+	struct wm8994 *wm8994 = dev_get_drvdata(pdev->dev.parent);
+	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
+	struct wm8994_gpio *wm8994_gpio;
+	int ret;
+
+	wm8994_gpio = kzalloc(sizeof(*wm8994_gpio), GFP_KERNEL);
+	if (wm8994_gpio == NULL)
+		return -ENOMEM;
+
+	wm8994_gpio->wm8994 = wm8994;
+	wm8994_gpio->gpio_chip = template_chip;
+	wm8994_gpio->gpio_chip.ngpio = WM8994_GPIO_MAX;
+	wm8994_gpio->gpio_chip.dev = &pdev->dev;
+	if (pdata && pdata->gpio_base)
+		wm8994_gpio->gpio_chip.base = pdata->gpio_base;
+	else
+		wm8994_gpio->gpio_chip.base = -1;
+
+	ret = gpiochip_add(&wm8994_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
+			ret);
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, wm8994_gpio);
+
+	return ret;
+
+err:
+	kfree(wm8994_gpio);
+	return ret;
+}
+
+static int __devexit wm8994_gpio_remove(struct platform_device *pdev)
+{
+	struct wm8994_gpio *wm8994_gpio = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(&wm8994_gpio->gpio_chip);
+	if (ret == 0)
+		kfree(wm8994_gpio);
+
+	return ret;
+}
+
+static struct platform_driver wm8994_gpio_driver = {
+	.driver.name	= "wm8994-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= wm8994_gpio_probe,
+	.remove		= __devexit_p(wm8994_gpio_remove),
+};
+
+static int __init wm8994_gpio_init(void)
+{
+	return platform_driver_register(&wm8994_gpio_driver);
+}
+subsys_initcall(wm8994_gpio_init);
+
+static void __exit wm8994_gpio_exit(void)
+{
+	platform_driver_unregister(&wm8994_gpio_driver);
+}
+module_exit(wm8994_gpio_exit);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("GPIO interface for WM8994");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8994-gpio");
-- 
1.6.6

