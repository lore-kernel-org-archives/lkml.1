Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYGKJz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYGKJz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYGKJzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:55:19 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:32964 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYGKJzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=qmTU0Y7CGzGolj7l9r7elbav8hwnhDYGeZQohfTxn6TnaPittdg8kpr+im9LEzudZJ
         2LNvzYvQJDmVthd2N/Ywo6MNSHeVcvQPYY9BQRSVEyy3czQnwuleJ2vC2ctzFqspiqR0
         +W7oU7ywu9Yl+WyTvLcP6ljJFi4qbS+7wE44w=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       hjk@linutronix.de, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de,
       alan@lxorguk.ukuu.org.uk
Date: Fri, 11 Jul 2008 18:55:27 +0900
Message-Id: <20080711095527.6762.84233.sendpatchset@rx1.opensource.se>
Subject: [PATCH] uio: uio_pdrv_genirq V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is V3 of uio_pdrv_genirq.c, a platform driver for UIO with
generic IRQ handling code. This driver is very similar to the regular
UIO platform driver, but is only suitable for devices that are
connected to the interrupt controller using unique interrupt lines.

The uio_pdrv_genirq driver includes generic interrupt handling code
which disables the serviced interrupt in the interrupt controller
and makes the user space driver responsible for acknowledging the
interrupt in the device and reenabling the interrupt in the interrupt
controller.

Shared interrupts are not supported since the in-kernel interrupt
handler will disable the interrupt line in the interrupt controller,
and in a shared interrupt configuration this will stop other devices
from delivering interrupts.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Changes since V2
  - readded bitops
  - removed irq handler spinlock to fix potential deadlock
  - kept irq control spinlock to serialize user space access

 Changes since V1
  - allow user space to enable _and_ disable the interrupt
  - replaced bitops with spinlock + irq_disabled variable
  - renamed pdata variable name to priv

 drivers/uio/Kconfig           |   13 ++
 drivers/uio/Makefile          |    1 
 drivers/uio/uio_pdrv_genirq.c |  188 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 202 insertions(+)

--- 0003/drivers/uio/Kconfig
+++ work/drivers/uio/Kconfig	2008-07-11 18:38:33.000000000 +0900
@@ -33,6 +33,19 @@ config UIO_PDRV
 
 	  If you don't know what to do here, say N.
 
+config UIO_PDRV_GENIRQ
+	tristate "Userspace I/O platform driver with generic IRQ handling"
+	help
+	  Platform driver for Userspace I/O devices, including generic
+	  interrupt handling code. Shared interrupts are not supported.
+
+	  This kernel driver requires that the matching userspace driver
+	  handles interrupts in a special way. Userspace is responsible
+	  for acknowledging the hardware device if needed, and re-enabling
+	  interrupts in the interrupt controller using the write() syscall.
+
+	  If you don't know what to do here, say N.
+
 config UIO_SMX
 	tristate "SMX cryptengine UIO interface"
 	depends on UIO
--- 0003/drivers/uio/Makefile
+++ work/drivers/uio/Makefile	2008-07-11 18:38:33.000000000 +0900
@@ -1,4 +1,5 @@
 obj-$(CONFIG_UIO)	+= uio.o
 obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
 obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
+obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
 obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
--- /dev/null
+++ work/drivers/uio/uio_pdrv_genirq.c	2008-07-11 18:44:12.000000000 +0900
@@ -0,0 +1,188 @@
+/*
+ * drivers/uio/uio_pdrv_genirq.c
+ *
+ * Userspace I/O platform driver with generic IRQ handling code.
+ *
+ * Copyright (C) 2008 Magnus Damm
+ *
+ * Based on uio_pdrv.c by Uwe Kleine-Koenig,
+ * Copyright (C) 2008 by Digi International Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/uio_driver.h>
+#include <linux/spinlock.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/stringify.h>
+
+#define DRIVER_NAME "uio_pdrv_genirq"
+
+struct uio_pdrv_genirq_platdata {
+	struct uio_info *uioinfo;
+	spinlock_t lock;
+	unsigned long flags;
+};
+
+static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
+{
+	struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
+
+	/* Just disable the interrupt in the interrupt controller, and
+	 * remember the state so we can allow user space to enable it later.
+	 */
+
+	if (!test_and_set_bit(0, &priv->flags))
+		disable_irq_nosync(irq);
+
+	return IRQ_HANDLED;
+}
+
+static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
+{
+	struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
+	unsigned long flags;
+
+	/* Allow user space to enable and disable the interrupt
+	 * in the interrupt controller, but keep track of the
+	 * state to prevent per-irq depth damage.
+	 *
+	 * Serialize this operation to support multiple tasks.
+	 */
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (irq_on) {
+		if (test_and_clear_bit(0, &priv->flags))
+			enable_irq(dev_info->irq);
+	} else {
+		if (!test_and_set_bit(0, &priv->flags))
+			disable_irq(dev_info->irq);
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+static int uio_pdrv_genirq_probe(struct platform_device *pdev)
+{
+	struct uio_info *uioinfo = pdev->dev.platform_data;
+	struct uio_pdrv_genirq_platdata *priv;
+	struct uio_mem *uiomem;
+	int ret = -EINVAL;
+	int i;
+
+	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
+		dev_err(&pdev->dev, "missing platform_data\n");
+		goto bad0;
+	}
+
+	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
+		dev_err(&pdev->dev, "interrupt configuration error\n");
+		goto bad0;
+	}
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "unable to kmalloc\n");
+		goto bad0;
+	}
+
+	priv->uioinfo = uioinfo;
+	spin_lock_init(&priv->lock);
+	priv->flags = 0; /* interrupt is enabled to begin with */
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
+	/* This driver requires no hardware specific kernel code to handle
+	 * interrupts. Instead, the interrupt handler simply disables the
+	 * interrupt in the interrupt controller. User space is responsible
+	 * for performing hardware specific acknowledge and re-enabling of
+	 * the interrupt in the interrupt controller.
+	 *
+	 * Interrupt sharing is not supported.
+	 */
+
+	uioinfo->irq_flags = IRQF_DISABLED;
+	uioinfo->handler = uio_pdrv_genirq_handler;
+	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
+	uioinfo->priv = priv;
+
+	ret = uio_register_device(&pdev->dev, priv->uioinfo);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to register uio device\n");
+		goto bad1;
+	}
+
+	platform_set_drvdata(pdev, priv);
+	return 0;
+ bad1:
+	kfree(priv);
+ bad0:
+	return ret;
+}
+
+static int uio_pdrv_genirq_remove(struct platform_device *pdev)
+{
+	struct uio_pdrv_genirq_platdata *priv = platform_get_drvdata(pdev);
+
+	uio_unregister_device(priv->uioinfo);
+	kfree(priv);
+	return 0;
+}
+
+static struct platform_driver uio_pdrv_genirq = {
+	.probe = uio_pdrv_genirq_probe,
+	.remove = uio_pdrv_genirq_remove,
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init uio_pdrv_genirq_init(void)
+{
+	return platform_driver_register(&uio_pdrv_genirq);
+}
+
+static void __exit uio_pdrv_genirq_exit(void)
+{
+	platform_driver_unregister(&uio_pdrv_genirq);
+}
+
+module_init(uio_pdrv_genirq_init);
+module_exit(uio_pdrv_genirq_exit);
+
+MODULE_AUTHOR("Magnus Damm");
+MODULE_DESCRIPTION("Userspace I/O platform driver with generic IRQ handling");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
