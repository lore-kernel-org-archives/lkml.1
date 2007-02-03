Return-Path: <linux-kernel-owner+w=401wt.eu-S1750725AbXBCRTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750725AbXBCRTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 12:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbXBCRTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 12:19:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:51770 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXBCRTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 12:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:subject;
        b=AR9jzxLvTVHrskic/DAwjCcgjgIY/hMMWnsz/CM+yVXNfSYAlDDgj70jYVsVEwa3RpAnZHVoC12ygH3slHx0LkiLqh+QAEXEACBQgoh2iedms2XKkeLqagJ6PYwkvz/9Kq8M78LhDunwFfwlTzgHgUG625KY97HO/j2nfGko2nM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 03 Feb 2007 18:24:15 +0100
Message-Id: <20070203172415.4926.29574.sendpatchset@localhost.localdomain>
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] ide: fix UDMA/MWDMA/SWDMA masks

* use 0x00 instead of 0x80 to disable ->{ultra,mwdma,swdma}_mask
* add udma_mask field to ide_pci_device_t and use it to initialize
  ->ultra_mask in aec62xx, cmd64x, pdc202xx_{new,old} and piix drivers
* fix UDMA masks to match with chipset specific *_ratemask()
  (alim15x3, hpt366, serverworks and siimage drivers need UDMA mask
   filtering method - done in the next patch)

v2:
* piix: fix cable detection for 82801AA_1 and 82372FB_1
  [ Noticed by Sergei Shtylyov <sshtylyov@ru.mvista.com>. ]
* cmd64x: use hwif->cds->udma_mask
  [ Suggested by Sergei Shtylyov <sshtylyov@ru.mvista.com>. ]
* aec62xx: fix newly introduced bug - check DMA status not command register
  [ Noticed by Sergei Shtylyov <sshtylyov@ru.mvista.com>. ]

v3:
* piix: use hwif->cds->udma_mask
  [ Suggested by Sergei Shtylyov <sshtylyov@ru.mvista.com>. ]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

