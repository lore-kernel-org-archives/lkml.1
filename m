Return-Path: <linux-kernel-owner+w=401wt.eu-S1765438AbYA2RZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765438AbYA2RZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYA2RZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:25:46 -0500
Received: from ns1.suse.de ([195.135.220.2]:35491 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbYA2RZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:25:44 -0500
Subject: [PATCH] [RFC] block/elevator: change nr_requests handling
From: Nikanth Karthikesan <knikanth@suse.de>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, nickpiggin@yahoo.com.au
Content-Type: text/plain
Date: Tue, 29 Jan 2008 22:59:34 +0530
Message-Id: <1201627774.14644.5.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /sys/block/whateverdisk/queue/nr_requests is used to limit the
number of requests allocated per queue. There can be atmost nr_requests
read requests and nr_requests write requests allocated.

But this can lead to starvation when there are many tasks doing heavy
IO. And the ioc_batching code lets those who had failed to allocate a
request once, to allocate upto 150% of nr_requests in next round. This
just makes the limit a little higher, when there are too many tasks
doing heavy IO. IO schedulers have no control over this to choose which
task should get the requests. During such situations, even ionice cannot
help as CFQ cannot serve a task which cannot allocate any requests.
Setting nr_requests to a higher value is like disabling this queue depth
check at all.

This patch defers the nr_requests check till dispatching the requests
instead of limiting while creating them. There can be more than
nr_requests allocated, but only upto nr_requests chosen by the io
scheduler will be dispatched at a time. This lets the io scheduler to
guarantee some sort of interactivity even when there are many batchers,
if it wants to.

This patch removes the ioc_batching code. Also the schedulers stop
dispatching when it chooses a Read request and Read queue is full and
vice versa. On top of this patch, the individual schedulers can be
changed to take advantage of knowing the no of read and write requests
that can be dispatched. Or atleast dispatch until both read and write
queues are full.

Thanks
Nikanth

Check for nr_requests only when io schedulers dispatch

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/block/as-iosched.c b/block/as-iosched.c
index cb5e53b..39b58cf 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -931,9 +931,12 @@ static inline int as_batch_expired(struc
 static void as_move_to_dispatch(struct as_data *ad, struct request *rq)
 {
 	const int data_dir = rq_is_sync(rq);
+	int rw = rq_data_dir(rq);
+	struct request_list *rl = &ad->q->rq;
 
 	BUG_ON(RB_EMPTY_NODE(&rq->rb_node));
 
+	rl->count[rw]++;
 	as_antic_stop(ad);
 	ad->antic_status = ANTIC_OFF;
 
@@ -985,6 +988,7 @@ static int as_dispatch_request(struct re
 	const int reads = !list_empty(&ad->fifo_list[REQ_SYNC]);
 	const int writes = !list_empty(&ad->fifo_list[REQ_ASYNC]);
 	struct request *rq;
+	int rw;
 
 	if (unlikely(force)) {
 		/*
@@ -1133,6 +1137,9 @@ fifo_expired:
 	/*
 	 * rq is the selected appropriate request.
 	 */
+	rw = rq_data_dir(rq);
+	if (elv_queue_space(ad->q,rw) == 0)
+		return 0;
 	as_move_to_dispatch(ad, rq);
 
 	return 1;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 13553e0..4e8e6c7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -927,6 +927,9 @@ static void cfq_dispatch_insert(struct r
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
+	struct request_list *rl = &q->rq;
+	int rw = rq_data_dir(rq);
+	rl->count[rw]++;
 
 	cfq_remove_request(rq);
 	cfqq->dispatched++;
@@ -1030,6 +1033,7 @@ __cfq_dispatch_requests(struct cfq_data
 
 	do {
 		struct request *rq;
+		int rw;
 
 		/*
 		 * follow expired path, else get first next available
@@ -1037,6 +1041,10 @@ __cfq_dispatch_requests(struct cfq_data
 		if ((rq = cfq_check_fifo(cfqq)) == NULL)
 			rq = cfqq->next_rq;
 
+		rw = rq_data_dir(rq);
+		if (elv_queue_space(cfqd->queue,rw) == 0)
+			break;
+
 		/*
 		 * finally, insert request into driver dispatch list
 		 */
@@ -1118,6 +1126,7 @@ static int cfq_dispatch_requests(struct
 	dispatched = 0;
 	while ((cfqq = cfq_select_queue(cfqd)) != NULL) {
 		int max_dispatch;
+		int this_dispatch = 1;
 
 		max_dispatch = cfqd->cfq_quantum;
 		if (cfq_class_idle(cfqq))
@@ -1137,7 +1146,10 @@ static int cfq_dispatch_requests(struct
 		cfq_clear_cfqq_wait_request(cfqq);
 		del_timer(&cfqd->idle_slice_timer);
 
-		dispatched += __cfq_dispatch_requests(cfqd, cfqq, max_dispatch);
+		if ((this_dispatch = __cfq_dispatch_requests(cfqd, cfqq, max_dispatch))==0)
+			break;
+
+		dispatched += this_dispatch;
 	}
 
 	return dispatched;
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 342448c..57a15f6 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -195,6 +195,10 @@ static inline void
 deadline_move_to_dispatch(struct deadline_data *dd, struct request *rq)
 {
 	struct request_queue *q = rq->q;
+	int rw = rq_data_dir(rq);
+	struct request_list *rl = &q->rq;
+
+	rl->count[rw]++;
 
 	deadline_remove_request(q, rq);
 	elv_dispatch_add_tail(q, rq);
@@ -328,6 +332,10 @@ dispatch_request:
 	/*
 	 * rq is the selected appropriate request.
 	 */
+	data_dir = rq_data_dir(rq);
+	if (elv_queue_space(rq->q, data_dir) == 0)
+		return 0;
+
 	dd->batching++;
 	deadline_move_request(dd, rq);
 
diff --git a/block/elevator.c b/block/elevator.c
index e452deb..ab6f4d7 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -528,6 +528,32 @@ void elv_requeue_request(struct request_
 	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
+int elv_queue_space(struct request_queue *q, int rw)
+{
+
+        struct request_list *rl = &q->rq;
+
+        if (rl->count[rw]+1 >= q->nr_congestion_on) {
+                if (rl->count[rw]+1 >= q->nr_requests) {
+                        /*
+                         * The queue will fill after this allocation, so set
+                         * it as full
+                         */
+                        if (!blk_queue_full(q, rw)) {
+                                blk_set_queue_full(q, rw);
+                        } else {
+                                        /*
+                                         * The queue is full
+                                         */
+                                        return 0;
+                        }
+                }
+                blk_set_queue_congested(q, rw);
+        }
+
+        return q->nr_requests - rl->count[rw];
+}
+
 static void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8b91994..dfd4382 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -77,9 +77,6 @@ static DEFINE_PER_CPU(struct list_head,
 /* Amount of time in which a process may batch requests */
 #define BLK_BATCH_TIME	(HZ/50UL)
 
-/* Number of requests a "batching" process may submit */
-#define BLK_BATCH_REQ	32
-
 /*
  * Return the threshold (number of used requests) at which the queue is
  * considered to be congested.  It include a little hysteresis to keep the
@@ -219,7 +216,6 @@ void blk_queue_make_request(struct reque
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
-	q->nr_batching = BLK_BATCH_REQ;
 
 	q->unplug_thresh = 4;		/* hmm */
 	q->unplug_delay = (3 * HZ) / 1000;	/* 3 milliseconds */
@@ -2007,40 +2003,6 @@ blk_alloc_request(struct request_queue *
 	return rq;
 }
 
-/*
- * ioc_batching returns true if the ioc is a valid batching request and
- * should be given priority access to a request.
- */
-static inline int ioc_batching(struct request_queue *q, struct io_context *ioc)
-{
-	if (!ioc)
-		return 0;
-
-	/*
-	 * Make sure the process is able to allocate at least 1 request
-	 * even if the batch times out, otherwise we could theoretically
-	 * lose wakeups.
-	 */
-	return ioc->nr_batch_requests == q->nr_batching ||
-		(ioc->nr_batch_requests > 0
-		&& time_before(jiffies, ioc->last_waited + BLK_BATCH_TIME));
-}
-
-/*
- * ioc_set_batching sets ioc to be a new "batcher" if it is not one. This
- * will cause the process to be a "batcher" on all queues in the system. This
- * is the behaviour we want though - once it gets a wakeup it should be given
- * a nice run.
- */
-static void ioc_set_batching(struct request_queue *q, struct io_context *ioc)
-{
-	if (!ioc || ioc_batching(q, ioc))
-		return;
-
-	ioc->nr_batch_requests = q->nr_batching;
-	ioc->last_waited = jiffies;
-}
-
 static void __freed_request(struct request_queue *q, int rw)
 {
 	struct request_list *rl = &q->rq;
@@ -2060,11 +2022,13 @@ static void __freed_request(struct reque
  * A request has just been released.  Account for it, update the full and
  * congestion status, wake up any waiters.   Called under q->queue_lock.
  */
-static void freed_request(struct request_queue *q, int rw, int priv)
+static void freed_request(struct request_queue *q, int rw, int priv, int count)
 {
 	struct request_list *rl = &q->rq;
 
-	rl->count[rw]--;
+	if (count)
+		rl->count[rw]--;
+
 	if (priv)
 		rl->elvpriv--;
 
@@ -2093,42 +2057,6 @@ static struct request *get_request(struc
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
-	if (rl->count[rw]+1 >= queue_congestion_on_threshold(q)) {
-		if (rl->count[rw]+1 >= q->nr_requests) {
-			ioc = current_io_context(GFP_ATOMIC, q->node);
-			/*
-			 * The queue will fill after this allocation, so set
-			 * it as full, and mark this process as "batching".
-			 * This process will be allowed to complete a batch of
-			 * requests, others will be blocked.
-			 */
-			if (!blk_queue_full(q, rw)) {
-				ioc_set_batching(q, ioc);
-				blk_set_queue_full(q, rw);
-			} else {
-				if (may_queue != ELV_MQUEUE_MUST
-						&& !ioc_batching(q, ioc)) {
-					/*
-					 * The queue is full and the allocating
-					 * process is not a "batcher", and not
-					 * exempted by the IO scheduler
-					 */
-					goto out;
-				}
-			}
-		}
-		blk_set_queue_congested(q, rw);
-	}
-
-	/*
-	 * Only allow batching queuers to allocate up to 50% over the defined
-	 * limit of requests, otherwise we could have thousands of requests
-	 * allocated with any setting of ->nr_requests
-	 */
-	if (rl->count[rw] >= (3 * q->nr_requests / 2))
-		goto out;
-
-	rl->count[rw]++;
 	rl->starved[rw] = 0;
 
 	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
@@ -2147,7 +2075,7 @@ static struct request *get_request(struc
 		 * wait queue, but this is pretty rare.
 		 */
 		spin_lock_irq(q->queue_lock);
-		freed_request(q, rw, priv);
+		freed_request(q, rw, priv, 0);
 
 		/*
 		 * in the very unlikely event that allocation failed and no
@@ -2162,15 +2090,6 @@ rq_starved:
 
 		goto out;
 	}
-
-	/*
-	 * ioc may be NULL here, and ioc_batching will be false. That's
-	 * OK, if the queue is under the request limit then requests need
-	 * not count toward the nr_batch_requests limit. There will always
-	 * be some limit enforced by BLK_BATCH_TIME.
-	 */
-	if (ioc_batching(q, ioc))
-		ioc->nr_batch_requests--;
 	
 	rq_init(q, rq);
 
@@ -2202,23 +2121,12 @@ static struct request *get_request_wait(
 		rq = get_request(q, rw_flags, bio, GFP_NOIO);
 
 		if (!rq) {
-			struct io_context *ioc;
-
 			blk_add_trace_generic(q, bio, rw, BLK_TA_SLEEPRQ);
 
 			__generic_unplug_device(q);
 			spin_unlock_irq(q->queue_lock);
 			io_schedule();
 
-			/*
-			 * After sleeping, we become a "batching" process and
-			 * will be able to allocate at least one request, and
-			 * up to a big batch of them for a small period time.
-			 * See ioc_batching, ioc_set_batching
-			 */
-			ioc = current_io_context(GFP_NOIO, q->node);
-			ioc_set_batching(q, ioc);
-
 			spin_lock_irq(q->queue_lock);
 		}
 		finish_wait(&rl->wait[rw], &wait);
@@ -2808,12 +2716,23 @@ void __blk_put_request(struct request_qu
 	if (req->cmd_flags & REQ_ALLOCED) {
 		int rw = rq_data_dir(req);
 		int priv = req->cmd_flags & REQ_ELVPRIV;
+		int counted = 1;
 
 		BUG_ON(!list_empty(&req->queuelist));
 		BUG_ON(!hlist_unhashed(&req->hash));
 
+		/*
+		 * Request was never started or it is a scsi cmd which was
+		 * not accounted by elevators. So just increase the count,
+		 * which will be decreased after freed_request()
+		 */
+		if (!(req->cmd_flags & REQ_STARTED) || !blk_fs_request(req))
+			counted = 0;
+
 		blk_free_request(q, req);
-		freed_request(q, rw, priv);
+
+		/* update q->count only for started fs requests */
+		freed_request(q, rw, priv, counted);
 	}
 }
 
@@ -3904,8 +3823,6 @@ static struct io_context *current_io_con
 		atomic_set(&ret->refcount, 1);
 		ret->task = current;
 		ret->ioprio_changed = 0;
-		ret->last_waited = jiffies; /* doesn't matter... */
-		ret->nr_batch_requests = 0; /* because this is 0 */
 		ret->aic = NULL;
 		ret->cic_root.rb_node = NULL;
 		ret->ioc_data = NULL;
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index c23e029..c36e2ce 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -23,10 +23,16 @@ static int noop_dispatch(struct request_
 
 	if (!list_empty(&nd->queue)) {
 		struct request *rq;
+		int rw;
 		rq = list_entry(nd->queue.next, struct request, queuelist);
-		list_del_init(&rq->queuelist);
-		elv_dispatch_sort(q, rq);
-		return 1;
+		rw = rq_data_dir(rq);
+		if (force || elv_queue_space(q, rw) != 0) {
+			struct request_list *rl = &q->rq;
+			rl->count[rw]++;
+			list_del_init(&rq->queuelist);
+			elv_dispatch_sort(q, rq);
+			return 1;
+		}
 	}
 	return 0;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d18ee67..11ebeb6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -97,12 +97,6 @@ struct io_context {
 
 	unsigned int ioprio_changed;
 
-	/*
-	 * For request batching
-	 */
-	unsigned long last_waited; /* Time last woken after wait for request */
-	int nr_batch_requests;     /* Number of requests left in the batch */
-
 	struct as_io_context *aic;
 	struct rb_root cic_root;
 	void *ioc_data;
@@ -421,7 +415,6 @@ struct request_queue
 	unsigned long		nr_requests;	/* Max # of requests */
 	unsigned int		nr_congestion_on;
 	unsigned int		nr_congestion_off;
-	unsigned int		nr_batching;
 
 	unsigned int		max_sectors;
 	unsigned int		max_hw_sectors;
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 639624b..123f92b 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -106,6 +106,7 @@ extern void elv_merged_request(struct re
 extern void elv_dequeue_request(struct request_queue *, struct request *);
 extern void elv_requeue_request(struct request_queue *, struct request *);
 extern int elv_queue_empty(struct request_queue *);
+extern int elv_queue_space(struct request_queue *q, int rw);
 extern struct request *elv_next_request(struct request_queue *q);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);


