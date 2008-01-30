Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYA3DYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYA3DYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYA3DTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:19:19 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:50748 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYA3DSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:18:52 -0500
Message-Id: <20080130031842.290013804@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 22:15:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 14/22 -v7] Generic command line storage
Content-Disposition: inline; filename=trace-generic-cmdline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saving the comm of tasks for each trace is very expensive.
This patch includes in the context switch hook, a way to
store the last 100 command lines of tasks. This table is
examined when a trace is to be printed.

Note: The comm may be destroyed if other traces are performed.
Later (TBD) patches may simply store this information in the trace
itself.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/Kconfig              |    1 
 lib/tracing/trace_function.c     |    2 
 lib/tracing/trace_sched_switch.c |    5 +
 lib/tracing/tracer.c             |  108 ++++++++++++++++++++++++++++++++++++---
 lib/tracing/tracer.h             |    3 -
 5 files changed, 111 insertions(+), 8 deletions(-)

Index: linux-mcount.git/lib/tracing/Kconfig
===================================================================
--- linux-mcount.git.orig/lib/tracing/Kconfig	2008-01-29 18:08:06.000000000 -0500
+++ linux-mcount.git/lib/tracing/Kconfig	2008-01-29 18:09:01.000000000 -0500
@@ -18,6 +18,7 @@ config FUNCTION_TRACER
 	depends on DEBUG_KERNEL && HAVE_MCOUNT
 	select MCOUNT
 	select TRACING
+	select CONTEXT_SWITCH_TRACER
 	help
 	  Use profiler instrumentation, adding -pg to CFLAGS. This will
 	  insert a call to an architecture specific __mcount routine,
Index: linux-mcount.git/lib/tracing/trace_function.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_function.c	2008-01-29 18:06:24.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_function.c	2008-01-29 18:08:10.000000000 -0500
@@ -29,10 +29,12 @@ static notrace void start_function_trace
 {
 	function_reset(tr);
 	tracing_start_function_trace();
+	tracing_start_sched_switch();
 }
 
 static notrace void stop_function_trace(struct tracing_trace *tr)
 {
+	tracing_stop_sched_switch();
 	tracing_stop_function_trace();
 }
 
Index: linux-mcount.git/lib/tracing/trace_sched_switch.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_sched_switch.c	2008-01-29 18:08:06.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_sched_switch.c	2008-01-29 18:09:03.000000000 -0500
@@ -32,6 +32,11 @@ static notrace void sched_switch_callbac
 	va_list ap;
 	int cpu;
 
+	if (!atomic_read(&sched_ref))
+		return;
+
+	tracing_record_cmdline(current);
+
 	if (!trace_enabled)
 		return;
 
Index: linux-mcount.git/lib/tracing/tracer.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/tracer.c	2008-01-29 18:08:06.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.c	2008-01-29 18:10:04.000000000 -0500
@@ -171,6 +171,87 @@ void tracing_stop_function_trace(void)
 	unregister_mcount_function(&trace_ops);
 }
 
+#define SAVED_CMDLINES 128
+static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
+static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
+static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
+static int cmdline_idx;
+static DEFINE_SPINLOCK(trace_cmdline_lock);
+atomic_t trace_record_cmdline_disabled;
+
+static void trace_init_cmdlines(void)
+{
+	memset(&map_pid_to_cmdline, -1, sizeof(map_pid_to_cmdline));
+	memset(&map_cmdline_to_pid, -1, sizeof(map_cmdline_to_pid));
+	cmdline_idx = 0;
+}
+
+notrace void trace_stop_cmdline_recording(void);
+
+static void notrace trace_save_cmdline(struct task_struct *tsk)
+{
+	unsigned map;
+	unsigned idx;
+
+	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
+		return;
+
+	/*
+	 * It's not the end of the world if we don't get
+	 * the lock, but we also don't want to spin
+	 * nor do we want to disable interrupts,
+	 * so if we miss here, then better luck next time.
+	 */
+	if (!spin_trylock(&trace_cmdline_lock))
+		return;
+
+	idx = map_pid_to_cmdline[tsk->pid];
+	if (idx >= SAVED_CMDLINES) {
+		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
+
+		map = map_cmdline_to_pid[idx];
+		if (map <= PID_MAX_DEFAULT)
+			map_pid_to_cmdline[map] = (unsigned)-1;
+
+		map_pid_to_cmdline[tsk->pid] = idx;
+
+		cmdline_idx = idx;
+	}
+
+	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
+
+	spin_unlock(&trace_cmdline_lock);
+}
+
+static notrace char *trace_find_cmdline(int pid)
+{
+	char *cmdline = "<...>";
+	unsigned map;
+
+	if (!pid)
+		return "<idle>";
+
+	if (pid > PID_MAX_DEFAULT)
+		goto out;
+
+	map = map_pid_to_cmdline[pid];
+	if (map >= SAVED_CMDLINES)
+		goto out;
+
+	cmdline = saved_cmdlines[map];
+
+ out:
+	return cmdline;
+}
+
+void tracing_record_cmdline(struct task_struct *tsk)
+{
+	if (atomic_read(&trace_record_cmdline_disabled))
+		return;
+
+	trace_save_cmdline(tsk);
+}
+
 static inline notrace struct tracing_entry *
 tracing_get_trace_entry(struct tracing_trace *tr,
 			struct tracing_trace_cpu *data)
