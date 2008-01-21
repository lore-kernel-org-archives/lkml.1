Return-Path: <linux-kernel-owner+w=401wt.eu-S1763886AbYAUPdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763886AbYAUPdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbYAUPY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:58 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:58902 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbYAUPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:24:05 -0500
Message-Id: <20080121152353.112828774@goodmis.org>
References: <20080121152231.579118762@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 10:22:45 -0500
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
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 14/23 -v4] mcount based trace in the form of a header file library
Content-Disposition: inline; filename=mcount-function-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple trace that uses the mcount infrastructure. It is
designed to be fast and small, and easy to use. It is useful to
record things that happen over a very short period of time, and
not to analyze the system in general.

An interface is added to the debugfs

  /debugfs/tracing/

This patch adds the following files:

  fn_trace_ctrl
     echoing "1" into this file starts the mcount function tracing
      (if sysctl kernel.mcount_enabled=1)
     echoing "0" turns it off.

  function_trace
      This file is readonly and holds the result of the trace.

  trace
      This file outputs a easier to read version of the trace.

  iter_ctrl
      Controls the way the output of traces look.
      So far there's two controls:
        echoing in "symonly" will only show the kallsyms variables
            without the addresses (if kallsyms was configured)
        echoing in "verbose" will change the output to show
            a lot more data, but not very easy to understand by
            humans.
        echoing in "nosymonly" turns off symonly.
        echoing in "noverbose" turns off verbose.

The output of the function_trace file is as follows

  "echo noverbose > /debugfs/tracing/iter_ctrl"

preemption latency trace v1.1.5 on 2.6.24-rc7-tst
--------------------------------------------------------------------
 latency: 0 us, #419428/4361791, CPU#1 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:4)
    -----------------
    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------

                 _------=> CPU#
                / _-----=> irqs-off
               | / _----=> need-resched
               || / _---=> hardirq/softirq
               ||| / _--=> preempt-depth
               |||| /
               |||||     delay
   cmd     pid ||||| time  |   caller
      \   /    |||||   \   |   /
 swapper-0     0d.h. 1595128us+: set_normalized_timespec+0x8/0x2d <c043841d> (ktime_get_ts+0x4a/0x4e <c04499d4>)
 swapper-0     0d.h. 1595131us+: _spin_lock+0x8/0x18 <c0630690> (hrtimer_interrupt+0x6e/0x1b0 <c0449c56>)

Or with verbose turned on:

  "echo verbose > /debugfs/tracing/iter_ctrl"

preemption latency trace v1.1.5 on 2.6.24-rc7-tst
--------------------------------------------------------------------
 latency: 0 us, #419428/4361791, CPU#1 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:4)
    -----------------
    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------

         swapper     0 0 9 00000000 00000000 [f3675f41] 1595.128ms (+0.003ms): set_normalized_timespec+0x8/0x2d <c043841d> (ktime_get_ts+0x4a/0x4e <c04499d4>)
         swapper     0 0 9 00000000 00000001 [f3675f45] 1595.131ms (+0.003ms): _spin_lock+0x8/0x18 <c0630690> (hrtimer_interrupt+0x6e/0x1b0 <c0449c56>)
         swapper     0 0 9 00000000 00000002 [f3675f48] 1595.135ms (+0.003ms): _spin_lock+0x8/0x18 <c0630690> (hrtimer_interrupt+0x6e/0x1b0 <c0449c56>)


The "trace" file is not affected by the verbose mode, but is by the symonly.

 echo "nosymonly" > /debugfs/tracing/iter_ctrl

tracer:
[   81.479967] CPU 0: bash:3154 register_mcount_function+0x5f/0x66 <ffffffff80337a4d> <-- _spin_unlock_irqrestore+0xe/0x5a <ffffffff8048cc8f>
[   81.479967] CPU 0: bash:3154 _spin_unlock_irqrestore+0x3e/0x5a <ffffffff8048ccbf> <-- sub_preempt_count+0xc/0x7a <ffffffff80233d7b>
[   81.479968] CPU 0: bash:3154 sub_preempt_count+0x30/0x7a <ffffffff80233d9f> <-- in_lock_functions+0x9/0x24 <ffffffff8025a75d>
[   81.479968] CPU 0: bash:3154 vfs_write+0x11d/0x155 <ffffffff8029a043> <-- dnotify_parent+0x12/0x78 <ffffffff802d54fb>
[   81.479968] CPU 0: bash:3154 dnotify_parent+0x2d/0x78 <ffffffff802d5516> <-- _spin_lock+0xe/0x70 <ffffffff8048c910>
[   81.479969] CPU 0: bash:3154 _spin_lock+0x1b/0x70 <ffffffff8048c91d> <-- add_preempt_count+0xe/0x77 <ffffffff80233df7>
[   81.479969] CPU 0: bash:3154 add_preempt_count+0x3e/0x77 <ffffffff80233e27> <-- in_lock_functions+0x9/0x24 <ffffffff8025a75d>


 echo "symonly" > /debugfs/tracing/iter_ctrl

