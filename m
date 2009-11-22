Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZKVE0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZKVE0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 23:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZKVE0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 23:26:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:1355 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZKVE0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 23:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Mt3FparWa7kDyNSWguIDgvvI1hRNoCi8k44ynxiaN2pOT9nS3jXiTvp+HH90pHiy6b
         nrp2jhEZP5jQsFCYocwoDzSkzyOj18SCthfrPS4IkbT4J0ni+adYArwlRnqUM2XvE/Yc
         VgVcbCoIhMEcF5OR8GI0ArgpiIMiue4WHeP3I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/4 v2] tracing: Use the perf recursion protection from trace event
Date: Sun, 22 Nov 2009 05:26:55 +0100
Message-Id: <1258864015-10579-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
References: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we commit a trace to perf, we first check if we are recursing in
the same buffer so that we don't mess-up the buffer with a recursing
trace. But later on, we do the same check from perf to avoid commit
recursion. The recursion check is desired early before we touch the
buffer but we want to do this check only once.

Then export the recursion protection from perf and use it from the trace
events before submitting a trace.

v2: Put appropriate Reported-by tag

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/ftrace_event.h       |    9 +----
 include/linux/perf_event.h         |    4 ++
 include/trace/ftrace.h             |   23 ++++++------
 kernel/perf_event.c                |   68 +++++++++++++++++++++++------------
 kernel/trace/trace_event_profile.c |   14 ++++---
 kernel/trace/trace_kprobe.c        |   48 +++++++++----------------
 kernel/trace/trace_syscalls.c      |   47 +++++++++----------------
 7 files changed, 106 insertions(+), 107 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 43360c1..47bbdf9 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -137,13 +137,8 @@ struct ftrace_event_call {
 
 #define FTRACE_MAX_PROFILE_SIZE	2048
 
-struct perf_trace_buf {
-	char	buf[FTRACE_MAX_PROFILE_SIZE];
-	int	recursion;
-};
-
-extern struct perf_trace_buf	*perf_trace_buf;
-extern struct perf_trace_buf	*perf_trace_buf_nmi;
+extern char *perf_trace_buf;
+extern char *perf_trace_buf_nmi;
 
 #define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 36fe89f..74e98b1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -874,6 +874,8 @@ extern int perf_output_begin(struct perf_output_handle *handle,
 extern void perf_output_end(struct perf_output_handle *handle);
 extern void perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
+extern int perf_swevent_get_recursion_context(int **recursion);
+extern void perf_swevent_put_recursion_context(int *recursion);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -902,6 +904,8 @@ static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
+static int perf_swevent_get_recursion_context(int **recursion)	{ return -1; }
+static void perf_swevent_put_recursion_context(int *recursion)		{ }
 
 #endif
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 4945d1c..c222ef5 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -724,16 +724,19 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 static void ftrace_profile_##call(proto)				\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
+	extern int perf_swevent_get_recursion_context(int **recursion); \
+	extern void perf_swevent_put_recursion_context(int *recursion); \
 	struct ftrace_event_call *event_call = &event_##call;		\
 	extern void perf_tp_event(int, u64, u64, void *, int);		\
 	struct ftrace_raw_##call *entry;				\
-	struct perf_trace_buf *trace_buf;				\
 	u64 __addr = 0, __count = 1;					\
 	unsigned long irq_flags;					\
 	struct trace_entry *ent;					\
 	int __entry_size;						\
 	int __data_size;						\
+	char *trace_buf;						\
 	char *raw_data;							\
+	int *recursion;							\
 	int __cpu;							\
 	int pc;								\
 									\
@@ -749,6 +752,10 @@ static void ftrace_profile_##call(proto)				\
 		return;							\
 									\
 	local_irq_save(irq_flags);					\
+									\
+	if (perf_swevent_get_recursion_context(&recursion))		\
+		goto end_recursion;						\
+									\
 	__cpu = smp_processor_id();					\
 									\
 	if (in_nmi())							\
@@ -759,13 +766,7 @@ static void ftrace_profile_##call(proto)				\
 	if (!trace_buf)							\
 		goto end;						\
 									\
-	trace_buf = per_cpu_ptr(trace_buf, __cpu);			\
-	if (trace_buf->recursion++)					\
-		goto end_recursion;					\
-									\
-	barrier();							\
-									\
-	raw_data = trace_buf->buf;					\
+	raw_data = per_cpu_ptr(trace_buf, __cpu);			\
 									\
 	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;		\
 	entry = (struct ftrace_raw_##call *)raw_data;			\
@@ -780,9 +781,9 @@ static void ftrace_profile_##call(proto)				\
 	perf_tp_event(event_call->id, __addr, __count, entry,		\
 			     __entry_size);				\
 									\
-end_recursion:								\
-	trace_buf->recursion--;						\
-end:									\
+end:								\
+	perf_swevent_put_recursion_context(recursion);			\
+end_recursion:									\
 	local_irq_restore(irq_flags);					\
 									\
 }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 718fa93..aba8227 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3880,34 +3880,42 @@ static void perf_swevent_ctx_event(struct perf_event_context *ctx,
 	}
 }
 
