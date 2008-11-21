Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYKUQoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYKUQoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbYKUQo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:44:26 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:52832 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbYKUQoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:44:24 -0500
Message-Id: <20081121160522.717181451@dodger.lab.datenfreihafen.org>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 17:04:13 +0100
From: stefan@datenfreihafen.org
To: eric.y.miao@gmail.com, rpurdie@rpsys.net
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Daniel Ribeiro <drwyrm@gmail.com>
Content-Disposition: inline; filename=ezx/pcap_leds.diff
Subject: [patch 10/14] LED: PCAP2 based LED driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED driver based on the PCAP2 multi function device.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/leds/Kconfig      |    6 ++
 drivers/leds/Makefile     |    1 +
 drivers/leds/leds-pcap.c  |  160 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-pcap.h |   15 ++++
 4 files changed, 182 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e7fb7d2..449b653 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -165,6 +165,12 @@ config LEDS_DA903X
 	  This option enables support for on-chip LED drivers found
 	  on Dialog Semiconductor DA9030/DA9034 PMICs.
 
+config LEDS_PCAP
+	tristate "LED Support for PCAP2 ASIC"
+	depends on EZX_PCAP
+	help
+	  This option enables support for the led controller on PCAP2.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e1967a2..424a74a 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_HP_DISK)		+= leds-hp-disk.o
+obj-$(CONFIG_LEDS_PCAP)			+= leds-pcap.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff --git a/drivers/leds/leds-pcap.c b/drivers/leds/leds-pcap.c
new file mode 100644
index 0000000..0603b2f
--- /dev/null
+++ b/drivers/leds/leds-pcap.c
@@ -0,0 +1,160 @@
+/*
+ * linux/drivers/leds/leds-pcap.c
+ *
+ * Copyright (C) 2008 Daniel Ribeiro <drwyrm@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/leds.h>
+#include <linux/leds-pcap.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/ezx-pcap.h>
+
+static void pcap_led_set_brightness(struct led_classdev *led_cdev,
+					enum led_brightness val)
+{
+	struct pcap_led *led = container_of(led_cdev, struct pcap_led, ldev);
+
+	led->brightness = val;
+
+	schedule_work(&led->work);
+}
+
+static void pcap_led_work(struct work_struct *work)
+{
+	u32 tmp;
+	u8 t, c, e;
+	struct pcap_led *led = container_of(work, struct pcap_led, work);
+
+	ezx_pcap_read(PCAP_REG_PERIPH, &tmp);
+	switch (led->type) {
+	case PCAP_LED0:
+		t = PCAP_LED0_T_SHIFT;
+		c = PCAP_LED0_C_SHIFT;
+		e = PCAP_LED0_EN;
+		if (led->brightness)
+			led->brightness = 1;
+		break;
+	case PCAP_LED1:
+		t = PCAP_LED1_T_SHIFT;
+		c = PCAP_LED1_C_SHIFT;
+		e = PCAP_LED1_EN;
+		if (led->brightness)
+			led->brightness = 1;
+		break;
+	case PCAP_BL0:
+		if (led->brightness > PCAP_BL_MASK)
+			led->brightness = PCAP_BL_MASK;
+		tmp &= ~(PCAP_BL_MASK << PCAP_BL0_SHIFT);
+		tmp |= led->brightness << PCAP_BL0_SHIFT;
+		ezx_pcap_write(PCAP_REG_PERIPH, tmp);
+		return;
+	case PCAP_BL1:
+		if (led->brightness > PCAP_BL_MASK)
+			led->brightness = PCAP_BL_MASK;
+		tmp &= ~(PCAP_BL_MASK << PCAP_BL1_SHIFT);
+		tmp |= led->brightness << PCAP_BL1_SHIFT;
+		ezx_pcap_write(PCAP_REG_PERIPH, tmp);
+		return;
+	default:
+		return;
+	}
+	/* turn off */
+	tmp &= ~(e | (PCAP_LED_T_MASK << t) | (PCAP_LED_C_MASK << c));
+
+	if (led->brightness) /* turn on */
+		tmp |= (e | (led->curr << c) | (led->timing << t));
+
+	if (led->gpio & PCAP_LED_GPIO_EN)
+		gpio_set_value((led->gpio & PCAP_LED_GPIO_VAL_MASK),
+			((led->gpio & PCAP_LED_GPIO_INVERT) ?
+			!led->brightness : led->brightness));
+
+	ezx_pcap_write(PCAP_REG_PERIPH, tmp);
+}
+
+static int __devinit pcap_led_probe(struct platform_device *pdev)
+{
+	int i, err;
+	struct pcap_leds_platform_data *pdata = pdev->dev.platform_data;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "%s: no platform data\n", __func__);
+		return -EINVAL;
+	}
+	for (i = 0; i < pdata->num_leds; i++) {
+		struct pcap_led *led = &pdata->leds[i];
+		led->ldev.name = led->name;
+		led->ldev.brightness_set = pcap_led_set_brightness;
+		if (led->gpio & PCAP_LED_GPIO_EN) {
+			int gpio = (led->gpio & PCAP_LED_GPIO_VAL_MASK);
+			err = gpio_request(gpio, "PCAP LED");
+			if (err) {
+				dev_err(&pdev->dev,
+					"couldn't request gpio %d\n", gpio);
+				goto fail;
+			}
+			gpio_direction_output(gpio,
+				(led->gpio & PCAP_LED_GPIO_INVERT) ? 1 : 0);
+		}
+		err = led_classdev_register(&pdev->dev, &led->ldev);
+		if (err) {
+			dev_err(&pdev->dev, "couldn't register LED %s\n",
+					led->name);
+			goto fail;
+		}
+		INIT_WORK(&led->work, pcap_led_work);
+	}
+	return 0;
+
+fail:
+	while (i >= 0) {
+		led_classdev_unregister(&pdata->leds[--i].ldev);
+		cancel_work_sync(&pdata->leds[i].work);
+	}
+	return err;
+}
+
+static int __devexit pcap_led_remove(struct platform_device *pdev)
+{
+	int i;
+	struct pcap_leds_platform_data *pdata = pdev->dev.platform_data;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		led_classdev_unregister(&pdata->leds[i].ldev);
+		cancel_work_sync(&pdata->leds[i].work);
+	}
+	return 0;
+}
+
+static struct platform_driver pcap_led_driver = {
+	.probe  = pcap_led_probe,
+	.remove = pcap_led_remove,
+	.driver = {
+		.name = "pcap-leds",
+	},
+};
+
+static int __init pcap_led_init(void)
+{
+	return platform_driver_register(&pcap_led_driver);
+}
+
+static void __exit pcap_led_exit(void)
+{
+	return platform_driver_unregister(&pcap_led_driver);
+}
+
+module_init(pcap_led_init);
+module_exit(pcap_led_exit);
+
+MODULE_AUTHOR("Daniel Ribeiro <drwyrm@gmail.com>");
+MODULE_DESCRIPTION("PCAP LED driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/leds-pcap.h b/include/linux/leds-pcap.h
new file mode 100644
index 0000000..62263c0
--- /dev/null
+++ b/include/linux/leds-pcap.h
@@ -0,0 +1,15 @@
+struct pcap_led {
+	u8 type;
+	char *name;
+	u8 curr;
+	u8 timing;
+	u32 gpio;
+	int brightness;
+	struct led_classdev ldev;
+	struct work_struct work;
+};
+
+struct pcap_leds_platform_data {
+	int num_leds;
+	struct pcap_led leds[];
+};
-- 
tg: (618a1f7..) ezx/pcap_leds (depends on: ezx/local/pcap)

-- 
