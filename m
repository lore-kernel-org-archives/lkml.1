Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbXJMQY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbXJMQY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 12:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbXJMQYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 12:24:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:12643 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbXJMQYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 12:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=fnHSWdKN7nKnZHP8q3QxyJleoR+itzFHzG0d9HS+pTG32D1KOW4F9/e1WaC532KdzqVLPB1hkVC14k567PBkJuopP3nvKKjsZSrZhkqurPAgj7ojEzGkNucMmUug7oS+XF90daoxz6e/zPpn7NhhCcjtHrzqFOElLAt0ZsPaUnI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates (part 2)
Date: Sat, 13 Oct 2007 18:25:24 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710131825.24768.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

highlights of this update:

* Rework of IDE PMAC host driver: bugfixes, removal of the code
  duplicated from the IDE core and conversion to use the generic
  DMA tuning code path (the rework cuts ide-pmac.c by ~200 LOC).

  Thanks to Ben Herrenschmidt for help with it.

* Move setting device transfer mode from host drivers to the core
  code, this makes IDE host drivers very similar to libata one's
  w.r.t. PIO/DMA tuning and cuts another ~200 LOC from IDE code.

* Backport cable fix from libata (original fix by Jeff & Tejun)
  and remove no longer needed CONFIG_IDEDMA_IVB config option.

* More host driver fixes.


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig               |   16 --
 drivers/ide/arm/icside.c          |   45 +-----
 drivers/ide/cris/ide-cris.c       |    8 +-
 drivers/ide/ide-acpi.c            |    1 -
 drivers/ide/ide-dma.c             |   28 ++--
 drivers/ide/ide-io.c              |   10 +-
 drivers/ide/ide-iops.c            |  133 +++++----------
 drivers/ide/ide-lib.c             |   78 +++++++--
 drivers/ide/ide-probe.c           |    7 +-
 drivers/ide/ide.c                 |    2 +-
 drivers/ide/legacy/ide_platform.c |    2 +-
 drivers/ide/mips/au1xxx-ide.c     |   28 +---
 drivers/ide/pci/aec62xx.c         |   12 +-
 drivers/ide/pci/alim15x3.c        |   58 +++-----
 drivers/ide/pci/amd74xx.c         |   26 +--
 drivers/ide/pci/atiixp.c          |   33 ++---
 drivers/ide/pci/cmd64x.c          |    9 +-
 drivers/ide/pci/cs5520.c          |   32 ++---
 drivers/ide/pci/cs5530.c          |   50 +-----
 drivers/ide/pci/cs5535.c          |   38 ++---
 drivers/ide/pci/hpt34x.c          |    9 +-
 drivers/ide/pci/hpt366.c          |   18 +--
 drivers/ide/pci/it8213.c          |   34 ++---
 drivers/ide/pci/it821x.c          |   90 ++++-------
 drivers/ide/pci/jmicron.c         |   15 +-
 drivers/ide/pci/pdc202xx_new.c    |   24 ++--
 drivers/ide/pci/pdc202xx_old.c    |    9 +-
 drivers/ide/pci/piix.c            |   46 ++----
 drivers/ide/pci/sc1200.c          |   54 ++----
 drivers/ide/pci/scc_pata.c        |   28 ++--
 drivers/ide/pci/serverworks.c     |   14 +--
 drivers/ide/pci/sgiioc4.c         |   24 ++--
 drivers/ide/pci/siimage.c         |   29 ++--
 drivers/ide/pci/sis5513.c         |   16 +--
 drivers/ide/pci/sl82c105.c        |   23 +--
 drivers/ide/pci/slc90e66.c        |   18 +--
 drivers/ide/pci/tc86c001.c        |    9 +-
 drivers/ide/pci/triflex.c         |   10 +-
 drivers/ide/pci/via82cxxx.c       |   29 ++---
 drivers/ide/ppc/pmac.c            |  323 ++++++-------------------------------
 include/linux/ide.h               |   35 ++--
 41 files changed, 484 insertions(+), 989 deletions(-)


Adrian Bunk (1):
      ide: unexport ide_acpi_set_state

Bartlomiej Zolnierkiewicz (25):
      ide_platform: set hwif->chipset
      ide-pmac: don't check kauai_lookup_timing() return value
      ide-pmac: pmac_ide_tune_chipset() fixes
      ide-pmac: fix set_timings_mdma()
      ide-pmac: remove control register messing from pmac_ide_dma_check()
      ide-pmac: remove pmac_ide_{m,u}dma_enable() (take 2)
      ide: add __ide_wait_stat() helper
      ide-pmac: remove extra good status wait from pmac_ide_do_setfeature()
      ide-pmac: use __ide_wait_stat()
      ide-pmac: remove nIEN clearing from pmac_ide_do_setfeature()
      ide-pmac: remove pmac_ide_do_setfeature() (take 2)
      ide-pmac: use ide_tune_dma() (take 2)
      icside: use ide_tune_dma()
      au1xxx: fix au1xxx_set_pio_mode()
      amd74xx/via82cxxx: check ide_config_drive_speed() return value
      cs5535: check ide_config_drive_speed() return value
      pdc202xx_new: check ide_config_drive_speed() return value
      ide: move ide_config_drive_speed() calls to upper layers (take 2)
      ide: change master/slave IDENTIFY order
      ide: remove CONFIG_IDEDMA_IVB config option
      cs5535: add missing ->dma_base check
      sgiioc4: add missing ->dma_base check
      cs5520: fix ->dma_base equal zero handling
      sc1200: fix ->dma_base equal zero handling
      alim15x3: remove redundant m5229_revision check

Benjamin Herrenschmidt (1):
      ide-pmac: fix PIO setup and enable autotune


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index aa0e0c9..8982c09 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1074,22 +1074,6 @@ endif
 config BLK_DEV_IDEDMA
 	def_bool BLK_DEV_IDEDMA_PCI || BLK_DEV_IDEDMA_PMAC || BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 
-config IDEDMA_IVB
-	bool "IGNORE word93 Validation BITS"
-	depends on BLK_DEV_IDEDMA_PCI || BLK_DEV_IDEDMA_PMAC || BLK_DEV_IDEDMA_ICS
-	---help---
-	  There are unclear terms in ATA-4 and ATA-5 standards how certain
-	  hardware (an 80c ribbon) should be detected. Different interpretations
-	  of the standards have been released in hardware. This causes problems:
-	  for example, a host with Ultra Mode 4 (or higher) will not run
-	  in that mode with an 80c ribbon.
-
-	  If you are experiencing compatibility or performance problems, you
-	  MAY try to answer Y here. However, it does not necessarily solve
-	  any of your problems, it could even cause more of them.
-
-	  It is normally safe to answer Y; however, the default is N.
-
 endif
 
 config BLK_DEV_HD_ONLY
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 7912a47..bd1f5b6 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -248,7 +248,7 @@ static void icside_build_sglist(ide_drive_t *drive, struct request *rq)
  *	MW1	80	50	50	150	C
  *	MW2	70	25	25	120	C
  */
-static int icside_set_speed(ide_drive_t *drive, const u8 xfer_mode)
+static void icside_set_dma_mode(ide_drive_t *drive, const u8 xfer_mode)
 {
 	int cycle_time, use_dma_info = 0;
 
@@ -273,7 +273,7 @@ static int icside_set_speed(ide_drive_t *drive, const u8 xfer_mode)
 		cycle_time = 480;
 		break;
 	default:
-		return 1;
+		return;
 	}
 
 	/*
@@ -287,8 +287,6 @@ static int icside_set_speed(ide_drive_t *drive, const u8 xfer_mode)
 
 	printk("%s: %s selected (peak %dMB/s)\n", drive->name,
 		ide_xfer_verbose(xfer_mode), 2000 / drive->drive_data);
-
-	return ide_config_drive_speed(drive, xfer_mode);
 }
 
 static void icside_dma_host_off(ide_drive_t *drive)
@@ -313,41 +311,10 @@ static int icside_dma_on(ide_drive_t *drive)
 
 static int icside_dma_check(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
-	ide_hwif_t *hwif = HWIF(drive);
-	int xfer_mode = 0;
-
-	if (!(id->capability & 1) || !hwif->autodma)
-		goto out;
-
-	/*
-	 * Consult the list of known "bad" drives
-	 */
-	if (__ide_dma_bad_drive(drive))
-		goto out;
-
-	/*
-	 * Enable DMA on any drive that has multiword DMA
-	 */
-	if (id->field_valid & 2) {
-		xfer_mode = ide_max_dma_mode(drive);
-		goto out;
-	}
-
-	/*
-	 * Consult the list of known "good" drives
-	 */
-	if (__ide_dma_good_drive(drive)) {
-		if (id->eide_dma_time > 150)
-			goto out;
-		xfer_mode = XFER_MW_DMA_1;
-	}
-
-out:
-	if (xfer_mode == 0)
-		return -1;
+	if (ide_tune_dma(drive))
+		return 0;
 
-	return icside_set_speed(drive, xfer_mode) ? -1 : 0;
+	return -1;
 }
 
 static int icside_dma_end(ide_drive_t *drive)
@@ -464,7 +431,7 @@ static void icside_dma_init(ide_hwif_t *hwif)
 
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
-	hwif->speedproc		= icside_set_speed;
+	hwif->set_dma_mode	= icside_set_dma_mode;
 	hwif->autodma		= 1;
 
 	hwif->ide_dma_check	= icside_dma_check;
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 4bb42b3..2b4d2a0 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -716,11 +716,9 @@ static void cris_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	}
 
 	cris_ide_set_speed(TYPE_PIO, setup, strobe, hold);
-
-	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
-static int speed_cris_ide(ide_drive_t *drive, const u8 speed)
+static void cris_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	int cyc = 0, dvs = 0, strobe = 0, hold = 0;
 
@@ -759,8 +757,6 @@ static int speed_cris_ide(ide_drive_t *drive, const u8 speed)
 		cris_ide_set_speed(TYPE_UDMA, cyc, dvs, 0);
 	else
 		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
-
-	return ide_config_drive_speed(drive, speed);
 }
 
 void __init
@@ -791,7 +787,7 @@ init_e100_ide (void)
 		hwif->mmio = 1;
 		hwif->chipset = ide_etrax100;
 		hwif->set_pio_mode = &cris_set_pio_mode;
-		hwif->speedproc = &speed_cris_ide;
+		hwif->set_dma_mode = &cris_set_dma_mode;
 		hwif->ata_input_data = &cris_ide_input_data;
 		hwif->ata_output_data = &cris_ide_output_data;
 		hwif->atapi_input_bytes = &cris_atapi_input_bytes;
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 6bff81a..1d5f682 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -649,7 +649,6 @@ void ide_acpi_set_state(ide_hwif_t *hwif, int on)
 	if (!on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3);
 }
-EXPORT_SYMBOL_GPL(ide_acpi_set_state);
 
 /**
  * ide_acpi_init - initialize the ACPI link for an IDE interface
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 6000c08..b453211 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -169,6 +169,11 @@ ide_startstop_t ide_dma_intr (ide_drive_t *drive)
 
 EXPORT_SYMBOL_GPL(ide_dma_intr);
 
+static int ide_dma_good_drive(ide_drive_t *drive)
+{
+	return ide_in_drive_list(drive->id, drive_whitelist);
+}
+
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	ide_build_sglist	-	map IDE scatter gather for DMA I/O
@@ -357,7 +362,7 @@ static int config_drive_for_dma (ide_drive_t *drive)
 				return 0;
 
 		/* Consult the list of known "good" drives */
-		if (__ide_dma_good_drive(drive))
+		if (ide_dma_good_drive(drive))
 			return 0;
 	}
 
@@ -639,14 +644,6 @@ int __ide_dma_bad_drive (ide_drive_t *drive)
 
 EXPORT_SYMBOL(__ide_dma_bad_drive);
 
-int __ide_dma_good_drive (ide_drive_t *drive)
-{
-	struct hd_driveid *id = drive->id;
-	return ide_in_drive_list(id, drive_whitelist);
-}
-
-EXPORT_SYMBOL(__ide_dma_good_drive);
-
 static const u8 xfer_mode_bases[] = {
 	XFER_UDMA_0,
 	XFER_MW_DMA_0,
@@ -746,6 +743,14 @@ u8 ide_find_dma_mode(ide_drive_t *drive, u8 req_mode)
 		}
 	}
 
+	if (hwif->chipset == ide_acorn && mode == 0) {
+		/*
+		 * is this correct?
+		 */
+		if (ide_dma_good_drive(drive) && drive->id->eide_dma_time < 150)
+			mode = XFER_MW_DMA_1;
+	}
+
 	printk(KERN_DEBUG "%s: selected mode 0x%x\n", drive->name, mode);
 
 	return min(mode, req_mode);
@@ -769,7 +774,10 @@ int ide_tune_dma(ide_drive_t *drive)
 	if (!speed)
 		return 0;
 
-	if (drive->hwif->speedproc(drive, speed))
+	if (drive->hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
+	if (ide_set_dma_mode(drive, speed))
 		return 0;
 
 	return 1;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 9560a8f..4cece93 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -836,9 +836,17 @@ static ide_startstop_t do_special (ide_drive_t *drive)
 		if (set_pio_mode_abuse(drive->hwif, req_pio)) {
 			if (hwif->set_pio_mode)
 				hwif->set_pio_mode(drive, req_pio);
-		} else
+		} else {
+			int keep_dma = drive->using_dma;
+
 			ide_set_pio(drive, req_pio);
 
+			if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
+				if (keep_dma)
+					hwif->ide_dma_on(drive);
+			}
+		}
+
 		return ide_stopped;
 	} else {
 		if (drive->media == ide_disk)
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index cf0678b..aa73883 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -473,57 +473,22 @@ int drive_is_ready (ide_drive_t *drive)
 EXPORT_SYMBOL(drive_is_ready);
 
 /*
- * Global for All, and taken from ide-pmac.c. Can be called
- * with spinlock held & IRQs disabled, so don't schedule !
- */
-int wait_for_ready (ide_drive_t *drive, int timeout)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 stat			= 0;
-
-	while(--timeout) {
-		stat = hwif->INB(IDE_STATUS_REG);
-		if (!(stat & BUSY_STAT)) {
-			if (drive->ready_stat == 0)
-				break;
-			else if ((stat & drive->ready_stat)||(stat & ERR_STAT))
-				break;
-		}
-		mdelay(1);
-	}
-	if ((stat & ERR_STAT) || timeout <= 0) {
-		if (stat & ERR_STAT) {
-			printk(KERN_ERR "%s: wait_for_ready, "
-				"error status: %x\n", drive->name, stat);
-		}
-		return 1;
-	}
-	return 0;
-}
-
-/*
  * This routine busy-waits for the drive status to be not "busy".
  * It then checks the status for all of the "good" bits and none
  * of the "bad" bits, and if all is okay it returns 0.  All other
- * cases return 1 after invoking ide_error() -- caller should just return.
+ * cases return error -- caller may then invoke ide_error().
  *
  * This routine should get fixed to not hog the cpu during extra long waits..
  * That could be done by busy-waiting for the first jiffy or two, and then
  * setting a timer to wake up at half second intervals thereafter,
  * until timeout is achieved, before timing out.
  */
