Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYINLhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYINLhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYINLgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3871 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYINLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=v4jEwlPLQbeY+P4z1E5dd3QDXko9MFUPUVRChp7x47lYRQejZQJybwnW9fSbQ4dtY0
         CyH0tbSZh2n/GpqzUi9FaeIAj10gbLQb2AS8mB/R8HQ+fGA3GJyJa2l0KFu4aA3hN1DG
         AhS5ZuNfXXf20kvooaEKcj6K2+r1m/xCO6ghk=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 02/10] ide-cd: move cdrom_info.dma to ide_drive_t.dma
Date: Sun, 14 Sep 2008 13:35:50 +0200
Message-Id: <1221392158-3848-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   32 ++++++++++++++------------------
 drivers/ide/ide-cd.h |    1 -
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 24d1e69..6258c5f 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -556,22 +556,21 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 						  int xferlen,
 						  ide_handler_t *handler)
 {
-	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 
 	ide_debug_log(IDE_DBG_PC, "Call %s, xferlen: %d\n", __func__, xferlen);
 
 	/* FIXME: for Virtual DMA we must check harder */
-	if (info->dma)
-		info->dma = !hwif->dma_ops->dma_setup(drive);
+	if (drive->dma)
+		drive->dma = !hwif->dma_ops->dma_setup(drive);
 
 	/* set up the controller registers */
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
-			   xferlen, info->dma);
+			   xferlen, drive->dma);
 
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		/* waiting for CDB interrupt, not DMA yet. */
-		if (info->dma)
+		if (drive->dma)
 			drive->waiting_for_dma = 0;
 
 		/* packet command */
@@ -598,7 +597,6 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 {
 	ide_hwif_t *hwif = drive->hwif;
 	int cmd_len;
-	struct cdrom_info *info = drive->driver_data;
 	ide_startstop_t startstop;
 
 	ide_debug_log(IDE_DBG_PC, "Call %s\n", __func__);
@@ -614,7 +612,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 			return ide_stopped;
 
 		/* ok, next interrupt will be DMA interrupt */
-		if (info->dma)
+		if (drive->dma)
 			drive->waiting_for_dma = 1;
 	} else {
 		/* otherwise, we must wait for DRQ to get set */
@@ -635,7 +633,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
 
 	/* start the DMA if need be */
-	if (info->dma)
+	if (drive->dma)
 		hwif->dma_ops->dma_start(drive);
 
 	return ide_started;
@@ -949,7 +947,6 @@ static int cdrom_newpc_intr_dummy_cb(struct request *rq)
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct cdrom_info *info = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
@@ -963,9 +960,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		      __func__, rq->cmd[0], write);
 
 	/* check for errors */
-	dma = info->dma;
+	dma = drive->dma;
 	if (dma) {
-		info->dma = 0;
+		drive->dma = 0;
 		dma_error = hwif->dma_ops->dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR PFX "%s: DMA %s error\n", drive->name,
@@ -1198,9 +1195,9 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 			cdrom_end_request(drive, 0);
 			return ide_stopped;
 		}
-		cd->dma = 0;
+		drive->dma = 0;
 	} else
-		cd->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 	if (write)
 		cd->devinfo.media_written = 1;
@@ -1217,7 +1214,6 @@ static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
 
 static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 {
-	struct cdrom_info *info = drive->driver_data;
 
 	ide_debug_log(IDE_DBG_PC, "Call %s, rq->cmd_type: 0x%x\n", __func__,
 		      rq->cmd_type);
@@ -1227,7 +1223,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	else
 		rq->cmd_flags &= ~REQ_FAILED;
 
-	info->dma = 0;
+	drive->dma = 0;
 
 	/* sg request */
 	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
@@ -1240,7 +1236,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		else
 			buf = rq->data;
 
-		info->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
 		/*
 		 * check if dma is safe
@@ -1251,7 +1247,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 		if ((unsigned long)buf & alignment || rq->data_len & alignment
 		    || object_is_on_stack(buf))
-			info->dma = 0;
+			drive->dma = 0;
 	}
 }
 
@@ -1292,7 +1288,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 			xferlen = 0;
 			fn = cdrom_start_seek_continuation;
 
-			info->dma = 0;
+			drive->dma = 0;
 			info->start_seek = jiffies;
 
 			ide_cd_prepare_seek_request(drive, rq);
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 61a4599..5882b9a 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -88,7 +88,6 @@ struct cdrom_info {
 	struct request_sense sense_data;
 
 	struct request request_sense_request;
-	int dma;
 	unsigned long last_block;
 	unsigned long start_seek;
 
-- 
1.5.5.1

