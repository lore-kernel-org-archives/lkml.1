Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbZATUru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbZATUru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbZATUrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:47:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:11499 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937AbZATUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:47:40 -0500
Date: Tue, 20 Jan 2009 12:47:29 -0800
From: Brandon Philips <brandon@ifup.org>
To: hjk@linutronix.de, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: uio: add the uio_aec driver
Message-ID: <20090120204729.GA26477@jenkins.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UIO driver for the Adrienne Electronics Corporation PCI time code
device.

This device differs from other UIO devices since it uses I/O ports instead of
memory mapped I/O. In order to make it possible for UIO to work with this
device a utility, uioport, can be used to read and write the ports.

uioport is designed to be a setuid program and checks the permissions of
the /dev/uio* node and if the user has write permissions it will use
iopl and out*/in* to access the device.

[1] git clone git://ifup.org/philips/uioport.git

Signed-off-by: Brandon Philips <brandon@ifup.org>

---
 drivers/uio/Kconfig        |   18 ++++
 drivers/uio/Makefile       |    1 
 drivers/uio/uio_aec.c      |  177 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/uio_driver.h |    1 
 4 files changed, 197 insertions(+)

Index: linux-2.6/drivers/uio/Makefile
===================================================================
--- linux-2.6.orig/drivers/uio/Makefile
+++ linux-2.6/drivers/uio/Makefile
@@ -3,4 +3,5 @@ obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
 obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
 obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
 obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
+obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
 obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
