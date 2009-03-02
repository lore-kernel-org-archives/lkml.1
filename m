Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZCBQdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZCBQdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbZCBQcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:32:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36842 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754165AbZCBQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:32:50 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Allow boot_on regulators to be disabled by clients
Date: Mon,  2 Mar 2009 16:32:46 +0000
Message-Id: <1236011567-31311-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than incrementing the reference count for boot_on regulators
(which prevents them being disabled later on) simply force the
regulator to be enabled when applying the constraints. Previously
boot_on was essentially equivalent to always_on.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c          |   13 ++++---------
 include/linux/regulator/machine.h |    4 +++-
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index da357a0..464e9b1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -772,10 +772,6 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 			}
 	}
 
-	/* are we enabled at boot time by firmware / bootloader */
-	if (rdev->constraints->boot_on)
-		rdev->use_count = 1;
-
 	/* do we need to setup our suspend state */
 	if (constraints->initial_state) {
 		ret = suspend_prepare(rdev, constraints->initial_state);
@@ -804,11 +800,10 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
-	/* if always_on is set then turn the regulator on if it's not
-	 * already on. */
-	if (constraints->always_on && ops->enable &&
-	    ((ops->is_enabled && !ops->is_enabled(rdev)) ||
-	     (!ops->is_enabled && !constraints->boot_on))) {
+	/* If the constraints say the regulator should be on at this point
+	 * and we have control then make sure it is enabled.
+	 */
+	if ((constraints->always_on || constraints->boot_on) && ops->enable) {
 		ret = ops->enable(rdev);
 		if (ret < 0) {
 			printk(KERN_ERR "%s: failed to enable %s\n",
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 1eb861c..5de7aa3 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -73,7 +73,9 @@ struct regulator_state {
  *
  * @always_on: Set if the regulator should never be disabled.
  * @boot_on: Set if the regulator is enabled when the system is initially
- *           started.
+ *           started.  If the regulator is not enabled by the hardware or
+ *           bootloader then it will be enabled when the constraints are
+ *           applied.
  * @apply_uV: Apply the voltage constraint when initialising.
  *
  * @input_uV: Input voltage for regulator when supplied by another regulator.
-- 
1.6.1.3

