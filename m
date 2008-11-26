Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYKZNhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYKZNhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYKZNhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:37:06 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:49445 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbYKZNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:37:03 -0500
From: Frans Pop <elendil@planet.nl>
To: Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
Date: Wed, 26 Nov 2008 14:36:56 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx, drzeus@drzeus.cx,
       fseidel@suse.de, weyland@library.ethz.ch,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <492BBA91.5010302@overt.org>
In-reply-To: <492BBA91.5010302@overt.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5DVLJJpXLLBvMIz"
Message-Id: <200811261436.57946.elendil@planet.nl>
X-OriginalArrivalTime: 26 Nov 2008 13:36:58.0574 (UTC) FILETIME=[0E210EE0:01C94FCC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_5DVLJJpXLLBvMIz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> The latest generation of laptops are shipping with a newer
> model of Ricoh chip where the firewire controller is the
> primary PCI function but a cardbus controller is also present.

Note that the current separate ricoh_mmc disabling module approach has 
been shown to break during suspend/resume. Matthew Garret proposed a 
patch for that which (with minor fixups) I tested successfully.

A fixed up version of Matthew's patch (not signed off) rebased against 
current mainline git is attached below. It does not include the changes 
proposed here.

Original bug report: http://lkml.org/lkml/2008/9/28/90
Matthew's analysis and patch: http://lkml.org/lkml/2008/9/29/87
Test results with patch: http://lkml.org/lkml/2008/9/29/195

Cheers,
FJP


--Boundary-00=_5DVLJJpXLLBvMIz
Content-Type: text/x-diff;
  charset="us-ascii";
  name="mmc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="mmc.patch"

From: Matthew Garrett <mjg59@srcf.ucam.org>

    mmc: Use a quirk to disable the proprietary Ricoh MMC controller
    
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index dfa585f..31c5f63 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -48,23 +48,6 @@ config MMC_SDHCI_PCI
 
 	  If unsure, say N.
 
-config MMC_RICOH_MMC
-	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
-	depends on MMC_SDHCI_PCI
-	help
-	  This selects the disabler for the Ricoh MMC Controller. This
-	  proprietary controller is unnecessary because the SDHCI driver
-	  supports MMC cards on the SD controller, but if it is not
-	  disabled, it will steal the MMC cards away - rendering them
-	  useless. It is safe to select this driver even if you don't
-	  have a Ricoh based card reader.
-
-
-	  To compile this driver as a module, choose M here:
-	  the module will be called ricoh_mmc.
-
-	  If unsure, say Y.
-
 config MMC_OMAP
 	tristate "TI OMAP Multimedia Card Interface support"
 	depends on ARCH_OMAP
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index c794cc5..0676890 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_MMC_PXA)		+= pxamci.o
 obj-$(CONFIG_MMC_IMX)		+= imxmmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
-obj-$(CONFIG_MMC_RICOH_MMC)	+= ricoh_mmc.o
 obj-$(CONFIG_MMC_WBSD)		+= wbsd.o
 obj-$(CONFIG_MMC_AU1X)		+= au1xmmc.o
 obj-$(CONFIG_MMC_OMAP)		+= omap.o
