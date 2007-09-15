Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbXIOUYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbXIOUYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 16:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXIOUXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 16:23:55 -0400
Received: from usul.saidi.cx ([204.11.33.34]:59919 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753118AbXIOUXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 16:23:54 -0400
X-Greylist: delayed 1776 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 16:23:54 EDT
Message-ID: <46EC3860.3070600@overt.org>
Date: Sat, 15 Sep 2007 12:54:08 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>, sdhci-devel@list.drzeus.cx,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: Disabler for Ricoh MMC controller
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Matt Domsch and Rezwanul Kabir at Dell, we know how to disable the
MMC controller on the multi-function Ricoh R5C832. The MMC controller needs
to be disabled or it will steal MMC cards from the SD controller where they
would otherwise be supported by the Linux SDHCI driver.

Signed-off-by: Philipl Langdale <philipl@overt.org>

--- linux-2.6.22/drivers/mmc/host/Kconfig	2007-07-08 16:32:17.000000000 -0700
+++ linux-ricoh/drivers/mmc/host/Kconfig	2007-09-15 12:32:10.000000000 -0700
@@ -35,6 +35,23 @@

 	  If unsure, say N.

+config MMC_RICOH_MMC
+	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
+	depends on PCI && EXPERIMENTAL && MMC_SDHCI
+	help
+	  This selects the disabler for the Ricoh MMC Controller. This
+	  proprietary controller is unnecessary because the SDHCI driver
+	  supports MMC cards on the SD controller, but if it is not
+	  disabled, it will steal the MMC cards away - rendering them
+	  useless. It is safe to select this driver even if you don't
+	  have a Ricoh based card reader.
+
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called ricoh_mmc.
+
+	  If unsure, say Y.
+
 config MMC_OMAP
 	tristate "TI OMAP Multimedia Card Interface support"
 	depends on ARCH_OMAP
--- linux-2.6.22/drivers/mmc/host/Makefile	2007-07-08 16:32:17.000000000 -0700
+++ linux-ricoh/drivers/mmc/host/Makefile	2007-09-15 12:28:49.000000000 -0700
@@ -15,4 +15,5 @@
 obj-$(CONFIG_MMC_OMAP)		+= omap.o
 obj-$(CONFIG_MMC_AT91)		+= at91_mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
+obj-$(CONFIG_MMC_RICOH_MMC)	+= ricoh_mmc.o

--- linux-2.6.22/drivers/mmc/host/ricoh_mmc.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-ricoh/drivers/mmc/host/ricoh_mmc.c	2007-09-15 12:29:05.000000000 -0700
@@ -0,0 +1,152 @@
+/*
+ *  ricoh_mmc.c - Dummy driver to disable the Rioch MMC controller.
+ *
+ *  Copyright (C) 2007 Philip Langdale, All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+/*
+ * This is a conceptually ridiculous driver, but it is required by the way
+ * the Ricoh multi-function R5C832 works. This chip implements firewire
+ * and four different memory card controllers. Two of those controllers are
+ * an SDHCI controller and a proprietary MMC controller. The linux SDHCI
+ * driver supports MMC cards but the chip detects MMC cards in hardware
+ * and directs them to the MMC controller - so the SDHCI driver never sees
+ * them. To get around this, we must disable the useless MMC controller.
+ * At that point, the SDHCI controller will start seeing them. As a bonus,
+ * a detection event occurs immediately, even if the MMC card is already
+ * in the reader.
+ *
+ * The relevant registers live on the firewire function, so this is unavoidably
+ * ugly. Such is life.
+ */
+
+#include <linux/pci.h>
+
+#define DRIVER_NAME "ricoh-mmc"
+
+static const struct pci_device_id pci_ids[] __devinitdata = {
+	{
+		.vendor		= PCI_VENDOR_ID_RICOH,
+		.device		= PCI_DEVICE_ID_RICOH_R5C843,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	},
+};
+
+MODULE_DEVICE_TABLE(pci, pci_ids);
+
+static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
+				     const struct pci_device_id *ent)
+{
+	u8 rev;
+
+	struct pci_dev *fw_dev = NULL;
+
+	BUG_ON(pdev == NULL);
+	BUG_ON(ent == NULL);
+
+	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &rev);
+
+	printk(KERN_INFO DRIVER_NAME
+		": Ricoh MMC controller found at %s [%04x:%04x] (rev %x)\n",
+		pci_name(pdev), (int)pdev->vendor, (int)pdev->device,
+		(int)rev);
+
+	while ((fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
+		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
+		    pdev->bus == fw_dev->bus) {
+			u8 write_enable;
+			u8 disable;
+
+			pci_read_config_byte(fw_dev, 0xCB, &disable);
+			if (disable & 0x02) {
+				printk(KERN_INFO DRIVER_NAME
+				       ": Controller already disabled. Nothing to do.\n");
+				return -ENODEV;
+			}
+
+			pci_read_config_byte(fw_dev, 0xCA, &write_enable);
+			pci_write_config_byte(fw_dev, 0xCA, 0x57);
+			pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
+			pci_write_config_byte(fw_dev, 0xCA, write_enable);
+
+			pci_set_drvdata(pdev, fw_dev);
+
+			printk(KERN_INFO DRIVER_NAME
+			       ": Controller is now disabled.\n");
+
+			break;
+		}
+	}
+
+	if (pci_get_drvdata(pdev) == NULL) {
+		printk(KERN_WARNING DRIVER_NAME
+		       ": Main firewire function not found. Cannot disable controller.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
+{
+	u8 write_enable;
+	u8 disable;
+	struct pci_dev *fw_dev = NULL;
+
+	fw_dev = pci_get_drvdata(pdev);
+	BUG_ON(fw_dev == NULL);
+
+	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
+	pci_read_config_byte(fw_dev, 0xCB, &disable);
+	pci_write_config_byte(fw_dev, 0xCA, 0x57);
+	pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
+	pci_write_config_byte(fw_dev, 0xCA, write_enable);
+
+	printk(KERN_INFO DRIVER_NAME
+	       ": Controller is now re-enabled.\n");
+
+	pci_set_drvdata(pdev, NULL);
+}
+
+static struct pci_driver ricoh_mmc_driver = {
+	.name = 	DRIVER_NAME,
+	.id_table =	pci_ids,
+	.probe = 	ricoh_mmc_probe,
+	.remove =	__devexit_p(ricoh_mmc_remove),
+};
+
+/*****************************************************************************\
+ *                                                                           *
+ * Driver init/exit                                                          *
+ *                                                                           *
+\*****************************************************************************/
+
+static int __init ricoh_mmc_drv_init(void)
+{
+	printk(KERN_INFO DRIVER_NAME
+		": Ricoh MMC Controller disabling driver\n");
+	printk(KERN_INFO DRIVER_NAME ": Copyright(c) Philip Langdale\n");
+
+	return pci_register_driver(&ricoh_mmc_driver);
+}
+
+static void __exit ricoh_mmc_drv_exit(void)
+{
+	DBG("Exiting\n");
+
+	pci_unregister_driver(&ricoh_mmc_driver);
+}
+
+module_init(ricoh_mmc_drv_init);
+module_exit(ricoh_mmc_drv_exit);
+
+MODULE_AUTHOR("Philip Langdale <philipl@alumni.utexas.net>");
+MODULE_DESCRIPTION("Ricoh MMC Controller disabling driver");
+MODULE_LICENSE("GPL");
+
--- linux-2.6.22/include/linux/pci_ids.h	2007-09-02 00:14:25.000000000 -0700
+++ linux-ricoh/include/linux/pci_ids.h	2007-09-15 12:27:36.000000000 -0700
@@ -1485,6 +1485,8 @@
 #define PCI_DEVICE_ID_RICOH_RL5C476	0x0476
 #define PCI_DEVICE_ID_RICOH_RL5C478	0x0478
 #define PCI_DEVICE_ID_RICOH_R5C822	0x0822
+#define PCI_DEVICE_ID_RICOH_R5C832	0x0832
+#define PCI_DEVICE_ID_RICOH_R5C843	0x0843

 #define PCI_VENDOR_ID_DLINK		0x1186
 #define PCI_DEVICE_ID_DLINK_DGE510T	0x4c00
