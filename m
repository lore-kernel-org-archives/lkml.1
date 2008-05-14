Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYENVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYENVFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYENVFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:05:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:45124 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYENVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=n91oJQNwqoJUlMiJPbyOrOX1lMuGTcjFFqT4P4f3b/VFkZVxX4vTasKJj49fa73hm7bcjHK5u9abDqYTVHXu5ZIkVG2nL4q/H+JKQJzb+gVHlDms5PfvoiR08liha4Ux74kPH6ewMf0OmO/xUbZCfkUCnUW8cH/VU36vcCMaY9k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 14 May 2008 23:18:54 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805142318.55261.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- disable Virtual DMA support in CS5520 host driver for now (it causes
  weird system lockups, thanks to TAKADA Yoshihito for reporting the issue)

- fix up SWARM IDE for recent IDE core changes (Maciej W. Rozycki)

- few obvious/trivial fixes for ALiM15x3 host driver

- couple of obvious ide/Kconfig fixes

- some code can be static now (Adrian Bunk)


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig        |   54 +++++++++-----------------------------------
 drivers/ide/ide-iops.c     |    2 +-
 drivers/ide/mips/swarm.c   |   16 +++++++-----
 drivers/ide/pci/alim15x3.c |   42 ++++++++++-----------------------
 drivers/ide/pci/cs5520.c   |    2 +-
 include/linux/ide.h        |    9 +++----
 6 files changed, 39 insertions(+), 86 deletions(-)


Adrian Bunk (1):
      make ide-iops.c:SELECT_MASK() static

Bartlomiej Zolnierkiewicz (6):
      alim15x3: trivial cleanup for ali_set_pio_mode()
      alim15x3: remove stale warning about ATI RS100 northbridge
      alim15x3: add "wdc_udma" module parameter
      alim15x3: remove WDC_ALI15X3 config option
      ide/Kconfig: couple of fixes
      cs5520: disable VDMA

Maciej W. Rozycki (1):
      SWARM IDE: Fix up following changes to ide_hwif_t


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index f702f91..b4f3aef 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1,8 +1,6 @@
 #
 # IDE ATA ATAPI Block device driver configuration
 #
-# Andre Hedrick <andre@linux-ide.org>
-#
 
 # Select HAVE_IDE if IDE is supported
 config HAVE_IDE
@@ -335,7 +333,7 @@ config BLK_DEV_CMD640
 	  This driver will work automatically in PCI based systems (most new
 	  systems have PCI slots). But if your system uses VESA local bus
 	  (VLB) instead of PCI, you must also supply a kernel boot parameter
