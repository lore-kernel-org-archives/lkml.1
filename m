Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYJQOzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYJQOzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYJQOzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:55:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48278 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbYJQOze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:55:34 -0400
From: Madhu Chikkature <madhu.cr@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: [Resending PATCH 3/4] HDQ: BQ27000 HDQ Slave Interface Driver
Date: Fri, 17 Oct 2008 20:25:02 +0530
Message-Id: <1224255302-22131-1-git-send-email-madhu.cr@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madhusudhan Chikkature <madhu.cr@ti.com>

This patch provides the BQ27000 slave interface driver.

Signed-off-by: Madhusudhan Chikkature<madhu.cr@ti.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/slaves/Kconfig      |    7 ++
 drivers/w1/slaves/Makefile     |    2 
 drivers/w1/slaves/w1_bq27000.c |  123 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/w1/slaves/Kconfig
===================================================================
--- linux-2.6.orig/drivers/w1/slaves/Kconfig	2008-10-17 17:26:37.005264023 +0530
+++ linux-2.6/drivers/w1/slaves/Kconfig	2008-10-17 17:27:35.418525961 +0530
@@ -44,4 +44,11 @@ config W1_SLAVE_DS2760
 
 	  If you are unsure, say N.
 
+config W1_SLAVE_BQ27000
+	tristate "BQ27000 slave support"
+	depends on W1
+	help
+	  Say Y here if you want to use a hdq
+	  bq27000 slave support.
+
 endmenu
Index: linux-2.6/drivers/w1/slaves/Makefile
===================================================================
--- linux-2.6.orig/drivers/w1/slaves/Makefile	2008-10-17 17:26:37.005264023 +0530
+++ linux-2.6/drivers/w1/slaves/Makefile	2008-10-17 17:27:35.418525961 +0530
@@ -6,4 +6,4 @@ obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
-
+obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
Index: linux-2.6/drivers/w1/slaves/w1_bq27000.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/w1/slaves/w1_bq27000.c	2008-10-17 17:34:45.031604027 +0530
@@ -0,0 +1,123 @@
+/*
+ * drivers/w1/slaves/w1_bq27000.c
+ *
+ * Copyright (C) 2007 Texas Instruments, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+#define HDQ_CMD_READ	(0)
+#define HDQ_CMD_WRITE	(1<<7)
+
+static int F_ID;
+
+void w1_bq27000_write(struct device *dev, u8 buf, u8 reg)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev) {
+		pr_info("Could not obtain slave dev ptr\n");
+		return;
+	}
+
+	w1_write_8(sl->master, HDQ_CMD_WRITE | reg);
+	w1_write_8(sl->master, buf);
+}
+EXPORT_SYMBOL(w1_bq27000_write);
+
+int w1_bq27000_read(struct device *dev, u8 reg)
+{
+	u8 val;
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev)
+		return 0;
+
+	w1_write_8(sl->master, HDQ_CMD_READ | reg);
+	val = w1_read_8(sl->master);
+
+	return val;
+}
+EXPORT_SYMBOL(w1_bq27000_read);
+
+static int w1_bq27000_add_slave(struct w1_slave *sl)
+{
+	int ret;
+	int id = 1;
+	struct platform_device *pdev;
+
+	pdev = platform_device_alloc("bq27000-battery", id);
+	if (!pdev) {
+		ret = -ENOMEM;
+		return ret;
+	}
+	pdev->dev.parent = &sl->dev;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto pdev_add_failed;
+
+	dev_set_drvdata(&sl->dev, pdev);
+
+	goto success;
+
+pdev_add_failed:
+	platform_device_unregister(pdev);
+success:
+	return ret;
+}
+
+static void w1_bq27000_remove_slave(struct w1_slave *sl)
+{
+	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
+
+	platform_device_unregister(pdev);
+}
+
+static struct w1_family_ops w1_bq27000_fops = {
+	.add_slave	= w1_bq27000_add_slave,
+	.remove_slave	= w1_bq27000_remove_slave,
+};
+
+static struct w1_family w1_bq27000_family = {
+	.fid = 1,
+	.fops = &w1_bq27000_fops,
+};
+
+static int __init w1_bq27000_init(void)
+{
+	if (F_ID)
+		w1_bq27000_family.fid = F_ID;
+
+	return w1_register_family(&w1_bq27000_family);
+}
+
+static void __exit w1_bq27000_exit(void)
+{
+	w1_unregister_family(&w1_bq27000_family);
+}
+
+
+module_init(w1_bq27000_init);
+module_exit(w1_bq27000_exit);
+
+module_param(F_ID, int, S_IRUSR);
+MODULE_PARM_DESC(F_ID, "1-wire slave FID for BQ device");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Texas Instruments Ltd");
+MODULE_DESCRIPTION("HDQ/1-wire slave driver bq27000 battery monitor chip");
