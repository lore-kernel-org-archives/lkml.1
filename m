Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbZAUOIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbZAUOIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZAUOIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:08:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38038 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753282AbZAUOIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:08:42 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Hoist struct regulator_dev out of core to fix notifiers
Date: Wed, 21 Jan 2009 14:08:40 +0000
Message-Id: <1232546920-14915-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 872ed3fe176833f7d43748eb88010da4bbd2f983 caused regulator drivers
to take the struct regulator_dev lock themselves which requires that the
struct be visible to them. Band aid this by making the struct visible.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   27 ---------------------------
 include/linux/regulator/driver.h |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f17362a..0ed13c2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -30,33 +30,6 @@ static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
 
 /*
- * struct regulator_dev
- *
- * Voltage / Current regulator class device. One for each regulator.
- */
-struct regulator_dev {
-	struct regulator_desc *desc;
-	int use_count;
-
-	/* lists we belong to */
-	struct list_head list; /* list of all regulators */
-	struct list_head slist; /* list of supplied regulators */
-
-	/* lists we own */
-	struct list_head consumer_list; /* consumers we supply */
-	struct list_head supply_list; /* regulators we supply */
-
-	struct blocking_notifier_head notifier;
-	struct mutex mutex; /* consumer lock */
-	struct module *owner;
-	struct device dev;
-	struct regulation_constraints *constraints;
-	struct regulator_dev *supply;	/* for tree */
-
-	void *reg_data;		/* regulator_dev data */
-};
-
-/*
  * struct regulator_map
  *
  * Used to provide symbolic supply names to devices.
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 2254ad9..c263e36 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -137,6 +137,38 @@ struct regulator_desc {
 	struct module *owner;
 };
 
+/*
+ * struct regulator_dev
+ *
+ * Voltage / Current regulator class device. One for each
+ * regulator.
+ *
+ * This should *not* be used directly by anything except the regulator
+ * core and notification injection (which should take the mutex and do
+ * no other direct access).
+ */
+struct regulator_dev {
+	struct regulator_desc *desc;
+	int use_count;
+
+	/* lists we belong to */
+	struct list_head list; /* list of all regulators */
+	struct list_head slist; /* list of supplied regulators */
+
+	/* lists we own */
+	struct list_head consumer_list; /* consumers we supply */
+	struct list_head supply_list; /* regulators we supply */
+
+	struct blocking_notifier_head notifier;
+	struct mutex mutex; /* consumer lock */
+	struct module *owner;
+	struct device dev;
+	struct regulation_constraints *constraints;
+	struct regulator_dev *supply;	/* for tree */
+
+	void *reg_data;		/* regulator_dev data */
+};
+
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	struct device *dev, struct regulator_init_data *init_data,
 	void *driver_data);
-- 
1.5.6.5

