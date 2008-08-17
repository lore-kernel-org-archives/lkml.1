Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYHQRZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYHQRZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYHQRXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:23:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:31287 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYHQRXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=wt50aBFs7F/+MGeOqQTplTd0NEVk8hV+ps+sCqoYaH5IrzIP/rwKWnGnEXANAoCeuS
         V5z0KczOAvzOYLwAMLpUrnSkOUj1tO4ywGbCdu0JxAAe0I2U7AySeFWOCD3ONX834Pjt
         TuiogA2ekw1tq/MSv0FeeHRc+iKgZMxhkroU4=
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/5] ide-floppy: convert driver to the new debugging macro
Date: Sun, 17 Aug 2008 19:23:45 +0200
Message-Id: <1218993826-4571-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also:

- leave in the possibility for optimizing away all debugging macros
- add a PFX macro and prepend all printk calls with it for consistency
- change idefloppy_create_rw_cmd's 1st arg from idefloppy_floppy_t * to
ide_drive_t *.
- add a missing printk-level in idefloppy_init
- fix minor checkpatch warnings

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |  140 ++++++++++++++++++++++++---------------------
 1 files changed, 75 insertions(+), 65 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2a54a25..3de9478 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -16,6 +16,7 @@
  */
 
 #define DRV_NAME "ide-floppy"
+#define PFX DRV_NAME ": "
 
 #define IDEFLOPPY_VERSION "1.00"
 
@@ -49,16 +50,12 @@
 #include "ide-floppy.h"
 
 /* define to see debug info */
-#define IDEFLOPPY_DEBUG_LOG		0
-
-/* #define IDEFLOPPY_DEBUG(fmt, args...) printk(KERN_INFO fmt, ## args) */
-#define IDEFLOPPY_DEBUG(fmt, args...)
+#define IDEFLOPPY_DEBUG_LOG	0
 
 #if IDEFLOPPY_DEBUG_LOG
-#define debug_log(fmt, args...) \
-	printk(KERN_INFO "ide-floppy: " fmt, ## args)
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
 #else
-#define debug_log(fmt, args...) do {} while (0)
+#define ide_debug_log(lvl, fmt, args...) do {} while (0)
 #endif
 
 /*
@@ -122,13 +119,21 @@ static int idefloppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	struct request *rq = HWGROUP(drive)->rq;
 	int error;
 
-	debug_log("Reached %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
 	switch (uptodate) {
-	case 0: error = IDEFLOPPY_ERROR_GENERAL; break;
-	case 1: error = 0; break;
-	default: error = uptodate;
+	case 0:
+		error = IDEFLOPPY_ERROR_GENERAL;
+		break;
+
+	case 1:
+		error = 0;
+		break;
+
+	default:
+		error = uptodate;
 	}
+
 	if (error)
 		floppy->failed_pc = NULL;
 	/* Why does this happen? */
@@ -161,7 +166,7 @@ static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 	struct ide_atapi_pc *pc = drive->pc;
 	int uptodate = pc->error ? 0 : 1;
 
-	debug_log("Reached %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
 	if (floppy->failed_pc == pc)
 		floppy->failed_pc = NULL;
@@ -180,13 +185,15 @@ static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
 
 			if (floppy->failed_pc)
-				debug_log("pc = %x, ", floppy->failed_pc->c[0]);
+				ide_debug_log(IDE_DBG_PC, "pc = %x, ",
+					      floppy->failed_pc->c[0]);
 
-			debug_log("sense key = %x, asc = %x, ascq = %x\n",
-				  floppy->sense_key, floppy->asc, floppy->ascq);
+			ide_debug_log(IDE_DBG_SENSE, "sense key = %x, asc = %x,"
+				      "ascq = %x\n", floppy->sense_key,
+				      floppy->asc, floppy->ascq);
 		} else
-			printk(KERN_ERR "Error in REQUEST SENSE itself - "
-					"Aborting request!\n");
+			printk(KERN_ERR PFX "Error in REQUEST SENSE itself - "
+			       "Aborting request!\n");
 	}
 
 	idefloppy_end_request(drive, uptodate, 0);
@@ -201,7 +208,7 @@ static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
 	    floppy->ascq      == 0x00)
 		return;
 
-	printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x, key = %2x, "
+	printk(KERN_ERR PFX "%s: I/O error, pc = %2x, key = %2x, "
 			"asc = %2x, ascq = %2x\n",
 			floppy->drive->name, pc->c[0], floppy->sense_key,
 			floppy->asc, floppy->ascq);
@@ -231,7 +238,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		return ide_stopped;
 	}
 