---
 drivers/ide/ide.c              |    3 -
 drivers/ide/pci/aec62xx.c      |   19 +++++++++-
 drivers/ide/pci/alim15x3.c     |   13 ++++++-
 drivers/ide/pci/cmd64x.c       |   15 ++++----
 drivers/ide/pci/pdc202xx_new.c |    9 ++++-
 drivers/ide/pci/pdc202xx_old.c |    7 +++
 drivers/ide/pci/piix.c         |   73 +++++++++++++++++------------------------
 drivers/ide/pci/sis5513.c      |    5 ++
 include/linux/ide.h            |    1 
 9 files changed, 86 insertions(+), 59 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -222,9 +222,6 @@ static void init_hwif_data(ide_hwif_t *h
 	hwif->bus_state	= BUSSTATE_ON;
 
 	hwif->atapi_dma = 0;		/* disable all atapi dma */ 
-	hwif->ultra_mask = 0x80;	/* disable all ultra */
-	hwif->mwdma_mask = 0x80;	/* disable all mwdma */
-	hwif->swdma_mask = 0x80;	/* disable all swdma */
 
 	init_completion(&hwif->gendev_rel_comp);
 
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -270,11 +270,13 @@ static unsigned int __devinit init_chips
 
 static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = hwif->pci_dev;
+
 	hwif->autodma = 0;
 	hwif->tuneproc = &aec62xx_tune_drive;
 	hwif->speedproc = &aec62xx_tune_chipset;
 
-	if (hwif->pci_dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
+	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
 		hwif->serialized = hwif->channel;
 
 	if (hwif->mate)
@@ -286,7 +288,15 @@ static void __devinit init_hwif_aec62xx(
 		return;
 	}
 
-	hwif->ultra_mask = 0x7f;
+	hwif->ultra_mask = hwif->cds->udma_mask;
+
+	/* atp865 and atp865r */
+	if (hwif->ultra_mask == 0x3f) {
+		/* check bit 0x10 of DMA status register */
+		if (inb(pci_resource_start(dev, 4) + 2) & 0x10)
+ 			hwif->ultra_mask = 0x7f; /* udma0-6 */
+	}
+
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
@@ -354,6 +364,7 @@ static ide_pci_device_t aec62xx_chipsets
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 1 */
 		.name		= "AEC6260",
 		.init_setup	= init_setup_aec62xx,
@@ -363,6 +374,7 @@ static ide_pci_device_t aec62xx_chipsets
 		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 2 */
 		.name		= "AEC6260R",
 		.init_setup	= init_setup_aec62xx,
@@ -373,6 +385,7 @@ static ide_pci_device_t aec62xx_chipsets
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= NEVER_BOARD,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "AEC6X80",
 		.init_setup	= init_setup_aec6x80,
@@ -382,6 +395,7 @@ static ide_pci_device_t aec62xx_chipsets
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 4 */
 		.name		= "AEC6X80R",
 		.init_setup	= init_setup_aec6x80,
@@ -392,6 +406,7 @@ static ide_pci_device_t aec62xx_chipsets
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
 
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -765,8 +765,17 @@ static void __devinit init_hwif_common_a
 
 	hwif->atapi_dma = 1;
 
-	if (m5229_revision > 0x20)
-		hwif->ultra_mask = 0x7f;
+	if (m5229_revision <= 0x20)
+		hwif->ultra_mask = 0x00; /* no udma */
+	else if (m5229_revision < 0xC2)
+		hwif->ultra_mask = 0x07; /* udma0-2 */
+	else if (m5229_revision == 0xC2 || m5229_revision == 0xC3)
+		hwif->ultra_mask = 0x1f; /* udma0-4 */
+	else if (m5229_revision == 0xC4)
+		hwif->ultra_mask = 0x3f; /* udma0-5 */
+	else
+		hwif->ultra_mask = 0x7f; /* udma0-6 */
+
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -690,16 +690,13 @@ static void __devinit init_hwif_cmd64x(i
 
 	hwif->atapi_dma = 1;
 
-	hwif->ultra_mask = 0x3f;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
-	if (dev->device == PCI_DEVICE_ID_CMD_643)
-		hwif->ultra_mask = 0x80;
-	if (dev->device == PCI_DEVICE_ID_CMD_646)
-		hwif->ultra_mask = (class_rev > 0x04) ? 0x07 : 0x80;
-	if (dev->device == PCI_DEVICE_ID_CMD_648)
-		hwif->ultra_mask = 0x1f;
+	hwif->ultra_mask = hwif->cds->udma_mask;
+
+	if (dev->device == PCI_DEVICE_ID_CMD_646 && class_rev < 5)
+		hwif->ultra_mask = 0x00;
 
 	hwif->ide_dma_check = &cmd64x_config_drive_for_dma;
 	if (!(hwif->udma_four))
@@ -733,6 +730,7 @@ static ide_pci_device_t cmd64x_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.udma_mask	= 0x00, /* no udma */
 	},{	/* 1 */
 		.name		= "CMD646",
 		.init_chipset	= init_chipset_cmd64x,
@@ -741,6 +739,7 @@ static ide_pci_device_t cmd64x_chipsets[
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x80,0x80}},
 		.bootable	= ON_BOARD,
+		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 2 */
 		.name		= "CMD648",
 		.init_chipset	= init_chipset_cmd64x,
@@ -748,6 +747,7 @@ static ide_pci_device_t cmd64x_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "CMD649",
 		.init_chipset	= init_chipset_cmd64x,
@@ -755,6 +755,7 @@ static ide_pci_device_t cmd64x_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= ON_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
 
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -545,7 +545,7 @@ static void __devinit init_hwif_pdc202ne
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
-	hwif->ultra_mask = 0x7f;
+	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 
 	hwif->err_stops_fifo = 1;
@@ -621,6 +621,7 @@ static ide_pci_device_t pdcnew_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 1 */
 		.name		= "PDC20269",
 		.init_setup	= init_setup_pdcnew,
@@ -629,6 +630,7 @@ static ide_pci_device_t pdcnew_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 2 */
 		.name		= "PDC20270",
 		.init_setup	= init_setup_pdc20270,
@@ -637,6 +639,7 @@ static ide_pci_device_t pdcnew_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 3 */
 		.name		= "PDC20271",
 		.init_setup	= init_setup_pdcnew,
@@ -645,6 +648,7 @@ static ide_pci_device_t pdcnew_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 4 */
 		.name		= "PDC20275",
 		.init_setup	= init_setup_pdcnew,
@@ -653,6 +657,7 @@ static ide_pci_device_t pdcnew_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 5 */
 		.name		= "PDC20276",
 		.init_setup	= init_setup_pdc20276,
@@ -661,6 +666,7 @@ static ide_pci_device_t pdcnew_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 6 */
 		.name		= "PDC20277",
 		.init_setup	= init_setup_pdcnew,
@@ -669,6 +675,7 @@ static ide_pci_device_t pdcnew_chipsets[
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	}
 };
 
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -478,7 +478,7 @@ static void __devinit init_hwif_pdc202xx
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
-	hwif->ultra_mask = 0x3f;
+	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 	hwif->atapi_dma = 1;
@@ -587,6 +587,7 @@ static ide_pci_device_t pdc202xx_chipset
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 16,
+		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 1 */
 		.name		= "PDC20262",
 		.init_setup	= init_setup_pdc202ata4,
@@ -597,6 +598,7 @@ static ide_pci_device_t pdc202xx_chipset
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 2 */
 		.name		= "PDC20263",
 		.init_setup	= init_setup_pdc202ata4,
@@ -607,6 +609,7 @@ static ide_pci_device_t pdc202xx_chipset
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "PDC20265",
 		.init_setup	= init_setup_pdc20265,
@@ -617,6 +620,7 @@ static ide_pci_device_t pdc202xx_chipset
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 4 */
 		.name		= "PDC20267",
 		.init_setup	= init_setup_pdc202xx,
@@ -627,6 +631,7 @@ static ide_pci_device_t pdc202xx_chipset
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
 
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -514,26 +514,14 @@ static void __devinit init_hwif_piix(ide
 		hwif->ide_dma_clear_irq = &piix_dma_clear_irq;
 
 	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x3f;
+
+	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x06;
 	hwif->swdma_mask = 0x04;
 
-	switch(hwif->pci_dev->device) {
-		case PCI_DEVICE_ID_INTEL_82371FB_0:
-		case PCI_DEVICE_ID_INTEL_82371FB_1:
-		case PCI_DEVICE_ID_INTEL_82371SB_1:
-			hwif->ultra_mask = 0x80;
-			break;
-		case PCI_DEVICE_ID_INTEL_82371AB:
-		case PCI_DEVICE_ID_INTEL_82443MX_1:
-		case PCI_DEVICE_ID_INTEL_82451NX:
-		case PCI_DEVICE_ID_INTEL_82801AB_1:
-			hwif->ultra_mask = 0x07;
-			break;
-		default:
-			if (!hwif->udma_four)
-				hwif->udma_four = piix_cable_detect(hwif);
-			break;
+	if (hwif->ultra_mask & 0x78) {
+		if (!hwif->udma_four)
+			hwif->udma_four = piix_cable_detect(hwif);
 	}
 
 	if (no_piix_dma)
@@ -547,7 +535,7 @@ static void __devinit init_hwif_piix(ide
 	hwif->drives[0].autodma = hwif->autodma;
 }
 
-#define DECLARE_PIIX_DEV(name_str) \
+#define DECLARE_PIIX_DEV(name_str, udma) \
 	{						\
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_piix,	\
@@ -556,11 +544,12 @@ static void __devinit init_hwif_piix(ide
 		.autodma	= AUTODMA,		\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.bootable	= ON_BOARD,		\
+		.udma_mask	= udma,			\
 	}
 
 static ide_pci_device_t piix_pci_info[] __devinitdata = {
-	/*  0 */ DECLARE_PIIX_DEV("PIIXa"),
-	/*  1 */ DECLARE_PIIX_DEV("PIIXb"),
+	/*  0 */ DECLARE_PIIX_DEV("PIIXa", 0x00),	/* no udma */
+	/*  1 */ DECLARE_PIIX_DEV("PIIXb", 0x00),	/* no udma */
 
 	/*  2 */
 	{	/*
@@ -577,28 +566,28 @@ static ide_pci_device_t piix_pci_info[] 
 		.flags		= IDEPCI_FLAG_ISA_PORTS
 	},
 
-	/*  3 */ DECLARE_PIIX_DEV("PIIX3"),
-	/*  4 */ DECLARE_PIIX_DEV("PIIX4"),
-	/*  5 */ DECLARE_PIIX_DEV("ICH0"),
-	/*  6 */ DECLARE_PIIX_DEV("PIIX4"),
-	/*  7 */ DECLARE_PIIX_DEV("ICH"),
-	/*  8 */ DECLARE_PIIX_DEV("PIIX4"),
-	/*  9 */ DECLARE_PIIX_DEV("PIIX4"),
-	/* 10 */ DECLARE_PIIX_DEV("ICH2"),
-	/* 11 */ DECLARE_PIIX_DEV("ICH2M"),
-	/* 12 */ DECLARE_PIIX_DEV("ICH3M"),
-	/* 13 */ DECLARE_PIIX_DEV("ICH3"),
-	/* 14 */ DECLARE_PIIX_DEV("ICH4"),
-	/* 15 */ DECLARE_PIIX_DEV("ICH5"),
-	/* 16 */ DECLARE_PIIX_DEV("C-ICH"),
-	/* 17 */ DECLARE_PIIX_DEV("ICH4"),
-	/* 18 */ DECLARE_PIIX_DEV("ICH5-SATA"),
-	/* 19 */ DECLARE_PIIX_DEV("ICH5"),
-	/* 20 */ DECLARE_PIIX_DEV("ICH6"),
-	/* 21 */ DECLARE_PIIX_DEV("ICH7"),
-	/* 22 */ DECLARE_PIIX_DEV("ICH4"),
-	/* 23 */ DECLARE_PIIX_DEV("ESB2"),
-	/* 24 */ DECLARE_PIIX_DEV("ICH8M"),
+	/*  3 */ DECLARE_PIIX_DEV("PIIX3", 0x00),	/* no udma */
+	/*  4 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
+	/*  5 */ DECLARE_PIIX_DEV("ICH0",  0x07),	/* udma0-2 */
+	/*  6 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
+	/*  7 */ DECLARE_PIIX_DEV("ICH",   0x1f),	/* udma0-4 */
+	/*  8 */ DECLARE_PIIX_DEV("PIIX4", 0x1f),	/* udma0-4 */
+	/*  9 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
+	/* 10 */ DECLARE_PIIX_DEV("ICH2",  0x3f),	/* udma0-5 */
+	/* 11 */ DECLARE_PIIX_DEV("ICH2M", 0x3f),	/* udma0-5 */
+	/* 12 */ DECLARE_PIIX_DEV("ICH3M", 0x3f),	/* udma0-5 */
+	/* 13 */ DECLARE_PIIX_DEV("ICH3",  0x3f),	/* udma0-5 */
+	/* 14 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
+	/* 15 */ DECLARE_PIIX_DEV("ICH5",  0x3f),	/* udma0-5 */
+	/* 16 */ DECLARE_PIIX_DEV("C-ICH", 0x3f),	/* udma0-5 */
+	/* 17 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
+	/* 18 */ DECLARE_PIIX_DEV("ICH5-SATA", 0x3f),	/* udma0-5 */
+	/* 19 */ DECLARE_PIIX_DEV("ICH5",  0x3f),	/* udma0-5 */
+	/* 20 */ DECLARE_PIIX_DEV("ICH6",  0x3f),	/* udma0-5 */
+	/* 21 */ DECLARE_PIIX_DEV("ICH7",  0x3f),	/* udma0-5 */
+	/* 22 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
+	/* 23 */ DECLARE_PIIX_DEV("ESB2",  0x3f),	/* udma0-5 */
+	/* 24 */ DECLARE_PIIX_DEV("ICH8M", 0x3f),	/* udma0-5 */
 };
 
 /**
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -858,6 +858,8 @@ static unsigned int __devinit ata66_sis5
 
 static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 {
+	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
+
 	hwif->autodma = 0;
 
 	if (!hwif->irq)
@@ -873,7 +875,8 @@ static void __devinit init_hwif_sis5513 
 	}
 
 	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x7f;
+
+	hwif->ultra_mask = udma_rates[chipset_family];
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1255,6 +1255,7 @@ typedef struct ide_pci_device_s {
 	unsigned int		extra;
 	struct ide_pci_device_s	*next;
 	u8			flags;
+	u8			udma_mask;
 } ide_pci_device_t;
 
 extern int ide_setup_pci_device(struct pci_dev *, ide_pci_device_t *);