-int ide_wait_stat (ide_startstop_t *startstop, ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout)
+static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout, u8 *rstat)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	u8 stat;
-	int i;
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
- 
-	/* bail early if we've exceeded max_failures */
-	if (drive->max_failures && (drive->failures > drive->max_failures)) {
-		*startstop = ide_stopped;
-		return 1;
-	}
+	int i;
+	u8 stat;
 
 	udelay(1);	/* spec allows drive 400ns to assert "BUSY" */
 	if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) {
@@ -541,8 +506,8 @@ int ide_wait_stat (ide_startstop_t *startstop, ide_drive_t *drive, u8 good, u8 b
 					break;
 
 				local_irq_restore(flags);
-				*startstop = ide_error(drive, "status timeout", stat);
-				return 1;
+				*rstat = stat;
+				return -EBUSY;
 			}
 		}
 		local_irq_restore(flags);
@@ -556,11 +521,39 @@ int ide_wait_stat (ide_startstop_t *startstop, ide_drive_t *drive, u8 good, u8 b
 	 */
 	for (i = 0; i < 10; i++) {
 		udelay(1);
-		if (OK_STAT((stat = hwif->INB(IDE_STATUS_REG)), good, bad))
+		if (OK_STAT((stat = hwif->INB(IDE_STATUS_REG)), good, bad)) {
+			*rstat = stat;
 			return 0;
+		}
 	}
-	*startstop = ide_error(drive, "status error", stat);
-	return 1;
+	*rstat = stat;
+	return -EFAULT;
+}
+
+/*
+ * In case of error returns error value after doing "*startstop = ide_error()".
+ * The caller should return the updated value of "startstop" in this case,
+ * "startstop" is unchanged when the function returns 0.
+ */
+int ide_wait_stat(ide_startstop_t *startstop, ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout)
+{
+	int err;
+	u8 stat;
+
+	/* bail early if we've exceeded max_failures */
+	if (drive->max_failures && (drive->failures > drive->max_failures)) {
+		*startstop = ide_stopped;
+		return 1;
+	}
+
+	err = __ide_wait_stat(drive, good, bad, timeout, &stat);
+
+	if (err) {
+		char *s = (err == -EBUSY) ? "status timeout" : "status error";
+		*startstop = ide_error(drive, s, stat);
+	}
+
+	return err;
 }
 
 EXPORT_SYMBOL(ide_wait_stat);
@@ -620,15 +613,10 @@ u8 eighty_ninty_three (ide_drive_t *drive)
 
 	/*
 	 * FIXME:
-	 * - change master/slave IDENTIFY order
 	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
-#ifndef CONFIG_IDEDMA_IVB
 	if ((id->hw_config & 0x4000) || (ivb && (id->hw_config & 0x2000)))
-#else
-	if (id->hw_config & 0x6000)
-#endif
 		return 1;
 
 no_80w:
@@ -778,15 +766,10 @@ int ide_driveid_update (ide_drive_t *drive)
 #endif
 }
 
-/*
- * Similar to ide_wait_stat(), except it never calls ide_error internally.
- *
- * const char *msg == consider adding for verbose errors.
- */
-int ide_config_drive_speed (ide_drive_t *drive, u8 speed)
+int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	int	i, error	= 1;
+	ide_hwif_t *hwif = drive->hwif;
+	int error;
 	u8 stat;
 
 //	while (HWGROUP(drive)->busy)
@@ -826,35 +809,10 @@ int ide_config_drive_speed (ide_drive_t *drive, u8 speed)
 	hwif->OUTBSYNC(drive, WIN_SETFEATURES, IDE_COMMAND_REG);
 	if ((IDE_CONTROL_REG) && (drive->quirk_list == 2))
 		hwif->OUTB(drive->ctl, IDE_CONTROL_REG);
-	udelay(1);
-	/*
-	 * Wait for drive to become non-BUSY
-	 */
-	if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) {
-		unsigned long flags, timeout;
-		local_irq_set(flags);
-		timeout = jiffies + WAIT_CMD;
-		while ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) {
-			if (time_after(jiffies, timeout))
-				break;
-		}
-		local_irq_restore(flags);
-	}
 
-	/*
-	 * Allow status to settle, then read it again.
-	 * A few rare drives vastly violate the 400ns spec here,
-	 * so we'll wait up to 10usec for a "good" status
-	 * rather than expensively fail things immediately.
-	 * This fix courtesy of Matthew Faupel & Niccolo Rigacci.
-	 */
-	for (i = 0; i < 10; i++) {
-		udelay(1);
-		if (OK_STAT((stat = hwif->INB(IDE_STATUS_REG)), drive->ready_stat, BUSY_STAT|DRQ_STAT|ERR_STAT)) {
-			error = 0;
-			break;
-		}
-	}
+	error = __ide_wait_stat(drive, drive->ready_stat,
+				BUSY_STAT|DRQ_STAT|ERR_STAT,
+				WAIT_CMD, &stat);
 
 	SELECT_MASK(drive, 0);
 
@@ -899,9 +857,6 @@ int ide_config_drive_speed (ide_drive_t *drive, u8 speed)
 	return error;
 }
 
-EXPORT_SYMBOL(ide_config_drive_speed);
-
-
 /*
  * This should get invoked any time we exit the driver to
  * wait for an interrupt response from a drive.  handler() points
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index d97390c..0e2562f 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -349,7 +349,7 @@ void ide_set_pio(ide_drive_t *drive, u8 req_pio)
 			  drive->name, host_pio, req_pio,
 			  req_pio == 255 ? "(auto-tune)" : "", pio);
 
-	hwif->set_pio_mode(drive, pio);
+	(void)ide_set_pio_mode(drive, XFER_PIO_0 + pio);
 }
 
 EXPORT_SYMBOL_GPL(ide_set_pio);
@@ -378,39 +378,83 @@ void ide_toggle_bounce(ide_drive_t *drive, int on)
 		blk_queue_bounce_limit(drive->queue, addr);
 }
 
+int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	if (hwif->set_pio_mode == NULL)
+		return -1;
+
+	/*
+	 * TODO: temporary hack for some legacy host drivers that didn't
+	 * set transfer mode on the device in ->set_pio_mode method...
+	 */
+	if (hwif->set_dma_mode == NULL) {
+		hwif->set_pio_mode(drive, mode - XFER_PIO_0);
+		return 0;
+	}
+
+	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
+		if (ide_config_drive_speed(drive, mode))
+			return -1;
+		hwif->set_pio_mode(drive, mode - XFER_PIO_0);
+		return 0;
+	} else {
+		hwif->set_pio_mode(drive, mode - XFER_PIO_0);
+		return ide_config_drive_speed(drive, mode);
+	}
+}
+
+int ide_set_dma_mode(ide_drive_t *drive, const u8 mode)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	if (hwif->set_dma_mode == NULL)
+		return -1;
+
+	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
+		if (ide_config_drive_speed(drive, mode))
+			return -1;
+		hwif->set_dma_mode(drive, mode);
+		return 0;
+	} else {
+		hwif->set_dma_mode(drive, mode);
+		return ide_config_drive_speed(drive, mode);
+	}
+}
+
+EXPORT_SYMBOL_GPL(ide_set_dma_mode);
+
 /**
  *	ide_set_xfer_rate	-	set transfer rate
  *	@drive: drive to set
- *	@speed: speed to attempt to set
+ *	@rate: speed to attempt to set
  *	
  *	General helper for setting the speed of an IDE device. This
  *	function knows about user enforced limits from the configuration
- *	which speedproc() does not.  High level drivers should never
- *	invoke speedproc() directly.
+ *	which ->set_pio_mode/->set_dma_mode does not.
  */
- 
+
 int ide_set_xfer_rate(ide_drive_t *drive, u8 rate)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (hwif->speedproc == NULL)
+	if (hwif->set_dma_mode == NULL)
 		return -1;
 
 	rate = ide_rate_filter(drive, rate);
 
-	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5) {
-		if (hwif->set_pio_mode)
-			hwif->set_pio_mode(drive, rate - XFER_PIO_0);
+	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5)
+		return ide_set_pio_mode(drive, rate);
 
-		/*
-		 * FIXME: this is incorrect to return zero here but
-		 * since all users of ide_set_xfer_rate() ignore
-		 * the return value it is not a problem currently
-		 */
-		return 0;
-	}
+	/*
+	 * TODO: transfer modes 0x00-0x07 passed from the user-space are
+	 * currently handled here which needs fixing (please note that such
+	 * case could happen iff the transfer mode has already been set on
+	 * the device by ide-proc.c::set_xfer_rate()).
+	 */
 
-	return hwif->speedproc(drive, rate);
+	return ide_set_dma_mode(drive, rate);
 }
 
 static void ide_dump_opcode(ide_drive_t *drive)
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index b4c9f63..d101171 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -719,9 +719,9 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
  */
 static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 {
-	unsigned int unit;
 	unsigned long flags;
 	unsigned int irqd;
+	int unit;
 
 	if (hwif->noprobe)
 		return;
@@ -777,10 +777,9 @@ static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
 
 	/*
-	 * Second drive should only exist if first drive was found,
-	 * but a lot of cdrom drives are configured as single slaves.
+	 * Need to probe slave device first to make it release PDIAG-.
 	 */
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
+	for (unit = MAX_DRIVES - 1; unit >= 0; unit--) {
 		ide_drive_t *drive = &hwif->drives[unit];
 		drive->dn = (hwif->channel ? 2 : 0) + unit;
 		(void) probe_for_drive(drive);
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index a96a8b1..5c0e407 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -397,7 +397,7 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 #endif
 
 	hwif->set_pio_mode		= tmp_hwif->set_pio_mode;
-	hwif->speedproc			= tmp_hwif->speedproc;
+	hwif->set_dma_mode		= tmp_hwif->set_dma_mode;
 	hwif->mdma_filter		= tmp_hwif->mdma_filter;
 	hwif->udma_filter		= tmp_hwif->udma_filter;
 	hwif->selectproc		= tmp_hwif->selectproc;
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
index ccfb989..b992b2b 100644
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -65,7 +65,7 @@ found:
 	hwif->hw.irq = hwif->irq = irq;
 
 	hwif->hw.dma = NO_DMA;
-	hwif->hw.chipset = ide_generic;
+	hwif->chipset = hwif->hw.chipset = ide_generic;
 
 	if (mmio) {
 		hwif->mmio = 1;
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 85819ae..aebde49 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -101,12 +101,7 @@ void auide_outsw(unsigned long port, void *addr, u32 count)
 
 static void au1xxx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	int mem_sttime;
-	int mem_stcfg;
-	u8 speed;
-
-	mem_sttime = 0;
-	mem_stcfg  = au_readl(MEM_STCFG2);
+	int mem_sttime = 0, mem_stcfg = au_readl(MEM_STCFG2);
 
 	/* set pio mode! */
 	switch(pio) {
@@ -164,18 +159,11 @@ static void au1xxx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	au_writel(mem_sttime,MEM_STTIME2);
 	au_writel(mem_stcfg,MEM_STCFG2);
-
-	speed = pio + XFER_PIO_0;
-	ide_config_drive_speed(drive, speed);
 }
 
-static int auide_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void auide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	int mem_sttime;
-	int mem_stcfg;
-
-	mem_sttime = 0;
-	mem_stcfg  = au_readl(MEM_STCFG2);
+	int mem_sttime = 0, mem_stcfg = au_readl(MEM_STCFG2);
 
 	switch(speed) {
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
@@ -211,16 +199,11 @@ static int auide_tune_chipset(ide_drive_t *drive, const u8 speed)
 		break;
 #endif
 	default:
-		return 1;
+		return;
 	}
 
-	if (ide_config_drive_speed(drive, speed))
-		return 1;
-
 	au_writel(mem_sttime,MEM_STTIME2);
 	au_writel(mem_stcfg,MEM_STCFG2);
-
-	return 0;
 }
 
 /*
@@ -682,6 +665,7 @@ static int au_ide_probe(struct device *dev)
 #endif
 
 	hwif->pio_mask = ATA_PIO4;
+	hwif->host_flags = IDE_HFLAG_POST_SET_MODE;
 
 	hwif->noprobe = 0;
 	hwif->drives[0].unmask          = 1;
@@ -702,7 +686,7 @@ static int au_ide_probe(struct device *dev)
 #endif
 
 	hwif->set_pio_mode		= &au1xxx_set_pio_mode;
-	hwif->speedproc                 = &auide_tune_chipset;
+	hwif->set_dma_mode		= &auide_set_dma_mode;
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	hwif->dma_off_quietly		= &auide_dma_off_quietly;
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 0d5f62c..d6cb2d5 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -87,7 +87,7 @@ static u8 pci_bus_clock_list_ultra (u8 speed, struct chipset_bus_clock_list_entr
 	return chipset_table->ultra_settings;
 }
 
-static int aec6210_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void aec6210_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -111,10 +111,9 @@ static int aec6210_tune_chipset(ide_drive_t *drive, const u8 speed)
 	tmp2 = ((ultra_conf << (2*drive->dn)) | (tmp1 & ~(3 << (2*drive->dn))));
 	pci_write_config_byte(dev, 0x54, tmp2);
 	local_irq_restore(flags);
-	return(ide_config_drive_speed(drive, speed));
 }
 
-static int aec6260_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void aec6260_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -135,12 +134,11 @@ static int aec6260_tune_chipset(ide_drive_t *drive, const u8 speed)
 	tmp2 = ((ultra_conf << (4*unit)) | (tmp1 & ~(7 << (4*unit))));
 	pci_write_config_byte(dev, (0x44|hwif->channel), tmp2);
 	local_irq_restore(flags);
-	return(ide_config_drive_speed(drive, speed));
 }
 
 static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	(void) HWIF(drive)->speedproc(drive, pio + XFER_PIO_0);
+	drive->hwif->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
 static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
@@ -205,9 +203,9 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF) {
 		if(hwif->mate)
 			hwif->mate->serialized = hwif->serialized = 1;
-		hwif->speedproc = &aec6210_tune_chipset;
+		hwif->set_dma_mode = &aec6210_set_mode;
 	} else
-		hwif->speedproc = &aec6260_tune_chipset;
+		hwif->set_dma_mode = &aec6260_set_mode;
 
 	if (!hwif->dma_base) {
 		hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index d04b966..0b83443 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -283,14 +283,14 @@ static int ali_get_info (char *buffer, char **addr, off_t offset, int count)
 #endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
 /**
- *	ali_tune_pio	-	set host controller for PIO mode
+ *	ali_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
  *	@pio: PIO mode number
  *
  *	Program the controller for the given PIO mode.
  */
 
-static void ali_tune_pio(ide_drive_t *drive, const u8 pio)
+static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = hwif->pci_dev;
@@ -358,21 +358,6 @@ static void ali_tune_pio(ide_drive_t *drive, const u8 pio)
 }
 
 /**
- *	ali_set_pio_mode	-	set up drive for PIO mode
- *	@drive: drive to tune
- *	@pio: desired mode
- *
- *	Program the controller with the desired PIO timing for the given drive.
- *	Then set up the drive itself.
- */
-
-static void ali_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	ali_tune_pio(drive, pio);
-	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
-
-/**
  *	ali_udma_filter		-	compute UDMA mask
  *	@drive: IDE device
  *
@@ -401,15 +386,14 @@ static u8 ali_udma_filter(ide_drive_t *drive)
 }
 
 /**
- *	ali15x3_tune_chipset	-	set up chipset/drive for new speed
- *	@drive: drive to configure for
- *	@speed: desired speed
+ *	ali_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@speed: DMA mode
  *
  *	Configure the hardware for the desired IDE transfer mode.
- *	We also do the needed drive configuration through helpers
  */
 
-static int ali15x3_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void ali_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -419,7 +403,7 @@ static int ali15x3_tune_chipset(ide_drive_t *drive, const u8 speed)
 	int m5229_udma		= (hwif->channel) ? 0x57 : 0x56;
 
 	if (speed < XFER_PIO_0)
-		return 1;
+		return;
 
 	if (speed == XFER_UDMA_6)
 		speed1 = 0x47;
@@ -450,7 +434,6 @@ static int ali15x3_tune_chipset(ide_drive_t *drive, const u8 speed)
 			pci_write_config_byte(dev, 0x4b, tmpbyte);
 		}
 	}
