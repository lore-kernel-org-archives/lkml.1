Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZJHIA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZJHIA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZJHIA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:00:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55513 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbZJHIAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:00:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH v2] LED Support for ADP5520/ADP5501 MFD PMICs
Date: Thu,  8 Oct 2009 04:00:19 -0400
Message-Id: <1254988819-31876-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1253223921-6417-1-git-send-email-vapier@gentoo.org>
References: <1253223921-6417-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- update define/platform names based on common adp5520 mfd changes

 drivers/leds/Kconfig        |   10 ++
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-adp5520.c |  230 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 241 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-adp5520.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e4f599f..33ac8dc 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -236,6 +236,16 @@ config LEDS_BD2802
 	  This option enables support for BD2802GU RGB LED driver chips
 	  accessed via the I2C bus.
 
+config LEDS_ADP5520
+	tristate "LED Support for ADP5520/ADP5501 PMIC"
+	depends on LEDS_CLASS && PMIC_ADP5520
+	help
+	  This option enables support for on-chip LED drivers found
+	  on Analog Devices ADP5520/ADP5501 PMICs.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called leds-adp5520.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 46d7270..f7e17f4 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
+obj-$(CONFIG_LEDS_ADP5520)		+= leds-adp5520.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-adp5520.c b/drivers/leds/leds-adp5520.c
new file mode 100644
index 0000000..a8f3159
--- /dev/null
+++ b/drivers/leds/leds-adp5520.c
@@ -0,0 +1,230 @@
+/*
+ * LEDs driver for Analog Devices ADP5520/ADP5501 MFD PMICs
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Loosely derived from leds-da903x:
+ * Copyright (C) 2008 Compulab, Ltd.
+ * 	Mike Rapoport <mike@compulab.co.il>
+ *
+ * Copyright (C) 2006-2008 Marvell International Ltd.
+ * 	Eric Miao <eric.miao@marvell.com>
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+#include <linux/mfd/adp5520.h>
+
+struct adp5520_led {
+	struct led_classdev	cdev;
+	struct work_struct	work;
+	struct device		*master;
+	enum led_brightness	new_brightness;
+	int			id;
+	int			flags;
+};
+
+static void adp5520_led_work(struct work_struct *work)
+{
+	struct adp5520_led *led = container_of(work, struct adp5520_led, work);
+	adp5520_write(led->master, ADP5520_LED1_CURRENT + led->id - 1,
+			 led->new_brightness >> 2);
+}
+
+static void adp5520_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct adp5520_led *led;
+
+	led = container_of(led_cdev, struct adp5520_led, cdev);
+	led->new_brightness = value;
+	schedule_work(&led->work);
+}
+
+static int adp5520_led_setup(struct adp5520_led *led)
+{
+	struct device *dev = led->master;
+	int flags = led->flags;
+	int ret = 0;
+
+	switch (led->id) {
+	case FLAG_ID_ADP5520_LED1_ADP5501_LED0:
+		ret |= adp5520_set_bits(dev, ADP5520_LED_TIME,
+					(flags >> ADP5520_FLAG_OFFT_SHIFT) &
+					ADP5520_FLAG_OFFT_MASK);
+		ret |= adp5520_set_bits(dev, ADP5520_LED_CONTROL,
+					ADP5520_LED1_EN);
+		break;
+	case FLAG_ID_ADP5520_LED2_ADP5501_LED1:
+		ret |= adp5520_set_bits(dev,  ADP5520_LED_TIME,
+					((flags >> ADP5520_FLAG_OFFT_SHIFT) &
+					ADP5520_FLAG_OFFT_MASK) << 2);
+		ret |= adp5520_clr_bits(dev, ADP5520_LED_CONTROL,
+					 ADP5520_R3_MODE);
+		ret |= adp5520_set_bits(dev, ADP5520_LED_CONTROL,
+					ADP5520_LED2_EN);
+		break;
+	case FLAG_ID_ADP5520_LED3_ADP5501_LED2:
+		ret |= adp5520_set_bits(dev,  ADP5520_LED_TIME,
+					((flags >> ADP5520_FLAG_OFFT_SHIFT) &
+					ADP5520_FLAG_OFFT_MASK) << 4);
+		ret |= adp5520_clr_bits(dev, ADP5520_LED_CONTROL,
+					ADP5520_C3_MODE);
+		ret |= adp5520_set_bits(dev, ADP5520_LED_CONTROL,
+					ADP5520_LED3_EN);
+		break;
+	}
+
+	return ret;
+}
+
+static int __devinit adp5520_led_prepare(struct platform_device *pdev)
+{
+	struct adp5520_leds_platform_data *pdata = pdev->dev.platform_data;
+	struct device *dev = pdev->dev.parent;
+	int ret = 0;
+
+	ret |= adp5520_write(dev, ADP5520_LED1_CURRENT, 0);
+	ret |= adp5520_write(dev, ADP5520_LED2_CURRENT, 0);
+	ret |= adp5520_write(dev, ADP5520_LED3_CURRENT, 0);
+	ret |= adp5520_write(dev, ADP5520_LED_TIME, pdata->led_on_time << 6);
+	ret |= adp5520_write(dev, ADP5520_LED_FADE, FADE_VAL(pdata->fade_in,
+		 pdata->fade_out));
+
+	return ret;
+}
+
+static int __devinit adp5520_led_probe(struct platform_device *pdev)
+{
+	struct adp5520_leds_platform_data *pdata = pdev->dev.platform_data;
+	struct adp5520_led *led, *led_dat;
+	struct led_info *cur_led;
+	int ret, i;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -ENODEV;
+	}
+
+	if (pdata->num_leds > ADP5520_01_MAXLEDS) {
+		dev_err(&pdev->dev, "can't handle more than %d LEDS\n",
+				 ADP5520_01_MAXLEDS);
+		return -EFAULT;
+	}
+
+	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&pdev->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	ret = adp5520_led_prepare(pdev);
+
+	if (ret) {
+		dev_err(&pdev->dev, "failed to write\n");
+		goto err_free;
+	}
+
+	for (i = 0; i < pdata->num_leds; ++i) {
+		cur_led = &pdata->leds[i];
+		led_dat = &led[i];
+
+		led_dat->cdev.name = cur_led->name;
+		led_dat->cdev.default_trigger = cur_led->default_trigger;
+		led_dat->cdev.brightness_set = adp5520_led_set;
+		led_dat->cdev.brightness = LED_OFF;
+
+		if (cur_led->flags & ADP5520_FLAG_LED_MASK)
+			led_dat->flags = cur_led->flags;
+		else
+			led_dat->flags = i + 1;
+
+		led_dat->id = led_dat->flags & ADP5520_FLAG_LED_MASK;
+
+		led_dat->master = pdev->dev.parent;
+		led_dat->new_brightness = LED_OFF;
+
+		INIT_WORK(&led_dat->work, adp5520_led_work);
+
+		ret = led_classdev_register(led_dat->master, &led_dat->cdev);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to register LED %d\n",
+				led_dat->id);
+			goto err;
+		}
+
+		ret = adp5520_led_setup(led_dat);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to write\n");
+			i++;
+			goto err;
+		}
+	}
+
+	platform_set_drvdata(pdev, led);
+	return 0;
+
+err:
+	if (i > 0) {
+		for (i = i - 1; i >= 0; i--) {
+			led_classdev_unregister(&led[i].cdev);
+			cancel_work_sync(&led[i].work);
+		}
+	}
+
+err_free:
+	kfree(led);
+	return ret;
+}
+
+static int __devexit adp5520_led_remove(struct platform_device *pdev)
+{
+	struct adp5520_leds_platform_data *pdata = pdev->dev.platform_data;
+	struct adp5520_led *led;
+	int i;
+
+	led = platform_get_drvdata(pdev);
+
+	adp5520_clr_bits(led->master, ADP5520_LED_CONTROL,
+		 ADP5520_LED1_EN | ADP5520_LED2_EN | ADP5520_LED3_EN);
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+
+	kfree(led);
+	return 0;
+}
+
+static struct platform_driver adp5520_led_driver = {
+	.driver	= {
+		.name	= "adp5520-led",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= adp5520_led_probe,
+	.remove		= __devexit_p(adp5520_led_remove),
+};
+
+static int __init adp5520_led_init(void)
+{
+	return platform_driver_register(&adp5520_led_driver);
+}
+module_init(adp5520_led_init);
+
+static void __exit adp5520_led_exit(void)
+{
+	platform_driver_unregister(&adp5520_led_driver);
+}
+module_exit(adp5520_led_exit);
+
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("LEDS ADP5520(01) Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:adp5520-led");
-- 
1.6.5.rc2

