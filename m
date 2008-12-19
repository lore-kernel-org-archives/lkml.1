Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYLSQCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYLSQCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYLSQBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:01:49 -0500
Received: from relay3.sgi.com ([192.48.171.31]:59910 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751056AbYLSQBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:01:46 -0500
Message-Id: <20081219160145.272814000@polaris-admin.engr.sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 08:01:48 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/8] cpumask: convert kernel trace functions
Content-Disposition: inline; filename=cpumask:convert-kernel_trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduce memory usage, use new cpumask API.

Convert kernel trace functions to use struct cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c   |   42 +++++++++++++++++------------
 kernel/trace/trace.c         |   62 +++++++++++++++++++++++++------------------
 kernel/trace/trace_sysprof.c |   13 ++-------
 3 files changed, 65 insertions(+), 52 deletions(-)

--- linux-2.6-for-ingo.orig/kernel/trace/ring_buffer.c
+++ linux-2.6-for-ingo/kernel/trace/ring_buffer.c
@@ -189,7 +189,7 @@ void *ring_buffer_event_data(struct ring
 }
 
 #define for_each_buffer_cpu(buffer, cpu)		\
-	for_each_cpu_mask(cpu, buffer->cpumask)
+	for_each_cpu(cpu, buffer->cpumask)
 
 #define TS_SHIFT	27
 #define TS_MASK		((1ULL << TS_SHIFT) - 1)
