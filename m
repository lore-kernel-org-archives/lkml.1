Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYECNMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYECNMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 09:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYECNL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 09:11:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:31258 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYECNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 09:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dwEo8HfNpz0AybR8ZNl7TMdp81RQejvCnwu0r7bF+XONoMawbYlIfiWKW+oFXNYpTH/mFTjflumfDjlMNQKmZTAuhrpxHdC0arp7eNo13XLhNZXVdwfH3ecNcd2GwylO4KUZJl57AeuSB/I3d2u/wlKai5aXuLPbZYUMVnXWv40=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: set REQ_PREEMPT request flag in ide_do_drive_cmd() users
Date: Sat, 3 May 2008 15:12:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Borislav Petkov <petkovbb@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805031512.30755.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Set REQ_PREEMPT request flag in ide_do_drive_cmd() users
  for ide_preempt and ide_head_wait action types.

* Remove setting REQ_PREEMPT from ide_do_drive_cmd().

While at it:

* Set 'where' variable outside ide_lock.

This is a preparation for converting IDE to use blk_execute_rq().

There should be no functional changes caused by this patch.

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    1 +
 drivers/ide/ide-floppy.c |    1 +
 drivers/ide/ide-io.c     |    7 +++----
 drivers/ide/ide-tape.c   |    1 +
 drivers/ide/ide.c        |    1 +
 drivers/scsi/ide-scsi.c  |    1 +
 6 files changed, 8 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -216,6 +216,7 @@ static void cdrom_queue_request_sense(id
 	rq->data_len = 18;
 
 	rq->cmd_type = REQ_TYPE_SENSE;
+	rq->cmd_flags |= REQ_PREEMPT;
 
 	/* NOTE! Save the failed command in "rq->buffer" */
 	rq->buffer = (void *) failed_command;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -289,6 +289,7 @@ static void idefloppy_queue_pc_head(ide_
 	ide_init_drive_cmd(rq);
 	rq->buffer = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_flags |= REQ_PREEMPT;
 	rq->rq_disk = floppy->disk;
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1600,13 +1600,12 @@ int ide_do_drive_cmd (ide_drive_t *drive
 		rq->end_io = blk_end_sync_rq;
 	}
 
+	if (action == ide_preempt || action == ide_head_wait)
+		where = ELEVATOR_INSERT_FRONT;
+
 	spin_lock_irqsave(&ide_lock, flags);
 	if (action == ide_preempt)
 		hwgroup->rq = NULL;
-	if (action == ide_preempt || action == ide_head_wait) {
-		where = ELEVATOR_INSERT_FRONT;
-		rq->cmd_flags |= REQ_PREEMPT;
-	}
 	__elv_add_request(drive->queue, rq, where, 0);
 	ide_do_request(hwgroup, IDE_NO_IRQ);
 	spin_unlock_irqrestore(&ide_lock, flags);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -688,6 +688,7 @@ static void idetape_queue_pc_head(ide_dr
 	struct ide_tape_obj *tape = drive->driver_data;
 
 	idetape_init_rq(rq, REQ_IDETAPE_PC1);
+	rq->cmd_flags |= REQ_PREEMPT;
 	rq->buffer = (char *) pc;
 	rq->rq_disk = tape->disk;
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -534,6 +534,7 @@ static int generic_ide_resume(struct dev
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type = REQ_TYPE_PM_RESUME;
+	rq.cmd_flags |= REQ_PREEMPT;
 	rq.special = &args;
 	rq.data = &rqpm;
 	rqpm.pm_step = ide_pm_state_start_resume;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -235,6 +235,7 @@ static int idescsi_check_condition(ide_d
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = pc->req_xfer = pc->buf_size = SCSI_SENSE_BUFFERSIZE;
 	rq->cmd_type = REQ_TYPE_SENSE;
+	rq->cmd_flags |= REQ_PREEMPT;
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_cmd->special;
