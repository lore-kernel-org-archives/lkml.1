Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbYBGJXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYBGJXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbYBGJUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:20:20 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18523 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYBGJUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:20:05 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 8/8] block: add test code for testing CPU affinity
Date: Thu,  7 Feb 2008 10:19:05 +0100
Message-Id: <1202375945-29525-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.22.g7a20
In-Reply-To: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supports several modes:

- Force IO queue affinity to a specific mask of CPUs
- Force IO completion affinity to a specific mask of CPUs
- Force completion of a request on the same CPU that queued it

Test code so far.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |   80 ++++++++++++++++++++++++-------------
 block/blk-settings.c   |   47 +++++++++++++++++++++
 block/blk-softirq.c    |  105 ++++++++++++++++++++++++++++++++++++++----------
 block/blk-sysfs.c      |   85 ++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    8 ++++
 5 files changed, 275 insertions(+), 50 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 34a475b..bda4623 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -103,6 +103,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->donelist);
 
+	rq->cpu = -1;
 	rq->errors = 0;
 	rq->bio = rq->biotail = NULL;
 	INIT_HLIST_NODE(&rq->hash);
@@ -180,6 +181,11 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
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
@@ -200,6 +206,10 @@ void blk_plug_device(struct request_queue *q)
 		return;
 
 	if (!test_and_set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
+		/*
+		 * no need to care about the io cpu here, since the
+		 * timeout handler needs to punt to kblockd anyway
+		 */
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
 		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
 	}
@@ -299,6 +309,22 @@ void blk_unplug(struct request_queue *q)
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
@@ -313,18 +339,7 @@ void blk_start_queue(struct request_queue *q)
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
 
@@ -381,19 +396,8 @@ void blk_run_queue(struct request_queue *q)
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
@@ -453,6 +457,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
+	cpus_setall(q->queue_cpu);
+	cpus_setall(q->complete_cpu);
+	q->force_same_complete = 0;
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
 	err = bdi_init(&q->backing_dev_info);
@@ -857,7 +864,10 @@ EXPORT_SYMBOL(blk_get_request);
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
@@ -1160,13 +1170,18 @@ get_rq:
 	init_request_from_bio(req, bio);
 
 	spin_lock_irq(q->queue_lock);
+	if (q->force_same_complete)
+		req->cpu = smp_processor_id();
 	if (elv_queue_empty(q))
 		blk_plug_device(q);
 	add_request(q, req);
 out:
 	if (sync)
 		__generic_unplug_device(q);
-
+	if (cpu_isset(smp_processor_id(), q->queue_cpu))
+		q->local_queue++;
+	else
+		q->remote_queue++;
 	spin_unlock_irq(q->queue_lock);
 	return 0;
 
@@ -1912,7 +1927,16 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 
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
index c8d0c57..2126139 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -386,6 +386,53 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
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
 int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 05f9451..5ae8345 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -11,29 +11,51 @@
 
 #include "blk.h"
 
-static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
+struct blk_comp {
+	spinlock_t lock;
+	struct list_head list;
+	int dead;
+};
+static DEFINE_PER_CPU(struct blk_comp, blk_cpu_done);
 
 static int __cpuinit blk_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
-	/*
-	 * If a CPU goes away, splice its entries to the current CPU
-	 * and trigger a run of the softirq
-	 */
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		int cpu = (unsigned long) hcpu;
+	int cpu = (unsigned long) hcpu;
+	struct blk_comp *bc;
+
+	switch (action) {
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN: {
+		/*
+		 * If a CPU goes away, splice its entries to the current CPU
+		 * and trigger a run of the softirq
+		 */
+		struct blk_comp *dead;
 
 		local_irq_disable();
-		list_splice_init(&per_cpu(blk_cpu_done, cpu),
-				 &__get_cpu_var(blk_cpu_done));
+		bc = &__get_cpu_var(blk_cpu_done);
+		dead = &per_cpu(blk_cpu_done, cpu);
+		double_spin_lock(&bc->lock, &dead->lock, bc < dead);
+		list_splice_init(&dead->list, &bc->list);
+		dead->dead = 1;
+		double_spin_unlock(&bc->lock, &dead->lock, bc < dead);
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 		local_irq_enable();
+		break;
+		}
+	case CPU_ONLINE: {
+		local_irq_disable();
+		bc = &per_cpu(blk_cpu_done, cpu);
+		bc->dead = 0;
+		local_irq_enable();
+		break;
+		}
 	}
 
 	return NOTIFY_OK;
 }
 
-
 static struct notifier_block blk_cpu_notifier __cpuinitdata = {
 	.notifier_call	= blk_cpu_notify,
 };
