Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbYISRks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbYISRks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYISRkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:40:18 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:45772 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbYISRkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:40:16 -0400
Subject: [PATCH 5/6] regulator: Enable regulators marked as always_on
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 18:40:16 +0100
Message-Id: <1221846016.6892.139.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the machine constraints mark a regulator as always_on but this was
not done by the bootloader then enable the regulator when applying
constraints.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/regulator/core.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b1b2518..ba4f2ce 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -670,6 +670,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 {
 	int ret = 0;
 	const char *name;
+	struct regulator_ops *ops = rdev->desc->ops;
 
 	if (constraints->name)
 		name = constraints->name;
@@ -683,8 +684,8 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 	/* do we need to apply the constraint voltage */
 	if (rdev->constraints->apply_uV &&
 		rdev->constraints->min_uV == rdev->constraints->max_uV &&
-		rdev->desc->ops->set_voltage) {
-		ret = rdev->desc->ops->set_voltage(rdev,
+		ops->set_voltage) {
+		ret = ops->set_voltage(rdev,
 			rdev->constraints->min_uV, rdev->constraints->max_uV);
 			if (ret < 0) {
 				printk(KERN_ERR "%s: failed to apply %duV constraint to %s\n",
@@ -710,6 +711,20 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
+	/* if always_on is set then turn the regulator on if it's not
+	 * already on. */
+	if (constraints->always_on && ops->enable &&
+	    ((ops->is_enabled && !ops->is_enabled(rdev)) ||
+	     (!ops->is_enabled && !constraints->boot_on))) {
+		ret = ops->enable(rdev);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: failed to enable %s\n",
+			       __func__, name);
+			rdev->constraints = NULL;
+			goto out;
+		}
+	}
+
 	print_constraints(rdev);
 out:
 	return ret;
-- 
1.5.4.3


