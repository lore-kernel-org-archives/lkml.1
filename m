Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbZDFMte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbZDFMte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZDFMsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50474 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbZDFMsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:15 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/8] block: change the request allocation/congestion logic to be sync/async based
Date: Mon,  6 Apr 2009 14:48:01 +0200
Message-Id: <1239022088-29002-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure that we never wait on async IO for sync requests, instead
of doing the split on writes vs reads.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c            |   70 +++++++++++++++++++++---------------------
 block/blk-sysfs.c           |   40 ++++++++++++------------
 block/elevator.c            |    2 +-
 include/linux/backing-dev.h |   12 ++++----
 include/linux/blkdev.h      |   52 +++++++++++++++++++++----------
 mm/backing-dev.c            |   10 +++---
 6 files changed, 102 insertions(+), 84 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 996ed90..a32b571 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -484,11 +484,11 @@ static int blk_init_free_list(struct request_queue *q)
 {
 	struct request_list *rl = &q->rq;
 
-	rl->count[READ] = rl->count[WRITE] = 0;
-	rl->starved[READ] = rl->starved[WRITE] = 0;
+	rl->count[BLK_RW_SYNC] = rl->count[BLK_RW_ASYNC] = 0;
+	rl->starved[BLK_RW_SYNC] = rl->starved[BLK_RW_ASYNC] = 0;
 	rl->elvpriv = 0;
-	init_waitqueue_head(&rl->wait[READ]);
-	init_waitqueue_head(&rl->wait[WRITE]);
+	init_waitqueue_head(&rl->wait[BLK_RW_SYNC]);
+	init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
 
 	rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, mempool_alloc_slab,
 				mempool_free_slab, request_cachep, q->node);
@@ -699,18 +699,18 @@ static void ioc_set_batching(struct request_queue *q, struct io_context *ioc)
 	ioc->last_waited = jiffies;
 }
 
-static void __freed_request(struct request_queue *q, int rw)
+static void __freed_request(struct request_queue *q, int sync)
 {
 	struct request_list *rl = &q->rq;
 
-	if (rl->count[rw] < queue_congestion_off_threshold(q))
-		blk_clear_queue_congested(q, rw);
+	if (rl->count[sync] < queue_congestion_off_threshold(q))
+		blk_clear_queue_congested(q, sync);
 
-	if (rl->count[rw] + 1 <= q->nr_requests) {
-		if (waitqueue_active(&rl->wait[rw]))
-			wake_up(&rl->wait[rw]);
+	if (rl->count[sync] + 1 <= q->nr_requests) {
+		if (waitqueue_active(&rl->wait[sync]))
+			wake_up(&rl->wait[sync]);
 
-		blk_clear_queue_full(q, rw);
+		blk_clear_queue_full(q, sync);
 	}
 }
 
@@ -718,18 +718,18 @@ static void __freed_request(struct request_queue *q, int rw)
  * A request has just been released.  Account for it, update the full and
  * congestion status, wake up any waiters.   Called under q->queue_lock.
  */
-static void freed_request(struct request_queue *q, int rw, int priv)
+static void freed_request(struct request_queue *q, int sync, int priv)
 {
 	struct request_list *rl = &q->rq;
 
-	rl->count[rw]--;
+	rl->count[sync]--;
 	if (priv)
 		rl->elvpriv--;
 
-	__freed_request(q, rw);
+	__freed_request(q, sync);
 
-	if (unlikely(rl->starved[rw ^ 1]))
-		__freed_request(q, rw ^ 1);
+	if (unlikely(rl->starved[sync ^ 1]))
+		__freed_request(q, sync ^ 1);
 }
 
 /*
@@ -743,15 +743,15 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	struct request *rq = NULL;
 	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
-	const int rw = rw_flags & 0x01;
+	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	int may_queue, priv;
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
-	if (rl->count[rw]+1 >= queue_congestion_on_threshold(q)) {
-		if (rl->count[rw]+1 >= q->nr_requests) {
+	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
+		if (rl->count[is_sync]+1 >= q->nr_requests) {
 			ioc = current_io_context(GFP_ATOMIC, q->node);
 			/*
 			 * The queue will fill after this allocation, so set
@@ -759,9 +759,9 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 			 * This process will be allowed to complete a batch of
 			 * requests, others will be blocked.
 			 */
-			if (!blk_queue_full(q, rw)) {
+			if (!blk_queue_full(q, is_sync)) {
 				ioc_set_batching(q, ioc);
-				blk_set_queue_full(q, rw);
+				blk_set_queue_full(q, is_sync);
 			} else {
 				if (may_queue != ELV_MQUEUE_MUST
 						&& !ioc_batching(q, ioc)) {
@@ -774,7 +774,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 				}
 			}
 		}
-		blk_set_queue_congested(q, rw);
+		blk_set_queue_congested(q, is_sync);
 	}
 
 	/*
@@ -782,11 +782,11 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	 * limit of requests, otherwise we could have thousands of requests
 	 * allocated with any setting of ->nr_requests
 	 */
