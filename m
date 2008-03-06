Return-Path: <linux-kernel-owner+w=401wt.eu-S935477AbYCFSM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935477AbYCFSM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935609AbYCFSLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:11:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42918 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935606AbYCFSLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:11:12 -0500
Subject: UPDATED v3][PATCH 2/7] regulator: regulator driver interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 18:11:09 +0000
Message-Id: <1204827069.15360.148.camel@a10323.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface allows regulator drivers to register their voltage and current
regulators with the core. It also has a notifier call chain for propagating
regulator events to clients.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 include/linux/regulator/regulator-drv.h |   85 +++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/regulator/regulator-drv.h

diff --git a/include/linux/regulator/regulator-drv.h b/include/linux/regulator/regulator-drv.h
new file mode 100644
index 0000000..3230689
--- /dev/null
+++ b/include/linux/regulator/regulator-drv.h
@@ -0,0 +1,85 @@
+/*
+ * regulator-drv.h -- SoC Regulator support.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Driver Interface.
+ */
+
+#ifndef __LINUX_REGULATOR_DRV_H_
+#define __LINUX_REGULATOR_DRV_H_
+
+#include <linux/device.h>
+#include <linux/regulator/regulator.h>
+
+struct regulator_constraints;
+struct regulator_cdev;
+
+/**
+ * struct regulator_ops - regulator operations.
+ *
+ * This struct describes regulator operations.
+ */
+struct regulator_ops {
+
+	/* get/set regulator voltage */
+	int (*set_voltage) (struct regulator_cdev *, int uV);
+	int (*get_voltage) (struct regulator_cdev *);
+
+	/* get/set regulator current  */
+	int (*set_current) (struct regulator_cdev *, int uA);
+	int (*get_current) (struct regulator_cdev *);
+
+	/* enable/disable regulator */
+	int (*enable) (struct regulator_cdev *);
+	int (*disable) (struct regulator_cdev *);
+	int (*is_enabled) (struct regulator_cdev *);
+
+	/* get/set regulator operating mode (defined in regulator.h) */
+	int (*set_mode) (struct regulator_cdev *, unsigned int mode);
+	unsigned int (*get_mode) (struct regulator_cdev *);
+
+	/* get most efficient regulator operating mode for load */
+	unsigned int (*get_optimum_mode) (struct regulator_cdev *, int input_uV,
+					  int output_uV, int load_uA);
+};
+
+/*
+ * Regulators can either control voltage or current.
+ */
+enum regulator_type {
+	REGULATOR_VOLTAGE,
+	REGULATOR_CURRENT,
+};
+
+/**
+ * struct regulator_desc - Regulator descriptor
+ *
+ */
+struct regulator_desc {
+	const char *name;
+	int id;
+	struct regulator_ops *ops;
+	int irq;
+	enum regulator_type type;
+	struct module *owner;
+};
+
+
+struct regulator_cdev *regulator_register(struct regulator_desc *regulator_desc,
+					  void *reg_data);
+void regulator_unregister(struct regulator_cdev *rcdev);
+
+int regulator_notifier_call_chain(struct regulator_cdev *rcdev,
+				  unsigned long event, void *data);
+
+void *rcdev_get_drvdata(struct regulator_cdev *rcdev);
+int rcdev_get_id(struct regulator_cdev *rcdev);
+
+#endif
-- 
1.5.4.3



