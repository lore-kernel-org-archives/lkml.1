Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZJVPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZJVPcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZJVPbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:31:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41211 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756517AbZJVPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:31:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] regulator: Also lift apply_uV into machine_constraints_voltage()
Date: Thu, 22 Oct 2009 16:31:30 +0100
Message-Id: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes sense to do all the voltage configuration in the one split
out function.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c1a4991..1848a3f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -676,6 +676,22 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 	const char *name, struct regulation_constraints *constraints)
 {
 	struct regulator_ops *ops = rdev->desc->ops;
+	int ret;
+
+	/* do we need to apply the constraint voltage */
+	if (rdev->constraints->apply_uV &&
+		rdev->constraints->min_uV == rdev->constraints->max_uV &&
+		ops->set_voltage) {
+		ret = ops->set_voltage(rdev,
+			rdev->constraints->min_uV, rdev->constraints->max_uV);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: failed to apply %duV constraint to %s\n",
+				       __func__,
+				       rdev->constraints->min_uV, name);
+				rdev->constraints = NULL;
+				return ret;
+			}
+	}
 
 	/* constrain machine-level voltage specs to fit
 	 * the actual range supported by this regulator.
@@ -773,27 +789,12 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	else
 		name = "regulator";
 
+	rdev->constraints = constraints;
+
 	ret = machine_constraints_voltage(rdev, name, constraints);
 	if (ret != 0)
 		goto out;
 
-	rdev->constraints = constraints;
-
-	/* do we need to apply the constraint voltage */
-	if (rdev->constraints->apply_uV &&
-		rdev->constraints->min_uV == rdev->constraints->max_uV &&
-		ops->set_voltage) {
-		ret = ops->set_voltage(rdev,
-			rdev->constraints->min_uV, rdev->constraints->max_uV);
-			if (ret < 0) {
-				printk(KERN_ERR "%s: failed to apply %duV constraint to %s\n",
-				       __func__,
-				       rdev->constraints->min_uV, name);
-				rdev->constraints = NULL;
-				goto out;
-			}
-	}
-
 	/* do we need to setup our suspend state */
 	if (constraints->initial_state) {
 		ret = suspend_prepare(rdev, constraints->initial_state);
-- 
1.6.5