-	if (rl->count[rw] >= (3 * q->nr_requests / 2))
+	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
 		goto out;
 
-	rl->count[rw]++;
-	rl->starved[rw] = 0;
+	rl->count[is_sync]++;
+	rl->starved[is_sync] = 0;
 
 	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
 	if (priv)
@@ -804,7 +804,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		 * wait queue, but this is pretty rare.
 		 */
 		spin_lock_irq(q->queue_lock);
-		freed_request(q, rw, priv);
+		freed_request(q, is_sync, priv);
 
 		/*
 		 * in the very unlikely event that allocation failed and no
@@ -814,8 +814,8 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		 * rq mempool into READ and WRITE
 		 */
 rq_starved:
-		if (unlikely(rl->count[rw] == 0))
-			rl->starved[rw] = 1;
+		if (unlikely(rl->count[is_sync] == 0))
+			rl->starved[is_sync] = 1;
 
 		goto out;
 	}
@@ -829,7 +829,7 @@ rq_starved:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
-	trace_block_getrq(q, bio, rw);
+	trace_block_getrq(q, bio, rw_flags & 1);
 out:
 	return rq;
 }
@@ -843,7 +843,7 @@ out:
 static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 					struct bio *bio)
 {
-	const int rw = rw_flags & 0x01;
+	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	struct request *rq;
 
 	rq = get_request(q, rw_flags, bio, GFP_NOIO);
@@ -852,10 +852,10 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		struct io_context *ioc;
 		struct request_list *rl = &q->rq;
 
-		prepare_to_wait_exclusive(&rl->wait[rw], &wait,
+		prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
 				TASK_UNINTERRUPTIBLE);
 
-		trace_block_sleeprq(q, bio, rw);
+		trace_block_sleeprq(q, bio, rw_flags & 1);
 
 		__generic_unplug_device(q);
 		spin_unlock_irq(q->queue_lock);
@@ -871,7 +871,7 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		ioc_set_batching(q, ioc);
 
 		spin_lock_irq(q->queue_lock);
-		finish_wait(&rl->wait[rw], &wait);
+		finish_wait(&rl->wait[is_sync], &wait);
 
 		rq = get_request(q, rw_flags, bio, GFP_NOIO);
 	};
@@ -1070,14 +1070,14 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	 * it didn't come out of our reserved rq pools
 	 */
 	if (req->cmd_flags & REQ_ALLOCED) {
-		int rw = rq_data_dir(req);
+		int is_sync = rq_is_sync(req) != 0;
 		int priv = req->cmd_flags & REQ_ELVPRIV;
 
 		BUG_ON(!list_empty(&req->queuelist));
 		BUG_ON(!hlist_unhashed(&req->hash));
 
 		blk_free_request(q, req);
-		freed_request(q, rw, priv);
+		freed_request(q, is_sync, priv);
 	}
 }
 EXPORT_SYMBOL_GPL(__blk_put_request);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e29ddfc..3ff9bba 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -48,28 +48,28 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	q->nr_requests = nr;
 	blk_queue_congestion_threshold(q);
 
