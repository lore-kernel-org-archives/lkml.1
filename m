Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZCDJRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZCDJRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZCDJRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:17:09 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:48944 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbZCDJRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:17:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iPwMQ/KQCJJKMRH4hZyiV+px9f7Cnv7tAdzYQhGI8gta0uGznyN4UFRZYuplara34v
         nxAJYJn66QU1mW9Xz9ocRBboFakGV1XSPywtmEgyVv4zar22DnJ4xzS/L4T26KzubcgQ
         S5KghbYwurRfu57g6JVQ1vjlq/NHaPwX1p3zM=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/3] ide-floppy: use ide_pio_bytes()
Date: Wed,  4 Mar 2009 10:16:55 +0100
Message-Id: <1236158216-23052-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236158216-23052-1-git-send-email-petkovbb@gmail.com>
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

* Fix ide_init_sg_cmd() setup for non-fs requests.

* Convert ide_pc_intr() to use ide_pio_bytes() for floppy media.

* Remove no longer needed ide_io_buffers() and sg/sg_cnt fields
  from struct ide_atapi_pc.

* Remove partial completions; kill idefloppy_update_buffers(), as a
  result.

* Add some more debugging statements.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |   68 +++++++++++-----------------------------------
 drivers/ide/ide-floppy.c |   24 +++-------------
 include/linux/ide.h      |    5 ---
 3 files changed, 21 insertions(+), 76 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 314e6af..a5596a6 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -69,49 +69,6 @@ int ide_check_atapi_device(ide_drive_t *drive, const char *s)
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
@@ -339,6 +296,9 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			pc->xferred = pc->req_xfer;
 			if (drive->pc_update_buffers)
 				drive->pc_update_buffers(drive, pc);
+
+			if (drive->media == ide_floppy)
+				ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 		}
 		debug_log("%s: DMA finished\n", drive->name);
 	}
@@ -394,12 +354,19 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			rq->errors = 0;
 			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 		} else {
+			unsigned int done;
+
 			if (blk_fs_request(rq) == 0 && uptodate <= 0) {
 				if (rq->errors == 0)
 					rq->errors = -EIO;
 			}
-			ide_complete_rq(drive, uptodate ? 0 : -EIO,
-					ide_rq_bytes(rq));
+
+			if (drive->media == ide_tape)
+				done = ide_rq_bytes(rq); /* FIXME */
+			else
+				done = blk_rq_bytes(rq);
+
+			ide_complete_rq(drive, uptodate ? 0 : -EIO, done);
 		}
 
 		return ide_stopped;
@@ -432,14 +399,11 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	xferfunc = write ? tp_ops->output_data : tp_ops->input_data;
 
-	if ((drive->media == ide_floppy && !pc->buf) ||
-	    (drive->media == ide_tape && pc->bh)) {
+	if (drive->media == ide_floppy && pc->buf == NULL) {
+		done = min_t(unsigned int, bcount, cmd->nleft);
+		ide_pio_bytes(drive, cmd, write, done);
+	} else if (drive->media == ide_tape && pc->bh) {
 		done = drive->pc_io_buffers(drive, pc, bcount, write);
-
-		/* FIXME: don't do partial completions */
-		if (drive->media == ide_floppy)
-			ide_complete_rq(drive, 0,
-					done ? done : ide_rq_bytes(rq));
 	} else {
 		done = min_t(unsigned int, bcount, pc->req_xfer - pc->xferred);
 		xferfunc(drive, NULL, pc->cur_pos, done);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 50d918a..2f8f453 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -61,16 +61,6 @@
  */
 #define IDEFLOPPY_PC_DELAY	(HZ/20)	/* default delay for ZIP 100 (50ms) */
 
-static void idefloppy_update_buffers(ide_drive_t *drive,
-				struct ide_atapi_pc *pc)
-{
-	struct request *rq = pc->rq;
-	struct bio *bio = rq->bio;
-
-	while ((bio = rq->bio) != NULL)
-		ide_complete_rq(drive, 0, ide_rq_bytes(rq));
-}
-
 static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
@@ -213,7 +203,6 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	memcpy(rq->cmd, pc->c, 12);
 
 	pc->rq = rq;
-	pc->b_count = 0;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = NULL;
@@ -227,7 +216,6 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 	ide_init_pc(pc);
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
-	pc->b_count = 0;
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = rq->data;
@@ -244,10 +232,11 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 					     struct request *rq, sector_t block)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	ide_hwif_t *hwif = drive->hwif;
 	struct ide_cmd cmd;
 	struct ide_atapi_pc *pc;
 
+	ide_debug_log(IDE_DBG_FUNC, "enter, cmd: 0x%x\n", rq->cmd[0]);
+
 	if (drive->debug_mask & IDE_DBG_RQ)
 		blk_dump_rq_flags(rq, (rq->rq_disk
 					? rq->rq_disk->disk_name
@@ -293,12 +282,9 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 
 	cmd.rq = rq;
 
-	ide_init_sg_cmd(&cmd, rq->nr_sectors << 9);
+	ide_init_sg_cmd(&cmd, pc->req_xfer);
 	ide_map_sg(drive, &cmd);
 
-	pc->sg = hwif->sg_table;
-	pc->sg_cnt = cmd.sg_nents;
-
 	pc->rq = rq;
 
 	return ide_floppy_issue_pc(drive, &cmd, pc);
@@ -386,6 +372,8 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	u8 pc_buf[256], header_len, desc_cnt;
 	int i, rc = 1, blocks, length;
 
+	ide_debug_log(IDE_DBG_FUNC, "enter");
+
 	drive->bios_cyl = 0;
 	drive->bios_head = drive->bios_sect = 0;
 	floppy->blocks = 0;
@@ -486,8 +474,6 @@ static void ide_floppy_setup(ide_drive_t *drive)
 	u16 *id = drive->id;
 
 	drive->pc_callback	 = ide_floppy_callback;
-	drive->pc_update_buffers = idefloppy_update_buffers;
-	drive->pc_io_buffers	 = ide_io_buffers;
 
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e53f820..09bc586 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -415,9 +415,6 @@ struct ide_atapi_pc {
 	struct idetape_bh *bh;
 	char *b_data;
 
-	struct scatterlist *sg;
-	unsigned int sg_cnt;
-
 	unsigned long timeout;
 };
 
@@ -1175,8 +1172,6 @@ void ide_tf_read(ide_drive_t *, struct ide_cmd *);
 void ide_input_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 void ide_output_data(ide_drive_t *, struct ide_cmd *, void *, unsigned int);
 
-int ide_io_buffers(ide_drive_t *, struct ide_atapi_pc *, unsigned int, int);
-
 extern void SELECT_DRIVE(ide_drive_t *);
 void SELECT_MASK(ide_drive_t *, int);
 
-- 
1.6.1.3

