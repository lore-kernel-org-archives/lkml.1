Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZJVPbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZJVPbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbZJVPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:31:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41213 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756040AbZJVPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:31:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/6] regulator: Handle regulators without suspend mode configuration
Date: Thu, 22 Oct 2009 16:31:33 +0100
Message-Id: <1256225495-15379-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since some regulators in the system may not support suspend mode
configuration we need to allow some regulators to have a missing
suspend mode configuration. Do this by requiring that disabled
regulators are explicitly flagged and then skip over regulators
that have no state specified.

Try to avoid surprises by warning the if we could set the state
but no configuration is provided.  This also ensures that an all
zeros configuration generates a warning rather than silently
disabling the regulator.

Reported-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c          |   25 ++++++++++++++++++++++---
 include/linux/regulator/machine.h |    6 +++++-
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 7d0c0d7..2dab0d9 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -581,10 +581,29 @@ static int suspend_set_state(struct regulator_dev *rdev,
 	struct regulator_state *rstate)
 {
 	int ret = 0;
+	bool can_set_state;
 
-	/* enable & disable are mandatory for suspend control */
-	if (!rdev->desc->ops->set_suspend_enable ||
-		!rdev->desc->ops->set_suspend_disable) {
+	can_set_state = rdev->desc->ops->set_suspend_enable &&
+		rdev->desc->ops->set_suspend_disable;
+
+	/* If we have no suspend mode configration don't set anything;
+	 * only warn if the driver actually makes the suspend mode
+	 * configurable.
+	 */
+	if (!rstate->enabled && !rstate->disabled) {
+		if (can_set_state)
+			printk(KERN_WARNING "%s: No configuration for %s\n",
+			       __func__, rdev_get_name(rdev));
+		return 0;
+	}
+
+	if (rstate->enabled && rstate->disabled) {
+		printk(KERN_ERR "%s: invalid configuration for %s\n",
+		       __func__, rdev_get_name(rdev));
+		return -EINVAL;
+	}
+
+	if (!can_set_state) {
 		printk(KERN_ERR "%s: no way to set suspend state\n",
 			__func__);
 		return -EINVAL;
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 87f5f17..234a847 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -43,16 +43,20 @@ struct regulator;
 /**
  * struct regulator_state - regulator state during low power system states
  *
- * This describes a regulators state during a system wide low power state.
+ * This describes a regulators state during a system wide low power
+ * state.  One of enabled or disabled must be set for the
+ * configuration to be applied.
  *
  * @uV: Operating voltage during suspend.
  * @mode: Operating mode during suspend.
  * @enabled: Enabled during suspend.
+ * @disabled: Disabled during suspend.
  */
 struct regulator_state {
 	int uV;	/* suspend voltage */
 	unsigned int mode; /* suspend regulator operating mode */
 	int enabled; /* is regulator enabled in this suspend state */
+	int disabled; /* is the regulator disbled in this suspend state */
 };
 
 /**
-- 
1.6.5

