Return-Path: <linux-kernel-owner+w=401wt.eu-S1031685AbXEAMMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031685AbXEAMMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031686AbXEAMMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:12:20 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9804 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031685AbXEAMMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:12:18 -0400
Date: Tue, 1 May 2007 14:11:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFQ IO scheduler patch series - AIM7 DBase results on a 16-way  IA64
Message-ID: <20070501121139.GA4653@kernel.dk>
References: <4635D59C.4050300@hp.com> <20070430122753.GL21015@kernel.dk> <46372C8B.7090901@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46372C8B.7090901@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01 2007, Alan D. Brunelle wrote:
> Jens Axboe wrote:
> >On Mon, Apr 30 2007, Alan D. Brunelle wrote:
> >>The results from a single run of an AIM7 DBase load on a 16-way ia64 box 
> >>(64GB RAM + 144 FC disks) showed a slight regression (~0.5%) by adding 
> >>in this patch. (Graph can be found at   
> >>http://free.linux.hp.com/~adb/cfq/cfq_dbase.png   ) It is only a single 
> >>set of runs, on a single platform, but it is something to keep an eye on 
> >>as the regression showed itself across the complete run.
> >
> >Do you know if this regression is due to worse IO performance, or
> >increased system CPU usage?
> We performed two point runs yesterday (20,000 and 50,000 tasks) and here 
> are the results:
> 
> Kernel  Tasks  Jobs per Minute  %sys (avg)
> ------  -----  ---------------  ----------
> 2.6.21  20000     60,831.1        39.83%
> CFQ br  20000     60,237.4        40.80%
>                    -0.98%        +2.44%
> 
> 2.6.21  50000     60,881.6        40.43%
> CFQ br  50000     60,400.6        40.80%
>                    -0.79%        +0.92%
> 
> So we're seeing a slight IO performance regression with a slight 
> increase in %system with the CFQ branch. (A chart of the complete run 
> values is up on  http://free.linux.hp.com/~adb/cfq/cfq_20k50k.png  ).

Alan, can you repeat that same run with this patch applied? It
reinstates the cfq lookup hash, which could account for increased system
utilization.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 64df3fa..0af5e9a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
+#include <linux/hash.h>
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 
@@ -37,6 +38,14 @@ static int cfq_slice_idle = HZ / 125;
 
 #define CFQ_SLICE_SCALE		(5)
 
+#define CFQ_KEY_ASYNC		(0)
+
+/*
+ * for the hash of cfqq inside the cfqd
+ */
+#define CFQ_QHASH_SHIFT		6
+#define CFQ_QHASH_ENTRIES	(1 << CFQ_QHASH_SHIFT)
+
 #define RQ_CIC(rq)		((struct cfq_io_context*)(rq)->elevator_private)
 #define RQ_CFQQ(rq)		((rq)->elevator_private2)
 
@@ -53,6 +62,8 @@ static struct completion *ioc_gone;
 #define ASYNC			(0)
 #define SYNC			(1)
 
+#define cfq_cfqq_sync(cfqq)	((cfqq)->key != CFQ_KEY_ASYNC)
+
 #define sample_valid(samples)	((samples) > 80)
 
 /*
@@ -79,6 +90,11 @@ struct cfq_data {
 	struct cfq_rb_root service_tree;
 	unsigned int busy_queues;
 
+	/*
+	 * cfqq lookup hash
+	 */
+	struct hlist_head *cfq_hash;
+
 	int rq_in_driver;
 	int sync_flight;
 	int hw_tag;
@@ -122,6 +138,10 @@ struct cfq_queue {
 	atomic_t ref;
 	/* parent cfq_data */
 	struct cfq_data *cfqd;
+	/* cfqq lookup hash */
+	struct hlist_node cfq_hash;
+	/* hash key */
+	unsigned int key;
 	/* service_tree member */
 	struct rb_node rb_node;
 	/* service_tree key */
@@ -166,7 +186,6 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_prio_changed,	/* task priority has changed */
 	CFQ_CFQQ_FLAG_queue_new,	/* queue never been serviced */
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
-	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -193,38 +212,11 @@ CFQ_CFQQ_FNS(idle_window);
 CFQ_CFQQ_FNS(prio_changed);
 CFQ_CFQQ_FNS(queue_new);
 CFQ_CFQQ_FNS(slice_new);
-CFQ_CFQQ_FNS(sync);
 #undef CFQ_CFQQ_FNS
 
+static struct cfq_queue *cfq_find_cfq_hash(struct cfq_data *, unsigned int, unsigned short);
 static void cfq_dispatch_insert(request_queue_t *, struct request *);
-static struct cfq_queue *cfq_get_queue(struct cfq_data *, int,
-				       struct task_struct *, gfp_t);
-static struct cfq_io_context *cfq_cic_rb_lookup(struct cfq_data *,
-						struct io_context *);
-
-static inline struct cfq_queue *cic_to_cfqq(struct cfq_io_context *cic,
-					    int is_sync)
-{
-	return cic->cfqq[!!is_sync];
-}
-
-static inline void cic_set_cfqq(struct cfq_io_context *cic,
-				struct cfq_queue *cfqq, int is_sync)
-{
-	cic->cfqq[!!is_sync] = cfqq;
-}
-
-/*
- * We regard a request as SYNC, if it's either a read or has the SYNC bit
- * set (in which case it could also be direct WRITE).
- */
-static inline int cfq_bio_sync(struct bio *bio)
-{
-	if (bio_data_dir(bio) == READ || bio_sync(bio))
-		return 1;
-
-	return 0;
-}
+static struct cfq_queue *cfq_get_queue(struct cfq_data *, unsigned int, struct task_struct *, gfp_t);
 
 /*
  * scheduler run of queue, if there are requests pending and no one in the
@@ -243,6 +235,17 @@ static int cfq_queue_empty(request_queue_t *q)
 	return !cfqd->busy_queues;
 }
 
+static inline pid_t cfq_queue_pid(struct task_struct *task, int rw, int is_sync)
+{
+	/*
+	 * Use the per-process queue, for read requests and syncronous writes
+	 */
+	if (!(rw & REQ_RW) || is_sync)
+		return task->pid;
+
+	return CFQ_KEY_ASYNC;
+}
+
 /*
  * Scale schedule slice based on io priority. Use the sync time slice only
  * if a queue is marked sync and has sync io queued. A sync queue with async
@@ -605,14 +608,10 @@ static struct request *
 cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 {
 	struct task_struct *tsk = current;
-	struct cfq_io_context *cic;
+	pid_t key = cfq_queue_pid(tsk, bio_data_dir(bio), bio_sync(bio));
 	struct cfq_queue *cfqq;
 
-	cic = cfq_cic_rb_lookup(cfqd, tsk->io_context);
-	if (!cic)
-		return NULL;
-
-	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
+	cfqq = cfq_find_cfq_hash(cfqd, key, tsk->ioprio);
 	if (cfqq) {
 		sector_t sector = bio->bi_sector + bio_sectors(bio);
 
@@ -706,24 +705,23 @@ static int cfq_allow_merge(request_queue_t *q, struct request *rq,
 			   struct bio *bio)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct cfq_io_context *cic;
+	const int rw = bio_data_dir(bio);
 	struct cfq_queue *cfqq;
+	pid_t key;
 
 	/*
 	 * Disallow merge of a sync bio into an async request.
 	 */
-	if (cfq_bio_sync(bio) && !rq_is_sync(rq))
+	if ((bio_data_dir(bio) == READ || bio_sync(bio)) && !rq_is_sync(rq))
 		return 0;
 
 	/*
 	 * Lookup the cfqq that this bio will be queued with. Allow
 	 * merge only if rq is queued there.
 	 */
-	cic = cfq_cic_rb_lookup(cfqd, current->io_context);
-	if (!cic)
-		return 0;
+	key = cfq_queue_pid(current, rw, bio_sync(bio));
+	cfqq = cfq_find_cfq_hash(cfqd, key, current->ioprio);
 
-	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
 	if (cfqq == RQ_CFQQ(rq))
 		return 1;
 
@@ -1156,9 +1154,37 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 		cfq_schedule_dispatch(cfqd);
 	}
 
+	/*
+	 * it's on the empty list and still hashed
+	 */
+	hlist_del(&cfqq->cfq_hash);
 	kmem_cache_free(cfq_pool, cfqq);
 }
 
