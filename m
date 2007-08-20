Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbXHTUu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbXHTUu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXHTUuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:50:46 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:1834 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXHTUum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=S0aVeCY/WJPVAUniaSv5s1u/poF7aLGl/gBul3Yfrgw/cbTOXSjwgYEOwRvPe6uvwoTooCLbKc60DhkEXJQ36JtMcbc1/kDxsLq34Xjj+S5k2+qNtiuulovenk6Aik6g2rxb+bIh7n0bCdiTRrZQKsk/6jW0sKMLzySiBNpxe1c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Mon, 20 Aug 2007 22:49:35 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708202249.35120.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/cris/arch-v10/drivers/Kconfig |    1 +
 arch/cris/arch-v32/drivers/Kconfig |    1 +
 drivers/ide/Kconfig                |   12 ++++++++-
 drivers/ide/cris/ide-cris.c        |    2 +
 drivers/ide/ide-disk.c             |   18 ++++++++++++++
 drivers/ide/ide-dma.c              |   45 ++++++++----------------------------
 drivers/ide/ide-iops.c             |   45 ++++++++++++++++++++++++++++++++----
 drivers/ide/pci/cs5530.c           |    8 +++++-
 drivers/ide/pci/hpt34x.c           |    6 +---
 drivers/ide/pci/ns87415.c          |    9 -------
 drivers/ide/pci/pdc202xx_new.c     |   10 ++++++-
 drivers/ide/pci/pdc202xx_old.c     |    9 ++++--
 drivers/ide/pci/triflex.c          |    3 ++
 drivers/ide/ppc/pmac.c             |   14 ++--------
 include/linux/ide.h                |    4 +-
 15 files changed, 113 insertions(+), 74 deletions(-)


Bartlomiej Zolnierkiewicz (12):
      ide: fix hidden dependencies on CONFIG_IDE_GENERIC
      ide-cris: fix ->set_pio_mode method to set transfer mode on the device
      ide: config_drive_for_dma() fixes
      ide-pmac: fix drive->init_speed reporting
      ide: add cable detection for early UDMA66 devices (take 3)
      ide: ide_config_drive_speed() bugfixes
      cs5530: add missing ->dma_base check
      pdc202xx_new: add missing ->dma_base check
      pdc202xx_old: add missing ->dma_base check
      triflex: add missing ->dma_base check
      hpt34x: fix CONFIG_HPT34X_AUTODMA=n handling
      ide-disk: workaround for buggy HPA support on ST340823A (take 3)

Tejun Heo (1):
      ide: make CONFIG_IDE_GENERIC default to N


diff --git a/arch/cris/arch-v10/drivers/Kconfig b/arch/cris/arch-v10/drivers/Kconfig
index e7e724b..03e2e68 100644
--- a/arch/cris/arch-v10/drivers/Kconfig
+++ b/arch/cris/arch-v10/drivers/Kconfig
@@ -548,6 +548,7 @@ config ETRAX_IDE
 	select BLK_DEV_IDEDISK
 	select BLK_DEV_IDECD
 	select BLK_DEV_IDEDMA
+	select IDE_GENERIC
 	help
 	  Enable this to get support for ATA/IDE.
 	  You can't use parallel ports or SCSI ports
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 1d859c1..cc6ba54 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -592,6 +592,7 @@ config ETRAX_IDE
 	select BLK_DEV_IDEDISK
 	select BLK_DEV_IDECD
 	select BLK_DEV_IDEDMA
+	select IDE_GENERIC
 	help
 	  Enables the ETRAX IDE driver.
 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index e049f65..7adb61b 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -304,9 +304,9 @@ comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
 	tristate "generic/default IDE chipset support"
-	default y
+	default H8300
 	help
-	  If unsure, say Y.
+	  If unsure, say N.
 
 config BLK_DEV_CMD640
 	bool "CMD640 chipset bugfix/support"
@@ -345,6 +345,7 @@ config BLK_DEV_CMD640_ENHANCED
 config BLK_DEV_IDEPNP
 	bool "PNP EIDE support"
 	depends on PNP
+	select IDE_GENERIC
 	help
 	  If you have a PnP (Plug and Play) compatible EIDE card and
 	  would like the kernel to automatically detect and activate
@@ -834,6 +835,7 @@ config BLK_DEV_IDE_AU1XXX_SEQTS_PER_RQ
 
 config IDE_ARM
 	def_bool ARM && (ARCH_CLPS7500 || ARCH_RPC || ARCH_SHARK)
