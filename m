Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbYBGS0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbYBGS0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbYBGSZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:25:53 -0500
Received: from brick.kernel.dk ([87.55.233.238]:5861 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbYBGSZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:25:51 -0500
Date: Thu, 7 Feb 2008 19:25:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de
Subject: IO queuing and complete affinity with threads (was Re: [PATCH 0/8] IO queuing and complete affinity)
Message-ID: <20080207182544.GM15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Here's a variant using kernel threads only, the nasty arch bits are then
not needed. Works for me, no performance testing (that's a hint for Alan
to try and queue up some testing for this variant as well :-)

-- 
Jens Axboe


--z4+8/lEcDcG5Ke9S
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-block-split-softirq-handling-into-blk-softirq.c.patch"

>From b76144d3b3be91c691717e222f92747c0cbb8d5c Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Mon, 4 Feb 2008 21:26:42 +0100
Subject: [PATCH] block: split softirq handling into blk-softirq.c

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/Makefile      |    3 +-
 block/blk-core.c    |   88 -------------------------------------------
 block/blk-softirq.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+), 89 deletions(-)
 create mode 100644 block/blk-softirq.c

diff --git a/block/Makefile b/block/Makefile
index 5a43c7d..b064190 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -4,7 +4,8 @@
 
 obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-barrier.o blk-settings.o blk-ioc.o blk-map.o \
-			blk-exec.o blk-merge.o ioctl.o genhd.o scsi_ioctl.o
+			blk-exec.o blk-merge.o blk-softirq.o ioctl.o genhd.o \
+			scsi_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
diff --git a/block/blk-core.c b/block/blk-core.c
index 4afb39c..11d79f6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -26,8 +26,6 @@
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/interrupt.h>
-#include <linux/cpu.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
 
@@ -50,8 +48,6 @@ struct kmem_cache *blk_requestq_cachep;
  */
 static struct workqueue_struct *kblockd_workqueue;
 
