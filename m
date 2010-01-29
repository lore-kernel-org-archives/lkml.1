Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812Ab0A2QMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0A2QMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229Ab0A2QM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:12:27 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab0A2QJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=c16rVezFEr47TGvpm/e6lBExIhcIW0CnR6a88bY8qd1YsS7ZZtfSyu/VF7lj5No5z4
         FGs1l/Drnm1nJTl1gG8FqziarzJNbKS1fYuquakmT6cIGzGCWpbBdHoLmgQbneA6l/6R
         CPbDszs1Z6hrK4HrMyng64iIy2AQE+selmyFg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:41 +0100
Message-Id: <20100129160941.21495.37920.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 61/68] serverworks: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] serverworks: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_serverworks.h |   20 ++
 drivers/ide/serverworks.c      |  281 ++---------------------------------------
 2 files changed, 40 insertions(+), 261 deletions(-)

Index: b/drivers/ata/pata_serverworks.h
===================================================================
--- a/drivers/ata/pata_serverworks.h
+++ b/drivers/ata/pata_serverworks.h
@@ -11,6 +11,9 @@
  *         *** to detect 80-conductor cable presence. ***
  *
  *   CSB6: `Champion South Bridge' IDE Interface (optional: third channel)
+ *
+ *   HT1000: AKA BCM5785 - Hypertransport Southbridge for Opteron systems. IDE
+ *   controller same as the CSB6. Single channel ATA100 only.
  */
 
 #define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
@@ -213,6 +216,10 @@ static int serverworks_fixup_csb(struct
 			pci_write_config_dword(findev, 0x4C, reg4c);
 			pci_dev_put(findev);
 		}
+#ifdef __IDE2LIBATA
+		outb_p(0x06, 0x0c00);
+		pdev->irq = inb_p(0x0c01);
+#endif
 	} else {
 		struct pci_dev *findev = NULL;
 		u8 reg41 = 0;
@@ -225,6 +232,17 @@ static int serverworks_fixup_csb(struct
 			pci_write_config_byte(findev, 0x41, reg41);
 			pci_dev_put(findev);
 		}
+#ifdef __IDE2LIBATA
+		/*
+		 * This is a device pin issue on CSB6.
+		 * Since there will be a future raid mode,
+		 * early versions of the chipset require the
+		 * interrupt pin to be set, and it is a compatibility
+		 * mode issue.
+		 */
+		if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
+			pdev->irq = 0;
+#endif
 	}
 	/* setup the UDMA Control register
 	 *
@@ -268,7 +286,9 @@ static int serverworks_fixup(struct pci_
 		rc = serverworks_fixup_osb4(pdev);
 		break;
 	case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
+#ifndef __IDE2LIBATA
 		ata_pci_bmdma_clear_simplex(pdev);
+#endif
 		/* fall through */
 	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
 	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
Index: b/drivers/ide/serverworks.c
===================================================================
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -8,21 +8,6 @@
  *
  * RCC/ServerWorks IDE driver for Linux
  *
- *   OSB4: `Open South Bridge' IDE Interface (fn 1)
- *         supports UDMA mode 2 (33 MB/s)
- *
- *   CSB5: `Champion South Bridge' IDE Interface (fn 1)
- *         all revisions support UDMA mode 4 (66 MB/s)
- *         revision A2.0 and up support UDMA mode 5 (100 MB/s)
- *
- *         *** The CSB5 does not provide ANY register ***
- *         *** to detect 80-conductor cable presence. ***
- *
- *   CSB6: `Champion South Bridge' IDE Interface (optional: third channel)
- *
- *   HT1000: AKA BCM5785 - Hypertransport Southbridge for Opteron systems. IDE
- *   controller same as the CSB6. Single channel ATA100 only.
- *
  * Documentation:
  *	Available under NDA only. Errata info very hard to get.
  *
@@ -39,19 +24,6 @@
 
 #define DRV_NAME "serverworks"
 
