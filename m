Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZHCRuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZHCRuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZHCRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:50:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37457 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752880AbZHCRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:49:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/5] regulator: Push locking for regulator_is_enabled() out
Date: Mon,  3 Aug 2009 18:49:56 +0100
Message-Id: <1249321797-4582-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249321797-4582-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1249321797-4582-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249321797-4582-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249321797-4582-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows use by more of the internal regulator API code.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dfbf431..60fcd98 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -280,8 +280,13 @@ static ssize_t regulator_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
+	ssize_t ret;
+
+	mutex_lock(&rdev->mutex);
+	ret = regulator_print_state(buf, _regulator_is_enabled(rdev));
+	mutex_unlock(&rdev->mutex);
 
-	return regulator_print_state(buf, _regulator_is_enabled(rdev));
+	return ret;
 }
 static DEVICE_ATTR(state, 0444, regulator_state_show, NULL);
 
@@ -1365,20 +1370,11 @@ EXPORT_SYMBOL_GPL(regulator_force_disable);
 
 static int _regulator_is_enabled(struct regulator_dev *rdev)
 {
-	int ret;
-
-	mutex_lock(&rdev->mutex);
-
 	/* sanity check */
-	if (!rdev->desc->ops->is_enabled) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!rdev->desc->ops->is_enabled)
+		return -EINVAL;
 
-	ret = rdev->desc->ops->is_enabled(rdev);
-out:
-	mutex_unlock(&rdev->mutex);
-	return ret;
+	return rdev->desc->ops->is_enabled(rdev);
 }
 
 /**
@@ -1395,7 +1391,13 @@ out:
  */
 int regulator_is_enabled(struct regulator *regulator)
 {
-	return _regulator_is_enabled(regulator->rdev);
+	int ret;
+
+	mutex_lock(&regulator->rdev->mutex);
+	ret = _regulator_is_enabled(regulator->rdev);
+	mutex_unlock(&regulator->rdev->mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_is_enabled);
 
-- 
1.6.3.3

