Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886Ab0A3V2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0A3V2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 16:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566Ab0A3V2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 16:28:50 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50354 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab0A3V2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 16:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MJBpYhEga43sRUTpkFwfdclCXFXzQm6isWNldJfA/fb+/BspbfRyb1/Mak2mjWTMWz
         QiqCdEFcWqlbdGvmDAEpzIULEuZ4Lgfpl+n4qeV1vbAqJCINtpb9w0d7egeVfiI6xA0T
         vC5SjLh91ecyLyXc0HiNNyAiIrG9fuvWGpk2I=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>, Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH] Port ricoh_mmc to pci quirk
Date: Sat, 30 Jan 2010 23:28:34 +0200
Message-Id: <1264886914-30179-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1264772255.4620.3.camel@maxim-laptop>
References: <1264772255.4620.3.camel@maxim-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves nasty problem original driver had.
Original goal of the ricoh_mmc, was to disable this device because
then, mmc cards can be read using standard SDHCI controller,
thus avoiding the need in yet another driver.
However, the act of disablement, makes other pci functions that belong to
this controller (xD and memstick) shift up one level, thus pci core has now wrong idea
about these devices.

To fix this issue, this patch moves the driver into pci quirk section, thus it
is executed before the pci is enumerated, and therefore solve that issue,
also the same is preformed on resume for same reasons.

Also regardless of the above, this way is cleaner.

You still need to set CONFIG_MMC_RICOH_MMC
to enable this quirk

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mmc/host/Kconfig     |   10 +-
 drivers/mmc/host/Makefile    |    1 -
 drivers/mmc/host/ricoh_mmc.c |  262 ------------------------------------------
 drivers/pci/quirks.c         |   85 ++++++++++++++
 4 files changed, 88 insertions(+), 270 deletions(-)
 delete mode 100644 drivers/mmc/host/ricoh_mmc.c

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ce1d288..6bc3ecb 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -69,20 +69,16 @@ config MMC_SDHCI_PCI
 	  If unsure, say N.
 
 config MMC_RICOH_MMC
-	tristate "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
+	bool "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
 	depends on MMC_SDHCI_PCI
 	help
-	  This selects the disabler for the Ricoh MMC Controller. This
+	  This adds a pci quirk to disable Ricoh MMC Controller. This
 	  proprietary controller is unnecessary because the SDHCI driver
 	  supports MMC cards on the SD controller, but if it is not
 	  disabled, it will steal the MMC cards away - rendering them
-	  useless. It is safe to select this driver even if you don't
+	  useless. It is safe to select this even if you don't
 	  have a Ricoh based card reader.
 
-
-	  To compile this driver as a module, choose M here:
-	  the module will be called ricoh_mmc.
-
 	  If unsure, say Y.
 
 config MMC_SDHCI_OF
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 3d253dd..f480397 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_MMC_IMX)		+= imxmmc.o
 obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
-obj-$(CONFIG_MMC_RICOH_MMC)	+= ricoh_mmc.o
 obj-$(CONFIG_MMC_SDHCI_PLTFM)	+= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_S3C)	+= sdhci-s3c.o
 obj-$(CONFIG_MMC_WBSD)		+= wbsd.o
