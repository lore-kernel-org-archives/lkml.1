Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYAIXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYAIXiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbYAIXbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:31:20 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:33595 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbYAIXax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:53 -0500
Message-Id: <20080109233045.577396650@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:35 -0500
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
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 21/22 -v2] Split out specific tracing functions
Content-Disposition: inline; filename=mctracer-splitout.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several different types of tracing needs to use the
same core functions. This patch separates the core
functions from more specific onecs to allow for
future tracing methods.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/Kconfig            |    6 
 lib/tracing/Makefile           |    3 
 lib/tracing/trace_function.c   |  211 ++++++++++++++++++
 lib/tracing/tracer.c           |  457 ++++++++++++++---------------------------
 lib/tracing/tracer.h           |   55 ++++
 lib/tracing/tracer_interface.h |   14 -
 6 files changed, 430 insertions(+), 316 deletions(-)

Index: linux-compile-i386.git/lib/tracing/trace_function.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile-i386.git/lib/tracing/trace_function.c	2008-01-09 15:17:20.000000000 -0500
@@ -0,0 +1,211 @@
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
+static struct tracing_trace function_trace;
+static DEFINE_PER_CPU(struct tracing_trace_cpu, function_trace_cpu);
+
+static notrace void function_trace_reset(struct tracing_trace *tr)
+{
+	int cpu;
+
+	tr->time_start = now();
+	tr->saved_latency = 0;
+	tr->critical_start = 0;
+	tr->critical_end = 0;
+
+	for_each_online_cpu(cpu) {
+		tr->data[cpu]->trace_idx = 0;
+		atomic_set(&tr->data[cpu]->underrun, 0);
+	}
+}
+
+#ifdef CONFIG_DEBUG_FS
+static ssize_t function_trace_ctrl_read(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	struct tracing_trace *tr = filp->private_data;
+	char buf[16];
+	int r;
+
+	r = sprintf(buf, "%ld\n", tr->ctrl);
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       buf, r);
+}
+
+static void notrace function_trace_call(unsigned long ip,
+					unsigned long parent_ip)
+{
+	struct tracing_trace *tr = &function_trace;
+
+	tracing_function_trace(tr, ip, parent_ip);
+}
+
+static ssize_t function_trace_ctrl_write(struct file *filp,
+					 const char __user *ubuf,
+					 size_t cnt, loff_t *ppos)
+{
+	struct tracing_trace *tr = filp->private_data;
+	long val;
+	char buf[16];
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	val = !!simple_strtoul(buf, NULL, 10);
+
+	/* When starting a new trace, reset the buffers */
+	if (val)
+		function_trace_reset(tr);
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
+
+	if (tr->ctrl ^ val) {
+		if (val)
+			register_mcount_function(function_trace_call);
+		else
+			clear_mcount_function();
+		tr->ctrl = val;
+	}
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
+static struct file_operations function_trace_ctrl_fops = {
+	.open = tracing_open_generic,
+	.read = function_trace_ctrl_read,
+	.write = function_trace_ctrl_write,
+};
+
+static __init void function_trace_init_debugfs(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	entry = debugfs_create_file("fn_trace_ctrl", 0644, d_tracer,
+				    &function_trace, &function_trace_ctrl_fops);
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
+	register_mcount_function(trace_function);
+}
+#endif
+
+static void function_trace_open(struct tracing_iterator *iter)
+{
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl)
+		clear_mcount_function();
+}
+
+static void function_trace_close(struct tracing_iterator *iter)
+{
+	if (iter->tr->ctrl)
+		register_mcount_function(function_trace_call);
+}
+
+static notrace int page_order(const unsigned long size)
+{
+	const unsigned long nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
+	return ilog2(roundup_pow_of_two(nr_pages));
+}
+
+__init static int function_trace_alloc_buffers(void)
+{
+	const int order = page_order(TRACING_NR_ENTRIES * TRACING_ENTRY_SIZE);
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
+		size, TRACING_NR_ENTRIES);
+	pr_info(" entries of %d bytes\n", TRACING_ENTRY_SIZE);
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
+		if (function_trace.data[i] && function_trace.data[i]->trace) {
+			free_pages((unsigned long)function_trace.data[i]->trace,
+				   order);
+			function_trace.data[i]->trace = NULL;
+		}
+	}
+	return -ENOMEM;
+}
+
+device_initcall(function_trace_alloc_buffers);
Index: linux-compile-i386.git/lib/tracing/tracer.c
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.c	2008-01-09 14:49:52.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.c	2008-01-09 15:17:20.000000000 -0500
@@ -19,22 +19,21 @@
 #include <linux/percpu.h>
 #include <linux/debugfs.h>
 #include <linux/kallsyms.h>
