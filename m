Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYGWSvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYGWSvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYGWSuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:50:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:18045 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYGWSuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=wJgCt5hak2WAVNZCcm5s1+oNrajg5HjDqfXu9NWAaHUXrJhBri4C+EoXbxaiR3usD/
         e1NQL/Em3OF7uwIF2bLwmXvOYZTAxxwwlooKxElubdIsxhQ7e4UgX5ZlmTH2kI41Jegm
         XjyZySOp56rH3jWNcQNDVcMbYXlXNe2iPF/34=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/7] ide: WIN_* -> ATA_CMD_*
Date: Wed, 23 Jul 2008 20:42:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807232042.45733.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use ATA_CMD_* defines instead of WIN_* ones.

While at it:

* EXABYTE_ENABLE_NEXT -> ATA_EXABYTE_ENABLE_NEST

* SETFEATURES_{EN,DIS}_WCACHE -> SETFEATURES_WC_{ON,OFF}

* SETFEATURES_{EN,DIS}_AAM -> SETFEATURES_AAM_{ON,OFF}

* SMART_* -> ATA_SMART_*

* Remove stale comment from ide-proc.c.

Partially based on earlier work by Chris Wedgwood.

Cc: Chris Wedgwood <cw@f00f.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |    2 -
 drivers/ide/ide-cd.c       |    2 -
 drivers/ide/ide-disk.c     |   68 ++++++++++++++++++++++-----------------------
 drivers/ide/ide-io.c       |   27 +++++++++--------
 drivers/ide/ide-iops.c     |   10 +++---
 drivers/ide/ide-probe.c    |   34 ++++++++++------------
 drivers/ide/ide-proc.c     |   10 ------
 drivers/ide/ide-taskfile.c |   27 ++++++++++-------
 drivers/scsi/ide-scsi.c    |    2 -
 9 files changed, 89 insertions(+), 93 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -303,7 +303,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		ide_execute_command(drive, WIN_PACKETCMD, handler,
+		ide_execute_command(drive, ATA_CMD_PACKET, handler,
 				    timeout, NULL);
 		return ide_started;
 	} else {
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -539,7 +539,7 @@ static ide_startstop_t cdrom_start_packe
 			drive->waiting_for_dma = 0;
 
 		/* packet command */
-		ide_execute_command(drive, WIN_PACKETCMD, handler,
+		ide_execute_command(drive, ATA_CMD_PACKET, handler,
 				    ATAPI_WAIT_PC, cdrom_timer_expiry);
 		return ide_started;
 	} else {
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -134,18 +134,18 @@ static int lba_capacity_is_ok(u16 *id)
 }
 
 static const u8 ide_rw_cmds[] = {
-	WIN_MULTREAD,
-	WIN_MULTWRITE,
-	WIN_MULTREAD_EXT,
-	WIN_MULTWRITE_EXT,
-	WIN_READ,
-	WIN_WRITE,
-	WIN_READ_EXT,
-	WIN_WRITE_EXT,
-	WIN_READDMA,
-	WIN_WRITEDMA,
-	WIN_READDMA_EXT,
-	WIN_WRITEDMA_EXT,
+	ATA_CMD_READ_MULTI,
+	ATA_CMD_WRITE_MULTI,
+	ATA_CMD_READ_MULTI_EXT,
+	ATA_CMD_WRITE_MULTI_EXT,
+	ATA_CMD_PIO_READ,
+	ATA_CMD_PIO_WRITE,
+	ATA_CMD_PIO_READ_EXT,
+	ATA_CMD_PIO_WRITE_EXT,
+	ATA_CMD_READ,
+	ATA_CMD_WRITE,
+	ATA_CMD_READ_EXT,
+	ATA_CMD_WRITE_EXT,
 };
 
 static const u8 ide_data_phases[] = {
@@ -316,9 +316,9 @@ static u64 idedisk_read_native_max_addre
 	/* Create IDE/ATA command request structure */
 	memset(&args, 0, sizeof(ide_task_t));
 	if (lba48)
-		tf->command = WIN_READ_NATIVE_MAX_EXT;
+		tf->command = ATA_CMD_READ_NATIVE_MAX_EXT;
 	else
-		tf->command = WIN_READ_NATIVE_MAX;
+		tf->command = ATA_CMD_READ_NATIVE_MAX;
 	tf->device  = ATA_LBA;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	if (lba48)
@@ -353,10 +353,10 @@ static u64 idedisk_set_max_address(ide_d
 		tf->hob_lbal = (addr_req >>= 8) & 0xff;
 		tf->hob_lbam = (addr_req >>= 8) & 0xff;
 		tf->hob_lbah = (addr_req >>= 8) & 0xff;
-		tf->command  = WIN_SET_MAX_EXT;
+		tf->command  = ATA_CMD_SET_MAX_EXT;
 	} else {
 		tf->device   = (addr_req >>= 8) & 0x0f;
-		tf->command  = WIN_SET_MAX;
+		tf->command  = ATA_CMD_SET_MAX;
 	}
 	tf->device |= ATA_LBA;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
@@ -489,10 +489,10 @@ static int smart_enable(ide_drive_t *dri
 	struct ide_taskfile *tf = &args.tf;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	tf->feature = SMART_ENABLE;
-	tf->lbam    = SMART_LCYL_PASS;
-	tf->lbah    = SMART_HCYL_PASS;
-	tf->command = WIN_SMART;
+	tf->feature = ATA_SMART_ENABLE;
+	tf->lbam    = ATA_SMART_LBAM_PASS;
+	tf->lbah    = ATA_SMART_LBAH_PASS;
+	tf->command = ATA_CMD_SMART;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	return ide_no_data_taskfile(drive, &args);
 }
@@ -505,9 +505,9 @@ static int get_smart_data(ide_drive_t *d
 	memset(&args, 0, sizeof(ide_task_t));
 	tf->feature = sub_cmd;
 	tf->nsect   = 0x01;
-	tf->lbam    = SMART_LCYL_PASS;
-	tf->lbah    = SMART_HCYL_PASS;
-	tf->command = WIN_SMART;
+	tf->lbam    = ATA_SMART_LBAM_PASS;
+	tf->lbah    = ATA_SMART_LBAH_PASS;
+	tf->command = ATA_CMD_SMART;
 	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	args.data_phase	= TASKFILE_IN;
 	(void) smart_enable(drive);
@@ -565,14 +565,14 @@ static int proc_idedisk_read_sv
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
 	return proc_idedisk_read_smart(page, start, off, count, eof, data,
-				       SMART_READ_VALUES);
+				       ATA_SMART_READ_VALUES);
 }
 
 static int proc_idedisk_read_st
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
 	return proc_idedisk_read_smart(page, start, off, count, eof, data,
-				       SMART_READ_THRESHOLDS);
+				       ATA_SMART_READ_THRESHOLDS);
 }
 
 static ide_proc_entry_t idedisk_proc[] = {
@@ -596,9 +596,9 @@ static void idedisk_prepare_flush(struct
 	memset(task, 0, sizeof(*task));
 	if (ide_id_has_flush_cache_ext(drive->id) &&
 	    (drive->capacity64 >= (1UL << 28)))
-		task->tf.command = WIN_FLUSH_CACHE_EXT;
+		task->tf.command = ATA_CMD_FLUSH_EXT;
 	else
-		task->tf.command = WIN_FLUSH_CACHE;
+		task->tf.command = ATA_CMD_FLUSH;
 	task->tf_flags	 = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
 			   IDE_TFLAG_DYN;
 	task->data_phase = TASKFILE_NO_DATA;
@@ -693,8 +693,8 @@ static int write_cache(ide_drive_t *driv
 	if (ide_id_has_flush_cache(drive->id)) {
 		memset(&args, 0, sizeof(ide_task_t));
 		args.tf.feature = arg ?
-			SETFEATURES_EN_WCACHE : SETFEATURES_DIS_WCACHE;
-		args.tf.command = WIN_SETFEATURES;
+			SETFEATURES_WC_ON : SETFEATURES_WC_OFF;
+		args.tf.command = ATA_CMD_SET_FEATURES;
 		args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 		err = ide_no_data_taskfile(drive, &args);
 		if (err == 0)
@@ -712,9 +712,9 @@ static int do_idedisk_flushcache(ide_dri
 
 	memset(&args, 0, sizeof(ide_task_t));
 	if (ide_id_has_flush_cache_ext(drive->id))
-		args.tf.command = WIN_FLUSH_CACHE_EXT;
+		args.tf.command = ATA_CMD_FLUSH_EXT;
 	else
-		args.tf.command = WIN_FLUSH_CACHE;
+		args.tf.command = ATA_CMD_FLUSH;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	return ide_no_data_taskfile(drive, &args);
 }
@@ -727,9 +727,9 @@ static int set_acoustic(ide_drive_t *dri
 		return -EINVAL;
 
 	memset(&args, 0, sizeof(ide_task_t));
-	args.tf.feature = arg ? SETFEATURES_EN_AAM : SETFEATURES_DIS_AAM;
+	args.tf.feature = arg ? SETFEATURES_AAM_ON : SETFEATURES_AAM_OFF;
 	args.tf.nsect   = arg;
-	args.tf.command = WIN_SETFEATURES;
+	args.tf.command = ATA_CMD_SET_FEATURES;
 	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	ide_no_data_taskfile(drive, &args);
 	drive->acoustic = arg;
@@ -992,7 +992,7 @@ static int idedisk_set_doorlock(ide_driv
 	ide_task_t task;
 
 	memset(&task, 0, sizeof(task));
-	task.tf.command = on ? WIN_DOORLOCK : WIN_DOORUNLOCK;
+	task.tf.command = on ? ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
 	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
 	return ide_no_data_taskfile(drive, &task);
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -188,13 +188,13 @@ static ide_startstop_t ide_start_power_s
 			return ide_stopped;
 		}
 		if (ide_id_has_flush_cache_ext(drive->id))
-			args->tf.command = WIN_FLUSH_CACHE_EXT;
+			args->tf.command = ATA_CMD_FLUSH_EXT;
 		else
-			args->tf.command = WIN_FLUSH_CACHE;
+			args->tf.command = ATA_CMD_FLUSH;
 		goto out_do_tf;
 
 	case idedisk_pm_standby:	/* Suspend step 2 (standby) */
-		args->tf.command = WIN_STANDBYNOW1;
+		args->tf.command = ATA_CMD_STANDBYNOW1;
 		goto out_do_tf;
 
 	case idedisk_pm_restore_pio:	/* Resume step 1 (restore PIO) */
@@ -209,7 +209,7 @@ static ide_startstop_t ide_start_power_s
 		return ide_stopped;
 
 	case idedisk_pm_idle:		/* Resume step 2 (idle) */
-		args->tf.command = WIN_IDLEIMMEDIATE;
+		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
 		goto out_do_tf;
 
 	case ide_pm_restore_dma:	/* Resume step 3 (restore DMA) */
@@ -380,8 +380,8 @@ static ide_startstop_t ide_ata_error(ide
 		/* err has different meaning on cdrom and tape */
 		if (err == ABRT_ERR) {
 			if (drive->select.b.lba &&
-			    /* some newer drives don't support WIN_SPECIFY */
-			    hwif->tp_ops->read_status(hwif) == WIN_SPECIFY)
+			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
+			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
 				return ide_stopped;
 		} else if ((err & BAD_CRC) == BAD_CRC) {
 			/* UDMA crc error, just retry the operation */
@@ -436,7 +436,7 @@ static ide_startstop_t ide_atapi_error(i
 
 	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->tp_ops->exec_command(hwif, WIN_IDLEIMMEDIATE);
+		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
 
 	if (rq->errors >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
@@ -509,19 +509,19 @@ static void ide_tf_set_specify_cmd(ide_d
 	tf->lbam    = drive->cyl;
 	tf->lbah    = drive->cyl >> 8;
 	tf->device  = ((drive->head - 1) | drive->select.all) & ~ATA_LBA;
-	tf->command = WIN_SPECIFY;
+	tf->command = ATA_CMD_INIT_DEV_PARAMS;
 }
 
 static void ide_tf_set_restore_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
 	tf->nsect   = drive->sect;
-	tf->command = WIN_RESTORE;
+	tf->command = ATA_CMD_RESTORE;
 }
 
 static void ide_tf_set_setmult_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
 	tf->nsect   = drive->mult_req;
-	tf->command = WIN_SETMULT;
+	tf->command = ATA_CMD_SET_MULTI;
 }
 
 static ide_startstop_t ide_disk_special(ide_drive_t *drive)
@@ -584,9 +584,10 @@ static int set_pio_mode_abuse(ide_hwif_t
  *	do_special		-	issue some special commands
  *	@drive: drive the command is for
  *
- *	do_special() is used to issue WIN_SPECIFY, WIN_RESTORE, and WIN_SETMULT
- *	commands to a drive.  It used to do much more, but has been scaled
- *	back.
+ *	do_special() is used to issue ATA_CMD_INIT_DEV_PARAMS,
+ *	ATA_CMD_RESTORE and ATA_CMD_SET_MULTI commands to a drive.
+ *
+ *	It used to do much more, but has been scaled back.
  */
 
 static ide_startstop_t do_special (ide_drive_t *drive)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -418,7 +418,7 @@ void ide_fix_driveid(u16 *id)
  * ide_fixstring() cleans up and (optionally) byte-swaps a text string,
  * removing leading/trailing blanks and compressing internal blanks.
  * It is primarily used to tidy up the model name/number fields as
- * returned by the WIN_[P]IDENTIFY commands.
+ * returned by the ATA_CMD_ID_ATA[PI] commands.
  */
 
 void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
@@ -675,7 +675,7 @@ int ide_driveid_update(ide_drive_t *driv
 	SELECT_MASK(drive, 1);
 	tp_ops->set_irq(hwif, 0);
 	msleep(50);
-	tp_ops->exec_command(hwif, WIN_IDENTIFY);
+	tp_ops->exec_command(hwif, ATA_CMD_ID_ATA);
 	timeout = jiffies + WAIT_WORSTCASE;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -770,7 +770,7 @@ int ide_config_drive_speed(ide_drive_t *
 
 	tp_ops->tf_load(drive, &task);
 
-	tp_ops->exec_command(hwif, WIN_SETFEATURES);
+	tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
 
 	if (drive->quirk_list == 2)
 		tp_ops->set_irq(hwif, 1);
@@ -890,7 +890,7 @@ void ide_execute_pkt_cmd(ide_drive_t *dr
 	unsigned long flags;
 
 	spin_lock_irqsave(&ide_lock, flags);
-	hwif->tp_ops->exec_command(hwif, WIN_PACKETCMD);
+	hwif->tp_ops->exec_command(hwif, ATA_CMD_PACKET);
 	ndelay(400);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -1100,7 +1100,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		pre_reset(drive);
 		SELECT_DRIVE(drive);
 		udelay (20);
-		tp_ops->exec_command(hwif, WIN_SRST);
+		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 		ndelay(400);
 		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwgroup->polling = 1;
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -132,10 +132,10 @@ static inline void do_identify (ide_driv
 	ide_fix_driveid(id);
 
 	/*
-	 *  WIN_IDENTIFY returns little-endian info,
-	 *  WIN_PIDENTIFY *usually* returns little-endian info.
+	 *  ATA_CMD_ID_ATA returns little-endian info,
+	 *  ATA_CMD_ID_ATAPI *usually* returns little-endian info.
 	 */
-	if (cmd == WIN_PIDENTIFY) {
+	if (cmd == ATA_CMD_ID_ATAPI) {
 		if ((m[0] == 'N' && m[1] == 'E') ||  /* NEC */
 		    (m[0] == 'F' && m[1] == 'X') ||  /* Mitsumi */
 		    (m[0] == 'P' && m[1] == 'i'))    /* Pioneer */
@@ -161,7 +161,7 @@ static inline void do_identify (ide_driv
 	/*
 	 * Check for an ATAPI device
 	 */
-	if (cmd == WIN_PIDENTIFY) {
+	if (cmd == ATA_CMD_ID_ATAPI) {
 		u8 type = (id[ATA_ID_CONFIG] >> 8) & 0x1f;
 
 		printk(KERN_CONT "ATAPI ");
@@ -277,7 +277,7 @@ static int actual_try_to_identify (ide_d
 	/* set features register for atapi
 	 * identify command to be sure of reply
 	 */
-	if (cmd == WIN_PIDENTIFY) {
+	if (cmd == ATA_CMD_ID_ATAPI) {
 		ide_task_t task;
 
 		memset(&task, 0, sizeof(task));
@@ -290,7 +290,7 @@ static int actual_try_to_identify (ide_d
 	/* ask drive for ID */
 	tp_ops->exec_command(hwif, cmd);
 
-	timeout = ((cmd == WIN_IDENTIFY) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
+	timeout = ((cmd == ATA_CMD_ID_ATA) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 	timeout += jiffies;
 	do {
 		if (time_after(jiffies, timeout)) {
@@ -440,13 +440,13 @@ static int do_probe (ide_drive_t *drive,
 
 	if (drive->present) {
 		/* avoid waiting for inappropriate probes */
-		if ((drive->media != ide_disk) && (cmd == WIN_IDENTIFY))
+		if (drive->media != ide_disk && cmd == ATA_CMD_ID_ATA)
 			return 4;
 	}
 #ifdef DEBUG
 	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
 		drive->name, drive->present, drive->media,
-		(cmd == WIN_IDENTIFY) ? "ATA" : "ATAPI");
+		(cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
 #endif
 
 	/* needed for some systems
@@ -470,7 +470,7 @@ static int do_probe (ide_drive_t *drive,
 	stat = tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, READY_STAT, BUSY_STAT) ||
-	    drive->present || cmd == WIN_PIDENTIFY) {
+	    drive->present || cmd == ATA_CMD_ID_ATAPI) {
 		/* send cmd and wait */
 		if ((rc = try_to_identify(drive, cmd))) {
 			/* failed: try again */
@@ -482,13 +482,13 @@ static int do_probe (ide_drive_t *drive,
 		if (stat == (BUSY_STAT | READY_STAT))
 			return 4;
 
-		if (rc == 1 && cmd == WIN_PIDENTIFY) {
+		if (rc == 1 && cmd == ATA_CMD_ID_ATAPI) {
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
 			SELECT_DRIVE(drive);
 			msleep(50);
-			tp_ops->exec_command(hwif, WIN_SRST);
+			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 			(void)ide_busy_sleep(hwif);
 			rc = try_to_identify(drive, cmd);
 		}
@@ -527,7 +527,7 @@ static void enable_nest (ide_drive_t *dr
 
 	SELECT_DRIVE(drive);
 	msleep(50);
-	tp_ops->exec_command(hwif, EXABYTE_ENABLE_NEST);
+	tp_ops->exec_command(hwif, ATA_EXABYTE_ENABLE_NEST);
 
 	if (ide_busy_sleep(hwif)) {
 		printk(KERN_CONT "failed (timeout)\n");
@@ -544,10 +544,9 @@ static void enable_nest (ide_drive_t *dr
 		printk(KERN_CONT "success\n");
 
 	/* if !(success||timed-out) */
-	if (do_probe(drive, WIN_IDENTIFY) >= 2) {
+	if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
 		/* look for ATAPI device */
-		(void) do_probe(drive, WIN_PIDENTIFY);
-	}
+		(void)do_probe(drive, ATA_CMD_ID_ATAPI);
 }
 
 /**
@@ -590,10 +589,9 @@ static inline u8 probe_for_drive (ide_dr
 	if (!drive->noprobe)
 	{
 		/* if !(success||timed-out) */
-		if (do_probe(drive, WIN_IDENTIFY) >= 2) {
+		if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
 			/* look for ATAPI device */
-			(void) do_probe(drive, WIN_PIDENTIFY);
-		}
+			(void)do_probe(drive, ATA_CMD_ID_ATAPI);
 		if (!drive->present)
 			/* drive not found */
 			return 0;
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -12,14 +12,6 @@
  * "settings" files.  e.g.    "cat /proc/ide0/hda/settings"
  * To write a new value "val" into a specific setting "name", use:
  *   echo "name:val" >/proc/ide/ide0/hda/settings
- *
- * Also useful, "cat /proc/ide0/hda/[identify, smart_values,
- * smart_thresholds, capabilities]" will issue an IDENTIFY /
- * PACKET_IDENTIFY / SMART_READ_VALUES / SMART_READ_THRESHOLDS /
- * SENSE CAPABILITIES command to /dev/hda, and then dump out the
- * returned data as 256 16-bit words.  The "hdparm" utility will
- * be updated someday soon to use this mechanism.
- *
  */
 
 #include <linux/module.h>
@@ -349,7 +341,7 @@ static int set_xfer_rate (ide_drive_t *d
 		return -EINVAL;
 
 	memset(&task, 0, sizeof(task));
-	task.tf.command = WIN_SETFEATURES;
+	task.tf.command = ATA_CMD_SET_FEATURES;
 	task.tf.feature = SETFEATURES_XFER;
 	task.tf.nsect   = (u8)arg;
 	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT |
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -44,9 +44,9 @@ int taskfile_lib_get_identify (ide_drive
 	memset(&args, 0, sizeof(ide_task_t));
 	args.tf.nsect = 0x01;
 	if (drive->media == ide_disk)
-		args.tf.command = WIN_IDENTIFY;
+		args.tf.command = ATA_CMD_ID_ATA;
 	else
-		args.tf.command = WIN_PIDENTIFY;
+		args.tf.command = ATA_CMD_ID_ATAPI;
 	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	args.data_phase	= TASKFILE_IN;
 	return ide_raw_taskfile(drive, &args, buf, 1);
@@ -99,12 +99,17 @@ ide_startstop_t do_rw_taskfile (ide_driv
 	case TASKFILE_NO_DATA:
 		if (handler == NULL)
 			handler = task_no_data_intr;
-		/* WIN_{SPECIFY,RESTORE,SETMULT} use custom handlers */
 		if (task->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) {
 			switch (tf->command) {
-			case WIN_SPECIFY: handler = set_geometry_intr;	break;
-			case WIN_RESTORE: handler = recal_intr;		break;
-			case WIN_SETMULT: handler = set_multmode_intr;	break;
+			case ATA_CMD_INIT_DEV_PARAMS:
+				handler = set_geometry_intr;
+				break;
+			case ATA_CMD_RESTORE:
+				handler = recal_intr;
+				break;
+			case ATA_CMD_SET_MULTI:
+				handler = set_multmode_intr;
+				break;
 			}
 		}
 		ide_execute_command(drive, tf->command, handler,
@@ -121,7 +126,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 EXPORT_SYMBOL_GPL(do_rw_taskfile);
 
 /*
- * set_multmode_intr() is invoked on completion of a WIN_SETMULT cmd.
+ * set_multmode_intr() is invoked on completion of a ATA_CMD_SET_MULTI cmd.
  */
 static ide_startstop_t set_multmode_intr(ide_drive_t *drive)
 {
@@ -142,7 +147,7 @@ static ide_startstop_t set_multmode_intr
 }
 
 /*
- * set_geometry_intr() is invoked on completion of a WIN_SPECIFY cmd.
+ * set_geometry_intr() is invoked on completion of a ATA_CMD_INIT_DEV_PARAMS cmd.
  */
 static ide_startstop_t set_geometry_intr(ide_drive_t *drive)
 {
@@ -170,7 +175,7 @@ static ide_startstop_t set_geometry_intr
 }
 
 /*
- * recal_intr() is invoked on completion of a WIN_RESTORE (recalibrate) cmd.
+ * recal_intr() is invoked on completion of a ATA_CMD_RESTORE (recalibrate) cmd.
  */
 static ide_startstop_t recal_intr(ide_drive_t *drive)
 {
@@ -747,7 +752,7 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 
 	memset(&tfargs, 0, sizeof(ide_task_t));
 	tf->feature = args[2];
-	if (args[0] == WIN_SMART) {
+	if (args[0] == ATA_CMD_SMART) {
 		tf->nsect = args[3];
 		tf->lbal  = args[1];
 		tf->lbam  = 0x4f;
@@ -769,7 +774,7 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 			return -ENOMEM;
 	}
 
-	if (tf->command == WIN_SETFEATURES &&
+	if (tf->command == ATA_CMD_SET_FEATURES &&
 	    tf->feature == SETFEATURES_XFER &&
 	    tf->nsect >= XFER_SW_DMA_0 &&
 	    (id[ATA_ID_UDMA_MODES] ||
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -245,7 +245,7 @@ idescsi_atapi_error(ide_drive_t *drive, 
 
 	if (hwif->tp_ops->read_status(hwif) & (BUSY_STAT | DRQ_STAT))
 		/* force an abort */
-		hwif->tp_ops->exec_command(hwif, WIN_IDLEIMMEDIATE);
+		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
 
 	rq->errors++;
 
