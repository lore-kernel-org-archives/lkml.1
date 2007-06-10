Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbXFJNp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbXFJNp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXFJNpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:45:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29288 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXFJNpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:cc:content-type:content-transfer-encoding;
        b=YPZ21ZPpWAM9+gOGfw239QsI3goHXvBT6mGg72TvAMWQkVOUoIeIDUFSJU2Qg0vHL3mPO5MgIOmzGtUDPbTydzj87XD7SdPNitakhGfzlPJKpxZyREECnzZNcShnfIJ+UpnIpbRL1tTSdTrLe94GGkMLy+DmEQcDrVLROHc+l7M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/5] ide: add short cables support
Date: Sun, 10 Jun 2007 15:58:08 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706101558.08990.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch allows users to override both host and device side cable detection
with "ideX=ata66" kernel parameter.  Thanks to this it should be now possible
to use UDMA > 2 modes on systems (laptops mainly) which use short 40-pin cable
instead of 80-pin one.

Next patches add automatic detection of some systems using short cables.

Changes:

* Rename hwif->udma_four to hwif->cbl and make it u8.

* Convert all existing users accordingly (use ATA_CBL_* defines while at it).  

* Add ATA_CBL_PATA40_SHORT support to ide-iops.c:eighty_ninty_three().

* Use ATA_CBL_PATA40_SHORT for "ideX=ata66" kernel parameter.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cris/ide-cris.c    |    2 +-
 drivers/ide/ide-iops.c         |    8 ++++++--
 drivers/ide/ide.c              |    9 +++++++--
 drivers/ide/pci/aec62xx.c      |    5 +++--
 drivers/ide/pci/alim15x3.c     |    9 +++++----
 drivers/ide/pci/amd74xx.c      |    9 +++++++--
 drivers/ide/pci/atiixp.c       |    5 +++--
 drivers/ide/pci/cmd64x.c       |   10 +++++-----
 drivers/ide/pci/cs5535.c       |    6 +++---
 drivers/ide/pci/hpt366.c       |    4 ++--
 drivers/ide/pci/it8213.c       |    8 ++++----
 drivers/ide/pci/it821x.c       |    9 +++++----
 drivers/ide/pci/jmicron.c      |   20 +++++++++++---------
 drivers/ide/pci/pdc202xx_new.c |    9 ++++++---
 drivers/ide/pci/pdc202xx_old.c |    9 ++++++---
 drivers/ide/pci/piix.c         |    8 ++++----
 drivers/ide/pci/scc_pata.c     |    2 +-
 drivers/ide/pci/serverworks.c  |   26 +++++++++++++-------------
 drivers/ide/pci/siimage.c      |   18 ++++++++++--------
 drivers/ide/pci/sis5513.c      |    9 +++++----
 drivers/ide/pci/slc90e66.c     |    5 ++---
 drivers/ide/pci/tc86c001.c     |    4 ++--
 drivers/ide/pci/via82cxxx.c    |    9 +++++++--
 drivers/ide/ppc/pmac.c         |    6 +++---
 include/linux/ide.h            |    3 ++-
 25 files changed, 123 insertions(+), 89 deletions(-)

Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -819,7 +819,7 @@ init_e100_ide (void)
 		hwif->dma_host_off = &cris_dma_off;
 		hwif->dma_host_on = &cris_dma_on;
 		hwif->dma_off_quietly = &cris_dma_off;
