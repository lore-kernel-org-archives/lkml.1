Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZIJI3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZIJI3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZIJI3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:29:40 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51951 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbZIJI3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M+ynySvYWaXMO5GsIR3qWrdFK7BqdG1llrKDZG9EYkT39KNcvTGOSOjcdYJrqFrJsl
         +yQmWm++kv0xjDLhH9mTaV6FuvIxLfofqyrqSHBoGZKdaoMZM4E5kSm4nbDeze8AWmar
         cPKYKiSE29iga8Vb+mWpQuRRi8ZOnBMr27cV0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 2/5] perf_counter: Export various perf helpers for external users
Date: Thu, 10 Sep 2009 10:29:24 +0200
Message-Id: <1252571367-25876-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export various perf helpers that initialize, destroy, attach and detach
a perf counter for future external users like the hardware breakpoint api.

The allocation and initialization of a perf counter have been split up
so that an external user can first allocate and then prefill the
counter before initialize it properly.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 include/linux/perf_counter.h |   31 +++++++++++++++++
 kernel/perf_counter.c        |   74 +++++++++++++++++++++++++-----------------
 2 files changed, 75 insertions(+), 30 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index f557483..1181c24 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -692,9 +692,23 @@ extern int perf_max_counters;
 
 extern const struct pmu *hw_perf_counter_init(struct perf_counter *counter);
 
+extern int
+__perf_counter_init(struct perf_counter *counter,
+		    struct perf_counter_attr *attr,
+		    int cpu,
+		    struct perf_counter_context *ctx,
+		    struct perf_counter *group_leader,
+		    struct perf_counter *parent_counter);
+extern void free_counter(struct perf_counter *counter);
+extern void put_ctx(struct perf_counter_context *ctx);
 extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
 extern void perf_counter_task_sched_out(struct task_struct *task,
 					struct task_struct *next, int cpu);
+extern struct perf_counter_context *find_get_context(pid_t pid, int cpu);
+extern void perf_install_in_context(struct perf_counter_context *ctx,
+				    struct perf_counter *counter,
+				    int cpu);
+extern void perf_counter_remove_from_context(struct perf_counter *counter);
 extern void perf_counter_task_tick(struct task_struct *task, int cpu);
 extern int perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
@@ -799,6 +813,23 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)	{ }
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
+static inline int
+__perf_counter_init(struct perf_counter *counter,
+		    struct perf_counter_attr *attr,
+		    int cpu,
+		    struct perf_counter_context *ctx,
+		    struct perf_counter *group_leader,
+		    struct perf_counter *parent_counter)	{ return NULL; }
+static inline void free_counter(struct perf_counter *counter)		{ }
+static inline void put_ctx(struct perf_counter_context *ctx)		{ }
+static inline struct perf_counter_context *
+find_get_context(pid_t pid, int cpu)			{ return NULL; }
+static inline void perf_install_in_context(struct perf_counter_context *ctx,
+					   struct perf_counter *counter,
+					   int cpu)			{ }
+static inline void
+perf_counter_remove_from_context(struct perf_counter *counter)		{ }
+
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 400ccf6..de62fab 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -137,7 +137,7 @@ static void free_ctx(struct rcu_head *head)
 	kfree(ctx);
 }
 
-static void put_ctx(struct perf_counter_context *ctx)
+void put_ctx(struct perf_counter_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
 		if (ctx->parent_ctx)
@@ -405,7 +405,7 @@ static void __perf_counter_remove_from_context(void *info)
  * When called from perf_counter_exit_task, it's OK because the
  * context has been detached from its task.
  */
-static void perf_counter_remove_from_context(struct perf_counter *counter)
+void perf_counter_remove_from_context(struct perf_counter *counter)
 {
 	struct perf_counter_context *ctx = counter->ctx;
 	struct task_struct *task = ctx->task;
@@ -810,10 +810,9 @@ static void __perf_install_in_context(void *info)
  *
  * Must be called with ctx->mutex held.
  */
-static void
-perf_install_in_context(struct perf_counter_context *ctx,
-			struct perf_counter *counter,
-			int cpu)
+void perf_install_in_context(struct perf_counter_context *ctx,
+			     struct perf_counter *counter,
+			     int cpu)
 {
 	struct task_struct *task = ctx->task;
 
@@ -1558,7 +1557,7 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 	ctx->task = task;
 }
 
-static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
+struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 {
 	struct perf_counter_context *ctx;
 	struct perf_cpu_context *cpuctx;
@@ -1661,7 +1660,7 @@ static void free_counter_rcu(struct rcu_head *head)
 
 static void perf_pending_sync(struct perf_counter *counter);
 
-static void free_counter(struct perf_counter *counter)
+void free_counter(struct perf_counter *counter)
 {
 	perf_pending_sync(counter);
 
@@ -1676,8 +1675,7 @@ static void free_counter(struct perf_counter *counter)
 	}
 
 	if (counter->pmu->close)
-		if (counter->state != PERF_COUNTER_STATE_UNOPENED)
-			counter->pmu->close(counter);
+		counter->pmu->close(counter);
 
 	if (counter->destroy)
 		counter->destroy(counter);
@@ -4010,26 +4008,18 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	return pmu;
 }
 
-/*
- * Allocate and initialize a counter structure
- */
-static struct perf_counter *
-perf_counter_alloc(struct perf_counter_attr *attr,
-		   int cpu,
-		   struct perf_counter_context *ctx,
-		   struct perf_counter *group_leader,
-		   struct perf_counter *parent_counter,
-		   gfp_t gfpflags)
+
+int __perf_counter_init(struct perf_counter *counter,
+			struct perf_counter_attr *attr,
+			int cpu,
+			struct perf_counter_context *ctx,
+			struct perf_counter *group_leader,
+			struct perf_counter *parent_counter)
 {
 	const struct pmu *pmu;
-	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
 	long err;
 
-	counter = kzalloc(sizeof(*counter), gfpflags);
-	if (!counter)
-		return ERR_PTR(-ENOMEM);
-
 	/*
 	 * Single counters are their own group leaders, with an
 	 * empty sibling list:
@@ -4112,10 +4102,8 @@ done:
 
 	if (pmu->open) {
 		err = pmu->open(counter);
-		if (err) {
-			counter->state = PERF_COUNTER_STATE_UNOPENED;
+		if (err)
 			goto fail;
-		}
 	}
 
 	if (!counter->parent) {
@@ -4128,14 +4116,40 @@ done:
 			atomic_inc(&nr_task_counters);
 	}
 
-	return counter;
+	return 0;
 
 fail:
 	if (counter->ns)
 		put_pid_ns(counter->ns);
 	kfree(counter);
 
-	return ERR_PTR(err);
+	return err;
+}
+
+/*
+ * Allocate and initialize a counter structure
+ */
+static struct perf_counter *
+perf_counter_alloc(struct perf_counter_attr *attr,
+		   int cpu,
+		   struct perf_counter_context *ctx,
+		   struct perf_counter *group_leader,
+		   struct perf_counter *parent_counter,
+		   gfp_t gfpflags)
+{
+	int err;
+	struct perf_counter *counter;
+
+	counter = kzalloc(sizeof(*counter), gfpflags);
+	if (!counter)
+		return ERR_PTR(-ENOMEM);
+
+	err = __perf_counter_init(counter, attr, cpu, ctx, group_leader,
+				  parent_counter);
+	if (err)
+		return ERR_PTR(err);
+
+	return counter;
 }
 
 static int perf_copy_attr(struct perf_counter_attr __user *uattr,
-- 
1.6.2.3

