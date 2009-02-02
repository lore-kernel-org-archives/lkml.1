Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbZBBVjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbZBBVjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbZBBVjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:39:10 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:47527 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbZBBVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:39:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=B9Bcr1Un3rmCiCZEW1b2KX3nJl7ULPsKFjF7Y0mTGT7k2Azeswyo7+AJxApczuogNO
         +krnY+kIeOyCk55tJsihffkIvHDhQp9dIo2hejwy7j5thIcg1UsjMtl+HsVG1FvGbJCC
         X07+byJqSINLoZ70lWBwheqmCa194e1X8crOI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:37:34 +0100
Message-Id: <20090202213734.17960.44016.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/14] ide: pass command instead of request to ide_pio_datablock()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: pass command instead of request to ide_pio_datablock()

* Add IDE_TFLAG_FS taskfile flag and set it for REQ_TYPE_FS requests.

* Convert ->{in,out}put_data methods to take command instead of request
  as an argument.  Then convert pre_task_out_intr(), task_end_request(),
  task_error(), task_in_unexpected(), ide_pio_sector(), ide_pio_multi()
  and ide_pio_datablock() in similar way.

* Rename task_end_request() to ide_finish_cmd().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/au1xxx-ide.c   |    4 +-
 drivers/ide/falconide.c    |    8 ++--
 drivers/ide/ide-disk.c     |    2 +
 drivers/ide/ide-dma.c      |    4 +-
 drivers/ide/ide-h8300.c    |    4 +-
 drivers/ide/ide-io-std.c   |    4 +-
 drivers/ide/ide-taskfile.c |   88 +++++++++++++++++++++------------------------
 drivers/ide/q40ide.c       |    8 ++--
 drivers/ide/scc_pata.c     |    4 +-
 drivers/ide/tx4938ide.c    |    4 +-
 include/linux/ide.h        |   17 ++++----
 11 files changed, 74 insertions(+), 73 deletions(-)

Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -86,13 +86,13 @@ void auide_outsw(unsigned long port, voi
 	ctp->cur_ptr = au1xxx_ddma_get_nextptr_virt(dp);
 }
 
