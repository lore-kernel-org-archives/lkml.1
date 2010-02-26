Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936043Ab0BZMSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:18:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:43425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935995Ab0BZMOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:50 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 35/43] workqueue: implement several utility APIs
Date: Fri, 26 Feb 2010 21:23:12 +0900
Message-Id: <1267187000-18791-36-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the following utility APIs.

* workqueue_set_max_active()	: adjust max_active of a wq
* workqueue_congested()		: test whether a wq is contested
* work_cpu()			: determine the last / current cpu of a work
* work_busy()			: query whether a work is busy

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   11 ++++-
 kernel/workqueue.c        |  108 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 6a3a1e5..66573b8 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -64,6 +64,10 @@ enum {
 	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
 	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
 	WORK_STRUCT_NO_CPU	= NR_CPUS << WORK_STRUCT_FLAG_BITS,
+
+	/* bit mask for work_busy() return values */
+	WORK_BUSY_PENDING	= 1 << 0,
+	WORK_BUSY_RUNNING	= 1 << 1,
 };
 
 struct work_struct {
@@ -319,9 +323,14 @@ extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 extern int flush_work(struct work_struct *work);
-
 extern int cancel_work_sync(struct work_struct *work);
 
+extern void workqueue_set_max_active(struct workqueue_struct *wq,
+				     int max_active);
+extern bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq);
+extern unsigned int work_cpu(struct work_struct *work);
+extern unsigned int work_busy(struct work_struct *work);
+
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
  * function may still be running on return from cancel_delayed_work(), unless
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 15d3369..5871708 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -205,7 +205,7 @@ struct workqueue_struct {
 	cpumask_var_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
-	int			saved_max_active; /* I: saved cwq max_active */
+	int			saved_max_active; /* W: saved cwq max_active */
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
@@ -2594,6 +2594,112 @@ void destroy_workqueue(struct workqueue_struct *wq)
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
+/**
+ * workqueue_set_max_active - adjust max_active of a workqueue
+ * @wq: target workqueue
+ * @max_active: new max_active value.
+ *
+ * Set max_active of @wq to @max_active.
+ *
+ * CONTEXT:
+ * Don't call from IRQ context.
+ */
+void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
+{
+	unsigned int cpu;
+
+	max_active = wq_clamp_max_active(max_active, wq->name);
+
+	spin_lock(&workqueue_lock);
+
+	wq->saved_max_active = max_active;
+
+	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+
+		spin_lock_irq(&gcwq->lock);
+
+		if (!(wq->flags & WQ_FREEZEABLE) ||
+		    !(gcwq->flags & GCWQ_FREEZING))
+			get_cwq(gcwq->cpu, wq)->max_active = max_active;
+
+		spin_unlock_irq(&gcwq->lock);
+	}
+
+	spin_unlock(&workqueue_lock);
+}
+EXPORT_SYMBOL_GPL(workqueue_set_max_active);
+
+/**
+ * workqueue_congested - test whether a workqueue is congested
+ * @cpu: CPU in question
+ * @wq: target workqueue
+ *
+ * Test whether @wq's cpu workqueue for @cpu is congested.  There is
+ * no synchronization around this function and the test result is
+ * unreliable and only useful as advisory hints or for debugging.
+ *
+ * RETURNS:
+ * %true if congested, %false otherwise.
+ */
+bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq)
+{
+	struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+	return !list_empty(&cwq->delayed_works);
+}
+EXPORT_SYMBOL_GPL(workqueue_congested);
+
+/**
+ * work_cpu - return the last known associated cpu for @work
+ * @work: the work of interest
+ *
+ * RETURNS:
+ * CPU number if @work was ever queued.  NR_CPUS otherwise.
+ */
+unsigned int work_cpu(struct work_struct *work)
+{
+	struct global_cwq *gcwq = get_work_gcwq(work);
+
+	return gcwq ? gcwq->cpu : NR_CPUS;
+}
+EXPORT_SYMBOL_GPL(work_cpu);
+
+/**
+ * work_busy - test whether a work is currently pending or running
+ * @work: the work to be tested
+ *
+ * Test whether @work is currently pending or running.  There is no
+ * synchronization around this function and the test result is
+ * unreliable and only useful as advisory hints or for debugging.
+ * Especially for reentrant wqs, the pending state might hide the
+ * running state.
+ *
+ * RETURNS:
+ * OR'd bitmask of WORK_BUSY_* bits.
+ */
+unsigned int work_busy(struct work_struct *work)
+{
+	struct global_cwq *gcwq = get_work_gcwq(work);
+	unsigned long flags;
+	unsigned int ret;
+
+	if (!gcwq)
+		return false;
+
+	spin_lock_irqsave(&gcwq->lock, flags);
+
+	if (work_pending(work))
+		ret |= WORK_BUSY_PENDING;
+	if (find_worker_executing_work(gcwq, work))
+		ret |= WORK_BUSY_RUNNING;
+
+	spin_unlock_irqrestore(&gcwq->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(work_busy);
+
 /*
  * CPU hotplug.
  *
-- 
1.6.4.2

