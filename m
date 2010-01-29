Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315Ab0A2CHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab0A2CHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228Ab0A2CHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:07:17 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:44606 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0A2CHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:07:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YkxeJlcxkpGOckpeTie6/clB+D6DXKHDJ/ikNwWJZOqUV3EyZSuJOZuLzcF2VRuCaO
         YOIqZtSiiSnqrYYeuZzt1VlNwjFcLpFBJe5eQMlSWtIJj0n/i6qAfAGcIEawOn6McAKq
         IIDF+i+AzvJkXYM1u0/TSM0JR7gSNpJsTRmgA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] perf: Factorize trace events raw sample buffer operations
Date: Fri, 29 Jan 2010 03:07:06 +0100
Message-Id: <1264730829-14563-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
References: <1264730829-14563-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Introduce ftrace_perf_buf_prepare() and ftrace_perf_buf_submit() to
gather the common code that operates on raw events sampling buffer.
This cleans up redundant code between regular trace events, syscall
events and kprobe events.

Changelog v1->v2:
- Rename function name as per Masami and Frederic's suggestion
- Add __kprobes for ftrace_perf_buf_prepare() and make
  ftrace_perf_buf_submit() inline as per Masami's suggestion
- Export ftrace_perf_buf_prepare since modules will use it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4B60E92D.9000808@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace_event.h       |   18 ++++++-
 include/trace/ftrace.h             |   48 +++-----------------
 kernel/trace/trace_event_profile.c |   52 +++++++++++++++++++--
 kernel/trace/trace_kprobe.c        |   86 ++++-------------------------------
 kernel/trace/trace_syscalls.c      |   71 ++++-------------------------
 5 files changed, 88 insertions(+), 187 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0a09e75..cd95919 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -5,6 +5,7 @@
 #include <linux/trace_seq.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/perf_event.h>
 
 struct trace_array;
 struct tracer;
@@ -138,9 +139,6 @@ struct ftrace_event_call {
 
 #define FTRACE_MAX_PROFILE_SIZE	2048
 
-extern char *perf_trace_buf;
-extern char *perf_trace_buf_nmi;
-
 #define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
@@ -195,6 +193,20 @@ extern void ftrace_profile_disable(int event_id);
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
index 4a46a60..f2c09e4 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -850,22 +850,12 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
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
@@ -875,42 +865,16 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
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
index d6266ca..2e28ee3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1243,14 +1243,10 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
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
@@ -1258,45 +1254,16 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
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
@@ -1308,14 +1275,10 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
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
@@ -1323,46 +1286,17 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
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
index f694f66..4e332b9 100644
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
1.6.2.3

