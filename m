Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZBBVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZBBVhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758582AbZBBVgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:36:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:13673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbZBBVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:36:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Md1uOlYSEfi8ZluGOz4j5do1E6Jg+liphYWozxPwIqFex7sneZNF+u/NUE6WE1FAHM
         JYBLm6Rz3MX7+eFlfKWOnTr7Mdz99aIV12vgW83OSCOWMtnCh8r2VtVXzBd5a6x/5Fzc
         O3IIJ9YDUpa8km8VUhjwBiEvsWFH3IfZuctxE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:37:27 +0100
Message-Id: <20090202213727.17960.25320.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/14] ide: remove ide_task_t typedef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ide_task_t typedef

While at it:
- rename struct ide_task_s to struct ide_cmd
- remove stale comments from idedisk_{read_native,set}_max_address()
- drop unused 'cmd' argument from ide_{cmd,task}_ioctl()
- drop unused 'task' argument from tx4939ide_tf_load_fixup()
- rename ide_complete_task() to ide_complete_cmd()
- use consistent naming for struct ide_cmd variables

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c      |   10 +-
 drivers/ide/ide-atapi.c     |   42 ++++++------
 drivers/ide/ide-disk.c      |  121 ++++++++++++++++++-----------------
 drivers/ide/ide-disk_proc.c |   23 +++---
 drivers/ide/ide-eh.c        |    6 -
 drivers/ide/ide-h8300.c     |   62 +++++++++---------
 drivers/ide/ide-io-std.c    |   62 +++++++++---------
 drivers/ide/ide-io.c        |   36 +++++-----
 drivers/ide/ide-ioctls.c    |   44 ++++++------
 drivers/ide/ide-iops.c      |   30 ++++----
 drivers/ide/ide-lib.c       |   20 ++---
 drivers/ide/ide-park.c      |   17 ++--
 drivers/ide/ide-pm.c        |   32 ++++-----
 drivers/ide/ide-probe.c     |   18 ++---
 drivers/ide/ide-proc.c      |   16 ++--
 drivers/ide/ide-taskfile.c  |  150 ++++++++++++++++++++++----------------------
 drivers/ide/ns87415.c       |   30 ++++----
 drivers/ide/scc_pata.c      |   62 +++++++++---------
 drivers/ide/tx4938ide.c     |   62 +++++++++---------
 drivers/ide/tx4939ide.c     |   75 +++++++++++-----------
 include/linux/ide.h         |   26 +++----
 21 files changed, 479 insertions(+), 465 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -304,7 +304,7 @@ static int do_drive_set_taskfiles(ide_dr
 	/* send all taskfile registers (0x1f1-0x1f7) *in*that*order* */
 	for (ix = 0; ix < gtf_count; ix++) {
 		u8 *gtf = (u8 *)(gtf_address + ix * REGS_PER_GTF);
-		ide_task_t task;
+		struct ide_cmd cmd;
 
 		DEBPRINT("(0x1f1-1f7): "
 			 "hex: %02x %02x %02x %02x %02x %02x %02x\n",
@@ -317,11 +317,11 @@ static int do_drive_set_taskfiles(ide_dr
 		}
 
 		/* convert GTF to taskfile */
-		memset(&task, 0, sizeof(ide_task_t));
-		memcpy(&task.tf_array[7], gtf, REGS_PER_GTF);
-		task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+		memset(&cmd, 0, sizeof(cmd));
+		memcpy(&cmd.tf_array[7], gtf, REGS_PER_GTF);
+		cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-		err = ide_no_data_taskfile(drive, &task);
+		err = ide_no_data_taskfile(drive, &cmd);
 		if (err) {
 			printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
 					__func__, err);
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -290,16 +290,16 @@ EXPORT_SYMBOL_GPL(ide_cd_get_xferlen);
 
 void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
-			IDE_TFLAG_IN_NSECT;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
+		       IDE_TFLAG_IN_NSECT;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
-	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
-	*ireason = task.tf.nsect & 3;
+	*bcount = (cmd.tf.lbah << 8) | cmd.tf.lbam;
+	*ireason = cmd.tf.nsect & 3;
 }
 EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
 
@@ -470,32 +470,32 @@ next_irq:
 static void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t task;
+	struct ide_cmd cmd;
 	u8 dma = drive->dma;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
-			IDE_TFLAG_OUT_FEATURE | tf_flags;
-	task.tf.feature = dma;		/* Use PIO/DMA */
-	task.tf.lbam    = bcount & 0xff;
-	task.tf.lbah    = (bcount >> 8) & 0xff;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
+		       IDE_TFLAG_OUT_FEATURE | tf_flags;
+	cmd.tf.feature = dma;		/* Use PIO/DMA */
+	cmd.tf.lbam    = bcount & 0xff;
+	cmd.tf.lbah    = (bcount >> 8) & 0xff;
 
-	ide_tf_dump(drive->name, &task.tf);
+	ide_tf_dump(drive->name, &cmd.tf);
 	hwif->tp_ops->set_irq(hwif, 1);
 	SELECT_MASK(drive, 0);
-	hwif->tp_ops->tf_load(drive, &task);
+	hwif->tp_ops->tf_load(drive, &cmd);
 }
 
 static u8 ide_read_ireason(ide_drive_t *drive)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_NSECT;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_IN_NSECT;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
-	return task.tf.nsect & 3;
+	return cmd.tf.nsect & 3;
 }
 
 static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -62,24 +62,24 @@ static const u8 ide_data_phases[] = {
 	TASKFILE_OUT_DMA,
 };
 
-static void ide_tf_set_cmd(ide_drive_t *drive, ide_task_t *task, u8 dma)
+static void ide_tf_set_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 dma)
 {
 	u8 index, lba48, write;
 
-	lba48 = (task->tf_flags & IDE_TFLAG_LBA48) ? 2 : 0;
-	write = (task->tf_flags & IDE_TFLAG_WRITE) ? 1 : 0;
+	lba48 = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 2 : 0;
+	write = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 1 : 0;
 
 	if (dma)
 		index = 8;
 	else
 		index = drive->mult_count ? 0 : 4;
 
-	task->tf.command = ide_rw_cmds[index + lba48 + write];
+	cmd->tf.command = ide_rw_cmds[index + lba48 + write];
 
 	if (dma)
 		index = 8; /* fixup index */
 
-	task->data_phase = ide_data_phases[index / 2 + write];
+	cmd->data_phase = ide_data_phases[index / 2 + write];
 }
 
 /*
@@ -93,8 +93,8 @@ static ide_startstop_t __ide_do_rw_disk(
 	u16 nsectors		= (u16)rq->nr_sectors;
 	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
 	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
-	ide_task_t		task;
-	struct ide_taskfile	*tf = &task.tf;
+	struct ide_cmd		cmd;
+	struct ide_taskfile	*tf = &cmd.tf;
 	ide_startstop_t		rc;
 
 	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && lba48 && dma) {
@@ -109,8 +109,8 @@ static ide_startstop_t __ide_do_rw_disk(
 		ide_map_sg(drive, rq);
 	}
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
 	if (drive->dev_flags & IDE_DFLAG_LBA) {
 		if (lba48) {
@@ -129,7 +129,7 @@ static ide_startstop_t __ide_do_rw_disk(
 			tf->lbam   = (u8)(block >>  8);
 			tf->lbah   = (u8)(block >> 16);
 
-			task.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+			cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
 		} else {
 			tf->nsect  = nsectors & 0xff;
 			tf->lbal   = block;
@@ -157,19 +157,19 @@ static ide_startstop_t __ide_do_rw_disk(
 	}
 
 	if (rq_data_dir(rq))
-		task.tf_flags |= IDE_TFLAG_WRITE;
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
 
-	ide_tf_set_cmd(drive, &task, dma);
-	task.rq = rq;
+	ide_tf_set_cmd(drive, &cmd, dma);
+	cmd.rq = rq;
 
-	rc = do_rw_taskfile(drive, &task);
+	rc = do_rw_taskfile(drive, &cmd);
 
 	if (rc == ide_stopped && dma) {
 		/* fallback to PIO */