-	debug_log("Retry number - %d\n", pc->retries);
+	ide_debug_log(IDE_DBG_FUNC, "%s: Retry #%d\n", __func__, pc->retries);
 
 	pc->retries++;
 
@@ -265,23 +272,23 @@ void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 		length += 32;
 		break;
 	default:
-		printk(KERN_ERR "ide-floppy: unsupported page code "
-				"in create_mode_sense_cmd\n");
+		printk(KERN_ERR PFX "unsupported page code in %s\n", __func__);
 	}
 	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
 	pc->req_xfer = length;
 }
 
-static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
+static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
 {
+	idefloppy_floppy_t *floppy = drive->driver_data;
 	int block = sector / floppy->bs_factor;
 	int blocks = rq->nr_sectors / floppy->bs_factor;
 	int cmd = rq_data_dir(rq);
 
-	debug_log("create_rw10_cmd: block == %d, blocks == %d\n",
-		block, blocks);
+	ide_debug_log(IDE_DBG_FUNC, "%s: block: %d, blocks: %d\n", __func__,
+		      block, blocks);
 
 	ide_init_pc(pc);
 	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
@@ -326,41 +333,42 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 	struct ide_atapi_pc *pc;
 	unsigned long block = (unsigned long)block_s;
 
-	debug_log("%s: dev: %s, cmd: 0x%x, cmd_type: %x, errors: %d\n",
-		  __func__, rq->rq_disk ? rq->rq_disk->disk_name : "?",
-		  rq->cmd[0], rq->cmd_type, rq->errors);
+	ide_debug_log(IDE_DBG_FUNC, "%s: dev: %s, cmd: 0x%x, cmd_type: %x, "
+		      "errors: %d\n",
+		      __func__, rq->rq_disk ? rq->rq_disk->disk_name : "?",
+		      rq->cmd[0], rq->cmd_type, rq->errors);
 
-	debug_log("%s: sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",
-		  __func__, (long)rq->sector, rq->nr_sectors,
-		  rq->current_nr_sectors);
+	ide_debug_log(IDE_DBG_FUNC, "%s: sector: %ld, nr_sectors: %ld, "
+		      "current_nr_sectors: %d\n",
+		      __func__, (long)rq->sector, rq->nr_sectors,
+		      rq->current_nr_sectors);
 
 	if (rq->errors >= ERROR_MAX) {
 		if (floppy->failed_pc)
 			ide_floppy_report_error(floppy, floppy->failed_pc);
 		else
-			printk(KERN_ERR "ide-floppy: %s: I/O error\n",
-				drive->name);
+			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
+
 		idefloppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 	if (blk_fs_request(rq)) {
 		if (((long)rq->sector % floppy->bs_factor) ||
 		    (rq->nr_sectors % floppy->bs_factor)) {
-			printk(KERN_ERR "%s: unsupported r/w request size\n",
-					drive->name);
+			printk(KERN_ERR PFX "%s: unsupported r/w rq size\n",
+				drive->name);
 			idefloppy_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
 		pc = &floppy->queued_pc;
-		idefloppy_create_rw_cmd(floppy, pc, rq, block);
+		idefloppy_create_rw_cmd(drive, pc, rq, block);
 	} else if (blk_special_request(rq)) {
 		pc = (struct ide_atapi_pc *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
 		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
-		blk_dump_rq_flags(rq,
-			"ide-floppy: unsupported command in queue");
+		blk_dump_rq_flags(rq, PFX "unsupported command in queue");
 		idefloppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
@@ -393,8 +401,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 	ide_floppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
-				" parameters\n");
+		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
 		return 1;
 	}
 
@@ -417,7 +424,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 	capacity = cyls * heads * sectors * sector_size;
 
 	if (memcmp(page, &floppy->flexible_disk_page, 32))
-		printk(KERN_INFO "%s: %dkB, %d/%d/%d CHS, %d kBps, "
+		printk(KERN_INFO PFX "%s: %dkB, %d/%d/%d CHS, %d kBps, "
 				"%d sector size, %d rpm\n",
 				drive->name, capacity / 1024, cyls, heads,
 				sectors, transfer_rate / 8, sector_size, rpm);
@@ -429,7 +436,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 	lba_capacity = floppy->blocks * floppy->block_size;
 
 	if (capacity < lba_capacity) {
-		printk(KERN_NOTICE "%s: The disk reports a capacity of %d "
+		printk(KERN_NOTICE PFX "%s: The disk reports a capacity of %d "
 			"bytes, but the drive only handles %d\n",
 			drive->name, lba_capacity, capacity);
 		floppy->blocks = floppy->block_size ?
@@ -459,7 +466,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 
 	ide_floppy_create_read_capacity_cmd(&pc);
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
+		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
 	}
 	header_len = pc.buf[3];
@@ -472,8 +479,9 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
 		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
 
-		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
-				i, blocks * length / 1024, blocks, length);
+		ide_debug_log(IDE_DBG_PROBE, "Descriptor %d: %dkB, %d blocks, "
+			      "%d sector size\n",
+			      i, blocks * length / 1024, blocks, length);
 
 		if (i)
 			continue;
@@ -493,23 +501,24 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		case CAPACITY_CURRENT:
 			/* Normal Zip/LS-120 disks */
 			if (memcmp(cap_desc, &floppy->cap_desc, 8))
-				printk(KERN_INFO "%s: %dkB, %d blocks, %d "
-					"sector size\n", drive->name,
-					blocks * length / 1024, blocks, length);
+				printk(KERN_INFO PFX "%s: %dkB, %d blocks, %d "
+				       "sector size\n",
+				       drive->name, blocks * length / 1024,
+				       blocks, length);
 			memcpy(&floppy->cap_desc, cap_desc, 8);
 
 			if (!length || length % 512) {
-				printk(KERN_NOTICE "%s: %d bytes block size "
-					"not supported\n", drive->name, length);
+				printk(KERN_NOTICE PFX "%s: %d bytes block size"
+				       " not supported\n", drive->name, length);
 			} else {
 				floppy->blocks = blocks;
 				floppy->block_size = length;
 				floppy->bs_factor = length / 512;
 				if (floppy->bs_factor != 1)
-					printk(KERN_NOTICE "%s: warning: non "
-						"512 bytes block size not "
-						"fully supported\n",
-						drive->name);
+					printk(KERN_NOTICE PFX "%s: Warning: "
+					       "non 512 bytes block size not "
+					       "fully supported\n",
+					       drive->name);
 				rc = 0;
 			}
 			break;
@@ -518,15 +527,16 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 			 * This is a KERN_ERR so it appears on screen
 			 * for the user to see
 			 */
-			printk(KERN_ERR "%s: No disk in drive\n", drive->name);
+			printk(KERN_ERR PFX "%s: No disk in drive\n",
+			       drive->name);
 			break;
 		case CAPACITY_INVALID:
-			printk(KERN_ERR "%s: Invalid capacity for disk "
+			printk(KERN_ERR PFX "%s: Invalid capacity for disk "
 				"in drive\n", drive->name);
 			break;
 		}
-		debug_log("Descriptor 0 Code: %d\n",
-			  pc.buf[desc_start + 4] & 0x03);
+		ide_debug_log(IDE_DBG_PROBE, "Descriptor 0 Code: %d\n",
+			      pc.buf[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
@@ -676,14 +686,14 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	ide_drive_t *drive;
 	int ret = 0;
 
-	debug_log("Reached %s\n", __func__);
-
 	floppy = ide_floppy_get(disk);
 	if (!floppy)
 		return -ENXIO;
 
 	drive = floppy->drive;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	floppy->openers++;
 
 	if (floppy->openers == 1) {
@@ -731,7 +741,7 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
 	ide_drive_t *drive = floppy->drive;
 
-	debug_log("Reached %s\n", __func__);
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
 	if (floppy->openers == 1) {
 		ide_set_media_lock(drive, disk, 0);
@@ -852,14 +862,14 @@ static int ide_floppy_probe(ide_drive_t *drive)
 		goto failed;
 
 	if (!ide_check_atapi_device(drive, DRV_NAME)) {
-		printk(KERN_ERR "ide-floppy: %s: not supported by this version"
-				" of ide-floppy\n", drive->name);
+		printk(KERN_ERR PFX "%s: not supported by this version of "
+		       DRV_NAME "\n", drive->name);
 		goto failed;
 	}
 	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
 	if (!floppy) {
-		printk(KERN_ERR "ide-floppy: %s: Can't allocate a floppy"
-				" structure\n", drive->name);
+		printk(KERN_ERR PFX "%s: Can't allocate a floppy structure\n",
+		       drive->name);
 		goto failed;
 	}
 
@@ -902,7 +912,7 @@ static void __exit idefloppy_exit(void)
 
 static int __init idefloppy_init(void)
 {
-	printk("ide-floppy driver " IDEFLOPPY_VERSION "\n");
+	printk(KERN_INFO DRV_NAME " driver " IDEFLOPPY_VERSION "\n");
 	return driver_register(&idefloppy_driver.gen_driver);
 }
 
-- 
1.5.5.4