-static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
-
 static void drive_stat_acct(struct request *rq, int new_io)
 {
 	int rw = rq_data_dir(rq);
@@ -1605,82 +1601,6 @@ static int __end_that_request_first(struct request *req, int error,
 }
 
 /*
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
-static int __cpuinit blk_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
-{
-	/*
-	 * If a CPU goes away, splice its entries to the current CPU
-	 * and trigger a run of the softirq
-	 */
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		int cpu = (unsigned long) hcpu;
-
-		local_irq_disable();
-		list_splice_init(&per_cpu(blk_cpu_done, cpu),
-				 &__get_cpu_var(blk_cpu_done));
-		raise_softirq_irqoff(BLOCK_SOFTIRQ);
-		local_irq_enable();
-	}
-
-	return NOTIFY_OK;
-}
-
-
-static struct notifier_block blk_cpu_notifier __cpuinitdata = {
-	.notifier_call	= blk_cpu_notify,
-};
-
-/**
- * blk_complete_request - end I/O on a request
- * @req:      the request being processed
- *
- * Description:
- *     Ends all I/O on a request. It does not handle partial completions,
- *     unless the driver actually implements this in its completion callback
- *     through requeueing. The actual completion happens out-of-order,
- *     through a softirq handler. The user must have registered a completion
- *     callback through blk_queue_softirq_done().
- **/
-
-void blk_complete_request(struct request *req)
-{
-	struct list_head *cpu_list;
-	unsigned long flags;
-
-	BUG_ON(!req->q->softirq_done_fn);
-
-	local_irq_save(flags);
-
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_add_tail(&req->donelist, cpu_list);
-	raise_softirq_irqoff(BLOCK_SOFTIRQ);
-
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(blk_complete_request);
-
-/*
  * queue lock must be held
  */
 static void end_that_request_last(struct request *req, int error)
@@ -2004,8 +1924,6 @@ EXPORT_SYMBOL(kblockd_flush_work);
 
 int __init blk_dev_init(void)
 {
-	int i;
-
 	kblockd_workqueue = create_workqueue("kblockd");
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");
@@ -2016,12 +1934,6 @@ int __init blk_dev_init(void)
 	blk_requestq_cachep = kmem_cache_create("blkdev_queue",
 			sizeof(struct request_queue), 0, SLAB_PANIC, NULL);
 
-	for_each_possible_cpu(i)
-		INIT_LIST_HEAD(&per_cpu(blk_cpu_done, i));
-
-	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
-	register_hotcpu_notifier(&blk_cpu_notifier);
-
 	return 0;
 }
 
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
new file mode 100644
index 0000000..05f9451
--- /dev/null
+++ b/block/blk-softirq.c
@@ -0,0 +1,103 @@
+/*
+ * Functions related to softirq rq completions
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
+
+#include "blk.h"
+
+static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
+
+static int __cpuinit blk_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	/*
+	 * If a CPU goes away, splice its entries to the current CPU
+	 * and trigger a run of the softirq
+	 */
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		int cpu = (unsigned long) hcpu;
+
+		local_irq_disable();
+		list_splice_init(&per_cpu(blk_cpu_done, cpu),
+				 &__get_cpu_var(blk_cpu_done));
+		raise_softirq_irqoff(BLOCK_SOFTIRQ);
+		local_irq_enable();
+	}
+
+	return NOTIFY_OK;
+}
+
+
+static struct notifier_block blk_cpu_notifier __cpuinitdata = {
+	.notifier_call	= blk_cpu_notify,
+};
+
+/*
+ * splice the completion data to a local structure and hand off to
+ * process_completion_queue() to complete the requests
+ */
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
+		rq = list_entry(local_list.next, struct request, donelist);
+		list_del_init(&rq->donelist);
+		rq->q->softirq_done_fn(rq);
+	}
+}
+
+/**
+ * blk_complete_request - end I/O on a request
+ * @req:      the request being processed
+ *
+ * Description:
+ *     Ends all I/O on a request. It does not handle partial completions,
+ *     unless the driver actually implements this in its completion callback
+ *     through requeueing. The actual completion happens out-of-order,
+ *     through a softirq handler. The user must have registered a completion
+ *     callback through blk_queue_softirq_done().
+ **/
+
+void blk_complete_request(struct request *req)
+{
+	struct list_head *cpu_list;
+	unsigned long flags;
+
+	BUG_ON(!req->q->softirq_done_fn);
+
+	local_irq_save(flags);
+
+	cpu_list = &__get_cpu_var(blk_cpu_done);
+	list_add_tail(&req->donelist, cpu_list);
+	raise_softirq_irqoff(BLOCK_SOFTIRQ);
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(blk_complete_request);
+
+int __init blk_softirq_init(void)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&per_cpu(blk_cpu_done, i));
+
+	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
+	register_hotcpu_notifier(&blk_cpu_notifier);
+	return 0;
+}
+subsys_initcall(blk_softirq_init);
-- 
1.5.4.rc5.5.gab98


--z4+8/lEcDcG5Ke9S
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-Add-interface-for-queuing-work-on-a-specific-CPU.patch"

>From 5a4876f8d06451b2fd41f617b773488030772362 Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 7 Feb 2008 19:14:05 +0100
Subject: [PATCH] Add interface for queuing work on a specific CPU

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/workqueue.h |    2 ++
 kernel/workqueue.c        |   33 ++++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 7f28c32..53c45c4 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -179,6 +179,8 @@ __create_workqueue_key(const char *name, int singlethread,
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
+extern int queue_work_on_cpu(struct workqueue_struct *wq,
+			struct work_struct *work, int cpu);
 extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay));
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52db48e..96dd90e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -152,25 +152,44 @@ static void __queue_work(struct cpu_workqueue_struct *cwq,
 }
 
 /**
- * queue_work - queue work on a workqueue
+ * queue_work_on_cpu - queue work on a workqueue on a specific CPU
  * @wq: workqueue to use
  * @work: work to queue
+ * @cpu: cpu to queue the work on
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
- *
- * We queue the work to the CPU it was submitted, but there is no
- * guarantee that it will be processed by that CPU.
  */
