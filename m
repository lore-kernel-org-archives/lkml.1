Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0CBXfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:35:41 -0500
Received: from kroah.org ([198.145.64.141]:38659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0CBX3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/62] UIO: Remove SMX Cryptengine driver
Date: Tue,  2 Mar 2010 15:28:39 -0800
Message-Id: <1267572541-410-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

Ben Nizette, the author of this driver, told me in a private mail that this
project has been cancelled. He suggested to remove the driver for now, and
will come back with a new version should the hardware really exist.
This patch completely removes the driver.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Acked-by: Ben Nizette <bn@niasdigital.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig   |   11 ----
 drivers/uio/Makefile  |    1 -
 drivers/uio/uio_smx.c |  140 -------------------------------------------------
 3 files changed, 0 insertions(+), 152 deletions(-)
 delete mode 100644 drivers/uio/uio_smx.c

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 6dd2a29..1da73ec 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -44,17 +44,6 @@ config UIO_PDRV_GENIRQ
 
 	  If you don't know what to do here, say N.
 
-config UIO_SMX
-	tristate "SMX cryptengine UIO interface"
-	help
-	  Userspace IO interface to the Cryptography engine found on the
-	  Nias Digital SMX boards.  These will be available from Q4 2008
-	  from http://www.niasdigital.com.  The userspace part of this
-	  driver will be released under the GPL at the same time as the
-	  hardware and will be able to be downloaded from the same site.
-
-	  If you compile this as a module, it will be called uio_smx.
-
 config UIO_AEC
 	tristate "AEC video timestamp device"
 	depends on PCI
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index aa7d033..18fd818 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -2,7 +2,6 @@ obj-$(CONFIG_UIO)	+= uio.o
 obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
 obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
 obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
-obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
 obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
 obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
 obj-$(CONFIG_UIO_PCI_GENERIC)	+= uio_pci_generic.o
diff --git a/drivers/uio/uio_smx.c b/drivers/uio/uio_smx.c
deleted file mode 100644
index 44054a6..0000000
--- a/drivers/uio/uio_smx.c
+++ /dev/null
@@ -1,140 +0,0 @@
-/*
- * UIO SMX Cryptengine driver.
- *
- * (C) 2008 Nias Digital P/L <bn@niasdigital.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/device.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/uio_driver.h>
-#include <linux/io.h>
-
-#define DRV_NAME "smx-ce"
-#define DRV_VERSION "0.03"
-
-#define SMX_CSR  0x00000000
-#define SMX_EnD  0x00000001
-#define SMX_RUN  0x00000002
-#define SMX_DRDY 0x00000004
-#define SMX_ERR  0x00000008
-
-static irqreturn_t smx_handler(int irq, struct uio_info *dev_info)
-{
-	void __iomem *csr = dev_info->mem[0].internal_addr + SMX_CSR;
-
-	u32 status = ioread32(csr);
-
-	if (!(status & SMX_DRDY))
-		return IRQ_NONE;
-
-	/* Disable interrupt */
-	iowrite32(status & ~SMX_DRDY, csr);
-	return IRQ_HANDLED;
-}
-
-static int __devinit smx_ce_probe(struct platform_device *dev)
-{
-
-	int ret = -ENODEV;
-	struct uio_info *info;
-	struct resource *regs;
-
-	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		dev_err(&dev->dev, "No memory resource specified\n");
-		goto out_free;
-	}
-
-	info->mem[0].addr = regs->start;
-	if (!info->mem[0].addr) {
-		dev_err(&dev->dev, "Invalid memory resource\n");
-		goto out_free;
-	}
-
-	info->mem[0].size = regs->end - regs->start + 1;
-	info->mem[0].internal_addr = ioremap(regs->start, info->mem[0].size);
-
-	if (!info->mem[0].internal_addr) {
-		dev_err(&dev->dev, "Can't remap memory address range\n");
-		goto out_free;
-	}
-
-	info->mem[0].memtype = UIO_MEM_PHYS;
-
-	info->name = "smx-ce";
-	info->version = "0.03";
-
-	info->irq = platform_get_irq(dev, 0);
-	if (info->irq < 0) {
-		ret = info->irq;
-		dev_err(&dev->dev, "No (or invalid) IRQ resource specified\n");
-		goto out_unmap;
-	}
-
-	info->irq_flags = IRQF_SHARED;
-	info->handler = smx_handler;
-
-	platform_set_drvdata(dev, info);
-
-	ret = uio_register_device(&dev->dev, info);
-
-	if (ret)
-		goto out_unmap;
-
-	return 0;
-
-out_unmap:
-	iounmap(info->mem[0].internal_addr);
-out_free:
-	kfree(info);
-
-	return ret;
-}
-
-static int __devexit smx_ce_remove(struct platform_device *dev)
-{
-	struct uio_info *info = platform_get_drvdata(dev);
-
-	uio_unregister_device(info);
-	platform_set_drvdata(dev, NULL);
-	iounmap(info->mem[0].internal_addr);
-
-	kfree(info);
-
-	return 0;
-}
-
-static struct platform_driver smx_ce_driver = {
-	.probe		= smx_ce_probe,
-	.remove		= __devexit_p(smx_ce_remove),
-	.driver		= {
-		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init smx_ce_init_module(void)
-{
-	return platform_driver_register(&smx_ce_driver);
-}
-module_init(smx_ce_init_module);
-
-static void __exit smx_ce_exit_module(void)
-{
-	platform_driver_unregister(&smx_ce_driver);
-}
-module_exit(smx_ce_exit_module);
-
-MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
-MODULE_AUTHOR("Ben Nizette <bn@niasdigital.com>");
-- 
1.7.0.1

