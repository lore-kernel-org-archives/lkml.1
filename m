Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYIXFO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYIXFO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYIXFOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:14:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYIXFOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:14:16 -0400
Message-Id: <20080924051400.552924670@goodmis.org>
References: <20080924051056.650388887@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 24 Sep 2008 01:10:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Tom Zanussi <zanussi@comcast.net>, Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 3/3] ftrace: hack in the ring buffer
Content-Disposition: inline; filename=ftrace-use-ring-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a test case for the unified ring buffer, I wanted to try it out with
ftrace. This is a big patch that hacks up ftrace to get it to work.
Actually, I see areas that can be greatly improved with this new approach.
A lot of clean ups can follow this.

But before I go ahead and do all this work, I want to "release early
release often". This way I can get the feedback (whew, it's hot in here)
that will let me know what is expected.

Note, selftest is busted with this patch. I didn't have time to fixe it.

All these patches are busted, this is RFC remember!

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/Makefile          |    1 
 include/linux/ftrace.h            |    6 
 include/linux/mmiotrace.h         |    3 
 kernel/trace/trace.c              | 1326 ++++++++++----------------------------
 kernel/trace/trace.h              |   87 --
 kernel/trace/trace_functions.c    |    2 
 kernel/trace/trace_irqsoff.c      |   38 -
 kernel/trace/trace_mmiotrace.c    |   73 --
 kernel/trace/trace_sched_switch.c |    2 
 kernel/trace/trace_sched_wakeup.c |    3 
 10 files changed, 464 insertions(+), 1077 deletions(-)

Index: linux-compile.git/kernel/trace/trace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace.c	2008-09-23 23:33:47.000000000 -0400
+++ linux-compile.git/kernel/trace/trace.c	2008-09-24 00:16:24.000000000 -0400
@@ -31,25 +31,24 @@
 #include <linux/writeback.h>
 
 #include <linux/stacktrace.h>
+#include <linux/ring_buffer.h>
 
 #include "trace.h"
 
+#define FTRACE_BUF_NAME		"ftrace"
+
+#define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE | RB_FL_SNAPSHOT)
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
@@ -79,20 +78,6 @@ static struct trace_array	global_trace;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
-/*
- * The max_tr is used to snapshot the global_trace when a maximum
- * latency is reached. Some tracers will use this to store a maximum
- * trace while it continues examining live traces.
- *
- * The buffers for the max_tr are set up the same as the global_trace.
- * When a snapshot is taken, the link list of the max_tr is swapped
- * with the link list of the global_trace and the buffers are reset for
- * the global_trace so the tracing can continue.
- */
-static struct trace_array	max_tr;
-
-static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
-
 /* tracer_enabled is used to toggle activation of a tracer */
 static int			tracer_enabled = 1;
 
@@ -100,11 +85,11 @@ static int			tracer_enabled = 1;
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
@@ -140,7 +125,7 @@ static notrace void no_trace_init(struct
 	ftrace_function_enabled = 0;
 	if(tr->ctrl)
 		for_each_online_cpu(cpu)
-			tracing_reset(tr->data[cpu]);
+			tracing_reset(tr, cpu);
 	tracer_enabled = 0;
 }
 
