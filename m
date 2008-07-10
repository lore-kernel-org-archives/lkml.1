Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYGJP0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYGJP0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758457AbYGJPZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:25:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55101 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758424AbYGJPZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:25:47 -0400
Subject: [PATCH 02/15] regulator: regulator driver interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:25:46 +0100
Message-Id: <1215703546.13431.58.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows regulator drivers to register their regulators and provide
operations to the core. It also has a notifier call chain for propagating
regulator events to clients.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/driver.h |   86 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/regulator/driver.h

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
new file mode 100644
index 0000000..1c02362
--- /dev/null
+++ b/include/linux/regulator/driver.h
@@ -0,0 +1,86 @@
+/*
+ * driver.h -- SoC Regulator driver support.
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
+#ifndef __LINUX_REGULATOR_DRIVER_H_
+#define __LINUX_REGULATOR_DRIVER_H_
+
+#include <linux/device.h>
+#include <linux/regulator/consumer.h>
+
+struct regulator_constraints;
+struct regulator_dev;
+
+/**
+ * struct regulator_ops - regulator operations.
+ *
+ * This struct describes regulator operations.
+ */
+struct regulator_ops {
+
+	/* get/set regulator voltage */
+	int (*set_voltage) (struct regulator_dev *, int min_uV, int max_uV);
+	int (*get_voltage) (struct regulator_dev *);
+
+	/* get/set regulator current  */
+	int (*set_current_limit) (struct regulator_dev *,
+				 int min_uA, int max_uA);
+	int (*get_current_limit) (struct regulator_dev *);
+
+	/* enable/disable regulator */
+	int (*enable) (struct regulator_dev *);
+	int (*disable) (struct regulator_dev *);
+	int (*is_enabled) (struct regulator_dev *);
+
+	/* get/set regulator operating mode (defined in regulator.h) */
+	int (*set_mode) (struct regulator_dev *, unsigned int mode);
+	unsigned int (*get_mode) (struct regulator_dev *);
+
+	/* get most efficient regulator operating mode for load */
+	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
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
+struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
+					  void *reg_data);
+void regulator_unregister(struct regulator_dev *rdev);
+
+int regulator_notifier_call_chain(struct regulator_dev *rdev,
+				  unsigned long event, void *data);
+
+void *rdev_get_drvdata(struct regulator_dev *rdev);
+int rdev_get_id(struct regulator_dev *rdev);
+
+#endif
-- 
1.5.4.3



