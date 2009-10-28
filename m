Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZJ1QaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZJ1QaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZJ1QaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:30:21 -0400
Received: from mail.df.lth.se ([194.47.250.12]:59901 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754230AbZJ1QaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:30:20 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] Fix some AB3100 regulator issues
Date: Wed, 28 Oct 2009 17:30:15 +0100
Message-Id: <1256747415-18486-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will remove surplus register writes on shut down of
LDO D (this magic was not needed), remove an unnecessary (!) error
check and really unregister the regulators when the module is
unloaded.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/ab3100.c |   23 ++---------------------
 1 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 5da127b..b349db4 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -241,24 +241,12 @@ static int ab3100_disable_regulator(struct regulator_dev *reg)
 	 * LDO D is a special regulator. When it is disabled, the entire
 	 * system is shut down. So this is handled specially.
 	 */
+	pr_info("Called ab3100_disable_regulator\n");
 	if (abreg->regreg == AB3100_LDO_D) {
-		int i;
-
 		dev_info(&reg->dev, "disabling LDO D - shut down system\n");
-		/*
-		 * Set regulators to default values, ignore any errors,
-		 * we're going DOWN
-		 */
-		for (i = 0; i < ARRAY_SIZE(ab3100_reg_init_order); i++) {
-			(void) ab3100_set_register_interruptible(abreg->ab3100,
-					ab3100_reg_init_order[i],
-					abreg->plfdata->reg_initvals[i]);
-		}
-
 		/* Setting LDO D to 0x00 cuts the power to the SoC */
 		return ab3100_set_register_interruptible(abreg->ab3100,
 							 AB3100_LDO_D, 0x00U);
-
 	}
 
 	/*
@@ -607,13 +595,6 @@ static int __init ab3100_regulators_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (err) {
-		dev_err(&pdev->dev,
-			"LDO D regulator initialization failed with error %d\n",
-			err);
-		return err;
-	}
-
 	/* Register the regulators */
 	for (i = 0; i < AB3100_NUM_REGULATORS; i++) {
 		struct ab3100_regulator *reg = &ab3100_regulators[i];
@@ -688,7 +669,7 @@ static __init int ab3100_regulators_init(void)
 
 static __exit void ab3100_regulators_exit(void)
 {
-	platform_driver_register(&ab3100_regulators_driver);
+	platform_driver_unregister(&ab3100_regulators_driver);
 }
 
 subsys_initcall(ab3100_regulators_init);
-- 
1.6.3.3