+	select IDE_GENERIC
 
 config BLK_DEV_IDE_ICSIDE
 	tristate "ICS IDE interface support"
@@ -867,6 +869,7 @@ config BLK_DEV_IDE_BAST
 config BLK_DEV_GAYLE
 	bool "Amiga Gayle IDE interface support"
 	depends on AMIGA
+	select IDE_GENERIC
 	help
 	  This is the IDE driver for the Amiga Gayle IDE interface. It supports
 	  both the `A1200 style' and `A4000 style' of the Gayle IDE interface,
@@ -898,6 +901,7 @@ config BLK_DEV_IDEDOUBLER
 config BLK_DEV_BUDDHA
 	bool "Buddha/Catweasel/X-Surf IDE interface support (EXPERIMENTAL)"
 	depends on ZORRO && EXPERIMENTAL
+	select IDE_GENERIC
 	help
 	  This is the IDE driver for the IDE interfaces on the Buddha, 
 	  Catweasel and X-Surf expansion boards.  It supports up to two interfaces 
@@ -910,6 +914,7 @@ config BLK_DEV_BUDDHA
 config BLK_DEV_FALCON_IDE
 	bool "Falcon IDE interface support"
 	depends on ATARI
+	select IDE_GENERIC
 	help
 	  This is the IDE driver for the builtin IDE interface on the Atari
 	  Falcon. Say Y if you have a Falcon and want to use IDE devices (hard
@@ -919,6 +924,7 @@ config BLK_DEV_FALCON_IDE
 config BLK_DEV_MAC_IDE
 	bool "Macintosh Quadra/Powerbook IDE interface support"
 	depends on MAC
+	select IDE_GENERIC
 	help
 	  This is the IDE driver for the builtin IDE interface on some m68k
 	  Macintosh models. It supports both the `Quadra style' (used in
@@ -932,6 +938,7 @@ config BLK_DEV_MAC_IDE
 config BLK_DEV_Q40IDE
 	bool "Q40/Q60 IDE interface support"
 	depends on Q40
+	select IDE_GENERIC
 	help
 	  Enable the on-board IDE controller in the Q40/Q60.  This should
 	  normally be on; disable it only if you are running a custom hard
@@ -940,6 +947,7 @@ config BLK_DEV_Q40IDE
 config BLK_DEV_MPC8xx_IDE
 	bool "MPC8xx IDE support"
 	depends on 8xx && IDE=y && BLK_DEV_IDE=y
+	select IDE_GENERIC
 	help
 	  This option provides support for IDE on Motorola MPC8xx Systems.
 	  Please see 'Type of MPC8xx IDE interface' for details.
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index fbfea46..04636f7 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -718,6 +718,8 @@ static void tune_cris_ide(ide_drive_t *drive, u8 pio)
 	}
 
 	cris_ide_set_speed(TYPE_PIO, setup, strobe, hold);
+
+	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 static int speed_cris_ide(ide_drive_t *drive, u8 speed)
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 5ce4216..eba1adb 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -481,6 +481,15 @@ static inline int idedisk_supports_lba48(const struct hd_driveid *id)
 	       && id->lba_capacity_2;
 }
 
+/*
+ * Some disks report total number of sectors instead of
+ * maximum sector address.  We list them here.
+ */
+static const struct drive_list_entry hpa_list[] = {
+	{ "ST340823A",	NULL },
+	{ NULL,		NULL }
+};
+
 static void idedisk_check_hpa(ide_drive_t *drive)
 {
 	unsigned long long capacity, set_max;
@@ -492,6 +501,15 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 	else
 		set_max = idedisk_read_native_max_address(drive);
 
+	if (ide_in_drive_list(drive->id, hpa_list)) {
+		/*
+		 * Since we are inclusive wrt to firmware revisions do this
+		 * extra check and apply the workaround only when needed.
+		 */
+		if (set_max == capacity + 1)
+			set_max--;
+	}
+
 	if (set_max <= capacity)
 		return;
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 5fe1d72..ff644a5 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -135,25 +135,6 @@ static const struct drive_list_entry drive_blacklist [] = {
 };
 
 /**
- *	ide_in_drive_list	-	look for drive in black/white list
- *	@id: drive identifier
- *	@drive_table: list to inspect
- *
- *	Look for a drive in the blacklist and the whitelist tables
- *	Returns 1 if the drive is found in the table.
- */
-
-int ide_in_drive_list(struct hd_driveid *id, const struct drive_list_entry *drive_table)
-{
-	for ( ; drive_table->id_model ; drive_table++)
-		if ((!strcmp(drive_table->id_model, id->model)) &&
-		    (!drive_table->id_firmware ||
-		     strstr(id->fw_rev, drive_table->id_firmware)))
-			return 1;
-	return 0;
-}
-
-/**
  *	ide_dma_intr	-	IDE DMA interrupt handler
  *	@drive: the drive the interrupt is for
  *
@@ -349,9 +330,17 @@ EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
  
 static int config_drive_for_dma (ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
 
-	if ((id->capability & 1) && drive->hwif->autodma) {
+	/* consult the list of known "bad" drives */
+	if (__ide_dma_bad_drive(drive))
+		return -1;
+
+	if (drive->media != ide_disk && hwif->atapi_dma == 0)
+		return -1;
+
+	if ((id->capability & 1) && drive->autodma) {
 		/*
 		 * Enable DMA on any drive that has
 		 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
@@ -514,20 +503,6 @@ int __ide_dma_on (ide_drive_t *drive)
 EXPORT_SYMBOL(__ide_dma_on);
 
 /**
- *	__ide_dma_check		-	check DMA setup
- *	@drive: drive to check
- *
- *	Don't use - due for extermination
- */
- 
-int __ide_dma_check (ide_drive_t *drive)
-{
-	return config_drive_for_dma(drive);
-}
-
-EXPORT_SYMBOL(__ide_dma_check);
-
-/**
  *	ide_dma_setup	-	begin a DMA phase
  *	@drive: target device
  *
@@ -1021,7 +996,7 @@ void ide_setup_dma (ide_hwif_t *hwif, unsigned long dma_base, unsigned int num_p
 	if (!hwif->dma_host_on)
 		hwif->dma_host_on = &ide_dma_host_on;
 	if (!hwif->ide_dma_check)
-		hwif->ide_dma_check = &__ide_dma_check;
+		hwif->ide_dma_check = &config_drive_for_dma;
 	if (!hwif->dma_setup)
 		hwif->dma_setup = &ide_dma_setup;
 	if (!hwif->dma_exec_cmd)
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 92578b6..f4cd270 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -565,6 +565,36 @@ int ide_wait_stat (ide_startstop_t *startstop, ide_drive_t *drive, u8 good, u8 b
 
 EXPORT_SYMBOL(ide_wait_stat);
 
+/**
+ *	ide_in_drive_list	-	look for drive in black/white list
+ *	@id: drive identifier
+ *	@drive_table: list to inspect
+ *
+ *	Look for a drive in the blacklist and the whitelist tables
+ *	Returns 1 if the drive is found in the table.
+ */
+
+int ide_in_drive_list(struct hd_driveid *id, const struct drive_list_entry *drive_table)
+{
+	for ( ; drive_table->id_model; drive_table++)
+		if ((!strcmp(drive_table->id_model, id->model)) &&
+		    (!drive_table->id_firmware ||
+		     strstr(id->fw_rev, drive_table->id_firmware)))
+			return 1;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ide_in_drive_list);
+
+/*
+ * Early UDMA66 devices don't set bit14 to 1, only bit13 is valid.
+ * We list them here and depend on the device side cable detection for them.
+ */
+static const struct drive_list_entry ivb_list[] = {
+	{ "QUANTUM FIREBALLlct10 05"	, "A03.0900"	},
+	{ NULL				, NULL		}
+};
+
 /*
  *  All hosts that use the 80c ribbon must use!
  *  The name is derived from upper byte of word 93 and the 80c ribbon.
@@ -573,11 +603,16 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct hd_driveid *id = drive->id;
+	int ivb = ide_in_drive_list(id, ivb_list);
 
 	if (hwif->cbl == ATA_CBL_PATA40_SHORT)
 		return 1;
 
-	if (hwif->cbl != ATA_CBL_PATA80)
+	if (ivb)
+		printk(KERN_DEBUG "%s: skipping word 93 validity check\n",
+				  drive->name);
+
+	if (hwif->cbl != ATA_CBL_PATA80 && !ivb)
 		goto no_80w;
 
 	/* Check for SATA but only if we are ATA5 or higher */
@@ -587,11 +622,11 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 	/*
 	 * FIXME:
 	 * - change master/slave IDENTIFY order
-	 * - force bit13 (80c cable present) check
+	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
 #ifndef CONFIG_IDEDMA_IVB
-	if (id->hw_config & 0x4000)
+	if ((id->hw_config & 0x4000) || (ivb && (id->hw_config & 0x2000)))
 #else
 	if (id->hw_config & 0x6000)
 #endif
@@ -795,7 +830,7 @@ int ide_config_drive_speed (ide_drive_t *drive, u8 speed)
 		hwif->OUTB(drive->ctl | 2, IDE_CONTROL_REG);
 	hwif->OUTB(speed, IDE_NSECTOR_REG);
 	hwif->OUTB(SETFEATURES_XFER, IDE_FEATURE_REG);
-	hwif->OUTB(WIN_SETFEATURES, IDE_COMMAND_REG);
+	hwif->OUTBSYNC(drive, WIN_SETFEATURES, IDE_COMMAND_REG);
 	if ((IDE_CONTROL_REG) && (drive->quirk_list == 2))
 		hwif->OUTB(drive->ctl, IDE_CONTROL_REG);
 	udelay(1);
@@ -822,7 +857,7 @@ int ide_config_drive_speed (ide_drive_t *drive, u8 speed)
 	 */
 	for (i = 0; i < 10; i++) {
 		udelay(1);
-		if (OK_STAT((stat = hwif->INB(IDE_STATUS_REG)), DRIVE_READY, BUSY_STAT|DRQ_STAT|ERR_STAT)) {
+		if (OK_STAT((stat = hwif->INB(IDE_STATUS_REG)), drive->ready_stat, BUSY_STAT|DRQ_STAT|ERR_STAT)) {
 			error = 0;
 			break;
 		}
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index acaf71f..e5949b1 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cs5530.c		Version 0.73	Mar 10 2007
+ * linux/drivers/ide/pci/cs5530.c		Version 0.74	Jul 28 2007
  *
  * Copyright (C) 2000			Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2000			Mark Lord <mlord@pobox.com>
@@ -207,6 +207,9 @@ static unsigned int __devinit init_chipset_cs5530 (struct pci_dev *dev, const ch
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL;
 	unsigned long flags;
 
+	if (pci_resource_start(dev, 4) == 0)
+		return -EFAULT;
+
 	dev = NULL;
 	while ((dev = pci_get_device(PCI_VENDOR_ID_CYRIX, PCI_ANY_ID, dev)) != NULL) {
 		switch (dev->device) {
@@ -325,6 +328,9 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 			/* needs autotuning later */
 	}
 
+	if (hwif->dma_base == 0)
+		return;
+
 	hwif->atapi_dma = 1;
 	hwif->ultra_mask = 0x07;
 	hwif->mwdma_mask = 0x07;
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 19778c5..cb8fe56 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -89,11 +89,7 @@ static int hpt34x_config_drive_xfer_rate (ide_drive_t *drive)
 	drive->init_speed = 0;
 
 	if (ide_tune_dma(drive))
-#ifndef CONFIG_HPT34X_AUTODMA
 		return -1;
-#else
-		return 0;
-#endif
 
 	if (ide_use_fast_pio(drive))
 		hpt34x_tune_drive(drive, 255);
@@ -160,9 +156,11 @@ static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
 	if (!hwif->dma_base)
 		return;
 
+#ifdef CONFIG_HPT34X_AUTODMA
 	hwif->ultra_mask = 0x07;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
+#endif
 
 	hwif->ide_dma_check = &hpt34x_config_drive_xfer_rate;
 	if (!noautodma)
diff --git a/drivers/ide/pci/ns87415.c b/drivers/ide/pci/ns87415.c
index 09941f3..465c935 100644
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -187,14 +187,6 @@ static int ns87415_ide_dma_setup(ide_drive_t *drive)
 	return 1;
 }
 
-static int ns87415_ide_dma_check (ide_drive_t *drive)
-{
-	if (drive->media != ide_disk)
-		return -1;
-
-	return __ide_dma_check(drive);
-}
-
 static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = hwif->pci_dev;
@@ -266,7 +258,6 @@ static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 
 	outb(0x60, hwif->dma_status);
 	hwif->dma_setup = &ns87415_ide_dma_setup;
-	hwif->ide_dma_check = &ns87415_ide_dma_check;
 	hwif->ide_dma_end = &ns87415_ide_dma_end;
 
 	if (!noautodma)
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 8a66a28..f6db2f3 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -378,6 +378,9 @@ static unsigned int __devinit init_chipset_pdcnew(struct pci_dev *dev, const cha
 	int f, r;
 	u8 pll_ctl0, pll_ctl1;
 
+	if (dma_base == 0)
+		return -EFAULT;
+
 #ifdef CONFIG_PPC_PMAC
 	apple_kiwi_init(dev);
 #endif
@@ -494,15 +497,18 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 	hwif->speedproc = &pdcnew_tune_chipset;
 	hwif->resetproc = &pdcnew_reset;
 
+	hwif->err_stops_fifo = 1;
+
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
+	if (hwif->dma_base == 0)
+		return;
+
 	hwif->atapi_dma  = 1;
 
 	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 
-	hwif->err_stops_fifo = 1;
-
 	hwif->ide_dma_check = &pdcnew_config_drive_xfer_rate;
 
 	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index fbcb0bb..e19a891 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/pdc202xx_old.c	Version 0.50	Mar 3, 2007
+ *  linux/drivers/ide/pci/pdc202xx_old.c	Version 0.51	Jul 27, 2007
  *
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007		MontaVista Software, Inc.
@@ -337,15 +337,18 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 
 	hwif->speedproc = &pdc202xx_tune_chipset;
 
+	hwif->err_stops_fifo = 1;
+
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
+	if (hwif->dma_base == 0)
+		return;
+
 	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 	hwif->atapi_dma = 1;
 
-	hwif->err_stops_fifo = 1;
-
 	hwif->ide_dma_check = &pdc202xx_config_drive_xfer_rate;
 	hwif->dma_lost_irq = &pdc202xx_dma_lost_irq;
 	hwif->dma_timeout = &pdc202xx_dma_timeout;
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 024bbfa..098692a 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -115,6 +115,9 @@ static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
 	hwif->tuneproc = &triflex_tune_drive;
 	hwif->speedproc = &triflex_tune_chipset;
 
+	if (hwif->dma_base == 0)
+		return;
+
 	hwif->atapi_dma  = 1;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 33630ad..4b13cd9 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -604,6 +604,9 @@ out:
 				drive->id->dma_1word |= 0x0101; break;
 			default: break;
 		}
+		if (!drive->init_speed)
+			drive->init_speed = command;
+		drive->current_speed = command;
 	}
 	enable_irq(hwif->irq);
 	return result;
@@ -986,7 +989,6 @@ pmac_ide_tune_chipset (ide_drive_t *drive, byte speed)
 		return ret;
 		
 	pmac_ide_do_update_timings(drive);	
-	drive->current_speed = speed;
 
 	return 0;
 }
@@ -1737,11 +1739,6 @@ pmac_ide_mdma_enable(ide_drive_t *drive, u16 mode)
 	/* Apply timings to controller */
 	*timings = timing_local[0];
 	*timings2 = timing_local[1];
-	
-	/* Set speed info in drive */
-	drive->current_speed = mode;	
-	if (!drive->init_speed)
-		drive->init_speed = mode;
 
 	return 1;
 }
@@ -1793,11 +1790,6 @@ pmac_ide_udma_enable(ide_drive_t *drive, u16 mode)
 	*timings = timing_local[0];
 	*timings2 = timing_local[1];
 
-	/* Set speed info in drive */
-	drive->current_speed = mode;	
-	if (!drive->init_speed)
-		drive->init_speed = mode;
-
 	return 1;
 }
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index d71d012..c792b4f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1285,13 +1285,14 @@ void ide_init_sg_cmd(ide_drive_t *, struct request *);
 #define BAD_DMA_DRIVE		0
 #define GOOD_DMA_DRIVE		1
 
-#ifdef CONFIG_BLK_DEV_IDEDMA
 struct drive_list_entry {
 	const char *id_model;
 	const char *id_firmware;
 };
 
 int ide_in_drive_list(struct hd_driveid *, const struct drive_list_entry *);
+
+#ifdef CONFIG_BLK_DEV_IDEDMA
 int __ide_dma_bad_drive(ide_drive_t *);
 int __ide_dma_good_drive(ide_drive_t *);
 u8 ide_max_dma_mode(ide_drive_t *);
@@ -1312,7 +1313,6 @@ void ide_dma_host_off(ide_drive_t *);
 void ide_dma_off_quietly(ide_drive_t *);
 void ide_dma_host_on(ide_drive_t *);
 extern int __ide_dma_on(ide_drive_t *);
-extern int __ide_dma_check(ide_drive_t *);
 extern int ide_dma_setup(ide_drive_t *);
 extern void ide_dma_start(ide_drive_t *);
 extern int __ide_dma_end(ide_drive_t *);
