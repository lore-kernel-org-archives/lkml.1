Return-Path: <linux-kernel-owner+w=401wt.eu-S966491AbXIKUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966491AbXIKUiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbXIKUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:37:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:8117 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226AbXIKUh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ObbreQm+4OReDszmoctOSanOQg1J4NI2coz4XITb3ONN264j8M10B+GkhtXicyCWt13ySyo6QJG0zmsgOCmZA1F/WVvuSa6YIp/nS+8lLS9ocERcOhLRzEudb6egbtTJM0zcbBdo2urBc7Wwfo9Awtq/H3qSgVoG0mWdjghCkjY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes for 2.6.23-rc6
Date: Tue, 11 Sep 2007 22:37:40 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112237.40613.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ata/pata_ali.c         |    7 ++
 drivers/ide/Kconfig            |    4 +-
 drivers/ide/ide-iops.c         |    3 +-
 drivers/ide/pci/alim15x3.c     |    7 ++
 drivers/ide/pci/hpt366.c       |  138 +++++++++++++++++++++++-----------------
 drivers/ide/pci/pdc202xx_new.c |    9 ++-
 drivers/ide/pci/via82cxxx.c    |   15 +++-
 drivers/ide/ppc/mpc8xx.c       |    1 -
 drivers/ide/setup-pci.c        |   41 +++++-------
 include/linux/ide.h            |   13 ++++
 10 files changed, 141 insertions(+), 97 deletions(-)


Bartlomiej Zolnierkiewicz (1):
      via82cxxx: add Arima W730-K8 and other rebadgings to short cables list

Daniel Exner (1):
      pata_ali/alim15x3: override 80-wire cable detection for Toshiba S1800-814

Kumar Gala (1):
      mpc8xx: Only build mpc8xx on arch/ppc

Mikael Pettersson (1):
      pdc202xx_new: PLL detection fix

Sergei Shtylyov (5):
      ide: fix PCI refcounting
      pdc202xx_new: fix PCI refcounting
      hpt366: fix PCI clock detection for HPT374 (take 4)
      ide: add ide_dev_is_sata() helper (take 2)
      hpt366: UltraDMA filter for SATA cards (take 2)

Tony Breeds (1):
      pmac: build fix


diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 94e5edc..71bdc3b 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -48,6 +48,13 @@ static struct dmi_system_id cable_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
 		},
 	},
+	{
+		.ident = "Toshiba Satelite S1800-814",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
+		},
+	},
 	{ }
 };
 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 7adb61b..4200251 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -781,7 +781,7 @@ endif
 
 config BLK_DEV_IDE_PMAC
 	bool "Builtin PowerMac IDE support"
-	depends on PPC_PMAC && IDE=y
+	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
 	help
 	  This driver provides support for the built-in IDE controller on
 	  most of the recent Apple Power Macintoshes and PowerBooks.
@@ -946,7 +946,7 @@ config BLK_DEV_Q40IDE
 
 config BLK_DEV_MPC8xx_IDE
 	bool "MPC8xx IDE support"
-	depends on 8xx && IDE=y && BLK_DEV_IDE=y
+	depends on 8xx && IDE=y && BLK_DEV_IDE=y && !PPC_MERGE
 	select IDE_GENERIC
 	help
 	  This option provides support for IDE on Motorola MPC8xx Systems.
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index f4cd270..646a54e 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -615,8 +615,7 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 	if (hwif->cbl != ATA_CBL_PATA80 && !ivb)
 		goto no_80w;
 