-		hwif->udma_four = 0;
+		hwif->cbl = ATA_CBL_PATA40;
 		hwif->ultra_mask = cris_ultra_mask;
 		hwif->mwdma_mask = 0x07; /* Multiword DMA 0-2 */
 		hwif->autodma = 1;
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -574,7 +574,10 @@ u8 eighty_ninty_three (ide_drive_t *driv
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
 
-	if (hwif->udma_four == 0)
+	if (hwif->cbl == ATA_CBL_PATA40_SHORT)
+		return 1;
+
+	if (hwif->cbl != ATA_CBL_PATA80)
 		goto no_80w;
 
 	/* Check for SATA but only if we are ATA5 or higher */
@@ -600,7 +603,8 @@ no_80w:
 
 	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
 			    "limiting max speed to UDMA33\n",
-			    drive->name, hwif->udma_four ? "drive" : "host");
+			    drive->name,
+			    hwif->cbl == ATA_CBL_PATA80 ? "drive" : "host");
 
 	drive->udma33_warned = 1;
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -460,6 +460,8 @@ static void ide_hwif_restore(ide_hwif_t 
 	hwif->mwdma_mask		= tmp_hwif->mwdma_mask;
 	hwif->swdma_mask		= tmp_hwif->swdma_mask;
 
+	hwif->cbl			= tmp_hwif->cbl;
+
 	hwif->chipset			= tmp_hwif->chipset;
 	hwif->hold			= tmp_hwif->hold;
 
@@ -533,7 +535,6 @@ static void ide_hwif_restore(ide_hwif_t 
 	hwif->extra_base		= tmp_hwif->extra_base;
 	hwif->extra_ports		= tmp_hwif->extra_ports;
 	hwif->autodma			= tmp_hwif->autodma;
-	hwif->udma_four			= tmp_hwif->udma_four;
 
 	hwif->hwif_data			= tmp_hwif->hwif_data;
 }
@@ -1545,7 +1546,11 @@ static int __init ide_setup(char *s)
 				goto bad_option;
 			case -7: /* ata66 */
 #ifdef CONFIG_BLK_DEV_IDEPCI
-				hwif->udma_four = 1;
+				/*
+				 * Use ATA_CBL_PATA40_SHORT so drive side
+				 * cable detection is also overriden.
+				 */
+				hwif->cbl = ATA_CBL_PATA40_SHORT;
 				goto obsolete_option;
 #else
 				goto bad_hwif;
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -234,11 +234,12 @@ static void __devinit init_hwif_aec62xx(
 		pci_read_config_byte (dev, 0x54, &reg54);
 		pci_write_config_byte(dev, 0x54, (reg54 & ~mask));
 		spin_unlock_irqrestore(&ide_lock, flags);
-	} else if (!hwif->udma_four) {
+	} else if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
 		u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
 
 		pci_read_config_byte(hwif->pci_dev, 0x49, &ata66);
-		hwif->udma_four = (ata66 & mask) ? 0 : 1;
+
+		hwif->cbl = (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 	}
 
 	if (!noautodma)
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -594,7 +594,7 @@ out:
  *	FIXME: frobs bits that are not defined on newer ALi devicea
  */
 
-static unsigned int __devinit ata66_ali15x3 (ide_hwif_t *hwif)
+static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= hwif->pci_dev;
 	unsigned int ata66	= 0;
@@ -657,7 +657,7 @@ static unsigned int __devinit ata66_ali1
 
 	local_irq_restore(flags);
 
-	return(ata66);
+	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 /**
@@ -708,8 +708,9 @@ static void __devinit init_hwif_common_a
 		hwif->dma_setup = &ali15x3_dma_setup;
 		if (!noautodma)
 			hwif->autodma = 1;
-		if (!(hwif->udma_four))
-			hwif->udma_four = ata66_ali15x3(hwif);
+
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = ata66_ali15x3(hwif);
 	}
 	hwif->drives[0].autodma = hwif->autodma;
 	hwif->drives[1].autodma = hwif->autodma;
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -433,8 +433,13 @@ static void __devinit init_hwif_amd74xx(
 	if ((amd_config->flags & AMD_BAD_SWDMA) == 0)
 		hwif->swdma_mask = 0x07;
 
-	if (!hwif->udma_four)
-		hwif->udma_four = (amd_80w >> hwif->channel) & 1;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
+		if ((amd_80w >> hwif->channel) & 1)
+			hwif->cbl = ATA_CBL_PATA80;
+		else
+			hwif->cbl = ATA_CBL_PATA40;
+	}
+
         hwif->ide_dma_check = &amd74xx_ide_dma_check;
         if (!noautodma)
                 hwif->autodma = 1;
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -264,10 +264,11 @@ static void __devinit init_hwif_atiixp(i
 	hwif->swdma_mask = 0x04;
 
 	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
+
 	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
-		hwif->udma_four = 1;
+		hwif->cbl = ATA_CBL_PATA80;
 	else
-		hwif->udma_four = 0;
+		hwif->cbl = ATA_CBL_PATA40;
 
 	hwif->dma_host_on = &atiixp_dma_host_on;
 	hwif->dma_host_off = &atiixp_dma_host_off;
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -517,7 +517,7 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
-static unsigned int __devinit ata66_cmd64x(ide_hwif_t *hwif)
+static u8 __devinit ata66_cmd64x(ide_hwif_t *hwif)
 {
 	struct pci_dev  *dev	= hwif->pci_dev;
 	u8 bmidecsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
@@ -526,9 +526,9 @@ static unsigned int __devinit ata66_cmd6
 	case PCI_DEVICE_ID_CMD_648:
 	case PCI_DEVICE_ID_CMD_649:
  		pci_read_config_byte(dev, BMIDECSR, &bmidecsr);
-		return (bmidecsr & mask) ? 1 : 0;
+		return (bmidecsr & mask) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 	default:
-		return 0;
+		return ATA_CBL_PATA40;
 	}
 }
 
@@ -568,8 +568,8 @@ static void __devinit init_hwif_cmd64x(i
 
 	hwif->ide_dma_check = &cmd64x_config_drive_for_dma;
 
-	if (!hwif->udma_four)
-		hwif->udma_four = ata66_cmd64x(hwif);
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_cmd64x(hwif);
 
 	switch (dev->device) {
 	case PCI_DEVICE_ID_CMD_648:
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -187,7 +187,8 @@ static u8 __devinit cs5535_cable_detect(
 
 	/* if a 80 wire cable was detected */
 	pci_read_config_byte(dev, CS5535_CABLE_DETECT, &bit);
-	return (bit & 1);
+
+	return (bit & 1) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 /****
@@ -212,8 +213,7 @@ static void __devinit init_hwif_cs5535(i
 	hwif->ultra_mask = 0x1F;
 	hwif->mwdma_mask = 0x07;
 
-
-	hwif->udma_four = cs5535_cable_detect(hwif->pci_dev);
+	hwif->cbl = cs5535_cable_detect(hwif->pci_dev);
 
 	if (!noautodma)
 		hwif->autodma = 1;
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1329,8 +1329,8 @@ static void __devinit init_hwif_hpt366(i
 	} else
 		pci_read_config_byte (dev, 0x5a, &scr1);
 
-	if (!hwif->udma_four)
-		hwif->udma_four = (scr1 & ata66) ? 0 : 1;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = (scr1 & ata66) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 
 	hwif->ide_dma_check		= &hpt366_config_drive_xfer_rate;
 
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -231,7 +231,7 @@ static int it8213_config_drive_for_dma (
 
 static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 {
-	u8 reg42h = 0, ata66 = 0;
+	u8 reg42h = 0;
 
 	hwif->speedproc = &it8213_tune_chipset;
 	hwif->tuneproc	= &it8213_tuneproc;
@@ -250,11 +250,11 @@ static void __devinit init_hwif_it8213(i
 	hwif->swdma_mask = 0x04;
 
 	pci_read_config_byte(hwif->pci_dev, 0x42, &reg42h);
-	ata66 = (reg42h & 0x02) ? 0 : 1;
 
 	hwif->ide_dma_check = &it8213_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66;
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 
 	/*
 	 *	The BIOS often doesn't set up DMA on this controller
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -491,10 +491,10 @@ static int it821x_config_drive_for_dma (
  *	the needed logic onboard.
  */
 
-static unsigned int __devinit ata66_it821x(ide_hwif_t *hwif)
+static u8 __devinit ata66_it821x(ide_hwif_t *hwif)
 {
 	/* The reference driver also only does disk side */
-	return 1;
+	return ATA_CBL_PATA80;
 }
 
 /**
@@ -663,8 +663,9 @@ static void __devinit init_hwif_it821x(i
 	hwif->swdma_mask = 0x07;
 
 	hwif->ide_dma_check = &it821x_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_it821x(hwif);
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_it821x(hwif);
 
 	/*
 	 *	The BIOS often doesn't set up DMA on this controller
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -25,10 +25,10 @@ typedef enum {
  *	ata66_jmicron		-	Cable check
  *	@hwif: IDE port
  *
- *	Return 1 if the cable is 80pin
+ *	Returns the cable type.
  */
 
-static int __devinit ata66_jmicron(ide_hwif_t *hwif)
+static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = hwif->pci_dev;
 
@@ -70,16 +70,17 @@ static int __devinit ata66_jmicron(ide_h
 	{
 	case PORT_PATA0:
 		if (control & (1 << 3))	/* 40/80 pin primary */
-			return 0;
-		return 1;
+			return ATA_CBL_PATA40;
+		return ATA_CBL_PATA80;
 	case PORT_PATA1:
 		if (control5 & (1 << 19))	/* 40/80 pin secondary */
-			return 0;
-		return 1;
+			return ATA_CBL_PATA40;
+		return ATA_CBL_PATA80;
 	case PORT_SATA:
 		break;
 	}
-	return 1; /* Avoid bogus "control reaches end of non-void function" */
+	/* Avoid bogus "control reaches end of non-void function" */
+	return ATA_CBL_PATA80;
 }
 
 static void jmicron_tuneproc (ide_drive_t *drive, byte mode_wanted)
@@ -159,8 +160,9 @@ static void __devinit init_hwif_jmicron(
 	hwif->mwdma_mask = 0x07;
 
 	hwif->ide_dma_check = &jmicron_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_jmicron(hwif);
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_jmicron(hwif);
 
 	hwif->autodma = 1;
 	hwif->drives[0].autodma = hwif->autodma;
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -225,7 +225,10 @@ static void pdcnew_tune_drive(ide_drive_
 
 static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
 {
-	return get_indexed_reg(hwif, 0x0b) & 0x04;
+	if (get_indexed_reg(hwif, 0x0b) & 0x04)
+		return ATA_CBL_PATA40;
+	else
+		return ATA_CBL_PATA80;
 }
 
 static int pdcnew_config_drive_xfer_rate(ide_drive_t *drive)
@@ -503,8 +506,8 @@ static void __devinit init_hwif_pdc202ne
 
 	hwif->ide_dma_check = &pdcnew_config_drive_xfer_rate;
 
-	if (!hwif->udma_four)
-		hwif->udma_four = pdcnew_cable_detect(hwif) ? 0 : 1;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = pdcnew_cable_detect(hwif);
 
 	if (!noautodma)
 		hwif->autodma = 1;
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -152,8 +152,10 @@ static void pdc202xx_tune_drive(ide_driv
 static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
 {
 	u16 CIS = 0, mask = (hwif->channel) ? (1<<11) : (1<<10);
+
 	pci_read_config_word(hwif->pci_dev, 0x50, &CIS);
-	return (CIS & mask) ? 1 : 0;
+
+	return (CIS & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 }
 
 /*
@@ -357,8 +359,9 @@ static void __devinit init_hwif_pdc202xx
 	hwif->dma_timeout = &pdc202xx_dma_timeout;
 
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_PROMISE_20246) {
-		if (!(hwif->udma_four))
-			hwif->udma_four = (pdc202xx_old_cable_detect(hwif)) ? 0 : 1;
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = pdc202xx_old_cable_detect(hwif);
+
 		hwif->dma_start = &pdc202xx_old_ide_dma_start;
 		hwif->ide_dma_end = &pdc202xx_old_ide_dma_end;
 	} 
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -394,14 +394,14 @@ static void piix_dma_clear_irq(ide_drive
 	hwif->OUTB(dma_stat, hwif->dma_status);
 }
 
-static int __devinit piix_cable_detect(ide_hwif_t *hwif)
+static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = hwif->pci_dev;
 	u8 reg54h = 0, mask = hwif->channel ? 0xc0 : 0x30;
 
 	pci_read_config_byte(dev, 0x54, &reg54h);
 
-	return (reg54h & mask) ? 1 : 0;
+	return (reg54h & mask) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 /**
@@ -444,8 +444,8 @@ static void __devinit init_hwif_piix(ide
 	hwif->swdma_mask = 0x04;
 
 	if (hwif->ultra_mask & 0x78) {
-		if (!hwif->udma_four)
-			hwif->udma_four = piix_cable_detect(hwif);
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = piix_cable_detect(hwif);
 	}
 
 	if (no_piix_dma)
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -716,7 +716,7 @@ static void __devinit init_hwif_scc(ide_
 	hwif->atapi_dma = 1;
 
 	/* we support 80c cable only. */
-	hwif->udma_four = 1;
+	hwif->cbl = ATA_CBL_PATA80;
 
 	hwif->autodma = 0;
 	if (!noautodma)
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -329,9 +329,9 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
-static unsigned int __devinit ata66_svwks_svwks (ide_hwif_t *hwif)
+static u8 __devinit ata66_svwks_svwks(ide_hwif_t *hwif)
 {
-	return 1;
+	return ATA_CBL_PATA80;
 }
 
 /* On Dell PowerEdge servers with a CSB5/CSB6, the top two bits
@@ -341,7 +341,7 @@ static unsigned int __devinit ata66_svwk
  * Bit 14 clear = primary IDE channel does not have 80-pin cable.
  * Bit 14 set   = primary IDE channel has 80-pin cable.
  */
-static unsigned int __devinit ata66_svwks_dell (ide_hwif_t *hwif)
+static u8 __devinit ata66_svwks_dell(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = hwif->pci_dev;
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
@@ -349,8 +349,8 @@ static unsigned int __devinit ata66_svwk
 	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE ||
 	     dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE))
 		return ((1 << (hwif->channel + 14)) &
-			dev->subsystem_device) ? 1 : 0;
-	return 0;
+			dev->subsystem_device) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
+	return ATA_CBL_PATA40;
 }
 
 /* Sun Cobalt Alpine hardware avoids the 80-pin cable
@@ -359,18 +359,18 @@ static unsigned int __devinit ata66_svwk
  *
  * WARNING: this only works on Alpine hardware!
  */
-static unsigned int __devinit ata66_svwks_cobalt (ide_hwif_t *hwif)
+static u8 __devinit ata66_svwks_cobalt(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = hwif->pci_dev;
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_SUN &&
 	    dev->vendor	== PCI_VENDOR_ID_SERVERWORKS &&
 	    dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
 		return ((1 << (hwif->channel + 14)) &
-			dev->subsystem_device) ? 1 : 0;
-	return 0;
+			dev->subsystem_device) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
+	return ATA_CBL_PATA40;
 }
 
-static unsigned int __devinit ata66_svwks (ide_hwif_t *hwif)
+static u8 __devinit ata66_svwks(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = hwif->pci_dev;
 
@@ -389,9 +389,9 @@ static unsigned int __devinit ata66_svwk
 	/* Per Specified Design by OEM, and ASIC Architect */
 	if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
 	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2))
