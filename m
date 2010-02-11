Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab0BKUBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:01:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47372 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756897Ab0BKUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:01:44 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mike Rapoport <mike@compulab.co.il>, Grazvydas Ignotas <notasas@gmail.com>,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Provide optional dummy regulator for consumers
Date: Thu, 11 Feb 2010 20:01:39 +0000
Message-Id: <1265918499-9583-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to ease transitions with drivers are boards start using regulators
provide an option to cause all regulator_get() calls to succeed, with a
dummy always on regulator being supplied where one has not been configured.
A warning is printed whenever the dummy regulator is used to aid system
development.

This regulator does not implement any regulator operations but will allow
simple consumers which only do enable() and disable() calls to run. It
is kept separate from the fixed voltage regulator to avoid Kconfig
confusion on the part of users when it is extended to allow boards to
explicitly use the dummy regulator to simplify cases where the majority
of supplies are from fixed regulators without software control.

This option is currently only effective for systems which do not specify
full constriants. If required an override could also be provided to allow
these systems to use the dummy regulator, though it is likely that
unconfigured supplies on such systems will lead to error due to
regulators being powered down more aggressively when not in use.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig  |   11 +++++++
 drivers/regulator/Makefile |    1 +
 drivers/regulator/core.c   |   27 ++++++++++++++++-
 drivers/regulator/dummy.c  |   71 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/regulator/dummy.h  |   31 +++++++++++++++++++
 5 files changed, 140 insertions(+), 1 deletions(-)
 create mode 100644 drivers/regulator/dummy.c
 create mode 100644 drivers/regulator/dummy.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 3c07169..834b484 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -27,6 +27,17 @@ config REGULATOR_DEBUG
 	help
 	  Say yes here to enable debugging support.
 
+config REGULATOR_DUMMY
+	bool "Provide a dummy regulator if regulator lookups fail"
+	help
+	  If this option is enabled then when a regulator lookup fails
+	  and the board has not specified that it has provided full
+	  constraints then the regulator core will provide an always
+	  enabled dummy regulator will be provided, allowing consumer
+	  drivers to continue.
+
+	  A warning will be generated when this substitution is done.
+
 config REGULATOR_FIXED_VOLTAGE
 	tristate "Fixed voltage regulator support"
 	help
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 7c59bcb..e845b66 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
+obj-$(CONFIG_REGULATOR_DUMMY) += dummy.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 75a26f7..c7bbe30 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -24,6 +24,8 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 
+#include "dummy.h"
+
 #define REGULATOR_VERSION "0.5"
 
 static DEFINE_MUTEX(regulator_list_mutex);
@@ -1123,6 +1125,22 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 			goto found;
 		}
 	}
+
+#ifdef CONFIG_REGULATOR_DUMMY
+	if (!devname)
+		devname = "deviceless";
+
+	/* If the board didn't flag that it was fully constrained then
+	 * substitute in a dummy regulator so consumers can continue.
+	 */
+	if (!has_full_constraints) {
+		pr_warning("%s supply %s not found, using dummy regulator\n",
+			   devname, id);
+		rdev = dummy_regulator_rdev;
+		goto found;
+	}
+#endif
+
 	mutex_unlock(&regulator_list_mutex);
 	return regulator;
 
@@ -2483,8 +2501,15 @@ EXPORT_SYMBOL_GPL(regulator_get_init_drvdata);
 
 static int __init regulator_init(void)
 {
+	int ret;
+
 	printk(KERN_INFO "regulator: core version %s\n", REGULATOR_VERSION);
-	return class_register(&regulator_class);
+
+	ret = class_register(&regulator_class);
+
+	regulator_dummy_init();
+
+	return ret;
 }
 
 /* init early to allow our consumers to complete system booting */
diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
new file mode 100644
index 0000000..a41c733
--- /dev/null
+++ b/drivers/regulator/dummy.c
@@ -0,0 +1,71 @@
+/*
+ * dummy.c
+ *
+ * Copyright 2010 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This is useful for systems with mixed controllable and
+ * non-controllable regulators, as well as for allowing testing on
+ * systems with no controllable regulators.
+ */
+
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+#include "dummy.h"
+
+struct regulator_dev *dummy_regulator_rdev;
+
+static struct regulator_init_data dummy_initdata;
+
+static struct regulator_ops dummy_ops;
+
+static struct regulator_desc dummy_desc = {
+	.name = "dummy",
+	.id = -1,
+	.type = REGULATOR_VOLTAGE,
+	.owner = THIS_MODULE,
+	.ops = &dummy_ops,
+};
+
+static struct platform_device *dummy_pdev;
+
+void __init regulator_dummy_init(void)
+{
+	int ret;
+
+	dummy_pdev = platform_device_alloc("reg-dummy", -1);
+	if (!dummy_pdev) {
+		pr_err("Failed to allocate dummy regulator device\n");
+		return -ENODEV;
+	}
+
+	ret = platform_device_add(dummy_pdev);
+	if (ret != 0) {
+		pr_err("Failed to register dummy regulator device: %d\n", ret);
+		goto err;
+	}
+
+	dummy_regulator_rdev = regulator_register(&dummy_desc, NULL,
+						  &dummy_initdata, NULL);
+	if (IS_ERR(dummy_regulator_rdev)) {
+		ret = PTR_ERR(dummy_regulator_rdev);
+		pr_err("Failed to register regulator: %d\n", ret);
+		platform_device_unregister(dummy_pdev);
+		return ret;
+	}
+
+	return 0;
+
+err:
+	platform_device_put(dummy_pdev);
+	return ret;
+}
diff --git a/drivers/regulator/dummy.h b/drivers/regulator/dummy.h
new file mode 100644
index 0000000..3921c0e
--- /dev/null
+++ b/drivers/regulator/dummy.h
@@ -0,0 +1,31 @@
+/*
+ * dummy.h
+ *
+ * Copyright 2010 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This is useful for systems with mixed controllable and
+ * non-controllable regulators, as well as for allowing testing on
+ * systems with no controllable regulators.
+ */
+
+#ifndef _DUMMY_H
+#define _DUMMY_H
+
+struct regulator_dev;
+
+extern struct regulator_dev *dummy_regulator_rdev;
+
+#ifdef CONFIG_REGULATOR_DUMMY
+void __init regulator_dummy_init(void);
+#else
+static inline void regulator_dummy_init(void) { }
+#endif
+
+#endif
-- 
1.6.6.1

