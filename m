Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbYDKTVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbYDKTVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbYDKTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:21:26 -0400
Received: from mail0.scram.de ([78.47.204.202]:51120 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757756AbYDKTVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:21:25 -0400
X-Spam-Score: -4.082
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <47FFBA7B.8050900@scram.de>
Date: Fri, 11 Apr 2008 21:22:35 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, i2c@lm-sensors.org,
       Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       David Miller <davem@davemloft.net>
Subject: [PATCHv2 3/7] i2c: OF helpers for the i2c API
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements various helpers to support OF bindings for
the i2c API.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/of/Kconfig     |    6 +++
 drivers/of/Makefile    |    1 +
 drivers/of/i2c.c       |  115 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_i2c.h |   24 ++++++++++
 4 files changed, 146 insertions(+), 0 deletions(-)
 create mode 100644 drivers/of/i2c.c
 create mode 100644 include/linux/of_i2c.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index c03072b..89396f1 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -1,3 +1,9 @@
 config OF_DEVICE
 	def_bool y
 	depends on OF && (SPARC || PPC_OF)
+
+config OF_I2C
+	def_bool y
+	depends on OF && I2C
+	help
+	  OpenFirmware I2C accessors
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index ab9be5d..655b982 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,2 +1,3 @@
 obj-y = base.o
 obj-$(CONFIG_OF_DEVICE) += device.o platform.o
+obj-$(CONFIG_OF_I2C)	+= i2c.o
diff --git a/drivers/of/i2c.c b/drivers/of/i2c.c
new file mode 100644
index 0000000..6316891
--- /dev/null
+++ b/drivers/of/i2c.c
@@ -0,0 +1,115 @@
+/*
+ * OF helpers for the I2C API
+ *
+ * Copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
+ *
+ * Based on a previous patch from Jon Smirl <jonsmirl@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/i2c.h>
+#include <linux/of.h>
+
+struct i2c_driver_device {
+	char    *of_device;
+	char    *i2c_type;
+};
+
+static struct i2c_driver_device i2c_devices[] = {
+	{ "dallas,ds1374", "rtc-ds1374" },
+};
+
+static int of_find_i2c_driver(struct device_node *node,
+			      struct i2c_board_info *info)
+{
+	int i, cplen;
+	const char *compatible;
+	const char *p;
+
+	/* 1. search for exception list entry */
+	for (i = 0; i < ARRAY_SIZE(i2c_devices); i++) {
+		if (!of_device_is_compatible(node, i2c_devices[i].of_device))
+			continue;
+		if (strlcpy(info->type, i2c_devices[i].i2c_type,
+			    I2C_NAME_SIZE) >= I2C_NAME_SIZE)
+			return -ENOMEM;
+
+		return 0;
+	}
+
+	compatible = of_get_property(node, "compatible", &cplen);
+	if (!compatible)
+		return -ENODEV;
+
+	/* 2. search for linux,<i2c-type> entry */
+	p = compatible;
+	while (cplen > 0) {
+		if (!strncmp(p, "linux,", 6)) {
+			p += 6;
+			if (strlcpy(info->type, p,
+				    I2C_NAME_SIZE) >= I2C_NAME_SIZE)
+				return -ENOMEM;
+			return 0;
+		}
+
+		i = strlen(p) + 1;
+		p += i;
+		cplen -= i;
+	}
+
+	/* 3. take fist compatible entry and strip manufacturer */
+	p = strchr(compatible, ',');
+	if (!p)
+		return -ENODEV;
+	p++;
+	if (strlcpy(info->type, p, I2C_NAME_SIZE) >= I2C_NAME_SIZE)
+		return -ENOMEM;
+	return 0;
+}
+
+void of_register_i2c_devices(struct i2c_adapter *adap,
+			     struct device_node *adap_node)
+{
+	void *result;
+	struct device_node *node;
+
+	for_each_child_of_node(adap_node, node) {
+		struct i2c_board_info info = {};
+		const u32 *addr;
+		int len;
+
+		addr = of_get_property(node, "reg", &len);
+		if (!addr || len < sizeof(int) || *addr > (1 << 10) - 1) {
+			printk(KERN_ERR
+			       "of-i2c: invalid i2c device entry\n");
+			continue;
+		}
+
+		info.irq = irq_of_parse_and_map(node, 0);
+		if (info.irq == NO_IRQ)
+			info.irq = -1;
+
+		if (of_find_i2c_driver(node, &info) < 0) {
+			irq_dispose_mapping(info.irq);
+			continue;
+		}
+
+		info.addr = *addr;
+
+		request_module(info.type);
+
+		result = i2c_new_device(adap, &info);
+		if (result == NULL) {
+			printk(KERN_ERR
+			       "of-i2c: Failed to load driver for %s\n",
+			       info.type);
+			irq_dispose_mapping(info.irq);
+			continue;
+		}
+	}
+}
+EXPORT_SYMBOL(of_register_i2c_devices);
diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
new file mode 100644
index 0000000..2e5a967
--- /dev/null
+++ b/include/linux/of_i2c.h
@@ -0,0 +1,24 @@
+/*
+ * Generic I2C API implementation for PowerPC.
+ *
+ * Copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_OF_I2C_H
+#define __LINUX_OF_I2C_H
+
+#include <linux/i2c.h>
+
+#ifdef CONFIG_OF_I2C
+
+void of_register_i2c_devices(struct i2c_adapter *adap,
+			     struct device_node *adap_node);
+
+#endif /* CONFIG_OF_I2C */
+
+#endif /* __LINUX_OF_I2C_H */
-- 
1.5.4.5