-	return (ide_config_drive_speed(drive, speed));
 }
 
 /**
@@ -699,7 +682,7 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 {
 	hwif->autodma = 0;
 	hwif->set_pio_mode = &ali_set_pio_mode;
-	hwif->speedproc = &ali15x3_tune_chipset;
+	hwif->set_dma_mode = &ali_set_dma_mode;
 	hwif->udma_filter = &ali_udma_filter;
 
 	/* don't use LBA48 DMA on ALi devices before rev 0xC5 */
@@ -711,6 +694,10 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 		return;
 	}
 
+	/*
+	 * check in ->init_dma guarantees m5229_revision >= 0x20 here
+	 */
+
 	if (m5229_revision > 0x20)
 		hwif->atapi_dma = 1;
 
@@ -728,18 +715,15 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
-        if (m5229_revision >= 0x20) {
-                /*
-                 * M1543C or newer for DMAing
-                 */
-                hwif->ide_dma_check = &ali15x3_config_drive_for_dma;
-		hwif->dma_setup = &ali15x3_dma_setup;
-		if (!noautodma)
-			hwif->autodma = 1;
-
-		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-			hwif->cbl = ata66_ali15x3(hwif);
-	}
+	hwif->ide_dma_check = &ali15x3_config_drive_for_dma;
+	hwif->dma_setup = &ali15x3_dma_setup;
+
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = ata66_ali15x3(hwif);
+
+	if (!noautodma)
+		hwif->autodma = 1;
+
 	hwif->drives[0].autodma = hwif->autodma;
 	hwif->drives[1].autodma = hwif->autodma;
 }
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 513205e..6ff4089 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,5 +1,5 @@
 /*
- * Version 2.22
+ * Version 2.23
  *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
@@ -229,20 +229,16 @@ static void amd_set_speed(struct pci_dev *dev, unsigned char dn, struct ide_timi
 }
 
 /*
- * amd_set_drive() computes timing values configures the drive and
- * the chipset to a desired transfer mode. It also can be called
- * by upper layers.
+ * amd_set_drive() computes timing values and configures the chipset
+ * to a desired transfer mode.  It also can be called by upper layers.
  */
 
-static int amd_set_drive(ide_drive_t *drive, const u8 speed)
+static void amd_set_drive(ide_drive_t *drive, const u8 speed)
 {
 	ide_drive_t *peer = HWIF(drive)->drives + (~drive->dn & 1);
 	struct ide_timing t, p;
 	int T, UT;
 
-	if (speed != XFER_PIO_SLOW)
-		ide_config_drive_speed(drive, speed);
-
 	T = 1000000000 / amd_clock;
 	UT = (amd_config->udma_mask == ATA_UDMA2) ? T : (T / 2);
 
@@ -257,12 +253,6 @@ static int amd_set_drive(ide_drive_t *drive, const u8 speed)
 	if (speed == XFER_UDMA_6 && amd_clock <= 33333) t.udma = 15;
 
 	amd_set_speed(HWIF(drive)->pci_dev, drive->dn, &t);
-
-	if (!drive->init_speed)	
-		drive->init_speed = speed;
-	drive->current_speed = speed;
-
-	return 0;
 }
 
 /*
@@ -399,7 +389,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 	hwif->autodma = 0;
 
 	hwif->set_pio_mode = &amd_set_pio_mode;
-	hwif->speedproc = &amd_set_drive;
+	hwif->set_dma_mode = &amd_set_drive;
 
 	for (i = 0; i < 2; i++) {
 		hwif->drives[i].io_32bit = 1;
@@ -441,7 +431,8 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
 		.bootable	= ON_BOARD,				\
 		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST		\
-				| IDE_HFLAG_PIO_NO_DOWNGRADE,		\
+				| IDE_HFLAG_PIO_NO_DOWNGRADE		\
+				| IDE_HFLAG_POST_SET_MODE,		\
 		.pio_mask	= ATA_PIO5,				\
 	}
 
@@ -454,7 +445,8 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
 		.bootable	= ON_BOARD,				\
 		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST		\
-				| IDE_HFLAG_PIO_NO_DOWNGRADE,		\
+				| IDE_HFLAG_PIO_NO_DOWNGRADE		\
+				| IDE_HFLAG_POST_SET_MODE,		\
 		.pio_mask	= ATA_PIO5,				\
 	}
 
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 178876a..0eb97f0 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -122,14 +122,14 @@ static void atiixp_dma_host_off(ide_drive_t *drive)
 }
 
 /**
- *	atiixp_tune_pio	-	tune a drive attached to a ATIIXP
- *	@drive: drive to tune
- *	@pio: desired PIO mode
+ *	atiixp_set_pio_mode	-	set host controller for PIO mode
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
  *	Set the interface PIO mode.
  */
 
-static void atiixp_tune_pio(ide_drive_t *drive, u8 pio)
+static void atiixp_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	struct pci_dev *dev = drive->hwif->pci_dev;
 	unsigned long flags;
@@ -153,23 +153,16 @@ static void atiixp_tune_pio(ide_drive_t *drive, u8 pio)
 	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
-static void atiixp_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	atiixp_tune_pio(drive, pio);
-	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
-
 /**
- *	atiixp_tune_chipset	-	tune a ATIIXP interface
- *	@drive: IDE drive to tune
- *	@speed: speed to configure
+ *	atiixp_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@speed: DMA mode
  *
- *	Set a ATIIXP interface channel to the desired speeds. This involves
- *	requires the right timing data into the ATIIXP configuration space
- *	then setting the drive parameters appropriately
+ *	Set a ATIIXP host controller to the desired DMA mode.  This involves
+ *	programming the right timing data into the PCI configuration space.
  */
 
-static int atiixp_speedproc(ide_drive_t *drive, const u8 speed)
+static void atiixp_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	struct pci_dev *dev = drive->hwif->pci_dev;
 	unsigned long flags;
@@ -204,9 +197,7 @@ static int atiixp_speedproc(ide_drive_t *drive, const u8 speed)
 	else
 		pio = speed - XFER_PIO_0;
 
-	atiixp_tune_pio(drive, pio);
-
-	return ide_config_drive_speed(drive, speed);
+	atiixp_set_pio_mode(drive, pio);
 }
 
 /**
@@ -249,7 +240,7 @@ static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 
 	hwif->autodma = 0;
 	hwif->set_pio_mode = &atiixp_set_pio_mode;
-	hwif->speedproc = &atiixp_speedproc;
+	hwif->set_dma_mode = &atiixp_set_dma_mode;
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
 
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 0b568c6..d50f15e 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -280,10 +280,9 @@ static void cmd64x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		return;
 
 	cmd64x_tune_pio(drive, pio);
-	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
-static int cmd64x_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -324,13 +323,11 @@ static int cmd64x_tune_chipset(ide_drive_t *drive, const u8 speed)
 		program_cycle_times(drive, 480, 215);
 		break;
 	default:
-		return 1;
+		return;
 	}
 
 	if (speed >= XFER_SW_DMA_0)
 		(void) pci_write_config_byte(dev, pciU, regU);
-
-	return ide_config_drive_speed(drive, speed);
 }
 
 static int cmd64x_config_drive_for_dma (ide_drive_t *drive)
@@ -524,7 +521,7 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
 
 	hwif->set_pio_mode = &cmd64x_set_pio_mode;
-	hwif->speedproc = &cmd64x_tune_chipset;
+	hwif->set_dma_mode = &cmd64x_set_dma_mode;
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 1217d2a..fbce900 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -96,22 +96,13 @@ static void cs5520_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	reg = inb(hwif->dma_base + 0x02 + 8*controller);
 	reg |= 1<<((drive->dn&1)+5);
 	outb(reg, hwif->dma_base + 0x02 + 8*controller);
-
-	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
-static int cs5520_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void cs5520_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	printk(KERN_ERR "cs55x0: bad ide timing.\n");
 
 	cs5520_set_pio_mode(drive, 0);
-
-	/*
-	 * FIXME: this is incorrect to return zero here but
-	 * since all users of ide_set_xfer_rate() ignore
-	 * the return value it is not a problem currently
-	 */
-	return 0;
 }
 
 static int cs5520_config_drive_xfer_rate(ide_drive_t *drive)
@@ -150,26 +141,25 @@ static int cs5520_dma_on(ide_drive_t *drive)
 static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
 {
 	hwif->set_pio_mode = &cs5520_set_pio_mode;
-	hwif->speedproc = &cs5520_tune_chipset;
-	hwif->ide_dma_check = &cs5520_config_drive_xfer_rate;
-	hwif->ide_dma_on = &cs5520_dma_on;
+	hwif->set_dma_mode = &cs5520_set_dma_mode;
 
-	if(!noautodma)
-		hwif->autodma = 1;
-	
-	if(!hwif->dma_base)
-	{
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
+	if (hwif->dma_base == 0) {
+		hwif->drives[1].autotune = hwif->drives[0].autotune = 1;
 		return;
 	}
 
+	hwif->ide_dma_check = &cs5520_config_drive_xfer_rate;
+	hwif->ide_dma_on = &cs5520_dma_on;
+
 	/* ATAPI is harder so leave it for now */
 	hwif->atapi_dma = 0;
 	hwif->ultra_mask = 0;
 	hwif->swdma_mask = 0;
 	hwif->mwdma_mask = 0;
-	
+
+	if (!noautodma)
+		hwif->autodma = 1;
+
 	hwif->drives[0].autodma = hwif->autodma;
 	hwif->drives[1].autodma = hwif->autodma;
 }
diff --git a/drivers/ide/pci/cs5530.c b/drivers/ide/pci/cs5530.c
index 741507b..e412157 100644
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -30,22 +30,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-/**
- *	cs5530_xfer_set_mode	-	set a new transfer mode at the drive
- *	@drive: drive to tune
- *	@mode: new mode
- *
- *	Logging wrapper to the IDE driver speed configuration. This can
- *	probably go away now.
- */
- 
-static int cs5530_set_xfer_mode (ide_drive_t *drive, u8 mode)
-{
-	printk(KERN_DEBUG "%s: cs5530_set_xfer_mode(%s)\n",
-		drive->name, ide_xfer_verbose(mode));
-	return (ide_config_drive_speed(drive, mode));
-}
-
 /*
  * Here are the standard PIO mode 0-4 timings for each "format".
  * Format-0 uses fast data reg timings, with slower command reg timings.
@@ -62,20 +46,12 @@ static unsigned int cs5530_pio_timings[2][5] = {
 #define CS5530_BAD_PIO(timings) (((timings)&~0x80000000)==0x0000e132)
 #define CS5530_BASEREG(hwif)	(((hwif)->dma_base & ~0xf) + ((hwif)->channel ? 0x30 : 0x20))
 
-static void cs5530_tunepio(ide_drive_t *drive, u8 pio)
-{
-	unsigned long basereg = CS5530_BASEREG(drive->hwif);
-	unsigned int format = (inl(basereg + 4) >> 31) & 1;
-
-	outl(cs5530_pio_timings[format][pio], basereg + ((drive->dn & 1)<<3));
-}
-
 /**
- *	cs5530_set_pio_mode	-	set PIO mode
+ *	cs5530_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
  *	@pio: PIO mode number
  *
- *	Handles setting of PIO mode for both the chipset and drive.
+ *	Handles setting of PIO mode for the chipset.
  *
  *	The init_hwif_cs5530() routine guarantees that all drives
  *	will have valid default PIO timings set up before we get here.
@@ -83,8 +59,10 @@ static void cs5530_tunepio(ide_drive_t *drive, u8 pio)
 
 static void cs5530_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	if (cs5530_set_xfer_mode(drive, XFER_PIO_0 + pio) == 0)
-		cs5530_tunepio(drive, pio);
+	unsigned long basereg = CS5530_BASEREG(drive->hwif);
+	unsigned int format = (inl(basereg + 4) >> 31) & 1;
+
+	outl(cs5530_pio_timings[format][pio], basereg + ((drive->dn & 1)<<3));
 }
 
 /**
@@ -142,20 +120,11 @@ static int cs5530_config_dma(ide_drive_t *drive)
 	return 1;
 }
 
-static int cs5530_tune_chipset(ide_drive_t *drive, const u8 mode)
+static void cs5530_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
 	unsigned long basereg;
 	unsigned int reg, timings = 0;
 
-	/*
-	 * Tell the drive to switch to the new mode; abort on failure.
-	 */
-	if (cs5530_set_xfer_mode(drive, mode))
-		return 1;	/* failure */
-
-	/*
-	 * Now tune the chipset to match the drive:
-	 */
 	switch (mode) {
 		case XFER_UDMA_0:	timings = 0x00921250; break;
 		case XFER_UDMA_1:	timings = 0x00911140; break;
@@ -180,8 +149,6 @@ static int cs5530_tune_chipset(ide_drive_t *drive, const u8 mode)
 		outl(reg, basereg + 4);		/* write drive0 config register */
 		outl(timings, basereg + 12);	/* write drive1 config register */
 	}
-
-	return 0;	/* success */
 }
 
 /**
@@ -299,7 +266,7 @@ static void __devinit init_hwif_cs5530 (ide_hwif_t *hwif)
 		hwif->serialized = hwif->mate->serialized = 1;
 
 	hwif->set_pio_mode = &cs5530_set_pio_mode;
-	hwif->speedproc = &cs5530_tune_chipset;
+	hwif->set_dma_mode = &cs5530_set_dma_mode;
 
 	basereg = CS5530_BASEREG(hwif);
 	d0_timings = inl(basereg + 0);
@@ -340,6 +307,7 @@ static ide_pci_device_t cs5530_chipset __devinitdata = {
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
 	.pio_mask	= ATA_PIO4,
+	.host_flags	= IDE_HFLAG_POST_SET_MODE,
 };
 
 static int __devinit cs5530_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 383b7ec..2578657 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -131,24 +131,21 @@ static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
 	}
 }
 
-/****
- *	cs5535_set_drive         -     Configure the drive to the new speed
- *	@drive: Drive to set up
- *	@speed: desired speed
+/**
+ *	cs5535_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@speed: DMA mode
  *
- *	cs5535_set_drive() configures the drive and the chipset to a
- *	new speed. It also can be called by upper layers.
+ *	Programs the chipset for DMA mode.
  */
