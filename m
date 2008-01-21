Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbYAUPcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbYAUPcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758814AbYAUPYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:53 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:49292 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991AbYAUPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:24:05 -0500
Message-Id: <20080121152354.230254511@goodmis.org>
References: <20080121152231.579118762@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 10:22:52 -0500
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
Subject: [RFC PATCH 21/23 -v4] mcount tracer for wakeup latency timings.
Content-Disposition: inline; filename=mcount-trace-wakeup-latency.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds hooks to trace the wake up latency of the highest
priority waking task. The following files are added to
/debugfs/tracing/

  wakeup_max_latency
     holds the current max latency for wakeup

  wakeup_thresh
     if set to other than zero, a log will be recorded
     for every wakeup that takes longer than the number
     entered in here (usecs for all counters)
     (deletes previous trace)

  wakeup_trace_ctrl
     echo 1 to start tracing wakeups
     echo 0 to stop

  wakeup_trace
     holds the output of the traces:

Examples:

  (with mcount_enabled = 0)

============
preemption latency trace v1.1.5 on 2.6.24-rc8
--------------------------------------------------------------------
 latency: 26 us, #2/2, CPU#1 | (M:rt VP:0, KP:0, SP:0 HP:0 #P:2)
    -----------------
    | task: migration/0-3 (uid:0 nice:-5 policy:1 rt_prio:99)
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
   quilt-8551  0d..3    0us+: wake_up_process+0x15/0x17 <ffffffff80233e80> (sched_exec+0xc9/0x100 <ffffffff80235343>)
   quilt-8551  0d..4   26us : sched_switch_callback+0x73/0x81 <ffffffff80338d2f> (schedule+0x483/0x6d5 <ffffffff8048b3ee>)


vim:ft=help
============

    
  (with mcount_enabled = 1)

============
preemption latency trace v1.1.5 on 2.6.24-rc8
--------------------------------------------------------------------
 latency: 36 us, #45/45, CPU#0 | (M:rt VP:0, KP:0, SP:0 HP:0 #P:2)
    -----------------
    | task: migration/1-5 (uid:0 nice:-5 policy:1 rt_prio:99)
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
    bash-10653 1d..3    0us : wake_up_process+0x15/0x17 <ffffffff80233e80> (sched_exec+0xc9/0x100 <ffffffff80235343>)
    bash-10653 1d..3    1us : try_to_wake_up+0x271/0x2e7 <ffffffff80233dcf> (sub_preempt_count+0xc/0x7a <ffffffff8023309e>)
    bash-10653 1d..2    2us : try_to_wake_up+0x296/0x2e7 <ffffffff80233df4> (update_rq_clock+0x9/0x20 <ffffffff802303f3>)
    bash-10653 1d..2    2us : update_rq_clock+0x1e/0x20 <ffffffff80230408> (__update_rq_clock+0xc/0x90 <ffffffff80230366>)
    bash-10653 1d..2    3us : __update_rq_clock+0x1b/0x90 <ffffffff80230375> (sched_clock+0x9/0x29 <ffffffff80214529>)
    bash-10653 1d..2    4us : try_to_wake_up+0x2a6/0x2e7 <ffffffff80233e04> (activate_task+0xc/0x3f <ffffffff8022ffca>)
    bash-10653 1d..2    4us : activate_task+0x2d/0x3f <ffffffff8022ffeb> (enqueue_task+0xe/0x66 <ffffffff8022ff66>)
    bash-10653 1d..2    5us : enqueue_task+0x5b/0x66 <ffffffff8022ffb3> (enqueue_task_rt+0x9/0x3c <ffffffff80233351>)
    bash-10653 1d..2    6us : try_to_wake_up+0x2ba/0x2e7 <ffffffff80233e18> (check_preempt_wakeup+0x12/0x99 <ffffffff80234f84>)
[...]
    bash-10653 1d..5   33us : tracing_record_cmdline+0xcf/0xd4 <ffffffff80338aad> (_spin_unlock+0x9/0x33 <ffffffff8048d3ec>)
    bash-10653 1d..5   34us : _spin_unlock+0x19/0x33 <ffffffff8048d3fc> (sub_preempt_count+0xc/0x7a <ffffffff8023309e>)
    bash-10653 1d..4   35us : wakeup_sched_switch+0x65/0x2ff <ffffffff80339f66> (_spin_lock_irqsave+0xc/0xa9 <ffffffff8048d08b>)
    bash-10653 1d..4   35us : _spin_lock_irqsave+0x19/0xa9 <ffffffff8048d098> (add_preempt_count+0xe/0x77 <ffffffff8023311a>)
    bash-10653 1d..4   36us : sched_switch_callback+0x73/0x81 <ffffffff80338d2f> (schedule+0x483/0x6d5 <ffffffff8048b3ee>)