Index: linux-2.6/include/linux/uio_driver.h
===================================================================
--- linux-2.6.orig/include/linux/uio_driver.h
+++ linux-2.6/include/linux/uio_driver.h
@@ -91,5 +91,6 @@ extern void uio_event_notify(struct uio_
 #define UIO_MEM_PHYS	1
 #define UIO_MEM_LOGICAL	2
 #define UIO_MEM_VIRTUAL 3
+#define UIO_MEM_PORT	4
 
 #endif /* _LINUX_UIO_DRIVER_H_ */
Index: linux-2.6/drivers/uio/Kconfig
===================================================================
--- linux-2.6.orig/drivers/uio/Kconfig
+++ linux-2.6/drivers/uio/Kconfig
@@ -58,6 +58,24 @@ config UIO_SMX
 
 	  If you compile this as a module, it will be called uio_smx.
 
+config UIO_AEC
+	tristate "AEC video timestamp device"
+	depends on PCI
+	default n
+	help
+
+	  UIO driver for the Adrienne Electronics Corporation PCI time
+	  code device.
+
+	  This device differs from other UIO devices since it uses I/O
+	  ports instead of memory mapped I/O. In order to make it
+	  possible for UIO to work with this device a utility, uioport,
+	  can be used to read and write the ports:
+
+	    git clone git://ifup.org/philips/uioport.git
+
+	  If you compile this as a module, it will be called uio_aec.
+
 config UIO_SERCOS3
 	tristate "Automata Sercos III PCI card driver"
 	default n
Index: linux-2.6/drivers/uio/uio_aec.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/uio/uio_aec.c
@@ -0,0 +1,177 @@
+/*
+ * uio_aec.c -- simple driver for Adrienne Electronics Corp time code PCI device
+ *
+ * Copyright (C) 2008 Brandon Philips <brandon@ifup.org>
+ *
+ *   This program is free software; you can redistribute it and/or modify it
+ *   under the terms of the GNU General Public License version 2 as published
+ *   by the Free Software Foundation.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License along
+ *   with this program; if not, write to the Free Software Foundation, Inc., 59
+ *   Temple Place, Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <asm/system.h>
+#include <linux/uaccess.h>
+#include <linux/uio_driver.h>
+
+#define PCI_VENDOR_ID_AEC 0xaecb
+#define PCI_DEVICE_ID_AEC_VITCLTC 0x6250
+
+#define INT_ENABLE_ADDR		0xFC
+#define INT_ENABLE		0x10
+#define INT_DISABLE		0x0
+
+#define INT_MASK_ADDR		0x2E
+#define INT_MASK_ALL		0x3F
+
+#define INTA_DRVR_ADDR		0xFE
+#define INTA_ENABLED_FLAG	0x08
+#define INTA_FLAG		0x01
+
+#define MAILBOX			0x0F
+
+static struct pci_device_id ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AEC, PCI_DEVICE_ID_AEC_VITCLTC), },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, ids);
+
+static irqreturn_t aectc_irq(int irq, struct uio_info *dev_info)
+{
+	void __iomem *int_flag = dev_info->mem[0].internal_addr
+					+ INTA_DRVR_ADDR;
+	unsigned char status = ioread8(int_flag);
+
+
+	if ((status & INTA_ENABLED_FLAG) && (status & INTA_FLAG)) {
+		/* application writes 0x00 to 0x2F to get next interrupt */
+		status = ioread8(dev_info->mem[0].internal_addr + MAILBOX);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static void print_board_data(struct uio_info *i)
+{
+	printk(KERN_INFO "PCI-TC board vendor: %x%x number: %x%x"
+		" revision: %c%c\n",
+		ioread8(i->mem[0].internal_addr + 0x01),
+		ioread8(i->mem[0].internal_addr + 0x00),
+		ioread8(i->mem[0].internal_addr + 0x03),
+		ioread8(i->mem[0].internal_addr + 0x02),
+		ioread8(i->mem[0].internal_addr + 0x06),
+		ioread8(i->mem[0].internal_addr + 0x07));
+}
+
+static int __devinit probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	struct uio_info *info;
+	int ret;
+
+	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	if (pci_enable_device(dev))
+		goto out_free;
+
+	if (pci_request_regions(dev, "aectc"))
+		goto out_disable;
+
+	info->name = "aectc";
+	info->mem[0].addr = pci_resource_start(dev, 0);
+	if (!info->mem[0].addr)
+		goto out_release;
+	info->mem[0].internal_addr = pci_iomap(dev, 0, 0);
+	if (!info->mem[0].internal_addr)
+		goto out_release;
+	info->mem[0].size = pci_resource_len(dev, 0);
+	info->mem[0].memtype = UIO_MEM_PORT;
+
+	info->version = "0.0.1";
+	info->irq = dev->irq;
+	info->irq_flags = IRQF_DISABLED | IRQF_SHARED;
+	info->handler = aectc_irq;
+
+	print_board_data(info);
+	ret = uio_register_device(&dev->dev, info);
+	if (ret)
+		goto out_unmap;
+
+	iowrite32(INT_ENABLE, info->mem[0].internal_addr + INT_ENABLE_ADDR);
+	iowrite8(INT_MASK_ALL, info->mem[0].internal_addr + INT_MASK_ADDR);
+	if (ioread8(info->mem[0].internal_addr + INTA_DRVR_ADDR)
+			& INTA_ENABLED_FLAG)
+		printk(KERN_INFO "aectc: interrupts successfully enabled\n");
+
+	pci_set_drvdata(dev, info);
+
+	return 0;
+
+out_unmap:
+	pci_iounmap(dev, info->mem[0].internal_addr);
+out_release:
+	pci_release_regions(dev);
+out_disable:
+	pci_disable_device(dev);
+out_free:
+	kfree(info);
+	return -ENODEV;
+}
+
+static void remove(struct pci_dev *dev)
+{
+	struct uio_info *info = pci_get_drvdata(dev);
+
+	/* disable interrupts */
+	iowrite8(INT_DISABLE, info->mem[0].internal_addr + INT_MASK_ADDR);
+	iowrite32(INT_DISABLE, info->mem[0].internal_addr + INT_ENABLE_ADDR);
+	/* read mailbox to ensure board drops irq */
+	ioread8(info->mem[0].internal_addr + MAILBOX);
+
+	uio_unregister_device(info);
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+	pci_set_drvdata(dev, NULL);
+	iounmap(info->mem[0].internal_addr);
+
+	kfree(info);
+}
+
+static struct pci_driver pci_driver = {
+	.name = "aectc",
+	.id_table = ids,
+	.probe = probe,
+	.remove = remove,
+};
+
+static int __init aectc_init(void)
+{
+	return pci_register_driver(&pci_driver);
+}
+
+static void __exit aectc_exit(void)
+{
+	pci_unregister_driver(&pci_driver);
+}
+
+MODULE_LICENSE("GPL");
+
+module_init(aectc_init);
+module_exit(aectc_exit);
