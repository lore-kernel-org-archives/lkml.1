Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbXLLW6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbXLLW6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXLLW6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:58:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:39660 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXLLW6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:58:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=QGBGC0WVNC0ZooDspkCZReyWKP8S4nwtbq/x/N4nOUHusKTaP+XojzcF8b3pbehdm3uuhlUkv/NyHRfL3K63fYLdCD9kWxj4ri//ARrg/TGXAmj0tjodiL6YwuB/ndza7g8nJ+2I2JvFLDjdYe6/Leaopsaes+S1dsjnYcEUg0s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Thu, 13 Dec 2007 00:03:48 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712130003.48368.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

This update contains: HPT37x PIO mode timings fixes (from Sergei Shtylyov),
Promise TX4 support bugfix, DMA modes reporting and validity checking fixes,
->io32_bit setting race fix, addition of device model/firmware/serial entries
to sysfs, some minor fixups and a few trivial patches like coding style fixes
dead code removal etc. (just to keep IDE tree patchcount + me sane)...

Bart


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig            |    6 +++-
 drivers/ide/ide-cd.c           |   35 +-------------------
 drivers/ide/ide-disk.c         |   33 +-----------------
 drivers/ide/ide-dma.c          |   66 ++++++++----------------------------
 drivers/ide/ide-io.c           |    3 +-
 drivers/ide/ide-iops.c         |    3 ++
 drivers/ide/ide-lib.c          |   55 ++++++++++++++++--------------
 drivers/ide/ide-probe.c        |   21 ++---------
 drivers/ide/ide.c              |   30 +++++++++++++++++
 drivers/ide/pci/hpt366.c       |   71 +++++++++++++++++++++++++++++++++++++++-
 drivers/ide/pci/pdc202xx_new.c |    3 +-
 drivers/ide/setup-pci.c        |   31 +++++++++--------
 drivers/scsi/ide-scsi.c        |   17 +++++----
 include/linux/ide.h            |    6 ++--
 14 files changed, 191 insertions(+), 189 deletions(-)


