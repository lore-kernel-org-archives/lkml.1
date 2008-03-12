Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYCLL5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYCLL5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYCLL5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:57:12 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25740 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYCLL5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:57:10 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, dgc@sgi.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/7] block: split softirq handling into blk-softirq.c
Date: Wed, 12 Mar 2008 12:55:37 +0100
Message-Id: <1205322940-20127-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 2a438a9..46819c1 100644
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
@@ -1632,82 +1628,6 @@ static int __end_that_request_first(struct request *req, int error,
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
@@ -2038,8 +1958,6 @@ EXPORT_SYMBOL(kblockd_flush_work);
 
 int __init blk_dev_init(void)
 {
-	int i;
-
 	kblockd_workqueue = create_workqueue("kblockd");
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");
@@ -2050,12 +1968,6 @@ int __init blk_dev_init(void)
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
1.5.4.GIT