-	if (rl->count[READ] >= queue_congestion_on_threshold(q))
-		blk_set_queue_congested(q, READ);
-	else if (rl->count[READ] < queue_congestion_off_threshold(q))
-		blk_clear_queue_congested(q, READ);
-
-	if (rl->count[WRITE] >= queue_congestion_on_threshold(q))
-		blk_set_queue_congested(q, WRITE);
-	else if (rl->count[WRITE] < queue_congestion_off_threshold(q))
-		blk_clear_queue_congested(q, WRITE);
-
-	if (rl->count[READ] >= q->nr_requests) {
-		blk_set_queue_full(q, READ);
-	} else if (rl->count[READ]+1 <= q->nr_requests) {
-		blk_clear_queue_full(q, READ);
-		wake_up(&rl->wait[READ]);
+	if (rl->count[BLK_RW_SYNC] >= queue_congestion_on_threshold(q))
+		blk_set_queue_congested(q, BLK_RW_SYNC);
+	else if (rl->count[BLK_RW_SYNC] < queue_congestion_off_threshold(q))
+		blk_clear_queue_congested(q, BLK_RW_SYNC);
+
+	if (rl->count[BLK_RW_ASYNC] >= queue_congestion_on_threshold(q))
+		blk_set_queue_congested(q, BLK_RW_ASYNC);
+	else if (rl->count[BLK_RW_ASYNC] < queue_congestion_off_threshold(q))
+		blk_clear_queue_congested(q, BLK_RW_ASYNC);
+
+	if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
+		blk_set_queue_full(q, BLK_RW_SYNC);
+	} else if (rl->count[BLK_RW_SYNC]+1 <= q->nr_requests) {
+		blk_clear_queue_full(q, BLK_RW_SYNC);
+		wake_up(&rl->wait[BLK_RW_SYNC]);
 	}
 
