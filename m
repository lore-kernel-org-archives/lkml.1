Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYHQT64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYHQT64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbYHQT4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:56:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:44415 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbYHQT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:56:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PluGl67LJnjvWJ5i0M+VAOfY04OwznVByosjC5Ei+w0CBXEiWl5S2QWcQEdTuJaezs
         ryXD5sKihbi/mT00Eez3eguKbcWjHPJNEUWAwDDhX32yQmFwQ4ycJlBZAQv50LDkbB+6
         QsFuMJvMGsPdlLL30ucTHPfa9zMhmHm63MuEQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 21:54:32 +0200
Message-Id: <20080817195432.13393.20639.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
References: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: merge all TASKFILE_NO_DATA data phase handlers into taskfile_no_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'struct task_s' to ide_hwif_t and init it to the current command
  in do_rw_taskfile().

* Merge all TASKFILE_NO_DATA data phase handlers into taskfile_no_intr().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |  105 +++++-----------------
 include/linux/ide.h        |  211 ++++++++++++++++++++++-----------------------
 2 files changed, 131 insertions(+), 185 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -53,9 +53,6 @@ int taskfile_lib_get_identify (ide_drive
 }
 
 static ide_startstop_t task_no_data_intr(ide_drive_t *);
-static ide_startstop_t set_geometry_intr(ide_drive_t *);
-static ide_startstop_t recal_intr(ide_drive_t *);
-static ide_startstop_t set_multmode_intr(ide_drive_t *);
 static ide_startstop_t pre_task_out_intr(ide_drive_t *, struct request *);
 static ide_startstop_t task_in_intr(ide_drive_t *);
 
@@ -79,6 +76,8 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	if (task->tf_flags & IDE_TFLAG_FLAGGED)
 		task->tf_flags |= IDE_TFLAG_FLAGGED_SET_IN_FLAGS;
 
+	memcpy(&hwif->task, task, sizeof(*task));
+
 	if ((task->tf_flags & IDE_TFLAG_DMA_PIO_FALLBACK) == 0) {
 		ide_tf_dump(drive->name, tf);
 		tp_ops->set_irq(hwif, 1);
@@ -99,19 +98,6 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	case TASKFILE_NO_DATA:
 		if (handler == NULL)
 			handler = task_no_data_intr;
-		if (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) {
-			switch (tf->command) {
-			case ATA_CMD_INIT_DEV_PARAMS:
-				handler = set_geometry_intr;
-				break;
-			case ATA_CMD_RESTORE:
-				handler = recal_intr;
-				break;
-			case ATA_CMD_SET_MULTI:
-				handler = set_multmode_intr;
-				break;
-			}
-		}
 		ide_execute_command(drive, tf->command, handler,
 				    WAIT_WORSTCASE, NULL);
 		return ide_started;
@@ -127,33 +113,15 @@ ide_startstop_t do_rw_taskfile (ide_driv
 EXPORT_SYMBOL_GPL(do_rw_taskfile);
 
 /*
- * set_multmode_intr() is invoked on completion of a ATA_CMD_SET_MULTI cmd.
- */
-static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 stat;
-
-	local_irq_enable_in_hardirq();
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (OK_STAT(stat, ATA_DRDY, BAD_STAT))
-		drive->mult_count = drive->mult_req;
-	else {
-		drive->mult_req = drive->mult_count = 0;
-		drive->special.b.recalibrate = 1;
-		(void) ide_dump_status(drive, "set_multmode", stat);
-	}
-	return ide_stopped;
-}
-
-/*
- * set_geometry_intr() is invoked on completion of a ATA_CMD_INIT_DEV_PARAMS cmd.
+ * Handler for commands without a data phase
  */
-static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
+static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int retries = 5;
+	ide_task_t *task = &hwif->task;
+	struct ide_taskfile *tf = &task->tf;
+	int custom = (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) ? 1 : 0;
+	int retries = (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) ? 5 : 1;
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
@@ -165,50 +133,27 @@ static ide_startstop_t set_geometry_intr
 		udelay(10);
 	};
 