-#include <linux/clocksource.h>
 #include <linux/utsrelease.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
 #include <linux/mcount.h>
 
 #include "tracer.h"
-#include "tracer_interface.h"
 
-static inline notrace cycle_t now(void)
+enum trace_type
 {
-	return get_monotonic_cycles();
-}
+	__TRACE_FIRST_TYPE = 0,
+
+	TRACE_FN,
 
-static struct mctracer_trace mctracer_trace;
-static DEFINE_PER_CPU(struct mctracer_trace_cpu, mctracer_trace_cpu);
+	__TRACE_LAST_TYPE
+};
 
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
@@ -45,18 +44,12 @@ enum trace_flag_type {
 	TRACE_FLAG_IRQS_HARD_OFF	= 0x20,
 };
 
-static inline notrace void
-mctracer_add_trace_entry(struct mctracer_trace *tr,
-			 int cpu,
-			 const unsigned long ip,
-			 const unsigned long parent_ip,
-			 unsigned long flags)
+static inline notrace struct tracing_entry *
+tracing_get_trace_entry(struct tracing_trace *tr,
+			struct tracing_trace_cpu *data)
 {
 	unsigned long idx, idx_next;
-	struct mctracer_entry *entry;
-	struct task_struct *tsk = current;
-	struct mctracer_trace_cpu *data = tr->data[cpu];
-	unsigned long pc;
+	struct tracing_entry *entry;
 
 	idx = data->trace_idx;
 	idx_next = idx + 1;
@@ -71,12 +64,21 @@ mctracer_add_trace_entry(struct mctracer
 	if (unlikely(idx_next != 0 && atomic_read(&data->underrun)))
 		atomic_inc(&data->underrun);
 
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
 	pc = preempt_count();
 
-	entry = data->trace + idx * MCTRACER_ENTRY_SIZE;
 	entry->preempt_count = pc & 0xff;
-	entry->ip	 = ip;
-	entry->parent_ip = parent_ip;
 	entry->pid	 = tsk->pid;
 	entry->t	 = now();
 	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
@@ -86,42 +88,33 @@ mctracer_add_trace_entry(struct mctracer
 	memcpy(entry->comm, tsk->comm, TASK_COMM_LEN);
 }
 
-static notrace void trace_function(const unsigned long ip,
-				   const unsigned long parent_ip)
+notrace void tracing_function_trace(struct tracing_trace *tr,
+				    unsigned long ip,
+				    unsigned long parent_ip)
 {
 	unsigned long flags;
-	struct mctracer_trace *tr;
 	int cpu;
 
 	raw_local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 
-	tr = &mctracer_trace;
-
 	atomic_inc(&tr->data[cpu]->disabled);
-	if (likely(atomic_read(&tr->data[cpu]->disabled) == 1))
-		mctracer_add_trace_entry(tr, cpu, ip, parent_ip, flags);
+	if (likely(atomic_read(&tr->data[cpu]->disabled) == 1)) {
+		struct tracing_entry *entry;
+		struct tracing_trace_cpu *data = tr->data[cpu];
+
+		entry = tracing_get_trace_entry(tr, data);
+		tracing_generic_entry_update(entry, flags);
+		entry->type	    = TRACE_FN;
+		entry->fn.ip	    = ip;
+		entry->fn.parent_ip = parent_ip;
+	}
 
 	atomic_dec(&tr->data[cpu]->disabled);
 
 	raw_local_irq_restore(flags);
 }
 
-static notrace void mctracer_reset(struct mctracer_trace *tr)
-{
-	int cpu;
-
-	tr->time_start = now();
-	tr->saved_latency = 0;
-	tr->critical_start = 0;
-	tr->critical_end = 0;
-
-	for_each_online_cpu(cpu) {
-		tr->data[cpu]->trace_idx = 0;
-		atomic_set(&tr->data[cpu]->underrun, 0);
-	}
-}
-
 #ifdef CONFIG_DEBUG_FS
 enum trace_iterator {
 	TRACE_ITER_SYM_ONLY	= 1,
@@ -135,25 +128,17 @@ static const char *trace_options[] = {
 	NULL
 };
 
+static unsigned trace_flags;
+
 enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 };
 
-struct mctracer_iterator {
-	struct mctracer_trace *tr;
-	struct mctracer_entry *ent;
-	unsigned long iter_flags;
-	loff_t pos;
-	unsigned long next_idx[NR_CPUS];
-	int cpu;
-	int idx;
-};
-
-static struct mctracer_entry *mctracer_entry_idx(struct mctracer_trace *tr,
-						 unsigned long idx,
-						 int cpu)
+static struct tracing_entry *tracing_entry_idx(struct tracing_trace *tr,
+					       unsigned long idx,
+					       int cpu)
 {
-	struct mctracer_entry *array = tr->data[cpu]->trace;
+	struct tracing_entry *array = tr->data[cpu]->trace;
 	unsigned long underrun;
 
 	if (idx >= tr->entries)
@@ -168,18 +153,18 @@ static struct mctracer_entry *mctracer_e
 	return &array[idx];
 }
 
-static struct notrace mctracer_entry *
-find_next_entry(struct mctracer_iterator *iter, int *ent_cpu)
+static struct notrace tracing_entry *
+find_next_entry(struct tracing_iterator *iter, int *ent_cpu)
 {
-	struct mctracer_trace *tr = iter->tr;
-	struct mctracer_entry *ent, *next = NULL;
+	struct tracing_trace *tr = iter->tr;
+	struct tracing_entry *ent, *next = NULL;
 	int next_cpu = -1;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		if (!tr->data[cpu]->trace)
 			continue;
-		ent = mctracer_entry_idx(tr, iter->next_idx[cpu], cpu);
+		ent = tracing_entry_idx(tr, iter->next_idx[cpu], cpu);
 		if (ent && (!next || next->t > ent->t)) {
 			next = ent;
 			next_cpu = cpu;
@@ -192,9 +177,9 @@ find_next_entry(struct mctracer_iterator
 	return next;
 }
 
-static void *find_next_entry_inc(struct mctracer_iterator *iter)
+static void *find_next_entry_inc(struct tracing_iterator *iter)
 {
-	struct mctracer_entry *next;
+	struct tracing_entry *next;
 	int next_cpu = -1;
 
 	next = find_next_entry(iter, &next_cpu);
@@ -212,7 +197,7 @@ static void *find_next_entry_inc(struct 
 static void notrace *
 s_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct mctracer_iterator *iter = m->private;
+	struct tracing_iterator *iter = m->private;
 	void *ent;
 	void *last_ent = iter->ent;
 	int i = (int)*pos;
@@ -241,15 +226,11 @@ s_next(struct seq_file *m, void *v, loff
 
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
-	struct mctracer_iterator *iter = m->private;
+	struct tracing_iterator *iter = m->private;
 	void *p = NULL;
 	loff_t l = 0;
 	int i;
 
-	/* stop the trace while dumping */
-	if (iter->tr->ctrl)
-		clear_mcount_function();
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -271,9 +252,6 @@ static void *s_start(struct seq_file *m,
 
 static void s_stop(struct seq_file *m, void *p)
 {
-	struct mctracer_iterator *iter = m->private;
-	if (iter->tr->ctrl)
-		register_mcount_function(trace_function);
 }
 
 #ifdef CONFIG_KALLSYMS
@@ -322,13 +300,13 @@ static void notrace print_help_header(st
 }
 
 static void notrace print_trace_header(struct seq_file *m,
-				       struct mctracer_iterator *iter)
+				       struct tracing_iterator *iter)
 {
-	struct mctracer_trace *tr = iter->tr;
+	struct tracing_trace *tr = iter->tr;
 	unsigned long underruns = 0;
 	unsigned long underrun;
 	unsigned long entries   = 0;
-	int sym_only = !!(tr->iter_flags & TRACE_ITER_SYM_ONLY);
+	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -388,7 +366,7 @@ static void notrace print_trace_header(s
 
 
 static void notrace
-lat_print_generic(struct seq_file *m, struct mctracer_entry *entry, int cpu)
+lat_print_generic(struct seq_file *m, struct tracing_entry *entry, int cpu)
 {
 	int hardirq, softirq;
 
@@ -415,7 +393,7 @@ lat_print_generic(struct seq_file *m, st
 	}
 
 	if (entry->preempt_count)
-		seq_printf(m, "%lx", entry->preempt_count);
+		seq_printf(m, "%x", entry->preempt_count);
 	else
 		seq_puts(m, ".");
 }
@@ -436,15 +414,15 @@ lat_print_timestamp(struct seq_file *m, 
 }
 
 static void notrace
-print_lat_fmt(struct seq_file *m, struct mctracer_iterator *iter,
+print_lat_fmt(struct seq_file *m, struct tracing_iterator *iter,
 	      unsigned int trace_idx, int cpu)
 {
-	struct mctracer_entry *entry = iter->ent;
-	struct mctracer_entry *next_entry = find_next_entry(iter, NULL);
+	struct tracing_entry *entry = iter->ent;
+	struct tracing_entry *next_entry = find_next_entry(iter, NULL);
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
-	int sym_only = !!(iter->tr->iter_flags & TRACE_ITER_SYM_ONLY);
-	int verbose = !!(iter->tr->iter_flags & TRACE_ITER_VERBOSE);
+	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
+	int verbose = !!(trace_flags & TRACE_ITER_VERBOSE);
 
 	if (!next_entry)
 		next_entry = entry;
@@ -452,7 +430,7 @@ print_lat_fmt(struct seq_file *m, struct
 	abs_usecs = cycles_to_usecs(entry->t - iter->tr->time_start);
 
 	if (verbose) {
-		seq_printf(m, "%16s %5d %d %ld %08lx %08x [%08lx]"
+		seq_printf(m, "%16s %5d %d %d %08x %08x [%08lx]"
 			   " %ld.%03ldms (+%ld.%03ldms): ",
 			   entry->comm,
 			   entry->pid, cpu, entry->flags,
@@ -464,18 +442,22 @@ print_lat_fmt(struct seq_file *m, struct
 		lat_print_generic(m, entry, cpu);
 		lat_print_timestamp(m, abs_usecs, rel_usecs);
 	}
-	seq_print_ip_sym(m, entry->ip, sym_only);
-	seq_puts(m, " (");
-	seq_print_ip_sym(m, entry->parent_ip, sym_only);
-	seq_puts(m, ")\n");
+	switch (entry->type) {
+	case TRACE_FN:
+		seq_print_ip_sym(m, entry->fn.ip, sym_only);
+		seq_puts(m, " (");
+		seq_print_ip_sym(m, entry->fn.parent_ip, sym_only);
+		seq_puts(m, ")\n");
+		break;
+	}
 }
 
 static void notrace print_trace_fmt(struct seq_file *m,
-				    struct mctracer_iterator *iter)
+				    struct tracing_iterator *iter)
 {
 	unsigned long usec_rem;
 	unsigned long secs;
-	int sym_only = !!(iter->tr->iter_flags & TRACE_ITER_SYM_ONLY);
+	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	unsigned long long t;
 
 	t = cycles_to_usecs(iter->ent->t);
@@ -486,18 +468,22 @@ static void notrace print_trace_fmt(stru
 	seq_printf(m, "CPU %d: ", iter->cpu);
 	seq_printf(m, "%s:%d ", iter->ent->comm,
 		   iter->ent->pid);
-	seq_print_ip_sym(m, iter->ent->ip, sym_only);
-	if (iter->ent->parent_ip) {
-		seq_printf(m, " <-- ");
-		seq_print_ip_sym(m, iter->ent->parent_ip,
-				 sym_only);
+	switch (iter->ent->type) {
+	case TRACE_FN:
+		seq_print_ip_sym(m, iter->ent->fn.ip, sym_only);
+		if (iter->ent->fn.parent_ip) {
+			seq_printf(m, " <-- ");
+			seq_print_ip_sym(m, iter->ent->fn.parent_ip,
+					 sym_only);
+		}
+		break;
 	}
 	seq_printf(m, "\n");
 }
 
-static int trace_empty(struct mctracer_iterator *iter)
+static int trace_empty(struct tracing_iterator *iter)
 {
-	struct mctracer_trace_cpu *data;
+	struct tracing_trace_cpu *data;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -513,7 +499,7 @@ static int trace_empty(struct mctracer_i
 
 static int s_show(struct seq_file *m, void *v)
 {
-	struct mctracer_iterator *iter = v;
+	struct tracing_iterator *iter = v;
 
 	if (iter->ent == NULL) {
 		if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
@@ -521,10 +507,10 @@ static int s_show(struct seq_file *m, vo
 			if (trace_empty(iter))
 				return 0;
 			print_trace_header(m, iter);
-			if (!(iter->tr->iter_flags & TRACE_ITER_VERBOSE))
+			if (!(trace_flags & TRACE_ITER_VERBOSE))
 				print_help_header(m);
 		} else
-			seq_printf(m, "mctracer:\n");
+			seq_printf(m, "tracer:\n");
 	} else {
 		if (iter->iter_flags & TRACE_FILE_LAT_FMT)
 			print_lat_fmt(m, iter, iter->idx, iter->cpu);
@@ -535,17 +521,17 @@ static int s_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations mctrace_seq_ops = {
+static struct seq_operations tracer_seq_ops = {
 	.start = s_start,
 	.next = s_next,
 	.stop = s_stop,
 	.show = s_show,
 };
 
-static struct mctracer_iterator *
-__mctrace_open(struct inode *inode, struct file *file, int *ret)
+static struct tracing_iterator notrace *
+__tracing_open(struct inode *inode, struct file *file, int *ret)
 {
-	struct mctracer_iterator *iter;
+	struct tracing_iterator *iter;
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter) {
@@ -553,14 +539,21 @@ __mctrace_open(struct inode *inode, stru
 		goto out;
 	}
 
-	iter->tr = &mctracer_trace;
+	iter->tr = inode->i_private;
 	iter->pos = -1;
 
 	/* TODO stop tracer */
-	*ret = seq_open(file, &mctrace_seq_ops);
+	*ret = seq_open(file, &tracer_seq_ops);
 	if (!*ret) {
 		struct seq_file *m = file->private_data;
 		m->private = iter;
+
+		/*
+		 * Most tracers want to disable the
+		 * trace while printing a trace.
+		 */
+		if (iter->tr->open)
+			iter->tr->open(iter);
 	} else {
 		kfree(iter);
 		iter = NULL;
@@ -570,21 +563,40 @@ __mctrace_open(struct inode *inode, stru
 	return iter;
 }
 
-static int mctrace_open(struct inode *inode, struct file *file)
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
 {
 	int ret;
 
-	__mctrace_open(inode, file, &ret);
+	__tracing_open(inode, file, &ret);
 
 	return ret;
 }
 
-static int mctrace_lt_open(struct inode *inode, struct file *file)
+static int tracing_lt_open(struct inode *inode, struct file *file)
 {
-	struct mctracer_iterator *iter;
+	struct tracing_iterator *iter;
 	int ret;
 
-	iter = __mctrace_open(inode, file, &ret);
+	iter = __tracing_open(inode, file, &ret);
 
 	if (!ret)
 		iter->iter_flags |= TRACE_FILE_LAT_FMT;
@@ -592,105 +604,23 @@ static int mctrace_lt_open(struct inode 
 	return ret;
 }
 
-int mctrace_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = (struct seq_file *)file->private_data;
-	struct mctracer_iterator *iter = m->private;
-
-	seq_release(inode, file);
-	kfree(iter);
-	return 0;
-}
-
-static struct file_operations mctrace_fops = {
-	.open = mctrace_open,
+struct file_operations tracing_fops = {
+	.open = tracing_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = mctrace_release,
+	.release = tracing_release,
 };
 
-static struct file_operations mctrace_lt_fops = {
-	.open = mctrace_lt_open,
+struct file_operations tracing_lt_fops = {
+	.open = tracing_lt_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = mctrace_release,
+	.release = tracing_release,
 };
 
-static int mctracer_open_generic(struct inode *inode, struct file *filp)
+static ssize_t tracing_iter_ctrl_read(struct file *filp, char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
 {
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
-
-static ssize_t mctracer_ctrl_read(struct file *filp, char __user *ubuf,
-				  size_t cnt, loff_t *ppos)
-{
-	struct mctracer_trace *tr = filp->private_data;
-	char buf[16];
-	int r;
-
-	r = sprintf(buf, "%ld\n", tr->ctrl);
-	return simple_read_from_buffer(ubuf, cnt, ppos,
-				       buf, r);
-}
-
-static ssize_t mctracer_ctrl_write(struct file *filp,
-				   const char __user *ubuf,
-				   size_t cnt, loff_t *ppos)
-{
-	struct mctracer_trace *tr = filp->private_data;
-	long val;
-	char buf[16];
-
-	if (cnt > 15)
-		cnt = 15;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	val = !!simple_strtoul(buf, NULL, 10);
-
-	/* When starting a new trace, reset the buffers */
-	if (val)
-		mctracer_reset(tr);
-	else {
-		/* pretty meaningless for now */
-		tr->time_end = now();
-		tr->saved_latency = tr->time_end - tr->time_start;
-		memcpy(tr->comm, current->comm, TASK_COMM_LEN);
-		tr->pid = current->pid;
-		tr->uid = current->uid;
-		tr->nice = current->static_prio - 20 - MAX_RT_PRIO;
-		tr->policy = current->policy;
-		tr->rt_priority = current->rt_priority;
-	}
-
-	if (tr->ctrl ^ val) {
-		if (val)
-			register_mcount_function(trace_function);
-		else
-			clear_mcount_function();
-		tr->ctrl = val;
-	}
-
-	filp->f_pos += cnt;
-
-	return cnt;
-}
-
-static struct file_operations mctracer_ctrl_fops = {
-	.open = mctracer_open_generic,
-	.read = mctracer_ctrl_read,
-	.write = mctracer_ctrl_write,
-};
-
-static ssize_t mctracer_iter_ctrl_read(struct file *filp, char __user *ubuf,
-				       size_t cnt, loff_t *ppos)
-{
-	struct mctracer_trace *tr = filp->private_data;
 	char *buf;
 	int r = 0;
 	int i;
@@ -708,7 +638,7 @@ static ssize_t mctracer_iter_ctrl_read(s
 		return -ENOMEM;
 
 	for (i = 0; trace_options[i]; i++) {
-		if (tr->iter_flags & (1 << i))
+		if (trace_flags & (1 << i))
 			r += sprintf(buf + r, "%s ", trace_options[i]);
 		else
 			r += sprintf(buf + r, "no%s ", trace_options[i]);
@@ -725,11 +655,10 @@ static ssize_t mctracer_iter_ctrl_read(s
 	return r;
 }
 
-static ssize_t mctracer_iter_ctrl_write(struct file *filp,
-					const char __user *ubuf,
-					size_t cnt, loff_t *ppos)
+static ssize_t tracing_iter_ctrl_write(struct file *filp,
+				       const char __user *ubuf,
+				       size_t cnt, loff_t *ppos)
 {
-	struct mctracer_trace *tr = filp->private_data;
 	char buf[64];
 	char *cmp = buf;
 	int neg = 0;
@@ -753,9 +682,9 @@ static ssize_t mctracer_iter_ctrl_write(
 
 		if (strncmp(cmp, trace_options[i], len) == 0) {
 			if (neg)
-				tr->iter_flags &= ~(1 << i);
+				trace_flags &= ~(1 << i);
 			else
-				tr->iter_flags |= (1 << i);
+				trace_flags |= (1 << i);
 			break;
 		}
 	}
@@ -765,103 +694,49 @@ static ssize_t mctracer_iter_ctrl_write(
 	return cnt;
 }
 
-static struct file_operations mctracer_iter_fops = {
-	.open = mctracer_open_generic,
-	.read = mctracer_iter_ctrl_read,
-	.write = mctracer_iter_ctrl_write,
+static struct file_operations tracing_iter_fops = {
+	.open = tracing_open_generic,
+	.read = tracing_iter_ctrl_read,
+	.write = tracing_iter_ctrl_write,
 };
 
-static void mctrace_init_debugfs(void)
-{
-	struct dentry *d_mctracer;
-	struct dentry *entry;
+static struct dentry *d_tracer;
 
-	d_mctracer = debugfs_create_dir("tracing", NULL);
-	if (!d_mctracer) {
-		pr_warning("Could not create debugfs directory mctracer\n");
-		return;
-	}
-
-	entry = debugfs_create_file("ctrl", 0644, d_mctracer,
-				    &mctracer_trace, &mctracer_ctrl_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'ctrl' entry\n");
+struct dentry *tracing_init_dentry(void)
+{
+	static int once;
 
-	entry = debugfs_create_file("iter_ctrl", 0644, d_mctracer,
-				    &mctracer_trace, &mctracer_iter_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'iter_ctrl' entry\n");
+	if (d_tracer)
+		return d_tracer;
 
-	entry = debugfs_create_file("function_trace", 0444, d_mctracer,
-				    &mctracer_trace, &mctrace_lt_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'function_trace' entry\n");
+	d_tracer = debugfs_create_dir("tracing", NULL);
 
-	entry = debugfs_create_file("trace", 0444, d_mctracer,
-				    &mctracer_trace, &mctrace_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
+	if (!d_tracer && !once) {
+		once = 1;
+		pr_warning("Could not create debugfs directory 'tracing'\n");
+		return NULL;
+	}
 
+	return d_tracer;
 }
-#else /* CONFIG_DEBUG_FS */
-static void mctrace_init_debugfs(void)
-{
-	/*
-	 * No way to turn on or off the trace function
-	 * without debugfs, so we just turn it on.
-	 */
-	register_mcount_function(trace_function);
-}
-#endif /* CONFIG_DEBUG_FS */
 
-static notrace int page_order(const unsigned long size)
+static __init int trace_init_debugfs(void)
 {
-	const unsigned long nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
-	return ilog2(roundup_pow_of_two(nr_pages));
-}
-
-static notrace int mctracer_alloc_buffers(void)
-{
-	const int order = page_order(MCTRACER_NR_ENTRIES * MCTRACER_ENTRY_SIZE);
-	const unsigned long size = (1UL << order) << PAGE_SHIFT;
-	struct mctracer_entry *array;
-	int i;
-
-	for_each_possible_cpu(i) {
-		mctracer_trace.data[i] = &per_cpu(mctracer_trace_cpu, i);
-		array = (struct mctracer_entry *)
-			  __get_free_pages(GFP_KERNEL, order);
-		if (array == NULL) {
-			printk(KERN_ERR "mctracer: failed to allocate"
-			       " %ld bytes for trace buffer!\n", size);
-			goto free_buffers;
-		}
-		mctracer_trace.data[i]->trace = array;
-	}
-
-	/*
-	 * Since we allocate by orders of pages, we may be able to
-	 * round up a bit.
-	 */
-	mctracer_trace.entries = size / MCTRACER_ENTRY_SIZE;
+	struct dentry *d_tracer;
+	struct dentry *entry;
 
-	pr_info("mctracer: %ld bytes allocated for %ld entries of %d bytes\n",
-		size, MCTRACER_NR_ENTRIES, MCTRACER_ENTRY_SIZE);
-	pr_info("   actual entries %ld\n", mctracer_trace.entries);
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
-	mctrace_init_debugfs();
+	entry = debugfs_create_file("iter_ctrl", 0644, d_tracer,
+				    NULL, &tracing_iter_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'iter_ctrl' entry\n");
 
 	return 0;
-
- free_buffers:
-	for (i-- ; i >= 0; i--) {
-		if (mctracer_trace.data[i] && mctracer_trace.data[i]->trace) {
-			free_pages((unsigned long)mctracer_trace.data[i]->trace,
-				   order);
-			mctracer_trace.data[i]->trace = NULL;
-		}
-	}
-	return -ENOMEM;
 }
 
-device_initcall(mctracer_alloc_buffers);
+device_initcall(trace_init_debugfs);
+
+#endif /* CONFIG_DEBUG_FS */
Index: linux-compile-i386.git/lib/tracing/tracer.h
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.h	2008-01-09 14:49:52.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.h	2008-01-09 15:17:20.000000000 -0500
@@ -3,28 +3,36 @@
 
 #include <asm/atomic.h>
 #include <linux/sched.h>
+#include <linux/clocksource.h>
 
-struct mctracer_entry {
-	unsigned long long t;
+struct tracing_function {
 	unsigned long ip;
 	unsigned long parent_ip;
-	unsigned long preempt_count;
-	unsigned long flags;
+};
+
+struct tracing_entry {
+	char type;
+	char cpu;  /* who will want to trace more than 256 CPUS? */
+	char flags;
+	char preempt_count; /* assumes PREEMPT_MASK is 8 bits or less */
+	int pid;
+	cycle_t t;
 	char comm[TASK_COMM_LEN];
-	pid_t pid;
+	struct tracing_function fn;
 };
 
-struct mctracer_trace_cpu {
+struct tracing_trace_cpu {
 	void *trace;
 	unsigned long trace_idx;
 	atomic_t      disabled;
 	atomic_t      underrun;
 };
 
-struct mctracer_trace {
+struct tracing_iterator;
+
+struct tracing_trace {
 	unsigned long entries;
 	long	      ctrl;
-	unsigned long iter_flags;
 	char comm[TASK_COMM_LEN];
 	pid_t	      pid;
 	uid_t	      uid;
@@ -36,7 +44,36 @@ struct mctracer_trace {
 	unsigned long critical_end;
 	unsigned long long time_start;
 	unsigned long long time_end;
-	struct mctracer_trace_cpu *data[NR_CPUS];
+	void (*open)(struct tracing_iterator *iter);
+	void (*close)(struct tracing_iterator *iter);
+	struct tracing_trace_cpu *data[NR_CPUS];
 };
 
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
+#define TRACING_NR_ENTRIES (65536UL)
+
+int tracing_open_generic(struct inode *inode, struct file *filp);
+struct dentry *tracing_init_dentry(void);
+void tracing_function_trace(struct tracing_trace *tr,
+			    unsigned long ip,
+			    unsigned long parent_ip);
+
+extern struct file_operations tracing_fops;
+extern struct file_operations tracing_lt_fops;
+
+static inline notrace cycle_t now(void)
+{
+	return get_monotonic_cycles();
+}
+
 #endif /* _LINUX_MCOUNT_TRACER_H */
Index: linux-compile-i386.git/lib/tracing/Kconfig
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/Kconfig	2008-01-09 14:49:52.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/Kconfig	2008-01-09 15:17:20.000000000 -0500
@@ -6,12 +6,16 @@ config MCOUNT
 	depends on DEBUG_KERNEL
 	select FRAME_POINTER
 
+config TRACING
+        bool
+	depends on DEBUG_KERNEL
 
-config MCOUNT_TRACER
+config FUNCTION_TRACER
 	bool "Profiler instrumentation based tracer"
 	depends on DEBUG_KERNEL && ARCH_HAS_MCOUNT
 	default n
 	select MCOUNT
+	select TRACING
 	help
 	  Use profiler instrumentation, adding -pg to CFLAGS. This will
 	  insert a call to an architecture specific __mcount routine,
Index: linux-compile-i386.git/lib/tracing/Makefile
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/Makefile	2008-01-09 14:49:52.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/Makefile	2008-01-09 15:17:20.000000000 -0500
@@ -1,5 +1,6 @@
 obj-$(CONFIG_MCOUNT) += libmcount.o
 
-obj-$(CONFIG_MCOUNT_TRACER) += tracer.o
+obj-$(CONFIG_TRACING) += tracer.o
+obj-$(CONFIG_FUNCTION_TRACER) += trace_function.o
 
 libmcount-y := mcount.o
Index: linux-compile-i386.git/lib/tracing/tracer_interface.h
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer_interface.h	2008-01-09 14:49:52.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,14 +0,0 @@
-#ifndef _LINUX_MCTRACER_INTERFACE_H
-#define _LINUX_MCTRACER_INTERFACE_H
-
-#include "tracer.h"
-
-/*
- * Will be at least sizeof(struct mctracer_entry), but callers can request more
- * space for private stuff, such as a timestamp, preempt_count, etc.
- */
-#define MCTRACER_ENTRY_SIZE sizeof(struct mctracer_entry)
-
-#define MCTRACER_NR_ENTRIES (65536UL)
-
-#endif /* _LINUX_MCTRACER_INTERFACE_H */

-- 
