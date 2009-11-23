Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZKWLzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZKWLzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZKWLza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:55:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:56181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbZKWLz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:55:26 -0500
Date: Mon, 23 Nov 2009 11:55:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091123103819.993226816@chello.nl>
References: <20091123103819.993226816@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Undo some recursion damage
Message-ID: <tip-4ed7c92d68a5387ba5f7030dc76eab03558e27f5@git.kernel.org>
Git-Commit-ID: 4ed7c92d68a5387ba5f7030dc76eab03558e27f5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ed7c92d68a5387ba5f7030dc76eab03558e27f5
Gitweb:     http://git.kernel.org/tip/4ed7c92d68a5387ba5f7030dc76eab03558e27f5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Nov 2009 11:37:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:49:57 +0100

perf_events: Undo some recursion damage

Make perf_swevent_get_recursion_context return a context number
and disable preemption.

This could be used to remove the IRQ disable from the trace bit
and index the per-cpu buffer with.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091123103819.993226816@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h    |    8 ++--
 include/trace/ftrace.h        |   17 +++++-----
 kernel/perf_event.c           |   71 ++++++++++++++++++----------------------
 kernel/trace/trace_kprobe.c   |   14 +++++---
 kernel/trace/trace_syscalls.c |   14 +++++---
 5 files changed, 61 insertions(+), 63 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 74e98b1..43adbd7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -874,8 +874,8 @@ extern int perf_output_begin(struct perf_output_handle *handle,
 extern void perf_output_end(struct perf_output_handle *handle);
 extern void perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
-extern int perf_swevent_get_recursion_context(int **recursion);
-extern void perf_swevent_put_recursion_context(int *recursion);
+extern int perf_swevent_get_recursion_context(void);
+extern void perf_swevent_put_recursion_context(int rctx);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -904,8 +904,8 @@ static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
-static int perf_swevent_get_recursion_context(int **recursion)	{ return -1; }
-static void perf_swevent_put_recursion_context(int *recursion)		{ }
+static inline int  perf_swevent_get_recursion_context(void)  { return -1; }
+static inline void perf_swevent_put_recursion_context(int rctx)		{ }
 
 #endif
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c222ef5..c3417c1 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -724,8 +724,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 static void ftrace_profile_##call(proto)				\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	extern int perf_swevent_get_recursion_context(int **recursion); \
-	extern void perf_swevent_put_recursion_context(int *recursion); \
+	extern int perf_swevent_get_recursion_context(void);		\
+	extern void perf_swevent_put_recursion_context(int rctx);	\
 	struct ftrace_event_call *event_call = &event_##call;		\
 	extern void perf_tp_event(int, u64, u64, void *, int);		\
 	struct ftrace_raw_##call *entry;				\
@@ -736,8 +736,8 @@ static void ftrace_profile_##call(proto)				\
 	int __data_size;						\
 	char *trace_buf;						\
 	char *raw_data;							\
-	int *recursion;							\
 	int __cpu;							\
+	int rctx;							\
 	int pc;								\
 									\
 	pc = preempt_count();						\
@@ -753,8 +753,9 @@ static void ftrace_profile_##call(proto)				\
 									\
 	local_irq_save(irq_flags);					\
 									\
-	if (perf_swevent_get_recursion_context(&recursion))		\
-		goto end_recursion;						\
+	rctx = perf_swevent_get_recursion_context();			\
+	if (rctx < 0)							\
+		goto end_recursion;					\
 									\
 	__cpu = smp_processor_id();					\
 									\
@@ -781,9 +782,9 @@ static void ftrace_profile_##call(proto)				\
 	perf_tp_event(event_call->id, __addr, __count, entry,		\
 			     __entry_size);				\
 									\
-end:								\
-	perf_swevent_put_recursion_context(recursion);			\
-end_recursion:									\
+end:									\
+	perf_swevent_put_recursion_context(rctx);			\
+end_recursion:								\
 	local_irq_restore(irq_flags);					\
 									\
 }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 50f11b5..0b0d5f7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3869,45 +3869,50 @@ static void perf_swevent_ctx_event(struct perf_event_context *ctx,
 	}
 }
 
-/*
- * Must be called with preemption disabled
- */
-int perf_swevent_get_recursion_context(int **recursion)
+int perf_swevent_get_recursion_context(void)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
+	int rctx;
 
 	if (in_nmi())
-		*recursion = &cpuctx->recursion[3];
+		rctx = 3;
 	else if (in_irq())
-		*recursion = &cpuctx->recursion[2];
+		rctx = 2;
 	else if (in_softirq())
-		*recursion = &cpuctx->recursion[1];
+		rctx = 1;
 	else
-		*recursion = &cpuctx->recursion[0];
+		rctx = 0;
 
-	if (**recursion)
+	if (cpuctx->recursion[rctx]) {
+		put_cpu_var(perf_cpu_context);
 		return -1;
+	}
 
-	(**recursion)++;
+	cpuctx->recursion[rctx]++;
+	barrier();
 
-	return 0;
+	return rctx;
 }
 EXPORT_SYMBOL_GPL(perf_swevent_get_recursion_context);
 