diff --git a/drivers/mmc/host/ricoh_mmc.c b/drivers/mmc/host/ricoh_mmc.c
deleted file mode 100644
index a16d760..0000000
--- a/drivers/mmc/host/ricoh_mmc.c
+++ /dev/null
@@ -1,257 +0,0 @@
-/*
- *  ricoh_mmc.c - Dummy driver to disable the Rioch MMC controller.
- *
- *  Copyright (C) 2007 Philip Langdale, All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or (at
- * your option) any later version.
- */
-
-/*
- * This is a conceptually ridiculous driver, but it is required by the way
- * the Ricoh multi-function R5C832 works. This chip implements firewire
- * and four different memory card controllers. Two of those controllers are
- * an SDHCI controller and a proprietary MMC controller. The linux SDHCI
- * driver supports MMC cards but the chip detects MMC cards in hardware
- * and directs them to the MMC controller - so the SDHCI driver never sees
- * them. To get around this, we must disable the useless MMC controller.
- * At that point, the SDHCI controller will start seeing them. As a bonus,
- * a detection event occurs immediately, even if the MMC card is already
- * in the reader.
- *
- * The relevant registers live on the firewire function, so this is unavoidably
- * ugly. Such is life.
- */
-
-#include <linux/pci.h>
-
-#define DRIVER_NAME "ricoh-mmc"
-
-static const struct pci_device_id pci_ids[] __devinitdata = {
-	{
-		.vendor		= PCI_VENDOR_ID_RICOH,
-		.device		= PCI_DEVICE_ID_RICOH_R5C843,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-	},
-	{ /* end: all zeroes */ },
-};
-
-MODULE_DEVICE_TABLE(pci, pci_ids);
-
-static int ricoh_mmc_disable(struct pci_dev *fw_dev)
-{
-	u8 write_enable;
-	u8 write_target;
-	u8 disable;
-
-	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
-		/* via RL5C476 */
-
-		pci_read_config_byte(fw_dev, 0xB7, &disable);
-		if (disable & 0x02) {
-			printk(KERN_INFO DRIVER_NAME
-				": Controller already disabled. " \
-				"Nothing to do.\n");
-			return -ENODEV;
-		}
-
-		pci_read_config_byte(fw_dev, 0x8E, &write_enable);
-		pci_write_config_byte(fw_dev, 0x8E, 0xAA);
-		pci_read_config_byte(fw_dev, 0x8D, &write_target);
-		pci_write_config_byte(fw_dev, 0x8D, 0xB7);
-		pci_write_config_byte(fw_dev, 0xB7, disable | 0x02);
-		pci_write_config_byte(fw_dev, 0x8E, write_enable);
-		pci_write_config_byte(fw_dev, 0x8D, write_target);
-	} else {
-		/* via R5C832 */
-
-		pci_read_config_byte(fw_dev, 0xCB, &disable);
-		if (disable & 0x02) {
-			printk(KERN_INFO DRIVER_NAME
-			       ": Controller already disabled. " \
-				"Nothing to do.\n");
-			return -ENODEV;
-		}
-
-		pci_read_config_byte(fw_dev, 0xCA, &write_enable);
-		pci_write_config_byte(fw_dev, 0xCA, 0x57);
-		pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
-		pci_write_config_byte(fw_dev, 0xCA, write_enable);
-	}
-
-	printk(KERN_INFO DRIVER_NAME
-	       ": Controller is now disabled.\n");
-
-	return 0;
-}
-
-static int ricoh_mmc_enable(struct pci_dev *fw_dev)
-{
-	u8 write_enable;
-	u8 write_target;
-	u8 disable;
-
-	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
-		/* via RL5C476 */
-
-		pci_read_config_byte(fw_dev, 0x8E, &write_enable);
-		pci_write_config_byte(fw_dev, 0x8E, 0xAA);
-		pci_read_config_byte(fw_dev, 0x8D, &write_target);
-		pci_write_config_byte(fw_dev, 0x8D, 0xB7);
-		pci_read_config_byte(fw_dev, 0xB7, &disable);
-		pci_write_config_byte(fw_dev, 0xB7, disable & ~0x02);
-		pci_write_config_byte(fw_dev, 0x8E, write_enable);
-		pci_write_config_byte(fw_dev, 0x8D, write_target);
-	} else {
-		/* via R5C832 */
-
-		pci_read_config_byte(fw_dev, 0xCA, &write_enable);
-		pci_read_config_byte(fw_dev, 0xCB, &disable);
-		pci_write_config_byte(fw_dev, 0xCA, 0x57);
-		pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
-		pci_write_config_byte(fw_dev, 0xCA, write_enable);
-	}
-
-	printk(KERN_INFO DRIVER_NAME
-	       ": Controller is now re-enabled.\n");
-
-	return 0;
-}
-
-static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
-				     const struct pci_device_id *ent)
-{
-	u8 rev;
-	u8 ctrlfound = 0;
-
-	struct pci_dev *fw_dev = NULL;
-
-	BUG_ON(pdev == NULL);
-	BUG_ON(ent == NULL);
-
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &rev);
-
-	printk(KERN_INFO DRIVER_NAME
-		": Ricoh MMC controller found at %s [%04x:%04x] (rev %x)\n",
-		pci_name(pdev), (int)pdev->vendor, (int)pdev->device,
-		(int)rev);
-
-	while ((fw_dev =
-		pci_get_device(PCI_VENDOR_ID_RICOH,
-			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
-		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
-		    pdev->bus == fw_dev->bus) {
-			if (ricoh_mmc_disable(fw_dev) != 0)
-				return -ENODEV;
-
-			pci_set_drvdata(pdev, fw_dev);
-
-			++ctrlfound;
-			break;
-		}
-	}
-
-	fw_dev = NULL;
-
-	while (!ctrlfound &&
-	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
-					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
-		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
-		    pdev->bus == fw_dev->bus) {
-			if (ricoh_mmc_disable(fw_dev) != 0)
-				return -ENODEV;
-
-			pci_set_drvdata(pdev, fw_dev);
-
-			++ctrlfound;
-		}
-	}
-
-	if (!ctrlfound) {
-		printk(KERN_WARNING DRIVER_NAME
-		       ": Main firewire function not found. Cannot disable controller.\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
-{
-	struct pci_dev *fw_dev = NULL;
-
-	fw_dev = pci_get_drvdata(pdev);
-	BUG_ON(fw_dev == NULL);
-
-	ricoh_mmc_enable(fw_dev);
-
-	pci_set_drvdata(pdev, NULL);
-}
-
-static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct pci_dev *fw_dev = NULL;
-
-	fw_dev = pci_get_drvdata(pdev);
-	BUG_ON(fw_dev == NULL);
-
-	printk(KERN_INFO DRIVER_NAME ": Suspending.\n");
-
-	ricoh_mmc_enable(fw_dev);
-
-	return 0;
-}
-
-static int ricoh_mmc_resume(struct pci_dev *pdev)
-{
-	struct pci_dev *fw_dev = NULL;
-
-	fw_dev = pci_get_drvdata(pdev);
-	BUG_ON(fw_dev == NULL);
-
-	printk(KERN_INFO DRIVER_NAME ": Resuming.\n");
-
-	ricoh_mmc_disable(fw_dev);
-
-	return 0;
-}
-
-static struct pci_driver ricoh_mmc_driver = {
-	.name = 	DRIVER_NAME,
-	.id_table =	pci_ids,
-	.probe = 	ricoh_mmc_probe,
-	.remove =	__devexit_p(ricoh_mmc_remove),
-	.suspend =	ricoh_mmc_suspend,
-	.resume =	ricoh_mmc_resume,
-};
-
-/*****************************************************************************\
- *                                                                           *
- * Driver init/exit                                                          *
- *                                                                           *
-\*****************************************************************************/
-
-static int __init ricoh_mmc_drv_init(void)
-{
-	printk(KERN_INFO DRIVER_NAME
-		": Ricoh MMC Controller disabling driver\n");
-	printk(KERN_INFO DRIVER_NAME ": Copyright(c) Philip Langdale\n");
-
-	return pci_register_driver(&ricoh_mmc_driver);
-}
-
-static void __exit ricoh_mmc_drv_exit(void)
-{
-	pci_unregister_driver(&ricoh_mmc_driver);
-}
-
-module_init(ricoh_mmc_drv_init);
-module_exit(ricoh_mmc_drv_exit);
-
-MODULE_AUTHOR("Philip Langdale <philipl@alumni.utexas.net>");
-MODULE_DESCRIPTION("Ricoh MMC Controller disabling driver");
-MODULE_LICENSE("GPL");
-
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5049a47..9939cab 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1711,6 +1711,74 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 			PCI_DEVICE_ID_NX2_5709S,
 			quirk_brcm_570x_limit_vpd);
 