tracer:
[   81.479913] CPU 0: bash:3154 register_mcount_function+0x5f/0x66 <-- _spin_unlock_irqrestore+0xe/0x5a
[   81.479913] CPU 0: bash:3154 _spin_unlock_irqrestore+0x3e/0x5a <-- sub_preempt_count+0xc/0x7a
[   81.479913] CPU 0: bash:3154 sub_preempt_count+0x30/0x7a <-- in_lock_functions+0x9/0x24
[   81.479914] CPU 0: bash:3154 vfs_write+0x11d/0x155 <-- dnotify_parent+0x12/0x78
[   81.479914] CPU 0: bash:3154 dnotify_parent+0x2d/0x78 <-- _spin_lock+0xe/0x70
[   81.479914] CPU 0: bash:3154 _spin_lock+0x1b/0x70 <-- add_preempt_count+0xe/0x77
[   81.479914] CPU 0: bash:3154 add_preempt_count+0x3e/0x77 <-- in_lock_functions+0x9/0x24


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 lib/Makefile                 |    1 
 lib/tracing/Kconfig          |   16 
 lib/tracing/Makefile         |    3 
 lib/tracing/trace_function.c |  190 ++++++++++
 lib/tracing/tracer.c         |  786 +++++++++++++++++++++++++++++++++++++++++++
 lib/tracing/tracer.h         |   94 +++++
 6 files changed, 1090 insertions(+)

Index: linux-mcount.git/lib/tracing/Kconfig
===================================================================
--- linux-mcount.git.orig/lib/tracing/Kconfig	2008-01-21 09:32:35.000000000 -0500
+++ linux-mcount.git/lib/tracing/Kconfig	2008-01-21 09:59:15.000000000 -0500
@@ -8,3 +8,19 @@ config HAVE_MCOUNT
 config MCOUNT
 	bool
 	select FRAME_POINTER
+
+config TRACING
+        bool
+	depends on DEBUG_KERNEL
+
+config FUNCTION_TRACER
+	bool "Profiler instrumentation based tracer"
+	depends on DEBUG_KERNEL && HAVE_MCOUNT
+	default n
+	select MCOUNT
+	select TRACING
+	help
+	  Use profiler instrumentation, adding -pg to CFLAGS. This will
+	  insert a call to an architecture specific __mcount routine,
+	  that the debugging mechanism using this facility will hook by
+	  providing a set of inline routines.
Index: linux-mcount.git/lib/tracing/Makefile
===================================================================
--- linux-mcount.git.orig/lib/tracing/Makefile	2008-01-21 09:32:35.000000000 -0500
+++ linux-mcount.git/lib/tracing/Makefile	2008-01-21 09:59:15.000000000 -0500
@@ -1,3 +1,6 @@
 obj-$(CONFIG_MCOUNT) += libmcount.o
 
+obj-$(CONFIG_TRACING) += tracer.o
+obj-$(CONFIG_FUNCTION_TRACER) += trace_function.o
+
 libmcount-y := mcount.o
