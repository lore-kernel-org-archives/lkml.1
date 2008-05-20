Return-Path: <linux-kernel-owner+w=401wt.eu-S1764398AbYETKwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764398AbYETKwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760992AbYETKvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:51:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:14151 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764157AbYETKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jjP/B6ISwPScmUA9isGQtTf8bvFKM3HP39eLe68KeuYR7lm5kwRfy7Ua83UQTIxqyggoK+hT6Y4JpJ/mSVo333ikwheCh8Yrvlz9qSEaKAsQUQMOtCbC6pzW949S3ODTWTN5IzI3kvMJm4VU213WOUHEF4xpTWLXCLJ0w4yIsrk=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org, gregkh@suse.de,
       hjk@linutronix.de, linux-sh@vger.kernel.org
Date: Tue, 20 May 2008 19:51:48 +0900
Message-Id: <20080520105148.1474.9734.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
Subject: [PATCH 02/03] uio: Add uio_platform driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a reusable UIO platform driver. Only memory mapped
hardware devices with unique IRQs are supported.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Tested using the VEU on a SuperH sh7722.

 drivers/uio/Kconfig          |   10 ++
 drivers/uio/Makefile         |    1 
 drivers/uio/uio_platform.c   |  161 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/uio_platform.h |   10 ++
 4 files changed, 182 insertions(+)

--- 0001/drivers/uio/Kconfig
+++ work/drivers/uio/Kconfig	2008-05-20 17:20:18.000000000 +0900
@@ -39,4 +39,14 @@ config UIO_SMX
 
 	  If you compile this as a module, it will be called uio_smx.
 
+config UIO_PLATFORM
+	tristate "Userspace I/O Platform driver"
+	depends on UIO
+	default n
+	help
+	  Reusable userspace IO interface for memory mapped devices
+	  equipped with an unique IRQ. IRQ sharing is not supported.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called uio_platform.
 endif
--- 0001/drivers/uio/Makefile
+++ work/drivers/uio/Makefile	2008-05-20 17:20:18.000000000 +0900
@@ -1,3 +1,4 @@
 obj-$(CONFIG_UIO)	+= uio.o
 obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
 obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
+obj-$(CONFIG_UIO_PLATFORM)	+= uio_platform.o
--- /dev/null
+++ work/drivers/uio/uio_platform.c	2008-05-20 18:06:08.000000000 +0900
@@ -0,0 +1,161 @@
+/*
+ * Userspace I/O Platform Driver
+ *
+ * Copyright(C) 2008 Magnus Damm
+ *
+ * Platform data driven UIO kernel glue, only memory mapped I/O devices
+ * with unique IRQs are supported.
+ *
+ * Licensed under the GPLv2 only.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/uio_driver.h>
+#include <linux/uio_platform.h>
+#include <linux/bitops.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+
+struct uio_platform_priv {
+	struct uio_info info;
+	unsigned long irq_disabled;
+};
+
+#define to_priv(uinfo) container_of(uinfo, struct uio_platform_priv, info)
+
+static irqreturn_t uio_platform_handler(int irq, struct uio_info *dev_info)
+{
+	struct uio_platform_priv *priv = to_priv(dev_info);
+
+	/* Since we are the only user of this interrupt, just disable
+	 * it and remember the state so we can enable it later.
+	 */
+
+	disable_irq(irq);
+	set_bit(0, &priv->irq_disabled);
+	return IRQ_HANDLED;
+}
+
+static void uio_platform_enable_irq(struct uio_info *dev_info)
+{
+	struct uio_platform_priv *priv = to_priv(dev_info);
+
+	if (test_and_clear_bit(0, &priv->irq_disabled))
+		enable_irq(dev_info->irq);
+}
+
+static int uio_platform_probe(struct platform_device *dev)
+{
+	struct uio_platform_info *platform_info = dev->dev.platform_data;
+	struct uio_platform_priv *priv;
+	struct uio_info *info;
+	struct resource	*r;
+	int ret, k;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	info = &priv->info;
+
+	for (k = 0; k < MAX_UIO_MAPS; k++) {
+		r = platform_get_resource(dev, IORESOURCE_MEM, k);
+		if (r == NULL)
+			break;
+
+		info->mem[k].memtype = UIO_MEM_PHYS;
+		info->mem[k].addr = r->start;
+		info->mem[k].size = r->end - r->start + 1;
+	}
+
+	if (platform_info->memsize && k < MAX_UIO_MAPS) {
+		dma_addr_t dma_handle;
+		void *buf;
+
+		buf = dma_alloc_coherent(&dev->dev, platform_info->memsize,
+					 &dma_handle, GFP_KERNEL);
+		if (buf == NULL) {
+			kfree(priv);
+			return -ENOMEM;
+		}
+
+		info->mem[k].memtype = UIO_MEM_PHYS;
+		info->mem[k].addr = dma_handle;
+		info->mem[k].internal_addr = buf;
+		info->mem[k].size = platform_info->memsize;
+
+		memset(buf, 0, info->mem[k].size);
+	}
+
+	info->name = platform_info->name;
+	info->version = platform_info->version;
+	info->irq = platform_get_irq(dev, 0);
+	info->irq_flags = IRQF_DISABLED;
+	info->handler = uio_platform_handler;
+	info->enable_irq = uio_platform_enable_irq;
+
+	platform_set_drvdata(dev, info);
+
+	ret = uio_register_device(&dev->dev, info);
+	if (ret)
+		goto err;
+
+	return 0;
+ err:
+	for (k = 0; k < MAX_UIO_MAPS; k++)
+		if (info->mem[k].memtype == UIO_MEM_PHYS)
+			dma_free_coherent(&dev->dev, info->mem[k].size,
+					  info->mem[k].internal_addr,
+					  info->mem[k].addr);
+	kfree(priv);
+	return ret;
+}
+
+static int uio_platform_remove(struct platform_device *dev)
+{
+	struct uio_info *info = platform_get_drvdata(dev);
+	struct uio_platform_priv *priv = to_priv(info);
+	int k;
+
+	uio_unregister_device(&priv->info);
+
+	for (k = 0; k < MAX_UIO_MAPS; k++)
+		if (info->mem[k].memtype == UIO_MEM_PHYS)
+			dma_free_coherent(&dev->dev, info->mem[k].size,
+					  info->mem[k].internal_addr,
+					  info->mem[k].addr);
+
+	kfree(priv);
+	return 0;
+}
+
+static struct platform_driver uio_platform_drv = {
+	.probe		= uio_platform_probe,
+	.remove		= uio_platform_remove,
+	.driver		= {
+		.name	= "uio-platform",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init uio_platform_init(void)
+{
+	return platform_driver_register(&uio_platform_drv);
+}
+module_init(uio_platform_init);
+
+static void __exit uio_platform_exit(void)
+{
+	platform_driver_unregister(&uio_platform_drv);
+}
+module_exit(uio_platform_exit);
+
+MODULE_DESCRIPTION("UIO Platform Driver");
+MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
+MODULE_LICENSE("GPL v2");
--- /dev/null
+++ work/include/linux/uio_platform.h	2008-05-20 17:20:18.000000000 +0900
@@ -0,0 +1,10 @@
+#ifndef __LINUX_UIO_PLATFORM_H__
+#define __LINUX_UIO_PLATFORM_H__
+
+struct uio_platform_info {
+	char *name;
+	char *version;
+	unsigned long memsize;
+};
+
+#endif /* __LINUX_UIO_PLATFORM_H__ */