Bartlomiej Zolnierkiewicz (13):
      ide-scsi: add ide_scsi_hex_dump() helper
      ide: add missing checks for control register existence
      ide: deprecate CONFIG_BLK_DEV_OFFBOARD
      ide: fix ide_scan_pcibus() error message
      ide: coding style fixes for drivers/ide/setup-pci.c
      ide: add /sys/bus/ide/devices/*/{model,firmware,serial} sysfs entries
      ide: DMA reporting and validity checking fixes (take 3)
      ide-cd: remove dead post_transform_command()
      pdc202xx_new: fix Promise TX4 support
      ide: remove dead code from __ide_dma_test_irq()
      ide: remove stale changelog from ide-disk.c
      ide: remove stale changelog from ide-probe.c
      ide: fix ->io_32bit race in set_io_32bit()

Sergei Shtylyov (1):
      hpt366: fix HPT37x PIO mode timings (take 2)


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 45b2228..fb06555 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -390,7 +390,7 @@ config IDEPCI_PCIBUS_ORDER
 
 # TODO: split it on per host driver config options (or module parameters)
 config BLK_DEV_OFFBOARD
-	bool "Boot off-board chipsets first support"
+	bool "Boot off-board chipsets first support (DEPRECATED)"
 	depends on BLK_DEV_IDEPCI && (BLK_DEV_AEC62XX || BLK_DEV_GENERIC || BLK_DEV_HPT34X || 
BLK_DEV_HPT366 || BLK_DEV_PDC202XX_NEW || BLK_DEV_PDC202XX_OLD || BLK_DEV_TC86C001)
 	help
 	  Normally, IDE controllers built into the motherboard (on-board
@@ -410,6 +410,10 @@ config BLK_DEV_OFFBOARD
 	  Note that, if you do this, the order of the hd* devices will be
 	  rearranged which may require modification of fstab and other files.
 
+	  Please also note that this method of assuring stable naming of
+	  IDE devices is unreliable and use other means for achieving it
+	  (i.e. udev).
+
 	  If in doubt, say N.
 
 config BLK_DEV_GENERIC
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 57a5f63..92ac658 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1650,31 +1650,6 @@ static int cdrom_write_check_ireason(ide_drive_t *drive, int len, int ireason)
 	return 1;
 }
 
-static void post_transform_command(struct request *req)
-{
-	u8 *c = req->cmd;
-	char *ibuf;
-
-	if (!blk_pc_request(req))
-		return;
-
-	if (req->bio)
-		ibuf = bio_data(req->bio);
-	else
-		ibuf = req->data;
-
-	if (!ibuf)
-		return;
-
-	/*
-	 * set ansi-revision and response data as atapi
-	 */
-	if (c[0] == GPCMD_INQUIRY) {
-		ibuf[2] |= 2;
-		ibuf[3] = (ibuf[3] & 0xf0) | 2;
-	}
-}
-
 typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
 
 /*
@@ -1810,9 +1785,6 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	return ide_started;
 
 end_request:
-	if (!rq->data_len)
-		post_transform_command(rq);
-
 	spin_lock_irqsave(&ide_lock, flags);
 	blkdev_dequeue_request(rq);
 	end_that_request_last(rq, 1);
@@ -3049,12 +3021,7 @@ int ide_cdrom_probe_capabilities (ide_drive_t *drive)
         else 	
         	printk(" drive");
 
-	printk(", %dkB Cache", be16_to_cpu(cap.buffer_size));
-
-	if (drive->using_dma)
-		ide_dma_verbose(drive);
-
-	printk("\n");
+	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpu(cap.buffer_size));
 
 	return nslots;
 }
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 00123d9..b178190 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -13,32 +13,6 @@
  *                and Andre Hedrick <andre@linux-ide.org>
  *
  * This is the IDE/ATA disk driver, as evolved from hd.c and ide.c.
- *
- * Version 1.00		move disk only code from ide.c to ide-disk.c
- *			support optional byte-swapping of all data
- * Version 1.01		fix previous byte-swapping code
- * Version 1.02		remove ", LBA" from drive identification msgs
- * Version 1.03		fix display of id->buf_size for big-endian
- * Version 1.04		add /proc configurable settings and S.M.A.R.T support
- * Version 1.05		add capacity support for ATA3 >= 8GB
- * Version 1.06		get boot-up messages to show full cyl count
- * Version 1.07		disable door-locking if it fails
- * Version 1.08		fixed CHS/LBA translations for ATA4 > 8GB,
- *			process of adding new ATA4 compliance.
- *			fixed problems in allowing fdisk to see
- *			the entire disk.
- * Version 1.09		added increment of rq->sector in ide_multwrite
- *			added UDMA 3/4 reporting
- * Version 1.10		request queue changes, Ultra DMA 100
- * Version 1.11		added 48-bit lba
- * Version 1.12		adding taskfile io access method
- * Version 1.13		added standby and flush-cache for notifier
- * Version 1.14		added acoustic-wcache
- * Version 1.15		convert all calls to ide_raw_taskfile
- *				since args will return register content.
- * Version 1.16		added suspend-resume-checkpower
- * Version 1.17		do flush on standby, do flush on ATA < ATA6
- *			fix wcache setup.
  */
 
 #define IDEDISK_VERSION	"1.18"
@@ -961,11 +935,8 @@ static void idedisk_setup (ide_drive_t *drive)
 	if (id->buf_size)
 		printk (" w/%dKiB Cache", id->buf_size/2);
 
-	printk(", CHS=%d/%d/%d", 
-	       drive->bios_cyl, drive->bios_head, drive->bios_sect);
-	if (drive->using_dma)
-		ide_dma_verbose(drive);
-	printk("\n");
+	printk(KERN_CONT ", CHS=%d/%d/%d\n",
+			 drive->bios_cyl, drive->bios_head, drive->bios_sect);
 
 	/* write cache enabled? */
 	if ((id->csfo & 1) || (id->cfs_enable_1 & (1 << 5)))
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 0d795a1..4703837 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -611,12 +611,6 @@ static int __ide_dma_test_irq(ide_drive_t *drive)
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 dma_stat		= hwif->INB(hwif->dma_status);
 
-#if 0  /* do not set unless you know what you are doing */
-	if (dma_stat & 4) {
-		u8 stat = hwif->INB(IDE_STATUS_REG);
-		hwif->OUTB(hwif->dma_status, dma_stat & 0xE4);
-	}
-#endif
 	/* return 1 if INTR asserted */
 	if ((dma_stat & 4) == 4)
 		return 1;
