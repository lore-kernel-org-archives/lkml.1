Return-Path: <linux-kernel-owner+w=401wt.eu-S1763820AbXJZS2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763820AbXJZS2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXJZS2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:28:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:55870 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234AbXJZS2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TB6rUC4laieCSsgX/R44U7spuAoYDu7sZFmRSeRQRVib6FGD3ZfG+m2n4j1ZI8jukWEZVFkSkcRbTLDd//Hi6AnZU+bZ/nr0N1hL2rmwZG5f5tQVYtn/P0XC8hpDU10/pZklbUwHvRWqrngEZfGG+7IjVzlS02wpmOCRQkYbTPo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Fri, 26 Oct 2007 20:34:10 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710262034.11054.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-iops.c     |    3 +++
 drivers/ide/pci/cy82c693.c |    6 +++---
 drivers/ide/pci/generic.c  |    2 +-
 drivers/ide/pci/hpt366.c   |   32 ++++++++++++++++----------------
 drivers/ide/pci/sc1200.c   |    9 +++++----
 5 files changed, 28 insertions(+), 24 deletions(-)


Bartlomiej Zolnierkiewicz (4):
      cy82c693: fix build for CONFIG_HOTPLUG=n
      hpt366: fix build for CONFIG_HOTPLUG=n
      drivers/ide/pci/generic: fix build for CONFIG_HOTPLUG=n
      ide: add SH-S202J to ivb_list[]

Jeff Garzik (1):
      drivers/ide/pci/sc1200.c: fix suspend/resume buglets and warnings


diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 9516883..dcda0f1 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -582,9 +582,12 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
 /*
  * Early UDMA66 devices don't set bit14 to 1, only bit13 is valid.
  * We list them here and depend on the device side cable detection for them.
+ *
+ * Some optical devices with the buggy firmwares have the same problem.
  */
 static const struct drive_list_entry ivb_list[] = {
 	{ "QUANTUM FIREBALLlct10 05"	, "A03.0900"	},
+	{ "TSSTcorp CDDVDW SH-S202J"	, "SB00"	},
 	{ NULL				, NULL		}
 };
 
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 3ef4fc1..1cd4e9c 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cy82c693.c		Version 0.41	Aug 27, 2007
+ * linux/drivers/ide/pci/cy82c693.c		Version 0.42	Oct 23, 2007
  *
  *  Copyright (C) 1998-2000 Andreas S. Krebs (akrebs@altavista.net), Maintainer
  *  Copyright (C) 1998-2002 Andre Hedrick <andre@linux-ide.org>, Integrator
@@ -436,10 +436,10 @@ static void __devinit init_hwif_cy82c693(ide_hwif_t *hwif)
 	hwif->ide_dma_on = &cy82c693_ide_dma_on;
 }
 