-	  to enable the CMD640 bugfix/support: "ide0=cmd640_vlb". (Try "man
+	  to enable the CMD640 bugfix/support: "cmd640.probe_vlb". (Try "man
 	  bootparam" or see the documentation of your boot loader about how to
 	  pass options to the kernel.)
 
@@ -457,27 +455,11 @@ config BLK_DEV_ALI15X3
 	  onboard chipsets.  It also tests for Simplex mode and enables
 	  normal dual channel support.
 
-	  If you say Y here, you also need to say Y to "Use DMA by default
-	  when available", above.  Please read the comments at the top of
+	  Please read the comments at the top of
 	  <file:drivers/ide/pci/alim15x3.c>.
 
 	  If unsure, say N.
 
-config WDC_ALI15X3
-	bool "ALI M15x3 WDC support (DANGEROUS)"
-	depends on BLK_DEV_ALI15X3
-	---help---
-	  This allows for UltraDMA support for WDC drives that ignore CRC
-	  checking. You are a fool for enabling this option, but there have
-	  been requests. DO NOT COMPLAIN IF YOUR DRIVE HAS FS CORRUPTION, IF
-	  YOU ENABLE THIS! No one will listen, just laugh for ignoring this
-	  SERIOUS WARNING.
-
-	  Using this option can allow WDC drives to run at ATA-4/5 transfer
-	  rates with only an ATA-2 support structure.
-
-	  SAY N!
-
 config BLK_DEV_AMD74XX
 	tristate "AMD and nVidia IDE support"
 	depends on !ARM
@@ -520,9 +502,6 @@ config BLK_DEV_CY82C693
 	  This driver adds detection and support for the CY82C693 chipset
 	  used on Digital's PC-Alpha 164SX boards.
 
-	  If you say Y here, you need to say Y to "Use DMA by default
-	  when available" as well.
-
 config BLK_DEV_CS5520
 	tristate "Cyrix CS5510/20 MediaGX chipset support (VERY EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -613,13 +592,12 @@ config BLK_DEV_SC1200
 	  National SCx200 series of embedded x86 "Geode" systems.
 
 config BLK_DEV_PIIX
-	tristate "Intel PIIXn chipsets support"
+	tristate "Intel PIIX/ICH chipsets support"
 	select BLK_DEV_IDEDMA_PCI
 	help
-	  This driver adds explicit support for Intel PIIX and ICH chips
-	  and also for the Efar Victory66 (slc90e66) chip.  This allows
-	  the kernel to change PIO, DMA and UDMA speeds and to configure
-	  the chip to optimum performance.
+	  This driver adds explicit support for Intel PIIX and ICH chips.
+	  This allows the kernel to change PIO, DMA and UDMA speeds and to
+	  configure the chip to optimum performance.
 
 config BLK_DEV_IT8213
 	tristate "IT8213 IDE support"
@@ -657,11 +635,7 @@ config BLK_DEV_PDC202XX_OLD
 	  happen if the BIOS revisions of all installed cards (three-max) do
 	  not match, the driver attempts to do dynamic tuning of the chipset
 	  at boot-time for max-speed.  Ultra33 BIOS 1.25 or newer is required
-	  for more than one card. This card may require that you say Y to
-	  "Special UDMA Feature".
-
-	  If you say Y here, you need to say Y to "Use DMA by default when
-	  available" as well.
+	  for more than one card.
 
 	  Please read the comments at the top of
 	  <file:drivers/ide/pci/pdc202xx_old.c>.
@@ -710,9 +684,6 @@ config BLK_DEV_SIS5513
 	  ATA100: SiS635, SiS645, SiS650, SiS730, SiS735, SiS740,
 	  SiS745, SiS750
 
-	  If you say Y here, you need to say Y to "Use DMA by default when
-	  available" as well.
-
 	  Please read the comments at the top of <file:drivers/ide/pci/sis5513.c>.
 
 config BLK_DEV_SL82C105
@@ -734,9 +705,6 @@ config BLK_DEV_SLC90E66
 	  and it will handle timing cycles.  Since this is an improved
 	  look-a-like to the PIIX4 it should be a nice addition.
 
-	  If you say Y here, you need to say Y to "Use DMA by default when
-	  available" as well.
-
 	  Please read the comments at the top of
 	  <file:drivers/ide/pci/slc90e66.c>.
 
@@ -888,17 +856,17 @@ config BLK_DEV_IDEDOUBLER
 	bool "Amiga IDE Doubler support (EXPERIMENTAL)"
 	depends on BLK_DEV_GAYLE && EXPERIMENTAL
 	---help---
-	  This driver provides support for the so-called `IDE doublers' (made
+	  This feature provides support for the so-called `IDE doublers' (made
 	  by various manufacturers, e.g. Eyetech) that can be connected to
 	  the on-board IDE interface of some Amiga models. Using such an IDE
 	  doubler, you can connect up to four instead of two IDE devices to
 	  the Amiga's on-board IDE interface.
 
 	  Note that the normal Amiga Gayle IDE driver may not work correctly
-	  if you have an IDE doubler and don't enable this driver!
+	  if you have an IDE doubler and don't enable this feature!
 
-	  Say Y if you have an IDE doubler.  The driver is enabled at kernel
-	  runtime using the "ide=doubler" kernel boot parameter.
+	  Say Y if you have an IDE doubler.  The feature is enabled at kernel
+	  runtime using the "gayle.doubler" kernel boot parameter.
 
 config BLK_DEV_BUDDHA
 	tristate "Buddha/Catweasel/X-Surf IDE interface support (EXPERIMENTAL)"
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 57d9a9a..0daf923 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -95,7 +95,7 @@ void SELECT_DRIVE (ide_drive_t *drive)
 	hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
 }
 
