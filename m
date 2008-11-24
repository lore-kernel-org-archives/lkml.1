Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYKXQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYKXQo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYKXQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:44:20 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:47450 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYKXQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:44:19 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] regulator: move set_machine_constraints after regulator device initialization
Date: Mon, 24 Nov 2008 18:44:15 +0200
Message-Id: <1227545055-28782-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling set_machine_constraints before regulator device initialization
causes crash when constraints have apply_uV set.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/core.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 02a7744..c4636da 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1768,14 +1768,6 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 		}
 	}
 
-	/* set regulator constraints */
-	ret = set_machine_constraints(rdev, &init_data->constraints);
-	if (ret < 0) {
-		kfree(rdev);
-		rdev = ERR_PTR(ret);
-		goto out;
-	}
-
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
 	rdev->dev.parent = dev;
@@ -1790,6 +1782,15 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
+	/* set regulator constraints */
+	ret = set_machine_constraints(rdev, &init_data->constraints);
+	if (ret < 0) {
+		device_unregister(&rdev->dev);
+		kfree(rdev);
+		rdev = ERR_PTR(ret);
+		goto out;
+	}
+
 	/* set supply regulator if it exists */
 	if (init_data->supply_regulator_dev) {
 		ret = set_supply(rdev,
-- 
1.5.6.4