-		task.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
-		ide_tf_set_cmd(drive, &task, 0);
+		cmd.tf_flags |= IDE_TFLAG_DMA_PIO_FALLBACK;
+		ide_tf_set_cmd(drive, &cmd, 0);
 		ide_init_sg_cmd(drive, rq);
-		rc = do_rw_taskfile(drive, &task);
+		rc = do_rw_taskfile(drive, &cmd);
 	}
 
 	return rc;
@@ -213,22 +213,22 @@ static ide_startstop_t ide_do_rw_disk(id
  */
 static u64 idedisk_read_native_max_address(ide_drive_t *drive, int lba48)
 {
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 	u64 addr = 0;
 
-	/* Create IDE/ATA command request structure */
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	if (lba48)
 		tf->command = ATA_CMD_READ_NATIVE_MAX_EXT;
 	else
 		tf->command = ATA_CMD_READ_NATIVE_MAX;
 	tf->device  = ATA_LBA;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	if (lba48)
-		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
-	/* submit command request */
-	ide_no_data_taskfile(drive, &args);
+		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+
+	ide_no_data_taskfile(drive, &cmd);
 
 	/* if OK, compute maximum address value */
 	if ((tf->status & 0x01) == 0)
@@ -243,13 +243,13 @@ static u64 idedisk_read_native_max_addre
  */
 static u64 idedisk_set_max_address(ide_drive_t *drive, u64 addr_req, int lba48)
 {
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 	u64 addr_set = 0;
 
 	addr_req--;
-	/* Create IDE/ATA command request structure */
-	memset(&args, 0, sizeof(ide_task_t));
+
+	memset(&cmd, 0, sizeof(cmd));
 	tf->lbal     = (addr_req >>  0) & 0xff;
 	tf->lbam     = (addr_req >>= 8) & 0xff;
 	tf->lbah     = (addr_req >>= 8) & 0xff;
@@ -263,11 +263,13 @@ static u64 idedisk_set_max_address(ide_d
 		tf->command  = ATA_CMD_SET_MAX;
 	}
 	tf->device |= ATA_LBA;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	if (lba48)
-		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
-	/* submit command request */
-	ide_no_data_taskfile(drive, &args);
+		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_HOB);
+
+	ide_no_data_taskfile(drive, &cmd);
+
 	/* if OK, compute maximum address value */
 	if ((tf->status & 0x01) == 0)
 		addr_set = ide_get_lba_addr(tf, lba48) + 1;
@@ -386,24 +388,24 @@ static int ide_disk_get_capacity(ide_dri
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
-	ide_task_t *task = kmalloc(sizeof(*task), GFP_ATOMIC);
+	struct ide_cmd *cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
 
 	/* FIXME: map struct ide_taskfile on rq->cmd[] */
-	BUG_ON(task == NULL);
+	BUG_ON(cmd == NULL);
 
-	memset(task, 0, sizeof(*task));
+	memset(cmd, 0, sizeof(*cmd));
 	if (ata_id_flush_ext_enabled(drive->id) &&
 	    (drive->capacity64 >= (1UL << 28)))
-		task->tf.command = ATA_CMD_FLUSH_EXT;
+		cmd->tf.command = ATA_CMD_FLUSH_EXT;
 	else
-		task->tf.command = ATA_CMD_FLUSH;
-	task->tf_flags	 = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
+		cmd->tf.command = ATA_CMD_FLUSH;
+	cmd->tf_flags	 = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
 			   IDE_TFLAG_DYN;
-	task->data_phase = TASKFILE_NO_DATA;
+	cmd->data_phase = TASKFILE_NO_DATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq->cmd_flags |= REQ_SOFTBARRIER;
-	rq->special = task;
+	rq->special = cmd;
 }
 
 ide_devset_get(multcount, mult_count);
@@ -453,15 +455,15 @@ static int set_nowerr(ide_drive_t *drive
 
 static int ide_do_setfeature(ide_drive_t *drive, u8 feature, u8 nsect)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf.feature = feature;
-	task.tf.nsect   = nsect;
-	task.tf.command = ATA_CMD_SET_FEATURES;
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf.feature = feature;
+	cmd.tf.nsect   = nsect;
+	cmd.tf.command = ATA_CMD_SET_FEATURES;
+	cmd.tf_flags   = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	return ide_no_data_taskfile(drive, &task);
+	return ide_no_data_taskfile(drive, &cmd);
 }
 
 static void update_ordered(ide_drive_t *drive)
@@ -528,15 +530,16 @@ static int set_wcache(ide_drive_t *drive
 
 static int do_idedisk_flushcache(ide_drive_t *drive)
 {
-	ide_task_t args;
+	struct ide_cmd cmd;
 
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	if (ata_id_flush_ext_enabled(drive->id))
-		args.tf.command = ATA_CMD_FLUSH_EXT;
+		cmd.tf.command = ATA_CMD_FLUSH_EXT;
 	else
-		args.tf.command = ATA_CMD_FLUSH;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	return ide_no_data_taskfile(drive, &args);
+		cmd.tf.command = ATA_CMD_FLUSH;
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	return ide_no_data_taskfile(drive, &cmd);
 }
 
 ide_devset_get(acoustic, acoustic);
@@ -708,17 +711,17 @@ static int ide_disk_init_media(ide_drive
 static int ide_disk_set_doorlock(ide_drive_t *drive, struct gendisk *disk,
 				 int on)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 	int ret;
 
 	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0)
 		return 0;
 
-	memset(&task, 0, sizeof(task));
-	task.tf.command = on ? ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf.command = on ? ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
+	cmd.tf_flags   = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	ret = ide_no_data_taskfile(drive, &task);
+	ret = ide_no_data_taskfile(drive, &cmd);
 
 	if (ret)
 		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
Index: b/drivers/ide/ide-disk_proc.c
===================================================================
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -6,33 +6,34 @@
 
 static int smart_enable(ide_drive_t *drive)
 {
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	tf->feature = ATA_SMART_ENABLE;
 	tf->lbam    = ATA_SMART_LBAM_PASS;
 	tf->lbah    = ATA_SMART_LBAH_PASS;
 	tf->command = ATA_CMD_SMART;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	return ide_no_data_taskfile(drive, &args);
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	return ide_no_data_taskfile(drive, &cmd);
 }
 
 static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
 {
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 
-	memset(&args, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	tf->feature = sub_cmd;
 	tf->nsect   = 0x01;
 	tf->lbam    = ATA_SMART_LBAM_PASS;
 	tf->lbah    = ATA_SMART_LBAH_PASS;
 	tf->command = ATA_CMD_SMART;
-	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args.data_phase	= TASKFILE_IN;
+	cmd.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.data_phase	= TASKFILE_IN;
 
-	return ide_raw_taskfile(drive, &args, buf, 1);
+	return ide_raw_taskfile(drive, &cmd, buf, 1);
 }
 
 static int proc_idedisk_read_cache
Index: b/drivers/ide/ide-eh.c
===================================================================
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -125,10 +125,10 @@ ide_startstop_t ide_error(ide_drive_t *d
 	if (!blk_fs_request(rq)) {
 		rq->errors = 1;
 		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-			ide_task_t *task = rq->special;
+			struct ide_cmd *cmd = rq->special;
 
-			if (task)
-				ide_complete_task(drive, task, stat, err);
+			if (cmd)
+				ide_complete_cmd(drive, cmd, stat, err);
 		} else if (blk_pm_request(rq)) {
 			ide_complete_pm_rq(drive, rq);
 			return ide_stopped;
Index: b/drivers/ide/ide-h8300.c
===================================================================
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -44,53 +44,53 @@ static u16 mm_inw(unsigned long a)
 	return r;
 }
 
-static void h8300_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void h8300_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA)
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA)
 		mm_outw((tf->hob_data << 8) | tf->data, io_ports->data_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		outb((tf->device & HIHI) | drive->select,
 		     io_ports->device_addr);
 }
 
-static void h8300_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void h8300_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = mm_inw(io_ports->data_addr);
 
 		tf->data = data & 0xff;
@@ -100,31 +100,31 @@ static void h8300_tf_read(ide_drive_t *d
 	/* be sure we're looking at the low order bits */
 	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = inb(io_ports->lbah_addr);
 	}
 }
Index: b/drivers/ide/ide-io-std.c
===================================================================
--- a/drivers/ide/ide-io-std.c
+++ b/drivers/ide/ide-io-std.c
@@ -82,24 +82,24 @@ void ide_set_irq(ide_hwif_t *hwif, int o
 }
 EXPORT_SYMBOL_GPL(ide_set_irq);
 
-void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+void ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 	void (*tf_outb)(u8 addr, unsigned long port);
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
 	if (mmio)
 		tf_outb = ide_mm_outb;
 	else
 		tf_outb = ide_outb;
 
-	if (task->ftf_flags & IDE_FTFLAG_FLAGGED)
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		if (mmio)
@@ -108,39 +108,39 @@ void ide_tf_load(ide_drive_t *drive, ide
 			outw(data, io_ports->data_addr);
 	}
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tf_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		tf_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		tf_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		tf_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		tf_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		tf_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		tf_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		tf_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		tf_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		tf_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		tf_outb((tf->device & HIHI) | drive->select,
 			 io_ports->device_addr);
 }
 EXPORT_SYMBOL_GPL(ide_tf_load);
 
-void ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+void ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 	void (*tf_outb)(u8 addr, unsigned long port);
 	u8 (*tf_inb)(unsigned long port);
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
@@ -153,7 +153,7 @@ void ide_tf_read(ide_drive_t *drive, ide
 		tf_inb  = ide_inb;
 	}
 
-	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		if (mmio)
@@ -168,31 +168,31 @@ void ide_tf_read(ide_drive_t *drive, ide
 	/* be sure we're looking at the low order bits */
 	tf_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = tf_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tf_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = tf_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = tf_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = tf_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = tf_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		tf_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = tf_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = tf_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = tf_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = tf_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = tf_inb(io_ports->lbah_addr);
 	}
 }
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -144,17 +144,17 @@ int ide_end_dequeued_request(ide_drive_t
 }
 EXPORT_SYMBOL_GPL(ide_end_dequeued_request);
 
