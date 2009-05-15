Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbZEOFOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbZEOFOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZEOFLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:11:54 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:38151 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbZEOFLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q8OtIJg4kaB1aVSffXHbSDit+CvCd/TmsrrLlPpu7p0yXsBa1Co7NiRVqbCDLDVtpF
         orgid+/dG3Dx59BVu+rKUXX5ygS8S4NDs8y/ZKWIWvX56dVDzuTy3V5YJhfZOWMmr5yJ
         HaWEDpmqmzsU9+ATt1v+oV8LDTGX2mLEcmz7g=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] ide-atapi: remove pc->buf
Date: Fri, 15 May 2009 07:11:31 +0200
Message-Id: <1242364293-29223-14-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now after all users of pc->buf have been converted, remove the 64B buffer
embedded in each packet command.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c        |    6 ------
 drivers/ide/ide-floppy.c       |    8 +-------
 drivers/ide/ide-floppy_ioctl.c |    1 -
 drivers/ide/ide-tape.c         |    7 ++-----
 include/linux/ide.h            |   11 -----------
 5 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 66ea1e7..3075b04 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -74,8 +74,6 @@ EXPORT_SYMBOL_GPL(ide_check_atapi_device);
 void ide_init_pc(struct ide_atapi_pc *pc)
 {
 	memset(pc, 0, sizeof(*pc));
-	pc->buf = pc->pc_buf;
-	pc->buf_size = IDE_PC_BUFFER_SIZE;
 }
 EXPORT_SYMBOL_GPL(ide_init_pc);
 
@@ -254,10 +252,6 @@ void ide_retry_pc(ide_drive_t *drive)
 	ide_init_pc(pc);
 	memcpy(pc->c, sense_rq->cmd, 12);
 
-	/* pointer to mapped address */
-	pc->buf = bio_data(sense_rq->bio);
-	pc->req_xfer = blk_rq_bytes(sense_rq);
-
 	if (drive->media == ide_tape)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 14e5e9c..800c83a 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -210,8 +210,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	pc->rq = rq;
 	if (rq->cmd_flags & REQ_RW)
 		pc->flags |= PC_FLAG_WRITING;
-	pc->buf = NULL;
-	pc->buf_size = blk_rq_bytes(rq);
+
 	pc->flags |= PC_FLAG_DMA_OK;
 }
 
@@ -226,9 +225,6 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 		if (rq_data_dir(rq) == WRITE)
 			pc->flags |= PC_FLAG_WRITING;
 	}
-	/* pio will be performed by ide_pio_bytes() which handles sg fine */
-	pc->buf = NULL;
-	pc->buf_size = blk_rq_bytes(rq);
 }
 
 static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
@@ -388,8 +384,6 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	drive->capacity64 = 0;
 
 	ide_floppy_create_read_capacity_cmd(&pc);
-	pc.buf_size = sizeof(pc_buf);
-
 	if (ide_queue_pc_tail(drive, disk, &pc, pc_buf, pc.req_xfer)) {
 		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 3a1f9b5..9c22882 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -47,7 +47,6 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive,
 		return -EINVAL;
 
 	ide_floppy_create_read_capacity_cmd(pc);
-	pc->buf_size = sizeof(pc_buf);
 
 	if (ide_queue_pc_tail(drive, floppy->disk, pc, pc_buf, pc->req_xfer)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ead2734..9ca2665 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -568,9 +568,8 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->buf = NULL;
-	pc->buf_size = blk_rq_bytes(rq);
-	if (pc->buf_size == tape->buffer_size)
+
+	if (blk_rq_bytes(rq) == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_OK;
 
 	if (opcode == READ_6)
@@ -1608,8 +1607,6 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	char fw_rev[4], vendor_id[8], product_id[16];
 
 	idetape_create_inquiry_cmd(&pc);
-	pc.buf_size = sizeof(pc_buf);
-
 	if (ide_queue_pc_tail(drive, tape->disk, &pc, pc_buf, pc.req_xfer)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 4cd7157..59aedcd 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -341,11 +341,6 @@ enum {
 	PC_FLAG_WRITING			= (1 << 6),
 };
 
-/*
- * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
- * This is used for several packet commands (not for READ/WRITE commands).
- */
-#define IDE_PC_BUFFER_SIZE	64
 #define ATAPI_WAIT_PC		(60 * HZ)
 
 struct ide_atapi_pc {
@@ -358,10 +353,6 @@ struct ide_atapi_pc {
 	/* bytes to transfer */
 	int req_xfer;
 
-	/* data buffer */
-	u8 *buf;
-	int buf_size;
-
 	/* the corresponding request */
 	struct request *rq;
 
@@ -371,8 +362,6 @@ struct ide_atapi_pc {
 	 * those are more or less driver-specific and some of them are subject
 	 * to change/removal later.
 	 */
-	u8 pc_buf[IDE_PC_BUFFER_SIZE];
-
 	unsigned long timeout;
 };
 
-- 
1.6.3