-void SELECT_MASK (ide_drive_t *drive, int mask)
+static void SELECT_MASK(ide_drive_t *drive, int mask)
 {
 	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
 
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index 712d17b..52fee3d 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -4,7 +4,7 @@
  *	Author:	Manish Lachwani, mlachwani@mvista.com
  * Copyright (C) 2004  MIPS Technologies, Inc.  All rights reserved.
  *	Author: Maciej W. Rozycki <macro@mips.com>
- * Copyright (c) 2006  Maciej W. Rozycki
+ * Copyright (c) 2006, 2008  Maciej W. Rozycki
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -70,8 +70,9 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	ide_hwif_t *hwif;
 	u8 __iomem *base;
 	phys_t offset, size;
+	hw_regs_t hw;
 	int i;
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	u8 idx[] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (!SIBYTE_HAVE_IDE)
 		return -ENODEV;
@@ -112,14 +113,15 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	hwif->host_flags = IDE_HFLAG_MMIO;
 	default_hwif_mmiops(hwif);
 
-	hwif->chipset = ide_generic;
-
 	for (i = 0; i <= 7; i++)
-		hwif->io_ports_array[i] =
+		hw.io_ports_array[i] =
 				(unsigned long)(base + ((0x1f0 + i) << 5));
-	hwif->io_ports.ctl_addr =
+	hw.io_ports.ctl_addr =
 				(unsigned long)(base + (0x3f6 << 5));
-	hwif->irq = K_INT_GB_IDE;
+	hw.irq = K_INT_GB_IDE;
+	hw.chipset = ide_generic;
+
+	ide_init_port_hw(hwif, &hw);
 
 	idx[0] = hwif->index;
 
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index c1922f9..f2129d5 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -39,6 +39,16 @@
 #include <asm/io.h>
 
 /*
+ * Allow UDMA on M1543C-E chipset for WDC disks that ignore CRC checking
+ * (this is DANGEROUS and could result in data corruption).
+ */
+static int wdc_udma;
+
+module_param(wdc_udma, bool, 0);
+MODULE_PARM_DESC(wdc_udma,
+		 "allow UDMA on M1543C-E chipset for WDC disks (DANGEROUS)");
+
+/*
  *	ALi devices are not plug in. Otherwise these static values would
  *	need to go. They ought to go away anyway
  */
@@ -76,11 +86,6 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		a_clc = 0;
 	c_time = ide_pio_timings[pio].cycle_time;
 
-#if 0
-	if ((r_clc = ((c_time - s_time - a_time) * bus_speed + 999) / 1000) >= 16)
-		r_clc = 0;
-#endif
-
 	if (!(r_clc = (c_time * bus_speed + 999) / 1000 - a_clc - s_clc)) {
 		r_clc = 1;
 	} else {
@@ -110,16 +115,6 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	pci_write_config_byte(dev, port, s_clc);
 	pci_write_config_byte(dev, port+drive->select.b.unit+2, (a_clc << 4) | r_clc);
 	local_irq_restore(flags);
-
-	/*
-	 * setup   active  rec
-	 * { 70,   165,    365 },   PIO Mode 0
-	 * { 50,   125,    208 },   PIO Mode 1
-	 * { 30,   100,    110 },   PIO Mode 2
-	 * { 30,   80,     70  },   PIO Mode 3 with IORDY
-	 * { 25,   70,     25  },   PIO Mode 4 with IORDY  ns
-	 * { 20,   50,     30  }    PIO Mode 5 with IORDY (nonstandard)
-	 */
 }
 
 /**
@@ -131,9 +126,7 @@ static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
  *	The actual rules for the ALi are:
  *		No UDMA on revisions <= 0x20
  *		Disk only for revisions < 0xC2
- *		Not WDC drives for revisions < 0xC2
- *
- *	FIXME: WDC ifdef needs to die
+ *		Not WDC drives on M1543C-E (?)
  */
 
 static u8 ali_udma_filter(ide_drive_t *drive)
@@ -141,10 +134,9 @@ static u8 ali_udma_filter(ide_drive_t *drive)
 	if (m5229_revision > 0x20 && m5229_revision < 0xC2) {
 		if (drive->media != ide_disk)
 			return 0;
-#ifndef CONFIG_WDC_ALI15X3
-		if (chip_is_1543c_e && strstr(drive->id->model, "WDC "))
+		if (chip_is_1543c_e && strstr(drive->id->model, "WDC ") &&
+		    wdc_udma == 0)
 			return 0;
-#endif
 	}
 
 	return drive->hwif->ultra_mask;
@@ -537,17 +529,9 @@ static const struct ide_port_info ali15x3_chipset __devinitdata = {
  
 static int __devinit alim15x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct pci_device_id ati_rs100[] = {
-		{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS100) },
-		{ },
-	};
-
 	struct ide_port_info d = ali15x3_chipset;
 	u8 rev = dev->revision, idx = id->driver_data;
 
-	if (pci_dev_present(ati_rs100))
-		printk(KERN_WARNING "alim15x3: ATI Radeon IGP Northbridge is not yet fully tested.\n");
-
 	/* don't use LBA48 DMA on ALi devices before rev 0xC5 */
 	if (rev <= 0xC4)
 		d.host_flags |= IDE_HFLAG_NO_LBA48_DMA;
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 17669a4..992b1cf 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -119,6 +119,7 @@ static const struct ide_dma_ops cs5520_dma_ops = {
 	.dma_timeout		= ide_dma_timeout,
 };
 
+/* FIXME: VDMA is disabled because it caused system hangs */
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
@@ -126,7 +127,6 @@ static const struct ide_dma_ops cs5520_dma_ops = {
 		.dma_ops	= &cs5520_dma_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
 				  IDE_HFLAG_CS5520 |		\
-				  IDE_HFLAG_VDMA |		\
 				  IDE_HFLAG_NO_ATAPI_DMA |	\
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE, \
 		.pio_mask	= ATA_PIO4,			\
diff --git a/include/linux/ide.h b/include/linux/ide.h
index b0135b0..f8f195c 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -965,7 +965,6 @@ typedef struct ide_task_s {
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
 extern void SELECT_DRIVE(ide_drive_t *);
-extern void SELECT_MASK(ide_drive_t *, int);
 
 extern int drive_is_ready(ide_drive_t *);
 
@@ -1058,8 +1057,8 @@ enum {
 	IDE_HFLAG_NO_SET_MODE		= (1 << 9),
 	/* trust BIOS for programming chipset/device for DMA */
 	IDE_HFLAG_TRUST_BIOS_FOR_DMA	= (1 << 10),
-	/* host uses VDMA (tied with IDE_HFLAG_CS5520 for now) */
-	IDE_HFLAG_VDMA			= (1 << 11),
+	/* host is CS5510/CS5520 */
+	IDE_HFLAG_CS5520		= (1 << 11),
 	/* ATAPI DMA is unsupported */
 	IDE_HFLAG_NO_ATAPI_DMA		= (1 << 12),
 	/* set if host is a "non-bootable" controller */
@@ -1070,8 +1069,6 @@ enum {
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
 	/* host uses MMIO */
 	IDE_HFLAG_MMIO			= (1 << 16),
-	/* host is CS5510/CS5520 */
-	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */
 	IDE_HFLAG_NO_LBA48		= (1 << 17),
 	/* no LBA48 DMA */
@@ -1101,6 +1098,8 @@ enum {
 	IDE_HFLAG_NO_IO_32BIT		= (1 << 30),
 	/* never unmask IRQs */
 	IDE_HFLAG_NO_UNMASK_IRQS	= (1 << 31),
+	/* host uses VDMA (disabled for now) */
+	IDE_HFLAG_VDMA			= 0,
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