-int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
+int queue_work_on_cpu(struct workqueue_struct *wq, struct work_struct *work,
+		      int cpu)
 {
 	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, get_cpu()), work);
-		put_cpu();
+		__queue_work(wq_per_cpu(wq, cpu), work);
 		ret = 1;
 	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work_on_cpu);
+
+/**
+ * queue_work - queue work on a workqueue
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ * We queue the work to the CPU it was submitted, but there is no
+ * guarantee that it will be processed by that CPU.
+ */
+int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
+{
+	int ret;
+
+	ret = queue_work_on_cpu(wq, work, get_cpu());
+	put_cpu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);
-- 
1.5.4.rc5.5.gab98


--z4+8/lEcDcG5Ke9S
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0003-block-make-kblockd_schedule_work-take-the-queue-a.patch"

>From eb9a144bd0b44987ce51eb3ac699adae5a36c847 Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 7 Feb 2008 09:37:32 +0100
Subject: [PATCH] block: make kblockd_schedule_work() take the queue as parameter

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
index 11d79f6..34a475b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -282,7 +282,7 @@ void blk_unplug_timeout(unsigned long data)
 	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_TIMER, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
-	kblockd_schedule_work(&q->unplug_work);
+	kblockd_schedule_work(q, &q->unplug_work);
 }
 
 void blk_unplug(struct request_queue *q)
@@ -323,7 +323,7 @@ void blk_start_queue(struct request_queue *q)
 		clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 	} else {
 		blk_plug_device(q);
-		kblockd_schedule_work(&q->unplug_work);
+		kblockd_schedule_work(q, &q->unplug_work);
 	}
 }
 EXPORT_SYMBOL(blk_start_queue);
@@ -391,7 +391,7 @@ void blk_run_queue(struct request_queue *q)
 			clear_bit(QUEUE_FLAG_REENTER, &q->queue_flags);
 		} else {
 			blk_plug_device(q);
-			kblockd_schedule_work(&q->unplug_work);
+			kblockd_schedule_work(q, &q->unplug_work);
 		}
 	}
 
@@ -1910,7 +1910,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		rq->rq_disk = bio->bi_bdev->bd_disk;
 }
 
-int kblockd_schedule_work(struct work_struct *work)
+int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 {
 	return queue_work(kblockd_workqueue, work);
 }
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ca198e6..91d1126 100644
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
index 90392a9..5e43772 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -803,7 +803,7 @@ static inline void put_dev_sector(Sector p)
 }
 
 struct work_struct;
-int kblockd_schedule_work(struct work_struct *work);
+int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
 void kblockd_flush_work(struct work_struct *work);
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
-- 
1.5.4.rc5.5.gab98


--z4+8/lEcDcG5Ke9S
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0004-block-add-test-code-for-testing-CPU-affinity.patch"

>From 43e7930bd3d4a997886c1a483031fa57c41c893c Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 7 Feb 2008 19:17:30 +0100
Subject: [PATCH] block: add test code for testing CPU affinity

Supports several modes:

- Force IO queue affinity to a specific mask of CPUs
- Force IO completion affinity to a specific mask of CPUs
- Force completion of a request on the same CPU that queued it

Test code so far, this variant being based on removing the block softirq
completion and moving post-processing to a per-cpu kernel thread.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |   80 +++++++++++------
 block/blk-settings.c   |   47 ++++++++++
 block/blk-softirq.c    |  233 +++++++++++++++++++++++++++++++++++++++---------
 block/blk-sysfs.c      |   85 ++++++++++++++++++
 include/linux/blkdev.h |    8 ++
 5 files changed, 384 insertions(+), 69 deletions(-)

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
index 05f9451..52bcddb 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -7,59 +7,177 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/kthread.h>
 #include <linux/cpu.h>
 
 #include "blk.h"
 