-#define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
-#define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
-
-/* Seagate Barracuda ATA IV Family drives in UDMA mode 5
- * can overrun their FIFOs when used with the CSB5 */
-static const char *svwks_bad_ata100[] = {
-	"ST320011A",
-	"ST340016A",
-	"ST360021A",
-	"ST380021A",
-	NULL
-};
-
 static int check_in_drive_lists (ide_drive_t *drive, const char **list)
 {
 	char *m = (char *)&drive->id[ATA_ID_PROD];
@@ -62,6 +34,19 @@ static int check_in_drive_lists (ide_dri
 	return 0;
 }
 
+static int ata_cable_40wire(ide_hwif_t *hwif)
+{
+	return ATA_CBL_PATA40;
+}
+
+static int ata_cable_unknown(ide_hwif_t *hwif)
+{
+	return ATA_CBL_PATA80;
+}
+
+#include <linux/ide2libata.h>
+#include "../ata/pata_serverworks.h"
+
 static u8 svwks_udma_filter(ide_drive_t *drive)
 {
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
@@ -78,7 +63,7 @@ static u8 svwks_udma_filter(ide_drive_t
 
 		/* If someone decides to do UDMA133 on CSB5 the same
 		   issue will bite so be inclusive */
-		if (mode > 2 && check_in_drive_lists(drive, svwks_bad_ata100))
+		if (mode > 2 && check_in_drive_lists(drive, csb_bad_ata100))
 			mode = 2;
 
 		switch(mode) {
@@ -92,249 +77,23 @@ static u8 svwks_udma_filter(ide_drive_t
 	}
 }
 
-static u8 svwks_csb_check (struct pci_dev *dev)
-{
-	switch (dev->device) {
-		case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
-		case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
-		case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
-		case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
-			return 1;
-		default:
-			break;
-	}
-	return 0;
-}
-
-static void svwks_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	static const u8 pio_modes[] = { 0x5d, 0x47, 0x34, 0x22, 0x20 };
-	static const u8 drive_pci[] = { 0x41, 0x40, 0x43, 0x42 };
-
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-	pci_write_config_byte(dev, drive_pci[drive->dn], pio_modes[pio]);
-
-	if (svwks_csb_check(dev)) {
-		u16 csb_pio = 0;
-
-		pci_read_config_word(dev, 0x4a, &csb_pio);
-
-		csb_pio &= ~(0x0f << (4 * drive->dn));
-		csb_pio |= (pio << (4 * drive->dn));
-
-		pci_write_config_word(dev, 0x4a, csb_pio);
-	}
-}
-
-static void svwks_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	static const u8 udma_modes[]		= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05 };
-	static const u8 dma_modes[]		= { 0x77, 0x21, 0x20 };
-	static const u8 drive_pci2[]		= { 0x45, 0x44, 0x47, 0x46 };
-
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	const u8 speed		= drive->dma_mode;
-	u8 unit			= drive->dn & 1;
-
-	u8 ultra_enable	 = 0, ultra_timing = 0, dma_timing = 0;
-
-	pci_read_config_byte(dev, (0x56|hwif->channel), &ultra_timing);
-	pci_read_config_byte(dev, 0x54, &ultra_enable);
-
-	ultra_timing	&= ~(0x0F << (4*unit));
-	ultra_enable	&= ~(0x01 << drive->dn);
-
-	if (speed >= XFER_UDMA_0) {
-		dma_timing   |= dma_modes[2];
-		ultra_timing |= (udma_modes[speed - XFER_UDMA_0] << (4 * unit));
-		ultra_enable |= (0x01 << drive->dn);
-	} else if (speed >= XFER_MW_DMA_0)
-		dma_timing   |= dma_modes[speed - XFER_MW_DMA_0];
-
-	pci_write_config_byte(dev, drive_pci2[drive->dn], dma_timing);
-	pci_write_config_byte(dev, (0x56|hwif->channel), ultra_timing);
-	pci_write_config_byte(dev, 0x54, ultra_enable);
-}
-
 static int init_chipset_svwks(struct pci_dev *dev)
 {
-	unsigned int reg;
-	u8 btr;
-
-	/* force Master Latency Timer value to 64 PCICLKs */
-	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x40);
-
-	/* OSB4 : South Bridge and IDE */
-	if (dev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
-		struct pci_dev *isa_dev =
-			pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
-					PCI_DEVICE_ID_SERVERWORKS_OSB4, NULL);
-		if (isa_dev) {
-			pci_read_config_dword(isa_dev, 0x64, &reg);
-			reg &= ~0x00002000; /* disable 600ns interrupt mask */
-			if(!(reg & 0x00004000))
-				printk(KERN_DEBUG DRV_NAME " %s: UDMA not BIOS "
-					"enabled.\n", pci_name(dev));
-			reg |=  0x00004000; /* enable UDMA/33 support */
-			pci_write_config_dword(isa_dev, 0x64, reg);
-			pci_dev_put(isa_dev);
-		}
-	}
-
-	/* setup CSB5/CSB6 : South Bridge and IDE option RAID */
-	else if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE) ||
-		 (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
-		 (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)) {
-
-		/* Third Channel Test */
-		if (!(PCI_FUNC(dev->devfn) & 1)) {
-			struct pci_dev * findev = NULL;
-			u32 reg4c = 0;
-			findev = pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
-				PCI_DEVICE_ID_SERVERWORKS_CSB5, NULL);
-			if (findev) {
-				pci_read_config_dword(findev, 0x4C, &reg4c);
-				reg4c &= ~0x000007FF;
-				reg4c |=  0x00000040;
-				reg4c |=  0x00000020;
-				pci_write_config_dword(findev, 0x4C, reg4c);
-				pci_dev_put(findev);
-			}
-			outb_p(0x06, 0x0c00);
-			dev->irq = inb_p(0x0c01);
-		} else {
-			struct pci_dev * findev = NULL;
-			u8 reg41 = 0;
-
-			findev = pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
-					PCI_DEVICE_ID_SERVERWORKS_CSB6, NULL);
-			if (findev) {
-				pci_read_config_byte(findev, 0x41, &reg41);
-				reg41 &= ~0x40;
-				pci_write_config_byte(findev, 0x41, reg41);
-				pci_dev_put(findev);
-			}
-			/*
-			 * This is a device pin issue on CSB6.
-			 * Since there will be a future raid mode,
-			 * early versions of the chipset require the
-			 * interrupt pin to be set, and it is a compatibility
-			 * mode issue.
-			 */
-			if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE)
-				dev->irq = 0;
-		}
-//		pci_read_config_dword(dev, 0x40, &pioreg)
-//		pci_write_config_dword(dev, 0x40, 0x99999999);
-//		pci_read_config_dword(dev, 0x44, &dmareg);
-//		pci_write_config_dword(dev, 0x44, 0xFFFFFFFF);
-		/* setup the UDMA Control register
-		 *
-		 * 1. clear bit 6 to enable DMA
-		 * 2. enable DMA modes with bits 0-1
-		 * 	00 : legacy
-		 * 	01 : udma2
-		 * 	10 : udma2/udma4
-		 * 	11 : udma2/udma4/udma5
-		 */
-		pci_read_config_byte(dev, 0x5A, &btr);
-		btr &= ~0x40;
-		if (!(PCI_FUNC(dev->devfn) & 1))
-			btr |= 0x2;
-		else
-			btr |= (dev->revision >= SVWKS_CSB5_REVISION_NEW) ? 0x3 : 0x2;
-		pci_write_config_byte(dev, 0x5A, btr);
-	}
-	/* Setup HT1000 SouthBridge Controller - Single Channel Only */
-	else if (dev->device == PCI_DEVICE_ID_SERVERWORKS_HT1000IDE) {
-		pci_read_config_byte(dev, 0x5A, &btr);
-		btr &= ~0x40;
-		btr |= 0x3;
-		pci_write_config_byte(dev, 0x5A, btr);
-	}
+	(void)serverworks_fixup(dev);
 
 	return 0;
 }
 
