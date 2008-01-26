Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbYAZEe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbYAZEe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 23:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYAZE2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 23:28:49 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:37731 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbYAZE2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 23:28:23 -0500
Message-Id: <20080126042804.657038019@goodmis.org>
References: <20080126042152.526086719@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jan 2008 23:22:14 -0500
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
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 22/23 -v6] Add event tracer.
Content-Disposition: inline; filename=tracer-event-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a event trace that hooks into various events
in the kernel. Although it can be used separately, it is mainly
to help other traces (wakeup and preempt off) with seeing various
events in the traces without having to enable the heavy mcount
hooks.

Here's an example:


                 _------=> CPU#            
                / _-----=> irqs-off        
               | / _----=> need-resched    
               || / _---=> hardirq/softirq 
               ||| / _--=> preempt-depth   
               |||| /                      
               |||||     delay             
   cmd     pid ||||| time  |   caller      
      \   /    |||||   \   |   /           
    bash-2857  1d..3  180us : try_to_wake_up+0xdc/0x172 <sshd-2849> (0 0)
    bash-2857  1d..3  181us+: activate_task+0x7d/0xb9 <sshd-2849> (0 2)
    bash-2857  1d..2  192us!: enqueue_hrtimer+0x55/0x156(    a4bf49c2e ffff81000
10b3ce8)
    bash-2857  1d..3  331us+: deactivate_task+0x7c/0xa8 <bash-2857> (0 3)
    bash-2857  1d..3  334us+:  2857:120:S --> 2849:120
    sshd-2849  1d..3  338us+: enqueue_hrtimer+0x55/0x156(    a4c2a94a7 ffff81000
10b3ce8)
    sshd-2849  1d..3  370us : try_to_wake_up+0xdc/0x172 <bash-2857> (0 0)
    sshd-2849  1d..3  370us+: activate_task+0x7d/0xb9 <bash-2857> (0 2)
    sshd-2849  1d..2  380us+: enqueue_hrtimer+0x55/0x156(    a4c0cae6f ffff81000
10b3ce8)


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/Kconfig         |   12 +
 lib/tracing/Makefile        |    1 
 lib/tracing/trace_events.c  |  472 ++++++++++++++++++++++++++++++++++++++++++++
 lib/tracing/trace_irqsoff.c |    6 
 lib/tracing/trace_wakeup.c  |   13 +
 lib/tracing/tracer.c        |  154 ++++++++++----
 lib/tracing/tracer.h        |   62 +++++
 7 files changed, 678 insertions(+), 42 deletions(-)

