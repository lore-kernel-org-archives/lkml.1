Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbZGOUb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbZGOUb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbZGOUb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:31:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33654 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932284AbZGOUb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:31:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Improve virtual consumer probe error handling
Date: Wed, 15 Jul 2009 21:31:25 +0100
Message-Id: <1247689885-29359-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report errors to the user and try harder to clean up if we're not
able to probe.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/virtual.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index acbe18f..036d790 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -286,8 +286,7 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
 
 	drvdata = kzalloc(sizeof(struct virtual_consumer_data), GFP_KERNEL);
 	if (drvdata == NULL) {
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	mutex_init(&drvdata->lock);
@@ -295,13 +294,17 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
 	drvdata->regulator = regulator_get(&pdev->dev, reg_id);
 	if (IS_ERR(drvdata->regulator)) {
 		ret = PTR_ERR(drvdata->regulator);
+		dev_err(&pdev->dev, "Failed to get %s: %d\n", reg_id, ret);
 		goto err;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(attributes); i++) {
 		ret = device_create_file(&pdev->dev, attributes[i]);
-		if (ret != 0)
-			goto err;
+		if (ret != 0) {
+			dev_err(&pdev->dev, "Failed to create attr %d: %d\n",
+				i, ret);
+			goto err_regulator;
+		}
 	}
 
 	drvdata->mode = regulator_get_mode(drvdata->regulator);
@@ -310,6 +313,8 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_regulator:
+	regulator_put(drvdata->regulator);
 err:
 	for (i = 0; i < ARRAY_SIZE(attributes); i++)
 		device_remove_file(&pdev->dev, attributes[i]);
-- 
1.6.3.3

