Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYIYSxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYIYSxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYIYSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:52:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbYIYSwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:52:40 -0400
Message-Id: <20080925185236.428253912@goodmis.org>
References: <20080925185154.230259579@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 25 Sep 2008 14:51:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 2/2 v3] ftrace: make work with new ring buffer
Content-Disposition: inline; filename=ftrace-ring-buffer-take-two.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: This patch is a proof of concept, and breaks a lot of
 functionality of ftrace.

This patch simply makes ftrace work with the developmental ring buffer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |  776 ++++++++------------------------------
 kernel/trace/trace.h              |   22 -
 kernel/trace/trace_functions.c    |    2 
 kernel/trace/trace_irqsoff.c      |    6 
 kernel/trace/trace_mmiotrace.c    |   10 
 kernel/trace/trace_sched_switch.c |    2 
 kernel/trace/trace_sched_wakeup.c |    2 
 7 files changed, 195 insertions(+), 625 deletions(-)

Index: linux-compile.git/kernel/trace/trace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace.c	2008-09-25 12:34:11.000000000 -0400
+++ linux-compile.git/kernel/trace/trace.c	2008-09-25 12:34:23.000000000 -0400
@@ -31,25 +31,24 @@
 #include <linux/writeback.h>
 
 #include <linux/stacktrace.h>
+#include <linux/ring_buffer.h>
 
 #include "trace.h"
 
+#define sdr_print(x, y...) printk("%s:%d " x "\n", __FUNCTION__, __LINE__, y)
+
+#define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
+
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;
 
-static unsigned long __read_mostly	tracing_nr_buffers;
 static cpumask_t __read_mostly		tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
 	for_each_cpu_mask(cpu, tracing_buffer_mask)
 
-static int trace_alloc_page(void);
-static int trace_free_page(void);
-
 static int tracing_disabled = 1;
 
-static unsigned long tracing_pages_allocated;
-
 long
 ns2usecs(cycle_t nsec)
 {
@@ -100,11 +99,11 @@ static int			tracer_enabled = 1;
 int				ftrace_function_enabled;
 
 /*
- * trace_nr_entries is the number of entries that is allocated
- * for a buffer. Note, the number of entries is always rounded
- * to ENTRIES_PER_PAGE.
+ * trace_buf_size is the size in bytes that is allocated
+ * for a buffer. Note, the number of bytes is always rounded
+ * to page size.
  */
-static unsigned long		trace_nr_entries = 65536UL;
+static unsigned long		trace_buf_size = 65536UL;
 
 /* trace_types holds a link list of available tracers. */
 static struct tracer		*trace_types __read_mostly;
@@ -139,8 +138,8 @@ static notrace void no_trace_init(struct
 
 	ftrace_function_enabled = 0;
 	if(tr->ctrl)
-		for_each_online_cpu(cpu)
-			tracing_reset(tr->data[cpu]);
+		for_each_tracing_cpu(cpu)
+			tracing_reset(tr, cpu);
 	tracer_enabled = 0;
 }
 
@@ -167,23 +166,21 @@ void trace_wake_up(void)
 		wake_up(&trace_wait);
 }
 
-#define ENTRIES_PER_PAGE (PAGE_SIZE / sizeof(struct trace_entry))
-
-static int __init set_nr_entries(char *str)
+static int __init set_buf_size(char *str)
 {
-	unsigned long nr_entries;
+	unsigned long buf_size;
 	int ret;
 
 	if (!str)
 		return 0;
-	ret = strict_strtoul(str, 0, &nr_entries);
+	ret = strict_strtoul(str, 0, &buf_size);
 	/* nr_entries can not be zero */
-	if (ret < 0 || nr_entries == 0)
+	if (ret < 0 || buf_size == 0)
 		return 0;
-	trace_nr_entries = nr_entries;
+	trace_buf_size = buf_size;
 	return 1;
 }
