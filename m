Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZGaMzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZGaMzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZGaMzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:55:48 -0400
Received: from smtp.nokia.com ([192.100.105.134]:43183 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZGaMzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:55:48 -0400
From: Roger Quadros <quadros.roger@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Add GPIO enable control to fixed voltage regulator driver
Date: Fri, 31 Jul 2009 15:55:18 +0300
Message-Id: <1249044918-695-1-git-send-email-quadros.roger@gmail.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 31 Jul 2009 12:55:35.0748 (UTC) FILETIME=[32482040:01CA11DE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <ext-roger.quadros@nokia.com>

Now fixed regulators that have their enable pin connected to a GPIO line
can use the fixed regulator driver. The GPIO number and polarity
information is passed through platform data. GPIO enable control
is acheived using gpiolib.

Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
---
 drivers/regulator/fixed.c       |   60 ++++++++++++++++++++++++++++++++++++++-
 include/linux/regulator/fixed.h |    7 ++++
 2 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index cdc674f..4ba6a50 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -20,20 +20,51 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/fixed.h>
+#include <linux/gpio.h>
 
 struct fixed_voltage_data {
 	struct regulator_desc desc;
 	struct regulator_dev *dev;
 	int microvolts;
+	int use_gpio_control;
+	int gpio;
+	int enable_high;
+	int is_enabled;
 };
 
 static int fixed_voltage_is_enabled(struct regulator_dev *dev)
 {
-	return 1;
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	if (data->use_gpio_control)
+		return data->is_enabled;
+	else
+		return 1;
 }
 
 static int fixed_voltage_enable(struct regulator_dev *dev)
 {
+	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
+
+	if (data->use_gpio_control) {
+		gpio_set_value(data->gpio,
+				data->enable_high ? 1 : 0);
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
+	if (data->use_gpio_control) {
+		gpio_set_value(data->gpio,
+				data->enable_high ? 0 : 1);
+		data->is_enabled = 0;
+	}
+
 	return 0;
 }
 
@@ -58,6 +89,7 @@ static int fixed_voltage_list_voltage(struct regulator_dev *dev,
 static struct regulator_ops fixed_voltage_ops = {
 	.is_enabled = fixed_voltage_is_enabled,
 	.enable = fixed_voltage_enable,
+	.disable = fixed_voltage_disable,
 	.get_voltage = fixed_voltage_get_voltage,
 	.list_voltage = fixed_voltage_list_voltage,
 };
@@ -85,6 +117,29 @@ static int regulator_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->desc.n_voltages = 1;
 
 	drvdata->microvolts = config->microvolts;
+	drvdata->use_gpio_control = config->use_gpio_control;
+	if (drvdata->use_gpio_control) {
+		drvdata->gpio = config->gpio;
+		drvdata->enable_high = config->enable_high;
+
+		ret = gpio_request(config->gpio,
+					config->supply_name);
+		if (ret) {
+			dev_err(&pdev->dev, "Could not obtain regulator " \
+					"enable GPIO %d\n", config->gpio);
+			goto err_name;
+		} else {
+			ret = gpio_direction_output(config->gpio,
+				config->enable_high ? 0 : 1);
+			if (ret) {
+				dev_err(&pdev->dev, "Could not configure " \
+					"enable GPIO %d direction\n",
+					config->gpio);
+				gpio_free(config->gpio);
+				goto err_name;
+			}
+		}
+	}
 
 	drvdata->dev = regulator_register(&drvdata->desc, &pdev->dev,
 					  config->init_data, drvdata);
@@ -115,6 +170,9 @@ static int regulator_fixed_voltage_remove(struct platform_device *pdev)
 	kfree(drvdata->desc.name);
 	kfree(drvdata);
 
+	if (drvdata->_use_gpio_control)
+		gpio_free(drvdata->gpio);
+
 	return 0;
 }
 
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index 91b4da3..5b963cc 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -19,6 +19,13 @@ struct regulator_init_data;
 struct fixed_voltage_config {
 	const char *supply_name;
 	int microvolts;
+	int use_gpio_control;	/* Use GPIO enable control */
+	int gpio;		/* GPIO to use for enable control */
+
+	int enable_high;	/* Polarity of enable GPIO
+				 * 1 = Active High, 0 = Active Low
+				 */
+
 	struct regulator_init_data *init_data;
 };
 
-- 
1.6.0.4