Index: linux-mcount.git/lib/tracing/trace_events.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/trace_events.c	2008-01-25 21:47:40.000000000 -0500
@@ -0,0 +1,472 @@
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
+	tr->time_start = now();
+
+	for_each_possible_cpu(cpu) {
+		data = tr->data[cpu];
+		tracing_reset(data);
+	}
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
+	int cpu;
+
+	if (!trace_enabled || !tr)
+		return;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	atomic_inc(&data->disabled);
+	if (atomic_read(&data->disabled) != 1)
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
+	int cpu;
+
+	if (!trace_enabled || !tr)
+		return;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	atomic_inc(&data->disabled);
+	if (atomic_read(&data->disabled) != 1)
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
+	atomic_inc(&data->disabled);
+	if (atomic_read(&data->disabled) != 1)
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
+}
+
+static notrace void event_trace_disarm(void)
+{
+	struct event_probes *probe;
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
+	atomic_inc(&trace_record_cmdline);
+	tracing_start_function_trace();
+}
+
+static notrace void stop_event_trace(struct tracing_trace *tr)
+{
+	tracing_stop_function_trace();
+	trace_enabled = 0;
+
+	atomic_dec(&trace_record_cmdline);
+	unregister_tracer_switch(&switch_ops);
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
--- linux-mcount.git.orig/lib/tracing/Kconfig	2008-01-25 21:47:36.000000000 -0500
+++ linux-mcount.git/lib/tracing/Kconfig	2008-01-25 21:47:40.000000000 -0500
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
--- linux-mcount.git.orig/lib/tracing/Makefile	2008-01-25 21:47:36.000000000 -0500
+++ linux-mcount.git/lib/tracing/Makefile	2008-01-25 21:47:40.000000000 -0500
@@ -6,5 +6,6 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace_f
 obj-$(CONFIG_CRITICAL_IRQSOFF_TIMING) += trace_irqsoff.o
 obj-$(CONFIG_CRITICAL_PREEMPT_TIMING) += trace_irqsoff.o
 obj-$(CONFIG_WAKEUP_TRACER) += trace_wakeup.o
+obj-$(CONFIG_EVENT_TRACER) += trace_events.o
 
 libmcount-y := mcount.o
Index: linux-mcount.git/lib/tracing/trace_wakeup.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_wakeup.c	2008-01-25 21:47:32.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_wakeup.c	2008-01-25 21:47:40.000000000 -0500
@@ -200,6 +200,7 @@ static notrace void wakeup_check_start(s
 	register_tracer_switch(&switch_ops);
 	tracing_start_function_trace();
 	atomic_inc(&trace_record_cmdline);
+	trace_start_events();
 
 	local_save_flags(flags);
 	tracing_function_trace(tr, tr->data[wakeup_cpu],
@@ -222,7 +223,7 @@ static notrace void wake_up_callback(con
 	struct task_struct *p;
 	va_list ap;
 
-	if (likely(!trace_enabled))
+	if (likely(!trace_enabled) && !trace_event_enabled())
 		return;
 
 	va_start(ap, format);
@@ -233,7 +234,10 @@ static notrace void wake_up_callback(con
 
 	va_end(ap);
 
-	wakeup_check_start(tr, p, curr);
+	trace_event_wakeup(CALLER_ADDR0, p, curr);
+
+	if (trace_enabled)
+		wakeup_check_start(tr, p, curr);
 }
 
 static notrace void start_wakeup_trace(struct tracing_trace *tr)
@@ -251,14 +255,19 @@ static notrace void wakeup_trace_init(st
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
--- linux-mcount.git.orig/lib/tracing/tracer.c	2008-01-25 21:47:34.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.c	2008-01-25 21:47:40.000000000 -0500
@@ -58,6 +58,9 @@ enum trace_type {
 
 	TRACE_FN,
 	TRACE_CTX,
+	TRACE_PID,
+	TRACE_SPECIAL,
+	TRACE_TMR,
 
 	__TRACE_LAST_TYPE
 };
@@ -400,6 +403,61 @@ notrace void tracing_sched_switch_trace(
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
@@ -728,6 +786,59 @@ lat_print_timestamp(struct seq_file *m, 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
 static void notrace
+print_generic_output(struct seq_file *m,
+		     struct tracing_entry *entry, int sym_only)
+{
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
+		seq_printf(m, " %d:%d:%c --> %d:%d",
+			   entry->ctx.prev_pid,
+			   entry->ctx.prev_prio,
+			   S,
+			   entry->ctx.next_pid,
+			   entry->ctx.next_prio);
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
@@ -737,7 +848,6 @@ print_lat_fmt(struct seq_file *m, struct
 	unsigned long rel_usecs;
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	int verbose = !!(trace_flags & TRACE_ITER_VERBOSE);
-	int S;
 
 	if (!next_entry)
 		next_entry = entry;
@@ -760,24 +870,8 @@ print_lat_fmt(struct seq_file *m, struct
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
-		seq_printf(m, " %d:%d:%c --> %d:%d\n",
-			   entry->ctx.prev_pid,
-			   entry->ctx.prev_prio,
-			   S,
-			   entry->ctx.next_pid,
-			   entry->ctx.next_prio);
-		break;
-	}
+	print_generic_output(m, entry, sym_only);
+	seq_putc(m, '\n');
 }
 
 static void notrace print_trace_fmt(struct seq_file *m,
@@ -789,7 +883,6 @@ static void notrace print_trace_fmt(stru
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	unsigned long long t;
 	char *comm;
-	int S;
 
 	comm = trace_find_cmdline(iter->ent->pid);
 
@@ -801,26 +894,7 @@ static void notrace print_trace_fmt(stru
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
--- linux-mcount.git.orig/lib/tracing/tracer.h	2008-01-25 21:47:34.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.h	2008-01-25 21:47:40.000000000 -0500
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
@@ -132,6 +176,24 @@ struct tracer_switch_ops {
 
 extern int register_tracer_switch(struct tracer_switch_ops *ops);
 extern int unregister_tracer_switch(struct tracer_switch_ops *ops);
+
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
 #endif /* CONFIG_CONTEXT_SWITCH_TRACER */
 
 #endif /* _LINUX_MCOUNT_TRACER_H */
Index: linux-mcount.git/lib/tracing/trace_irqsoff.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/trace_irqsoff.c	2008-01-25 21:47:36.000000000 -0500
+++ linux-mcount.git/lib/tracing/trace_irqsoff.c	2008-01-25 21:47:40.000000000 -0500
@@ -216,6 +216,7 @@ start_critical_timing(unsigned long ip, 
 	local_save_flags(flags);
 
 	tracing_function_trace(tr, data, ip, parent_ip, flags);
+	trace_start_events();
 
 	__get_cpu_var(tracing_cpu) = 1;
 
@@ -248,6 +249,7 @@ stop_critical_timing(unsigned long ip, u
 
 	atomic_inc(&data->disabled);
 	local_save_flags(flags);
+	trace_stop_events();
 	tracing_function_trace(tr, data, ip, parent_ip, flags);
 	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
@@ -371,12 +373,16 @@ static void __irqsoff_trace_init(struct 
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
