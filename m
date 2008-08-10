Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYHJPkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYHJPkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYHJPi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:38:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:3925 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbYHJPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cJfv8/Lj6B1lTJzzOmbLfRIqFb1XpEXCB8Rb8jYHD2oIlDYfG3VBoap535ohfWcb4Z
         28C4G7WG2PfDO2myZeihsu4Ml+irqelccH+tJqOzcu/oqsBv/rijxAdPd00IFGVS1TTE
         x/goI5zLM83xi4Ez/3S1q1Vm7A6erWfLK4VFQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:36:16 +0200
Message-Id: <20080810153616.16255.49418.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/22] ide: add ide_queue_pc_head() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move REQ_IDETAPE_* enums to <linux/ide.h>.

* Add ide_queue_pc_head() and convert ide-{floppy,tape}.c to use it
  instead of ide*_queue_pc_head().

* Remove no longer used ide*_queue_pc_head().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   20 ++++++++++++++++++++
 drivers/ide/ide-floppy.c |   21 +--------------------
 drivers/ide/ide-tape.c   |   36 +-----------------------------------
 include/linux/ide.h      |   16 ++++++++++++++++
 4 files changed, 38 insertions(+), 55 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -119,6 +119,26 @@ void ide_init_pc(struct ide_atapi_pc *pc
 }
 EXPORT_SYMBOL_GPL(ide_init_pc);
 
+/*
+ * Generate a new packet command request in front of the request queue, before
+ * the current request, so that it will be processed immediately, on the next
+ * pass through the driver.
+ */
+void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
+		       struct ide_atapi_pc *pc, struct request *rq)
+{
+	blk_rq_init(NULL, rq);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_flags |= REQ_PREEMPT;
+	rq->buffer = (char *)pc;
+	rq->rq_disk = disk;
+	memcpy(rq->cmd, pc->c, 12);
+	if (drive->media == ide_tape)
+		rq->cmd[13] = REQ_IDETAPE_PC1;
+	ide_do_drive_cmd(drive, rq);
+}
+EXPORT_SYMBOL_GPL(ide_queue_pc_head);
+
 /* TODO: unify the code thus making some arguments go away */
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -211,25 +211,6 @@ static void idefloppy_update_buffers(ide
 		idefloppy_end_request(drive, 1, 0);
 }
 
-/*
- * Generate a new packet command request in front of the request queue, before
- * the current request so that it will be processed immediately, on the next
- * pass through the driver.
- */
-static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		struct request *rq)
-{
-	struct ide_floppy_obj *floppy = drive->driver_data;
-
-	blk_rq_init(NULL, rq);
-	rq->buffer = (char *) pc;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_flags |= REQ_PREEMPT;
-	rq->rq_disk = floppy->disk;
-	memcpy(rq->cmd, pc->c, 12);
-	ide_do_drive_cmd(drive, rq);
-}
-
 static void ide_floppy_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
@@ -287,7 +268,7 @@ static void idefloppy_retry_pc(ide_drive
 
 	(void)ide_read_error(drive);
 	idefloppy_create_request_sense_cmd(pc);
-	idefloppy_queue_pc_head(drive, pc, rq);
+	ide_queue_pc_head(drive, floppy->disk, pc, rq);
 }
 
 /* The usual interrupt handler called during a packet command. */
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -159,20 +159,6 @@ struct idetape_bh {
 #define IDETAPE_LU_RETENSION_MASK	2
 #define IDETAPE_LU_EOT_MASK		4
 
-/*
- * Special requests for our block device strategy routine.
- *
- * In order to service a character device command, we add special requests to
- * the tail of our block device request queue and wait for their completion.
- */
-
-enum {
-	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
-	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
-	REQ_IDETAPE_READ	= (1 << 2),
-	REQ_IDETAPE_WRITE	= (1 << 3),
-};
-
 /* Error codes returned in rq->errors to the higher part of the driver. */
 #define IDETAPE_ERROR_GENERAL		101
 #define IDETAPE_ERROR_FILEMARK		102
@@ -613,26 +599,6 @@ static void idetape_create_request_sense
 }
 
 /*
- * Generate a new packet command request in front of the request queue, before
- * the current request, so that it will be processed immediately, on the next
- * pass through the driver.
- */
-static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				  struct request *rq)
-{
-	struct ide_tape_obj *tape = drive->driver_data;
-
-	blk_rq_init(NULL, rq);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_flags |= REQ_PREEMPT;
-	rq->buffer = (char *) pc;
-	rq->rq_disk = tape->disk;
-	memcpy(rq->cmd, pc->c, 12);
-	rq->cmd[13] = REQ_IDETAPE_PC1;
-	ide_do_drive_cmd(drive, rq);
-}
-
-/*
  *	idetape_retry_pc is called when an error was detected during the
  *	last packet command. We queue a request sense packet command in
  *	the head of the request list.
@@ -646,7 +612,7 @@ static void idetape_retry_pc(ide_drive_t
 	(void)ide_read_error(drive);
 	idetape_create_request_sense_cmd(pc);
 	set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-	idetape_queue_pc_head(drive, pc, rq);
+	ide_queue_pc_head(drive, tape->disk, pc, rq);
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1119,6 +1119,22 @@ int ide_check_atapi_device(ide_drive_t *
 
 void ide_init_pc(struct ide_atapi_pc *);
 
+/*
+ * Special requests for ide-tape block device strategy routine.
+ *
+ * In order to service a character device command, we add special requests to
+ * the tail of our block device request queue and wait for their completion.
+ */
+enum {
+	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
+	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
+	REQ_IDETAPE_READ	= (1 << 2),
+	REQ_IDETAPE_WRITE	= (1 << 3),
+};
+
+void ide_queue_pc_head(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *,
+		       struct request *);
+
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
