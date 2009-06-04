Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZFDQBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZFDQBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbZFDQBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:01:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:37233 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZFDQBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:01:15 -0400
Date: Thu, 4 Jun 2009 16:00:35 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Add fork event
Message-ID: <tip-60313ebed739b331e8e61079da27a11ee3b73a30@git.kernel.org>
Git-Commit-ID: 60313ebed739b331e8e61079da27a11ee3b73a30
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 16:00:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60313ebed739b331e8e61079da27a11ee3b73a30
Gitweb:     http://git.kernel.org/tip/60313ebed739b331e8e61079da27a11ee3b73a30
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Jun 2009 16:53:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 17:51:38 +0200

perf_counter: Add fork event

Create a fork event so that we can easily clone the comm and
dso maps without having to generate all those events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   10 +++
 kernel/fork.c                |    4 +-
 kernel/perf_counter.c        |  131 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 126 insertions(+), 19 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 37d5541..380247b 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -277,6 +277,14 @@ enum perf_event_type {
 	PERF_EVENT_UNTHROTTLE		= 6,
 
 	/*
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u32				pid, ppid;
+	 * };
+	 */
+	PERF_EVENT_FORK			= 7,
+
+	/*
 	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
 	 * will be PERF_RECORD_*
 	 *
@@ -618,6 +626,7 @@ extern void perf_counter_munmap(unsigned long addr, unsigned long len,
 				unsigned long pgoff, struct file *file);
 
 extern void perf_counter_comm(struct task_struct *tsk);
+extern void perf_counter_fork(struct task_struct *tsk);
 
 extern void perf_counter_task_migration(struct task_struct *task, int cpu);
 
@@ -673,6 +682,7 @@ perf_counter_munmap(unsigned long addr, unsigned long len,
 		    unsigned long pgoff, struct file *file)		{ }
 
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
+static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
 static inline void perf_counter_task_migration(struct task_struct *task,
 					       int cpu)			{ }
diff --git a/kernel/fork.c b/kernel/fork.c
index b7d7a9f..f4466ca 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1412,12 +1412,12 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
-		} else {
+		} else if (!(clone_flags & CLONE_VM)) {
 			/*
 			 * vfork will do an exec which will call
 			 * set_task_comm()
 			 */
-			perf_counter_comm(p);
+			perf_counter_fork(p);
 		}
 
 		audit_finish_fork(p);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0bb03f1..78c5862 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -40,9 +40,9 @@ static int perf_reserved_percpu __read_mostly;
 static int perf_overcommit __read_mostly = 1;
 
 static atomic_t nr_counters __read_mostly;
-static atomic_t nr_mmap_tracking __read_mostly;
-static atomic_t nr_munmap_tracking __read_mostly;
-static atomic_t nr_comm_tracking __read_mostly;
+static atomic_t nr_mmap_counters __read_mostly;
+static atomic_t nr_munmap_counters __read_mostly;
+static atomic_t nr_comm_counters __read_mostly;
 
 int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
 int sysctl_perf_counter_mlock __read_mostly = 512; /* 'free' kb per user */
@@ -1447,11 +1447,11 @@ static void free_counter(struct perf_counter *counter)
 
 	atomic_dec(&nr_counters);
 	if (counter->attr.mmap)
-		atomic_dec(&nr_mmap_tracking);
+		atomic_dec(&nr_mmap_counters);
 	if (counter->attr.munmap)
-		atomic_dec(&nr_munmap_tracking);
+		atomic_dec(&nr_munmap_counters);
 	if (counter->attr.comm)
-		atomic_dec(&nr_comm_tracking);
+		atomic_dec(&nr_comm_counters);
 
 	if (counter->destroy)
 		counter->destroy(counter);
