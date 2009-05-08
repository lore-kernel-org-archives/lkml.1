Return-Path: <linux-kernel-owner+w=401wt.eu-S1763837AbZEHDCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763837AbZEHDCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762512AbZEHC5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:36285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746AbZEHC4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:56:48 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com,
       schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/18] gdrom: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:14 +0900
Message-Id: <1241751256-17435-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gdrom already dequeues and fully completes requests on normal path and
the error paths can be easily converted to do so too.  Clean it up and
dequeue requests on error paths too.

While at it remove superflous blk_fs_request() && !blk_rq_sectors()
condition check.

[ Impact: dequeue in-flight request, cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---
 drivers/cdrom/gdrom.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 488423c..3cc02bf 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -638,33 +638,31 @@ static void gdrom_readdisk_dma(struct work_struct *work)
 	kfree(read_command);
 }
 
-static void gdrom_request_handler_dma(struct request *req)
-{
-	/* dequeue, add to list of deferred work
-	* and then schedule workqueue */
-	blkdev_dequeue_request(req);
-	list_add_tail(&req->queuelist, &gdrom_deferred);
-	schedule_work(&work);
-}
-
 static void gdrom_request(struct request_queue *rq)
 {
 	struct request *req;
 
 	while ((req = elv_next_request(rq)) != NULL) {
+		blkdev_dequeue_request(req);
+
 		if (!blk_fs_request(req)) {
 			printk(KERN_DEBUG "GDROM: Non-fs request ignored\n");
-			__blk_end_request_cur(req, -EIO);
+			__blk_end_request_all(req, -EIO);
+			continue;
 		}
 		if (rq_data_dir(req) != READ) {
 			printk(KERN_NOTICE "GDROM: Read only device -");
 			printk(" write request ignored\n");
-			__blk_end_request_cur(req, -EIO);
+			__blk_end_request_all(req, -EIO);
+			continue;
 		}
-		if (blk_rq_sectors(req))
-			gdrom_request_handler_dma(req);
-		else
-			__blk_end_request_cur(req, -EIO);
+
+		/*
+		 * Add to list of deferred work and then schedule
+		 * workqueue.
+		 */
+		list_add_tail(&req->queuelist, &gdrom_deferred);
+		schedule_work(&work);
 	}
 }
 
-- 
1.6.0.2

