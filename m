Return-Path: <linux-kernel-owner+w=401wt.eu-S1763705AbZEHDCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763705AbZEHDCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762404AbZEHC5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:36289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762162AbZEHC4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:56:52 -0400
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
Subject: [PATCH 17/18] block: convert to dequeueing model (easy ones)
Date: Fri,  8 May 2009 11:54:15 +0900
Message-Id: <1241751256-17435-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

plat-omap/mailbox, floppy, viocd, mspro_block, i2o_block and
mmc/card/queue are already pretty close to dequeueing model and can be
converted with simple changes.  Convert them.

While at it,

* xen-blkfront: !fs check moved downwards to share dequeue call with
  normal path.

* mspro_block: __blk_end_request(..., blk_rq_cur_byte()) converted to
  __blk_end_request_cur()

* mmc/card/queue: loop of __blk_end_request() converted to
  __blk_end_request_all()


[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
---
 arch/arm/plat-omap/mailbox.c        |    9 +++++++++
 drivers/block/floppy.c              |    4 +++-
 drivers/block/xen-blkfront.c        |   13 +++++++------
 drivers/cdrom/viocd.c               |    2 ++
 drivers/memstick/core/mspro_block.c |    8 +++++---
 drivers/message/i2o/i2o_block.c     |    6 ++++--
 drivers/mmc/card/queue.c            |   12 ++++++------
 7 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index 538ba75..7a1f5c2 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -198,6 +198,8 @@ static void mbox_tx_work(struct work_struct *work)
 
 		spin_lock(q->queue_lock);
 		rq = elv_next_request(q);
+		if (rq)
+			blkdev_dequeue_request(rq);
 		spin_unlock(q->queue_lock);
 
 		if (!rq)
@@ -208,6 +210,9 @@ static void mbox_tx_work(struct work_struct *work)
 		ret = __mbox_msg_send(mbox, tx_data->msg, tx_data->arg);
 		if (ret) {
 			enable_mbox_irq(mbox, IRQ_TX);
+			spin_lock(q->queue_lock);
+			blk_requeue_request(q, rq);
+			spin_unlock(q->queue_lock);
 			return;
 		}
 
@@ -238,6 +243,8 @@ static void mbox_rx_work(struct work_struct *work)
 	while (1) {
 		spin_lock_irqsave(q->queue_lock, flags);
 		rq = elv_next_request(q);
+		if (rq)
+			blkdev_dequeue_request(rq);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 		if (!rq)
 			break;
@@ -345,6 +352,8 @@ omap_mbox_read(struct device *dev, struct device_attribute *attr, char *buf)
 	while (1) {
 		spin_lock_irqsave(q->queue_lock, flags);
 		rq = elv_next_request(q);
+		if (rq)
+			blkdev_dequeue_request(rq);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		if (!rq)
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 1e27ed9..e2c70d2 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -931,7 +931,7 @@ static inline void unlock_fdc(void)
 	del_timer(&fd_timeout);
 	cont = NULL;
 	clear_bit(0, &fdc_busy);
-	if (elv_next_request(floppy_queue))
+	if (current_req || elv_next_request(floppy_queue))
 		do_fd_request(floppy_queue);
 	spin_unlock_irqrestore(&floppy_lock, flags);
 	wake_up(&fdc_wait);
@@ -2913,6 +2913,8 @@ static void redo_fd_request(void)
 
 			spin_lock_irq(floppy_queue->queue_lock);
 			req = elv_next_request(floppy_queue);
+			if (req)
+				blkdev_dequeue_request(req);
 			spin_unlock_irq(floppy_queue->queue_lock);
 			if (!req) {
 				do_floppy = NULL;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 91fc565..66f8345 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -301,22 +301,23 @@ static void do_blkif_request(struct request_queue *rq)
 
 	while ((req = elv_next_request(rq)) != NULL) {
 		info = req->rq_disk->private_data;
-		if (!blk_fs_request(req)) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
 
 		if (RING_FULL(&info->ring))
 			goto wait;
 
+		blkdev_dequeue_request(req);
+
+		if (!blk_fs_request(req)) {
+			__blk_end_request_all(req, -EIO);
+			continue;
+		}
+
 		pr_debug("do_blk_req %p: cmd %p, sec %lx, "
 			 "(%u/%u) buffer:%p [%s]\n",
 			 req, req->cmd, (unsigned long)blk_rq_pos(req),
 			 blk_rq_cur_sectors(req), blk_rq_sectors(req),
 			 req->buffer, rq_data_dir(req) ? "write" : "read");
 
-
-		blkdev_dequeue_request(req);
 		if (blkif_queue_request(req)) {
 			blk_requeue_request(rq, req);
 wait:
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 6e190a9..bbe9f08 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -298,6 +298,8 @@ static void do_viocd_request(struct request_queue *q)
 	struct request *req;
 
 	while ((rwreq == 0) && ((req = elv_next_request(q)) != NULL)) {
+		blkdev_dequeue_request(req);
+
 		if (!blk_fs_request(req))
 			__blk_end_request_all(req, -EIO);
 		else if (send_request(req) < 0) {
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 93b2c61..58f5be8 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -672,8 +672,7 @@ try_again:
 					       msb->req_sg);
 
 		if (!msb->seg_count) {
-			chunk = __blk_end_request(msb->block_req, -ENOMEM,
-					blk_rq_cur_bytes(msb->block_req));
+			chunk = __blk_end_request_cur(msb->block_req, -ENOMEM);
 			continue;
 		}
 
@@ -711,6 +710,7 @@ try_again:
 		dev_dbg(&card->dev, "issue end\n");
 		return -EAGAIN;
 	}
+	blkdev_dequeue_request(msb->block_req);
 
 	dev_dbg(&card->dev, "trying again\n");
 	chunk = 1;
@@ -825,8 +825,10 @@ static void mspro_block_submit_req(struct request_queue *q)
 		return;
 
 	if (msb->eject) {
-		while ((req = elv_next_request(q)) != NULL)
+		while ((req = elv_next_request(q)) != NULL) {
+			blkdev_dequeue_request(req);
 			__blk_end_request_all(req, -ENODEV);
+		}
 
 		return;
 	}
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index e153f5d..8b5cbfc 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -916,8 +916,10 @@ static void i2o_block_request_fn(struct request_queue *q)
 				blk_stop_queue(q);
 				break;
 			}
-		} else
-			__blk_end_request_cur(req, -EIO);
+		} else {
+			blkdev_dequeue_request(req);
+			__blk_end_request_all(req, -EIO);
+		}
 	}
 };
 
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 7a72e75..4b70f1e 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -54,8 +54,11 @@ static int mmc_queue_thread(void *d)
 
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (!blk_queue_plugged(q))
+		if (!blk_queue_plugged(q)) {
 			req = elv_next_request(q);
+			if (req)
+				blkdev_dequeue_request(req);
+		}
 		mq->req = req;
 		spin_unlock_irq(q->queue_lock);
 
@@ -88,15 +91,12 @@ static void mmc_request(struct request_queue *q)
 {
 	struct mmc_queue *mq = q->queuedata;
 	struct request *req;
-	int ret;
 
 	if (!mq) {
 		printk(KERN_ERR "MMC: killing requests for dead queue\n");
 		while ((req = elv_next_request(q)) != NULL) {
-			do {
-				ret = __blk_end_request(req, -EIO,
-							blk_rq_cur_bytes(req));
-			} while (ret);
+			blkdev_dequeue_request(req);
+			__blk_end_request_all(req, -EIO);
 		}
 		return;
 	}
-- 
1.6.0.2

