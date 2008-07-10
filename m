Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbYGJP01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbYGJP01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbYGJPZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:25:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55107 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758606AbYGJPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:25:57 -0400
Subject: [PATCH 03/15] regulator: machine driver interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:25:55 +0100
Message-Id: <1215703555.13431.59.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface is for machine specific code and allows the creation of
voltage/current domains (with constraints) for each regulator. It can
provide regulator constraints that will prevent device damage through
overvoltage or over current caused by buggy client drivers. It also
allows the creation of a regulator tree whereby some regulators are
supplied by others (similar to a clock tree).

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/machine.h |   84 +++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/regulator/machine.h

diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
new file mode 100644
index 0000000..69b492c
--- /dev/null
+++ b/include/linux/regulator/machine.h
@@ -0,0 +1,84 @@
+/*
+ * machine.h -- SoC Regulator support, machine/board driver API.
+ *
+ * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Regulator Machine/Board Interface.
+ */
+
+#ifndef __LINUX_REGULATOR_MACHINE_H_
+#define __LINUX_REGULATOR_MACHINE_H_
+
+#include <linux/regulator/consumer.h>
+
+struct regulator;
+
+/*
+ * Regulator operation constraint flags. These flags are used to enable
+ * certain regulator operations and can be OR'ed together.
+ *
+ * VOLTAGE:  Regulator output voltage can be changed by software on this
+ *           board/machine.
+ * CURRENT:  Regulator output current can be changed by software on this
+ *           board machine.
+ * MODE:     Regulator operating mode can be changed by software on this
+ *           board machine.
+ * STATUS:   Regulator can be enabled and disabled.
+ * DRMS:     Dynamic Regulator Mode Switching is enabled for this regulator.
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
+	/* voltage output range (inclusive) - for voltage control */
+	int min_uV;
+	int max_uV;
+
+	/* current output range (inclusive) - for current control */
+	int min_uA;
+	int max_uA;
+
+	/* valid regulator operating modes for this machine */
+	unsigned int valid_modes_mask;
+
+	/* valid operations for regulator on this machine */
+	unsigned int valid_ops_mask;
+
+	/* regulator input voltage - only if supply is another regulator */
+	int input_uV;
+
+	/* constriant flags */
+	u32 always_on:1;	/* regulator never off when system is on */
+	u32 boot_on:1;		/* bootloader/firmware enabled regulator */
+	u32 apply_uV:1;		/* apply uV constraint iff min == max */
+};
+
+int regulator_set_supply(const char *regulator, const char *regulator_supply);
+
+const char *regulator_get_supply(const char *regulator);
+
+int regulator_set_machine_constraints(const char *regulator,
+	struct regulation_constraints *constraints);
+
+int regulator_set_device_supply(const char *regulator, struct device *dev,
+				const char *supply);
+
+#endif
-- 
1.5.4.3