-static int cs5535_set_drive(ide_drive_t *drive, u8 speed)
+
+static void cs5535_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	ide_config_drive_speed(drive, speed);
 	cs5535_set_speed(drive, speed);
-
-	return 0;
 }
 
 /**
- *	cs5535_set_pio_mode	-	PIO setup
+ *	cs5535_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
  *	@pio: PIO mode number
  *
@@ -157,7 +154,6 @@ static int cs5535_set_drive(ide_drive_t *drive, u8 speed)
 
 static void cs5535_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 	cs5535_set_speed(drive, XFER_PIO_0 + pio);
 }
 
@@ -194,12 +190,16 @@ static u8 __devinit cs5535_cable_detect(struct pci_dev *dev)
  */
 static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 {
-	int i;
-
 	hwif->autodma = 0;
 
 	hwif->set_pio_mode = &cs5535_set_pio_mode;
-	hwif->speedproc = &cs5535_set_drive;
+	hwif->set_dma_mode = &cs5535_set_dma_mode;
+
+	hwif->drives[1].autotune = hwif->drives[0].autotune = 1;
+
+	if (hwif->dma_base == 0)
+		return;
+
 	hwif->ide_dma_check = &cs5535_dma_check;
 
 	hwif->atapi_dma = 1;
@@ -211,11 +211,7 @@ static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 	if (!noautodma)
 		hwif->autodma = 1;
 
-	/* just setting autotune and not worrying about bios timings */
-	for (i = 0; i < 2; i++) {
-		hwif->drives[i].autotune = 1;
-		hwif->drives[i].autodma = hwif->autodma;
-	}
+	hwif->drives[1].autodma = hwif->drives[0].autodma = hwif->autodma;
 }
 
 static ide_pci_device_t cs5535_chipset __devinitdata = {
@@ -223,7 +219,7 @@ static ide_pci_device_t cs5535_chipset __devinitdata = {
 	.init_hwif	= init_hwif_cs5535,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
-	.host_flags	= IDE_HFLAG_SINGLE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
 };
 
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index a1bb101..218852a 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -43,7 +43,7 @@
 
 #define HPT343_DEBUG_DRIVE_INFO		0
 
-static int hpt34x_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void hpt34x_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	struct pci_dev *dev	= HWIF(drive)->pci_dev;
 	u32 reg1= 0, tmp1 = 0, reg2 = 0, tmp2 = 0;
@@ -73,13 +73,11 @@ static int hpt34x_tune_chipset(ide_drive_t *drive, const u8 speed)
 		drive->dn, reg1, tmp1, reg2, tmp2,
 		hi_speed, lo_speed);
 #endif /* HPT343_DEBUG_DRIVE_INFO */
-
-	return(ide_config_drive_speed(drive, speed));
 }
 
 static void hpt34x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	(void) hpt34x_tune_chipset(drive, (XFER_PIO_0 + pio));
+	hpt34x_set_mode(drive, XFER_PIO_0 + pio);
 }
 
 static int hpt34x_config_drive_xfer_rate (ide_drive_t *drive)
@@ -145,7 +143,8 @@ static void __devinit init_hwif_hpt34x(ide_hwif_t *hwif)
 	hwif->autodma = 0;
 
 	hwif->set_pio_mode = &hpt34x_set_pio_mode;
-	hwif->speedproc = &hpt34x_tune_chipset;
+	hwif->set_dma_mode = &hpt34x_set_mode;
+
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
 
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 0e7d3b6..8812a9b 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -600,7 +600,7 @@ static u32 get_speed_setting(u8 speed, struct hpt_info *info)
 	return (*info->settings)[i];
 }
 
-static int hpt36x_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void hpt36x_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev  *dev	= hwif->pci_dev;
@@ -623,11 +623,9 @@ static int hpt36x_tune_chipset(ide_drive_t *drive, const u8 speed)
 	new_itr &= ~0xc0000000;
 
 	pci_write_config_dword(dev, itr_addr, new_itr);
-
-	return ide_config_drive_speed(drive, speed);
 }
 
-static int hpt37x_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void hpt37x_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev  *dev	= hwif->pci_dev;
@@ -647,24 +645,22 @@ static int hpt37x_tune_chipset(ide_drive_t *drive, const u8 speed)
 	if (speed < XFER_MW_DMA_0)
 		new_itr &= ~0x80000000; /* Disable on-chip PIO FIFO/buffer */
 	pci_write_config_dword(dev, itr_addr, new_itr);
-
-	return ide_config_drive_speed(drive, speed);
 }
 
-static int hpt3xx_tune_chipset(ide_drive_t *drive, u8 speed)
+static void hpt3xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct hpt_info	*info	= pci_get_drvdata(hwif->pci_dev);
 
 	if (info->chip_type >= HPT370)
-		return hpt37x_tune_chipset(drive, speed);
+		hpt37x_set_mode(drive, speed);
 	else	/* hpt368: hpt_minimum_revision(dev, 2) */
-		return hpt36x_tune_chipset(drive, speed);
+		hpt36x_set_mode(drive, speed);
 }
 
 static void hpt3xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	(void) hpt3xx_tune_chipset (drive, XFER_PIO_0 + pio);
+	hpt3xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
 static int hpt3xx_quirkproc(ide_drive_t *drive)
@@ -1257,7 +1253,7 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
 
 	hwif->set_pio_mode	= &hpt3xx_set_pio_mode;
-	hwif->speedproc		= &hpt3xx_tune_chipset;
+	hwif->set_dma_mode	= &hpt3xx_set_mode;
 	hwif->quirkproc		= &hpt3xx_quirkproc;
 	hwif->intrproc		= &hpt3xx_intrproc;
 	hwif->maskproc		= &hpt3xx_maskproc;
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 76e91ff..ecf4ce0 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -48,15 +48,15 @@ static u8 it8213_dma_2_pio (u8 xfer_rate) {
 	}
 }
 
-/*
- *	it8213_tune_pio	-	tune a drive
- *	@drive: drive to tune
- *	@pio: desired PIO mode
+/**
+ *	it8213_set_pio_mode	-	set host controller for PIO mode
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
  *	Set the interface PIO mode.
  */
 
-static void it8213_tune_pio(ide_drive_t *drive, const u8 pio)
+static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -105,21 +105,15 @@ static void it8213_tune_pio(ide_drive_t *drive, const u8 pio)
 	spin_unlock_irqrestore(&tune_lock, flags);
 }
 
-static void it8213_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	it8213_tune_pio(drive, pio);
-	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
-
 /**
- *	it8213_tune_chipset	-	set controller timings
- *	@drive: Drive to set up
- *	@speed: speed we want to achieve
+ *	it8213_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@speed: DMA mode
  *
- *	Tune the ITE chipset for the desired mode.
+ *	Tune the ITE chipset for the DMA mode.
  */
 
-static int it8213_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void it8213_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -152,7 +146,7 @@ static int it8213_tune_chipset(ide_drive_t *drive, const u8 speed)
 		case XFER_SW_DMA_2:
 			break;
 		default:
-			return -1;
+			return;
 	}
 
 	if (speed >= XFER_UDMA_0) {
@@ -182,9 +176,7 @@ static int it8213_tune_chipset(ide_drive_t *drive, const u8 speed)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 	}
 
-	it8213_tune_pio(drive, it8213_dma_2_pio(speed));
-
-	return ide_config_drive_speed(drive, speed);
+	it8213_set_pio_mode(drive, it8213_dma_2_pio(speed));
 }
 
 /**
@@ -220,7 +212,7 @@ static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 {
 	u8 reg42h = 0;
 
-	hwif->speedproc = &it8213_tune_chipset;
+	hwif->set_dma_mode = &it8213_set_dma_mode;
 	hwif->set_pio_mode = &it8213_set_pio_mode;
 
 	hwif->autodma = 0;
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 758a982..1b69d82 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -229,24 +229,24 @@ static void it821x_clock_strategy(ide_drive_t *drive)
 }
 
 /**
- *	it821x_tunepio	-	tune a drive
- *	@drive: drive to tune
- *	@pio: the desired PIO mode
+ *	it821x_set_pio_mode	-	set host controller for PIO mode
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
- *	Try to tune the drive/host to the desired PIO mode taking into
- *	the consideration the maximum PIO mode supported by the other
- *	device on the cable.
+ *	Tune the host to the desired PIO mode taking into the consideration
+ *	the maximum PIO mode supported by the other device on the cable.
  */
 
-static int it821x_tunepio(ide_drive_t *drive, u8 set_pio)
+static void it821x_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	int unit = drive->select.b.unit;
 	ide_drive_t *pair = &hwif->drives[1 - unit];
+	u8 set_pio = pio;
 
 	/* Spec says 89 ref driver uses 88 */
-	static u16 pio[]	= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
+	static u16 pio_timings[]= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
 	static u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
 
 	/*
@@ -261,22 +261,12 @@ static int it821x_tunepio(ide_drive_t *drive, u8 set_pio)
 			set_pio = pair_pio;
 	}
 
-	if (itdev->smart)
-		return 0;
-
 	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
 	itdev->want[unit][1] = pio_want[set_pio];
 	itdev->want[unit][0] = 1;	/* PIO is lowest priority */
-	itdev->pio[unit] = pio[set_pio];
+	itdev->pio[unit] = pio_timings[set_pio];
 	it821x_clock_strategy(drive);
 	it821x_program(drive, itdev->pio[unit]);
-
-	return ide_config_drive_speed(drive, XFER_PIO_0 + set_pio);
-}
-
-static void it821x_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	(void)it821x_tunepio(drive, pio);
 }
 
 /**
@@ -405,47 +395,24 @@ static int it821x_dma_end(ide_drive_t *drive)
 }
 
 /**
- *	it821x_tune_chipset	-	set controller timings
- *	@drive: Drive to set up
- *	@speed: speed we want to achieve
+ *	it821x_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@speed: DMA mode
  *
- *	Tune the ITE chipset for the desired mode.
+ *	Tune the ITE chipset for the desired DMA mode.
  */
 