@@ -753,10 +747,12 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 			mode = XFER_MW_DMA_1;
 	}
 
-	printk(KERN_DEBUG "%s: %s mode selected\n", drive->name,
+	mode = min(mode, req_mode);
+
+	printk(KERN_INFO "%s: %s mode selected\n", drive->name,
 			  mode ? ide_xfer_verbose(mode) : "no DMA");
 
-	return min(mode, req_mode);
+	return mode;
 }
 
 EXPORT_SYMBOL_GPL(ide_find_dma_mode);
@@ -772,6 +768,9 @@ static int ide_tune_dma(ide_drive_t *drive)
 	if (__ide_dma_bad_drive(drive))
 		return 0;
 
+	if (ide_id_dma_bug(drive))
+		return 0;
+
 	if (drive->hwif->host_flags & IDE_HFLAG_TRUST_BIOS_FOR_DMA)
 		return config_drive_for_dma(drive);
 
@@ -806,58 +805,23 @@ static int ide_dma_check(ide_drive_t *drive)
 	return vdma ? 0 : -1;
 }
 
-void ide_dma_verbose(ide_drive_t *drive)
+int ide_id_dma_bug(ide_drive_t *drive)
 {
-	struct hd_driveid *id	= drive->id;
-	ide_hwif_t *hwif	= HWIF(drive);
+	struct hd_driveid *id = drive->id;
 
 	if (id->field_valid & 4) {
 		if ((id->dma_ultra >> 8) && (id->dma_mword >> 8))
-			goto bug_dma_off;
-		if (id->dma_ultra & ((id->dma_ultra >> 8) & hwif->ultra_mask)) {
-			if (((id->dma_ultra >> 11) & 0x1F) &&
-			    eighty_ninty_three(drive)) {
-				if ((id->dma_ultra >> 15) & 1) {
-					printk(", UDMA(mode 7)");
-				} else if ((id->dma_ultra >> 14) & 1) {
-					printk(", UDMA(133)");
-				} else if ((id->dma_ultra >> 13) & 1) {
-					printk(", UDMA(100)");
-				} else if ((id->dma_ultra >> 12) & 1) {
-					printk(", UDMA(66)");
-				} else if ((id->dma_ultra >> 11) & 1) {
-					printk(", UDMA(44)");
-				} else
-					goto mode_two;
-			} else {
-		mode_two:
-				if ((id->dma_ultra >> 10) & 1) {
-					printk(", UDMA(33)");
-				} else if ((id->dma_ultra >> 9) & 1) {
-					printk(", UDMA(25)");
-				} else if ((id->dma_ultra >> 8) & 1) {
-					printk(", UDMA(16)");
-				}
-			}
-		} else {
-			printk(", (U)DMA");	/* Can be BIOS-enabled! */
-		}
+			goto err_out;
 	} else if (id->field_valid & 2) {
 		if ((id->dma_mword >> 8) && (id->dma_1word >> 8))
-			goto bug_dma_off;
-		printk(", DMA");
-	} else if (id->field_valid & 1) {
-		goto bug_dma_off;
+			goto err_out;
 	}
-	return;
-bug_dma_off:
-	printk(", BUG DMA OFF");
-	hwif->dma_off_quietly(drive);
-	return;
+	return 0;
+err_out:
+	printk(KERN_ERR "%s: bad DMA info in identify block\n", drive->name);
+	return 1;
 }
 
-EXPORT_SYMBOL(ide_dma_verbose);
-
 int ide_set_dma(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index db22d1f..bef781f 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -970,7 +970,8 @@ static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 		if (rc)
 			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
 		SELECT_DRIVE(drive);
-		HWIF(drive)->OUTB(8, HWIF(drive)->io_ports[IDE_CONTROL_OFFSET]);
+		if (IDE_CONTROL_REG)
+			HWIF(drive)->OUTB(drive->ctl, IDE_CONTROL_REG);
 		rc = ide_wait_not_busy(HWIF(drive), 100000);
 		if (rc)
 			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 5c32561..cef405d 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -748,6 +748,9 @@ int ide_driveid_update(ide_drive_t *drive)
 		drive->id->dma_1word = id->dma_1word;
 		/* anything more ? */
 		kfree(id);
+
+		if (drive->using_dma && ide_id_dma_bug(drive))
+			ide_dma_off(drive);
 	}
 
 	return 1;
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 1609b86..062d3bc 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -29,41 +29,44 @@
  *	Add common non I/O op stuff here. Make sure it has proper
  *	kernel-doc function headers or your patch will be rejected
  */
