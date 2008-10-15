Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYJOTwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYJOTwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYJOTuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:50:39 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:59673 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbYJOTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=pA1uQ0/vlf+McGULgAy34fXY14Mt5qDJBQbVHnuztz2JWD6xK1yYOifA5jpm4ufZzX
         fdJnZ6yoX+PdsX05XPGl3F9rXpPjOc+3wFOok4KDQm7lg3QdpyobCina1vNkhksJf5PN
         ZSvFrO+WexAbTh9S6sOwWkRpF+U6sgoxtUZ+s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-cd: remove obsolete seek optimization
Date: Wed, 15 Oct 2008 21:47:47 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810152147.47534.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make much sense nowadays and is problematic on some drives.

Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against pata tree

 drivers/ide/ide-cd.c |   89 +++------------------------------------------------
 drivers/ide/ide-cd.h |    2 -
 include/linux/ide.h  |    4 --
 3 files changed, 6 insertions(+), 89 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -774,52 +774,6 @@ static ide_startstop_t cdrom_start_rw_co
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
-#define IDECD_SEEK_THRESHOLD	(1000)			/* 1000 blocks */
-#define IDECD_SEEK_TIMER	(5 * WAIT_MIN_SLEEP)	/* 100 ms */
-#define IDECD_SEEK_TIMEOUT	(2 * WAIT_CMD)		/* 20 sec */
-
-static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
-{
-	struct cdrom_info *info = drive->driver_data;
-	int stat;
-	static int retry = 10;
-
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
-
-	if (cdrom_decode_status(drive, 0, &stat))
-		return ide_stopped;
-
-	drive->atapi_flags |= IDE_AFLAG_SEEKING;
-
-	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
-		if (--retry == 0)
-			drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
-	}
-	return ide_stopped;
-}
-
-static void ide_cd_prepare_seek_request(ide_drive_t *drive, struct request *rq)
-{
-	sector_t frame = rq->sector;
-
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
-
-	sector_div(frame, queue_hardsect_size(drive->queue) >> SECTOR_BITS);
-
-	memset(rq->cmd, 0, BLK_MAX_CDB);
-	rq->cmd[0] = GPCMD_SEEK;
-	put_unaligned(cpu_to_be32(frame), (unsigned int *) &rq->cmd[2]);
-
-	rq->timeout = ATAPI_WAIT_PC;
-}
-
-static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
-{
-	struct request *rq = drive->hwif->hwgroup->rq;
-
-	return cdrom_transfer_packet_command(drive, rq, &cdrom_seek_intr);
-}
-
 /*
  * Fix up a possibly partially-processed request so that we can start it over
  * entirely, or even put it back on the request queue.
@@ -1259,7 +1213,6 @@ static void cdrom_do_block_pc(ide_drive_
 static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
-	struct cdrom_info *info = drive->driver_data;
 	ide_handler_t *fn;
 	int xferlen;
 
@@ -1269,44 +1222,14 @@ static ide_startstop_t ide_cd_do_request
 		      (unsigned long long)block);
 
 	if (blk_fs_request(rq)) {
-		if (drive->atapi_flags & IDE_AFLAG_SEEKING) {
-			ide_hwif_t *hwif = drive->hwif;
-			unsigned long elapsed = jiffies - info->start_seek;
-			int stat = hwif->tp_ops->read_status(hwif);
-
-			if ((stat & ATA_DSC) != ATA_DSC) {
-				if (elapsed < IDECD_SEEK_TIMEOUT) {
-					ide_stall_queue(drive,
-							IDECD_SEEK_TIMER);
-					return ide_stopped;
-				}
-				printk(KERN_ERR PFX "%s: DSC timeout\n",
-						drive->name);
-			}
-			drive->atapi_flags &= ~IDE_AFLAG_SEEKING;
-		}
-		if (rq_data_dir(rq) == READ &&
-		    IDE_LARGE_SEEK(info->last_block, block,
-			    IDECD_SEEK_THRESHOLD) &&
-		    (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP)) {
-			xferlen = 0;
-			fn = cdrom_start_seek_continuation;
-
-			drive->dma = 0;
-			info->start_seek = jiffies;
-
-			ide_cd_prepare_seek_request(drive, rq);
-		} else {
-			xferlen = 32768;
-			fn = cdrom_start_rw_cont;
+		xferlen = 32768;
+		fn = cdrom_start_rw_cont;
 
-			if (cdrom_start_rw(drive, rq) == ide_stopped)
-				return ide_stopped;
+		if (cdrom_start_rw(drive, rq) == ide_stopped)
+			return ide_stopped;
 
-			if (ide_cd_prepare_rw_request(drive, rq) == ide_stopped)
-				return ide_stopped;
-		}
-		info->last_block = block;
+		if (ide_cd_prepare_rw_request(drive, rq) == ide_stopped)
+			return ide_stopped;
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		xferlen = rq->data_len;
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -88,8 +88,6 @@ struct cdrom_info {
 	struct request_sense sense_data;
 
 	struct request request_sense_request;
-	unsigned long last_block;
-	unsigned long start_seek;
 
 	u8 max_speed;		/* Max speed of the drive. */
 	u8 current_speed;	/* Current speed of the drive. */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -122,8 +122,6 @@ struct ide_io_ports {
 #define MAX_DRIVES	2	/* per interface; 2 assumed by lots of code */
 #define SECTOR_SIZE	512
 
-#define IDE_LARGE_SEEK(b1,b2,t)	(((b1) > (b2) + (t)) || ((b2) > (b1) + (t)))
-
 /*
  * Timeouts for various operations:
  */
@@ -496,8 +494,6 @@ enum {
 	 * when more than one interrupt is needed.
 	 */
 	IDE_AFLAG_LIMIT_NFRAMES		= (1 << 7),
-	/* Seeking in progress. */
-	IDE_AFLAG_SEEKING		= (1 << 8),
 	/* Saved TOC information is current. */
 	IDE_AFLAG_TOC_VALID		= (1 << 9),
 	/* We think that the drive door is locked. */
