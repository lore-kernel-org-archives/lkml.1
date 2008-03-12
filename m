Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbYCLL5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbYCLL5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYCLL5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:57:13 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25746 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYCLL5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:57:10 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, dgc@sgi.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/7] block: make kblockd_schedule_work() take the queue as parameter
Date: Wed, 12 Mar 2008 12:55:39 +0100
Message-Id: <1205322940-20127-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for checking queuing affinity.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/as-iosched.c     |    6 +++---
 block/blk-core.c       |    8 ++++----
 block/cfq-iosched.c    |    2 +-
 include/linux/blkdev.h |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 8c39467..6ef766f 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -450,7 +450,7 @@ static void as_antic_stop(struct as_data *ad)
 			del_timer(&ad->antic_timer);
 		ad->antic_status = ANTIC_FINISHED;
 		/* see as_work_handler */
-		kblockd_schedule_work(&ad->antic_work);
+		kblockd_schedule_work(ad->q, &ad->antic_work);
 	}
 }
 
@@ -471,7 +471,7 @@ static void as_antic_timeout(unsigned long data)
 		aic = ad->io_context->aic;
 
 		ad->antic_status = ANTIC_FINISHED;
-		kblockd_schedule_work(&ad->antic_work);
+		kblockd_schedule_work(q, &ad->antic_work);
 
 		if (aic->ttime_samples == 0) {
 			/* process anticipated on has exited or timed out*/
@@ -831,7 +831,7 @@ static void as_completed_request(struct request_queue *q, struct request *rq)
 	}
 
 	if (ad->changed_batch && ad->nr_dispatched == 1) {
-		kblockd_schedule_work(&ad->antic_work);
+		kblockd_schedule_work(q, &ad->antic_work);
 		ad->changed_batch = 0;
 
 		if (ad->batch_data_dir == REQ_SYNC)
diff --git a/block/blk-core.c b/block/blk-core.c
index 46819c1..ec529dc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -299,7 +299,7 @@ void blk_unplug_timeout(unsigned long data)
 	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_TIMER, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
-	kblockd_schedule_work(&q->unplug_work);
+	kblockd_schedule_work(q, &q->unplug_work);
 }
 
 void blk_unplug(struct request_queue *q)
@@ -340,7 +340,7 @@ void blk_start_queue(struct request_queue *q)
 		clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 	} else {
 		blk_plug_device(q);
-		kblockd_schedule_work(&q->unplug_work);
+		kblockd_schedule_work(q, &q->unplug_work);
 	}
 }
 EXPORT_SYMBOL(blk_start_queue);
@@ -408,7 +408,7 @@ void blk_run_queue(struct request_queue *q)
 			clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 		} else {
 			blk_plug_device(q);
-			kblockd_schedule_work(&q->unplug_work);
+			kblockd_schedule_work(q, &q->unplug_work);
 		}
 	}
 
@@ -1944,7 +1944,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		rq->rq_disk = bio->bi_bdev->bd_disk;
 }
 
-int kblockd_schedule_work(struct work_struct *work)
+int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 {
 	return queue_work(kblockd_workqueue, work);
 }
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0f962ec..4b31f7c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -235,7 +235,7 @@ static inline int cfq_bio_sync(struct bio *bio)
 static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
 {
 	if (cfqd->busy_queues)
-		kblockd_schedule_work(&cfqd->unplug_work);
+		kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
 }
 
 static int cfq_queue_empty(struct request_queue *q)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..f48f32f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -811,7 +811,7 @@ static inline void put_dev_sector(Sector p)
 }
 
 struct work_struct;
-int kblockd_schedule_work(struct work_struct *work);
+int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
 void kblockd_flush_work(struct work_struct *work);
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
-- 
1.5.4.GIT

