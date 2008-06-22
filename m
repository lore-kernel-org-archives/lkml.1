Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYFVTe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYFVTe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbYFVTeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:34:21 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:35234 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbYFVTeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Awj/gjp4lOKF/3WafgquJ5Bgj9Q0rWOq+tRaMjSJpQlAaYtXDiZtDOwKiEx3ELt9D/
         p1ZQtCNXpLuz2yWXzhVZVba/N4qcKRN0rSblK+sWBw7I7IBMZZA+7mU51yL79ZcortwY
         yucyswrqTUfoVJan4wT8dKKxSIhan5iYCgb8A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2008 21:36:01 +0200
Message-Id: <20080622193601.5325.98852.sendpatchset@localhost.localdomain>
In-Reply-To: <20080622193537.5325.43764.sendpatchset@localhost.localdomain>
References: <20080622193537.5325.43764.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/4] ide: add struct ide_tp_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add struct ide_tp_ops for transport methods.

* Add 'const struct ide_tp_ops *tp_ops' to struct ide_port_info
  and ide_hwif_t.

* Set the default hwif->tp_ops in ide_init_port_data().

* Set host driver specific hwif->tp_ops in ide_init_port().

* Export ide_exec_command(), ide_read_status(), ide_read_altstatus(),
  ide_read_sff_dma_status(), ide_set_irq(), ide_tf_{load,read}()
  and ata_{in,out}put_data().

* Convert host drivers and core code to use struct ide_tp_ops.

* Remove no longer needed default_hwif_transport().

* Cleanup ide_hwif_t from methods that are now in struct ide_tp_ops.

While at it:

* Use struct ide_port_info in falconide.c and q40ide.c.

* Rename ata_{in,out}put_data() to ide_{in,out}put_data().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c       |    2 
 drivers/ide/h8300/ide-h8300.c  |   26 +++++---
 drivers/ide/ide-atapi.c        |   13 ++--
 drivers/ide/ide-cd.c           |   12 ++--
 drivers/ide/ide-dma.c          |   12 ++--
 drivers/ide/ide-floppy.c       |    8 +-
 drivers/ide/ide-io.c           |   32 +++++-----
 drivers/ide/ide-iops.c         |  122 ++++++++++++++++++++++-------------------
 drivers/ide/ide-lib.c          |    2 
 drivers/ide/ide-probe.c        |   53 ++++++++++-------
 drivers/ide/ide-tape.c         |    8 +-
 drivers/ide/ide-taskfile.c     |   29 +++++----
 drivers/ide/ide.c              |    2 
 drivers/ide/legacy/falconide.c |   27 +++++++--
 drivers/ide/legacy/q40ide.c    |   27 +++++++--
 drivers/ide/mips/au1xxx-ide.c  |   29 ++++++---
 drivers/ide/pci/ns87415.c      |   48 +++++++++-------
 drivers/ide/pci/scc_pata.c     |   29 +++++----
 drivers/ide/pci/sgiioc4.c      |   18 +++++-
 drivers/ide/ppc/pmac.c         |   21 +++++--
 drivers/ide/setup-pci.c        |    2 
 drivers/scsi/ide-scsi.c        |    7 +-
 include/linux/ide.h            |   52 +++++++++++------
 23 files changed, 357 insertions(+), 224 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -382,7 +382,7 @@ static void icside_dma_timeout(ide_drive
 	if (icside_dma_test_irq(drive))
 		return;
 
-	ide_dump_status(drive, "DMA timeout", hwif->read_status(hwif));
+	ide_dump_status(drive, "DMA timeout", hwif->tp_ops->read_status(hwif));
 
 	icside_dma_end(drive);
 }
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -155,6 +155,21 @@ static void h8300_output_data(ide_drive_
 	mm_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
+static const struct ide_tp_ops h8300_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= h8300_tf_load,
+	.tf_read		= h8300_tf_read,
+
+	.input_data		= h8300_input_data,
+	.output_data		= h8300_output_data,
+};
+
 #define H8300_IDE_GAP (2)
 
 static inline void hw_setup(hw_regs_t *hw)
@@ -169,16 +184,8 @@ static inline void hw_setup(hw_regs_t *h
 	hw->chipset = ide_generic;
 }
 
-static inline void hwif_setup(ide_hwif_t *hwif)
-{
-	hwif->tf_load = h8300_tf_load;
-	hwif->tf_read = h8300_tf_read;
-
-	hwif->input_data  = h8300_input_data;
-	hwif->output_data = h8300_output_data;
-}
-
 static const struct ide_port_info h8300_port_info = {
+	.tp_ops			= &h8300_tp_ops,
 	.host_flags		= IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_NO_DMA,
 };
 
@@ -205,7 +212,6 @@ static int __init h8300_ide_init(void)
 		return -ENOENT;
 
 	index = hwif->index;
-	hwif_setup(hwif);
 
 	idx[0] = index;
 
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -22,6 +22,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
 	unsigned int temp;
 	u16 bcount;
@@ -35,7 +36,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 	}
 
 	/* Clear the interrupt */
-	stat = hwif->read_status(hwif);
+	stat = tp_ops->read_status(hwif);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->dma_ops->dma_end(drive) ||
@@ -140,7 +141,7 @@ cmd_finished:
 					if (pc->sg)
 						io_buffers(drive, pc, temp, 0);
 					else
-						hwif->input_data(drive, NULL,
+						tp_ops->input_data(drive, NULL,
 							pc->cur_pos, temp);
 					printk(KERN_ERR "%s: transferred %d of "
 							"%d bytes\n",
@@ -157,9 +158,9 @@ cmd_finished:
 			debug_log("The device wants to send us more data than "
 				  "expected - allowing transfer\n");
 		}
-		xferfunc = hwif->input_data;
+		xferfunc = tp_ops->input_data;
 	} else
-		xferfunc = hwif->output_data;
+		xferfunc = tp_ops->output_data;
 
 	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
 	    (drive->media == ide_tape && !scsi && pc->bh) ||
@@ -188,7 +189,7 @@ static u8 ide_read_ireason(ide_drive_t *
 	memset(&task, 0, sizeof(task));
 	task.tf_flags = IDE_TFLAG_IN_NSECT;
 
-	drive->hwif->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &task);
 
 	return task.tf.nsect & 3;
 }