-	if (OK_STAT(stat, ATA_DRDY, BAD_STAT))
-		return ide_stopped;
-
-	if (stat & (ATA_ERR | ATA_DRQ))
-		return ide_error(drive, "set_geometry_intr", stat);
-
-	ide_set_handler(drive, &set_geometry_intr, WAIT_WORSTCASE, NULL);
-	return ide_started;
-}
-
-/*
- * recal_intr() is invoked on completion of a ATA_CMD_RESTORE (recalibrate) cmd.
- */
-static ide_startstop_t recal_intr(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 stat;
-
-	local_irq_enable_in_hardirq();
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT))
-		return ide_error(drive, "recal_intr", stat);
-	return ide_stopped;
-}
-
-/*
- * Handler for commands without a data phase
- */
-static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t *args = hwif->hwgroup->rq->special;
-	u8 stat;
-
-	local_irq_enable_in_hardirq();
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT))
+	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
+		if (custom && tf->command == ATA_CMD_SET_MULTI) {
+			drive->mult_req = drive->mult_count = 0;
+			drive->special.b.recalibrate = 1;
+			(void)ide_dump_status(drive, __func__, stat);
+			return ide_stopped;
+		} else if (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) {
+			if ((stat & (ATA_ERR | ATA_DRQ)) == 0) {
+				ide_set_handler(drive, &task_no_data_intr,
+						WAIT_WORSTCASE, NULL);
+				return ide_started;
+			}
+		}
 		return ide_error(drive, "task_no_data_intr", stat);
 		/* calls ide_end_drive_cmd */
+	}
 
-	if (args)
+	if (!custom)
 		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
+	else if (tf->command == ATA_CMD_SET_MULTI)
+		drive->mult_count = drive->mult_req;
 
 	return ide_stopped;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -282,6 +282,110 @@ typedef enum {
 	ide_started,	/* a drive operation was started, handler was set */
 } ide_startstop_t;
 
