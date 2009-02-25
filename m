Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbZBYGS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbZBYGS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZBYGSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:18:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:7815 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZBYGSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:18:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=HN0YIatVvLgMQGtpMLElqQwyz5UOHyMkwQgwGdTAl7xXdsz03odDQEx1tYWb9Kjfup
         O3G5xsy3fFeU8jE10ahx2ukmjZWbjiW8+FrO6kxL6xKua10djZK2naMwoTfO5XMA5965
         itUryeQbGLVoEezkFojWeSeZnhOzeMq0KH5D4=
Message-ID: <49a4e2c1.0508d00a.21e6.2eea@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Date: Wed, 25 Feb 2009 03:22:28 +0100
Subject: [PATCH 1/2] tracing/core: introduce per cpu tracing files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: split up tracing output per cpu

Currently, on the tracing debugfs directory, three files are available to the user
to let him extracting the trace output:

- trace is an iterator through the ring-buffer. It's a reader but not a consumer
  It doesn't block when no more traces are available.
- trace pretty similar to the former, except that it adds more informations such as
  prempt count, irq flag, ...
- trace_pipe is a reader and a consumer, it will also block waiting for traces if necessary (heh,
  yes it's a pipe).

The traces coming from different cpus are curretly mixed up inside these files. Sometimes it
messes up the informations, sometimes it's useful, depending on what does the tracer capture.

The tracing_cpumask file is useful to filter the output and select only the traces captured a custom
defined set of cpus. But still it is not enough powerful to extract at the same time one trace buffer
per cpu.

So this patch creates a new directory inside /debug/tracing (provided you have a debugfs mountpoint on /debug).
Inside this directory, you will now find one trace_pipe file, one trace file and one latency_trace file
per cpu.
Which means if you have two cpus, you will have:

latency_trace0
latency_trace1
trace0
trace1
trace_pipe0
trace_pipe1

And of course, reading these files will have the same effect than with the usual tracing files, except that
you will only see the traces from the given cpu.
The original all-in-one cpu trace file are still available on their original place.

Until now, only one consumer was allowed on trace_pipe to avoid racy consuming on the ring-buffer.
Now the approach changed a bit, you can have only one consumer per cpu.
Which means you are allowed to read concurrently trace_pipe0 and trace_pipe1
But you can't have two readers on trace_pipe0 or trace_pipe1.

Following the same logic, if there is one reader on the common trace_pipe, you can not have at the same time
another reader on trace_pipe0 or in trace_pipe1. Because in trace_pipe is already a consumer in all cpu buffers
in essence.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |  178 +++++++++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.h |    3 +
 2 files changed, 156 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 10173a0..48cb5f4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -98,6 +98,9 @@ static inline void ftrace_enable_cpu(void)
 
 static cpumask_var_t __read_mostly	tracing_buffer_mask;
 
+/* Define which cpu buffers are currently read in trace_pipe */
+static cpumask_var_t			tracing_reader_cpumask;
+
 #define for_each_tracing_cpu(cpu)	\
 	for_each_cpu(cpu, tracing_buffer_mask)
 
@@ -1195,10 +1198,24 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 {
 	struct ring_buffer *buffer = iter->tr->buffer;
 	struct trace_entry *ent, *next = NULL;
+	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
 	int cpu;
 
+	/*
+	 * If we are in a per_cpu trace file, don't bother by iterating over
+	 * all cpu and peek directly.
+	 */
+	if (cpu_file > TRACE_PIPE_ALL_CPU) {
+		if (ring_buffer_empty_cpu(buffer, cpu_file))
+			return NULL;
+		ent = peek_next_entry(iter, cpu_file, ent_ts);
+		if (ent_cpu)
+			*ent_cpu = cpu_file;
+
+		return ent;
+	}
+
 	for_each_tracing_cpu(cpu) {
 
 		if (ring_buffer_empty_cpu(buffer, cpu))
@@ -1279,6 +1296,7 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_iterator *iter = m->private;
+	int cpu_file = iter->cpu_file;
 	void *p = NULL;
 	loff_t l = 0;
 	int cpu;
@@ -1299,9 +1317,12 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 		ftrace_disable_cpu();
 
-		for_each_tracing_cpu(cpu) {
-			ring_buffer_iter_reset(iter->buffer_iter[cpu]);
-		}
+		if (cpu_file == TRACE_PIPE_ALL_CPU) {
+			for_each_tracing_cpu(cpu)
+				ring_buffer_iter_reset(iter->buffer_iter[cpu]);
+		} else
+			ring_buffer_iter_reset(iter->buffer_iter[cpu_file]);
+
 
 		ftrace_enable_cpu();
 
@@ -1653,6 +1674,7 @@ static struct seq_operations tracer_seq_ops = {
 static struct trace_iterator *
 __tracing_open(struct inode *inode, struct file *file, int *ret)
 {
+	long cpu_file = (long) inode->i_private;
 	struct trace_iterator *iter;
 	struct seq_file *m;
 	int cpu;
@@ -1672,9 +1694,10 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	if (current_trace && current_trace->print_max)
 		iter->tr = &max_tr;
 	else
-		iter->tr = inode->i_private;
+		iter->tr = &global_trace;
 	iter->trace = current_trace;
 	iter->pos = -1;
+	iter->cpu_file = cpu_file;
 
 	/* Notify the tracer early; before we stop tracing. */
 	if (iter->trace && iter->trace->open)
@@ -1684,14 +1707,22 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	if (ring_buffer_overruns(iter->tr->buffer))
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
+	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
+		for_each_tracing_cpu(cpu) {
 
-	for_each_tracing_cpu(cpu) {
+			iter->buffer_iter[cpu] =
+				ring_buffer_read_start(iter->tr->buffer, cpu);
 
+			if (!iter->buffer_iter[cpu])
+				goto fail_buffer;
+		}
+	} else {
+		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
-			ring_buffer_read_start(iter->tr->buffer, cpu);
+				ring_buffer_read_start(iter->tr->buffer, cpu);
 
 		if (!iter->buffer_iter[cpu])
-			goto fail_buffer;
+			goto fail;
 	}
 
 	/* TODO stop tracer */
@@ -1715,6 +1746,7 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 		if (iter->buffer_iter[cpu])
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
+fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter);
 
@@ -2325,54 +2357,77 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static atomic_t tracing_reader;
-
 static int tracing_open_pipe(struct inode *inode, struct file *filp)
 {
+	long cpu_file = (long) inode->i_private;
 	struct trace_iterator *iter;
+	int ret = 0;
 
 	if (tracing_disabled)
 		return -ENODEV;
 
-	/* We only allow for reader of the pipe */
-	if (atomic_inc_return(&tracing_reader) != 1) {
-		atomic_dec(&tracing_reader);
-		return -EBUSY;
+	mutex_lock(&trace_types_lock);
+
+	/* We only allow one reader per cpu */
+	if (cpu_file == TRACE_PIPE_ALL_CPU) {
+		if (!cpumask_empty(tracing_reader_cpumask)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		cpumask_setall(tracing_reader_cpumask);
+	} else {
+		if (!cpumask_test_cpu(cpu_file, tracing_reader_cpumask))
+			cpumask_set_cpu(cpu_file, tracing_reader_cpumask);
+		else {
+			ret = -EBUSY;
+			goto out;
+		}
 	}
 
 	/* create a buffer to store the information to pass to userspace */
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return -ENOMEM;
+	if (!iter) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
 		kfree(iter);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
-	mutex_lock(&trace_types_lock);
-
 	/* trace pipe does not show start of buffer */
 	cpumask_setall(iter->started);
 
+	iter->cpu_file = cpu_file;
 	iter->tr = &global_trace;
 	iter->trace = current_trace;
 	filp->private_data = iter;
 
 	if (iter->trace->pipe_open)
 		iter->trace->pipe_open(iter);
-	mutex_unlock(&trace_types_lock);
 
-	return 0;
+out:
+	mutex_unlock(&trace_types_lock);
+	return ret;
 }
 
 static int tracing_release_pipe(struct inode *inode, struct file *file)
 {
 	struct trace_iterator *iter = file->private_data;
 
+	mutex_lock(&trace_types_lock);
+
+	if (iter->cpu_file == TRACE_PIPE_ALL_CPU)
+		cpumask_clear(tracing_reader_cpumask);
+	else
+		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
+
+	mutex_unlock(&trace_types_lock);
+
 	free_cpumask_var(iter->started);
 	kfree(iter);
-	atomic_dec(&tracing_reader);
 
 	return 0;
 }
@@ -2911,6 +2966,68 @@ struct dentry *tracing_init_dentry(void)
 	return d_tracer;
 }
 
+static struct dentry *d_percpu;
+
+struct dentry *tracing_dentry_percpu(void)
+{
+	static int once;
+	struct dentry *d_tracer;
+
+	if (d_percpu)
+		return d_percpu;
+
+	d_tracer = tracing_init_dentry();
+
+	if (!d_tracer)
+		return NULL;
+
+	d_percpu = debugfs_create_dir("per_cpu", d_tracer);
+
+	if (!d_percpu && !once) {
+		once = 1;
+		pr_warning("Could not create debugfs directory 'per_cpu'\n");
+		return NULL;
+	}
+
+	return d_percpu;
+}
+
+static void tracing_init_debugfs_percpu(long cpu)
+{
+	struct dentry *d_percpu = tracing_dentry_percpu();
+	struct dentry *entry;
+	/* strlen(latency_trace) + MAX(log10(cpu)) + '\0' */
+	char filename[17];
+
+	if (cpu > 999 || cpu < 0)
+		return;
+
+	/* per cpu trace_pipe */
+	sprintf(filename, "trace_pipe%ld", cpu);
+
+	entry = debugfs_create_file(filename, 0444, d_percpu,
+				(void *) cpu, &tracing_pipe_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs '%s' entry\n", filename);
+
+	/* per cpu trace */
+	sprintf(filename, "trace%ld", cpu);
+
+	entry = debugfs_create_file(filename, 0444, d_percpu,
+				(void *) cpu, &tracing_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs '%s' entry\n", filename);
+
+
+	/* per cpu latency_trace */
+	sprintf(filename, "latency_trace%ld", cpu);
+
+	entry = debugfs_create_file(filename, 0444, d_percpu,
+				(void *) cpu, &tracing_lt_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs '%s' entry\n", filename);
+}
+
 #ifdef CONFIG_FTRACE_SELFTEST
 /* Let selftest have access to static functions in this file */
 #include "trace_selftest.c"
@@ -2920,6 +3037,7 @@ static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
 	struct dentry *entry;
+	int cpu;
 
 	d_tracer = tracing_init_dentry();
 
@@ -2939,12 +3057,12 @@ static __init int tracer_init_debugfs(void)
 		pr_warning("Could not create debugfs 'tracing_cpumask' entry\n");
 
 	entry = debugfs_create_file("latency_trace", 0444, d_tracer,
-				    &global_trace, &tracing_lt_fops);
+				(void *) TRACE_PIPE_ALL_CPU, &tracing_lt_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'latency_trace' entry\n");
 
 	entry = debugfs_create_file("trace", 0444, d_tracer,
-				    &global_trace, &tracing_fops);
+				 (void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'trace' entry\n");
 
@@ -2975,8 +3093,8 @@ static __init int tracer_init_debugfs(void)
 	if (!entry)
 		pr_warning("Could not create debugfs 'README' entry\n");
 
-	entry = debugfs_create_file("trace_pipe", 0644, d_tracer,
-				    NULL, &tracing_pipe_fops);
+	entry = debugfs_create_file("trace_pipe", 0444, d_tracer,
+			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'trace_pipe' entry\n");
@@ -3004,6 +3122,10 @@ static __init int tracer_init_debugfs(void)
 #ifdef CONFIG_SYSPROF_TRACER
 	init_tracer_sysprof_debugfs(d_tracer);
 #endif
+
+	for_each_tracing_cpu(cpu)
+		tracing_init_debugfs_percpu(cpu);
+
 	return 0;
 }
 
@@ -3299,8 +3421,12 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
 
+	if (!alloc_cpumask_var(&tracing_reader_cpumask, GFP_KERNEL))
+		goto out_free_tracing_cpumask;
+
 	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
 	cpumask_copy(tracing_cpumask, cpu_all_mask);
+	cpumask_clear(tracing_reader_cpumask);
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	global_trace.buffer = ring_buffer_alloc(trace_buf_size,
@@ -3349,6 +3475,8 @@ __init static int tracer_alloc_buffers(void)
 	ret = 0;
 
 out_free_cpumask:
+	free_cpumask_var(tracing_reader_cpumask);
+out_free_tracing_cpumask:
 	free_cpumask_var(tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 45a2a1b..0a38bdf 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -407,6 +407,8 @@ struct trace_seq {
 	unsigned int		readpos;
 };
 
+#define TRACE_PIPE_ALL_CPU	-1
+
 /*
  * Trace iterator - used by printout routines who present trace
  * results to users and which routines might sleep, etc:
@@ -416,6 +418,7 @@ struct trace_iterator {
 	struct tracer		*trace;
 	void			*private;
 	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
+	int			cpu_file;
 
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
-- 
1.6.1


