Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYCIPt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYCIPt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYCIPtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:49:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11671 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYCIPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hHDyMN1JpGCyPP+wbLU+AkCp+rHglKTopxq+fdwc5TsBxyX33143baEwnDNCf5U3B2ygpebOqqz/EnpZg2rKZ0Kj+ja4CoGHTMNvvHvmvOOTtpvnI46oCudUQOXS/fHm1yxx0CNVLYBsQy4PVhvRnkV0KP9bYWub6dhceuAtgy0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] ide: add struct ide_dma_ops
Date: Sun, 9 Mar 2008 17:00:45 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091700.46136.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct ide_dma_ops and convert core code + drivers to use it.

While at it:

* Drop "ide_" prefix from ->ide_dma_end and ->ide_dma_test_irq methods.

* siimage.c:
  - add siimage_ide_dma_test_irq() helper
  - print SATA warning in siimage_init_one()

* Remove no longer needed ->init_hwif implementations.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c       |   24 ++++++---
 drivers/ide/arm/palm_bk3710.c  |    2 
 drivers/ide/cris/ide-cris.c    |   23 ++++-----
 drivers/ide/ide-cd.c           |    6 +-
 drivers/ide/ide-dma.c          |   59 +++++++++++++++---------
 drivers/ide/ide-floppy.c       |    6 +-
 drivers/ide/ide-io.c           |    8 +--
 drivers/ide/ide-iops.c         |   10 ++--
 drivers/ide/ide-probe.c        |    5 +-
 drivers/ide/ide-tape.c         |    6 +-
 drivers/ide/ide-taskfile.c     |    7 +-
 drivers/ide/ide.c              |    2 
 drivers/ide/mips/au1xxx-ide.c  |   31 ++++++------
 drivers/ide/pci/alim15x3.c     |   32 ++++---------
 drivers/ide/pci/cmd64x.c       |  100 +++++++++++++++++++----------------------
 drivers/ide/pci/cs5520.c       |   14 ++---
 drivers/ide/pci/hpt366.c       |   35 ++++++++------
 drivers/ide/pci/it821x.c       |    8 ++-
 drivers/ide/pci/ns87415.c      |    8 ++-
 drivers/ide/pci/pdc202xx_old.c |   35 ++++++--------
 drivers/ide/pci/sc1200.c       |   20 ++------
 drivers/ide/pci/scc_pata.c     |   11 ++--
 drivers/ide/pci/sgiioc4.c      |   26 ++++------
 drivers/ide/pci/siimage.c      |   68 ++++++++++++---------------
 drivers/ide/pci/sl82c105.c     |   27 +++--------
 drivers/ide/pci/tc86c001.c     |    7 ++
 drivers/ide/pci/trm290.c       |   16 ++++--
 drivers/ide/ppc/pmac.c         |   25 ++++++----
 drivers/ide/setup-pci.c        |    2 
 drivers/scsi/ide-scsi.c        |    6 +-
 include/linux/ide.h            |   23 +++++----
 31 files changed, 333 insertions(+), 319 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -389,17 +389,21 @@ static int icside_dma_init(ide_hwif_t *h
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
 
-	hwif->dma_host_set	= icside_dma_host_set;
-	hwif->dma_setup		= icside_dma_setup;
-	hwif->dma_exec_cmd	= icside_dma_exec_cmd;
-	hwif->dma_start		= icside_dma_start;
-	hwif->ide_dma_end	= icside_dma_end;
-	hwif->ide_dma_test_irq	= icside_dma_test_irq;
-	hwif->dma_timeout	= icside_dma_timeout;
-	hwif->dma_lost_irq	= icside_dma_lost_irq;
-
 	return 0;
 }
+
+static struct ide_dma_ops icside_v6_dma_ops = {
+	.dma_host_set		= icside_dma_host_set,
+	.dma_setup		= icside_dma_setup,
+	.dma_exec_cmd		= icside_dma_exec_cmd,
+	.dma_start		= icside_dma_start,
+	.dma_end		= icside_dma_end,
+	.dma_test_irq		= icside_dma_test_irq,
+	.dma_timeout		= icside_dma_timeout,
+	.dma_lost_irq		= icside_dma_lost_irq,
+};
+#else
+#define icside_v6_dma_ops NULL
 #endif
 
 static int icside_dma_off_init(ide_hwif_t *hwif, const struct ide_port_info *d)
@@ -475,6 +479,7 @@ icside_register_v5(struct icside_state *
 static const struct ide_port_info icside_v6_port_info __initdata = {
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
+	.dma_ops		= &icside_v6_dma_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2,
@@ -550,6 +555,7 @@ icside_register_v6(struct icside_state *
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
 		d.init_dma = icside_dma_init;
 		d.port_ops = &icside_v6_dma_port_ops;
+		d.dma_ops = NULL;
 	}
 
 	idx[0] = hwif->index;
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -328,7 +328,7 @@ static int __devinit palm_bk3710_init_dm
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	ide_setup_dma(hwif, base, d);
 
 	return 0;
 }
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -673,11 +673,6 @@ cris_ide_inb(unsigned long reg)
 	return (unsigned char)cris_ide_inw(reg);
 }
 
-static int cris_dma_end (ide_drive_t *drive);
-static int cris_dma_setup (ide_drive_t *drive);
-static void cris_dma_exec_cmd (ide_drive_t *drive, u8 command);
-static int cris_dma_test_irq(ide_drive_t *drive);
-static void cris_dma_start(ide_drive_t *drive);
 static void cris_ide_input_data (ide_drive_t *drive, void *, unsigned int);
 static void cris_ide_output_data (ide_drive_t *drive, void *, unsigned int);
 static void cris_atapi_input_bytes(ide_drive_t *drive, void *, unsigned int);
@@ -787,9 +782,12 @@ static const struct ide_port_ops cris_po
 	.set_dma_mode		= cris_set_dma_mode,
 };
 
+static struct ide_dma_ops cris_dma_ops;
+
 static const struct ide_port_info cris_port_info __initdata = {
 	.chipset		= ide_etrax100,
 	.port_ops		= &cris_port_ops,
+	.dma_ops		= &cris_dma_ops,
 	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_NO_DMA, /* no SFF-style DMA */
 	.pio_mask		= ATA_PIO4,
@@ -820,12 +818,6 @@ static int __init init_e100_ide(void)
 		hwif->ata_output_data = &cris_ide_output_data;
 		hwif->atapi_input_bytes = &cris_atapi_input_bytes;
 		hwif->atapi_output_bytes = &cris_atapi_output_bytes;
-		hwif->dma_host_set = &cris_dma_host_set;
-		hwif->ide_dma_end = &cris_dma_end;
-		hwif->dma_setup = &cris_dma_setup;
-		hwif->dma_exec_cmd = &cris_dma_exec_cmd;
-		hwif->ide_dma_test_irq = &cris_dma_test_irq;
-		hwif->dma_start = &cris_dma_start;
 		hwif->OUTB = &cris_ide_outb;
 		hwif->OUTW = &cris_ide_outw;
 		hwif->OUTBSYNC = &cris_ide_outbsync;
@@ -1080,4 +1072,13 @@ static void cris_dma_start(ide_drive_t *
 	}
 }
 
