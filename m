Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbZEWQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbZEWQdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbZEWQdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:33:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbZEWQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:32:59 -0400
Message-Id: <20090523163012.916937244@chello.nl>
References: <20090523162854.599719825@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 23 May 2009 18:29:00 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 6/7] perf_counter: change pctrl() behaviour
Content-Disposition: inline; filename=perf_counter-ctrl-all.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of en/dis-abling all counters acting on a particular task, en/dis-
able all counters we created.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/init_task.h    |   10 +++++
 include/linux/perf_counter.h |    3 +
 include/linux/sched.h        |    2 +
 kernel/perf_counter.c        |   84 ++++++++++---------------------------------
 4 files changed, 36 insertions(+), 63 deletions(-)

Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -108,6 +108,15 @@ extern struct group_info init_groups;
 
 extern struct cred init_cred;
 
+#ifdef CONFIG_PERF_COUNTERS
+# define INIT_PERF_COUNTERS(tsk)					\
+	.perf_counter_mutex = 						\
+		 __MUTEX_INITIALIZER(tsk.perf_counter_mutex),		\
+	.perf_counter_list = LIST_HEAD_INIT(tsk.perf_counter_list),
+#else
+# define INIT_PERF_COUNTERS(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -171,6 +180,7 @@ extern struct cred init_cred;
 	},								\
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
 	INIT_IDS							\
+	INIT_PERF_COUNTERS(tsk)						\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
 	INIT_FTRACE_GRAPH						\
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -469,6 +469,9 @@ struct perf_counter {
 	int				oncpu;
 	int				cpu;
 
+	struct list_head		owner_entry;
+	struct task_struct		*owner;
+
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1403,6 +1403,8 @@ struct task_struct {
 #endif
 #ifdef CONFIG_PERF_COUNTERS
 	struct perf_counter_context *perf_counter_ctxp;
+	struct mutex perf_counter_mutex;
+	struct list_head perf_counter_list;
 #endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1076,79 +1076,26 @@ static void perf_counter_cpu_sched_in(st
 	__perf_counter_sched_in(ctx, cpuctx, cpu);
 }
 
-int perf_counter_task_disable(void)
+int perf_counter_task_enable(void)
 {
-	struct task_struct *curr = current;
-	struct perf_counter_context *ctx = curr->perf_counter_ctxp;
 	struct perf_counter *counter;
-	unsigned long flags;
-
-	if (!ctx || !ctx->nr_counters)
-		return 0;
-
-	local_irq_save(flags);
-
-	__perf_counter_task_sched_out(ctx);
-
-	spin_lock(&ctx->lock);
-
-	/*
-	 * Disable all the counters:
-	 */
-	perf_disable();
-
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		if (counter->state != PERF_COUNTER_STATE_ERROR) {
-			update_group_times(counter);
-			counter->state = PERF_COUNTER_STATE_OFF;
-		}
-	}
 
-	perf_enable();
-
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	mutex_lock(&current->perf_counter_mutex);
+	list_for_each_entry(counter, &current->perf_counter_list, owner_entry)
+		perf_counter_enable(counter);
+	mutex_unlock(&current->perf_counter_mutex);
 
 	return 0;
 }
 
-int perf_counter_task_enable(void)
+int perf_counter_task_disable(void)
 {
-	struct task_struct *curr = current;
-	struct perf_counter_context *ctx = curr->perf_counter_ctxp;
 	struct perf_counter *counter;
-	unsigned long flags;
-	int cpu;
 
-	if (!ctx || !ctx->nr_counters)
-		return 0;
-
-	local_irq_save(flags);
-	cpu = smp_processor_id();
-
-	__perf_counter_task_sched_out(ctx);
-
-	spin_lock(&ctx->lock);
-
-	/*
-	 * Disable all the counters:
-	 */
-	perf_disable();
-
-	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		if (counter->state > PERF_COUNTER_STATE_OFF)
-			continue;
-		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->tstamp_enabled =
-			ctx->time - counter->total_time_enabled;
-		counter->hw_event.disabled = 0;
-	}
-	perf_enable();
-
-	spin_unlock(&ctx->lock);
-
-	perf_counter_task_sched_in(curr, cpu);
-
-	local_irq_restore(flags);
+	mutex_lock(&current->perf_counter_mutex);
+	list_for_each_entry(counter, &current->perf_counter_list, owner_entry)
+		perf_counter_disable(counter);
+	mutex_unlock(&current->perf_counter_mutex);
 
 	return 0;
 }
@@ -1416,6 +1363,11 @@ static int perf_release(struct inode *in
 	perf_counter_remove_from_context(counter);
 	mutex_unlock(&ctx->mutex);
 
+	mutex_lock(&counter->owner->perf_counter_mutex);
+	list_del_init(&counter->owner_entry);
+	mutex_unlock(&counter->owner->perf_counter_mutex);
+	put_task_struct(counter->owner);
+
 	free_counter(counter);
 	put_context(ctx);
 
@@ -3272,6 +3224,12 @@ SYSCALL_DEFINE5(perf_counter_open,
 	perf_install_in_context(ctx, counter, cpu);
 	mutex_unlock(&ctx->mutex);
 
+	counter->owner = current;
+	get_task_struct(current);
+	mutex_lock(&current->perf_counter_mutex);
+	list_add_tail(&counter->owner_entry, &current->perf_counter_list);
+	mutex_unlock(&current->perf_counter_mutex);
+
 	fput_light(counter_file, fput_needed2);
 
 out_fput:

-- 