- 
+
+static const char *udma_str[] =
+	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
+	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
+static const char *mwdma_str[] =
+	{ "MWDMA0", "MWDMA1", "MWDMA2" };
+static const char *swdma_str[] =
+	{ "SWDMA0", "SWDMA1", "SWDMA2" };
+static const char *pio_str[] =
+	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5" };
 
 /**
  *	ide_xfer_verbose	-	return IDE mode names
- *	@xfer_rate: rate to name
+ *	@mode: transfer mode
  *
  *	Returns a constant string giving the name of the mode
  *	requested.
  */
 
-char *ide_xfer_verbose (u8 xfer_rate)
+const char *ide_xfer_verbose(u8 mode)
 {
-        switch(xfer_rate) {
-                case XFER_UDMA_7:	return("UDMA 7");
-                case XFER_UDMA_6:	return("UDMA 6");
-                case XFER_UDMA_5:	return("UDMA 5");
-                case XFER_UDMA_4:	return("UDMA 4");
-                case XFER_UDMA_3:	return("UDMA 3");
-                case XFER_UDMA_2:	return("UDMA 2");
-                case XFER_UDMA_1:	return("UDMA 1");
-                case XFER_UDMA_0:	return("UDMA 0");
-                case XFER_MW_DMA_2:	return("MW DMA 2");
-                case XFER_MW_DMA_1:	return("MW DMA 1");
-                case XFER_MW_DMA_0:	return("MW DMA 0");
-                case XFER_SW_DMA_2:	return("SW DMA 2");
-                case XFER_SW_DMA_1:	return("SW DMA 1");
-                case XFER_SW_DMA_0:	return("SW DMA 0");
-                case XFER_PIO_4:	return("PIO 4");
-                case XFER_PIO_3:	return("PIO 3");
-                case XFER_PIO_2:	return("PIO 2");
-                case XFER_PIO_1:	return("PIO 1");
-                case XFER_PIO_0:	return("PIO 0");
-                case XFER_PIO_SLOW:	return("PIO SLOW");
-                default:		return("XFER ERROR");
-        }
+	const char *s;
+	u8 i = mode & 0xf;
+
+	if (mode >= XFER_UDMA_0 && mode <= XFER_UDMA_7)
+		s = udma_str[i];
+	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_2)
+		s = mwdma_str[i];
+	else if (mode >= XFER_SW_DMA_0 && mode <= XFER_SW_DMA_2)
+		s = swdma_str[i];
+	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
+		s = pio_str[i & 0x7];
+	else if (mode == XFER_PIO_SLOW)
+		s = "PIO SLOW";
+	else
+		s = "XFER ERROR";
+
+	return s;
 }
 
 EXPORT_SYMBOL(ide_xfer_verbose);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index ee848c7..2994523 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -13,22 +13,8 @@
  *
  * This is the IDE probe module, as evolved from hd.c and ide.c.
  *
- * Version 1.00		move drive probing code from ide.c to ide-probe.c
- * Version 1.01		fix compilation problem for m68k
- * Version 1.02		increase WAIT_PIDENTIFY to avoid CD-ROM locking at boot
- *			 by Andrea Arcangeli
- * Version 1.03		fix for (hwif->chipset == ide_4drives)
- * Version 1.04		fixed buggy treatments of known flash memory cards
- *
- * Version 1.05		fix for (hwif->chipset == ide_pdc4030)
- *			added ide6/7/8/9
- *			allowed for secondary flash card to be detectable
- *			 with new flag : drive->ata_flash : 1;
- * Version 1.06		stream line request queue and prep for cascade project.
- * Version 1.07		max_sect <= 255; slower disks would get behind and
- * 			then fall over when they get to 256.	Paul G.
- * Version 1.10		Update set for new IDE. drive->id is now always
- *			valid after probe time even with noprobe
+ * -- increase WAIT_PIDENTIFY to avoid CD-ROM locking at boot
+ *	 by Andrea Arcangeli
  */
 
 #include <linux/module.h>