@@ -2476,6 +2476,105 @@ static void perf_counter_output(struct perf_counter *counter,
 }
 
 /*
+ * fork tracking
+ */
+
+struct perf_fork_event {
+	struct task_struct	*task;
+
+	struct {
+		struct perf_event_header	header;
+
+		u32				pid;
+		u32				ppid;
+	} event;
+};
+
+static void perf_counter_fork_output(struct perf_counter *counter,
+				     struct perf_fork_event *fork_event)
+{
+	struct perf_output_handle handle;
+	int size = fork_event->event.header.size;
+	struct task_struct *task = fork_event->task;
+	int ret = perf_output_begin(&handle, counter, size, 0, 0);
+
+	if (ret)
+		return;
+
+	fork_event->event.pid = perf_counter_pid(counter, task);
+	fork_event->event.ppid = perf_counter_pid(counter, task->real_parent);
+
+	perf_output_put(&handle, fork_event->event);
+	perf_output_end(&handle);
+}
+
+static int perf_counter_fork_match(struct perf_counter *counter)
+{
+	if (counter->attr.comm || counter->attr.mmap || counter->attr.munmap)
+		return 1;
+
+	return 0;
+}
+
+static void perf_counter_fork_ctx(struct perf_counter_context *ctx,
+				  struct perf_fork_event *fork_event)
+{
+	struct perf_counter *counter;
+
+	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
+		if (perf_counter_fork_match(counter))
+			perf_counter_fork_output(counter, fork_event);
+	}
+	rcu_read_unlock();
+}
+
+static void perf_counter_fork_event(struct perf_fork_event *fork_event)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_counter_context *ctx;
+
+	cpuctx = &get_cpu_var(perf_cpu_context);
+	perf_counter_fork_ctx(&cpuctx->ctx, fork_event);
+	put_cpu_var(perf_cpu_context);
+
+	rcu_read_lock();
+	/*
+	 * doesn't really matter which of the child contexts the
+	 * events ends up in.
+	 */
+	ctx = rcu_dereference(current->perf_counter_ctxp);
+	if (ctx)
+		perf_counter_fork_ctx(ctx, fork_event);
+	rcu_read_unlock();
+}
+
+void perf_counter_fork(struct task_struct *task)
+{
+	struct perf_fork_event fork_event;
+
+	if (!atomic_read(&nr_comm_counters) &&
+	    !atomic_read(&nr_mmap_counters) &&
+	    !atomic_read(&nr_munmap_counters))
+		return;
+
+	fork_event = (struct perf_fork_event){
+		.task	= task,
+		.event  = {
+			.header = {
+				.type = PERF_EVENT_FORK,
+				.size = sizeof(fork_event.event),
+			},
+		},
+	};
+
+	perf_counter_fork_event(&fork_event);
+}
+
+/*
  * comm tracking
  */
 
@@ -2511,11 +2610,9 @@ static void perf_counter_comm_output(struct perf_counter *counter,
 	perf_output_end(&handle);
 }
 
-static int perf_counter_comm_match(struct perf_counter *counter,
-				   struct perf_comm_event *comm_event)
+static int perf_counter_comm_match(struct perf_counter *counter)
 {
-	if (counter->attr.comm &&
-	    comm_event->event.header.type == PERF_EVENT_COMM)
+	if (counter->attr.comm)
 		return 1;
 
 	return 0;
@@ -2531,7 +2628,7 @@ static void perf_counter_comm_ctx(struct perf_counter_context *ctx,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_counter_comm_match(counter, comm_event))
+		if (perf_counter_comm_match(counter))
 			perf_counter_comm_output(counter, comm_event);
 	}
 	rcu_read_unlock();
@@ -2570,7 +2667,7 @@ void perf_counter_comm(struct task_struct *task)
 {
 	struct perf_comm_event comm_event;
 
-	if (!atomic_read(&nr_comm_tracking))
+	if (!atomic_read(&nr_comm_counters))
 		return;
 
 	comm_event = (struct perf_comm_event){
@@ -2708,7 +2805,7 @@ void perf_counter_mmap(unsigned long addr, unsigned long len,
 {
 	struct perf_mmap_event mmap_event;
 
-	if (!atomic_read(&nr_mmap_tracking))
+	if (!atomic_read(&nr_mmap_counters))
 		return;
 
 	mmap_event = (struct perf_mmap_event){
@@ -2729,7 +2826,7 @@ void perf_counter_munmap(unsigned long addr, unsigned long len,
 {
 	struct perf_mmap_event mmap_event;
 
-	if (!atomic_read(&nr_munmap_tracking))
+	if (!atomic_read(&nr_munmap_counters))
 		return;
 
 	mmap_event = (struct perf_mmap_event){
@@ -3427,11 +3524,11 @@ done:
 
 	atomic_inc(&nr_counters);
 	if (counter->attr.mmap)
-		atomic_inc(&nr_mmap_tracking);
+		atomic_inc(&nr_mmap_counters);
 	if (counter->attr.munmap)
-		atomic_inc(&nr_munmap_tracking);
+		atomic_inc(&nr_munmap_counters);
 	if (counter->attr.comm)
-		atomic_inc(&nr_comm_tracking);
+		atomic_inc(&nr_comm_counters);
 
 	return counter;
 }
