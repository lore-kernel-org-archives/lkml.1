Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513Ab0ASIlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0ASIlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433Ab0ASIln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:41:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57180 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab0ASIlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:41:42 -0500
Message-ID: <4B556FCA.3040602@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 16:39:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3 v2] perf_event: cleanup for event profile buffer operation
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B54662B.4050109@cn.fujitsu.com>
In-Reply-To: <4B54662B.4050109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce ftrace_perf_buf_prepare() and ftrace_perf_buf_submit() to
operate event profile buffer, clean up redundant code

Changlog v1->v2:
- Rename function name address Masami and Frederic's suggestion
- Add __kprobes for ftrace_perf_buf_prepare() and make
  ftrace_perf_buf_submit() inline address Masami's suggestion
- Export ftrace_perf_buf_prepare since module will use it

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/ftrace_event.h       |   18 ++++++-
 include/trace/ftrace.h             |   48 +++-----------------
 kernel/trace/trace_event_profile.c |   52 +++++++++++++++++++--
 kernel/trace/trace_kprobe.c        |   86 ++++-------------------------------
 kernel/trace/trace_syscalls.c      |   71 ++++-------------------------
 5 files changed, 88 insertions(+), 187 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 3ca9485..6b7c444 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -5,6 +5,7 @@
 #include <linux/trace_seq.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/perf_event.h>
 
 struct trace_array;
 struct tracer;
@@ -137,9 +138,6 @@ struct ftrace_event_call {
 
 #define FTRACE_MAX_PROFILE_SIZE	2048
 
-extern char *perf_trace_buf;
-extern char *perf_trace_buf_nmi;
-
 #define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
@@ -194,6 +192,20 @@ extern void ftrace_profile_disable(int event_id);
 extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 				     char *filter_str);
 extern void ftrace_profile_free_filter(struct perf_event *event);
+extern void *
+ftrace_perf_buf_prepare(int size, unsigned short type, int *rctxp,
+			 unsigned long *irq_flags);
+
+static inline void
+ftrace_perf_buf_submit(void *raw_data, int size, int rctx, u64 addr,
+		       u64 count, unsigned long irq_flags)
+{
+	struct trace_entry *entry = raw_data;
+
+	perf_tp_event(entry->type, addr, count, raw_data, size);
+	perf_swevent_put_recursion_context(rctx);
+	local_irq_restore(irq_flags);
+}
 #endif
 
 #endif /* _LINUX_FTRACE_EVENT_H */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 5b46cf9..fb2c5bd 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -755,22 +755,12 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 			    proto)					\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	extern int perf_swevent_get_recursion_context(void);		\
-	extern void perf_swevent_put_recursion_context(int rctx);	\
-	extern void perf_tp_event(int, u64, u64, void *, int);		\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
 	unsigned long irq_flags;					\
-	struct trace_entry *ent;					\
 	int __entry_size;						\
 	int __data_size;						\
-	char *trace_buf;						\
-	char *raw_data;							\
-	int __cpu;							\
 	int rctx;							\
-	int pc;								\
-									\
-	pc = preempt_count();						\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
@@ -780,42 +770,16 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 	if (WARN_ONCE(__entry_size > FTRACE_MAX_PROFILE_SIZE,		\
 		      "profile buffer not large enough"))		\
 		return;							\
-									\
-	local_irq_save(irq_flags);					\
-									\
-	rctx = perf_swevent_get_recursion_context();			\
-	if (rctx < 0)							\
-		goto end_recursion;					\
-									\
-	__cpu = smp_processor_id();					\
-									\
-	if (in_nmi())							\
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);	\
-	else								\
-		trace_buf = rcu_dereference(perf_trace_buf);		\
-									\
-	if (!trace_buf)							\
-		goto end;						\
-									\
-	raw_data = per_cpu_ptr(trace_buf, __cpu);			\
-									\
-	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;		\
-	entry = (struct ftrace_raw_##call *)raw_data;			\
-	ent = &entry->ent;						\
-	tracing_generic_entry_update(ent, irq_flags, pc);		\
-	ent->type = event_call->id;					\
-									\
+	entry = (struct ftrace_raw_##call *)ftrace_perf_buf_prepare(	\
+		__entry_size, event_call->id, &rctx, &irq_flags);	\
+	if (!entry)							\
+		return;							\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
-	perf_tp_event(event_call->id, __addr, __count, entry,		\
-			     __entry_size);				\
-									\
-end:									\
-	perf_swevent_put_recursion_context(rctx);			\
-end_recursion:								\
-	local_irq_restore(irq_flags);					\
+	ftrace_perf_buf_submit(entry, __entry_size, rctx, __addr,	\
+			       __count, irq_flags);			\
 }
 
 #undef DEFINE_EVENT
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 9e25573..f0d6930 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -6,14 +6,12 @@
  */
 
 #include <linux/module.h>