+enum {
+	IDE_TFLAG_LBA48			= (1 << 0),
+	IDE_TFLAG_FLAGGED		= (1 << 2),
+	IDE_TFLAG_OUT_DATA		= (1 << 3),
+	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
+	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 5),
+	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 6),
+	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 7),
+	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 8),
+	IDE_TFLAG_OUT_HOB		= IDE_TFLAG_OUT_HOB_FEATURE |
+					  IDE_TFLAG_OUT_HOB_NSECT |
+					  IDE_TFLAG_OUT_HOB_LBAL |
+					  IDE_TFLAG_OUT_HOB_LBAM |
+					  IDE_TFLAG_OUT_HOB_LBAH,
+	IDE_TFLAG_OUT_FEATURE		= (1 << 9),
+	IDE_TFLAG_OUT_NSECT		= (1 << 10),
+	IDE_TFLAG_OUT_LBAL		= (1 << 11),
+	IDE_TFLAG_OUT_LBAM		= (1 << 12),
+	IDE_TFLAG_OUT_LBAH		= (1 << 13),
+	IDE_TFLAG_OUT_TF		= IDE_TFLAG_OUT_FEATURE |
+					  IDE_TFLAG_OUT_NSECT |
+					  IDE_TFLAG_OUT_LBAL |
+					  IDE_TFLAG_OUT_LBAM |
+					  IDE_TFLAG_OUT_LBAH,
+	IDE_TFLAG_OUT_DEVICE		= (1 << 14),
+	IDE_TFLAG_WRITE			= (1 << 15),
+	IDE_TFLAG_FLAGGED_SET_IN_FLAGS	= (1 << 16),
+	IDE_TFLAG_IN_DATA		= (1 << 17),
+	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 18),
+	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 19),
+	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 20),
+	IDE_TFLAG_IN_HOB_NSECT		= (1 << 21),
+	IDE_TFLAG_IN_HOB_LBAL		= (1 << 22),
+	IDE_TFLAG_IN_HOB_LBAM		= (1 << 23),
+	IDE_TFLAG_IN_HOB_LBAH		= (1 << 24),
+	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
+					  IDE_TFLAG_IN_HOB_LBAM |
+					  IDE_TFLAG_IN_HOB_LBAH,
+	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
+					  IDE_TFLAG_IN_HOB_NSECT |
+					  IDE_TFLAG_IN_HOB_LBA,
+	IDE_TFLAG_IN_FEATURE		= (1 << 1),
+	IDE_TFLAG_IN_NSECT		= (1 << 25),
+	IDE_TFLAG_IN_LBAL		= (1 << 26),
+	IDE_TFLAG_IN_LBAM		= (1 << 27),
+	IDE_TFLAG_IN_LBAH		= (1 << 28),
+	IDE_TFLAG_IN_LBA		= IDE_TFLAG_IN_LBAL |
+					  IDE_TFLAG_IN_LBAM |
+					  IDE_TFLAG_IN_LBAH,
+	IDE_TFLAG_IN_TF			= IDE_TFLAG_IN_NSECT |
+					  IDE_TFLAG_IN_LBA,
+	IDE_TFLAG_IN_DEVICE		= (1 << 29),
+	IDE_TFLAG_HOB			= IDE_TFLAG_OUT_HOB |
+					  IDE_TFLAG_IN_HOB,
+	IDE_TFLAG_TF			= IDE_TFLAG_OUT_TF |
+					  IDE_TFLAG_IN_TF,
+	IDE_TFLAG_DEVICE		= IDE_TFLAG_OUT_DEVICE |
+					  IDE_TFLAG_IN_DEVICE,
+	/* force 16-bit I/O operations */
+	IDE_TFLAG_IO_16BIT		= (1 << 30),
+	/* ide_task_t was allocated using kmalloc() */
+	IDE_TFLAG_DYN			= (1 << 31),
+};
+
+struct ide_taskfile {
+	u8	hob_data;	/*  0: high data byte (for TASKFILE IOCTL) */
+
+	u8	hob_feature;	/*  1-5: additional data to support LBA48 */
+	u8	hob_nsect;
+	u8	hob_lbal;
+	u8	hob_lbam;
+	u8	hob_lbah;
+
+	u8	data;		/*  6: low data byte (for TASKFILE IOCTL) */
+
+	union {			/*  7: */
+		u8 error;	/*   read:  error */
+		u8 feature;	/*  write: feature */
+	};
+
+	u8	nsect;		/*  8: number of sectors */
+	u8	lbal;		/*  9: LBA low */
+	u8	lbam;		/* 10: LBA mid */
+	u8	lbah;		/* 11: LBA high */
+
+	u8	device;		/* 12: device select */
+
+	union {			/* 13: */
+		u8 status;	/*  read: status  */
+		u8 command;	/* write: command */
+	};
+};
+
+typedef struct ide_task_s {
+	union {
+		struct ide_taskfile	tf;
+		u8			tf_array[14];
+	};
+	u32			tf_flags;
+	int			data_phase;
+	struct request		*rq;		/* copy of request */
+	void			*special;	/* valid_t generally */
+} ide_task_t;
+
 /* ATAPI packet command flags */
 enum {
 	/* set when an error is considered normal - no retry (ide-tape) */
@@ -556,7 +660,6 @@ typedef struct ide_drive_s ide_drive_t;
 
 #define to_ide_device(dev)container_of(dev, ide_drive_t, gendev)
 
-struct ide_task_s;
 struct ide_port_info;
 
 struct ide_tp_ops {
@@ -683,6 +786,8 @@ typedef struct hwif_s {
 	/* data phase of the active command (currently only valid for PIO/DMA) */
 	int		data_phase;
 
+	struct ide_task_s task;		/* current command */
+
 	unsigned int nsect;
 	unsigned int nleft;
 	struct scatterlist *cursg;
@@ -1028,110 +1133,6 @@ extern void ide_do_drive_cmd(ide_drive_t
 
 extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
 
-enum {
-	IDE_TFLAG_LBA48			= (1 << 0),
-	IDE_TFLAG_FLAGGED		= (1 << 2),
-	IDE_TFLAG_OUT_DATA		= (1 << 3),
-	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
-	IDE_TFLAG_OUT_HOB_NSECT		= (1 << 5),
-	IDE_TFLAG_OUT_HOB_LBAL		= (1 << 6),
-	IDE_TFLAG_OUT_HOB_LBAM		= (1 << 7),
-	IDE_TFLAG_OUT_HOB_LBAH		= (1 << 8),
-	IDE_TFLAG_OUT_HOB		= IDE_TFLAG_OUT_HOB_FEATURE |
-					  IDE_TFLAG_OUT_HOB_NSECT |
-					  IDE_TFLAG_OUT_HOB_LBAL |
-					  IDE_TFLAG_OUT_HOB_LBAM |
-					  IDE_TFLAG_OUT_HOB_LBAH,
-	IDE_TFLAG_OUT_FEATURE		= (1 << 9),
-	IDE_TFLAG_OUT_NSECT		= (1 << 10),
-	IDE_TFLAG_OUT_LBAL		= (1 << 11),
-	IDE_TFLAG_OUT_LBAM		= (1 << 12),
-	IDE_TFLAG_OUT_LBAH		= (1 << 13),
-	IDE_TFLAG_OUT_TF		= IDE_TFLAG_OUT_FEATURE |
-					  IDE_TFLAG_OUT_NSECT |
-					  IDE_TFLAG_OUT_LBAL |
-					  IDE_TFLAG_OUT_LBAM |
-					  IDE_TFLAG_OUT_LBAH,
-	IDE_TFLAG_OUT_DEVICE		= (1 << 14),
-	IDE_TFLAG_WRITE			= (1 << 15),
-	IDE_TFLAG_FLAGGED_SET_IN_FLAGS	= (1 << 16),
-	IDE_TFLAG_IN_DATA		= (1 << 17),
-	IDE_TFLAG_CUSTOM_HANDLER	= (1 << 18),
-	IDE_TFLAG_DMA_PIO_FALLBACK	= (1 << 19),
-	IDE_TFLAG_IN_HOB_FEATURE	= (1 << 20),
-	IDE_TFLAG_IN_HOB_NSECT		= (1 << 21),
-	IDE_TFLAG_IN_HOB_LBAL		= (1 << 22),
-	IDE_TFLAG_IN_HOB_LBAM		= (1 << 23),
-	IDE_TFLAG_IN_HOB_LBAH		= (1 << 24),
-	IDE_TFLAG_IN_HOB_LBA		= IDE_TFLAG_IN_HOB_LBAL |
-					  IDE_TFLAG_IN_HOB_LBAM |
-					  IDE_TFLAG_IN_HOB_LBAH,
-	IDE_TFLAG_IN_HOB		= IDE_TFLAG_IN_HOB_FEATURE |
-					  IDE_TFLAG_IN_HOB_NSECT |
-					  IDE_TFLAG_IN_HOB_LBA,
-	IDE_TFLAG_IN_FEATURE		= (1 << 1),
-	IDE_TFLAG_IN_NSECT		= (1 << 25),
-	IDE_TFLAG_IN_LBAL		= (1 << 26),
-	IDE_TFLAG_IN_LBAM		= (1 << 27),
-	IDE_TFLAG_IN_LBAH		= (1 << 28),
-	IDE_TFLAG_IN_LBA		= IDE_TFLAG_IN_LBAL |
-					  IDE_TFLAG_IN_LBAM |
-					  IDE_TFLAG_IN_LBAH,
-	IDE_TFLAG_IN_TF			= IDE_TFLAG_IN_NSECT |
-					  IDE_TFLAG_IN_LBA,
-	IDE_TFLAG_IN_DEVICE		= (1 << 29),
-	IDE_TFLAG_HOB			= IDE_TFLAG_OUT_HOB |
-					  IDE_TFLAG_IN_HOB,
-	IDE_TFLAG_TF			= IDE_TFLAG_OUT_TF |
-					  IDE_TFLAG_IN_TF,
-	IDE_TFLAG_DEVICE		= IDE_TFLAG_OUT_DEVICE |
-					  IDE_TFLAG_IN_DEVICE,
-	/* force 16-bit I/O operations */
-	IDE_TFLAG_IO_16BIT		= (1 << 30),
-	/* ide_task_t was allocated using kmalloc() */
-	IDE_TFLAG_DYN			= (1 << 31),
-};
-
-struct ide_taskfile {
-	u8	hob_data;	/*  0: high data byte (for TASKFILE IOCTL) */
-
-	u8	hob_feature;	/*  1-5: additional data to support LBA48 */
-	u8	hob_nsect;
-	u8	hob_lbal;
-	u8	hob_lbam;
-	u8	hob_lbah;
-
-	u8	data;		/*  6: low data byte (for TASKFILE IOCTL) */
-
-	union {			/*  7: */
-		u8 error;	/*   read:  error */
-		u8 feature;	/*  write: feature */
-	};
-
-	u8	nsect;		/*  8: number of sectors */
-	u8	lbal;		/*  9: LBA low */
-	u8	lbam;		/* 10: LBA mid */
-	u8	lbah;		/* 11: LBA high */
-
-	u8	device;		/* 12: device select */
-
-	union {			/* 13: */
-		u8 status;	/*  read: status  */
-		u8 command;	/* write: command */
-	};
-};
-
-typedef struct ide_task_s {
-	union {
-		struct ide_taskfile	tf;
-		u8			tf_array[14];
-	};
-	u32			tf_flags;
-	int			data_phase;
-	struct request		*rq;		/* copy of request */
-	void			*special;	/* valid_t generally */
-} ide_task_t;
-
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
 void ide_exec_command(ide_hwif_t *, u8);
