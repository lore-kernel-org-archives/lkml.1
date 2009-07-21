Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZGUPAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZGUPAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZGUPAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:00:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42570 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752961AbZGUPAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:00:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] regulator: Add regulator_get_exclusive() API
Date: Tue, 21 Jul 2009 16:00:23 +0100
Message-Id: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some consumers require complete control of the regulator and can't
tolerate sharing it with other consumers, most commonly because they need
to have the regulator actually disabled so can't have other consumers
forcing it on. This new regulator_get_exclusive() API call allows these
consumers to explicitly request this, documenting the assumptions that
they are making.

In order to simplify coding of such consumers the use count for regulators
they request is forced to match the enabled state of the regulator when
it is requested. This is not possible for consumers which can share
regulators due to the need to keep track of the ownership of use counts.

A new API call is used rather than an additional argument to the existing
regulator_get() in order to avoid merge headaches with driver code in
other trees.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |   88 ++++++++++++++++++++++++++++++------
 include/linux/regulator/consumer.h |    2 +
 include/linux/regulator/driver.h   |    2 +
 3 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index eed62ad..8445524 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1025,25 +1025,15 @@ overflow_err:
 	return NULL;
 }
 
-/**
- * regulator_get - lookup and obtain a reference to a regulator.
- * @dev: device for regulator "consumer"
- * @id: Supply name or regulator ID.
- *
- * Returns a struct regulator corresponding to the regulator producer,
- * or IS_ERR() condition containing errno.
- *
- * Use of supply names configured via regulator_set_device_supply() is
- * strongly encouraged.  It is recommended that the supply name used
- * should match the name used for the supply and/or the relevant
- * device pins in the datasheet.
- */
-struct regulator *regulator_get(struct device *dev, const char *id)
+/* Internal regulator request function */
+static struct regulator *_regulator_get(struct device *dev, const char *id,
+					int exclusive)
 {
 	struct regulator_dev *rdev;
 	struct regulator_map *map;
 	struct regulator *regulator = ERR_PTR(-ENODEV);
 	const char *devname = NULL;
+	int ret;
 
 	if (id == NULL) {
 		printk(KERN_ERR "regulator: get() with no identifier\n");
@@ -1070,6 +1060,16 @@ struct regulator *regulator_get(struct device *dev, const char *id)
 	return regulator;
 
 found:
+	if (rdev->exclusive) {
+		regulator = ERR_PTR(-EPERM);
+		goto out;
+	}
+
+	if (exclusive && rdev->open_count) {
+		regulator = ERR_PTR(-EBUSY);
+		goto out;
+	}
+
 	if (!try_module_get(rdev->owner))
 		goto out;
 
@@ -1079,13 +1079,70 @@ found:
 		module_put(rdev->owner);
 	}
 
+	rdev->open_count++;
+	if (exclusive) {
+		rdev->exclusive = 1;
+
+		ret = _regulator_is_enabled(rdev);
+		if (ret > 0)
+			rdev->use_count = 1;
+		else
+			rdev->use_count = 0;
+	}
+
 out:
 	mutex_unlock(&regulator_list_mutex);
+
 	return regulator;
 }
+
+/**
+ * regulator_get - lookup and obtain a reference to a regulator.
+ * @dev: device for regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Returns a struct regulator corresponding to the regulator producer,
+ * or IS_ERR() condition containing errno.
+ *
+ * Use of supply names configured via regulator_set_device_supply() is
+ * strongly encouraged.  It is recommended that the supply name used
+ * should match the name used for the supply and/or the relevant
+ * device pins in the datasheet.
+ */
+struct regulator *regulator_get(struct device *dev, const char *id)
+{
+	return _regulator_get(dev, id, 0);
+}
 EXPORT_SYMBOL_GPL(regulator_get);
 
 /**
+ * regulator_get_exclusive - obtain exclusive access to a regulator.
+ * @dev: device for regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Returns a struct regulator corresponding to the regulator producer,
+ * or IS_ERR() condition containing errno.  Other consumers will be
+ * unable to obtain this reference is held and the use count for the
+ * regulator will be initialised to reflect the current state of the
+ * regulator.
+ *
+ * This is intended for use by consumers which cannot tolerate shared
+ * use of the regulator such as those which need to force the
+ * regulator off for correct operation of the hardware they are
+ * controlling.
+ *
+ * Use of supply names configured via regulator_set_device_supply() is
+ * strongly encouraged.  It is recommended that the supply name used
+ * should match the name used for the supply and/or the relevant
+ * device pins in the datasheet.
+ */
+struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
+{
+	return _regulator_get(dev, id, 1);
+}
+EXPORT_SYMBOL_GPL(regulator_get_exclusive);
+
+/**
  * regulator_put - "free" the regulator source
  * @regulator: regulator source
  *
@@ -1113,6 +1170,9 @@ void regulator_put(struct regulator *regulator)
 	list_del(&regulator->list);
 	kfree(regulator);
 
+	rdev->open_count--;
+	rdev->exclusive = 0;
+
 	module_put(rdev->owner);
 	mutex_unlock(&regulator_list_mutex);
 }
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 277f4b9..976b57b 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -125,6 +125,8 @@ struct regulator_bulk_data {
 /* regulator get and put */
 struct regulator *__must_check regulator_get(struct device *dev,
 					     const char *id);
+struct regulator *__must_check regulator_get_exclusive(struct device *dev,
+						       const char *id);
 void regulator_put(struct regulator *regulator);
 
 /* regulator output control and status */
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 225f733..60efbd1 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -162,6 +162,8 @@ struct regulator_desc {
 struct regulator_dev {
 	struct regulator_desc *desc;
 	int use_count;
+	int open_count;
+	int exclusive;
 
 	/* lists we belong to */
 	struct list_head list; /* list of all regulators */
-- 
1.6.3.3

