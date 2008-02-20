Return-Path: <linux-kernel-owner+w=401wt.eu-S933402AbYBTRK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbYBTRK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765850AbYBTRJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:09:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35647 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1765768AbYBTRJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:09:07 -0500
Subject: [PATCH 3/6] regulator: platform level interface.
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 17:09:05 +0000
Message-Id: <1203527345.4071.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface configures a regulator for use within a specific device. It
allows for the creation of voltage and current domains (with constraints) for
each regulator. Regulator constraints help prevent device damage by providing
protection for over voltage or over current events caused by buggy client
drivers.

This interface also allows the creation of a regulator tree whereby some
regulators are supplied by others (similar to a clock tree). This means a
parent regulator will be enabled before it's children are enabled and
disabled after it's children have all been disabled.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 include/linux/regulator/regulator-platform.h |  104 ++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/regulator/regulator-platform.h

diff --git a/include/linux/regulator/regulator-platform.h b/include/linux/regulator/regulator-platform.h
new file mode 100644
index 0000000..5558630
--- /dev/null
+++ b/include/linux/regulator/regulator-platform.h
@@ -0,0 +1,104 @@
+/*
+ * regulator-platform.h -- SoC Regulator support, platform driver API.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Platform Interface.
+ */
+
+
+#ifndef __LINUX_REGULATOR_PLATFORM_H_
+#define __LINUX_REGULATOR_PLATFORM_H_
+
+#include <linux/regulator/regulator.h>
+
+struct regulator;
+
+/*
+ * Regulator operation constraint flags. These flags are used to enable
+ * certain regulator operations.
+ *
+ * @VOLTAGE:  Regulator output voltage can be changed by software on this
+ *            board/machine.
+ * @CURRENT:  Regulator output current can be changed by software on this
+ *            board machine.
+ * @MODE:     Regulator operating mode can be changed by software on this
+ *            board machine.
+ * @STATUS:   Regulator can be enabled and disabled.
+ * @DRMS:     Dynamic Regulator Mode Switching is enabled for this regulator.
+ */
+
+#define REGULATOR_CHANGE_VOLTAGE	0x1
+#define REGULATOR_CHANGE_CURRENT	0x2
+#define REGULATOR_CHANGE_MODE		0x4
+#define REGULATOR_CHANGE_STATUS		0x8
+#define REGULATOR_CHANGE_DRMS		0x10
+
+/**
+ * struct regulation_constraints - regulator operating constraints.
+ *
+ * This struct describes regulator and board/machine specific constraints.
+ */
+struct regulation_constraints {
+
+	char *name;
+
+	/* voltage output range - for voltage control */
+	int min_uV;
+	int max_uV;
+
+	/* current output range - for current control */
+	int min_uA;
+	int max_uA;
+
+	/* valid regulator operating modes for this machine */
+	unsigned int valid_modes_mask;
+
+	/* valid operations for regulator on this machine */
+	unsigned int valid_ops_mask;
+
+	/* input voltage */
+	int input_uV;
+};
+
+/**
+ * regulator_set_platform_source - set regulator source regulator
+ * @regulator: regulator source
+ * @parent: source or parent regulator
+ *
+ * Called by platform initialisation code to set the source supply or "parent"
+ * regulator for this regulator. This ensures that a regulator source will
+ * also be enabled by the core if it's child is enabled.
+ */
+int regulator_set_platform_source(const char *regulator_source,
+	const char *regulator_parent);
+
+/**
+ * regulator_get_platform_source - get regulator source regulator
+ * @regulator: regulator source
+ *
+ * Returns the regulator supply regulator or NULL if no supply regulator
+ * exists (i.e the regulator is supplied directly from USB, Line, Battery, etc)
+ */
+const char *regulator_get_platform_source(const char *regulator_name);
+
+
+/**
+ * regulator_set_platform_constraints - sets regulator constraints
+ * @regulator: regulator source
+ *
+ * Allows platform initialisation code to define and constrain regulator
+ * circuits e.g. valid voltage/current ranges, etc.
+ * NOTE: Constraints *must* be set by platform code in order for some
+ * regulator operations to proceed i.e. set_voltage, set_current, set_mode.
+ */
+int regulator_set_platform_constraints(const char *regulator_name,
+	struct regulation_constraints *constraints);
+
+#endif
-- 
1.5.4.2