+static struct ide_dma_ops cris_dma_ops = {
+	.dma_host_set		= cris_dma_host_set,
+	.dma_setup		= cris_dma_setup,
+	.dma_exec_cmd		= cris_dma_exec_cmd,
+	.dma_start		= cris_dma_start,
+	.dma_end		= cris_dma_end,
+	.dma_test_irq		= cris_dma_test_irq,
+};
+
 module_init(init_e100_ide);
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -539,7 +539,7 @@ static ide_startstop_t cdrom_start_packe
 
 	/* FIXME: for Virtual DMA we must check harder */
 	if (info->dma)
-		info->dma = !hwif->dma_setup(drive);
+		info->dma = !hwif->dma_ops->dma_setup(drive);
 
 	/* set up the controller registers */
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
@@ -617,7 +617,7 @@ static ide_startstop_t cdrom_transfer_pa
 
 	/* start the DMA if need be */
 	if (info->dma)
-		hwif->dma_start(drive);
+		hwif->dma_ops->dma_start(drive);
 
 	return ide_started;
 }
@@ -929,7 +929,7 @@ static ide_startstop_t cdrom_newpc_intr(
 	dma = info->dma;
 	if (dma) {
 		info->dma = 0;
-		dma_error = HWIF(drive)->ide_dma_end(drive);
+		dma_error = hwif->dma_ops->dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
 					write ? "write" : "read");
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -102,7 +102,7 @@ ide_startstop_t ide_dma_intr (ide_drive_
 {
 	u8 stat = 0, dma_stat = 0;
 
-	dma_stat = HWIF(drive)->ide_dma_end(drive);
+	dma_stat = drive->hwif->dma_ops->dma_end(drive);
 	stat = ide_read_status(drive);
 
 	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
@@ -394,7 +394,7 @@ void ide_dma_off_quietly(ide_drive_t *dr
 	drive->using_dma = 0;
 	ide_toggle_bounce(drive, 0);
 
-	drive->hwif->dma_host_set(drive, 0);
+	drive->hwif->dma_ops->dma_host_set(drive, 0);
 }
 
 EXPORT_SYMBOL(ide_dma_off_quietly);
@@ -427,7 +427,7 @@ void ide_dma_on(ide_drive_t *drive)
 	drive->using_dma = 1;
 	ide_toggle_bounce(drive, 1);
 
-	drive->hwif->dma_host_set(drive, 1);
+	drive->hwif->dma_ops->dma_host_set(drive, 1);
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
@@ -802,10 +802,10 @@ void ide_dma_timeout (ide_drive_t *drive
 
 	printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
 
-	if (hwif->ide_dma_test_irq(drive))
+	if (hwif->dma_ops->dma_test_irq(drive))
 		return;
 
-	hwif->ide_dma_end(drive);
+	hwif->dma_ops->dma_end(drive);
 }
 
 EXPORT_SYMBOL(ide_dma_timeout);
@@ -839,8 +839,21 @@ int ide_allocate_dma_engine(ide_hwif_t *
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
 
-void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
+static struct ide_dma_ops sff_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= __ide_dma_end,
+	.dma_test_irq		= __ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
+};
+
+void ide_setup_dma(ide_hwif_t *hwif, unsigned long base,
+		   const struct ide_port_info *d)
 {
+	struct ide_dma_ops *dma_ops = d->dma_ops ? d->dma_ops : &sff_dma_ops;
 	hwif->dma_base = base;
 
 	if (!hwif->dma_command)
@@ -854,22 +867,24 @@ void ide_setup_dma(ide_hwif_t *hwif, uns
 	if (!hwif->dma_prdtable)
 		hwif->dma_prdtable	= hwif->dma_base + 4;
 
-	if (!hwif->dma_host_set)
-		hwif->dma_host_set = &ide_dma_host_set;
-	if (!hwif->dma_setup)
-		hwif->dma_setup = &ide_dma_setup;
-	if (!hwif->dma_exec_cmd)
-		hwif->dma_exec_cmd = &ide_dma_exec_cmd;
-	if (!hwif->dma_start)
-		hwif->dma_start = &ide_dma_start;
-	if (!hwif->ide_dma_end)
-		hwif->ide_dma_end = &__ide_dma_end;
-	if (!hwif->ide_dma_test_irq)
-		hwif->ide_dma_test_irq = &__ide_dma_test_irq;
-	if (!hwif->dma_timeout)
-		hwif->dma_timeout = &ide_dma_timeout;
-	if (!hwif->dma_lost_irq)
-		hwif->dma_lost_irq = &ide_dma_lost_irq;
+	hwif->dma_ops = dma_ops;
+
+	if (dma_ops->dma_host_set == NULL)
+		dma_ops->dma_host_set	= ide_dma_host_set;
+	if (dma_ops->dma_setup == NULL)
+		dma_ops->dma_setup	= ide_dma_setup;
+	if (dma_ops->dma_exec_cmd == NULL)
+		dma_ops->dma_exec_cmd	= ide_dma_exec_cmd;
+	if (dma_ops->dma_start == NULL)
+		dma_ops->dma_start	= ide_dma_start;
+	if (dma_ops->dma_end == NULL)
+		dma_ops->dma_end	= __ide_dma_end;
+	if (dma_ops->dma_test_irq == NULL)
+		dma_ops->dma_test_irq	= __ide_dma_test_irq;
+	if (dma_ops->dma_timeout == NULL)
+		dma_ops->dma_timeout	= ide_dma_timeout;
+	if (dma_ops->dma_lost_irq == NULL)
+		dma_ops->dma_lost_irq	= ide_dma_lost_irq;
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_dma);
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -411,7 +411,7 @@ static ide_startstop_t idefloppy_pc_intr
 	debug_log("Reached %s interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		dma_error = hwif->ide_dma_end(drive);
+		dma_error = drive->hwif->dma_ops->dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
 					rq_data_dir(rq) ? "write" : "read");
@@ -663,7 +663,7 @@ static ide_startstop_t idefloppy_issue_p
 	dma = 0;
 
 	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
-		dma = !hwif->dma_setup(drive);
+		dma = !hwif->dma_ops->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma);
@@ -671,7 +671,7 @@ static ide_startstop_t idefloppy_issue_p
 	if (dma) {
 		/* Begin DMA, if necessary */
 		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_start(drive);
+		hwif->dma_ops->dma_start(drive);
 	}
 
 	/* Can we transfer the packet when we get the interrupt or wait? */
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -218,7 +218,7 @@ static ide_startstop_t ide_start_power_s
 		 * we could be smarter and check for current xfer_speed
 		 * in struct drive etc...
 		 */
-		if (drive->hwif->dma_host_set == NULL)
+		if (drive->hwif->dma_ops == NULL)
 			break;
 		/*
 		 * TODO: respect ->using_dma setting
@@ -1238,12 +1238,12 @@ static ide_startstop_t ide_dma_timeout_r
 
 	if (error < 0) {
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
-		(void)HWIF(drive)->ide_dma_end(drive);
+		(void)hwif->dma_ops->dma_end(drive);
 		ret = ide_error(drive, "dma timeout error",
 				ide_read_status(drive));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
-		hwif->dma_timeout(drive);
+		hwif->dma_ops->dma_timeout(drive);
 	}
 
 	/*
@@ -1355,7 +1355,7 @@ void ide_timer_expiry (unsigned long dat
 				startstop = handler(drive);
 			} else if (drive_is_ready(drive)) {
 				if (drive->waiting_for_dma)
-					hwgroup->hwif->dma_lost_irq(drive);
+					hwif->dma_ops->dma_lost_irq(drive);
 				(void)ide_ack_intr(hwif);
 				printk(KERN_WARNING "%s: lost interrupt\n", drive->name);
 				startstop = handler(drive);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -432,7 +432,7 @@ int drive_is_ready (ide_drive_t *drive)
 	u8 stat			= 0;
 
 	if (drive->waiting_for_dma)
-		return hwif->ide_dma_test_irq(drive);
+		return hwif->dma_ops->dma_test_irq(drive);
 
 #if 0
 	/* need to guarantee 400ns since last command was issued */
@@ -702,8 +702,8 @@ int ide_config_drive_speed(ide_drive_t *
 //		msleep(50);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if (hwif->dma_host_set)	/* check if host supports DMA */
-		hwif->dma_host_set(drive, 0);
+	if (hwif->dma_ops)	/* check if host supports DMA */
+		hwif->dma_ops->dma_host_set(drive, 0);
 #endif
 
 	/* Skip setting PIO flow-control modes on pre-EIDE drives */
@@ -761,8 +761,8 @@ int ide_config_drive_speed(ide_drive_t *
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if ((speed >= XFER_SW_DMA_0 || (hwif->host_flags & IDE_HFLAG_VDMA)) &&
 	    drive->using_dma)
-		hwif->dma_host_set(drive, 1);
-	else if (hwif->dma_host_set)	/* check if host supports DMA */
+		hwif->dma_ops->dma_host_set(drive, 1);
+	else if (hwif->dma_ops)	/* check if host supports DMA */
 		ide_dma_off_quietly(drive);
 #endif
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -842,7 +842,7 @@ static void ide_port_tune_devices(ide_hw
 
 			drive->nice1 = 1;
 
-			if (hwif->dma_host_set)
+			if (hwif->dma_ops)
 				ide_set_dma(drive);
 		}
 	}
@@ -1387,7 +1387,8 @@ static void ide_init_port(ide_hwif_t *hw
 			hwif->swdma_mask = 0;
 			hwif->mwdma_mask = 0;
 			hwif->ultra_mask = 0;
-		}
+		} else if (d->dma_ops)
+			hwif->dma_ops = d->dma_ops;
 	}
 
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -993,7 +993,7 @@ static ide_startstop_t idetape_pc_intr(i
 	stat = ide_read_status(drive);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
+		if (hwif->dma_ops->dma_end(drive) || (stat & ERR_STAT)) {
 			/*
 			 * A DMA error is sometimes expected. For example,
 			 * if the tape is crossing a filemark during a
@@ -1213,7 +1213,7 @@ static ide_startstop_t idetape_transfer_
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	/* Begin DMA, if necessary */
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS)
-		hwif->dma_start(drive);
+		hwif->dma_ops->dma_start(drive);
 #endif
 	/* Send the actual packet */
 	HWIF(drive)->atapi_output_bytes(drive, pc->c, 12);
@@ -1279,7 +1279,7 @@ static ide_startstop_t idetape_issue_pc(
 		ide_dma_off(drive);
 	}
 	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
-		dma_ok = !hwif->dma_setup(drive);
+		dma_ok = !hwif->dma_ops->dma_setup(drive);
 
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -135,6 +135,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct ide_taskfile *tf = &task->tf;
 	ide_handler_t *handler = NULL;
+	struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
 	if (task->data_phase == TASKFILE_MULTI_IN ||
 	    task->data_phase == TASKFILE_MULTI_OUT) {
@@ -178,10 +179,10 @@ ide_startstop_t do_rw_taskfile (ide_driv
 		return ide_started;
 	default:
 		if (task_dma_ok(task) == 0 || drive->using_dma == 0 ||
-		    hwif->dma_setup(drive))
+		    dma_ops->dma_setup(drive))
 			return ide_stopped;
-		hwif->dma_exec_cmd(drive, tf->command);
-		hwif->dma_start(drive);
+		dma_ops->dma_exec_cmd(drive, tf->command);
+		dma_ops->dma_start(drive);
 		return ide_started;
 	}
 }
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -471,7 +471,7 @@ int set_using_dma(ide_drive_t *drive, in
 	if (!drive->id || !(drive->id->capability & 1))
 		goto out;
 
-	if (hwif->dma_host_set == NULL)
+	if (hwif->dma_ops == NULL)
 		goto out;
 
 	err = -EBUSY;
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -371,21 +371,31 @@ static void auide_init_dbdma_dev(dbdev_t
 	dev->dev_devwidth    = devwidth;
 	dev->dev_flags       = flags;
 }
-  
-#if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 static void auide_dma_timeout(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
 	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
 
-	if (hwif->ide_dma_test_irq(drive))
+	if (auide_dma_test_irq(drive))
 		return;
 
-	hwif->ide_dma_end(drive);
+	auide_dma_end(drive);
 }
 
+static struct ide_dma_ops auide_dma_ops = {
+	.dma_host_set		= auide_dma_host_set,
+	.dma_setup		= auide_dma_setup,
+	.dma_exec_cmd		= auide_dma_exec_cmd,
+	.dma_start		= auide_dma_start,
+	.dma_end		= auide_dma_end,
+	.dma_test_irq		= auide_dma_test_irq,
+	.dma_lost_irq		= auide_dma_lost_irq,
+	.dma_timeout		= auide_dma_timeout,
+};
+
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	_auide_hwif *auide = (_auide_hwif *)hwif->hwif_data;
@@ -516,6 +526,9 @@ static const struct ide_port_ops au1xxx_
 static const struct ide_port_info au1xxx_port_info = {
 	.init_dma		= auide_ddma_init,
 	.port_ops		= &au1xxx_port_ops,
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	.dma_ops		= &au1xxx_dma_ops,
+#endif
 	.host_flags		= IDE_HFLAG_POST_SET_MODE |
 				  IDE_HFLAG_NO_IO_32BIT |
 				  IDE_HFLAG_UNMASK_IRQS,
@@ -593,16 +606,6 @@ static int au_ide_probe(struct device *d
 	hwif->INSW                      = auide_insw;
 	hwif->OUTSW                     = auide_outsw;
 #endif
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-	hwif->dma_timeout		= &auide_dma_timeout;
-	hwif->dma_host_set		= &auide_dma_host_set;
-	hwif->dma_exec_cmd              = &auide_dma_exec_cmd;
-	hwif->dma_start                 = &auide_dma_start;
-	hwif->ide_dma_end               = &auide_dma_end;
-	hwif->dma_setup                 = &auide_dma_setup;
-	hwif->ide_dma_test_irq          = &auide_dma_test_irq;
-	hwif->dma_lost_irq		= &auide_dma_lost_irq;
-#endif
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
 
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -652,21 +652,7 @@ static u8 __devinit ali_cable_detect(ide
 	return cbl;
 }
 
-/**
- *	init_hwif_common_ali15x3	-	Set up ALI IDE hardware
- *	@hwif: IDE interface
- *
- *	Initialize the IDE structure side of the ALi 15x3 driver.
- */
- 
-static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
-{
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->dma_setup = &ali15x3_dma_setup;
-}
-
+#ifndef CONFIG_SPARC64
 /**
  *	init_hwif_ali15x3	-	Initialize the ALI IDE x86 stuff
  *	@hwif: interface to configure
@@ -716,9 +702,8 @@ static void __devinit init_hwif_ali15x3 
 		if(irq >= 0)
 			hwif->irq = irq;
 	}
-
-	init_hwif_common_ali15x3(hwif);
 }
+#endif
 
 /**
  *	init_dma_ali15x3	-	set up DMA on ALi15x3
@@ -746,7 +731,7 @@ static int __devinit init_dma_ali15x3(id
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	ide_setup_dma(hwif, base, d);
 
 	return 0;
 }
@@ -758,10 +743,16 @@ static const struct ide_port_ops ali_por
 	.cable_detect		= ali_cable_detect,
 };
 
+static struct ide_dma_ops ali_dma_ops = {
+	.dma_setup	= ali15x3_dma_setup,
+};
+
 static const struct ide_port_info ali15x3_chipset __devinitdata = {
 	.name		= "ALI15X3",
 	.init_chipset	= init_chipset_ali15x3,
+#ifndef CONFIG_SPARC64
 	.init_hwif	= init_hwif_ali15x3,
+#endif
 	.init_dma	= init_dma_ali15x3,
 	.port_ops	= &ali_port_ops,
 	.pio_mask	= ATA_PIO5,
@@ -806,6 +797,8 @@ static int __devinit alim15x3_init_one(s
 			d.udma_mask = ATA_UDMA5;
 		else
 			d.udma_mask = ATA_UDMA6;
+
+		d.dma_ops = &ali_dma_ops;
 	} else {
 		d.host_flags |= IDE_HFLAG_NO_DMA;
 
@@ -815,9 +808,6 @@ static int __devinit alim15x3_init_one(s
 	if (idx == 0)
 		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
 
-#if defined(CONFIG_SPARC64)
-	d.init_hwif = init_hwif_common_ali15x3;
-#endif /* CONFIG_SPARC64 */
 	return ide_setup_pci_device(dev, &d);
 }
 
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -385,62 +385,33 @@ static u8 __devinit cmd64x_cable_detect(
 	}
 }
 
-static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	if (!hwif->dma_base)
-		return;
-
-	/*
-	 * UltraDMA only supported on PCI646U and PCI646U2, which
-	 * correspond to revisions 0x03, 0x05 and 0x07 respectively.
-	 * Actually, although the CMD tech support people won't
-	 * tell me the details, the 0x03 revision cannot support
-	 * UDMA correctly without hardware modifications, and even
-	 * then it only works with Quantum disks due to some
-	 * hold time assumptions in the 646U part which are fixed
-	 * in the 646U2.
-	 *
-	 * So we only do UltraDMA on revision 0x05 and 0x07 chipsets.
-	 */
-	if (dev->device == PCI_DEVICE_ID_CMD_646 && dev->revision < 5)
-		hwif->ultra_mask = 0x00;
-
-	switch (dev->device) {
-	case PCI_DEVICE_ID_CMD_648:
-	case PCI_DEVICE_ID_CMD_649:
-	alt_irq_bits:
-		hwif->ide_dma_end	= &cmd648_ide_dma_end;
-		hwif->ide_dma_test_irq	= &cmd648_ide_dma_test_irq;
-		break;
-	case PCI_DEVICE_ID_CMD_646:
-		if (dev->revision == 0x01) {
-			hwif->ide_dma_end = &cmd646_1_ide_dma_end;
-			break;
-		} else if (dev->revision >= 0x03)
-			goto alt_irq_bits;
-		/* fall thru */
-	default:
-		hwif->ide_dma_end	= &cmd64x_ide_dma_end;
-		hwif->ide_dma_test_irq	= &cmd64x_ide_dma_test_irq;
-		break;
-	}
-}
-
 static const struct ide_port_ops cmd64x_port_ops = {
 	.set_pio_mode		= cmd64x_set_pio_mode,
 	.set_dma_mode		= cmd64x_set_dma_mode,
 	.cable_detect		= cmd64x_cable_detect,
 };
 
+static struct ide_dma_ops cmd643_dma_ops = {
+	.dma_end		= cmd64x_ide_dma_end,
+	.dma_test_irq		= cmd64x_ide_dma_test_irq,
+};
+
+static struct ide_dma_ops cmd646_rev1_dma_ops = {
+	.dma_end		= cmd646_1_ide_dma_end,
+};
+
+static struct ide_dma_ops cmd64x_dma_ops = {
+	.dma_end		= cmd648_ide_dma_end,
+	.dma_test_irq		= cmd648_ide_dma_test_irq,
+};
+
 static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "CMD643",
 		.init_chipset	= init_chipset_cmd64x,
-		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
+		.dma_ops	= &cmd643_dma_ops,
 		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
 				  IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
@@ -449,10 +420,10 @@ static const struct ide_port_info cmd64x
 	},{	/* 1 */
 		.name		= "CMD646",
 		.init_chipset	= init_chipset_cmd64x,
-		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.chipset	= ide_cmd646,
 		.port_ops	= &cmd64x_port_ops,
+		.dma_ops	= &cmd64x_dma_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -460,9 +431,9 @@ static const struct ide_port_info cmd64x
 	},{	/* 2 */
 		.name		= "CMD648",
 		.init_chipset	= init_chipset_cmd64x,
-		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
+		.dma_ops	= &cmd64x_dma_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -470,9 +441,9 @@ static const struct ide_port_info cmd64x
 	},{	/* 3 */
 		.name		= "CMD649",
 		.init_chipset	= init_chipset_cmd64x,
-		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.port_ops	= &cmd64x_port_ops,
+		.dma_ops	= &cmd64x_dma_ops,
 		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -487,12 +458,35 @@ static int __devinit cmd64x_init_one(str
 
 	d = cmd64x_chipsets[idx];
 
-	/*
-	 * The original PCI0646 didn't have the primary channel enable bit,
-	 * it appeared starting with PCI0646U (i.e. revision ID 3).
-	 */
-	if (idx == 1 && dev->revision < 3)
-		d.enablebits[0].reg = 0;
+	if (idx == 1) {
+		/*
+		 * UltraDMA only supported on PCI646U and PCI646U2, which
+		 * correspond to revisions 0x03, 0x05 and 0x07 respectively.
+		 * Actually, although the CMD tech support people won't
+		 * tell me the details, the 0x03 revision cannot support
+		 * UDMA correctly without hardware modifications, and even
+		 * then it only works with Quantum disks due to some
+		 * hold time assumptions in the 646U part which are fixed
+		 * in the 646U2.
+		 *
+		 * So we only do UltraDMA on revision 0x05 and 0x07 chipsets.
+		 */
+		if (dev->revision < 5) {
+			d.udma_mask = 0x00;
+			/*
+			 * The original PCI0646 didn't have the primary
+			 * channel enable bit, it appeared starting with
+			 * PCI0646U (i.e. revision ID 3).
+			 */
+			if (dev->revision < 3) {
+				d.enablebits[0].reg = 0;
+				if (dev->revision == 1)
+					d.dma_ops = &cmd646_rev1_dma_ops;
+				else
+					d.dma_ops = &cmd643_dma_ops;
+			}
+		}
+	}
 
 	return ide_setup_pci_device(dev, &d);
 }
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -103,24 +103,20 @@ static void cs5520_dma_host_set(ide_driv
 	ide_dma_host_set(drive, on);
 }
 
-static void __devinit init_hwif_cs5520(ide_hwif_t *hwif)
-{
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->dma_host_set = &cs5520_dma_host_set;
-}
-
 static const struct ide_port_ops cs5520_port_ops = {
 	.set_pio_mode		= cs5520_set_pio_mode,
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
+static struct ide_dma_ops cs5520_dma_ops = {
+	.dma_host_set		= cs5520_dma_host_set,
+};
+
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
-		.init_hwif	= init_hwif_cs5520,		\
 		.port_ops	= &cs5520_port_ops,		\
+		.dma_ops	= &cs5520_dma_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
 				  IDE_HFLAG_CS5520 |		\
 				  IDE_HFLAG_VDMA |		\
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1312,19 +1312,6 @@ static void __devinit init_hwif_hpt366(i
 
 	if (new_mcr != old_mcr)
 		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
-
-	if (hwif->dma_base == 0)
-		return;
-
-	if (chip_type >= HPT374) {
-		hwif->ide_dma_test_irq	= &hpt374_ide_dma_test_irq;
-		hwif->ide_dma_end	= &hpt374_ide_dma_end;
-	} else if (chip_type >= HPT370) {
-		hwif->dma_start 	= &hpt370_ide_dma_start;
-		hwif->ide_dma_end	= &hpt370_ide_dma_end;
-		hwif->dma_timeout	= &hpt370_dma_timeout;
-	} else
-		hwif->dma_lost_irq	= &hpt366_dma_lost_irq;
 }
 
 static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
@@ -1360,7 +1347,7 @@ static int __devinit init_dma_hpt366(ide
 	if (ide_allocate_dma_engine(hwif))
 		return -1;
 
-	ide_setup_dma(hwif, base);
+	ide_setup_dma(hwif, base, d);
 
 	return 0;
 }
@@ -1428,6 +1415,21 @@ static const struct ide_port_ops hpt3xx_
 	.cable_detect		= hpt3xx_cable_detect,
 };
 
+static struct ide_dma_ops hpt3xxx_dma_ops = {
+	.dma_end		= hpt374_ide_dma_end,
+	.dma_test_irq		= hpt374_ide_dma_test_irq,
+};
+
+static struct ide_dma_ops hpt370x_dma_ops = {
+	.dma_start		= hpt370_ide_dma_start,
+	.dma_end		= hpt370_ide_dma_end,
+	.dma_timeout		= hpt370_dma_timeout,
+};
+
+static struct ide_dma_ops hpt36x_dma_ops = {
+	.dma_lost_irq		= hpt366_dma_lost_irq,
+};
+
 static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "HPT36x",
@@ -1442,6 +1444,7 @@ static const struct ide_port_info hpt366
 		 */
 		.enablebits	= {{0x50,0x10,0x10}, {0x54,0x04,0x04}},
 		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt36x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX | IDE_HFLAG_SINGLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1452,6 +1455,7 @@ static const struct ide_port_info hpt366
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt3xxx_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1472,6 +1476,7 @@ static const struct ide_port_info hpt366
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt370x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1483,6 +1488,7 @@ static const struct ide_port_info hpt366
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.udma_mask	= ATA_UDMA5,
 		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt370x_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -1493,6 +1499,7 @@ static const struct ide_port_info hpt366
 		.init_dma	= init_dma_hpt366,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
 		.port_ops	= &hpt3xx_port_ops,
+		.dma_ops	= &hpt3xxx_dma_ops,
 		.host_flags	= IDE_HFLAGS_HPT3XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -511,6 +511,11 @@ static void __devinit it821x_quirkproc(i
 
 }
 
+static struct ide_dma_ops it821x_smart_dma_ops = {
+	.dma_start		= it821x_dma_start,
+	.dma_end		= it821x_dma_end,
+};
+
 /**
  *	init_hwif_it821x	-	set up hwif structs
  *	@hwif: interface to set up
@@ -562,8 +567,7 @@ static void __devinit init_hwif_it821x(i
 
 	if (idev->smart == 0) {
 		/* MWDMA/PIO clock switching for pass through mode */
-		hwif->dma_start = &it821x_dma_start;
-		hwif->ide_dma_end = &it821x_dma_end;
+		hwif->dma_ops = &it821x_smart_dma_ops;
 	} else
 		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;
 
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -252,14 +252,17 @@ static void __devinit init_hwif_ns87415 
 		return;
 
 	outb(0x60, hwif->dma_status);
