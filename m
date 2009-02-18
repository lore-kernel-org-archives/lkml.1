Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZBRTWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZBRTWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZBRTVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:21:39 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:14130 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbZBRTVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:21:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=QkFkXmkqs3bj9f/z2ovCT2hg4ACmxHSytm4ivCc9YPTiRH1c82RPpOLVLKXm86ZNoH
         E4rRSjAelR5/vptOS8FbAt0v8ATL1Rz+lEcEs8jVTHiRzlcOkAJtpuqDZDmdH44w7X9v
         rPg6XUgD9o9KcmKRLFHfevcu16m4YdTeQgjJY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide-floppy: use ide_pio_bytes()
Date: Wed, 18 Feb 2009 20:21:43 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090218; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182021.43377.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-floppy: use ide_pio_bytes()

* Fix ide_init_sg_cmd() setup for non-fs requests.

* Convert ide_pc_intr() to use ide_pio_bytes() for floppy media.

* Remove no longer needed ide_io_buffers() and sg/sg_cnt fields
  from struct ide_atapi_pc.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   57 +++++------------------------------------------
 drivers/ide/ide-floppy.c |    9 -------
 include/linux/ide.h      |    5 ----
 3 files changed, 8 insertions(+), 63 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -69,49 +69,6 @@ int ide_check_atapi_device(ide_drive_t *
 }
 EXPORT_SYMBOL_GPL(ide_check_atapi_device);
 
-/* PIO data transfer routine using the scatter gather table. */
-int ide_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		    unsigned int bcount, int write)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
-	struct scatterlist *sg = pc->sg;
-	char *buf;
-	int count, done = 0;
-
-	while (bcount) {
-		count = min(sg->length - pc->b_count, bcount);
-
-		if (PageHighMem(sg_page(sg))) {
-			unsigned long flags;
-
-			local_irq_save(flags);
-			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-			xf(drive, NULL, buf + pc->b_count, count);
-			kunmap_atomic(buf - sg->offset, KM_IRQ0);
-			local_irq_restore(flags);
-		} else {
-			buf = sg_virt(sg);
-			xf(drive, NULL, buf + pc->b_count, count);
-		}
-
-		bcount -= count;
-		pc->b_count += count;
-		done += count;
-
-		if (pc->b_count == sg->length) {
-			if (!--pc->sg_cnt)
-				break;
-			pc->sg = sg = sg_next(sg);
-			pc->b_count = 0;
-		}
-	}
-
-	return done;
-}
-EXPORT_SYMBOL_GPL(ide_io_buffers);
-
 void ide_init_pc(struct ide_atapi_pc *pc)
 {
 	memset(pc, 0, sizeof(*pc));
@@ -305,6 +262,7 @@ static ide_startstop_t ide_pc_intr(ide_d
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
+	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
@@ -426,14 +384,13 @@ static ide_startstop_t ide_pc_intr(ide_d
 
 	xferfunc = write ? tp_ops->output_data : tp_ops->input_data;
 
-	if ((drive->media == ide_floppy && !pc->buf) ||
-	    (drive->media == ide_tape && pc->bh)) {
-		done = drive->pc_io_buffers(drive, pc, bcount, write);
-
+	if (drive->media == ide_floppy && pc->buf == NULL) {
+		done = min_t(unsigned int, bcount, cmd->nleft);
+		ide_pio_bytes(drive, cmd, write, done);
 		/* FIXME: don't do partial completions */
-		if (drive->media == ide_floppy)
-			ide_complete_rq(drive, 0,
-					done ? done : ide_rq_bytes(rq));
+		ide_complete_rq(drive, 0, done ? done : ide_rq_bytes(rq));
+	} else if (drive->media == ide_tape && pc->bh) {
+		done = drive->pc_io_buffers(drive, pc, bcount, write);
 	} else {
 		done = min_t(unsigned int, bcount, pc->req_xfer - pc->xferred);
 		xferfunc(drive, NULL, pc->cur_pos, done);
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -213,7 +213,6 @@ static void idefloppy_create_rw_cmd(ide_
 	memcpy(rq->cmd, pc->c, 12);
 
 	pc->rq = rq;
-	pc->b_count = 0;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = NULL;
@@ -227,7 +226,6 @@ static void idefloppy_blockpc_cmd(struct
 	ide_init_pc(pc);
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
-	pc->b_count = 0;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = rq->data;
@@ -244,7 +242,6 @@ static ide_startstop_t ide_floppy_do_req
 					     struct request *rq, sector_t block)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	ide_hwif_t *hwif = drive->hwif;
 	struct ide_cmd cmd;
 	struct ide_atapi_pc *pc;
 
@@ -293,12 +290,9 @@ static ide_startstop_t ide_floppy_do_req
 
 	cmd.rq = rq;
 
-	ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
+	ide_init_sg_cmd(&cmd, pc->req_xfer);
 	ide_map_sg(drive, &cmd);
 
-	pc->sg = hwif->sg_table;
-	pc->sg_cnt = cmd.sg_nents;
-
 	pc->rq = rq;
 
 	return ide_floppy_issue_pc(drive, &cmd, pc);
@@ -484,7 +478,6 @@ static void ide_floppy_setup(ide_drive_t
 
 	drive->pc_callback	 = ide_floppy_callback;
 	drive->pc_update_buffers = idefloppy_update_buffers;
-	drive->pc_io_buffers	 = ide_io_buffers;
 
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -414,9 +414,6 @@ struct ide_atapi_pc {
 	struct idetape_bh *bh;
 	char *b_data;
 
-	struct scatterlist *sg;
-	unsigned int sg_cnt;
-
 	unsigned long timeout;
 };
 
@@ -1172,8 +1169,6 @@ void ide_tf_read(ide_drive_t *, struct i
 void ide_input_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 void ide_output_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 
-int ide_io_buffers(ide_drive_t *, struct ide_atapi_pc *, unsigned int, int);
-
 extern void SELECT_DRIVE(ide_drive_t *);
 void SELECT_MASK(ide_drive_t *, int);
 