@@ -212,7 +293,6 @@ tracing_generic_entry_update(struct trac
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
-	memcpy(entry->comm, tsk->comm, TASK_COMM_LEN);
 }
 
 notrace void tracing_function_trace(struct tracing_trace *tr,
@@ -368,6 +448,8 @@ static void *s_start(struct seq_file *m,
 	if (!current_trace || current_trace != iter->trace)
 		return NULL;
 
+	atomic_inc(&trace_record_cmdline_disabled);
+
 	/* let the tracer grab locks here if needed */
 	if (current_trace->start)
 		current_trace->start(iter);
@@ -395,6 +477,8 @@ static void s_stop(struct seq_file *m, v
 {
 	struct tracing_iterator *iter = m->private;
 
+	atomic_dec(&trace_record_cmdline_disabled);
+
 	/* let the tracer release locks here if needed */
 	if (current_trace && current_trace == iter->trace && iter->trace->stop)
 		iter->trace->stop(iter);
@@ -523,8 +607,11 @@ static void notrace
 lat_print_generic(struct seq_file *m, struct tracing_entry *entry, int cpu)
 {
 	int hardirq, softirq;
+	char *comm;
+
+	comm = trace_find_cmdline(entry->pid);
 
-	seq_printf(m, "%8.8s-%-5d ", entry->comm, entry->pid);
+	seq_printf(m, "%8.8s-%-5d ", comm, entry->pid);
 	seq_printf(m, "%d", cpu);
 	seq_printf(m, "%c%c",
 		   (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
@@ -576,6 +663,7 @@ print_lat_fmt(struct seq_file *m, struct
 	struct tracing_entry *next_entry = find_next_entry(iter, NULL);
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
+	char *comm;
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	int verbose = !!(trace_flags & TRACE_ITER_VERBOSE);
 	int S;
@@ -586,9 +674,10 @@ print_lat_fmt(struct seq_file *m, struct
 	abs_usecs = cycles_to_usecs(entry->t - iter->tr->time_start);
 
 	if (verbose) {
+		comm = trace_find_cmdline(entry->pid);
 		seq_printf(m, "%16s %5d %d %d %08x %08x [%08lx]"
 			   " %ld.%03ldms (+%ld.%03ldms): ",
-			   entry->comm,
+			   comm,
 			   entry->pid, cpu, entry->flags,
 			   entry->preempt_count, trace_idx,
 			   cycles_to_usecs(entry->t),
@@ -608,12 +697,14 @@ print_lat_fmt(struct seq_file *m, struct
 	case TRACE_CTX:
 		S = entry->ctx.prev_state < sizeof(state_to_char) ?
 			state_to_char[entry->ctx.prev_state] : 'X';
-		seq_printf(m, " %d:%d:%c --> %d:%d\n",
+		comm = trace_find_cmdline(entry->ctx.next_pid);
+		seq_printf(m, " %d:%d:%c --> %d:%d %s\n",
 			   entry->ctx.prev_pid,
 			   entry->ctx.prev_prio,
 			   S,
 			   entry->ctx.next_pid,
-			   entry->ctx.next_prio);
+			   entry->ctx.next_prio,
+			   comm);
 		break;
 	}
 }
@@ -626,15 +717,18 @@ static void notrace print_trace_fmt(stru
 	unsigned long secs;
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	unsigned long long t;
+	char *comm;
 	int S;
 
+	comm = trace_find_cmdline(iter->ent->pid);
+
 	t = cycles_to_usecs(entry->t);
 	usec_rem = do_div(t, 1000000ULL);
 	secs = (unsigned long)t;
 
 	seq_printf(m, "[%5lu.%06lu] ", secs, usec_rem);
 	seq_printf(m, "CPU %d: ", iter->cpu);
-	seq_printf(m, "%s:%d ", entry->comm,
+	seq_printf(m, "%s:%d ", comm,
 		   entry->pid);
 	switch (entry->type) {
 	case TRACE_FN:
@@ -1184,6 +1278,8 @@ __init static int tracer_alloc_buffers(v
 
 	tracer_init_debugfs();
 
+	trace_init_cmdlines();
+
 	register_trace(&disable_trace);
 
 	return 0;
Index: linux-mcount.git/lib/tracing/tracer.h
===================================================================
--- linux-mcount.git.orig/lib/tracing/tracer.h	2008-01-29 18:08:06.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.h	2008-01-29 18:09:03.000000000 -0500
@@ -25,7 +25,6 @@ struct tracing_entry {
 	char preempt_count; /* assumes PREEMPT_MASK is 8 bits or less */
 	int pid;
 	cycle_t t;
-	char comm[TASK_COMM_LEN];
 	union {
 		struct tracing_function fn;
 		struct tracing_sched_switch ctx;
@@ -98,7 +97,7 @@ void tracing_sched_switch_trace(struct t
 				struct task_struct *prev,
 				struct task_struct *next,
 				unsigned long flags);
-
+void tracing_record_cmdline(struct task_struct *tsk);
 
 void tracing_start_function_trace(void);
 void tracing_stop_function_trace(void);

-- 
