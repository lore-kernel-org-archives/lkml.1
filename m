Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab0BITNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:13:54 -0500
Received: from www.tglx.de ([62.245.132.106]:50095 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0BITNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:13:52 -0500
Date: Tue, 9 Feb 2010 20:13:49 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Manuel Traut <manut@linutronix.de>
Subject: [PATCH] UIO: Add a driver for Hilscher netX-based fieldbus cards
Message-ID: <20100209191349.GE3229@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a Userspace IO driver for netX-based fieldbus cards by
Hilscher (see http://www.hilscher.com). ATM, cifX and comX cards are
supported. The userspace part for this driver is provided by Hilscher
and should come with the card.
The driver is in use for several months now and has been tested by
people at Hilscher and Linutronix.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
 drivers/uio/Kconfig     |   11 +++
 drivers/uio/Makefile    |    1 
 drivers/uio/uio_netx.c  |  167 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    5 +
 4 files changed, 184 insertions(+)

Index: linux-2.6.33-rc/drivers/uio/Kconfig
===================================================================
--- linux-2.6.33-rc.orig/drivers/uio/Kconfig	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.33-rc/drivers/uio/Kconfig	2010-02-09 14:23:17.000000000 +0100
@@ -94,4 +94,15 @@
 	  primarily, for virtualization scenarios.
 	  If you compile this as a module, it will be called uio_pci_generic.
 
+config UIO_NETX
+	tristate "Hilscher NetX Card driver"
+	depends on PCI
+	help
+	  Driver for Hilscher NetX based fieldbus cards (cifX, comX).
+	  This driver requires a userspace component that comes with the card
+	  or is available from Hilscher (http://www.hilscher.com).
+
+	  To compile this driver as a module, choose M here; the module
+	  will be called uio_netx.
+
 endif
Index: linux-2.6.33-rc/drivers/uio/Makefile
===================================================================
--- linux-2.6.33-rc.orig/drivers/uio/Makefile	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.33-rc/drivers/uio/Makefile	2010-02-09 14:46:08.000000000 +0100
@@ -6,3 +6,4 @@
 obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
 obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
 obj-$(CONFIG_UIO_PCI_GENERIC)	+= uio_pci_generic.o
+obj-$(CONFIG_UIO_NETX)	+= uio_netx.o
Index: linux-2.6.33-rc/drivers/uio/uio_netx.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.33-rc/drivers/uio/uio_netx.c	2010-02-09 16:37:49.000000000 +0100
@@ -0,0 +1,167 @@
+/*
+ * UIO driver for Hilscher NetX based fieldbus cards (cifX, comX).
+ * See http://www.hilscher.com for details.
+ *
+ * (C) 2007 Hans J. Koch <hjk@linutronix.de>
+ * (C) 2008 Manuel Traut <manut@linutronix.de>
+ *
+ * Licensed under GPL version 2 only.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/uio_driver.h>
+
+#define DPM_HOST_INT_EN0	0xfff0
+#define DPM_HOST_INT_STAT0	0xffe0
+
+#define DPM_HOST_INT_MASK	0xe600ffff
+#define DPM_HOST_INT_GLOBAL_EN	0x80000000
+
+static irqreturn_t netx_handler(int irq, struct uio_info *dev_info)
+{
+	void __iomem *int_enable_reg = dev_info->mem[0].internal_addr
+					+ DPM_HOST_INT_EN0;
+	void __iomem *int_status_reg = dev_info->mem[0].internal_addr
+					+ DPM_HOST_INT_STAT0;
+
+	/* Is one of our interrupts enabled and active ? */
+	if (!(ioread32(int_enable_reg) & ioread32(int_status_reg)
+		& DPM_HOST_INT_MASK))
+		return IRQ_NONE;
+
+	/* Disable interrupt */
+	iowrite32(ioread32(int_enable_reg) & ~DPM_HOST_INT_GLOBAL_EN,
+		int_enable_reg);
+	return IRQ_HANDLED;
+}
+
+static int __devinit netx_pci_probe(struct pci_dev *dev,
+					const struct pci_device_id *id)
+{
+	struct uio_info *info;
+	int bar;
+
+	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	if (pci_enable_device(dev))
+		goto out_free;
+
+	if (pci_request_regions(dev, "netx"))
+		goto out_disable;
+
+	switch (id->device) {
+	case PCI_DEVICE_ID_HILSCHER_NETX:
+		bar = 0;
+		info->name = "netx";
+		break;
+	default:
+		bar = 2;
+		info->name = "netx_plx";
+	}
+
+	/* BAR0 or 2 points to the card's dual port memory */
+	info->mem[0].addr = pci_resource_start(dev, bar);
+	if (!info->mem[0].addr)
+		goto out_release;
+	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, bar),
+						pci_resource_len(dev, bar));
+
+	if (!info->mem[0].internal_addr)
+			goto out_release;
+
+	info->mem[0].size = pci_resource_len(dev, bar);
+	info->mem[0].memtype = UIO_MEM_PHYS;
+	info->irq = dev->irq;
+	info->irq_flags = IRQF_SHARED;
+	info->handler = netx_handler;
+	info->version = "0.0.1";
+
+	/* Make sure all interrupts are disabled */
+	iowrite32(0, info->mem[0].internal_addr + DPM_HOST_INT_EN0);
+
+	if (uio_register_device(&dev->dev, info))
+		goto out_unmap;
+
+	pci_set_drvdata(dev, info);
+	dev_info(&dev->dev, "Found %s card, registered UIO device.\n",
+				info->name);
+
+	return 0;
+
+out_unmap:
+	iounmap(info->mem[0].internal_addr);
+out_release:
+	pci_release_regions(dev);
+out_disable:
+	pci_disable_device(dev);
+out_free:
+	kfree(info);
+	return -ENODEV;
+}
+
+static void netx_pci_remove(struct pci_dev *dev)
+{
+	struct uio_info *info = pci_get_drvdata(dev);
+
+	/* Disable all interrupts */
+	iowrite32(0, info->mem[0].internal_addr + DPM_HOST_INT_EN0);
+	uio_unregister_device(info);
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+	pci_set_drvdata(dev, NULL);
+	iounmap(info->mem[0].internal_addr);
+
+	kfree(info);
+}
+
+static struct pci_device_id netx_pci_ids[] = {
+	{
+		.vendor =	PCI_VENDOR_ID_HILSCHER,
+		.device =	PCI_DEVICE_ID_HILSCHER_NETX,
+		.subvendor =	0,
+		.subdevice =	0,
+	},
+	{
+		.vendor =	PCI_VENDOR_ID_PLX,
+		.device =	PCI_DEVICE_ID_PLX_9030,
+		.subvendor =	PCI_VENDOR_ID_PLX,
+		.subdevice =	PCI_SUBDEVICE_ID_NXSB_PCA,
+	},
+	{
+		.vendor =	PCI_VENDOR_ID_PLX,
+		.device =	PCI_DEVICE_ID_PLX_9030,
+		.subvendor =	PCI_VENDOR_ID_PLX,
+		.subdevice =	PCI_SUBDEVICE_ID_NXPCA,
+	},
+	{ 0, }
+};
+
+static struct pci_driver netx_pci_driver = {
+	.name = "netx",
+	.id_table = netx_pci_ids,
+	.probe = netx_pci_probe,
+	.remove = netx_pci_remove,
+};
+
+static int __init netx_init_module(void)
+{
+	return pci_register_driver(&netx_pci_driver);
+}
+
+static void __exit netx_exit_module(void)
+{
+	pci_unregister_driver(&netx_pci_driver);
+}
+
+module_init(netx_init_module);
+module_exit(netx_exit_module);
+
+MODULE_DEVICE_TABLE(pci, netx_pci_ids);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Hans J. Koch, Manuel Traut");
Index: linux-2.6.33-rc/include/linux/pci_ids.h
===================================================================
--- linux-2.6.33-rc.orig/include/linux/pci_ids.h	2010-02-09 12:43:51.000000000 +0100
+++ linux-2.6.33-rc/include/linux/pci_ids.h	2010-02-09 12:44:51.000000000 +0100
@@ -137,6 +137,11 @@
 
 /* Vendors and devices.  Sort key: vendor first, device next. */
 
+#define PCI_VENDOR_ID_HILSCHER		0x15CF
+#define PCI_DEVICE_ID_HILSCHER_NETX	0x0000
+#define PCI_SUBDEVICE_ID_NXSB_PCA	0x3235
+#define PCI_SUBDEVICE_ID_NXPCA		0x3335
+
 #define PCI_VENDOR_ID_TTTECH		0x0357
 #define PCI_DEVICE_ID_TTTECH_MC322	0x000a
 
