Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYCLL6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYCLL6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYCLL5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:57:15 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25744 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYCLL5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:57:10 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, dgc@sgi.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/7] block: add test code for testing CPU affinity
Date: Wed, 12 Mar 2008 12:55:40 +0100
Message-Id: <1205322940-20127-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supports several modes:

- Force IO queue affinity to a specific mask of CPUs
- Force IO completion affinity to a specific mask of CPUs
- Force completion of a request on the same CPU that queued it
- Allow IO submitter to set BIO_CPU_AFFINE in the bio, in which case
  completion will be done on the same CPU as the submitter

Test code so far, this variant being based on using the more scalable
__smp_call_function_single().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c         |   77 ++++++++++++++++++++++-------------
 block/blk-settings.c     |   49 ++++++++++++++++++++++-
 block/blk-softirq.c      |   98 +++++++++++++++++++++++++++++++--------------
 block/blk-sysfs.c        |   86 ++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h      |    1 +
 include/linux/blkdev.h   |   12 +++++-
 include/linux/elevator.h |    8 ++--
 7 files changed, 264 insertions(+), 67 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ec529dc..8b04a15 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -110,7 +110,7 @@ EXPORT_SYMBOL(blk_get_backing_dev_info);
 void rq_init(struct request_queue *q, struct request *rq)
 {
 	INIT_LIST_HEAD(&rq->queuelist);
-	INIT_LIST_HEAD(&rq->donelist);
+	rq->cpu = -1;
 	rq->q = q;
 	rq->sector = rq->hard_sector = (sector_t) -1;
 	rq->nr_sectors = rq->hard_nr_sectors = 0;
@@ -197,6 +197,11 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 }
 EXPORT_SYMBOL(blk_dump_rq_flags);
 
+static inline int blk_is_io_cpu(struct request_queue *q)
+{
+	return cpu_isset(smp_processor_id(), q->queue_cpu);
+}
+
 /*
  * "plug" the device if there are no outstanding requests: this will
  * force the transfer to start only after we have put all the requests
@@ -217,6 +222,10 @@ void blk_plug_device(struct request_queue *q)
 		return;
 
 	if (!test_and_set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
+		/*
+		 * no need to care about the io cpu here, since the
+		 * timeout handler needs to punt to kblockd anyway
+		 */
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
 		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
 	}
@@ -316,6 +325,22 @@ void blk_unplug(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_unplug);
 
+static void blk_invoke_request_fn(struct request_queue *q)
+{
+	/*
+	 * one level of recursion is ok and is much faster than kicking
+	 * the unplug handling
+	 */
+	if (blk_is_io_cpu(q) &&
+	    !test_and_set_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
+		q->request_fn(q);
+		clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
+	} else {
+		set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+		kblockd_schedule_work(q, &q->unplug_work);
+	}
+}
+
 /**
  * blk_start_queue - restart a previously stopped queue
  * @q:    The &struct request_queue in question
@@ -330,18 +355,7 @@ void blk_start_queue(struct request_queue *q)
 	WARN_ON(!irqs_disabled());
 
 	clear_bit(QUEUE_FLAG_STOPPED, &q->queue_flags);
-
-	/*
-	 * one level of recursion is ok and is much faster than kicking
-	 * the unplug handling
-	 */
-	if (!test_and_set_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
-		q->request_fn(q);
-		clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
-	} else {
-		blk_plug_device(q);
-		kblockd_schedule_work(q, &q->unplug_work);
-	}
+	blk_invoke_request_fn(q);
 }
 EXPORT_SYMBOL(blk_start_queue);
 
@@ -398,19 +412,8 @@ void blk_run_queue(struct request_queue *q)
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_remove_plug(q);
 
-	/*
-	 * Only recurse once to avoid overrunning the stack, let the unplug
-	 * handling reinvoke the handler shortly if we already got there.
-	 */
-	if (!elv_queue_empty(q)) {
-		if (!test_and_set_bit(QUEUE_FLAG_REENTER, &q->queue_flags)) {
-			q->request_fn(q);
-			clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
-		} else {
-			blk_plug_device(q);
-			kblockd_schedule_work(q, &q->unplug_work);
-		}
-	}
+	if (!elv_queue_empty(q))
+		blk_invoke_request_fn(q);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
@@ -469,6 +472,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
+	cpus_setall(q->queue_cpu);
+	cpus_setall(q->complete_cpu);
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
 	err = bdi_init(&q->backing_dev_info);
