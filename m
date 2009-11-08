Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZKHJkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZKHJkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZKHJku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:40:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:37293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZKHJks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:40:48 -0500
Date: Sun, 8 Nov 2009 09:40:14 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, lizf@cn.fujitsu.com, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       jbaron@redhat.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, peterz@infradead.org,
       efault@gmx.de, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <1257477185-7838-1-git-send-email-fweisbec@gmail.com>
References: <1257477185-7838-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing, perf_events: Protect the buffer from recursion in perf
Message-ID: <tip-444a2a3bcd6d5bed5c823136f68fcc93c0fe283f@git.kernel.org>
Git-Commit-ID: 444a2a3bcd6d5bed5c823136f68fcc93c0fe283f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  444a2a3bcd6d5bed5c823136f68fcc93c0fe283f
Gitweb:     http://git.kernel.org/tip/444a2a3bcd6d5bed5c823136f68fcc93c0fe283f
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 6 Nov 2009 04:13:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:31:42 +0100

tracing, perf_events: Protect the buffer from recursion in perf

While tracing using events with perf, if one enables the
lockdep:lock_acquire event, it will infect every other perf
trace events.

Basically, you can enable whatever set of trace events through
perf but if this event is part of the set, the only result we
can get is a long list of lock_acquire events of rcu read lock,
and only that.

This is because of a recursion inside perf.

1) When a trace event is triggered, it will fill a per cpu
   buffer and submit it to perf.

2) Perf will commit this event but will also protect some data
   using rcu_read_lock

3) A recursion appears: rcu_read_lock triggers a lock_acquire
   event that will fill the per cpu event and then submit the
   buffer to perf.

4) Perf detects a recursion and ignores it

5) Perf continues its work on the previous event, but its buffer
   has been overwritten by the lock_acquire event, it has then
   been turned into a lock_acquire event of rcu read lock

Such scenario also happens with lock_release with
rcu_read_unlock().

We could turn the rcu_read_lock() into __rcu_read_lock() to drop
the lock debugging from perf fast path, but that would make us
lose the rcu debugging and that doesn't prevent from other
possible kind of recursion from perf in the future.

This patch adds a recursion protection based on a counter on the
perf trace per cpu buffers to solve the problem.