-void ide_complete_task(ide_drive_t *drive, ide_task_t *task, u8 stat, u8 err)
+void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 {
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
 	tf->error = err;
 	tf->status = stat;
 
-	drive->hwif->tp_ops->tf_read(drive, task);
+	drive->hwif->tp_ops->tf_read(drive, cmd);
 
-	if (task->tf_flags & IDE_TFLAG_DYN)
-		kfree(task);
+	if (cmd->tf_flags & IDE_TFLAG_DYN)
+		kfree(cmd);
 }
 
 void ide_complete_rq(ide_drive_t *drive, u8 err)
@@ -213,20 +213,20 @@ static void ide_tf_set_setmult_cmd(ide_d
 static ide_startstop_t ide_disk_special(ide_drive_t *drive)
 {
 	special_t *s = &drive->special;
-	ide_task_t args;
+	struct ide_cmd cmd;
 
-	memset(&args, 0, sizeof(ide_task_t));
-	args.data_phase = TASKFILE_NO_DATA;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.data_phase = TASKFILE_NO_DATA;
 
 	if (s->b.set_geometry) {
 		s->b.set_geometry = 0;
-		ide_tf_set_specify_cmd(drive, &args.tf);
+		ide_tf_set_specify_cmd(drive, &cmd.tf);
 	} else if (s->b.recalibrate) {
 		s->b.recalibrate = 0;
-		ide_tf_set_restore_cmd(drive, &args.tf);
+		ide_tf_set_restore_cmd(drive, &cmd.tf);
 	} else if (s->b.set_multmode) {
 		s->b.set_multmode = 0;
-		ide_tf_set_setmult_cmd(drive, &args.tf);
+		ide_tf_set_setmult_cmd(drive, &cmd.tf);
 	} else if (s->all) {
 		int special = s->all;
 		s->all = 0;
@@ -234,10 +234,10 @@ static ide_startstop_t ide_disk_special(
 		return ide_stopped;
 	}
 
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE |
-			IDE_TFLAG_CUSTOM_HANDLER;
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE |
+		       IDE_TFLAG_CUSTOM_HANDLER;
 
-	do_rw_taskfile(drive, &args);
+	do_rw_taskfile(drive, &cmd);
 
 	return ide_started;
 }
@@ -311,10 +311,10 @@ EXPORT_SYMBOL_GPL(ide_init_sg_cmd);
 static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 		struct request *rq)
 {
-	ide_task_t *task = rq->special;
+	struct ide_cmd *cmd = rq->special;
 
-	if (task) {
-		switch (task->data_phase) {
+	if (cmd) {
+		switch (cmd->data_phase) {
 		case TASKFILE_MULTI_OUT:
 		case TASKFILE_OUT:
 		case TASKFILE_MULTI_IN:
@@ -325,7 +325,7 @@ static ide_startstop_t execute_drive_cmd
 			break;
 		}
 
-		return do_rw_taskfile(drive, task);
+		return do_rw_taskfile(drive, cmd);
 	}
 
  	/*
Index: b/drivers/ide/ide-ioctls.c
===================================================================
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -111,13 +111,13 @@ static int ide_set_nice_ioctl(ide_drive_
 	return 0;
 }
 
-static int ide_cmd_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
+static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 {
 	u8 *buf = NULL;
 	int bufsize = 0, err = 0;
 	u8 args[4], xfer_rate = 0;
-	ide_task_t tfargs;
-	struct ide_taskfile *tf = &tfargs.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 	u16 *id = drive->id;
 
 	if (NULL == (void *) arg) {
@@ -134,24 +134,24 @@ static int ide_cmd_ioctl(ide_drive_t *dr
 	if (copy_from_user(args, (void __user *)arg, 4))
 		return -EFAULT;
 
-	memset(&tfargs, 0, sizeof(ide_task_t));
+	memset(&cmd, 0, sizeof(cmd));
 	tf->feature = args[2];
 	if (args[0] == ATA_CMD_SMART) {
 		tf->nsect = args[3];
 		tf->lbal  = args[1];
 		tf->lbam  = 0x4f;
 		tf->lbah  = 0xc2;
-		tfargs.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
+		cmd.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
 	} else {
 		tf->nsect = args[1];
-		tfargs.tf_flags = IDE_TFLAG_OUT_FEATURE |
-				  IDE_TFLAG_OUT_NSECT | IDE_TFLAG_IN_NSECT;
+		cmd.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
+			       IDE_TFLAG_IN_NSECT;
 	}
 	tf->command = args[0];
-	tfargs.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
+	cmd.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
 
 	if (args[3]) {
-		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
+		cmd.tf_flags |= IDE_TFLAG_IO_16BIT;
 		bufsize = SECTOR_SIZE * args[3];
 		buf = kzalloc(bufsize, GFP_KERNEL);
 		if (buf == NULL)
@@ -172,7 +172,7 @@ static int ide_cmd_ioctl(ide_drive_t *dr
 		}
 	}
 
-	err = ide_raw_taskfile(drive, &tfargs, buf, args[3]);
+	err = ide_raw_taskfile(drive, &cmd, buf, args[3]);
 
 	args[0] = tf->status;
 	args[1] = tf->error;
@@ -194,25 +194,25 @@ abort:
 	return err;
 }
 
-static int ide_task_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
+static int ide_task_ioctl(ide_drive_t *drive, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int err = 0;
 	u8 args[7];
-	ide_task_t task;
+	struct ide_cmd cmd;
 
 	if (copy_from_user(args, p, 7))
 		return -EFAULT;
 
-	memset(&task, 0, sizeof(task));
-	memcpy(&task.tf_array[7], &args[1], 6);
-	task.tf.command = args[0];
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	memcpy(&cmd.tf_array[7], &args[1], 6);
+	cmd.tf.command = args[0];
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	err = ide_no_data_taskfile(drive, &task);
+	err = ide_no_data_taskfile(drive, &cmd);
 
-	args[0] = task.tf.command;
-	memcpy(&args[1], &task.tf_array[7], 6);
+	args[0] = cmd.tf.command;
+	memcpy(&args[1], &cmd.tf_array[7], 6);
 
 	if (copy_to_user(p, args, 7))
 		err = -EFAULT;
@@ -262,17 +262,17 @@ int generic_ide_ioctl(ide_drive_t *drive
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 			return -EACCES;
 		if (drive->media == ide_disk)
-			return ide_taskfile_ioctl(drive, cmd, arg);
+			return ide_taskfile_ioctl(drive, arg);
 		return -ENOMSG;
 #endif
 	case HDIO_DRIVE_CMD:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		return ide_cmd_ioctl(drive, cmd, arg);
+		return ide_cmd_ioctl(drive, arg);
 	case HDIO_DRIVE_TASK:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		return ide_task_ioctl(drive, cmd, arg);
+		return ide_task_ioctl(drive, arg);
 	case HDIO_DRIVE_RESET:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -31,15 +31,15 @@ void SELECT_DRIVE(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
-	ide_task_t task;
+	struct ide_cmd cmd;
 
 	if (port_ops && port_ops->selectproc)
 		port_ops->selectproc(drive);
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_OUT_DEVICE;
 
-	drive->hwif->tp_ops->tf_load(drive, &task);
+	drive->hwif->tp_ops->tf_load(drive, &cmd);
 }
 
 void SELECT_MASK(ide_drive_t *drive, int mask)
@@ -52,14 +52,14 @@ void SELECT_MASK(ide_drive_t *drive, int
 
 u8 ide_read_error(ide_drive_t *drive)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_FEATURE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_IN_FEATURE;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
-	return task.tf.error;
+	return cmd.tf.error;
 }
 EXPORT_SYMBOL_GPL(ide_read_error);
 
@@ -329,7 +329,7 @@ int ide_config_drive_speed(ide_drive_t *
 	u16 *id = drive->id, i;
 	int error = 0;
 	u8 stat;
-	ide_task_t task;
+	struct ide_cmd cmd;
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->dma_ops)	/* check if host supports DMA */
@@ -361,12 +361,12 @@ int ide_config_drive_speed(ide_drive_t *
 	udelay(1);
 	tp_ops->set_irq(hwif, 0);
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
-	task.tf.feature = SETFEATURES_XFER;
-	task.tf.nsect   = speed;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
+	cmd.tf.feature = SETFEATURES_XFER;
+	cmd.tf.nsect   = speed;
 
-	tp_ops->tf_load(drive, &task);
+	tp_ops->tf_load(drive, &cmd);
 
 	tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
 
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -34,19 +34,19 @@ void ide_toggle_bounce(ide_drive_t *driv
 static void ide_dump_opcode(ide_drive_t *drive)
 {
 	struct request *rq = drive->hwif->rq;
-	ide_task_t *task = NULL;
+	struct ide_cmd *cmd = NULL;
 
 	if (!rq)
 		return;
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
-		task = rq->special;
+		cmd = rq->special;
 
 	printk(KERN_ERR "ide: failed opcode was: ");
-	if (task == NULL)
+	if (cmd == NULL)
 		printk(KERN_CONT "unknown\n");
 	else
-		printk(KERN_CONT "0x%02x\n", task->tf.command);
+		printk(KERN_CONT "0x%02x\n", cmd->tf.command);
 }
 
 u64 ide_get_lba_addr(struct ide_taskfile *tf, int lba48)
@@ -66,18 +66,18 @@ EXPORT_SYMBOL_GPL(ide_get_lba_addr);
 
 static void ide_dump_sector(ide_drive_t *drive)
 {
-	ide_task_t task;
-	struct ide_taskfile *tf = &task.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 	u8 lba48 = !!(drive->dev_flags & IDE_DFLAG_LBA48);
 
-	memset(&task, 0, sizeof(task));
+	memset(&cmd, 0, sizeof(cmd));
 	if (lba48)
-		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_HOB_LBA |
+		cmd.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_HOB_LBA |
 				IDE_TFLAG_LBA48;
 	else
-		task.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
+		cmd.tf_flags = IDE_TFLAG_IN_LBA | IDE_TFLAG_IN_DEVICE;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
 	if (lba48 || (tf->device & ATA_LBA))
 		printk(KERN_CONT ", LBAsect=%llu",
Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -63,10 +63,10 @@ out:
 
 ide_startstop_t ide_do_park_unpark(ide_drive_t *drive, struct request *rq)
 {
-	ide_task_t task;
-	struct ide_taskfile *tf = &task.tf;
+	struct ide_cmd cmd;
+	struct ide_taskfile *tf = &cmd.tf;
 
-	memset(&task, 0, sizeof(task));
+	memset(&cmd, 0, sizeof(cmd));
 	if (rq->cmd[0] == REQ_PARK_HEADS) {
 		drive->sleep = *(unsigned long *)rq->special;
 		drive->dev_flags |= IDE_DFLAG_SLEEPING;
@@ -75,14 +75,15 @@ ide_startstop_t ide_do_park_unpark(ide_d
 		tf->lbal = 0x4c;
 		tf->lbam = 0x4e;
 		tf->lbah = 0x55;
-		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+		cmd.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
 	} else		/* cmd == REQ_UNPARK_HEADS */
 		tf->command = ATA_CMD_CHK_POWER;
 
-	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	task.rq = rq;
-	task.data_phase = TASKFILE_NO_DATA;
-	return do_rw_taskfile(drive, &task);
+	cmd.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.rq = rq;
+	cmd.data_phase = TASKFILE_NO_DATA;
+
+	return do_rw_taskfile(drive, &cmd);
 }
 
 ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
Index: b/drivers/ide/ide-pm.c
===================================================================
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -8,7 +8,7 @@ int generic_ide_suspend(struct device *d
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
-	ide_task_t args;
+	struct ide_cmd cmd;
 	int ret;
 
 	/* call ACPI _GTM only once */
@@ -16,10 +16,10 @@ int generic_ide_suspend(struct device *d
 		ide_acpi_get_timing(hwif);
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&args, 0, sizeof(args));
+	memset(&cmd, 0, sizeof(cmd));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
-	rq->special = &args;
+	rq->special = &cmd;
 	rq->data = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
 	if (mesg.event == PM_EVENT_PRETHAW)
@@ -42,7 +42,7 @@ int generic_ide_resume(struct device *de
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
-	ide_task_t args;
+	struct ide_cmd cmd;
 	int err;
 
 	/* call ACPI _PS0 / _STM only once */
@@ -54,11 +54,11 @@ int generic_ide_resume(struct device *de
 	ide_acpi_exec_tfs(drive);
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&args, 0, sizeof(args));
+	memset(&cmd, 0, sizeof(cmd));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_PM_RESUME;
 	rq->cmd_flags |= REQ_PREEMPT;
-	rq->special = &args;
+	rq->special = &cmd;
 	rq->data = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
@@ -109,9 +109,9 @@ void ide_complete_power_step(ide_drive_t
 ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 {
 	struct request_pm_state *pm = rq->data;
-	ide_task_t *args = rq->special;
+	struct ide_cmd *cmd = rq->special;
 
-	memset(args, 0, sizeof(*args));
+	memset(cmd, 0, sizeof(*cmd));
 
 	switch (pm->pm_step) {
 	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
@@ -124,12 +124,12 @@ ide_startstop_t ide_start_power_step(ide
 			return ide_stopped;
 		}
 		if (ata_id_flush_ext_enabled(drive->id))
-			args->tf.command = ATA_CMD_FLUSH_EXT;
+			cmd->tf.command = ATA_CMD_FLUSH_EXT;
 		else
-			args->tf.command = ATA_CMD_FLUSH;
+			cmd->tf.command = ATA_CMD_FLUSH;
 		goto out_do_tf;
 	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
-		args->tf.command = ATA_CMD_STANDBYNOW1;
+		cmd->tf.command = ATA_CMD_STANDBYNOW1;
 		goto out_do_tf;
 	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
 		ide_set_max_pio(drive);
@@ -142,7 +142,7 @@ ide_startstop_t ide_start_power_step(ide
 			ide_complete_power_step(drive, rq);
 		return ide_stopped;
 	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
-		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
+		cmd->tf.command = ATA_CMD_IDLEIMMEDIATE;
 		goto out_do_tf;
 	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
 		/*
@@ -160,12 +160,14 @@ ide_startstop_t ide_start_power_step(ide
 	}
 
 	pm->pm_step = IDE_PM_COMPLETED;
+
 	return ide_stopped;
 
 out_do_tf:
-	args->tf_flags	 = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args->data_phase = TASKFILE_NO_DATA;
-	return do_rw_taskfile(drive, args);
+	cmd->tf_flags	 = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd->data_phase = TASKFILE_NO_DATA;
+
+	return do_rw_taskfile(drive, cmd);
 }
 
 /**
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -283,13 +283,13 @@ int ide_dev_read_id(ide_drive_t *drive, 
 	 * identify command to be sure of reply
 	 */
 	if (cmd == ATA_CMD_ID_ATAPI) {
-		ide_task_t task;
+		struct ide_cmd cmd;
 
-		memset(&task, 0, sizeof(task));
+		memset(&cmd, 0, sizeof(cmd));
 		/* disable DMA & overlap */
-		task.tf_flags = IDE_TFLAG_OUT_FEATURE;
+		cmd.tf_flags = IDE_TFLAG_OUT_FEATURE;
 
-		tp_ops->tf_load(drive, &task);
+		tp_ops->tf_load(drive, &cmd);
 	}
 
 	/* ask drive for ID */
@@ -337,14 +337,14 @@ int ide_busy_sleep(ide_hwif_t *hwif, uns
 
 static u8 ide_read_device(ide_drive_t *drive)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_DEVICE;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf_flags = IDE_TFLAG_IN_DEVICE;
 
-	drive->hwif->tp_ops->tf_read(drive, &task);
+	drive->hwif->tp_ops->tf_read(drive, &cmd);
 
-	return task.tf.device;
+	return cmd.tf.device;
 }
 
 /**
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -194,20 +194,20 @@ ide_devset_get(xfer_rate, current_speed)
 
 static int set_xfer_rate (ide_drive_t *drive, int arg)
 {
-	ide_task_t task;
+	struct ide_cmd cmd;
 	int err;
 
 	if (arg < XFER_PIO_0 || arg > XFER_UDMA_6)
 		return -EINVAL;
 
-	memset(&task, 0, sizeof(task));
-	task.tf.command = ATA_CMD_SET_FEATURES;
-	task.tf.feature = SETFEATURES_XFER;
-	task.tf.nsect   = (u8)arg;
-	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
-			IDE_TFLAG_IN_NSECT;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf.command = ATA_CMD_SET_FEATURES;
+	cmd.tf.feature = SETFEATURES_XFER;
+	cmd.tf.nsect   = (u8)arg;
+	cmd.tf_flags   = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
+			 IDE_TFLAG_IN_NSECT;
 
-	err = ide_no_data_taskfile(drive, &task);
+	err = ide_no_data_taskfile(drive, &cmd);
 
 	if (!err) {
 		ide_set_xfer_rate(drive, (u8) arg);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -39,33 +39,34 @@ void ide_tf_dump(const char *s, struct i
 
 int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
 {
-	ide_task_t args;
+	struct ide_cmd cmd;
 
-	memset(&args, 0, sizeof(ide_task_t));
-	args.tf.nsect = 0x01;
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tf.nsect = 0x01;
 	if (drive->media == ide_disk)
-		args.tf.command = ATA_CMD_ID_ATA;
+		cmd.tf.command = ATA_CMD_ID_ATA;
 	else
-		args.tf.command = ATA_CMD_ID_ATAPI;
-	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args.data_phase	= TASKFILE_IN;
-	return ide_raw_taskfile(drive, &args, buf, 1);
+		cmd.tf.command = ATA_CMD_ID_ATAPI;
+	cmd.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.data_phase	= TASKFILE_IN;
+
+	return ide_raw_taskfile(drive, &cmd, buf, 1);
 }
 
 static ide_startstop_t task_no_data_intr(ide_drive_t *);
 static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
 static ide_startstop_t task_in_intr(ide_drive_t *);
 
-ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
+ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 	ide_handler_t *handler = NULL;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
-	if (task->data_phase == TASKFILE_MULTI_IN ||
-	    task->data_phase == TASKFILE_MULTI_OUT) {
+	if (cmd->data_phase == TASKFILE_MULTI_IN ||
+	    cmd->data_phase == TASKFILE_MULTI_OUT) {
 		if (!drive->mult_count) {
 			printk(KERN_ERR "%s: multimode not set!\n",
 					drive->name);
@@ -73,24 +74,24 @@ ide_startstop_t do_rw_taskfile (ide_driv
 		}
 	}
 
-	if (task->ftf_flags & IDE_FTFLAG_FLAGGED)
-		task->ftf_flags |= IDE_FTFLAG_SET_IN_FLAGS;
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
+		cmd->ftf_flags |= IDE_FTFLAG_SET_IN_FLAGS;
 
-	memcpy(&hwif->task, task, sizeof(*task));
+	memcpy(&hwif->cmd, cmd, sizeof(*cmd));
 
-	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
+	if ((cmd->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
 		tp_ops->set_irq(hwif, 1);
 		SELECT_MASK(drive, 0);
-		tp_ops->tf_load(drive, task);
+		tp_ops->tf_load(drive, cmd);
 	}
 
-	switch (task->data_phase) {
+	switch (cmd->data_phase) {
 	case TASKFILE_MULTI_OUT:
 	case TASKFILE_OUT:
 		tp_ops->exec_command(hwif, tf->command);
 		ndelay(400);	/* FIXME */
-		return pre_task_out_intr(drive, task->rq);
+		return pre_task_out_intr(drive, cmd->rq);
 	case TASKFILE_MULTI_IN:
 	case TASKFILE_IN:
 		handler = task_in_intr;
@@ -119,9 +120,9 @@ EXPORT_SYMBOL_GPL(do_rw_taskfile);
 static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t *task = &hwif->task;
-	struct ide_taskfile *tf = &task->tf;
-	int custom = (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) ? 1 : 0;
+	struct ide_cmd *cmd = &hwif->cmd;
+	struct ide_taskfile *tf = &cmd->tf;
+	int custom = (cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) ? 1 : 0;
 	int retries = (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) ? 5 : 1;
 	u8 stat;
 
@@ -151,7 +152,7 @@ static ide_startstop_t task_no_data_intr
 	}
 
 	if (custom && tf->command == ATA_CMD_IDLEIMMEDIATE) {
-		hwif->tp_ops->tf_read(drive, task);
+		hwif->tp_ops->tf_read(drive, cmd);
 		if (tf->lbal != 0xc4) {
 			printk(KERN_ERR "%s: head unload failed!\n",
 			       drive->name);
@@ -166,7 +167,7 @@ static ide_startstop_t task_no_data_intr
 		u8 err = ide_read_error(drive);
 
 		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
-			ide_complete_task(drive, task, stat, err);
+			ide_complete_cmd(drive, cmd, stat, err);
 		ide_complete_rq(drive, err);
 	}
 
@@ -262,18 +263,18 @@ static void ide_pio_multi(ide_drive_t *d
 static void ide_pio_datablock(ide_drive_t *drive, struct request *rq,
 				     unsigned int write)
 {
-	ide_task_t *task = &drive->hwif->task;
+	struct ide_cmd *cmd = &drive->hwif->cmd;
 	u8 saved_io_32bit = drive->io_32bit;
 
 	if (blk_fs_request(rq))
 		rq->errors = 0;
 
-	if (task->tf_flags & IDE_TFLAG_IO_16BIT)
+	if (cmd->tf_flags & IDE_TFLAG_IO_16BIT)
 		drive->io_32bit = 0;
 
 	touch_softlockup_watchdog();
 
-	switch (task->data_phase) {
+	switch (cmd->data_phase) {
 	case TASKFILE_MULTI_IN:
 	case TASKFILE_MULTI_OUT:
 		ide_pio_multi(drive, rq, write);
@@ -291,10 +292,10 @@ static ide_startstop_t task_error(ide_dr
 {
 	if (blk_fs_request(rq)) {
 		ide_hwif_t *hwif = drive->hwif;
-		ide_task_t *task = &hwif->task;
+		struct ide_cmd *cmd = &hwif->cmd;
 		int sectors = hwif->nsect - hwif->nleft;
 
-		switch (task->data_phase) {
+		switch (cmd->data_phase) {
 		case TASKFILE_IN:
 			if (hwif->nleft)
 				break;
@@ -321,11 +322,11 @@ static ide_startstop_t task_error(ide_dr
 void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
 	if (blk_fs_request(rq) == 0) {
-		ide_task_t *task = rq->special;
+		struct ide_cmd *cmd = rq->special;
 		u8 err = ide_read_error(drive);
 
-		if (task)
-			ide_complete_task(drive, task, stat, err);
+		if (cmd)
+			ide_complete_cmd(drive, cmd, stat, err);
 		ide_complete_rq(drive, err);
 		return;
 	}
@@ -416,14 +417,14 @@ static ide_startstop_t task_out_intr (id
 
 static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 {
-	ide_task_t *task = &drive->hwif->task;
+	struct ide_cmd *cmd = &drive->hwif->cmd;
 	ide_startstop_t startstop;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
 			drive->name,
-			task->data_phase == TASKFILE_MULTI_OUT ? "MULT" : "",
+			cmd->data_phase == TASKFILE_MULTI_OUT ? "MULT" : "",
 			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
@@ -437,7 +438,8 @@ static ide_startstop_t pre_task_out_intr
 	return ide_started;
 }
 
-int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
+int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
+		     u16 nsect)
 {
 	struct request *rq;
 	int error;
@@ -455,11 +457,11 @@ int ide_raw_taskfile(ide_drive_t *drive,
 	rq->hard_nr_sectors = rq->nr_sectors = nsect;
 	rq->hard_cur_sectors = rq->current_nr_sectors = nsect;
 
-	if (task->tf_flags & IDE_TFLAG_WRITE)
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
 		rq->cmd_flags |= REQ_RW;
 
-	rq->special = task;
-	task->rq = rq;
+	rq->special = cmd;
+	cmd->rq = rq;
 
 	error = blk_execute_rq(drive->queue, NULL, rq, 0);
 	blk_put_request(rq);
@@ -469,19 +471,19 @@ int ide_raw_taskfile(ide_drive_t *drive,
 
 EXPORT_SYMBOL(ide_raw_taskfile);
 
-int ide_no_data_taskfile(ide_drive_t *drive, ide_task_t *task)
+int ide_no_data_taskfile(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	task->data_phase = TASKFILE_NO_DATA;
+	cmd->data_phase = TASKFILE_NO_DATA;
 
-	return ide_raw_taskfile(drive, task, NULL, 0);
+	return ide_raw_taskfile(drive, cmd, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(ide_no_data_taskfile);
 
 #ifdef CONFIG_IDE_TASK_IOCTL
-int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
+int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 {
 	ide_task_request_t	*req_task;
-	ide_task_t		args;
+	struct ide_cmd		cmd;
 	u8 *outbuf		= NULL;
 	u8 *inbuf		= NULL;
 	u8 *data_buf		= NULL;
@@ -535,51 +537,53 @@ int ide_taskfile_ioctl (ide_drive_t *dri
 		}
 	}
 
-	memset(&args, 0, sizeof(ide_task_t));
-
-	memcpy(&args.tf_array[0], req_task->hob_ports, HDIO_DRIVE_HOB_HDR_SIZE - 2);
-	memcpy(&args.tf_array[6], req_task->io_ports, HDIO_DRIVE_TASK_HDR_SIZE);
+	memset(&cmd, 0, sizeof(cmd));
 
-	args.data_phase = req_task->data_phase;
+	memcpy(&cmd.tf_array[0], req_task->hob_ports,
+	       HDIO_DRIVE_HOB_HDR_SIZE - 2);
+	memcpy(&cmd.tf_array[6], req_task->io_ports,
+	       HDIO_DRIVE_TASK_HDR_SIZE);
+
+	cmd.data_phase = req_task->data_phase;
+	cmd.tf_flags   = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
+			 IDE_TFLAG_IN_TF;
 
-	args.tf_flags = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
-			IDE_TFLAG_IN_TF;
 	if (drive->dev_flags & IDE_DFLAG_LBA48)
-		args.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
+		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
 
 	if (req_task->out_flags.all) {
-		args.ftf_flags |= IDE_FTFLAG_FLAGGED;
+		cmd.ftf_flags |= IDE_FTFLAG_FLAGGED;
 
 		if (req_task->out_flags.b.data)
-			args.ftf_flags |= IDE_FTFLAG_OUT_DATA;
+			cmd.ftf_flags |= IDE_FTFLAG_OUT_DATA;
 
 		if (req_task->out_flags.b.nsector_hob)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB_NSECT;
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_NSECT;
 		if (req_task->out_flags.b.sector_hob)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAL;
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAL;
 		if (req_task->out_flags.b.lcyl_hob)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAM;
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAM;
 		if (req_task->out_flags.b.hcyl_hob)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB_LBAH;
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB_LBAH;
 
 		if (req_task->out_flags.b.error_feature)
-			args.tf_flags |= IDE_TFLAG_OUT_FEATURE;
+			cmd.tf_flags |= IDE_TFLAG_OUT_FEATURE;
 		if (req_task->out_flags.b.nsector)
-			args.tf_flags |= IDE_TFLAG_OUT_NSECT;
+			cmd.tf_flags |= IDE_TFLAG_OUT_NSECT;
 		if (req_task->out_flags.b.sector)
-			args.tf_flags |= IDE_TFLAG_OUT_LBAL;
+			cmd.tf_flags |= IDE_TFLAG_OUT_LBAL;
 		if (req_task->out_flags.b.lcyl)
-			args.tf_flags |= IDE_TFLAG_OUT_LBAM;
+			cmd.tf_flags |= IDE_TFLAG_OUT_LBAM;
 		if (req_task->out_flags.b.hcyl)
-			args.tf_flags |= IDE_TFLAG_OUT_LBAH;
+			cmd.tf_flags |= IDE_TFLAG_OUT_LBAH;
 	} else {
-		args.tf_flags |= IDE_TFLAG_OUT_TF;
-		if (args.tf_flags & IDE_TFLAG_LBA48)
-			args.tf_flags |= IDE_TFLAG_OUT_HOB;
+		cmd.tf_flags |= IDE_TFLAG_OUT_TF;
+		if (cmd.tf_flags & IDE_TFLAG_LBA48)
+			cmd.tf_flags |= IDE_TFLAG_OUT_HOB;
 	}
 
 	if (req_task->in_flags.b.data)
-		args.ftf_flags |= IDE_FTFLAG_IN_DATA;
+		cmd.ftf_flags |= IDE_FTFLAG_IN_DATA;
 
 	switch(req_task->data_phase) {
 		case TASKFILE_MULTI_OUT:
@@ -626,7 +630,7 @@ int ide_taskfile_ioctl (ide_drive_t *dri
 	if (req_task->req_cmd == IDE_DRIVE_TASK_NO_DATA)
 		nsect = 0;
 	else if (!nsect) {
-		nsect = (args.tf.hob_nsect << 8) | args.tf.nsect;
+		nsect = (cmd.tf.hob_nsect << 8) | cmd.tf.nsect;
 
 		if (!nsect) {
 			printk(KERN_ERR "%s: in/out command without data\n",
@@ -637,14 +641,16 @@ int ide_taskfile_ioctl (ide_drive_t *dri
 	}
 
 	if (req_task->req_cmd == IDE_DRIVE_TASK_RAW_WRITE)
-		args.tf_flags |= IDE_TFLAG_WRITE;
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
 
-	err = ide_raw_taskfile(drive, &args, data_buf, nsect);
+	err = ide_raw_taskfile(drive, &cmd, data_buf, nsect);
 
-	memcpy(req_task->hob_ports, &args.tf_array[0], HDIO_DRIVE_HOB_HDR_SIZE - 2);
-	memcpy(req_task->io_ports, &args.tf_array[6], HDIO_DRIVE_TASK_HDR_SIZE);
+	memcpy(req_task->hob_ports, &cmd.tf_array[0],
+	       HDIO_DRIVE_HOB_HDR_SIZE - 2);
+	memcpy(req_task->io_ports, &cmd.tf_array[6],
+	       HDIO_DRIVE_TASK_HDR_SIZE);
 
-	if ((args.ftf_flags & IDE_FTFLAG_SET_IN_FLAGS) &&
+	if ((cmd.ftf_flags & IDE_FTFLAG_SET_IN_FLAGS) &&
 	    req_task->in_flags.all == 0) {
 		req_task->in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
 		if (drive->dev_flags & IDE_DFLAG_LBA48)
Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -61,12 +61,12 @@ static u8 superio_dma_sff_read_status(id
 	return superio_ide_inb(hwif->dma_base + ATA_DMA_STATUS);
 }
 
-static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void superio_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = inw(io_ports->data_addr);
 
 		tf->data = data & 0xff;
@@ -76,31 +76,31 @@ static void superio_tf_read(ide_drive_t 
 	/* be sure we're looking at the low order bits */
 	outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = superio_ide_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = inb(io_ports->lbah_addr);
 	}
 }
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -666,52 +666,52 @@ static int __devinit init_setup_scc(stru
 	return rc;
 }
 
-static void scc_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void scc_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA)
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA)
 		out_be32((void *)io_ports->data_addr,
 			 (tf->hob_data << 8) | tf->data);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		scc_ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		scc_ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		scc_ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		scc_ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		scc_ide_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		scc_ide_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		scc_ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		scc_ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		scc_ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		scc_ide_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		scc_ide_outb((tf->device & HIHI) | drive->select,
 			     io_ports->device_addr);
 }
 
-static void scc_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void scc_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data = (u16)in_be32((void *)io_ports->data_addr);
 
 		tf->data = data & 0xff;
@@ -721,31 +721,31 @@ static void scc_tf_read(ide_drive_t *dri
 	/* be sure we're looking at the low order bits */
 	scc_ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = scc_ide_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = scc_ide_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = scc_ide_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = scc_ide_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = scc_ide_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = scc_ide_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		scc_ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature = scc_ide_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = scc_ide_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = scc_ide_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = scc_ide_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = scc_ide_inb(io_ports->lbah_addr);
 	}
 }
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -82,57 +82,57 @@ static void tx4938ide_outb(u8 value, uns
 	__raw_writeb(value, (void __iomem *)port);
 }
 
-static void tx4938ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void tx4938ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = task->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = cmd->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		/* no endian swap */
 		__raw_writew(data, (void __iomem *)io_ports->data_addr);
 	}
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tx4938ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		tx4938ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		tx4938ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		tx4938ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		tx4938ide_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		tx4938ide_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		tx4938ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		tx4938ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		tx4938ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		tx4938ide_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
 		tx4938ide_outb((tf->device & HIHI) | drive->select,
 			       io_ports->device_addr);
 }
 
-static void tx4938ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void tx4938ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		/* no endian swap */
@@ -144,32 +144,32 @@ static void tx4938ide_tf_read(ide_drive_
 	/* be sure we're looking at the low order bits */
 	tx4938ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = tx4938ide_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tx4938ide_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = tx4938ide_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = tx4938ide_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = tx4938ide_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = tx4938ide_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		tx4938ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature =
 				tx4938ide_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = tx4938ide_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = tx4938ide_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = tx4938ide_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = tx4938ide_inb(io_ports->lbah_addr);
 	}
 }
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -435,7 +435,7 @@ static int tx4939ide_init_dma(ide_hwif_t
 	return ide_allocate_dma_engine(hwif);
 }
 
-static void tx4939ide_tf_load_fixup(ide_drive_t *drive, ide_task_t *task)
+static void tx4939ide_tf_load_fixup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *base = TX4939IDE_BASE(hwif);
@@ -463,59 +463,59 @@ static void tx4939ide_outb(u8 value, uns
 	__raw_writeb(value, (void __iomem *)port);
 }
 
-static void tx4939ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
-	u8 HIHI = task->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
+	struct ide_taskfile *tf = &cmd->tf;
+	u8 HIHI = cmd->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (cmd->tf_flags & IDE_TFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		/* no endian swap */
 		__raw_writew(data, (void __iomem *)io_ports->data_addr);
 	}
 
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
 		tx4939ide_outb(tf->hob_feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
 		tx4939ide_outb(tf->hob_nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
 		tx4939ide_outb(tf->hob_lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
 		tx4939ide_outb(tf->hob_lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
 		tx4939ide_outb(tf->hob_lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_FEATURE)
 		tx4939ide_outb(tf->feature, io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_NSECT)
 		tx4939ide_outb(tf->nsect, io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAL)
 		tx4939ide_outb(tf->lbal, io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAM)
 		tx4939ide_outb(tf->lbam, io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_OUT_LBAH)
 		tx4939ide_outb(tf->lbah, io_ports->lbah_addr);
 
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE) {
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE) {
 		tx4939ide_outb((tf->device & HIHI) | drive->select,
 			       io_ports->device_addr);
-		tx4939ide_tf_load_fixup(drive, task);
+		tx4939ide_tf_load_fixup(drive);
 	}
 }
 
-static void tx4939ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+static void tx4939ide_tf_read(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	struct ide_taskfile *tf = &task->tf;
+	struct ide_taskfile *tf = &cmd->tf;
 
-	if (task->ftf_flags & IDE_FTFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		/* no endian swap */
@@ -527,32 +527,32 @@ static void tx4939ide_tf_read(ide_drive_
 	/* be sure we're looking at the low order bits */
 	tx4939ide_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
 
-	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_FEATURE)
 		tf->feature = tx4939ide_inb(io_ports->feature_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+	if (cmd->tf_flags & IDE_TFLAG_IN_NSECT)
 		tf->nsect  = tx4939ide_inb(io_ports->nsect_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAL)
 		tf->lbal   = tx4939ide_inb(io_ports->lbal_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAM)
 		tf->lbam   = tx4939ide_inb(io_ports->lbam_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+	if (cmd->tf_flags & IDE_TFLAG_IN_LBAH)
 		tf->lbah   = tx4939ide_inb(io_ports->lbah_addr);
-	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+	if (cmd->tf_flags & IDE_TFLAG_IN_DEVICE)
 		tf->device = tx4939ide_inb(io_ports->device_addr);
 
-	if (task->tf_flags & IDE_TFLAG_LBA48) {
+	if (cmd->tf_flags & IDE_TFLAG_LBA48) {
 		tx4939ide_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
 
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
 			tf->hob_feature =
 				tx4939ide_inb(io_ports->feature_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
 			tf->hob_nsect   = tx4939ide_inb(io_ports->nsect_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
 			tf->hob_lbal    = tx4939ide_inb(io_ports->lbal_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
 			tf->hob_lbam    = tx4939ide_inb(io_ports->lbam_addr);
-		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+		if (cmd->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
 			tf->hob_lbah    = tx4939ide_inb(io_ports->lbah_addr);
 	}
 }
@@ -599,11 +599,12 @@ static const struct ide_tp_ops tx4939ide
 
 #else	/* __LITTLE_ENDIAN */
 
-static void tx4939ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	ide_tf_load(drive, task);
-	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tx4939ide_tf_load_fixup(drive, task);
+	ide_tf_load(drive, cmd);
+
+	if (cmd->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		tx4939ide_tf_load_fixup(drive);
 }
 
 static const struct ide_tp_ops tx4939ide_tp_ops = {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -295,7 +295,7 @@ enum {
 					  IDE_TFLAG_IN_DEVICE,
 	/* force 16-bit I/O operations */
 	IDE_TFLAG_IO_16BIT		= (1 << 26),
-	/* ide_task_t was allocated using kmalloc() */
+	/* struct ide_cmd was allocated using kmalloc() */
 	IDE_TFLAG_DYN			= (1 << 27),
 };
 
@@ -335,7 +335,7 @@ struct ide_taskfile {
 	};
 };
 
-typedef struct ide_task_s {
+struct ide_cmd {
 	union {
 		struct ide_taskfile	tf;
 		u8			tf_array[14];
@@ -345,7 +345,7 @@ typedef struct ide_task_s {
 	int			data_phase;
 	struct request		*rq;		/* copy of request */
 	void			*special;	/* valid_t generally */
-} ide_task_t;
+};
 
 /* ATAPI packet command flags */
 enum {
@@ -652,8 +652,8 @@ struct ide_tp_ops {
 
 	void	(*set_irq)(struct hwif_s *, int);
 
-	void	(*tf_load)(ide_drive_t *, struct ide_task_s *);
-	void	(*tf_read)(ide_drive_t *, struct ide_task_s *);
+	void	(*tf_load)(ide_drive_t *, struct ide_cmd *);
+	void	(*tf_read)(ide_drive_t *, struct ide_cmd *);
 
 	void	(*input_data)(ide_drive_t *, struct request *, void *,
 			      unsigned int);
@@ -774,7 +774,7 @@ typedef struct hwif_s {
 	int sg_nents;			/* Current number of entries in it */
 	int sg_dma_direction;		/* dma transfer direction */
 
-	struct ide_task_s task;		/* current command */
+	struct ide_cmd cmd;		/* current command */
 
 	unsigned int nsect;
 	unsigned int nleft;
@@ -1158,7 +1158,7 @@ extern ide_startstop_t ide_do_reset (ide
 extern int ide_devset_execute(ide_drive_t *drive,
 			      const struct ide_devset *setting, int arg);
 
-void ide_complete_task(ide_drive_t *, ide_task_t *, u8, u8);
+void ide_complete_cmd(ide_drive_t *, struct ide_cmd *, u8, u8);
 void ide_complete_rq(ide_drive_t *, u8);
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
@@ -1169,8 +1169,8 @@ u8 ide_read_altstatus(ide_hwif_t *);
 
 void ide_set_irq(ide_hwif_t *, int);
 
-void ide_tf_load(ide_drive_t *, ide_task_t *);
-void ide_tf_read(ide_drive_t *, ide_task_t *);
+void ide_tf_load(ide_drive_t *, struct ide_cmd *);
+void ide_tf_read(ide_drive_t *, struct ide_cmd *);
 
 void ide_input_data(ide_drive_t *, struct request *, void *, unsigned int);
 void ide_output_data(ide_drive_t *, struct request *, void *, unsigned int);
@@ -1221,14 +1221,14 @@ int ide_cd_get_xferlen(struct request *)
 
 ide_startstop_t ide_issue_pc(ide_drive_t *);
 
-ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
+ide_startstop_t do_rw_taskfile(ide_drive_t *, struct ide_cmd *);
 
 void task_end_request(ide_drive_t *, struct request *, u8);
 
-int ide_raw_taskfile(ide_drive_t *, ide_task_t *, u8 *, u16);
-int ide_no_data_taskfile(ide_drive_t *, ide_task_t *);
+int ide_raw_taskfile(ide_drive_t *, struct ide_cmd *, u8 *, u16);
+int ide_no_data_taskfile(ide_drive_t *, struct ide_cmd *);
 
-int ide_taskfile_ioctl(ide_drive_t *, unsigned int, unsigned long);
+int ide_taskfile_ioctl(ide_drive_t *, unsigned long);
 
 int ide_dev_read_id(ide_drive_t *, u8, u16 *);
 