-	/* Check for SATA but only if we are ATA5 or higher */
-	if (id->hw_config == 0 && (id->major_rev_num & 0x7FE0))
+	if (ide_dev_is_sata(id))
 		return 1;
 
 	/*
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 025689d..11ecb61 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -596,6 +596,13 @@ static struct dmi_system_id cable_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
 		},
 	},
+	{
+		.ident = "Toshiba Satellite S1800-814",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
+		},
+	},
 	{ }
 };
 
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 2cd74c3..39f1c89 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.10	Jun 29, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.12	Aug 19, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -68,7 +68,8 @@
  *   HPT37x chip family; save space by introducing the separate transfer mode
  *   table in which the mode lookup is done
  * - use f_CNT value saved by  the HighPoint BIOS as reading it directly gives
- *   the wrong PCI frequency since DPLL has already been calibrated by BIOS
+ *   the wrong PCI frequency since DPLL has already been calibrated by BIOS;
+ *   read it only from the function 0 of HPT374 chips
  * - fix the hotswap code:  it caused RESET- to glitch when tristating the bus,
  *   and for HPT36x the obsolete HDIO_TRISTATE_HWIF handler was called instead
  * - pass to init_chipset() handlers a copy of the IDE PCI device structure as
@@ -113,6 +114,7 @@
  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
  *   the register setting lists into the table indexed by the clock selected
  * - set the correct hwif->ultra_mask for each individual chip
+ * - add UltraDMA mode filtering for the HPT37[24] based SATA cards
  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
  */
 
@@ -517,42 +519,44 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
 }
 
 /*
- *	Note for the future; the SATA hpt37x we must set
- *	either PIO or UDMA modes 0,4,5
+ * The Marvell bridge chips used on the HighPoint SATA cards do not seem
+ * to support the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes...
  */
 
 static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
-	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
-	u8 mask;
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct hpt_info *info	= pci_get_drvdata(hwif->pci_dev);
+	u8 mask 		= hwif->ultra_mask;
 
 	switch (info->chip_type) {
-	case HPT370A:
-		if (!HPT370_ALLOW_ATA100_5 ||
-		    check_in_drive_list(drive, bad_ata100_5))
-			return 0x1f;
-		else
-			return 0x3f;
-	case HPT370:
-		if (!HPT370_ALLOW_ATA100_5 ||
-		    check_in_drive_list(drive, bad_ata100_5))
-			mask = 0x1f;
-		else
-			mask = 0x3f;
-		break;
 	case HPT36x:
 		if (!HPT366_ALLOW_ATA66_4 ||
 		    check_in_drive_list(drive, bad_ata66_4))
-			mask = 0x0f;
-		else
-			mask = 0x1f;
+			mask = ATA_UDMA3;
 
 		if (!HPT366_ALLOW_ATA66_3 ||
 		    check_in_drive_list(drive, bad_ata66_3))
-			mask = 0x07;
+			mask = ATA_UDMA2;
+		break;
+	case HPT370:
+		if (!HPT370_ALLOW_ATA100_5 ||
+		    check_in_drive_list(drive, bad_ata100_5))
+			mask = ATA_UDMA4;
 		break;
+	case HPT370A:
+		if (!HPT370_ALLOW_ATA100_5 ||
+		    check_in_drive_list(drive, bad_ata100_5))
+			return ATA_UDMA4;
+	case HPT372 :
+	case HPT372A:
+	case HPT372N:
+	case HPT374 :
+		if (ide_dev_is_sata(drive->id))
+			mask &= ~0x0e;
+		/* Fall thru */
 	default:
-		return 0x7f;
+		return mask;
 	}
 
 	return check_in_drive_list(drive, bad_ata33) ? 0x00 : mask;
@@ -981,6 +985,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	struct hpt_info *info	= kmalloc(sizeof(struct hpt_info), GFP_KERNEL);
 	unsigned long io_base	= pci_resource_start(dev, 4);
 	u8 pci_clk,  dpll_clk	= 0;	/* PCI and DPLL clock in MHz */
+	u8 chip_type;
 	enum ata_clock	clock;
 
 	if (info == NULL) {
@@ -992,7 +997,8 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	 * Copy everything from a static "template" structure
 	 * to just allocated per-chip hpt_info structure.
 	 */
-	*info = *(struct hpt_info *)pci_get_drvdata(dev);
+	memcpy(info, pci_get_drvdata(dev), sizeof(struct hpt_info));
+	chip_type = info->chip_type;
 
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, (L1_CACHE_BYTES / 4));
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x78);
@@ -1002,7 +1008,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	/*
 	 * First, try to estimate the PCI clock frequency...
 	 */
