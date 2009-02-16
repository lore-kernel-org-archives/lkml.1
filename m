Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbZBPASc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbZBPASc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbZBPANn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:13:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:51735 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbZBPANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:13:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=suzWdc8vhqJCrhzyDw3uNhZQBTfTcK+AiGHccxDJUrHZBLuBGsP41pndU8fxOpF2dU
         ClezXDX3XyvGAILAoVAeqNsdYXxBXCKJI4JDviuXNBCBzX++3rcvIP5Xr0l31Fczpr3f
         hhCRMQW50mBW+hRWEdPBRai9Oy+VXG77v2wTE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:15:08 +0100
Message-Id: <20090216001508.27491.1594.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/20] ide-cd: use scatterlists for PIO transfers (non-fs requests)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: use scatterlists for PIO transfers (non-fs requests)

Convert ide-cd to use scatterlists for PIO transfers and get rid of
partial completions (except on error) also for non-fs requests.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |  102 +++++++++++++++------------------------------------
 1 file changed, 30 insertions(+), 72 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -501,8 +501,10 @@ static int ide_cd_check_ireason(ide_driv
 	return -1;
 }
 
-static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
+static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
+	struct request *rq = cmd->rq;
+
 	ide_debug_log(IDE_DBG_FUNC, "rq->cmd[0]: 0x%x", rq->cmd[0]);
 
 	/*
@@ -510,11 +512,14 @@ static void ide_cd_request_sense_fixup(i
 	 * and some drives don't send them.  Sigh.
 	 */
 	if (rq->cmd[0] == GPCMD_REQUEST_SENSE &&
-	    rq->data_len > 0 && rq->data_len <= 5)
-		while (rq->data_len > 0) {
-			*(u8 *)rq->data++ = 0;
-			--rq->data_len;
+	    cmd->nleft > 0 && cmd->nleft <= 5) {
+		unsigned int ofs = cmd->nbytes - cmd->nleft;
+
+		while (cmd->nleft > 0) {
+			*((u8 *)rq->data + ofs++) = 0;
+			cmd->nleft--;
 		}
+	}
 }
 
 int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
@@ -605,22 +610,11 @@ static void ide_cd_error_cmd(ide_drive_t
 		ide_complete_rq(drive, 0, nr_bytes);
 }
 
-/*
- * Called from blk_end_request_callback() after the data of the request is
- * completed and before the request itself is completed. By returning value '1',
- * blk_end_request_callback() returns immediately without completing it.
- */
-static int cdrom_newpc_intr_dummy_cb(struct request *rq)
-{
-	return 1;
-}
-
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
-	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, stat, thislen, uptodate = 0;
 	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
@@ -670,7 +664,7 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	ide_read_bcount_and_ireason(drive, &len, &ireason);
 
-	thislen = blk_fs_request(rq) ? len : rq->data_len;
+	thislen = blk_fs_request(rq) ? len : cmd->nleft;
 	if (thislen > len)
 		thislen = len;
 
@@ -694,9 +688,9 @@ static ide_startstop_t cdrom_newpc_intr(
 				uptodate = 0;
 			}
 		} else if (!blk_pc_request(rq)) {
-			ide_cd_request_sense_fixup(drive, rq);
+			ide_cd_request_sense_fixup(drive, cmd);
 			/* complain if we still have data left to transfer */
-			uptodate = rq->data_len ? 0 : 1;
+			uptodate = cmd->nleft ? 0 : 1;
 			if (uptodate == 0)
 				rq->cmd_flags |= REQ_FAILED;
 		}
@@ -710,35 +704,15 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	cmd->last_xfer_len = 0;
 