@@ -262,7 +262,7 @@ struct ring_buffer {
 	unsigned			pages;
 	unsigned			flags;
 	int				cpus;
-	cpumask_t			cpumask;
+	cpumask_var_t			cpumask;
 	atomic_t			record_disabled;
 
 	struct mutex			mutex;
@@ -453,6 +453,9 @@ struct ring_buffer *ring_buffer_alloc(un
 	if (!buffer)
 		return NULL;
 
+	if (!alloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
+		goto fail_free_buffer;
+
 	buffer->pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	buffer->flags = flags;
 
@@ -460,14 +463,14 @@ struct ring_buffer *ring_buffer_alloc(un
 	if (buffer->pages == 1)
 		buffer->pages++;
 
-	buffer->cpumask = cpu_possible_map;
+	cpumask_copy(buffer->cpumask, cpu_possible_mask);
 	buffer->cpus = nr_cpu_ids;
 
 	bsize = sizeof(void *) * nr_cpu_ids;
 	buffer->buffers = kzalloc(ALIGN(bsize, cache_line_size()),
 				  GFP_KERNEL);
 	if (!buffer->buffers)
-		goto fail_free_buffer;
+		goto fail_free_cpumask;
 
 	for_each_buffer_cpu(buffer, cpu) {
 		buffer->buffers[cpu] =
@@ -487,6 +490,9 @@ struct ring_buffer *ring_buffer_alloc(un
 	}
 	kfree(buffer->buffers);
 
+ fail_free_cpumask:
+	free_cpumask_var(buffer->cpumask);
+
  fail_free_buffer:
 	kfree(buffer);
 	return NULL;
@@ -504,6 +510,8 @@ ring_buffer_free(struct ring_buffer *buf
 	for_each_buffer_cpu(buffer, cpu)
 		rb_free_cpu_buffer(buffer->buffers[cpu]);
 
+	free_cpumask_var(buffer->cpumask);
+
 	kfree(buffer);
 }
 
@@ -1260,7 +1268,7 @@ ring_buffer_lock_reserve(struct ring_buf
 
 	cpu = raw_smp_processor_id();
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1371,7 +1379,7 @@ int ring_buffer_write(struct ring_buffer
 
 	cpu = raw_smp_processor_id();
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1450,7 +1458,7 @@ void ring_buffer_record_disable_cpu(stru
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1469,7 +1477,7 @@ void ring_buffer_record_enable_cpu(struc
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1485,7 +1493,7 @@ unsigned long ring_buffer_entries_cpu(st
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1501,7 +1509,7 @@ unsigned long ring_buffer_overrun_cpu(st
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1814,7 +1822,7 @@ rb_buffer_peek(struct ring_buffer *buffe
 	struct buffer_page *reader;
 	int nr_loops = 0;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1987,7 +1995,7 @@ ring_buffer_consume(struct ring_buffer *
 	struct ring_buffer_event *event;
 	unsigned long flags;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
@@ -2023,7 +2031,7 @@ ring_buffer_read_start(struct ring_buffe
 	struct ring_buffer_iter *iter;
 	unsigned long flags;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
@@ -2129,7 +2137,7 @@ void ring_buffer_reset_cpu(struct ring_b
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	unsigned long flags;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
@@ -2182,7 +2190,7 @@ int ring_buffer_empty_cpu(struct ring_bu
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 1;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -2205,8 +2213,8 @@ int ring_buffer_swap_cpu(struct ring_buf
 	struct ring_buffer_per_cpu *cpu_buffer_a;
 	struct ring_buffer_per_cpu *cpu_buffer_b;
 
-	if (!cpu_isset(cpu, buffer_a->cpumask) ||
-	    !cpu_isset(cpu, buffer_b->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
+	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
 		return -EINVAL;
 
 	/* At least make sure the two buffers are somewhat the same */
--- linux-2.6-for-ingo.orig/kernel/trace/trace.c
+++ linux-2.6-for-ingo/kernel/trace/trace.c
@@ -90,10 +90,10 @@ static inline void ftrace_enable_cpu(voi
 	preempt_enable();
 }
 
-static cpumask_t __read_mostly		tracing_buffer_mask;
+static cpumask_var_t __read_mostly	tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
-	for_each_cpu_mask(cpu, tracing_buffer_mask)
+	for_each_cpu(cpu, tracing_buffer_mask)
 
 /*
  * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
@@ -2618,13 +2618,7 @@ static struct file_operations show_trace
 /*
  * Only trace on a CPU if the bitmask is set:
  */
-static cpumask_t tracing_cpumask = CPU_MASK_ALL;
-
-/*
- * When tracing/tracing_cpu_mask is modified then this holds
- * the new bitmask we are about to install:
- */
-static cpumask_t tracing_cpumask_new;
+static cpumask_var_t tracing_cpumask;
 
 /*
  * The tracer itself will not take this lock, but still we want
@@ -2646,7 +2640,7 @@ tracing_cpumask_read(struct file *filp, 
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, &tracing_cpumask);
+	len = cpumask_scnprintf(mask_str, count, tracing_cpumask);
 	if (count - len < 2) {
 		count = -EINVAL;
 		goto out_err;
@@ -2665,9 +2659,13 @@ tracing_cpumask_write(struct file *filp,
 		      size_t count, loff_t *ppos)
 {
 	int err, cpu;
+	cpumask_var_t tracing_cpumask_new;
+
+	if (!alloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
+		return -ENOMEM;
 
 	mutex_lock(&tracing_cpumask_update_lock);
-	err = cpumask_parse_user(ubuf, count, &tracing_cpumask_new);
+	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
 	if (err)
 		goto err_unlock;
 
@@ -2678,26 +2676,28 @@ tracing_cpumask_write(struct file *filp,
 		 * Increase/decrease the disabled counter if we are
 		 * about to flip a bit in the cpumask:
 		 */
-		if (cpu_isset(cpu, tracing_cpumask) &&
-				!cpu_isset(cpu, tracing_cpumask_new)) {
+		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
+				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_inc(&global_trace.data[cpu]->disabled);
 		}
-		if (!cpu_isset(cpu, tracing_cpumask) &&
-				cpu_isset(cpu, tracing_cpumask_new)) {
+		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
+				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_dec(&global_trace.data[cpu]->disabled);
 		}
 	}
 	__raw_spin_unlock(&ftrace_max_lock);
 	local_irq_enable();
 
-	tracing_cpumask = tracing_cpumask_new;
+	cpumask_copy(tracing_cpumask, tracing_cpumask_new);
 
 	mutex_unlock(&tracing_cpumask_update_lock);
+	free_cpumask_var(tracing_cpumask_new);
 
 	return count;
 
 err_unlock:
 	mutex_unlock(&tracing_cpumask_update_lock);
+	free_cpumask_var(tracing_cpumask);
 
 	return err;
 }
@@ -3724,7 +3724,6 @@ void ftrace_dump(void)
 	static DEFINE_SPINLOCK(ftrace_dump_lock);
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
-	static cpumask_t mask;
 	static int dump_ran;
 	unsigned long flags;
 	int cnt = 0, cpu;
@@ -3758,8 +3757,6 @@ void ftrace_dump(void)
 	 * and then release the locks again.
 	 */
 
-	cpus_clear(mask);
-
 	while (!trace_empty(&iter)) {
 
 		if (!cnt)
@@ -3795,19 +3792,28 @@ __init static int tracer_alloc_buffers(v
 {
 	struct trace_array_cpu *data;
 	int i;
+	int ret = -ENOMEM;
 
-	/* TODO: make the number of buffers hot pluggable with CPUS */
-	tracing_buffer_mask = cpu_possible_map;
+	if (!alloc_cpumask_var(&tracing_buffer_mask, GFP_KERNEL))
+		goto out;
+
+	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
+		goto out_free_buffer_mask;
 
+	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
+	cpumask_copy(tracing_cpumask, cpu_all_mask);
+
+	/* TODO: make the number of buffers hot pluggable with CPUS */
 	global_trace.buffer = ring_buffer_alloc(trace_buf_size,
 						   TRACE_BUFFER_FLAGS);
 	if (!global_trace.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
-		return 0;
+		goto out_free_cpumask;
 	}
 	global_trace.entries = ring_buffer_size(global_trace.buffer);
 
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 	max_tr.buffer = ring_buffer_alloc(trace_buf_size,
 					     TRACE_BUFFER_FLAGS);
@@ -3815,7 +3821,7 @@ __init static int tracer_alloc_buffers(v
 		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
 		WARN_ON(1);
 		ring_buffer_free(global_trace.buffer);
-		return 0;
+		goto out_free_cpumask;
 	}
 	max_tr.entries = ring_buffer_size(max_tr.buffer);
 	WARN_ON(max_tr.entries != global_trace.entries);
@@ -3842,11 +3848,17 @@ __init static int tracer_alloc_buffers(v
 	tracing_disabled = 0;
 
 	atomic_notifier_chain_register(&panic_notifier_list,
-				       &trace_panic_notifier);
+					&trace_panic_notifier);
 
 	register_die_notifier(&trace_die_notifier);
+	ret = 0;
 
-	return 0;
+out_free_cpumask:
+	free_cpumask_var(tracing_cpumask);
+out_free_buffer_mask:
+	free_cpumask_var(tracing_buffer_mask);
+out:
+	return ret;
 }
 early_initcall(tracer_alloc_buffers);
 fs_initcall(tracer_init_debugfs);
--- linux-2.6-for-ingo.orig/kernel/trace/trace_sysprof.c
+++ linux-2.6-for-ingo/kernel/trace/trace_sysprof.c
@@ -196,9 +196,9 @@ static enum hrtimer_restart stack_trace_
 	return HRTIMER_RESTART;
 }
 
-static void start_stack_timer(int cpu)
+static void start_stack_timer(void *unused)
 {
-	struct hrtimer *hrtimer = &per_cpu(stack_trace_hrtimer, cpu);
+	struct hrtimer *hrtimer = &__get_cpu_var(stack_trace_hrtimer);
 
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
@@ -209,14 +209,7 @@ static void start_stack_timer(int cpu)
 
 static void start_stack_timers(void)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-		start_stack_timer(cpu);
-	}
-	set_cpus_allowed_ptr(current, &saved_mask);
+	on_each_cpu(start_stack_timer, NULL, 1);
 }
 
 static void stop_stack_timer(int cpu)

-- 
