Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZEXHD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZEXHD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbZEXHCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:02:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:35725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbZEXHCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:02:42 -0400
Date: Sun, 24 May 2009 07:02:05 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090523163012.916937244@chello.nl>
References: <20090523163012.916937244@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Change pctrl() behaviour
Message-ID: <tip-082ff5a2767a0679ee543f14883adbafb631ffbe@git.kernel.org>
Git-Commit-ID: 082ff5a2767a0679ee543f14883adbafb631ffbe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 07:02:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  082ff5a2767a0679ee543f14883adbafb631ffbe
Gitweb:     http://git.kernel.org/tip/082ff5a2767a0679ee543f14883adbafb631ffbe
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 23 May 2009 18:29:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 24 May 2009 08:24:08 +0200

perf_counter: Change pctrl() behaviour

Instead of en/dis-abling all counters acting on a particular
task, en/dis- able all counters we created.

[ v2: fix crash on first counter enable ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090523163012.916937244@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/init_task.h    |   10 +++++
 include/linux/perf_counter.h |    3 +
 include/linux/sched.h        |    2 +
 kernel/perf_counter.c        |   87 +++++++++++------------------------------
 4 files changed, 39 insertions(+), 63 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d87247d..353c0ac 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
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
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 4ab8050..4159ee5 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -469,6 +469,9 @@ struct perf_counter {
 	int				oncpu;
 	int				cpu;
 
+	struct list_head		owner_entry;
+	struct task_struct		*owner;
+
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9714d45..bc9326d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1389,6 +1389,8 @@ struct task_struct {
 #endif
 #ifdef CONFIG_PERF_COUNTERS
 	struct perf_counter_context *perf_counter_ctxp;
+	struct mutex perf_counter_mutex;
+	struct list_head perf_counter_list;
 #endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0e97f89..4c86a63 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1076,79 +1076,26 @@ static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
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
-
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
-
-	if (!ctx || !ctx->nr_counters)
-		return 0;
-
-	local_irq_save(flags);
-	cpu = smp_processor_id();
-
-	__perf_counter_task_sched_out(ctx);
-
-	spin_lock(&ctx->lock);
 
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
@@ -1416,6 +1363,11 @@ static int perf_release(struct inode *inode, struct file *file)
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
@@ -3488,6 +3446,9 @@ void perf_counter_init_task(struct task_struct *child)
 
 	child->perf_counter_ctxp = NULL;
 
+	mutex_init(&child->perf_counter_mutex);
+	INIT_LIST_HEAD(&child->perf_counter_list);
+
 	/*
 	 * This is executed from the parent task context, so inherit
 	 * counters that have been marked for cloning.