+/*
+ * This is a conceptually ridiculous quirk, but it is required by the
+ * way the Ricoh multi-function R5C832 works. This chip implements
+ * firewire and four different memory card controllers. Two of those
+ * controllers are an SDHCI controller and a proprietary MMC
+ * controller. The linux SDHCI driver supports MMC cards but the chip
+ * detects MMC cards in hardware and directs them to the MMC
+ * controller - so the SDHCI driver never sees them. To get around
+ * this, we must disable the useless MMC controller.  At that point,
+ * the SDHCI controller will start seeing them. As a bonus, a
+ * detection event occurs immediately, even if the MMC card is already
+ * in the reader.
+ *
+ * The relevant registers live on the firewire function, so this is
+ * unavoidably ugly. Such is life.
+ */
+
+static void quirk_ricoh_rl5c476_mmc_disable(struct pci_dev *dev)
+{
+	u8 write_enable;
+	u8 write_target;
+	u8 disable;
+
+	pci_read_config_byte(dev, 0xB7, &disable);
+
+	if (disable & 0x02)
+		/* Already disabled */
+		return;
+
+	pci_read_config_byte(dev, 0x8E, &write_enable);
+	pci_write_config_byte(dev, 0x8E, 0xAA);
+	pci_read_config_byte(dev, 0x8D, &write_target);
+	pci_write_config_byte(dev, 0x8D, 0xB7);
+	pci_write_config_byte(dev, 0xB7, disable | 0x02);
+	pci_write_config_byte(dev, 0x8E, write_enable);
+	pci_write_config_byte(dev, 0x8D, write_target);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH,
+			 PCI_DEVICE_ID_RICOH_RL5C476,
+			 quirk_ricoh_rl5c476_mmc_disable);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH,
+			       PCI_DEVICE_ID_RICOH_RL5C476,
+			       quirk_ricoh_rl5c476_mmc_disable);
+
+static void quirk_ricoh_r5c832_mmc_disable(struct pci_dev *dev)
+{
+	u8 disable;
+	u8 write_enable;
+
+	pci_read_config_byte(dev, 0xCB, &disable);
+
+	if (disable & 0x02)
+		return;
+
+	pci_read_config_byte(dev, 0xCA, &write_enable);
+	pci_write_config_byte(dev, 0xCA, 0x57);
+	pci_write_config_byte(dev, 0xCB, disable | 0x02);
+	pci_write_config_byte(dev, 0xCA, write_enable);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH,
+			 PCI_DEVICE_ID_RICOH_R5C832,
+			 quirk_ricoh_r5c832_mmc_disable);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH,
+			       PCI_DEVICE_ID_RICOH_R5C832,
+			       quirk_ricoh_r5c832_mmc_disable);
+
 #ifdef CONFIG_PCI_MSI
 /* Some chipsets do not support MSI. We cannot easily rely on setting
  * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually

--Boundary-00=_5DVLJJpXLLBvMIz--