@@ -667,7 +653,8 @@ static int wait_hwif_ready(ide_hwif_t *hwif)
 		/* Ignore disks that we will not probe for later. */
 		if (!drive->noprobe || drive->present) {
 			SELECT_DRIVE(drive);
-			hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
+			if (IDE_CONTROL_REG)
+				hwif->OUTB(drive->ctl, IDE_CONTROL_REG);
 			mdelay(2);
 			rc = ide_wait_not_busy(hwif, 35000);
 			if (rc)
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 674a65c..54943da 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -800,11 +800,17 @@ int set_io_32bit(ide_drive_t *drive, int arg)
 	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
 		return -EINVAL;
 
+	if (ide_spin_wait_hwgroup(drive))
+		return -EBUSY;
+
 	drive->io_32bit = arg;
 #ifdef CONFIG_BLK_DEV_DTC2278
 	if (HWIF(drive)->chipset == ide_dtc2278)
 		HWIF(drive)->drives[!drive->select.b.unit].io_32bit = arg;
 #endif /* CONFIG_BLK_DEV_DTC2278 */
+
+	spin_unlock_irq(&ide_lock);
+
 	return 0;
 }
 
@@ -1670,10 +1676,34 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "ide:m-%s\n", media_string(drive));
 }
 
+static ssize_t model_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", drive->id->model);
+}
+
+static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", drive->id->fw_rev);
+}
+
+static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	return sprintf(buf, "%s\n", drive->id->serial_no);
+}
+
 static struct device_attribute ide_dev_attrs[] = {
 	__ATTR_RO(media),
 	__ATTR_RO(drivename),
 	__ATTR_RO(modalias),
+	__ATTR_RO(model),
+	__ATTR_RO(firmware),
+	__ATTR(serial, 0400, serial_show, NULL),
 	__ATTR_NULL
 };
 
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 5682895..9fce25b 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.21	Oct 23, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.22	Dec 4, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -310,6 +310,8 @@ static u32 twenty_five_base_hpt36x[] = {
 	/* XFER_PIO_0 */	0xc0d08585
 };
 