-	if (rl->count[WRITE] >= q->nr_requests) {
-		blk_set_queue_full(q, WRITE);
-	} else if (rl->count[WRITE]+1 <= q->nr_requests) {
-		blk_clear_queue_full(q, WRITE);
-		wake_up(&rl->wait[WRITE]);
+	if (rl->count[BLK_RW_ASYNC] >= q->nr_requests) {
+		blk_set_queue_full(q, BLK_RW_ASYNC);
+	} else if (rl->count[BLK_RW_ASYNC]+1 <= q->nr_requests) {
+		blk_clear_queue_full(q, BLK_RW_ASYNC);
+		wake_up(&rl->wait[BLK_RW_ASYNC]);
 	}
 	spin_unlock_irq(q->queue_lock);
 	return ret;
diff --git a/block/elevator.c b/block/elevator.c
index 98259ed..ca6788a 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -677,7 +677,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 	}
 
 	if (unplug_it && blk_queue_plugged(q)) {
-		int nrq = q->rq.count[READ] + q->rq.count[WRITE]
+		int nrq = q->rq.count[BLK_RW_SYNC] + q->rq.count[BLK_RW_ASYNC]
 			- q->in_flight;
 
 		if (nrq >= q->unplug_thresh)
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index bee52ab..0ec2c59 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -24,8 +24,8 @@ struct dentry;
  */
 enum bdi_state {
 	BDI_pdflush,		/* A pdflush thread is working this device */
-	BDI_write_congested,	/* The write queue is getting full */
-	BDI_read_congested,	/* The read queue is getting full */
+	BDI_async_congested,	/* The async (write) queue is getting full */
+	BDI_sync_congested,	/* The sync queue is getting full */
 	BDI_unused,		/* Available bits start here */
 };
 
@@ -215,18 +215,18 @@ static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 
 static inline int bdi_read_congested(struct backing_dev_info *bdi)
 {
-	return bdi_congested(bdi, 1 << BDI_read_congested);
+	return bdi_congested(bdi, 1 << BDI_sync_congested);
 }
 
 static inline int bdi_write_congested(struct backing_dev_info *bdi)
 {
-	return bdi_congested(bdi, 1 << BDI_write_congested);
+	return bdi_congested(bdi, 1 << BDI_async_congested);
 }
 
 static inline int bdi_rw_congested(struct backing_dev_info *bdi)
 {
-	return bdi_congested(bdi, (1 << BDI_read_congested)|
-				  (1 << BDI_write_congested));
+	return bdi_congested(bdi, (1 << BDI_sync_congested) |
+				  (1 << BDI_async_congested));
 }
 
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 465d6ba..67dae3b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -38,6 +38,10 @@ struct request;
 typedef void (rq_end_io_fn)(struct request *, int);
 
 struct request_list {
+	/*
+	 * count[], starved[], and wait[] are indexed by
+	 * BLK_RW_SYNC/BLK_RW_ASYNC
+	 */
 	int count[2];
 	int starved[2];
 	int elvpriv;
@@ -66,6 +70,11 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_ATA_PC,
 };
 
+enum {
+	BLK_RW_ASYNC	= 0,
+	BLK_RW_SYNC	= 1,
+};
+
 /*
  * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
  * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a
@@ -103,7 +112,7 @@ enum rq_flag_bits {
 	__REQ_QUIET,		/* don't worry about errors */
 	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
 	__REQ_ORDERED_COLOR,	/* is before or after barrier */
-	__REQ_RW_SYNC,		/* request is sync (O_DIRECT) */
+	__REQ_RW_SYNC,		/* request is sync (sync write or read) */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_RW_META,		/* metadata io request */
 	__REQ_COPY_USER,	/* contains copies of user pages */
@@ -438,8 +447,8 @@ struct request_queue
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
 #define QUEUE_FLAG_STOPPED	2	/* queue is stopped */
-#define	QUEUE_FLAG_READFULL	3	/* read queue has been filled */
-#define QUEUE_FLAG_WRITEFULL	4	/* write queue has been filled */
+#define	QUEUE_FLAG_SYNCFULL	3	/* read queue has been filled */
+#define QUEUE_FLAG_ASYNCFULL	4	/* write queue has been filled */
 #define QUEUE_FLAG_DEAD		5	/* queue being torn down */
 #define QUEUE_FLAG_REENTER	6	/* Re-entrancy avoidance */
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
@@ -611,32 +620,41 @@ enum {
 #define rq_data_dir(rq)		((rq)->cmd_flags & 1)
 
 /*
- * We regard a request as sync, if it's a READ or a SYNC write.
+ * We regard a request as sync, if either a read or a sync write
  */
-#define rq_is_sync(rq)		(rq_data_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
+static inline bool rw_is_sync(unsigned int rw_flags)
+{
+	return !(rw_flags & REQ_RW) || (rw_flags & REQ_RW_SYNC);
+}
+
+static inline bool rq_is_sync(struct request *rq)
+{
+	return rw_is_sync(rq->cmd_flags);
+}
+
 #define rq_is_meta(rq)		((rq)->cmd_flags & REQ_RW_META)
 
-static inline int blk_queue_full(struct request_queue *q, int rw)
+static inline int blk_queue_full(struct request_queue *q, int sync)
 {
-	if (rw == READ)
-		return test_bit(QUEUE_FLAG_READFULL, &q->queue_flags);
-	return test_bit(QUEUE_FLAG_WRITEFULL, &q->queue_flags);
+	if (sync)
+		return test_bit(QUEUE_FLAG_SYNCFULL, &q->queue_flags);
+	return test_bit(QUEUE_FLAG_ASYNCFULL, &q->queue_flags);
 }
 
-static inline void blk_set_queue_full(struct request_queue *q, int rw)
+static inline void blk_set_queue_full(struct request_queue *q, int sync)
 {
-	if (rw == READ)
-		queue_flag_set(QUEUE_FLAG_READFULL, q);
+	if (sync)
+		queue_flag_set(QUEUE_FLAG_SYNCFULL, q);
 	else
-		queue_flag_set(QUEUE_FLAG_WRITEFULL, q);
+		queue_flag_set(QUEUE_FLAG_ASYNCFULL, q);
 }
 
-static inline void blk_clear_queue_full(struct request_queue *q, int rw)
+static inline void blk_clear_queue_full(struct request_queue *q, int sync)
 {
-	if (rw == READ)
-		queue_flag_clear(QUEUE_FLAG_READFULL, q);
+	if (sync)
+		queue_flag_clear(QUEUE_FLAG_SYNCFULL, q);
 	else
-		queue_flag_clear(QUEUE_FLAG_WRITEFULL, q);
+		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
 }
 
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index be68c95..493b468 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -284,12 +284,12 @@ static wait_queue_head_t congestion_wqh[2] = {
 	};
 
 
-void clear_bdi_congested(struct backing_dev_info *bdi, int rw)
+void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
 {
 	enum bdi_state bit;
-	wait_queue_head_t *wqh = &congestion_wqh[rw];
+	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
-	bit = (rw == WRITE) ? BDI_write_congested : BDI_read_congested;
+	bit = sync ? BDI_sync_congested : BDI_async_congested;
 	clear_bit(bit, &bdi->state);
 	smp_mb__after_clear_bit();
 	if (waitqueue_active(wqh))
@@ -297,11 +297,11 @@ void clear_bdi_congested(struct backing_dev_info *bdi, int rw)
 }
 EXPORT_SYMBOL(clear_bdi_congested);
 
-void set_bdi_congested(struct backing_dev_info *bdi, int rw)
+void set_bdi_congested(struct backing_dev_info *bdi, int sync)
 {
 	enum bdi_state bit;
 
-	bit = (rw == WRITE) ? BDI_write_congested : BDI_read_congested;
+	bit = sync ? BDI_sync_congested : BDI_async_congested;
 	set_bit(bit, &bdi->state);
 }
 EXPORT_SYMBOL(set_bdi_congested);
-- 
1.6.2.1.423.g442d

