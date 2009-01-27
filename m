Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZA0Kyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZA0Kyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZA0Kx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:53:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54226 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZA0Kx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:53:57 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] leds: Simple driver for pwm driven LEDs
Date: Tue, 27 Jan 2009 11:53:54 +0100
Message-Id: <1233053634-25052-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one adds a simple driver for pwm driver LEDs. pwm_id and period can be
defined in board file. It is developed for pxa, however it is probably generic
enough to be used on other platforms with pwm.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/leds/Kconfig     |    6 ++
 drivers/leds/Makefile    |    1 +
 drivers/leds/leds-pwm.c  |  153 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds_pwm.h |   21 ++++++
 4 files changed, 181 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-pwm.c
 create mode 100644 include/linux/leds_pwm.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 7427136..4dcd58d 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -171,6 +171,12 @@ config LEDS_DA903X
 	  This option enables support for on-chip LED drivers found
 	  on Dialog Semiconductor DA9030/DA9034 PMICs.
 
+config LEDS_PWM
+	tristate "PWM driven LED Support"
+	depends on LEDS_CLASS && HAVE_PWM
+	help
+	  This option enables support for pwm driven LEDs
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 9d76f0f..8a8c22a 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
+obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
new file mode 100644
index 0000000..cdfdc87
--- /dev/null
+++ b/drivers/leds/leds-pwm.c
@@ -0,0 +1,153 @@
+/*
+ * linux/drivers/leds-pwm.c
+ *
+ * simple PWM based LED control
+ *
+ * Copyright 2009 Luotao Fu @ Pengutronix (l.fu@pengutronix.de)
+ *
+ * based on leds-gpio.c by Raphael Assenat <raph@8d.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/pwm.h>
+#include <linux/leds_pwm.h>
+
+struct led_pwm_data {
+	struct led_classdev	cdev;
+	struct pwm_device	*pwm;
+	unsigned int 		active_low;
+	unsigned int		period;
+	unsigned int		max_brightness;
+};
+
+static void led_pwm_set(struct led_classdev *led_cdev,
+	enum led_brightness brightness)
+{
+	struct led_pwm_data *led_dat =
+		container_of(led_cdev, struct led_pwm_data, cdev);
+	unsigned int max = led_dat->max_brightness;
+	unsigned int period =  led_dat->period;
+
+	if (brightness == 0) {
+		pwm_config(led_dat->pwm, 0, period);
+		pwm_disable(led_dat->pwm);
+	} else {
+		pwm_config(led_dat->pwm, brightness * period / max, period);
+		pwm_enable(led_dat->pwm);
+	}
+}
+
+static int led_pwm_probe(struct platform_device *pdev)
+{
+	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
+	struct led_pwm *cur_led;
+	struct led_pwm_data *leds_data, *led_dat;
+	int i, ret = 0;
+
+	if (!pdata)
+		return -EBUSY;
+
+	leds_data = kzalloc(sizeof(struct led_pwm_data) * pdata->num_leds,
+				GFP_KERNEL);
+	if (!leds_data)
+		return -ENOMEM;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		cur_led = &pdata->leds[i];
+		led_dat = &leds_data[i];
+
+		led_dat->pwm = pwm_request(cur_led->pwm_id,
+				cur_led->name);
+		if (IS_ERR(led_dat->pwm)) {
+			dev_err(&pdev->dev, "unable to request PWM %d\n",
+					cur_led->pwm_id);
+			goto err;
+		}
+
+		led_dat->cdev.name = cur_led->name;
+		led_dat->cdev.default_trigger = cur_led->default_trigger;
+		led_dat->active_low = cur_led->active_low;
+		led_dat->max_brightness = cur_led->max_brightness;
+		led_dat->period = cur_led->pwm_period_ns;
+		led_dat->cdev.brightness_set = led_pwm_set;
+		led_dat->cdev.brightness = LED_OFF;
+		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
+
+		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
+		if (ret < 0) {
+			pwm_free(led_dat->pwm);
+			goto err;
+		}
+	}
+
+	platform_set_drvdata(pdev, leds_data);
+
+	return 0;
+
+err:
+	if (i > 0) {
+		for (i = i - 1; i >= 0; i--) {
+			led_classdev_unregister(&leds_data[i].cdev);
+			pwm_free(leds_data[i].pwm);
+		}
+	}
+
+	kfree(leds_data);
+
+	return ret;
+}
+
+static int __devexit led_pwm_remove(struct platform_device *pdev)
+{
+	int i;
+	struct led_pwm_platform_data *pdata = pdev->dev.platform_data;
+	struct led_pwm_data *leds_data;
+
+	leds_data = platform_get_drvdata(pdev);
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		led_classdev_unregister(&leds_data[i].cdev);
+		pwm_free(leds_data[i].pwm);
+	}
+
+	kfree(leds_data);
+
+	return 0;
+}
+
+static struct platform_driver led_pwm_driver = {
+	.probe		= led_pwm_probe,
+	.remove		= __devexit_p(led_pwm_remove),
+	.driver		= {
+		.name	= "leds_pwm",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init led_pwm_init(void)
+{
+	return platform_driver_register(&led_pwm_driver);
+}
+
+static void __exit led_pwm_exit(void)
+{
+	platform_driver_unregister(&led_pwm_driver);
+}
+
+module_init(led_pwm_init);
+module_exit(led_pwm_exit);
+
+MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
+MODULE_DESCRIPTION("PWM LED driver for PXA");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-pwm");
diff --git a/include/linux/leds_pwm.h b/include/linux/leds_pwm.h
new file mode 100644
index 0000000..33a0711
--- /dev/null
+++ b/include/linux/leds_pwm.h
@@ -0,0 +1,21 @@
+/*
+ * PWM LED driver data - see drivers/leds/leds-pwm.c
+ */
+#ifndef __LINUX_LEDS_PWM_H
+#define __LINUX_LEDS_PWM_H
+
+struct led_pwm {
+	const char	*name;
+	const char	*default_trigger;
+	unsigned	pwm_id;
+	u8 		active_low;
+	unsigned 	max_brightness;
+	unsigned	pwm_period_ns;
+};
+
+struct led_pwm_platform_data {
+	int			num_leds;
+	struct led_pwm	*leds;
+};
+
+#endif
-- 
1.5.6.5

