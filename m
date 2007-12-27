Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXL0R2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXL0R2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 12:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXL0R2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 12:28:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:1606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXL0R2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 12:28:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CXmPzsqx9A5q38MAuZ9twoji7fGprIccYn/Dur3emz70v1Gyw03KhsWNagD1kFtKM/iJZ3T0+7F/cixUeyEOf+hYYIjfMUvtnQMqv5rTzLdOS3vGamXj04lS3JKHWj8O3rzlm65wP0bbLFV3c4lk3b9MqewmKjjnAzUnZ2IQeec=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] amd74xx: remove amd_ide_chips table
Date: Thu, 27 Dec 2007 18:36:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271836.23028.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Remove no longer needed assertion from amd74xx_probe().

* Factor out cable detection for AMD7409 to amd7409_cable_detect() and for
  chipsets >= AMD7411 to amd7411_cable_detect().

* Use dev->vendor and dev->device instead of amd_config->udma_mask when
  selecting cable detection method and checking for broken FIFO support in
  init_chipset_amd74xx().

* Remove no longer needed AMD_BAD_FIFO define.

* Add 'swdma' parameter for setting .swdma_mask to DECLARE_AMD_DEV() macro.

* Add 'udma' parameter for setting .udma_mask to DECLARE_{AMD,NV}_DEV() macro.

* Keep a copy of a current amd74xx_chipsets[] entry in amd74xx_probe()
  in order to fix ->swdma_mask on early AMD7409 revisions and ->udma_mask
  on Serenade mainboards.

* Remove no longer needed fixups from init_chipset_amd74xx()
  and AMD_CHECK_{SWDMA,SERENADE} defines.

* Move printing banner message from init_chipset_amd74xx() to amd74xx_probe(),
  also remove incorrect comment while at it.

* Use hwif->ultra_mask instead of amd_config->udma_mask in amd_set_drive().

* Add 'udma_mask' argument to amd_set_speed() and pass UDMA mask from
  amd_set_drive() instead of using amd_config->udma_mask.

* Move amd_config->base from AMD_* defines to users of these defines and add
  0x40 the defined values.  Then add amd_offset() inline helper for selecting
  offset from 0x40 base (needed for nVidia controllers) and finally use it in
  amd_set_speed(), amd7411_cable_detect() and init_chipset_amd74xx() instead
  of amd_config->base.

* Remove no longer needed AMD_BAD_SWDMA define, ->{swdma,ultra}_mask setup
  from init_hwif_amd74xx(), amd_{config,chipset} variables and amd_ide_chips
  table.

* Fix init_chipset_amd74xx() comment.

* Bump driver version.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-305 bytes
 drivers/ide/pci/amd74xx.c |  275 ++++++++++++++++++++--------------------------
 1 file changed, 124 insertions(+), 151 deletions(-)

Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,5 +1,5 @@
 /*
- * Version 2.24
+ * Version 2.25
  *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
@@ -28,81 +28,46 @@
 
 #include "ide-timing.h"
 
-#define AMD_IDE_CONFIG		(0x01 + amd_config->base)
-#define AMD_CABLE_DETECT	(0x02 + amd_config->base)
-#define AMD_DRIVE_TIMING	(0x08 + amd_config->base)
-#define AMD_8BIT_TIMING		(0x0e + amd_config->base)
-#define AMD_ADDRESS_SETUP	(0x0c + amd_config->base)
-#define AMD_UDMA_TIMING		(0x10 + amd_config->base)
-
-#define AMD_CHECK_SWDMA		0x08
-#define AMD_BAD_SWDMA		0x10
-#define AMD_BAD_FIFO		0x20
-#define AMD_CHECK_SERENADE	0x40
-
-/*
- * AMD SouthBridge chips.
- */
-
-static struct amd_ide_chip {
-	unsigned short id;
-	u8 base;
-	u8 udma_mask;
-	u8 flags;
-} amd_ide_chips[] = {
-	{ PCI_DEVICE_ID_AMD_COBRA_7401,		 0x40, ATA_UDMA2, AMD_BAD_SWDMA },
-	{ PCI_DEVICE_ID_AMD_VIPER_7409,		 0x40, ATA_UDMA4, AMD_CHECK_SWDMA },
-	{ PCI_DEVICE_ID_AMD_VIPER_7411,		 0x40, ATA_UDMA5, AMD_BAD_FIFO },
-	{ PCI_DEVICE_ID_AMD_OPUS_7441,		 0x40, ATA_UDMA5, },
-	{ PCI_DEVICE_ID_AMD_8111_IDE,		 0x40, ATA_UDMA6, AMD_CHECK_SERENADE },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_IDE,	 0x50, ATA_UDMA5, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE2_IDE,	 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE2S_IDE,	 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE2S_SATA,	 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE3_IDE,	 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_IDE,	 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA,	 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE3S_SATA2,	 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE, 0x50, ATA_UDMA6, },
-	{ PCI_DEVICE_ID_AMD_CS5536_IDE,		 0x40, ATA_UDMA5, },
-	{ 0 }
+enum {
+	AMD_IDE_CONFIG		= 0x41,
+	AMD_CABLE_DETECT	= 0x42,
+	AMD_DRIVE_TIMING	= 0x48,
+	AMD_8BIT_TIMING		= 0x4e,
+	AMD_ADDRESS_SETUP	= 0x4c,
+	AMD_UDMA_TIMING		= 0x50,
 };
 
