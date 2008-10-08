Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYJHHXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYJHHXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYJHHWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:22:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60243 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYJHHWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:22:44 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Date: Wed, 8 Oct 2008 12:49:19 +0530
Subject: [PATCH 2/5] HDQ: BQ27000 HDQ Slave Interface Driver
Thread-Topic: [PATCH 2/5] HDQ: BQ27000 HDQ Slave Interface Driver
Thread-Index: AckpFi5CUOTTdDcGQz61Y/yX0HrPCQ==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF2@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madhusudhan Chikkature <madhu.cr@ti.com>

This patch provides the BQ27000 slave interface driver.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/slaves/Kconfig      |    7 ++
 drivers/w1/slaves/Makefile     |    2 
 drivers/w1/slaves/w1_bq27000.c |  120 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/w1/slaves/Kconfig
===================================================================
--- linux-2.6.orig/drivers/w1/slaves/Kconfig	2008-09-19 13:39:41.000000000 +0530
+++ linux-2.6/drivers/w1/slaves/Kconfig	2008-09-26 14:45:04.000000000 +0530
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
--- linux-2.6.orig/drivers/w1/slaves/Makefile	2008-09-19 13:39:41.000000000 +0530
+++ linux-2.6/drivers/w1/slaves/Makefile	2008-09-26 14:45:43.000000000 +0530
@@ -6,4 +6,4 @@ obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
-
+obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
Index: linux-2.6/drivers/w1/slaves/w1_bq27000.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/w1/slaves/w1_bq27000.c	2008-09-26 14:43:42.000000000 +0530
@@ -0,0 +1,120 @@
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
+int F_ID;
+int family_id;
+
+void w1_bq27000_write(struct device *dev, u8 buf, u8 reg)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
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
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Texas Instruments Ltd");
+MODULE_DESCRIPTION("HDQ/1-wire slave driver bq27000 battery monitor chip");