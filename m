Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZEHDBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZEHDBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762260AbZEHC5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:36193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbZEHC4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:56:13 -0400
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
Subject: [PATCH 13/18] mtd_blkdevs: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:11 +0900
Message-Id: <1241751256-17435-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtd_blkdevs processes requests one-by-one synchronously from a kthread
and can be easily converted to dequeueing model.  Convert it.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/mtd_blkdevs.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 50c76a2..3e10442 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -89,18 +89,22 @@ static int mtd_blktrans_thread(void *arg)
 {
 	struct mtd_blktrans_ops *tr = arg;
 	struct request_queue *rq = tr->blkcore_priv->rq;
+	struct request *req = NULL;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
 	current->flags |= PF_MEMALLOC;
 
 	spin_lock_irq(rq->queue_lock);
+
 	while (!kthread_should_stop()) {
-		struct request *req;
 		struct mtd_blktrans_dev *dev;
 		int res;
 
-		req = elv_next_request(rq);
-
+		if (!req) {
+			req = elv_next_request(rq);
+			if (req)
+				blkdev_dequeue_request(req);
+		}
 		if (!req) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_irq(rq->queue_lock);
@@ -120,8 +124,13 @@ static int mtd_blktrans_thread(void *arg)
 
 		spin_lock_irq(rq->queue_lock);
 
-		__blk_end_request_cur(req, res);
+		if (!__blk_end_request_cur(req, res))
+			req = NULL;
 	}
+
+	if (req)
+		__blk_end_request_all(req, -EIO);
+
 	spin_unlock_irq(rq->queue_lock);
 
 	return 0;
-- 
1.6.0.2