-static struct amd_ide_chip *amd_config;
-static const struct ide_port_info *amd_chipset;
 static unsigned int amd_80w;
 static unsigned int amd_clock;
 
 static char *amd_dma[] = { "16", "25", "33", "44", "66", "100", "133" };
 static unsigned char amd_cyc2udma[] = { 6, 6, 5, 4, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 7 };
 
+static inline u8 amd_offset(struct pci_dev *dev)
+{
+	return (dev->vendor == PCI_VENDOR_ID_NVIDIA) ? 0x10 : 0;
+}
+
 /*
  * amd_set_speed() writes timing values to the chipset registers
  */
 
-static void amd_set_speed(struct pci_dev *dev, unsigned char dn, struct ide_timing *timing)
+static void amd_set_speed(struct pci_dev *dev, u8 dn, u8 udma_mask,
+			  struct ide_timing *timing)
 {
-	unsigned char t;
+	u8 t = 0, offset = amd_offset(dev);
 
-	pci_read_config_byte(dev, AMD_ADDRESS_SETUP, &t);
+	pci_read_config_byte(dev, AMD_ADDRESS_SETUP + offset, &t);
 	t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
-	pci_write_config_byte(dev, AMD_ADDRESS_SETUP, t);
+	pci_write_config_byte(dev, AMD_ADDRESS_SETUP + offset, t);
 
-	pci_write_config_byte(dev, AMD_8BIT_TIMING + (1 - (dn >> 1)),
+	pci_write_config_byte(dev, AMD_8BIT_TIMING + offset + (1 - (dn >> 1)),
 		((FIT(timing->act8b, 1, 16) - 1) << 4) | (FIT(timing->rec8b, 1, 16) - 1));
 
-	pci_write_config_byte(dev, AMD_DRIVE_TIMING + (3 - dn),
+	pci_write_config_byte(dev, AMD_DRIVE_TIMING + offset + (3 - dn),
 		((FIT(timing->active, 1, 16) - 1) << 4) | (FIT(timing->recover, 1, 16) - 1));
 
-	switch (amd_config->udma_mask) {
+	switch (udma_mask) {
 	case ATA_UDMA2: t = timing->udma ? (0xc0 | (FIT(timing->udma, 2, 5) - 2)) : 0x03; break;
 	case ATA_UDMA4: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 2, 10)]) : 0x03; break;
 	case ATA_UDMA5: t = timing->udma ? (0xc0 | amd_cyc2udma[FIT(timing->udma, 1, 10)]) : 0x03; break;
@@ -110,7 +75,7 @@ static void amd_set_speed(struct pci_dev
 	default: return;
 	}
 
-	pci_write_config_byte(dev, AMD_UDMA_TIMING + (3 - dn), t);
+	pci_write_config_byte(dev, AMD_UDMA_TIMING + offset + (3 - dn), t);
 }
 
 /*
@@ -120,12 +85,14 @@ static void amd_set_speed(struct pci_dev
 
 static void amd_set_drive(ide_drive_t *drive, const u8 speed)
 {
-	ide_drive_t *peer = HWIF(drive)->drives + (~drive->dn & 1);
+	ide_hwif_t *hwif = drive->hwif;
+	ide_drive_t *peer = hwif->drives + (~drive->dn & 1);
 	struct ide_timing t, p;
 	int T, UT;
+	u8 udma_mask = hwif->ultra_mask;
 
 	T = 1000000000 / amd_clock;
-	UT = (amd_config->udma_mask == ATA_UDMA2) ? T : (T / 2);
+	UT = (udma_mask == ATA_UDMA2) ? T : (T / 2);
 
 	ide_timing_compute(drive, speed, &t, T, UT);
 
@@ -137,7 +104,7 @@ static void amd_set_drive(ide_drive_t *d
 	if (speed == XFER_UDMA_5 && amd_clock <= 33333) t.udma = 1;
 	if (speed == XFER_UDMA_6 && amd_clock <= 33333) t.udma = 15;
 
-	amd_set_speed(HWIF(drive)->pci_dev, drive->dn, &t);
+	amd_set_speed(hwif->pci_dev, drive->dn, udma_mask, &t);
 }
 
 /*
@@ -149,67 +116,68 @@ static void amd_set_pio_mode(ide_drive_t
 	amd_set_drive(drive, XFER_PIO_0 + pio);
 }
 
-/*
- * The initialization callback. Here we determine the IDE chip type
- * and initialize its drive independent registers.
- */
+static void __devinit amd7409_cable_detect(struct pci_dev *dev,
+					   const char *name)
+{
+	/* no host side cable detection */
+	amd_80w = 0x03;
+}
 
-static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const char *name)
+static void __devinit amd7411_cable_detect(struct pci_dev *dev,
+					   const char *name)
 {
-	unsigned char t;
-	unsigned int u;
 	int i;
+	u32 u = 0;
+	u8 t = 0, offset = amd_offset(dev);
+
+	pci_read_config_byte(dev, AMD_CABLE_DETECT + offset, &t);
+	pci_read_config_dword(dev, AMD_UDMA_TIMING + offset, &u);
+	amd_80w = ((t & 0x3) ? 1 : 0) | ((t & 0xc) ? 2 : 0);
+	for (i = 24; i >= 0; i -= 8)
+		if (((u >> i) & 4) && !(amd_80w & (1 << (1 - (i >> 4))))) {
+			printk(KERN_WARNING "%s: BIOS didn't set cable bits "
+					    "correctly. Enabling workaround.\n",
+					    name);
+			amd_80w |= (1 << (1 - (i >> 4)));
+		}
+}
 
 /*
- * Check for bad SWDMA.
+ * The initialization callback.  Initialize drive independent registers.
  */
 