+#include <linux/kprobes.h>
 #include "trace.h"
 
 
-char *perf_trace_buf;
-EXPORT_SYMBOL_GPL(perf_trace_buf);
-
-char *perf_trace_buf_nmi;
-EXPORT_SYMBOL_GPL(perf_trace_buf_nmi);
+static char *perf_trace_buf;
+static char *perf_trace_buf_nmi;
 
 typedef typeof(char [FTRACE_MAX_PROFILE_SIZE]) perf_trace_t ;
 
@@ -120,3 +118,47 @@ void ftrace_profile_disable(int event_id)
 	}
 	mutex_unlock(&event_mutex);
 }
+
+__kprobes void *ftrace_perf_buf_prepare(int size, unsigned short type,
+					int *rctxp, unsigned long *irq_flags)
+{
+	struct trace_entry *entry;
+	char *trace_buf, *raw_data;
+	int pc, cpu;
+
+	pc = preempt_count();
+
+	/* Protect the per cpu buffer, begin the rcu read side */
+	local_irq_save(*irq_flags);
+
+	*rctxp = perf_swevent_get_recursion_context();
+	if (*rctxp < 0)
+		goto err_recursion;
+
+	cpu = smp_processor_id();
+
+	if (in_nmi())
+		trace_buf = rcu_dereference(perf_trace_buf_nmi);
+	else
+		trace_buf = rcu_dereference(perf_trace_buf);
+
+	if (!trace_buf)
+		goto err;
+
+	raw_data = per_cpu_ptr(trace_buf, cpu);
+
+	/* zero the dead bytes from align to not leak stack to user */
+	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+
+	entry = (struct trace_entry *)raw_data;
+	tracing_generic_entry_update(entry, *irq_flags, pc);
+	entry->type = type;
+
+	return raw_data;
+err:
+	perf_swevent_put_recursion_context(*rctxp);
+err_recursion:
+	local_irq_restore(*irq_flags);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(ftrace_perf_buf_prepare);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index aa19b6a..2714d23 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1223,14 +1223,10 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry *entry;
-	struct trace_entry *ent;
-	int size, __size, i, pc, __cpu;
+	int size, __size, i;
 	unsigned long irq_flags;
-	char *trace_buf;
-	char *raw_data;
 	int rctx;
 
-	pc = preempt_count();
 	__size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -1238,45 +1234,16 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 		     "profile buffer not large enough"))
 		return 0;
 
-	/*
-	 * Protect the non nmi buffer
-	 * This also protects the rcu read side
-	 */
-	local_irq_save(irq_flags);
-
-	rctx = perf_swevent_get_recursion_context();
-	if (rctx < 0)
-		goto end_recursion;
-
-	__cpu = smp_processor_id();
-
-	if (in_nmi())
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference(perf_trace_buf);
-
-	if (!trace_buf)
-		goto end;
-
-	raw_data = per_cpu_ptr(trace_buf, __cpu);
-
-	/* Zero dead bytes from alignment to avoid buffer leak to userspace */
-	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
-	entry = (struct kprobe_trace_entry *)raw_data;
-	ent = &entry->ent;
+	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
+	if (!entry)
+		return 0;
 
-	tracing_generic_entry_update(ent, irq_flags, pc);
-	ent->type = call->id;
 	entry->nargs = tp->nr_args;
 	entry->ip = (unsigned long)kp->addr;
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
-	perf_tp_event(call->id, entry->ip, 1, entry, size);
 
-end:
-	perf_swevent_put_recursion_context(rctx);
-end_recursion:
-	local_irq_restore(irq_flags);
+	ftrace_perf_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags);
 
 	return 0;
 }
@@ -1288,14 +1255,10 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry *entry;
-	struct trace_entry *ent;
-	int size, __size, i, pc, __cpu;
+	int size, __size, i;
 	unsigned long irq_flags;
-	char *trace_buf;
-	char *raw_data;
 	int rctx;
 
-	pc = preempt_count();
 	__size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -1303,46 +1266,17 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 		     "profile buffer not large enough"))
 		return 0;
 
