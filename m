Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZCMUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZCMUsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZCMUsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:48:05 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:48115 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZCMUsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=LnXOh/glNt9iIB+OZPpr+mFd4rqRLbNrA4aCAIn3TjKr3HP0dYtmC9DUQjBDraP9sY
         KP43/PnQAnMnrICwpx6xqT/z0/o+rO3sIH8VqlXRUd12JFquXf8JmQ9PK1eMH0RguBiw
         1M35L/PYa77yWGKAekMzNPL3tU7AgGGEGM5YA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 13 Mar 2009 21:49:12 +0100
Message-Id: <200903132149.12780.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

ide-floppy regression fix (from Borislav Petkov) and an important
bug fix for DMA mapping code (from FUJITA Tomonori).


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-atapi.c  |   12 ++++++++++++
 drivers/ide/ide-dma.c    |   12 +++++++++---
 drivers/ide/ide-floppy.c |    6 ++++--
 include/linux/ide.h      |    1 +
 4 files changed, 26 insertions(+), 5 deletions(-)


Borislav Petkov (1):
      ide-floppy: do not map dataless cmds to an sg

FUJITA Tomonori (1):
      ide: save the returned value of dma_map_sg


diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e96c012..e9d042d 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -140,6 +140,12 @@ static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->buffer = (char *)pc;
 	rq->rq_disk = disk;
+
+	if (pc->req_xfer) {
+		rq->data = pc->buf;
+		rq->data_len = pc->req_xfer;
+	}
+
 	memcpy(rq->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		rq->cmd[13] = REQ_IDETAPE_PC1;
@@ -159,6 +165,12 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->buffer = (char *)pc;
+
+	if (pc->req_xfer) {
+		rq->data = pc->buf;
+		rq->data_len = pc->req_xfer;
+	}
+
 	memcpy(rq->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		rq->cmd[13] = REQ_IDETAPE_PC1;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 72ebab0..059c90b 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -128,6 +128,7 @@ int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
+	int i;
 
 	ide_map_sg(drive, rq);
 
@@ -136,8 +137,13 @@ int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 	else
 		hwif->sg_dma_direction = DMA_TO_DEVICE;
 
-	return dma_map_sg(hwif->dev, sg, hwif->sg_nents,
-			  hwif->sg_dma_direction);
+	i = dma_map_sg(hwif->dev, sg, hwif->sg_nents, hwif->sg_dma_direction);
+	if (i) {
+		hwif->orig_sg_nents = hwif->sg_nents;
+		hwif->sg_nents = i;
+	}
+
+	return i;
 }
 EXPORT_SYMBOL_GPL(ide_build_sglist);
 
@@ -156,7 +162,7 @@ void ide_destroy_dmatable(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->sg_nents,
+	dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->orig_sg_nents,
 		     hwif->sg_dma_direction);
 }
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3eab1c6..317ec62 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -327,8 +327,10 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 
-	ide_init_sg_cmd(drive, rq);
-	ide_map_sg(drive, rq);
+	if (blk_fs_request(rq) || pc->req_xfer) {
+		ide_init_sg_cmd(drive, rq);
+		ide_map_sg(drive, rq);
+	}
 
 	pc->sg = hwif->sg_table;
 	pc->sg_cnt = hwif->sg_nents;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e0cedfe..25087ae 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -797,6 +797,7 @@ typedef struct hwif_s {
 	struct scatterlist *sg_table;
 	int sg_max_nents;		/* Maximum number of entries in it */
 	int sg_nents;			/* Current number of entries in it */
+	int orig_sg_nents;
 	int sg_dma_direction;		/* dma transfer direction */
 
 	/* data phase of the active command (currently only valid for PIO/DMA) */