-	hwif->dma_setup = &ns87415_ide_dma_setup;
-	hwif->ide_dma_end = &ns87415_ide_dma_end;
 }
 
 static const struct ide_port_ops ns87415_port_ops = {
 	.selectproc		= ns87415_selectproc,
 };
 
+static struct ide_dma_ops ns87415_dma_ops = {
+	.dma_setup		= ns87415_ide_dma_setup,
+	.dma_end		= ns87415_ide_dma_end,
+};
+
 static const struct ide_port_info ns87415_chipset __devinitdata = {
 	.name		= "NS87415",
 #ifdef CONFIG_SUPERIO
@@ -267,6 +270,7 @@ static const struct ide_port_info ns8741
 #endif
 	.init_hwif	= init_hwif_ns87415,
 	.port_ops	= &ns87415_port_ops,
+	.dma_ops	= &ns87415_dma_ops,
 	.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 			  IDE_HFLAG_NO_ATAPI_DMA,
 };
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -263,23 +263,6 @@ static void pdc202xx_dma_timeout(ide_dri
 	ide_dma_timeout(drive);
 }
 
-static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->dma_lost_irq = &pdc202xx_dma_lost_irq;
-	hwif->dma_timeout = &pdc202xx_dma_timeout;
-
-	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
-		hwif->dma_start = &pdc202xx_old_ide_dma_start;
-		hwif->ide_dma_end = &pdc202xx_old_ide_dma_end;
-	} 
-	hwif->ide_dma_test_irq = &pdc202xx_old_ide_dma_test_irq;
-}
-
 static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
 						    const char *name)
 {
@@ -346,12 +329,26 @@ static const struct ide_port_ops pdc2026
 	.cable_detect		= pdc2026x_cable_detect,
 };
 