@@ -167,23 +152,21 @@ void trace_wake_up(void)
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
@@ -249,245 +232,20 @@ __update_max_tr(struct trace_array *tr, 
 {
 	struct trace_array_cpu *data = tr->data[cpu];
 
-	max_tr.cpu = cpu;
-	max_tr.time_start = data->preempt_timestamp;
-
-	data = max_tr.data[cpu];
-	data->saved_latency = tracing_max_latency;
-
-	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
-	data->pid = tsk->pid;
-	data->uid = tsk->uid;
-	data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
-	data->policy = tsk->policy;
-	data->rt_priority = tsk->rt_priority;
+	tr->cpu = cpu;
+	tr->time_start = data->preempt_timestamp;
+	tr->saved_latency = tracing_max_latency;
+	tr->pid = tsk->pid;
+	tr->uid = tsk->uid;
+	tr->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
+	tr->policy = tsk->policy;
+	tr->rt_priority = tsk->rt_priority;
+	memcpy(tr->comm, tsk->comm, TASK_COMM_LEN);
 
 	/* record this tasks comm */
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
-/**
- * trace_seq_printf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	va_list ap;
-	int ret;
-
-	if (!len)
-		return 0;
-
-	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
-	va_end(ap);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
-		return 0;
-
-	s->len += ret;
-
-	return len;
-}
-
-/**
- * trace_seq_puts - trace sequence printing of simple string
- * @s: trace sequence descriptor
- * @str: simple string to record
- *
- * The tracer may use either the sequence operations or its own
- * copy to user routines. This function records a simple string
- * into a special buffer (@s) for later retrieval by a sequencer
- * or other mechanism.
- */
-static int
-trace_seq_puts(struct trace_seq *s, const char *str)
-{
-	int len = strlen(str);
-
-	if (len > ((PAGE_SIZE - 1) - s->len))
-		return 0;
-
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
-
-	return len;
-}
-
-static int
-trace_seq_putc(struct trace_seq *s, unsigned char c)
-{
-	if (s->len >= (PAGE_SIZE - 1))
-		return 0;
-
-	s->buffer[s->len++] = c;
-
-	return 1;
-}
-
-static int
-trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
-{
-	if (len > ((PAGE_SIZE - 1) - s->len))
-		return 0;
-
-	memcpy(s->buffer + s->len, mem, len);
-	s->len += len;
-
-	return len;
-}
-
-#define HEX_CHARS 17
-static const char hex2asc[] = "0123456789abcdef";
-
-static int
-trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
-{
-	unsigned char hex[HEX_CHARS];
-	unsigned char *data = mem;
-	unsigned char byte;
-	int i, j;
-
-	BUG_ON(len >= HEX_CHARS);
-
-#ifdef __BIG_ENDIAN
-	for (i = 0, j = 0; i < len; i++) {
-#else
-	for (i = len-1, j = 0; i >= 0; i--) {
-#endif
-		byte = data[i];
-
-		hex[j++] = hex2asc[byte & 0x0f];
-		hex[j++] = hex2asc[byte >> 4];
-	}
-	hex[j++] = ' ';
-
-	return trace_seq_putmem(s, hex, j);
-}
-
-static void
-trace_seq_reset(struct trace_seq *s)
-{
-	s->len = 0;
-	s->readpos = 0;
-}
-
-ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
-{
-	int len;
-	int ret;
-
-	if (s->len <= s->readpos)
-		return -EBUSY;
-
-	len = s->len - s->readpos;
-	if (cnt > len)
-		cnt = len;
-	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
-	if (ret)
-		return -EFAULT;
-
-	s->readpos += len;
-	return cnt;
-}
-
-static void
-trace_print_seq(struct seq_file *m, struct trace_seq *s)
-{
-	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
-
-	s->buffer[len] = 0;
-	seq_puts(m, s->buffer);
-
-	trace_seq_reset(s);
-}
-
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
@@ -500,18 +258,9 @@ flip_trace(struct trace_array_cpu *tr1, 
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_array_cpu *data;
-	int i;
-
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
-	/* clear out all the previous traces */
-	for_each_tracing_cpu(i) {
-		data = tr->data[i];
-		flip_trace(max_tr.data[i], data);
-		tracing_reset(data);
-	}
-
+	ring_buffer_snapshot(tr->buffer);
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
 }
@@ -527,21 +276,20 @@ update_max_tr(struct trace_array *tr, st
 void
 update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_array_cpu *data = tr->data[cpu];
-	int i;
-
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
-	for_each_tracing_cpu(i)
-		tracing_reset(max_tr.data[i]);
-
-	flip_trace(max_tr.data[cpu], data);
-	tracing_reset(data);
-
+	ring_buffer_snapshot_one_cpu(tr->buffer, cpu);
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
 }
 
+#define CHECK_COND(cond)			\
+	if (unlikely(cond)) {			\
+		tracing_disabled = 1;		\
+		WARN_ON(1);			\
+		return -1;			\
+	}
+
 /**
  * register_tracer - register a tracer with the ftrace system.
  * @type - the plugin for the tracer
@@ -573,7 +321,6 @@ int register_tracer(struct tracer *type)
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	if (type->selftest) {
 		struct tracer *saved_tracer = current_trace;
-		struct trace_array_cpu *data;
 		struct trace_array *tr = &global_trace;
 		int saved_ctrl = tr->ctrl;
 		int i;
@@ -585,10 +332,7 @@ int register_tracer(struct tracer *type)
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
@@ -604,10 +348,7 @@ int register_tracer(struct tracer *type)
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
@@ -653,13 +394,9 @@ void unregister_tracer(struct tracer *ty
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
@@ -745,70 +482,6 @@ void tracing_record_cmdline(struct task_
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
@@ -819,7 +492,6 @@ tracing_generic_entry_update(struct trac
 
 	entry->preempt_count	= pc & 0xff;
 	entry->pid		= (tsk) ? tsk->pid : 0;
-	entry->t		= ftrace_now(raw_smp_processor_id());
 	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
@@ -830,18 +502,17 @@ void
 trace_function(struct trace_array *tr, struct trace_array_cpu *data,
 	       unsigned long ip, unsigned long parent_ip, unsigned long flags)
 {
-	struct trace_entry *entry;
+	struct ftrace_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_FN;
-	entry->fn.ip		= ip;
-	entry->fn.parent_ip	= parent_ip;
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	entry = ring_buffer_lock_reserve(tr->buffer, TRACE_FN, sizeof(*entry),
+					 &irq_flags);
+	if (!entry)
+		return;
+	tracing_generic_entry_update(&entry->ent, flags);
+	entry->ip		= ip;
+	entry->parent_ip	= parent_ip;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 }
 
 void
@@ -856,19 +527,16 @@ ftrace(struct trace_array *tr, struct tr
 void __trace_mmiotrace_rw(struct trace_array *tr, struct trace_array_cpu *data,
 						struct mmiotrace_rw *rw)
 {
-	struct trace_entry *entry;
+	struct mmiotrace_rw *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_MMIO_RW;
-	entry->mmiorw		= *rw;
-
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	entry = ring_buffer_lock_reserve(tr->buffer, TRACE_MMIO_RW,
+					 sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
+	tracing_generic_entry_update(&entry->ent, 0);
+	*entry			= *rw;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 
 	trace_wake_up();
 }
@@ -876,19 +544,16 @@ void __trace_mmiotrace_rw(struct trace_a
 void __trace_mmiotrace_map(struct trace_array *tr, struct trace_array_cpu *data,
 						struct mmiotrace_map *map)
 {
-	struct trace_entry *entry;
+	struct mmiotrace_map *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_MMIO_MAP;
-	entry->mmiomap		= *map;
-
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	entry = ring_buffer_lock_reserve(tr->buffer, TRACE_MMIO_MAP,
+					 sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
+	tracing_generic_entry_update(&entry->ent, 0);
+	*entry			= *map;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 
 	trace_wake_up();
 }
@@ -899,24 +564,28 @@ void __trace_stack(struct trace_array *t
 		   unsigned long flags,
 		   int skip)
 {
-	struct trace_entry *entry;
+	struct stack_entry *entry;
 	struct stack_trace trace;
+	unsigned long irq_flags;
 
 	if (!(trace_flags & TRACE_ITER_STACKTRACE))
 		return;
 
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_STACK;
+	entry = ring_buffer_lock_reserve(tr->buffer, FTRACE_STACK_ENTRIES,
+					 sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
+	tracing_generic_entry_update(&entry->ent, flags);
 
-	memset(&entry->stack, 0, sizeof(entry->stack));
+	memset(&entry->caller, 0, sizeof(entry->caller));
 
 	trace.nr_entries	= 0;
 	trace.max_entries	= FTRACE_STACK_ENTRIES;
 	trace.skip		= skip;
-	trace.entries		= entry->stack.caller;
+	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 }
 
 void
@@ -925,20 +594,19 @@ __trace_special(void *__tr, void *__data
 {
 	struct trace_array_cpu *data = __data;
 	struct trace_array *tr = __tr;
-	struct trace_entry *entry;
+	struct special_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_SPECIAL;
-	entry->special.arg1	= arg1;
-	entry->special.arg2	= arg2;
-	entry->special.arg3	= arg3;
+	entry = ring_buffer_lock_reserve(tr->buffer, TRACE_SPECIAL,
+					 sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
+	tracing_generic_entry_update(&entry->ent, 0);
+	entry->arg1	= arg1;
+	entry->arg2	= arg2;
+	entry->arg3	= arg3;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 	__trace_stack(tr, data, irq_flags, 4);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
 
 	trace_wake_up();
 }
@@ -950,23 +618,22 @@ tracing_sched_switch_trace(struct trace_
 			   struct task_struct *next,
 			   unsigned long flags)
 {
-	struct trace_entry *entry;
+	struct ctx_switch_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_CTX;
-	entry->ctx.prev_pid	= prev->pid;
-	entry->ctx.prev_prio	= prev->prio;
-	entry->ctx.prev_state	= prev->state;
-	entry->ctx.next_pid	= next->pid;
-	entry->ctx.next_prio	= next->prio;
-	entry->ctx.next_state	= next->state;
+	entry = ring_buffer_lock_reserve(tr->buffer, TRACE_CTX,
+					 sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
+	tracing_generic_entry_update(&entry->ent, flags);
+	entry->prev_pid		= prev->pid;
+	entry->prev_prio	= prev->prio;
+	entry->prev_state	= prev->state;
+	entry->next_pid		= next->pid;
+	entry->next_prio	= next->prio;
+	entry->next_state	= next->state;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 	__trace_stack(tr, data, flags, 5);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
 }
 
 void
@@ -976,23 +643,22 @@ tracing_sched_wakeup_trace(struct trace_
 			   struct task_struct *curr,
 			   unsigned long flags)
 {
-	struct trace_entry *entry;
+	struct ctx_switch_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_WAKE;
-	entry->ctx.prev_pid	= curr->pid;
-	entry->ctx.prev_prio	= curr->prio;
-	entry->ctx.prev_state	= curr->state;
-	entry->ctx.next_pid	= wakee->pid;
-	entry->ctx.next_prio	= wakee->prio;
-	entry->ctx.next_state	= wakee->state;
+	entry = ring_buffer_lock_reserve(tr->buffer, TRACE_WAKE,
+					 sizeof(*entry), &irq_flags);
+	if (!entry)
+		return;
+	tracing_generic_entry_update(&entry->ent, flags);
+	entry->prev_pid	= curr->pid;
+	entry->prev_prio	= curr->prio;
+	entry->prev_state	= curr->state;
+	entry->next_pid	= wakee->pid;
+	entry->next_prio	= wakee->prio;
+	entry->next_state	= wakee->state;
+	ring_buffer_unlock_commit(tr->buffer, entry, irq_flags);
 	__trace_stack(tr, data, flags, 6);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
 
 	trace_wake_up();
 }
@@ -1070,112 +736,21 @@ void tracing_stop_function_trace(void)
 #endif
 
 enum trace_file_type {
-	TRACE_FILE_LAT_FMT	= 1,
+	TRACE_FILE_LAT_FMT	= 1 << 0,
+	TRACE_FILE_USE_MAX	= 1 << 1,
 };
 
-static struct trace_entry *
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
-{
-	struct trace_array *tr = iter->tr;
-	struct trace_entry *ent, *next = NULL;
-	int next_cpu = -1;
-	int cpu;
-
-	for_each_tracing_cpu(cpu) {
-		if (!head_page(tr->data[cpu]))
-			continue;
-		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
-		/*
-		 * Pick the entry with the smallest timestamp:
-		 */
-		if (ent && (!next || ent->t < next->t)) {
-			next = ent;
-			next_cpu = cpu;
-		}
-	}
-
-	if (ent_cpu)
-		*ent_cpu = next_cpu;
-
-	return next;
-}
-
-static void trace_iterator_increment(struct trace_iterator *iter)
-{
-	iter->idx++;
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
-}
-
-static void trace_consume(struct trace_iterator *iter)
-{
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
-}
-
 static void *find_next_entry_inc(struct trace_iterator *iter)
 {
-	struct trace_entry *next;
+	struct ring_buffer_event *next;
 	int next_cpu = -1;
 
-	next = find_next_entry(iter, &next_cpu);
-
-	iter->prev_ent = iter->ent;
-	iter->prev_cpu = iter->cpu;
-
-	iter->ent = next;
+	next = ring_buffer_read(iter->buffer_iter, &next_cpu);
+	iter->event = next;
 	iter->cpu = next_cpu;
 
 	if (next)
-		trace_iterator_increment(iter);
+		iter->idx++;
 
 	return next ? iter : NULL;
 }
@@ -1210,7 +785,6 @@ static void *s_start(struct seq_file *m,
 	struct trace_iterator *iter = m->private;
 	void *p = NULL;
 	loff_t l = 0;
-	int i;
 
 	mutex_lock(&trace_types_lock);
 
@@ -1226,16 +800,9 @@ static void *s_start(struct seq_file *m,
 		current_trace->start(iter);
 
 	if (*pos != iter->pos) {
-		iter->ent = NULL;
+		iter->event = NULL;
 		iter->cpu = 0;
 		iter->idx = -1;
-		iter->prev_ent = NULL;
-		iter->prev_cpu = -1;
-
-		for_each_tracing_cpu(i) {
-			iter->next_idx[i] = 0;
-			iter->next_page[i] = NULL;
-		}
 
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
 			;
@@ -1276,27 +843,27 @@ static inline int kretprobed(unsigned lo
 #endif /* CONFIG_KRETPROBES */
 
 static int
-seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
+seq_print_sym_short(struct ring_buffer_seq *s, const char *fmt, unsigned long address)
 {
 #ifdef CONFIG_KALLSYMS
 	char str[KSYM_SYMBOL_LEN];
 
 	kallsyms_lookup(address, NULL, NULL, NULL, str);
 
-	return trace_seq_printf(s, fmt, str);
+	return ring_buffer_seq_printf(s, fmt, str);
 #endif
 	return 1;
 }
 
 static int
-seq_print_sym_offset(struct trace_seq *s, const char *fmt,
+seq_print_sym_offset(struct ring_buffer_seq *s, const char *fmt,
 		     unsigned long address)
 {
 #ifdef CONFIG_KALLSYMS
 	char str[KSYM_SYMBOL_LEN];
 
 	sprint_symbol(str, address);
-	return trace_seq_printf(s, fmt, str);
+	return ring_buffer_seq_printf(s, fmt, str);
 #endif
 	return 1;
 }
@@ -1308,12 +875,12 @@ seq_print_sym_offset(struct trace_seq *s
 #endif
 
 static int
-seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
+seq_print_ip_sym(struct ring_buffer_seq *s, unsigned long ip, unsigned long sym_flags)
 {
 	int ret;
 
 	if (!ip)
-		return trace_seq_printf(s, "0");
+		return ring_buffer_seq_printf(s, "0");
 
 	if (sym_flags & TRACE_ITER_SYM_OFFSET)
 		ret = seq_print_sym_offset(s, "%s", ip);
@@ -1324,7 +891,7 @@ seq_print_ip_sym(struct trace_seq *s, un
 		return 0;
 
 	if (sym_flags & TRACE_ITER_SYM_ADDR)
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+		ret = ring_buffer_seq_printf(s, " <" IP_FMT ">", ip);
 	return ret;
 }
 
@@ -1357,21 +924,12 @@ print_trace_header(struct seq_file *m, s
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
@@ -1379,7 +937,7 @@ print_trace_header(struct seq_file *m, s
 		 "---------------------------------\n");
 	seq_printf(m, " latency: %lu us, #%lu/%lu, CPU#%d |"
 		   " (M:%s VP:%d, KP:%d, SP:%d HP:%d",
-		   nsecs_to_usecs(data->saved_latency),
+		   nsecs_to_usecs(tr->saved_latency),
 		   entries,
 		   total,
 		   tr->cpu,
@@ -1402,17 +960,17 @@ print_trace_header(struct seq_file *m, s
 	seq_puts(m, "    -----------------\n");
 	seq_printf(m, "    | task: %.16s-%d "
 		   "(uid:%d nice:%ld policy:%ld rt_prio:%ld)\n",
-		   data->comm, data->pid, data->uid, data->nice,
-		   data->policy, data->rt_priority);
+		   tr->comm, tr->pid, tr->uid, tr->nice,
+		   tr->policy, tr->rt_priority);
 	seq_puts(m, "    -----------------\n");
 
 	if (data->critical_start) {
 		seq_puts(m, " => started at: ");
-		seq_print_ip_sym(&iter->seq, data->critical_start, sym_flags);
-		trace_print_seq(m, &iter->seq);
+		seq_print_ip_sym(iter->seq, data->critical_start, sym_flags);
+		ring_buffer_seq_to_seqfile(m, iter->seq);
 		seq_puts(m, "\n => ended at:   ");
-		seq_print_ip_sym(&iter->seq, data->critical_end, sym_flags);
-		trace_print_seq(m, &iter->seq);
+		seq_print_ip_sym(iter->seq, data->critical_end, sym_flags);
+		ring_buffer_seq_to_seqfile(m, iter->seq);
 		seq_puts(m, "\n");
 	}
 
@@ -1420,71 +978,71 @@ print_trace_header(struct seq_file *m, s
 }
 
 static void
-lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
+lat_print_generic(struct ring_buffer_seq *s, struct trace_entry *entry, int cpu)
 {
 	int hardirq, softirq;
 	char *comm;
 
 	comm = trace_find_cmdline(entry->pid);
 
-	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
-	trace_seq_printf(s, "%d", cpu);
-	trace_seq_printf(s, "%c%c",
+	ring_buffer_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
+	ring_buffer_seq_printf(s, "%d", cpu);
+	ring_buffer_seq_printf(s, "%c%c",
 			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
 			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
 
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
 	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
 	if (hardirq && softirq) {
-		trace_seq_putc(s, 'H');
+		ring_buffer_seq_putc(s, 'H');
 	} else {
 		if (hardirq) {
-			trace_seq_putc(s, 'h');
+			ring_buffer_seq_putc(s, 'h');
 		} else {
 			if (softirq)
-				trace_seq_putc(s, 's');
+				ring_buffer_seq_putc(s, 's');
 			else
-				trace_seq_putc(s, '.');
+				ring_buffer_seq_putc(s, '.');
 		}
 	}
 
 	if (entry->preempt_count)
-		trace_seq_printf(s, "%x", entry->preempt_count);
+		ring_buffer_seq_printf(s, "%x", entry->preempt_count);
 	else
-		trace_seq_puts(s, ".");
+		ring_buffer_seq_puts(s, ".");
 }
 
 unsigned long preempt_mark_thresh = 100;
 
 static void
-lat_print_timestamp(struct trace_seq *s, unsigned long long abs_usecs,
+lat_print_timestamp(struct ring_buffer_seq *s, unsigned long long abs_usecs,
 		    unsigned long rel_usecs)
 {
-	trace_seq_printf(s, " %4lldus", abs_usecs);
+	ring_buffer_seq_printf(s, " %4lldus", abs_usecs);
 	if (rel_usecs > preempt_mark_thresh)
-		trace_seq_puts(s, "!: ");
+		ring_buffer_seq_puts(s, "!: ");
 	else if (rel_usecs > 1)
-		trace_seq_puts(s, "+: ");
+		ring_buffer_seq_puts(s, "+: ");
 	else
-		trace_seq_puts(s, " : ");
+		ring_buffer_seq_puts(s, " : ");
 }
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
 #define SEQ_PUT_FIELD_RET(s, x)				\
 do {							\
-	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
+	if (!ring_buffer_seq_putmem(s, &(x), sizeof(x)))	\
 		return 0;				\
 } while (0)
 
 #define SEQ_PUT_HEX_FIELD_RET(s, x)			\
 do {							\
-	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
+	if (!ring_buffer_seq_putmem_hex(s, &(x), sizeof(x)))	\
 		return 0;				\
 } while (0)
 
 static int
-trace_print_func(struct trace_seq *s, struct ftrace_entry *entry,
+trace_print_func(struct ring_buffer_seq *s, struct ftrace_entry *entry,
 		 int sym_flags, int print_type)
 {
 	int ret = 1;
@@ -1499,17 +1057,17 @@ trace_print_func(struct trace_seq *s, st
 		SEQ_PUT_HEX_FIELD_RET(s, entry->parent_ip);
 		break;
 	case TRACE_ITER_RAW:
-		ret = trace_seq_printf(s, "%x %x\n",
+		ret = ring_buffer_seq_printf(s, "%lx %lx\n",
 					entry->ip, entry->parent_ip);
 		break;
 	case TRACE_FILE_LAT_FMT:
 		seq_print_ip_sym(s, entry->ip, sym_flags);
-		trace_seq_puts(s, " (");
+		ring_buffer_seq_puts(s, " (");
 		if (kretprobed(entry->parent_ip))
-			trace_seq_puts(s, KRETPROBE_MSG);
+			ring_buffer_seq_puts(s, KRETPROBE_MSG);
 		else
 			seq_print_ip_sym(s, entry->parent_ip, sym_flags);
-		trace_seq_puts(s, ")\n");
+		ring_buffer_seq_puts(s, ")\n");
 		break;
 	default:
 		ret = seq_print_ip_sym(s, entry->ip, sym_flags);
@@ -1517,25 +1075,25 @@ trace_print_func(struct trace_seq *s, st
 			return 0;
 		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
 					entry->parent_ip) {
-			ret = trace_seq_printf(s, " <-");
+			ret = ring_buffer_seq_printf(s, " <-");
 			if (!ret)
 				return 0;
 			if (kretprobed(entry->parent_ip))
-				ret = trace_seq_puts(s, KRETPROBE_MSG);
+				ret = ring_buffer_seq_puts(s, KRETPROBE_MSG);
 			else
 				ret = seq_print_ip_sym(s, entry->parent_ip,
 						       sym_flags);
 			if (!ret)
 				return 0;
 		}
-		ret = trace_seq_printf(s, "\n");
+		ret = ring_buffer_seq_printf(s, "\n");
 	}
 
 	return ret;
 }
 
 static int
-trace_print_ctx(struct trace_seq *s, struct ctx_switch_entry *entry,
+trace_print_ctx(struct ring_buffer_seq *s, struct ctx_switch_entry *entry,
 		int type, int print_type)
 {
 	unsigned state;
@@ -1571,7 +1129,7 @@ trace_print_ctx(struct trace_seq *s, str
 	case TRACE_ITER_RAW:
 		if (type == TRACE_WAKE)
 			S = '+';
-		ret = trace_seq_printf(s, "%d %d %c %d %d %c\n",
+		ret = ring_buffer_seq_printf(s, "%d %d %c %d %d %c\n",
 				       entry->prev_pid,
 				       entry->prev_prio,
 				       S,
@@ -1581,7 +1139,7 @@ trace_print_ctx(struct trace_seq *s, str
 		break;
 	default:
 		comm = trace_find_cmdline(entry->next_pid);
-		ret = trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c %s\n",
+		ret = ring_buffer_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c %s\n",
 				       entry->prev_pid,
 				       entry->prev_prio,
 				       S, type == TRACE_CTX ? "==>" : "  +",
@@ -1594,7 +1152,7 @@ trace_print_ctx(struct trace_seq *s, str
 }
 
 static int
-trace_print_special(struct trace_seq *s, struct special_entry *entry,
+trace_print_special(struct ring_buffer_seq *s, struct special_entry *entry,
 			    int print_type)
 {
 	int ret = 0;
@@ -1612,7 +1170,7 @@ trace_print_special(struct trace_seq *s,
 		break;
 	case TRACE_ITER_RAW:
 	default:
-		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
+		ret = ring_buffer_seq_printf(s, "# %ld %ld %ld\n",
 				       entry->arg1,
 				       entry->arg2,
 				       entry->arg3);
@@ -1621,7 +1179,7 @@ trace_print_special(struct trace_seq *s,
 }
 
 static int
-trace_print_stack(struct trace_seq *s, struct stack_entry *entry, int sym_flags,
+trace_print_stack(struct ring_buffer_seq *s, struct stack_entry *entry, int sym_flags,
 		  int print_type)
 {
 	int i;
@@ -1634,7 +1192,7 @@ trace_print_stack(struct trace_seq *s, s
 	default:
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i) {
-				ret = trace_seq_puts(s, " <= ");
+				ret = ring_buffer_seq_puts(s, " <= ");
 				if (!ret)
 					return 0;
 			}
@@ -1643,7 +1201,7 @@ trace_print_stack(struct trace_seq *s, s
 			if (!ret)
 				return 0;
 		}
-		ret = trace_seq_puts(s, "\n");
+		ret = ring_buffer_seq_puts(s, "\n");
 	}
 
 	return ret;
@@ -1652,29 +1210,35 @@ trace_print_stack(struct trace_seq *s, s
 static int
 print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 {
-	struct trace_seq *s = &iter->seq;
+	struct ring_buffer_seq *s = iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
-	struct trace_entry *next_entry = find_next_entry(iter, NULL);
+	struct ring_buffer_event *next_event = ring_buffer_peek(iter->buffer_iter, NULL);
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
-	struct trace_entry *entry = iter->ent;
+	struct trace_entry *entry = ring_buffer_event_data(iter->event);
+	unsigned long long ns1, ns2;
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
 	char *comm;
 	int print_type = TRACE_FILE_LAT_FMT;
+	int type;
+
+	if (!next_event)
+		next_event = iter->event;
+	ns1 = ring_buffer_event_counter(iter->event);
+	ns2 = ring_buffer_event_counter(next_event);
+	rel_usecs = ns2usecs(ns2 - ns1);
+	abs_usecs = ns2usecs(ns1 - iter->tr->time_start);
 
-	if (!next_entry)
-		next_entry = entry;
-	rel_usecs = ns2usecs(next_entry->t - entry->t);
-	abs_usecs = ns2usecs(entry->t - iter->tr->time_start);
+	type = ring_buffer_event_type(iter->event);
 
 	if (verbose) {
 		comm = trace_find_cmdline(entry->pid);
-		trace_seq_printf(s, "%16s %5d %d %d %08x %08x [%08lx]"
+		ring_buffer_seq_printf(s, "%16s %5d %d %d %08x %08x [%08lx]"
 				 " %ld.%03ldms (+%ld.%03ldms): ",
 				 comm,
 				 entry->pid, cpu, entry->flags,
 				 entry->preempt_count, trace_idx,
-				 ns2usecs(entry->t),
+				 ns2usecs(ns1),
 				 abs_usecs/1000,
 				 abs_usecs % 1000, rel_usecs/1000,
 				 rel_usecs % 1000);
@@ -1682,74 +1246,77 @@ print_lat_fmt(struct trace_iterator *ite
 		lat_print_generic(s, entry, cpu);
 		lat_print_timestamp(s, abs_usecs, rel_usecs);
 	}
-	switch (entry->type) {
+	switch (type) {
 	case TRACE_FN:
-		trace_print_func(s, &entry->fn, sym_flags, print_type);
+		trace_print_func(s, (struct ftrace_entry *)entry, sym_flags, print_type);
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		trace_print_ctx(s, &entry->ctx, entry->type, print_type);
+		trace_print_ctx(s, (struct ctx_switch_entry *)entry, type, print_type);
 		break;
 	case TRACE_SPECIAL:
-		trace_print_special(s, &entry->special, print_type);
+		trace_print_special(s, (struct special_entry *)entry, print_type);
 		break;
 	case TRACE_STACK:
-		trace_print_stack(s, &entry->stack, sym_flags, print_type);
+		trace_print_stack(s, (struct stack_entry *)entry, sym_flags, print_type);
 		break;
 	default:
-		trace_seq_printf(s, "Unknown type %d\n", entry->type);
+		ring_buffer_seq_printf(s, "Unknown type %d\n", type);
 	}
 	return 1;
 }
 
 static int print_trace_fmt(struct trace_iterator *iter)
 {
-	struct trace_seq *s = &iter->seq;
+	struct ring_buffer_seq *s = iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_entry *entry;
 	unsigned long usec_rem;
-	unsigned long long t;
+	unsigned long long t, ns;
 	unsigned long secs;
 	char *comm;
+	int type;
 	int ret;
 
-	entry = iter->ent;
+	entry = ring_buffer_event_data(iter->event);
+	type = ring_buffer_event_type(iter->event);
+	ns = ring_buffer_event_counter(iter->event);
 
-	comm = trace_find_cmdline(iter->ent->pid);
+	comm = trace_find_cmdline(entry->pid);
 
-	t = ns2usecs(entry->t);
+	t = ns2usecs(ns);
 	usec_rem = do_div(t, 1000000ULL);
 	secs = (unsigned long)t;
 
-	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
+	ret = ring_buffer_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
 	if (!ret)
 		return 0;
-	ret = trace_seq_printf(s, "[%02d] ", iter->cpu);
+	ret = ring_buffer_seq_printf(s, "[%02d] ", iter->cpu);
 	if (!ret)
 		return 0;
-	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
+	ret = ring_buffer_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
 	if (!ret)
 		return 0;
 
-	switch (entry->type) {
+	switch (type) {
 	case TRACE_FN:
-		ret = trace_print_func(s, &entry->fn, sym_flags, 0);
+		ret = trace_print_func(s, (struct ftrace_entry *)entry, sym_flags, 0);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		ret = trace_print_ctx(s, &entry->ctx, entry->type, 0);
+ 		ret = trace_print_ctx(s, (struct ctx_switch_entry *)entry, type, 0);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_SPECIAL:
-		ret = trace_print_special(s, &entry->special, 0);
+		ret = trace_print_special(s, (struct special_entry *)entry, 0);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_STACK:
-		ret = trace_print_stack(s, &entry->stack, sym_flags, 0);
+		ret = trace_print_stack(s, (struct stack_entry *)entry, sym_flags, 0);
 		if (!ret)
 			return 0;
 		break;
@@ -1759,33 +1326,37 @@ static int print_trace_fmt(struct trace_
 
 static int print_raw_fmt(struct trace_iterator *iter)
 {
-	struct trace_seq *s = &iter->seq;
+	struct ring_buffer_seq *s = iter->seq;
 	struct trace_entry *entry;
+	unsigned long long t;
+	int type;
 	int print_type = TRACE_ITER_RAW;
 	int ret;
 
-	entry = iter->ent;
+	entry = ring_buffer_event_data(iter->event);
+	type = ring_buffer_event_type(iter->event);
+	t = ring_buffer_event_counter(iter->event);
 
-	ret = trace_seq_printf(s, "%d %d %llu ",
-		entry->pid, iter->cpu, entry->t);
+	ret = ring_buffer_seq_printf(s, "%d %d %llu ",
+		entry->pid, iter->cpu, t);
 	if (!ret)
 		return 0;
 
-	switch (entry->type) {
+	switch (type) {
 	case TRACE_FN:
-		ret = trace_print_func(s, &entry->fn, 0, print_type);
+		ret = trace_print_func(s, (struct ftrace_entry *)entry, 0, print_type);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		ret = trace_print_ctx(s, &entry->ctx, entry->type, print_type);
+		ret = trace_print_ctx(s, (struct ctx_switch_entry *)entry, type, print_type);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
-		ret = trace_print_special(s, &entry->special, print_type);
+		ret = trace_print_special(s, (struct special_entry *)entry, print_type);
 		if (!ret)
 			return 0;
 		break;
@@ -1795,28 +1366,32 @@ static int print_raw_fmt(struct trace_it
 
 static int print_hex_fmt(struct trace_iterator *iter)
 {
-	struct trace_seq *s = &iter->seq;
+	struct ring_buffer_seq *s = iter->seq;
 	unsigned char newline = '\n';
 	struct trace_entry *entry;
 	int print_type = TRACE_ITER_HEX;
+	unsigned long long t;
+	int type;
 
-	entry = iter->ent;
+	entry = ring_buffer_event_data(iter->event);
+	type = ring_buffer_event_type(iter->event);
+	t = ring_buffer_event_counter(iter->event);
 
 	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
-	SEQ_PUT_HEX_FIELD_RET(s, entry->t);
+	SEQ_PUT_HEX_FIELD_RET(s, t);
 
-	switch (entry->type) {
+	switch (type) {
 	case TRACE_FN:
-		trace_print_func(s, &entry->fn, 0, print_type);
+		trace_print_func(s, (struct ftrace_entry *)entry, 0, print_type);
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		trace_print_ctx(s, &entry->ctx, entry->type, print_type);
+		trace_print_ctx(s, (struct ctx_switch_entry *)entry, type, print_type);
 		break;
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
-		trace_print_special(s, &entry->special, print_type);
+		trace_print_special(s, (struct special_entry *)entry, print_type);
 		break;
 	}
 	SEQ_PUT_FIELD_RET(s, newline);
@@ -1826,26 +1401,30 @@ static int print_hex_fmt(struct trace_it
 
 static int print_bin_fmt(struct trace_iterator *iter)
 {
-	struct trace_seq *s = &iter->seq;
+	struct ring_buffer_seq *s = iter->seq;
 	struct trace_entry *entry;
 	int print_type = TRACE_ITER_BIN;
+	unsigned long long t;
+	int type;
 
-	entry = iter->ent;
+	entry = ring_buffer_event_data(iter->event);
+	type = ring_buffer_event_type(iter->event);
+	t = ring_buffer_event_counter(iter->event);
 
 	SEQ_PUT_FIELD_RET(s, entry->pid);
-	SEQ_PUT_FIELD_RET(s, entry->cpu);
-	SEQ_PUT_FIELD_RET(s, entry->t);
+	SEQ_PUT_FIELD_RET(s, iter->cpu);
+	SEQ_PUT_FIELD_RET(s, t);
 
-	switch (entry->type) {
+	switch (type) {
 	case TRACE_FN:
-		trace_print_func(s, &entry->fn, 0, print_type);
+		trace_print_func(s, (struct ftrace_entry *)entry, 0, print_type);
 		break;
 	case TRACE_CTX:
-		trace_print_ctx(s, &entry->ctx, entry->type, print_type);
+		trace_print_ctx(s, (struct ctx_switch_entry *)entry, type, print_type);
 		break;
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
-		trace_print_special(s, &entry->special, print_type);
+		trace_print_special(s, (struct special_entry *)entry, print_type);
 		break;
 	}
 	return 1;
@@ -1853,18 +1432,7 @@ static int print_bin_fmt(struct trace_it
 
 static int trace_empty(struct trace_iterator *iter)
 {
-	struct trace_array_cpu *data;
-	int cpu;
-
-	for_each_tracing_cpu(cpu) {
-		data = iter->tr->data[cpu];
-
-		if (head_page(data) && data->trace_idx &&
-		    (data->trace_tail != data->trace_head ||
-		     data->trace_tail_idx != data->trace_head_idx))
-			return 0;
-	}
-	return 1;
+	return ring_buffer_empty(iter->tr->buffer);
 }
 
 static int print_trace_line(struct trace_iterator *iter)
@@ -1891,7 +1459,7 @@ static int s_show(struct seq_file *m, vo
 {
 	struct trace_iterator *iter = v;
 
-	if (iter->ent == NULL) {
+	if (iter->event == NULL) {
 		if (iter->tr) {
 			seq_printf(m, "# tracer: %s\n", iter->trace->name);
 			seq_puts(m, "#\n");
@@ -1909,7 +1477,7 @@ static int s_show(struct seq_file *m, vo
 		}
 	} else {
 		print_trace_line(iter);
-		trace_print_seq(m, &iter->seq);
+		ring_buffer_seq_to_seqfile(m, iter->seq);
 	}
 
 	return 0;
@@ -1926,6 +1494,7 @@ static struct trace_iterator *
 __tracing_open(struct inode *inode, struct file *file, int *ret)
 {
 	struct trace_iterator *iter;
+	unsigned buf_flags = 0;
 
 	if (tracing_disabled) {
 		*ret = -ENODEV;
@@ -1938,11 +1507,32 @@ __tracing_open(struct inode *inode, stru
 		goto out;
 	}
 
+
+
 	mutex_lock(&trace_types_lock);
-	if (current_trace && current_trace->print_max)
-		iter->tr = &max_tr;
-	else
-		iter->tr = inode->i_private;
+
+	iter->tr = inode->i_private;
+
+	if (current_trace && current_trace->print_max) {
+		iter->iter_flags |= TRACE_FILE_USE_MAX;
+		buf_flags = RB_ITER_FL_SNAP;
+	}
+
+	iter->buffer_iter = ring_buffer_start(iter->tr->buffer, buf_flags);
+	if (!iter->buffer_iter) {
+		kfree(iter);
+		iter = NULL;
+		goto out_unlock;
+	}
+
+	iter->seq = ring_buffer_seq_alloc(GFP_KERNEL);
+	if (!iter->seq) {
+		ring_buffer_finish(iter->buffer_iter);
+		kfree(iter);
+		iter = NULL;
+		goto out_unlock;
+	}
+
 	iter->trace = current_trace;
 	iter->pos = -1;
 
@@ -1964,6 +1554,7 @@ __tracing_open(struct inode *inode, stru
 		kfree(iter);
 		iter = NULL;
 	}
+ out_unlock:
 	mutex_unlock(&trace_types_lock);
 
  out:
@@ -1985,6 +1576,10 @@ int tracing_release(struct inode *inode,
 	struct trace_iterator *iter = m->private;
 
 	mutex_lock(&trace_types_lock);
+
+	ring_buffer_seq_free(iter->seq);
+	ring_buffer_finish(iter->buffer_iter);
+
 	if (iter->trace && iter->trace->close)
 		iter->trace->close(iter);
 
@@ -2491,6 +2086,7 @@ static atomic_t tracing_reader;
 static int tracing_open_pipe(struct inode *inode, struct file *filp)
 {
 	struct trace_iterator *iter;
+	int max_event_size;
 
 	if (tracing_disabled)
 		return -ENODEV;
@@ -2506,6 +2102,13 @@ static int tracing_open_pipe(struct inod
 	if (!iter)
 		return -ENOMEM;
 
+	max_event_size = ring_buffer_max_event_size(global_trace.buffer);
+	iter->last_event = kmalloc(max_event_size, GFP_KERNEL);
+	if (!iter->last_event) {
+		kfree(iter);
+		return -ENOMEM;
+	}
+
 	mutex_lock(&trace_types_lock);
 	iter->tr = &global_trace;
 	iter->trace = current_trace;
@@ -2522,6 +2125,7 @@ static int tracing_release_pipe(struct i
 {
 	struct trace_iterator *iter = file->private_data;
 
+	kfree(iter->last_event);
 	kfree(iter);
 	atomic_dec(&tracing_reader);
 
@@ -2557,22 +2161,30 @@ tracing_read_pipe(struct file *filp, cha
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	struct trace_array_cpu *data;
-	static cpumask_t mask;
+	struct ring_buffer_event *event;
 	unsigned long flags;
 #ifdef CONFIG_FTRACE
 	int ftrace_save;
 #endif
-	int cpu;
+	static int save_event;
 	ssize_t sret;
 
 	/* return any leftover data */
-	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
+	sret = ring_buffer_seq_copy_to_user(iter->seq, ubuf, cnt);
 	if (sret != -EBUSY)
 		return sret;
 	sret = 0;
 
-	trace_seq_reset(&iter->seq);
+	ring_buffer_seq_reset(iter->seq);
+
+	/* Check to see if we over flowed the iterator */
+	if (save_event) {
+		iter->event = iter->last_event;
+		print_trace_line(iter);
+		save_event = 0;
+		sret = ring_buffer_seq_copy_to_user(iter->seq, ubuf, cnt);
+		return sret;
+	}
 
 	mutex_lock(&trace_types_lock);
 	if (iter->trace->read) {
@@ -2652,68 +2264,40 @@ tracing_read_pipe(struct file *filp, cha
 	 * and then release the locks again.
 	 */
 
-	cpus_clear(mask);
-	local_irq_save(flags);
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
+	ring_buffer_lock(iter->tr->buffer, &flags);
 
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
-
-	while (find_next_entry_inc(iter) != NULL) {
+	while ((event = ring_buffer_consume(iter->tr->buffer))) {
 		int ret;
-		int len = iter->seq.len;
+		int len = ring_buffer_seq_length(iter->seq);
 
+		iter->event = event;
 		ret = print_trace_line(iter);
 		if (!ret) {
 			/* don't print partial lines */
-			iter->seq.len = len;
+			ring_buffer_seq_set_length(iter->seq, len);
+			save_event = 1;
+			memcpy(iter->last_event, event,
+			       ring_buffer_event_length(event));
 			break;
 		}
 
-		trace_consume(iter);
-
-		if (iter->seq.len >= cnt)
+		len = ring_buffer_seq_length(iter->seq);
+		if (len >= cnt)
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
 #ifdef CONFIG_FTRACE
 	ftrace_enabled = ftrace_save;
 #endif
-	local_irq_restore(flags);
+	ring_buffer_unlock(iter->tr->buffer, flags);
 
 	/* Now copy what we have to the user */
-	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
-	if (iter->seq.readpos >= iter->seq.len)
-		trace_seq_reset(&iter->seq);
+	sret = ring_buffer_seq_copy_to_user(iter->seq, ubuf, cnt);
 	if (sret == -EBUSY)
 		sret = 0;
 
@@ -2731,17 +2315,28 @@ tracing_entries_read(struct file *filp, 
 	char buf[64];
 	int r;
 
-	r = sprintf(buf, "%lu\n", tr->entries);
+	r = sprintf(buf, "%lu\n", ring_buffer_size(tr->buffer));
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
+static void
+trace_default_print(struct ring_buffer *buffer,
+		    struct ring_buffer_seq *seq,
+		    struct ring_buffer_event *event)
+{
+	/* just some garbage for now */
+	ring_buffer_seq_printf(seq, "found %d\n",
+			       ring_buffer_event_type(event));
+}
+
 static ssize_t
 tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
+	struct ring_buffer *buffer;
 	unsigned long val;
 	char buf[64];
-	int i, ret;
+	int ret;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2768,59 +2363,28 @@ tracing_entries_write(struct file *filp,
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
-			goto out;
-		}
 
-		freeable_pages = determine_dirtyable_memory();
+	if (val == ring_buffer_size(global_trace.buffer))
+		goto out_same;
 
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
-			}
-			/* double check that we don't go over the known pages */
-			if (tracing_pages_allocated > pages_requested)
-				break;
-		}
-
-	} else {
-		/* include the number of entries in val (inc of page entries) */
-		while (global_trace.entries > val + (ENTRIES_PER_PAGE - 1))
-			trace_free_page();
+	buffer = ring_buffer_alloc(val,
+				   TRACE_BUFFER_FLAGS, 0,
+				   trace_default_print,
+				   "ftrace_tmp");
+	if (!buffer) {
+		cnt = -ENOMEM;
+		goto out;
 	}
 
-	/* check integrity */
-	for_each_tracing_cpu(i)
-		check_pages(global_trace.data[i]);
+	ring_buffer_free(global_trace.buffer);
+	ring_buffer_rename(buffer, FTRACE_BUF_NAME);
 
+	global_trace.buffer = buffer;
+
+ out_same:
 	filp->f_pos += cnt;
 
-	/* If check pages failed, return ENOMEM */
-	if (tracing_disabled)
-		cnt = -ENOMEM;
  out:
-	max_tr.entries = global_trace.entries;
 	mutex_unlock(&trace_types_lock);
 
 	return cnt;
@@ -2883,17 +2447,23 @@ static struct dentry *d_tracer;
 struct dentry *tracing_init_dentry(void)
 {
 	static int once;
+	static DEFINE_MUTEX(mutex);
 
 	if (d_tracer)
 		return d_tracer;
 
+	mutex_lock(&mutex);
+	if (d_tracer)
+		goto out;
+
 	d_tracer = debugfs_create_dir("tracing", NULL);
 
 	if (!d_tracer && !once) {
 		once = 1;
 		pr_warning("Could not create debugfs directory 'tracing'\n");
-		return NULL;
 	}
+ out:
+	mutex_unlock(&mutex);
 
 	return d_tracer;
 }
@@ -2987,190 +2557,52 @@ static __init void tracer_init_debugfs(v
 #endif
 }
 
-static int trace_alloc_page(void)
+struct trace_array *
+trace_allocate_tracer(unsigned long size,
+		      unsigned long flags,
+		      unsigned long max_entry_size,
+		      ring_buffer_print_func print_func,
+		      char *name)
 {
-	struct trace_array_cpu *data;
-	struct page *page, *tmp;
-	LIST_HEAD(pages);
-	void *array;
-	unsigned pages_allocated = 0;
-	int i;
-
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
-
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
-	}
+	struct trace_array *tr;
 
-	/* Now that we successfully allocate a page per CPU, add them */
-	for_each_tracing_cpu(i) {
-		data = global_trace.data[i];
-		page = list_entry(pages.next, struct page, lru);
-		list_del_init(&page->lru);
-		list_add_tail(&page->lru, &data->trace_pages);
-		ClearPageLRU(page);
-
-#ifdef CONFIG_TRACER_MAX_TRACE
-		data = max_tr.data[i];
-		page = list_entry(pages.next, struct page, lru);
-		list_del_init(&page->lru);
-		list_add_tail(&page->lru, &data->trace_pages);
-		SetPageLRU(page);
-#endif
-	}
-	tracing_pages_allocated += pages_allocated;
-	global_trace.entries += ENTRIES_PER_PAGE;
+	tr = kzalloc(ALIGN(sizeof(*tr), cache_line_size()), GFP_KERNEL);
+	if (!tr)
+		return NULL;
 
-	return 0;
+	tr->buffer = ring_buffer_alloc(size, flags, max_entry_size,
+				       print_func, name);
 
- free_pages:
-	list_for_each_entry_safe(page, tmp, &pages, lru) {
-		list_del_init(&page->lru);
-		__free_page(page);
-	}
-	return -ENOMEM;
-}
+	if (!tr->buffer)
+		goto fail_free_trace;
 
-static int trace_free_page(void)
-{
-	struct trace_array_cpu *data;
-	struct page *page;
-	struct list_head *p;
-	int i;
-	int ret = 0;
+	tr->ctrl = tracer_enabled;
 
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
+	return tr;
 
-		tracing_reset(data);
-#endif
-	}
-	global_trace.entries -= ENTRIES_PER_PAGE;
-
-	return ret;
+ fail_free_trace:
+	kfree(tr);
+	return NULL;
 }
 
 __init static int tracer_alloc_buffers(void)
 {
-	struct trace_array_cpu *data;
-	void *array;
-	struct page *page;
-	int pages = 0;
-	int ret = -ENOMEM;
 	int i;
 
-	/* TODO: make the number of buffers hot pluggable with CPUS */
-	tracing_nr_buffers = num_possible_cpus();
 	tracing_buffer_mask = cpu_possible_map;
 
-	/* Allocate the first page for all buffers */
-	for_each_tracing_cpu(i) {
-		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
-		max_tr.data[i] = &per_cpu(max_data, i);
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
+	global_trace.buffer = ring_buffer_alloc(trace_buf_size,
+						TRACE_BUFFER_FLAGS, 0,
+						trace_default_print,
+						FTRACE_BUF_NAME);
+	if (!global_trace.buffer) {
+		printk(KERN_ERR "tracer: failed to allocate buffer\n");
+		return -ENOMEM;
 	}
 
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
-	}
-	max_tr.entries = global_trace.entries;
+	for_each_tracing_cpu(i)
+		global_trace.data[i] = &per_cpu(global_trace_cpu, i);
 
-	pr_info("tracer: %d pages allocated for %ld entries of %ld bytes\n",
-		pages, trace_nr_entries, (long)TRACE_ENTRY_SIZE);
-	pr_info("   actual entries %ld\n", global_trace.entries);
 
 	tracer_init_debugfs();
 
@@ -3184,31 +2616,5 @@ __init static int tracer_alloc_buffers(v
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
--- linux-compile.git.orig/kernel/trace/trace.h	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/kernel/trace/trace.h	2008-09-23 23:34:46.000000000 -0400
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/clocksource.h>
 #include <linux/mmiotrace.h>
+#include <linux/ring_buffer.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -25,6 +26,7 @@ enum trace_type {
  * Function trace entry - function address and parent function addres:
  */
 struct ftrace_entry {
+	struct trace_entry	ent;
 	unsigned long		ip;
 	unsigned long		parent_ip;
 };
@@ -33,6 +35,7 @@ struct ftrace_entry {
  * Context switch trace entry - which task (and prio) we switched from/to:
  */
 struct ctx_switch_entry {
+	struct trace_entry	ent;
 	unsigned int		prev_pid;
 	unsigned char		prev_prio;
 	unsigned char		prev_state;
@@ -45,6 +48,7 @@ struct ctx_switch_entry {
  * Special (free-form) trace entry:
  */
 struct special_entry {
+	struct trace_entry	ent;
 	unsigned long		arg1;
 	unsigned long		arg2;
 	unsigned long		arg3;
@@ -57,63 +61,23 @@ struct special_entry {
 #define FTRACE_STACK_ENTRIES	8
 
 struct stack_entry {
+	struct trace_entry	ent;
 	unsigned long		caller[FTRACE_STACK_ENTRIES];
 };
 
 /*
- * The trace entry - the most basic unit of tracing. This is what
- * is printed in the end as a single line in the trace output, such as:
- *
- *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
- */
-struct trace_entry {
-	char			type;
-	char			cpu;
-	char			flags;
-	char			preempt_count;
-	int			pid;
-	cycle_t			t;
-	union {
-		struct ftrace_entry		fn;
-		struct ctx_switch_entry		ctx;
-		struct special_entry		special;
-		struct stack_entry		stack;
-		struct mmiotrace_rw		mmiorw;
-		struct mmiotrace_map		mmiomap;
-	};
-};
-
-#define TRACE_ENTRY_SIZE	sizeof(struct trace_entry)
-
-/*
  * The CPU trace array - it consists of thousands of trace entries
  * plus some other descriptor data: (for example which task started
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
-	unsigned long		trace_idx;
-	unsigned long		overrun;
-	unsigned long		saved_latency;
 	unsigned long		critical_start;
 	unsigned long		critical_end;
 	unsigned long		critical_sequence;
-	unsigned long		nice;
-	unsigned long		policy;
-	unsigned long		rt_priority;
 	cycle_t			preempt_timestamp;
-	pid_t			pid;
-	uid_t			uid;
-	char			comm[TASK_COMM_LEN];
 };
 
 struct trace_iterator;
@@ -124,12 +88,20 @@ struct trace_iterator;
  * They have on/off state as well:
  */
 struct trace_array {
-	unsigned long		entries;
+	struct ring_buffer	*buffer;
 	long			ctrl;
 	int			cpu;
 	cycle_t			time_start;
 	struct task_struct	*waiter;
 	struct trace_array_cpu	*data[NR_CPUS];
+
+	unsigned long		saved_latency;
+	unsigned long		nice;
+	unsigned long		policy;
+	unsigned long		rt_priority;
+	pid_t			pid;
+	uid_t			uid;
+	char			comm[TASK_COMM_LEN];
 };
 
 /*
@@ -137,6 +109,7 @@ struct trace_array {
  */
 struct tracer {
 	const char		*name;
+	struct trace_array	*tr;
 	void			(*init)(struct trace_array *tr);
 	void			(*reset)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
@@ -157,12 +130,6 @@ struct tracer {
 	int			print_max;
 };
 
-struct trace_seq {
-	unsigned char		buffer[PAGE_SIZE];
-	unsigned int		len;
-	unsigned int		readpos;
-};
-
 /*
  * Trace iterator - used by printout routines who present trace
  * results to users and which routines might sleep, etc:
@@ -171,26 +138,21 @@ struct trace_iterator {
 	struct trace_array	*tr;
 	struct tracer		*trace;
 	void			*private;
-	long			last_overrun[NR_CPUS];
-	long			overrun[NR_CPUS];
 
 	/* The below is zeroed out in pipe_read */
-	struct trace_seq	seq;
-	struct trace_entry	*ent;
+	struct ring_buffer_seq	*seq;
 	int			cpu;
 
-	struct trace_entry	*prev_ent;
-	int			prev_cpu;
+	struct ring_buffer_event *event;
+	struct ring_buffer_event *last_event;
+	struct ring_buffer_iter	*buffer_iter;
 
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
@@ -227,6 +189,11 @@ void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
+struct trace_array *trace_allocate_tracer(unsigned long size,
+					  unsigned long flags,
+					  unsigned long max_entry_size,
+					  ring_buffer_print_func print_func,
+					  char *name);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
@@ -308,10 +275,6 @@ extern int trace_selftest_startup_syspro
 #endif
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
-extern void *head_page(struct trace_array_cpu *data);
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
-extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
 
 extern unsigned long trace_flags;
Index: linux-compile.git/include/linux/ftrace.h
===================================================================
--- linux-compile.git.orig/include/linux/ftrace.h	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/include/linux/ftrace.h	2008-09-23 23:34:46.000000000 -0400
@@ -162,4 +162,10 @@ static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 #endif
 
+struct trace_entry {
+	char			flags;
+	char			preempt_count;
+	int			pid;
+};
+
 #endif /* _LINUX_FTRACE_H */
Index: linux-compile.git/include/linux/mmiotrace.h
===================================================================
--- linux-compile.git.orig/include/linux/mmiotrace.h	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/include/linux/mmiotrace.h	2008-09-23 23:34:46.000000000 -0400
@@ -1,6 +1,7 @@
 #ifndef MMIOTRACE_H
 #define MMIOTRACE_H
 
+#include <linux/ftrace.h>
 #include <linux/types.h>
 #include <linux/list.h>
 
@@ -60,6 +61,7 @@ enum mm_io_opcode {
 };
 
 struct mmiotrace_rw {
+	struct trace_entry ent;
 	resource_size_t phys;	/* PCI address of register */
 	unsigned long value;
 	unsigned long pc;	/* optional program counter */
@@ -69,6 +71,7 @@ struct mmiotrace_rw {
 };
 
 struct mmiotrace_map {
+	struct trace_entry ent;
 	resource_size_t phys;	/* base address in PCI space */
 	unsigned long virt;	/* base virtual address */
 	unsigned long len;	/* mapping size */
Index: linux-compile.git/kernel/trace/trace_functions.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_functions.c	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_functions.c	2008-09-23 23:34:46.000000000 -0400
@@ -23,7 +23,7 @@ static void function_reset(struct trace_
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static void start_function_trace(struct trace_array *tr)
Index: linux-compile.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_irqsoff.c	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_irqsoff.c	2008-09-23 23:34:46.000000000 -0400
@@ -20,6 +20,7 @@
 
 static struct trace_array		*irqsoff_trace __read_mostly;
 static int				tracer_enabled __read_mostly;
+static int				preemptirq_buffer_size = 10000;
 
 static DEFINE_PER_CPU(int, tracing_cpu);
 
@@ -173,7 +174,7 @@ out_unlock:
 out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
-	tracing_reset(data);
+	tracing_reset(tr, cpu);
 	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags);
 }
 
@@ -203,7 +204,7 @@ start_critical_timing(unsigned long ip, 
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
 	data->critical_start = parent_ip ? : ip;
-	tracing_reset(data);
+	tracing_reset(tr, cpu);
 
 	local_save_flags(flags);
 
@@ -234,8 +235,7 @@ stop_critical_timing(unsigned long ip, u
 
 	data = tr->data[cpu];
 
-	if (unlikely(!data) || unlikely(!head_page(data)) ||
-	    !data->critical_start || atomic_read(&data->disabled))
+	if (unlikely(!data) || !data->critical_start || atomic_read(&data->disabled))
 		return;
 
 	atomic_inc(&data->disabled);
@@ -399,6 +399,13 @@ static void irqsoff_tracer_close(struct 
 		start_irqsoff_tracer(iter->tr);
 }
 
+static void
+register_preemptirq_tracer(struct tracer *trace, struct trace_array *tr)
+{
+	trace->tr = tr;
+	register_tracer(trace);
+}
+
 #ifdef CONFIG_IRQSOFF_TRACER
 static void irqsoff_tracer_init(struct trace_array *tr)
 {
@@ -419,7 +426,7 @@ static struct tracer irqsoff_tracer __re
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
 };
-# define register_irqsoff(trace) register_tracer(&trace)
+# define register_irqsoff(trace, tr) register_preemptirq_tracer(trace, tr)
 #else
 # define register_irqsoff(trace) do { } while (0)
 #endif
@@ -445,7 +452,7 @@ static struct tracer preemptoff_tracer _
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
 };
-# define register_preemptoff(trace) register_tracer(&trace)
+# define register_preemptoff(trace, tr) register_preemptirq_tracer(trace, tr)
 #else
 # define register_preemptoff(trace) do { } while (0)
 #endif
@@ -474,16 +481,25 @@ static struct tracer preemptirqsoff_trac
 #endif
 };
 
-# define register_preemptirqsoff(trace) register_tracer(&trace)
+# define register_preemptirqsoff(trace, tr) register_preemptirq_tracer(trace, tr)
 #else
-# define register_preemptirqsoff(trace) do { } while (0)
+# define register_preemptirqsoff(trace, tr) do { } while (0)
 #endif
 
 __init static int init_irqsoff_tracer(void)
 {
-	register_irqsoff(irqsoff_tracer);
-	register_preemptoff(preemptoff_tracer);
-	register_preemptirqsoff(preemptirqsoff_tracer);
+	struct trace_array *tr = NULL;
+#if 0
+	tr = trace_allocate_tracer(preemptirq_buffer_size,
+				   RB_FL_SNAPSHOT | RB_FL_OVERWRITE, 0,
+				   NULL, "preemptirqs");
+	if (!tr)
+		return -ENOMEM;
+#endif
+
+	register_irqsoff(&irqsoff_tracer, tr);
+	register_preemptoff(&preemptoff_tracer, tr);
+	register_preemptirqsoff(&preemptirqsoff_tracer, tr);
 
 	return 0;
 }
Index: linux-compile.git/kernel/trace/trace_mmiotrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_mmiotrace.c	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_mmiotrace.c	2008-09-23 23:34:46.000000000 -0400
@@ -27,7 +27,7 @@ static void mmio_reset_data(struct trace
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static void mmio_trace_init(struct trace_array *tr)
@@ -60,17 +60,17 @@ static void mmio_trace_ctrl_update(struc
 	}
 }
 
-static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
+static int mmio_print_pcidev(struct ring_buffer_seq *s, const struct pci_dev *dev)
 {
 	int ret = 0;
 	int i;
 	resource_size_t start, end;
 	const struct pci_driver *drv = pci_dev_driver(dev);
 
-	/* XXX: incomplete checks for trace_seq_printf() return value */
-	ret += trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
-				dev->bus->number, dev->devfn,
-				dev->vendor, dev->device, dev->irq);
+	/* XXX: incomplete checks for ring_buffer_seq_printf() return value */
+	ret += ring_buffer_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
+				      dev->bus->number, dev->devfn,
+				      dev->vendor, dev->device, dev->irq);
 	/*
 	 * XXX: is pci_resource_to_user() appropriate, since we are
 	 * supposed to interpret the __ioremap() phys_addr argument based on
@@ -78,20 +78,20 @@ static int mmio_print_pcidev(struct trac
 	 */
 	for (i = 0; i < 7; i++) {
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
-		ret += trace_seq_printf(s, " %llx",
+		ret += ring_buffer_seq_printf(s, " %llx",
 			(unsigned long long)(start |
 			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
 	}
 	for (i = 0; i < 7; i++) {
 		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
-		ret += trace_seq_printf(s, " %llx",
+		ret += ring_buffer_seq_printf(s, " %llx",
 			dev->resource[i].start < dev->resource[i].end ?
 			(unsigned long long)(end - start) + 1 : 0);
 	}
 	if (drv)
-		ret += trace_seq_printf(s, " %s\n", drv->name);
+		ret += ring_buffer_seq_printf(s, " %s\n", drv->name);
 	else
-		ret += trace_seq_printf(s, " \n");
+		ret += ring_buffer_seq_printf(s, " \n");
 	return ret;
 }
 
@@ -106,9 +106,9 @@ static void destroy_header_iter(struct h
 static void mmio_pipe_open(struct trace_iterator *iter)
 {
 	struct header_iter *hiter;
-	struct trace_seq *s = &iter->seq;
+	struct ring_buffer_seq *s = iter->seq;
 
-	trace_seq_printf(s, "VERSION 20070824\n");
+	ring_buffer_seq_printf(s, "VERSION 20070824\n");
 
 	hiter = kzalloc(sizeof(*hiter), GFP_KERNEL);
 	if (!hiter)
@@ -128,13 +128,7 @@ static void mmio_close(struct trace_iter
 
 static unsigned long count_overruns(struct trace_iterator *iter)
 {
-	int cpu;
-	unsigned long cnt = 0;
-	for_each_online_cpu(cpu) {
-		cnt += iter->overrun[cpu];
-		iter->overrun[cpu] = 0;
-	}
-	return cnt;
+	return ring_buffer_overruns(iter->tr->buffer);
 }
 
 static ssize_t mmio_read(struct trace_iterator *iter, struct file *filp,
@@ -142,13 +136,13 @@ static ssize_t mmio_read(struct trace_it
 {
 	ssize_t ret;
 	struct header_iter *hiter = iter->private;
-	struct trace_seq *s = &iter->seq;
+	struct ring_buffer_seq *s = iter->seq;
 	unsigned long n;
 
 	n = count_overruns(iter);
 	if (n) {
 		/* XXX: This is later than where events were lost. */
-		trace_seq_printf(s, "MARK 0.000000 Lost %lu events.\n", n);
+		ring_buffer_seq_printf(s, "MARK 0.000000 Lost %lu events.\n", n);
 		if (!overrun_detected)
 			pr_warning("mmiotrace has lost events.\n");
 		overrun_detected = true;
@@ -167,37 +161,37 @@ static ssize_t mmio_read(struct trace_it
 	}
 
 print_out:
-	ret = trace_seq_to_user(s, ubuf, cnt);
+	ret = ring_buffer_seq_copy_to_user(s, ubuf, cnt);
 	return (ret == -EBUSY) ? 0 : ret;
 }
 
 static int mmio_print_rw(struct trace_iterator *iter)
 {
-	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_rw *rw	= &entry->mmiorw;
-	struct trace_seq *s	= &iter->seq;
-	unsigned long long t	= ns2usecs(entry->t);
+	struct ring_buffer_event *event = iter->event;
+	struct mmiotrace_rw *rw = ring_buffer_event_data(event);
+	struct ring_buffer_seq *s = iter->seq;
+	unsigned long long t	= ns2usecs(ring_buffer_event_counter(event));
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
-	switch (entry->mmiorw.opcode) {
+	switch (rw->opcode) {
 	case MMIO_READ:
-		ret = trace_seq_printf(s,
+		ret = ring_buffer_seq_printf(s,
 			"R %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
 			rw->width, secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_WRITE:
-		ret = trace_seq_printf(s,
+		ret = ring_buffer_seq_printf(s,
 			"W %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
 			rw->width, secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_UNKNOWN_OP:
-		ret = trace_seq_printf(s,
+		ret = ring_buffer_seq_printf(s,
 			"UNKNOWN %lu.%06lu %d 0x%llx %02x,%02x,%02x 0x%lx %d\n",
 			secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
@@ -205,7 +199,7 @@ static int mmio_print_rw(struct trace_it
 			(rw->value >> 0) & 0xff, rw->pc, 0);
 		break;
 	default:
-		ret = trace_seq_printf(s, "rw what?\n");
+		ret = ring_buffer_seq_printf(s, "rw what?\n");
 		break;
 	}
 	if (ret)
@@ -215,29 +209,28 @@ static int mmio_print_rw(struct trace_it
 
 static int mmio_print_map(struct trace_iterator *iter)
 {
-	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_map *m	= &entry->mmiomap;
-	struct trace_seq *s	= &iter->seq;
-	unsigned long long t	= ns2usecs(entry->t);
+	struct mmiotrace_map *m	= ring_buffer_event_data(iter->event);
+	struct ring_buffer_seq *s = iter->seq;
+	unsigned long long t	= ns2usecs(ring_buffer_event_counter(iter->event));
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
-	switch (entry->mmiorw.opcode) {
+	switch (m->opcode) {
 	case MMIO_PROBE:
-		ret = trace_seq_printf(s,
+		ret = ring_buffer_seq_printf(s,
 			"MAP %lu.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
 			secs, usec_rem, m->map_id,
 			(unsigned long long)m->phys, m->virt, m->len,
 			0UL, 0);
 		break;
 	case MMIO_UNPROBE:
-		ret = trace_seq_printf(s,
+		ret = ring_buffer_seq_printf(s,
 			"UNMAP %lu.%06lu %d 0x%lx %d\n",
 			secs, usec_rem, m->map_id, 0UL, 0);
 		break;
 	default:
-		ret = trace_seq_printf(s, "map what?\n");
+		ret = ring_buffer_seq_printf(s, "map what?\n");
 		break;
 	}
 	if (ret)
@@ -248,7 +241,7 @@ static int mmio_print_map(struct trace_i
 /* return 0 to abort printing without consuming current entry in pipe mode */
 static int mmio_print_line(struct trace_iterator *iter)
 {
-	switch (iter->ent->type) {
+	switch (ring_buffer_event_type(iter->event)) {
 	case TRACE_MMIO_RW:
 		return mmio_print_rw(iter);
 	case TRACE_MMIO_MAP:
Index: linux-compile.git/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_sched_switch.c	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_sched_switch.c	2008-09-23 23:34:46.000000000 -0400
@@ -133,7 +133,7 @@ static void sched_switch_reset(struct tr
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static int tracing_sched_register(void)
Index: linux-compile.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_sched_wakeup.c	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_sched_wakeup.c	2008-09-23 23:34:46.000000000 -0400
@@ -215,8 +215,7 @@ static void __wakeup_reset(struct trace_
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		data = tr->data[cpu];
-		tracing_reset(data);
+		tracing_reset(tr, cpu);
 	}
 
 	wakeup_cpu = -1;
Index: linux-compile.git/arch/x86/kernel/Makefile
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/Makefile	2008-09-23 23:33:29.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/Makefile	2008-09-23 23:34:46.000000000 -0400
@@ -11,6 +11,7 @@ ifdef CONFIG_FTRACE
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt.o = -pg
+CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
 #

-- 
