Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYHJPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYHJPoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbYHJPjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:39:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:2609 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbYHJPjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OdnsgJo+OMUNuf+G9P0iFHJIuTQKzsWR6z1UHcz90a21mbVLfsmBHq38ljnfZMMN6u
         KAd5Ahxidjs13D/Pydn0wHBfROuTWnrAG0Ml3ZRwGKGD1RXrExBTrV7SCYRV0+58Rzka
         bYH5MAU30G6Q32SsCguLuBojOUtq2uqR7+jwE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:37:36 +0200
Message-Id: <20080810153736.16255.43132.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/22] ide: add request_sense_{pc,rq} to ide_drive_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'struct ide_atapi_pc request_sense_pc' and 'request request_sense_rq' to
ide_drive_t and use them instead of fields in struct ide_{floppy,tape}_obj.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    4 -
 drivers/ide/ide-floppy.h |    3 -
 drivers/ide/ide-tape.c   |    7 --
 include/linux/ide.h      |  134 +++++++++++++++++++++++------------------------
 4 files changed, 72 insertions(+), 76 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -207,8 +207,8 @@ void ide_floppy_create_request_sense_cmd
 static void idefloppy_retry_pc(ide_drive_t *drive)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
-	struct request *rq = &floppy->request_sense_rq;
-	struct ide_atapi_pc *pc = &floppy->request_sense_pc;
+	struct request *rq = &drive->request_sense_rq;
+	struct ide_atapi_pc *pc = &drive->request_sense_pc;
 
 	(void)ide_read_error(drive);
 	ide_floppy_create_request_sense_cmd(pc);
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -18,9 +18,6 @@ typedef struct ide_floppy_obj {
 	/* used for blk_{fs,pc}_request() requests */
 	struct ide_atapi_pc queued_pc;
 
-	struct ide_atapi_pc request_sense_pc;
-	struct request request_sense_rq;
-
 	/* Last error information */
 	u8 sense_key, asc, ascq;
 	/* delay this long before sending packet command */
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -182,9 +182,6 @@ typedef struct ide_tape_obj {
 	/* used by REQ_IDETAPE_{READ,WRITE} requests */
 	struct ide_atapi_pc queued_pc;
 
-	struct ide_atapi_pc request_sense_pc;
-	struct request request_sense_rq;
-
 	/*
 	 * DSC polling variables.
 	 *
@@ -600,8 +597,8 @@ static void idetape_create_request_sense
 static void idetape_retry_pc(ide_drive_t *drive)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
-	struct request *rq = &tape->request_sense_rq;
-	struct ide_atapi_pc *pc = &tape->request_sense_pc;
+	struct request *rq = &drive->request_sense_rq;
+	struct ide_atapi_pc *pc = &drive->request_sense_pc;
 
 	(void)ide_read_error(drive);
 	idetape_create_request_sense_cmd(pc);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -321,7 +321,71 @@ typedef enum {
 	ide_started,	/* a drive operation was started, handler was set */
 } ide_startstop_t;
 
-struct ide_atapi_pc;
+/* ATAPI packet command flags */
+enum {
+	/* set when an error is considered normal - no retry (ide-tape) */
+	PC_FLAG_ABORT			= (1 << 0),
+	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
+	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
+	PC_FLAG_DMA_OK			= (1 << 3),
+	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
+	PC_FLAG_DMA_ERROR		= (1 << 5),
+	PC_FLAG_WRITING			= (1 << 6),
+	/* command timed out */
+	PC_FLAG_TIMEDOUT		= (1 << 7),
+};
+
+/*
+ * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
+ * This is used for several packet commands (not for READ/WRITE commands).
+ */
+#define IDE_PC_BUFFER_SIZE	256
+
+struct ide_atapi_pc {
+	/* actual packet bytes */
+	u8 c[12];
+	/* incremented on each retry */
+	int retries;
+	int error;
+
+	/* bytes to transfer */
+	int req_xfer;
+	/* bytes actually transferred */
+	int xferred;
+
+	/* data buffer */
+	u8 *buf;
+	/* current buffer position */
+	u8 *cur_pos;
+	int buf_size;
+	/* missing/available data on the current buffer */
+	int b_count;
+
+	/* the corresponding request */
+	struct request *rq;
+
+	unsigned long flags;
+
+	/*
+	 * those are more or less driver-specific and some of them are subject
+	 * to change/removal later.
+	 */
+	u8 pc_buf[IDE_PC_BUFFER_SIZE];
+
+	/* idetape only */
+	struct idetape_bh *bh;
+	char *b_data;
+
+	/* idescsi only for now */
+	struct scatterlist *sg;
+	unsigned int sg_cnt;
+
+	struct scsi_cmnd *scsi_cmd;
+	void (*done) (struct scsi_cmnd *);
+
+	unsigned long timeout;
+};
+
 struct ide_devset;
 struct ide_driver_s;
 
@@ -489,6 +553,9 @@ struct ide_drive_s {
 	void (*pc_callback)(struct ide_drive_s *, int);
 
 	unsigned long atapi_flags;
+
+	struct ide_atapi_pc request_sense_pc;
+	struct request request_sense_rq;
 };
 
 typedef struct ide_drive_s ide_drive_t;
@@ -732,71 +799,6 @@ int set_##name(ide_drive_t *drive, int a
 	return 0; \
 }
 
-/* ATAPI packet command flags */
-enum {
-	/* set when an error is considered normal - no retry (ide-tape) */
-	PC_FLAG_ABORT			= (1 << 0),
-	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
-	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
-	PC_FLAG_DMA_OK			= (1 << 3),
-	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
-	PC_FLAG_DMA_ERROR		= (1 << 5),
-	PC_FLAG_WRITING			= (1 << 6),
-	/* command timed out */
-	PC_FLAG_TIMEDOUT		= (1 << 7),
-};
-
-/*
- * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
- * This is used for several packet commands (not for READ/WRITE commands).
- */
-#define IDE_PC_BUFFER_SIZE	256
-
-struct ide_atapi_pc {
-	/* actual packet bytes */
-	u8 c[12];
-	/* incremented on each retry */
-	int retries;
-	int error;
-
-	/* bytes to transfer */
-	int req_xfer;
-	/* bytes actually transferred */
-	int xferred;
-
-	/* data buffer */
-	u8 *buf;
-	/* current buffer position */
-	u8 *cur_pos;
-	int buf_size;
-	/* missing/available data on the current buffer */
-	int b_count;
-
-	/* the corresponding request */
-	struct request *rq;
-
-	unsigned long flags;
-
-	/*
-	 * those are more or less driver-specific and some of them are subject
-	 * to change/removal later.
-	 */
-	u8 pc_buf[IDE_PC_BUFFER_SIZE];
-
-	/* idetape only */
-	struct idetape_bh *bh;
-	char *b_data;
-
-	/* idescsi only for now */
-	struct scatterlist *sg;
-	unsigned int sg_cnt;
-
-	struct scsi_cmnd *scsi_cmd;
-	void (*done) (struct scsi_cmnd *);
-
-	unsigned long timeout;
-};
-
 #ifdef CONFIG_IDE_PROC_FS
 /*
  * configurable drive settings