+#if 0
+/* These are the timing tables from the HighPoint open source drivers... */
 static u32 thirty_three_base_hpt37x[] = {
 	/* XFER_UDMA_6 */	0x12446231,	/* 0x12646231 ?? */
 	/* XFER_UDMA_5 */	0x12446231,
@@ -369,6 +371,73 @@ static u32 sixty_six_base_hpt37x[] = {
 	/* XFER_PIO_1 */	0x0d029d26,
 	/* XFER_PIO_0 */	0x0d029d5e
 };
+#else
+/*
+ * The following are the new timing tables with PIO mode data/taskfile transfer
+ * overclocking fixed...
+ */
+
+/* This table is taken from the HPT370 data manual rev. 1.02 */
+static u32 thirty_three_base_hpt37x[] = {
+	/* XFER_UDMA_6 */	0x16455031,	/* 0x16655031 ?? */
+	/* XFER_UDMA_5 */	0x16455031,
+	/* XFER_UDMA_4 */	0x16455031,
+	/* XFER_UDMA_3 */	0x166d5031,
+	/* XFER_UDMA_2 */	0x16495031,
+	/* XFER_UDMA_1 */	0x164d5033,
+	/* XFER_UDMA_0 */	0x16515097,
+
+	/* XFER_MW_DMA_2 */	0x26515031,
+	/* XFER_MW_DMA_1 */	0x26515033,
+	/* XFER_MW_DMA_0 */	0x26515097,
+
+	/* XFER_PIO_4 */	0x06515021,
+	/* XFER_PIO_3 */	0x06515022,
+	/* XFER_PIO_2 */	0x06515033,
+	/* XFER_PIO_1 */	0x06915065,
+	/* XFER_PIO_0 */	0x06d1508a
+};
+
+static u32 fifty_base_hpt37x[] = {
+	/* XFER_UDMA_6 */	0x1a861842,
+	/* XFER_UDMA_5 */	0x1a861842,
+	/* XFER_UDMA_4 */	0x1aae1842,
+	/* XFER_UDMA_3 */	0x1a8e1842,
+	/* XFER_UDMA_2 */	0x1a0e1842,
+	/* XFER_UDMA_1 */	0x1a161854,
+	/* XFER_UDMA_0 */	0x1a1a18ea,
+
+	/* XFER_MW_DMA_2 */	0x2a821842,
+	/* XFER_MW_DMA_1 */	0x2a821854,
+	/* XFER_MW_DMA_0 */	0x2a8218ea,
+
+	/* XFER_PIO_4 */	0x0a821842,
+	/* XFER_PIO_3 */	0x0a821843,
+	/* XFER_PIO_2 */	0x0a821855,
+	/* XFER_PIO_1 */	0x0ac218a8,
+	/* XFER_PIO_0 */	0x0b02190c
+};
+
+static u32 sixty_six_base_hpt37x[] = {
+	/* XFER_UDMA_6 */	0x1c86fe62,
+	/* XFER_UDMA_5 */	0x1caefe62,	/* 0x1c8afe62 */
+	/* XFER_UDMA_4 */	0x1c8afe62,
+	/* XFER_UDMA_3 */	0x1c8efe62,
+	/* XFER_UDMA_2 */	0x1c92fe62,
+	/* XFER_UDMA_1 */	0x1c9afe62,
+	/* XFER_UDMA_0 */	0x1c82fe62,
+
+	/* XFER_MW_DMA_2 */	0x2c82fe62,
+	/* XFER_MW_DMA_1 */	0x2c82fe66,
+	/* XFER_MW_DMA_0 */	0x2c82ff2e,
+
+	/* XFER_PIO_4 */	0x0c82fe62,
+	/* XFER_PIO_3 */	0x0c82fe84,
+	/* XFER_PIO_2 */	0x0c82fea6,
+	/* XFER_PIO_1 */	0x0d02ff26,
+	/* XFER_PIO_0 */	0x0d42ff7f
+};
+#endif
 
 #define HPT366_DEBUG_DRIVE_INFO		0
 #define HPT371_ALLOW_ATA133_6		1
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 4234efe..2b4f44e 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -482,8 +482,9 @@ static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
 {
 	struct pci_dev *dev2;
 
-	dev2 = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn) + 2,
+	dev2 = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn) + 1,
 						PCI_FUNC(dev->devfn)));