Index: linux-mcount.git/lib/tracing/tracer.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/tracer.c	2008-01-21 10:01:49.000000000 -0500
@@ -0,0 +1,786 @@
+/*
+ * ring buffer based mcount tracer
+ *
+ * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
+ *
+ * Originally taken from the RT patch by:
+ *    Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Based on code from the latency_tracer, that is:
+ *  Copyright (C) 2004-2006 Ingo Molnar
+ *  Copyright (C) 2004 William Lee Irwin III
+ */
+
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/linkage.h>
+#include <linux/seq_file.h>
+#include <linux/percpu.h>
+#include <linux/debugfs.h>
+#include <linux/kallsyms.h>
+#include <linux/utsrelease.h>
+#include <linux/uaccess.h>
+#include <linux/hardirq.h>
+#include <linux/mcount.h>
+
+#include "tracer.h"
+
+enum trace_type {
+	__TRACE_FIRST_TYPE = 0,
+
+	TRACE_FN,
+
+	__TRACE_LAST_TYPE
+};
+
+enum trace_flag_type {
+	TRACE_FLAG_IRQS_OFF		= 0x01,
+	TRACE_FLAG_NEED_RESCHED		= 0x02,
+	TRACE_FLAG_HARDIRQ		= 0x04,
+	TRACE_FLAG_SOFTIRQ		= 0x08,
+};
+
+void notrace tracing_reset(struct tracing_trace_cpu *data)
+{
+	data->trace_idx = 0;
+	atomic_set(&data->underrun, 0);
+}
+
+static inline notrace struct tracing_entry *
+tracing_get_trace_entry(struct tracing_trace *tr,
+			struct tracing_trace_cpu *data)
+{
+	unsigned long idx, idx_next;
+	struct tracing_entry *entry;
+
+	idx = data->trace_idx;
+	idx_next = idx + 1;
+
+	if (unlikely(idx_next >= tr->entries)) {
+		atomic_inc(&data->underrun);
+		idx_next = 0;
+	}
+
+	data->trace_idx = idx_next;
+
+	if (unlikely(idx_next != 0 && atomic_read(&data->underrun)))
+		atomic_inc(&data->underrun);
+
+	entry = data->trace + idx * TRACING_ENTRY_SIZE;
+
+	return entry;
+}
+
+static inline notrace void
+tracing_generic_entry_update(struct tracing_entry *entry,
+			     unsigned long flags)
+{
+	struct task_struct *tsk = current;
+	unsigned long pc;
+
+	pc = preempt_count();
+
+	entry->preempt_count = pc & 0xff;
+	entry->pid	 = tsk->pid;
+	entry->t	 = now();
+	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
+		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
+		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
+		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
+	memcpy(entry->comm, tsk->comm, TASK_COMM_LEN);
+}
+
+notrace void tracing_function_trace(struct tracing_trace *tr,
+				    struct tracing_trace_cpu *data,
+				    unsigned long ip,
+				    unsigned long parent_ip,
+				    unsigned long flags)
+{
+	struct tracing_entry *entry;
+
+	entry = tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, flags);
+	entry->type	    = TRACE_FN;
+	entry->fn.ip	    = ip;
+	entry->fn.parent_ip = parent_ip;
+}
+
+#ifdef CONFIG_DEBUG_FS
+enum trace_iterator {
+	TRACE_ITER_SYM_ONLY	= 1,
+	TRACE_ITER_VERBOSE	= 2,
+};
+
+/* These must match the bit postions above */
+static const char *trace_options[] = {
+	"symonly",
+	"verbose",
+	NULL
+};
+
+static unsigned trace_flags;
+
+enum trace_file_type {
+	TRACE_FILE_LAT_FMT	= 1,
+};
+
+static struct tracing_entry *tracing_entry_idx(struct tracing_trace *tr,
+					       unsigned long idx,
+					       int cpu)
+{
+	struct tracing_entry *array = tr->data[cpu]->trace;
+	unsigned long underrun;
+
+	if (idx >= tr->entries)
+		return NULL;
+
+	underrun = atomic_read(&tr->data[cpu]->underrun);
+	if (underrun)
+		idx = ((underrun - 1) + idx) % tr->entries;
+	else if (idx >= tr->data[cpu]->trace_idx)
+		return NULL;
+
+	return &array[idx];
+}
+
+static struct notrace tracing_entry *
+find_next_entry(struct tracing_iterator *iter, int *ent_cpu)
+{
+	struct tracing_trace *tr = iter->tr;
+	struct tracing_entry *ent, *next = NULL;
+	int next_cpu = -1;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (!tr->data[cpu]->trace)
+			continue;
+		ent = tracing_entry_idx(tr, iter->next_idx[cpu], cpu);
+		if (ent && (!next || next->t > ent->t)) {
+			next = ent;
+			next_cpu = cpu;
+		}
+	}
+
+	if (ent_cpu)
+		*ent_cpu = next_cpu;
+
+	return next;
+}
+
+static void *find_next_entry_inc(struct tracing_iterator *iter)
+{
+	struct tracing_entry *next;
+	int next_cpu = -1;
+
+	next = find_next_entry(iter, &next_cpu);
+
+	if (next) {
+		iter->next_idx[next_cpu]++;
+		iter->idx++;
+	}
+	iter->ent = next;
+	iter->cpu = next_cpu;
+
+	return next ? iter : NULL;
+}
+
+static void notrace *
+s_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct tracing_iterator *iter = m->private;
+	void *ent;
+	void *last_ent = iter->ent;
+	int i = (int)*pos;
+
+	(*pos)++;
+
+	/* can't go backwards */
+	if (iter->idx > i)
+		return NULL;
+
+	if (iter->idx < 0)
+		ent = find_next_entry_inc(iter);
+	else
+		ent = iter;
+
+	while (ent && iter->idx < i)
+		ent = find_next_entry_inc(iter);
+
+	iter->pos = *pos;
+
+	if (last_ent && !ent)
+		seq_puts(m, "\n\nvim:ft=help\n");
+
+	return ent;
+}
+
+static void *s_start(struct seq_file *m, loff_t *pos)
+{
+	struct tracing_iterator *iter = m->private;
+	void *p = NULL;
+	loff_t l = 0;
+	int i;
+
+	/* let the tracer grab locks here if needed */
+	if (iter->tr->start)
+		iter->tr->start(iter);
+
+	if (*pos != iter->pos) {
+		iter->ent = NULL;
+		iter->cpu = 0;
+		iter->idx = -1;
+
+		for (i = 0; i < NR_CPUS; i++)
+			iter->next_idx[i] = 0;
+
+		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
+			;
+
+	} else {
+		l = *pos;
+		p = s_next(m, p, &l);
+	}
+
+	return p;
+}
+
+static void s_stop(struct seq_file *m, void *p)
+{
+	struct tracing_iterator *iter = m->private;
+
+	/* let the tracer release locks here if needed */
+	if (iter->tr->stop)
+		iter->tr->stop(iter);
+}
+
+#ifdef CONFIG_KALLSYMS
+static void seq_print_symbol(struct seq_file *m,
+			     const char *fmt, unsigned long address)
+{
+	char buffer[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(buffer, address);
+	seq_printf(m, fmt, buffer);
+}
+#else
+# define seq_print_symbol(m, fmt, address) do { } while (0)
+#endif
+
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
+static void notrace seq_print_ip_sym(struct seq_file *m,
+				     unsigned long ip, int sym_only)
+{
+	if (!ip) {
+		seq_printf(m, "0");
+		return;
+	}
+
+	seq_print_symbol(m, "%s", ip);
+	if (!sym_only)
+		seq_printf(m, " <" IP_FMT ">", ip);
+}
+
+static void notrace print_help_header(struct seq_file *m)
+{
+	seq_puts(m, "                 _------=> CPU#            \n");
+	seq_puts(m, "                / _-----=> irqs-off        \n");
+	seq_puts(m, "               | / _----=> need-resched    \n");
+	seq_puts(m, "               || / _---=> hardirq/softirq \n");
+	seq_puts(m, "               ||| / _--=> preempt-depth   \n");
+	seq_puts(m, "               |||| /                      \n");
+	seq_puts(m, "               |||||     delay             \n");
+	seq_puts(m, "   cmd     pid ||||| time  |   caller      \n");
+	seq_puts(m, "      \\   /    |||||   \\   |   /           \n");
+}
+
+static void notrace print_trace_header(struct seq_file *m,
+				       struct tracing_iterator *iter)
+{
+	struct tracing_trace *tr = iter->tr;
+	struct tracing_trace_cpu *data = tr->data[tr->cpu];
+	unsigned long underruns = 0;
+	unsigned long underrun;
+	unsigned long entries   = 0;
+	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (tr->data[cpu]->trace) {
+			underrun = atomic_read(&tr->data[cpu]->underrun);
+			if (underrun) {
+				underruns += underrun;
+				entries += tr->entries;
+			} else
+				entries += tr->data[cpu]->trace_idx;
+		}
+	}
+
+	seq_printf(m, "preemption latency trace v1.1.5 on %s\n",
+		   UTS_RELEASE);
+	seq_puts(m, "-----------------------------------"
+		 "---------------------------------\n");
+	seq_printf(m, " latency: %lu us, #%lu/%lu, CPU#%d |"
+		   " (M:%s VP:%d, KP:%d, SP:%d HP:%d",
+		   cycles_to_usecs(data->saved_latency),
+		   entries,
+		   (entries + underruns),
+		   tr->cpu,
+#if defined(CONFIG_PREEMPT_NONE)
+		   "server",
+#elif defined(CONFIG_PREEMPT_VOLUNTARY)
+		   "desktop",
+#elif defined(CONFIG_PREEMPT_DESKTOP)
+		   "preempt",
+#else
+		   "unknown",
+#endif
+		   /* These are reserved for later use */
+		   0, 0, 0, 0);
+#ifdef CONFIG_SMP
+	seq_printf(m, " #P:%d)\n", num_online_cpus());
+#else
+	seq_puts(m, ")\n");
+#endif
+	seq_puts(m, "    -----------------\n");
+	seq_printf(m, "    | task: %.16s-%d "
+		   "(uid:%d nice:%ld policy:%ld rt_prio:%ld)\n",
+		   data->comm, data->pid, data->uid, data->nice,
+		   data->policy, data->rt_priority);
+	seq_puts(m, "    -----------------\n");
+
+	if (data->critical_start) {
+		seq_puts(m, " => started at: ");
+		seq_print_ip_sym(m, data->critical_start, sym_only);
+		seq_puts(m, "\n => ended at:   ");
+		seq_print_ip_sym(m, data->critical_end, sym_only);
+		seq_puts(m, "\n");
+	}
+
+	seq_puts(m, "\n");
+}
+
+
+static void notrace
+lat_print_generic(struct seq_file *m, struct tracing_entry *entry, int cpu)
+{
+	int hardirq, softirq;
+
+	seq_printf(m, "%8.8s-%-5d ", entry->comm, entry->pid);
+	seq_printf(m, "%d", cpu);
+	seq_printf(m, "%c%c",
+		   (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
+		   ((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
+
+	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
+	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
+	if (hardirq && softirq)
+		seq_putc(m, 'H');
+	else {
+		if (hardirq)
+			seq_putc(m, 'h');
+		else {
+			if (softirq)
+				seq_putc(m, 's');
+			else
+				seq_putc(m, '.');
+		}
+	}
+
+	if (entry->preempt_count)
+		seq_printf(m, "%x", entry->preempt_count);
+	else
+		seq_puts(m, ".");
+}
+
+unsigned long preempt_mark_thresh = 100;
+
+static void notrace
+lat_print_timestamp(struct seq_file *m, unsigned long long abs_usecs,
+		    unsigned long rel_usecs)
+{
+	seq_printf(m, " %4lldus", abs_usecs);
+	if (rel_usecs > preempt_mark_thresh)
+		seq_puts(m, "!: ");
+	else if (rel_usecs > 1)
+		seq_puts(m, "+: ");
+	else
+		seq_puts(m, " : ");
+}
+
+static void notrace
+print_lat_fmt(struct seq_file *m, struct tracing_iterator *iter,
+	      unsigned int trace_idx, int cpu)
+{
+	struct tracing_entry *entry = iter->ent;
+	struct tracing_entry *next_entry = find_next_entry(iter, NULL);
+	unsigned long abs_usecs;
+	unsigned long rel_usecs;
+	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
+	int verbose = !!(trace_flags & TRACE_ITER_VERBOSE);
+
+	if (!next_entry)
+		next_entry = entry;
+	rel_usecs = cycles_to_usecs(next_entry->t - entry->t);
+	abs_usecs = cycles_to_usecs(entry->t - iter->tr->time_start);
+
+	if (verbose) {
+		seq_printf(m, "%16s %5d %d %d %08x %08x [%08lx]"
+			   " %ld.%03ldms (+%ld.%03ldms): ",
+			   entry->comm,
+			   entry->pid, cpu, entry->flags,
+			   entry->preempt_count, trace_idx,
+			   cycles_to_usecs(entry->t),
+			   abs_usecs/1000,
+			   abs_usecs % 1000, rel_usecs/1000, rel_usecs % 1000);
+	} else {
+		lat_print_generic(m, entry, cpu);
+		lat_print_timestamp(m, abs_usecs, rel_usecs);
+	}
+	switch (entry->type) {
+	case TRACE_FN:
+		seq_print_ip_sym(m, entry->fn.ip, sym_only);
+		seq_puts(m, " (");
+		seq_print_ip_sym(m, entry->fn.parent_ip, sym_only);
+		seq_puts(m, ")\n");
+		break;
+	}
+}
+
+static void notrace print_trace_fmt(struct seq_file *m,
+				    struct tracing_iterator *iter)
+{
+	unsigned long usec_rem;
+	unsigned long secs;
+	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
+	unsigned long long t;
+
+	t = cycles_to_usecs(iter->ent->t);
+	usec_rem = do_div(t, 1000000ULL);
+	secs = (unsigned long)t;
+
+	seq_printf(m, "[%5lu.%06lu] ", secs, usec_rem);
+	seq_printf(m, "CPU %d: ", iter->cpu);
+	seq_printf(m, "%s:%d ", iter->ent->comm,
+		   iter->ent->pid);
+	switch (iter->ent->type) {
+	case TRACE_FN:
+		seq_print_ip_sym(m, iter->ent->fn.ip, sym_only);
+		if (iter->ent->fn.parent_ip) {
+			seq_printf(m, " <-- ");
+			seq_print_ip_sym(m, iter->ent->fn.parent_ip,
+					 sym_only);
+		}
+		break;
+	}
+	seq_printf(m, "\n");
+}
+
+static int trace_empty(struct tracing_iterator *iter)
+{
+	struct tracing_trace_cpu *data;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		data = iter->tr->data[cpu];
+
+		if (data->trace &&
+		    (data->trace_idx ||
+		     atomic_read(&data->underrun)))
+			return 0;
+	}
+	return 1;
+}
+
+static int s_show(struct seq_file *m, void *v)
+{
+	struct tracing_iterator *iter = v;
+
+	if (iter->ent == NULL) {
+		if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
+			/* print nothing if the buffers are empty */
+			if (trace_empty(iter))
+				return 0;
+			print_trace_header(m, iter);
+			if (!(trace_flags & TRACE_ITER_VERBOSE))
+				print_help_header(m);
+		} else
+			seq_printf(m, "tracer:\n");
+	} else {
+		if (iter->iter_flags & TRACE_FILE_LAT_FMT)
+			print_lat_fmt(m, iter, iter->idx, iter->cpu);
+		else
+			print_trace_fmt(m, iter);
+	}
+
+	return 0;
+}
+
+static struct seq_operations tracer_seq_ops = {
+	.start = s_start,
+	.next = s_next,
+	.stop = s_stop,
+	.show = s_show,
+};
+
+static struct tracing_iterator notrace *
+__tracing_open(struct inode *inode, struct file *file, int *ret)
+{
+	struct tracing_iterator *iter;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter) {
+		*ret = -ENOMEM;
+		goto out;
+	}
+
+	iter->tr = inode->i_private;
+	iter->pos = -1;
+
+	/* TODO stop tracer */
+	*ret = seq_open(file, &tracer_seq_ops);
+	if (!*ret) {
+		struct seq_file *m = file->private_data;
+		m->private = iter;
+
+		/*
+		 * Most tracers want to disable the
+		 * trace while printing a trace.
+		 */
+		if (iter->tr->open)
+			iter->tr->open(iter);
+	} else {
+		kfree(iter);
+		iter = NULL;
+	}
+
+ out:
+	return iter;
+}
+
+int tracing_open_generic(struct inode *inode, struct file *filp)
+{
+	filp->private_data = inode->i_private;
+	return 0;
+}
+
+int tracing_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct tracing_iterator *iter = m->private;
+
+	if (iter->tr->close)
+		iter->tr->close(iter);
+
+	seq_release(inode, file);
+	kfree(iter);
+	return 0;
+}
+
+static int tracing_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	__tracing_open(inode, file, &ret);
+
+	return ret;
+}
+
+static int tracing_lt_open(struct inode *inode, struct file *file)
+{
+	struct tracing_iterator *iter;
+	int ret;
+
+	iter = __tracing_open(inode, file, &ret);
+
+	if (!ret)
+		iter->iter_flags |= TRACE_FILE_LAT_FMT;
+
+	return ret;
+}
+
+struct file_operations tracing_fops = {
+	.open = tracing_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = tracing_release,
+};
+
+struct file_operations tracing_lt_fops = {
+	.open = tracing_lt_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = tracing_release,
+};
+
+static ssize_t tracing_iter_ctrl_read(struct file *filp, char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
+{
+	char *buf;
+	int r = 0;
+	int len = 0;
+	int i;
+
+	/* calulate max size */
+	for (i = 0; trace_options[i]; i++) {
+		len += strlen(trace_options[i]);
+		len += 3; /* "no" and space */
+	}
+
+	/* +2 for \n and \0 */
+	buf = kmalloc(len + 2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; trace_options[i]; i++) {
+		if (trace_flags & (1 << i))
+			r += sprintf(buf + r, "%s ", trace_options[i]);
+		else
+			r += sprintf(buf + r, "no%s ", trace_options[i]);
+	}
+
+	r += sprintf(buf + r, "\n");
+	WARN_ON(r >= len + 2);
+
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    buf, r);
+
+	kfree(buf);
+
+	return r;
+}
+
+static ssize_t tracing_iter_ctrl_write(struct file *filp,
+				       const char __user *ubuf,
+				       size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	char *cmp = buf;
+	int neg = 0;
+	int i;
+
+	if (cnt > 63)
+		cnt = 63;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	if (strncmp(buf, "no", 2) == 0) {
+		neg = 1;
+		cmp += 2;
+	}
+
+	for (i = 0; trace_options[i]; i++) {
+		int len = strlen(trace_options[i]);
+
+		if (strncmp(cmp, trace_options[i], len) == 0) {
+			if (neg)
+				trace_flags &= ~(1 << i);
+			else
+				trace_flags |= (1 << i);
+			break;
+		}
+	}
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
+static struct file_operations tracing_iter_fops = {
+	.open = tracing_open_generic,
+	.read = tracing_iter_ctrl_read,
+	.write = tracing_iter_ctrl_write,
+};
+
+static ssize_t tracing_ctrl_read(struct file *filp, char __user *ubuf,
+				 size_t cnt, loff_t *ppos)
+{
+	struct tracing_trace *tr = filp->private_data;
+	char buf[64];
+	int r;
+
+	r = sprintf(buf, "%ld\n", tr->ctrl);
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       buf, r);
+}
+
+static ssize_t tracing_ctrl_write(struct file *filp,
+				  const char __user *ubuf,
+				  size_t cnt, loff_t *ppos)
+{
+	struct tracing_trace *tr = filp->private_data;
+	long val;
+	char buf[64];
+
+	if (cnt > 63)
+		cnt = 63;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	val = simple_strtoul(buf, NULL, 10);
+
+	tr->ctrl_update(tr, val);
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
+struct file_operations tracing_ctrl_fops = {
+	.open = tracing_open_generic,
+	.read = tracing_ctrl_read,
+	.write = tracing_ctrl_write,
+};
+
+static struct dentry *d_tracer;
+
+struct dentry *tracing_init_dentry(void)
+{
+	static int once;
+
+	if (d_tracer)
+		return d_tracer;
+
+	d_tracer = debugfs_create_dir("tracing", NULL);
+
+	if (!d_tracer && !once) {
+		once = 1;
+		pr_warning("Could not create debugfs directory 'tracing'\n");
+		return NULL;
+	}
+
+	return d_tracer;
+}
+
+static __init int trace_init_debugfs(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	entry = debugfs_create_file("iter_ctrl", 0644, d_tracer,
+				    NULL, &tracing_iter_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'iter_ctrl' entry\n");
+
+	return 0;
+}
+
+device_initcall(trace_init_debugfs);
+
+#endif /* CONFIG_DEBUG_FS */
Index: linux-mcount.git/lib/tracing/tracer.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/tracer.h	2008-01-21 09:59:15.000000000 -0500
@@ -0,0 +1,94 @@
+#ifndef _LINUX_MCOUNT_TRACER_H
+#define _LINUX_MCOUNT_TRACER_H
+
+#include <asm/atomic.h>
+#include <linux/sched.h>
+#include <linux/clocksource.h>
+
+struct tracing_function {
+	unsigned long ip;
+	unsigned long parent_ip;
+};
+
+struct tracing_entry {
+	char type;
+	char cpu;  /* who will want to trace more than 256 CPUS? */
+	char flags;
+	char preempt_count; /* assumes PREEMPT_MASK is 8 bits or less */
+	int pid;
+	cycle_t t;
+	char comm[TASK_COMM_LEN];
+	struct tracing_function fn;
+};
+
+struct tracing_trace_cpu {
+	void *trace;
+	unsigned long trace_idx;
+	atomic_t      disabled;
+	atomic_t      underrun;
+	unsigned long saved_latency;
+	unsigned long critical_start;
+	unsigned long critical_end;
+	unsigned long critical_sequence;
+	unsigned long nice;
+	unsigned long policy;
+	unsigned long rt_priority;
+	cycle_t preempt_timestamp;
+	pid_t	      pid;
+	uid_t	      uid;
+	char comm[TASK_COMM_LEN];
+};
+
+struct tracing_iterator;
+
+struct tracing_trace {
+	unsigned long entries;
+	long	      ctrl;
+	int	      cpu;
+	cycle_t	      time_start;
+	void (*open)(struct tracing_iterator *iter);
+	void (*close)(struct tracing_iterator *iter);
+	void (*start)(struct tracing_iterator *iter);
+	void (*stop)(struct tracing_iterator *iter);
+	void (*ctrl_update)(struct tracing_trace *tr,
+			    unsigned long val);
+	struct tracing_trace_cpu *data[NR_CPUS];
+};
+
+struct tracing_iterator {
+	struct tracing_trace *tr;
+	struct tracing_entry *ent;
+	unsigned long iter_flags;
+	loff_t pos;
+	unsigned long next_idx[NR_CPUS];
+	int cpu;
+	int idx;
+};
+
+#define TRACING_ENTRY_SIZE sizeof(struct tracing_entry)
+
+void notrace tracing_reset(struct tracing_trace_cpu *data);
+int tracing_open_generic(struct inode *inode, struct file *filp);
+struct dentry *tracing_init_dentry(void);
+void tracing_function_trace(struct tracing_trace *tr,
+			    struct tracing_trace_cpu *data,
+			    unsigned long ip,
+			    unsigned long parent_ip,
+			    unsigned long flags);
+
+extern struct file_operations tracing_fops;
+extern struct file_operations tracing_lt_fops;
+extern struct file_operations tracing_ctrl_fops;
+
+static inline notrace cycle_t now(void)
+{
+	return get_monotonic_cycles();
+}
+
+static inline notrace int page_order(const unsigned long size)
+{
+	const unsigned long nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
+	return ilog2(roundup_pow_of_two(nr_pages));
+}
+
+#endif /* _LINUX_MCOUNT_TRACER_H */
Index: linux-mcount.git/lib/Makefile
===================================================================
--- linux-mcount.git.orig/lib/Makefile	2008-01-21 09:32:35.000000000 -0500
+++ linux-mcount.git/lib/Makefile	2008-01-21 09:59:15.000000000 -0500
@@ -67,6 +67,7 @@ obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 obj-$(CONFIG_MCOUNT) += tracing/
+obj-$(CONFIG_TRACING) += tracing/
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
Index: linux-mcount.git/lib/tracing/trace_function.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/trace_function.c	2008-01-21 09:59:15.000000000 -0500
@@ -0,0 +1,190 @@
+/*
+ * ring buffer based mcount tracer
+ *
+ * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
+ *
+ * Based on code from the latency_tracer, that is:
+ *
+ *  Copyright (C) 2004-2006 Ingo Molnar
+ *  Copyright (C) 2004 William Lee Irwin III
+ */
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/mcount.h>
+
+#include "tracer.h"
+
+static struct tracing_trace function_trace __read_mostly;
+static DEFINE_PER_CPU(struct tracing_trace_cpu, function_trace_cpu);
+static int trace_enabled __read_mostly;
+static unsigned long trace_nr_entries = (65536UL);
+
+static int __init set_nr_entries(char *str)
+{
+	if (!str)
+		return 0;
+	trace_nr_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("trace_fn_entries=", set_nr_entries);
+
+static notrace void function_trace_reset(struct tracing_trace *tr)
+{
+	int cpu;
+
+	tr->time_start = now();
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr->data[cpu]);
+}
+
+static void notrace function_trace_call(unsigned long ip,
+					unsigned long parent_ip)
+{
+	struct tracing_trace *tr = &function_trace;
+	struct tracing_trace_cpu *data;
+	unsigned long flags;
+	int cpu;
+
+	if (unlikely(!trace_enabled))
+		return;
+
+	raw_local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	atomic_inc(&data->disabled);
+
+	if (likely(atomic_read(&data->disabled) == 1))
+		tracing_function_trace(tr, data, ip, parent_ip, flags);
+
+	atomic_dec(&data->disabled);
+	raw_local_irq_restore(flags);
+}
+
+static struct mcount_ops trace_ops __read_mostly =
+{
+	.func = function_trace_call,
+};
+
+#ifdef CONFIG_DEBUG_FS
+static void function_trace_ctrl_update(struct tracing_trace *tr,
+				       unsigned long val)
+{
+	val = !!val;
+
+	/* When starting a new trace, reset the buffers */
+	if (val)
+		function_trace_reset(tr);
+
+	if (tr->ctrl ^ val) {
+		if (val) {
+			trace_enabled = 1;
+			register_mcount_function(&trace_ops);
+		} else {
+			trace_enabled = 0;
+			unregister_mcount_function(&trace_ops);
+		}
+		tr->ctrl = val;
+	}
+}
+
+static __init void function_trace_init_debugfs(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	function_trace.ctrl_update = function_trace_ctrl_update;
+
+	entry = debugfs_create_file("fn_trace_ctrl", 0644, d_tracer,
+				    &function_trace, &tracing_ctrl_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'ctrl' entry\n");
+
+	entry = debugfs_create_file("function_trace", 0444, d_tracer,
+				    &function_trace, &tracing_lt_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'function_trace' entry\n");
+
+	entry = debugfs_create_file("trace", 0444, d_tracer,
+				    &function_trace, &tracing_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'trace' entry\n");
+
+}
+
+#else
+static __init void function_trace_init_debugfs(void)
+{
+	/*
+	 * No way to turn on or off the trace function
+	 * without debugfs, so we just turn it on.
+	 */
+}
+#endif
+
+static void function_trace_open(struct tracing_iterator *iter)
+{
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl)
+		trace_enabled = 0;
+}
+
+static void function_trace_close(struct tracing_iterator *iter)
+{
+	if (iter->tr->ctrl)
+		trace_enabled = 1;
+}
+
+__init static int function_trace_alloc_buffers(void)
+{
+	const int order = page_order(trace_nr_entries * TRACING_ENTRY_SIZE);
+	const unsigned long size = (1UL << order) << PAGE_SHIFT;
+	struct tracing_entry *array;
+	int i;
+
+	for_each_possible_cpu(i) {
+		function_trace.data[i] = &per_cpu(function_trace_cpu, i);
+		array = (struct tracing_entry *)
+			  __get_free_pages(GFP_KERNEL, order);
+		if (array == NULL) {
+			printk(KERN_ERR "function tracer: failed to allocate"
+			       " %ld bytes for trace buffer!\n", size);
+			goto free_buffers;
+		}
+		function_trace.data[i]->trace = array;
+	}
+
+	/*
+	 * Since we allocate by orders of pages, we may be able to
+	 * round up a bit.
+	 */
+	function_trace.entries = size / TRACING_ENTRY_SIZE;
+
+	pr_info("function tracer: %ld bytes allocated for %ld",
+		size, trace_nr_entries);
+	pr_info(" entries of %ld bytes\n", (long)TRACING_ENTRY_SIZE);
+	pr_info("   actual entries %ld\n", function_trace.entries);
+
+	function_trace_init_debugfs();
+
+	function_trace.open = function_trace_open;
+	function_trace.close = function_trace_close;
+
+	return 0;
+
+ free_buffers:
+	for (i-- ; i >= 0; i--) {
+		struct tracing_trace_cpu *data = function_trace.data[i];
+
+		if (data && data->trace) {
+			free_pages((unsigned long)data->trace, order);
+			data->trace = NULL;
+		}
+	}
+	return -ENOMEM;
+}
+
+device_initcall(function_trace_alloc_buffers);

-- 
