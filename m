Return-Path: <linux-kernel-owner+w=401wt.eu-S936980AbXGRXf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936980AbXGRXf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936438AbXGRX1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:27:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:33093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935960AbXGRX1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:27:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Hans-J=C3=BCrgen=20Koch?= <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] UIO: Hilscher CIF card driver
Date: Wed, 18 Jul 2007 16:26:45 -0700
Message-Id: <1184801218392-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848012122374-git-send-email-gregkh@suse.de>
References: <20070718232332.GA4620@kroah.com>
 <11848012053678-git-send-email-gregkh@suse.de>
 <11848012122374-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Jürgen Koch <hjk@linutronix.de>

this is a patch that adds support for Hilscher CIF DeviceNet and
Profibus cards. I tested it on a Kontron CPX board, and Thomas reviewed
it.

You can find the user space part here:

http://www.osadl.org/projects/downloads/UIO/user/cif-0.1.0.tar.gz

Notes: cif_api.c is the main file you want to look at. It contains the
functions to open, close, mmap and so on. cif_dps.c adds functions
specific to Profibus cards, and cif_dn.c contains functions for
DeviceNet cards.  cif.c is a universal playground, it's just a small
test program.  The user space part of this UIO driver is still work in
progress, and not everything is tested yet. At the moment, the thread in
cif_api.c contains some code that artificially makes the card generate
interrupts, this was added for testing and will be removed later. But
the driver already contains all the functions needed for useful
operation, so it gives a good idea of how such a thing looks like.

For comparison, here's what you get from the manufacturer
(www.hilscher.com) when you ask for a Linux 2.6 driver:

http://www.tglx.de/private/hjk/cif-orig-2.6.tar.bz2

WARNING: Don't look at the code for too long, you might become sick :-)


Signed-off-by: Hans-Jürgen Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig   |   13 ++++
 drivers/uio/Makefile  |    3 +-
 drivers/uio/uio_cif.c |  156 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+), 1 deletions(-)
 create mode 100644 drivers/uio/uio_cif.c

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 6b1a62d..b778ed7 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -13,4 +13,17 @@ config UIO
 
 	  If you don't know what to do here, say N.
 