-static int it821x_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void it821x_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-
-	ide_hwif_t *hwif	= drive->hwif;
-	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-
-	if (itdev->smart == 0) {
-		switch (speed) {
-			/* MWDMA tuning is really hard because our MWDMA and PIO
-			   timings are kept in the same place. We can switch in the
-			   host dma on/off callbacks */
-			case XFER_MW_DMA_2:
-			case XFER_MW_DMA_1:
-			case XFER_MW_DMA_0:
-				it821x_tune_mwdma(drive, (speed - XFER_MW_DMA_0));
-				break;
-			case XFER_UDMA_6:
-			case XFER_UDMA_5:
-			case XFER_UDMA_4:
-			case XFER_UDMA_3:
-			case XFER_UDMA_2:
-			case XFER_UDMA_1:
-			case XFER_UDMA_0:
-				it821x_tune_udma(drive, (speed - XFER_UDMA_0));
-				break;
-			default:
-				return 1;
-		}
-
-		return ide_config_drive_speed(drive, speed);
-	}
-
-	/* don't touch anything in the smart mode */
-	return 0;
+	/*
+	 * MWDMA tuning is really hard because our MWDMA and PIO
+	 * timings are kept in the same place.  We can switch in the
+	 * host dma on/off callbacks.
+	 */
+	if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_6)
+		it821x_tune_udma(drive, speed - XFER_UDMA_0);
+	else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
+		it821x_tune_mwdma(drive, speed - XFER_MW_DMA_0);
 }
 
 /**
@@ -629,14 +596,15 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 			printk(KERN_WARNING "it821x: Revision 0x10, workarounds activated.\n");
 	}
 
-	hwif->speedproc = &it821x_tune_chipset;
-	hwif->set_pio_mode = &it821x_set_pio_mode;
+	if (idev->smart == 0) {
+		hwif->set_pio_mode = &it821x_set_pio_mode;
+		hwif->set_dma_mode = &it821x_set_dma_mode;
 
-	/* MWDMA/PIO clock switching for pass through mode */
-	if(!idev->smart) {
+		/* MWDMA/PIO clock switching for pass through mode */
 		hwif->dma_start = &it821x_dma_start;
 		hwif->ide_dma_end = &it821x_dma_end;
-	}
+	} else
+		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;
 
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index d379fba..582b4ca 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -85,21 +85,18 @@ static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
 
 static void jmicron_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 /**
- *	jmicron_tune_chipset	-	set controller timings
- *	@drive: Drive to set up
- *	@speed: speed we want to achieve
+ *	jmicron_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@mode: DMA mode
  *
- *	As the JMicron snoops for timings all we actually need to do is
- *	set the transfer mode on the device.
+ *	As the JMicron snoops for timings we don't need to do anything here.
  */
 
-static int jmicron_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void jmicron_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
-	return ide_config_drive_speed(drive, speed);
 }
 
 /**
@@ -129,8 +126,8 @@ static int jmicron_config_drive_for_dma (ide_drive_t *drive)
 
 static void __devinit init_hwif_jmicron(ide_hwif_t *hwif)
 {
-	hwif->speedproc = &jmicron_tune_chipset;
 	hwif->set_pio_mode = &jmicron_set_pio_mode;
+	hwif->set_dma_mode = &jmicron_set_dma_mode;
 
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 5fb1eed..ad0bdcb 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -146,19 +146,16 @@ static struct udma_timing {
 	{ 0x1a, 0x01, 0xcb },	/* UDMA mode 6 */
 };
 
-static int pdcnew_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void pdcnew_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
-	int			err;
 
 	/*
-	 * Issue SETFEATURES_XFER to the drive first. PDC202xx hardware will
+	 * IDE core issues SETFEATURES_XFER to the drive first (thanks to
+	 * IDE_HFLAG_POST_SET_MODE in ->host_flags).  PDC202xx hardware will
 	 * automatically set the timing registers based on 100 MHz PLL output.
-	 */
- 	err = ide_config_drive_speed(drive, speed);
-
-	/*
+	 *
 	 * As we set up the PLL to output 133 MHz for UltraDMA/133 capable
 	 * chips, we must override the default register settings...
 	 */
@@ -211,13 +208,11 @@ static int pdcnew_tune_chipset(ide_drive_t *drive, const u8 speed)
 
 		set_indexed_reg(hwif, 0x10 + adj, tmp & 0x7f);
  	}
-
-	return err;
 }
 
 static void pdcnew_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	(void)pdcnew_tune_chipset(drive, XFER_PIO_0 + pio);
+	pdcnew_set_mode(drive, XFER_PIO_0 + pio);
 }
 
 static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
@@ -490,9 +485,9 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 	hwif->autodma = 0;
 
 	hwif->set_pio_mode = &pdcnew_set_pio_mode;
+	hwif->set_dma_mode = &pdcnew_set_mode;
 
 	hwif->quirkproc = &pdcnew_quirkproc;
-	hwif->speedproc = &pdcnew_tune_chipset;
 	hwif->resetproc = &pdcnew_reset;
 
 	hwif->err_stops_fifo = 1;
@@ -583,6 +578,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.bootable	= OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x3f, /* udma0-5 */
+		.host_flags	= IDE_HFLAG_POST_SET_MODE,
 	},{	/* 1 */
 		.name		= "PDC20269",
 		.init_setup	= init_setup_pdcnew,
@@ -592,6 +588,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.bootable	= OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
+		.host_flags	= IDE_HFLAG_POST_SET_MODE,
 	},{	/* 2 */
 		.name		= "PDC20270",
 		.init_setup	= init_setup_pdc20270,
@@ -601,6 +598,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.bootable	= OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x3f, /* udma0-5 */
+		.host_flags	= IDE_HFLAG_POST_SET_MODE,
 	},{	/* 3 */
 		.name		= "PDC20271",
 		.init_setup	= init_setup_pdcnew,
@@ -610,6 +608,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.bootable	= OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
+		.host_flags	= IDE_HFLAG_POST_SET_MODE,
 	},{	/* 4 */
 		.name		= "PDC20275",
 		.init_setup	= init_setup_pdcnew,
@@ -619,6 +618,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.bootable	= OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
+		.host_flags	= IDE_HFLAG_POST_SET_MODE,
 	},{	/* 5 */
 		.name		= "PDC20276",
 		.init_setup	= init_setup_pdc20276,
@@ -628,6 +628,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.bootable	= OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
+		.host_flags	= IDE_HFLAG_POST_SET_MODE,
 	},{	/* 6 */
 		.name		= "PDC20277",
 		.init_setup	= init_setup_pdcnew,
@@ -637,6 +638,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.bootable	= OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= 0x7f, /* udma0-6*/
+		.host_flags	= IDE_HFLAG_POST_SET_MODE,
 	}
 };
 
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index b578307..8c3e8cf 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -63,7 +63,7 @@ static const char *pdc_quirk_drives[] = {
 
 static void pdc_old_disable_66MHz_clock(ide_hwif_t *);
 
-static int pdc202xx_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -138,13 +138,11 @@ static int pdc202xx_tune_chipset(ide_drive_t *drive, const u8 speed)
 	pci_read_config_dword(dev, drive_pci, &drive_conf);
 	printk("0x%08x\n", drive_conf);
 #endif
-
-	return ide_config_drive_speed(drive, speed);
 }
 
 static void pdc202xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	pdc202xx_tune_chipset(drive, XFER_PIO_0 + pio);
+	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
 static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
@@ -330,14 +328,13 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 	hwif->autodma = 0;
 
 	hwif->set_pio_mode = &pdc202xx_set_pio_mode;
+	hwif->set_dma_mode = &pdc202xx_set_mode;
 
 	hwif->quirkproc = &pdc202xx_quirkproc;
 
 	if (hwif->pci_dev->device != PCI_DEVICE_ID_PROMISE_20246)
 		hwif->resetproc = &pdc202xx_reset;
 
-	hwif->speedproc = &pdc202xx_tune_chipset;
-
 	hwif->err_stops_fifo = 1;
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index fd8214a..38c91ba 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -137,13 +137,14 @@ static u8 piix_dma_2_pio (u8 xfer_rate) {
 }
 
 /**
- *	piix_tune_pio		-	tune PIIX for PIO mode
- *	@drive: drive to tune
- *	@pio: desired PIO mode
+ *	piix_set_pio_mode	-	set host controller for PIO mode
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
  *	Set the interface PIO mode based upon the settings done by AMI BIOS.
  */
-static void piix_tune_pio (ide_drive_t *drive, u8 pio)
+
+static void piix_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -204,31 +205,15 @@ static void piix_tune_pio (ide_drive_t *drive, u8 pio)
 }
 
 /**
- *	piix_set_pio_mode	-	set PIO mode
- *	@drive: drive to tune
- *	@pio: desired PIO mode
- *
- *	Set the drive's PIO mode (might be useful if drive is not registered
- *	in CMOS for any reason).
- */
-
-static void piix_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	piix_tune_pio(drive, pio);
-	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
-
-/**
- *	piix_tune_chipset	-	tune a PIIX interface
- *	@drive: IDE drive to tune
- *	@speed: speed to configure
+ *	piix_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@speed: DMA mode
  *
- *	Set a PIIX interface channel to the desired speeds. This involves
- *	requires the right timing data into the PIIX configuration space
- *	then setting the drive parameters appropriately
+ *	Set a PIIX host controller to the desired DMA mode.  This involves
+ *	programming the right timing data into the PCI configuration space.
  */
 
-static int piix_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void piix_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -259,7 +244,7 @@ static int piix_tune_chipset(ide_drive_t *drive, const u8 speed)
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_SW_DMA_2:	break;
-		default:		return -1;
+		default:		return;
 	}
 
 	if (speed >= XFER_UDMA_0) {
@@ -288,9 +273,7 @@ static int piix_tune_chipset(ide_drive_t *drive, const u8 speed)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 	}
 
-	piix_tune_pio(drive, piix_dma_2_pio(speed));
-
-	return ide_config_drive_speed(drive, speed);
+	piix_set_pio_mode(drive, piix_dma_2_pio(speed));
 }
 
 /**
@@ -448,7 +431,8 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 	hwif->autodma = 0;
 
 	hwif->set_pio_mode = &piix_set_pio_mode;
-	hwif->speedproc = &piix_tune_chipset;
+	hwif->set_dma_mode = &piix_set_dma_mode;
+
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
 
diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 79ecab6..ee0e3f5 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -68,17 +68,6 @@ static unsigned short sc1200_get_pci_clock (void)
 	return pci_clock;
 }
 
-extern char *ide_xfer_verbose (byte xfer_rate);
-
-/*
- * Set a new transfer mode at the drive
- */
-static int sc1200_set_xfer_mode (ide_drive_t *drive, byte mode)
-{
-	printk("%s: sc1200_set_xfer_mode(%s)\n", drive->name, ide_xfer_verbose(mode));
-	return ide_config_drive_speed(drive, mode);
-}
-
 /*
  * Here are the standard PIO mode 0-4 timings for each "format".
  * Format-0 uses fast data reg timings, with slower command reg timings.
@@ -138,7 +127,7 @@ out:
 	return mask;
 }
 
-static int sc1200_tune_chipset(ide_drive_t *drive, const u8 mode)
+static void sc1200_set_dma_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t		*hwif = HWIF(drive);
 	int			unit = drive->select.b.unit;
@@ -146,17 +135,9 @@ static int sc1200_tune_chipset(ide_drive_t *drive, const u8 mode)
 	unsigned short		pci_clock;
 	unsigned int		basereg = hwif->channel ? 0x50 : 0x40;
 
-	/*
-	 * Tell the drive to switch to the new mode; abort on failure.
-	 */
-	if (sc1200_set_xfer_mode(drive, mode))
-		return 1;	/* failure */
-
 	pci_clock = sc1200_get_pci_clock();
 
 	/*
-	 * Now tune the chipset to match the drive:
-	 *
 	 * Note that each DMA mode has several timings associated with it.
 	 * The correct timing depends on the fast PCI clock freq.
 	 */
@@ -216,8 +197,6 @@ static int sc1200_tune_chipset(ide_drive_t *drive, const u8 mode)
 	} else {
 		pci_write_config_dword(hwif->pci_dev, basereg+12, timings);
 	}
-
-	return 0;	/* success */
 }
 
 /*
@@ -286,13 +265,12 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	if (mode != -1) {
 		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
 		hwif->dma_off_quietly(drive);
-		if (sc1200_tune_chipset(drive, mode) == 0)
+		if (ide_set_dma_mode(drive, mode) == 0)
 			hwif->dma_host_on(drive);
 		return;
 	}
 
-	if (sc1200_set_xfer_mode(drive, XFER_PIO_0 + pio) == 0)
-		sc1200_tunepio(drive, pio);
+	sc1200_tunepio(drive, pio);
 }
 
 #ifdef CONFIG_PM
@@ -400,16 +378,20 @@ static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
 	if (hwif->mate)
 		hwif->serialized = hwif->mate->serialized = 1;
 	hwif->autodma = 0;
-	if (hwif->dma_base) {
-		hwif->udma_filter = sc1200_udma_filter;
-		hwif->ide_dma_check = &sc1200_config_dma;
-		hwif->ide_dma_end   = &sc1200_ide_dma_end;
-        	if (!noautodma)
-                	hwif->autodma = 1;
-
-		hwif->set_pio_mode = &sc1200_set_pio_mode;
-		hwif->speedproc = &sc1200_tune_chipset;
-	}
+
+	hwif->set_pio_mode = &sc1200_set_pio_mode;
+	hwif->set_dma_mode = &sc1200_set_dma_mode;
+
+	if (hwif->dma_base == 0)
+		return;
+
+	hwif->udma_filter = sc1200_udma_filter;
+	hwif->ide_dma_check = &sc1200_config_dma;
+	hwif->ide_dma_end   = &sc1200_ide_dma_end;
+
+	if (!noautodma)
+		hwif->autodma = 1;
+
         hwif->atapi_dma = 1;
         hwif->ultra_mask = 0x07;
         hwif->mwdma_mask = 0x07;
@@ -423,7 +405,7 @@ static ide_pci_device_t sc1200_chipset __devinitdata = {
 	.init_hwif	= init_hwif_sc1200,
 	.autodma	= AUTODMA,
 	.bootable	= ON_BOARD,
-	.host_flags	= IDE_HFLAG_ABUSE_DMA_MODES,
+	.host_flags	= IDE_HFLAG_ABUSE_DMA_MODES | IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
 };
 
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 66a526e..67f06dd 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -190,15 +190,15 @@ scc_ide_outsl(unsigned long port, void *addr, u32 count)
 }
 
 /**
- *	scc_tune_pio	-	tune a drive PIO mode
- *	@drive: drive to tune
- *	@mode_wanted: the target operating mode
+ *	scc_set_pio_mode	-	set host controller for PIO mode
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
  *	Load the timing settings for this device mode into the
  *	controller.
  */
 
-static void scc_tune_pio(ide_drive_t *drive, const u8 pio)
+static void scc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
@@ -221,22 +221,16 @@ static void scc_tune_pio(ide_drive_t *drive, const u8 pio)
 	out_be32((void __iomem *)pioct_port, reg);
 }
 
-static void scc_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	scc_tune_pio(drive, pio);
-	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
-
 /**
- *	scc_tune_chipset	-	tune a drive DMA mode
- *	@drive: Drive to set up
- *	@speed: speed we want to achieve
+ *	scc_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@speed: DMA mode
  *
  *	Load the timing settings for this device mode into the
  *	controller.
  */
 