vim:ft=help
============

The [...] was added here to not waste your email box space.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/Kconfig        |   10 
 lib/tracing/Makefile       |    1 
 lib/tracing/trace_wakeup.c |  526 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 537 insertions(+)

Index: linux-mcount.git/lib/tracing/Kconfig
===================================================================
--- linux-mcount.git.orig/lib/tracing/Kconfig	2008-01-18 23:09:43.000000000 -0500
+++ linux-mcount.git/lib/tracing/Kconfig	2008-01-18 23:29:25.000000000 -0500
@@ -26,6 +26,16 @@ config FUNCTION_TRACER
 	  that the debugging mechanism using this facility will hook by
 	  providing a set of inline routines.
 
+config WAKEUP_TRACER
+	bool "Trace wakeup latencies"
+	depends on DEBUG_KERNEL
+	select TRACING
+	select CONTEXT_SWITCH_TRACER
+	help
+	  This tracer adds hooks into scheduling to time the latency
+	  of the highest priority task tasks to be scheduled in
+	  after it has worken up.
+
 config CONTEXT_SWITCH_TRACER
 	bool "Trace process context switches"
 	depends on DEBUG_KERNEL
Index: linux-mcount.git/lib/tracing/Makefile
===================================================================
--- linux-mcount.git.orig/lib/tracing/Makefile	2008-01-18 23:00:02.000000000 -0500
+++ linux-mcount.git/lib/tracing/Makefile	2008-01-18 23:28:15.000000000 -0500
@@ -3,5 +3,6 @@ obj-$(CONFIG_MCOUNT) += libmcount.o
 obj-$(CONFIG_TRACING) += tracer.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_function.o
+obj-$(CONFIG_WAKEUP_TRACER) += trace_wakeup.o
 
 libmcount-y := mcount.o