-static int *perf_swevent_recursion_context(struct perf_cpu_context *cpuctx)
+/*
+ * Must be called with preemption disabled
+ */
+int perf_swevent_get_recursion_context(int **recursion)
 {
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+
 	if (in_nmi())
-		return &cpuctx->recursion[3];
+		*recursion = &cpuctx->recursion[3];
+	else if (in_irq())
+		*recursion = &cpuctx->recursion[2];
+	else if (in_softirq())
+		*recursion = &cpuctx->recursion[1];
+	else
+		*recursion = &cpuctx->recursion[0];
 
-	if (in_irq())
-		return &cpuctx->recursion[2];
+	if (**recursion)
+		return -1;
 
-	if (in_softirq())
-		return &cpuctx->recursion[1];
+	(**recursion)++;
 
-	return &cpuctx->recursion[0];
+	return 0;
 }
 
-static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
-				    u64 nr, int nmi,
-				    struct perf_sample_data *data,
-				    struct pt_regs *regs)
+void perf_swevent_put_recursion_context(int *recursion)
 {
-	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
-	int *recursion = perf_swevent_recursion_context(cpuctx);
-	struct perf_event_context *ctx;
-
-	if (*recursion)
-		goto out;
+	(*recursion)--;
+}
 
-	(*recursion)++;
-	barrier();
+static void __do_perf_sw_event(enum perf_type_id type, u32 event_id,
+			       u64 nr, int nmi,
+			       struct perf_sample_data *data,
+			       struct pt_regs *regs)
+{
+	struct perf_event_context *ctx;
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 
 	rcu_read_lock();
 	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
@@ -3920,12 +3928,25 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 	if (ctx)
 		perf_swevent_ctx_event(ctx, type, event_id, nr, nmi, data, regs);
 	rcu_read_unlock();
+}
 
-	barrier();
-	(*recursion)--;
+static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
+				    u64 nr, int nmi,
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs)
+{
+	int *recursion;
+
+	preempt_disable();
+
+	if (perf_swevent_get_recursion_context(&recursion))
+		goto out;
+
+	__do_perf_sw_event(type, event_id, nr, nmi, data, regs);
 
+	perf_swevent_put_recursion_context(recursion);
 out:
-	put_cpu_var(perf_cpu_context);
+	preempt_enable();
 }
 
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
@@ -4159,7 +4180,8 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 	if (!regs)
 		regs = task_pt_regs(current);
 
-	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
+	/* Trace events already protected against recursion */
+	__do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
 				&data, regs);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index e0d351b..d9c60f8 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -9,31 +9,33 @@
 #include "trace.h"
 
 
