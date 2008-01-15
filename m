Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYAOVA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYAOVA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbYAOUvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:51:09 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:65141 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbYAOUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:38 -0500
Message-Id: <20080115205025.718613836@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:30 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 23/30 v3] Add latency_trace format tor tracer
Content-Disposition: inline; filename=mcount-tracer-latency-tracer-fmt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a latency_trace file with the format used
by RT in which others have created tools to disect. This
file adds some useful recording for tracing, but still
does not add actual latency tracing.

Format like (default):

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


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |  451 +++++++++++++++++++++++++++++++++++++++++++++------
 lib/tracing/tracer.h |   13 +
 2 files changed, 411 insertions(+), 53 deletions(-)

Index: linux-compile.git/lib/tracing/tracer.c
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-15 15:03:17.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.c	2008-01-15 15:03:41.000000000 -0500
@@ -20,7 +20,9 @@
 #include <linux/debugfs.h>
 #include <linux/kallsyms.h>
 #include <linux/clocksource.h>
+#include <linux/utsrelease.h>
 #include <linux/uaccess.h>
+#include <linux/hardirq.h>
 #include <linux/mcount.h>
 
 #include "tracer.h"
@@ -35,16 +37,25 @@ static struct mctracer_trace mctracer_tr
 static DEFINE_PER_CPU(struct mctracer_trace_cpu, mctracer_trace_cpu);
 static int trace_enabled __read_mostly;
 
