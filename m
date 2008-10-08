Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbYJHUde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbYJHUde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYJHUcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:32:05 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:26067 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbYJHUcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=iztkwnrt/gvWrQBcSFh2CnQsPl55jXE3y5qxhsuygdk9t2a4PtTwdxfGLQ4yo7WYmO
         CCLMO2mLnjTaYrlMb7vu6xLzEPp18+BR2S7cIfzStxe7jc+7UuGBXB9C7Xc24531X0zT
         gMLV1R5sxW2Ds9bW4mCrkcyZjLHPL41kGPtno=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2008 22:30:27 +0200
Message-Id: <20081008203027.19112.20883.sendpatchset@localhost.localdomain>
In-Reply-To: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/7] ide: use queue lock instead of ide_lock when possible
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use queue lock instead of ide_lock when possible

This is just a preparation for future changes and there should be no
functional changes caused by this patch since ide_lock is currently
also used as queue lock.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   14 ++++++++------
 drivers/ide/ide-io.c |   19 ++++++++++---------
 2 files changed, 18 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -424,16 +424,17 @@ static int cdrom_decode_status(ide_drive
 				if (time_after(jiffies, info->write_timeout))
 					do_end_request = 1;
 				else {
+					struct request_queue *q = drive->queue;
 					unsigned long flags;
 
 					/*
 					 * take a breather relying on the unplug
 					 * timer to kick us again
 					 */
-					spin_lock_irqsave(&ide_lock, flags);
-					blk_plug_device(drive->queue);
-					spin_unlock_irqrestore(&ide_lock,
-								flags);
+					spin_lock_irqsave(q->queue_lock, flags);
+					blk_plug_device(q);
+					spin_unlock_irqrestore(q->queue_lock, flags);
+
 					return 1;
 				}
 			}
@@ -502,11 +503,12 @@ static int cdrom_decode_status(ide_drive
 
 end_request:
 	if (stat & ATA_ERR) {
+		struct request_queue *q = drive->queue;
 		unsigned long flags;
 
-		spin_lock_irqsave(&ide_lock, flags);
+		spin_lock_irqsave(q->queue_lock, flags);
 		blkdev_dequeue_request(rq);
-		spin_unlock_irqrestore(&ide_lock, flags);
+		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		hwgroup->rq = NULL;
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -243,20 +243,21 @@ EXPORT_SYMBOL_GPL(ide_end_dequeued_reque
  */
 static void ide_complete_pm_request (ide_drive_t *drive, struct request *rq)
 {
+	struct request_queue *q = drive->queue;
 	unsigned long flags;
 
 #ifdef DEBUG_PM
 	printk("%s: completing PM request, %s\n", drive->name,
 	       blk_pm_suspend_request(rq) ? "suspend" : "resume");
 #endif
-	spin_lock_irqsave(&ide_lock, flags);
+	spin_lock_irqsave(q->queue_lock, flags);
 	if (blk_pm_suspend_request(rq)) {
-		blk_stop_queue(drive->queue);
+		blk_stop_queue(q);
 	} else {
 		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
-		blk_start_queue(drive->queue);
+		blk_start_queue(q);
 	}
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	drive->hwif->hwgroup->rq = NULL;
 
@@ -1469,16 +1470,16 @@ out:
 void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
 {
 	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	struct request_queue *q = drive->queue;
 	unsigned long flags;
 
 	hwgroup->rq = NULL;
 
-	spin_lock_irqsave(&ide_lock, flags);
-	__elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 1);
-	__generic_unplug_device(drive->queue);
-	spin_unlock_irqrestore(&ide_lock, flags);
+	spin_lock_irqsave(q->queue_lock, flags);
+	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
+	__generic_unplug_device(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
-
 EXPORT_SYMBOL(ide_do_drive_cmd);
 
 void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
