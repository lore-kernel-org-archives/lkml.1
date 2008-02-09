Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYBIQUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYBIQUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYBIQSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:18:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:3473 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbYBIQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:18:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dK/bwm9pT4c4Je9bHpWjyV5uRfplpDCQ74RT26blg0TCZhhbCNcB2SgvcpIiK4f0Fhlmefyozhjs6ARTmRCZ8ql080OiJWPTwv2abWgOVybD8SVHJDvUP5RVZAiUnMexhqu9I9ICnAvH80YpaXAharEnuUcJxBOD3rgABioVzQY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ide: remove IDE_*_REG macros
Date: Sat, 9 Feb 2008 16:24:33 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802091624.34064.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Add IDE_{ALTSTATUS,IREASON,BCOUNTL,BCOUNTH}_OFFSET defines.

* Remove IDE_*_REG macros - this results in more readable
  and slightly smaller code.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cris/ide-cris.c  |   18 +++++++--
 drivers/ide/ide-cd.c         |   10 +++--
 drivers/ide/ide-floppy.c     |   14 ++++---
 drivers/ide/ide-io.c         |   38 +++++++++++--------
 drivers/ide/ide-iops.c       |   86 +++++++++++++++++++++++++------------------
 drivers/ide/ide-probe.c      |   19 +++++----
 drivers/ide/ide-tape.c       |   12 +++---
 drivers/ide/ide-taskfile.c   |   29 ++++++++------
 drivers/ide/legacy/ht6560b.c |   13 +++---
 drivers/ide/pci/hpt366.c     |    2 -
 drivers/ide/pci/scc_pata.c   |    6 ++-
 drivers/ide/pci/sgiioc4.c    |   19 ++++-----
 drivers/ide/ppc/pmac.c       |    3 +
 drivers/scsi/ide-scsi.c      |   15 ++++---
 include/linux/ide.h          |   29 ++++----------
 15 files changed, 175 insertions(+), 138 deletions(-)

Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -228,7 +228,10 @@ cris_ide_fill_descriptor(cris_dma_descr_
 static void
 cris_ide_start_dma(ide_drive_t *drive, cris_dma_descr_type *d, int dir,int type,int len)
 {
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int, IDE_DATA_REG);
+	ide_hwif_t *hwif = drive->hwif;
+
+	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
+					       hwif->io_ports[IDE_DATA_OFFSET]);
 	reg_ata_rw_trf_cnt trf_cnt = {0};
 
 	mycontext.saved_data = (dma_descr_data*)virt_to_phys(d);
@@ -264,8 +267,12 @@ cris_ide_wait_dma(int dir)
 
 static int cris_dma_test_irq(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	int intr = REG_RD_INT(ata, regi_ata, r_intr);
-	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int, IDE_DATA_REG);
+
+	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
+					       hwif->io_ports[IDE_DATA_OFFSET]);
+
 	return intr & (1 << ctrl2.sel) ? 1 : 0;
 }
 
@@ -523,7 +530,8 @@ static void cris_ide_start_dma(ide_drive
 	                          IO_STATE(R_ATA_CTRL_DATA, handsh, dma);
 	*R_ATA_CTRL_DATA =
 		cmd |
-		IO_FIELD(R_ATA_CTRL_DATA, data, IDE_DATA_REG) |
+		IO_FIELD(R_ATA_CTRL_DATA, data,
+			 drive->hwif->io_ports[IDE_DATA_OFFSET]) |
 		IO_STATE(R_ATA_CTRL_DATA, src_dst,  dma)  |
 		IO_STATE(R_ATA_CTRL_DATA, multi,    on)   |
 		IO_STATE(R_ATA_CTRL_DATA, dma_size, word);
@@ -541,7 +549,9 @@ cris_ide_wait_dma(int dir)
 static int cris_dma_test_irq(ide_drive_t *drive)
 {
 	int intr = *R_IRQ_MASK0_RD;
-	int bus = IO_EXTRACT(R_ATA_CTRL_DATA, sel, IDE_DATA_REG);
+	int bus = IO_EXTRACT(R_ATA_CTRL_DATA, sel,
+			     drive->hwif->io_ports[IDE_DATA_OFFSET]);
+
 	return intr & (1 << (bus + IO_BITNR(R_IRQ_MASK0_RD, ata_irq0))) ? 1 : 0;
 }
 
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -542,7 +542,8 @@ static ide_startstop_t cdrom_start_packe
 
 		/* packet command */
 		spin_lock_irqsave(&ide_lock, flags);
-		hwif->OUTBSYNC(drive, WIN_PACKETCMD, IDE_COMMAND_REG);
+		hwif->OUTBSYNC(drive, WIN_PACKETCMD,
+			       hwif->io_ports[IDE_COMMAND_OFFSET]);
 		ndelay(400);
 		spin_unlock_irqrestore(&ide_lock, flags);
 
@@ -989,6 +990,7 @@ static int cdrom_newpc_intr_dummy_cb(str
 
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	struct cdrom_info *info = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
@@ -1029,9 +1031,9 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * ok we fall to pio :/
 	 */
-	ireason = HWIF(drive)->INB(IDE_IREASON_REG) & 0x3;
-	lowcyl  = HWIF(drive)->INB(IDE_BCOUNTL_REG);
-	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]) & 0x3;
+	lowcyl  = hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
+	highcyl = hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]);
 
 	len = lowcyl + (256 * highcyl);
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -498,10 +498,10 @@ static ide_startstop_t idefloppy_pc_intr
 	}
 
 	/* Get the number of bytes to transfer */