+config UIO_CIF
+	tristate "generic Hilscher CIF Card driver"
+	depends on UIO && PCI
+	default n
+	help
+	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
+	  driver requires a userspace component that handles all of the
+	  heavy lifting and can be found at:
+	  	http://www.osadl.org/projects/downloads/UIO/user/cif-*
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called uio_cif.
+
 endmenu
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index 9b7c830..7fecfb4 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -1 +1,2 @@
-obj-$(CONFIG_UIO) += uio.o
+obj-$(CONFIG_UIO)	+= uio.o
+obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
new file mode 100644
index 0000000..838bae4
--- /dev/null
+++ b/drivers/uio/uio_cif.c
@@ -0,0 +1,156 @@
+/*
+ * UIO Hilscher CIF card driver
+ *
+ * (C) 2007 Hans J. Koch <hjk@linutronix.de>
+ * Original code (C) 2005 Benedikt Spranger <b.spranger@linutronix.de>
+ *
+ * Licensed under GPL version 2 only.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/uio_driver.h>
+
+#include <asm/io.h>
+
+#ifndef PCI_DEVICE_ID_PLX_9030
+#define PCI_DEVICE_ID_PLX_9030	0x9030
+#endif
+
+#define PLX9030_INTCSR		0x4C
+#define INTSCR_INT1_ENABLE	0x01
+#define INTSCR_INT1_STATUS	0x04
+#define INT1_ENABLED_AND_ACTIVE	(INTSCR_INT1_ENABLE | INTSCR_INT1_STATUS)
+
+#define PCI_SUBVENDOR_ID_PEP	0x1518
+#define CIF_SUBDEVICE_PROFIBUS	0x430
+#define CIF_SUBDEVICE_DEVICENET	0x432
+
+
+static irqreturn_t hilscher_handler(int irq, struct uio_info *dev_info)
+{
+	void __iomem *plx_intscr = dev_info->mem[0].internal_addr
+					+ PLX9030_INTCSR;
+
+	if ((ioread8(plx_intscr) & INT1_ENABLED_AND_ACTIVE)
+	    != INT1_ENABLED_AND_ACTIVE)
+		return IRQ_NONE;
+
+	/* Disable interrupt */
+	iowrite8(ioread8(plx_intscr) & ~INTSCR_INT1_ENABLE, plx_intscr);
+	return IRQ_HANDLED;
+}
+
+static int __devinit hilscher_pci_probe(struct pci_dev *dev,
+					const struct pci_device_id *id)
+{
+	struct uio_info *info;
+
+	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	if (pci_enable_device(dev))
+		goto out_free;
+
+	if (pci_request_regions(dev, "hilscher"))
+		goto out_disable;
+
+	info->mem[0].addr = pci_resource_start(dev, 0);
+	if (!info->mem[0].addr)
+		goto out_release;
+	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, 0),
+					     pci_resource_len(dev, 0));
+	if (!info->mem[0].internal_addr)
+		goto out_release;
+
+	info->mem[0].size = pci_resource_len(dev, 0);
+	info->mem[0].memtype = UIO_MEM_PHYS;
+	info->mem[1].addr = pci_resource_start(dev, 2);
+	info->mem[1].size = pci_resource_len(dev, 2);
+	info->mem[1].memtype = UIO_MEM_PHYS;
+	switch (id->subdevice) {
+		case CIF_SUBDEVICE_PROFIBUS:
+			info->name = "CIF_Profibus";
+			break;
+		case CIF_SUBDEVICE_DEVICENET:
+			info->name = "CIF_Devicenet";
+			break;
+		default:
+			info->name = "CIF_???";
+	}
+	info->version = "0.0.1";
+	info->irq = dev->irq;
+	info->irq_flags = IRQF_DISABLED | IRQF_SHARED;
+	info->handler = hilscher_handler;
+
+	if (uio_register_device(&dev->dev, info))
+		goto out_unmap;
+
+	pci_set_drvdata(dev, info);
+
+	return 0;
+out_unmap:
+	iounmap(info->mem[0].internal_addr);
+out_release:
+	pci_release_regions(dev);
+out_disable:
+	pci_disable_device(dev);
+out_free:
+	kfree (info);
+	return -ENODEV;
+}
+
+static void hilscher_pci_remove(struct pci_dev *dev)
+{
+	struct uio_info *info = pci_get_drvdata(dev);
+
+	uio_unregister_device(info);
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+	pci_set_drvdata(dev, NULL);
+	iounmap(info->mem[0].internal_addr);
+
+	kfree (info);
+}
+
+static struct pci_device_id hilscher_pci_ids[] = {
+	{
+		.vendor =	PCI_VENDOR_ID_PLX,
+		.device =	PCI_DEVICE_ID_PLX_9030,
+		.subvendor =	PCI_SUBVENDOR_ID_PEP,
+		.subdevice =	CIF_SUBDEVICE_PROFIBUS,
+	},
+	{
+		.vendor =	PCI_VENDOR_ID_PLX,
+		.device =	PCI_DEVICE_ID_PLX_9030,
+		.subvendor =	PCI_SUBVENDOR_ID_PEP,
+		.subdevice =	CIF_SUBDEVICE_DEVICENET,
+	},
+	{ 0, }
+};
+
+static struct pci_driver hilscher_pci_driver = {
+	.name = "hilscher",
+	.id_table = hilscher_pci_ids,
+	.probe = hilscher_pci_probe,
+	.remove = hilscher_pci_remove,
+};
+
+static int __init hilscher_init_module(void)
+{
+	return pci_register_driver(&hilscher_pci_driver);
+}
+
+static void __exit hilscher_exit_module(void)
+{
+	pci_unregister_driver(&hilscher_pci_driver);
+}
+
+module_init(hilscher_init_module);
+module_exit(hilscher_exit_module);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Hans J. Koch, Benedikt Spranger");
-- 
1.5.2.2

