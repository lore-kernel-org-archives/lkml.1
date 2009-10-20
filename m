Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZJTT2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZJTT2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZJTT2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:28:42 -0400
Received: from toro.web-alm.net ([62.245.132.31]:55972 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZJTT2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:28:40 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2009 15:28:40 EDT
Message-ID: <4ADE0A89.1000600@osadl.org>
Date: Tue, 20 Oct 2009 21:07:53 +0200
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>
Subject: [PATCH RT] Consider shared max priority in latency histograms
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The algorithm used so far to trace the process with the highest priority requires that no other processes with the same priority are being woken up simultaneously. Otherwise, a process with a lower priority may be picked up for tracing which leads to an erroneously high latency value being recorded.

Generally, the wakeup latency of a process that exclusively uses the highest priority of the system is due to software or hardware issues we would like to solve or, at least, keep as small as possible. This is what latency measurements are made for, after all. The wakeup latency of a process that shares the highest priority of the system with other processes, is quite another story. It may contain the worst-case runtime durations of the other processes; thus, it is the result of the priority design of a given system and nothing a kernel developer or hardware engineer may want to fix.

This said, we need to separately record latencies i) of processes that exclusively use the highest priority of the system and ii) of processes that share the highest priority of the system with other processes.

The above mentioned shortcoming of the tracing algorithm also applies to the variable tracing_max_latency that the wakeup latency tracer uses, since it is based on the same procedure as the original version of the latency histogram. In consequence, if several processes share the highest priority of the system, the variable tracing_max_latency may contain erroneously high values. We could now patch the wakeup latency tracer as well and separately record the various latencies, but we better document this behavior and recommend the latency histograms to reliably determine a system's worst-case wakeup latency.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

Index: linux-2.6.31.4-rt14/kernel/trace/latency_hist.c
===================================================================
--- linux-2.6.31.4-rt14.orig/kernel/trace/latency_hist.c
+++ linux-2.6.31.4-rt14/kernel/trace/latency_hist.c
@@ -34,6 +34,7 @@ enum {
 	PREEMPTOFF_LATENCY,
 	PREEMPTIRQSOFF_LATENCY,
 	WAKEUP_LATENCY,
+	WAKEUP_LATENCY_SHAREDPRIO,
 	MAX_LATENCY_TYPE,
 };
 
@@ -81,7 +82,9 @@ static struct enable_data preemptirqsoff
 
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
 static DEFINE_PER_CPU(struct hist_data, wakeup_latency_hist);
+static DEFINE_PER_CPU(struct hist_data, wakeup_latency_hist_sharedprio);
 static char *wakeup_latency_hist_dir = "wakeup";