-	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
-		  hwif->INB(IDE_BCOUNTL_REG);
+	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
+		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
 	/* on this interrupt */
-	ireason = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __func__);
@@ -562,6 +562,7 @@ static ide_startstop_t idefloppy_pc_intr
  */
 static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	ide_startstop_t startstop;
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	u8 ireason;
@@ -571,7 +572,7 @@ static ide_startstop_t idefloppy_transfe
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = drive->hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
@@ -608,6 +609,7 @@ static int idefloppy_transfer_pc2(ide_dr
 
 static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_startstop_t startstop;
 	u8 ireason;
@@ -617,7 +619,7 @@ static ide_startstop_t idefloppy_transfe
 				"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = drive->hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) "
 				"while issuing a packet command\n");
@@ -723,7 +725,7 @@ static ide_startstop_t idefloppy_issue_p
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		HWIF(drive)->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
 		return (*pkt_xfer_routine) (drive);
 	}
 }
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -301,39 +301,45 @@ void ide_tf_read(ide_drive_t *drive, ide
 	struct ide_taskfile *tf = &task->tf;
 
 	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
-		u16 data = hwif->INW(IDE_DATA_REG);
+		u16 data = hwif->INW(hwif->io_ports[IDE_DATA_OFFSET]);
 
 		tf->data = data & 0xff;
 		tf->hob_data = (data >> 8) & 0xff;
 	}
 
 	/* be sure we're looking at the low order bits */