-	if (ireason == 0) {
-		write = 1;
-		xferfunc = hwif->tp_ops->output_data;
-	} else {
-		write = 0;
-		xferfunc = hwif->tp_ops->input_data;
-	}
-
 	ide_debug_log(IDE_DBG_PC, "data transfer, rq->cmd_type: 0x%x, "
 				  "ireason: 0x%x",
 				  rq->cmd_type, ireason);
 
 	/* transfer data */
 	while (thislen > 0) {
-		u8 *ptr = blk_fs_request(rq) ? NULL : rq->data;
-		int blen = rq->data_len;
-
-		/* bio backed? */
-		if (rq->bio) {
-			if (blk_fs_request(rq)) {
-				blen = min_t(int, thislen, cmd->nleft);
-			} else {
-				ptr = bio_data(rq->bio);
-				blen = bio_iovec(rq->bio)->bv_len;
-			}
-		}
+		int blen = min_t(int, thislen, cmd->nleft);
 
-		if ((blk_fs_request(rq) && cmd->nleft == 0) ||
-		    (blk_fs_request(rq) == 0 && ptr == NULL)) {
+		if (cmd->nleft == 0) {
 			if (blk_fs_request(rq) && !write)
 				/*
 				 * If the buffers are full, pipe the rest into
@@ -755,33 +729,12 @@ static ide_startstop_t cdrom_newpc_intr(
 			break;
 		}
 
-		if (blen > thislen)
-			blen = thislen;
-
-		if (blk_fs_request(rq)) {
-			ide_pio_bytes(drive, cmd, write, blen);
-			cmd->last_xfer_len += blen;
-		} else
-			xferfunc(drive, NULL, ptr, blen);
+		ide_pio_bytes(drive, cmd, write, blen);
+		cmd->last_xfer_len += blen;
 
 		thislen -= blen;
 		len -= blen;
 
-		if (blk_fs_request(rq) == 0) {
-			rq->data_len -= blen;
-
-			/*
-			 * The request can't be completed until DRQ is cleared.
-			 * So complete the data, but don't complete the request
-			 * using the dummy function for the callback feature
-			 * of blk_end_request_callback().
-			 */
-			if (rq->bio)
-				blk_end_request_callback(rq, 0, blen,
-						 cdrom_newpc_intr_dummy_cb);
-			else
-				rq->data += blen;
-		}
 		if (sense && write == 0)
 			rq->sense_len += blen;
 	}
@@ -806,8 +759,7 @@ out_end:
 	if (blk_pc_request(rq) && rc == 0) {
 		unsigned int dlen = rq->data_len;
 
-		if (dma)
-			rq->data_len = 0;
+		rq->data_len = 0;
 
 		if (blk_end_request(rq, 0, dlen))
 			BUG();
@@ -820,13 +772,14 @@ out_end:
 		if (blk_fs_request(rq)) {
 			if (cmd->nleft == 0)
 				uptodate = 1;
-			if (uptodate == 0)
-				ide_cd_error_cmd(drive, cmd);
 		} else {
 			if (uptodate <= 0 && rq->errors == 0)
 				rq->errors = -EIO;
 		}
 
+		if (uptodate == 0)
+			ide_cd_error_cmd(drive, cmd);
+
 		/* make sure it's fully ended */
 		if (blk_pc_request(rq))
 			nsectors = (rq->data_len + 511) >> 9;
@@ -836,6 +789,12 @@ out_end:
 		if (nsectors == 0)
 			nsectors = 1;
 
+		if (blk_fs_request(rq) == 0) {
+			rq->data_len -= (cmd->nbytes - cmd->nleft);
+			if (uptodate == 0 && (cmd->tf_flags & IDE_TFLAG_WRITE))
+				rq->data_len += cmd->last_xfer_len;
+		}
+
 		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
 
 		if (sense && rc == 2)
@@ -963,10 +922,9 @@ static ide_startstop_t ide_cd_do_request
 
 	cmd.rq = rq;
 
-	if (blk_fs_request(rq)) {
-		ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
-		ide_map_sg(drive, &cmd);
-	}
+	ide_init_sg_cmd(&cmd,
+		blk_fs_request(rq) ? (rq->nr_sectors << 9) : rq->data_len);
+	ide_map_sg(drive, &cmd);
 
 	return ide_issue_pc(drive, &cmd);
 out_end:
