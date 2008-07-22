Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYGVFlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYGVFlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbYGVFZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:37 -0400
Received: from ns.suse.de ([195.135.220.2]:54053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbYGVFZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 58/79] UIO: add generic UIO platform driver
Date: Mon, 21 Jul 2008 22:19:22 -0700
Message-Id: <1216703983-21448-58-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

This patch adds a generic UIO platform driver. It eliminates the need for a
dedicated kernel module for simple platform devices. Users only need to
implement their irq handler in platform code and fill a struct uio_info
there. This helps avoiding code duplication as UIO platform drivers often
share a lot of common code.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig    |    7 +++
 drivers/uio/Makefile   |    1 +
 drivers/uio/uio_pdrv.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 drivers/uio/uio_pdrv.c

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 78e139c..2e9079d 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -26,6 +26,13 @@ config UIO_CIF
 	  To compile this driver as a module, choose M here: the module
 	  will be called uio_cif.
 
+config UIO_PDRV
+	tristate "Userspace I/O platform driver"
+	help
+	  Generic platform driver for Userspace I/O devices.
+
+	  If you don't know what to do here, say N.
+
 config UIO_SMX
 	tristate "SMX cryptengine UIO interface"
 	default n
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index 18c4566..e00ce0d 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_UIO)	+= uio.o
 obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
+obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
 obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
new file mode 100644
index 0000000..5d0d2e8
--- /dev/null
+++ b/drivers/uio/uio_pdrv.c
@@ -0,0 +1,118 @@
+/*
+ * drivers/uio/uio_pdrv.c
+ *
+ * Copyright (C) 2008 by Digi International Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/platform_device.h>
+#include <linux/uio_driver.h>
+#include <linux/stringify.h>
+
+#define DRIVER_NAME "uio"
+
+struct uio_platdata {
+	struct uio_info *uioinfo;
+};
+
+static int uio_pdrv_probe(struct platform_device *pdev)
+{
+	struct uio_info *uioinfo = pdev->dev.platform_data;
+	struct uio_platdata *pdata;
+	struct uio_mem *uiomem;
+	int ret = -ENODEV;
+	int i;
+
+	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
+		dev_dbg(&pdev->dev, "%s: err_uioinfo\n", __func__);
+		goto err_uioinfo;
+	}
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "%s: err_alloc_pdata\n", __func__);
+		goto err_alloc_pdata;
+	}
+
+	pdata->uioinfo = uioinfo;
+
+	uiomem = &uioinfo->mem[0];
+
+	for (i = 0; i < pdev->num_resources; ++i) {
+		struct resource *r = &pdev->resource[i];
+
+		if (r->flags != IORESOURCE_MEM)
+			continue;
+
+		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
+			dev_warn(&pdev->dev, "device has more than "
+					__stringify(MAX_UIO_MAPS)
+					" I/O memory resources.\n");
+			break;
+		}
+
+		uiomem->memtype = UIO_MEM_PHYS;
+		uiomem->addr = r->start;
+		uiomem->size = r->end - r->start + 1;
+		++uiomem;
+	}
+
+	while (uiomem < &uioinfo->mem[MAX_UIO_MAPS]) {
+		uiomem->size = 0;
+		++uiomem;
+	}
+
+	pdata->uioinfo->priv = pdata;
+
+	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
+
+	if (ret) {
+		kfree(pdata);
+err_alloc_pdata:
+err_uioinfo:
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, pdata);
+
+	return 0;
+}
+
+static int uio_pdrv_remove(struct platform_device *pdev)
+{
+	struct uio_platdata *pdata = platform_get_drvdata(pdev);
+
+	uio_unregister_device(pdata->uioinfo);
+
+	return 0;
+}
+
+static struct platform_driver uio_pdrv = {
+	.probe = uio_pdrv_probe,
+	.remove = uio_pdrv_remove,
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init uio_pdrv_init(void)
+{
+	return platform_driver_register(&uio_pdrv);
+}
+
+static void __exit uio_pdrv_exit(void)
+{
+	platform_driver_unregister(&uio_pdrv);
+}
+module_init(uio_pdrv_init);
+module_exit(uio_pdrv_exit);
+
+MODULE_AUTHOR("Uwe Kleine-Koenig");
+MODULE_DESCRIPTION("Userspace I/O platform driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.5.6.3