+static struct cfq_queue *
+__cfq_find_cfq_hash(struct cfq_data *cfqd, unsigned int key, unsigned int prio,
+		    const int hashval)
+{
+	struct hlist_head *hash_list = &cfqd->cfq_hash[hashval];
+	struct hlist_node *entry;
+	struct cfq_queue *__cfqq;
+
+	hlist_for_each_entry(__cfqq, entry, hash_list, cfq_hash) {
+		const unsigned short __p = IOPRIO_PRIO_VALUE(__cfqq->org_ioprio_class, __cfqq->org_ioprio);
+
+		if (__cfqq->key == key && (__p == prio || !prio))
+			return __cfqq;
+	}
+
+	return NULL;
+}
+
+static struct cfq_queue *
+cfq_find_cfq_hash(struct cfq_data *cfqd, unsigned int key, unsigned short prio)
+{
+	return __cfq_find_cfq_hash(cfqd, key, prio, hash_long(key, CFQ_QHASH_SHIFT));
+}
+
 static void cfq_free_io_context(struct io_context *ioc)
 {
 	struct cfq_io_context *__cic;
@@ -1319,7 +1345,7 @@ static inline void changed_ioprio(struct cfq_io_context *cic)
 	cfqq = cic->cfqq[ASYNC];
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, ASYNC, cic->ioc->task,
+		new_cfqq = cfq_get_queue(cfqd, CFQ_KEY_ASYNC, cic->ioc->task,
 					 GFP_ATOMIC);
 		if (new_cfqq) {
 			cic->cfqq[ASYNC] = new_cfqq;
@@ -1351,16 +1377,16 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 }
 
 static struct cfq_queue *
-cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct task_struct *tsk,
+cfq_get_queue(struct cfq_data *cfqd, unsigned int key, struct task_struct *tsk,
 	      gfp_t gfp_mask)
 {
+	const int hashval = hash_long(key, CFQ_QHASH_SHIFT);
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
-	struct cfq_io_context *cic;
+	unsigned short ioprio;
 
 retry:
-	cic = cfq_cic_rb_lookup(cfqd, tsk->io_context);
-	/* cic always exists here */
-	cfqq = cic_to_cfqq(cic, is_sync);
+	ioprio = tsk->ioprio;
+	cfqq = __cfq_find_cfq_hash(cfqd, key, ioprio, hashval);
 
 	if (!cfqq) {
 		if (new_cfqq) {
@@ -1385,20 +1411,20 @@ retry:
 
 		memset(cfqq, 0, sizeof(*cfqq));
 
+		INIT_HLIST_NODE(&cfqq->cfq_hash);
 		RB_CLEAR_NODE(&cfqq->rb_node);
 		INIT_LIST_HEAD(&cfqq->fifo);
 
+		cfqq->key = key;
+		hlist_add_head(&cfqq->cfq_hash, &cfqd->cfq_hash[hashval]);
 		atomic_set(&cfqq->ref, 0);
 		cfqq->cfqd = cfqd;
 
-		if (is_sync) {
+		if (key != CFQ_KEY_ASYNC)
 			cfq_mark_cfqq_idle_window(cfqq);
-			cfq_mark_cfqq_sync(cfqq);
-		}
 
 		cfq_mark_cfqq_prio_changed(cfqq);
 		cfq_mark_cfqq_queue_new(cfqq);
-
 		cfq_init_prio_data(cfqq);
 	}
 
@@ -1434,9 +1460,6 @@ cfq_cic_rb_lookup(struct cfq_data *cfqd, struct io_context *ioc)
 	struct cfq_io_context *cic;
 	void *k, *key = cfqd;
 
-	if (unlikely(!ioc))
-		return NULL;
-
 	/*
 	 * we maintain a last-hit cache, to avoid browsing over the tree
 	 */
@@ -1832,8 +1855,10 @@ static int cfq_may_queue(request_queue_t *q, int rw)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
-	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
+	unsigned int key;
+
+	key = cfq_queue_pid(tsk, rw, rw & REQ_RW_SYNC);
 
 	/*
 	 * don't force setup of a queue from here, as a call to may_queue
@@ -1841,11 +1866,7 @@ static int cfq_may_queue(request_queue_t *q, int rw)
 	 * so just lookup a possibly existing queue, or return 'may queue'
 	 * if that fails
 	 */
-	cic = cfq_cic_rb_lookup(cfqd, tsk->io_context);
-	if (!cic)
-		return ELV_MQUEUE_MAY;
-
-	cfqq = cic_to_cfqq(cic, rw & REQ_RW_SYNC);
+	cfqq = cfq_find_cfq_hash(cfqd, key, tsk->ioprio);
 	if (cfqq) {
 		cfq_init_prio_data(cfqq);
 		cfq_prio_boost(cfqq);
@@ -1889,6 +1910,7 @@ cfq_set_request(request_queue_t *q, struct request *rq, gfp_t gfp_mask)
 	struct cfq_io_context *cic;
 	const int rw = rq_data_dir(rq);
 	const int is_sync = rq_is_sync(rq);
+	pid_t key = cfq_queue_pid(tsk, rw, is_sync);
 	struct cfq_queue *cfqq;
 	unsigned long flags;
 
@@ -1901,15 +1923,14 @@ cfq_set_request(request_queue_t *q, struct request *rq, gfp_t gfp_mask)
 	if (!cic)
 		goto queue_fail;
 
-	cfqq = cic_to_cfqq(cic, is_sync);
-	if (!cfqq) {
-		cfqq = cfq_get_queue(cfqd, is_sync, tsk, gfp_mask);
-
+	if (!cic->cfqq[is_sync]) {
+		cfqq = cfq_get_queue(cfqd, key, tsk, gfp_mask);
 		if (!cfqq)
 			goto queue_fail;
 
-		cic_set_cfqq(cic, cfqq, is_sync);
-	}
+		cic->cfqq[is_sync] = cfqq;
+	} else
+		cfqq = cic->cfqq[is_sync];
 
 	cfqq->allocated[rw]++;
 	cfq_clear_cfqq_must_alloc(cfqq);
@@ -2039,12 +2060,14 @@ static void cfq_exit_queue(elevator_t *e)
 
 	cfq_shutdown_timer_wq(cfqd);
 
+	kfree(cfqd->cfq_hash);
 	kfree(cfqd);
 }
 
 static void *cfq_init_queue(request_queue_t *q)
 {
 	struct cfq_data *cfqd;
+	int i;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL, q->node);
 	if (!cfqd)
@@ -2055,6 +2078,13 @@ static void *cfq_init_queue(request_queue_t *q)
 	cfqd->service_tree = CFQ_RB_ROOT;
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
+	cfqd->cfq_hash = kmalloc_node(sizeof(struct hlist_head) * CFQ_QHASH_ENTRIES, GFP_KERNEL, q->node);
+	if (!cfqd->cfq_hash)
+		goto out_free;
+
+	for (i = 0; i < CFQ_QHASH_ENTRIES; i++)
+		INIT_HLIST_HEAD(&cfqd->cfq_hash[i]);
+
 	cfqd->queue = q;
 
 	init_timer(&cfqd->idle_slice_timer);
@@ -2078,6 +2108,9 @@ static void *cfq_init_queue(request_queue_t *q)
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 
 	return cfqd;
+out_free:
+	kfree(cfqd);
+	return NULL;
 }
 
 static void cfq_slab_kill(void)

-- 
Jens Axboe

