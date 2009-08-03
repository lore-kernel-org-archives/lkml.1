Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZHCRuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZHCRuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZHCRuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:50:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37458 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752742AbZHCRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:49:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/5] regulator: regulator_enable() permission checking
Date: Mon,  3 Aug 2009 18:49:57 +0100
Message-Id: <1249321797-4582-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249321797-4582-4-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1249321797-4582-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249321797-4582-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249321797-4582-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249321797-4582-4-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_enable() code wasn't actually checking that the
machine constraints had given permission to enable the regulator.
Add code to do that, but only if the regulator is not already on
due to something like always_on or being left on at startup since
in those cases there's no physical change being introduced and the
constraint wouldn't make any sense.

Also add matching code for disable(). We need to do less there since
either regulator_enable() should have succeeded first or the board
setup makes no sense.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   56 +++++++++++++++++++++++++++++----------------
 1 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 60fcd98..dbf27bf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1191,16 +1191,21 @@ void regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(regulator_put);
 
+static int _regulator_can_change_status(struct regulator_dev *rdev)
+{
+	if (!rdev->constraints)
+		return 0;
+
+	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_STATUS)
+		return 1;
+	else
+		return 0;
+}
+
 /* locks held by regulator_enable() */
 static int _regulator_enable(struct regulator_dev *rdev)
 {
-	int ret = -EINVAL;
-
-	if (!rdev->constraints) {
-		printk(KERN_ERR "%s: %s has no constraints\n",
-		       __func__, rdev->desc->name);
-		return ret;
-	}
+	int ret;
 
 	/* do we need to enable the supply regulator first */
 	if (rdev->supply) {
@@ -1213,24 +1218,34 @@ static int _regulator_enable(struct regulator_dev *rdev)
 	}
 
 	/* check voltage and requested load before enabling */
-	if (rdev->desc->ops->enable) {
+	if (rdev->constraints &&
+	    (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS))
+		drms_uA_update(rdev);
 
-		if (rdev->constraints &&
-			(rdev->constraints->valid_ops_mask &
-			REGULATOR_CHANGE_DRMS))
-			drms_uA_update(rdev);
-
-		ret = rdev->desc->ops->enable(rdev);
-		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to enable %s: %d\n",
+	if (rdev->use_count == 0) {
+		/* The regulator may on if it's not switchable or left on */
+		ret = _regulator_is_enabled(rdev);
+		if (ret == -EINVAL || ret == 0) {
+			if (!_regulator_can_change_status(rdev))
+				return -EPERM;
+
+			if (rdev->desc->ops->enable) {
+				ret = rdev->desc->ops->enable(rdev);
+				if (ret < 0)
+					return ret;
+			} else {
+				return -EINVAL;
+			}
+		} else {
+			printk(KERN_ERR "%s: is_enabled() failed for %s: %d\n",
 			       __func__, rdev->desc->name, ret);
 			return ret;
 		}
-		rdev->use_count++;
-		return ret;
 	}
 
-	return ret;
+	rdev->use_count++;
+
+	return 0;
 }
 
 /**
@@ -1270,7 +1285,8 @@ static int _regulator_disable(struct regulator_dev *rdev)
 	if (rdev->use_count == 1 && !rdev->constraints->always_on) {
 
 		/* we are last user */
-		if (rdev->desc->ops->disable) {
+		if (_regulator_can_change_status(rdev) &&
+		    rdev->desc->ops->disable) {
 			ret = rdev->desc->ops->disable(rdev);
 			if (ret < 0) {
 				printk(KERN_ERR "%s: failed to disable %s\n",
-- 
1.6.3.3

