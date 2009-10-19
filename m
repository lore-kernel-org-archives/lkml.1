Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZJSOxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZJSOxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbZJSOxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:53:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37810 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756134AbZJSOxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:53:47 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Factor out voltage constraint setup
Date: Mon, 19 Oct 2009 15:53:50 +0100
Message-Id: <1255964030-12147-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows constraints to take effect on regulators that support
voltage setting but for which the board does not specify a voltage
range (for example, because it is fixed correctly at system startup).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   64 ++++++++++++++++++++++++++-------------------
 1 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 744ea1d..282ff1f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -672,31 +672,11 @@ static void print_constraints(struct regulator_dev *rdev)
 	printk(KERN_INFO "regulator: %s: %s\n", rdev->desc->name, buf);
 }
 
-/**
- * set_machine_constraints - sets regulator constraints
- * @rdev: regulator source
- * @constraints: constraints to apply
- *
- * Allows platform initialisation code to define and constrain
- * regulator circuits e.g. valid voltage/current ranges, etc.  NOTE:
- * Constraints *must* be set by platform code in order for some
- * regulator operations to proceed i.e. set_voltage, set_current_limit,
- * set_mode.
- */
-static int set_machine_constraints(struct regulator_dev *rdev,
-	struct regulation_constraints *constraints)
+static int machine_constraints_voltage(struct regulator_dev *rdev,
+	const char *name, struct regulation_constraints *constraints)
 {
-	int ret = 0;
-	const char *name;
 	struct regulator_ops *ops = rdev->desc->ops;
 
-	if (constraints->name)
-		name = constraints->name;
-	else if (rdev->desc->name)
-		name = rdev->desc->name;
-	else
-		name = "regulator";
-
 	/* constrain machine-level voltage specs to fit
 	 * the actual range supported by this regulator.
 	 */
@@ -719,14 +699,13 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 
 		/* voltage constraints are optional */
 		if ((cmin == 0) && (cmax == 0))
-			goto out;
+			return 0;
 
 		/* else require explicit machine-level constraints */
 		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
 			pr_err("%s: %s '%s' voltage constraints\n",
 				       __func__, "invalid", name);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		/* initial: [cmin..cmax] valid, [min_uV..max_uV] not */
@@ -748,8 +727,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		if (max_uV < min_uV) {
 			pr_err("%s: %s '%s' voltage constraints\n",
 				       __func__, "unsupportable", name);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		/* use regulator's subset of machine constraints */
@@ -767,6 +745,38 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
+	return 0;
+}
+
+/**
+ * set_machine_constraints - sets regulator constraints
+ * @rdev: regulator source
+ * @constraints: constraints to apply
+ *
+ * Allows platform initialisation code to define and constrain
+ * regulator circuits e.g. valid voltage/current ranges, etc.  NOTE:
+ * Constraints *must* be set by platform code in order for some
+ * regulator operations to proceed i.e. set_voltage, set_current_limit,
+ * set_mode.
+ */
+static int set_machine_constraints(struct regulator_dev *rdev,
+	struct regulation_constraints *constraints)
+{
+	int ret = 0;
+	const char *name;
+	struct regulator_ops *ops = rdev->desc->ops;
+
+	if (constraints->name)
+		name = constraints->name;
+	else if (rdev->desc->name)
+		name = rdev->desc->name;
+	else
+		name = "regulator";
+
+	ret = machine_constraints_voltage(rdev, name, constraints);
+	if (ret != 0)
+		goto out;
+
 	rdev->constraints = constraints;
 
 	/* do we need to apply the constraint voltage */
-- 
1.6.5