-static u8 ata66_svwks_svwks(ide_hwif_t *hwif)
-{
-	return ATA_CBL_PATA80;
-}
-
-/* On Dell PowerEdge servers with a CSB5/CSB6, the top two bits
- * of the subsystem device ID indicate presence of an 80-pin cable.
- * Bit 15 clear = secondary IDE channel does not have 80-pin cable.
- * Bit 15 set   = secondary IDE channel has 80-pin cable.
- * Bit 14 clear = primary IDE channel does not have 80-pin cable.
- * Bit 14 set   = primary IDE channel has 80-pin cable.
- */
-static u8 ata66_svwks_dell(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	if (dev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
-	    dev->vendor	== PCI_VENDOR_ID_SERVERWORKS &&
-	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE ||
-	     dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE))
-		return ((1 << (hwif->channel + 14)) &
-			dev->subsystem_device) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
-	return ATA_CBL_PATA40;
-}
-
-/* Sun Cobalt Alpine hardware avoids the 80-pin cable
- * detect issue by attaching the drives directly to the board.
- * This check follows the Dell precedent (how scary is that?!)
- *
- * WARNING: this only works on Alpine hardware!
- */
-static u8 ata66_svwks_cobalt(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	if (dev->subsystem_vendor == PCI_VENDOR_ID_SUN &&
-	    dev->vendor	== PCI_VENDOR_ID_SERVERWORKS &&
-	    dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
-		return ((1 << (hwif->channel + 14)) &
-			dev->subsystem_device) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
-	return ATA_CBL_PATA40;
-}
-
-static int svwks_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	/* Server Works */
-	if (dev->subsystem_vendor == PCI_VENDOR_ID_SERVERWORKS)
-		return ata66_svwks_svwks (hwif);
-	
-	/* Dell PowerEdge */
-	if (dev->subsystem_vendor == PCI_VENDOR_ID_DELL)
-		return ata66_svwks_dell (hwif);
-
-	/* Cobalt Alpine */
-	if (dev->subsystem_vendor == PCI_VENDOR_ID_SUN)
-		return ata66_svwks_cobalt (hwif);
-
-	/* Per Specified Design by OEM, and ASIC Architect */
-	if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
-	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2))
-		return ATA_CBL_PATA80;
-
-	return ATA_CBL_PATA40;
-}
-
 static const struct ide_port_ops osb4_port_ops = {
-	.set_pio_mode		= svwks_set_pio_mode,
-	.set_dma_mode		= svwks_set_dma_mode,
+	.set_pio_mode		= serverworks_set_piomode,
+	.set_dma_mode		= serverworks_set_dmamode,
 };
 
 static const struct ide_port_ops svwks_port_ops = {
-	.set_pio_mode		= svwks_set_pio_mode,
-	.set_dma_mode		= svwks_set_dma_mode,
+	.set_pio_mode		= serverworks_set_piomode,
+	.set_dma_mode		= serverworks_set_dmamode,
 	.udma_filter		= svwks_udma_filter,
-	.cable_detect		= svwks_cable_detect,
+	.cable_detect		= serverworks_cable_detect,
 };
 
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
