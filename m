Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZBPARd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZBPARd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZBPAN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:13:26 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53581 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbZBPANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:13:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=d8OIEJRd5clmEFMG1lFI1rPVU5hq+i02egf7c30umGnudrGc+H/AFW+4OCaU3sR0BH
         wdkvWqsdJa/SlESi9TkUaGJTYyFOHUQMECjH8GURFh5xM5gF9MhFnGOmiZxoZvdKP1dN
         CsvwMul0XnDofOu7ID91zZgm45e0blcq1rYxY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:14:48 +0100
Message-Id: <20090216001448.27491.24142.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/20] ide-cd: use scatterlists for PIO transfers (fs requests)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: use scatterlists for PIO transfers (fs requests)

* Export ide_pio_bytes().

* Add ->last_xfer_len field to struct ide_cmd.

* Add ide_cd_error_cmd() helper to ide-cd.

* Convert ide-cd to use scatterlists also for PIO transfers (fs requests
  only for now) and get rid of partial completions (except when the error
  happens -- which is still subject to change later because looking at
  ATAPI spec it seems that the device is free to error the whole transfer
  with setting the Error bit only on the last transfer chunk).

* Update ide_cd_{prepare_rw,restore_request,do_request}() accordingly.

* Inline ide_cd_restore_request() into cdrom_start_rw().

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c       |  146 +++++++++++++--------------------------------
 drivers/ide/ide-taskfile.c |    5 -
 include/linux/ide.h        |    4 +
 3 files changed, 50 insertions(+), 105 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -531,64 +531,12 @@ static ide_startstop_t ide_cd_prepare_rw
 {
 	ide_debug_log(IDE_DBG_RQ, "rq->cmd_flags: 0x%x", rq->cmd_flags);
 
-	if (rq_data_dir(rq) == READ) {
-		unsigned short sectors_per_frame =
-			queue_hardsect_size(drive->queue) >> SECTOR_BITS;
-		int nskip = rq->sector & (sectors_per_frame - 1);
-
-		/*
-		 * If the requested sector doesn't start on a frame boundary,
-		 * we must adjust the start of the transfer so that it does,
-		 * and remember to skip the first few sectors.
-		 *
-		 * If the rq->current_nr_sectors field is larger than the size
-		 * of the buffer, it will mean that we're to skip a number of
-		 * sectors equal to the amount by which rq->current_nr_sectors
-		 * is larger than the buffer size.
-		 */
-		if (nskip > 0) {
-			/* sanity check... */
-			if (rq->current_nr_sectors !=
-			    bio_cur_sectors(rq->bio)) {
-				printk(KERN_ERR PFX "%s: %s: buffer botch (%u)\n",
-						drive->name, __func__,
-						rq->current_nr_sectors);
-				return ide_stopped;
-			}
-			rq->current_nr_sectors += nskip;
-		}
-	}
-
 	/* set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
 	return ide_started;
 }
 
-/*
- * Fix up a possibly partially-processed request so that we can start it over
- * entirely, or even put it back on the request queue.
- */
-static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
-{
-
-	ide_debug_log(IDE_DBG_FUNC, "enter");
-
-	if (rq->buffer != bio_data(rq->bio)) {
-		sector_t n =
-			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;
-
-		rq->buffer = bio_data(rq->bio);
-		rq->nr_sectors += n;
-		rq->sector -= n;
-	}
-	rq->current_nr_sectors = bio_cur_sectors(rq->bio);
-	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->hard_nr_sectors = rq->nr_sectors;
-	rq->hard_sector = rq->sector;
-	rq->q->prep_rq_fn(rq->q, rq);
-}
-
 static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
 {
 	ide_debug_log(IDE_DBG_FUNC, "rq->cmd[0]: 0x%x", rq->cmd[0]);
@@ -682,6 +630,17 @@ int ide_cd_queue_pc(ide_drive_t *drive, 
 	return (flags & REQ_FAILED) ? -EIO : 0;
 }
 
+static void ide_cd_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
+{
+	unsigned int nr_bytes = cmd->nbytes - cmd->nleft;
+
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
+		nr_bytes -= cmd->last_xfer_len;
+
+	if (nr_bytes > 0)
+		ide_complete_rq(drive, 0, nr_bytes);
+}
+
 /*
  * Called from blk_end_request_callback() after the data of the request is
  * completed and before the request itself is completed. By returning value '1',
@@ -695,6 +654,7 @@ static int cdrom_newpc_intr_dummy_cb(str
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
@@ -761,11 +721,10 @@ static ide_startstop_t cdrom_newpc_intr(
 			 * Otherwise, complete the command normally.
 			 */
 			uptodate = 1;
-			if (rq->current_nr_sectors > 0) {
+			if (cmd->nleft > 0) {
 				printk(KERN_ERR PFX "%s: %s: data underrun "
-						"(%d blocks)\n",
-						drive->name, __func__,
-						rq->current_nr_sectors);
+					"(%u bytes)\n", drive->name, __func__,
+					cmd->nleft);
 				if (!write)
 					rq->cmd_flags |= REQ_FAILED;
 				uptodate = 0;
@@ -787,24 +746,10 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	if (blk_fs_request(rq)) {
 		if (write == 0) {
-			int nskip;
-
 			if (ide_cd_check_transfer_size(drive, len))
 				goto out_end;
-
-			/*
-			 * First, figure out if we need to bit-bucket
-			 * any of the leading sectors.
-			 */
-			nskip = min_t(int, rq->current_nr_sectors
-					   - bio_cur_sectors(rq->bio),
-					   thislen >> 9);
-			if (nskip > 0) {
-				ide_pad_transfer(drive, write, nskip << 9);
-				rq->current_nr_sectors -= nskip;
-				thislen -= (nskip << 9);
-			}
 		}
+		cmd->last_xfer_len = 0;
 	}
 
 	if (ireason == 0) {
@@ -827,15 +772,15 @@ static ide_startstop_t cdrom_newpc_intr(
 		/* bio backed? */
 		if (rq->bio) {
 			if (blk_fs_request(rq)) {
-				ptr = rq->buffer;
-				blen = rq->current_nr_sectors << 9;
+				blen = min_t(int, thislen, cmd->nleft);
 			} else {
 				ptr = bio_data(rq->bio);
 				blen = bio_iovec(rq->bio)->bv_len;
 			}
 		}
 
-		if (!ptr) {
+		if ((blk_fs_request(rq) && cmd->nleft == 0) ||
+		    (blk_fs_request(rq) == 0 && ptr == NULL)) {
 			if (blk_fs_request(rq) && !write)
 				/*
 				 * If the buffers are full, pipe the rest into
@@ -855,26 +800,16 @@ static ide_startstop_t cdrom_newpc_intr(
 		if (blen > thislen)
 			blen = thislen;
 
-		xferfunc(drive, NULL, ptr, blen);
+		if (blk_fs_request(rq)) {
+			ide_pio_bytes(drive, cmd, write, blen);
+			cmd->last_xfer_len += blen;
+		} else
+			xferfunc(drive, NULL, ptr, blen);
 
 		thislen -= blen;
 		len -= blen;
 
-		if (blk_fs_request(rq)) {
-			rq->buffer += blen;
-			rq->nr_sectors -= (blen >> 9);
-			rq->current_nr_sectors -= (blen >> 9);
-			rq->sector += (blen >> 9);
-
-			if (rq->current_nr_sectors == 0 && rq->nr_sectors) {
-				nsectors = rq->hard_cur_sectors;
-
-				if (nsectors == 0)
-					nsectors = 1;
-
-				ide_complete_rq(drive, 0, nsectors << 9);
-			}
-		} else {
+		if (blk_fs_request(rq) == 0) {
 			rq->data_len -= blen;
 
 			/*
@@ -925,8 +860,10 @@ out_end:
 			ide_cd_complete_failed_rq(drive, rq);
 
 		if (blk_fs_request(rq)) {
-			if (rq->current_nr_sectors == 0)
+			if (cmd->nleft == 0)
 				uptodate = 1;
+			if (uptodate == 0)
+				ide_cd_error_cmd(drive, cmd);
 		} else {
 			if (uptodate <= 0 && rq->errors == 0)
 				rq->errors = -EIO;
@@ -936,7 +873,7 @@ out_end:
 		if (blk_pc_request(rq))
 			nsectors = (rq->data_len + 511) >> 9;
 		else
-			nsectors = rq->hard_cur_sectors;
+			nsectors = rq->hard_nr_sectors;
 
 		if (nsectors == 0)
 			nsectors = 1;
@@ -952,9 +889,10 @@ out_end:
 static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *cd = drive->driver_data;
+	struct request_queue *q = drive->queue;
 	int write = rq_data_dir(rq) == WRITE;
 	unsigned short sectors_per_frame =
-		queue_hardsect_size(drive->queue) >> SECTOR_BITS;
+		queue_hardsect_size(q) >> SECTOR_BITS;
 
 	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, write: 0x%x, "
 				  "secs_per_frame: %u",
@@ -969,17 +907,16 @@ static ide_startstop_t cdrom_start_rw(id
 		 * We may be retrying this request after an error.  Fix up any
 		 * weirdness which might be present in the request packet.
 		 */
-		ide_cd_restore_request(drive, rq);
+		q->prep_rq_fn(q, rq);
 	}
 
-	/* use DMA, if possible / writes *must* be hardware frame aligned */
+	/* fs requests *must* be hardware frame aligned */
 	if ((rq->nr_sectors & (sectors_per_frame - 1)) ||
-	    (rq->sector & (sectors_per_frame - 1))) {
-		if (write)
-			return ide_stopped;
-		drive->dma = 0;
-	} else
-		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+	    (rq->sector & (sectors_per_frame - 1)))
+		return ide_stopped;
+
+	/* use DMA, if possible */
+	drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 	if (write)
 		cd->devinfo.media_written = 1;
@@ -1042,8 +979,6 @@ static ide_startstop_t ide_cd_do_request
 	if (blk_fs_request(rq)) {
 		if (cdrom_start_rw(drive, rq) == ide_stopped ||
 		    ide_cd_prepare_rw_request(drive, rq) == ide_stopped) {
-			if (rq->current_nr_sectors == 0)
-				uptodate = 1;
 			goto out_end;
 		}
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
@@ -1070,6 +1005,11 @@ static ide_startstop_t ide_cd_do_request
 
 	cmd.rq = rq;
 
+	if (blk_fs_request(rq)) {
+		ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
+		ide_map_sg(drive, &cmd);
+	}
+
 	return ide_issue_pc(drive, &cmd);
 out_end:
 	nsectors = rq->hard_nr_sectors;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -188,8 +188,8 @@ static u8 wait_drive_not_busy(ide_drive_
 	return stat;
 }
 
-static void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
-			  unsigned int write, unsigned int len)
+void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
+		   unsigned int write, unsigned int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
@@ -240,6 +240,7 @@ static void ide_pio_bytes(ide_drive_t *d
 		len -= nr_bytes;
 	}
 }
+EXPORT_SYMBOL_GPL(ide_pio_bytes);
 
 static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
 			      unsigned int write)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -351,6 +351,8 @@ struct ide_cmd {
 
 	unsigned int		nbytes;
 	unsigned int		nleft;
+	unsigned int		last_xfer_len;
+
 	struct scatterlist	*cursg;
 	unsigned int		cursg_ofs;
 
@@ -1223,6 +1225,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, struct ide_cmd *);
 
+void ide_pio_bytes(ide_drive_t *, struct ide_cmd *, unsigned int, unsigned int);
+
 void ide_finish_cmd(ide_drive_t *, struct ide_cmd *, u8);
 
 int ide_raw_taskfile(ide_drive_t *, struct ide_cmd *, u8 *, u16);
