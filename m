Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbZIQVtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbZIQVtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZIQVtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:49:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49159 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbZIQVtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:49:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] GPIO: GPIO Support for ADP5520/ADP5501 MFD PMICs
Date: Thu, 17 Sep 2009 17:49:11 -0400
Message-Id: <1253224151-6820-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/gpio/Kconfig        |   10 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/adp5520-gpio.c |  206 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/adp5520-gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 96dda81..2b3548b 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -155,6 +155,16 @@ config GPIO_TWL4030
 	  Say yes here to access the GPIO signals of various multi-function
 	  power management chips from Texas Instruments.
 
+config GPIO_ADP5520
+	tristate "GPIO Support for ADP5520 PMIC"
+	depends on PMIC_ADP5520
+	help
+	  This option enables support for on-chip GPIO found
+	  on Analog Devices ADP5520 PMICs.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called adp5520-gpio.
+
 comment "PCI GPIO expanders:"
 
 config GPIO_BT8XX
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 9244c6f..c2acf2f 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
+obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
diff --git a/drivers/gpio/adp5520-gpio.c b/drivers/gpio/adp5520-gpio.c
new file mode 100644
index 0000000..ad05bbc
--- /dev/null
+++ b/drivers/gpio/adp5520-gpio.c
@@ -0,0 +1,206 @@
+/*
+ * GPIO driver for Analog Devices ADP5520 MFD PMICs
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/adp5520.h>
+
+#include <linux/gpio.h>
+
+struct adp5520_gpio {
+	struct device *master;
+	struct gpio_chip gpio_chip;
+	unsigned char lut[ADP5520_MAXGPIOS];
+	unsigned long output;
+};
+
+static int adp5520_gpio_get_value(struct gpio_chip *chip, unsigned off)
+{
+	struct adp5520_gpio *dev;
+	uint8_t reg_val;
+
+	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
+
+	/*
+	 * There are dedicated registers for GPIO IN/OUT.
+	 * Make sure we return the right value, even when configured as output
+	 */
+
+	if (test_bit(off, &dev->output))
+		adp5520_read(dev->master, GPIO_OUT, &reg_val);
+	else
+		adp5520_read(dev->master, GPIO_IN, &reg_val);
+
+	return !!(reg_val & dev->lut[off]);
+}
+
+static void adp5520_gpio_set_value(struct gpio_chip *chip,
+		unsigned off, int val)
+{
+	struct adp5520_gpio *dev;
+	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
+
+	if (val)
+		adp5520_set_bits(dev->master, GPIO_OUT, dev->lut[off]);
+	else
+		adp5520_clr_bits(dev->master, GPIO_OUT, dev->lut[off]);
+}
+
+static int adp5520_gpio_direction_input(struct gpio_chip *chip, unsigned off)
+{
+	struct adp5520_gpio *dev;
+	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
+
+	clear_bit(off, &dev->output);
+
+	return adp5520_clr_bits(dev->master, GPIO_CFG_2, dev->lut[off]);
+}
+
+static int adp5520_gpio_direction_output(struct gpio_chip *chip,
+		unsigned off, int val)
+{
+	struct adp5520_gpio *dev;
+	int ret = 0;
+	dev = container_of(chip, struct adp5520_gpio, gpio_chip);
+
+	set_bit(off, &dev->output);
+
+	if (val)
+		ret |= adp5520_set_bits(dev->master, GPIO_OUT, dev->lut[off]);
+	else
+		ret |= adp5520_clr_bits(dev->master, GPIO_OUT, dev->lut[off]);
+
+	ret |= adp5520_set_bits(dev->master, GPIO_CFG_2, dev->lut[off]);
+
+	return ret;
+}
+
+static int __devinit adp5520_gpio_probe(struct platform_device *pdev)
+{
+	struct adp5520_gpio_platfrom_data *pdata = pdev->dev.platform_data;
+	struct adp5520_gpio *dev;
+	struct gpio_chip *gc;
+	int ret, i, gpios;
+	unsigned char ctl_mask = 0;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -ENODEV;
+	}
+
+	if (pdev->id != ID_ADP5520) {
+		dev_err(&pdev->dev, "only ADP5520 supports GPIO\n");
+		return -ENODEV;
+	}
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		dev_err(&pdev->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	dev->master = pdev->dev.parent;
+
+	for (gpios = 0, i = 0; i < ADP5520_MAXGPIOS; i++)
+		if (pdata->gpio_en_mask & (1 << i))
+			dev->lut[gpios++] = 1 << i;
+
+	if (gpios < 1) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	gc = &dev->gpio_chip;
+	gc->direction_input  = adp5520_gpio_direction_input;
+	gc->direction_output = adp5520_gpio_direction_output;
+	gc->get = adp5520_gpio_get_value;
+	gc->set = adp5520_gpio_set_value;
+	gc->can_sleep = 1;
+
+	gc->base = pdata->gpio_start;
+	gc->ngpio = gpios;
+	gc->label = pdev->name;
+	gc->owner = THIS_MODULE;
+
+	ret = adp5520_clr_bits(dev->master, GPIO_CFG_1,
+		pdata->gpio_en_mask);
+
+	if (pdata->gpio_en_mask & GPIO_C3)
+		ctl_mask |= C3_MODE;
+
+	if (pdata->gpio_en_mask & GPIO_R3)
+		ctl_mask |= R3_MODE;
+
+	if (ctl_mask)
+		ret = adp5520_set_bits(dev->master, LED_CONTROL,
+			ctl_mask);
+
+	ret |= adp5520_set_bits(dev->master, GPIO_PULLUP,
+		pdata->gpio_pullup_mask);
+
+	if (ret) {
+		dev_err(&pdev->dev, "failed to write\n");
+		goto err;
+	}
+
+	ret = gpiochip_add(&dev->gpio_chip);
+	if (ret)
+		goto err;
+
+	platform_set_drvdata(pdev, dev);
+	return 0;
+
+err:
+	kfree(dev);
+	return ret;
+}
+
+static int __devexit adp5520_gpio_remove(struct platform_device *pdev)
+{
+	struct adp5520_gpio *dev;
+	int ret;
+
+	dev = platform_get_drvdata(pdev);
+	ret = gpiochip_remove(&dev->gpio_chip);
+	if (ret) {
+		dev_err(&pdev->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
+		return ret;
+	}
+
+	kfree(dev);
+	return 0;
+}
+
+static struct platform_driver adp5520_gpio_driver = {
+	.driver	= {
+		.name	= "adp5520-gpio",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= adp5520_gpio_probe,
+	.remove		= __devexit_p(adp5520_gpio_remove),
+};
+
+static int __init adp5520_gpio_init(void)
+{
+	return platform_driver_register(&adp5520_gpio_driver);
+}
+module_init(adp5520_gpio_init);
+
+static void __exit adp5520_gpio_exit(void)
+{
+	platform_driver_unregister(&adp5520_gpio_driver);
+}
+module_exit(adp5520_gpio_exit);
+
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("GPIO ADP5520 Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:adp5520-gpio");
-- 
1.6.5.rc1