-v2: Fixed lost whitespace, added reviewed-by tag

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
LKML-Reference: <1257477185-7838-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace_event.h       |    9 +++++-
 include/trace/ftrace.h             |   39 +++++++++++++++++++++------
 kernel/trace/trace_event_profile.c |   41 +++++++++++++----------------
 kernel/trace/trace_kprobe.c        |   50 ++++++++++++++++++++++++++++++------
 kernel/trace/trace_syscalls.c      |   44 ++++++++++++++++++++++++++------
 5 files changed, 133 insertions(+), 50 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index f7b47c3..43360c1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -137,8 +137,13 @@ struct ftrace_event_call {
 
 #define FTRACE_MAX_PROFILE_SIZE	2048
 
-extern char			*trace_profile_buf;
-extern char			*trace_profile_buf_nmi;
+struct perf_trace_buf {
+	char	buf[FTRACE_MAX_PROFILE_SIZE];
+	int	recursion;
+};
+
+extern struct perf_trace_buf	*perf_trace_buf;
+extern struct perf_trace_buf	*perf_trace_buf_nmi;
 
 #define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a7f9460..4945d1c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -649,6 +649,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *	struct ftrace_event_call *event_call = &event_<call>;
  *	extern void perf_tp_event(int, u64, u64, void *, int);
  *	struct ftrace_raw_##call *entry;
+ *	struct perf_trace_buf *trace_buf;
  *	u64 __addr = 0, __count = 1;
  *	unsigned long irq_flags;
  *	struct trace_entry *ent;
@@ -673,14 +674,25 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *	__cpu = smp_processor_id();
  *
  *	if (in_nmi())
- *		raw_data = rcu_dereference(trace_profile_buf_nmi);
+ *		trace_buf = rcu_dereference(perf_trace_buf_nmi);
  *	else
- *		raw_data = rcu_dereference(trace_profile_buf);
+ *		trace_buf = rcu_dereference(perf_trace_buf);
  *
- *	if (!raw_data)
+ *	if (!trace_buf)
  *		goto end;
  *
- *	raw_data = per_cpu_ptr(raw_data, __cpu);
+ *	trace_buf = per_cpu_ptr(trace_buf, __cpu);
+ *
+ * 	// Avoid recursion from perf that could mess up the buffer
+ * 	if (trace_buf->recursion++)
+ *		goto end_recursion;
+ *
+ * 	raw_data = trace_buf->buf;
+ *
+ *	// Make recursion update visible before entering perf_tp_event
+ *	// so that we protect from perf recursions.
+ *
+ *	barrier();
  *
  *	//zero dead bytes from alignment to avoid stack leak to userspace:
  *	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
@@ -713,8 +725,9 @@ static void ftrace_profile_##call(proto)				\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_event_call *event_call = &event_##call;		\
-	extern void perf_tp_event(int, u64, u64, void *, int);	\
+	extern void perf_tp_event(int, u64, u64, void *, int);		\
 	struct ftrace_raw_##call *entry;				\
+	struct perf_trace_buf *trace_buf;				\
 	u64 __addr = 0, __count = 1;					\
 	unsigned long irq_flags;					\
 	struct trace_entry *ent;					\
@@ -739,14 +752,20 @@ static void ftrace_profile_##call(proto)				\
 	__cpu = smp_processor_id();					\
 									\
 	if (in_nmi())							\
-		raw_data = rcu_dereference(trace_profile_buf_nmi);		\
+		trace_buf = rcu_dereference(perf_trace_buf_nmi);	\
 	else								\
-		raw_data = rcu_dereference(trace_profile_buf);		\
+		trace_buf = rcu_dereference(perf_trace_buf);		\
 									\
-	if (!raw_data)							\
+	if (!trace_buf)							\
 		goto end;						\
 									\
-	raw_data = per_cpu_ptr(raw_data, __cpu);			\
+	trace_buf = per_cpu_ptr(trace_buf, __cpu);			\
+	if (trace_buf->recursion++)					\
+		goto end_recursion;					\
+									\
+	barrier();							\
+									\
+	raw_data = trace_buf->buf;					\
 									\
 	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;		\
 	entry = (struct ftrace_raw_##call *)raw_data;			\
@@ -761,6 +780,8 @@ static void ftrace_profile_##call(proto)				\
 	perf_tp_event(event_call->id, __addr, __count, entry,		\
 			     __entry_size);				\
 									\
+end_recursion:								\
+	trace_buf->recursion--;						\
 end:									\
 	local_irq_restore(irq_flags);					\
 									\
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index c9f687a..e0d351b 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -8,41 +8,36 @@
 #include <linux/module.h>
 #include "trace.h"
 
-/*
- * We can't use a size but a type in alloc_percpu()
- * So let's create a dummy type that matches the desired size
- */
-typedef struct {char buf[FTRACE_MAX_PROFILE_SIZE];} profile_buf_t;
 
-char		*trace_profile_buf;
-EXPORT_SYMBOL_GPL(trace_profile_buf);
+struct perf_trace_buf *perf_trace_buf;
+EXPORT_SYMBOL_GPL(perf_trace_buf);
 
-char		*trace_profile_buf_nmi;
-EXPORT_SYMBOL_GPL(trace_profile_buf_nmi);
+struct perf_trace_buf *perf_trace_buf_nmi;
+EXPORT_SYMBOL_GPL(perf_trace_buf_nmi);
 
 /* Count the events in use (per event id, not per instance) */
 static int	total_profile_count;
 
 static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 {
-	char *buf;
+	struct perf_trace_buf *buf;
 	int ret = -ENOMEM;
 
 	if (atomic_inc_return(&event->profile_count))
 		return 0;
 
 	if (!total_profile_count) {
-		buf = (char *)alloc_percpu(profile_buf_t);
+		buf = alloc_percpu(struct perf_trace_buf);
 		if (!buf)
 			goto fail_buf;
 
-		rcu_assign_pointer(trace_profile_buf, buf);
+		rcu_assign_pointer(perf_trace_buf, buf);
 
-		buf = (char *)alloc_percpu(profile_buf_t);
+		buf = alloc_percpu(struct perf_trace_buf);
 		if (!buf)
 			goto fail_buf_nmi;
 
-		rcu_assign_pointer(trace_profile_buf_nmi, buf);
+		rcu_assign_pointer(perf_trace_buf_nmi, buf);
 	}
 
 	ret = event->profile_enable(event);
@@ -53,10 +48,10 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 
 fail_buf_nmi:
 	if (!total_profile_count) {
-		free_percpu(trace_profile_buf_nmi);
-		free_percpu(trace_profile_buf);
-		trace_profile_buf_nmi = NULL;
-		trace_profile_buf = NULL;
+		free_percpu(perf_trace_buf_nmi);
+		free_percpu(perf_trace_buf);
+		perf_trace_buf_nmi = NULL;
+		perf_trace_buf = NULL;
 	}
 fail_buf:
 	atomic_dec(&event->profile_count);
@@ -84,7 +79,7 @@ int ftrace_profile_enable(int event_id)
 
 static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 {
-	char *buf, *nmi_buf;
+	struct perf_trace_buf *buf, *nmi_buf;
 
 	if (!atomic_add_negative(-1, &event->profile_count))
 		return;
@@ -92,11 +87,11 @@ static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 	event->profile_disable(event);
 
 	if (!--total_profile_count) {
-		buf = trace_profile_buf;
-		rcu_assign_pointer(trace_profile_buf, NULL);
+		buf = perf_trace_buf;
+		rcu_assign_pointer(perf_trace_buf, NULL);
 
-		nmi_buf = trace_profile_buf_nmi;
-		rcu_assign_pointer(trace_profile_buf_nmi, NULL);
+		nmi_buf = perf_trace_buf_nmi;
+		rcu_assign_pointer(perf_trace_buf_nmi, NULL);
 
 		/*
 		 * Ensure every events in profiling have finished before
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index cf17a66..3696476 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1208,6 +1208,7 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry *entry;
+	struct perf_trace_buf *trace_buf;
 	struct trace_entry *ent;
 	int size, __size, i, pc, __cpu;
 	unsigned long irq_flags;
@@ -1229,14 +1230,26 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	__cpu = smp_processor_id();
 
 	if (in_nmi())
-		raw_data = rcu_dereference(trace_profile_buf_nmi);
+		trace_buf = rcu_dereference(perf_trace_buf_nmi);
 	else
-		raw_data = rcu_dereference(trace_profile_buf);
+		trace_buf = rcu_dereference(perf_trace_buf);
 
-	if (!raw_data)
+	if (!trace_buf)
 		goto end;
 
-	raw_data = per_cpu_ptr(raw_data, __cpu);
+	trace_buf = per_cpu_ptr(trace_buf, __cpu);
+
+	if (trace_buf->recursion++)
+		goto end_recursion;
+
+	/*
+	 * Make recursion update visible before entering perf_tp_event
+	 * so that we protect from perf recursions.
+	 */
+	barrier();
+
+	raw_data = trace_buf->buf;
+
 	/* Zero dead bytes from alignment to avoid buffer leak to userspace */
 	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
 	entry = (struct kprobe_trace_entry *)raw_data;
@@ -1249,8 +1262,12 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 	perf_tp_event(call->id, entry->ip, 1, entry, size);
+
+end_recursion:
+	trace_buf->recursion--;
 end:
 	local_irq_restore(irq_flags);
+
 	return 0;
 }
 
@@ -1261,6 +1278,7 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry *entry;
+	struct perf_trace_buf *trace_buf;
 	struct trace_entry *ent;
 	int size, __size, i, pc, __cpu;
 	unsigned long irq_flags;
@@ -1282,14 +1300,26 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	__cpu = smp_processor_id();
 
 	if (in_nmi())
-		raw_data = rcu_dereference(trace_profile_buf_nmi);
+		trace_buf = rcu_dereference(perf_trace_buf_nmi);
 	else
-		raw_data = rcu_dereference(trace_profile_buf);
+		trace_buf = rcu_dereference(perf_trace_buf);
 
-	if (!raw_data)
+	if (!trace_buf)
 		goto end;
 
-	raw_data = per_cpu_ptr(raw_data, __cpu);
+	trace_buf = per_cpu_ptr(trace_buf, __cpu);
+
+	if (trace_buf->recursion++)
+		goto end_recursion;
+
+	/*
+	 * Make recursion update visible before entering perf_tp_event
+	 * so that we protect from perf recursions.
+	 */
+	barrier();
+
+	raw_data = trace_buf->buf;
+
 	/* Zero dead bytes from alignment to avoid buffer leak to userspace */
 	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
 	entry = (struct kretprobe_trace_entry *)raw_data;
@@ -1303,8 +1333,12 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 	perf_tp_event(call->id, entry->ret_ip, 1, entry, size);
+
+end_recursion:
+	trace_buf->recursion--;
 end:
 	local_irq_restore(irq_flags);
+
 	return 0;
 }
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 58b8e53..51213b0 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -477,6 +477,7 @@ static int sys_prof_refcount_exit;
 static void prof_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_metadata *sys_data;
+	struct perf_trace_buf *trace_buf;
 	struct syscall_trace_enter *rec;
 	unsigned long flags;
 	char *raw_data;
@@ -507,14 +508,25 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	cpu = smp_processor_id();
 
 	if (in_nmi())
-		raw_data = rcu_dereference(trace_profile_buf_nmi);
+		trace_buf = rcu_dereference(perf_trace_buf_nmi);
 	else
-		raw_data = rcu_dereference(trace_profile_buf);
+		trace_buf = rcu_dereference(perf_trace_buf);
 
-	if (!raw_data)
+	if (!trace_buf)
 		goto end;
 
-	raw_data = per_cpu_ptr(raw_data, cpu);
+	trace_buf = per_cpu_ptr(trace_buf, cpu);
+
+	if (trace_buf->recursion++)
+		goto end_recursion;
+
+	/*
+	 * Make recursion update visible before entering perf_tp_event
+	 * so that we protect from perf recursions.
+	 */
+	barrier();
+
+	raw_data = trace_buf->buf;
 
 	/* zero the dead bytes from align to not leak stack to user */
 	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
@@ -527,6 +539,8 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 			       (unsigned long *)&rec->args);
 	perf_tp_event(sys_data->enter_id, 0, 1, rec, size);
 
+end_recursion:
+	trace_buf->recursion--;
 end:
 	local_irq_restore(flags);
 }
@@ -574,6 +588,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_exit *rec;
+	struct perf_trace_buf *trace_buf;
 	unsigned long flags;
 	int syscall_nr;
 	char *raw_data;
@@ -605,14 +620,25 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	cpu = smp_processor_id();
 
 	if (in_nmi())
-		raw_data = rcu_dereference(trace_profile_buf_nmi);
+		trace_buf = rcu_dereference(perf_trace_buf_nmi);
 	else
-		raw_data = rcu_dereference(trace_profile_buf);
+		trace_buf = rcu_dereference(perf_trace_buf);
 
-	if (!raw_data)
+	if (!trace_buf)
 		goto end;
 
-	raw_data = per_cpu_ptr(raw_data, cpu);
+	trace_buf = per_cpu_ptr(trace_buf, cpu);
+
+	if (trace_buf->recursion++)
+		goto end_recursion;
+
+	/*
+	 * Make recursion update visible before entering perf_tp_event
+	 * so that we protect from perf recursions.
+	 */
+	barrier();
+
+	raw_data = trace_buf->buf;
 
 	/* zero the dead bytes from align to not leak stack to user */
 	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
@@ -626,6 +652,8 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 
 	perf_tp_event(sys_data->exit_id, 0, 1, rec, size);
 
+end_recursion:
+	trace_buf->recursion--;
 end:
 	local_irq_restore(flags);
 }
