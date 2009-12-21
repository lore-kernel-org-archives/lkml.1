Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZLUC2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZLUC2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 21:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZLUC23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 21:28:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:38834 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZLUC23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 21:28:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,429,1257148800"; 
   d="scan'208";a="477874064"
Date: Mon, 21 Dec 2009 10:28:27 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org
Subject: [RFC]block: add a new flag to make request complete on submitted
 cpu
Message-ID: <20091221022827.GA1897@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have a QUEUE_FLAG_SAME_COMP, which makes request complete
on the first cpu of a mc/ht, but this isn't sufficient. In a system
with fast block devices (intel SSD), it turns out the first cpu is
bottlenect. Add a flag to make request complete on cpu where request
is submitted. The flag implies QUEUE_FLAG_SAME_COMP. By default, it is off.

My test machine has two CPUs and 4 intel SSD. Without the new flag,
the io thoughput is about 400m/s; with it, the thoughput is about 500m/s.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-core.c       |    2 +-
 block/blk-softirq.c    |    2 +-
 block/blk-sysfs.c      |   33 +++++++++++++++++++++++++++++++++
 block/blk.h            |    9 +++++++--
 include/linux/blkdev.h |    3 ++-
 5 files changed, 44 insertions(+), 5 deletions(-)

Index: linux-2.6/block/blk-sysfs.c
===================================================================
--- linux-2.6.orig/block/blk-sysfs.c
+++ linux-2.6/block/blk-sysfs.c
@@ -233,6 +233,32 @@ queue_rq_affinity_store(struct request_q
 	return ret;
 }
 
+static ssize_t queue_rq_samecpu_show(struct request_queue *q, char *page)
+{
+	bool set = test_bit(QUEUE_FLAG_SAME_CPU, &q->queue_flags);
+
+	return queue_var_show(set, page);
+}
+
+static ssize_t
+queue_rq_samecpu_store(struct request_queue *q, const char *page, size_t count)
+{
+	ssize_t ret = -EINVAL;
+#if defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+	unsigned long val;
+
+	ret = queue_var_store(&val, page, count);
+	spin_lock_irq(q->queue_lock);
+	if (val) {
+		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
+		queue_flag_set(QUEUE_FLAG_SAME_CPU, q);
+	} else
+		queue_flag_clear(QUEUE_FLAG_SAME_CPU,  q);
+	spin_unlock_irq(q->queue_lock);
+#endif
+	return ret;
+}
+
 static ssize_t queue_iostats_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(blk_queue_io_stat(q), page);
@@ -341,6 +367,12 @@ static struct queue_sysfs_entry queue_rq
 	.store = queue_rq_affinity_store,
 };
 
+static struct queue_sysfs_entry queue_rq_samecpu_entry = {
+	.attr = {.name = "rq_samecpu", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_rq_samecpu_show,
+	.store = queue_rq_samecpu_store,
+};
+
 static struct queue_sysfs_entry queue_iostats_entry = {
 	.attr = {.name = "iostats", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_iostats_show,
@@ -365,6 +397,7 @@ static struct attribute *default_attrs[]
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
+	&queue_rq_samecpu_entry.attr,
 	NULL,
 };
 
Index: linux-2.6/block/blk.h
===================================================================
--- linux-2.6.orig/block/blk.h
+++ linux-2.6/block/blk.h
@@ -140,10 +140,15 @@ static inline int queue_congestion_off_t
 
 #endif /* BLK_DEV_INTEGRITY */
 
-static inline int blk_cpu_to_group(int cpu)
+static inline int blk_cpu_to_group(struct request_queue *q, int cpu)
 {
+	const struct cpumask *mask;
+
+	if (test_bit(QUEUE_FLAG_SAME_CPU, &q->queue_flags))
+		return cpu;
+
 #ifdef CONFIG_SCHED_MC
-	const struct cpumask *mask = cpu_coregroup_mask(cpu);
+	mask = cpu_coregroup_mask(cpu);
 	return cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
 	return cpumask_first(topology_thread_cpumask(cpu));
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -455,7 +455,7 @@ struct request_queue
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
 #define QUEUE_FLAG_NOMERGES    10	/* disable merge attempts */
-#define QUEUE_FLAG_SAME_COMP   11	/* force complete on same CPU */
+#define QUEUE_FLAG_SAME_COMP   11	/* force complete on same CPU group */
 #define QUEUE_FLAG_FAIL_IO     12	/* fake timeout */
 #define QUEUE_FLAG_STACKABLE   13	/* supports request stacking */
 #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
@@ -463,6 +463,7 @@ struct request_queue
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
 #define QUEUE_FLAG_CQ	       16	/* hardware does queuing */
 #define QUEUE_FLAG_DISCARD     17	/* supports DISCARD */
+#define QUEUE_FLAG_SAME_CPU    18	/* force complete on same CPU */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -1267,7 +1267,7 @@ get_rq:
 	spin_lock_irq(q->queue_lock);
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
 	    bio_flagged(bio, BIO_CPU_AFFINE))
-		req->cpu = blk_cpu_to_group(smp_processor_id());
+		req->cpu = blk_cpu_to_group(q, smp_processor_id());
 	if (queue_should_plug(q) && elv_queue_empty(q))
 		blk_plug_device(q);
 	add_request(q, req);
Index: linux-2.6/block/blk-softirq.c
===================================================================
--- linux-2.6.orig/block/blk-softirq.c
+++ linux-2.6/block/blk-softirq.c
@@ -111,7 +111,7 @@ void __blk_complete_request(struct reque
 
 	local_irq_save(flags);
 	cpu = smp_processor_id();
-	group_cpu = blk_cpu_to_group(cpu);
+	group_cpu = blk_cpu_to_group(q, cpu);
 
 	/*
 	 * Select completion CPU