-static int scc_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void scc_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
@@ -271,7 +265,7 @@ static int scc_tune_chipset(ide_drive_t *drive, const u8 speed)
 		idx = speed - XFER_UDMA_0;
 		break;
 	default:
-		return 1;
+		return;
 	}
 
 	jcactsel = JCACTSELtbl[offset][idx];
@@ -287,8 +281,6 @@ static int scc_tune_chipset(ide_drive_t *drive, const u8 speed)
 	}
 	reg = JCTSStbl[offset][idx] << 16 | JCENVTtbl[offset][idx];
 	out_be32((void __iomem *)udenvt_port, reg);
-
-	return ide_config_drive_speed(drive, speed);
 }
 
 /**
@@ -708,8 +700,8 @@ static void __devinit init_hwif_scc(ide_hwif_t *hwif)
 
 	hwif->dma_setup = scc_dma_setup;
 	hwif->ide_dma_end = scc_ide_dma_end;
-	hwif->speedproc = scc_tune_chipset;
 	hwif->set_pio_mode = scc_set_pio_mode;
+	hwif->set_dma_mode = scc_set_dma_mode;
 	hwif->ide_dma_check = scc_config_drive_for_dma;
 	hwif->ide_dma_test_irq = scc_dma_test_irq;
 	hwif->udma_filter = scc_udma_filter;
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index 0351cf2..49ec0ac 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -124,7 +124,7 @@ static u8 svwks_csb_check (struct pci_dev *dev)
 	return 0;
 }
 
-static void svwks_tune_pio(ide_drive_t *drive, const u8 pio)
+static void svwks_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	static const u8 pio_modes[] = { 0x5d, 0x47, 0x34, 0x22, 0x20 };
 	static const u8 drive_pci[] = { 0x41, 0x40, 0x43, 0x42 };
@@ -145,7 +145,7 @@ static void svwks_tune_pio(ide_drive_t *drive, const u8 pio)
 	}
 }
 
-static int svwks_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void svwks_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	static const u8 udma_modes[]		= { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05 };
 	static const u8 dma_modes[]		= { 0x77, 0x21, 0x20 };
@@ -193,14 +193,6 @@ static int svwks_tune_chipset(ide_drive_t *drive, const u8 speed)
 	pci_write_config_byte(dev, drive_pci2[drive->dn], dma_timing);
 	pci_write_config_byte(dev, (0x56|hwif->channel), ultra_timing);
 	pci_write_config_byte(dev, 0x54, ultra_enable);
-
-	return (ide_config_drive_speed(drive, speed));
-}
-
-static void svwks_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	svwks_tune_pio(drive, pio);
-	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 static int svwks_config_drive_xfer_rate (ide_drive_t *drive)
@@ -384,7 +376,7 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 		hwif->irq = hwif->channel ? 15 : 14;
 
 	hwif->set_pio_mode = &svwks_set_pio_mode;
-	hwif->speedproc = &svwks_tune_chipset;
+	hwif->set_dma_mode = &svwks_set_dma_mode;
 	hwif->udma_filter = &svwks_udma_filter;
 
 	hwif->atapi_dma = 1;
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index c292e1d..85ffaaa 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -291,12 +291,8 @@ static void sgiioc4_dma_off_quietly(ide_drive_t *drive)
 	drive->hwif->dma_host_off(drive);
 }
 
-static int sgiioc4_speedproc(ide_drive_t *drive, const u8 speed)
+static void sgiioc4_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
-	if (speed != XFER_MW_DMA_2)
-		return 1;
-
-	return ide_config_drive_speed(drive, speed);
 }
 
 static int sgiioc4_ide_dma_check(ide_drive_t *drive)
@@ -591,11 +587,9 @@ static void __devinit
 ide_init_sgiioc4(ide_hwif_t * hwif)
 {
 	hwif->mmio = 1;
-	hwif->atapi_dma = 1;
-	hwif->mwdma_mask = 0x04;
 	hwif->pio_mask = 0x00;
 	hwif->set_pio_mode = NULL; /* Sets timing for PIO mode */
-	hwif->speedproc = &sgiioc4_speedproc;
+	hwif->set_dma_mode = &sgiioc4_set_dma_mode;
 	hwif->selectproc = NULL;/* Use the default routine to select drive */
 	hwif->reset_poll = NULL;/* No HBA specific reset_poll needed */
 	hwif->pre_reset = NULL;	/* No HBA specific pre_set needed */
@@ -606,6 +600,14 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->quirkproc = NULL;
 	hwif->busproc = NULL;
 
+	hwif->INB = &sgiioc4_INB;
+
+	if (hwif->dma_base == 0)
+		return;
+
+	hwif->atapi_dma = 1;
+	hwif->mwdma_mask = 0x04;
+
 	hwif->dma_setup = &sgiioc4_ide_dma_setup;
 	hwif->dma_start = &sgiioc4_ide_dma_start;
 	hwif->ide_dma_end = &sgiioc4_ide_dma_end;
@@ -617,8 +619,6 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->dma_host_off = &sgiioc4_dma_host_off;
 	hwif->dma_lost_irq = &sgiioc4_dma_lost_irq;
 	hwif->dma_timeout = &ide_dma_timeout;
-
-	hwif->INB = &sgiioc4_INB;
 }
 
 static int __devinit
@@ -688,8 +688,6 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	ide_init_sgiioc4(hwif);
-
 	hwif->autodma = 0;
 
 	if (dma_base && ide_dma_sgiioc4(hwif, dma_base) == 0) {
@@ -699,6 +697,8 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 		printk(KERN_INFO "%s: %s Bus-Master DMA disabled\n",
 				 hwif->name, DRV_NAME);
 
+	ide_init_sgiioc4(hwif);
+
 	if (probe_hwif_init(hwif))
 		return -EIO;
 
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 5d1e5e5..ce77849 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -165,16 +165,16 @@ out:
 }
 
 /**
- *	sil_tune_pio	-	tune a drive
- *	@drive: drive to tune
- *	@pio: the desired PIO mode
+ *	sil_set_pio_mode	-	set host controller for PIO mode
+ *	@drive: drive
+ *	@pio: PIO mode number
  *
  *	Load the timing settings for this device mode into the
  *	controller. If we are in PIO mode 3 or 4 turn on IORDY
  *	monitoring (bit 9). The TF timing is bits 31:16
  */
 
-static void sil_tune_pio(ide_drive_t *drive, u8 pio)
+static void sil_set_pio_mode(ide_drive_t *drive, u8 pio)
 {
 	const u16 tf_speed[]	= { 0x328a, 0x2283, 0x1281, 0x10c3, 0x10c1 };
 	const u16 data_speed[]	= { 0x328a, 0x2283, 0x1104, 0x10c3, 0x10c1 };
@@ -234,21 +234,15 @@ static void sil_tune_pio(ide_drive_t *drive, u8 pio)
 	}
 }
 
-static void sil_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	sil_tune_pio(drive, pio);
-	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
-
 /**
- *	siimage_tune_chipset	-	set controller timings
- *	@drive: Drive to set up
- *	@speed: speed we want to achieve
+ *	sil_set_dma_mode	-	set host controller for DMA mode
+ *	@drive: drive
+ *	@speed: DMA mode
  *
- *	Tune the SII chipset for the desired mode.
+ *	Tune the SiI chipset for the desired DMA mode.
  */
 
-static int siimage_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void sil_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	u8 ultra6[]		= { 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 };
 	u8 ultra5[]		= { 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01 };
@@ -303,7 +297,7 @@ static int siimage_tune_chipset(ide_drive_t *drive, const u8 speed)
 			mode |= ((unit) ? 0x30 : 0x03);
 			break;
 		default:
-			return 1;
+			return;
 	}
 
 	if (hwif->mmio) {
@@ -315,7 +309,6 @@ static int siimage_tune_chipset(ide_drive_t *drive, const u8 speed)
 		pci_write_config_word(hwif->pci_dev, ma, multi);
 		pci_write_config_word(hwif->pci_dev, ua, ultra);
 	}
-	return (ide_config_drive_speed(drive, speed));
 }
 
 /**
@@ -904,8 +897,8 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 	hwif->autodma = 0;
 	
 	hwif->resetproc = &siimage_reset;
-	hwif->speedproc = &siimage_tune_chipset;
 	hwif->set_pio_mode = &sil_set_pio_mode;
+	hwif->set_dma_mode = &sil_set_dma_mode;
 	hwif->reset_poll = &siimage_reset_poll;
 	hwif->pre_reset = &siimage_pre_reset;
 	hwif->udma_filter = &sil_udma_filter;
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 3e18899..b375ee5 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -451,7 +451,7 @@ static void config_drive_art_rwp (ide_drive_t *drive)
 }
 
 /* Set per-drive active and recovery time */
-static void config_art_rwp_pio (ide_drive_t *drive, u8 pio)
+static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -519,20 +519,14 @@ static void config_art_rwp_pio (ide_drive_t *drive, u8 pio)
 	}
 }
 
-static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	config_art_rwp_pio(drive, pio);
-	(void)ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
-
-static int sis5513_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void sis_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u32 regdw;
 	u8 drive_pci, reg;
 
-	/* See config_art_rwp_pio for drive pci config registers */
+	/* See sis_set_pio_mode() for drive PCI config registers */
 	drive_pci = 0x40;
 	if (chipset_family >= ATA_133) {
 		u32 reg54h;
@@ -600,8 +594,6 @@ static int sis5513_tune_chipset(ide_drive_t *drive, const u8 speed)
 			BUG();
 			break;
 	}
-
-	return ide_config_drive_speed(drive, speed);
 }
 
 static int sis5513_config_xfer_rate(ide_drive_t *drive)
@@ -841,7 +833,7 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 		hwif->irq = hwif->channel ? 15 : 14;
 
 	hwif->set_pio_mode = &sis_set_pio_mode;
-	hwif->speedproc = &sis5513_tune_chipset;
+	hwif->set_dma_mode = &sis_set_dma_mode;
 
 	if (chipset_family >= ATA_133)
 		hwif->udma_filter = sis5513_ata133_udma_filter;
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index f492318..2ef26e3 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -75,7 +75,7 @@ static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 /*
  * Configure the chipset for PIO mode.
  */
-static void sl82c105_tune_pio(ide_drive_t *drive, const u8 pio)
+static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	struct pci_dev *dev	= HWIF(drive)->pci_dev;
 	int reg			= 0x44 + drive->dn * 4;
@@ -105,9 +105,9 @@ static void sl82c105_tune_pio(ide_drive_t *drive, const u8 pio)
 }
 
 /*
- * Configure the drive and chipset for a new transfer speed.
+ * Configure the chipset for DMA mode.
  */
-static int sl82c105_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void sl82c105_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	static u16 mwdma_timings[] = {0x0707, 0x0201, 0x0200};
 	u16 drv_ctrl;
@@ -140,10 +140,8 @@ static int sl82c105_tune_chipset(ide_drive_t *drive, const u8 speed)
 		}
 		break;
 	default:
-		return -1;
+		return;
 	}
-
-	return ide_config_drive_speed(drive, speed);
 }
 
 /*
@@ -306,17 +304,6 @@ static void sl82c105_resetproc(ide_drive_t *drive)
 	pci_read_config_dword(dev, 0x40, &val);
 	pci_set_drvdata(dev, (void *)val);
 }
-	
-/*
- * We only deal with PIO mode here - DMA mode 'using_dma' is not
- * initialised at the point that this function is called.
- */
-static void sl82c105_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	sl82c105_tune_pio(drive, pio);
-
-	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
 
 /*
  * Return the revision of the Winbond bridge
@@ -383,7 +370,7 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
 
 	hwif->set_pio_mode	= &sl82c105_set_pio_mode;
-	hwif->speedproc 	= &sl82c105_tune_chipset;
+	hwif->set_dma_mode	= &sl82c105_set_dma_mode;
 	hwif->selectproc	= &sl82c105_selectproc;
 	hwif->resetproc 	= &sl82c105_resetproc;
 
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index ae8e913..ebac87f 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -42,7 +42,7 @@ static u8 slc90e66_dma_2_pio (u8 xfer_rate) {
 	}
 }
 
-static void slc90e66_tune_pio (ide_drive_t *drive, u8 pio)
+static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -95,13 +95,7 @@ static void slc90e66_tune_pio (ide_drive_t *drive, u8 pio)
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
-static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	slc90e66_tune_pio(drive, pio);
-	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
-}
-
-static int slc90e66_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void slc90e66_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -125,7 +119,7 @@ static int slc90e66_tune_chipset(ide_drive_t *drive, const u8 speed)
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_SW_DMA_2:	break;
-		default:		return -1;
+		default:		return;
 	}
 
 	if (speed >= XFER_UDMA_0) {
@@ -144,9 +138,7 @@ static int slc90e66_tune_chipset(ide_drive_t *drive, const u8 speed)
 			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
 	}
 
-	slc90e66_tune_pio(drive, slc90e66_dma_2_pio(speed));
-
-	return ide_config_drive_speed(drive, speed);
+	slc90e66_set_pio_mode(drive, slc90e66_dma_2_pio(speed));
 }
 
 static int slc90e66_config_drive_xfer_rate (ide_drive_t *drive)
@@ -172,8 +164,8 @@ static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
 	if (!hwif->irq)
 		hwif->irq = hwif->channel ? 15 : 14;
 
-	hwif->speedproc = &slc90e66_tune_chipset;
 	hwif->set_pio_mode = &slc90e66_set_pio_mode;
+	hwif->set_dma_mode = &slc90e66_set_dma_mode;
 
 	pci_read_config_byte(hwif->pci_dev, 0x47, &reg47);
 
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index e23b9cf..840415d 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -13,7 +13,7 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
-static int tc86c001_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long scr_port	= hwif->config_data + (drive->dn ? 0x02 : 0x00);
@@ -39,13 +39,11 @@ static int tc86c001_tune_chipset(ide_drive_t *drive, const u8 speed)
 	scr &= (speed < XFER_MW_DMA_0) ? 0xf8ff : 0xff0f;
 	scr |= mode;
 	outw(scr, scr_port);
-
-	return ide_config_drive_speed(drive, speed);
 }
 
 static void tc86c001_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	(void) tc86c001_tune_chipset(drive, XFER_PIO_0 + pio);
+	tc86c001_set_mode(drive, XFER_PIO_0 + pio);
 }
 
 /*
@@ -193,7 +191,8 @@ static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 	hwif->config_data = sc_base;
 
 	hwif->set_pio_mode = &tc86c001_set_pio_mode;
-	hwif->speedproc = &tc86c001_tune_chipset;
+	hwif->set_dma_mode = &tc86c001_set_mode;
+
 	hwif->busproc	= &tc86c001_busproc;
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index c3ff066..54e411d 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -40,7 +40,7 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 
-static int triflex_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void triflex_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct pci_dev *dev = hwif->pci_dev;
@@ -82,20 +82,18 @@ static int triflex_tune_chipset(ide_drive_t *drive, const u8 speed)
 			timing = 0x0808;
 			break;
 		default:
-			return -1;
+			return;
 	}
 
 	triflex_timings &= ~(0xFFFF << (16 * unit));
 	triflex_timings |= (timing << (16 * unit));
 	
 	pci_write_config_dword(dev, channel_offset, triflex_timings);
-	
-	return (ide_config_drive_speed(drive, speed));
 }
 
 static void triflex_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	(void)triflex_tune_chipset(drive, XFER_PIO_0 + pio);
+	triflex_set_mode(drive, XFER_PIO_0 + pio);
 }
 
 static int triflex_config_drive_xfer_rate(ide_drive_t *drive)
@@ -111,7 +109,7 @@ static int triflex_config_drive_xfer_rate(ide_drive_t *drive)
 static void __devinit init_hwif_triflex(ide_hwif_t *hwif)
 {
 	hwif->set_pio_mode = &triflex_set_pio_mode;
-	hwif->speedproc = &triflex_tune_chipset;
+	hwif->set_dma_mode = &triflex_set_mode;
 
 	if (hwif->dma_base == 0)
 		return;
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 378feb4..479e496 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,6 +1,6 @@
 /*
  *
- * Version 3.48
+ * Version 3.49
  *
  * VIA IDE driver for Linux. Supported southbridges:
  *
@@ -153,21 +153,17 @@ static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
  *	@drive: Drive to set up
  *	@speed: desired speed
  *
- *	via_set_drive() computes timing values configures the drive and
- *	the chipset to a desired transfer mode. It also can be called
- *	by upper layers.
+ *	via_set_drive() computes timing values configures the chipset to
+ *	a desired transfer mode.  It also can be called by upper layers.
  */
 