-	/*
-	 * Protect the non nmi buffer
-	 * This also protects the rcu read side
-	 */
-	local_irq_save(irq_flags);
-
-	rctx = perf_swevent_get_recursion_context();
-	if (rctx < 0)
-		goto end_recursion;
-
-	__cpu = smp_processor_id();
-
-	if (in_nmi())
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference(perf_trace_buf);
-
-	if (!trace_buf)
-		goto end;
-
-	raw_data = per_cpu_ptr(trace_buf, __cpu);
-
-	/* Zero dead bytes from alignment to avoid buffer leak to userspace */
-	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
-	entry = (struct kretprobe_trace_entry *)raw_data;
-	ent = &entry->ent;
+	entry = ftrace_perf_buf_prepare(size, call->id, &rctx, &irq_flags);
+	if (!entry)
+		return 0;
 
-	tracing_generic_entry_update(ent, irq_flags, pc);
-	ent->type = call->id;
 	entry->nargs = tp->nr_args;
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
-	perf_tp_event(call->id, entry->ret_ip, 1, entry, size);
 
-end:
-	perf_swevent_put_recursion_context(rctx);
-end_recursion:
-	local_irq_restore(irq_flags);
+	ftrace_perf_buf_submit(entry, size, rctx, entry->ret_ip, 1, irq_flags);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f6b0712..6cce6a8 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -433,12 +433,9 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	struct syscall_metadata *sys_data;
 	struct syscall_trace_enter *rec;
 	unsigned long flags;
-	char *trace_buf;
-	char *raw_data;
 	int syscall_nr;
 	int rctx;
 	int size;
-	int cpu;
 
 	syscall_nr = syscall_get_nr(current, regs);
 	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
@@ -457,37 +454,15 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 		      "profile buffer not large enough"))
 		return;
 
-	/* Protect the per cpu buffer, begin the rcu read side */
-	local_irq_save(flags);
-
-	rctx = perf_swevent_get_recursion_context();
-	if (rctx < 0)
-		goto end_recursion;
-
-	cpu = smp_processor_id();
-
-	trace_buf = rcu_dereference(perf_trace_buf);
-
-	if (!trace_buf)
-		goto end;
-
-	raw_data = per_cpu_ptr(trace_buf, cpu);
-
-	/* zero the dead bytes from align to not leak stack to user */
-	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+	rec = (struct syscall_trace_enter *)ftrace_perf_buf_prepare(size,
+				sys_data->enter_event->id, &rctx, &flags);
+	if (!rec)
+		return;
 
-	rec = (struct syscall_trace_enter *) raw_data;
-	tracing_generic_entry_update(&rec->ent, 0, 0);
-	rec->ent.type = sys_data->enter_event->id;
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	perf_tp_event(sys_data->enter_event->id, 0, 1, rec, size);
-
-end:
-	perf_swevent_put_recursion_context(rctx);
-end_recursion:
-	local_irq_restore(flags);
+	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags);
 }
 
 int prof_sysenter_enable(struct ftrace_event_call *call)
@@ -531,11 +506,8 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	struct syscall_trace_exit *rec;
 	unsigned long flags;
 	int syscall_nr;
-	char *trace_buf;
-	char *raw_data;
 	int rctx;
 	int size;
-	int cpu;
 
 	syscall_nr = syscall_get_nr(current, regs);
 	if (!test_bit(syscall_nr, enabled_prof_exit_syscalls))
@@ -557,38 +529,15 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 		"exit event has grown above profile buffer size"))
 		return;
 
-	/* Protect the per cpu buffer, begin the rcu read side */
-	local_irq_save(flags);
-
-	rctx = perf_swevent_get_recursion_context();
-	if (rctx < 0)
-		goto end_recursion;
-
-	cpu = smp_processor_id();
-
-	trace_buf = rcu_dereference(perf_trace_buf);
-
-	if (!trace_buf)
-		goto end;
-
-	raw_data = per_cpu_ptr(trace_buf, cpu);
-
-	/* zero the dead bytes from align to not leak stack to user */
-	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
-
-	rec = (struct syscall_trace_exit *)raw_data;
+	rec = (struct syscall_trace_exit *)ftrace_perf_buf_prepare(size,
+				sys_data->exit_event->id, &rctx, &flags);
+	if (!rec)
+		return;
 
-	tracing_generic_entry_update(&rec->ent, 0, 0);
-	rec->ent.type = sys_data->exit_event->id;
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	perf_tp_event(sys_data->exit_event->id, 0, 1, rec, size);
-
-end:
-	perf_swevent_put_recursion_context(rctx);
-end_recursion:
-	local_irq_restore(flags);
+	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags);
 }
 
 int prof_sysexit_enable(struct ftrace_event_call *call)
-- 
1.6.1.2


