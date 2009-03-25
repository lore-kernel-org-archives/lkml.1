Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbZCYAnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbZCYAnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbZCYAaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:18 -0400
Received: from kroah.org ([198.145.64.141]:54138 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756884AbZCYAaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Brandon Philips <brandon@ifup.org>, "Hans J. Koch" <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/61] uio: add the uio_aec driver
Date: Tue, 24 Mar 2009 17:26:40 -0700
Message-Id: <1237940825-22904-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brandon Philips <brandon@ifup.org>

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
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig   |   18 +++++
 drivers/uio/Makefile  |    1 +
 drivers/uio/uio_aec.c |  175 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 194 insertions(+), 0 deletions(-)
 create mode 100644 drivers/uio/uio_aec.c

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 04b954c..7f86534 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
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
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index e695581..5c2586d 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -3,4 +3,5 @@ obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
 obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
 obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
 obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
+obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
 obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
diff --git a/drivers/uio/uio_aec.c b/drivers/uio/uio_aec.c
new file mode 100644
index 0000000..b7830e9
--- /dev/null
+++ b/drivers/uio/uio_aec.c
@@ -0,0 +1,175 @@
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
+	void __iomem *int_flag = dev_info->priv + INTA_DRVR_ADDR;
+	unsigned char status = ioread8(int_flag);
+
+
+	if ((status & INTA_ENABLED_FLAG) && (status & INTA_FLAG)) {
+		/* application writes 0x00 to 0x2F to get next interrupt */
+		status = ioread8(dev_info->priv + MAILBOX);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static void print_board_data(struct pci_dev *pdev, struct uio_info *i)
+{
+	dev_info(&pdev->dev, "PCI-TC board vendor: %x%x number: %x%x"
+		" revision: %c%c\n",
+		ioread8(i->priv + 0x01),
+		ioread8(i->priv + 0x00),
+		ioread8(i->priv + 0x03),
+		ioread8(i->priv + 0x02),
+		ioread8(i->priv + 0x06),
+		ioread8(i->priv + 0x07));
+}
+
+static int __devinit probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct uio_info *info;
+	int ret;
+
+	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	if (pci_enable_device(pdev))
+		goto out_free;
+
+	if (pci_request_regions(pdev, "aectc"))
+		goto out_disable;
+
+	info->name = "aectc";
+	info->port[0].start = pci_resource_start(pdev, 0);
+	if (!info->port[0].start)
+		goto out_release;
+	info->priv = pci_iomap(pdev, 0, 0);
+	if (!info->priv)
+		goto out_release;
+	info->port[0].size = pci_resource_len(pdev, 0);
+	info->port[0].porttype = UIO_PORT_GPIO;
+
+	info->version = "0.0.1";
+	info->irq = pdev->irq;
+	info->irq_flags = IRQF_SHARED;
+	info->handler = aectc_irq;
+
+	print_board_data(pdev, info);
+	ret = uio_register_device(&pdev->dev, info);
+	if (ret)
+		goto out_unmap;
+
+	iowrite32(INT_ENABLE, info->priv + INT_ENABLE_ADDR);
+	iowrite8(INT_MASK_ALL, info->priv + INT_MASK_ADDR);
+	if (!(ioread8(info->priv + INTA_DRVR_ADDR)
+			& INTA_ENABLED_FLAG))
+		dev_err(&pdev->dev, "aectc: interrupts not enabled\n");
+
+	pci_set_drvdata(pdev, info);
+
+	return 0;
+
+out_unmap:
+	pci_iounmap(pdev, info->priv);
+out_release:
+	pci_release_regions(pdev);
+out_disable:
+	pci_disable_device(pdev);
+out_free:
+	kfree(info);
+	return -ENODEV;
+}
+
+static void remove(struct pci_dev *pdev)
+{
+	struct uio_info *info = pci_get_drvdata(pdev);
+
+	/* disable interrupts */
+	iowrite8(INT_DISABLE, info->priv + INT_MASK_ADDR);
+	iowrite32(INT_DISABLE, info->priv + INT_ENABLE_ADDR);
+	/* read mailbox to ensure board drops irq */
+	ioread8(info->priv + MAILBOX);
+
+	uio_unregister_device(info);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+	iounmap(info->priv);
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
-- 
1.6.2

