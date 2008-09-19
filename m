Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYISRke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYISRke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYISRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:40:13 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:45770 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbYISRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:40:11 -0400
Subject: [PATCH 4/6] regulator: Additional diagnostics for machine
	constraints
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 18:40:11 +0100
Message-Id: <1221846011.6892.138.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to find a human readable name for the regulator we're failing on and
print a specific diagnostic when we fail to set the suspend state.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/regulator/core.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f5fcdf7..b1b2518 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -669,6 +669,14 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	struct regulation_constraints *constraints)
 {
 	int ret = 0;
+	const char *name;
+
+	if (constraints->name)
+		name = constraints->name;
+	else if (rdev->desc->name)
+		name = rdev->desc->name;
+	else
+		name = "regulator";
 
 	rdev->constraints = constraints;
 
@@ -679,9 +687,9 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		ret = rdev->desc->ops->set_voltage(rdev,
 			rdev->constraints->min_uV, rdev->constraints->max_uV);
 			if (ret < 0) {
-				printk(KERN_ERR "%s: failed to apply %duV"
-					" constraint\n", __func__,
-					rdev->constraints->min_uV);
+				printk(KERN_ERR "%s: failed to apply %duV constraint to %s\n",
+				       __func__,
+				       rdev->constraints->min_uV, name);
 				rdev->constraints = NULL;
 				goto out;
 			}
@@ -692,8 +700,15 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		rdev->use_count = 1;
 
 	/* do we need to setup our suspend state */
-	if (constraints->initial_state)
+	if (constraints->initial_state) {
 		ret = suspend_prepare(rdev, constraints->initial_state);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: failed to set suspend state for %s\n",
+			       __func__, name);
+			rdev->constraints = NULL;
+			goto out;
+		}
+	}
 
 	print_constraints(rdev);
 out:
-- 
1.5.4.3


