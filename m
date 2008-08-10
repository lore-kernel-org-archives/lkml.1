Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbYHJPkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbYHJPkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYHJPiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:38:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:10683 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYHJPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RelpdjssaDDvGU0iGFqJMaXVH46DJWrCox1TvocxXnbegbj3wPcQtZ66e8tmGZ07WO
         io8KMeOvu6gqkhA0td2C28jBxqU07BkxU5PGqIHMmSaIyX2xHJcFXcUGd7OErv3Wg94y
         odcvoLkYtslZAL0+a72/Drv/92KLnRNf0/+Us=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:36:09 +0200
Message-Id: <20080810153609.16255.47218.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/22] ide: add ide_init_pc() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add IDE_PC_BUFFER_SIZE define.

* Add ide_init_pc() and convert ide-{floppy,tape}.c to use it
  instead of ide*_init_pc().

* Remove no longer used IDE*_PC_BUFFER_SIZE and ide*_init_pc().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |    8 ++++++++
 drivers/ide/ide-floppy.c |   31 +++++++++----------------------
 drivers/ide/ide-tape.c   |   44 +++++++++++++-------------------------------
 include/linux/ide.h      |   10 +++++++++-
 4 files changed, 39 insertions(+), 54 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -111,6 +111,14 @@ int ide_io_buffers(ide_drive_t *drive, s
 }
 EXPORT_SYMBOL_GPL(ide_io_buffers);
 
+void ide_init_pc(struct ide_atapi_pc *pc)
+{
+	memset(pc, 0, sizeof(*pc));
+	pc->buf = pc->pc_buf;
+	pc->buf_size = IDE_PC_BUFFER_SIZE;
+}
+EXPORT_SYMBOL_GPL(ide_init_pc);
+
 /* TODO: unify the code thus making some arguments go away */
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -68,12 +68,6 @@
  */
 #define IDEFLOPPY_MAX_PC_RETRIES	3
 
-/*
- * With each packet command, we allocate a buffer of IDEFLOPPY_PC_BUFFER_SIZE
- * bytes.
- */
-#define IDEFLOPPY_PC_BUFFER_SIZE	256
-
 /* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
 #define CAPACITY_UNFORMATTED	0x01
@@ -273,16 +267,9 @@ static void ide_floppy_callback(ide_driv
 	idefloppy_end_request(drive, uptodate, 0);
 }
 
-static void idefloppy_init_pc(struct ide_atapi_pc *pc)
-{
-	memset(pc, 0, sizeof(*pc));
-	pc->buf = pc->pc_buf;
-	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
-}
-
 static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
 	pc->req_xfer = 18;
@@ -412,14 +399,14 @@ static void idefloppy_create_prevent_cmd
 {
 	debug_log("creating prevent removal command, prevent = %d\n", prevent);
 
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
 }
 
 static void idefloppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
 {
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
 	pc->c[7] = 255;
 	pc->c[8] = 255;
@@ -429,7 +416,7 @@ static void idefloppy_create_read_capaci
 static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
 		int l, int flags)
 {
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
@@ -453,7 +440,7 @@ static void idefloppy_create_mode_sense_
 {
 	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
 
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_MODE_SENSE_10;
 	pc->c[1] = 0;
 	pc->c[2] = page_code;
@@ -475,7 +462,7 @@ static void idefloppy_create_mode_sense_
 
 static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start)
 {
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = GPCMD_START_STOP_UNIT;
 	pc->c[4] = start;
 }
@@ -491,7 +478,7 @@ static void idefloppy_create_rw_cmd(idef
 	debug_log("create_rw10_cmd: block == %d, blocks == %d\n",
 		block, blocks);
 
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
@@ -510,7 +497,7 @@ static void idefloppy_create_rw_cmd(idef
 static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
 		struct ide_atapi_pc *pc, struct request *rq)
 {
-	idefloppy_init_pc(pc);
+	ide_init_pc(pc);
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	pc->b_count = 0;
@@ -1070,7 +1057,7 @@ static int idefloppy_open(struct inode *
 		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
-		idefloppy_init_pc(&pc);
+		ide_init_pc(&pc);
 		pc.c[0] = GPCMD_TEST_UNIT_READY;
 
 		if (idefloppy_queue_pc_tail(drive, &pc)) {
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -81,12 +81,6 @@ enum {
 #define IDETAPE_MAX_PC_RETRIES		3
 
 /*
- * With each packet command, we allocate a buffer of IDETAPE_PC_BUFFER_SIZE
- * bytes. This is used for several packet commands (Not for READ/WRITE commands)
- */
-#define IDETAPE_PC_BUFFER_SIZE		256
-
-/*
  * Some drives (for example, Seagate STT3401A Travan) require a very long
  * timeout, because they don't return an interrupt or clear their busy bit
  * until after the command completes (even retension commands).
@@ -610,21 +604,9 @@ static void ide_tape_callback(ide_drive_
 	idetape_end_request(drive, uptodate, 0);
 }
 
-static void idetape_init_pc(struct ide_atapi_pc *pc)
-{
-	memset(pc->c, 0, 12);
-	pc->retries = 0;
-	pc->flags = 0;
-	pc->req_xfer = 0;
-	pc->buf = pc->pc_buf;
-	pc->buf_size = IDETAPE_PC_BUFFER_SIZE;
-	pc->bh = NULL;
-	pc->b_data = NULL;
-}
-
 static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
 	pc->req_xfer = 20;
@@ -816,7 +798,7 @@ static ide_startstop_t idetape_issue_pc(
 /* A mode sense command is used to "sense" tape parameters. */
 static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = MODE_SENSE;
 	if (page_code != IDETAPE_BLOCK_DESCRIPTOR)
 		/* DBD = 1 - Don't return block descriptors */