@@ -44,11 +66,14 @@ static struct notifier_block blk_cpu_notifier __cpuinitdata = {
  */
 static void blk_done_softirq(struct softirq_action *h)
 {
-	struct list_head *cpu_list, local_list;
+	struct blk_comp *bc;
+	struct list_head local_list;
 
 	local_irq_disable();
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_replace_init(cpu_list, &local_list);
+	bc = &__get_cpu_var(blk_cpu_done);
+	spin_lock(&bc->lock);
+	list_replace_init(&bc->list, &local_list);
+	spin_unlock(&bc->lock);
 	local_irq_enable();
 
 	while (!list_empty(&local_list)) {
@@ -71,30 +96,66 @@ static void blk_done_softirq(struct softirq_action *h)
  *     through a softirq handler. The user must have registered a completion
  *     callback through blk_queue_softirq_done().
  **/
-
 void blk_complete_request(struct request *req)
 {
-	struct list_head *cpu_list;
+	int ccpu, cpu, was_empty;
+	struct request_queue *q = req->q;
+	struct blk_comp *bc;
 	unsigned long flags;
 
-	BUG_ON(!req->q->softirq_done_fn);
+	BUG_ON(!q->softirq_done_fn);
 
 	local_irq_save(flags);
+	cpu = smp_processor_id();
+
+	if (q->force_same_complete && req->cpu != -1)
+		ccpu = req->cpu;
+	else if (cpu_isset(cpu, q->complete_cpu))
+		ccpu = cpu;
+	else
+		ccpu = first_cpu(q->complete_cpu);
+
+	if (ccpu == cpu) {
+is_dead:
+		bc = &__get_cpu_var(blk_cpu_done);
+		q->local_complete++;
+	} else {
+		bc = &per_cpu(blk_cpu_done, ccpu);
+		if (unlikely(bc->dead)) {
+			ccpu = cpu;
+			goto is_dead;
+		}
+
+		q->remote_complete++;
+	}
+
+	spin_lock(&bc->lock);
+	was_empty = list_empty(&bc->list);
+	list_add_tail(&req->donelist, &bc->list);
+	spin_unlock(&bc->lock);
 
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_add_tail(&req->donelist, cpu_list);
-	raise_softirq_irqoff(BLOCK_SOFTIRQ);
+	if (was_empty) {
+		if (cpu == ccpu)
+			raise_softirq_irqoff(BLOCK_SOFTIRQ);
+		else
+			raise_softirq_on_cpu(ccpu, BLOCK_SOFTIRQ);
+	}
 
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(blk_complete_request);
 
-int __init blk_softirq_init(void)
+static int __init blk_softirq_init(void)
 {
 	int i;
 
-	for_each_possible_cpu(i)
-		INIT_LIST_HEAD(&per_cpu(blk_cpu_done, i));
+	for_each_possible_cpu(i) {
+		struct blk_comp *bc = &per_cpu(blk_cpu_done, i);
+
+		spin_lock_init(&bc->lock);
+		INIT_LIST_HEAD(&bc->list);
+		bc->dead = 0;
+	}
 
 	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
 	register_hotcpu_notifier(&blk_cpu_notifier);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 54d0db1..870e837 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -135,6 +135,70 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_complete_affinity_show(struct request_queue *q, char *page)
+{
+	ssize_t len;
+
+	len = cpumask_scnprintf(page, PAGE_SIZE, q->complete_cpu);
+	len += sprintf(page+len, "\nlocal\t%d\nremote\t%d\n", q->local_complete, q->remote_complete);
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
+	q->local_complete = q->remote_complete = 0;
+	spin_unlock_irq(q->queue_lock);
+	return count;
+}
+
+static ssize_t queue_queue_affinity_show(struct request_queue *q, char *page)
+{
+	ssize_t len;
+
+	len = cpumask_scnprintf(page, PAGE_SIZE, q->queue_cpu);
+	len += sprintf(page+len, "\nlocal\t%d\nremote\t%d\n", q->local_queue, q->remote_queue);
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
+	q->local_queue = q->remote_queue = 0;
+	spin_unlock_irq(q->queue_lock);
+	return count;
+}
+
+static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->force_same_complete, page);
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
+	q->force_same_complete = !!val;
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -170,6 +234,24 @@ static struct queue_sysfs_entry queue_hw_sector_size_entry = {
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
@@ -177,6 +259,9 @@ static struct attribute *default_attrs[] = {
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
+	&queue_complete_affinity_entry.attr,
+	&queue_queue_affinity_entry.attr,
+	&queue_rq_affinity_entry.attr,
 	NULL,
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5e43772..7db3bdf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -142,6 +142,7 @@ enum rq_flag_bits {
 struct request {
 	struct list_head queuelist;
 	struct list_head donelist;
+	int cpu;
 
 	struct request_queue *q;
 
@@ -387,6 +388,11 @@ struct request_queue
 #if defined(CONFIG_BLK_DEV_BSG)
 	struct bsg_class_device bsg_dev;
 #endif
+	cpumask_t		queue_cpu;
+	cpumask_t		complete_cpu;
+	int local_queue, remote_queue;
+	int local_complete, remote_complete;
+	int force_same_complete;
 };
 
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
@@ -702,6 +708,8 @@ extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
+extern int blk_queue_set_queue_cpu(struct request_queue *, int);
+extern int blk_queue_set_completion_cpu(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
-- 
1.5.4.22.g7a20