-	hwif->OUTB(drive->ctl & ~0x80, IDE_CONTROL_REG);
+	hwif->OUTB(drive->ctl & ~0x80, hwif->io_ports[IDE_CONTROL_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
-		tf->nsect  = hwif->INB(IDE_NSECTOR_REG);
+		tf->nsect  = hwif->INB(hwif->io_ports[IDE_NSECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
-		tf->lbal   = hwif->INB(IDE_SECTOR_REG);
+		tf->lbal   = hwif->INB(hwif->io_ports[IDE_SECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
-		tf->lbam   = hwif->INB(IDE_LCYL_REG);
+		tf->lbam   = hwif->INB(hwif->io_ports[IDE_LCYL_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
-		tf->lbah   = hwif->INB(IDE_HCYL_REG);
+		tf->lbah   = hwif->INB(hwif->io_ports[IDE_HCYL_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
-		tf->device = hwif->INB(IDE_SELECT_REG);
+		tf->device = hwif->INB(hwif->io_ports[IDE_SELECT_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_LBA48) {
-		hwif->OUTB(drive->ctl | 0x80, IDE_CONTROL_REG);
+		hwif->OUTB(drive->ctl | 0x80,
+			   hwif->io_ports[IDE_CONTROL_OFFSET]);
 
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
-			tf->hob_feature = hwif->INB(IDE_FEATURE_REG);
+			tf->hob_feature =
+				hwif->INB(hwif->io_ports[IDE_FEATURE_OFFSET]);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
-			tf->hob_nsect   = hwif->INB(IDE_NSECTOR_REG);
+			tf->hob_nsect   =
+				hwif->INB(hwif->io_ports[IDE_NSECTOR_OFFSET]);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
-			tf->hob_lbal    = hwif->INB(IDE_SECTOR_REG);
+			tf->hob_lbal    =
+				hwif->INB(hwif->io_ports[IDE_SECTOR_OFFSET]);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
-			tf->hob_lbam    = hwif->INB(IDE_LCYL_REG);
+			tf->hob_lbam    =
+				hwif->INB(hwif->io_ports[IDE_LCYL_OFFSET]);
 		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
-			tf->hob_lbah    = hwif->INB(IDE_HCYL_REG);
+			tf->hob_lbah    =
+				hwif->INB(hwif->io_ports[IDE_HCYL_OFFSET]);
 	}
 }
 
@@ -444,7 +450,8 @@ static ide_startstop_t ide_ata_error(ide
 		if (err == ABRT_ERR) {
 			if (drive->select.b.lba &&
 			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->INB(IDE_COMMAND_REG) == WIN_SPECIFY)
+			    hwif->INB(hwif->io_ports[IDE_COMMAND_OFFSET]) ==
+				WIN_SPECIFY)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
 			/* UDMA crc error, just retry the operation */
@@ -496,7 +503,8 @@ static ide_startstop_t ide_atapi_error(i
 
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE, IDE_COMMAND_REG);
+		hwif->OUTB(WIN_IDLEIMMEDIATE,
+			   hwif->io_ports[IDE_COMMAND_OFFSET]);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -158,9 +158,12 @@ EXPORT_SYMBOL(default_hwif_mmiops);
 
 void SELECT_DRIVE (ide_drive_t *drive)
 {
-	if (HWIF(drive)->selectproc)
-		HWIF(drive)->selectproc(drive);
-	HWIF(drive)->OUTB(drive->select.all, IDE_SELECT_REG);
+	ide_hwif_t *hwif = drive->hwif;
+
+	if (hwif->selectproc)
+		hwif->selectproc(drive);
+
+	hwif->OUTB(drive->select.all, hwif->io_ports[IDE_SELECT_OFFSET]);
 }
 
 void SELECT_MASK (ide_drive_t *drive, int mask)
@@ -194,15 +197,18 @@ static void ata_input_data(ide_drive_t *
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
+
 			local_irq_save(flags);
-			ata_vlb_sync(drive, IDE_NSECTOR_REG);
-			hwif->INSL(IDE_DATA_REG, buffer, wcount);
+			ata_vlb_sync(drive, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+			hwif->INSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+				   wcount);
 			local_irq_restore(flags);
 		} else
-			hwif->INSL(IDE_DATA_REG, buffer, wcount);
-	} else {
-		hwif->INSW(IDE_DATA_REG, buffer, wcount<<1);
-	}
+			hwif->INSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+				   wcount);
+	} else
+		hwif->INSW(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+			   wcount << 1);
 }
 
 /*
@@ -216,15 +222,18 @@ static void ata_output_data(ide_drive_t 
 	if (io_32bit) {
 		if (io_32bit & 2) {
 			unsigned long flags;
+
 			local_irq_save(flags);
-			ata_vlb_sync(drive, IDE_NSECTOR_REG);
-			hwif->OUTSL(IDE_DATA_REG, buffer, wcount);
+			ata_vlb_sync(drive, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+			hwif->OUTSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+				    wcount);
 			local_irq_restore(flags);
 		} else
-			hwif->OUTSL(IDE_DATA_REG, buffer, wcount);
-	} else {
-		hwif->OUTSW(IDE_DATA_REG, buffer, wcount<<1);
-	}
+			hwif->OUTSL(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+				    wcount);
+	} else
+		hwif->OUTSW(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+			    wcount << 1);
 }
 
 /*
@@ -243,13 +252,15 @@ static void atapi_input_bytes(ide_drive_
 #if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
 	if (MACH_IS_ATARI || MACH_IS_Q40) {
 		/* Atari has a byte-swapped IDE interface */
-		insw_swapw(IDE_DATA_REG, buffer, bytecount / 2);
+		insw_swapw(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+			   bytecount / 2);
 		return;
 	}
 #endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_input_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
-		hwif->INSW(IDE_DATA_REG, ((u8 *)buffer)+(bytecount & ~0x03), 1);
+		hwif->INSW(hwif->io_ports[IDE_DATA_OFFSET],
+			   (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
 static void atapi_output_bytes(ide_drive_t *drive, void *buffer, u32 bytecount)
@@ -260,13 +271,15 @@ static void atapi_output_bytes(ide_drive
 #if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
 	if (MACH_IS_ATARI || MACH_IS_Q40) {
 		/* Atari has a byte-swapped IDE interface */
-		outsw_swapw(IDE_DATA_REG, buffer, bytecount / 2);
+		outsw_swapw(hwif->io_ports[IDE_DATA_OFFSET], buffer,
+			    bytecount / 2);
 		return;
 	}
 #endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_output_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
-		hwif->OUTSW(IDE_DATA_REG, ((u8*)buffer)+(bytecount & ~0x03), 1);
+		hwif->OUTSW(hwif->io_ports[IDE_DATA_OFFSET],
+			    (u8 *)buffer + (bytecount & ~0x03), 1);
 }
 
 void default_hwif_transport(ide_hwif_t *hwif)
@@ -429,7 +442,7 @@ int drive_is_ready (ide_drive_t *drive)
 	 * an interrupt with another pci card/device.  We make no assumptions
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
-	if (IDE_CONTROL_REG)
+	if (hwif->io_ports[IDE_CONTROL_OFFSET])
 		stat = ide_read_altstatus(drive);
 	else
 		/* Note: this may clear a pending IRQ!! */
@@ -630,7 +643,7 @@ int ide_driveid_update(ide_drive_t *driv
 	SELECT_MASK(drive, 1);
 	ide_set_irq(drive, 1);
 	msleep(50);
-	hwif->OUTB(WIN_IDENTIFY, IDE_COMMAND_REG);
+	hwif->OUTB(WIN_IDENTIFY, hwif->io_ports[IDE_COMMAND_OFFSET]);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -717,9 +730,10 @@ int ide_config_drive_speed(ide_drive_t *
 	SELECT_MASK(drive, 0);
 	udelay(1);
 	ide_set_irq(drive, 0);
-	hwif->OUTB(speed, IDE_NSECTOR_REG);
-	hwif->OUTB(SETFEATURES_XFER, IDE_FEATURE_REG);
-	hwif->OUTBSYNC(drive, WIN_SETFEATURES, IDE_COMMAND_REG);
+	hwif->OUTB(speed, hwif->io_ports[IDE_NSECTOR_OFFSET]);
+	hwif->OUTB(SETFEATURES_XFER, hwif->io_ports[IDE_FEATURE_OFFSET]);
+	hwif->OUTBSYNC(drive, WIN_SETFEATURES,
+		       hwif->io_ports[IDE_COMMAND_OFFSET]);
 	if (drive->quirk_list == 2)
 		ide_set_irq(drive, 1);
 
@@ -827,7 +841,7 @@ void ide_execute_command(ide_drive_t *dr
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->OUTBSYNC(drive, cmd, IDE_COMMAND_REG);
+	hwif->OUTBSYNC(drive, cmd, hwif->io_ports[IDE_COMMAND_OFFSET]);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -1008,7 +1022,8 @@ static ide_startstop_t do_reset1 (ide_dr
 	unsigned long flags;
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
-	
+	u8 ctl;
+
 	spin_lock_irqsave(&ide_lock, flags);
 	hwif = HWIF(drive);
 	hwgroup = HWGROUP(drive);
@@ -1022,7 +1037,8 @@ static ide_startstop_t do_reset1 (ide_dr
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->OUTBSYNC(drive, WIN_SRST, IDE_COMMAND_REG);
+		hwif->OUTBSYNC(drive, WIN_SRST,
+			       hwif->io_ports[IDE_COMMAND_OFFSET]);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1038,7 +1054,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	for (unit = 0; unit < MAX_DRIVES; ++unit)
 		pre_reset(&hwif->drives[unit]);
 
-	if (!IDE_CONTROL_REG) {
+	if (hwif->io_ports[IDE_CONTROL_OFFSET] == 0) {
 		spin_unlock_irqrestore(&ide_lock, flags);
 		return ide_stopped;
 	}
@@ -1053,16 +1069,14 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * recover from reset very quickly, saving us the first 50ms wait time.
 	 */
 	/* set SRST and nIEN */
-	hwif->OUTBSYNC(drive, drive->ctl|6,IDE_CONTROL_REG);
+	hwif->OUTBSYNC(drive, drive->ctl|6, hwif->io_ports[IDE_CONTROL_OFFSET]);
 	/* more than enough time */
 	udelay(10);
-	if (drive->quirk_list == 2) {
-		/* clear SRST and nIEN */
-		hwif->OUTBSYNC(drive, drive->ctl, IDE_CONTROL_REG);
-	} else {
-		/* clear SRST, leave nIEN */
-		hwif->OUTBSYNC(drive, drive->ctl|2, IDE_CONTROL_REG);
-	}
+	if (drive->quirk_list == 2)
+		ctl = drive->ctl;	/* clear SRST and nIEN */
+	else
+		ctl = drive->ctl | 2;	/* clear SRST, leave nIEN */
+	hwif->OUTBSYNC(drive, ctl, hwif->io_ports[IDE_CONTROL_OFFSET]);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -271,7 +271,7 @@ static int actual_try_to_identify (ide_d
 	/* take a deep breath */
 	msleep(50);
 
-	if (IDE_CONTROL_REG) {
+	if (hwif->io_ports[IDE_CONTROL_OFFSET]) {
 		a = ide_read_altstatus(drive);
 		s = ide_read_status(drive);
 		if ((a ^ s) & ~INDEX_STAT)
@@ -289,10 +289,10 @@ static int actual_try_to_identify (ide_d
 	 */
 	if ((cmd == WIN_PIDENTIFY))
 		/* disable dma & overlap */
-		hwif->OUTB(0, IDE_FEATURE_REG);
+		hwif->OUTB(0, hwif->io_ports[IDE_FEATURE_OFFSET]);
 
 	/* ask drive for ID */
-	hwif->OUTB(cmd, IDE_COMMAND_REG);
+	hwif->OUTB(cmd, hwif->io_ports[IDE_COMMAND_OFFSET]);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -353,7 +353,7 @@ static int try_to_identify (ide_drive_t 
 	 * interrupts during the identify-phase that
 	 * the irq handler isn't expecting.
 	 */
-	if (IDE_CONTROL_REG) {
+	if (hwif->io_ports[IDE_CONTROL_OFFSET]) {
 		if (!hwif->irq) {
 			autoprobe = 1;
 			cookie = probe_irq_on();
@@ -445,7 +445,8 @@ static int do_probe (ide_drive_t *drive,
 	msleep(50);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	if (hwif->INB(IDE_SELECT_REG) != drive->select.all && !drive->present) {
+	if (hwif->INB(hwif->io_ports[IDE_SELECT_OFFSET]) != drive->select.all &&
+	    !drive->present) {
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
@@ -477,9 +478,11 @@ static int do_probe (ide_drive_t *drive,
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
-			hwif->OUTB(drive->select.all, IDE_SELECT_REG);
+			hwif->OUTB(drive->select.all,
+				   hwif->io_ports[IDE_SELECT_OFFSET]);
 			msleep(50);
-			hwif->OUTB(WIN_SRST, IDE_COMMAND_REG);
+			hwif->OUTB(WIN_SRST,
+				   hwif->io_ports[IDE_COMMAND_OFFSET]);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -515,7 +518,7 @@ static void enable_nest (ide_drive_t *dr
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->OUTB(EXABYTE_ENABLE_NEST, IDE_COMMAND_REG);
+	hwif->OUTB(EXABYTE_ENABLE_NEST, hwif->io_ports[IDE_COMMAND_OFFSET]);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1117,10 +1117,10 @@ static ide_startstop_t idetape_pc_intr(i
 		return ide_do_reset(drive);
 	}
 	/* Get the number of bytes to transfer on this interrupt. */
-	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
-		  hwif->INB(IDE_BCOUNTL_REG);
+	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
+		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
 
-	ireason = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
@@ -1224,12 +1224,12 @@ static ide_startstop_t idetape_transfer_
 				"yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
 		printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n");
 		udelay(100);
-		ireason = hwif->INB(IDE_IREASON_REG);
+		ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 		if (retries == 0) {
 			printk(KERN_ERR "ide-tape: (IO,CoD != (0,1) while "
 					"issuing a packet command, ignoring\n");
@@ -1323,7 +1323,7 @@ static ide_startstop_t idetape_issue_pc(
 				    IDETAPE_WAIT_CMD, NULL);
 		return ide_started;
 	} else {
-		hwif->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
 		return idetape_transfer_pc(drive);
 	}
 }
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -59,32 +59,34 @@ void ide_tf_load(ide_drive_t *drive, ide
 		SELECT_MASK(drive, 0);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA)
-		hwif->OUTW((tf->hob_data << 8) | tf->data, IDE_DATA_REG);
+		hwif->OUTW((tf->hob_data << 8) | tf->data,
+			   hwif->io_ports[IDE_DATA_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
-		hwif->OUTB(tf->hob_feature, IDE_FEATURE_REG);
+		hwif->OUTB(tf->hob_feature, hwif->io_ports[IDE_FEATURE_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
-		hwif->OUTB(tf->hob_nsect, IDE_NSECTOR_REG);
+		hwif->OUTB(tf->hob_nsect, hwif->io_ports[IDE_NSECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
-		hwif->OUTB(tf->hob_lbal, IDE_SECTOR_REG);
+		hwif->OUTB(tf->hob_lbal, hwif->io_ports[IDE_SECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
-		hwif->OUTB(tf->hob_lbam, IDE_LCYL_REG);
+		hwif->OUTB(tf->hob_lbam, hwif->io_ports[IDE_LCYL_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
-		hwif->OUTB(tf->hob_lbah, IDE_HCYL_REG);
+		hwif->OUTB(tf->hob_lbah, hwif->io_ports[IDE_HCYL_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
-		hwif->OUTB(tf->feature, IDE_FEATURE_REG);
+		hwif->OUTB(tf->feature, hwif->io_ports[IDE_FEATURE_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
-		hwif->OUTB(tf->nsect, IDE_NSECTOR_REG);
+		hwif->OUTB(tf->nsect, hwif->io_ports[IDE_NSECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
-		hwif->OUTB(tf->lbal, IDE_SECTOR_REG);
+		hwif->OUTB(tf->lbal, hwif->io_ports[IDE_SECTOR_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
-		hwif->OUTB(tf->lbam, IDE_LCYL_REG);
+		hwif->OUTB(tf->lbam, hwif->io_ports[IDE_LCYL_OFFSET]);
 	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
-		hwif->OUTB(tf->lbah, IDE_HCYL_REG);
+		hwif->OUTB(tf->lbah, hwif->io_ports[IDE_HCYL_OFFSET]);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		hwif->OUTB((tf->device & HIHI) | drive->select.all, IDE_SELECT_REG);
+		hwif->OUTB((tf->device & HIHI) | drive->select.all,
+			   hwif->io_ports[IDE_SELECT_OFFSET]);
 }
 
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
@@ -152,7 +154,8 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->OUTBSYNC(drive, tf->command, IDE_COMMAND_REG);
+		hwif->OUTBSYNC(drive, tf->command,
+			       hwif->io_ports[IDE_COMMAND_OFFSET]);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -79,7 +79,7 @@
  * out how they setup those cycle time interfacing values, as they at Holtek
  * call them. IDESETUP.COM that is supplied with the drivers figures out
  * optimal values and fetches those values to drivers. I found out that
- * they use IDE_SELECT_REG to fetch timings to the ide board right after
+ * they use Select register to fetch timings to the ide board right after
  * interface switching. After that it was quite easy to add code to
  * ht6560b.c.
  *
@@ -124,6 +124,7 @@
  */
 static void ht6560b_selectproc (ide_drive_t *drive)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 	static u8 current_select = 0;
 	static u8 current_timing = 0;
@@ -147,8 +148,8 @@ static void ht6560b_selectproc (ide_driv
 		/*
 		 * Set timing for this drive:
 		 */
-		outb(timing, IDE_SELECT_REG);
-		(void)inb(IDE_STATUS_REG);
+		outb(timing, hwif->io_ports[IDE_SELECT_OFFSET]);
+		(void)inb(hwif->io_ports[IDE_STATUS_OFFSET]);
 #ifdef DEBUG
 		printk("ht6560b: %s: select=%#x timing=%#x\n",
 			drive->name, select, timing);
@@ -185,9 +186,9 @@ static int __init try_to_init_ht6560b(vo
 	 * Ht6560b autodetected
 	 */
 	outb(HT_CONFIG_DEFAULT, HT_CONFIG_PORT);
-	outb(HT_TIMING_DEFAULT, 0x1f6);  /* IDE_SELECT_REG */
-	(void) inb(0x1f7);               /* IDE_STATUS_REG */
-	
+	outb(HT_TIMING_DEFAULT, 0x1f6);	/* Select register */
+	(void)inb(0x1f7);		/* Status register */
+
 	printk("\nht6560b " HT6560B_VERSION
 	       ": chipset detected and initialized"
 #ifdef DEBUG
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -760,7 +760,7 @@ static void hpt3xx_maskproc(ide_drive_t 
 		}
 	} else
 		outb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-		     IDE_CONTROL_REG);
+		     hwif->io_ports[IDE_CONTROL_OFFSET]);
 }
 
 /*
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -334,7 +334,8 @@ static int scc_ide_dma_end(ide_drive_t *
 
 	/* errata A308 workaround: Step5 (check data loss) */
 	/* We don't check non ide_disk because it is limited to UDMA4 */
-	if (!(in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT) &&
+	if (!(in_be32((void __iomem *)hwif->io_ports[IDE_ALTSTATUS_OFFSET])
+	      & ERR_STAT) &&
 	    drive->media == ide_disk && drive->current_speed > XFER_UDMA_4) {
 		reg = in_be32((void __iomem *)intsts_port);
 		if (!(reg & INTSTS_ACTEINT)) {
@@ -437,7 +438,8 @@ static int scc_dma_test_irq(ide_drive_t 
 	u32 int_stat = in_be32((void __iomem *)hwif->dma_base + 0x014);
 
 	/* SCC errata A252,A308 workaround: Step4 */
-	if ((in_be32((void __iomem *)IDE_ALTSTATUS_REG) & ERR_STAT) &&
+	if ((in_be32((void __iomem *)hwif->io_ports[IDE_ALTSTATUS_OFFSET])
+	     & ERR_STAT) &&
 	    (int_stat & INTSTS_INTRQ))
 		return 1;
 
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -112,10 +112,9 @@ static void
 sgiioc4_maskproc(ide_drive_t * drive, int mask)
 {
 	writeb(mask ? (drive->ctl | 2) : (drive->ctl & ~2),
-	       (void __iomem *)IDE_CONTROL_REG);
+	       (void __iomem *)drive->hwif->io_ports[IDE_CONTROL_OFFSET]);
 }
 
-
 static int
 sgiioc4_checkirq(ide_hwif_t * hwif)
 {
@@ -142,18 +141,18 @@ sgiioc4_clearirq(ide_drive_t * drive)
 	intr_reg = readl((void __iomem *)other_ir);
 	if (intr_reg & 0x03) { /* Valid IOC4-IDE interrupt */
 		/*
-		 * Using sgiioc4_INB to read the IDE_STATUS_REG has a side effect
-		 * of clearing the interrupt.  The first read should clear it
-		 * if it is set.  The second read should return a "clear" status
-		 * if it got cleared.  If not, then spin for a bit trying to
-		 * clear it.
+		 * Using sgiioc4_INB to read the Status register has a side
+		 * effect of clearing the interrupt.  The first read should
+		 * clear it if it is set.  The second read should return
+		 * a "clear" status if it got cleared.  If not, then spin
+		 * for a bit trying to clear it.
 		 */
-		u8 stat = sgiioc4_INB(IDE_STATUS_REG);
+		u8 stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
 		int count = 0;
-		stat = sgiioc4_INB(IDE_STATUS_REG);
+		stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
 		while ((stat & 0x80) && (count++ < 100)) {
 			udelay(1);
-			stat = sgiioc4_INB(IDE_STATUS_REG);
+			stat = sgiioc4_INB(hwif->io_ports[IDE_STATUS_OFFSET]);
 		}
 
 		if (intr_reg & 0x02) {
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -450,7 +450,8 @@ pmac_ide_init_hwif_ports(hw_regs_t *hw,
 	hw->dev = &pmac_ide[ix].mdev->ofdev.dev;
 }
 
-#define PMAC_IDE_REG(x) ((void __iomem *)(IDE_DATA_REG+(x)))
+#define PMAC_IDE_REG(x) \
+	((void __iomem *)((drive)->hwif->io_ports[IDE_DATA_OFFSET] + (x)))
 
 /*
  * Apply the timings of the proper unit (master/slave) to the shared
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -275,9 +275,12 @@ static int idescsi_end_request(ide_drive
 static ide_startstop_t
 idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
+	ide_hwif_t *hwif = drive->hwif;
+
 	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		HWIF(drive)->OUTB(WIN_IDLEIMMEDIATE,IDE_COMMAND_REG);
+		hwif->OUTB(WIN_IDLEIMMEDIATE,
+			   hwif->io_ports[IDE_COMMAND_OFFSET]);
 
 	rq->errors++;
 
@@ -423,9 +426,9 @@ static ide_startstop_t idescsi_pc_intr (
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	bcount = (hwif->INB(IDE_BCOUNTH_REG) << 8) |
-		  hwif->INB(IDE_BCOUNTL_REG);
-	ireason = hwif->INB(IDE_IREASON_REG);
+	bcount = (hwif->INB(hwif->io_ports[IDE_BCOUNTH_OFFSET]) << 8) |
+		  hwif->INB(hwif->io_ports[IDE_BCOUNTL_OFFSET]);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
@@ -497,7 +500,7 @@ static ide_startstop_t idescsi_transfer_
 			"initiated yet DRQ isn't asserted\n");
 		return startstop;
 	}
-	ireason = hwif->INB(IDE_IREASON_REG);
+	ireason = hwif->INB(hwif->io_ports[IDE_IREASON_OFFSET]);
 	if ((ireason & CD) == 0 || (ireason & IO)) {
 		printk(KERN_ERR "ide-scsi: (IO,CoD) != (0,1) while "
 				"issuing a packet command\n");
@@ -587,7 +590,7 @@ static ide_startstop_t idescsi_issue_pc 
 		return ide_started;
 	} else {
 		/* Issue the packet command */
-		HWIF(drive)->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
+		hwif->OUTB(WIN_PACKETCMD, hwif->io_ports[IDE_COMMAND_OFFSET]);
 		return idescsi_transfer_pc(drive);
 	}
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -82,24 +82,10 @@ typedef unsigned char	byte;	/* used ever
 
 #define IDE_FEATURE_OFFSET	IDE_ERROR_OFFSET
 #define IDE_COMMAND_OFFSET	IDE_STATUS_OFFSET
-
-#define IDE_DATA_REG		(HWIF(drive)->io_ports[IDE_DATA_OFFSET])
-#define IDE_ERROR_REG		(HWIF(drive)->io_ports[IDE_ERROR_OFFSET])
-#define IDE_NSECTOR_REG		(HWIF(drive)->io_ports[IDE_NSECTOR_OFFSET])
-#define IDE_SECTOR_REG		(HWIF(drive)->io_ports[IDE_SECTOR_OFFSET])
-#define IDE_LCYL_REG		(HWIF(drive)->io_ports[IDE_LCYL_OFFSET])
-#define IDE_HCYL_REG		(HWIF(drive)->io_ports[IDE_HCYL_OFFSET])
-#define IDE_SELECT_REG		(HWIF(drive)->io_ports[IDE_SELECT_OFFSET])
-#define IDE_STATUS_REG		(HWIF(drive)->io_ports[IDE_STATUS_OFFSET])
-#define IDE_CONTROL_REG		(HWIF(drive)->io_ports[IDE_CONTROL_OFFSET])
-#define IDE_IRQ_REG		(HWIF(drive)->io_ports[IDE_IRQ_OFFSET])
-
-#define IDE_FEATURE_REG		IDE_ERROR_REG
-#define IDE_COMMAND_REG		IDE_STATUS_REG
-#define IDE_ALTSTATUS_REG	IDE_CONTROL_REG
-#define IDE_IREASON_REG		IDE_NSECTOR_REG
-#define IDE_BCOUNTL_REG		IDE_LCYL_REG
-#define IDE_BCOUNTH_REG		IDE_HCYL_REG
+#define IDE_ALTSTATUS_OFFSET	IDE_CONTROL_OFFSET
+#define IDE_IREASON_OFFSET	IDE_NSECTOR_OFFSET
+#define IDE_BCOUNTL_OFFSET	IDE_LCYL_OFFSET
+#define IDE_BCOUNTH_OFFSET	IDE_HCYL_OFFSET
 
 #define OK_STAT(stat,good,bad)	(((stat)&((good)|(bad)))==(good))
 #define BAD_R_STAT		(BUSY_STAT   | ERR_STAT)
@@ -369,7 +355,7 @@ typedef struct ide_drive_s {
         u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */
 	u8	media;		/* disk, cdrom, tape, floppy, ... */
-	u8	ctl;		/* "normal" value for IDE_CONTROL_REG */
+	u8	ctl;		/* "normal" value for Control register */
 	u8	ready_stat;	/* min status value for drive ready */
 	u8	mult_count;	/* current multiple sector setting */
 	u8	mult_req;	/* requested multiple sector setting */
@@ -1275,7 +1261,10 @@ static inline ide_drive_t *ide_get_paire
 
 static inline void ide_set_irq(ide_drive_t *drive, int on)
 {
-	drive->hwif->OUTB(drive->ctl | (on ? 0 : 2), IDE_CONTROL_REG);
+	ide_hwif_t *hwif = drive->hwif;
+
+	hwif->OUTB(drive->ctl | (on ? 0 : 2),
+		   hwif->io_ports[IDE_CONTROL_OFFSET]);
 }
 
 static inline u8 ide_read_status(ide_drive_t *drive)
