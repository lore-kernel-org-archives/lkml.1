Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224Ab0AGQKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0AGQKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021Ab0AGQKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:10:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46459 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753206Ab0AGQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:10:13 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Add support for WM8350 GPIO controller
Date: Thu,  7 Jan 2010 16:10:08 +0000
Message-Id: <1262880608-19890-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/Kconfig            |    7 ++
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/wm8350-gpiolib.c   |  181 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8350/core.h |    2 +
 include/linux/mfd/wm8350/gpio.h |    1 +
 5 files changed, 192 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/wm8350-gpiolib.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index a019b49..e353fa1 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -162,6 +162,13 @@ config GPIO_WM831X
 	  Say yes here to access the GPIO signals of WM831x power management
 	  chips from Wolfson Microelectronics.
 
+config GPIO_WM8350
+	tristate "WM8350 GPIOs"
+	depends on MFD_WM8350
+	help
+	  Say yes here to access the GPIO signals of WM8350 power management
+	  chips from Wolfson Microelectronics.
+
 config GPIO_ADP5520
 	tristate "GPIO Support for ADP5520 PMIC"
 	depends on PMIC_ADP5520
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 52fe4cf..970a271 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_GPIO_CS5535)	+= cs5535-gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
 obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
+obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
diff --git a/drivers/gpio/wm8350-gpiolib.c b/drivers/gpio/wm8350-gpiolib.c
new file mode 100644
index 0000000..511840d
--- /dev/null
+++ b/drivers/gpio/wm8350-gpiolib.c
@@ -0,0 +1,181 @@
+/*
+ * wm835x-gpiolib.c  --  gpiolib support for Wolfson WM835x PMICs
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
+#include <linux/mfd/wm8350/core.h>
+#include <linux/mfd/wm8350/gpio.h>
+
+struct wm8350_gpio_data {
+	struct wm8350 *wm8350;
+	struct gpio_chip gpio_chip;
+};
+
+static inline struct wm8350_gpio_data *to_wm8350_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct wm8350_gpio_data, gpio_chip);
+}
+
+static int wm8350_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct wm8350_gpio_data *wm8350_gpio = to_wm8350_gpio(chip);
+	struct wm8350 *wm8350 = wm8350_gpio->wm8350;
+
+	return wm8350_set_bits(wm8350, WM8350_GPIO_CONFIGURATION_I_O,
+			       1 << offset);
+}
+
+static int wm8350_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct wm8350_gpio_data *wm8350_gpio = to_wm8350_gpio(chip);
+	struct wm8350 *wm8350 = wm8350_gpio->wm8350;
+	int ret;
+
+	ret = wm8350_reg_read(wm8350, WM8350_GPIO_LEVEL);
+	if (ret < 0)
+		return ret;
+
+	if (ret & (1 << offset))
+		return 1;
+	else
+		return 0;
+}
+
+static void wm8350_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct wm8350_gpio_data *wm8350_gpio = to_wm8350_gpio(chip);
+	struct wm8350 *wm8350 = wm8350_gpio->wm8350;
+
+	if (value)
+		wm8350_set_bits(wm8350, WM8350_GPIO_LEVEL, 1 << offset);
+	else
+		wm8350_clear_bits(wm8350, WM8350_GPIO_LEVEL, 1 << offset);
+}
+
+static int wm8350_gpio_direction_out(struct gpio_chip *chip,
+				     unsigned offset, int value)
+{
+	struct wm8350_gpio_data *wm8350_gpio = to_wm8350_gpio(chip);
+	struct wm8350 *wm8350 = wm8350_gpio->wm8350;
+	int ret;
+
+	ret = wm8350_clear_bits(wm8350, WM8350_GPIO_CONFIGURATION_I_O,
+				1 << offset);
+	if (ret < 0)
+		return ret;
+
+	/* Don't have an atomic direction/value setup */
+	wm8350_gpio_set(chip, offset, value);
+
+	return 0;
+}
+
+static int wm8350_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct wm8350_gpio_data *wm8350_gpio = to_wm8350_gpio(chip);
+	struct wm8350 *wm8350 = wm8350_gpio->wm8350;
+
+	if (!wm8350->irq_base)
+		return -EINVAL;
+
+	return wm8350->irq_base + WM8350_IRQ_GPIO(offset);
+}
+
+static struct gpio_chip template_chip = {
+	.label			= "wm8350",
+	.owner			= THIS_MODULE,
+	.direction_input	= wm8350_gpio_direction_in,
+	.get			= wm8350_gpio_get,
+	.direction_output	= wm8350_gpio_direction_out,
+	.set			= wm8350_gpio_set,
+	.to_irq			= wm8350_gpio_to_irq,
+	.can_sleep		= 1,
+};
+
+static int __devinit wm8350_gpio_probe(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(pdev->dev.parent);
+	struct wm8350_platform_data *pdata = wm8350->dev->platform_data;
+	struct wm8350_gpio_data *wm8350_gpio;
+	int ret;
+
+	wm8350_gpio = kzalloc(sizeof(*wm8350_gpio), GFP_KERNEL);
+	if (wm8350_gpio == NULL)
+		return -ENOMEM;
+
+	wm8350_gpio->wm8350 = wm8350;
+	wm8350_gpio->gpio_chip = template_chip;
+	wm8350_gpio->gpio_chip.ngpio = 13;
+	wm8350_gpio->gpio_chip.dev = &pdev->dev;
+	if (pdata && pdata->gpio_base)
+		wm8350_gpio->gpio_chip.base = pdata->gpio_base;
+	else
+		wm8350_gpio->gpio_chip.base = -1;
+
+	ret = gpiochip_add(&wm8350_gpio->gpio_chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
+			ret);
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, wm8350_gpio);
+
+	return ret;
+
+err:
+	kfree(wm8350_gpio);
+	return ret;
+}
+
+static int __devexit wm8350_gpio_remove(struct platform_device *pdev)
+{
+	struct wm8350_gpio_data *wm8350_gpio = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(&wm8350_gpio->gpio_chip);
+	if (ret == 0)
+		kfree(wm8350_gpio);
+
+	return ret;
+}
+
+static struct platform_driver wm8350_gpio_driver = {
+	.driver.name	= "wm8350-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= wm8350_gpio_probe,
+	.remove		= __devexit_p(wm8350_gpio_remove),
+};
+
+static int __init wm8350_gpio_init(void)
+{
+	return platform_driver_register(&wm8350_gpio_driver);
+}
+subsys_initcall(wm8350_gpio_init);
+
+static void __exit wm8350_gpio_exit(void)
+{
+	platform_driver_unregister(&wm8350_gpio_driver);
+}
+module_exit(wm8350_gpio_exit);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("GPIO interface for WM8350 PMICs");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8350-gpio");
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 04217a7..fae08aa 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -645,11 +645,13 @@ struct wm8350 {
  *        used by the platform to configure GPIO functions and similar.
  * @irq_high: Set if WM8350 IRQ is active high.
  * @irq_base: Base IRQ for genirq (not currently used).
+ * @gpio_base: Base for gpiolib.
  */
 struct wm8350_platform_data {
 	int (*init)(struct wm8350 *wm8350);
 	int irq_high;
 	int irq_base;
+	int gpio_base;
 };
 
 
diff --git a/include/linux/mfd/wm8350/gpio.h b/include/linux/mfd/wm8350/gpio.h
index 71af3d6..d657bcd 100644
--- a/include/linux/mfd/wm8350/gpio.h
+++ b/include/linux/mfd/wm8350/gpio.h
@@ -29,6 +29,7 @@
 #define WM8350_GPIO_FUNCTION_SELECT_2           0x8D
 #define WM8350_GPIO_FUNCTION_SELECT_3           0x8E
 #define WM8350_GPIO_FUNCTION_SELECT_4           0x8F
+#define WM8350_GPIO_LEVEL			0xE6
 
 /*
  * GPIO Functions
-- 
1.6.6