-static int via_set_drive(ide_drive_t *drive, const u8 speed)
+static void via_set_drive(ide_drive_t *drive, const u8 speed)
 {
 	ide_drive_t *peer = HWIF(drive)->drives + (~drive->dn & 1);
 	struct via82cxxx_dev *vdev = pci_get_drvdata(drive->hwif->pci_dev);
 	struct ide_timing t, p;
 	unsigned int T, UT;
 
-	if (speed != XFER_PIO_SLOW)
-		ide_config_drive_speed(drive, speed);
-
 	T = 1000000000 / via_clock;
 
 	switch (vdev->via_config->udma_mask) {
@@ -186,16 +182,10 @@ static int via_set_drive(ide_drive_t *drive, const u8 speed)
 	}
 
 	via_set_speed(HWIF(drive), drive->dn, &t);
-
-	if (!drive->init_speed)
-		drive->init_speed = speed;
-	drive->current_speed = speed;
-
-	return 0;
 }
 
 /**
- *	via_set_pio_mode	-	PIO setup
+ *	via_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
  *	@pio: PIO mode number
  *
@@ -456,8 +446,7 @@ static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 	hwif->autodma = 0;
 
 	hwif->set_pio_mode = &via_set_pio_mode;
-	hwif->speedproc = &via_set_drive;
-
+	hwif->set_dma_mode = &via_set_drive;
 
 #ifdef CONFIG_PPC_CHRP
 	if(machine_is(chrp) && _chrp_type == _CHRP_Pegasos) {
@@ -500,7 +489,8 @@ static ide_pci_device_t via82cxxx_chipsets[] __devinitdata = {
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},
 		.bootable	= ON_BOARD,
 		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST
-				| IDE_HFLAG_PIO_NO_DOWNGRADE,
+				| IDE_HFLAG_PIO_NO_DOWNGRADE
+				| IDE_HFLAG_POST_SET_MODE,
 		.pio_mask	= ATA_PIO5,
 	},{	/* 1 */
 		.name		= "VP_IDE",
@@ -510,7 +500,8 @@ static ide_pci_device_t via82cxxx_chipsets[] __devinitdata = {
 		.enablebits	= {{0x00,0x00,0x00}, {0x00,0x00,0x00}},
 		.bootable	= ON_BOARD,
 		.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST
-				| IDE_HFLAG_PIO_NO_DOWNGRADE,
+				| IDE_HFLAG_PIO_NO_DOWNGRADE
+				| IDE_HFLAG_POST_SET_MODE,
 		.pio_mask	= ATA_PIO5,
 	}
 };
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index f759a53..7d88738 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -392,6 +392,7 @@ kauai_lookup_timing(struct kauai_timing* table, int cycle_time)
 	for (i=0; table[i].cycle_time; i++)
 		if (cycle_time > table[i+1].cycle_time)
 			return table[i].timing_reg;
+	BUG();
 	return 0;
 }
 
@@ -529,97 +530,12 @@ pmac_outbsync(ide_drive_t *drive, u8 value, unsigned long port)
 }
 
 /*
- * Send the SET_FEATURE IDE command to the drive and update drive->id with
- * the new state. We currently don't use the generic routine as it used to
- * cause various trouble, especially with older mediabays.
- * This code is sometimes triggering a spurrious interrupt though, I need
- * to sort that out sooner or later and see if I can finally get the
- * common version to work properly in all cases
- */
-static int
-pmac_ide_do_setfeature(ide_drive_t *drive, u8 command)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-	int result = 1;
-	
-	disable_irq_nosync(hwif->irq);
-	udelay(1);
-	SELECT_DRIVE(drive);
-	SELECT_MASK(drive, 0);
-	udelay(1);
-	/* Get rid of pending error state */
-	(void) hwif->INB(IDE_STATUS_REG);
-	/* Timeout bumped for some powerbooks */
-	if (wait_for_ready(drive, 2000)) {
-		/* Timeout bumped for some powerbooks */
-		printk(KERN_ERR "%s: pmac_ide_do_setfeature disk not ready "
-			"before SET_FEATURE!\n", drive->name);
-		goto out;
-	}
-	udelay(10);
-	hwif->OUTB(drive->ctl | 2, IDE_CONTROL_REG);
-	hwif->OUTB(command, IDE_NSECTOR_REG);
-	hwif->OUTB(SETFEATURES_XFER, IDE_FEATURE_REG);
-	hwif->OUTBSYNC(drive, WIN_SETFEATURES, IDE_COMMAND_REG);
-	udelay(1);
-	/* Timeout bumped for some powerbooks */
-	result = wait_for_ready(drive, 2000);
-	hwif->OUTB(drive->ctl, IDE_CONTROL_REG);
-	if (result)
-		printk(KERN_ERR "%s: pmac_ide_do_setfeature disk not ready "
-			"after SET_FEATURE !\n", drive->name);
-out:
-	SELECT_MASK(drive, 0);
-	if (result == 0) {
-		drive->id->dma_ultra &= ~0xFF00;
-		drive->id->dma_mword &= ~0x0F00;
-		drive->id->dma_1word &= ~0x0F00;
-		switch(command) {
-			case XFER_UDMA_7:
-				drive->id->dma_ultra |= 0x8080; break;
-			case XFER_UDMA_6:
-				drive->id->dma_ultra |= 0x4040; break;
-			case XFER_UDMA_5:
-				drive->id->dma_ultra |= 0x2020; break;
-			case XFER_UDMA_4:
-				drive->id->dma_ultra |= 0x1010; break;
-			case XFER_UDMA_3:
-				drive->id->dma_ultra |= 0x0808; break;
-			case XFER_UDMA_2:
-				drive->id->dma_ultra |= 0x0404; break;
-			case XFER_UDMA_1:
-				drive->id->dma_ultra |= 0x0202; break;
-			case XFER_UDMA_0:
-				drive->id->dma_ultra |= 0x0101; break;
-			case XFER_MW_DMA_2:
-				drive->id->dma_mword |= 0x0404; break;
-			case XFER_MW_DMA_1:
-				drive->id->dma_mword |= 0x0202; break;
-			case XFER_MW_DMA_0:
-				drive->id->dma_mword |= 0x0101; break;
-			case XFER_SW_DMA_2:
-				drive->id->dma_1word |= 0x0404; break;
-			case XFER_SW_DMA_1:
-				drive->id->dma_1word |= 0x0202; break;
-			case XFER_SW_DMA_0:
-				drive->id->dma_1word |= 0x0101; break;
-			default: break;
-		}
-		if (!drive->init_speed)
-			drive->init_speed = command;
-		drive->current_speed = command;
-	}
-	enable_irq(hwif->irq);
-	return result;
-}
-
-/*
  * Old tuning functions (called on hdparm -p), sets up drive PIO timings
  */
 static void
 pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	u32 *timings;
+	u32 *timings, t;
 	unsigned accessTicks, recTicks;
 	unsigned accessTime, recTime;
 	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
@@ -630,6 +546,7 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		
 	/* which drive is it ? */
 	timings = &pmif->timings[drive->select.b.unit & 0x01];
+	t = *timings;
 
 	cycle_time = ide_pio_cycle_time(drive, pio);
 
@@ -637,18 +554,14 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	case controller_sh_ata6: {
 		/* 133Mhz cell */
 		u32 tr = kauai_lookup_timing(shasta_pio_timings, cycle_time);
-		if (tr == 0)
-			return;
-		*timings = ((*timings) & ~TR_133_PIOREG_PIO_MASK) | tr;
+		t = (t & ~TR_133_PIOREG_PIO_MASK) | tr;
 		break;
 		}
 	case controller_un_ata6:
 	case controller_k2_ata6: {
 		/* 100Mhz cell */
 		u32 tr = kauai_lookup_timing(kauai_pio_timings, cycle_time);
-		if (tr == 0)
-			return;
-		*timings = ((*timings) & ~TR_100_PIOREG_PIO_MASK) | tr;
+		t = (t & ~TR_100_PIOREG_PIO_MASK) | tr;
 		break;
 		}
 	case controller_kl_ata4:
@@ -662,9 +575,9 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		accessTicks = min(accessTicks, 0x1fU);
 		recTicks = SYSCLK_TICKS_66(recTime);
 		recTicks = min(recTicks, 0x1fU);
-		*timings = ((*timings) & ~TR_66_PIO_MASK) |
-				(accessTicks << TR_66_PIO_ACCESS_SHIFT) |
-				(recTicks << TR_66_PIO_RECOVERY_SHIFT);
+		t = (t & ~TR_66_PIO_MASK) |
+			(accessTicks << TR_66_PIO_ACCESS_SHIFT) |
+			(recTicks << TR_66_PIO_RECOVERY_SHIFT);
 		break;
 	default: {
 		/* 33Mhz cell */
@@ -684,11 +597,11 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 			recTicks--; /* guess, but it's only for PIO0, so... */
 			ebit = 1;
 		}
-		*timings = ((*timings) & ~TR_33_PIO_MASK) |
+		t = (t & ~TR_33_PIO_MASK) |
 				(accessTicks << TR_33_PIO_ACCESS_SHIFT) |
 				(recTicks << TR_33_PIO_RECOVERY_SHIFT);
 		if (ebit)
-			*timings |= TR_33_PIO_E;
+			t |= TR_33_PIO_E;
 		break;
 		}
 	}
@@ -698,9 +611,7 @@ pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		drive->name, pio,  *timings);
 #endif	
 
-	if (pmac_ide_do_setfeature(drive, XFER_PIO_0 + pio))
-		return;
-
+	*timings = t;
 	pmac_ide_do_update_timings(drive);
 }
 
@@ -746,8 +657,6 @@ set_timings_udma_ata6(u32 *pio_timings, u32 *ultra_timings, u8 speed)
 	if (speed > XFER_UDMA_5 || t == NULL)
 		return 1;
 	tr = kauai_lookup_timing(kauai_udma_timings, (int)t->udma);
-	if (tr == 0)
-		return 1;
 	*ultra_timings = ((*ultra_timings) & ~TR_100_UDMAREG_UDMA_MASK) | tr;
 	*ultra_timings = (*ultra_timings) | TR_100_UDMAREG_UDMA_EN;
 
@@ -766,8 +675,6 @@ set_timings_udma_shasta(u32 *pio_timings, u32 *ultra_timings, u8 speed)
 	if (speed > XFER_UDMA_6 || t == NULL)
 		return 1;
 	tr = kauai_lookup_timing(shasta_udma133_timings, (int)t->udma);
-	if (tr == 0)
-		return 1;
 	*ultra_timings = ((*ultra_timings) & ~TR_133_UDMAREG_UDMA_MASK) | tr;
 	*ultra_timings = (*ultra_timings) | TR_133_UDMAREG_UDMA_EN;
 
@@ -777,12 +684,13 @@ set_timings_udma_shasta(u32 *pio_timings, u32 *ultra_timings, u8 speed)
 /*
  * Calculate MDMA timings for all cells
  */
-static int
+static void
 set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
-			u8 speed, int drive_cycle_time)
+		 	u8 speed)
 {
 	int cycleTime, accessTime = 0, recTime = 0;
 	unsigned accessTicks, recTicks;
+	struct hd_driveid *id = drive->id;
 	struct mdma_timings_t* tm = NULL;
 	int i;
 
@@ -792,11 +700,14 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 		case 1: cycleTime = 150; break;
 		case 2: cycleTime = 120; break;
 		default:
-			return 1;
+			BUG();
+			break;
 	}
-	/* Adjust for drive */
-	if (drive_cycle_time && drive_cycle_time > cycleTime)
-		cycleTime = drive_cycle_time;
+
+	/* Check if drive provides explicit DMA cycle time */
+	if ((id->field_valid & 2) && id->eide_dma_time)
+		cycleTime = max_t(int, id->eide_dma_time, cycleTime);
+
 	/* OHare limits according to some old Apple sources */	
 	if ((intf_type == controller_ohare) && (cycleTime < 150))
 		cycleTime = 150;