+static struct ide_dma_ops pdc20246_dma_ops = {
+	.dma_test_irq		= pdc202xx_old_ide_dma_test_irq,
+	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_timeout		= pdc202xx_dma_timeout,
+};
+
+static struct ide_dma_ops pdc2026x_dma_ops = {
+	.dma_start		= pdc202xx_old_ide_dma_start,
+	.dma_end		= pdc202xx_old_ide_dma_end,
+	.dma_test_irq		= pdc202xx_old_ide_dma_test_irq,
+	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_timeout		= pdc202xx_dma_timeout,
+};
+
 #define DECLARE_PDC2026X_DEV(name_str, udma, extra_flags) \
 	{ \
 		.name		= name_str, \
 		.init_chipset	= init_chipset_pdc202xx, \
-		.init_hwif	= init_hwif_pdc202xx, \
 		.port_ops	= &pdc2026x_port_ops, \
+		.dma_ops	= &pdc2026x_dma_ops, \
 		.host_flags	= IDE_HFLAGS_PDC202XX | extra_flags, \
 		.pio_mask	= ATA_PIO4, \
 		.mwdma_mask	= ATA_MWDMA2, \
@@ -362,8 +359,8 @@ static const struct ide_port_info pdc202
 	{	/* 0 */
 		.name		= "PDC20246",
 		.init_chipset	= init_chipset_pdc202xx,
-		.init_hwif	= init_hwif_pdc202xx,
 		.port_ops	= &pdc20246_port_ops,
+		.dma_ops	= &pdc20246_dma_ops,
 		.host_flags	= IDE_HFLAGS_PDC202XX,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -214,7 +214,7 @@ static void sc1200_set_pio_mode(ide_driv
 		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
 		ide_dma_off_quietly(drive);
 		if (ide_set_dma_mode(drive, mode) == 0 && drive->using_dma)
-			hwif->dma_host_set(drive, 1);
+			hwif->dma_ops->dma_host_set(drive, 1);
 		return;
 	}
 
@@ -286,28 +286,20 @@ static int sc1200_resume (struct pci_dev
 }
 #endif
 
-/*
- * This gets invoked by the IDE driver once for each channel,
- * and performs channel-specific pre-initialization before drive probing.
- */
-static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
-{
-	if (hwif->dma_base == 0)
-		return;
-
-	hwif->ide_dma_end   = &sc1200_ide_dma_end;
-}
-
 static const struct ide_port_ops sc1200_port_ops = {
 	.set_pio_mode		= sc1200_set_pio_mode,
 	.set_dma_mode		= sc1200_set_dma_mode,
 	.udma_filter		= sc1200_udma_filter,
 };
 
+static struct ide_dma_ops sc1200_dma_ops = {
+	.dma_end		= sc1200_ide_dma_end,
+};
+
 static const struct ide_port_info sc1200_chipset __devinitdata = {
 	.name		= "SC1200",
-	.init_hwif	= init_hwif_sc1200,
 	.port_ops	= &sc1200_port_ops,
+	.dma_ops	= &sc1200_dma_ops,
 	.host_flags	= IDE_HFLAG_SERIALIZE |
 			  IDE_HFLAG_POST_SET_MODE |
 			  IDE_HFLAG_ABUSE_DMA_MODES,
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -659,10 +659,6 @@ static void __devinit init_hwif_scc(ide_
 	/* PTERADD */
 	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
 
-	hwif->dma_setup = scc_dma_setup;
-	hwif->ide_dma_end = scc_ide_dma_end;
-	hwif->ide_dma_test_irq = scc_dma_test_irq;
-
 	if (in_be32((void __iomem *)(hwif->config_data + 0xff0)) & CCKCTRL_ATACLKOEN)
 		hwif->ultra_mask = ATA_UDMA6; /* 133MHz */
 	else
@@ -676,12 +672,19 @@ static const struct ide_port_ops scc_por
 	.cable_detect		= scc_cable_detect,
 };
 
+static struct ide_dma_ops scc_dma_ops = {
+	.dma_setup		= scc_dma_setup,
+	.dma_end		= scc_ide_dma_end,
+	.dma_test_irq		= scc_dma_test_irq,
+};
+
 #define DECLARE_SCC_DEV(name_str)			\
   {							\
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
       .port_ops		= &scc_port_ops,		\
+      .dma_ops		= &scc_dma_ops,			\
       .host_flags	= IDE_HFLAG_SINGLE,		\
       .pio_mask		= ATA_PIO4,			\
   }
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -327,8 +327,6 @@ sgiioc4_INB(unsigned long port)
 	return reg;
 }
 
-static void __devinit ide_init_sgiioc4(ide_hwif_t *);
-
 /* Creates a dma map for the scatter-gather list entries */
 static int __devinit
 ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
@@ -377,7 +375,6 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const 
 
 	if (pad) {
 		ide_set_hwifdata(hwif, pad);
-		ide_init_sgiioc4(hwif);
 		return 0;
 	}
 
@@ -555,18 +552,6 @@ static int sgiioc4_ide_dma_setup(ide_dri
 	return 0;
 }
 
-static void __devinit
-ide_init_sgiioc4(ide_hwif_t * hwif)
-{
-	hwif->dma_host_set = &sgiioc4_dma_host_set;
-	hwif->dma_setup = &sgiioc4_ide_dma_setup;
-	hwif->dma_start = &sgiioc4_ide_dma_start;
-	hwif->ide_dma_end = &sgiioc4_ide_dma_end;
-	hwif->ide_dma_test_irq = &sgiioc4_ide_dma_test_irq;
-	hwif->dma_lost_irq = &sgiioc4_dma_lost_irq;
-	hwif->dma_timeout = &ide_dma_timeout;
-}
-
 static const struct ide_port_ops sgiioc4_port_ops = {
 	.set_dma_mode		= sgiioc4_set_dma_mode,
 	/* reset DMA engine, clear IRQs */
@@ -575,10 +560,21 @@ static const struct ide_port_ops sgiioc4
 	.maskproc		= sgiioc4_maskproc,
 };
 
+static struct ide_dma_ops sgiioc4_dma_ops = {
+	.dma_host_set		= sgiioc4_dma_host_set,
+	.dma_setup		= sgiioc4_ide_dma_setup,
+	.dma_start		= sgiioc4_ide_dma_start,
+	.dma_end		= sgiioc4_ide_dma_end,
+	.dma_test_irq		= sgiioc4_ide_dma_test_irq,
+	.dma_lost_irq		= sgiioc4_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
+};
+
 static const struct ide_port_info sgiioc4_port_info __devinitdata = {
 	.chipset		= ide_pci,
 	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
+	.dma_ops		= &sgiioc4_dma_ops,
 	.host_flags		= IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -369,6 +369,14 @@ static int siimage_mmio_ide_dma_test_irq
 	return 0;
 }
 
+static int siimage_ide_dma_test_irq(ide_drive_t *drive)
+{
+	if (drive->hwif->mmio)
+		return siimage_mmio_ide_dma_test_irq(drive);
+	else
+		return siimage_io_ide_dma_test_irq(drive);
+}
+
 /**
  *	sil_sata_reset_poll	-	wait for SATA reset
  *	@drive: drive we are resetting
@@ -756,41 +764,6 @@ static u8 __devinit sil_cable_detect(ide
 	return (ata66 & 0x01) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
 
-/**
- *	init_hwif_siimage	-	set up hwif structs
- *	@hwif: interface to set up
- *
- *	We do the basic set up of the interface structure. The SIIMAGE
- *	requires several custom handlers so we override the default
- *	ide DMA handlers appropriately
- */
-
-static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
-{
-	u8 sata = is_sata(hwif);
-
-	if (sata) {
-		static int first = 1;
-
-		if (first) {
-			printk(KERN_INFO "siimage: For full SATA support you should use the libata sata_sil module.\n");
-			first = 0;
-		}
-	}
-
-	if (hwif->dma_base == 0)
-		return;
-
-	if (sata)
-		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
-
-	if (hwif->mmio) {
-		hwif->ide_dma_test_irq = &siimage_mmio_ide_dma_test_irq;
-	} else {
-		hwif->ide_dma_test_irq = & siimage_io_ide_dma_test_irq;
-	}
-}
-
 static const struct ide_port_ops sil_pata_port_ops = {
 	.set_pio_mode		= sil_set_pio_mode,
 	.set_dma_mode		= sil_set_dma_mode,
@@ -809,13 +782,17 @@ static const struct ide_port_ops sil_sat
 	.cable_detect		= sil_cable_detect,
 };
 
+static struct ide_dma_ops sil_dma_ops = {
+	.dma_test_irq		= siimage_ide_dma_test_irq,
+};
+
 #define DECLARE_SII_DEV(name_str, p_ops)		\
 	{						\
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_siimage,	\
 		.init_iops	= init_iops_siimage,	\
-		.init_hwif	= init_hwif_siimage,	\
 		.port_ops	= p_ops,		\
+		.dma_ops	= &sil_dma_ops,		\
 		.pio_mask	= ATA_PIO4,		\
 		.mwdma_mask	= ATA_MWDMA2,		\
 		.udma_mask	= ATA_UDMA6,		\
@@ -838,7 +815,24 @@ static const struct ide_port_info siimag
  
 static int __devinit siimage_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &siimage_chipsets[id->driver_data]);
+	struct ide_port_info d;
+	u8 idx = id->driver_data;
+
+	d = siimage_chipsets[idx];
+
+	if (idx) {
+		static int first = 1;
+
+		if (first) {
+			printk(KERN_INFO "siimage: For full SATA support you "
+				"should use the libata sata_sil module.\n");
+			first = 0;
+		}
+
+		d.host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
+	}
+
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id siimage_pci_tbl[] = {
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -282,34 +282,25 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
-/*
- * Initialise IDE channel
- */
-static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
-{
-	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
-
-	if (!hwif->dma_base)
-		return;
-
-	hwif->dma_lost_irq		= &sl82c105_dma_lost_irq;
-	hwif->dma_start			= &sl82c105_dma_start;
-	hwif->ide_dma_end		= &sl82c105_dma_end;
-	hwif->dma_timeout		= &sl82c105_dma_timeout;
-}
-
 static const struct ide_port_ops sl82c105_port_ops = {
 	.set_pio_mode		= sl82c105_set_pio_mode,
 	.set_dma_mode		= sl82c105_set_dma_mode,
 	.resetproc		= sl82c105_resetproc,
 };
 
+static struct ide_dma_ops sl82c105_dma_ops = {
+	.dma_start		= sl82c105_dma_start,
+	.dma_end		= sl82c105_dma_end,
+	.dma_lost_irq		= sl82c105_dma_lost_irq,
+	.dma_timeout		= sl82c105_dma_timeout,
+};
+
 static const struct ide_port_info sl82c105_chipset __devinitdata = {
 	.name		= "W82C105",
 	.init_chipset	= init_chipset_sl82c105,
-	.init_hwif	= init_hwif_sl82c105,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
 	.port_ops	= &sl82c105_port_ops,
+	.dma_ops	= &sl82c105_dma_ops,
 	.host_flags	= IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_UNMASK_IRQS |
 /* FIXME: check for Compatibility mode in generic IDE PCI code */
@@ -334,7 +325,7 @@ static int __devinit sl82c105_init_one(s
 		 */
 		printk(KERN_INFO "W82C105_IDE: Winbond W83C553 bridge "
 				 "revision %d, BM-DMA disabled\n", rev);
-		d.init_hwif = NULL;
+		d.dma_ops = NULL;
 		d.mwdma_mask = 0;
 		d.host_flags &= ~IDE_HFLAG_SERIALIZE_DMA;
 	}
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -168,8 +168,6 @@ static void __devinit init_hwif_tc86c001
 
 	/* Sector Count Register limit */
 	hwif->rqsize	 = 0xffff;
-
-	hwif->dma_start 	= &tc86c001_dma_start;
 }
 
 static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
@@ -188,11 +186,16 @@ static const struct ide_port_ops tc86c00
 	.cable_detect		= tc86c001_cable_detect,
 };
 
+static struct ide_dma_ops tc86c001_dma_ops = {
+	.dma_start		= tc86c001_dma_start,
+};
+
 static const struct ide_port_info tc86c001_chipset __devinitdata = {
 	.name		= "TC86C001",
 	.init_chipset	= init_chipset_tc86c001,
 	.init_hwif	= init_hwif_tc86c001,
 	.port_ops	= &tc86c001_port_ops,
+	.dma_ops	= &tc86c001_dma_ops,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD |
 			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
 	.pio_mask	= ATA_PIO4,
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -280,12 +280,6 @@ static void __devinit init_hwif_trm290(i
 		/* sharing IRQ with mate */
 		hwif->irq = hwif->mate->irq;
 
-	hwif->dma_host_set	= &trm290_dma_host_set;
-	hwif->dma_setup 	= &trm290_dma_setup;
-	hwif->dma_exec_cmd	= &trm290_dma_exec_cmd;
-	hwif->dma_start 	= &trm290_dma_start;
-	hwif->ide_dma_end	= &trm290_ide_dma_end;
-	hwif->ide_dma_test_irq	= &trm290_ide_dma_test_irq;
 #if 1
 	{
 	/*
@@ -319,11 +313,21 @@ static const struct ide_port_ops trm290_
 	.selectproc		= trm290_selectproc,
 };
 
+static struct ide_dma_ops trm290_dma_ops = {
+	.dma_host_set		= trm290_dma_host_set,
+	.dma_setup 		= trm290_dma_setup,
+	.dma_exec_cmd		= trm290_dma_exec_cmd,
+	.dma_start 		= trm290_dma_start,
+	.dma_end		= trm290_ide_dma_end,
+	.dma_test_irq		= trm290_ide_dma_test_irq,
+};
+
 static const struct ide_port_info trm290_chipset __devinitdata = {
 	.name		= "TRM290",
 	.init_hwif	= init_hwif_trm290,
 	.chipset	= ide_trm290,
 	.port_ops	= &trm290_port_ops,
+	.dma_ops	= &trm290_dma_ops,
 	.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
 #if 0 /* play it safe for now */
 			  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -930,9 +930,14 @@ static const struct ide_port_ops pmac_id
 	.selectproc		= pmac_ide_selectproc,
 };
 
+static struct ide_dma_ops pmac_dma_ops;
+
 static const struct ide_port_info pmac_port_info = {
 	.init_dma		= pmac_ide_init_dma,
 	.chipset		= ide_pmac,
+#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
+	.dma_ops		= &pmac_dma_ops,
+#endif
 	.port_ops		= &pmac_ide_port_ops,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
@@ -1670,6 +1675,17 @@ pmac_ide_dma_lost_irq (ide_drive_t *driv
 	printk(KERN_ERR "ide-pmac lost interrupt, dma status: %lx\n", status);
 }
 
+static struct ide_dma_ops pmac_dma_ops = {
+	.dma_host_set		= pmac_ide_dma_host_set,
+	.dma_setup		= pmac_ide_dma_setup,
+	.dma_exec_cmd		= pmac_ide_dma_exec_cmd,
+	.dma_start		= pmac_ide_dma_start,
+	.dma_end		= pmac_ide_dma_end,
+	.dma_test_irq		= pmac_ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= pmac_ide_dma_lost_irq,
+};
+
 /*
  * Allocate the data structures needed for using DMA with an interface
  * and fill the proper list of functions pointers
@@ -1702,15 +1718,6 @@ static int __devinit pmac_ide_init_dma(i
 
 	hwif->sg_max_nents = MAX_DCMDS;
 
-	hwif->dma_host_set = &pmac_ide_dma_host_set;
-	hwif->dma_setup = &pmac_ide_dma_setup;
-	hwif->dma_exec_cmd = &pmac_ide_dma_exec_cmd;
-	hwif->dma_start = &pmac_ide_dma_start;
-	hwif->ide_dma_end = &pmac_ide_dma_end;
-	hwif->ide_dma_test_irq = &pmac_ide_dma_test_irq;
-	hwif->dma_timeout = &ide_dma_timeout;
-	hwif->dma_lost_irq = &pmac_ide_dma_lost_irq;
-
 	return 0;
 }
 #else
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -384,7 +384,7 @@ int ide_hwif_setup_dma(ide_hwif_t *hwif,
 		if (ide_allocate_dma_engine(hwif))
 			return -1;
 
-		ide_setup_dma(hwif, base);
+		ide_setup_dma(hwif, base, d);
 	}
 
 	return 0;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -393,7 +393,7 @@ static ide_startstop_t idescsi_pc_intr (
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
 		pc->xferred = pc->req_xfer;
-		(void) HWIF(drive)->ide_dma_end(drive);
+		(void)hwif->dma_ops->dma_end(drive);
 	}
 
 	/* Clear the interrupt */
@@ -498,7 +498,7 @@ static ide_startstop_t idescsi_transfer_
 	drive->hwif->atapi_output_bytes(drive, scsi->pc->c, 12);
 	if (pc->flags & PC_FLAG_DMA_OK) {
 		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_start(drive);
+		hwif->dma_ops->dma_start(drive);
 	}
 	return ide_started;
 }
@@ -560,7 +560,7 @@ static ide_startstop_t idescsi_issue_pc(
 
 	if (drive->using_dma && !idescsi_map_sg(drive, pc)) {
 		hwif->sg_mapped = 1;
-		dma = !hwif->dma_setup(drive);
+		dma = !hwif->dma_ops->dma_setup(drive);
 		hwif->sg_mapped = 0;
 	}
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -414,6 +414,17 @@ struct ide_port_ops {
 	u8	(*cable_detect)(struct hwif_s *);
 };
 
+struct ide_dma_ops {
+	void	(*dma_host_set)(struct ide_drive_s *, int);
+	int	(*dma_setup)(struct ide_drive_s *);
+	void	(*dma_exec_cmd)(struct ide_drive_s *, u8);
+	void	(*dma_start)(struct ide_drive_s *);
+	int	(*dma_end)(struct ide_drive_s *);
+	int	(*dma_test_irq)(struct ide_drive_s *);
+	void	(*dma_lost_irq)(struct ide_drive_s *);
+	void	(*dma_timeout)(struct ide_drive_s *);
+};
+
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
@@ -452,6 +463,7 @@ typedef struct hwif_s {
 	void (*rw_disk)(ide_drive_t *, struct request *);
 
 	const struct ide_port_ops	*port_ops;
+	struct ide_dma_ops		*dma_ops;
 
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
 	void (*ata_output_data)(ide_drive_t *, void *, u32);
@@ -459,15 +471,7 @@ typedef struct hwif_s {
 	void (*atapi_input_bytes)(ide_drive_t *, void *, u32);
 	void (*atapi_output_bytes)(ide_drive_t *, void *, u32);
 
-	void (*dma_host_set)(ide_drive_t *, int);
-	int (*dma_setup)(ide_drive_t *);
-	void (*dma_exec_cmd)(ide_drive_t *, u8);
-	void (*dma_start)(ide_drive_t *);
-	int (*ide_dma_end)(ide_drive_t *drive);
-	int (*ide_dma_test_irq)(ide_drive_t *drive);
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
-	void (*dma_lost_irq)(ide_drive_t *drive);
-	void (*dma_timeout)(ide_drive_t *drive);
 
 	void (*OUTB)(u8 addr, unsigned long port);
 	void (*OUTBSYNC)(ide_drive_t *drive, u8 addr, unsigned long port);
@@ -1113,6 +1117,7 @@ struct ide_port_info {
 					    const struct ide_port_info *);
 
 	const struct ide_port_ops	*port_ops;
+	struct ide_dma_ops		*dma_ops;
 
 	ide_pci_enablebit_t	enablebits[2];
 	hwif_chipset_t		chipset;
@@ -1164,7 +1169,7 @@ void ide_destroy_dmatable(ide_drive_t *)
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
 int ide_allocate_dma_engine(ide_hwif_t *);
 void ide_release_dma_engine(ide_hwif_t *);
-extern void ide_setup_dma(ide_hwif_t *, unsigned long);
+void ide_setup_dma(ide_hwif_t *, unsigned long, const struct ide_port_info *);
 
 void ide_dma_host_set(ide_drive_t *, int);
 extern int ide_dma_setup(ide_drive_t *);
