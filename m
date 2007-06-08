Return-Path: <linux-kernel-owner+w=401wt.eu-S969134AbXFHNMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969134AbXFHNMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968900AbXFHNJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:09:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:48267 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968540AbXFHNJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=q6orh7CVorfHENpCM3gB5/rjARvvgiTTuwcy0CZho1yHS2a0WI9NEGeDgEqFE0bfeslg5PV5MUmkzEXXe4ARIQBEg/v47NmQ2+OcbDWU2dYXmlVnkKmU0W+fkcfeTkJw6LjjSFtNQZp8T+QkWIKJa24czHs/GfM0tF8s3evk9hg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Fri, 8 Jun 2007 15:20:23 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706081520.23426.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-disk.c        |   12 +++++++++
 drivers/ide/ide-probe.c       |   12 +++++-----
 drivers/ide/ide.c             |    9 ++++++-
 drivers/ide/pci/amd74xx.c     |   12 +++++++--
 drivers/ide/pci/generic.c     |   37 ++++++++++++++++++-----------
 drivers/ide/pci/hpt366.c      |    8 +++---
 drivers/ide/pci/it821x.c      |   34 ++++++++++++++-------------
 drivers/ide/pci/serverworks.c |   51 +++++++++++++++++++++++++---------------
 include/linux/ide.h           |    1 +
 include/linux/pci_ids.h       |    2 +
 10 files changed, 115 insertions(+), 63 deletions(-)


Bartlomiej Zolnierkiewicz (3):
      serverworks: remove crappy code
      serverworks: fix CSB6 tuning logic
      it821x: RAID mode fixes

Jiri Slaby (1):
      ide: generic IDE PCI driver, add another device exception

Lee Trager (1):
      ide: HPA detect from resume

Peer Chen (2):
      Add the PATA controller device ID to pci_ids.h for MCP73/MCP77.
      ide: Add the MCP73/77 support to PATA driver

Sergei Shtylyov (1):
      hpt366: disallow Ultra133 for HPT374


diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7fff773..dc2175c 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -1037,6 +1037,17 @@ static void ide_disk_release(struct kref *kref)
 
 static int ide_disk_probe(ide_drive_t *drive);
 
