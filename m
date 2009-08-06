Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZHFQhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZHFQhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZHFQhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:37:35 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63010 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbZHFQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:37:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cWvr+CaqJVkrke90ceJgCqZt5/Wc81SIV7M1IVOASWMiG+QlCSmQSXx+EH+iHL9tkE
         fjG62fbbvTNKy8pDrGpLJA0+pkjnkX4PCunl4j3eycvVkgUVz/jzNPJsWTrh3WYll5eT
         g0VHoHNizg6wNbj+TggAXq2AMMPCoV/AzZS/4=
From: Roger Quadros <quadros.roger@gmail.com>
To: broonie@sirena.org.uk
Cc: lrg@slimlogic.co.uk, philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH v5] [RESEND 2] regulator: Add GPIO enable control to fixed voltage regulator driver
Date: Thu,  6 Aug 2009 19:37:29 +0300
Message-Id: <1249576649-10906-1-git-send-email-quadros.roger@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <quadros.roger@gmail.com>
References: <quadros.roger@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <ext-roger.quadros@nokia.com>

Now fixed regulators that have their enable pin connected to a GPIO line
can use the fixed regulator driver for regulator enable/disable control.
The GPIO number and polarity information is passed through platform data.
GPIO enable control is achieved using gpiolib.

Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
Reviewed-by: Felipe Balbi <felipe.balbi@nokia.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/fixed.c       |   88 ++++++++++++++++++++++++++++++++++++++-
 include/linux/regulator/fixed.h |   24 +++++++++++
 2 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 9c7f956..f8b2957 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -5,6 +5,9 @@
  *
  * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
  *
+ * Copyright (c) 2009 Nokia Corporation
+ * Roger Quadros <ext-roger.quadros@nokia.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation; either version 2 of the
@@ -20,20 +23,45 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/fixed.h>
+#include <linux/gpio.h>
 
 struct fixed_voltage_data {
 	struct regulator_desc desc;
 	struct regulator_dev *dev;
 	int microvolts;
+	int gpio;
+	unsigned enable_high:1;
+	unsigned is_enabled:1;
 };
 
 static int fixed_voltage_is_enabled(struct regulator_dev *dev)
 {
-	return 1;
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	return data->is_enabled;
 }
 
 static int fixed_voltage_enable(struct regulator_dev *dev)
 {
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	if (gpio_is_valid(data->gpio)) {
+		gpio_set_value_cansleep(data->gpio, data->enable_high);
+		data->is_enabled = 1;
+	}
+
+	return 0;
+}
+
+static int fixed_voltage_disable(struct regulator_dev *dev)
+{
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	if (gpio_is_valid(data->gpio)) {
+		gpio_set_value_cansleep(data->gpio, !data->enable_high);
+		data->is_enabled = 0;
+	}
+
 	return 0;
 }
 
@@ -58,6 +86,7 @@ static int fixed_voltage_list_voltage(struct regulator_dev *dev,
 static struct regulator_ops fixed_voltage_ops = {
 	.is_enabled = fixed_voltage_is_enabled,
 	.enable = fixed_voltage_enable,
+	.disable = fixed_voltage_disable,
 	.get_voltage = fixed_voltage_get_voltage,
 	.list_voltage = fixed_voltage_list_voltage,
 };
@@ -87,13 +116,62 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->desc.n_voltages = 1;
 
 	drvdata->microvolts = config->microvolts;
+	drvdata->gpio = config->gpio;
+
+	if (gpio_is_valid(config->gpio)) {
+		drvdata->enable_high = config->enable_high;
+
+		/* FIXME: Remove below print warning
+		 *
+		 * config->gpio must be set to -EINVAL by platform code if
+		 * GPIO control is not required. However, early adopters
+		 * not requiring GPIO control may forget to initialize
+		 * config->gpio to -EINVAL. This will cause GPIO 0 to be used
+		 * for GPIO control.
+		 *
+		 * This warning will be removed once there are a couple of users
+		 * for this driver.
+		 */
+		if (!config->gpio)
+			dev_warn(&pdev->dev,
+				"using GPIO 0 for regulator enable control\n");
+
+		ret = gpio_request(config->gpio, config->supply_name);
+		if (ret) {
+			dev_err(&pdev->dev,
+			   "Could not obtain regulator enable GPIO %d: %d\n",
+							config->gpio, ret);
+			goto err_name;
+		}
+
+		/* set output direction without changing state
+		 * to prevent glitch
+		 */
+		drvdata->is_enabled = config->enabled_at_boot;
+		ret = drvdata->is_enabled ?
+				config->enable_high : !config->enable_high;
+
+		ret = gpio_direction_output(config->gpio, ret);
+		if (ret) {
+			dev_err(&pdev->dev,
+			   "Could not configure regulator enable GPIO %d direction: %d\n",
+							config->gpio, ret);
+			goto err_gpio;
+		}
+
+	} else {
+		/* Regulator without GPIO control is considered
+		 * always enabled
+		 */
+		drvdata->is_enabled = 1;
+	}
 
 	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
 					  config->init_data, drvdata);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
-		goto err_name;
+		goto err_gpio;
 	}
 
 	platform_set_drvdata(pdev, drvdata);
@@ -103,6 +181,9 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_gpio:
+	if (gpio_is_valid(config->gpio))
+		gpio_free(config->gpio);
 err_name:
 	kfree(drvdata->desc.name);
 err:
@@ -118,6 +199,9 @@ static int regulator_fixed_voltage_remove(struct platform_device *pdev)
 	kfree(drvdata->desc.name);
 	kfree(drvdata);
 
+	if (gpio_is_valid(drvdata->gpio))
+		gpio_free(drvdata->gpio);
+
 	return 0;
 }
 
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index 91b4da3..e94a4a1 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -5,6 +5,9 @@
  *
  * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
  *
+ * Copyright (c) 2009 Nokia Corporation
+ * Roger Quadros <ext-roger.quadros@nokia.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation; either version 2 of the
@@ -16,9 +19,30 @@
 
 struct regulator_init_data;
 
+/**
+ * struct fixed_voltage_config - fixed_voltage_config structure
+ * @supply_name:	Name of the regulator supply
+ * @microvolts:		Output voltage of regulator
+ * @gpio:		GPIO to use for enable control
+ * 			set to -EINVAL if not used
+ * @enable_high:	Polarity of enable GPIO
+ *			1 = Active high, 0 = Active low
+ * @enabled_at_boot:	Whether regulator has been enabled at
+ * 			boot or not. 1 = Yes, 0 = No
+ * 			This is used to keep the regulator at
+ * 			the default state
+ * @init_data:		regulator_init_data
+ *
+ * This structure contains fixed voltage regulator configuration
+ * information that must be passed by platform code to the fixed
+ * voltage regulator driver.
+ */
 struct fixed_voltage_config {
 	const char *supply_name;
 	int microvolts;
+	int gpio;
+	unsigned enable_high:1;
+	unsigned enabled_at_boot:1;
 	struct regulator_init_data *init_data;
 };
 
-- 
1.5.6.3

