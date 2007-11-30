Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbXK3Xfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbXK3Xfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXK3Xet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:34:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbXK3Xer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:34:47 -0500
Date: Fri, 30 Nov 2007 18:33:58 -0500 (EST)
Message-Id: <20071130.183358.35360061.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 24/28] blk_end_request: changing ide normal caller (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts "normal" parts of ide to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/ide/ide-cd.c |    6 +++---
 drivers/ide/ide-io.c |   17 ++++++-----------
 2 files changed, 9 insertions(+), 14 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/ide/ide-cd.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/ide/ide-cd.c
+++ 2.6.24-rc3-mm2/drivers/ide/ide-cd.c
@@ -655,9 +655,9 @@ static void cdrom_end_request (ide_drive
 					BUG();
 			} else {
 				spin_lock_irqsave(&ide_lock, flags);
-				end_that_request_chunk(failed, 0,
-							failed->data_len);
-				end_that_request_last(failed, 0);
+				if (__blk_end_request(failed, 0,
+						      failed->data_len))
+					BUG();
 				spin_unlock_irqrestore(&ide_lock, flags);
 			}
 		} else
Index: 2.6.24-rc3-mm2/drivers/ide/ide-io.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/ide/ide-io.c
+++ 2.6.24-rc3-mm2/drivers/ide/ide-io.c
@@ -78,14 +78,9 @@ static int __ide_end_request(ide_drive_t
 		ide_dma_on(drive);
 	}
 
-	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
-		add_disk_randomness(rq->rq_disk);
-		if (dequeue) {
-			if (!list_empty(&rq->queuelist))
-				blkdev_dequeue_request(rq);
+	if (!__blk_end_request(rq, uptodate, nr_bytes)) {
+		if (dequeue)
 			HWGROUP(drive)->rq = NULL;
-		}
-		end_that_request_last(rq, uptodate);
 		ret = 0;
 	}
 
@@ -290,9 +285,9 @@ static void ide_complete_pm_request (ide
 		drive->blocked = 0;
 		blk_start_queue(drive->queue);
 	}
-	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
-	end_that_request_last(rq, 1);
+	if (__blk_end_request(rq, 1, 0))
+		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
@@ -402,10 +397,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 	}
 
 	spin_lock_irqsave(&ide_lock, flags);
-	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
 	rq->errors = err;
-	end_that_request_last(rq, !rq->errors);
+	if (__blk_end_request(rq, !rq->errors, 0))
+		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
