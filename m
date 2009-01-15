Return-Path: <linux-kernel-owner+w=401wt.eu-S933182AbZAOUXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbZAOUXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765632AbZAOUBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:44426 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761795AbZAOUAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Ag9YXhP162MkCGmemctLVCgwVpXR18zrDXR9JBm/CGvXkFuVVLr9cag6b4l1KmZdZ7
         EO9HYF84OF1eM2eqMAcQHKMrnN2BXjNasKWg9szy+ohjkiRXlNmZrQl0KUlSiUXZwMy3
         rn+p9C06JQUkHoPZQaAgHrkY4Y/cZMmcqFN5s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 21:01:08 +0100
Message-Id: <20090115200108.17294.11783.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] ide: remove ide_do_drive_cmd()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ide_do_drive_cmd()

* Use elv_add_request() instead of __elv_add_request() in ide_do_drive_cmd().

* ide_do_drive_cmd() is used only in ide-{atapi,cd}.c so inline it there.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c |    5 ++++-
 drivers/ide/ide-cd.c    |    4 +++-
 drivers/ide/ide-io.c    |   28 ----------------------------
 include/linux/ide.h     |    2 --
 4 files changed, 7 insertions(+), 32 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -143,7 +143,10 @@ static void ide_queue_pc_head(ide_drive_
 	memcpy(rq->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		rq->cmd[13] = REQ_IDETAPE_PC1;
-	ide_do_drive_cmd(drive, rq);
+
+	drive->hwif->rq = NULL;
+
+	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
 }
 
 /*
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -234,7 +234,9 @@ static void cdrom_queue_request_sense(id
 		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x\n",
 			      failed_command->cmd[0]);
 
-	ide_do_drive_cmd(drive, rq);
+	drive->hwif->rq = NULL;
+
+	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
 }
 
 static void cdrom_end_request(ide_drive_t *drive, int uptodate)
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1125,34 +1125,6 @@ out_early:
 	return irq_ret;
 }
 
-/**
- *	ide_do_drive_cmd	-	issue IDE special command
- *	@drive: device to issue command
- *	@rq: request to issue
- *
- *	This function issues a special IDE device request
- *	onto the request queue.
- *
- *	the rq is queued at the head of the request queue, displacing
- *	the currently-being-processed request and this function
- *	returns immediately without waiting for the new rq to be
- *	completed.  This is VERY DANGEROUS, and is intended for
- *	careful use by the ATAPI tape/cdrom driver code.
- */
-
-void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
-{
-	struct request_queue *q = drive->queue;
-	unsigned long flags;
-
-	drive->hwif->rq = NULL;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-EXPORT_SYMBOL(ide_do_drive_cmd);
-
 void ide_pad_transfer(ide_drive_t *drive, int write, int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1172,8 +1172,6 @@ extern ide_startstop_t ide_do_reset (ide
 extern int ide_devset_execute(ide_drive_t *drive,
 			      const struct ide_devset *setting, int arg);
 
-extern void ide_do_drive_cmd(ide_drive_t *, struct request *);
-
 extern void ide_end_drive_cmd(ide_drive_t *, u8, u8);
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
