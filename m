Return-Path: <linux-kernel-owner+w=401wt.eu-S1765900AbYA3VOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765900AbYA3VOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbYA3VGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:06:14 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:39726 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbYA3VFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:39 -0500
Message-Id: <20080130210528.314923056@goodmis.org>
References: <20080130210357.927754294@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 16:04:19 -0500
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
Subject: [PATCH 22/23 -v8] Add event tracer.
Content-Disposition: inline; filename=tracer-event-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a event trace that hooks into various events
in the kernel. Although it can be used separately, it is mainly
to help other traces (wakeup and preempt off) with seeing various
events in the traces without having to enable the heavy mcount
hooks.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/Kconfig         |   12 +
 lib/tracing/Makefile        |    1 
 lib/tracing/trace_events.c  |  478 ++++++++++++++++++++++++++++++++++++++++++++
 lib/tracing/trace_irqsoff.c |    6 
 lib/tracing/trace_wakeup.c  |   55 ++++-
 lib/tracing/tracer.c        |  159 ++++++++++----
 lib/tracing/tracer.h        |   64 +++++
 7 files changed, 724 insertions(+), 51 deletions(-)

Index: linux-mcount.git/lib/tracing/trace_events.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/trace_events.c	2008-01-30 15:55:32.000000000 -0500
@@ -0,0 +1,478 @@
+/*
+ * trace task events
+ *
+ * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
+ *
+ * Based on code from the latency_tracer, that is:
+ *
+ *  Copyright (C) 2004-2006 Ingo Molnar
+ *  Copyright (C) 2004 William Lee Irwin III
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/kallsyms.h>
+#include <linux/uaccess.h>
+#include <linux/mcount.h>
+
+#include "tracer.h"
+
+static struct tracing_trace *tracer_trace __read_mostly;
+static int trace_enabled __read_mostly;
+
+static void notrace event_reset(struct tracing_trace *tr)
+{
+	struct tracing_trace_cpu *data;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		data = tr->data[cpu];
+		tracing_reset(data);
+	}
+
+	tr->time_start = now();
+}
+
+static void notrace event_trace_sched_switch(void *private,
+					     struct task_struct *prev,
+					     struct task_struct *next)
+{
+	struct tracing_trace **ptr = private;
+	struct tracing_trace *tr = *ptr;
+	struct tracing_trace_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+
+	if (!trace_enabled || !tr)
+		return;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	disabled = atomic_inc_return(&data->disabled);
+	if (unlikely(disabled != 1))
+		goto out;
+
+	tracing_sched_switch_trace(tr, data, prev, next, flags);
+
+ out:
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
+static struct tracer_switch_ops switch_ops __read_mostly = {
+	.func = event_trace_sched_switch,
+	.private = &tracer_trace,
+};
+
+notrace int trace_event_enabled(void)
+{
+	return trace_enabled && tracer_trace;
+}
+
+/* Taken from sched.c */
+#define __PRIO(prio) \
+	((prio) <= 99 ? 199 - (prio) : (prio) - 120)
+
+#define PRIO(p) __PRIO((p)->prio)
+
+notrace void trace_event_wakeup(unsigned long ip,
+				struct task_struct *p,
+				struct task_struct *curr)
+{
+	struct tracing_trace *tr = tracer_trace;
+	struct tracing_trace_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+
+	if (!trace_enabled || !tr)
+		return;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	disabled = atomic_inc_return(&data->disabled);
+	if (unlikely(disabled != 1))
+		goto out;
+
+	/* record process's command line */
+	tracing_record_cmdline(p);
+	tracing_record_cmdline(curr);
+	tracing_trace_pid(tr, data, flags, ip, p->pid, PRIO(p), PRIO(curr));
+
+ out:
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
+struct event_probes {
+	const char *name;
+	const char *fmt;
+	void (*func)(const struct event_probes *probe,
+		     struct tracing_trace *tr,
+		     struct tracing_trace_cpu *data,
+		     unsigned long flags,
+		     unsigned long ip,
+		     va_list ap);
+	int active;
+	int armed;
+};
+
+#define getarg(arg, ap) arg = va_arg(ap, typeof(arg))
+
+static notrace void event_trace_apic_timer(const struct event_probes *probe,
+					   struct tracing_trace *tr,
+					   struct tracing_trace_cpu *data,
+					   unsigned long flags,
+					   unsigned long ip,
+					   va_list ap)
+{
+	unsigned long parent_ip;
+
+	getarg(parent_ip, ap);
+
+	tracing_trace_special(tr, data, flags, ip, parent_ip, 0, 0);
+}
+
+static notrace void event_trace_do_irq(const struct event_probes *probe,
+				       struct tracing_trace *tr,
+				       struct tracing_trace_cpu *data,
+				       unsigned long flags,
+				       unsigned long ip,
+				       va_list ap)
+{
+	unsigned long parent_ip;
+	int irq;
+
+	getarg(parent_ip, ap);
+	getarg(irq, ap);
+
+	tracing_trace_special(tr, data, flags, ip, parent_ip, irq, 0);
+}
+
+static notrace void event_trace_do_page_fault(const struct event_probes *probe,
+					      struct tracing_trace *tr,
+					      struct tracing_trace_cpu *data,
+					      unsigned long flags,
+					      unsigned long ip,
+					      va_list ap)
+{
+	unsigned long parent_ip;
+	unsigned long err;
+	unsigned long addr;
+
+	getarg(parent_ip, ap);
+	getarg(err, ap);
+	getarg(addr, ap);
+
+	tracing_trace_special(tr, data, flags, ip, parent_ip, err, addr);
+}
+
+static notrace void event_trace_hrtimer_timer(const struct event_probes *probe,
+					      struct tracing_trace *tr,
+					      struct tracing_trace_cpu *data,
+					      unsigned long flags,
+					      unsigned long ip,
+					      va_list ap)
+{
+	ktime_t *expires;
+	unsigned long timer;
+
+	getarg(expires, ap);
+	getarg(timer, ap);
+
+	tracing_trace_timer(tr, data, flags, ip, ktime_to_ns(*expires), timer);
+}
+
+static notrace void event_trace_hrtimer_time(const struct event_probes *probe,
+					     struct tracing_trace *tr,
+					     struct tracing_trace_cpu *data,
+					     unsigned long flags,
+					     unsigned long ip,
+					     va_list ap)
+{
+	ktime_t *now;
+
+	getarg(now, ap);
+
+	tracing_trace_timer(tr, data, flags, ip, ktime_to_ns(*now), 0);
+}
+
+static notrace void event_trace_sched3(const struct event_probes *probe,
+				       struct tracing_trace *tr,
+				       struct tracing_trace_cpu *data,
+				       unsigned long flags,
+				       unsigned long ip,
+				       va_list ap)
+{
+	int pid;
+	int prio;
+	int running;
+
+	getarg(pid, ap);
+	getarg(prio, ap);
+	getarg(running, ap);
+
+	tracing_trace_pid(tr, data, flags, ip, pid, prio, running);
+}
+
+#ifndef CONFIG_WAKEUP_TRACER
+static notrace event_trace_sched_wakeup(const struct event_probes *probe,
+					struct tracing_trace *tr,
+					struct tracing_trace_cpu *data,
+					unsigned long flags,
+					unsigned long ip,
+					va_list ap)
+{
+	struct task_struct *p;
+	struct task_struct *curr;
+
+	getarg(p, ap);
+	getarg(curr, ap);
+
+	tracing_record_cmdline(p);
+	tracing_record_cmdline(curr);
+	tracing_trace_pid(tr, data, flags, ip, p->pid, PRIO(p), PRIO(curr));
+}
+#endif
+
+static struct event_probes event_probes[] __read_mostly = {
+	{
+		.name = "arch_apic_timer",
+		.fmt = "ip %lx",
+		.func = event_trace_apic_timer,
+	},
+	{
+		.name = "arch_do_irq",
+		.fmt = "ip %lx irq %d",
+		.func = event_trace_do_irq,
+	},
+	{
+		.name = "arch_do_page_fault",
+		.fmt = "ip %lx err %lx addr %lx",
+		.func = event_trace_do_page_fault,
+	},
+	{
+		.name = "kernel_hrtimer_enqueue",
+		.fmt = "expires %p timer %p",
+		.func = event_trace_hrtimer_timer,
+	},
+	{
+		.name = "kernel_hrtimer_interrupt",
+		.fmt = "now %p",
+		.func = event_trace_hrtimer_time,
+	},
+	{
+		.name = "kernel_hrtimer_interrupt_expire",
+		.fmt = "expires %p timer %p",
+		.func = event_trace_hrtimer_timer,
+	},
+	{
+		.name = "kernel_sched_activate_task",
+		.fmt = "pid %d prio %d nr_running %ld",
+		.func = event_trace_sched3,
+	},
+	{
+		.name = "kernel_sched_deactivate_task",
+		.fmt = "pid %d prio %d nr_running %ld",
+		.func = event_trace_sched3,
+	},
+#ifndef CONFIG_WAKEUP_TRACER
+	{
+		.name = "kernel_sched_wakeup",
+		.fmt = "p %p rq->curr %p",
+		.func = event_trace_sched_wakeup,
+	},
+#endif
+	{
+		.name = NULL,
+	}
+};
+
+static notrace void event_trace_callback(const struct marker *mdata,
+					 void *private_data,
+					 const char *format, ...)
+{
+	struct event_probes *probe = mdata->private;
+	struct tracing_trace *tr = tracer_trace;
+	struct tracing_trace_cpu *data;
+	unsigned long flags;
+	unsigned long ip;
+	long disabled;
+	int cpu;
+	va_list ap;
+
+	if (!trace_enabled || !tracer_trace)
+		return;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	disabled = atomic_inc_return(&data->disabled);
+	if (unlikely(disabled != 1))
+		goto out;
+
+	ip = CALLER_ADDR0;
+
+	va_start(ap, format);
+	probe->func(probe, tr, data, flags, ip, ap);
+	va_end(ap);
+
+ out:
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
+static notrace void event_trace_arm(void)
+{
+	struct event_probes *probe;
+	int ret;
+
+	for (probe = event_probes; probe->name; probe++) {
+		if (!probe->active || probe->armed)
+			continue;
+
+		ret = marker_arm(probe->name);
+		if (ret)
+			pr_info("event trace: Couldn't arm probe %s\n",
+				probe->name);
+		else
+			probe->armed = 1;
+	}
+
+	tracing_start_wakeup();
+}
+
+static notrace void event_trace_disarm(void)
+{
+	struct event_probes *probe;
+
+	tracing_stop_wakeup();
+
+	for (probe = event_probes; probe->name; probe++) {
+		if (!probe->active || !probe->armed)
+			continue;
+
+		marker_disarm(probe->name);
+		probe->armed = 0;
+	}
+}
+
+static notrace void start_event_trace(struct tracing_trace *tr)
+{
+	event_trace_arm();
+
+	event_reset(tr);
+	trace_enabled = 1;
+
+	register_tracer_switch(&switch_ops);
+	tracing_start_sched_switch();
+	tracing_start_function_trace();
+}
+
+static notrace void stop_event_trace(struct tracing_trace *tr)
+{
+	tracing_stop_function_trace();
+	trace_enabled = 0;
+	unregister_tracer_switch(&switch_ops);
+	tracing_stop_sched_switch();
+	event_trace_disarm();
+}
+
+static notrace void event_trace_init(struct tracing_trace *tr)
+{
+	tracer_trace = tr;
+
+	if (tr->ctrl)
+		start_event_trace(tr);
+}
+
+static notrace void event_trace_reset(struct tracing_trace *tr)
+{
+	if (tr->ctrl)
+		stop_event_trace(tr);
+}
+
+static void event_trace_ctrl_update(struct tracing_trace *tr)
+{
+	if (tr->ctrl)
+		start_event_trace(tr);
+	else
+		stop_event_trace(tr);
+}
+
+static void notrace event_trace_open(struct tracing_iterator *iter)
+{
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl)
+		stop_event_trace(iter->tr);
+}
+
+static void notrace event_trace_close(struct tracing_iterator *iter)
+{
+	if (iter->tr->ctrl)
+		start_event_trace(iter->tr);
+}
+
+static struct trace_types_struct event_trace __read_mostly =
+{
+	.name = "events",
+	.init = event_trace_init,
+	.reset = event_trace_reset,
+	.open = event_trace_open,
+	.close = event_trace_close,
+	.ctrl_update = event_trace_ctrl_update,
+};
+
+notrace void trace_event_register(struct tracing_trace *tr)
+{
+	tracer_trace = tr;
+	event_trace_arm();
+}
+
+notrace void trace_event_unregister(struct tracing_trace *tr)
+{
+	event_trace_disarm();
+}
+
+notrace void trace_start_events(void)
+{
+	trace_enabled = 1;
+}
+
+notrace void trace_stop_events(void)
+{
+	trace_enabled = 0;
+}
+
+__init static int init_event_trace(void)
+{
+	struct event_probes *probe;
+	int ret;
+
+	ret = register_trace(&event_trace);
+	if (ret)
+		return ret;
+
+	for (probe = event_probes; probe->name; probe++) {
+
+		ret = marker_probe_register(probe->name,
+					    probe->fmt,
+					    event_trace_callback,
+					    probe);
+		if (ret)
+			pr_info("event trace: Couldn't add marker"
+				" probe to %s\n", probe->name);
+		else
+			probe->active = 1;
+	}
+
+	return 0;
+}
+
+device_initcall(init_event_trace);
Index: linux-mcount.git/lib/tracing/Kconfig
===================================================================
--- linux-mcount.git.orig/lib/tracing/Kconfig	2008-01-30 15:46:44.000000000 -0500
+++ linux-mcount.git/lib/tracing/Kconfig	2008-01-30 15:55:33.000000000 -0500
@@ -28,6 +28,18 @@ config FUNCTION_TRACER
 	  that the debugging mechanism using this facility will hook by
 	  providing a set of inline routines.
 
+config EVENT_TRACER
+	bool "trace kernel events"
+	depends on DEBUG_KERNEL
+	select TRACING
+	select CONTEXT_SWITCH_TRACER
+	select MARKERS
+	help
+	  This option activates the event tracer of the latency_tracer.
+	  It activates markers through out the kernel for tracing.
+	  This option has a fairly low overhead when enabled.
+
+
 config CRITICAL_IRQSOFF_TIMING
 	bool "Interrupts-off critical section latency timing"
 	default n
Index: linux-mcount.git/lib/tracing/Makefile
===================================================================
--- linux-mcount.git.orig/lib/tracing/Makefile	2008-01-30 15:46:44.000000000 -0500
+++ linux-mcount.git/lib/tracing/Makefile	2008-01-30 15:55:33.000000000 -0500
@@ -6,5 +6,6 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace_f
 obj-$(CONFIG_CRITICAL_IRQSOFF_TIMING) += trace_irqsoff.o
 obj-$(CONFIG_CRITICAL_PREEMPT_TIMING) += trace_irqsoff.o
 obj-$(CONFIG_WAKEUP_TRACER) += trace_wakeup.o
+obj-$(CONFIG_EVENT_TRACER) += trace_events.o
 
 libmcount-y := mcount.o
Index: linux-mcount.git/lib/tracing/trace_wakeup.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_wakeup.c	2008-01-30 15:38:44.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_wakeup.c	2008-01-30 15:55:33.000000000 -0500
@@ -23,6 +23,7 @@ static int trace_enabled __read_mostly;
 static struct task_struct *wakeup_task;
 static int wakeup_cpu;
 static unsigned wakeup_prio = -1;
+static atomic_t wakeup_ref;
 
 static DEFINE_SPINLOCK(wakeup_lock);
 
@@ -225,7 +226,7 @@ static notrace void wake_up_callback(con
 	struct task_struct *p;
 	va_list ap;
 
-	if (likely(!trace_enabled))
+	if (likely(!trace_enabled) && !trace_event_enabled())
 		return;
 
 	va_start(ap, format);
@@ -236,18 +237,26 @@ static notrace void wake_up_callback(con
 
 	va_end(ap);
 
-	wakeup_check_start(tr, p, curr);
+	trace_event_wakeup(CALLER_ADDR0, p, curr);
+
+	if (trace_enabled)
+		wakeup_check_start(tr, p, curr);
 }
 
-static notrace void start_wakeup_trace(struct tracing_trace *tr)
+notrace int tracing_start_wakeup(void)
 {
+	long ref;
 	int ret;
 
+	ref = atomic_inc_return(&wakeup_ref);
+	if (ref != 1)
+		return 0;
+
 	ret = marker_arm("kernel_sched_wakeup");
 	if (ret) {
 		pr_info("wakeup trace: Couldn't arm probe"
 			" kernel_sched_wakeup\n");
-		return;
+		return -1;
 	}
 
 	ret = marker_arm("kernel_sched_wakeup_new");
@@ -257,8 +266,35 @@ static notrace void start_wakeup_trace(s
 		goto out;
 	}
 
+	return 0;
+
+ out:
+	marker_disarm("kernel_sched_wakeup");
+	return -1;
+}
+
+notrace void tracing_stop_wakeup(void)
+{
+	long ref;
+
+	ref = atomic_dec_and_test(&wakeup_ref);
+	if (ref) {
+		marker_disarm("kernel_sched_wakeup");
+		marker_disarm("kernel_sched_wakeup_new");
+	}
+}
+
+static notrace void start_wakeup_trace(struct tracing_trace *tr)
+{
+	int ret;
+
+	ret = tracing_start_wakeup();
+	if (ret)
+		return;
+
 	register_tracer_switch(&switch_ops);
 	tracing_start_sched_switch();
+	trace_start_events();
 
 	wakeup_reset(tr);
 
@@ -274,32 +310,33 @@ static notrace void start_wakeup_trace(s
 	trace_enabled = 1;
 
 	return;
-
- out:
-	marker_disarm("kernel_sched_wakeup");
 }
 
 static notrace void stop_wakeup_trace(struct tracing_trace *tr)
 {
 	trace_enabled = 0;
+	tracing_stop_wakeup();
 	tracing_stop_sched_switch();
 	unregister_tracer_switch(&switch_ops);
-	marker_disarm("kernel_sched_wakeup");
-	marker_disarm("kernel_sched_wakeup_new");
 }
 
 static notrace void wakeup_trace_init(struct tracing_trace *tr)
 {
 	tracer_trace = tr;
 
+	trace_event_register(tr);
+
 	if (tr->ctrl)
 		start_wakeup_trace(tr);
 }
 
 static notrace void wakeup_trace_reset(struct tracing_trace *tr)
 {
+	trace_event_unregister(tr);
+
 	if (tr->ctrl) {
 		stop_wakeup_trace(tr);
+		trace_stop_events();
 		/* make sure we put back any tasks we are tracing */
 		wakeup_reset(tr);
 	}
Index: linux-mcount.git/lib/tracing/tracer.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/tracer.c	2008-01-30 15:39:30.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.c	2008-01-30 15:55:33.000000000 -0500
@@ -58,6 +58,9 @@ enum trace_type {
 
 	TRACE_FN,
 	TRACE_CTX,
+	TRACE_PID,
+	TRACE_SPECIAL,
+	TRACE_TMR,
 
 	__TRACE_LAST_TYPE
 };
@@ -402,6 +405,61 @@ notrace void tracing_sched_switch_trace(
 	entry->ctx.next_prio	= next->prio;
 }
 
+void tracing_trace_pid(struct tracing_trace *tr,
+		       struct tracing_trace_cpu *data,
+		       unsigned long flags,
+		       unsigned long ip,
+		       unsigned long pid,
+		       unsigned long a,
+		       unsigned long b)
+{
+	struct tracing_entry *entry;
+
+	entry = tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, flags);
+	entry->type		= TRACE_PID;
+	entry->id.ip		= ip;
+	entry->id.pid		= pid;
+	entry->id.a		= a;
+	entry->id.b		= b;
+}
+
+void tracing_trace_special(struct tracing_trace *tr,
+			   struct tracing_trace_cpu *data,
+			   unsigned long flags,
+			   unsigned long ip,
+			   unsigned long parent_ip,
+			   unsigned long a,
+			   unsigned long b)
+{
+	struct tracing_entry *entry;
+
+	entry = tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, flags);
+	entry->type			= TRACE_SPECIAL;
+	entry->special.ip		= ip;
+	entry->special.parent_ip	= parent_ip;
+	entry->special.a		= a;
+	entry->special.b		= b;
+}
+
+void tracing_trace_timer(struct tracing_trace *tr,
+			 struct tracing_trace_cpu *data,
+			 unsigned long flags,
+			 unsigned long ip,
+			 unsigned long long time,
+			 unsigned long a)
+{
+	struct tracing_entry *entry;
+
+	entry = tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, flags);
+	entry->type			= TRACE_TMR;
+	entry->tmr.ip		= ip;
+	entry->tmr.time		= time;
+	entry->tmr.a		= a;
+}
+
 enum trace_iterator {
 	TRACE_ITER_SYM_ONLY	= 1,
 	TRACE_ITER_VERBOSE	= 2,
@@ -730,6 +788,62 @@ lat_print_timestamp(struct seq_file *m, 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
 static void notrace
+print_generic_output(struct seq_file *m,
+		     struct tracing_entry *entry, int sym_only)
+{
+	char *comm;
+	int S;
+
+	switch (entry->type) {
+	case TRACE_FN:
+		seq_print_ip_sym(m, entry->fn.ip, sym_only);
+		seq_puts(m, " (");
+		seq_print_ip_sym(m, entry->fn.parent_ip, sym_only);
+		seq_puts(m, ")");
+		break;
+	case TRACE_CTX:
+		S = entry->ctx.prev_state < sizeof(state_to_char) ?
+			state_to_char[entry->ctx.prev_state] : 'X';
+		comm = trace_find_cmdline(entry->ctx.next_pid);
+		seq_printf(m, " %d:%d:%c --> %d:%d %s",
+			   entry->ctx.prev_pid,
+			   entry->ctx.prev_prio,
+			   S,
+			   entry->ctx.next_pid,
+			   entry->ctx.next_prio,
+			   comm);
+		break;
+	case TRACE_PID:
+		seq_print_ip_sym(m, entry->id.ip, sym_only);
+		seq_printf(m, " <%.8s-%ld> (%ld %ld)",
+			   trace_find_cmdline(entry->id.pid),
+			   entry->id.pid,
+			   entry->id.a, entry->id.b);
+		break;
+	case TRACE_SPECIAL:
+		seq_print_ip_sym(m, entry->special.ip, sym_only);
+		seq_putc(m, ' ');
+		seq_print_ip_sym(m, entry->special.parent_ip, 0);
+		/* For convenience, print small numbers in decimal */
+		if (abs((int)entry->special.a) < 100000)
+			seq_printf(m, "(%ld ", entry->special.a);
+		else
+			seq_printf(m, "(%lx ", entry->special.a);
+		if (abs((int)entry->special.b) < 100000)
+			seq_printf(m, "%ld)", entry->special.b);
+		else
+			seq_printf(m, "%lx)", entry->special.b);
+		break;
+	case TRACE_TMR:
+		seq_print_ip_sym(m, entry->tmr.ip, sym_only);
+		seq_printf(m, "(%13Lx %lx)",
+			   entry->tmr.time,
+			   entry->tmr.a);
+		break;
+	}
+}
+
+static void notrace
 print_lat_fmt(struct seq_file *m, struct tracing_iterator *iter,
 	      unsigned int trace_idx, int cpu)
 {
@@ -740,7 +854,6 @@ print_lat_fmt(struct seq_file *m, struct
 	char *comm;
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	int verbose = !!(trace_flags & TRACE_ITER_VERBOSE);
-	int S;
 
 	if (!next_entry)
 		next_entry = entry;
@@ -761,26 +874,8 @@ print_lat_fmt(struct seq_file *m, struct
 		lat_print_generic(m, entry, cpu);
 		lat_print_timestamp(m, abs_usecs, rel_usecs);
 	}
-	switch (entry->type) {
-	case TRACE_FN:
-		seq_print_ip_sym(m, entry->fn.ip, sym_only);
-		seq_puts(m, " (");
-		seq_print_ip_sym(m, entry->fn.parent_ip, sym_only);
-		seq_puts(m, ")\n");
-		break;
-	case TRACE_CTX:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		comm = trace_find_cmdline(entry->ctx.next_pid);
-		seq_printf(m, " %d:%d:%c --> %d:%d %s\n",
-			   entry->ctx.prev_pid,
-			   entry->ctx.prev_prio,
-			   S,
-			   entry->ctx.next_pid,
-			   entry->ctx.next_prio,
-			   comm);
-		break;
-	}
+	print_generic_output(m, entry, sym_only);
+	seq_putc(m, '\n');
 }
 
 static void notrace print_trace_fmt(struct seq_file *m,
@@ -792,7 +887,6 @@ static void notrace print_trace_fmt(stru
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	unsigned long long t;
 	char *comm;
-	int S;
 
 	comm = trace_find_cmdline(iter->ent->pid);
 
@@ -804,26 +898,7 @@ static void notrace print_trace_fmt(stru
 	seq_printf(m, "CPU %d: ", iter->cpu);
 	seq_printf(m, "%s:%d ", comm,
 		   entry->pid);
-	switch (entry->type) {
-	case TRACE_FN:
-		seq_print_ip_sym(m, entry->fn.ip, sym_only);
-		if (entry->fn.parent_ip) {
-			seq_printf(m, " <-- ");
-			seq_print_ip_sym(m, entry->fn.parent_ip,
-					 sym_only);
-		}
-		break;
-	case TRACE_CTX:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		seq_printf(m, " %d:%d:%c ==> %d:%d\n",
-			   entry->ctx.prev_pid,
-			   entry->ctx.prev_prio,
-			   S,
-			   entry->ctx.next_pid,
-			   entry->ctx.next_prio);
-		break;
-	}
+	print_generic_output(m, entry, sym_only);
 	seq_printf(m, "\n");
 }
 
Index: linux-mcount.git/lib/tracing/tracer.h
===================================================================
--- linux-mcount.git.orig/lib/tracing/tracer.h	2008-01-30 15:39:30.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.h	2008-01-30 15:55:33.000000000 -0500
@@ -18,6 +18,27 @@ struct tracing_sched_switch {
 	unsigned char next_prio;
 };
 
+struct tracing_pid {
+	unsigned long ip;
+	unsigned long pid;
+	unsigned long a;
+	unsigned long b;
+};
+
+struct tracing_special {
+	unsigned long ip;
+	unsigned long parent_ip;
+	unsigned long pid;
+	unsigned long a;
+	unsigned long b;
+};
+
+struct tracing_timer {
+	unsigned long ip;
+	unsigned long long time;
+	unsigned long a;
+};
+
 struct tracing_entry {
 	char type;
 	char cpu;  /* who will want to trace more than 256 CPUS? */
@@ -28,6 +49,9 @@ struct tracing_entry {
 	union {
 		struct tracing_function fn;
 		struct tracing_sched_switch ctx;
+		struct tracing_pid id;
+		struct tracing_special special;
+		struct tracing_timer tmr;
 	};
 };
 
@@ -99,6 +123,26 @@ void tracing_sched_switch_trace(struct t
 				struct task_struct *next,
 				unsigned long flags);
 void tracing_record_cmdline(struct task_struct *tsk);
+void tracing_trace_pid(struct tracing_trace *tr,
+		       struct tracing_trace_cpu *data,
+		       unsigned long flags,
+		       unsigned long ip,
+		       unsigned long pid,
+		       unsigned long a,
+		       unsigned long b);
+void tracing_trace_special(struct tracing_trace *tr,
+			   struct tracing_trace_cpu *data,
+			   unsigned long flags,
+			   unsigned long ip,
+			   unsigned long parent_ip,
+			   unsigned long a,
+			   unsigned long b);
+void tracing_trace_timer(struct tracing_trace *tr,
+			 struct tracing_trace_cpu *data,
+			 unsigned long flags,
+			 unsigned long ip,
+			 unsigned long long time,
+			 unsigned long a);
 
 void tracing_start_function_trace(void);
 void tracing_stop_function_trace(void);
@@ -106,6 +150,8 @@ int register_trace(struct trace_types_st
 void unregister_trace(struct trace_types_struct *type);
 void tracing_start_sched_switch(void);
 void tracing_stop_sched_switch(void);
+int tracing_start_wakeup(void);
+void tracing_stop_wakeup(void);
 
 extern int tracing_sched_switch_enabled;
 extern unsigned long tracing_max_latency;
@@ -134,4 +180,22 @@ extern int register_tracer_switch(struct
 extern int unregister_tracer_switch(struct tracer_switch_ops *ops);
 #endif /* CONFIG_CONTEXT_SWITCH_TRACER */
 
+#ifdef CONFIG_EVENT_TRACER
+extern int trace_event_enabled(void);
+extern void trace_event_wakeup(unsigned long ip,
+			       struct task_struct *p,
+			       struct task_struct *curr);
+extern void trace_event_register(struct tracing_trace *tr);
+extern void trace_event_unregister(struct tracing_trace *tr);
+extern void trace_start_events(void);
+extern void trace_stop_events(void);
+#else
+# define trace_event_enabled() 0
+# define trace_event_wakeup(ip, p, curr) do { } while (0)
+# define trace_event_register(tr) do { } while (0)
+# define trace_event_unregister(tr) do { } while (0)
+# define trace_start_events() do { } while (0)
+# define trace_stop_events() do { } while (0)
+#endif
+
 #endif /* _LINUX_MCOUNT_TRACER_H */
Index: linux-mcount.git/lib/tracing/trace_irqsoff.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_irqsoff.c	2008-01-30 15:46:44.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_irqsoff.c	2008-01-30 15:55:33.000000000 -0500
@@ -217,6 +217,7 @@ start_critical_timing(unsigned long ip, 
 	local_save_flags(flags);
 
 	tracing_function_trace(tr, data, ip, parent_ip, flags);
+	trace_start_events();
 
 	__get_cpu_var(tracing_cpu) = 1;
 
@@ -249,6 +250,7 @@ stop_critical_timing(unsigned long ip, u
 
 	atomic_inc(&data->disabled);
 	local_save_flags(flags);
+	trace_stop_events();
 	tracing_function_trace(tr, data, ip, parent_ip, flags);
 	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
@@ -372,12 +374,16 @@ static void __irqsoff_trace_init(struct 
 	/* make sure that the tracer is visibel */
 	smp_wmb();
 
+	trace_event_register(tr);
+
 	if (tr->ctrl)
 		start_irqsoff_trace(tr);
 }
 
 static void irqsoff_trace_reset(struct tracing_trace *tr)
 {
+	trace_event_unregister(tr);
+
 	if (tr->ctrl)
 		stop_irqsoff_trace(tr);
 }

-- 
