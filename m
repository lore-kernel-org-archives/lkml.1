Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZHISBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZHISBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 14:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZHISBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 14:01:52 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:40286 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZHISBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 14:01:52 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH] regulator: userspace: use sysfs_create_group
Date: Sun,  9 Aug 2009 21:01:25 +0300
Message-Id: <1249840885-13498-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/regulator/userspace-consumer.c |   44 ++++++++++++++++----------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
index 06d2fa9..a7e8e0b 100644
--- a/drivers/regulator/userspace-consumer.c
+++ b/drivers/regulator/userspace-consumer.c
@@ -93,16 +93,20 @@ static ssize_t reg_set_state(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(name, 0444, reg_show_name, NULL);
 static DEVICE_ATTR(state, 0644, reg_show_state, reg_set_state);
 
-static struct device_attribute *attributes[] = {
-	&dev_attr_name,
-	&dev_attr_state,
+static struct attribute *attributes[] = {
+	&dev_attr_name.attr,
+	&dev_attr_state.attr,
+};
+
+static const struct attribute_group attr_group = {
+	.attrs	= attributes,
 };
 
 static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 {
 	struct regulator_userspace_consumer_data *pdata;
 	struct userspace_consumer_data *drvdata;
-	int ret, i;
+	int ret;
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata)
@@ -125,31 +129,29 @@ static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 		goto err_alloc_supplies;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(attributes); i++) {
-		ret = device_create_file(&pdev->dev, attributes[i]);
-		if (ret != 0)
-			goto err_create_attrs;
-	}
+	ret = sysfs_create_group(&pdev->dev.kobj, &attr_group);
+	if (ret != 0)
+		goto err_create_attrs;
 
-	if (pdata->init_on)
+	if (pdata->init_on) {
 		ret = regulator_bulk_enable(drvdata->num_supplies,
 					    drvdata->supplies);
-
-	drvdata->enabled = pdata->init_on;
-
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to set initial state: %d\n", ret);
-		goto err_create_attrs;
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Failed to set initial state: %d\n", ret);
+			goto err_enable;
+		}
 	}
 
+	drvdata->enabled = pdata->init_on;
 	platform_set_drvdata(pdev, drvdata);
 
 	return 0;
 
-err_create_attrs:
-	for (i = 0; i < ARRAY_SIZE(attributes); i++)
-		device_remove_file(&pdev->dev, attributes[i]);
+err_enable:
+	sysfs_remove_group(&pdev->dev.kobj, &attr_group);
 
+err_create_attrs:
 	regulator_bulk_free(drvdata->num_supplies, drvdata->supplies);
 
 err_alloc_supplies:
@@ -160,10 +162,8 @@ err_alloc_supplies:
 static int regulator_userspace_consumer_remove(struct platform_device *pdev)
 {
 	struct userspace_consumer_data *data = platform_get_drvdata(pdev);
-	int i;
 
-	for (i = 0; i < ARRAY_SIZE(attributes); i++)
-		device_remove_file(&pdev->dev, attributes[i]);
+	sysfs_remove_group(&pdev->dev.kobj, &attr_group);
 
 	if (data->enabled)
 		regulator_bulk_disable(data->num_supplies, data->supplies);
-- 
1.6.4.rc1

