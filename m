Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYA3DUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYA3DUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYA3DS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:18:56 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:60240 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYA3DSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:18:49 -0500
Message-Id: <20080130031843.606919805@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 22:15:43 -0500
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
Subject: [PATCH 22/22 -v7] Critical latency timings histogram
Content-Disposition: inline; filename=trace-histograms.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds hooks into the latency tracer to give
us histograms of interrupts off, preemption off and
wakeup timings.

This code was based off of work done by Yi Yang <yyang@ch.mvista.com>

But heavily modified to work with the new tracer, and some
clean ups by Steven Rostedt <srostedt@redhat.com>

This adds the following to /debugfs/tracing

  latency_hist/ - root dir for historgrams.

  Under latency_hist there is (depending on what's configured):

    interrupt_off_latency/ - latency histograms of interrupts off.

    preempt_interrupts_off_latency/ - latency histograms of
                              preemption and/or interrupts off.

    preempt_off_latency/ - latency histograms of preemption off.

    wakeup_latency/ - latency histograms of wakeup timings.

  Under each of the above is a file labeled:

    CPU# for each possible CPU were # is the CPU number.

    reset - writing into this file will reset the histogram
            back to zeros and start again.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/Kconfig         |   20 +
 lib/tracing/Makefile        |    4 
 lib/tracing/trace_irqsoff.c |   19 +
 lib/tracing/trace_wakeup.c  |   21 +
 lib/tracing/tracer_hist.c   |  514 ++++++++++++++++++++++++++++++++++++++++++++
 lib/tracing/tracer_hist.h   |   39 +++
 6 files changed, 613 insertions(+), 4 deletions(-)

Index: linux-mcount.git/lib/tracing/Kconfig
===================================================================
--- linux-mcount.git.orig/lib/tracing/Kconfig	2008-01-29 21:34:14.000000000 -0500
+++ linux-mcount.git/lib/tracing/Kconfig	2008-01-29 21:34:30.000000000 -0500
@@ -102,3 +102,23 @@ config CONTEXT_SWITCH_TRACER
 	  This tracer hooks into the context switch and records
 	  all switching of tasks.
 
+config INTERRUPT_OFF_HIST
+	bool "Interrupts off critical timings histogram"
+	depends on CRITICAL_IRQSOFF_TIMING
+	help
+	  This option uses the infrastructure of the critical
+	  irqs off timings to create a histogram of latencies.
+
+config PREEMPT_OFF_HIST
+	bool "Preempt off critical timings histogram"
+	depends on CRITICAL_PREEMPT_TIMING
+	help
+	  This option uses the infrastructure of the critical
+	  preemption off timings to create a histogram of latencies.
+
+config WAKEUP_LATENCY_HIST
+	bool "Interrupts off critical timings histogram"
+	depends on WAKEUP_TRACER
+	help
+	  This option uses the infrastructure of the wakeup tracer
+	  to create a histogram of latencies.
Index: linux-mcount.git/lib/tracing/Makefile
===================================================================
--- linux-mcount.git.orig/lib/tracing/Makefile	2008-01-29 21:34:14.000000000 -0500
+++ linux-mcount.git/lib/tracing/Makefile	2008-01-29 21:34:30.000000000 -0500
@@ -8,4 +8,8 @@ obj-$(CONFIG_CRITICAL_PREEMPT_TIMING) +=
 obj-$(CONFIG_WAKEUP_TRACER) += trace_wakeup.o
 obj-$(CONFIG_EVENT_TRACER) += trace_events.o
 
+obj-$(CONFIG_INTERRUPT_OFF_HIST) += tracer_hist.o
+obj-$(CONFIG_PREEMPT_OFF_HIST) += tracer_hist.o
+obj-$(CONFIG_WAKEUP_LATENCY_HIST) += tracer_hist.o
+
 libmcount-y := mcount.o
Index: linux-mcount.git/lib/tracing/trace_irqsoff.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_irqsoff.c	2008-01-29 21:34:14.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_irqsoff.c	2008-01-29 21:34:30.000000000 -0500
@@ -16,6 +16,7 @@
 #include <linux/mcount.h>
 
 #include "tracer.h"
+#include "tracer_hist.h"
 
 static struct tracing_trace *tracer_trace __read_mostly;
 static __cacheline_aligned_in_smp DEFINE_MUTEX(max_mutex);
@@ -261,10 +262,14 @@ void notrace start_critical_timings(void
 {
 	if (preempt_trace() || irq_trace())
 		start_critical_timing(CALLER_ADDR0, 0);
+
+	tracing_hist_preempt_start();
 }
 
 void notrace stop_critical_timings(void)
 {
+	tracing_hist_preempt_stop(TRACE_STOP);
+
 	if (preempt_trace() || irq_trace())
 		stop_critical_timing(CALLER_ADDR0, 0);
 }
@@ -273,6 +278,8 @@ void notrace stop_critical_timings(void)
 #ifdef CONFIG_LOCKDEP
 void notrace time_hardirqs_on(unsigned long a0, unsigned long a1)
 {
+	tracing_hist_preempt_stop(1);
+
 	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(a0, a1);
 }
@@ -281,6 +288,8 @@ void notrace time_hardirqs_off(unsigned 
 {
 	if (!preempt_trace() && irq_trace())
 		start_critical_timing(a0, a1);
+
+	tracing_hist_preempt_start();
 }
 
 #else /* !CONFIG_LOCKDEP */
@@ -314,6 +323,8 @@ inline void print_irqtrace_events(struct
  */
 void notrace trace_hardirqs_on(void)
 {
+	tracing_hist_preempt_stop(1);
+
 	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(CALLER_ADDR0, 0);
 }
@@ -323,11 +334,15 @@ void notrace trace_hardirqs_off(void)
 {
 	if (!preempt_trace() && irq_trace())
 		start_critical_timing(CALLER_ADDR0, 0);
+
+	tracing_hist_preempt_start();
 }
 EXPORT_SYMBOL(trace_hardirqs_off);
 
 void notrace trace_hardirqs_on_caller(unsigned long caller_addr)
 {
+	tracing_hist_preempt_stop(1);
+
 	if (!preempt_trace() && irq_trace())
 		stop_critical_timing(CALLER_ADDR0, caller_addr);
 }
@@ -337,6 +352,8 @@ void notrace trace_hardirqs_off_caller(u
 {
 	if (!preempt_trace() && irq_trace())
 		start_critical_timing(CALLER_ADDR0, caller_addr);
+
+	tracing_hist_preempt_start();
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 
@@ -346,12 +363,14 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller)
 #ifdef CONFIG_CRITICAL_PREEMPT_TIMING
 void notrace trace_preempt_on(unsigned long a0, unsigned long a1)
 {
+	tracing_hist_preempt_stop(0);
 	stop_critical_timing(a0, a1);
 }
 
 void notrace trace_preempt_off(unsigned long a0, unsigned long a1)
 {
 	start_critical_timing(a0, a1);
+	tracing_hist_preempt_start();
 }
 #endif /* CONFIG_CRITICAL_PREEMPT_TIMING */
 
Index: linux-mcount.git/lib/tracing/trace_wakeup.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_wakeup.c	2008-01-29 21:34:14.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_wakeup.c	2008-01-29 21:34:30.000000000 -0500
@@ -16,6 +16,7 @@
 #include <linux/mcount.h>
 
 #include "tracer.h"
+#include "tracer_hist.h"
 
 static struct tracing_trace *tracer_trace __read_mostly;
 static int trace_enabled __read_mostly;
@@ -55,7 +56,9 @@ static void notrace wakeup_sched_switch(
 	unsigned long flags;
 	int cpu;
 
-	if (unlikely(!trace_enabled) || next != wakeup_task)
+	tracing_hist_wakeup_stop(next);
+
+	if (!trace_enabled || next != wakeup_task)
 		return;
 
 	/* The task we are waitng for is waking up */
@@ -219,7 +222,8 @@ static notrace void wake_up_callback(con
 	struct task_struct *p;
 	va_list ap;
 
-	if (likely(!trace_enabled) && !trace_event_enabled())
+	if (likely(!trace_enabled) &&
+	    !trace_event_enabled() && !tracing_wakeup_hist)
 		return;
 
 	va_start(ap, format);
@@ -231,6 +235,7 @@ static notrace void wake_up_callback(con
 	va_end(ap);
 
 	trace_event_wakeup(CALLER_ADDR0, p, curr);
+	tracing_hist_wakeup_start(p, curr);
 
 	if (trace_enabled)
 		wakeup_check_start(tr, p, curr);
@@ -285,7 +290,8 @@ static notrace void start_wakeup_trace(s
 	if (ret)
 		return;
 
-	register_tracer_switch(&switch_ops);
+	if (!tracing_wakeup_hist)
+		register_tracer_switch(&switch_ops);
 	tracing_start_sched_switch();
 	trace_start_events();
 
@@ -299,7 +305,8 @@ static notrace void stop_wakeup_trace(st
 	trace_enabled = 0;
 	tracing_stop_wakeup();
 	tracing_stop_sched_switch();
-	unregister_tracer_switch(&switch_ops);
+	if (!tracing_wakeup_hist)
+		unregister_tracer_switch(&switch_ops);
 }
 
 static notrace void wakeup_trace_init(struct tracing_trace *tr)
@@ -385,6 +392,12 @@ __init static int init_wakeup_trace(void
 		goto fail_deprobe;
 	}
 
+	if (tracing_wakeup_hist) {
+		register_tracer_switch(&switch_ops);
+		tracing_start_wakeup();
+		tracing_start_sched_switch();
+	}
+
 	return 0;
  fail_deprobe:
 	marker_probe_unregister("kernel_sched_wakeup");
Index: linux-mcount.git/lib/tracing/tracer_hist.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/tracer_hist.c	2008-01-29 21:34:30.000000000 -0500
@@ -0,0 +1,514 @@
+/*
+ * lib/tracing/tracer_hist.c
+ *
+ * Add support for histograms of preemption-off latency and
+ * interrupt-off latency and wakeup latency, it depends on
+ * Real-Time Preemption Support.
+ *
+ *  Copyright (C) 2005 MontaVista Software, Inc.
+ *  Yi Yang <yyang@ch.mvista.com>
+ *
+ *  Converted to work with the new latency tracer.
+ *  Copyright (C) 2008 Red Hat, Inc.
+ *    Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <asm/atomic.h>
+#include <asm/div64.h>
+#include <asm/uaccess.h>
+
+#include "tracer.h"
+#include "tracer_hist.h"
+
+enum {
+	INTERRUPT_LATENCY = 0,
+	PREEMPT_LATENCY,
+	PREEMPT_INTERRUPT_LATENCY,
+	WAKEUP_LATENCY,
+};
+
+#define MAX_ENTRY_NUM 10240
+
+struct hist_data {
+	atomic_t hist_mode; /* 0 log, 1 don't log */
+	unsigned long min_lat;
+	unsigned long avg_lat;
+	unsigned long max_lat;
+	unsigned long long beyond_hist_bound_samples;
+	unsigned long long accumulate_lat;
+	unsigned long long total_samples;
+	unsigned long long hist_array[MAX_ENTRY_NUM];
+};
+
+static char *latency_hist_dir_root = "latency_hist";
+
+#ifdef CONFIG_INTERRUPT_OFF_HIST
+static DEFINE_PER_CPU(struct hist_data, interrupt_off_hist);
+static char *interrupt_off_hist_dir = "interrupt_off_latency";
+#endif
+
+#ifdef CONFIG_PREEMPT_OFF_HIST
+static DEFINE_PER_CPU(struct hist_data, preempt_off_hist);
+static char *preempt_off_hist_dir = "preempt_off_latency";
+#endif
+
+#if defined(CONFIG_PREEMPT_OFF_HIST) && defined(CONFIG_INTERRUPT_OFF_HIST)
+static DEFINE_PER_CPU(struct hist_data, preempt_irqs_off_hist);
+static char *preempt_irqs_off_hist_dir = "preempt_interrupts_off_latency";
+#endif
+
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+static DEFINE_PER_CPU(struct hist_data, wakeup_latency_hist);
+static char *wakeup_latency_hist_dir = "wakeup_latency";
+#endif
+
+static inline u64 u64_div(u64 x, u64 y)
+{
+	do_div(x, y);
+	return x;
+}
+
+void notrace latency_hist(int latency_type, int cpu, unsigned long latency)
+{
+	struct hist_data *my_hist;
+
+	if ((cpu < 0) || (cpu >= NR_CPUS) || (latency_type < INTERRUPT_LATENCY)
+			|| (latency_type > WAKEUP_LATENCY) || (latency < 0))
+		return;
+
+	switch (latency_type) {
+#ifdef CONFIG_INTERRUPT_OFF_HIST
+	case INTERRUPT_LATENCY:
+		my_hist = &per_cpu(interrupt_off_hist, cpu);
+		break;
+#endif
+
+#ifdef CONFIG_PREEMPT_OFF_HIST
+	case PREEMPT_LATENCY:
+		my_hist = &per_cpu(preempt_off_hist, cpu);
+		break;
+#endif
+
+#if defined(CONFIG_PREEMPT_OFF_HIST) && defined(CONFIG_INTERRUPT_OFF_HIST)
+	case PREEMPT_INTERRUPT_LATENCY:
+		my_hist = &per_cpu(preempt_irqs_off_hist, cpu);
+		break;
+#endif
+
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+	case WAKEUP_LATENCY:
+		my_hist = &per_cpu(wakeup_latency_hist, cpu);
+		break;
+#endif
+	default:
+		return;
+	}
+
+	if (atomic_read(&my_hist->hist_mode) == 0)
+		return;
+
+	if (latency >= MAX_ENTRY_NUM)
+		my_hist->beyond_hist_bound_samples++;
+	else
+		my_hist->hist_array[latency]++;
+
+	if (latency < my_hist->min_lat)
+		my_hist->min_lat = latency;
+	else if (latency > my_hist->max_lat)
+		my_hist->max_lat = latency;
+
+	my_hist->total_samples++;
+	my_hist->accumulate_lat += latency;
+	my_hist->avg_lat = (unsigned long) u64_div(my_hist->accumulate_lat,
+						  my_hist->total_samples);
+	return;
+}
+
+static void *l_start(struct seq_file *m, loff_t *pos)
+{
+	loff_t *index_ptr = kmalloc(sizeof(loff_t), GFP_KERNEL);
+	loff_t index = *pos;
+	struct hist_data *my_hist = m->private;
+
+	if (!index_ptr)
+		return NULL;
+
+	if (index == 0) {
+		atomic_dec(&my_hist->hist_mode);
+		seq_printf(m, "#Minimum latency: %lu microseconds.\n"
+			   "#Average latency: %lu microseconds.\n"
+			   "#Maximum latency: %lu microseconds.\n"
+			   "#Total samples: %llu\n"
+			   "#There are %llu samples greater or equal"
+			   " than %d microseconds\n"
+			   "#usecs\t%16s\n"
+			   , my_hist->min_lat
+			   , my_hist->avg_lat
+			   , my_hist->max_lat
+			   , my_hist->total_samples
+			   , my_hist->beyond_hist_bound_samples
+			   , MAX_ENTRY_NUM, "samples");
+	}
+	if (index >= MAX_ENTRY_NUM)
+		return NULL;
+
+	*index_ptr = index;
+	return index_ptr;
+}
+
+static void *l_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	loff_t *index_ptr = p;
+	struct hist_data *my_hist = m->private;
+
+	if (++*pos >= MAX_ENTRY_NUM) {
+		atomic_inc(&my_hist->hist_mode);
+		return NULL;
+	}
+	*index_ptr = *pos;
+	return index_ptr;
+}
+
+static void l_stop(struct seq_file *m, void *p)
+{
+	kfree(p);
+}
+
+static int l_show(struct seq_file *m, void *p)
+{
+	int index = *(loff_t *) p;
+	struct hist_data *my_hist = m->private;
+
+	seq_printf(m, "%5d\t%16llu\n", index, my_hist->hist_array[index]);
+	return 0;
+}
+
+static struct seq_operations latency_hist_seq_op = {
+	.start = l_start,
+	.next  = l_next,
+	.stop  = l_stop,
+	.show  = l_show
+};
+
+static int latency_hist_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = seq_open(file, &latency_hist_seq_op);
+	if (!ret) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static struct file_operations latency_hist_fops = {
+	.open = latency_hist_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static void hist_reset(struct hist_data *hist)
+{
+	atomic_dec(&hist->hist_mode);
+
+	memset(hist->hist_array, 0, sizeof(hist->hist_array));
+	hist->beyond_hist_bound_samples = 0UL;
+	hist->min_lat = 0xFFFFFFFFUL;
+	hist->max_lat = 0UL;
+	hist->total_samples = 0UL;
+	hist->accumulate_lat = 0UL;
+	hist->avg_lat = 0UL;
+
+	atomic_inc(&hist->hist_mode);
+}
+
+ssize_t latency_hist_reset(struct file *file, const char __user *a,
+			   size_t size, loff_t *off)
+{
+	int cpu;
+	struct hist_data *hist;
+	int latency_type = (long)file->private_data;
+
+	switch (latency_type) {
+
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+	case WAKEUP_LATENCY:
+		for_each_online_cpu(cpu) {
+			hist = &per_cpu(wakeup_latency_hist, cpu);
+			hist_reset(hist);
+		}
+		break;
+#endif
+
+#ifdef CONFIG_PREEMPT_OFF_HIST
+	case PREEMPT_LATENCY:
+		for_each_online_cpu(cpu) {
+			hist = &per_cpu(preempt_off_hist, cpu);
+			hist_reset(hist);
+		}
+		break;
+#endif
+
+#ifdef CONFIG_INTERRUPT_OFF_HIST
+	case INTERRUPT_LATENCY:
+		for_each_online_cpu(cpu) {
+			hist = &per_cpu(interrupt_off_hist, cpu);
+			hist_reset(hist);
+		}
+		break;
+#endif
+	}
+
+	return size;
+}
+
+static struct file_operations latency_hist_reset_fops = {
+	.open = tracing_open_generic,
+	.write = latency_hist_reset,
+};
+
+#if defined(CONFIG_INTERRUPT_OFF_HIST) || defined(CONFIG_PREEMPT_OFF_HIST)
+#ifdef CONFIG_INTERRUPT_OFF_HIST
+static DEFINE_PER_CPU(cycles_t, hist_irqsoff_start);
+static DEFINE_PER_CPU(int, hist_irqsoff_tracing);
+#endif
+#ifdef CONFIG_PREEMPT_OFF_HIST
+static DEFINE_PER_CPU(cycles_t, hist_preemptoff_start);
+static DEFINE_PER_CPU(int, hist_preemptoff_tracing);
+#endif
+#if defined(CONFIG_INTERRUPT_OFF_HIST) && defined(CONFIG_PREEMPT_OFF_HIST)
+static DEFINE_PER_CPU(cycles_t, hist_preemptirqsoff_start);
+static DEFINE_PER_CPU(int, hist_preemptirqsoff_tracing);
+#endif
+
+notrace void tracing_hist_preempt_start(void)
+{
+	cycle_t start;
+	int cpu;
+
+	start = now();
+	cpu = smp_processor_id();
+
+#ifdef CONFIG_INTERRUPT_OFF_HIST
+	if (!per_cpu(hist_irqsoff_tracing, cpu) &&
+	    irqs_disabled()) {
+		per_cpu(hist_irqsoff_tracing, cpu) = 1;
+		per_cpu(hist_irqsoff_start, cpu) = start;
+	}
+#endif
+
+#ifdef CONFIG_PREEMPT_OFF_HIST
+	if (!per_cpu(hist_preemptoff_tracing, cpu) &&
+	    preempt_count()) {
+		per_cpu(hist_preemptoff_tracing, cpu) = 1;
+		per_cpu(hist_preemptoff_start, cpu) = start;
+	}
+#endif
+
+#if defined(CONFIG_INTERRUPT_OFF_HIST) && defined(CONFIG_PREEMPT_OFF_HIST)
+	if (!per_cpu(hist_preemptirqsoff_tracing, cpu) &&
+	    (preempt_count() || irqs_disabled())) {
+		per_cpu(hist_preemptirqsoff_tracing, cpu) = 1;
+		per_cpu(hist_preemptirqsoff_start, cpu) = start;
+	}
+#endif
+}
+
+notrace void tracing_hist_preempt_stop(int irqs_on)
+{
+	long latency;
+	cycle_t start;
+	cycle_t stop;
+	int cpu;
+
+	stop = now();
+	cpu = smp_processor_id();
+
+	/* irqs_on == TRACE_STOP if we must stop tracing. */
+
+#ifdef CONFIG_INTERRUPT_OFF_HIST
+	if (per_cpu(hist_irqsoff_tracing, cpu) && irqs_on) {
+		per_cpu(hist_irqsoff_tracing, cpu) = 0;
+		start = per_cpu(hist_irqsoff_start, cpu);
+		latency = (long)cycles_to_usecs(stop - start);
+		latency_hist(INTERRUPT_LATENCY, smp_processor_id(), latency);
+	}
+#endif
+
+#ifdef CONFIG_PREEMPT_OFF_HIST
+	if (per_cpu(hist_preemptoff_tracing, cpu) &&
+	    (!preempt_count() || irqs_on == TRACE_STOP)) {
+		per_cpu(hist_preemptoff_tracing, cpu) = 0;
+		start = per_cpu(hist_preemptoff_start, cpu);
+		latency = (long)cycles_to_usecs(stop - start);
+		latency_hist(PREEMPT_LATENCY, smp_processor_id(), latency);
+	}
+#endif
+
+#if defined(CONFIG_INTERRUPT_OFF_HIST) && defined(CONFIG_PREEMPT_OFF_HIST)
+	if (per_cpu(hist_preemptirqsoff_tracing, cpu) &&
+	    ((!preempt_count() && irqs_on) || irqs_on == TRACE_STOP)) {
+		per_cpu(hist_preemptirqsoff_tracing, cpu) = 0;
+		start = per_cpu(hist_preemptirqsoff_start, cpu);
+		latency = (long)cycles_to_usecs(stop - start);
+		latency_hist(PREEMPT_INTERRUPT_LATENCY,
+			     smp_processor_id(), latency);
+	}
+#endif
+}
+#endif
+
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+int tracing_wakeup_hist __read_mostly = 1;
+
+static unsigned wakeup_prio = (unsigned)-1 ;
+static struct task_struct *wakeup_task;
+static cycle_t wakeup_start;
+static DEFINE_SPINLOCK(wakeup_lock);
+
+notrace void tracing_hist_wakeup_start(struct task_struct *p,
+				       struct task_struct *curr)
+{
+	unsigned long flags;
+
+	if (likely(!rt_task(p)) ||
+	    p->prio >= wakeup_prio ||
+	    p->prio >= curr->prio)
+		return;
+
+	spin_lock_irqsave(&wakeup_lock, flags);
+	if (wakeup_task)
+		put_task_struct(wakeup_task);
+
+	get_task_struct(p);
+	wakeup_task = p;
+	wakeup_prio = p->prio;
+	wakeup_start = now();
+	spin_unlock_irqrestore(&wakeup_lock, flags);
+}
+
+notrace void tracing_hist_wakeup_stop(struct task_struct *next)
+{
+	unsigned long flags;
+	long latency;
+	cycle_t stop;
+
+	if (next != wakeup_task)
+		return;
+
+	stop = now();
+
+	spin_lock_irqsave(&wakeup_lock, flags);
+	if (wakeup_task != next)
+		goto out;
+
+	latency = (long)cycles_to_usecs(stop - wakeup_start);
+
+	latency_hist(WAKEUP_LATENCY, smp_processor_id(), latency);
+
+	put_task_struct(wakeup_task);
+	wakeup_task = NULL;
+	wakeup_prio = (unsigned)-1;
+ out:
+	spin_unlock_irqrestore(&wakeup_lock, flags);
+
+}
+#endif
+
+static __init int latency_hist_init(void)
+{
+	struct dentry *latency_hist_root = NULL;
+	struct dentry *dentry;
+	struct dentry *entry;
+	int i = 0, len = 0;
+	struct hist_data *my_hist;
+	char name[64];
+
+	dentry = tracing_init_dentry();
+
+	latency_hist_root =
+		debugfs_create_dir(latency_hist_dir_root, dentry);
+
+#ifdef CONFIG_INTERRUPT_OFF_HIST
+	dentry = debugfs_create_dir(interrupt_off_hist_dir,
+				    latency_hist_root);
+	for_each_possible_cpu(i) {
+		len = sprintf(name, "CPU%d", i);
+		name[len] = '\0';
+		entry = debugfs_create_file(name, 0444, dentry,
+					    &per_cpu(interrupt_off_hist, i),
+					    &latency_hist_fops);
+		my_hist = &per_cpu(interrupt_off_hist, i);
+		atomic_set(&my_hist->hist_mode, 1);
+		my_hist->min_lat = 0xFFFFFFFFUL;
+	}
+	entry = debugfs_create_file("reset", 0444, dentry,
+				    (void *)INTERRUPT_LATENCY,
+				    &latency_hist_reset_fops);
+#endif
+
+#ifdef CONFIG_PREEMPT_OFF_HIST
+	dentry = debugfs_create_dir(preempt_off_hist_dir,
+				    latency_hist_root);
+	for_each_possible_cpu(i) {
+		len = sprintf(name, "CPU%d", i);
+		name[len] = '\0';
+		entry = debugfs_create_file(name, 0444, dentry,
+					    &per_cpu(preempt_off_hist, i),
+					    &latency_hist_fops);
+		my_hist = &per_cpu(preempt_off_hist, i);
+		atomic_set(&my_hist->hist_mode, 1);
+		my_hist->min_lat = 0xFFFFFFFFUL;
+	}
+	entry = debugfs_create_file("reset", 0444, dentry,
+				    (void *)PREEMPT_LATENCY,
+				    &latency_hist_reset_fops);
+#endif
+
+#if defined(CONFIG_INTERRUPT_OFF_HIST) && defined(CONFIG_PREEMPT_OFF_HIST)
+	dentry = debugfs_create_dir(preempt_irqs_off_hist_dir,
+				    latency_hist_root);
+	for_each_possible_cpu(i) {
+		len = sprintf(name, "CPU%d", i);
+		name[len] = '\0';
+		entry = debugfs_create_file(name, 0444, dentry,
+					    &per_cpu(preempt_off_hist, i),
+					    &latency_hist_fops);
+		my_hist = &per_cpu(preempt_irqs_off_hist, i);
+		atomic_set(&my_hist->hist_mode, 1);
+		my_hist->min_lat = 0xFFFFFFFFUL;
+	}
+	entry = debugfs_create_file("reset", 0444, dentry,
+				    (void *)PREEMPT_INTERRUPT_LATENCY,
+				    &latency_hist_reset_fops);
+#endif
+
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+	dentry = debugfs_create_dir(wakeup_latency_hist_dir,
+				    latency_hist_root);
+	for_each_possible_cpu(i) {
+		len = sprintf(name, "CPU%d", i);
+		name[len] = '\0';
+		entry = debugfs_create_file(name, 0444, dentry,
+					    &per_cpu(wakeup_latency_hist, i),
+					    &latency_hist_fops);
+		my_hist = &per_cpu(wakeup_latency_hist, i);
+		atomic_set(&my_hist->hist_mode, 1);
+		my_hist->min_lat = 0xFFFFFFFFUL;
+	}
+	entry = debugfs_create_file("reset", 0444, dentry,
+				    (void *)WAKEUP_LATENCY,
+				    &latency_hist_reset_fops);
+#endif
+	return 0;
+
+}
+
+__initcall(latency_hist_init);
Index: linux-mcount.git/lib/tracing/tracer_hist.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/tracer_hist.h	2008-01-29 21:34:30.000000000 -0500
@@ -0,0 +1,39 @@
+/*
+ * lib/tracing/tracer_hist.h
+ *
+ * Add support for histograms of preemption-off latency and
+ * interrupt-off latency and wakeup latency, it depends on
+ * Real-Time Preemption Support.
+ *
+ *  Copyright (C) 2005 MontaVista Software, Inc.
+ *  Yi Yang <yyang@ch.mvista.com>
+ *
+ *  Converted to work with the new latency tracer.
+ *  Copyright (C) 2008 Red Hat, Inc.
+ *    Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#ifndef _LIB_TRACING_TRACER_HIST_H_
+#define _LIB_TRACING_TRACER_HIST_H_
+
+#if defined(CONFIG_INTERRUPT_OFF_HIST) || defined(CONFIG_PREEMPT_OFF_HIST)
+# define TRACE_STOP 2
+void tracing_hist_preempt_start(void);
+void tracing_hist_preempt_stop(int irqs_on);
+#else
+# define tracing_hist_preempt_start() do { } while (0)
+# define tracing_hist_preempt_stop(irqs_off) do { } while (0)
+#endif
+
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+void tracing_hist_wakeup_start(struct task_struct *p,
+			       struct task_struct *curr);
+void tracing_hist_wakeup_stop(struct task_struct *next);
+extern int tracing_wakeup_hist;
+#else
+# define tracing_hist_wakeup_start(p, curr) do { } while (0)
+# define tracing_hist_wakeup_stop(next) do { } while (0)
+# define tracing_wakeup_hist 0
+#endif
+
+#endif /* ifndef _LIB_TRACING_TRACER_HIST_H_ */

-- 
