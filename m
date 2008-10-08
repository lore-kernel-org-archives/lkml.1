Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYJHUdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYJHUdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYJHUbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:31:55 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:25367 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbYJHUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CmHqf4vJtL/XrDt1W2ABr+Lfv3OHInwl7lE1tXjZieDjprsUFitNDh/gtSPxYkD6lh
         PThtl+X0WLWUmCTnDlJLpIACs1jrZiyZDw8QuEqpH6ft+kil71U0uDGudcDyiALbk/nZ
         86MJ5U9wSwxsdEY9Bu00pVz2JBm0J/7P8wj2o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2008 22:30:18 +0200
Message-Id: <20081008203018.19112.43718.sendpatchset@localhost.localdomain>
In-Reply-To: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/7] ide: ide_lock + __blk_end_request() -> blk_end_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: ide_lock + __blk_end_request() -> blk_end_request()

Use blk_end_request() instead of ide_lock + __blk_end_request()
in cdrom_end_request(), cdrom_newpc_intr(), __ide_end_request(),
ide_complete_pm_request() and ide_end_drive_cmd().

[ ide_lock is currently also used as queue lock ]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   12 +++---------
 drivers/ide/ide-io.c |   16 ++++------------
 2 files changed, 7 insertions(+), 21 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -262,7 +262,6 @@ static void cdrom_end_request(ide_drive_
 		struct request *failed = (struct request *) rq->buffer;
 		struct cdrom_info *info = drive->driver_data;
 		void *sense = &info->sense_data;
-		unsigned long flags;
 
 		if (failed) {
 			if (failed->sense) {
@@ -278,11 +277,9 @@ static void cdrom_end_request(ide_drive_
 						failed->hard_nr_sectors))
 					BUG();
 			} else {
-				spin_lock_irqsave(&ide_lock, flags);
-				if (__blk_end_request(failed, -EIO,
-						      failed->data_len))
+				if (blk_end_request(failed, -EIO,
+						    failed->data_len))
 					BUG();
-				spin_unlock_irqrestore(&ide_lock, flags);
 			}
 		} else
 			cdrom_analyze_sense_data(drive, NULL, sense);
@@ -1151,16 +1148,13 @@ static ide_startstop_t cdrom_newpc_intr(
 
 end_request:
 	if (blk_pc_request(rq)) {
-		unsigned long flags;
 		unsigned int dlen = rq->data_len;
 
 		if (dma)
 			rq->data_len = 0;
 
-		spin_lock_irqsave(&ide_lock, flags);
-		if (__blk_end_request(rq, 0, dlen))
+		if (blk_end_request(rq, 0, dlen))
 			BUG();
-		spin_unlock_irqrestore(&ide_lock, flags);
 
 		hwgroup->rq = NULL;
 	} else {
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -58,7 +58,6 @@
 static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, unsigned int nr_bytes, int dequeue)
 {
-	unsigned long flags;
 	int ret = 1;
 	int error = 0;
 
@@ -85,10 +84,8 @@ static int __ide_end_request(ide_drive_t
 		ide_dma_on(drive);
 	}
 
-	spin_lock_irqsave(&ide_lock, flags);
-	if (!__blk_end_request(rq, error, nr_bytes))
+	if (!blk_end_request(rq, error, nr_bytes))
 		ret = 0;
-	spin_unlock_irqrestore(&ide_lock, flags);
 
 	if (ret == 0 && dequeue)
 		drive->hwif->hwgroup->rq = NULL;
@@ -263,10 +260,8 @@ static void ide_complete_pm_request (ide
 
 	drive->hwif->hwgroup->rq = NULL;
 
-	spin_lock_irqsave(&ide_lock, flags);
-	if (__blk_end_request(rq, 0, 0))
+	if (blk_end_request(rq, 0, 0))
 		BUG();
-	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
 /**
@@ -287,7 +282,6 @@ void ide_end_drive_cmd (ide_drive_t *dri
 {
 	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 	struct request *rq = hwgroup->rq;
-	unsigned long flags;
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = (ide_task_t *)rq->special;
@@ -322,11 +316,9 @@ void ide_end_drive_cmd (ide_drive_t *dri
 
 	rq->errors = err;
 
-	spin_lock_irqsave(&ide_lock, flags);
-	if (unlikely(__blk_end_request(rq, (rq->errors ? -EIO : 0),
-				       blk_rq_bytes(rq))))
+	if (unlikely(blk_end_request(rq, (rq->errors ? -EIO : 0),
+				     blk_rq_bytes(rq))))
 		BUG();
-	spin_unlock_irqrestore(&ide_lock, flags);
 }
 EXPORT_SYMBOL(ide_end_drive_cmd);
 