-static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
+struct blk_comp {
+	spinlock_t lock;
+	struct list_head list;
+	struct task_struct *task;
+};
+static DEFINE_PER_CPU(struct blk_comp, blk_irq_data);
 
-static int __cpuinit blk_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
+static void raise_blk_irq(int cpu)
 {
-	/*
-	 * If a CPU goes away, splice its entries to the current CPU
-	 * and trigger a run of the softirq
-	 */
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		int cpu = (unsigned long) hcpu;
+	wake_up_process(per_cpu(blk_irq_data, cpu).task);
+}
 
-		local_irq_disable();
-		list_splice_init(&per_cpu(blk_cpu_done, cpu),
-				 &__get_cpu_var(blk_cpu_done));
-		raise_softirq_irqoff(BLOCK_SOFTIRQ);
-		local_irq_enable();
+static void blk_done_softirq(struct list_head *list)
+{
+	while (!list_empty(list)) {
+		struct request *rq;
+
+		rq = list_entry(list->next, struct request, donelist);
+		list_del_init(&rq->donelist);
+		rq->q->softirq_done_fn(rq);
 	}
+}
 
-	return NOTIFY_OK;
+static inline int work_in_list(struct list_head *list)
+{
+	/*
+	 * should be safe to test without holding the lock, as long as
+	 * we have an smp memory barrier before checking
+	 */
+	smp_mb();
+	return !list_empty(list);
 }
 
+/*
+ * sit idle until being woken up, then check the per-cpu list for
+ * work to do and hand that off to the queue specific completion function
+ */
+static int blk_irq_thread(void *data)
+{
+	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO / 2 };
+	struct blk_comp *bc = data;
+
+	sched_setscheduler(current, SCHED_FIFO, &param);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	while (!kthread_should_stop()) {
+		LIST_HEAD(local_list);
+
+		preempt_disable();
+		if (!work_in_list(&bc->list)) {
+			preempt_enable_no_resched();
+			schedule();
+			preempt_disable();
+		}
+
+		__set_current_state(TASK_RUNNING);
+
+		while (work_in_list(&bc->list)) {
+			spin_lock_irq(&bc->lock);
+			list_replace_init(&bc->list, &local_list);
+			spin_unlock_irq(&bc->lock);
+
+			preempt_enable();
+			blk_done_softirq(&local_list);
+			preempt_disable();
+		}
+		preempt_enable();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
 
-static struct notifier_block blk_cpu_notifier __cpuinitdata = {
-	.notifier_call	= blk_cpu_notify,
-};
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
 
 /*
- * splice the completion data to a local structure and hand off to
- * process_completion_queue() to complete the requests
+ * Create CPU private kernel thread and init associated structures
  */
-static void blk_done_softirq(struct softirq_action *h)
+static int create_blk_irq_thread(int cpu)
 {
-	struct list_head *cpu_list, local_list;
+	struct blk_comp *bc = &per_cpu(blk_irq_data, cpu);
+	struct task_struct *task;
 
-	local_irq_disable();
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_replace_init(cpu_list, &local_list);
-	local_irq_enable();
+	spin_lock_init(&bc->lock);
+	INIT_LIST_HEAD(&bc->list);
+	bc->task = NULL;
 
-	while (!list_empty(&local_list)) {
-		struct request *rq;
+	task = kthread_create(blk_irq_thread, bc, "blk-irq-%d", cpu);
+	if (IS_ERR(task)) {
+		printk("block: irq thread creation failed\n");
+		return 1;
+	}
 
-		rq = list_entry(local_list.next, struct request, donelist);
-		list_del_init(&rq->donelist);
-		rq->q->softirq_done_fn(rq);
+	kthread_bind(task, cpu);
+	bc->task = task;
+	return 0;
+}
+
+static int __cpuinit blk_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	int cpu = (unsigned long) hcpu;
+	struct task_struct *task;
+	struct blk_comp *bc;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		bc = &per_cpu(blk_irq_data, cpu);
+		if (bc->task) {
+			printk("blk: task for %d already there\n", cpu);
+			break;
+		}
+		if (create_blk_irq_thread(cpu))
+			return NOTIFY_BAD;
+		break;
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		raise_blk_irq(cpu);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		bc = &per_cpu(blk_irq_data, cpu);
+		if (!bc->task);
+			break;
+		kthread_bind(bc->task, any_online_cpu(cpu_online_map));
+		/*
+		 * fall through to splice and kill of task
+		 */
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN: {
+		/*
+		 * If a CPU goes away, splice its entries to the current CPU
+		 * and trigger a run of the softirq
+		 */
+		struct sched_param param;
+		struct blk_comp *dead;
+
+		local_irq_disable();
+		bc = &__get_cpu_var(blk_irq_data);
+		dead = &per_cpu(blk_irq_data, cpu);
+		double_spin_lock(&bc->lock, &dead->lock, bc < dead);
+		list_splice_init(&dead->list, &bc->list);
+		double_spin_unlock(&bc->lock, &dead->lock, bc < dead);
+
+		/*
+		 * stop thread
+		 */
+		param.sched_priority = MAX_RT_PRIO - 1;
+		task = dead->task;
+		sched_setscheduler(task, SCHED_FIFO, &param);
+		dead->task = NULL;
+		raise_blk_irq(smp_processor_id());
+		local_irq_enable();
+		kthread_stop(task);
+		break;
+		}
 	}
+
+	return NOTIFY_OK;
 }
 
