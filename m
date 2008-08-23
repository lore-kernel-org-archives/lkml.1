Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYHWNJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYHWNJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYHWNIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:08:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:41014 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYHWNIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=OBs6w50WmklIh2EtjSNI9ZMtT5ENHNHOor92wVBsxTDBfQtEWCUYVGgA94ZDqeFkTQ
         mnpHuGCsRwrF5Az4/F+Snn1CpI4FruqSYPfyMynRkRW21MDEYq95ZZ49mZoVJOY5PQsp
         99sHnyhnb5mpLA7jWUXt+kQ0woI1LkMbclt5U=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/2] ide-cd: convert driver to new ide debugging macro
Date: Sat, 23 Aug 2008 15:08:42 +0200
Message-Id: <1219496923-20868-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also,

- leave in the possibility for optimizing away all debugging macros
- add a PFX macro and prepend all printk calls with it for consistency
- add debug macro calls in important driver paths
- remove #if 0-ed code
- mv restore_request -> ide_cd_restore_request
- add a driver registration printk

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |  181 +++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 144 insertions(+), 37 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6ef9ba8..cca1011 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -23,6 +23,9 @@
  *	Documentation/ide/ChangeLog.ide-cd.1994-2004
  */
 
+#define DRV_NAME "ide-cd"
+#define PFX DRV_NAME ": "
+
 #define IDECD_VERSION "5.00"
 
 #include <linux/module.h>
@@ -50,6 +53,14 @@
 
 #include "ide-cd.h"
 
+#define IDECD_DEBUG_LOG		1
+
+#if IDECD_DEBUG_LOG
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#else
+#define ide_debug_log(lvl, fmt, args...) do {} while (0)
+#endif
+
 static DEFINE_MUTEX(idecd_ref_mutex);
 
 static void ide_cd_release(struct kref *);
@@ -97,6 +108,9 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 {
 	int log = 0;
 
+	ide_debug_log(IDE_DBG_SENSE, "Call %s, sense_key: 0x%x\n", __func__,
+		      sense->sense_key);
+
 	if (!sense || !rq || (rq->cmd_flags & REQ_QUIET))
 		return 0;
 
@@ -145,6 +159,11 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	unsigned long bio_sectors;
 	struct cdrom_info *info = drive->driver_data;
 
+	ide_debug_log(IDE_DBG_SENSE, "Call %s, failed cmd: 0x%x, "
+		      "error_code: 0x%x, sense_key: 0x%x\n",
+		      __func__, failed_command->cmd[0], sense->error_code,
+		      sense->sense_key);
+
 	if (!cdrom_log_sense(drive, failed_command, sense))
 		return;
 
@@ -214,6 +233,9 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	/* NOTE! Save the failed command in "rq->buffer" */
 	rq->buffer = (void *) failed_command;
 
+	ide_debug_log(IDE_DBG_SENSE, "Call %s, failed_cmd: 0x%x\n", __func__,
+		      failed_command->cmd[0]);
+
 	ide_do_drive_cmd(drive, rq);
 }
 
@@ -222,6 +244,10 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	struct request *rq = HWGROUP(drive)->rq;
 	int nsectors = rq->hard_cur_sectors;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s, cmd: 0x%x, uptodate: 0x%x, "
+		      "nsectors: %d\n", __func__, rq->cmd[0], uptodate,
+		      nsectors);
+
 	if (blk_sense_request(rq) && uptodate) {
 		/*
 		 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
@@ -264,6 +290,9 @@ static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 	if (!nsectors)
 		nsectors = 1;
 
+	ide_debug_log(IDE_DBG_FUNC, "Exit %s, uptodate: 0x%x, nsectors: %d\n",
+		      __func__, uptodate, nsectors);
+
 	ide_end_request(drive, uptodate, nsectors);
 }
 
@@ -299,11 +328,15 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	sense_key = err >> 4;
 
 	if (rq == NULL) {
-		printk(KERN_ERR "%s: missing rq in %s\n",
+		printk(KERN_ERR PFX "%s: missing rq in %s\n",
 				drive->name, __func__);
 		return 1;
 	}
 
+	ide_debug_log(IDE_DBG_RQ, "%s: stat: 0x%x, good_stat: 0x%x, "
+		      "rq->cmd_type: 0x%x, err: 0x%x\n", __func__, stat,
+		      good_stat, rq->cmd_type, err);
+
 	if (blk_sense_request(rq)) {
 		/*
 		 * We got an error trying to get sense info from the drive
@@ -369,7 +402,8 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 				cdrom_saw_media_change(drive);
 
 				/* fail the request */
-				printk(KERN_ERR "%s: tray open\n", drive->name);
+				printk(KERN_ERR PFX "%s: tray open\n",
+						drive->name);
 				do_end_request = 1;
 			} else {
 				struct cdrom_info *info = drive->driver_data;
@@ -455,7 +489,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 		if (stat & ATA_ERR)
 			cdrom_queue_request_sense(drive, NULL, NULL);
 	} else {
-		blk_dump_rq_flags(rq, "ide-cd: bad rq");
+		blk_dump_rq_flags(rq, PFX "bad rq");
 		cdrom_end_request(drive, 0);
 	}
 
