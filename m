Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbZGUPA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbZGUPA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZGUPAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:00:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42579 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753107AbZGUPAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:00:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] regulator: Improve virtual consumer probe error handling
Date: Tue, 21 Jul 2009 16:00:27 +0100
Message-Id: <1248188428-11277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248188428-11277-4-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-4-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report errors to the user and try harder to clean up if we're not
able to probe.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/virtual.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 1441107..addc032 100644
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
@@ -302,8 +301,11 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
 
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
@@ -312,6 +314,8 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_regulator:
+	regulator_put(drvdata->regulator);
 err:
 	for (i = 0; i < ARRAY_SIZE(attributes); i++)
 		device_remove_file(&pdev->dev, attributes[i]);
-- 
1.6.3.3