+static struct notifier_block __cpuinitdata blk_cpu_notifier = {
+	.notifier_call	= blk_cpu_notify,
+};
+
 /**
  * blk_complete_request - end I/O on a request
  * @req:      the request being processed
@@ -71,32 +189,65 @@ static void blk_done_softirq(struct softirq_action *h)
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
+		bc = &__get_cpu_var(blk_irq_data);
+		q->local_complete++;
+	} else {
+		bc = &per_cpu(blk_irq_data, ccpu);
+		if (unlikely(!bc->task)) {
+			ccpu = cpu;
+			goto is_dead;
+		}
+
+		q->remote_complete++;
+	}
 
-	cpu_list = &__get_cpu_var(blk_cpu_done);
-	list_add_tail(&req->donelist, cpu_list);
-	raise_softirq_irqoff(BLOCK_SOFTIRQ);
+	spin_lock(&bc->lock);
+	was_empty = list_empty(&bc->list);
+	list_add_tail(&req->donelist, &bc->list);
+	spin_unlock(&bc->lock);
+
+	if (was_empty)
+		raise_blk_irq(ccpu);
 
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(blk_complete_request);
 
-int __init blk_softirq_init(void)
+__init int blk_softirq_init(void)
 {
 	int i;
 
-	for_each_possible_cpu(i)
-		INIT_LIST_HEAD(&per_cpu(blk_cpu_done, i));
+	for_each_possible_cpu(i) {
+		void *cpu;
+		int err;
+
+		cpu = (void *) (long) i;
+		err = blk_cpu_notify(&blk_cpu_notifier, CPU_UP_PREPARE, cpu);
+		BUG_ON(err == NOTIFY_BAD);
+		blk_cpu_notify(&blk_cpu_notifier, CPU_ONLINE, cpu);
+	}
 
-	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
 	register_hotcpu_notifier(&blk_cpu_notifier);
 	return 0;
 }
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
1.5.4.rc5.5.gab98


--z4+8/lEcDcG5Ke9S--
