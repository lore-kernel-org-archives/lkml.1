Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbYDVJxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbYDVJxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbYDVJxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:53:05 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:41973 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757007AbYDVJxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:53:03 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-29.messagelabs.com!1208857982!11707819!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] UIO: generic platform driver
Date: Tue, 22 Apr 2008 11:52:57 +0200
Message-ID: <1208857977-29493-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208857977-29493-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <20080422094708.GB27126@digi.com>
 <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
 <1208857977-29493-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Apr 2008 09:52:58.0136 (UTC) FILETIME=[A4F37980:01C8A45E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15864.006
X-TM-AS-Result: No--13.329000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
Hello,

This is the former patch 4/4 after some discussion.

Open issues:
  - clock name "uio" isn't considered good by Russell King
    I don't have a better suggestion
  - some code could be shared with uio_smx.c
    I would address that in a seperate patch after this one hits mainline.

I appreciate any feedback.

Best regards,
Uwe

 drivers/uio/Kconfig    |    7 ++
 drivers/uio/Makefile   |    1 +
 drivers/uio/uio_pdrv.c |  154 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 0 deletions(-)
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
index 0000000..f421a6e
--- /dev/null
+++ b/drivers/uio/uio_pdrv.c
@@ -0,0 +1,154 @@
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
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/uio_driver.h>
+#include <linux/stringify.h>
+
+#define DRIVER_NAME "uio"
+
+struct uio_platdata {
+	struct uio_info *uioinfo;
+	struct clk *clk;
+};
+
+static int uio_pdrv_open(struct uio_info *info, struct inode *inode)
+{
+	struct uio_platdata *pdata = info->priv;
+
+	BUG_ON(pdata->uioinfo != info);
+
+	return clk_enable(pdata->clk);
+}
+
+static int uio_pdrv_release(struct uio_info *info, struct inode *inode)
+{
+	struct uio_platdata *pdata = info->priv;
+
+	BUG_ON(pdata->uioinfo != info);
+
+	clk_disable(pdata->clk);
+
+	return 0;
+}
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
+	pdata->clk = clk_get(&pdev->dev, DRIVER_NAME);
+	if (IS_ERR(pdata->clk)) {
+		ret = PTR_ERR(pdata->clk);
+		dev_dbg(&pdev->dev, "%s: err_clk_get -> %d\n", __func__, ret);
+		goto err_clk_get;
+	}
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
+	pdata->uioinfo->open = uio_pdrv_open;
+	pdata->uioinfo->release = uio_pdrv_release;
+	pdata->uioinfo->priv = pdata;
+
+	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
+
+	if (ret) {
+		clk_put(pdata->clk);
+err_clk_get:
+
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
+	clk_put(pdata->clk);
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
1.5.5

