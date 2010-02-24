Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab0BXHhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:37:51 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39422 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0BXHhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=o5kCk/1KqVE7mYVRakI6ITT7PKXI+geAOgcrTuc9I35k9VgrOfm/ps37/e+/vkuv6w
         PAkhPV/JyqhrkNDPt4rLvZBjYuEg9YPm5i4+00zSSOl9Ra2aeFky8MPul9ixoDo7Pnes
         W/XJJ4FU6kpwJdEet7l6qT8vu4fvsVhkJXbaM=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 01/14] Regulators: virtual - use sysfs attribute groups
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:37:44 -0800
Message-ID: <20100224073744.15964.93309.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding sysfs attribute group use canned solution.
Also add __devinit/__devexit markups for probe and remove methods
and use 'bool' where it makes sense.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/virtual.c |   64 ++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index addc032..d96ceca 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -19,7 +19,7 @@
 struct virtual_consumer_data {
 	struct mutex lock;
 	struct regulator *regulator;
-	int enabled;
+	bool enabled;
 	int min_uV;
 	int max_uV;
 	int min_uA;
@@ -49,7 +49,7 @@ static void update_voltage_constraints(struct device *dev,
 		dev_dbg(dev, "Enabling regulator\n");
 		ret = regulator_enable(data->regulator);
 		if (ret == 0)
-			data->enabled = 1;
+			data->enabled = true;
 		else
 			dev_err(dev, "regulator_enable() failed: %d\n",
 				ret);
@@ -59,7 +59,7 @@ static void update_voltage_constraints(struct device *dev,
 		dev_dbg(dev, "Disabling regulator\n");
 		ret = regulator_disable(data->regulator);
 		if (ret == 0)
-			data->enabled = 0;
+			data->enabled = false;
 		else
 			dev_err(dev, "regulator_disable() failed: %d\n",
 				ret);
@@ -89,7 +89,7 @@ static void update_current_limit_constraints(struct device *dev,
 		dev_dbg(dev, "Enabling regulator\n");
 		ret = regulator_enable(data->regulator);
 		if (ret == 0)
-			data->enabled = 1;
+			data->enabled = true;
 		else
 			dev_err(dev, "regulator_enable() failed: %d\n",
 				ret);
@@ -99,7 +99,7 @@ static void update_current_limit_constraints(struct device *dev,
 		dev_dbg(dev, "Disabling regulator\n");
 		ret = regulator_disable(data->regulator);
 		if (ret == 0)
-			data->enabled = 0;
+			data->enabled = false;
 		else
 			dev_err(dev, "regulator_disable() failed: %d\n",
 				ret);
@@ -270,24 +270,28 @@ static DEVICE_ATTR(min_microamps, 0666, show_min_uA, set_min_uA);
 static DEVICE_ATTR(max_microamps, 0666, show_max_uA, set_max_uA);
 static DEVICE_ATTR(mode, 0666, show_mode, set_mode);
 
-static struct device_attribute *attributes[] = {
-	&dev_attr_min_microvolts,
-	&dev_attr_max_microvolts,
-	&dev_attr_min_microamps,
-	&dev_attr_max_microamps,
-	&dev_attr_mode,
+static struct attribute *regulator_virtual_attributes[] = {
+	&dev_attr_min_microvolts.attr,
+	&dev_attr_max_microvolts.attr,
+	&dev_attr_min_microamps.attr,
+	&dev_attr_max_microamps.attr,
+	&dev_attr_mode.attr,
+	NULL
 };
 
-static int regulator_virtual_consumer_probe(struct platform_device *pdev)
+static const struct attribute_group regulator_virtual_attr_group = {
+	.attrs	= regulator_virtual_attributes,
+};
+
+static int __devinit regulator_virtual_probe(struct platform_device *pdev)
 {
 	char *reg_id = pdev->dev.platform_data;
 	struct virtual_consumer_data *drvdata;
-	int ret, i;
+	int ret;
 
 	drvdata = kzalloc(sizeof(struct virtual_consumer_data), GFP_KERNEL);
-	if (drvdata == NULL) {
+	if (drvdata == NULL)
 		return -ENOMEM;
-	}
 
 	mutex_init(&drvdata->lock);
 
@@ -299,13 +303,12 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(attributes); i++) {
-		ret = device_create_file(&pdev->dev, attributes[i]);
-		if (ret != 0) {
-			dev_err(&pdev->dev, "Failed to create attr %d: %d\n",
-				i, ret);
-			goto err_regulator;
-		}
+	ret = sysfs_create_group(&pdev->dev.kobj,
+				 &regulator_virtual_attr_group);
+	if (ret != 0) {
+		dev_err(&pdev->dev,
+			"Failed to create attribute group: %d\n", ret);
+		goto err_regulator;
 	}
 
 	drvdata->mode = regulator_get_mode(drvdata->regulator);
@@ -317,37 +320,36 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
 err_regulator:
 	regulator_put(drvdata->regulator);
 err:
-	for (i = 0; i < ARRAY_SIZE(attributes); i++)
-		device_remove_file(&pdev->dev, attributes[i]);
 	kfree(drvdata);
 	return ret;
 }
 
-static int regulator_virtual_consumer_remove(struct platform_device *pdev)
+static int __devexit regulator_virtual_remove(struct platform_device *pdev)
 {
 	struct virtual_consumer_data *drvdata = platform_get_drvdata(pdev);
-	int i;
 
-	for (i = 0; i < ARRAY_SIZE(attributes); i++)
-		device_remove_file(&pdev->dev, attributes[i]);
+	sysfs_remove_group(&pdev->dev.kobj, &regulator_virtual_attr_group);
+
 	if (drvdata->enabled)
 		regulator_disable(drvdata->regulator);
 	regulator_put(drvdata->regulator);
 
 	kfree(drvdata);
 
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
 static struct platform_driver regulator_virtual_consumer_driver = {
-	.probe		= regulator_virtual_consumer_probe,
-	.remove		= regulator_virtual_consumer_remove,
+	.probe		= regulator_virtual_probe,
+	.remove		= __devexit_p(regulator_virtual_remove),
 	.driver		= {
 		.name		= "reg-virt-consumer",
+		.owner		= THIS_MODULE,
 	},
 };
 
-
 static int __init regulator_virtual_consumer_init(void)
 {
 	return platform_driver_register(&regulator_virtual_consumer_driver);

