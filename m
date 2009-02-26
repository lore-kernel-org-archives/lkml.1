Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZBZTYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZBZTYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZBZTYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:24:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35106 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752379AbZBZTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:24:24 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Allow regulators to set the initial operating mode
Date: Thu, 26 Feb 2009 19:24:19 +0000
Message-Id: <1235676260-19696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful when wishing to run in a fixed operating mode that isn't
the default.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c          |   17 +++++++++++++++++
 include/linux/regulator/machine.h |    4 ++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d55a25a..75abcd8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -724,6 +724,23 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
+	if (constraints->initial_mode) {
+		if (!ops->set_mode) {
+			printk(KERN_ERR "%s: no set_mode operation for %s\n",
+			       __func__, name);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = ops->set_mode(rdev, constraints->initial_mode);
+		if (ret < 0) {
+			printk(KERN_ERR
+			       "%s: failed to set initial mode for %s: %d\n",
+			       __func__, name, ret);
+			goto out;
+		}
+	}
+
 	/* if always_on is set then turn the regulator on if it's not
 	 * already on. */
 	if (constraints->always_on && ops->enable &&
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 5aa00ee..1eb861c 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -83,6 +83,7 @@ struct regulator_state {
  * @state_standby: State for regulator when system is suspended in standby
  *                 mode.
  * @initial_state: Suspend state to set by default.
+ * @initial_mode: Mode to set at startup.
  */
 struct regulation_constraints {
 
@@ -111,6 +112,9 @@ struct regulation_constraints {
 	struct regulator_state state_standby;
 	suspend_state_t initial_state; /* suspend state to set at init */
 
+	/* mode to set on startup */
+	unsigned int initial_mode;
+
 	/* constriant flags */
 	unsigned always_on:1;	/* regulator never off when system is on */
 	unsigned boot_on:1;	/* bootloader/firmware enabled regulator */
-- 
1.6.1.3