@@ -872,7 +877,10 @@ EXPORT_SYMBOL(blk_get_request);
  */
 void blk_start_queueing(struct request_queue *q)
 {
-	if (!blk_queue_plugged(q))
+	if (!blk_is_io_cpu(q)) {
+		set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+		kblockd_schedule_work(q, &q->unplug_work);
+	} else if (!blk_queue_plugged(q))
 		q->request_fn(q);
 	else
 		__generic_unplug_device(q);
@@ -1190,13 +1198,15 @@ get_rq:
 	init_request_from_bio(req, bio);
 
 	spin_lock_irq(q->queue_lock);
+	if (q->queue_flags & (1 << QUEUE_FLAG_SAME_COMP) ||
+	    bio_flagged(bio, BIO_CPU_AFFINE))
+		req->cpu = smp_processor_id();
 	if (elv_queue_empty(q))
 		blk_plug_device(q);
 	add_request(q, req);
 out:
 	if (sync)
 		__generic_unplug_device(q);
-
 	spin_unlock_irq(q->queue_lock);
 	return 0;
 
@@ -1946,7 +1956,16 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 {
-	return queue_work(kblockd_workqueue, work);
+	int cpu;
+
+	if (blk_is_io_cpu(q))
+		return queue_work(kblockd_workqueue, work);
+
+	/*
+	 * would need to be improved, of course...
+	 */
+	cpu = first_cpu(q->queue_cpu);
+	return queue_work_on_cpu(kblockd_workqueue, work, cpu);
 }
 EXPORT_SYMBOL(kblockd_schedule_work);
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 1344a0e..1365dd4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -405,7 +405,54 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
-static int __init blk_settings_init(void)
+static int blk_queue_set_cpumask(cpumask_t *cpumask, int cpu)
+{
+	if (cpu == -1)
+		cpus_setall(*cpumask);
+	else if (!cpu_isset(cpu, cpu_possible_map)) {
+		cpus_setall(*cpumask);
+		return -EINVAL;
+	} else {
+		cpus_clear(*cpumask);
+		cpu_set(cpu, *cpumask);
+	}
+
+	return 0;
+}
+
+/**
+ * blk_queue_set_completion_cpu - Set IO CPU for completions
+ * @q:     the request queue for the device
+ * @cpu:   cpu
+ *
+ * Description:
+ *    This function allows a driver to set a CPU that should handle completions
+ *    for this device.
+ *
+ **/
+int blk_queue_set_completion_cpu(struct request_queue *q, int cpu)
+{
+	return blk_queue_set_cpumask(&q->complete_cpu, cpu);
+}
+EXPORT_SYMBOL(blk_queue_set_completion_cpu);
+
+/**
+ * blk_queue_set_queue_cpu - Set IO CPU for queuing
+ * @q:     the request queue for the device
+ * @cpu:   cpu
+ *
+ * Description:
+ *    This function allows a driver to set a CPU that should handle queuing
+ *    for this device.
+ *
+ **/
+int blk_queue_set_queue_cpu(struct request_queue *q, int cpu)
+{
+	return blk_queue_set_cpumask(&q->queue_cpu, cpu);
+}
+EXPORT_SYMBOL(blk_queue_set_queue_cpu);
+
+int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
 	blk_max_pfn = max_pfn - 1;
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 05f9451..0f90383 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -13,6 +13,50 @@
 
 static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
 
+static void blk_done_softirq(struct softirq_action *h)
+{
+	struct list_head *cpu_list, local_list;
+
+	local_irq_disable();
+	cpu_list = &__get_cpu_var(blk_cpu_done);
+	list_replace_init(cpu_list, &local_list);
+	local_irq_enable();
+
+	while (!list_empty(&local_list)) {
+		struct request *rq;
+
+		rq = list_entry(local_list.next, struct request, csd.list);
+		list_del_init(&rq->csd.list);
+		rq->q->softirq_done_fn(rq);
+	}
+}
+
+static void trigger_softirq(void *data)
+{
+	struct list_head *list = &__get_cpu_var(blk_cpu_done);
+	struct request *rq = data;
+
+	if (!list_empty(list)) {
+		INIT_LIST_HEAD(&rq->csd.list);
+		local_irq_disable();
+		list_add_tail(&rq->csd.list, list);
+		local_irq_enable();
+		blk_done_softirq(NULL);
+	} else
+		rq->q->softirq_done_fn(rq);
+}
+
+static void raise_blk_irq(int cpu, struct request *rq)
+{
+	struct call_single_data *data = &rq->csd;
+
+	data->func = trigger_softirq;
+	data->info = rq;
+	data->flags = 0;
+
+	__smp_call_function_single(cpu, data);
+}
+
 static int __cpuinit blk_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
@@ -33,33 +77,10 @@ static int __cpuinit blk_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-
-static struct notifier_block blk_cpu_notifier __cpuinitdata = {
+static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 	.notifier_call	= blk_cpu_notify,
 };
 
-/*
- * splice the completion data to a local structure and hand off to
- * process_completion_queue() to complete the requests
- */
-static void blk_done_softirq(struct softirq_action *h)
-{
-	struct list_head *cpu_list, local_list;
-
-	local_irq_disable();
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_replace_init(cpu_list, &local_list);
-	local_irq_enable();
-
-	while (!list_empty(&local_list)) {
-		struct request *rq;
-
-		rq = list_entry(local_list.next, struct request, donelist);
-		list_del_init(&rq->donelist);
-		rq->q->softirq_done_fn(rq);
-	}
-}
-
 /**
  * blk_complete_request - end I/O on a request
  * @req:      the request being processed
@@ -71,25 +92,40 @@ static void blk_done_softirq(struct softirq_action *h)
  *     through a softirq handler. The user must have registered a completion
  *     callback through blk_queue_softirq_done().
  **/
-
 void blk_complete_request(struct request *req)
 {
-	struct list_head *cpu_list;
+	struct request_queue *q = req->q;
 	unsigned long flags;
+	int ccpu, cpu;
 
-	BUG_ON(!req->q->softirq_done_fn);
+	BUG_ON(!q->softirq_done_fn);
 
 	local_irq_save(flags);
+	cpu = smp_processor_id();
 
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_add_tail(&req->donelist, cpu_list);
-	raise_softirq_irqoff(BLOCK_SOFTIRQ);
+	if ((q->queue_flags & (1 << QUEUE_FLAG_SAME_COMP)) && req->cpu != -1)
+		ccpu = req->cpu;
+	else if (cpu_isset(cpu, q->complete_cpu))
+		ccpu = cpu;
+	else
+		ccpu = first_cpu(q->complete_cpu);
+
+	if (ccpu == cpu) {
+		struct list_head *list = &__get_cpu_var(blk_cpu_done);
+
+		INIT_LIST_HEAD(&req->csd.list);
+		list_add_tail(&req->csd.list, list);
+
+		if (list->next == &req->csd.list)
+			raise_softirq_irqoff(BLOCK_SOFTIRQ);
+	} else
+		raise_blk_irq(ccpu, req);
 
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(blk_complete_request);
 
-int __init blk_softirq_init(void)
+__init int blk_softirq_init(void)
 {
 	int i;
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 54d0db1..947e463 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -135,6 +135,71 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_complete_affinity_show(struct request_queue *q, char *page)
+{
+	ssize_t len = cpumask_scnprintf(page, PAGE_SIZE, q->complete_cpu);
+
+	len += sprintf(page + len, "\n");
+	return len;
+}
+
+static ssize_t queue_complete_affinity_store(struct request_queue *q,
+					     const char *page, size_t count)
+{
+	char *p = (char *) page;
+	long val;
+
+	val = simple_strtol(p, &p, 10);
+	spin_lock_irq(q->queue_lock);
+	blk_queue_set_completion_cpu(q, val);
+	spin_unlock_irq(q->queue_lock);
+	return count;
+}
+
+static ssize_t queue_queue_affinity_show(struct request_queue *q, char *page)
+{
+	ssize_t len = cpumask_scnprintf(page, PAGE_SIZE, q->queue_cpu);
+
+	len += sprintf(page + len, "\n");
+	return len;
+}
+
+static ssize_t queue_queue_affinity_store(struct request_queue *q,
+					  const char *page, size_t count)
+{
+	char *p = (char *) page;
+	long val;
+
+	val = simple_strtol(p, &p, 10);
+	spin_lock_irq(q->queue_lock);
+	blk_queue_set_queue_cpu(q, val);
+	spin_unlock_irq(q->queue_lock);
+	return count;
+}
+
+static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
+{
+	unsigned int same = (q->queue_flags & 1 << (QUEUE_FLAG_SAME_COMP)) != 0;
+
+	return queue_var_show(same, page);
+}
+
+static ssize_t
+queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long val;
+	ssize_t ret;
+
+	ret = queue_var_store(&val, page, count);
+	spin_lock_irq(q->queue_lock);
+	if (val)
+		q->queue_flags |= (1 << QUEUE_FLAG_SAME_COMP);
+	else
+		q->queue_flags &= ~(1 << QUEUE_FLAG_SAME_COMP);
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -170,6 +235,24 @@ static struct queue_sysfs_entry queue_hw_sector_size_entry = {
 	.show = queue_hw_sector_size_show,
 };
 
+static struct queue_sysfs_entry queue_complete_affinity_entry = {
+	.attr = {.name = "completion_affinity", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_complete_affinity_show,
+	.store = queue_complete_affinity_store,
+};
+
+static struct queue_sysfs_entry queue_queue_affinity_entry = {
+	.attr = {.name = "queue_affinity", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_queue_affinity_show,
+	.store = queue_queue_affinity_store,
+};
+
+static struct queue_sysfs_entry queue_rq_affinity_entry = {
+	.attr = {.name = "rq_affinity", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_rq_affinity_show,
+	.store = queue_rq_affinity_store,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -177,6 +260,9 @@ static struct attribute *default_attrs[] = {
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
+	&queue_complete_affinity_entry.attr,
+	&queue_queue_affinity_entry.attr,
+	&queue_rq_affinity_entry.attr,
 	NULL,
 };
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4c59bdc..6c4c8d7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -127,6 +127,7 @@ struct bio {
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
 #define BIO_EOPNOTSUPP	7	/* not supported */
+#define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f48f32f..4038b6f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/stringify.h>
 #include <linux/bsg.h>
+#include <linux/smp.h>
 
 #include <asm/scatterlist.h>
 
@@ -143,7 +144,8 @@ enum rq_flag_bits {
  */
 struct request {
 	struct list_head queuelist;
-	struct list_head donelist;
+	struct call_single_data csd;
+	int cpu;
 
 	struct request_queue *q;
 
@@ -295,9 +297,12 @@ struct request_queue
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
-	softirq_done_fn		*softirq_done_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 
+	softirq_done_fn		*softirq_done_fn;
+	cpumask_t		queue_cpu;
+	cpumask_t		complete_cpu;
+
 	/*
 	 * Dispatch queue sorting
 	 */
@@ -405,6 +410,7 @@ struct request_queue
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
+#define QUEUE_FLAG_SAME_COMP	10	/* force complete on same CPU */
 
 enum {
 	/*
@@ -710,6 +716,8 @@ extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
+extern int blk_queue_set_queue_cpu(struct request_queue *, int);
+extern int blk_queue_set_completion_cpu(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 639624b..bb791c3 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -173,15 +173,15 @@ enum {
 #define rb_entry_rq(node)	rb_entry((node), struct request, rb_node)
 
 /*
- * Hack to reuse the donelist list_head as the fifo time holder while
+ * Hack to reuse the csd.list list_head as the fifo time holder while
  * the request is in the io scheduler. Saves an unsigned long in rq.
  */
-#define rq_fifo_time(rq)	((unsigned long) (rq)->donelist.next)
-#define rq_set_fifo_time(rq,exp)	((rq)->donelist.next = (void *) (exp))
+#define rq_fifo_time(rq)	((unsigned long) (rq)->csd.list.next)
+#define rq_set_fifo_time(rq,exp)	((rq)->csd.list.next = (void *) (exp))
 #define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
 #define rq_fifo_clear(rq)	do {		\
 	list_del_init(&(rq)->queuelist);	\
-	INIT_LIST_HEAD(&(rq)->donelist);	\
+	INIT_LIST_HEAD(&(rq)->csd.list);	\
 	} while (0)
 
 /*
-- 
1.5.4.GIT