+static char *wakeup_latency_hist_dir_sharedprio = "sharedprio";
 static notrace void probe_wakeup_latency_hist_start(struct rq *rq,
     struct task_struct *p, int success);
 static notrace void probe_wakeup_latency_hist_stop(struct rq *rq,
@@ -98,8 +101,9 @@ struct maxlatproc_data {
 	unsigned long latency;
 };
 static DEFINE_PER_CPU(struct maxlatproc_data, wakeup_maxlatproc);
-static unsigned wakeup_prio = (unsigned)-1;
+static DEFINE_PER_CPU(struct maxlatproc_data, wakeup_maxlatproc_sharedprio);
 static struct task_struct *wakeup_task;
+static int wakeup_sharedprio;
 static int wakeup_pid;
 #endif
 
@@ -107,6 +111,9 @@ void notrace latency_hist(int latency_ty
 			  struct task_struct *p)
 {
 	struct hist_data *my_hist;
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+	struct maxlatproc_data *mp = NULL;
+#endif
 
 	if (cpu < 0 || cpu >= NR_CPUS || latency_type < 0 ||
 	    latency_type >= MAX_LATENCY_TYPE)
@@ -134,6 +141,11 @@ void notrace latency_hist(int latency_ty
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
 	case WAKEUP_LATENCY:
 		my_hist = &per_cpu(wakeup_latency_hist, cpu);
+		mp = &per_cpu(wakeup_maxlatproc, cpu);
+		break;
+	case WAKEUP_LATENCY_SHAREDPRIO:
+		my_hist = &per_cpu(wakeup_latency_hist_sharedprio, cpu);
+		mp = &per_cpu(wakeup_maxlatproc_sharedprio, cpu);
 		break;
 #endif
 	default:
@@ -152,9 +164,8 @@ void notrace latency_hist(int latency_ty
 		my_hist->min_lat = latency;
 	else if (latency > my_hist->max_lat) {
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
-		if (latency_type == WAKEUP_LATENCY) {
-			struct maxlatproc_data *mp =
-			    &per_cpu(wakeup_maxlatproc, cpu);
+		if (latency_type == WAKEUP_LATENCY ||
+		    latency_type == WAKEUP_LATENCY_SHAREDPRIO) {
 			strncpy(mp->comm, p->comm, sizeof(mp->comm));
 			mp->pid = task_pid_nr(p);
 			mp->prio = p->prio;
@@ -284,6 +295,9 @@ latency_hist_reset(struct file *file, co
 {
 	int cpu;
 	struct hist_data *hist;
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+	struct maxlatproc_data *mp = NULL;
+#endif
 	int latency_type = (int) file->private_data;
 
 	switch (latency_type) {
@@ -318,12 +332,21 @@ latency_hist_reset(struct file *file, co
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
 	case WAKEUP_LATENCY:
 		for_each_online_cpu(cpu) {
-			struct maxlatproc_data *mp =
-			    &per_cpu(wakeup_maxlatproc, cpu);
+			hist = &per_cpu(wakeup_latency_hist, cpu);
+			hist_reset(hist);
+			mp = &per_cpu(wakeup_maxlatproc, cpu);
 			mp->comm[0] = '\0';
 			mp->prio = mp->pid = mp->latency = 0;
-			hist = &per_cpu(wakeup_latency_hist, cpu);
+		}
+		break;
+
+	case WAKEUP_LATENCY_SHAREDPRIO:
+		for_each_online_cpu(cpu) {
+			hist = &per_cpu(wakeup_latency_hist_sharedprio, cpu);
 			hist_reset(hist);
+			mp = &per_cpu(wakeup_maxlatproc_sharedprio, cpu);
+			mp->comm[0] = '\0';
+			mp->prio = mp->pid = mp->latency = 0;
 		}
 		break;
 #endif
@@ -341,8 +364,6 @@ latency_hist_show_pid(struct file *filp,
 	int r;
 
 	r = snprintf(buf, sizeof(buf), "%u\n", wakeup_pid);
-	if (r > sizeof(buf))
-		r = sizeof(buf);
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
@@ -379,8 +400,6 @@ latency_hist_show_maxlatproc(struct file
 
 	r = snprintf(buf, sizeof(buf), "%5d %3d %ld %s\n",
 	    mp->pid, mp->prio, mp->latency, mp->comm);
-	if (r > sizeof(buf))
-		r = sizeof(buf);
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
@@ -409,8 +428,6 @@ latency_hist_show_enable(struct file *fi
 	int r;
 
 	r = snprintf(buf, sizeof(buf), "%d\n", ed->enabled);
-	if (r > sizeof(buf))
-		r = sizeof(buf);
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
@@ -497,7 +514,7 @@ latency_hist_enable(struct file *filp, c
 			unregister_trace_sched_switch(
 			    probe_wakeup_latency_hist_stop);
 			wakeup_task = NULL;
-			wakeup_prio = (unsigned)-1;
+			wakeup_sharedprio = 0;
 			break;
 		case PREEMPTIRQSOFF_LATENCY:
 			unregister_trace_preemptirqsoff_hist(
@@ -657,23 +674,28 @@ notrace void probe_wakeup_latency_hist_s
 	struct task_struct *curr = rq_curr(rq);
 
 	if (wakeup_pid) {
+		if ((wakeup_task && p->prio == wakeup_task->prio) ||
+		    p->prio == curr->prio)
+			wakeup_sharedprio = 1;
 		if (likely(wakeup_pid != task_pid_nr(p)))
 			return;
 	} else {
 		if (likely(!rt_task(p)) ||
-		    p->prio >= wakeup_prio ||
-		    p->prio >= curr->prio)
+		    (wakeup_task && p->prio > wakeup_task->prio) ||
+		    p->prio > curr->prio)
 			return;
+		if ((wakeup_task && p->prio == wakeup_task->prio) ||
+		    p->prio == curr->prio)
+			wakeup_sharedprio = 1;
 	}
 
 	atomic_spin_lock_irqsave(&wakeup_lock, flags);
 	if (wakeup_task)
 		put_task_struct(wakeup_task);
-
 	get_task_struct(p);
 	wakeup_task = p;
-	wakeup_prio = p->prio;
 	wakeup_start = ftrace_now(raw_smp_processor_id());
+	wakeup_task->preempt_timestamp_hist = wakeup_start;
 	atomic_spin_unlock_irqrestore(&wakeup_lock, flags);
 }
 
@@ -692,15 +714,26 @@ notrace void probe_wakeup_latency_hist_s
 	stop = ftrace_now(cpu);
 
 	atomic_spin_lock_irqsave(&wakeup_lock, flags);
-	if (next != wakeup_task)
+	if (next != wakeup_task) {
+		if (wakeup_task && next->prio == wakeup_task->prio) {
+			latency = nsecs_to_usecs(
+			    stop - next->preempt_timestamp_hist);
+			latency_hist(WAKEUP_LATENCY_SHAREDPRIO, cpu, latency,
+			    next);
+		}
 		goto out;
+	}
 
 	latency = nsecs_to_usecs(stop - wakeup_start);
-	latency_hist(WAKEUP_LATENCY, cpu, latency, next);
+	if (!wakeup_sharedprio)
+		latency_hist(WAKEUP_LATENCY, cpu, latency, next);
+	else {
+		latency_hist(WAKEUP_LATENCY_SHAREDPRIO, cpu, latency, next);
+		wakeup_sharedprio = 0;
+	}
 
 	put_task_struct(wakeup_task);
 	wakeup_task = NULL;
-	wakeup_prio = (unsigned)-1;
 out:
 	atomic_spin_unlock_irqrestore(&wakeup_lock, flags);
 }
@@ -711,12 +744,16 @@ static __init int latency_hist_init(void
 {
 	struct dentry *latency_hist_root = NULL;
 	struct dentry *dentry;
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+	struct dentry *dentry_sharedprio;
+#endif
 	struct dentry *entry;
 	struct dentry *latency_hist_enable_root;
-	int i = 0, len = 0;
+	int i = 0;
 	struct hist_data *my_hist;
 	char name[64];
 	char *cpufmt = "CPU%d";
+	char *cpufmt_maxlatproc = "max_latency-CPU%d";
 
 	dentry = tracing_init_dentry();
 
@@ -729,92 +766,94 @@ static __init int latency_hist_init(void
 #ifdef CONFIG_INTERRUPT_OFF_HIST
 	dentry = debugfs_create_dir(irqsoff_hist_dir, latency_hist_root);
 	for_each_possible_cpu(i) {
-		len = sprintf(name, cpufmt, i);
-		name[len] = '\0';
+		sprintf(name, cpufmt, i);
 		entry = debugfs_create_file(name, 0444, dentry,
-					    &per_cpu(irqsoff_hist, i),
-					    &latency_hist_fops);
+		    &per_cpu(irqsoff_hist, i), &latency_hist_fops);
 		my_hist = &per_cpu(irqsoff_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
 		my_hist->min_lat = 0xFFFFFFFFUL;
 	}
 	entry = debugfs_create_file("reset", 0644, dentry,
-				    (void *)IRQSOFF_LATENCY,
-				    &latency_hist_reset_fops);
+	    (void *)IRQSOFF_LATENCY, &latency_hist_reset_fops);
 #endif
 
 #ifdef CONFIG_PREEMPT_OFF_HIST
 	dentry = debugfs_create_dir(preemptoff_hist_dir,
-				    latency_hist_root);
+	    latency_hist_root);
 	for_each_possible_cpu(i) {
-		len = sprintf(name, cpufmt, i);
-		name[len] = '\0';
+		sprintf(name, cpufmt, i);
 		entry = debugfs_create_file(name, 0444, dentry,
-					    &per_cpu(preemptoff_hist, i),
-					    &latency_hist_fops);
+		    &per_cpu(preemptoff_hist, i), &latency_hist_fops);
 		my_hist = &per_cpu(preemptoff_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
 		my_hist->min_lat = 0xFFFFFFFFUL;
 	}
 	entry = debugfs_create_file("reset", 0644, dentry,
-				    (void *)PREEMPTOFF_LATENCY,
-				    &latency_hist_reset_fops);
+	    (void *)PREEMPTOFF_LATENCY, &latency_hist_reset_fops);
 #endif
 
 #if defined(CONFIG_INTERRUPT_OFF_HIST) && defined(CONFIG_PREEMPT_OFF_HIST)
 	dentry = debugfs_create_dir(preemptirqsoff_hist_dir,
-				    latency_hist_root);
+	    latency_hist_root);
 	for_each_possible_cpu(i) {
-		len = sprintf(name, cpufmt, i);
-		name[len] = '\0';
+		sprintf(name, cpufmt, i);
 		entry = debugfs_create_file(name, 0444, dentry,
-					    &per_cpu(preemptirqsoff_hist, i),
-					    &latency_hist_fops);
+		    &per_cpu(preemptirqsoff_hist, i), &latency_hist_fops);
 		my_hist = &per_cpu(preemptirqsoff_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
 		my_hist->min_lat = 0xFFFFFFFFUL;
 	}
 	entry = debugfs_create_file("reset", 0644, dentry,
-				    (void *)PREEMPTIRQSOFF_LATENCY,
-				    &latency_hist_reset_fops);
+	    (void *)PREEMPTIRQSOFF_LATENCY, &latency_hist_reset_fops);
 #endif
 
 #if defined(CONFIG_INTERRUPT_OFF_HIST) || defined(CONFIG_PREEMPT_OFF_HIST)
 	entry = debugfs_create_file("preemptirqsoff", 0644,
-				    latency_hist_enable_root,
-				    (void *)&preemptirqsoff_enabled_data,
-				    &latency_hist_enable_fops);
+	    latency_hist_enable_root, (void *)&preemptirqsoff_enabled_data,
+	    &latency_hist_enable_fops);
 #endif
 
 #ifdef CONFIG_WAKEUP_LATENCY_HIST
 	dentry = debugfs_create_dir(wakeup_latency_hist_dir,
-				    latency_hist_root);
+	    latency_hist_root);
+	dentry_sharedprio = debugfs_create_dir(
+	    wakeup_latency_hist_dir_sharedprio, dentry);
 	for_each_possible_cpu(i) {
-		len = sprintf(name, cpufmt, i);
-		name[len] = '\0';
+		sprintf(name, cpufmt, i);
 		entry = debugfs_create_file(name, 0444, dentry,
-					    &per_cpu(wakeup_latency_hist, i),
-					    &latency_hist_fops);
+		    &per_cpu(wakeup_latency_hist, i),
+		    &latency_hist_fops);
 		my_hist = &per_cpu(wakeup_latency_hist, i);
 		atomic_set(&my_hist->hist_mode, 1);
 		my_hist->min_lat = 0xFFFFFFFFUL;
 
-		len = sprintf(name, "max_latency-CPU%d", i);
-		name[len] = '\0';
+		sprintf(name, cpufmt, i);
+		entry = debugfs_create_file(name, 0444, dentry_sharedprio,
+		    &per_cpu(wakeup_latency_hist_sharedprio, i),
+		    &latency_hist_fops);
+		my_hist = &per_cpu(wakeup_latency_hist_sharedprio, i);
+		atomic_set(&my_hist->hist_mode, 1);
+		my_hist->min_lat = 0xFFFFFFFFUL;
+
+		sprintf(name, cpufmt_maxlatproc, i);
 		entry = debugfs_create_file(name, 0444, dentry,
-					    &per_cpu(wakeup_maxlatproc, i),
-					    &latency_hist_maxlatproc_fops);
+		    &per_cpu(wakeup_maxlatproc, i),
+		    &latency_hist_maxlatproc_fops);
+
+		sprintf(name, cpufmt_maxlatproc, i);
+		entry = debugfs_create_file(name, 0444, dentry_sharedprio,
+		    &per_cpu(wakeup_maxlatproc_sharedprio, i),
+		    &latency_hist_maxlatproc_fops);
 	}
 	entry = debugfs_create_file("pid", 0644, dentry,
-				    (void *)&wakeup_pid,
-				    &latency_hist_pid_fops);
+	    (void *)&wakeup_pid, &latency_hist_pid_fops);
 	entry = debugfs_create_file("reset", 0644, dentry,
-				    (void *)WAKEUP_LATENCY,
-				    &latency_hist_reset_fops);
+	    (void *)WAKEUP_LATENCY, &latency_hist_reset_fops);
+	entry = debugfs_create_file("reset", 0644, dentry_sharedprio,
+	    (void *)WAKEUP_LATENCY_SHAREDPRIO, &latency_hist_reset_fops);
 	entry = debugfs_create_file("wakeup", 0644,
-				    latency_hist_enable_root,
-				    (void *)&wakeup_latency_enabled_data,
-				    &latency_hist_enable_fops);
+	    latency_hist_enable_root, (void *)&wakeup_latency_enabled_data,
+	    &latency_hist_enable_fops);
 #endif
 	return 0;
 }
Index: linux-2.6.31.4-rt14/include/linux/sched.h
===================================================================
--- linux-2.6.31.4-rt14.orig/include/linux/sched.h
+++ linux-2.6.31.4-rt14/include/linux/sched.h
@@ -1548,6 +1548,9 @@ struct task_struct {
 	unsigned long trace;
 	/* bitmask of trace recursion */
 	unsigned long trace_recursion;
+#ifdef CONFIG_WAKEUP_LATENCY_HIST
+	u64 preempt_timestamp_hist;
+#endif
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_PREEMPT_RT
 	/*
Index: linux-2.6.31.4-rt14/kernel/trace/Kconfig
===================================================================
--- linux-2.6.31.4-rt14.orig/kernel/trace/Kconfig
+++ linux-2.6.31.4-rt14/kernel/trace/Kconfig
@@ -143,7 +143,6 @@ config FUNCTION_GRAPH_TRACER
 	  the return value. This is done by setting the current return 
 	  address on the current task structure into a stack of calls.
 
-
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
@@ -171,15 +170,15 @@ config INTERRUPT_OFF_HIST
 	bool "Interrupts-off Latency Histogram"
 	depends on IRQSOFF_TRACER
 	help
-	  This option generates a continuously updated histogram (one per cpu)
+	  This option generates continuously updated histograms (one per cpu)
 	  of the duration of time periods with interrupts disabled. The
-	  histogram is disabled by default. To enable it, write a non-zero
-	  number to the related file in
+	  histograms are disabled by default. To enable them, write a non-zero
+	  number to
 
 	      /sys/kernel/debug/tracing/latency_hist/enable/preemptirqsoff
 
-	  If PREEMPT_OFF_HIST is also selected, an additional histogram (one
-	  per cpu) is generated that accumulates the duration of time periods
+	  If PREEMPT_OFF_HIST is also selected, additional histograms (one
+	  per cpu) are generated that accumulate the duration of time periods
 	  when both interrupts and preemption are disabled.
 
 config PREEMPT_TRACER
@@ -208,15 +207,15 @@ config PREEMPT_OFF_HIST
 	bool "Preemption-off Latency Histogram"
 	depends on PREEMPT_TRACER
 	help
-	  This option generates a continuously updated histogram (one per cpu)
+	  This option generates continuously updated histograms (one per cpu)
 	  of the duration of time periods with preemption disabled. The
-	  histogram is disabled by default. To enable it, write a non-zero
+	  histograms are disabled by default. To enable them, write a non-zero
 	  number to
 
 	      /sys/kernel/debug/tracing/latency_hist/enable/preemptirqsoff
 
-	  If INTERRUPT_OFF_HIST is also selected, an additional histogram (one
-	  per cpu) is generated that accumulates the duration of time periods
+	  If INTERRUPT_OFF_HIST is also selected, additional histograms (one
+	  per cpu) are generated that accumulate the duration of time periods
 	  when both interrupts and preemption are disabled.
 
 config SCHED_TRACER
@@ -232,12 +231,20 @@ config WAKEUP_LATENCY_HIST
 	bool "Scheduling Latency Histogram"
 	depends on SCHED_TRACER
 	help
-	  This option generates a continuously updated histogram (one per cpu)
-	  of the scheduling latency of the highest priority task. The histogram
-	  is disabled by default. To enable it, write a non-zero number to
+	  This option generates continuously updated histograms (one per cpu)
+	  of the scheduling latency of the highest priority task.
+	  The histograms are disabled by default. To enable them, write a
+	  non-zero number to
 
 	      /sys/kernel/debug/tracing/latency_hist/enable/wakeup
 
+	  Two different algorithms are used, one to determine the latency of
+	  processes that exclusively use the highest priority of the system and
+	  another one to determine the latency of processes that share the
+	  highest system priority with other processes. The former is used to
+	  improve hardware and system software, the latter to optimize the
+	  priority design of a given system.
+
 config SYSPROF_TRACER
 	bool "Sysprof Tracer"
 	depends on X86
Index: linux-2.6.31.4-rt14/Documentation/trace/histograms.txt
===================================================================
--- linux-2.6.31.4-rt14.orig/Documentation/trace/histograms.txt
+++ linux-2.6.31.4-rt14/Documentation/trace/histograms.txt
@@ -24,7 +24,7 @@ histograms of potential sources of laten
 stamp at the start of a critical section, determines the time elapsed
 when the end of the section is reached, and increments the frequency
 counter of that latency value - irrespective of whether any concurrently
-running process is affected by latency or not.
+running process is affected by this latency or not.
 - Configuration items (in the Kernel hacking/Tracers submenu)
   CONFIG_INTERRUPT_OFF_LATENCY
   CONFIG_PREEMPT_OFF_LATENCY
@@ -71,18 +71,20 @@ histogram data - one per CPU - are avail
 /sys/kernel/debug/tracing/latency_hist/irqsoff/CPUx
 /sys/kernel/debug/tracing/latency_hist/preemptirqsoff/CPUx
 /sys/kernel/debug/tracing/latency_hist/wakeup/CPUx.
+/sys/kernel/debug/tracing/latency_hist/wakeup/sharedprio/CPUx.
 
 The histograms are reset by writing non-zero to the file "reset" in a
 particular latency directory. To reset all latency data, use
 
-#!/bin/sh
+#!/bin/bash
 
-HISTDIR=/sys/kernel/debug/tracing/latency_hist
+TRACINGDIR=/sys/kernel/debug/tracing
+HISTDIR=$TRACINGDIR/latency_hist
 
 if test -d $HISTDIR
 then
   cd $HISTDIR
-  for i in */reset
+  for i in `find . | grep /reset$`
   do
     echo 1 >$i
   done
@@ -133,6 +135,18 @@ grep -v " 0$" /sys/kernel/debug/tracing/
    25	               1
 
 
+* Two types of wakeup latency histograms
+
+Two different algorithms are used to determine the wakeup latency of a
+process. One of them only considers processes that exclusively use the
+highest priority of the system, the other one records the wakeup latency
+of a process even if it shares the highest systemm latency with other
+processes. The former is used to improve hardware and system software;
+the related histograms are located it the wakeup subdirectory. The
+latter is used to optimize the priority design of a given system; the
+related histograms are located in the wakeup/sharedprio subdirectory.
+
+
 * Wakeup latency of a selected process
 
 To only collect wakeup latency data of a particular process, write the
@@ -146,11 +160,17 @@ PIDs are not considered, if this variabl
 * Details of the process with the highest wakeup latency so far
 
 Selected data of the process that suffered from the highest wakeup
-latency that occurred in a particular CPU are available in the file
+latency that occurred in a particular CPU are available in the files
+
+/sys/kernel/debug/tracing/latency_hist/wakeup/max_latency-CPUx
+
+and
+
+/sys/kernel/debug/tracing/latency_hist/wakeup/sharedprio/max_latency-CPUx,
 
-/sys/kernel/debug/tracing/latency_hist/wakeup/max_latency-CPUx.
+respectively.
 
 The format of the data is
 <PID> <Priority> <Latency> <Command>
 
-These data are also reset when the wakeup histogram ist reset.
+These data are also reset when the related wakeup histograms are reset.
Index: linux-2.6.31.4-rt14/Documentation/trace/ftrace.txt
===================================================================
--- linux-2.6.31.4-rt14.orig/Documentation/trace/ftrace.txt
+++ linux-2.6.31.4-rt14/Documentation/trace/ftrace.txt
@@ -111,9 +111,14 @@ of ftrace. Here is a list of some of the
 	For example, the time interrupts are disabled.
 	This time is saved in this file. The max trace
 	will also be stored, and displayed by "trace".
-	A new max trace will only be recorded if the
+	A new max trace will only be recorded, if the
 	latency is greater than the value in this
-	file. (in microseconds)
+	file (in microseconds). Note that the max latency
+	recorded by the wakeup and the wakeup_rt tracer
+	do not necessarily reflect the worst-case latency
+	of the system, but may be erroneously high in
+	case two or more processes share the maximum
+	priority of the system.
 
   buffer_size_kb:
 

