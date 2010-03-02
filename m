Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0CBXgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:36:08 -0500
Received: from kroah.org ([198.145.64.141]:38653 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab0CBX3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:36 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/62] UIO: Add a driver for Hilscher netX-based fieldbus cards
Date: Tue,  2 Mar 2010 15:28:37 -0800
Message-Id: <1267572541-410-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

This patch adds a Userspace IO driver for netX-based fieldbus cards by
Hilscher (see http://www.hilscher.com). ATM, cifX and comX cards are
supported. The userspace part for this driver is provided by Hilscher
and should come with the card.
The driver is in use for several months now and has been tested by
people at Hilscher and Linutronix.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig    |   11 +++
 drivers/uio/Makefile   |    1 +
 drivers/uio/uio_netx.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 184 insertions(+), 0 deletions(-)
 create mode 100644 drivers/uio/uio_netx.c

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 8aa1955..069b144 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -94,4 +94,15 @@ config UIO_PCI_GENERIC
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
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index 73b2e75..aa7d033 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
 obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
 obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
 obj-$(CONFIG_UIO_PCI_GENERIC)	+= uio_pci_generic.o
+obj-$(CONFIG_UIO_NETX)	+= uio_netx.o
diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
new file mode 100644
index 0000000..afbf0bd
--- /dev/null
+++ b/drivers/uio/uio_netx.c
@@ -0,0 +1,172 @@
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
+#define PCI_VENDOR_ID_HILSCHER		0x15CF
+#define PCI_DEVICE_ID_HILSCHER_NETX	0x0000
+#define PCI_SUBDEVICE_ID_NXSB_PCA	0x3235
+#define PCI_SUBDEVICE_ID_NXPCA		0x3335
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
-- 
1.7.0.1

