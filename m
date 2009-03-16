Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbZCPThi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbZCPThi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761523AbZCPTgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:36:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46144 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761525AbZCPTgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:36:38 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Support disabling of unused regulators by machines
Date: Mon, 16 Mar 2009 19:36:34 +0000
Message-Id: <1237232194-24113-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1237232194-24113-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1237232194-24113-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present it is not possible for machine constraints to disable
regulators which have been left on when the system starts, for example
as a result of fixed default configurations in hardware. This means that
power may be wasted by these regulators if they are not in use.

Provide intial support for this with a late_initcall which will disable
any unused regulators if the machine has enabled this feature by calling
regulator_has_full_constraints(). If this has not been called then print
a warning to encourage users to fully specify their constraints so that
we can change this to be the default behaviour in future.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c          |   92 +++++++++++++++++++++++++++++++++++++
 include/linux/regulator/machine.h |    2 +
 2 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8588a24..01f7702 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -28,6 +28,7 @@
 static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
+static int has_full_constraints;
 
 /*
  * struct regulator_map
@@ -2143,6 +2144,23 @@ out:
 EXPORT_SYMBOL_GPL(regulator_suspend_prepare);
 
 /**
+ * regulator_has_full_constraints - the system has fully specified constraints
+ *
+ * Calling this function will cause the regulator API to disable all
+ * regulators which have a zero use count and don't have an always_on
+ * constraint in a late_initcall.
+ *
+ * The intention is that this will become the default behaviour in a
+ * future kernel release so users are encouraged to use this facility
+ * now.
+ */
+void regulator_has_full_constraints(void)
+{
+	has_full_constraints = 1;
+}
+EXPORT_SYMBOL_GPL(regulator_has_full_constraints);
+
+/**
  * rdev_get_drvdata - get rdev regulator driver data
  * @rdev: regulator
  *
@@ -2209,3 +2227,77 @@ static int __init regulator_init(void)
 
 /* init early to allow our consumers to complete system booting */
 core_initcall(regulator_init);
+
+static int __init regulator_init_complete(void)
+{
+	struct regulator_dev *rdev;
+	struct regulator_ops *ops;
+	struct regulation_constraints *c;
+	int enabled, ret;
+	const char *name;
+
+	mutex_lock(&regulator_list_mutex);
+
+	/* If we have a full configuration then disable any regulators
+	 * which are not in use or always_on.  This will become the
+	 * default behaviour in the future.
+	 */
+	list_for_each_entry(rdev, &regulator_list, list) {
+		ops = rdev->desc->ops;
+		c = rdev->constraints;
+
+		if (c->name)
+			name = c->name;
+		else if (rdev->desc->name)
+			name = rdev->desc->name;
+		else
+			name = "regulator";
+
+		if (!ops->disable || c->always_on)
+			continue;
+
+		mutex_lock(&rdev->mutex);
+
+		if (rdev->use_count)
+			goto unlock;
+
+		/* If we can't read the status assume it's on. */
+		if (ops->is_enabled)
+			enabled = ops->is_enabled(rdev);
+		else
+			enabled = 1;
+
+		if (!enabled)
+			goto unlock;
+
+		if (has_full_constraints) {
+			/* We log since this may kill the system if it
+			 * goes wrong. */
+			printk(KERN_INFO "%s: disabling %s\n",
+			       __func__, name);
+			ret = ops->disable(rdev);
+			if (ret != 0) {
+				printk(KERN_ERR
+				       "%s: couldn't disable %s: %d\n",
+				       __func__, name, ret);
+			}
+		} else {
+			/* The intention is that in future we will
+			 * assume that full constraints are provided
+			 * so warn even if we aren't going to do
+			 * anything here.
+			 */
+			printk(KERN_WARNING
+			       "%s: incomplete constraints, leaving %s on\n",
+			       __func__, name);
+		}
+
+unlock:
+		mutex_unlock(&rdev->mutex);
+	}
+
+	mutex_unlock(&regulator_list_mutex);
+
+	return 0;
+}
+late_initcall(regulator_init_complete);
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 5de7aa3..bac64fa 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -166,4 +166,6 @@ struct regulator_init_data {
 
 int regulator_suspend_prepare(suspend_state_t state);
 
+void regulator_has_full_constraints(void);
+
 #endif
-- 
1.6.2