Index: linux-mcount.git/lib/tracing/trace_wakeup.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/trace_wakeup.c	2008-01-18 23:33:15.000000000 -0500
@@ -0,0 +1,526 @@
+/*
+ * trace task wakeup timings
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
+static struct tracing_trace wakeup_trace __read_mostly;
+static struct tracing_trace max_tr __read_mostly;
+static DEFINE_PER_CPU(struct tracing_trace_cpu, wakeup_trace_cpu);
+static DEFINE_PER_CPU(struct tracing_trace_cpu, max_data);
+static unsigned long wakeup_max_latency = (cycle_t)ULONG_MAX;
+static unsigned long wakeup_thresh;
+static int trace_enabled __read_mostly;
+static unsigned long trace_nr_entries = (1024UL);
+static struct task_struct *wakeup_task;
+static int wakeup_cpu;
+static unsigned wakeup_prio = -1;
+
+static DEFINE_SPINLOCK(wakeup_lock);
+
+static void notrace wakeup_reset(struct tracing_trace *tr);
+
+static int __init set_nr_entries(char *str)
+{
+	if (!str)
+		return 0;
+	trace_nr_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("trace_wakeup_entries=", set_nr_entries);
+
+#ifdef CONFIG_MCOUNT
+static void notrace wakeup_trace_call(unsigned long ip,
+				      unsigned long parent_ip)
+{
+	struct tracing_trace *tr = &wakeup_trace;
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
+	if (unlikely(atomic_read(&data->disabled) != 1))
+		goto out;
+
+	spin_lock(&wakeup_lock);
+	if (wakeup_task && cpu == task_cpu(wakeup_task))
+		tracing_function_trace(tr, data, ip, parent_ip, flags);
+	spin_unlock(&wakeup_lock);
+
+ out:
+	atomic_dec(&data->disabled);
+	raw_local_irq_restore(flags);
+}
+
+static struct mcount_ops trace_ops __read_mostly =
+{
+	.func = wakeup_trace_call,
+};
+#endif /* CONFIG_MCOUNT */
+
+/*
+ * Should this new latency be reported/recorded?
+ */
+static int notrace report_latency(cycle_t delta)
+{
+	if (wakeup_thresh) {
+		if (delta < wakeup_thresh)
+			return 0;
+	} else {
+		if (delta <= wakeup_max_latency)
+			return 0;
+	}
+	return 1;
+}
+
+/*
+ * Copy the new maximum trace into the separate maximum-trace
+ * structure. (this way the maximum trace is permanently saved,
+ * for later retrieval via /debugfs/tracing/wakeup_trace)
+ */
+static void update_max_tr(struct tracing_trace *tr)
+{
+	struct tracing_trace_cpu *data = tr->data[wakeup_cpu];
+	void *save_trace;
+	int i;
+
+	max_tr.cpu = wakeup_cpu;
+	max_tr.time_start = data->preempt_timestamp;
+
+
+	/* clear out all the previous traces */
+	for_each_possible_cpu(i) {
+		data = tr->data[i];
+		save_trace = max_tr.data[i]->trace;
+		memcpy(max_tr.data[i], data, sizeof(*data));
+		data->trace = save_trace;
+	}
+
+	data = max_tr.data[wakeup_cpu];
+	data->saved_latency = wakeup_max_latency;
+
+	memcpy(data->comm, wakeup_task->comm, TASK_COMM_LEN);
+	data->pid = wakeup_task->pid;
+	data->uid = wakeup_task->uid;
+	data->nice = wakeup_task->static_prio - 20 - MAX_RT_PRIO;
+	data->policy = wakeup_task->policy;
+	data->rt_priority = wakeup_task->rt_priority;
+
+	/* record this tasks comm */
+	tracing_record_cmdline(current);
+}
+
+static void notrace wakeup_sched_switch(struct tracing_trace *tr,
+					struct task_struct *prev,
+					struct task_struct *next)
+{
+	struct tracing_trace_cpu *data;
+	unsigned long latency = 0, t0 = 0, t1 = 0;
+	cycle_t T0, T1, delta;
+	unsigned long flags;
+	int cpu;
+
+	if (unlikely(!trace_enabled) || next != wakeup_task)
+		return;
+
+	/* The task we are waitng for is waking up */
+	data = tr->data[wakeup_cpu];
+
+	if (unlikely(!data) || unlikely(!data->trace) ||
+	    unlikely(atomic_read(&data->disabled)))
+		return;
+
+	spin_lock_irqsave(&wakeup_lock, flags);
+
+	/* disable local data, not wakeup_cpu data */
+	cpu = raw_smp_processor_id();
+	atomic_inc(&tr->data[cpu]->disabled);
+
+	/* We could race with grabbing wakeup_lock */
+	if (unlikely(!trace_enabled || next != wakeup_task))
+		goto out;
+
+	tracing_function_trace(tr, data, CALLER_ADDR1, CALLER_ADDR2, flags);
+
+	/*
+	 * usecs conversion is slow so we try to delay the conversion
+	 * as long as possible:
+	 */
+	T0 = data->preempt_timestamp;
+	T1 = now();
+	delta = T1-T0;
+
+	if (!report_latency(delta))
+		goto out;
+
+	latency = cycles_to_usecs(delta);
+
+	wakeup_max_latency = delta;
+	t0 = cycles_to_usecs(T0);
+	t1 = cycles_to_usecs(T1);
+
+	update_max_tr(tr);
+
+#if 1
+	if (wakeup_thresh)
+		printk(KERN_INFO "(%16s-%-5d|#%d): %lu us wakeup latency "
+		       "violates %lu us threshold.\n"
+		       " => started at timestamp %lu: ",
+				wakeup_task->comm, wakeup_task->pid,
+				raw_smp_processor_id(),
+				latency, cycles_to_usecs(wakeup_thresh), t0);
+	else
+		printk(KERN_INFO "(%16s-%-5d|#%d): new %lu us maximum "
+		       "wakeup latency.\n => started at timestamp %lu: ",
+				wakeup_task->comm, wakeup_task->pid,
+				cpu, latency, t0);
+
+	printk(KERN_CONT "   ended at timestamp %lu: ", t1);
+	dump_stack();
+	t1 = cycles_to_usecs(now());
+	printk(KERN_CONT "   dump-end timestamp %lu\n\n", t1);
+
+#endif
+
+out:
+	wakeup_reset(tr);
+	atomic_dec(&tr->data[cpu]->disabled);
+	spin_unlock_irqrestore(&wakeup_lock, flags);
+
+}
+
+static struct tracer_switch_ops switch_ops __read_mostly = {
+	.func = wakeup_sched_switch,
+	.tr = &wakeup_trace,
+};
+
+static void notrace wakeup_reset(struct tracing_trace *tr)
+{
+	struct tracing_trace_cpu *data;
+	int cpu;
+
+	assert_spin_locked(&wakeup_lock);
+
+	for_each_possible_cpu(cpu) {
+		data = tr->data[cpu];
+		tracing_reset(data);
+	}
+
+	wakeup_cpu = -1;
+	wakeup_prio = -1;
+	if (wakeup_task) {
+		put_task_struct(wakeup_task);
+		atomic_dec(&trace_record_cmdline);
+		unregister_mcount_function(&trace_ops);
+		unregister_tracer_switch(&switch_ops);
+	}
+
+	wakeup_task = NULL;
+}
+
+static notrace void wakeup_check_start(struct tracing_trace *tr,
+				       struct task_struct *p,
+				       struct task_struct *curr)
+{
+	unsigned long flags;
+	int cpu = smp_processor_id();
+
+	if (likely(!rt_task(p)) ||
+	    p->prio >= wakeup_prio ||
+	    p->prio >= curr->prio)
+		return;
+
+	atomic_inc(&tr->data[cpu]->disabled);
+	if (unlikely(atomic_read(&tr->data[cpu]->disabled) != 1))
+		goto out;
+
+	/* interrupts should be off from try_to_wake_up */
+	spin_lock(&wakeup_lock);
+
+	/* check for races. */
+	if (!trace_enabled || p->prio >= wakeup_prio)
+		goto out_locked;
+
+	/* reset the trace */
+	wakeup_reset(tr);
+
+	wakeup_cpu = task_cpu(p);
+	wakeup_prio = p->prio;
+
+	wakeup_task = p;
+	get_task_struct(wakeup_task);
+	register_tracer_switch(&switch_ops);
+	register_mcount_function(&trace_ops);
+	atomic_inc(&trace_record_cmdline);
+
+	tr->data[wakeup_cpu]->preempt_timestamp = now();
+
+	local_save_flags(flags);
+	tracing_function_trace(tr, tr->data[wakeup_cpu],
+			       CALLER_ADDR1, CALLER_ADDR2, flags);
+
+
+ out_locked:
+	spin_unlock(&wakeup_lock);
+ out:
+	atomic_dec(&tr->data[cpu]->disabled);
+}
+
+static notrace void wake_up_callback(const struct marker *mdata,
+				     void *private_data,
+				     const char *format, ...)
+{
+	struct tracing_trace *tr = mdata->private;
+	struct task_struct *curr;
+	struct task_struct *p;
+	va_list ap;
+
+	if (!trace_enabled)
+		return;
+
+	va_start(ap, format);
+
+	/*
+	 * skip over the pretty stuff
+	 *   "pid %d prio %d state %d\0"
+	 */
+	va_arg(ap, int);
+	va_arg(ap, long);
+
+	/* now get the meat: "p %p rq->curr %p" */
+	p = va_arg(ap, typeof(p));
+	curr = va_arg(ap, typeof(curr));
+
+	va_end(ap);
+
+	wakeup_check_start(tr, p, curr);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static ssize_t max_wakeup_lat_read(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	unsigned long *ptr = filp->private_data;
+	char buf[64];
+	int r;
+
+	r = snprintf(buf, 64, "%ld\n", *ptr == -1 ? : cycles_to_usecs(*ptr));
+	if (r > 64)
+		r = 64;
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       buf, r);
+}
+static ssize_t max_wakeup_lat_write(struct file *filp,
+				    const char __user *ubuf,
+				    size_t cnt, loff_t *ppos)
+{
+	long *ptr = filp->private_data;
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
+	*ptr = usecs_to_cycles(val);
+
+	return cnt;
+}
+
+static struct file_operations max_wakeup_lat_fops = {
+	.open = tracing_open_generic,
+	.read = max_wakeup_lat_read,
+	.write = max_wakeup_lat_write,
+};
+
+static void wakeup_trace_ctrl_update(struct tracing_trace *tr,
+				     unsigned long val)
+{
+	unsigned long flags;
+
+	val = !!val;
+
+	if (tr->ctrl ^ val) {
+		if (val) {
+			spin_lock_irqsave(&wakeup_lock, flags);
+			wakeup_reset(tr);
+			spin_unlock_irqrestore(&wakeup_lock, flags);
+			smp_wmb();
+			trace_enabled = 1;
+		} else {
+			trace_enabled = 0;
+		}
+		tr->ctrl = val;
+	}
+}
+
+static __init void wakeup_trace_init_debugfs(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	wakeup_trace.ctrl_update = wakeup_trace_ctrl_update;
+
+#ifdef CONFIG_MCOUNT
+	entry = debugfs_create_file("wakeup_trace_ctrl", 0644, d_tracer,
+				    &wakeup_trace, &tracing_ctrl_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs"
+			   " 'preempt_wakeup_trace_ctrl' entry\n");
+#endif
+
+	entry = debugfs_create_file("wakeup_max_latency", 0644, d_tracer,
+				    &wakeup_max_latency, &max_wakeup_lat_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'wakeup_max_latency' entry\n");
+
+	entry = debugfs_create_file("wakeup_thresh", 0644, d_tracer,
+				    &wakeup_thresh, &max_wakeup_lat_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'wakeup_threash' entry\n");
+
+	entry = debugfs_create_file("wakeup_trace", 0444, d_tracer,
+				    &max_tr, &tracing_lt_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'wakeup_trace' entry\n");
+}
+
+#endif /* CONFIG_DEBUGFS */
+
+static void notrace wakeup_trace_open(struct tracing_iterator *iter)
+{
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl)
+		trace_enabled = 0;
+}
+
+static void notrace wakeup_trace_close(struct tracing_iterator *iter)
+{
+	unsigned long flags;
+
+	if (iter->tr->ctrl) {
+		/* forget about any processes we were recording */
+		spin_lock_irqsave(&wakeup_lock, flags);
+		wakeup_reset(iter->tr);
+		spin_unlock_irqrestore(&wakeup_lock, flags);
+		trace_enabled = 1;
+	}
+}
+
+__init static int trace_wakeup_alloc_buffers(void)
+{
+	const int order = page_order(trace_nr_entries * TRACING_ENTRY_SIZE);
+	const unsigned long size = (1UL << order) << PAGE_SHIFT;
+	struct tracing_entry *array;
+	int i;
+	int ret;
+
+	for_each_possible_cpu(i) {
+		wakeup_trace.data[i] = &per_cpu(wakeup_trace_cpu, i);
+		max_tr.data[i] = &per_cpu(max_data, i);
+
+		array = (struct tracing_entry *)
+			  __get_free_pages(GFP_KERNEL, order);
+		if (array == NULL) {
+			printk(KERN_ERR "wakeup tracer: failed to allocate"
+			       " %ld bytes for trace buffer!\n", size);
+			goto free_buffers;
+		}
+		wakeup_trace.data[i]->trace = array;
+
+		array = (struct tracing_entry *)
+			  __get_free_pages(GFP_KERNEL, order);
+		if (array == NULL) {
+			printk(KERN_ERR "wakeup tracer: failed to allocate"
+			       " %ld bytes for trace buffer!\n", size);
+			goto free_buffers;
+		}
+		max_tr.data[i]->trace = array;
+	}
+
+	/*
+	 * Since we allocate by orders of pages, we may be able to
+	 * round up a bit.
+	 */
+	wakeup_trace.entries = size / TRACING_ENTRY_SIZE;
+	max_tr.entries = wakeup_trace.entries;
+
+	pr_info("wakeup tracer: %ld bytes allocated for %ld",
+		size, trace_nr_entries);
+	pr_info(" entries of %d bytes\n", (int)TRACING_ENTRY_SIZE);
+	pr_info("   actual entries %ld\n", wakeup_trace.entries);
+
+	wakeup_trace_init_debugfs();
+
+	wakeup_trace.open = wakeup_trace_open;
+	wakeup_trace.close = wakeup_trace_close;
+
+	ret = marker_probe_register("kernel_sched_wakeup",
+				    "pid %d state %ld --"
+				    "p %p rq->curr %p",
+				    wake_up_callback,
+				    &wakeup_trace);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't add marker"
+			" probe to kernel_sched_wakeup\n");
+		goto out;
+	}
+
+	ret = marker_arm("kernel_sched_wakeup");
+	if (ret) {
+		pr_info("wakeup trace: Couldn't arm probe"
+			" kernel_sched_wakeup\n");
+		goto out;
+	}
+
+ out:
+	return 0;
+
+ free_buffers:
+	for (i-- ; i >= 0; i--) {
+		struct tracing_trace_cpu *data = wakeup_trace.data[i];
+
+		if (data && data->trace) {
+			free_pages((unsigned long)data->trace, order);
+			data->trace = NULL;
+		}
+
+		data = max_tr.data[i];
+		if (data && data->trace) {
+			free_pages((unsigned long)data->trace, order);
+			data->trace = NULL;
+		}
+	}
+	return -ENOMEM;
+}
+
+device_initcall(trace_wakeup_alloc_buffers);

-- 