-	if (amd_config->flags & AMD_CHECK_SWDMA) {
-		if (dev->revision <= 7)
-			amd_config->flags |= AMD_BAD_SWDMA;
-	}
+static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev,
+						   const char *name)
+{
+	u8 t = 0, offset = amd_offset(dev);
 
 /*
  * Check 80-wire cable presence.
  */
 
-	switch (amd_config->udma_mask) {
-
-		case ATA_UDMA6:
-		case ATA_UDMA5:
-			pci_read_config_byte(dev, AMD_CABLE_DETECT, &t);
-			pci_read_config_dword(dev, AMD_UDMA_TIMING, &u);
-			amd_80w = ((t & 0x3) ? 1 : 0) | ((t & 0xc) ? 2 : 0);
-			for (i = 24; i >= 0; i -= 8)
-				if (((u >> i) & 4) && !(amd_80w & (1 << (1 - (i >> 4))))) {
-					printk(KERN_WARNING "%s: BIOS didn't set cable bits correctly. 
Enabling workaround.\n",
-						amd_chipset->name);
-					amd_80w |= (1 << (1 - (i >> 4)));
-				}
-			break;
-
-		case ATA_UDMA4:
-			/* no host side cable detection */
-			amd_80w = 0x03;
-			break;
-	}
+	if (dev->vendor == PCI_VENDOR_ID_AMD &&
+	    dev->device == PCI_DEVICE_ID_AMD_COBRA_7401)
+		; /* no UDMA > 2 */
+	else if (dev->vendor == PCI_VENDOR_ID_AMD &&
+		 dev->device == PCI_DEVICE_ID_AMD_VIPER_7409)
+		amd7409_cable_detect(dev, name);
+	else
+		amd7411_cable_detect(dev, name);
 
 /*
  * Take care of prefetch & postwrite.
  */
 
-	pci_read_config_byte(dev, AMD_IDE_CONFIG, &t);
-	pci_write_config_byte(dev, AMD_IDE_CONFIG,
-		(amd_config->flags & AMD_BAD_FIFO) ? (t & 0x0f) : (t | 0xf0));
-
-/*
- * Take care of incorrectly wired Serenade mainboards.
- */
-
-	if ((amd_config->flags & AMD_CHECK_SERENADE) &&
-		dev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
-		dev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
-			amd_config->udma_mask = ATA_UDMA5;
+	pci_read_config_byte(dev, AMD_IDE_CONFIG + offset, &t);
+	/*
+	 * Check for broken FIFO support.
+	 */
+	if (dev->vendor == PCI_VENDOR_ID_AMD &&
+	    dev->vendor == PCI_DEVICE_ID_AMD_VIPER_7411)
+		t &= 0x0f;
+	else
+		t |= 0xf0;
+	pci_write_config_byte(dev, AMD_IDE_CONFIG + offset, t);
 
 /*
  * Determine the system bus clock.
@@ -225,18 +193,10 @@ static unsigned int __devinit init_chips
 
 	if (amd_clock < 20000 || amd_clock > 50000) {
 		printk(KERN_WARNING "%s: User given PCI clock speed impossible (%d), using 33 MHz instead.\n",
-			amd_chipset->name, amd_clock);
+				    name, amd_clock);
 		amd_clock = 33333;
 	}
 
-/*
- * Print the boot message.
- */
-
-	printk(KERN_INFO "%s: %s (rev %02x) UDMA%s controller\n",
-		amd_chipset->name, pci_name(dev), dev->revision,
-		amd_dma[fls(amd_config->udma_mask) - 1]);
-
 	return dev->irq;
 }
 
@@ -251,10 +211,6 @@ static void __devinit init_hwif_amd74xx(
 	if (!hwif->dma_base)
 		return;
 
-	hwif->ultra_mask = amd_config->udma_mask;
-	if (amd_config->flags & AMD_BAD_SWDMA)
-		hwif->swdma_mask = 0x00;
-
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
 		if ((amd_80w >> hwif->channel) & 1)
 			hwif->cbl = ATA_CBL_PATA80;
@@ -272,7 +228,7 @@ static void __devinit init_hwif_amd74xx(
 	 IDE_HFLAG_UNMASK_IRQS | \
 	 IDE_HFLAG_BOOTABLE)
 
-#define DECLARE_AMD_DEV(name_str)					\
+#define DECLARE_AMD_DEV(name_str, swdma, udma)				\
 	{								\
 		.name		= name_str,				\
 		.init_chipset	= init_chipset_amd74xx,			\
@@ -280,11 +236,12 @@ static void __devinit init_hwif_amd74xx(
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
 		.host_flags	= IDE_HFLAGS_AMD,			\
 		.pio_mask	= ATA_PIO5,				\
-		.swdma_mask	= ATA_SWDMA2,				\
+		.swdma_mask	= swdma,				\
 		.mwdma_mask	= ATA_MWDMA2,				\
+		.udma_mask	= udma,					\
 	}
 
-#define DECLARE_NV_DEV(name_str)					\
+#define DECLARE_NV_DEV(name_str, udma)					\
 	{								\
 		.name		= name_str,				\
 		.init_chipset	= init_chipset_amd74xx,			\
@@ -294,45 +251,61 @@ static void __devinit init_hwif_amd74xx(
 		.pio_mask	= ATA_PIO5,				\
 		.swdma_mask	= ATA_SWDMA2,				\
 		.mwdma_mask	= ATA_MWDMA2,				\
+		.udma_mask	= udma,					\
 	}
 
 static const struct ide_port_info amd74xx_chipsets[] __devinitdata = {
-	/*  0 */ DECLARE_AMD_DEV("AMD7401"),
-	/*  1 */ DECLARE_AMD_DEV("AMD7409"),
-	/*  2 */ DECLARE_AMD_DEV("AMD7411"),
-	/*  3 */ DECLARE_AMD_DEV("AMD7441"),
-	/*  4 */ DECLARE_AMD_DEV("AMD8111"),
-
-	/*  5 */ DECLARE_NV_DEV("NFORCE"),
-	/*  6 */ DECLARE_NV_DEV("NFORCE2"),
-	/*  7 */ DECLARE_NV_DEV("NFORCE2-U400R"),
-	/*  8 */ DECLARE_NV_DEV("NFORCE2-U400R-SATA"),
-	/*  9 */ DECLARE_NV_DEV("NFORCE3-150"),
-	/* 10 */ DECLARE_NV_DEV("NFORCE3-250"),
-	/* 11 */ DECLARE_NV_DEV("NFORCE3-250-SATA"),
-	/* 12 */ DECLARE_NV_DEV("NFORCE3-250-SATA2"),
-	/* 13 */ DECLARE_NV_DEV("NFORCE-CK804"),
-	/* 14 */ DECLARE_NV_DEV("NFORCE-MCP04"),
-	/* 15 */ DECLARE_NV_DEV("NFORCE-MCP51"),
-	/* 16 */ DECLARE_NV_DEV("NFORCE-MCP55"),
-	/* 17 */ DECLARE_NV_DEV("NFORCE-MCP61"),
-	/* 18 */ DECLARE_NV_DEV("NFORCE-MCP65"),
-	/* 19 */ DECLARE_NV_DEV("NFORCE-MCP67"),
-	/* 20 */ DECLARE_NV_DEV("NFORCE-MCP73"),
-	/* 21 */ DECLARE_NV_DEV("NFORCE-MCP77"),
-	/* 22 */ DECLARE_AMD_DEV("AMD5536"),
+	/*  0 */ DECLARE_AMD_DEV("AMD7401",	  0x00, ATA_UDMA2),
+	/*  1 */ DECLARE_AMD_DEV("AMD7409", ATA_SWDMA2, ATA_UDMA4),
+	/*  2 */ DECLARE_AMD_DEV("AMD7411", ATA_SWDMA2, ATA_UDMA5),
+	/*  3 */ DECLARE_AMD_DEV("AMD7441", ATA_SWDMA2, ATA_UDMA5),
+	/*  4 */ DECLARE_AMD_DEV("AMD8111", ATA_SWDMA2, ATA_UDMA6),
+
+	/*  5 */ DECLARE_NV_DEV("NFORCE",		ATA_UDMA5),
+	/*  6 */ DECLARE_NV_DEV("NFORCE2",		ATA_UDMA6),
+	/*  7 */ DECLARE_NV_DEV("NFORCE2-U400R",	ATA_UDMA6),
+	/*  8 */ DECLARE_NV_DEV("NFORCE2-U400R-SATA",	ATA_UDMA6),
+	/*  9 */ DECLARE_NV_DEV("NFORCE3-150",		ATA_UDMA6),
+	/* 10 */ DECLARE_NV_DEV("NFORCE3-250",		ATA_UDMA6),
+	/* 11 */ DECLARE_NV_DEV("NFORCE3-250-SATA",	ATA_UDMA6),
+	/* 12 */ DECLARE_NV_DEV("NFORCE3-250-SATA2",	ATA_UDMA6),
+	/* 13 */ DECLARE_NV_DEV("NFORCE-CK804",		ATA_UDMA6),
+	/* 14 */ DECLARE_NV_DEV("NFORCE-MCP04",		ATA_UDMA6),
+	/* 15 */ DECLARE_NV_DEV("NFORCE-MCP51",		ATA_UDMA6),
+	/* 16 */ DECLARE_NV_DEV("NFORCE-MCP55",		ATA_UDMA6),
+	/* 17 */ DECLARE_NV_DEV("NFORCE-MCP61",		ATA_UDMA6),
+	/* 18 */ DECLARE_NV_DEV("NFORCE-MCP65",		ATA_UDMA6),
+	/* 19 */ DECLARE_NV_DEV("NFORCE-MCP67",		ATA_UDMA6),
+	/* 20 */ DECLARE_NV_DEV("NFORCE-MCP73",		ATA_UDMA6),
+	/* 21 */ DECLARE_NV_DEV("NFORCE-MCP77",		ATA_UDMA6),
+
+	/* 22 */ DECLARE_AMD_DEV("AMD5536", ATA_SWDMA2, ATA_UDMA5),
 };
 
 static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	amd_chipset = amd74xx_chipsets + id->driver_data;
-	amd_config = amd_ide_chips + id->driver_data;
-	if (dev->device != amd_config->id) {
-		printk(KERN_ERR "%s: assertion 0x%02x == 0x%02x failed !\n",
-		       pci_name(dev), dev->device, amd_config->id);
-		return -ENODEV;
+	struct ide_port_info d;
+	u8 idx = id->driver_data;
+
+	d = amd74xx_chipsets[idx];
+
+	/*
+	 * Check for bad SWDMA and incorrectly wired Serenade mainboards.
+	 */
+	if (idx == 1) {
+		if (dev->revision <= 7)
+			d.swdma_mask = 0;
+	} else if (idx == 4) {
+		if (dev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
+		    dev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
+			d.udma_mask = ATA_UDMA5;
 	}
-	return ide_setup_pci_device(dev, amd_chipset);
+
+	printk(KERN_INFO "%s: %s (rev %02x) UDMA%s controller\n",
+			 d.name, pci_name(dev), dev->revision,
+			 amd_dma[fls(d.udma_mask) - 1]);
+
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id amd74xx_pci_tbl[] = {
