Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbZCHRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbZCHRGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 13:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZCHRGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 13:06:10 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:64651 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZCHRGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 13:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=xDG/bL3aKgb/dKC+luVRU0f0YuuNWo/VsKr4wWivv+JvZHJ09j+vI1BqYDIai348f6
         dZi/NXwhZ/MSFez15ClkcfIXuhGM9AbpkwAIXqJd2cI5j8o6RPha33aeJzn8PSEbSR5f
         k/Gxxbowbwjq53Z/tMK870IbEZU3rwYmIjS6E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
Date: Sun, 8 Mar 2009 18:08:05 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090306; KDE/4.2.0; i686; ; )
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com> <200903051752.41611.bzolnier@gmail.com> <20090308075338.GB4078@liondog.tnic>
In-Reply-To: <20090308075338.GB4078@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903081808.05448.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Borislav Petkov wrote:

[...]

> > Wait... it makes things "worse" as there should have been 3 patches:
> > (IOW _three_ patchpoints! ;):
> > 
> > - ide-cd fix for problematic patch
> 
> see below

Ok, I folded it into the original patch (attached).

> > - ide-floppy fix for mainline
> 
> ide-floppy is still royally broken when reading the partition
> information - I've been staring at traces for a while yesterday and
> it looks pretty hairy. What is more, it needs that same fix for
> DEBUG_VIRTUAL as ide-cd since I could reproduce it yesterday. Do you
> still want that for the merge window or you wanna wait until its
> properly fixed?

If the mainline is broken sg fix can wait but to be honest I don't see much
point in delaying it (it is an independent problem and the bugfix should be
a completely safe one-liner).

> > - ide-atapi cleanup for pata tree
> 
> postponed for now.

Ok...

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: use scatterlists for PIO transfers (non-fs requests) (v2)

Convert ide-cd to use scatterlists for PIO transfers and get rid of
partial completions (except on error) also for non-fs requests.

v2:
Do not map dataless commands to an sg since it oopses on the virt_to_page()
translation check when DEBUG_VIRTUAL is enabled.  (from Borislav Petkov,
reported/bisected-by Tetsuo Handa).

Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch for the one in pata tree / linux-next

 drivers/ide/ide-cd.c |  100 +++++++++++++++------------------------------------
 1 file changed, 30 insertions(+), 70 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -509,8 +509,10 @@ static int ide_cd_check_ireason(ide_driv
 	return -1;
 }
 
-static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
+static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
+	struct request *rq = cmd->rq;
+
 	ide_debug_log(IDE_DBG_FUNC, "rq->cmd[0]: 0x%x", rq->cmd[0]);
 
 	/*
@@ -518,11 +520,14 @@ static void ide_cd_request_sense_fixup(i
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
@@ -613,22 +618,11 @@ static void ide_cd_error_cmd(ide_drive_t
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
@@ -678,7 +672,7 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	ide_read_bcount_and_ireason(drive, &len, &ireason);
 
-	thislen = blk_fs_request(rq) ? len : rq->data_len;
+	thislen = blk_fs_request(rq) ? len : cmd->nleft;
 	if (thislen > len)
 		thislen = len;
 
@@ -702,9 +696,9 @@ static ide_startstop_t cdrom_newpc_intr(
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
@@ -718,35 +712,15 @@ static ide_startstop_t cdrom_newpc_intr(
 
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
@@ -763,33 +737,12 @@ static ide_startstop_t cdrom_newpc_intr(
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
@@ -814,8 +767,7 @@ out_end:
 	if (blk_pc_request(rq) && rc == 0) {
 		unsigned int dlen = rq->data_len;
 
-		if (dma)
-			rq->data_len = 0;
+		rq->data_len = 0;
 
 		if (blk_end_request(rq, 0, dlen))
 			BUG();
@@ -828,13 +780,14 @@ out_end:
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
@@ -844,6 +797,12 @@ out_end:
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
@@ -971,8 +930,9 @@ static ide_startstop_t ide_cd_do_request
 
 	cmd.rq = rq;
 
-	if (blk_fs_request(rq)) {
-		ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
+	if (blk_fs_request(rq) || rq->data_len) {
+		ide_init_sg_cmd(&cmd, blk_fs_request(rq) ? (rq->nr_sectors << 9)
+							 : rq->data_len);
 		ide_map_sg(drive, &cmd);
 	}
 
