Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYLPHjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYLPHjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYLPHg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:36:29 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63077 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYLPHgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:36:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=fjwQNn45fLRM1YPOcxf8QwiVovQh9MTLfFf9eVye10VYv9kGFpBxRiyli3RByEkdp1
         czaghjjLUgvyiL/e/cFV6PppJoSLjiIvyOwXumSSH2Ew3cEY4xzoBgsRV2A+0aZC1gZY
         i3HJzWjQt6gs6mLcAfwLP33UQD4e6zguqV2gc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 5/9] ide-atapi: replace pc->buf_size with drive->pc_buf_size
Date: Tue, 16 Dec 2008 08:36:05 +0100
Message-Id: <1229412969-3552-6-git-send-email-petkovbb@gmail.com>
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
 drivers/ide/ide-atapi.c        |    4 ++--
 drivers/ide/ide-floppy.c       |    4 ++--
 drivers/ide/ide-floppy_ioctl.c |    2 +-
 drivers/ide/ide-tape.c         |    4 ++--
 include/linux/ide.h            |    1 +
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 1b4d157..f299d8e 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -121,7 +121,7 @@ void ide_init_pc(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	memset(pc, 0, sizeof(*pc));
 	pc->buf = pc->pc_buf;
-	pc->buf_size = IDE_PC_BUFFER_SIZE;
+	drive->pc_buf_size = IDE_PC_BUFFER_SIZE;
 	drive->pc_flags = 0;
 	drive->pc_req_xfer = 0;
 }
@@ -418,7 +418,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		/* Reading - Check that we have enough space */
 		temp = rq->data_len + bcount;
 		if (temp > drive->pc_req_xfer) {
-			if (temp > pc->buf_size) {
+			if (temp > drive->pc_buf_size) {
 
 				printk(KERN_ERR "%s: The device wants to send "
 						"us more data than expected - "
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 99f0c49..0977229 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -258,7 +258,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	pc->b_count = 0;
 	rq->data = NULL;
 	rq->data_len = 0;
-	drive->pc_req_xfer = pc->buf_size = blocks * floppy->block_size;
+	drive->pc_req_xfer = drive->pc_buf_size = blocks * floppy->block_size;
 	drive->pc_flags |= PC_FLAG_DMA_OK;
 }
 
@@ -276,7 +276,7 @@ static void idefloppy_blockpc_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
 	 */
-	drive->pc_req_xfer = pc->buf_size = rq->data_len;
+	drive->pc_req_xfer = drive->pc_buf_size = rq->data_len;
 }
 
 static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 88e14e4..1316271 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -109,7 +109,7 @@ static void ide_floppy_create_format_unit_cmd(ide_drive_t *drive,
 
 	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
 	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
-	pc->buf_size = 12;
+	drive->pc_buf_size = 12;
 }
 
 static int ide_floppy_get_sfrp_bit(ide_drive_t *drive, struct ide_atapi_pc *pc)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 35a41e2..fef9a78 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -767,8 +767,8 @@ static void ide_tape_create_rw_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	pc->c[1] = 1;
 	pc->bh = bh;
 	pc->buf = NULL;
-	pc->buf_size = length * tape->blk_size;
-	drive->pc_req_xfer = pc->buf_size;
+	drive->pc_buf_size = length * tape->blk_size;
+	drive->pc_req_xfer = drive->pc_buf_size;
 	if (drive->pc_req_xfer == tape->buffer_size)
 		drive->pc_flags |= PC_FLAG_DMA_OK;
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 7874ac5..dac382b 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -657,6 +657,7 @@ struct ide_drive_s {
 	/* atapi pc members: temporarily harbored here */
 	unsigned long pc_flags;
 	int pc_req_xfer;
+	int pc_buf_size;
 
 	/* callback for packet commands */
 	void (*pc_callback)(struct ide_drive_s *, int);
-- 
1.6.0.4

