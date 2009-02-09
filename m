Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZBIUDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZBIUDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbZBIUAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:00:42 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48124 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbZBIUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:00:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=olaW/FDVG28Y+33Rx5a0qgoFtdQiv4YcBio2d3StkdEDTUO8wN7hpg8U3FFUrSCNub
         nymPIxLS7jxwIvNnP59ohyDkRCPKzJwycY8JdcCKFTlTzAQ9pwde8kco0iFJdCcYWpX6
         pIHul86gBSBXr/KEQvtwKDWA+EZpHllQ/ajyU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:01:51 +0100
Message-Id: <20090209200151.7985.40667.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
References: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: remove ide_end_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ide_end_request()

* Add ide_rq_bytes() helper.

* Add blk_noretry_request() quirk to ide_complete_rq() (currently only fs
  requests can be marked as "noretry" so there is no change in behavior).

* Switch current ide_end_request() users to use ide_complete_rq().

  [ No need to check for rq->nr_sectors == 0 in {ide_dma,task_pio}_intr(),
    nsectors == 0 in cdrom_end_request() and err == 0 in ide_do_devset(). ]

* Remove no longer needed ide_end_request().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |    6 ++--
 drivers/ide/ide-cd.c       |    7 ++---
 drivers/ide/ide-devsets.c  |    4 --
 drivers/ide/ide-disk.c     |    2 -
 drivers/ide/ide-dma.c      |    3 +-
 drivers/ide/ide-eh.c       |    2 -
 drivers/ide/ide-floppy.c   |    4 +-
 drivers/ide/ide-io.c       |   61 +++++++++++++--------------------------------
 drivers/ide/ide-tape.c     |    2 -
 drivers/ide/ide-taskfile.c |    4 +-
 include/linux/ide.h        |    2 -
 11 files changed, 37 insertions(+), 60 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -398,7 +398,8 @@ static ide_startstop_t ide_pc_intr(ide_d
 				if (rq->errors == 0)
 					rq->errors = -EIO;
 			}
-			ide_end_request(drive, uptodate, 0);
+			ide_complete_rq(drive, uptodate ? 0 : -EIO,
+					ide_rq_bytes(rq));
 		}
 
 		return ide_stopped;
@@ -457,7 +458,8 @@ static ide_startstop_t ide_pc_intr(ide_d
 
 		/* FIXME: don't do partial completions */
 		if (drive->media == ide_floppy)
-			ide_end_request(drive, 1, done >> 9);
+			ide_complete_rq(drive, 0,
+					done ? done : ide_rq_bytes(rq));
 	} else
 		xferfunc(drive, NULL, pc->cur_pos, bcount);
 
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -292,7 +292,7 @@ static void cdrom_end_request(ide_drive_
 	if (blk_fs_request(rq) == 0 && uptodate <= 0 && rq->errors == 0)
 		rq->errors = -EIO;
 
-	ide_end_request(drive, uptodate, nsectors);
+	ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
 }
 
 static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
@@ -787,10 +787,11 @@ static ide_startstop_t cdrom_newpc_intr(
 		if (dma_error)
 			return ide_error(drive, "dma error", stat);
 		if (blk_fs_request(rq)) {
-			ide_end_request(drive, 1, rq->nr_sectors);
+			ide_complete_rq(drive, 0, rq->nr_sectors
+				? (rq->nr_sectors << 9) : ide_rq_bytes(rq));
 			return ide_stopped;
 		} else if (rq->cmd_type == REQ_TYPE_ATA_PC && !rq->bio) {
-			ide_end_request(drive, 1, 1);
+			ide_complete_rq(drive, 0, 512);
 			return ide_stopped;
 		}
 		goto end_request;
Index: b/drivers/ide/ide-devsets.c
===================================================================
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -183,8 +183,6 @@ ide_startstop_t ide_do_devset(ide_drive_
 	err = setfunc(drive, *(int *)&rq->cmd[1]);
 	if (err)
 		rq->errors = err;
-	else
-		err = 1;
-	ide_end_request(drive, err, 0);
+	ide_complete_rq(drive, err, ide_rq_bytes(rq));
 	return ide_stopped;
 }
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -186,7 +186,7 @@ static ide_startstop_t ide_do_rw_disk(id
 		blk_dump_rq_flags(rq, "ide_do_rw_disk - bad command");
 		if (rq->errors == 0)
 			rq->errors = -EIO;
-		ide_end_request(drive, 0, 0);
+		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
 		return ide_stopped;
 	}
 
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -101,7 +101,8 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 			if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
 				ide_finish_cmd(drive, cmd, stat);
 			else
-				ide_end_request(drive, 1, cmd->rq->nr_sectors);
+				ide_complete_rq(drive, 0,
+						cmd->rq->nr_sectors << 9);
 			return ide_stopped;
 		}
 		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