-struct perf_trace_buf *perf_trace_buf;
+char *perf_trace_buf;
 EXPORT_SYMBOL_GPL(perf_trace_buf);
 
-struct perf_trace_buf *perf_trace_buf_nmi;
+char *perf_trace_buf_nmi;
 EXPORT_SYMBOL_GPL(perf_trace_buf_nmi);
 
+typedef typeof(char [FTRACE_MAX_PROFILE_SIZE]) perf_trace_t ;
+
 /* Count the events in use (per event id, not per instance) */
 static int	total_profile_count;
 
 static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 {
-	struct perf_trace_buf *buf;
+	char *buf;
 	int ret = -ENOMEM;
 
 	if (atomic_inc_return(&event->profile_count))
 		return 0;
 
 	if (!total_profile_count) {
-		buf = alloc_percpu(struct perf_trace_buf);
+		buf = (char *)alloc_percpu(perf_trace_t);
 		if (!buf)
 			goto fail_buf;
 
 		rcu_assign_pointer(perf_trace_buf, buf);
 
-		buf = alloc_percpu(struct perf_trace_buf);
+		buf = (char *)alloc_percpu(perf_trace_t);
 		if (!buf)
 			goto fail_buf_nmi;
 
@@ -79,7 +81,7 @@ int ftrace_profile_enable(int event_id)
 
 static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 {
-	struct perf_trace_buf *buf, *nmi_buf;
+	char *buf, *nmi_buf;
 
 	if (!atomic_add_negative(-1, &event->profile_count))
 		return;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 3696476..22e6f68 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1208,11 +1208,12 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry *entry;
-	struct perf_trace_buf *trace_buf;
 	struct trace_entry *ent;
 	int size, __size, i, pc, __cpu;
 	unsigned long irq_flags;
+	char *trace_buf;
 	char *raw_data;
+	int *recursion;
 
 	pc = preempt_count();
 	__size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
@@ -1227,6 +1228,10 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	 * This also protects the rcu read side
 	 */
 	local_irq_save(irq_flags);
+
+	if (perf_swevent_get_recursion_context(&recursion))
+		goto end_recursion;
+
 	__cpu = smp_processor_id();
 
 	if (in_nmi())
@@ -1237,18 +1242,7 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	if (!trace_buf)
 		goto end;
 
-	trace_buf = per_cpu_ptr(trace_buf, __cpu);
-
-	if (trace_buf->recursion++)
-		goto end_recursion;
-
-	/*
-	 * Make recursion update visible before entering perf_tp_event
-	 * so that we protect from perf recursions.
-	 */
-	barrier();
-
-	raw_data = trace_buf->buf;
+	raw_data = per_cpu_ptr(trace_buf, __cpu);
 
 	/* Zero dead bytes from alignment to avoid buffer leak to userspace */
 	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
@@ -1263,9 +1257,9 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 	perf_tp_event(call->id, entry->ip, 1, entry, size);
 
-end_recursion:
-	trace_buf->recursion--;
 end:
+	perf_swevent_put_recursion_context(recursion);
+end_recursion:
 	local_irq_restore(irq_flags);
 
 	return 0;
@@ -1278,10 +1272,11 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry *entry;
-	struct perf_trace_buf *trace_buf;
 	struct trace_entry *ent;
 	int size, __size, i, pc, __cpu;
 	unsigned long irq_flags;
+	char *trace_buf;
+	int *recursion;
 	char *raw_data;
 
 	pc = preempt_count();
@@ -1297,6 +1292,10 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	 * This also protects the rcu read side
 	 */
 	local_irq_save(irq_flags);
+
+	if (perf_swevent_get_recursion_context(&recursion))
+		goto end_recursion;
+
 	__cpu = smp_processor_id();
 
 	if (in_nmi())
@@ -1307,18 +1306,7 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	if (!trace_buf)
 		goto end;
 
-	trace_buf = per_cpu_ptr(trace_buf, __cpu);
-
-	if (trace_buf->recursion++)
-		goto end_recursion;
-
-	/*
-	 * Make recursion update visible before entering perf_tp_event
-	 * so that we protect from perf recursions.
-	 */
-	barrier();
-
-	raw_data = trace_buf->buf;
+	raw_data = per_cpu_ptr(trace_buf, __cpu);
 
 	/* Zero dead bytes from alignment to avoid buffer leak to userspace */
 	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
@@ -1334,9 +1322,9 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 	perf_tp_event(call->id, entry->ret_ip, 1, entry, size);
 
-end_recursion:
-	trace_buf->recursion--;
 end:
+	perf_swevent_put_recursion_context(recursion);
+end_recursion:
 	local_irq_restore(irq_flags);
 
 	return 0;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 51213b0..0bb9348 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -477,10 +477,11 @@ static int sys_prof_refcount_exit;
 static void prof_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
-	struct perf_trace_buf *trace_buf;
 	struct syscall_trace_enter *rec;
 	unsigned long flags;
+	char *trace_buf;
 	char *raw_data;
+	int *recursion;
 	int syscall_nr;
 	int size;
 	int cpu;
@@ -505,6 +506,9 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	/* Protect the per cpu buffer, begin the rcu read side */
 	local_irq_save(flags);
 
+	if (perf_swevent_get_recursion_context(&recursion))
+		goto end_recursion;
+
 	cpu = smp_processor_id();
 
 	if (in_nmi())
@@ -515,18 +519,7 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	if (!trace_buf)
 		goto end;
 
-	trace_buf = per_cpu_ptr(trace_buf, cpu);
-
-	if (trace_buf->recursion++)
-		goto end_recursion;
-
-	/*
-	 * Make recursion update visible before entering perf_tp_event
-	 * so that we protect from perf recursions.
-	 */
-	barrier();
-
-	raw_data = trace_buf->buf;
+	raw_data = per_cpu_ptr(trace_buf, cpu);
 
 	/* zero the dead bytes from align to not leak stack to user */
 	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
@@ -539,9 +532,9 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 			       (unsigned long *)&rec->args);
 	perf_tp_event(sys_data->enter_id, 0, 1, rec, size);
 
-end_recursion:
-	trace_buf->recursion--;
 end:
+	perf_swevent_put_recursion_context(recursion);
+end_recursion:
 	local_irq_restore(flags);
 }
 
@@ -588,10 +581,11 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
-	struct perf_trace_buf *trace_buf;
 	unsigned long flags;
 	int syscall_nr;
+	char *trace_buf;
 	char *raw_data;
+	int *recursion;
 	int size;
 	int cpu;
 
@@ -617,6 +611,10 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 
 	/* Protect the per cpu buffer, begin the rcu read side */
 	local_irq_save(flags);
+
+	if (perf_swevent_get_recursion_context(&recursion))
+		goto end_recursion;
+
 	cpu = smp_processor_id();
 
 	if (in_nmi())
@@ -627,18 +625,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	if (!trace_buf)
 		goto end;
 
-	trace_buf = per_cpu_ptr(trace_buf, cpu);
-
-	if (trace_buf->recursion++)
-		goto end_recursion;
-
-	/*
-	 * Make recursion update visible before entering perf_tp_event
-	 * so that we protect from perf recursions.
-	 */
-	barrier();
-
-	raw_data = trace_buf->buf;
+	raw_data = per_cpu_ptr(trace_buf, cpu);
 
 	/* zero the dead bytes from align to not leak stack to user */
 	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
@@ -652,9 +639,9 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 
 	perf_tp_event(sys_data->exit_id, 0, 1, rec, size);
 
-end_recursion:
-	trace_buf->recursion--;
 end:
+	perf_swevent_put_recursion_context(recursion);
+end_recursion:
 	local_irq_restore(flags);
 }
 
-- 
1.6.2.3

