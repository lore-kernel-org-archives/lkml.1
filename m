Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYLPHgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYLPHgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYLPHgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:36:18 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:41035 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYLPHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:36:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=NKifyDcb8ODauxMC5nVKIJOgDoA01eBXPit+njxA/h/SYhni3pLhWXhNs8qLJxA36H
         Jz/wKgmuQNHV5ZAZOjwFfGND9iJr847ZXPmJYTs7dG1YjhOGZMA0NgxkH95w7bhMIhEl
         BrBwJOrJSc1rlYMkna8l3+E+sR76SIYAiGoEM=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/9] ide-atapi: remove PC_FLAG_WRITING atapi flag
Date: Tue, 16 Dec 2008 08:36:01 +0100
Message-Id: <1229412969-3552-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c        |   12 +++++++-----
 drivers/ide/ide-floppy.c       |    4 ----
 drivers/ide/ide-floppy_ioctl.c |    1 -
 drivers/ide/ide-tape.c         |    4 ++--
 include/linux/ide.h            |    3 +--
 5 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index d412bd2..2f0d5e7 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -296,11 +296,15 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
 	unsigned int timeout, temp;
+	int write = 0;
 	u16 bcount;
 	u8 stat, ireason, dsc = 0;
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
+	if (rq)
+		write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
+
 	timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
 					       : WAIT_TAPE_CMD;
 
@@ -389,8 +393,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 
-	if (((ireason & ATAPI_IO) == ATAPI_IO) ==
-		!!(pc->flags & PC_FLAG_WRITING)) {
+	if (((ireason & ATAPI_IO) == ATAPI_IO) == write) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
 				"to %s!\n", drive->name,
@@ -399,7 +402,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 
-	if (!(pc->flags & PC_FLAG_WRITING)) {
+	if (!write) {
 		/* Reading - Check that we have enough space */
 		temp = pc->xferred + bcount;
 		if (temp > pc->req_xfer) {
@@ -421,8 +424,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	if ((drive->media == ide_floppy && !pc->buf) ||
 	    (drive->media == ide_tape && pc->bh)) {
-		int done = drive->pc_io_buffers(drive, pc, bcount,
-				  !!(pc->flags & PC_FLAG_WRITING));
+		int done = drive->pc_io_buffers(drive, pc, bcount, write);
 
 		/* FIXME: don't do partial completions */
 		if (drive->media == ide_floppy)
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index fdec729..3ebe75a 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -254,8 +254,6 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 
 	pc->rq = rq;
 	pc->b_count = 0;
-	if (rq->cmd_flags & REQ_RW)
-		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = NULL;
 	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
 	pc->flags |= PC_FLAG_DMA_OK;
@@ -268,8 +266,6 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	pc->b_count = 0;
-	if (rq->data_len && rq_data_dir(rq) == WRITE)
-		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = rq->data;
 	if (rq->bio)
 		pc->flags |= PC_FLAG_DMA_OK;
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 8f8be85..513f651 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -109,7 +109,6 @@ static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
 	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
 	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
 	pc->buf_size = 12;
-	pc->flags |= PC_FLAG_WRITING;
 }
 
 static int ide_floppy_get_sfrp_bit(ide_drive_t *drive, struct ide_atapi_pc *pc)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ac9e29a..ba89d6a 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -373,10 +373,11 @@ static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct idetape_bh *bh = pc->bh;
+	struct request *rq = drive->hwif->hwgroup->rq;
 	int count;
 	unsigned int bcount = pc->xferred;
 
-	if (pc->flags & PC_FLAG_WRITING)
+	if (rq_data_dir(rq) == WRITE)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
@@ -774,7 +775,6 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 		atomic_set(&bh->b_count, 0);
 	} else if (opcode == WRITE_6) {
 		pc->c[0] = WRITE_6;
-		pc->flags |= PC_FLAG_WRITING;
 		pc->b_data = bh->b_data;
 		pc->b_count = atomic_read(&bh->b_count);
 	}
diff --git a/include/linux/ide.h b/include/linux/ide.h
index ad57a44..2041073 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -386,9 +386,8 @@ enum {
 	PC_FLAG_DMA_OK			= (1 << 3),
 	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
 	PC_FLAG_DMA_ERROR		= (1 << 5),
-	PC_FLAG_WRITING			= (1 << 6),
 	/* command timed out */
-	PC_FLAG_TIMEDOUT		= (1 << 7),
+	PC_FLAG_TIMEDOUT		= (1 << 6),
 };
 
 /*
-- 
1.6.0.4