-__setup("trace_entries=", set_nr_entries);
+__setup("trace_buf_size=", set_buf_size);
 
 unsigned long nsecs_to_usecs(unsigned long nsecs)
 {
@@ -266,54 +263,6 @@ __update_max_tr(struct trace_array *tr, 
 	tracing_record_cmdline(current);
 }
 
-#define CHECK_COND(cond)			\
-	if (unlikely(cond)) {			\
-		tracing_disabled = 1;		\
-		WARN_ON(1);			\
-		return -1;			\
-	}
-
-/**
- * check_pages - integrity check of trace buffers
- *
- * As a safty measure we check to make sure the data pages have not
- * been corrupted.
- */
-int check_pages(struct trace_array_cpu *data)
-{
-	struct page *page, *tmp;
-
-	CHECK_COND(data->trace_pages.next->prev != &data->trace_pages);
-	CHECK_COND(data->trace_pages.prev->next != &data->trace_pages);
-
-	list_for_each_entry_safe(page, tmp, &data->trace_pages, lru) {
-		CHECK_COND(page->lru.next->prev != &page->lru);
-		CHECK_COND(page->lru.prev->next != &page->lru);
-	}
-
-	return 0;
-}
-
-/**
- * head_page - page address of the first page in per_cpu buffer.
- *
- * head_page returns the page address of the first page in
- * a per_cpu buffer. This also preforms various consistency
- * checks to make sure the buffer has not been corrupted.
- */
-void *head_page(struct trace_array_cpu *data)
-{
-	struct page *page;
-
-	if (list_empty(&data->trace_pages))
-		return NULL;
-
-	page = list_entry(data->trace_pages.next, struct page, lru);
-	BUG_ON(&page->lru == &data->trace_pages);
-
-	return page_address(page);
-}
-
 /**
  * trace_seq_printf - sequence printing of trace information
  * @s: trace sequence descriptor
@@ -460,34 +409,6 @@ trace_print_seq(struct seq_file *m, stru
 	trace_seq_reset(s);
 }
 
-/*
- * flip the trace buffers between two trace descriptors.
- * This usually is the buffers between the global_trace and
- * the max_tr to record a snapshot of a current trace.
- *
- * The ftrace_max_lock must be held.
- */
-static void
-flip_trace(struct trace_array_cpu *tr1, struct trace_array_cpu *tr2)
-{
-	struct list_head flip_pages;
-
-	INIT_LIST_HEAD(&flip_pages);
-
-	memcpy(&tr1->trace_head_idx, &tr2->trace_head_idx,
-		sizeof(struct trace_array_cpu) -
-		offsetof(struct trace_array_cpu, trace_head_idx));
-
-	check_pages(tr1);
-	check_pages(tr2);
-	list_splice_init(&tr1->trace_pages, &flip_pages);
-	list_splice_init(&tr2->trace_pages, &tr1->trace_pages);
-	list_splice_init(&flip_pages, &tr2->trace_pages);
-	BUG_ON(!list_empty(&flip_pages));
-	check_pages(tr1);
-	check_pages(tr2);
-}
-
 /**
  * update_max_tr - snapshot all trace buffers from global_trace to max_tr
  * @tr: tracer
@@ -500,17 +421,15 @@ flip_trace(struct trace_array_cpu *tr1, 
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_array_cpu *data;
-	int i;
+	struct ring_buffer *buf = tr->buffer;
 
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
-	/* clear out all the previous traces */
-	for_each_tracing_cpu(i) {
-		data = tr->data[i];
-		flip_trace(max_tr.data[i], data);
-		tracing_reset(data);
-	}
+
+	tr->buffer = max_tr.buffer;
+	max_tr.buffer = buf;
+
+	ring_buffer_reset(tr->buffer);
 
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
@@ -527,16 +446,15 @@ update_max_tr(struct trace_array *tr, st
 void
 update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_array_cpu *data = tr->data[cpu];
-	int i;
+	int ret;
 
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
-	for_each_tracing_cpu(i)
-		tracing_reset(max_tr.data[i]);
 
-	flip_trace(max_tr.data[cpu], data);
-	tracing_reset(data);
+	ring_buffer_reset(max_tr.buffer);
+	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
+
+	WARN_ON_ONCE(ret);
 
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
@@ -573,7 +491,6 @@ int register_tracer(struct tracer *type)
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	if (type->selftest) {
 		struct tracer *saved_tracer = current_trace;
-		struct trace_array_cpu *data;
 		struct trace_array *tr = &global_trace;
 		int saved_ctrl = tr->ctrl;
 		int i;
@@ -585,10 +502,7 @@ int register_tracer(struct tracer *type)
 		 * If we fail, we do not register this tracer.
 		 */
 		for_each_tracing_cpu(i) {
-			data = tr->data[i];
-			if (!head_page(data))
-				continue;
-			tracing_reset(data);
+			tracing_reset(tr, i);
 		}
 		current_trace = type;
 		tr->ctrl = 0;
@@ -604,10 +518,7 @@ int register_tracer(struct tracer *type)
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
 		for_each_tracing_cpu(i) {
-			data = tr->data[i];
-			if (!head_page(data))
-				continue;
-			tracing_reset(data);
+			tracing_reset(tr, i);
 		}
 		printk(KERN_CONT "PASSED\n");
 	}
@@ -653,13 +564,9 @@ void unregister_tracer(struct tracer *ty
 	mutex_unlock(&trace_types_lock);
 }
 
-void tracing_reset(struct trace_array_cpu *data)
+void tracing_reset(struct trace_array *tr, int cpu)
 {
-	data->trace_idx = 0;
-	data->overrun = 0;
-	data->trace_head = data->trace_tail = head_page(data);
-	data->trace_head_idx = 0;
-	data->trace_tail_idx = 0;
+	ring_buffer_reset_cpu(tr->buffer, cpu);
 }
 
 #define SAVED_CMDLINES 128
@@ -745,70 +652,6 @@ void tracing_record_cmdline(struct task_
 	trace_save_cmdline(tsk);
 }
 
-static inline struct list_head *
-trace_next_list(struct trace_array_cpu *data, struct list_head *next)
-{
-	/*
-	 * Roundrobin - but skip the head (which is not a real page):
-	 */
-	next = next->next;
-	if (unlikely(next == &data->trace_pages))
-		next = next->next;
-	BUG_ON(next == &data->trace_pages);
-
-	return next;
-}
-
-static inline void *
-trace_next_page(struct trace_array_cpu *data, void *addr)
-{
-	struct list_head *next;
-	struct page *page;
-
-	page = virt_to_page(addr);
-
-	next = trace_next_list(data, &page->lru);
-	page = list_entry(next, struct page, lru);
-
-	return page_address(page);
-}
-
-static inline struct trace_entry *
-tracing_get_trace_entry(struct trace_array *tr, struct trace_array_cpu *data)
-{
-	unsigned long idx, idx_next;
-	struct trace_entry *entry;
-
-	data->trace_idx++;
-	idx = data->trace_head_idx;
-	idx_next = idx + 1;
-
-	BUG_ON(idx * TRACE_ENTRY_SIZE >= PAGE_SIZE);
-
-	entry = data->trace_head + idx * TRACE_ENTRY_SIZE;
-
-	if (unlikely(idx_next >= ENTRIES_PER_PAGE)) {
-		data->trace_head = trace_next_page(data, data->trace_head);
-		idx_next = 0;
-	}
-
-	if (data->trace_head == data->trace_tail &&
-	    idx_next == data->trace_tail_idx) {
-		/* overrun */
-		data->overrun++;
-		data->trace_tail_idx++;
-		if (data->trace_tail_idx >= ENTRIES_PER_PAGE) {
-			data->trace_tail =
-				trace_next_page(data, data->trace_tail);
-			data->trace_tail_idx = 0;
-		}
-	}
-
-	data->trace_head_idx = idx_next;
-
-	return entry;
-}
-
 static inline void
 tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags)
 {
@@ -819,7 +662,6 @@ tracing_generic_entry_update(struct trac
 
 	entry->preempt_count	= pc & 0xff;
 	entry->pid		= (tsk) ? tsk->pid : 0;
-	entry->t		= ftrace_now(raw_smp_processor_id());
 	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
@@ -833,15 +675,14 @@ trace_function(struct trace_array *tr, s
 	struct trace_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
+	entry	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
 	tracing_generic_entry_update(entry, flags);
 	entry->type		= TRACE_FN;
 	entry->fn.ip		= ip;
 	entry->fn.parent_ip	= parent_ip;
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 }
 
 void
@@ -859,16 +700,13 @@ void __trace_mmiotrace_rw(struct trace_a
 	struct trace_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-
-	entry			= tracing_get_trace_entry(tr, data);
+	entry	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
 	tracing_generic_entry_update(entry, 0);
 	entry->type		= TRACE_MMIO_RW;
 	entry->mmiorw		= *rw;
-
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 
 	trace_wake_up();
 }
@@ -879,16 +717,13 @@ void __trace_mmiotrace_map(struct trace_
 	struct trace_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-
-	entry			= tracing_get_trace_entry(tr, data);
+	entry	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
 	tracing_generic_entry_update(entry, 0);
 	entry->type		= TRACE_MMIO_MAP;
 	entry->mmiomap		= *map;
-
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 
 	trace_wake_up();
 }
@@ -901,11 +736,14 @@ void __trace_stack(struct trace_array *t
 {
 	struct trace_entry *entry;
 	struct stack_trace trace;
+	unsigned long irq_flags;
 
 	if (!(trace_flags & TRACE_ITER_STACKTRACE))
 		return;
 
-	entry			= tracing_get_trace_entry(tr, data);
+	entry	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
 	tracing_generic_entry_update(entry, flags);
 	entry->type		= TRACE_STACK;
 
@@ -917,6 +755,7 @@ void __trace_stack(struct trace_array *t
 	trace.entries		= entry->stack.caller;
 
 	save_stack_trace(&trace);
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 }
 
 void
@@ -928,17 +767,16 @@ __trace_special(void *__tr, void *__data
 	struct trace_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
+	entry	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
 	tracing_generic_entry_update(entry, 0);
 	entry->type		= TRACE_SPECIAL;
 	entry->special.arg1	= arg1;
 	entry->special.arg2	= arg2;
 	entry->special.arg3	= arg3;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 	__trace_stack(tr, data, irq_flags, 4);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
 
 	trace_wake_up();
 }
@@ -953,9 +791,9 @@ tracing_sched_switch_trace(struct trace_
 	struct trace_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
+	entry	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
 	tracing_generic_entry_update(entry, flags);
 	entry->type		= TRACE_CTX;
 	entry->ctx.prev_pid	= prev->pid;
@@ -964,9 +802,8 @@ tracing_sched_switch_trace(struct trace_
 	entry->ctx.next_pid	= next->pid;
 	entry->ctx.next_prio	= next->prio;
 	entry->ctx.next_state	= next->state;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 	__trace_stack(tr, data, flags, 5);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
 }
 
 void
@@ -979,9 +816,9 @@ tracing_sched_wakeup_trace(struct trace_
 	struct trace_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
+	entry	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
 	tracing_generic_entry_update(entry, flags);
 	entry->type		= TRACE_WAKE;
 	entry->ctx.prev_pid	= curr->pid;
@@ -990,9 +827,8 @@ tracing_sched_wakeup_trace(struct trace_
 	entry->ctx.next_pid	= wakee->pid;
 	entry->ctx.next_prio	= wakee->prio;
 	entry->ctx.next_state	= wakee->state;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 	__trace_stack(tr, data, flags, 6);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
 
 	trace_wake_up();
 }
@@ -1074,105 +910,66 @@ enum trace_file_type {
 };
 
 static struct trace_entry *
-trace_entry_idx(struct trace_array *tr, struct trace_array_cpu *data,
-		struct trace_iterator *iter, int cpu)
-{
-	struct page *page;
-	struct trace_entry *array;
-
-	if (iter->next_idx[cpu] >= tr->entries ||
-	    iter->next_idx[cpu] >= data->trace_idx ||
-	    (data->trace_head == data->trace_tail &&
-	     data->trace_head_idx == data->trace_tail_idx))
-		return NULL;
-
-	if (!iter->next_page[cpu]) {
-		/* Initialize the iterator for this cpu trace buffer */
-		WARN_ON(!data->trace_tail);
-		page = virt_to_page(data->trace_tail);
-		iter->next_page[cpu] = &page->lru;
-		iter->next_page_idx[cpu] = data->trace_tail_idx;
-	}
-
-	page = list_entry(iter->next_page[cpu], struct page, lru);
-	BUG_ON(&data->trace_pages == &page->lru);
-
-	array = page_address(page);
-
-	WARN_ON(iter->next_page_idx[cpu] >= ENTRIES_PER_PAGE);
-	return &array[iter->next_page_idx[cpu]];
-}
-
-static struct trace_entry *
-find_next_entry(struct trace_iterator *iter, int *ent_cpu)
+find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 {
-	struct trace_array *tr = iter->tr;
+	struct ring_buffer *buffer = iter->tr->buffer;
+	struct ring_buffer_event *event;
 	struct trace_entry *ent, *next = NULL;
+	u64 next_ts = 0, ts;
 	int next_cpu = -1;
 	int cpu;
 
 	for_each_tracing_cpu(cpu) {
-		if (!head_page(tr->data[cpu]))
+		struct ring_buffer_iter *buf_iter;
+
+		if (ring_buffer_empty_cpu(buffer, cpu))
 			continue;
-		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
+
+		buf_iter = iter->buffer_iter[cpu];
+		event = ring_buffer_iter_peek(buf_iter, &ts);
+		ent = event ? ring_buffer_event_data(event) : NULL;
+
 		/*
 		 * Pick the entry with the smallest timestamp:
 		 */
-		if (ent && (!next || ent->t < next->t)) {
+		if (ent && (!next || ts < next_ts)) {
 			next = ent;
 			next_cpu = cpu;
+			next_ts = ts;
 		}
 	}
 
 	if (ent_cpu)
 		*ent_cpu = next_cpu;
 
+	if (ent_ts)
+		*ent_ts = next_ts;
+
 	return next;
 }
 
 static void trace_iterator_increment(struct trace_iterator *iter)
 {
 	iter->idx++;
-	iter->next_idx[iter->cpu]++;
-	iter->next_page_idx[iter->cpu]++;
-
-	if (iter->next_page_idx[iter->cpu] >= ENTRIES_PER_PAGE) {
-		struct trace_array_cpu *data = iter->tr->data[iter->cpu];
-
-		iter->next_page_idx[iter->cpu] = 0;
-		iter->next_page[iter->cpu] =
-			trace_next_list(data, iter->next_page[iter->cpu]);
-	}
+	ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
 }
 
 static void trace_consume(struct trace_iterator *iter)
 {
-	struct trace_array_cpu *data = iter->tr->data[iter->cpu];
-
-	data->trace_tail_idx++;
-	if (data->trace_tail_idx >= ENTRIES_PER_PAGE) {
-		data->trace_tail = trace_next_page(data, data->trace_tail);
-		data->trace_tail_idx = 0;
-	}
-
-	/* Check if we empty it, then reset the index */
-	if (data->trace_head == data->trace_tail &&
-	    data->trace_head_idx == data->trace_tail_idx)
-		data->trace_idx = 0;
+	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts);
 }
 
 static void *find_next_entry_inc(struct trace_iterator *iter)
 {
 	struct trace_entry *next;
 	int next_cpu = -1;
+	u64 ts;
 
-	next = find_next_entry(iter, &next_cpu);
-
-	iter->prev_ent = iter->ent;
-	iter->prev_cpu = iter->cpu;
+	next = find_next_entry(iter, &next_cpu, &ts);
 
 	iter->ent = next;
 	iter->cpu = next_cpu;
+	iter->ts = ts;
 
 	if (next)
 		trace_iterator_increment(iter);
@@ -1210,7 +1007,7 @@ static void *s_start(struct seq_file *m,
 	struct trace_iterator *iter = m->private;
 	void *p = NULL;
 	loff_t l = 0;
-	int i;
+	int cpu;
 
 	mutex_lock(&trace_types_lock);
 
@@ -1229,12 +1026,9 @@ static void *s_start(struct seq_file *m,
 		iter->ent = NULL;
 		iter->cpu = 0;
 		iter->idx = -1;
-		iter->prev_ent = NULL;
-		iter->prev_cpu = -1;
 
-		for_each_tracing_cpu(i) {
-			iter->next_idx[i] = 0;
-			iter->next_page[i] = NULL;
+		for_each_tracing_cpu(cpu) {
+			ring_buffer_iter_reset(iter->buffer_iter[cpu]);
 		}
 
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
@@ -1357,21 +1151,12 @@ print_trace_header(struct seq_file *m, s
 	struct tracer *type = current_trace;
 	unsigned long total   = 0;
 	unsigned long entries = 0;
-	int cpu;
 	const char *name = "preemption";
 
 	if (type)
 		name = type->name;
 
-	for_each_tracing_cpu(cpu) {
-		if (head_page(tr->data[cpu])) {
-			total += tr->data[cpu]->trace_idx;
-			if (tr->data[cpu]->trace_idx > tr->entries)
-				entries += tr->entries;
-			else
-				entries += tr->data[cpu]->trace_idx;
-		}
-	}
+	entries = ring_buffer_entries(iter->tr->buffer);
 
 	seq_printf(m, "%s latency trace v1.1.5 on %s\n",
 		   name, UTS_RELEASE);
@@ -1457,7 +1242,7 @@ lat_print_generic(struct trace_seq *s, s
 unsigned long preempt_mark_thresh = 100;
 
 static void
-lat_print_timestamp(struct trace_seq *s, unsigned long long abs_usecs,
+lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
 		    unsigned long rel_usecs)
 {
 	trace_seq_printf(s, " %4lldus", abs_usecs);
@@ -1476,20 +1261,22 @@ print_lat_fmt(struct trace_iterator *ite
 {
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
-	struct trace_entry *next_entry = find_next_entry(iter, NULL);
+	struct trace_entry *next_entry;
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
 	struct trace_entry *entry = iter->ent;
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
+	u64 next_ts;
 	char *comm;
 	int S, T;
 	int i;
 	unsigned state;
 
+	next_entry = find_next_entry(iter, NULL, &next_ts);
 	if (!next_entry)
-		next_entry = entry;
-	rel_usecs = ns2usecs(next_entry->t - entry->t);
-	abs_usecs = ns2usecs(entry->t - iter->tr->time_start);
+		next_ts = iter->ts;
+	rel_usecs = ns2usecs(next_ts - iter->ts);
+	abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
 
 	if (verbose) {
 		comm = trace_find_cmdline(entry->pid);
@@ -1498,7 +1285,7 @@ print_lat_fmt(struct trace_iterator *ite
 				 comm,
 				 entry->pid, cpu, entry->flags,
 				 entry->preempt_count, trace_idx,
-				 ns2usecs(entry->t),
+				 ns2usecs(iter->ts),
 				 abs_usecs/1000,
 				 abs_usecs % 1000, rel_usecs/1000,
 				 rel_usecs % 1000);
@@ -1569,7 +1356,7 @@ static int print_trace_fmt(struct trace_
 
 	comm = trace_find_cmdline(iter->ent->pid);
 
-	t = ns2usecs(entry->t);
+	t = ns2usecs(iter->ts);
 	usec_rem = do_div(t, 1000000ULL);
 	secs = (unsigned long)t;
 
@@ -1660,7 +1447,7 @@ static int print_raw_fmt(struct trace_it
 	entry = iter->ent;
 
 	ret = trace_seq_printf(s, "%d %d %llu ",
-		entry->pid, iter->cpu, entry->t);
+		entry->pid, iter->cpu, iter->ts);
 	if (!ret)
 		return 0;
 
@@ -1725,7 +1512,7 @@ static int print_hex_fmt(struct trace_it
 
 	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
-	SEQ_PUT_HEX_FIELD_RET(s, entry->t);
+	SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
 
 	switch (entry->type) {
 	case TRACE_FN:
@@ -1769,7 +1556,7 @@ static int print_bin_fmt(struct trace_it
 
 	SEQ_PUT_FIELD_RET(s, entry->pid);
 	SEQ_PUT_FIELD_RET(s, entry->cpu);
-	SEQ_PUT_FIELD_RET(s, entry->t);
+	SEQ_PUT_FIELD_RET(s, iter->ts);
 
 	switch (entry->type) {
 	case TRACE_FN:
@@ -1796,16 +1583,10 @@ static int print_bin_fmt(struct trace_it
 
 static int trace_empty(struct trace_iterator *iter)
 {
-	struct trace_array_cpu *data;
 	int cpu;
 
 	for_each_tracing_cpu(cpu) {
-		data = iter->tr->data[cpu];
-
-		if (head_page(data) && data->trace_idx &&
-		    (data->trace_tail != data->trace_head ||
-		     data->trace_tail_idx != data->trace_head_idx))
-			return 0;
+		ring_buffer_iter_empty(iter->buffer_iter[cpu]);
 	}
 	return 1;
 }
@@ -1869,6 +1650,8 @@ static struct trace_iterator *
 __tracing_open(struct inode *inode, struct file *file, int *ret)
 {
 	struct trace_iterator *iter;
+	struct seq_file *m;
+	int cpu;
 
 	if (tracing_disabled) {
 		*ret = -ENODEV;
@@ -1889,28 +1672,43 @@ __tracing_open(struct inode *inode, stru
 	iter->trace = current_trace;
 	iter->pos = -1;
 
+	for_each_tracing_cpu(cpu) {
+		iter->buffer_iter[cpu] =
+			ring_buffer_read_start(iter->tr->buffer, cpu);
+		if (!iter->buffer_iter[cpu])
+			goto fail_buffer;
+	}
+
 	/* TODO stop tracer */
 	*ret = seq_open(file, &tracer_seq_ops);
-	if (!*ret) {
-		struct seq_file *m = file->private_data;
-		m->private = iter;
+	if (*ret)
+		goto fail_buffer;
 
-		/* stop the trace while dumping */
-		if (iter->tr->ctrl) {
-			tracer_enabled = 0;
-			ftrace_function_enabled = 0;
-		}
+	m = file->private_data;
+	m->private = iter;
 
-		if (iter->trace && iter->trace->open)
-			iter->trace->open(iter);
-	} else {
-		kfree(iter);
-		iter = NULL;
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl) {
+		tracer_enabled = 0;
+		ftrace_function_enabled = 0;
 	}
+
+	if (iter->trace && iter->trace->open)
+			iter->trace->open(iter);
+
 	mutex_unlock(&trace_types_lock);
 
  out:
 	return iter;
+
+ fail_buffer:
+	for_each_tracing_cpu(cpu) {
+		if (iter->buffer_iter[cpu])
+			ring_buffer_read_finish(iter->buffer_iter[cpu]);
+	}
+	mutex_unlock(&trace_types_lock);
+
+	return ERR_PTR(-ENOMEM);
 }
 
 int tracing_open_generic(struct inode *inode, struct file *filp)
@@ -1926,8 +1724,14 @@ int tracing_release(struct inode *inode,
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct trace_iterator *iter = m->private;
+	int cpu;
 
 	mutex_lock(&trace_types_lock);
+	for_each_tracing_cpu(cpu) {
+		if (iter->buffer_iter[cpu])
+			ring_buffer_read_finish(iter->buffer_iter[cpu]);
+	}
+
 	if (iter->trace && iter->trace->close)
 		iter->trace->close(iter);
 
@@ -2500,13 +2304,10 @@ tracing_read_pipe(struct file *filp, cha
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	struct trace_array_cpu *data;
-	static cpumask_t mask;
 	unsigned long flags;
 #ifdef CONFIG_FTRACE
 	int ftrace_save;
 #endif
-	int cpu;
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -2595,32 +2396,13 @@ tracing_read_pipe(struct file *filp, cha
 	 * and then release the locks again.
 	 */
 
-	cpus_clear(mask);
-	local_irq_save(flags);
+	local_irq_disable();
 #ifdef CONFIG_FTRACE
 	ftrace_save = ftrace_enabled;
 	ftrace_enabled = 0;
 #endif
 	smp_wmb();
-	for_each_tracing_cpu(cpu) {
-		data = iter->tr->data[cpu];
-
-		if (!head_page(data) || !data->trace_idx)
-			continue;
-
-		atomic_inc(&data->disabled);
-		cpu_set(cpu, mask);
-	}
-
-	for_each_cpu_mask(cpu, mask) {
-		data = iter->tr->data[cpu];
-		__raw_spin_lock(&data->lock);
-
-		if (data->overrun > iter->last_overrun[cpu])
-			iter->overrun[cpu] +=
-				data->overrun - iter->last_overrun[cpu];
-		iter->last_overrun[cpu] = data->overrun;
-	}
+	ring_buffer_lock(iter->tr->buffer, &flags);
 
 	while (find_next_entry_inc(iter) != NULL) {
 		int ret;
@@ -2639,19 +2421,11 @@ tracing_read_pipe(struct file *filp, cha
 			break;
 	}
 
-	for_each_cpu_mask(cpu, mask) {
-		data = iter->tr->data[cpu];
-		__raw_spin_unlock(&data->lock);
-	}
-
-	for_each_cpu_mask(cpu, mask) {
-		data = iter->tr->data[cpu];
-		atomic_dec(&data->disabled);
-	}
+	ring_buffer_unlock(iter->tr->buffer, flags);
 #ifdef CONFIG_FTRACE
 	ftrace_enabled = ftrace_save;
 #endif
-	local_irq_restore(flags);
+	local_irq_enable();
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
@@ -2684,7 +2458,7 @@ tracing_entries_write(struct file *filp,
 {
 	unsigned long val;
 	char buf[64];
-	int i, ret;
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2711,52 +2485,31 @@ tracing_entries_write(struct file *filp,
 		goto out;
 	}
 
-	if (val > global_trace.entries) {
-		long pages_requested;
-		unsigned long freeable_pages;
-
-		/* make sure we have enough memory before mapping */
-		pages_requested =
-			(val + (ENTRIES_PER_PAGE-1)) / ENTRIES_PER_PAGE;
-
-		/* account for each buffer (and max_tr) */
-		pages_requested *= tracing_nr_buffers * 2;
-
-		/* Check for overflow */
-		if (pages_requested < 0) {
-			cnt = -ENOMEM;
+	if (val != global_trace.entries) {
+		ret = ring_buffer_resize(global_trace.buffer, val);
+		if (ret < 0) {
+			cnt = ret;
 			goto out;
 		}
 
-		freeable_pages = determine_dirtyable_memory();
-
-		/* we only allow to request 1/4 of useable memory */
-		if (pages_requested >
-		    ((freeable_pages + tracing_pages_allocated) / 4)) {
-			cnt = -ENOMEM;
-			goto out;
-		}
-
-		while (global_trace.entries < val) {
-			if (trace_alloc_page()) {
-				cnt = -ENOMEM;
-				goto out;
+		ret = ring_buffer_resize(max_tr.buffer, val);
+		if (ret < 0) {
+			int r;
+			cnt = ret;
+			r = ring_buffer_resize(global_trace.buffer,
+					       global_trace.entries);
+			if (r < 0) {
+				/* AARGH! We are left with different
+				 * size max buffer!!!! */
+				WARN_ON(1);
+				tracing_disabled = 1;
 			}
-			/* double check that we don't go over the known pages */
-			if (tracing_pages_allocated > pages_requested)
-				break;
+			goto out;
 		}
 
-	} else {
-		/* include the number of entries in val (inc of page entries) */
-		while (global_trace.entries > val + (ENTRIES_PER_PAGE - 1))
-			trace_free_page();
+		global_trace.entries = val;
 	}
 
-	/* check integrity */
-	for_each_tracing_cpu(i)
-		check_pages(global_trace.data[i]);
-
 	filp->f_pos += cnt;
 
 	/* If check pages failed, return ENOMEM */
@@ -2930,190 +2683,41 @@ static __init void tracer_init_debugfs(v
 #endif
 }
 
-static int trace_alloc_page(void)
+__init static int tracer_alloc_buffers(void)
 {
 	struct trace_array_cpu *data;
-	struct page *page, *tmp;
-	LIST_HEAD(pages);
-	void *array;
-	unsigned pages_allocated = 0;
 	int i;
 
-	/* first allocate a page for each CPU */
-	for_each_tracing_cpu(i) {
-		array = (void *)__get_free_page(GFP_KERNEL);
-		if (array == NULL) {
-			printk(KERN_ERR "tracer: failed to allocate page"
-			       "for trace buffer!\n");
-			goto free_pages;
-		}
-
-		pages_allocated++;
-		page = virt_to_page(array);
-		list_add(&page->lru, &pages);
+	/* TODO: make the number of buffers hot pluggable with CPUS */
+	tracing_buffer_mask = cpu_possible_map;
 
-/* Only allocate if we are actually using the max trace */
-#ifdef CONFIG_TRACER_MAX_TRACE
-		array = (void *)__get_free_page(GFP_KERNEL);
-		if (array == NULL) {
-			printk(KERN_ERR "tracer: failed to allocate page"
-			       "for trace buffer!\n");
-			goto free_pages;
-		}
-		pages_allocated++;
-		page = virt_to_page(array);
-		list_add(&page->lru, &pages);
-#endif
+	global_trace.buffer = ring_buffer_alloc(trace_buf_size,
+						   TRACE_BUFFER_FLAGS);
+	if (!global_trace.buffer) {
+		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
+		WARN_ON(1);
+		return 0;
 	}
-
-	/* Now that we successfully allocate a page per CPU, add them */
-	for_each_tracing_cpu(i) {
-		data = global_trace.data[i];
-		page = list_entry(pages.next, struct page, lru);
-		list_del_init(&page->lru);
-		list_add_tail(&page->lru, &data->trace_pages);
-		ClearPageLRU(page);
+	global_trace.entries = ring_buffer_size(global_trace.buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-		data = max_tr.data[i];
-		page = list_entry(pages.next, struct page, lru);
-		list_del_init(&page->lru);
-		list_add_tail(&page->lru, &data->trace_pages);
-		SetPageLRU(page);
-#endif
-	}
-	tracing_pages_allocated += pages_allocated;
-	global_trace.entries += ENTRIES_PER_PAGE;
-
-	return 0;
-
- free_pages:
-	list_for_each_entry_safe(page, tmp, &pages, lru) {
-		list_del_init(&page->lru);
-		__free_page(page);
+	max_tr.buffer = ring_buffer_alloc(trace_buf_size,
+					     TRACE_BUFFER_FLAGS);
+	if (!max_tr.buffer) {
+		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
+		WARN_ON(1);
+		ring_buffer_free(global_trace.buffer);
+		return 0;
 	}
-	return -ENOMEM;
-}
-
-static int trace_free_page(void)
-{
-	struct trace_array_cpu *data;
-	struct page *page;
-	struct list_head *p;
-	int i;
-	int ret = 0;
-
-	/* free one page from each buffer */
-	for_each_tracing_cpu(i) {
-		data = global_trace.data[i];
-		p = data->trace_pages.next;
-		if (p == &data->trace_pages) {
-			/* should never happen */
-			WARN_ON(1);
-			tracing_disabled = 1;
-			ret = -1;
-			break;
-		}
-		page = list_entry(p, struct page, lru);
-		ClearPageLRU(page);
-		list_del(&page->lru);
-		tracing_pages_allocated--;
-		tracing_pages_allocated--;
-		__free_page(page);
-
-		tracing_reset(data);
-
-#ifdef CONFIG_TRACER_MAX_TRACE
-		data = max_tr.data[i];
-		p = data->trace_pages.next;
-		if (p == &data->trace_pages) {
-			/* should never happen */
-			WARN_ON(1);
-			tracing_disabled = 1;
-			ret = -1;
-			break;
-		}
-		page = list_entry(p, struct page, lru);
-		ClearPageLRU(page);
-		list_del(&page->lru);
-		__free_page(page);
-
-		tracing_reset(data);
+	max_tr.entries = ring_buffer_size(max_tr.buffer);
+	WARN_ON(max_tr.entries != global_trace.entries);
 #endif
-	}
-	global_trace.entries -= ENTRIES_PER_PAGE;
-
-	return ret;
-}
-
-__init static int tracer_alloc_buffers(void)
-{
-	struct trace_array_cpu *data;
-	void *array;
-	struct page *page;
-	int pages = 0;
-	int ret = -ENOMEM;
-	int i;
-
-	/* TODO: make the number of buffers hot pluggable with CPUS */
-	tracing_nr_buffers = num_possible_cpus();
-	tracing_buffer_mask = cpu_possible_map;
 
 	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
 		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
 		max_tr.data[i] = &per_cpu(max_data, i);
-
-		array = (void *)__get_free_page(GFP_KERNEL);
-		if (array == NULL) {
-			printk(KERN_ERR "tracer: failed to allocate page"
-			       "for trace buffer!\n");
-			goto free_buffers;
-		}
-
-		/* set the array to the list */
-		INIT_LIST_HEAD(&data->trace_pages);
-		page = virt_to_page(array);
-		list_add(&page->lru, &data->trace_pages);
-		/* use the LRU flag to differentiate the two buffers */
-		ClearPageLRU(page);
-
-		data->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		max_tr.data[i]->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-
-/* Only allocate if we are actually using the max trace */
-#ifdef CONFIG_TRACER_MAX_TRACE
-		array = (void *)__get_free_page(GFP_KERNEL);
-		if (array == NULL) {
-			printk(KERN_ERR "tracer: failed to allocate page"
-			       "for trace buffer!\n");
-			goto free_buffers;
-		}
-
-		INIT_LIST_HEAD(&max_tr.data[i]->trace_pages);
-		page = virt_to_page(array);
-		list_add(&page->lru, &max_tr.data[i]->trace_pages);
-		SetPageLRU(page);
-#endif
-	}
-
-	/*
-	 * Since we allocate by orders of pages, we may be able to
-	 * round up a bit.
-	 */
-	global_trace.entries = ENTRIES_PER_PAGE;
-	pages++;
-
-	while (global_trace.entries < trace_nr_entries) {
-		if (trace_alloc_page())
-			break;
-		pages++;
 	}
-	max_tr.entries = global_trace.entries;
-
-	pr_info("tracer: %d pages allocated for %ld entries of %ld bytes\n",
-		pages, trace_nr_entries, (long)TRACE_ENTRY_SIZE);
-	pr_info("   actual entries %ld\n", global_trace.entries);
 
 	tracer_init_debugfs();
 
@@ -3127,31 +2731,5 @@ __init static int tracer_alloc_buffers(v
 	tracing_disabled = 0;
 
 	return 0;
-
- free_buffers:
-	for (i-- ; i >= 0; i--) {
-		struct page *page, *tmp;
-		struct trace_array_cpu *data = global_trace.data[i];
-
-		if (data) {
-			list_for_each_entry_safe(page, tmp,
-						 &data->trace_pages, lru) {
-				list_del_init(&page->lru);
-				__free_page(page);
-			}
-		}
-
-#ifdef CONFIG_TRACER_MAX_TRACE
-		data = max_tr.data[i];
-		if (data) {
-			list_for_each_entry_safe(page, tmp,
-						 &data->trace_pages, lru) {
-				list_del_init(&page->lru);
-				__free_page(page);
-			}
-		}
-#endif
-	}
-	return ret;
 }
 fs_initcall(tracer_alloc_buffers);
Index: linux-compile.git/kernel/trace/trace.h
===================================================================
--- linux-compile.git.orig/kernel/trace/trace.h	2008-09-25 12:34:11.000000000 -0400
+++ linux-compile.git/kernel/trace/trace.h	2008-09-25 12:34:23.000000000 -0400
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/clocksource.h>
 #include <linux/mmiotrace.h>
+#include <linux/ring_buffer.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -72,7 +73,6 @@ struct trace_entry {
 	char			flags;
 	char			preempt_count;
 	int			pid;
-	cycle_t			t;
 	union {
 		struct ftrace_entry		fn;
 		struct ctx_switch_entry		ctx;
@@ -91,16 +91,9 @@ struct trace_entry {
  * the trace, etc.)
  */
 struct trace_array_cpu {
-	struct list_head	trace_pages;
 	atomic_t		disabled;
-	raw_spinlock_t		lock;
-	struct lock_class_key	lock_key;
 
 	/* these fields get copied into max-trace: */
-	unsigned		trace_head_idx;
-	unsigned		trace_tail_idx;
-	void			*trace_head; /* producer */
-	void			*trace_tail; /* consumer */
 	unsigned long		trace_idx;
 	unsigned long		overrun;
 	unsigned long		saved_latency;
@@ -124,6 +117,7 @@ struct trace_iterator;
  * They have on/off state as well:
  */
 struct trace_array {
+	struct ring_buffer	*buffer;
 	unsigned long		entries;
 	long			ctrl;
 	int			cpu;
@@ -171,26 +165,20 @@ struct trace_iterator {
 	struct trace_array	*tr;
 	struct tracer		*trace;
 	void			*private;
-	long			last_overrun[NR_CPUS];
-	long			overrun[NR_CPUS];
+	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
 
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
 	int			cpu;
-
-	struct trace_entry	*prev_ent;
-	int			prev_cpu;
+	u64			ts;
 
 	unsigned long		iter_flags;
 	loff_t			pos;
-	unsigned long		next_idx[NR_CPUS];
-	struct list_head	*next_page[NR_CPUS];
-	unsigned		next_page_idx[NR_CPUS];
 	long			idx;
 };
 
-void tracing_reset(struct trace_array_cpu *data);
+void tracing_reset(struct trace_array *tr, int cpu);
 int tracing_open_generic(struct inode *inode, struct file *filp);
 struct dentry *tracing_init_dentry(void);
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
Index: linux-compile.git/kernel/trace/trace_functions.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_functions.c	2008-09-25 12:34:11.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_functions.c	2008-09-25 12:34:23.000000000 -0400
@@ -23,7 +23,7 @@ static void function_reset(struct trace_
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static void start_function_trace(struct trace_array *tr)
Index: linux-compile.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_irqsoff.c	2008-09-25 12:34:11.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_irqsoff.c	2008-09-25 12:34:23.000000000 -0400
@@ -173,7 +173,7 @@ out_unlock:
 out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
-	tracing_reset(data);
+	tracing_reset(tr, cpu);
 	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags);
 }
 
@@ -203,7 +203,7 @@ start_critical_timing(unsigned long ip, 
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
 	data->critical_start = parent_ip ? : ip;
-	tracing_reset(data);
+	tracing_reset(tr, cpu);
 
 	local_save_flags(flags);
 
@@ -234,7 +234,7 @@ stop_critical_timing(unsigned long ip, u
 
 	data = tr->data[cpu];
 
-	if (unlikely(!data) || unlikely(!head_page(data)) ||
+	if (unlikely(!data) ||
 	    !data->critical_start || atomic_read(&data->disabled))
 		return;
 
Index: linux-compile.git/kernel/trace/trace_mmiotrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_mmiotrace.c	2008-09-25 12:34:11.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_mmiotrace.c	2008-09-25 12:34:23.000000000 -0400
@@ -27,7 +27,7 @@ static void mmio_reset_data(struct trace
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static void mmio_trace_init(struct trace_array *tr)
@@ -130,10 +130,14 @@ static unsigned long count_overruns(stru
 {
 	int cpu;
 	unsigned long cnt = 0;
+/* FIXME: */
+#if 0
 	for_each_online_cpu(cpu) {
 		cnt += iter->overrun[cpu];
 		iter->overrun[cpu] = 0;
 	}
+#endif
+	(void)cpu;
 	return cnt;
 }
 
@@ -176,7 +180,7 @@ static int mmio_print_rw(struct trace_it
 	struct trace_entry *entry = iter->ent;
 	struct mmiotrace_rw *rw	= &entry->mmiorw;
 	struct trace_seq *s	= &iter->seq;
-	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
@@ -218,7 +222,7 @@ static int mmio_print_map(struct trace_i
 	struct trace_entry *entry = iter->ent;
 	struct mmiotrace_map *m	= &entry->mmiomap;
 	struct trace_seq *s	= &iter->seq;
-	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
Index: linux-compile.git/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_sched_switch.c	2008-09-25 12:34:11.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_sched_switch.c	2008-09-25 12:34:23.000000000 -0400
@@ -133,7 +133,7 @@ static void sched_switch_reset(struct tr
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static int tracing_sched_register(void)
Index: linux-compile.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_sched_wakeup.c	2008-09-25 12:34:11.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_sched_wakeup.c	2008-09-25 12:34:23.000000000 -0400
@@ -216,7 +216,7 @@ static void __wakeup_reset(struct trace_
 
 	for_each_possible_cpu(cpu) {
 		data = tr->data[cpu];
-		tracing_reset(data);
+		tracing_reset(tr, cpu);
 	}
 
 	wakeup_cpu = -1;

-- 