-	if (info->chip_type >= HPT370) {
+	if (chip_type >= HPT370) {
 		u8  scr1  = 0;
 		u16 f_cnt = 0;
 		u32 temp  = 0;
@@ -1016,7 +1022,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 		 * HighPoint does this for HPT372A.
 		 * NOTE: This register is only writeable via I/O space.
 		 */
-		if (info->chip_type == HPT372A)
+		if (chip_type == HPT372A)
 			outb(0x0e, io_base + 0x9c);
 
 		/*
@@ -1034,13 +1040,28 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 		 * First try reading the register in which the HighPoint BIOS
 		 * saves f_CNT value before  reprogramming the DPLL from its
 		 * default setting (which differs for the various chips).
-		 * NOTE: This register is only accessible via I/O space.
 		 *
-		 * In case the signature check fails, we'll have to resort to
-		 * reading the f_CNT register itself in hopes that nobody has
-		 * touched the DPLL yet...
+		 * NOTE: This register is only accessible via I/O space;
+		 * HPT374 BIOS only saves it for the function 0, so we have to
+		 * always read it from there -- no need to check the result of
+		 * pci_get_slot() for the function 0 as the whole device has
+		 * been already "pinned" (via function 1) in init_setup_hpt374()
+		 */
+		if (chip_type == HPT374 && (PCI_FUNC(dev->devfn) & 1)) {
+			struct pci_dev	*dev1 = pci_get_slot(dev->bus,
+							     dev->devfn - 1);
+			unsigned long io_base = pci_resource_start(dev1, 4);
+
+			temp =	inl(io_base + 0x90);
+			pci_dev_put(dev1);
+		} else
+			temp =	inl(io_base + 0x90);
+
+		/*
+		 * In case the signature check fails, we'll have to
+		 * resort to reading the f_CNT register itself in hopes
+		 * that nobody has touched the DPLL yet...
 		 */
-		temp = inl(io_base + 0x90);
 		if ((temp & 0xFFFFF000) != 0xABCDE000) {
 			int i;
 
@@ -1120,7 +1141,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	 * We also  don't like using  the DPLL because this causes glitches
 	 * on PRST-/SRST- when the state engine gets reset...
 	 */
-	if (info->chip_type >= HPT374 || info->settings[clock] == NULL) {
+	if (chip_type >= HPT374 || info->settings[clock] == NULL) {
 		u16 f_low, delta = pci_clk < 50 ? 2 : 4;
 		int adjust;
 
@@ -1190,7 +1211,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	/* Point to this chip's own instance of the hpt_info structure. */
 	pci_set_drvdata(dev, info);
 
-	if (info->chip_type >= HPT370) {
+	if (chip_type >= HPT370) {
 		u8  mcr1, mcr4;
 
 		/*
@@ -1209,7 +1230,7 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 	 * the MISC. register to stretch the UltraDMA Tss timing.
 	 * NOTE: This register is only writeable via I/O space.
 	 */
-	if (info->chip_type == HPT371N && clock == ATA_CLOCK_66MHZ)
+	if (chip_type == HPT371N && clock == ATA_CLOCK_66MHZ)
 
 		outb(inb(io_base + 0x9c) | 0x04, io_base + 0x9c);
 
@@ -1218,25 +1239,24 @@ static unsigned int __devinit init_chipset_hpt366(struct pci_dev *dev, const cha
 
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
-	struct pci_dev	*dev		= hwif->pci_dev;
-	struct hpt_info *info		= pci_get_drvdata(dev);
-	int serialize			= HPT_SERIALIZE_IO;
-	u8  scr1 = 0, ata66		= hwif->channel ? 0x01 : 0x02;
-	u8  chip_type			= info->chip_type;
-	u8  new_mcr, old_mcr 		= 0;
+	struct pci_dev	*dev	= hwif->pci_dev;
+	struct hpt_info *info	= pci_get_drvdata(dev);
+	int serialize		= HPT_SERIALIZE_IO;
+	u8  scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
+	u8  chip_type		= info->chip_type;
+	u8  new_mcr, old_mcr	= 0;
 
 	/* Cache the channel's MISC. control registers' offset */
-	hwif->select_data		= hwif->channel ? 0x54 : 0x50;
+	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
 
-	hwif->tuneproc			= &hpt3xx_tune_drive;
-	hwif->speedproc			= &hpt3xx_tune_chipset;
-	hwif->quirkproc			= &hpt3xx_quirkproc;
-	hwif->intrproc			= &hpt3xx_intrproc;
-	hwif->maskproc			= &hpt3xx_maskproc;
-	hwif->busproc			= &hpt3xx_busproc;
+	hwif->tuneproc		= &hpt3xx_tune_drive;
+	hwif->speedproc		= &hpt3xx_tune_chipset;
+	hwif->quirkproc		= &hpt3xx_quirkproc;
+	hwif->intrproc		= &hpt3xx_intrproc;
+	hwif->maskproc		= &hpt3xx_maskproc;
+	hwif->busproc		= &hpt3xx_busproc;
 
-	if (chip_type <= HPT370A)
-		hwif->udma_filter	= &hpt3xx_udma_filter;
+	hwif->udma_filter	= &hpt3xx_udma_filter;
 
 	/*
 	 * HPT3xxN chips have some complications:
@@ -1486,19 +1506,19 @@ static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
 		d->host_flags |= IDE_HFLAG_SINGLE;
 		d->enablebits[0].mask = d->enablebits[0].val = 0x10;
 
-		d->udma_mask = HPT366_ALLOW_ATA66_3 ?
-			      (HPT366_ALLOW_ATA66_4 ? 0x1f : 0x0f) : 0x07;
+		d->udma_mask = HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ?
+			       ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2;
 		break;
 	case 3:
 	case 4:
-		d->udma_mask = HPT370_ALLOW_ATA100_5 ? 0x3f : 0x1f;
+		d->udma_mask = HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4;
 		break;
 	default:
 		rev = 6;
 		/* fall thru */
 	case 5:
 	case 6:
-		d->udma_mask = HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f;
+		d->udma_mask = HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5;
 		break;
 	}
 
@@ -1559,7 +1579,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f,
+		.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
@@ -1571,7 +1591,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT302_ALLOW_ATA133_6 ? 0x7f : 0x3f,
+		.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
@@ -1583,7 +1603,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT371_ALLOW_ATA133_6 ? 0x7f : 0x3f,
+		.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
@@ -1595,7 +1615,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= 0x3f,
+		.udma_mask	= ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
@@ -1607,7 +1627,7 @@ static ide_pci_device_t hpt366_chipsets[] __devinitdata = {
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f,
+		.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index f6db2f3..7b0e479 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -9,7 +9,7 @@
  *  Split from:
  *  linux/drivers/ide/pdc202xx.c	Version 0.35	Mar. 30, 2002
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2005-2006		MontaVista Software, Inc.
+ *  Copyright (C) 2005-2007		MontaVista Software, Inc.
  *  Portions Copyright (C) 1999 Promise Technology, Inc.
  *  Author: Frank Tiernan (frankt@promise.com)
  *  Released under terms of General Public License
@@ -341,7 +341,7 @@ static long __devinit detect_pll_input_clock(unsigned long dma_base)
 	 */
 	usec_elapsed = (end_time.tv_sec - start_time.tv_sec) * 1000000 +
 		(end_time.tv_usec - start_time.tv_usec);
-	pll_input = ((start_count - end_count) & 0x3ffffff) / 10 *
+	pll_input = ((start_count - end_count) & 0x3fffffff) / 10 *
 		(10000000 / usec_elapsed);
 
 	DBG("start[%ld] end[%ld]\n", start_count, end_count);
@@ -535,7 +535,7 @@ static int __devinit init_setup_pdc20270(struct pci_dev *dev,
 	    (dev->bus->self->device == PCI_DEVICE_ID_DEC_21150)) {
 		if (PCI_SLOT(dev->devfn) & 2)
 			return -ENODEV;
-		d->extra = 0;
+
 		while ((findev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, findev)) != NULL) {
 			if ((findev->vendor == dev->vendor) &&
 			    (findev->device == dev->device) &&
@@ -544,7 +544,8 @@ static int __devinit init_setup_pdc20270(struct pci_dev *dev,
 					findev->irq = dev->irq;
 				}
 				ret = ide_setup_pci_devices(dev, findev, d);
-				pci_dev_put(findev);
+				if (ret < 0)
+					pci_dev_put(findev);
 				return ret;
 			}
 		}
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 8c53938..a7be779 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,6 +1,6 @@
 /*
  *
- * Version 3.46
+ * Version 3.47
  *
  * VIA IDE driver for Linux. Supported southbridges:
  *
@@ -430,19 +430,26 @@ static struct dmi_system_id cable_dmi_table[] = {
 	{ }
 };
 
-static int via_cable_override(void)
+static int via_cable_override(struct pci_dev *pdev)
 {
 	/* Systems by DMI */
 	if (dmi_check_system(cable_dmi_table))
 		return 1;
+
+	/* Arima W730-K8/Targa Visionary 811/... */
+	if (pdev->subsystem_vendor == 0x161F &&
+	    pdev->subsystem_device == 0x2032)
+		return 1;
+
 	return 0;
 }
 
 static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
 {
-	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
+	struct pci_dev *pdev = hwif->pci_dev;
+	struct via82cxxx_dev *vdev = pci_get_drvdata(pdev);
 
-	if (via_cable_override())
+	if (via_cable_override(pdev))
 		return ATA_CBL_PATA40_SHORT;
 
 	if ((vdev->via_80w >> hwif->channel) & 1)
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index 8859fe2..dab79af 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -32,7 +32,6 @@
 #include <asm/mpc8xx.h>
 #include <asm/mmu.h>
 #include <asm/processor.h>
-#include <asm/residual.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/ide.h>
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 30e596c..1129f8c 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -816,19 +816,15 @@ static int __init ide_scan_pcidev(struct pci_dev *dev)
 	struct list_head *l;
 	struct pci_driver *d;
 	
-	list_for_each(l, &ide_pci_drivers)
-	{
+	list_for_each(l, &ide_pci_drivers) {
 		d = list_entry(l, struct pci_driver, node);
-		if(d->id_table)
-		{
-			const struct pci_device_id *id = pci_match_id(d->id_table, dev);
-			if(id != NULL)
-			{
-				if(d->probe(dev, id) >= 0)
-				{
-					dev->driver = d;
-					return 1;
-				}
+		if (d->id_table) {
+			const struct pci_device_id *id = pci_match_id(d->id_table,
+								      dev);
+			if (id != NULL && d->probe(dev, id) >= 0) {
+				dev->driver = d;
+				pci_dev_get(dev);
+				return 1;
 			}
 		}
 	}
@@ -851,15 +847,13 @@ void __init ide_scan_pcibus (int scan_direction)
 	struct list_head *l, *n;
 
 	pre_init = 0;
-	if (!scan_direction) {
-		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	if (!scan_direction)
+		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL)
 			ide_scan_pcidev(dev);
-		}
-	} else {
-		while ((dev = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	else
+		while ((dev = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID, dev))
+		       != NULL)
 			ide_scan_pcidev(dev);
-		}
-	}
 	
 	/*
 	 *	Hand the drivers over to the PCI layer now we
@@ -869,12 +863,9 @@ void __init ide_scan_pcibus (int scan_direction)
 	list_for_each_safe(l, n, &ide_pci_drivers) {
 		list_del(l);
 		d = list_entry(l, struct pci_driver, node);
-		if (__pci_register_driver(d, d->driver.owner,
-					d->driver.mod_name)) {
-			printk(KERN_ERR "%s: failed to register driver "
-					"for %s\n", __FUNCTION__,
-					 d->driver.mod_name);
-		}
+		if (__pci_register_driver(d, d->driver.owner, d->driver.mod_name))
+			printk(KERN_ERR "%s: failed to register driver for %s\n",
+			       __FUNCTION__, d->driver.mod_name);
 	}
 }
 #endif
diff --git a/include/linux/ide.h b/include/linux/ide.h
index c792b4f..b9f66c1 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1378,6 +1378,19 @@ static inline int ide_dev_has_iordy(struct hd_driveid *id)
 	return ((id->field_valid & 2) && (id->capability & 8)) ? 1 : 0;
 }
 
+static inline int ide_dev_is_sata(struct hd_driveid *id)
+{
+	/*
+	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
+	 * verifying that word 80 by casting it to a signed type --
+	 * this trick allows us to filter out the reserved values of
+	 * 0x0000 and 0xffff along with the earlier ATA revisions...
+	 */
+	if (id->hw_config == 0 && (short)id->major_rev_num >= 0x0020)
+		return 1;
+	return 0;
+}
+
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
 typedef struct ide_pio_timings_s {
