Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0BXUGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:06:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50948 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab0BXUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:05:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 05/10] perf_event: __rcu annotations
Date: Wed, 24 Feb 2010 21:04:01 +0100
Message-Id: <1267041846-10469-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX1+p9hsuXO029Ohib/+SQP4G/GLI2s/VE0a/SRi
 V60syytI8uN0EqKQWWBJb9egbmANWxs5/1HLJY8Amgakg4+Lr4
 UgR6FqBU2GM4c40kXH+CA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/perf_event.h |   10 ++++----
 include/linux/sched.h      |    2 +-
 kernel/perf_event.c        |   52 ++++++++++++++++++++++----------------------
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a177698..c0d85e3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -569,11 +569,11 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
 struct perf_event {
 #ifdef CONFIG_PERF_EVENTS
 	struct list_head		group_entry;
-	struct list_head		event_entry;
+	struct rcu_list_head		event_entry;
 	struct list_head		sibling_list;
 	int				nr_siblings;
 	struct perf_event		*group_leader;
-	struct perf_event		*output;
+	struct perf_event __rcu		*output;
 	const struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
@@ -634,7 +634,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	struct perf_mmap_data		*data;
+	struct perf_mmap_data __rcu	*data;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
@@ -682,7 +682,7 @@ struct perf_event_context {
 	struct mutex			mutex;
 
 	struct list_head		group_list;
-	struct list_head		event_list;
+	struct rcu_list_head		event_list;
 	int				nr_events;
 	int				nr_active;
 	int				is_active;
@@ -700,7 +700,7 @@ struct perf_event_context {
 	 * These fields let us detect when two contexts have both
 	 * been cloned (inherited) from a common ancestor.
 	 */
-	struct perf_event_context	*parent_ctx;
+	struct perf_event_context	__rcu *parent_ctx;
 	u64				parent_gen;
 	u64				generation;
 	int				pin_count;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 52a33eb..f14d925 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1502,7 +1502,7 @@ struct task_struct {
 	struct futex_pi_state *pi_state_cache;
 #endif
 #ifdef CONFIG_PERF_EVENTS
-	struct perf_event_context *perf_event_ctxp;
+	struct perf_event_context __rcu *perf_event_ctxp;
 	struct mutex perf_event_mutex;
 	struct list_head perf_event_list;
 #endif
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2ae7409..18701de 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -150,7 +150,7 @@ static void put_ctx(struct perf_event_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
 		if (ctx->parent_ctx)
-			put_ctx(ctx->parent_ctx);
+			put_ctx(__rcu_dereference(ctx->parent_ctx));
 		if (ctx->task)
 			put_task_struct(ctx->task);
 		call_rcu(&ctx->rcu_head, free_ctx);
@@ -160,7 +160,7 @@ static void put_ctx(struct perf_event_context *ctx)
 static void unclone_ctx(struct perf_event_context *ctx)
 {
 	if (ctx->parent_ctx) {
-		put_ctx(ctx->parent_ctx);
+		put_ctx(__rcu_dereference(ctx->parent_ctx));
 		ctx->parent_ctx = NULL;
 	}
 }
@@ -1129,8 +1129,8 @@ static void __perf_event_sync_stat(struct perf_event *event,
 	perf_event_update_userpage(next_event);
 }
 
-#define list_next_entry(pos, member) \
-	list_entry(pos->member.next, typeof(*pos), member)
+#define list_next_entry_rcu(pos, member) \
+	list_entry_rcu(pos->member.next, typeof(*pos), member)
 
 static void perf_event_sync_stat(struct perf_event_context *ctx,
 				   struct perf_event_context *next_ctx)
@@ -1142,10 +1142,10 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
 
 	update_context_time(ctx);
 
-	event = list_first_entry(&ctx->event_list,
+	event = list_first_entry_rcu(&ctx->event_list,
 				   struct perf_event, event_entry);
 
-	next_event = list_first_entry(&next_ctx->event_list,
+	next_event = list_first_entry_rcu(&next_ctx->event_list,
 					struct perf_event, event_entry);
 
 	while (&event->event_entry != &ctx->event_list &&
@@ -1153,8 +1153,8 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
 
 		__perf_event_sync_stat(event, next_event);
 
-		event = list_next_entry(event, event_entry);
-		next_event = list_next_entry(next_event, event_entry);
+		event = list_next_entry_rcu(event, event_entry);
+		next_event = list_next_entry_rcu(next_event, event_entry);
 	}
 }
 
@@ -1173,7 +1173,7 @@ void perf_event_task_sched_out(struct task_struct *task,
 				 struct task_struct *next, int cpu)
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
-	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_event_context *ctx = rcu_dereference(task->perf_event_ctxp);
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
 	struct pt_regs *regs;
@@ -1187,7 +1187,7 @@ void perf_event_task_sched_out(struct task_struct *task,
 
 	rcu_read_lock();
 	parent = rcu_dereference(ctx->parent_ctx);
-	next_ctx = next->perf_event_ctxp;
+	next_ctx = rcu_dereference(next->perf_event_ctxp);
 	if (parent && next_ctx &&
 	    rcu_dereference(next_ctx->parent_ctx) == parent) {
 		/*
@@ -1206,8 +1206,8 @@ void perf_event_task_sched_out(struct task_struct *task,
 			 * XXX do we need a memory barrier of sorts
 			 * wrt to rcu_dereference() of perf_event_ctxp
 			 */
-			task->perf_event_ctxp = next_ctx;
-			next->perf_event_ctxp = ctx;
+			__rcu_assign_pointer(task->perf_event_ctxp, next_ctx);
+			__rcu_assign_pointer(next->perf_event_ctxp, ctx);
 			ctx->task = next;
 			next_ctx->task = task;
 			do_switch = 0;
@@ -1329,7 +1329,7 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 void perf_event_task_sched_in(struct task_struct *task, int cpu)
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
-	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_event_context *ctx = __rcu_dereference(task->perf_event_ctxp);
 
 	if (likely(!ctx))
 		return;
@@ -1470,7 +1470,7 @@ void perf_event_task_tick(struct task_struct *curr, int cpu)
 		return;
 
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
-	ctx = curr->perf_event_ctxp;
+	ctx = rcu_dereference(curr->perf_event_ctxp);
 
 	perf_ctx_adjust_freq(&cpuctx->ctx);
 	if (ctx)
@@ -1501,7 +1501,7 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 	int enabled = 0;
 
 	local_irq_save(flags);
-	ctx = task->perf_event_ctxp;
+	ctx = __rcu_dereference(task->perf_event_ctxp);
 	if (!ctx || !ctx->nr_events)
 		goto out;
 
@@ -1591,7 +1591,7 @@ __perf_event_init_context(struct perf_event_context *ctx,
 	raw_spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->group_list);
-	INIT_LIST_HEAD(&ctx->event_list);
+	INIT_LIST_HEAD_RCU(&ctx->event_list);
 	atomic_set(&ctx->refcount, 1);
 	ctx->task = task;
 }
@@ -2366,7 +2366,7 @@ static void perf_mmap_data_free_rcu(struct rcu_head *rcu_head)
 
 static void perf_mmap_data_release(struct perf_event *event)
 {
-	struct perf_mmap_data *data = event->data;
+	struct perf_mmap_data *data = __rcu_dereference(event->data);
 
 	WARN_ON(atomic_read(&event->mmap_count));
 
@@ -2387,7 +2387,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->data);
+		unsigned long size = perf_data_size(__rcu_dereference(event->data));
 		struct user_struct *user = current_user();
 
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
@@ -4421,7 +4421,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 	INIT_LIST_HEAD(&event->child_list);
 
 	INIT_LIST_HEAD(&event->group_entry);
-	INIT_LIST_HEAD(&event->event_entry);
+	INIT_LIST_HEAD_RCU(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	init_waitqueue_head(&event->waitq);
 
@@ -4629,7 +4629,7 @@ static int perf_event_set_output(struct perf_event *event, int output_fd)
 
 set:
 	mutex_lock(&event->mmap_mutex);
-	old_output = event->output;
+	old_output = __rcu_dereference(event->output);
 	rcu_assign_pointer(event->output, output_event);
 	mutex_unlock(&event->mmap_mutex);
 
@@ -4999,7 +4999,7 @@ void perf_event_exit_task(struct task_struct *child)
 	 * scheduled, so we are now safe from rescheduling changing
 	 * our context.
 	 */
-	child_ctx = child->perf_event_ctxp;
+	child_ctx = __rcu_dereference(child->perf_event_ctxp);
 	__perf_event_task_sched_out(child_ctx);
 
 	/*
@@ -5062,7 +5062,7 @@ again:
  */
 void perf_event_free_task(struct task_struct *task)
 {
-	struct perf_event_context *ctx = task->perf_event_ctxp;
+	struct perf_event_context *ctx = __rcu_dereference(task->perf_event_ctxp);
 	struct perf_event *event, *tmp;
 
 	if (!ctx)
@@ -5160,7 +5160,7 @@ int perf_event_init_task(struct task_struct *child)
 			}
 
 			__perf_event_init_context(child_ctx, child);
-			child->perf_event_ctxp = child_ctx;
+			__rcu_assign_pointer(child->perf_event_ctxp, child_ctx);
 			get_task_struct(child);
 		}
 
@@ -5183,13 +5183,13 @@ int perf_event_init_task(struct task_struct *child)
 		 */
 		cloned_ctx = rcu_dereference(parent_ctx->parent_ctx);
 		if (cloned_ctx) {
-			child_ctx->parent_ctx = cloned_ctx;
+			__rcu_assign_pointer(child_ctx->parent_ctx, cloned_ctx);
 			child_ctx->parent_gen = parent_ctx->parent_gen;
 		} else {
-			child_ctx->parent_ctx = parent_ctx;
+			__rcu_assign_pointer(child_ctx->parent_ctx, parent_ctx);
 			child_ctx->parent_gen = parent_ctx->generation;
 		}
-		get_ctx(child_ctx->parent_ctx);
+		get_ctx(__rcu_dereference(child_ctx->parent_ctx));
 	}
 
 	mutex_unlock(&parent_ctx->mutex);
-- 
1.6.3.3

