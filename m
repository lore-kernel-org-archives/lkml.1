Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0CEUzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:55:31 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36566 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab0CEUzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YkjIe+vHZVCWjofd/Pi0NZz69vmPGxxDCRV7/WbNGEmisAFh0PMlu/Lq0Uc0pcM0Kn
         P3SXTibFPiVQWxc7+Z5TfxV7DvwK/vWIyc+ee8iAgfzmU79n4tmjk8YkHqwZEuJ/7mVy
         DOACZupRALEOFTGVfbhak9WeQv9yuPzXx3+k4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Archs <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] perf: Take a hot regs snapshot for trace events
Date: Fri,  5 Mar 2010 21:55:17 +0100
Message-Id: <1267822517-5935-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <4B913A83.4040805@redhat.com>
References: <4B913A83.4040805@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are taking a wrong regs snapshot when a trace event triggers.
Either we use get_irq_regs(), which gives us the interrupted
registers if we are in an interrupt, or we use task_pt_regs()
which gives us the state before we entered the kernel, assuming
we are lucky enough to be no kernel thread, in which case
task_pt_regs() returns the initial set of regs when the kernel
thread was started.

What we want is different. We need a hot snapshot of the regs,
so that we can get the instruction pointer to record in the
sample, the frame pointer for the callchain, and some other
things.

Let's use the new perf_fetch_caller_regs() for that.

Comparison with perf record -e lock: -R -a -f -g
Before:

        perf  [kernel]                   [k] __do_softirq
               |
               --- __do_softirq
                  |
                  |--55.16%-- __open
                  |
                   --44.84%-- __write_nocancel

After:

            perf  [kernel]           [k] perf_tp_event
               |
               --- perf_tp_event
                  |
                  |--41.07%-- lock_acquire
                  |          |
                  |          |--39.36%-- _raw_spin_lock
                  |          |          |
                  |          |          |--7.81%-- hrtimer_interrupt
                  |          |          |          smp_apic_timer_interrupt
                  |          |          |          apic_timer_interrupt

The old case was producing unreliable callchains. Now having
right frame and instruction pointers, we have the trace we
want.

Also syscalls and kprobe events already have the right regs,
let's use them instead of wasting a retrieval.

v2: Follow the rename perf_save_regs() -> perf_fetch_caller_regs()

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Archs <linux-arch@vger.kernel.org>
---
 include/linux/ftrace_event.h       |    7 +++++--
 include/trace/ftrace.h             |    6 +++++-
 kernel/perf_event.c                |    9 ++-------
 kernel/trace/trace_event_profile.c |    3 ++-
 kernel/trace/trace_kprobe.c        |    5 +++--
 kernel/trace/trace_syscalls.c      |    4 ++--
 6 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cd95919..48b367e 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -188,6 +188,9 @@ do {									\
 
 #ifdef CONFIG_PERF_EVENTS
 struct perf_event;
+
+DECLARE_PER_CPU(struct pt_regs, perf_trace_regs);
+
 extern int ftrace_profile_enable(int event_id);
 extern void ftrace_profile_disable(int event_id);
 extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
@@ -199,11 +202,11 @@ ftrace_perf_buf_prepare(int size, unsigned short type, int *rctxp,
 
 static inline void
 ftrace_perf_buf_submit(void *raw_data, int size, int rctx, u64 addr,
-		       u64 count, unsigned long irq_flags)
+		       u64 count, unsigned long irq_flags, struct pt_regs *regs)
 {
 	struct trace_entry *entry = raw_data;
 
-	perf_tp_event(entry->type, addr, count, raw_data, size);
+	perf_tp_event(entry->type, addr, count, raw_data, size, regs);
 	perf_swevent_put_recursion_context(rctx);
 	local_irq_restore(irq_flags);
 }
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f2c09e4..1f7677d 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -853,6 +853,7 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
 	unsigned long irq_flags;					\
+	struct pt_regs *__regs;						\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
@@ -873,8 +874,11 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 									\
 	{ assign; }							\
 									\
+	__regs = &__get_cpu_var(perf_trace_regs);			\
+	perf_fetch_caller_regs(__regs, 2);				\
+									\
 	ftrace_perf_buf_submit(entry, __entry_size, rctx, __addr,	\
-			       __count, irq_flags);			\
+			       __count, irq_flags, __regs);		\
 }
 
 #undef DEFINE_EVENT
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1c3059b..aa3b98c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4340,7 +4340,7 @@ static const struct pmu perf_ops_task_clock = {
 #ifdef CONFIG_EVENT_TRACING
 
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
-			  int entry_size)
+		   int entry_size, struct pt_regs *regs)
 {
 	struct perf_raw_record raw = {
 		.size = entry_size,
@@ -4352,14 +4352,9 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 		.raw = &raw,
 	};
 
-	struct pt_regs *regs = get_irq_regs();
-
-	if (!regs)
-		regs = task_pt_regs(current);
-
 	/* Trace events already protected against recursion */
 	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
-				&data, regs);
+			 &data, regs);
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index f0d6930..e66d21e 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -2,13 +2,14 @@
  * trace event based perf counter profiling
  *
  * Copyright (C) 2009 Red Hat Inc, Peter Zijlstra <pzijlstr@redhat.com>
- *
+ * Copyright (C) 2009-2010 Frederic Weisbecker <fweisbec@gmail.com>
  */
 
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include "trace.h"
 
+DEFINE_PER_CPU(struct pt_regs, perf_trace_regs);
 
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 356c102..73e0526 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1260,7 +1260,7 @@ static __kprobes void kprobe_profile_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
-	ftrace_perf_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags);
+	ftrace_perf_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
 }
 
 /* Kretprobe profile handler */
@@ -1291,7 +1291,8 @@ static __kprobes void kretprobe_profile_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
-	ftrace_perf_buf_submit(entry, size, rctx, entry->ret_ip, 1, irq_flags);
+	ftrace_perf_buf_submit(entry, size, rctx, entry->ret_ip, 1,
+			       irq_flags, regs);
 }
 
 static int probe_profile_enable(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4e332b9..d0f34ab 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -462,7 +462,7 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags);
+	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags, regs);
 }
 
 int prof_sysenter_enable(struct ftrace_event_call *call)
@@ -537,7 +537,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags);
+	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags, regs);
 }
 
 int prof_sysexit_enable(struct ftrace_event_call *call)
-- 
1.6.2.3