@@ -875,7 +857,7 @@ static void ide_tape_create_rw_cmd(ideta
 	struct idetape_bh *bh = (struct idetape_bh *)rq->special;
 	unsigned int length = rq->current_nr_sectors;
 
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->bh = bh;
@@ -1164,7 +1146,7 @@ static void idetape_init_merge_buffer(id
 static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc, int write_filemark)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
@@ -1172,7 +1154,7 @@ static void idetape_create_write_filemar
 
 static void idetape_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = TEST_UNIT_READY;
 }
 
@@ -1199,7 +1181,7 @@ static int idetape_queue_pc_tail(ide_dri
 static void idetape_create_load_unload_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc, int cmd)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
@@ -1251,7 +1233,7 @@ static int idetape_flush_tape_buffers(id
 
 static void idetape_create_read_position_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = READ_POSITION;
 	pc->req_xfer = 20;
 }
@@ -1275,7 +1257,7 @@ static void idetape_create_locate_cmd(id
 		struct ide_atapi_pc *pc,
 		unsigned int block, u8 partition, int skip)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = POSITION_TO_ELEMENT;
 	pc->c[1] = 2;
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
@@ -1292,7 +1274,7 @@ static int idetape_create_prevent_cmd(id
 	if (!(tape->caps[6] & 0x01))
 		return 0;
 
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
 	return 1;
@@ -1407,7 +1389,7 @@ static int idetape_queue_rw_tail(ide_dri
 
 static void idetape_create_inquiry_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = INQUIRY;
 	pc->c[4] = 254;
 	pc->req_xfer = 254;
@@ -1416,14 +1398,14 @@ static void idetape_create_inquiry_cmd(s
 static void idetape_create_rewind_cmd(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
 static void idetape_create_erase_cmd(struct ide_atapi_pc *pc)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = ERASE;
 	pc->c[1] = 1;
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
@@ -1431,7 +1413,7 @@ static void idetape_create_erase_cmd(str
 
 static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 {
-	idetape_init_pc(pc);
+	ide_init_pc(pc);
 	pc->c[0] = SPACE;
 	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -722,6 +722,12 @@ enum {
 	PC_FLAG_TIMEDOUT		= (1 << 7),
 };
 
+/*
+ * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
+ * This is used for several packet commands (not for READ/WRITE commands).
+ */
+#define IDE_PC_BUFFER_SIZE	256
+
 struct ide_atapi_pc {
 	/* actual packet bytes */
 	u8 c[12];
@@ -751,7 +757,7 @@ struct ide_atapi_pc {
 	 * those are more or less driver-specific and some of them are subject
 	 * to change/removal later.
 	 */
-	u8 pc_buf[256];
+	u8 pc_buf[IDE_PC_BUFFER_SIZE];
 
 	/* idetape only */
 	struct idetape_bh *bh;
@@ -1111,6 +1117,8 @@ void ide_pktcmd_tf_load(ide_drive_t *, u
 
 int ide_check_atapi_device(ide_drive_t *, const char *);
 
+void ide_init_pc(struct ide_atapi_pc *);
+
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