@@ -824,8 +735,6 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 				break;
 			i++;
 		}
-		if (i < 0)
-			return 1;
 		cycleTime = tm[i].cycleTime;
 		accessTime = tm[i].accessTime;
 		recTime = tm[i].recoveryTime;
@@ -839,8 +748,6 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 	case controller_sh_ata6: {
 		/* 133Mhz cell */
 		u32 tr = kauai_lookup_timing(shasta_mdma_timings, cycleTime);
-		if (tr == 0)
-			return 1;
 		*timings = ((*timings) & ~TR_133_PIOREG_MDMA_MASK) | tr;
 		*timings2 = (*timings2) & ~TR_133_UDMAREG_UDMA_EN;
 		}
@@ -848,8 +755,6 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 	case controller_k2_ata6: {
 		/* 100Mhz cell */
 		u32 tr = kauai_lookup_timing(kauai_mdma_timings, cycleTime);
-		if (tr == 0)
-			return 1;
 		*timings = ((*timings) & ~TR_100_PIOREG_MDMA_MASK) | tr;
 		*timings2 = (*timings2) & ~TR_100_UDMAREG_UDMA_EN;
 		}
@@ -911,30 +816,23 @@ set_timings_mdma(ide_drive_t *drive, int intf_type, u32 *timings, u32 *timings2,
 	printk(KERN_ERR "%s: Set MDMA timing for mode %d, reg: 0x%08x\n",
 		drive->name, speed & 0xf,  *timings);
 #endif	
-	return 0;
 }
 #endif /* #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC */
 
-/* 
- * Speedproc. This function is called by the core to set any of the standard
- * DMA timing (MDMA or UDMA) to both the drive and the controller.
- * You may notice we don't use this function on normal "dma check" operation,
- * our dedicated function is more precise as it uses the drive provided
- * cycle time value. We should probably fix this one to deal with that too...
- */
-static int pmac_ide_tune_chipset(ide_drive_t *drive, const u8 speed)
+static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 {
 	int unit = (drive->select.b.unit & 0x01);
 	int ret = 0;
 	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)HWIF(drive)->hwif_data;
-	u32 *timings, *timings2;
+	u32 *timings, *timings2, tl[2];
 
-	if (pmif == NULL)
-		return 1;
-		
 	timings = &pmif->timings[unit];
 	timings2 = &pmif->timings[unit+2];
-	
+
+	/* Copy timings to local image */
+	tl[0] = *timings;
+	tl[1] = *timings2;
+
 	switch(speed) {
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
 		case XFER_UDMA_6:
@@ -945,38 +843,36 @@ static int pmac_ide_tune_chipset(ide_drive_t *drive, const u8 speed)
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
 			if (pmif->kind == controller_kl_ata4)
-				ret = set_timings_udma_ata4(timings, speed);
+				ret = set_timings_udma_ata4(&tl[0], speed);
 			else if (pmif->kind == controller_un_ata6
 				 || pmif->kind == controller_k2_ata6)
-				ret = set_timings_udma_ata6(timings, timings2, speed);
+				ret = set_timings_udma_ata6(&tl[0], &tl[1], speed);
 			else if (pmif->kind == controller_sh_ata6)
-				ret = set_timings_udma_shasta(timings, timings2, speed);
+				ret = set_timings_udma_shasta(&tl[0], &tl[1], speed);
 			else
-				ret = 1;		
+				ret = 1;
 			break;
 		case XFER_MW_DMA_2:
 		case XFER_MW_DMA_1:
 		case XFER_MW_DMA_0:
-			ret = set_timings_mdma(drive, pmif->kind, timings, timings2, speed, 0);
+			set_timings_mdma(drive, pmif->kind, &tl[0], &tl[1], speed);
 			break;
 		case XFER_SW_DMA_2:
 		case XFER_SW_DMA_1:
 		case XFER_SW_DMA_0:
-			return 1;
+			return;
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 		default:
 			ret = 1;
 	}
 	if (ret)
-		return ret;
+		return;
 
-	ret = pmac_ide_do_setfeature(drive, speed);
-	if (ret)
-		return ret;
-		
-	pmac_ide_do_update_timings(drive);	
+	/* Apply timings to controller */
+	*timings = tl[0];
+	*timings2 = tl[1];
 
-	return 0;
+	pmac_ide_do_update_timings(drive);	
 }
 
 /*
@@ -1236,6 +1132,10 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 	hwif->drives[0].unmask = 1;
 	hwif->drives[1].unmask = 1;
+	hwif->drives[0].autotune = IDE_TUNE_AUTO;
+	hwif->drives[1].autotune = IDE_TUNE_AUTO;
+	hwif->host_flags = IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
+			   IDE_HFLAG_POST_SET_MODE;
 	hwif->pio_mask = ATA_PIO4;
 	hwif->set_pio_mode = pmac_ide_set_pio_mode;
 	if (pmif->kind == controller_un_ata6
@@ -1244,7 +1144,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 		hwif->selectproc = pmac_ide_kauai_selectproc;
 	else
 		hwif->selectproc = pmac_ide_selectproc;
-	hwif->speedproc = pmac_ide_tune_chipset;
+	hwif->set_dma_mode = pmac_ide_set_dma_mode;
 
 	printk(KERN_INFO "ide%d: Found Apple %s controller, bus ID %d%s, irq %d\n",
 	       hwif->index, model_name[pmif->kind], pmif->aapl_bus_id,
@@ -1679,138 +1579,16 @@ pmac_ide_destroy_dmatable (ide_drive_t *drive)
 }
 
 /*
- * Pick up best MDMA timing for the drive and apply it
- */
-static int
-pmac_ide_mdma_enable(ide_drive_t *drive, u16 mode)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
-	int drive_cycle_time;
-	struct hd_driveid *id = drive->id;
-	u32 *timings, *timings2;
-	u32 timing_local[2];
-	int ret;
-
-	/* which drive is it ? */
-	timings = &pmif->timings[drive->select.b.unit & 0x01];
-	timings2 = &pmif->timings[(drive->select.b.unit & 0x01) + 2];
-
-	/* Check if drive provide explicit cycle time */
-	if ((id->field_valid & 2) && (id->eide_dma_time))
-		drive_cycle_time = id->eide_dma_time;
-	else
-		drive_cycle_time = 0;
-
-	/* Copy timings to local image */
-	timing_local[0] = *timings;
-	timing_local[1] = *timings2;
-
-	/* Calculate controller timings */
-	ret = set_timings_mdma(	drive, pmif->kind,
-				&timing_local[0],
-				&timing_local[1],
-				mode,
-				drive_cycle_time);
-	if (ret)
-		return 0;
-
-	/* Set feature on drive */
-    	printk(KERN_INFO "%s: Enabling MultiWord DMA %d\n", drive->name, mode & 0xf);
-	ret = pmac_ide_do_setfeature(drive, mode);
-	if (ret) {
-	    	printk(KERN_WARNING "%s: Failed !\n", drive->name);
-	    	return 0;
-	}
-
-	/* Apply timings to controller */
-	*timings = timing_local[0];
-	*timings2 = timing_local[1];
-
-	return 1;
-}
-
-/*
- * Pick up best UDMA timing for the drive and apply it
- */
-static int
-pmac_ide_udma_enable(ide_drive_t *drive, u16 mode)
-{
-	ide_hwif_t *hwif = HWIF(drive);
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
-	u32 *timings, *timings2;
-	u32 timing_local[2];
-	int ret;
-		
-	/* which drive is it ? */
-	timings = &pmif->timings[drive->select.b.unit & 0x01];
-	timings2 = &pmif->timings[(drive->select.b.unit & 0x01) + 2];
-
-	/* Copy timings to local image */
-	timing_local[0] = *timings;
-	timing_local[1] = *timings2;
-	
-	/* Calculate timings for interface */
-	if (pmif->kind == controller_un_ata6
-	    || pmif->kind == controller_k2_ata6)
-		ret = set_timings_udma_ata6(	&timing_local[0],
-						&timing_local[1],
-						mode);
-	else if (pmif->kind == controller_sh_ata6)
-		ret = set_timings_udma_shasta(	&timing_local[0],
-						&timing_local[1],
-						mode);
-	else
-		ret = set_timings_udma_ata4(&timing_local[0], mode);
-	if (ret)
-		return 0;
-		
-	/* Set feature on drive */
-    	printk(KERN_INFO "%s: Enabling Ultra DMA %d\n", drive->name, mode & 0x0f);
-	ret = pmac_ide_do_setfeature(drive, mode);
-	if (ret) {
-		printk(KERN_WARNING "%s: Failed !\n", drive->name);
-		return 0;
-	}
-
-	/* Apply timings to controller */
-	*timings = timing_local[0];
-	*timings2 = timing_local[1];
-
-	return 1;
-}
-
-/*
  * Check what is the best DMA timing setting for the drive and
  * call appropriate functions to apply it.
  */
 static int
 pmac_ide_dma_check(ide_drive_t *drive)
 {
-	struct hd_driveid *id = drive->id;
-	ide_hwif_t *hwif = HWIF(drive);
-	int enable = 1;
-	drive->using_dma = 0;
-	
-	if (drive->media == ide_floppy)
-		enable = 0;
-	if (((id->capability & 1) == 0) && !__ide_dma_good_drive(drive))
-		enable = 0;
-	if (__ide_dma_bad_drive(drive))
-		enable = 0;
-
-	if (enable) {
-		u8 mode = ide_max_dma_mode(drive);
-
-		if (mode >= XFER_UDMA_0)
-			drive->using_dma = pmac_ide_udma_enable(drive, mode);
-		else if (mode >= XFER_MW_DMA_0)
-			drive->using_dma = pmac_ide_mdma_enable(drive, mode);
-		hwif->OUTB(0, IDE_CONTROL_REG);
-		/* Apply settings to controller */
-		pmac_ide_do_update_timings(drive);
-	}
-	return 0;
+	if (ide_tune_dma(drive))
+		return 0;
+
+	return -1;
 }
 
 /*
@@ -2044,7 +1822,10 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 			hwif->mwdma_mask = 0x07;
 			hwif->swdma_mask = 0x00;
 			break;
-	}	
+	}
+
+	hwif->autodma = 1;
+	hwif->drives[1].autodma = hwif->drives[0].autodma = hwif->autodma;
 }
 
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 85d448b..02a27e8 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -681,7 +681,7 @@ typedef struct hwif_s {
 	u8 straight8;	/* Alan's straight 8 check */
 	u8 bus_state;	/* power state of the IDE bus */
 
-	u8 host_flags;
+	u16 host_flags;
 
 	u8 pio_mask;
 
@@ -702,10 +702,10 @@ typedef struct hwif_s {
 #if 0
 	ide_hwif_ops_t	*hwifops;
 #else
-	/* routine to set PIO mode for drives */
+	/* routine to program host for PIO mode */
 	void	(*set_pio_mode)(ide_drive_t *, const u8);
-	/* routine to retune DMA modes for drives */
-	int	(*speedproc)(ide_drive_t *, const u8);
+	/* routine to program host for DMA mode */
+	void	(*set_dma_mode)(ide_drive_t *, const u8);
 	/* tweaks hardware to select drive */
 	void	(*selectproc)(ide_drive_t *);
 	/* chipset polling based on hba specifics */
@@ -1079,16 +1079,7 @@ extern void ide_fix_driveid(struct hd_driveid *);
  */
 extern void ide_fixstring(u8 *, const int, const int);
 
-/*
- * This routine busy-waits for the drive status to be not "busy".
- * It then checks the status for all of the "good" bits and none
- * of the "bad" bits, and if all is okay it returns 0.  All other
- * cases return 1 after doing "*startstop = ide_error()", and the
- * caller should return the updated value of "startstop" in this case.
- * "startstop" is unchanged when the function returns 0;
- * (startstop, drive, good, bad, timeout)
- */
-extern int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
+int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
 /*
  * Start a reset operation for an IDE interface.
@@ -1162,7 +1153,6 @@ extern void SELECT_MASK(ide_drive_t *, int);
 extern void QUIRK_LIST(ide_drive_t *);
 
 extern int drive_is_ready(ide_drive_t *);
-extern int wait_for_ready(ide_drive_t *, int /* timeout */);
 
 /*
  * taskfile io for disks for now...and builds request from ide_ioctl
@@ -1262,6 +1252,15 @@ enum {
 	IDE_HFLAG_ABUSE_FAST_DEVSEL	= (1 << 5),
 	/* use 100-102 and 200-202 PIO values to set DMA modes */
 	IDE_HFLAG_ABUSE_DMA_MODES	= (1 << 6),
+	/*
+	 * keep DMA setting when programming PIO mode, may be used only
+	 * for hosts which have separate PIO and DMA timings (ie. PMAC)
+	 */
+	IDE_HFLAG_SET_PIO_MODE_KEEP_DMA	= (1 << 7),
+	/* program host for the transfer mode after programming device */
+	IDE_HFLAG_POST_SET_MODE		= (1 << 8),
+	/* don't program host/device for the transfer mode ("smart" hosts) */
+	IDE_HFLAG_NO_SET_MODE		= (1 << 9),
 };
 
 typedef struct ide_pci_device_s {
@@ -1278,7 +1277,7 @@ typedef struct ide_pci_device_s {
 	u8			bootable;
 	unsigned int		extra;
 	struct ide_pci_device_s	*next;
-	u8			host_flags;
+	u16			host_flags;
 	u8			pio_mask;
 	u8			udma_mask;
 } ide_pci_device_t;
@@ -1301,7 +1300,6 @@ int ide_in_drive_list(struct hd_driveid *, const struct drive_list_entry *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 int __ide_dma_bad_drive(ide_drive_t *);
-int __ide_dma_good_drive(ide_drive_t *);
 
 u8 ide_find_dma_mode(ide_drive_t *, u8);
 
@@ -1420,6 +1418,9 @@ unsigned int ide_pio_cycle_time(ide_drive_t *, u8);
 u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
 extern const ide_pio_timings_t ide_pio_timings[6];
 
+int ide_set_pio_mode(ide_drive_t *, u8);
+int ide_set_dma_mode(ide_drive_t *, u8);
+
 void ide_set_pio(ide_drive_t *, u8);
 
 static inline void ide_set_max_pio(ide_drive_t *drive)