+enum trace_flag_type {
+	TRACE_FLAG_IRQS_OFF		= 0x01,
+	TRACE_FLAG_NEED_RESCHED		= 0x02,
+	TRACE_FLAG_HARDIRQ		= 0x04,
+	TRACE_FLAG_SOFTIRQ		= 0x08,
+};
+
 static inline notrace void
 mctracer_add_trace_entry(struct mctracer_trace *tr,
 			 int cpu,
 			 const unsigned long ip,
-			 const unsigned long parent_ip)
+			 const unsigned long parent_ip,
+			 unsigned long flags)
 {
 	unsigned long idx, idx_next;
 	struct mctracer_entry *entry;
 	struct task_struct *tsk = current;
 	struct mctracer_trace_cpu *data = tr->data[cpu];
+	unsigned long pc;
 
 	idx = data->trace_idx;
 	idx_next = idx + 1;
@@ -59,11 +70,18 @@ mctracer_add_trace_entry(struct mctracer
 	if (unlikely(idx_next != 0 && atomic_read(&data->underrun)))
 		atomic_inc(&data->underrun);
 
+	pc = preempt_count();
+
 	entry = data->trace + idx * MCTRACER_ENTRY_SIZE;
+	entry->preempt_count = pc & 0xff;
 	entry->ip	 = ip;
 	entry->parent_ip = parent_ip;
 	entry->pid	 = tsk->pid;
 	entry->t	 = now();
+	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
+		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
+		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
+		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
 	memcpy(entry->comm, tsk->comm, TASK_COMM_LEN);
 }
 
@@ -84,7 +102,7 @@ static notrace void trace_function(const
 
 	atomic_inc(&tr->data[cpu]->disabled);
 	if (likely(atomic_read(&tr->data[cpu]->disabled) == 1))
-		mctracer_add_trace_entry(tr, cpu, ip, parent_ip);
+		mctracer_add_trace_entry(tr, cpu, ip, parent_ip, flags);
 
 	atomic_dec(&tr->data[cpu]->disabled);
 
@@ -101,6 +119,11 @@ static notrace void mctracer_reset(struc
 {
 	int cpu;
 
+	tr->time_start = now();
+	tr->saved_latency = 0;
+	tr->critical_start = 0;
+	tr->critical_end = 0;
+
 	for_each_online_cpu(cpu) {
 		tr->data[cpu]->trace_idx = 0;
 		atomic_set(&tr->data[cpu]->underrun, 0);
@@ -110,11 +133,24 @@ static notrace void mctracer_reset(struc
 #ifdef CONFIG_DEBUG_FS
 enum trace_iterator {
 	TRACE_ITER_SYM_ONLY	= 1,
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
+enum trace_file_type {
+	TRACE_FILE_LAT_FMT	= 1,
 };
 
 struct mctracer_iterator {
 	struct mctracer_trace *tr;
 	struct mctracer_entry *ent;
+	unsigned long iter_flags;
 	loff_t pos;
 	unsigned long next_idx[NR_CPUS];
 	int cpu;
@@ -140,37 +176,53 @@ static struct mctracer_entry *mctracer_e
 	return &array[idx];
 }
 
-static void *find_next_entry(struct mctracer_iterator *iter)
+static struct notrace mctracer_entry *
+find_next_entry(struct mctracer_iterator *iter, int *ent_cpu)
 {
 	struct mctracer_trace *tr = iter->tr;
-	struct mctracer_entry *ent;
-	struct mctracer_entry *next = NULL;
-	int next_i = -1;
-	int i;
+	struct mctracer_entry *ent, *next = NULL;
+	int next_cpu = -1;
+	int cpu;
 
-	for_each_possible_cpu(i) {
-		if (!tr->data[i]->trace)
+	for_each_possible_cpu(cpu) {
+		if (!tr->data[cpu]->trace)
 			continue;
-		ent = mctracer_entry_idx(tr, iter->next_idx[i], i);
+		ent = mctracer_entry_idx(tr, iter->next_idx[cpu], cpu);
 		if (ent && (!next || next->t > ent->t)) {
 			next = ent;
-			next_i = i;
+			next_cpu = cpu;
 		}
 	}
+
+	if (ent_cpu)
+		*ent_cpu = next_cpu;
+
+	return next;
+}
+
+static void *find_next_entry_inc(struct mctracer_iterator *iter)
+{
+	struct mctracer_entry *next;
+	int next_cpu = -1;
+
+	next = find_next_entry(iter, &next_cpu);
+
 	if (next) {
-		iter->next_idx[next_i]++;
+		iter->next_idx[next_cpu]++;
 		iter->idx++;
 	}
 	iter->ent = next;
-	iter->cpu = next_i;
+	iter->cpu = next_cpu;
 
 	return next ? iter : NULL;
 }
 
-static void *s_next(struct seq_file *m, void *v, loff_t *pos)
+static void notrace *
+s_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct mctracer_iterator *iter = m->private;
 	void *ent;
+	void *last_ent = iter->ent;
 	int i = (int)*pos;
 
 	(*pos)++;
@@ -180,15 +232,18 @@ static void *s_next(struct seq_file *m, 
 		return NULL;
 
 	if (iter->idx < 0)
-		ent = find_next_entry(iter);
+		ent = find_next_entry_inc(iter);
 	else
 		ent = iter;
 
 	while (ent && iter->idx < i)
-		ent = find_next_entry(iter);
+		ent = find_next_entry_inc(iter);
 
 	iter->pos = *pos;
 
+	if (last_ent && !ent)
+		seq_puts(m, "\n\nvim:ft=help\n");
+
 	return ent;
 }
 
@@ -249,40 +304,239 @@ static void seq_print_symbol(struct seq_
 #endif
 
 static void notrace seq_print_ip_sym(struct seq_file *m,
-				     unsigned long ip,
-				     int sym_only)
+				     unsigned long ip, int sym_only)
 {
+	if (!ip) {
+		seq_printf(m, "0");
+		return;
+	}
+
 	seq_print_symbol(m, "%s", ip);
 	if (!sym_only)
 		seq_printf(m, " <" IP_FMT ">", ip);
 }
 
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
+				       struct mctracer_iterator *iter)
+{
+	struct mctracer_trace *tr = iter->tr;
+	unsigned long underruns = 0;
+	unsigned long underrun;
+	unsigned long entries   = 0;
+	int sym_only = !!(tr->iter_flags & TRACE_ITER_SYM_ONLY);
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
+		   cycles_to_usecs(tr->saved_latency),
+		   entries,
+		   (entries + underruns),
+		   smp_processor_id(),
+#if defined(CONFIG_PREEMPT_NONE)
+		   "server",
+#elif defined(CONFIG_PREEMPT_VOLUNTARY)
+		   "desktop",
+#elif defined(CONFIG_PREEMPT_DESKTOP)
+		   "preempt",
+#else
+		   "rt",
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
+		   tr->comm, tr->pid, tr->uid, tr->nice,
+		   tr->policy, tr->rt_priority);
+	seq_puts(m, "    -----------------\n");
+
+	if (tr->critical_start) {
+		seq_puts(m, " => started at: ");
+		seq_print_ip_sym(m, tr->critical_start, sym_only);
+		seq_puts(m, "\n => ended at:   ");
+		seq_print_ip_sym(m, tr->critical_end, sym_only);
+		seq_puts(m, "\n");
+	}
+
+	seq_puts(m, "\n");
+}
+
+
+static void notrace
+lat_print_generic(struct seq_file *m, struct mctracer_entry *entry, int cpu)
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
+		seq_printf(m, "%lx", entry->preempt_count);
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
+print_lat_fmt(struct seq_file *m, struct mctracer_iterator *iter,
+	      unsigned int trace_idx, int cpu)
+{
+	struct mctracer_entry *entry = iter->ent;
+	struct mctracer_entry *next_entry = find_next_entry(iter, NULL);
+	unsigned long abs_usecs;
+	unsigned long rel_usecs;
+	int sym_only = !!(iter->tr->iter_flags & TRACE_ITER_SYM_ONLY);
+	int verbose = !!(iter->tr->iter_flags & TRACE_ITER_VERBOSE);
+
+	if (!next_entry)
+		next_entry = entry;
+	rel_usecs = cycles_to_usecs(next_entry->t - entry->t);
+	abs_usecs = cycles_to_usecs(entry->t - iter->tr->time_start);
+
+	if (verbose) {
+		seq_printf(m, "%16s %5d %d %ld %08lx %08x [%08lx]"
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
+	seq_print_ip_sym(m, entry->ip, sym_only);
+	seq_puts(m, " (");
+	seq_print_ip_sym(m, entry->parent_ip, sym_only);
+	seq_puts(m, ")\n");
+}
+
+static void notrace print_trace_fmt(struct seq_file *m,
+				    struct mctracer_iterator *iter)
+{
+	unsigned long usec_rem;
+	unsigned long secs;
+	int sym_only = !!(iter->tr->iter_flags & TRACE_ITER_SYM_ONLY);
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
+	seq_print_ip_sym(m, iter->ent->ip, sym_only);
+	if (iter->ent->parent_ip) {
+		seq_printf(m, " <-- ");
+		seq_print_ip_sym(m, iter->ent->parent_ip,
+				 sym_only);
+	}
+	seq_printf(m, "\n");
+}
+
+static int trace_empty(struct mctracer_iterator *iter)
+{
+	struct mctracer_trace_cpu *data;
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
 static int s_show(struct seq_file *m, void *v)
 {
 	struct mctracer_iterator *iter = v;
-	int sym_only = !!(iter->tr->iter_flags & TRACE_ITER_SYM_ONLY);
 
 	if (iter->ent == NULL) {
-		seq_printf(m, "mctracer:\n");
+		if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
+			/* print nothing if the buffers are empty */
+			if (trace_empty(iter))
+				return 0;
+			print_trace_header(m, iter);
+			if (!(iter->tr->iter_flags & TRACE_ITER_VERBOSE))
+				print_help_header(m);
+		} else
+			seq_printf(m, "mctracer:\n");
 	} else {
-		unsigned long long t;
-		unsigned long usec_rem;
-		unsigned long secs;
-
-		t = cycles_to_usecs(iter->ent->t);
-		usec_rem = do_div(t, 1000000ULL);
-		secs = (unsigned long)t;
-
-		seq_printf(m, "[%5lu.%06lu] ", secs, usec_rem);
-		seq_printf(m, "CPU %d: ", iter->cpu);
-		seq_printf(m, "%s:%d ", iter->ent->comm, iter->ent->pid);
-		seq_print_ip_sym(m, iter->ent->ip, sym_only);
-		if (iter->ent->parent_ip) {
-			seq_printf(m, " <-- ");
-			seq_print_ip_sym(m, iter->ent->parent_ip,
-					 sym_only);
-		}
-		seq_printf(m, "\n");
+		if (iter->iter_flags & TRACE_FILE_LAT_FMT)
+			print_lat_fmt(m, iter, iter->idx, iter->cpu);
+		else
+			print_trace_fmt(m, iter);
 	}
 
 	return 0;
@@ -295,25 +549,52 @@ static struct seq_operations mctrace_seq
 	.show = s_show,
 };
 
-static int mctrace_open(struct inode *inode, struct file *file)
+static struct mctracer_iterator *
+__mctrace_open(struct inode *inode, struct file *file, int *ret)
 {
 	struct mctracer_iterator *iter;
-	int ret;
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return -ENOMEM;
+	if (!iter) {
+		*ret = -ENOMEM;
+		goto out;
+	}
 
 	iter->tr = &mctracer_trace;
 	iter->pos = -1;
 
 	/* TODO stop tracer */
-	ret = seq_open(file, &mctrace_seq_ops);
-	if (!ret) {
+	*ret = seq_open(file, &mctrace_seq_ops);
+	if (!*ret) {
 		struct seq_file *m = file->private_data;
 		m->private = iter;
-	} else
+	} else {
 		kfree(iter);
+		iter = NULL;
+	}
+
+ out:
+	return iter;
+}
+
+static int mctrace_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	__mctrace_open(inode, file, &ret);
+
+	return ret;
+}
+
+static int mctrace_lt_open(struct inode *inode, struct file *file)
+{
+	struct mctracer_iterator *iter;
+	int ret;
+
+	iter = __mctrace_open(inode, file, &ret);
+
+	if (!ret)
+		iter->iter_flags |= TRACE_FILE_LAT_FMT;
 
 	return ret;
 }
@@ -335,6 +616,13 @@ static struct file_operations mctrace_fo
 	.release = mctrace_release,
 };
 
+static struct file_operations mctrace_lt_fops = {
+	.open = mctrace_lt_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = mctrace_release,
+};
+
 static int mctracer_open_generic(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
@@ -375,6 +663,17 @@ static ssize_t mctracer_ctrl_write(struc
 	/* When starting a new trace, reset the buffers */
 	if (val)
 		mctracer_reset(tr);
+	else {
+		/* pretty meaningless for now */
+		tr->time_end = now();
+		tr->saved_latency = tr->time_end - tr->time_start;
+		memcpy(tr->comm, current->comm, TASK_COMM_LEN);
+		tr->pid = current->pid;
+		tr->uid = current->uid;
+		tr->nice = current->static_prio - 20 - MAX_RT_PRIO;
+		tr->policy = current->policy;
+		tr->rt_priority = current->rt_priority;
+	}
 
 	if (tr->ctrl ^ val) {
 		if (val)
@@ -399,15 +698,38 @@ static ssize_t mctracer_iter_ctrl_read(s
 				       size_t cnt, loff_t *ppos)
 {
 	struct mctracer_trace *tr = filp->private_data;
-	char buf[64];
+	char *buf;
 	int r = 0;
+	int i;
+	int len = 0;
 
-	if (tr->iter_flags & TRACE_ITER_SYM_ONLY)
-		r = sprintf(buf, "%s", "symonly ");
-	r += sprintf(buf+r, "\n");
+	/* calulate max size */
+	for (i = 0; trace_options[i]; i++) {
+		len += strlen(trace_options[i]);
+		len += 3; /* "no" and space */
+	}
 
-	return simple_read_from_buffer(ubuf, cnt, ppos,
-				       buf, r);
+	/* +2 for \n and \0 */
+	buf = kmalloc(len + 2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; trace_options[i]; i++) {
+		if (tr->iter_flags & (1 << i))
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
 }
 
 static ssize_t mctracer_iter_ctrl_write(struct file *filp,
@@ -416,6 +738,9 @@ static ssize_t mctracer_iter_ctrl_write(
 {
 	struct mctracer_trace *tr = filp->private_data;
 	char buf[64];
+	char *cmp = buf;
+	int neg = 0;
+	int i;
 
 	if (cnt > 63)
 		cnt = 63;
@@ -425,8 +750,22 @@ static ssize_t mctracer_iter_ctrl_write(
 
 	buf[cnt] = 0;
 
-	if (strncmp(buf, "symonly", 7) == 0)
-		tr->iter_flags |= TRACE_ITER_SYM_ONLY;
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
+				tr->iter_flags &= ~(1 << i);
+			else
+				tr->iter_flags |= (1 << i);
+			break;
+		}
+	}
 
 	filp->f_pos += cnt;
 
@@ -459,6 +798,12 @@ static void mctrace_init_debugfs(void)
 				    &mctracer_trace, &mctracer_iter_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'iter_ctrl' entry\n");
+
+	entry = debugfs_create_file("function_trace", 0444, d_mctracer,
+				    &mctracer_trace, &mctrace_lt_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'function_trace' entry\n");
+
 	entry = debugfs_create_file("trace", 0444, d_mctracer,
 				    &mctracer_trace, &mctrace_fops);
 	if (!entry)
Index: linux-compile.git/lib/tracing/tracer.h
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-15 15:03:02.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.h	2008-01-15 15:03:41.000000000 -0500
@@ -8,6 +8,8 @@ struct mctracer_entry {
 	unsigned long long t;
 	unsigned long ip;
 	unsigned long parent_ip;
+	unsigned long preempt_count;
+	unsigned long flags;
 	char comm[TASK_COMM_LEN];
 	pid_t pid;
 };
@@ -23,6 +25,17 @@ struct mctracer_trace {
 	unsigned long entries;
 	long	      ctrl;
 	unsigned long iter_flags;
+	char comm[TASK_COMM_LEN];
+	pid_t	      pid;
+	uid_t	      uid;
+	unsigned long nice;
+	unsigned long policy;
+	unsigned long rt_priority;
+	unsigned long saved_latency;
+	unsigned long critical_start;
+	unsigned long critical_end;
+	unsigned long long time_start;
+	unsigned long long time_end;
 	struct mctracer_trace_cpu *data[NR_CPUS];
 };
 

-- 