diff --git a/drivers/mmc/host/ricoh_mmc.c b/drivers/mmc/host/ricoh_mmc.c
deleted file mode 100644
index f627905..0000000
--- a/drivers/mmc/host/ricoh_mmc.c
+++ /dev/null
@@ -1,262 +0,0 @@
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
- * the Ricoh multi-function chips (R5CXXX) work. These chips implement
- * the four main memory card controllers (SD, MMC, MS, xD) and one or both
- * of cardbus or firewire. It happens that they implement SD and MMC
- * support as separate controllers (and PCI functions). The linux SDHCI
- * driver supports MMC cards but the chip detects MMC cards in hardware
- * and directs them to the MMC controller - so the SDHCI driver never sees
- * them. To get around this, we must disable the useless MMC controller.
- * At that point, the SDHCI controller will start seeing them. As a bonus,
- * a detection event occurs immediately, even if the MMC card is already
- * in the reader.
- *
- * It seems to be the case that the relevant PCI registers to deactivate the
- * MMC controller live on PCI function 0, which might be the cardbus controller
- * or the firewire controller, depending on the particular chip in question. As
- * such, it makes what this driver has to do unavoidably ugly. Such is life.
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
-		    PCI_FUNC(fw_dev->devfn) == 0 &&
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
-		    PCI_FUNC(fw_dev->devfn) == 0 &&
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
-		       ": Main Ricoh function not found. Cannot disable controller.\n");
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
-static int ricoh_mmc_suspend_late(struct pci_dev *pdev, pm_message_t state)
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
-static int ricoh_mmc_resume_early(struct pci_dev *pdev)
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
-	.suspend_late =	ricoh_mmc_suspend_late,
-	.resume_early =	ricoh_mmc_resume_early,
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
index c746943..df921db 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2520,6 +2520,91 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x150d, quirk_i82576_sriov);
 
 #endif	/* CONFIG_PCI_IOV */
 
+/*
+ * This is a quirk for the Ricoh MMC controller found as a part of
+ * some mulifunction chips.
+
+ * This is very similiar and based on the ricoh_mmc driver written by
+ * Philip Langdale. Thank you for these magic sequences.
+ *
+ * These chips implement the four main memory card controllers (SD, MMC, MS, xD)
+ * and one or both of cardbus or firewire.
+ *
+ * It happens that they implement SD and MMC
+ * support as separate controllers (and PCI functions). The linux SDHCI
+ * driver supports MMC cards but the chip detects MMC cards in hardware
+ * and directs them to the MMC controller - so the SDHCI driver never sees
+ * them.
+ *
+ * To get around this, we must disable the useless MMC controller.
+ * At that point, the SDHCI controller will start seeing them
+ * It seems to be the case that the relevant PCI registers to deactivate the
+ * MMC controller live on PCI function 0, which might be the cardbus controller
+ * or the firewire controller, depending on the particular chip in question
+ *
+ * This has to be done early, because as soon as we disable the MMC controller
+ * other pci functions shift up one level, e.g. function #2 becomes function
+ * #1, and this will confuse the pci core.
+ */
+
+#ifdef CONFIG_MMC_RICOH_MMC
+static void ricoh_mmc_fixup_rl5c476(struct pci_dev *dev)
+{
+	/* disable via cardbus interface */
+	u8 write_enable;
+	u8 write_target;
+	u8 disable;
+
+	/* disable must be done via function #0 */
+	if (PCI_FUNC(dev->devfn))
+		return;
+
+	pci_read_config_byte(dev, 0xB7, &disable);
+	if (disable & 0x02)
+		return;
+
+	pci_read_config_byte(dev, 0x8E, &write_enable);
+	pci_write_config_byte(dev, 0x8E, 0xAA);
+	pci_read_config_byte(dev, 0x8D, &write_target);
+	pci_write_config_byte(dev, 0x8D, 0xB7);
+	pci_write_config_byte(dev, 0xB7, disable | 0x02);
+	pci_write_config_byte(dev, 0x8E, write_enable);
+	pci_write_config_byte(dev, 0x8D, write_target);
+
+	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via cardbus function)\n");
+	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476, ricoh_mmc_fixup_rl5c476);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476, ricoh_mmc_fixup_rl5c476);
+
+static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
+{
+	/* disable via firewire interface */
+	u8 write_enable;
+	u8 disable;
+
+	/* disable must be done via function #0 */
+	if (PCI_FUNC(dev->devfn))
+		return;
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
+
+	dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via firewire function)\n");
+	dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI controller\n");
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
+#endif /*CONFIG_MMC_RICOH_MMC*/
+
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
-- 
1.6.3.3