+/*
+ * On HPA drives the capacity needs to be
+ * reinitilized on resume otherwise the disk
+ * can not be used and a hard reset is required
+ */
+static void ide_disk_resume(ide_drive_t *drive)
+{
+	if (idedisk_supports_hpa(drive->id))
+		init_idedisk_capacity(drive);
+}
+
 static void ide_device_shutdown(ide_drive_t *drive)
 {
 #ifdef	CONFIG_ALPHA
@@ -1071,6 +1082,7 @@ static ide_driver_t idedisk_driver = {
 	},
 	.probe			= ide_disk_probe,
 	.remove			= ide_disk_remove,
+	.resume			= ide_disk_resume,
 	.shutdown		= ide_device_shutdown,
 	.version		= IDEDISK_VERSION,
 	.media			= ide_disk,
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 3cebed7..41bfa4d 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -717,7 +717,7 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
  * This routine only knows how to look for drive units 0 and 1
  * on an interface, so any setting of MAX_DRIVES > 2 won't work here.
  */
-static void probe_hwif(ide_hwif_t *hwif)
+static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 {
 	unsigned int unit;
 	unsigned long flags;
@@ -820,6 +820,9 @@ static void probe_hwif(ide_hwif_t *hwif)
 		return;
 	}
 
+	if (fixup)
+		fixup(hwif);
+
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
@@ -874,10 +877,7 @@ static int hwif_init(ide_hwif_t *hwif);
 
 int probe_hwif_init_with_fixup(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 {
-	probe_hwif(hwif);
-
-	if (fixup)
-		fixup(hwif);
+	probe_hwif(hwif, fixup);
 
 	if (!hwif_init(hwif)) {
 		printk(KERN_INFO "%s: failed to initialize IDE interface\n",
@@ -1404,7 +1404,7 @@ int ideprobe_init (void)
 
 	for (index = 0; index < MAX_HWIFS; ++index)
 		if (probe[index])
-			probe_hwif(&ide_hwifs[index]);
+			probe_hwif(&ide_hwifs[index], NULL);
 	for (index = 0; index < MAX_HWIFS; ++index)
 		if (probe[index])
 			hwif_init(&ide_hwifs[index]);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 6002713..0af0d16 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1010,9 +1010,11 @@ static int generic_ide_resume(struct device *dev)
 {
 	ide_drive_t *drive = dev->driver_data;
 	ide_hwif_t *hwif = HWIF(drive);
+	ide_driver_t *drv = to_ide_driver(dev->driver);
 	struct request rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
+	int err;
 
 	/* Call ACPI _STM only once */
 	if (!(drive->dn % 2))
@@ -1029,7 +1031,12 @@ static int generic_ide_resume(struct device *dev)
 	rqpm.pm_step = ide_pm_state_start_resume;
 	rqpm.pm_state = PM_EVENT_ON;
 
-	return ide_do_drive_cmd(drive, &rq, ide_head_wait);
+	err = ide_do_drive_cmd(drive, &rq, ide_head_wait);
+
+	if (err == 0 && drv && drv->resume)
+		drv->resume(drive);
+
+	return err;
 }
 
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index becb1a5..9db1be8 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,5 +1,5 @@
 /*
- * Version 2.13
+ * Version 2.15
  *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
@@ -76,6 +76,8 @@ static struct amd_ide_chip {
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE,	0x50, AMD_UDMA_133 },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE,	0x50, AMD_UDMA_133 },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_AMD_CS5536_IDE,			0x40, AMD_UDMA_100 },
 	{ 0 }
 };
@@ -494,7 +496,9 @@ static ide_pci_device_t amd74xx_chipsets[] __devinitdata = {
 	/* 17 */ DECLARE_NV_DEV("NFORCE-MCP61"),
 	/* 18 */ DECLARE_NV_DEV("NFORCE-MCP65"),
 	/* 19 */ DECLARE_NV_DEV("NFORCE-MCP67"),
-	/* 20 */ DECLARE_AMD_DEV("AMD5536"),
+	/* 20 */ DECLARE_NV_DEV("NFORCE-MCP73"),
+	/* 21 */ DECLARE_NV_DEV("NFORCE-MCP77"),
+	/* 22 */ DECLARE_AMD_DEV("AMD5536"),
 };
 
 static int __devinit amd74xx_probe(struct pci_dev *dev, const struct pci_device_id *id)
@@ -534,7 +538,9 @@ static struct pci_device_id amd74xx_pci_tbl[] = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, 17 },
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 18 },
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 19 },
-	{ PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE,		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 20 },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 20 },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 21 },
+	{ PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE,		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 22 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, amd74xx_pci_tbl);
diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
index f2c5a14..0d51a11 100644
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -198,32 +198,41 @@ static ide_pci_device_t generic_chipsets[] __devinitdata = {
 static int __devinit generic_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	ide_pci_device_t *d = &generic_chipsets[id->driver_data];
-	u16 command;
 	int ret = -ENODEV;
 
 	/* Don't use the generic entry unless instructed to do so */
 	if (id->driver_data == 0 && ide_generic_all == 0)
 			goto out;
 
-	if (dev->vendor == PCI_VENDOR_ID_UMC &&
-	    dev->device == PCI_DEVICE_ID_UMC_UM8886A &&
-	    (!(PCI_FUNC(dev->devfn) & 1)))
-		goto out; /* UM8886A/BF pair */
-
-	if (dev->vendor == PCI_VENDOR_ID_OPTI &&
-	    dev->device == PCI_DEVICE_ID_OPTI_82C558 &&
-	    (!(PCI_FUNC(dev->devfn) & 1)))
-		goto out;
-
-	if (dev->vendor == PCI_VENDOR_ID_JMICRON) {
-		if (dev->device != PCI_DEVICE_ID_JMICRON_JMB368 && PCI_FUNC(dev->devfn) != 1)
+	switch (dev->vendor) {
+	case PCI_VENDOR_ID_UMC:
+		if (dev->device == PCI_DEVICE_ID_UMC_UM8886A &&
+				!(PCI_FUNC(dev->devfn) & 1))
+			goto out; /* UM8886A/BF pair */
+		break;
+	case PCI_VENDOR_ID_OPTI:
+		if (dev->device == PCI_DEVICE_ID_OPTI_82C558 &&
+				!(PCI_FUNC(dev->devfn) & 1))
+			goto out;
+		break;
+	case PCI_VENDOR_ID_JMICRON:
+		if (dev->device != PCI_DEVICE_ID_JMICRON_JMB368 &&
+				PCI_FUNC(dev->devfn) != 1)
+			goto out;
+		break;
+	case PCI_VENDOR_ID_NS:
+		if (dev->device == PCI_DEVICE_ID_NS_87410 &&
+				(dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
 			goto out;
+		break;
 	}
 
 	if (dev->vendor != PCI_VENDOR_ID_JMICRON) {
+		u16 command;
 		pci_read_config_word(dev, PCI_COMMAND, &command);
 		if (!(command & PCI_COMMAND_IO)) {
-			printk(KERN_INFO "Skipping disabled %s IDE controller.\n", d->name);
+			printk(KERN_INFO "Skipping disabled %s IDE "
+					"controller.\n", d->name);
 			goto out;
 		}
 	}
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index fcbc560..ce8a544 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.03	May 4, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.04	Jun 4, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -106,7 +106,8 @@
  *   switch  to calculating  PCI clock frequency based on the chip's base DPLL
  *   frequency
  * - switch to using the  DPLL clock and enable UltraATA/133 mode by default on
- *   anything  newer than HPT370/A
+ *   anything  newer than HPT370/A (except HPT374 that is not capable of this
+ *   mode according to the manual)
  * - fold PCI clock detection and DPLL setup code into init_chipset_hpt366(),
  *   also fixing the interchanged 25/40 MHz PCI clock cases for HPT36x chips;
  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
@@ -365,7 +366,6 @@ static u32 sixty_six_base_hpt37x[] = {
 };
 
 #define HPT366_DEBUG_DRIVE_INFO		0
-#define HPT374_ALLOW_ATA133_6		1
 #define HPT371_ALLOW_ATA133_6		1
 #define HPT302_ALLOW_ATA133_6		1
 #define HPT372_ALLOW_ATA133_6		1
@@ -450,7 +450,7 @@ static struct hpt_info hpt370a __devinitdata = {
 
 static struct hpt_info hpt374 __devinitdata = {
 	.chip_type	= HPT374,
-	.max_mode	= HPT374_ALLOW_ATA133_6 ? 4 : 3,
+	.max_mode	= 3,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 5faaff8..4bd4bf0 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -1,6 +1,6 @@
 
 /*
- * linux/drivers/ide/pci/it821x.c		Version 0.10	Mar 10 2007
+ * linux/drivers/ide/pci/it821x.c		Version 0.15	Jun 2 2007
  *
  * Copyright (C) 2004		Red Hat <alan@redhat.com>
  * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
@@ -262,7 +262,7 @@ static int it821x_tunepio(ide_drive_t *drive, u8 set_pio)
 	}
 
 	if (itdev->smart)
-		goto set_drive_speed;
+		return 0;
 
 	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
 	itdev->want[unit][1] = pio_want[set_pio];
@@ -271,7 +271,6 @@ static int it821x_tunepio(ide_drive_t *drive, u8 set_pio)
 	it821x_clock_strategy(drive);
 	it821x_program(drive, itdev->pio[unit]);
 
-set_drive_speed:
 	return ide_config_drive_speed(drive, XFER_PIO_0 + set_pio);
 }
 
@@ -455,12 +454,12 @@ static int it821x_tune_chipset (ide_drive_t *drive, byte xferspeed)
 			default:
 				return 1;
 		}
+
+		return ide_config_drive_speed(drive, speed);
 	}
-	/*
-	 *	In smart mode the clocking is done by the host controller
-	 * 	snooping the mode we picked. The rest of it is not our problem
-	 */
-	return ide_config_drive_speed(drive, speed);
+
+	/* don't touch anything in the smart mode */
+	return 0;
 }
 
 /**
@@ -559,17 +558,10 @@ static void __devinit it821x_fixups(ide_hwif_t *hwif)
 				if(idbits[129] != 1)
 					printk("(%dK stripe)", idbits[146]);
 				printk(".\n");
-			/* Now the core code will have wrongly decided no DMA
-			   so we need to fix this */
-			hwif->dma_off_quietly(drive);
-#ifdef CONFIG_IDEDMA_ONLYDISK
-			if (drive->media == ide_disk)
-#endif
-				ide_set_dma(drive);
 		} else {
 			/* Non RAID volume. Fixups to stop the core code
 			   doing unsupported things */
-			id->field_valid &= 1;
+			id->field_valid &= 3;
 			id->queue_depth = 0;
 			id->command_set_1 = 0;
 			id->command_set_2 &= 0xC400;
@@ -584,6 +576,16 @@ static void __devinit it821x_fixups(ide_hwif_t *hwif)
 			printk(KERN_INFO "%s: Performing identify fixups.\n",
 				drive->name);
 		}
+
+		/*
+		 * Set MWDMA0 mode as enabled/support - just to tell
+		 * IDE core that DMA is supported (it821x hardware
+		 * takes care of DMA mode programming).
+		 */
+		if (id->capability & 1) {
+			id->dma_mword |= 0x0101;
+			drive->current_speed = XFER_MW_DMA_0;
+		}
 	}
 
 }
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 47bcd91..d9c4fd1 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.9	Mar 4 2007
+ * linux/drivers/ide/pci/serverworks.c		Version 0.11	Jun 2 2007
  *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
@@ -170,42 +170,55 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		if (!drive->init_speed) {
 			u8 dma_stat = inb(hwif->dma_status);
 
-dma_pio:
 			if (((ultra_enable << (7-drive->dn) & 0x80) == 0x80) &&
 			    ((dma_stat & (1<<(5+unit))) == (1<<(5+unit)))) {
 				drive->current_speed = drive->init_speed = XFER_UDMA_0 + udma_modes[(ultra_timing >> (4*unit)) & ~(0xF0)];
 				return 0;
 			} else if ((dma_timing) &&
 				   ((dma_stat&(1<<(5+unit)))==(1<<(5+unit)))) {
-				u8 dmaspeed = dma_timing;
+				u8 dmaspeed;
 
-				dma_timing &= ~0xFFU;
-				if ((dmaspeed & 0x20) == 0x20)
+				switch (dma_timing & 0x77) {
+				case 0x20:
 					dmaspeed = XFER_MW_DMA_2;
-				else if ((dmaspeed & 0x21) == 0x21)
+					break;
+				case 0x21:
 					dmaspeed = XFER_MW_DMA_1;
-				else if ((dmaspeed & 0x77) == 0x77)
+					break;
+				case 0x77:
 					dmaspeed = XFER_MW_DMA_0;
-				else
+					break;
+				default:
 					goto dma_pio;
+				}
+
 				drive->current_speed = drive->init_speed = dmaspeed;
 				return 0;
-			} else if (pio_timing) {
-				u8 piospeed = pio_timing;
+			}
+dma_pio:
+			if (pio_timing) {
+				u8 piospeed;
 
-				pio_timing &= ~0xFFU;
-				if ((piospeed & 0x20) == 0x20)
+				switch (pio_timing & 0x7f) {
+				case 0x20:
 					piospeed = XFER_PIO_4;
-				else if ((piospeed & 0x22) == 0x22)
+					break;
+				case 0x22:
 					piospeed = XFER_PIO_3;
-				else if ((piospeed & 0x34) == 0x34)
+					break;
+				case 0x34:
 					piospeed = XFER_PIO_2;
-				else if ((piospeed & 0x47) == 0x47)
+					break;
+				case 0x47:
 					piospeed = XFER_PIO_1;
-				else if ((piospeed & 0x5d) == 0x5d)
+					break;
+				case 0x5d:
 					piospeed = XFER_PIO_0;
-				else
+					break;
+				default:
 					goto oem_setup_failed;
+				}
+
 				drive->current_speed = drive->init_speed = piospeed;
 				return 0;
 			}
@@ -214,8 +227,8 @@ dma_pio:
 
 oem_setup_failed:
 
-	pio_timing	&= ~0xFFU;
-	dma_timing	&= ~0xFFU;
+	pio_timing	= 0;
+	dma_timing	= 0;
 	ultra_timing	&= ~(0x0F << (4*unit));
 	ultra_enable	&= ~(0x01 << drive->dn);
 	csb5_pio	&= ~(0x0F << (4*drive->dn));
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 07aba87..1e365ac 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1001,6 +1001,7 @@ struct ide_driver_s {
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
+	void		(*resume)(ide_drive_t *);
 	void		(*shutdown)(ide_drive_t *);
 #ifdef CONFIG_IDE_PROC_FS
 	ide_proc_entry_t	*proc;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6a115cf..9a03b47 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1233,6 +1233,8 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_26              0x054E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_27              0x054F
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
