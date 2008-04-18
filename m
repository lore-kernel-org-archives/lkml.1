Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYDRUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYDRUJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757437AbYDRUIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:08:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33369 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061AbYDRUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:08:51 -0400
Message-Id: <20080418200850.299358789@goodmis.org>
References: <20080418200538.788522018@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 16:05:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@osdl.org, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ftrace: modulize the number of CPU buffers
Content-Disposition: inline; filename=ftrace-variable-nr-of-buffers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ftrace allocates a trace buffer for every possible CPU.
Work is being done to change it to only online CPUs and add hooks
to hotplug CPUS.

This patch lays out the infrastructer for such a change.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-18 15:50:42.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-18 15:50:47.000000000 -0400
@@ -35,6 +35,12 @@
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;
 
+static unsigned long __read_mostly	tracing_nr_buffers;
+static cpumask_t __read_mostly		tracing_buffer_mask;
+
+#define for_each_tracing_cpu(cpu)	\
+	for_each_cpu_mask(cpu, tracing_buffer_mask)
+
 /* dummy trace to disable tracing */
 static struct tracer no_tracer __read_mostly = {
 	.name		= "none",
@@ -341,7 +347,7 @@ update_max_tr(struct trace_array *tr, st
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
 	/* clear out all the previous traces */
-	for_each_possible_cpu(i) {
+	for_each_tracing_cpu(i) {
 		data = tr->data[i];
 		flip_trace(max_tr.data[i], data);
 		tracing_reset(data);
@@ -365,7 +371,7 @@ update_max_tr_single(struct trace_array 
 
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
-	for_each_possible_cpu(i)
+	for_each_tracing_cpu(i)
 		tracing_reset(max_tr.data[i]);
 
 	flip_trace(max_tr.data[cpu], data);
@@ -411,7 +417,7 @@ int register_tracer(struct tracer *type)
 		 * internal tracing to verify that everything is in order.
 		 * If we fail, we do not register this tracer.
 		 */
-		for_each_possible_cpu(i) {
+		for_each_tracing_cpu(i) {
 			data = tr->data[i];
 			if (!head_page(data))
 				continue;
@@ -430,7 +436,7 @@ int register_tracer(struct tracer *type)
 			goto out;
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
-		for_each_possible_cpu(i) {
+		for_each_tracing_cpu(i) {
 			data = tr->data[i];
 			if (!head_page(data))
 				continue;
@@ -902,7 +908,7 @@ find_next_entry(struct trace_iterator *i
 	int next_cpu = -1;
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
+	for_each_tracing_cpu(cpu) {
 		if (!head_page(tr->data[cpu]))
 			continue;
 		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
@@ -1027,7 +1033,7 @@ static void *s_start(struct seq_file *m,
 		iter->prev_ent = NULL;
 		iter->prev_cpu = -1;
 
-		for_each_possible_cpu(i) {
+		for_each_tracing_cpu(i) {
 			iter->next_idx[i] = 0;
 			iter->next_page[i] = NULL;
 		}
@@ -1144,7 +1150,7 @@ print_trace_header(struct seq_file *m, s
 	if (type)
 		name = type->name;
 
-	for_each_possible_cpu(cpu) {
+	for_each_tracing_cpu(cpu) {
 		if (head_page(tr->data[cpu])) {
 			total += tr->data[cpu]->trace_idx;
 			if (tr->data[cpu]->trace_idx > tr->entries)
@@ -1574,7 +1580,7 @@ static int trace_empty(struct trace_iter
 	struct trace_array_cpu *data;
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
+	for_each_tracing_cpu(cpu) {
 		data = iter->tr->data[cpu];
 
 		if (head_page(data) && data->trace_idx &&
@@ -1886,7 +1892,7 @@ tracing_cpumask_write(struct file *filp,
 
 	raw_local_irq_disable();
 	__raw_spin_lock(&ftrace_max_lock);
-	for_each_possible_cpu(cpu) {
+	for_each_tracing_cpu(cpu) {
 		/*
 		 * Increase/decrease the disabled counter if we are
 		 * about to flip a bit in the cpumask:
@@ -2364,7 +2370,7 @@ tracing_read_pipe(struct file *filp, cha
 	ftrace_enabled = 0;
 #endif
 	smp_wmb();
-	for_each_possible_cpu(cpu) {
+	for_each_tracing_cpu(cpu) {
 		data = iter->tr->data[cpu];
 
 		if (!head_page(data) || !data->trace_idx)
@@ -2664,7 +2670,7 @@ static int trace_alloc_page(void)
 	int i;
 
 	/* first allocate a page for each CPU */
-	for_each_possible_cpu(i) {
+	for_each_tracing_cpu(i) {
 		array = (void *)__get_free_page(GFP_KERNEL);
 		if (array == NULL) {
 			printk(KERN_ERR "tracer: failed to allocate page"
@@ -2689,7 +2695,7 @@ static int trace_alloc_page(void)
 	}
 
 	/* Now that we successfully allocate a page per CPU, add them */
-	for_each_possible_cpu(i) {
+	for_each_tracing_cpu(i) {
 		data = global_trace.data[i];
 		page = list_entry(pages.next, struct page, lru);
 		list_del_init(&page->lru);
@@ -2725,7 +2731,7 @@ static int trace_free_page(void)
 	int ret = 0;
 
 	/* free one page from each buffer */
-	for_each_possible_cpu(i) {
+	for_each_tracing_cpu(i) {
 		data = global_trace.data[i];
 		p = data->trace_pages.next;
 		if (p == &data->trace_pages) {
@@ -2776,8 +2782,12 @@ __init static int tracer_alloc_buffers(v
 
 	global_trace.ctrl = tracer_enabled;
 
+	/* TODO: make the number of buffers hot pluggable with CPUS */
+	tracing_nr_buffers = num_possible_cpus();
+	tracing_buffer_mask = cpu_possible_map;
+
 	/* Allocate the first page for all buffers */
-	for_each_possible_cpu(i) {
+	for_each_tracing_cpu(i) {
 		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
 		max_tr.data[i] = &per_cpu(max_data, i);
 

-- 