-		return 1;
+		return ATA_CBL_PATA80;
 
-	return 0;
+	return ATA_CBL_PATA40;
 }
 
 static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
@@ -422,8 +422,8 @@ static void __devinit init_hwif_svwks (i
 
 	hwif->ide_dma_check = &svwks_config_drive_xfer_rate;
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
-		if (!hwif->udma_four)
-			hwif->udma_four = ata66_svwks(hwif);
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = ata66_svwks(hwif);
 	}
 	if (!noautodma)
 		hwif->autodma = 1;
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -933,16 +933,17 @@ static void __devinit init_iops_siimage(
  *	interface.
  */
 
-static unsigned int __devinit ata66_siimage(ide_hwif_t *hwif)
+static u8 __devinit ata66_siimage(ide_hwif_t *hwif)
 {
 	unsigned long addr = siimage_selreg(hwif, 0);
-	if (pci_get_drvdata(hwif->pci_dev) == NULL) {
-		u8 ata66 = 0;
+	u8 ata66 = 0;
+
+	if (pci_get_drvdata(hwif->pci_dev) == NULL)
 		pci_read_config_byte(hwif->pci_dev, addr, &ata66);
-		return (ata66 & 0x01) ? 1 : 0;
-	}
+	else
+		ata66 = hwif->INB(addr);
 
-	return (hwif->INB(addr) & 0x01) ? 1 : 0;
+	return (ata66 & 0x01) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 /**
@@ -988,8 +989,9 @@ static void __devinit init_hwif_siimage(
 		hwif->atapi_dma = 1;
 
 	hwif->ide_dma_check = &siimage_config_drive_for_dma;
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_siimage(hwif);
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_siimage(hwif);
 
 	if (hwif->mmio) {
 		hwif->ide_dma_test_irq = &siimage_mmio_ide_dma_test_irq;
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -796,7 +796,7 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
-static unsigned int __devinit ata66_sis5513 (ide_hwif_t *hwif)
+static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
 {
 	u8 ata66 = 0;
 
@@ -811,7 +811,8 @@ static unsigned int __devinit ata66_sis5
 		pci_read_config_byte(hwif->pci_dev, 0x48, &reg48h);
 		ata66 = (reg48h & mask) ? 0 : 1;
 	}
-        return ata66;
+
+	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
 static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
@@ -841,8 +842,8 @@ static void __devinit init_hwif_sis5513 
 	if (!chipset_family)
 		return;
 
-	if (!(hwif->udma_four))
-		hwif->udma_four = ata66_sis5513(hwif);
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_sis5513(hwif);
 
 	if (chipset_family > ATA_16) {
 		hwif->ide_dma_check = &sis5513_config_xfer_rate;
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -199,10 +199,9 @@ static void __devinit init_hwif_slc90e66
 	hwif->mwdma_mask = 0x06;
 	hwif->swdma_mask = 0x04;
 
-	if (!hwif->udma_four) {
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
 		/* bit[0(1)]: 0:80, 1:40 */
-		hwif->udma_four = (reg47 & mask) ? 0 : 1;
-	}
+		hwif->cbl = (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 
 	hwif->ide_dma_check = &slc90e66_config_drive_xfer_rate;
 
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -220,13 +220,13 @@ static void __devinit init_hwif_tc86c001
 	hwif->ide_dma_check	= &tc86c001_config_drive_xfer_rate;
 	hwif->dma_start 	= &tc86c001_dma_start;
 
-	if (!hwif->udma_four) {
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
 		/*
 		 * System Control  1 Register bit 13 (PDIAGN):
 		 * 0=80-pin cable, 1=40-pin cable
 		 */
 		scr1 = hwif->INW(sc_base + 0x00);
-		hwif->udma_four = (scr1 & 0x2000) ? 0 : 1;
+		hwif->cbl = (scr1 & 0x2000) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
 	}
 
 	if (!noautodma)
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -448,8 +448,13 @@ static void __devinit init_hwif_via82cxx
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
-	if (!hwif->udma_four)
-		hwif->udma_four = (vdev->via_80w >> hwif->channel) & 1;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
+		if ((vdev->via_80w >> hwif->channel) & 1)
+			hwif->cbl = ATA_CBL_PATA80;
+		else
+			hwif->cbl = ATA_CBL_PATA40;
+	}
+
 	hwif->ide_dma_check = &via82cxxx_ide_dma_check;
 	if (!noautodma)
 		hwif->autodma = 1;
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -942,8 +942,8 @@ pmac_ide_tune_chipset (ide_drive_t *driv
 				return 1;
 		case XFER_UDMA_4:
 		case XFER_UDMA_3:
-			if (HWIF(drive)->udma_four == 0)
-				return 1;		
+			if (drive->hwif->cbl != ATA_CBL_PATA80)
+				return 1;
 		case XFER_UDMA_2:
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
@@ -1244,7 +1244,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	hwif->chipset = ide_pmac;
 	hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET] || pmif->mediabay;
 	hwif->hold = pmif->mediabay;
-	hwif->udma_four = pmif->cable_80;
+	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 	hwif->drives[0].unmask = 1;
 	hwif->drives[1].unmask = 1;
 	hwif->tuneproc = pmac_ide_tuneproc;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -686,6 +686,8 @@ typedef struct hwif_s {
 	u8 mwdma_mask;
 	u8 swdma_mask;
 
+	u8 cbl;		/* cable type */
+
 	hwif_chipset_t chipset;	/* sub-module for tuning.. */
 
 	struct pci_dev  *pci_dev;	/* for pci chipsets */
@@ -792,7 +794,6 @@ typedef struct hwif_s {
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	reset      : 1;	/* reset after probe */
 	unsigned	autodma    : 1;	/* auto-attempt using DMA at boot */
-	unsigned	udma_four  : 1;	/* 1=ATA-66 capable, 0=default */
 	unsigned	no_lba48   : 1; /* 1 = cannot do LBA48 */
 	unsigned	no_lba48_dma : 1; /* 1 = cannot do LBA48 DMA */
 	unsigned	auto_poll  : 1; /* supports nop auto-poll */