-static void au1xxx_input_data(ide_drive_t *drive, struct request *rq,
+static void au1xxx_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			      void *buf, unsigned int len)
 {
 	auide_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
-static void au1xxx_output_data(ide_drive_t *drive, struct request *rq,
+static void au1xxx_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			       void *buf, unsigned int len)
 {
 	auide_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
Index: b/drivers/ide/falconide.c
===================================================================
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -62,23 +62,23 @@ static void falconide_get_lock(irq_handl
 	}
 }
 
-static void falconide_input_data(ide_drive_t *drive, struct request *rq,
+static void falconide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 				 void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
 		return insw(data_addr, buf, (len + 1) / 2);
 
 	raw_insw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
 
-static void falconide_output_data(ide_drive_t *drive, struct request *rq,
+static void falconide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 				  void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
 		return outsw(data_addr, buf, (len + 1) / 2);
 
 	raw_outsw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -156,6 +156,8 @@ static ide_startstop_t __ide_do_rw_disk(
 		tf->device = head;
 	}
 
+	cmd.tf_flags |= IDE_TFLAG_FS;
+
 	if (rq_data_dir(rq))
 		cmd.tf_flags |= IDE_TFLAG_WRITE;
 
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -96,9 +96,9 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
-			struct request *rq = hwif->rq;
+			struct ide_cmd *cmd = &hwif->cmd;
 
-			task_end_request(drive, rq, stat);
+			ide_finish_cmd(drive, cmd, stat);
 			return ide_stopped;
 		}
 		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
Index: b/drivers/ide/ide-h8300.c
===================================================================
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -143,13 +143,13 @@ static void mm_insw(unsigned long addr, 
 		*bp = bswap(*(volatile u16 *)addr);
 }
 
-static void h8300_input_data(ide_drive_t *drive, struct request *rq,
+static void h8300_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			     void *buf, unsigned int len)
 {
 	mm_insw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
 }
 
-static void h8300_output_data(ide_drive_t *drive, struct request *rq,
+static void h8300_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			      void *buf, unsigned int len)
 {
 	mm_outsw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
Index: b/drivers/ide/ide-io-std.c
===================================================================
--- a/drivers/ide/ide-io-std.c
+++ b/drivers/ide/ide-io-std.c
@@ -219,7 +219,7 @@ static void ata_vlb_sync(unsigned long p
  * so if an odd len is specified, be sure that there's at least one
  * extra byte allocated for the buffer.
  */
-void ide_input_data(ide_drive_t *drive, struct request *rq, void *buf,
+void ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 		    unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -265,7 +265,7 @@ EXPORT_SYMBOL_GPL(ide_input_data);
 /*
  * This is used for most PIO data transfers *to* the IDE interface
  */
-void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
+void ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd, void *buf,
 		     unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -54,19 +54,20 @@ int taskfile_lib_get_identify (ide_drive
 }
 
 static ide_startstop_t task_no_data_intr(ide_drive_t *);
-static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
+static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct ide_cmd *);
 static ide_startstop_t task_in_intr(ide_drive_t *);
 
-ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd)
+ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct ide_taskfile *tf = &cmd->tf;
 	ide_handler_t *handler = NULL;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
-	if (cmd->data_phase == TASKFILE_MULTI_IN ||
-	    cmd->data_phase == TASKFILE_MULTI_OUT) {
+	if (orig_cmd->data_phase == TASKFILE_MULTI_IN ||
+	    orig_cmd->data_phase == TASKFILE_MULTI_OUT) {
 		if (!drive->mult_count) {
 			printk(KERN_ERR "%s: multimode not set!\n",
 					drive->name);
@@ -74,10 +75,10 @@ ide_startstop_t do_rw_taskfile(ide_drive
 		}
 	}
 
-	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
-		cmd->ftf_flags |= IDE_FTFLAG_SET_IN_FLAGS;
+	if (orig_cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
+		orig_cmd->ftf_flags |= IDE_FTFLAG_SET_IN_FLAGS;
 
-	memcpy(&hwif->cmd, cmd, sizeof(*cmd));
+	memcpy(cmd, orig_cmd, sizeof(*cmd));
 
 	if ((cmd->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
@@ -91,7 +92,7 @@ ide_startstop_t do_rw_taskfile(ide_drive
 	case TASKFILE_OUT:
 		tp_ops->exec_command(hwif, tf->command);
 		ndelay(400);	/* FIXME */
-		return pre_task_out_intr(drive, cmd->rq);
+		return pre_task_out_intr(drive, cmd);
 	case TASKFILE_MULTI_IN:
 	case TASKFILE_IN:
 		handler = task_in_intr;
@@ -199,7 +200,7 @@ static u8 wait_drive_not_busy(ide_drive_
 	return stat;
 }
 
-static void ide_pio_sector(ide_drive_t *drive, struct request *rq,
+static void ide_pio_sector(ide_drive_t *drive, struct ide_cmd *cmd,
 			   unsigned int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -240,9 +241,9 @@ static void ide_pio_sector(ide_drive_t *
 
 	/* do the actual data transfer */
 	if (write)
-		hwif->tp_ops->output_data(drive, rq, buf, SECTOR_SIZE);
+		hwif->tp_ops->output_data(drive, cmd, buf, SECTOR_SIZE);
 	else
-		hwif->tp_ops->input_data(drive, rq, buf, SECTOR_SIZE);
+		hwif->tp_ops->input_data(drive, cmd, buf, SECTOR_SIZE);
 
 	kunmap_atomic(buf, KM_BIO_SRC_IRQ);
 #ifdef CONFIG_HIGHMEM
@@ -250,24 +251,23 @@ static void ide_pio_sector(ide_drive_t *
 #endif
 }
 
-static void ide_pio_multi(ide_drive_t *drive, struct request *rq,
+static void ide_pio_multi(ide_drive_t *drive, struct ide_cmd *cmd,
 			  unsigned int write)
 {
 	unsigned int nsect;
 
 	nsect = min_t(unsigned int, drive->hwif->nleft, drive->mult_count);
 	while (nsect--)
-		ide_pio_sector(drive, rq, write);
+		ide_pio_sector(drive, cmd, write);
 }
 
-static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
-				     unsigned int write)
+static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
+			      unsigned int write)
 {
-	struct ide_cmd *cmd = &drive->hwif->cmd;
 	u8 saved_io_32bit = drive->io_32bit;
 
-	if (blk_fs_request(rq))
-		rq->errors = 0;
+	if (cmd->tf_flags & IDE_TFLAG_FS)
+		cmd->rq->errors = 0;
 
 	if (cmd->tf_flags & IDE_TFLAG_IO_16BIT)
 		drive->io_32bit = 0;
@@ -277,22 +277,21 @@ static void ide_pio_datablock(ide_drive_
 	switch (cmd->data_phase) {
 	case TASKFILE_MULTI_IN:
 	case TASKFILE_MULTI_OUT:
-		ide_pio_multi(drive, rq, write);
+		ide_pio_multi(drive, cmd, write);
 		break;
 	default:
-		ide_pio_sector(drive, rq, write);
+		ide_pio_sector(drive, cmd, write);
 		break;
 	}
 
 	drive->io_32bit = saved_io_32bit;
 }
 
-static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
+static ide_startstop_t task_error(ide_drive_t *drive, struct ide_cmd *cmd,
 				  const char *s, u8 stat)
 {
-	if (blk_fs_request(rq)) {
+	if (cmd->tf_flags & IDE_TFLAG_FS) {
 		ide_hwif_t *hwif = drive->hwif;
-		struct ide_cmd *cmd = &hwif->cmd;
 		int sectors = hwif->nsect - hwif->nleft;
 
 		switch (cmd->data_phase) {
@@ -319,19 +318,17 @@ static ide_startstop_t task_error(ide_dr
 	return ide_error(drive, s, stat);
 }
 
-void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
+void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
 {
-	if (blk_fs_request(rq) == 0) {
-		struct ide_cmd *cmd = rq->special;
+	if ((cmd->tf_flags & IDE_TFLAG_FS) == 0) {
 		u8 err = ide_read_error(drive);
 
-		if (cmd)
-			ide_complete_cmd(drive, cmd, stat, err);
+		ide_complete_cmd(drive, cmd, stat, err);
 		ide_complete_rq(drive, err);
 		return;
 	}
 
-	ide_end_request(drive, 1, rq->nr_sectors);
+	ide_end_request(drive, 1, cmd->rq->nr_sectors);
 }
 
 /*
@@ -340,11 +337,12 @@ void task_end_request(ide_drive_t *drive
  * It might be a spurious irq (shared irq), but it might be a
  * command that had no output.
  */
-static ide_startstop_t task_in_unexpected(ide_drive_t *drive, struct request *rq, u8 stat)
+static ide_startstop_t task_in_unexpected(ide_drive_t *drive,
+					  struct ide_cmd *cmd, u8 stat)
 {
 	/* Command all done? */
 	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY)) {
-		task_end_request(drive, rq, stat);
+		ide_finish_cmd(drive, cmd, stat);
 		return ide_stopped;
 	}
 
@@ -359,25 +357,25 @@ static ide_startstop_t task_in_unexpecte
 static ide_startstop_t task_in_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
+	struct ide_cmd *cmd = &drive->hwif->cmd;
 	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	/* Error? */
 	if (stat & ATA_ERR)
-		return task_error(drive, rq, __func__, stat);
+		return task_error(drive, cmd, __func__, stat);
 
 	/* Didn't want any data? Odd. */
 	if ((stat & ATA_DRQ) == 0)
-		return task_in_unexpected(drive, rq, stat);
+		return task_in_unexpected(drive, cmd, stat);
 
-	ide_pio_datablock(drive, rq, 0);
+	ide_pio_datablock(drive, cmd, 0);
 
 	/* Are we done? Check status and finish transfer. */
 	if (!hwif->nleft) {
 		stat = wait_drive_not_busy(drive);
 		if (!OK_STAT(stat, 0, BAD_STAT))
-			return task_error(drive, rq, __func__, stat);
-		task_end_request(drive, rq, stat);
+			return task_error(drive, cmd, __func__, stat);
+		ide_finish_cmd(drive, cmd, stat);
 		return ide_stopped;
 	}
 
@@ -393,31 +391,31 @@ static ide_startstop_t task_in_intr(ide_
 static ide_startstop_t task_out_intr (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->rq;
+	struct ide_cmd *cmd = &drive->hwif->cmd;
 	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
-		return task_error(drive, rq, __func__, stat);
+		return task_error(drive, cmd, __func__, stat);
 
 	/* Deal with unexpected ATA data phase. */
 	if (((stat & ATA_DRQ) == 0) ^ !hwif->nleft)
-		return task_error(drive, rq, __func__, stat);
+		return task_error(drive, cmd, __func__, stat);
 
 	if (!hwif->nleft) {
-		task_end_request(drive, rq, stat);
+		ide_finish_cmd(drive, cmd, stat);
 		return ide_stopped;
 	}
 
 	/* Still data left to transfer. */
-	ide_pio_datablock(drive, rq, 1);
+	ide_pio_datablock(drive, cmd, 1);
 	ide_set_handler(drive, &task_out_intr, WAIT_WORSTCASE, NULL);
 
 	return ide_started;
 }
 
-static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
+static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
+					 struct ide_cmd *cmd)
 {
-	struct ide_cmd *cmd = &drive->hwif->cmd;
 	ide_startstop_t startstop;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
@@ -433,7 +431,7 @@ static ide_startstop_t pre_task_out_intr
 		local_irq_disable();
 
 	ide_set_handler(drive, &task_out_intr, WAIT_WORSTCASE, NULL);
-	ide_pio_datablock(drive, rq, 1);
+	ide_pio_datablock(drive, cmd, 1);
 
 	return ide_started;
 }
Index: b/drivers/ide/q40ide.c
===================================================================
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -72,23 +72,23 @@ static void q40_ide_setup_ports(hw_regs_
 	hw->chipset = ide_generic;
 }
 
-static void q40ide_input_data(ide_drive_t *drive, struct request *rq,
+static void q40ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			      void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
 		return insw(data_addr, buf, (len + 1) / 2);
 
 	raw_insw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
 
-static void q40ide_output_data(ide_drive_t *drive, struct request *rq,
+static void q40ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			       void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
 		return outsw(data_addr, buf, (len + 1) / 2);
 
 	raw_outsw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -750,7 +750,7 @@ static void scc_tf_read(ide_drive_t *dri
 	}
 }
 
-static void scc_input_data(ide_drive_t *drive, struct request *rq,
+static void scc_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 			   void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
@@ -766,7 +766,7 @@ static void scc_input_data(ide_drive_t *
 		scc_ide_insw(data_addr, buf, len / 2);
 }
 
-static void scc_output_data(ide_drive_t *drive,  struct request *rq,
+static void scc_output_data(ide_drive_t *drive,  struct ide_cmd *cmd,
 			    void *buf, unsigned int len)
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -174,7 +174,7 @@ static void tx4938ide_tf_read(ide_drive_
 	}
 }
 
-static void tx4938ide_input_data_swap(ide_drive_t *drive, struct request *rq,
+static void tx4938ide_input_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	unsigned long port = drive->hwif->io_ports.data_addr;
@@ -186,7 +186,7 @@ static void tx4938ide_input_data_swap(id
 	__ide_flush_dcache_range((unsigned long)buf, roundup(len, 2));
 }
 
-static void tx4938ide_output_data_swap(ide_drive_t *drive, struct request *rq,
+static void tx4938ide_output_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	unsigned long port = drive->hwif->io_ports.data_addr;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -297,6 +297,7 @@ enum {
 	IDE_TFLAG_IO_16BIT		= (1 << 26),
 	/* struct ide_cmd was allocated using kmalloc() */
 	IDE_TFLAG_DYN			= (1 << 27),
+	IDE_TFLAG_FS			= (1 << 28),
 };
 
 enum {
@@ -655,10 +656,10 @@ struct ide_tp_ops {
 	void	(*tf_load)(ide_drive_t *, struct ide_cmd *);
 	void	(*tf_read)(ide_drive_t *, struct ide_cmd *);
 
-	void	(*input_data)(ide_drive_t *, struct request *, void *,
-			      unsigned int);
-	void	(*output_data)(ide_drive_t *, struct request *, void *,
-			       unsigned int);
+	void	(*input_data)(ide_drive_t *, struct ide_cmd *,
+			      void *, unsigned int);
+	void	(*output_data)(ide_drive_t *, struct ide_cmd *,
+			       void *, unsigned int);
 };
 
 extern const struct ide_tp_ops default_tp_ops;
@@ -863,7 +864,7 @@ typedef ide_startstop_t (ide_handler_t)(
 typedef int (ide_expiry_t)(ide_drive_t *);
 
 /* used by ide-cd, ide-floppy, etc. */
-typedef void (xfer_func_t)(ide_drive_t *, struct request *rq, void *, unsigned);
+typedef void (xfer_func_t)(ide_drive_t *, struct ide_cmd *, void *, unsigned);
 
 extern struct mutex ide_setting_mtx;
 
@@ -1172,8 +1173,8 @@ void ide_set_irq(ide_hwif_t *, int);
 void ide_tf_load(ide_drive_t *, struct ide_cmd *);
 void ide_tf_read(ide_drive_t *, struct ide_cmd *);
 
-void ide_input_data(ide_drive_t *, struct request *, void *, unsigned int);
-void ide_output_data(ide_drive_t *, struct request *, void *, unsigned int);
+void ide_input_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
+void ide_output_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 
 int ide_io_buffers(ide_drive_t *, struct ide_atapi_pc *, unsigned int, int);
 
@@ -1223,7 +1224,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, struct ide_cmd *);
 
-void task_end_request(ide_drive_t *, struct request *, u8);
+void ide_finish_cmd(ide_drive_t *, struct ide_cmd *, u8);
 
 int ide_raw_taskfile(ide_drive_t *, struct ide_cmd *, u8 *, u16);
 int ide_no_data_taskfile(ide_drive_t *, struct ide_cmd *);