@@ -249,7 +250,7 @@ ide_startstop_t ide_transfer_pc(ide_driv
 
 	/* Send the actual packet */
 	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
-		hwif->output_data(drive, NULL, pc->c, 12);
+		hwif->tp_ops->output_data(drive, NULL, pc->c, 12);
 
 	return ide_started;
 }
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -285,7 +285,7 @@ static int cdrom_decode_status(ide_drive
 	int stat, err, sense_key;
 
 	/* check for errors */
-	stat = hwif->read_status(hwif);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (stat_ret)
 		*stat_ret = stat;
@@ -590,7 +590,7 @@ static ide_startstop_t cdrom_transfer_pa
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
 	/* send the command to the device */
-	hwif->output_data(drive, NULL, rq->cmd, cmd_len);
+	hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
 
 	/* start the DMA if need be */
 	if (info->dma)
@@ -627,7 +627,7 @@ static int ide_cd_check_ireason(ide_driv
 		 * Some drives (ASUS) seem to tell us that status info is
 		 * available.  Just get it and ignore.
 		 */
-		(void)hwif->read_status(hwif);
+		(void)hwif->tp_ops->read_status(hwif);
 		return 0;
 	} else {
 		/* drive wants a command packet, or invalid ireason... */
@@ -990,10 +990,10 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	if (ireason == 0) {
 		write = 1;
-		xferfunc = hwif->output_data;
+		xferfunc = hwif->tp_ops->output_data;
 	} else {
 		write = 0;
-		xferfunc = hwif->input_data;
+		xferfunc = hwif->tp_ops->input_data;
 	}
 
 	/* transfer data */
@@ -1189,7 +1189,7 @@ static ide_startstop_t ide_cd_do_request
 		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
 			ide_hwif_t *hwif = drive->hwif;
 			unsigned long elapsed = jiffies - info->start_seek;
-			int stat = hwif->read_status(hwif);
+			int stat = hwif->tp_ops->read_status(hwif);
 
 			if ((stat & SEEK_STAT) != SEEK_STAT) {
 				if (elapsed < IDECD_SEEK_TIMEOUT) {
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -104,7 +104,7 @@ ide_startstop_t ide_dma_intr (ide_drive_
 	u8 stat = 0, dma_stat = 0;
 
 	dma_stat = hwif->dma_ops->dma_end(drive);
-	stat = hwif->read_status(hwif);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat,DRIVE_READY,drive->bad_wstat|DRQ_STAT)) {
 		if (!dma_stat) {
@@ -335,7 +335,7 @@ static int config_drive_for_dma (ide_dri
 static int dma_timer_expiry (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->read_sff_dma_status(hwif);
+	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
 
 	printk(KERN_WARNING "%s: dma_timer_expiry: dma status == 0x%02x\n",
 		drive->name, dma_stat);
@@ -370,7 +370,7 @@ void ide_dma_host_set(ide_drive_t *drive
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 unit			= (drive->select.b.unit & 0x01);
-	u8 dma_stat		= hwif->read_sff_dma_status(hwif);
+	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
 
 	if (on)
 		dma_stat |= (1 << (5 + unit));
@@ -482,7 +482,7 @@ int ide_dma_setup(ide_drive_t *drive)
 		outb(reading, hwif->dma_base + ATA_DMA_CMD);
 
 	/* read DMA status for INTR & ERROR flags */
-	dma_stat = hwif->read_sff_dma_status(hwif);
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 
 	/* clear INTR & ERROR flags */
 	if (mmio)
@@ -551,7 +551,7 @@ int __ide_dma_end (ide_drive_t *drive)
 	}
 
 	/* get DMA status */
-	dma_stat = hwif->read_sff_dma_status(hwif);
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 
 	if (mmio)
 		/* clear the INTR & ERROR bits */
@@ -574,7 +574,7 @@ EXPORT_SYMBOL(__ide_dma_end);
 int ide_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->read_sff_dma_status(hwif);
+	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
 
 	/* return 1 if INTR asserted */
 	if ((dma_stat & 4) == 4)
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -247,9 +247,9 @@ static void ide_floppy_io_buffers(ide_dr
 
 		data = bvec_kmap_irq(bvec, &flags);
 		if (direction)
-			hwif->output_data(drive, NULL, data, count);
+			hwif->tp_ops->output_data(drive, NULL, data, count);
 		else
-			hwif->input_data(drive, NULL, data, count);
+			hwif->tp_ops->input_data(drive, NULL, data, count);
 		bvec_kunmap_irq(data, &flags);
 
 		bcount -= count;
@@ -402,7 +402,7 @@ static int idefloppy_transfer_pc(ide_dri
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	/* Send the actual packet */
-	drive->hwif->output_data(drive, NULL, floppy->pc->c, 12);
+	drive->hwif->tp_ops->output_data(drive, NULL, floppy->pc->c, 12);
 
 	/* Timeout for the packet command */
 	return IDEFLOPPY_WAIT_CMD;
@@ -954,7 +954,7 @@ static int idefloppy_get_format_progress
 		u8 stat;
 
 		local_irq_save(flags);
-		stat = hwif->read_status(hwif);
+		stat = hwif->tp_ops->read_status(hwif);
 		local_irq_restore(flags);
 
 		progress_indication = ((stat & SEEK_STAT) == 0) ? 0 : 0x10000;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -330,7 +330,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 			tf->error = err;
 			tf->status = stat;
 
-			drive->hwif->tf_read(drive, task);
+			drive->hwif->tp_ops->tf_read(drive, task);
 
 			if (task->tf_flags & IDE_TFLAG_DYN)
 				kfree(task);
@@ -381,7 +381,7 @@ static ide_startstop_t ide_ata_error(ide
 		if (err == ABRT_ERR) {
 			if (drive->select.b.lba &&
 			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->read_status(hwif) == WIN_SPECIFY)
+			    hwif->tp_ops->read_status(hwif) == WIN_SPECIFY)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
 			/* UDMA crc error, just retry the operation */
@@ -407,7 +407,7 @@ static ide_startstop_t ide_ata_error(ide
 		return ide_stopped;
 	}
 
-	if (hwif->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		rq->errors |= ERROR_RESET;
 
 	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
@@ -434,9 +434,9 @@ static ide_startstop_t ide_atapi_error(i
 		/* add decoding error stuff */
 	}
 
-	if (hwif->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->exec_command(hwif, WIN_IDLEIMMEDIATE);
+		hwif->tp_ops->exec_command(hwif, WIN_IDLEIMMEDIATE);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
@@ -759,7 +759,7 @@ static ide_startstop_t execute_drive_cmd
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	ide_end_drive_cmd(drive, hwif->read_status(hwif),
+	ide_end_drive_cmd(drive, hwif->tp_ops->read_status(hwif),
 			  ide_read_error(drive));
 
  	return ide_stopped;
@@ -792,7 +792,7 @@ static void ide_check_pm_state(ide_drive
 		if (rc)
 			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
 		SELECT_DRIVE(drive);
-		hwif->set_irq(hwif, 1);
+		hwif->tp_ops->set_irq(hwif, 1);
 		rc = ide_wait_not_busy(hwif, 100000);
 		if (rc)
 			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
@@ -1070,7 +1070,7 @@ static void ide_do_request (ide_hwgroup_
 			 * quirk_list may not like intr setups/cleanups
 			 */
 			if (drive->quirk_list != 1)
-				hwif->set_irq(hwif, 0);
+				hwif->tp_ops->set_irq(hwif, 0);
 		}
 		hwgroup->hwif = hwif;
 		hwgroup->drive = drive;
@@ -1170,7 +1170,7 @@ static ide_startstop_t ide_dma_timeout_r
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
 		(void)hwif->dma_ops->dma_end(drive);
 		ret = ide_error(drive, "dma timeout error",
-				hwif->read_status(hwif));
+				hwif->tp_ops->read_status(hwif));
 	} else {
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
 		hwif->dma_ops->dma_timeout(drive);
@@ -1295,7 +1295,7 @@ void ide_timer_expiry (unsigned long dat
 				} else
 					startstop =
 					ide_error(drive, "irq timeout",
-						  hwif->read_status(hwif));
+						  hwif->tp_ops->read_status(hwif));
 			}
 			drive->service_time = jiffies - drive->service_start;
 			spin_lock_irq(&ide_lock);
@@ -1351,7 +1351,7 @@ static void unexpected_intr (int irq, id
 	 */
 	do {
 		if (hwif->irq == irq) {
-			stat = hwif->read_status(hwif);
+			stat = hwif->tp_ops->read_status(hwif);
 
 			if (!OK_STAT(stat, READY_STAT, BAD_STAT)) {
 				/* Try to not flood the console with msgs */
@@ -1442,7 +1442,7 @@ irqreturn_t ide_intr (int irq, void *dev
 			 * Whack the status register, just in case
 			 * we have a leftover pending IRQ.
 			 */
-			(void)hwif->read_status(hwif);
+			(void)hwif->tp_ops->read_status(hwif);
 #endif /* CONFIG_BLK_DEV_IDEPCI */
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
@@ -1559,9 +1559,9 @@ void ide_pktcmd_tf_load(ide_drive_t *dri
 	task.tf.lbah    = (bcount >> 8) & 0xff;
 
 	ide_tf_dump(drive->name, &task.tf);
-	hwif->set_irq(hwif, 1);
+	hwif->tp_ops->set_irq(hwif, 1);
 	SELECT_MASK(drive, 0);
-	hwif->tf_load(drive, &task);
+	hwif->tp_ops->tf_load(drive, &task);
 }
 
 EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
@@ -1573,9 +1573,9 @@ void ide_pad_transfer(ide_drive_t *drive
 
 	while (len > 0) {
 		if (write)
-			hwif->output_data(drive, NULL, buf, min(4, len));
+			hwif->tp_ops->output_data(drive, NULL, buf, min(4, len));
 		else
-			hwif->input_data(drive, NULL, buf, min(4, len));
+			hwif->tp_ops->input_data(drive, NULL, buf, min(4, len));
 		len -= 4;
 	}
 }
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -68,7 +68,7 @@ void SELECT_DRIVE (ide_drive_t *drive)
 	memset(&task, 0, sizeof(task));
 	task.tf_flags = IDE_TFLAG_OUT_DEVICE;
 
-	drive->hwif->tf_load(drive, &task);
+	drive->hwif->tp_ops->tf_load(drive, &task);
 }
 
 void SELECT_MASK(ide_drive_t *drive, int mask)
@@ -79,39 +79,43 @@ void SELECT_MASK(ide_drive_t *drive, int
 		port_ops->maskproc(drive, mask);
 }
 
-static void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
+void ide_exec_command(ide_hwif_t *hwif, u8 cmd)
 {
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
 	else
 		outb(cmd, hwif->io_ports.command_addr);
 }
+EXPORT_SYMBOL_GPL(ide_exec_command);
 
-static u8 ide_read_status(ide_hwif_t *hwif)
+u8 ide_read_status(ide_hwif_t *hwif)
 {
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		return readb((void __iomem *)hwif->io_ports.status_addr);
 	else
 		return inb(hwif->io_ports.status_addr);
 }
+EXPORT_SYMBOL_GPL(ide_read_status);
 
-static u8 ide_read_altstatus(ide_hwif_t *hwif)
+u8 ide_read_altstatus(ide_hwif_t *hwif)
 {
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		return readb((void __iomem *)hwif->io_ports.ctl_addr);
 	else
 		return inb(hwif->io_ports.ctl_addr);
 }
+EXPORT_SYMBOL_GPL(ide_read_altstatus);
 
-static u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
+u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
 		return readb((void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
 	else
 		return inb(hwif->dma_base + ATA_DMA_STATUS);
 }
+EXPORT_SYMBOL_GPL(ide_read_sff_dma_status);
 
-static void ide_set_irq(ide_hwif_t *hwif, int on)
+void ide_set_irq(ide_hwif_t *hwif, int on)
 {
 	u8 ctl = ATA_DEVCTL_OBS;
 
@@ -127,8 +131,9 @@ static void ide_set_irq(ide_hwif_t *hwif
 	else
 		outb(ctl, hwif->io_ports.ctl_addr);
 }
+EXPORT_SYMBOL_GPL(ide_set_irq);
 
-static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -180,8 +185,9 @@ static void ide_tf_load(ide_drive_t *dri
 		tf_outb((tf->device & HIHI) | drive->select.all,
 			 io_ports->device_addr);
 }
+EXPORT_SYMBOL_GPL(ide_tf_load);
 
-static void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -241,6 +247,7 @@ static void ide_tf_read(ide_drive_t *dri
 			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
 	}
 }
+EXPORT_SYMBOL_GPL(ide_tf_read);
 
 /*
  * Some localbus EIDE interfaces require a special access sequence
@@ -263,8 +270,8 @@ static void ata_vlb_sync(unsigned long p
  * so if an odd len is specified, be sure that there's at least one
  * extra byte allocated for the buffer.
  */
-static void ata_input_data(ide_drive_t *drive, struct request *rq,
-			   void *buf, unsigned int len)
+void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
+		    unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -304,12 +311,13 @@ static void ata_input_data(ide_drive_t *
 			insw(data_addr, buf, len / 2);
 	}
 }
+EXPORT_SYMBOL_GPL(ide_input_data);
 
 /*
  * This is used for most PIO data transfers *to* the IDE interface
  */
-static void ata_output_data(ide_drive_t *drive, struct request *rq,
-			    void *buf, unsigned int len)
+void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
+		     unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -347,22 +355,7 @@ static void ata_output_data(ide_drive_t 
 			outsw(data_addr, buf, len / 2);
 	}
 }
-
-void default_hwif_transport(ide_hwif_t *hwif)
-{
-	hwif->exec_command	  = ide_exec_command;
-	hwif->read_status	  = ide_read_status;
-	hwif->read_altstatus	  = ide_read_altstatus;
-	hwif->read_sff_dma_status = ide_read_sff_dma_status;
-
-	hwif->set_irq	  = ide_set_irq;
-
-	hwif->tf_load	  = ide_tf_load;
-	hwif->tf_read	  = ide_tf_read;
-
-	hwif->input_data  = ata_input_data;
-	hwif->output_data = ata_output_data;
-}
+EXPORT_SYMBOL_GPL(ide_output_data);
 
 u8 ide_read_error(ide_drive_t *drive)
 {
@@ -371,7 +364,7 @@ u8 ide_read_error(ide_drive_t *drive)
 	memset(&task, 0, sizeof(task));
 	task.tf_flags = IDE_TFLAG_IN_FEATURE;
 
-	drive->hwif->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &task);
 
 	return task.tf.error;
 }
@@ -385,13 +378,28 @@ void ide_read_bcount_and_ireason(ide_dri
 	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
 			IDE_TFLAG_IN_NSECT;
 
-	drive->hwif->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &task);
 
 	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
 	*ireason = task.tf.nsect & 3;
 }
 EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
 
+const struct ide_tp_ops default_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
 void ide_fix_driveid (struct hd_driveid *id)
 {
 #ifndef __LITTLE_ENDIAN
@@ -545,10 +553,10 @@ int drive_is_ready (ide_drive_t *drive)
 	 * about possible isa-pnp and pci-pnp issues yet.
 	 */
 	if (hwif->io_ports.ctl_addr)
-		stat = hwif->read_altstatus(hwif);
+		stat = hwif->tp_ops->read_altstatus(hwif);
 	else
 		/* Note: this may clear a pending IRQ!! */
-		stat = hwif->read_status(hwif);
+		stat = hwif->tp_ops->read_status(hwif);
 
 	if (stat & BUSY_STAT)
 		/* drive busy:  definitely not interrupting */
@@ -574,24 +582,25 @@ EXPORT_SYMBOL(drive_is_ready);
 static int __ide_wait_stat(ide_drive_t *drive, u8 good, u8 bad, unsigned long timeout, u8 *rstat)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	unsigned long flags;
 	int i;
 	u8 stat;
 
 	udelay(1);	/* spec allows drive 400ns to assert "BUSY" */
-	stat = hwif->read_status(hwif);
+	stat = tp_ops->read_status(hwif);
 
 	if (stat & BUSY_STAT) {
 		local_irq_set(flags);
 		timeout += jiffies;
-		while ((stat = hwif->read_status(hwif)) & BUSY_STAT) {
+		while ((stat = tp_ops->read_status(hwif)) & BUSY_STAT) {
 			if (time_after(jiffies, timeout)) {
 				/*
 				 * One last read after the timeout in case
 				 * heavy interrupt load made us not make any
 				 * progress during the timeout..
 				 */
-				stat = hwif->read_status(hwif);
+				stat = tp_ops->read_status(hwif);
 				if (!(stat & BUSY_STAT))
 					break;
 
@@ -611,7 +620,7 @@ static int __ide_wait_stat(ide_drive_t *
 	 */
 	for (i = 0; i < 10; i++) {
 		udelay(1);
-		stat = hwif->read_status(hwif);
+		stat = tp_ops->read_status(hwif);
 
 		if (OK_STAT(stat, good, bad)) {
 			*rstat = stat;
@@ -737,6 +746,7 @@ no_80w:
 int ide_driveid_update(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	struct hd_driveid *id;
 	unsigned long timeout, flags;
 	u8 stat;
@@ -747,9 +757,9 @@ int ide_driveid_update(ide_drive_t *driv
 	 */
 
 	SELECT_MASK(drive, 1);
-	hwif->set_irq(hwif, 1);
+	tp_ops->set_irq(hwif, 1);
 	msleep(50);
-	hwif->exec_command(hwif, WIN_IDENTIFY);
+	tp_ops->exec_command(hwif, WIN_IDENTIFY);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -758,11 +768,11 @@ int ide_driveid_update(ide_drive_t *driv
 		}
 
 		msleep(50);	/* give drive a breather */
-		stat = hwif->read_altstatus(hwif);
+		stat = tp_ops->read_altstatus(hwif);
 	} while (stat & BUSY_STAT);
 
 	msleep(50);	/* wait for IRQ and DRQ_STAT */
-	stat = hwif->read_status(hwif);
+	stat = tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
 		SELECT_MASK(drive, 0);
@@ -776,8 +786,8 @@ int ide_driveid_update(ide_drive_t *driv
 		local_irq_restore(flags);
 		return 0;
 	}
-	hwif->input_data(drive, NULL, id, SECTOR_SIZE);
-	(void)hwif->read_status(hwif);	/* clear drive IRQ */
+	tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
+	(void)tp_ops->read_status(hwif);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
 	ide_fix_driveid(id);
@@ -798,6 +808,7 @@ int ide_driveid_update(ide_drive_t *driv
 int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int error = 0;
 	u8 stat;
 	ide_task_t task;
@@ -833,19 +844,19 @@ int ide_config_drive_speed(ide_drive_t *
 	SELECT_DRIVE(drive);
 	SELECT_MASK(drive, 0);
 	udelay(1);
-	hwif->set_irq(hwif, 0);
+	tp_ops->set_irq(hwif, 0);
 
 	memset(&task, 0, sizeof(task));
 	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
 	task.tf.feature = SETFEATURES_XFER;
 	task.tf.nsect   = speed;
 
-	hwif->tf_load(drive, &task);
+	tp_ops->tf_load(drive, &task);
 
-	hwif->exec_command(hwif, WIN_SETFEATURES);
+	tp_ops->exec_command(hwif, WIN_SETFEATURES);
 
 	if (drive->quirk_list == 2)
-		hwif->set_irq(hwif, 1);
+		tp_ops->set_irq(hwif, 1);
 
 	error = __ide_wait_stat(drive, drive->ready_stat,
 				BUSY_STAT|DRQ_STAT|ERR_STAT,
@@ -950,7 +961,7 @@ void ide_execute_command(ide_drive_t *dr
 
 	spin_lock_irqsave(&ide_lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	hwif->exec_command(hwif, cmd);
+	hwif->tp_ops->exec_command(hwif, cmd);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
 	 * serviced before that.
@@ -968,7 +979,7 @@ void ide_execute_pkt_cmd(ide_drive_t *dr
 	unsigned long flags;
 
 	spin_lock_irqsave(&ide_lock, flags);
-	hwif->exec_command(hwif, WIN_PACKETCMD);
+	hwif->tp_ops->exec_command(hwif, WIN_PACKETCMD);
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -991,7 +1002,7 @@ static ide_startstop_t atapi_reset_pollf
 
 	SELECT_DRIVE(drive);
 	udelay (10);
-	stat = hwif->read_status(hwif);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, 0, BUSY_STAT))
 		printk("%s: ATAPI reset complete\n", drive->name);
@@ -1035,7 +1046,7 @@ static ide_startstop_t reset_pollfunc (i
 		}
 	}
 
-	tmp = hwif->read_status(hwif);
+	tmp = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(tmp, 0, BUSY_STAT)) {
 		if (time_before(jiffies, hwgroup->poll_timeout)) {
@@ -1146,6 +1157,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
 	struct ide_io_ports *io_ports;
+	const struct ide_tp_ops *tp_ops;
 	const struct ide_port_ops *port_ops;
 
 	spin_lock_irqsave(&ide_lock, flags);
@@ -1154,6 +1166,8 @@ static ide_startstop_t do_reset1 (ide_dr
 
 	io_ports = &hwif->io_ports;
 
+	tp_ops = hwif->tp_ops;
+
 	/* We must not reset with running handlers */
 	BUG_ON(hwgroup->handler != NULL);
 
@@ -1163,7 +1177,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		hwif->exec_command(hwif, WIN_SRST);
+		tp_ops->exec_command(hwif, WIN_SRST);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
@@ -1196,11 +1210,11 @@ static ide_startstop_t do_reset1 (ide_dr
 	 * TODO: add ->softreset method and stop abusing ->set_irq
 	 */
 	/* set SRST and nIEN */
-	hwif->set_irq(hwif, 4);
+	tp_ops->set_irq(hwif, 4);
 	/* more than enough time */
 	udelay(10);
 	/* clear SRST, leave nIEN (unless device is on the quirk list) */
-	hwif->set_irq(hwif, drive->quirk_list == 2);
+	tp_ops->set_irq(hwif, drive->quirk_list == 2);
 	/* more than enough time */
 	udelay(10);
 	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
@@ -1245,7 +1259,7 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 		 * about locking issues (2.5 work ?).
 		 */
 		mdelay(1);
-		stat = hwif->read_status(hwif);
+		stat = hwif->tp_ops->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 		/*
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -325,7 +325,7 @@ static void ide_dump_sector(ide_drive_t 
 	else
 		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
 
-	drive->hwif->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &task);
 
 	if (lba48 || (tf->device & ATA_LBA))
 		printk(", LBAsect=%llu",
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -126,7 +126,7 @@ static inline void do_identify (ide_driv
 
 	id = drive->id;
 	/* read 512 bytes of id info */
-	hwif->input_data(drive, NULL, id, SECTOR_SIZE);
+	hwif->tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
 
 	drive->id_read = 1;
 	local_irq_enable();
@@ -267,6 +267,7 @@ static int actual_try_to_identify (ide_d
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct ide_io_ports *io_ports = &hwif->io_ports;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int use_altstatus = 0, rc;
 	unsigned long timeout;
 	u8 s = 0, a = 0;
@@ -275,8 +276,8 @@ static int actual_try_to_identify (ide_d
 	msleep(50);
 
 	if (io_ports->ctl_addr) {
-		a = hwif->read_altstatus(hwif);
-		s = hwif->read_status(hwif);
+		a = tp_ops->read_altstatus(hwif);
+		s = tp_ops->read_status(hwif);
 		if ((a ^ s) & ~INDEX_STAT)
 			/* ancient Seagate drives, broken interfaces */
 			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
@@ -297,11 +298,11 @@ static int actual_try_to_identify (ide_d
 		/* disable DMA & overlap */
 		task.tf_flags = IDE_TFLAG_OUT_FEATURE;
 
-		drive->hwif->tf_load(drive, &task);
+		tp_ops->tf_load(drive, &task);
 	}
 
 	/* ask drive for ID */
-	hwif->exec_command(hwif, cmd);
+	tp_ops->exec_command(hwif, cmd);
 
 	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
@@ -312,13 +313,13 @@ static int actual_try_to_identify (ide_d
 		}
 		/* give drive a breather */
 		msleep(50);
-		s = use_altstatus ? hwif->read_altstatus(hwif)
-				  : hwif->read_status(hwif);
+		s = use_altstatus ? tp_ops->read_altstatus(hwif)
+				  : tp_ops->read_status(hwif);
 	} while (s & BUSY_STAT);
 
 	/* wait for IRQ and DRQ_STAT */
 	msleep(50);
-	s = hwif->read_status(hwif);
+	s = tp_ops->read_status(hwif);
 
 	if (OK_STAT(s, DRQ_STAT, BAD_R_STAT)) {
 		unsigned long flags;
@@ -330,7 +331,7 @@ static int actual_try_to_identify (ide_d
 		/* drive responded with ID */
 		rc = 0;
 		/* clear drive IRQ */
-		(void)hwif->read_status(hwif);
+		(void)tp_ops->read_status(hwif);
 		local_irq_restore(flags);
 	} else {
 		/* drive refused ID */
@@ -352,6 +353,7 @@ static int actual_try_to_identify (ide_d
 static int try_to_identify (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int retval;
 	int autoprobe = 0;
 	unsigned long cookie = 0;
@@ -367,7 +369,7 @@ static int try_to_identify (ide_drive_t 
 			autoprobe = 1;
 			cookie = probe_irq_on();
 		}
-		hwif->set_irq(hwif, autoprobe);
+		tp_ops->set_irq(hwif, autoprobe);
 	}
 
 	retval = actual_try_to_identify(drive, cmd);
@@ -375,9 +377,9 @@ static int try_to_identify (ide_drive_t 
 	if (autoprobe) {
 		int irq;
 
-		hwif->set_irq(hwif, 0);
+		tp_ops->set_irq(hwif, 0);
 		/* clear drive IRQ */
-		(void)hwif->read_status(hwif);
+		(void)tp_ops->read_status(hwif);
 		udelay(5);
 		irq = probe_irq_off(cookie);
 		if (!hwif->irq) {
@@ -402,7 +404,7 @@ static int ide_busy_sleep(ide_hwif_t *hw
 
 	do {
 		msleep(50);
-		stat = hwif->read_status(hwif);
+		stat = hwif->tp_ops->read_status(hwif);
 		if ((stat & BUSY_STAT) == 0)
 			return 0;
 	} while (time_before(jiffies, timeout));
@@ -417,7 +419,7 @@ static u8 ide_read_device(ide_drive_t *d
 	memset(&task, 0, sizeof(task));
 	task.tf_flags = IDE_TFLAG_IN_DEVICE;
 
-	drive->hwif->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &task);
 
 	return task.tf.device;
 }
@@ -446,6 +448,7 @@ static u8 ide_read_device(ide_drive_t *d
 static int do_probe (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	int rc;
 	u8 stat;
 
@@ -478,7 +481,7 @@ static int do_probe (ide_drive_t *drive,
 		return 3;
 	}
 
-	stat = hwif->read_status(hwif);
+	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BUSY_STAT) ||
 	    drive->present || cmd == WIN_PIDENTIFY) {
@@ -488,7 +491,7 @@ static int do_probe (ide_drive_t *drive,
 			rc = try_to_identify(drive,cmd);
 		}
 
-		stat = hwif->read_status(hwif);
+		stat = tp_ops->read_status(hwif);
 
 		if (stat == (BUSY_STAT | READY_STAT))
 			return 4;
@@ -499,13 +502,13 @@ static int do_probe (ide_drive_t *drive,
 			msleep(50);
 			SELECT_DRIVE(drive);
 			msleep(50);
-			hwif->exec_command(hwif, WIN_SRST);
+			tp_ops->exec_command(hwif, WIN_SRST);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
 
 		/* ensure drive IRQ is clear */
-		stat = hwif->read_status(hwif);
+		stat = tp_ops->read_status(hwif);
 
 		if (rc == 1)
 			printk(KERN_ERR "%s: no response (status = 0x%02x)\n",
@@ -519,7 +522,7 @@ static int do_probe (ide_drive_t *drive,
 		SELECT_DRIVE(&hwif->drives[0]);
 		msleep(50);
 		/* ensure drive irq is clear */
-		(void)hwif->read_status(hwif);
+		(void)tp_ops->read_status(hwif);
 	}
 	return rc;
 }
@@ -530,12 +533,13 @@ static int do_probe (ide_drive_t *drive,
 static void enable_nest (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
 	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	hwif->exec_command(hwif, EXABYTE_ENABLE_NEST);
+	tp_ops->exec_command(hwif, EXABYTE_ENABLE_NEST);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
@@ -544,7 +548,7 @@ static void enable_nest (ide_drive_t *dr
 
 	msleep(50);
 
-	stat = hwif->read_status(hwif);
+	stat = tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, 0, BAD_STAT))
 		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
@@ -728,7 +732,7 @@ static int ide_port_wait_ready(ide_hwif_
 		/* Ignore disks that we will not probe for later. */
 		if (!drive->noprobe || drive->present) {
 			SELECT_DRIVE(drive);
-			hwif->set_irq(hwif, 1);
+			hwif->tp_ops->set_irq(hwif, 1);
 			mdelay(2);
 			rc = ide_wait_not_busy(hwif, 35000);
 			if (rc)
@@ -1085,7 +1089,7 @@ static int init_irq (ide_hwif_t *hwif)
 			sa = IRQF_SHARED;
 
 		if (io_ports->ctl_addr)
-			hwif->set_irq(hwif, 1);
+			hwif->tp_ops->set_irq(hwif, 1);
 
 		if (request_irq(hwif->irq,&ide_intr,sa,hwif->name,hwgroup))
 	       		goto out_unlink;
@@ -1367,6 +1371,9 @@ static void ide_init_port(ide_hwif_t *hw
 	hwif->host_flags |= d->host_flags;
 	hwif->pio_mask = d->pio_mask;
 
+	if (d->tp_ops)
+		hwif->tp_ops = d->tp_ops;
+
 	/* ->set_pio_mode for DTC2278 is currently limited to port 0 */
 	if (hwif->chipset != ide_dtc2278 || hwif->channel == 0)
 		hwif->port_ops = d->port_ops;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -398,7 +398,7 @@ static void idetape_input_buffers(ide_dr
 		count = min(
 			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
 			bcount);
-		drive->hwif->input_data(drive, NULL, bh->b_data +
+		drive->hwif->tp_ops->input_data(drive, NULL, bh->b_data +
 					atomic_read(&bh->b_count), count);
 		bcount -= count;
 		atomic_add(count, &bh->b_count);
@@ -424,7 +424,7 @@ static void idetape_output_buffers(ide_d
 			return;
 		}
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
-		drive->hwif->output_data(drive, NULL, pc->b_data, count);
+		drive->hwif->tp_ops->output_data(drive, NULL, pc->b_data, count);
 		bcount -= count;
 		pc->b_data += count;
 		pc->b_count -= count;
@@ -932,7 +932,7 @@ static ide_startstop_t idetape_media_acc
 	struct ide_atapi_pc *pc = tape->pc;
 	u8 stat;
 
-	stat = hwif->read_status(hwif);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (stat & SEEK_STAT) {
 		if (stat & ERR_STAT) {
@@ -1019,7 +1019,7 @@ static ide_startstop_t idetape_do_reques
 	 * If the tape is still busy, postpone our request and service
 	 * the other device meanwhile.
 	 */
-	stat = hwif->read_status(hwif);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
 		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -64,6 +64,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct ide_taskfile *tf = &task->tf;
 	ide_handler_t *handler = NULL;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
 	if (task->data_phase == TASKFILE_MULTI_IN ||
@@ -80,15 +81,15 @@ ide_startstop_t do_rw_taskfile (ide_driv
 
 	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
-		hwif->set_irq(hwif, 1);
+		tp_ops->set_irq(hwif, 1);
 		SELECT_MASK(drive, 0);
-		hwif->tf_load(drive, task);
+		tp_ops->tf_load(drive, task);
 	}
 
 	switch (task->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
-		hwif->exec_command(hwif, tf->command);
+		tp_ops->exec_command(hwif, tf->command);
 		ndelay(400);	/* FIXME */
 		return pre_task_out_intr(drive, task->rq);
 	case TASKFILE_MULTI_IN:
@@ -125,7 +126,7 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 stat = hwif->read_status(hwif);
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		drive->mult_count = drive->mult_req;
@@ -146,8 +147,12 @@ static ide_startstop_t set_geometry_intr
 	int retries = 5;
 	u8 stat;
 
-	while (((stat = hwif->read_status(hwif)) & BUSY_STAT) && retries--)
+	while (1) {
+		stat = hwif->tp_ops->read_status(hwif);
+		if ((stat & BUSY_STAT) == 0 || retries-- == 0)
+			break;
 		udelay(10);
+	};
 
 	if (OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_stopped;
@@ -165,7 +170,7 @@ static ide_startstop_t set_geometry_intr
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 stat = hwif->read_status(hwif);
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "recal_intr", stat);
@@ -182,7 +187,7 @@ static ide_startstop_t task_no_data_intr
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
-	stat = hwif->read_status(hwif);
+	stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, READY_STAT, BAD_STAT))
 		return ide_error(drive, "task_no_data_intr", stat);
@@ -205,7 +210,7 @@ static u8 wait_drive_not_busy(ide_drive_
 	 * take up to 6 ms on some ATAPI devices, so we will wait max 10 ms.
 	 */
 	for (retries = 0; retries < 1000; retries++) {
-		stat = hwif->read_status(hwif);
+		stat = hwif->tp_ops->read_status(hwif);
 
 		if (stat & BUSY_STAT)
 			udelay(10);
@@ -260,9 +265,9 @@ static void ide_pio_sector(ide_drive_t *
 
 	/* do the actual data transfer */
 	if (write)
-		hwif->output_data(drive, rq, buf, SECTOR_SIZE);
+		hwif->tp_ops->output_data(drive, rq, buf, SECTOR_SIZE);
 	else
-		hwif->input_data(drive, rq, buf, SECTOR_SIZE);
+		hwif->tp_ops->input_data(drive, rq, buf, SECTOR_SIZE);
 
 	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
@@ -389,7 +394,7 @@ static ide_startstop_t task_in_intr(ide_
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
-	u8 stat = hwif->read_status(hwif);
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	/* Error? */
 	if (stat & ERR_STAT)
@@ -423,7 +428,7 @@ static ide_startstop_t task_out_intr (id
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 stat = hwif->read_status(hwif);
+	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
 		return task_error(drive, rq, __func__, stat);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -101,7 +101,7 @@ void ide_init_port_data(ide_hwif_t *hwif
 
 	init_completion(&hwif->gendev_rel_comp);
 
-	default_hwif_transport(hwif);
+	hwif->tp_ops = &default_tp_ops;
 
 	ide_port_init_devices_data(hwif);
 }
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -66,6 +66,27 @@ static void falconide_output_data(ide_dr
 	outsw_swapw(data_addr, buf, (len + 1) / 2);
 }
 
+/* Atari has a byte-swapped IDE interface */
+static const struct ide_tp_ops falconide_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= falconide_input_data,
+	.output_data		= falconide_output_data,
+};
+
+static const struct ide_port_info falconide_port_info = {
+	.tp_ops			= &falconide_tp_ops,
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static void __init falconide_setup_ports(hw_regs_t *hw)
 {
 	int i;
@@ -111,12 +132,8 @@ static int __init falconide_init(void)
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		/* Atari has a byte-swapped IDE interface */
-		hwif->input_data  = falconide_input_data;
-		hwif->output_data = falconide_output_data;
-
 		ide_get_lock(NULL, NULL);
-		ide_device_add(idx, NULL, hws);
+		ide_device_add(idx, &falconide_port_info, hws);
 		ide_release_lock();
 	}
 
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -96,6 +96,27 @@ static void q40ide_output_data(ide_drive
 	outsw_swapw(data_addr, buf, (len + 1) / 2);
 }
 
+/* Q40 has a byte-swapped IDE interface */
+static const struct ide_tp_ops q40ide_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= q40ide_input_data,
+	.output_data		= q40ide_output_data,
+};
+
+static const struct ide_port_info q40ide_port_info = {
+	.tp_ops			= &q40ide_tp_ops,
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 /* 
  * the static array is needed to have the name reported in /proc/ioports,
  * hwif->name unfortunately isn't available yet
@@ -141,16 +162,12 @@ static int __init q40ide_init(void)
 	if (hwif) {
 		hwif->chipset = ide_generic;
 
-		/* Q40 has a byte-swapped IDE interface */
-		hwif->input_data  = q40ide_input_data;
-		hwif->output_data = q40ide_output_data;
-
 		hws[i] = &hw[i];
 		idx[i] = hwif->index;
 	}
     }
 
-    ide_device_add(idx, NULL, hws);
+    ide_device_add(idx, &q40ide_port_info, hws);
 
     return 0;
 }
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -519,6 +519,23 @@ static void auide_setup_ports(hw_regs_t 
 	*ata_regs = ahwif->regbase + (14 << IDE_REG_SHIFT);
 }
 
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
+static const struct ide_tp_ops au1xxx_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= au1xxx_input_data,
+	.output_data		= au1xxx_output_data,
+};
+#endif
+
 static const struct ide_port_ops au1xxx_port_ops = {
 	.set_pio_mode		= au1xxx_set_pio_mode,
 	.set_dma_mode		= auide_set_dma_mode,
@@ -526,6 +543,9 @@ static const struct ide_port_ops au1xxx_
 
 static const struct ide_port_info au1xxx_port_info = {
 	.init_dma		= auide_ddma_init,
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
+	.tp_ops			= &au1xxx_tp_ops,
+#endif
 	.port_ops		= &au1xxx_port_ops,
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	.dma_ops		= &au1xxx_dma_ops,
@@ -596,15 +616,6 @@ static int au_ide_probe(struct device *d
 	hw.dev = dev;
 	hw.chipset = ide_au1xxx;
 
-	/* If the user has selected DDMA assisted copies,
-	   then set up a few local I/O function entry points 
-	*/
-
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA	
-	hwif->input_data  = au1xxx_input_data;
-	hwif->output_data = au1xxx_output_data;
-#endif
-
 	auide_hwif.hwif                 = hwif;
 
 	idx[0] = hwif->index;
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -104,7 +104,22 @@ static void superio_tf_read(ide_drive_t 
 	}
 }
 
-static void __devinit superio_ide_init_iops (struct hwif_s *hwif)
+static const struct ide_tp_ops superio_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= superio_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= superio_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= superio_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
+static void __devinit superio_init_iops(struct hwif_s *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	u32 dma_stat;
@@ -115,21 +130,6 @@ static void __devinit superio_ide_init_i
 	/* Clear error/interrupt, enable dma */
 	tmp = superio_ide_inb(dma_stat);
 	outb(tmp | 0x66, dma_stat);
-
-	hwif->read_status	  = superio_read_status;
-	hwif->read_sff_dma_status = superio_read_sff_dma_status;
-
-	hwif->tf_read = superio_tf_read;
-
-}
-
-static void __devinit init_iops_ns87415(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	if (PCI_SLOT(dev->devfn) == 0xE)
-		/* Built-in - assume it's under superio. */
-		superio_ide_init_iops(hwif);
 }
 #endif
 
@@ -195,7 +195,7 @@ static int ns87415_dma_end(ide_drive_t *
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
-	dma_stat = hwif->read_sff_dma_status(hwif);
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 	/* get DMA command mode */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
@@ -310,9 +310,6 @@ static const struct ide_dma_ops ns87415_
 
 static const struct ide_port_info ns87415_chipset __devinitdata = {
 	.name		= "NS87415",
-#ifdef CONFIG_SUPERIO
-	.init_iops	= init_iops_ns87415,
-#endif
 	.init_hwif	= init_hwif_ns87415,
 	.port_ops	= &ns87415_port_ops,
 	.dma_ops	= &ns87415_dma_ops,
@@ -322,7 +319,16 @@ static const struct ide_port_info ns8741
 
 static int __devinit ns87415_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &ns87415_chipset);
+	struct ide_port_info d = ns87415_chipset;
+
+#ifdef CONFIG_SUPERIO
+	if (PCI_SLOT(dev->devfn) == 0xE) {
+		/* Built-in - assume it's under superio. */
+		d.init_iops = superio_init_iops;
+		d.tp_ops = &superio_tp_ops;
+	}
+#endif
+	return ide_setup_pci_device(dev, &d);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -808,19 +808,6 @@ static void __devinit init_mmio_iops_scc
 
 	ide_set_hwifdata(hwif, ports);
 
-	hwif->exec_command	  = scc_exec_command;
-	hwif->read_status	  = scc_read_status;
-	hwif->read_altstatus	  = scc_read_altstatus;
-	hwif->read_sff_dma_status = scc_read_sff_dma_status;
-
-	hwif->set_irq = scc_set_irq;
-
-	hwif->tf_load = scc_tf_load;
-	hwif->tf_read = scc_tf_read;
-
-	hwif->input_data  = scc_input_data;
-	hwif->output_data = scc_output_data;
-
 	hwif->dma_base = dma_base;
 	hwif->config_data = ports->ctl;
 }
@@ -872,6 +859,21 @@ static void __devinit init_hwif_scc(ide_
 		hwif->ultra_mask = ATA_UDMA5; /* 100MHz */
 }
 
+static const struct ide_tp_ops scc_tp_ops = {
+	.exec_command		= scc_exec_command,
+	.read_status		= scc_read_status,
+	.read_altstatus		= scc_read_altstatus,
+	.read_sff_dma_status	= scc_read_sff_dma_status,
+
+	.set_irq		= scc_set_irq,
+
+	.tf_load		= scc_tf_load,
+	.tf_read		= scc_tf_read,
+
+	.input_data		= scc_input_data,
+	.output_data		= scc_output_data,
+};
+
 static const struct ide_port_ops scc_port_ops = {
 	.set_pio_mode		= scc_set_pio_mode,
 	.set_dma_mode		= scc_set_dma_mode,
@@ -895,6 +897,7 @@ static const struct ide_dma_ops scc_dma_
       .name		= name_str,			\
       .init_iops	= init_iops_scc,		\
       .init_hwif	= init_hwif_scc,		\
+      .tp_ops		= &scc_tp_ops,		\
       .port_ops		= &scc_port_ops,		\
       .dma_ops		= &scc_dma_ops,			\
       .host_flags	= IDE_HFLAG_SINGLE,		\
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -550,6 +550,21 @@ static int sgiioc4_dma_setup(ide_drive_t
 	return 0;
 }
 
+static const struct ide_tp_ops sgiioc4_tp_ops = {
+	.exec_command		= ide_exec_command,
+	.read_status		= sgiioc4_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= ide_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
 static const struct ide_port_ops sgiioc4_port_ops = {
 	.set_dma_mode		= sgiioc4_set_dma_mode,
 	/* reset DMA engine, clear IRQs */
@@ -572,6 +587,7 @@ static const struct ide_port_info sgiioc
 	.name			= DRV_NAME,
 	.chipset		= ide_pci,
 	.init_dma		= ide_dma_sgiioc4,
+	.tp_ops			= &sgiioc4_tp_ops,
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
 	.host_flags		= IDE_HFLAG_MMIO,
@@ -626,8 +642,6 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	hwif->read_status = sgiioc4_read_status;
-
 	idx[0] = hwif->index;
 
 	if (ide_device_add(idx, &d, hws))
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -972,6 +972,21 @@ static void pmac_ide_init_dev(ide_drive_
 	}
 }
 
+static const struct ide_tp_ops pmac_tp_ops = {
+	.exec_command		= pmac_exec_command,
+	.read_status		= ide_read_status,
+	.read_altstatus		= ide_read_altstatus,
+	.read_sff_dma_status	= ide_read_sff_dma_status,
+
+	.set_irq		= pmac_set_irq,
+
+	.tf_load		= ide_tf_load,
+	.tf_read		= ide_tf_read,
+
+	.input_data		= ide_input_data,
+	.output_data		= ide_output_data,
+};
+
 static const struct ide_port_ops pmac_ide_ata6_port_ops = {
 	.init_dev		= pmac_ide_init_dev,
 	.set_pio_mode		= pmac_ide_set_pio_mode,
@@ -1001,10 +1016,11 @@ static const struct ide_port_info pmac_p
 	.name			= DRV_NAME,
 	.init_dma		= pmac_ide_init_dma,
 	.chipset		= ide_pmac,
+	.tp_ops			= &pmac_tp_ops,
+	.port_ops		= &pmac_ide_port_ops,
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
 	.dma_ops		= &pmac_dma_ops,
 #endif
-	.port_ops		= &pmac_ide_port_ops,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
 				  IDE_HFLAG_MMIO |
@@ -1100,9 +1116,6 @@ static int __devinit pmac_ide_setup_devi
 	if (hwif == NULL)
 		return -ENOENT;
 
-	hwif->exec_command = pmac_exec_command;
-	hwif->set_irq	   = pmac_set_irq;
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &d, hws);
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -124,7 +124,7 @@ int ide_pci_check_simplex(ide_hwif_t *hw
 	 * we tune the drive then try to grab DMA ownership if we want to be
 	 * the DMA end.  This has to be become dynamic to handle hot-plug.
 	 */
-	dma_stat = hwif->read_sff_dma_status(hwif);
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
 		printk(KERN_INFO "%s: simplex device: DMA disabled\n", d->name);
 		return -1;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -142,7 +142,8 @@ static void ide_scsi_io_buffers(ide_driv
 				unsigned int bcount, int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	xfer_func_t *xf = write ? hwif->output_data : hwif->input_data;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
 	char *buf;
 	int count;
 
@@ -246,9 +247,9 @@ idescsi_atapi_error(ide_drive_t *drive, 
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (hwif->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
+	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->exec_command(hwif, WIN_IDLEIMMEDIATE);
+		hwif->tp_ops->exec_command(hwif, WIN_IDLEIMMEDIATE);
 
 	rq->errors++;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -387,8 +387,28 @@ typedef struct ide_drive_s {
     ((1<<ide_pci)|(1<<ide_cmd646)|(1<<ide_ali14xx))
 #define IDE_CHIPSET_IS_PCI(c)	((IDE_CHIPSET_PCI_MASK >> (c)) & 1)
 
+struct ide_task_s;
 struct ide_port_info;
 
+struct ide_tp_ops {
+	void	(*exec_command)(struct hwif_s *, u8);
+	u8	(*read_status)(struct hwif_s *);
+	u8	(*read_altstatus)(struct hwif_s *);
+	u8	(*read_sff_dma_status)(struct hwif_s *);
+
+	void	(*set_irq)(struct hwif_s *, int);
+
+	void	(*tf_load)(ide_drive_t *, struct ide_task_s *);
+	void	(*tf_read)(ide_drive_t *, struct ide_task_s *);
+
+	void	(*input_data)(ide_drive_t *, struct request *, void *,
+			      unsigned int);
+	void	(*output_data)(ide_drive_t *, struct request *, void *,
+			       unsigned int);
+};
+
+extern const struct ide_tp_ops default_tp_ops;
+
 struct ide_port_ops {
 	/* host specific initialization of a device */
 	void	(*init_dev)(ide_drive_t *);
@@ -426,8 +446,6 @@ struct ide_dma_ops {
 	void	(*dma_timeout)(struct ide_drive_s *);
 };
 
-struct ide_task_s;
-
 typedef struct hwif_s {
 	struct hwif_s *next;		/* for linked-list in ide_hwgroup_t */
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
@@ -465,22 +483,10 @@ typedef struct hwif_s {
 
 	void (*rw_disk)(ide_drive_t *, struct request *);
 
+	const struct ide_tp_ops		*tp_ops;
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
-	void	(*exec_command)(struct hwif_s *, u8);
-	u8	(*read_status)(struct hwif_s *);
-	u8	(*read_altstatus)(struct hwif_s *);
-	u8	(*read_sff_dma_status)(struct hwif_s *);
-
-	void	(*set_irq)(struct hwif_s *, int);
-
-	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
-	void (*tf_read)(ide_drive_t *, struct ide_task_s *);
-
-	void (*input_data)(ide_drive_t *, struct request *, void *, unsigned);
-	void (*output_data)(ide_drive_t *, struct request *, void *, unsigned);
-
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 
 	/* dma physical region descriptor table (cpu view) */
@@ -935,6 +941,19 @@ typedef struct ide_task_s {
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
+void ide_exec_command(ide_hwif_t *, u8);
+u8 ide_read_status(ide_hwif_t *);
+u8 ide_read_altstatus(ide_hwif_t *);
+u8 ide_read_sff_dma_status(ide_hwif_t *);
+
+void ide_set_irq(ide_hwif_t *, int);
+
+void ide_tf_load(ide_drive_t *, ide_task_t *);
+void ide_tf_read(ide_drive_t *, ide_task_t *);
+
+void ide_input_data(ide_drive_t *, struct request *, void *, unsigned int);
+void ide_output_data(ide_drive_t *, struct request *, void *, unsigned int);
+
 extern void SELECT_DRIVE(ide_drive_t *);
 void SELECT_MASK(ide_drive_t *, int);
 
@@ -1008,8 +1027,6 @@ static inline int ide_hwif_setup_dma(ide
 }
 #endif
 
-extern void default_hwif_transport(ide_hwif_t *);
-
 typedef struct ide_pci_enablebit_s {
 	u8	reg;	/* byte pci reg holding the enable-bit */
 	u8	mask;	/* mask to isolate the enable-bit */
@@ -1098,6 +1115,7 @@ struct ide_port_info {
 	int			(*init_dma)(ide_hwif_t *,
 					    const struct ide_port_info *);
 
+	const struct ide_tp_ops		*tp_ops;
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