@@ -483,6 +517,9 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 	struct request *rq = HWGROUP(drive)->rq;
 	unsigned long wait = 0;
 
+	ide_debug_log(IDE_DBG_RQ, "Call %s: rq->cmd[0]: 0x%x\n", __func__,
+		      rq->cmd[0]);
+
 	/*
 	 * Some commands are *slow* and normally take a long time to complete.
 	 * Usually we can use the ATAPI "disconnect" to bypass this, but not all
@@ -499,7 +536,7 @@ static int cdrom_timer_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
+			printk(KERN_INFO PFX "cmd 0x%x timed out\n",
 					 rq->cmd[0]);
 		wait = 0;
 		break;
@@ -522,6 +559,8 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s, xferlen: %d\n", __func__, xferlen);
+
 	/* FIXME: for Virtual DMA we must check harder */
 	if (info->dma)
 		info->dma = !hwif->dma_ops->dma_setup(drive);
@@ -562,6 +601,8 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	struct cdrom_info *info = drive->driver_data;
 	ide_startstop_t startstop;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s\n", __func__);
+
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		/*
 		 * Here we should have been called after receiving an interrupt
@@ -610,6 +651,9 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif = drive->hwif;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s, ireason: 0x%x, rw: 0x%x\n",
+		      __func__, ireason, rw);
+
 	/*
 	 * ireason == 0: the drive wants to receive data from us
 	 * ireason == 2: the drive is expecting to transfer data to us
@@ -619,7 +663,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 	else if (ireason == (rw << 1)) {
 
 		/* whoops... */
-		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
+		printk(KERN_ERR PFX "%s: %s: wrong transfer direction!\n",
 				drive->name, __func__);
 
 		ide_pad_transfer(drive, rw, len);
@@ -632,7 +676,7 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
 		return 0;
 	} else {
 		/* drive wants a command packet, or invalid ireason... */
-		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
+		printk(KERN_ERR PFX "%s: %s: bad interrupt reason 0x%02x\n",
 				drive->name, __func__, ireason);
 	}
 
