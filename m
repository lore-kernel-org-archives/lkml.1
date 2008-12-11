Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYLKPFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYLKPFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYLKPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:05:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51370 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbYLKPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:05:39 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: hjk@linutronix.de
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: [RESEND][PATCH] uio: Add of_platform_driver to uio_pdrv_genirq
Date: Thu, 11 Dec 2008 16:05:37 +0100
Message-Id: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the generic uio-driver also accessible for of devices. It utilizes the
standard 'reg' and 'interrupt' properties. A typical usage would look like
this:

	fpga-io@00003000 {
		compatible = "generic-uio";
		reg = <0x00003000 0x20>;
		interrupts = <0xa>;
		interrupt-parent = <&fpga_irq_mux>;
	};

To achieve this, the probe function has been refactored, so it can be used by
platform and of code. Then, the of driver has been added.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/uio/uio_pdrv_genirq.c |  178 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 154 insertions(+), 24 deletions(-)

Index: playground/drivers/uio/uio_pdrv_genirq.c
===================================================================
--- playground.orig/drivers/uio/uio_pdrv_genirq.c
+++ playground/drivers/uio/uio_pdrv_genirq.c
@@ -1,13 +1,15 @@
 /*
  * drivers/uio/uio_pdrv_genirq.c
  *
- * Userspace I/O platform driver with generic IRQ handling code.
+ * Userspace I/O platform & of driver with generic IRQ handling code.
  *
  * Copyright (C) 2008 Magnus Damm
+ * Copyright (C) 2008 Wolfram Sang, Pengutronix e.K.
  *
  * Based on uio_pdrv.c by Uwe Kleine-Koenig,
  * Copyright (C) 2008 by Digi International Inc.
  * All rights reserved.
+ * Adding of_platform_driver based on xilinxfb.c by Grant Likely.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published by
@@ -20,6 +22,10 @@
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
 #include <linux/stringify.h>
+#if defined(CONFIG_OF)
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#endif
 
 #define DRIVER_NAME "uio_pdrv_genirq"
 
@@ -68,28 +74,18 @@
 	return 0;
 }
 
-static int uio_pdrv_genirq_probe(struct platform_device *pdev)
+static int uio_pdrv_genirq_setup(struct device *dev, struct uio_info *uioinfo,
+		struct resource *resources, unsigned int num_resources)
 {
-	struct uio_info *uioinfo = pdev->dev.platform_data;
 	struct uio_pdrv_genirq_platdata *priv;
 	struct uio_mem *uiomem;
-	int ret = -EINVAL;
-	int i;
-
-	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
-		dev_err(&pdev->dev, "missing platform_data\n");
-		goto bad0;
-	}
-
-	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
-		dev_err(&pdev->dev, "interrupt configuration error\n");
-		goto bad0;
-	}
+	unsigned int i;
+	int ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
 		ret = -ENOMEM;
-		dev_err(&pdev->dev, "unable to kmalloc\n");
+		dev_err(dev, "unable to kmalloc\n");
 		goto bad0;
 	}
 
@@ -99,14 +95,15 @@
 
 	uiomem = &uioinfo->mem[0];
 
-	for (i = 0; i < pdev->num_resources; ++i) {
-		struct resource *r = &pdev->resource[i];
+	for (i = 0; i < num_resources; ++i) {
+
+		struct resource *r = resources + i;
 
 		if (r->flags != IORESOURCE_MEM)
 			continue;
 
 		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
-			dev_warn(&pdev->dev, "device has more than "
+			dev_warn(dev, "device has more than "
 					__stringify(MAX_UIO_MAPS)
 					" I/O memory resources.\n");
 			break;
@@ -137,13 +134,13 @@
 	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
 	uioinfo->priv = priv;
 
-	ret = uio_register_device(&pdev->dev, priv->uioinfo);
+	ret = uio_register_device(dev, priv->uioinfo);
 	if (ret) {
-		dev_err(&pdev->dev, "unable to register uio device\n");
+		dev_err(dev, "unable to register uio device\n");
 		goto bad1;
 	}
 
-	platform_set_drvdata(pdev, priv);
+	dev_set_drvdata(dev, priv);
 	return 0;
  bad1:
 	kfree(priv);
@@ -151,6 +148,24 @@
 	return ret;
 }
 
+static int uio_pdrv_genirq_probe(struct platform_device *pdev)
+{
+	struct uio_info *uioinfo = pdev->dev.platform_data;
+
+	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
+		dev_err(&pdev->dev, "missing platform_data\n");
+		return -EINVAL;
+	}
+
+	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
+		dev_err(&pdev->dev, "interrupt configuration error\n");
+		return -EINVAL;
+	}
+
+	return uio_pdrv_genirq_setup(&pdev->dev, uioinfo, pdev->resource,
+			pdev->num_resources);
+}
+
 static int uio_pdrv_genirq_remove(struct platform_device *pdev)
 {
 	struct uio_pdrv_genirq_platdata *priv = platform_get_drvdata(pdev);
@@ -169,20 +184,135 @@
 	},
 };
 
+/* ---------------------------------------------------------------------
+ * OF bus binding
+ */
+
+#if defined(CONFIG_OF)
+
+#define OF_DRIVER_NAME "uio_of_genirq"
+#define OF_DRIVER_VERSION "1"
+
+static int uio_of_genirq_probe(struct of_device *op,
+		const struct of_device_id *match)
+{
+	struct uio_info *uioinfo;
+	struct resource *resources;
+	int i, ret = -ENOMEM;
+
+	uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
+	if (!uioinfo)
+		goto bad0;
+
+	uioinfo->name = (char *)of_get_property(op->node, "name", NULL);
+	if (!uioinfo->name) {
+		ret = -ENODEV;
+		dev_err(&op->dev, "could not get node name\n");
+		goto bad1;
+	}
+
+	uioinfo->version = OF_DRIVER_VERSION;
+	uioinfo->irq = irq_of_parse_and_map(op->node, 0);
+	if (!uioinfo->irq)
+		uioinfo->irq = UIO_IRQ_NONE;
+
+	resources = kzalloc(MAX_UIO_MAPS * sizeof(struct resource), GFP_KERNEL);
+	if (!resources)
+		goto bad2;
+
+	for (i = 0; i < MAX_UIO_MAPS; ++i)
+		if (of_address_to_resource(op->node, i, resources + i))
+			break;
+
+	ret = uio_pdrv_genirq_setup(&op->dev, uioinfo, resources, i);
+	kfree(resources);
+	if (ret)
+		goto bad2;
+
+	return 0;
+
+ bad2:
+	if (uioinfo->irq != UIO_IRQ_NONE)
+		irq_dispose_mapping(uioinfo->irq);
+ bad1:
+	kfree(uioinfo);
+ bad0:
+	return ret;
+}
+
+static int  uio_of_genirq_remove(struct of_device *op)
+{
+	struct uio_pdrv_genirq_platdata *priv = dev_get_drvdata(&op->dev);
+
+	uio_unregister_device(priv->uioinfo);
+
+	if (priv->uioinfo->irq != UIO_IRQ_NONE)
+		irq_dispose_mapping(priv->uioinfo->irq);
+
+	kfree(priv->uioinfo);
+	kfree(priv);
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id uio_of_genirq_match[] = {
+	{ .compatible = "generic-uio", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
+
+static struct of_platform_driver uio_of_genirq_driver = {
+	.owner = THIS_MODULE,
+	.name = OF_DRIVER_NAME,
+	.match_table = uio_of_genirq_match,
+	.probe = uio_of_genirq_probe,
+	.remove = uio_of_genirq_remove,
+};
+
+/* Registration helpers to keep the number of #ifdefs to a minimum */
+static inline int __init uio_of_genirq_register(void)
+{
+	return of_register_platform_driver(&uio_of_genirq_driver);
+}
+
+static inline void __exit uio_of_genirq_unregister(void)
+{
+	of_unregister_platform_driver(&uio_of_genirq_driver);
+}
+#else /* CONFIG_OF */
+/* CONFIG_OF not enabled; do nothing helpers */
+static inline int __init uio_of_genirq_register(void) { return 0; }
+static inline void __exit uio_of_genirq_unregister(void) { }
+#endif /* CONFIG_OF */
+
+/* --------------------------------------------------------------------- */
+
 static int __init uio_pdrv_genirq_init(void)
 {
-	return platform_driver_register(&uio_pdrv_genirq);
+	int retval;
+
+	retval = uio_of_genirq_register();
+	if (retval)
+		return retval;
+
+	retval = platform_driver_register(&uio_pdrv_genirq);
+	if (retval)
+		uio_of_genirq_unregister();
+
+	return retval;
 }
 
 static void __exit uio_pdrv_genirq_exit(void)
 {
 	platform_driver_unregister(&uio_pdrv_genirq);
+	uio_of_genirq_unregister();
 }
 
 module_init(uio_pdrv_genirq_init);
 module_exit(uio_pdrv_genirq_exit);
 
 MODULE_AUTHOR("Magnus Damm");
-MODULE_DESCRIPTION("Userspace I/O platform driver with generic IRQ handling");
+MODULE_DESCRIPTION("Userspace I/O platform & of driver with generic"
+		   "IRQ handling");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:" DRIVER_NAME);