-void perf_swevent_put_recursion_context(int *recursion)
+void perf_swevent_put_recursion_context(int rctx)
 {
-	(*recursion)--;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	barrier();
+	cpuctx->recursion[rctx]++;
+	put_cpu_var(perf_cpu_context);
 }
 EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
 
-static void __do_perf_sw_event(enum perf_type_id type, u32 event_id,
-			       u64 nr, int nmi,
-			       struct perf_sample_data *data,
-			       struct pt_regs *regs)
+static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
+				    u64 nr, int nmi,
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs)
 {
+	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 
+	cpuctx = &__get_cpu_var(perf_cpu_context);
 	rcu_read_lock();
 	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
 				 nr, nmi, data, regs);
@@ -3921,34 +3926,22 @@ static void __do_perf_sw_event(enum perf_type_id type, u32 event_id,
 	rcu_read_unlock();
 }
 
-static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
-				    u64 nr, int nmi,
-				    struct perf_sample_data *data,
-				    struct pt_regs *regs)
-{
-	int *recursion;
-
-	preempt_disable();
-
-	if (perf_swevent_get_recursion_context(&recursion))
-		goto out;
-
-	__do_perf_sw_event(type, event_id, nr, nmi, data, regs);
-
-	perf_swevent_put_recursion_context(recursion);
-out:
-	preempt_enable();
-}
-
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 			    struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data;
+	int rctx;
+
+	rctx = perf_swevent_get_recursion_context();
+	if (rctx < 0)
+		return;
 
 	data.addr = addr;
 	data.raw  = NULL;
 
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
+
+	perf_swevent_put_recursion_context(rctx);
 }
 
 static void perf_swevent_read(struct perf_event *event)
@@ -4172,7 +4165,7 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 		regs = task_pt_regs(current);
 
 	/* Trace events already protected against recursion */
-	__do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
+	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
 				&data, regs);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 22e6f68..79ce6a2 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1213,7 +1213,7 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	unsigned long irq_flags;
 	char *trace_buf;
 	char *raw_data;
-	int *recursion;
+	int rctx;
 
 	pc = preempt_count();
 	__size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
@@ -1229,7 +1229,8 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	 */
 	local_irq_save(irq_flags);
 
-	if (perf_swevent_get_recursion_context(&recursion))
+	rctx = perf_swevent_get_recursion_context();
+	if (rctx < 0)
 		goto end_recursion;
 
 	__cpu = smp_processor_id();
@@ -1258,7 +1259,7 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	perf_tp_event(call->id, entry->ip, 1, entry, size);
 
 end:
-	perf_swevent_put_recursion_context(recursion);
+	perf_swevent_put_recursion_context(rctx);
 end_recursion:
 	local_irq_restore(irq_flags);
 
@@ -1276,8 +1277,8 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	int size, __size, i, pc, __cpu;
 	unsigned long irq_flags;
 	char *trace_buf;
-	int *recursion;
 	char *raw_data;
+	int rctx;
 
 	pc = preempt_count();
 	__size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
@@ -1293,7 +1294,8 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	 */
 	local_irq_save(irq_flags);
 
-	if (perf_swevent_get_recursion_context(&recursion))
+	rctx = perf_swevent_get_recursion_context();
+	if (rctx < 0)
 		goto end_recursion;
 
 	__cpu = smp_processor_id();
@@ -1323,7 +1325,7 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	perf_tp_event(call->id, entry->ret_ip, 1, entry, size);
 
 end:
-	perf_swevent_put_recursion_context(recursion);
+	perf_swevent_put_recursion_context(rctx);
 end_recursion:
 	local_irq_restore(irq_flags);
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 41b6dd9..9189cbe 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -481,8 +481,8 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	unsigned long flags;
 	char *trace_buf;
 	char *raw_data;
-	int *recursion;
 	int syscall_nr;
+	int rctx;
 	int size;
 	int cpu;
 
@@ -506,7 +506,8 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	/* Protect the per cpu buffer, begin the rcu read side */
 	local_irq_save(flags);
 
-	if (perf_swevent_get_recursion_context(&recursion))
+	rctx = perf_swevent_get_recursion_context();
+	if (rctx < 0)
 		goto end_recursion;
 
 	cpu = smp_processor_id();
@@ -530,7 +531,7 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	perf_tp_event(sys_data->enter_id, 0, 1, rec, size);
 
 end:
-	perf_swevent_put_recursion_context(recursion);
+	perf_swevent_put_recursion_context(rctx);
 end_recursion:
 	local_irq_restore(flags);
 }
@@ -582,7 +583,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	int syscall_nr;
 	char *trace_buf;
 	char *raw_data;
-	int *recursion;
+	int rctx;
 	int size;
 	int cpu;
 
@@ -609,7 +610,8 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	/* Protect the per cpu buffer, begin the rcu read side */
 	local_irq_save(flags);
 
-	if (perf_swevent_get_recursion_context(&recursion))
+	rctx = perf_swevent_get_recursion_context();
+	if (rctx < 0)
 		goto end_recursion;
 
 	cpu = smp_processor_id();
@@ -634,7 +636,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	perf_tp_event(sys_data->exit_id, 0, 1, rec, size);
 
 end:
-	perf_swevent_put_recursion_context(recursion);
+	perf_swevent_put_recursion_context(rctx);
 end_recursion:
 	local_irq_restore(flags);
 }