@@ -649,17 +693,19 @@ static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
  */
 static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 {
+	ide_debug_log(IDE_DBG_FUNC, "Call %s, len: %d\n", __func__, len);
+
 	if ((len % SECTOR_SIZE) == 0)
 		return 0;
 
-	printk(KERN_ERR "%s: %s: Bad transfer size %d\n",
-			drive->name, __func__, len);
+	printk(KERN_ERR PFX "%s: %s: Bad transfer size %d\n", drive->name,
+			__func__, len);
 
 	if (drive->atapi_flags & IDE_AFLAG_LIMIT_NFRAMES)
-		printk(KERN_ERR "  This drive is not supported by "
-				"this version of the driver\n");
+		printk(KERN_ERR PFX "This drive is not supported by this "
+				"version of the driver\n");
 	else {
-		printk(KERN_ERR "  Trying to limit transfer sizes\n");
+		printk(KERN_ERR PFX "Trying to limit transfer sizes\n");
 		drive->atapi_flags |= IDE_AFLAG_LIMIT_NFRAMES;
 	}
 
@@ -671,6 +717,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 						 struct request *rq)
 {
+	ide_debug_log(IDE_DBG_RQ, "Call %s: rq->cmd_flags: 0x%x\n", __func__,
+		      rq->cmd_flags);
+
 	if (rq_data_dir(rq) == READ) {
 		unsigned short sectors_per_frame =
 			queue_hardsect_size(drive->queue) >> SECTOR_BITS;
@@ -690,7 +739,7 @@ static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 			/* sanity check... */
 			if (rq->current_nr_sectors !=
 			    bio_cur_sectors(rq->bio)) {
-				printk(KERN_ERR "%s: %s: buffer botch (%u)\n",
+				printk(KERN_ERR PFX "%s: %s: buffer botch (%u)\n",
 						drive->name, __func__,
 						rq->current_nr_sectors);
 				cdrom_end_request(drive, 0);
@@ -699,11 +748,7 @@ static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
 			rq->current_nr_sectors += nskip;
 		}
 	}
-#if 0
-	else
-		/* the immediate bit */
-		rq->cmd[1] = 1 << 3;
-#endif
+
 	/* set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
@@ -734,6 +779,8 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 	int stat;
 	static int retry = 10;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (cdrom_decode_status(drive, 0, &stat))
 		return ide_stopped;
 
@@ -750,6 +797,8 @@ static void ide_cd_prepare_seek_request(ide_drive_t *drive, struct request *rq)
 {
 	sector_t frame = rq->sector;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	sector_div(frame, queue_hardsect_size(drive->queue) >> SECTOR_BITS);
 
 	memset(rq->cmd, 0, BLK_MAX_CDB);
@@ -770,8 +819,11 @@ static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
  * Fix up a possibly partially-processed request so that we can start it over
  * entirely, or even put it back on the request queue.
  */
-static void restore_request(struct request *rq)
+static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
 {
+
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (rq->buffer != bio_data(rq->bio)) {
 		sector_t n =
 			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;
@@ -790,8 +842,11 @@ static void restore_request(struct request *rq)
 /*
  * All other packet commands.
  */
-static void ide_cd_request_sense_fixup(struct request *rq)
+static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
 {
+
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	/*
 	 * Some of the trailing request sense fields are optional,
 	 * and some drives don't send them.  Sigh.
@@ -817,6 +872,10 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	if (!sense)
 		sense = &local_sense;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x, "
+		      "timeout: %d, cmd_flags: 0x%x\n", __func__, cmd[0], write,
+		      timeout, cmd_flags);
+
 	/* start of retry loop */
 	do {
 		struct request *rq;
@@ -900,13 +959,16 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	u16 len;
 	u8 ireason;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd[0]: 0x%x, write: 0x%x\n",
+		      __func__, rq->cmd[0], write);
+
 	/* check for errors */
 	dma = info->dma;
 	if (dma) {
 		info->dma = 0;
 		dma_error = hwif->dma_ops->dma_end(drive);
 		if (dma_error) {
-			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
+			printk(KERN_ERR PFX "%s: DMA %s error\n", drive->name,
 					write ? "write" : "read");
 			ide_dma_off(drive);
 		}
@@ -932,6 +994,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	if (thislen > len)
 		thislen = len;
 
+	ide_debug_log(IDE_DBG_PC, "%s: DRQ: stat: 0x%x, thislen: %d\n",
+		      __func__, stat, thislen);
+
 	/* If DRQ is clear, the command has completed. */
 	if ((stat & ATA_DRQ) == 0) {
 		if (blk_fs_request(rq)) {
@@ -941,7 +1006,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			 */
 			uptodate = 1;
 			if (rq->current_nr_sectors > 0) {
-				printk(KERN_ERR "%s: %s: data underrun "
+				printk(KERN_ERR PFX "%s: %s: data underrun "
 						"(%d blocks)\n",
 						drive->name, __func__,
 						rq->current_nr_sectors);
@@ -952,7 +1017,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			cdrom_end_request(drive, uptodate);
 			return ide_stopped;
 		} else if (!blk_pc_request(rq)) {
-			ide_cd_request_sense_fixup(rq);
+			ide_cd_request_sense_fixup(drive, rq);
 			/* complain if we still have data left to transfer */
 			uptodate = rq->data_len ? 0 : 1;
 		}
@@ -995,6 +1060,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		xferfunc = hwif->tp_ops->input_data;
 	}
 
+	ide_debug_log(IDE_DBG_PC, "%s: data transfer, rq->cmd_type: 0x%x, "
+		      "ireason: 0x%x\n", __func__, rq->cmd_type, ireason);
+
 	/* transfer data */
 	while (thislen > 0) {
 		u8 *ptr = blk_fs_request(rq) ? NULL : rq->data;
@@ -1019,7 +1087,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 				 */
 				ide_pad_transfer(drive, 0, thislen);
 			else {
-				printk(KERN_ERR "%s: confused, missing data\n",
+				printk(KERN_ERR PFX "%s: confused, missing data\n",
 						drive->name);
 				blk_dump_rq_flags(rq, rq_data_dir(rq)
 						  ? "cdrom_newpc_intr, write"
@@ -1106,6 +1174,9 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	unsigned short sectors_per_frame =
 		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
 
+	ide_debug_log(IDE_DBG_RQ, "Call %s, write: 0x%x, secs_per_frame: %u\n",
+		      __func__, write, sectors_per_frame);
+
 	if (write) {
 		/* disk has become write protected */
 		if (cd->disk->policy) {
@@ -1117,7 +1188,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		 * We may be retrying this request after an error.  Fix up any
 		 * weirdness which might be present in the request packet.
 		 */
-		restore_request(rq);
+		ide_cd_restore_request(drive, rq);
 	}
 
 	/* use DMA, if possible / writes *must* be hardware frame aligned */
@@ -1148,6 +1219,9 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *info = drive->driver_data;
 
+	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd_type: 0x%x\n", __func__,
+		      rq->cmd_type);
+
 	if (blk_pc_request(rq))
 		rq->cmd_flags |= REQ_QUIET;
 	else
@@ -1191,6 +1265,9 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	ide_handler_t *fn;
 	int xferlen;
 
+	ide_debug_log(IDE_DBG_RQ, "Call %s, rq->cmd_type: 0x%x, block: %llu\n",
+		      __func__, rq->cmd_type, (u64)block);
+
 	if (blk_fs_request(rq)) {
 		if (drive->atapi_flags & IDE_AFLAG_SEEKING) {
 			ide_hwif_t *hwif = drive->hwif;
@@ -1203,7 +1280,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 							IDECD_SEEK_TIMER);
 					return ide_stopped;
 				}
-				printk(KERN_ERR "%s: DSC timeout\n",
+				printk(KERN_ERR PFX "%s: DSC timeout\n",
 						drive->name);
 			}
 			drive->atapi_flags &= ~IDE_AFLAG_SEEKING;
@@ -1244,7 +1321,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		cdrom_end_request(drive, 1);
 		return ide_stopped;
 	} else {
-		blk_dump_rq_flags(rq, "ide-cd bad flags");
+		blk_dump_rq_flags(rq, DRV_NAME " bad flags");
 		cdrom_end_request(drive, 0);
 		return ide_stopped;
 	}
@@ -1274,6 +1351,8 @@ int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
 	struct cdrom_device_info *cdi = &info->devinfo;
 	unsigned char cmd[BLK_MAX_CDB];
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_TEST_UNIT_READY;
 
@@ -1300,6 +1379,8 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	unsigned len = sizeof(capbuf);
 	u32 blocklen;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	memset(cmd, 0, BLK_MAX_CDB);
 	cmd[0] = GPCMD_READ_CDVD_CAPACITY;
 
@@ -1319,10 +1400,10 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 	case 4096:
 		break;
 	default:
-		printk(KERN_ERR "%s: weird block size %u\n",
-			drive->name, blocklen);
-		printk(KERN_ERR "%s: default to 2kb block size\n",
-			drive->name);
+		printk(KERN_ERR PFX "%s: weird block size %u\n",
+				drive->name, blocklen);
+		printk(KERN_ERR PFX "%s: default to 2kb block size\n",
+				drive->name);
 		blocklen = 2048;
 		break;
 	}
@@ -1338,6 +1419,8 @@ static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
 {
 	unsigned char cmd[BLK_MAX_CDB];
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	memset(cmd, 0, BLK_MAX_CDB);
 
 	cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
@@ -1366,11 +1449,13 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	long last_written;
 	unsigned long sectors_per_frame = SECTORS_PER_FRAME;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (toc == NULL) {
 		/* try to allocate space */
 		toc = kmalloc(sizeof(struct atapi_toc), GFP_KERNEL);
 		if (toc == NULL) {
-			printk(KERN_ERR "%s: No cdrom TOC buffer!\n",
+			printk(KERN_ERR PFX "%s: No cdrom TOC buffer!\n",
 					drive->name);
 			return -ENOMEM;
 		}
@@ -1526,6 +1611,8 @@ int ide_cdrom_get_capabilities(ide_drive_t *drive, u8 *buf)
 	struct packet_command cgc;
 	int stat, attempts = 3, size = ATAPI_CAPABILITIES_PAGE_SIZE;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if ((drive->atapi_flags & IDE_AFLAG_FULL_CAPS_PAGE) == 0)
 		size -= ATAPI_CAPABILITIES_PAGE_PAD_SIZE;
 
@@ -1544,6 +1631,8 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	struct cdrom_info *cd = drive->driver_data;
 	u16 curspeed, maxspeed;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (drive->atapi_flags & IDE_AFLAG_LE_SPEED_FIELDS) {
 		curspeed = le16_to_cpup((__le16 *)&buf[8 + 14]);
 		maxspeed = le16_to_cpup((__le16 *)&buf[8 + 8]);
@@ -1584,6 +1673,8 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *devinfo = &info->devinfo;
 
+	ide_debug_log(IDE_DBG_PROBE, "Call %s, nslots: %d\n", __func__, nslots);
+
 	devinfo->ops = &ide_cdrom_dops;
 	devinfo->speed = info->current_speed;
 	devinfo->capacity = nslots;
@@ -1605,13 +1696,17 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	mechtype_t mechtype;
 	int nslots = 1;
 
+	ide_debug_log(IDE_DBG_PROBE, "Call %s, drive->media: 0x%x, "
+		      "drive->atapi_flags: 0x%lx\n", __func__, drive->media,
+		      drive->atapi_flags);
+
 	cdi->mask = (CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
 		     CDC_DVD_RAM | CDC_SELECT_DISC | CDC_PLAY_AUDIO |
 		     CDC_MO_DRIVE | CDC_RAM);
 
 	if (drive->media == ide_optical) {
 		cdi->mask &= ~(CDC_MO_DRIVE | CDC_RAM);
-		printk(KERN_ERR "%s: ATAPI magneto-optical drive\n",
+		printk(KERN_ERR PFX "%s: ATAPI magneto-optical drive\n",
 				drive->name);
 		return nslots;
 	}
@@ -1667,7 +1762,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 
 	ide_cdrom_update_speed(drive, buf);
 
-	printk(KERN_INFO "%s: ATAPI", drive->name);
+	printk(KERN_INFO PFX "%s: ATAPI", drive->name);
 
 	/* don't print speed if the drive reported 0 */
 	if (cd->max_speed)
@@ -1690,7 +1785,8 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	else
 		printk(KERN_CONT " drive");
 
-	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpup((__be16 *)&buf[8 + 12]));
+	printk(KERN_CONT ", %dkB Cache\n",
+			 be16_to_cpup((__be16 *)&buf[8 + 12]));
 
 	return nslots;
 }
@@ -1875,6 +1971,8 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 	char *fw_rev = (char *)&id[ATA_ID_FW_REV];
 	int nslots;
 
+	ide_debug_log(IDE_DBG_PROBE, "Call %s\n", __func__);
+
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
 	blk_queue_update_dma_pad(drive->queue, 15);
@@ -1912,7 +2010,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 		drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 
 	if (ide_cdrom_register(drive, nslots)) {
-		printk(KERN_ERR "%s: %s failed to register device with the"
+		printk(KERN_ERR PFX "%s: %s failed to register device with the"
 				" cdrom driver.\n", drive->name, __func__);
 		cd->devinfo.handle = NULL;
 		return 1;
@@ -1926,6 +2024,8 @@ static void ide_cd_remove(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	ide_proc_unregister_driver(drive, info->driver);
 
 	del_gendisk(info->disk);
@@ -1940,6 +2040,8 @@ static void ide_cd_release(struct kref *kref)
 	ide_drive_t *drive = info->drive;
 	struct gendisk *g = info->disk;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	kfree(info->toc);
 	if (devinfo->handle == drive)
 		unregister_cdrom(devinfo);
@@ -2100,6 +2202,10 @@ static int ide_cd_probe(ide_drive_t *drive)
 	struct gendisk *g;
 	struct request_sense sense;
 
+	ide_debug_log(IDE_DBG_PROBE, "Call %s, drive->driver_req: %s, "
+		      "drive->media: 0x%x\n", __func__, drive->driver_req,
+		      drive->media);
+
 	if (!strstr("ide-cdrom", drive->driver_req))
 		goto failed;
 
@@ -2109,14 +2215,14 @@ static int ide_cd_probe(ide_drive_t *drive)
 	/* skip drives that we were told to ignore */
 	if (ignore != NULL) {
 		if (strstr(ignore, drive->name)) {
-			printk(KERN_INFO "ide-cd: ignoring drive %s\n",
+			printk(KERN_INFO PFX "ignoring drive %s\n",
 					 drive->name);
 			goto failed;
 		}
 	}
 	info = kzalloc(sizeof(struct cdrom_info), GFP_KERNEL);
 	if (info == NULL) {
-		printk(KERN_ERR "%s: Can't allocate a cdrom structure\n",
+		printk(KERN_ERR PFX "%s: Can't allocate a cdrom structure\n",
 				drive->name);
 		goto failed;
 	}
@@ -2164,6 +2270,7 @@ static void __exit ide_cdrom_exit(void)
 
 static int __init ide_cdrom_init(void)
 {
+	printk(KERN_INFO DRV_NAME " driver " IDECD_VERSION "\n");
 	return driver_register(&ide_cdrom_driver.gen_driver);
 }
 
-- 
1.5.5.4