-static __devinitdata ide_hwif_t *primary;
-
 static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
 {
+	static ide_hwif_t *primary;
+
 	if (PCI_FUNC(hwif->pci_dev->devfn) == 1)
 		primary = hwif;
 	else {
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index f44d708..0688569 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -49,7 +49,7 @@ static int __init ide_generic_all_on(char *unused)
 	printk(KERN_INFO "IDE generic will claim all unknown PCI IDE storage controllers.\n");
 	return 1;
 }
-__setup("all-generic-ide", ide_generic_all_on);
+const __setup("all-generic-ide", ide_generic_all_on);
 #endif
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
 MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE storage controllers.");
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 612b795..5682895 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.20	Oct 1, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.21	Oct 23, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -433,7 +433,7 @@ static u32 *hpt37x_settings[NUM_ATA_CLOCKS] = {
 	sixty_six_base_hpt37x
 };
 
-static struct hpt_info hpt36x __devinitdata = {
+static const struct hpt_info hpt36x __devinitdata = {
 	.chip_name	= "HPT36x",
 	.chip_type	= HPT36x,
 	.udma_mask	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2,
@@ -441,7 +441,7 @@ static struct hpt_info hpt36x __devinitdata = {
 	.settings	= hpt36x_settings
 };
 
-static struct hpt_info hpt370 __devinitdata = {
+static const struct hpt_info hpt370 __devinitdata = {
 	.chip_name	= "HPT370",
 	.chip_type	= HPT370,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -449,7 +449,7 @@ static struct hpt_info hpt370 __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt370a __devinitdata = {
+static const struct hpt_info hpt370a __devinitdata = {
 	.chip_name	= "HPT370A",
 	.chip_type	= HPT370A,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -457,7 +457,7 @@ static struct hpt_info hpt370a __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt374 __devinitdata = {
+static const struct hpt_info hpt374 __devinitdata = {
 	.chip_name	= "HPT374",
 	.chip_type	= HPT374,
 	.udma_mask	= ATA_UDMA5,
@@ -465,7 +465,7 @@ static struct hpt_info hpt374 __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt372 __devinitdata = {
+static const struct hpt_info hpt372 __devinitdata = {
 	.chip_name	= "HPT372",
 	.chip_type	= HPT372,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -473,7 +473,7 @@ static struct hpt_info hpt372 __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt372a __devinitdata = {
+static const struct hpt_info hpt372a __devinitdata = {
 	.chip_name	= "HPT372A",
 	.chip_type	= HPT372A,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -481,7 +481,7 @@ static struct hpt_info hpt372a __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt302 __devinitdata = {
+static const struct hpt_info hpt302 __devinitdata = {
 	.chip_name	= "HPT302",
 	.chip_type	= HPT302,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -489,7 +489,7 @@ static struct hpt_info hpt302 __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt371 __devinitdata = {
+static const struct hpt_info hpt371 __devinitdata = {
 	.chip_name	= "HPT371",
 	.chip_type	= HPT371,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -497,7 +497,7 @@ static struct hpt_info hpt371 __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt372n __devinitdata = {
+static const struct hpt_info hpt372n __devinitdata = {
 	.chip_name	= "HPT372N",
 	.chip_type	= HPT372N,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -505,7 +505,7 @@ static struct hpt_info hpt372n __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt302n __devinitdata = {
+static const struct hpt_info hpt302n __devinitdata = {
 	.chip_name	= "HPT302N",
 	.chip_type	= HPT302N,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -513,7 +513,7 @@ static struct hpt_info hpt302n __devinitdata = {
 	.settings	= hpt37x_settings
 };
 
-static struct hpt_info hpt371n __devinitdata = {
+static const struct hpt_info hpt371n __devinitdata = {
 	.chip_name	= "HPT371N",
 	.chip_type	= HPT371N,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -1508,7 +1508,7 @@ static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
  */
 static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	struct hpt_info *info = NULL;
+	const struct hpt_info *info = NULL;
 	struct pci_dev *dev2 = NULL;
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
@@ -1522,7 +1522,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 		if (rev < 3)
 			info = &hpt36x;
 		else {
-			static struct hpt_info *hpt37x_info[] =
+			static const struct hpt_info *hpt37x_info[] =
 				{ &hpt370, &hpt370a, &hpt372, &hpt372n };
 
 			info = hpt37x_info[min_t(u8, rev, 6) - 3];
@@ -1552,7 +1552,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 	d.name = info->chip_name;
 	d.udma_mask = info->udma_mask;
 
-	pci_set_drvdata(dev, info);
+	pci_set_drvdata(dev, (void *)info);
 
 	if (info == &hpt36x || info == &hpt374)
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
@@ -1560,7 +1560,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 	if (dev2) {
 		int ret;
 
-		pci_set_drvdata(dev2, info);
+		pci_set_drvdata(dev2, (void *)info);
 
 		if (info == &hpt374)
 			hpt374_init(dev, dev2);
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index d2c8b55..0a7b320 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -324,17 +324,18 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
-	dev->current_state = state.event;
 	return 0;
 }
 
 static int sc1200_resume (struct pci_dev *dev)
 {
 	ide_hwif_t	*hwif = NULL;
+	int		i;
+
+	i = pci_enable_device(dev);
+	if (i)
+		return i;
 
-	pci_set_power_state(dev, PCI_D0);	// bring chip back from sleep state
-	dev->current_state = PM_EVENT_ON;
-	pci_enable_device(dev);
 	//
 	// loop over all interfaces that are part of this pci device:
 	//