+
 	if (dev2 &&
 	    dev2->vendor == dev->vendor &&
 	    dev2->device == dev->device) {
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 25fd090..d2cd5a3 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -704,7 +704,7 @@ EXPORT_SYMBOL_GPL(ide_setup_pci_devices);
 /*
  *	Module interfaces
  */
- 
+
 static int pre_init = 1;		/* Before first ordered IDE scan */
 static LIST_HEAD(ide_pci_drivers);
 
@@ -714,7 +714,7 @@ static LIST_HEAD(ide_pci_drivers);
  *	@module: owner module of the driver
  *
  *	Registers a driver with the IDE layer. The IDE layer arranges that
- *	boot time setup is done in the expected device order and then 
+ *	boot time setup is done in the expected device order and then
  *	hands the controllers off to the core PCI code to do the rest of
  *	the work.
  *
@@ -724,13 +724,12 @@ static LIST_HEAD(ide_pci_drivers);
 int __ide_pci_register_driver(struct pci_driver *driver, struct module *module,
 			      const char *mod_name)
 {
-	if(!pre_init)
+	if (!pre_init)
 		return __pci_register_driver(driver, module, mod_name);
 	driver->driver.owner = module;
 	list_add_tail(&driver->node, &ide_pci_drivers);
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(__ide_pci_register_driver);
 
 /**
@@ -741,17 +740,18 @@ EXPORT_SYMBOL_GPL(__ide_pci_register_driver);
  *	This is only used during boot up to get the ordering correct. After
  *	boot up the pci layer takes over the job.
  */
- 
+
 static int __init ide_scan_pcidev(struct pci_dev *dev)
 {
 	struct list_head *l;
 	struct pci_driver *d;
-	
+
 	list_for_each(l, &ide_pci_drivers) {
 		d = list_entry(l, struct pci_driver, node);
 		if (d->id_table) {
-			const struct pci_device_id *id = pci_match_id(d->id_table,
-								      dev);
+			const struct pci_device_id *id =
+				pci_match_id(d->id_table, dev);
+
 			if (id != NULL && d->probe(dev, id) >= 0) {
 				dev->driver = d;
 				pci_dev_get(dev);
@@ -779,13 +779,13 @@ void __init ide_scan_pcibus (int scan_direction)
 
 	pre_init = 0;
 	if (!scan_direction)
-		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL)
+		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
 			ide_scan_pcidev(dev);
 	else
-		while ((dev = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID, dev))
-		       != NULL)
+		while ((dev = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID,
+						     dev)))
 			ide_scan_pcidev(dev);
-	
+
 	/*
 	 *	Hand the drivers over to the PCI layer now we
 	 *	are post init.
@@ -794,9 +794,10 @@ void __init ide_scan_pcibus (int scan_direction)
 	list_for_each_safe(l, n, &ide_pci_drivers) {
 		list_del(l);
 		d = list_entry(l, struct pci_driver, node);
-		if (__pci_register_driver(d, d->driver.owner, d->driver.mod_name))
-			printk(KERN_ERR "%s: failed to register driver for %s\n",
-			       __FUNCTION__, d->driver.mod_name);
+		if (__pci_register_driver(d, d->driver.owner,
+					  d->driver.mod_name))
+			printk(KERN_ERR "%s: failed to register %s driver\n",
+					__FUNCTION__, d->driver.mod_name);
 	}
 }
 #endif
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 7a835a3..9706de9 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -242,6 +242,11 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 	}
 }
 
+static void ide_scsi_hex_dump(u8 *data, int len)
+{
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
+}
+
 static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
@@ -272,8 +277,7 @@ static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_co
 	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
-		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, pc->c,
-			       6, 0);
+		ide_scsi_hex_dump(pc->c, 6);
 	}
 	rq->rq_disk = scsi->disk;
 	return ide_do_drive_cmd(drive, rq, ide_preempt);
@@ -328,8 +332,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
 		if (log) {
 			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, 
opc->scsi_cmd->serial_number);
-			print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
-				       pc->buffer, 16, 0);
+			ide_scsi_hex_dump(pc->buffer, 16);
 		}
 		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
 		kfree(pc->buffer);
@@ -808,12 +811,10 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
-		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
-			       cmd->cmnd, cmd->cmd_len, 0);
+		ide_scsi_hex_dump(cmd->cmnd, cmd->cmd_len);
 		if (memcmp(pc->c, cmd->cmnd, cmd->cmd_len)) {
 			printk ("ide-scsi: %s: que %lu, tsl = ", drive->name, cmd->serial_number);
-			print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1,
-				       pc->c, 12, 0);
+			ide_scsi_hex_dump(pc->c, 12);
 		}
 	}
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index dc75ccb..9a6a41e 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1255,6 +1255,7 @@ int ide_in_drive_list(struct hd_driveid *, const struct drive_list_entry *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 int __ide_dma_bad_drive(ide_drive_t *);
+int ide_id_dma_bug(ide_drive_t *);
 
 u8 ide_find_dma_mode(ide_drive_t *, u8);
 
@@ -1264,7 +1265,6 @@ static inline u8 ide_max_dma_mode(ide_drive_t *drive)
 }
 
 void ide_dma_off(ide_drive_t *);
-void ide_dma_verbose(ide_drive_t *);
 int ide_set_dma(ide_drive_t *);
 ide_startstop_t ide_dma_intr(ide_drive_t *);
 
@@ -1287,6 +1287,7 @@ extern void ide_dma_timeout(ide_drive_t *);
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 #else
+static inline int ide_id_dma_bug(ide_drive_t *drive) { return 0; }
 static inline u8 ide_find_dma_mode(ide_drive_t *drive, u8 speed) { return 0; }
 static inline u8 ide_max_dma_mode(ide_drive_t *drive) { return 0; }
 static inline void ide_dma_off(ide_drive_t *drive) { ; }
@@ -1333,8 +1334,7 @@ static inline void ide_set_hwifdata (ide_hwif_t * hwif, void *data)
 	hwif->hwif_data = data;
 }
 
-/* ide-lib.c */
-extern char *ide_xfer_verbose(u8 xfer_rate);
+const char *ide_xfer_verbose(u8 mode);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 