Index: b/drivers/ide/ide-eh.c
===================================================================
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -149,7 +149,7 @@ static inline void ide_complete_drive_re
 	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET) {
 		if (err <= 0 && rq->errors == 0)
 			rq->errors = -EIO;
-		ide_end_request(drive, err ? err : 1, 0);
+		ide_complete_rq(drive, err ? err : 0, ide_rq_bytes(rq));
 	}
 }
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -68,7 +68,7 @@ static void idefloppy_update_buffers(ide
 	struct bio *bio = rq->bio;
 
 	while ((bio = rq->bio) != NULL)
-		ide_end_request(drive, 1, 0);
+		ide_complete_rq(drive, 0, ide_rq_bytes(rq));
 }
 
 static int ide_floppy_callback(ide_drive_t *drive, int dsc)
@@ -298,7 +298,7 @@ out_end:
 	drive->failed_pc = NULL;
 	if (blk_fs_request(rq) == 0 && rq->errors == 0)
 		rq->errors = -EIO;
-	ide_end_request(drive, 0, 0);
+	ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
 	return ide_stopped;
 }
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -71,48 +71,6 @@ int ide_end_rq(ide_drive_t *drive, struc
 }
 EXPORT_SYMBOL_GPL(ide_end_rq);
 
-/**
- *	ide_end_request		-	complete an IDE I/O
- *	@drive: IDE device for the I/O
- *	@uptodate:
- *	@nr_sectors: number of sectors completed
- *
- *	This is our end_request wrapper function. We complete the I/O
- *	update random number input and dequeue the request, which if
- *	it was tagged may be out of order.
- */
-
-int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
-{
-	unsigned int nr_bytes = nr_sectors << 9;
-	struct request *rq = drive->hwif->rq;
-	int rc, error = 0;
-
-	if (!nr_bytes) {
-		if (blk_pc_request(rq))
-			nr_bytes = rq->data_len;
-		else
-			nr_bytes = rq->hard_cur_sectors << 9;
-	}
-
-	/*
-	 * if failfast is set on a request, override number of sectors
-	 * and complete the whole request right now
-	 */
-	if (blk_noretry_request(rq) && uptodate <= 0)
-		nr_bytes = rq->hard_nr_sectors << 9;
-
-	if (uptodate <= 0)
-		error = uptodate ? uptodate : -EIO;
-
-	rc = ide_end_rq(drive, rq, error, nr_bytes);
-	if (rc == 0)
-		drive->hwif->rq = NULL;
-
-	return rc;
-}
-EXPORT_SYMBOL(ide_end_request);
-
 void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 {
 	struct ide_taskfile *tf = &cmd->tf;
@@ -137,12 +95,29 @@ void ide_complete_cmd(ide_drive_t *drive
 		kfree(cmd);
 }
 
+/* obsolete, blk_rq_bytes() should be used instead */
+unsigned int ide_rq_bytes(struct request *rq)
+{
+	if (blk_pc_request(rq))
+		return rq->data_len;
+	else
+		return rq->hard_cur_sectors << 9;
+}
+EXPORT_SYMBOL_GPL(ide_rq_bytes);
+
 int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 	int rc;
 
+	/*
+	 * if failfast is set on a request, override number of sectors
+	 * and complete the whole request right now
+	 */
+	if (blk_noretry_request(rq) && error <= 0)
+		nr_bytes = rq->hard_nr_sectors << 9;
+
 	rc = ide_end_rq(drive, rq, error, nr_bytes);
 	if (rc == 0)
 		hwif->rq = NULL;
@@ -166,7 +141,7 @@ void ide_kill_rq(ide_drive_t *drive, str
 			rq->errors = IDE_DRV_ERROR_GENERAL;
 		else if (blk_fs_request(rq) == 0 && rq->errors == 0)
 			rq->errors = -EIO;
-		ide_end_request(drive, 0, 0);
+		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
 	}
 }
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -762,7 +762,7 @@ static ide_startstop_t idetape_do_reques
 			"request queue (%d)\n", drive->name, rq->cmd_type);
 		if (blk_fs_request(rq) == 0 && rq->errors == 0)
 			rq->errors = -EIO;
-		ide_end_request(drive, 0, 0);
+		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
 		return ide_stopped;
 	}
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -283,7 +283,7 @@ static void ide_error_cmd(ide_drive_t *d
 		}
 
 		if (sectors > 0)
-			ide_end_request(drive, 1, sectors);
+			ide_complete_rq(drive, 0, sectors << 9);
 	}
 }
 
@@ -352,7 +352,7 @@ out_end:
 	if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
 		ide_finish_cmd(drive, cmd, stat);
 	else
-		ide_end_request(drive, 1, cmd->rq->nr_sectors);
+		ide_complete_rq(drive, 0, cmd->rq->nr_sectors << 9);
 	return ide_stopped;
 out_err:
 	ide_error_cmd(drive, cmd);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1128,8 +1128,8 @@ int generic_ide_ioctl(ide_drive_t *, str
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
+unsigned int ide_rq_bytes(struct request *);
 int ide_end_rq(ide_drive_t *, struct request *, int, unsigned int);
-int ide_end_request(ide_drive_t *, int, int);
 void ide_kill_rq(ide_drive_t *, struct request *);
 
 void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
