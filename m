Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYJAEjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYJAEjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 00:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYJAEjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 00:39:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYJAEjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 00:39:11 -0400
Message-Id: <20081001043908.306306212@goodmis.org>
References: <20081001042951.412019606@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 00:29:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Pekka Paalanen <pq@iki.fi>, Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Bligh <mbligh@google.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ring_buffer: implement new locking
Content-Disposition: inline; filename=ring-buffer-new-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old "lock always" scheme had issues with lockdep, and was not very
efficient anyways.

This patch does a new design to be partially lockless on writes.
Writes will add new entries to the per cpu pages by simply disabling
interrupts. When a write needs to go to another page than it will
grab the lock.

A new "read page" has been added so that the reader can pull out a page
from the ring buffer to read without worrying about the writer writing over
it. This allows us to not take the lock for all reads. The lock is
now only taken when a read needs to go to a new page.

This is far from lockless, and interrupts still need to be disabled,
but it is a step towards a more lockless solution, and it also
solves a lot of the issues that were noticed by the first conversion
of ftrace to the ring buffers.

Note: the ring_buffer_{un}lock API has been removed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    3 
 kernel/trace/ring_buffer.c  |  298 +++++++++++++++++++++++++-------------------
 kernel/trace/trace.c        |  113 +++++++++++-----
 3 files changed, 247 insertions(+), 167 deletions(-)

Index: linux-tip.git/include/linux/ring_buffer.h
===================================================================
--- linux-tip.git.orig/include/linux/ring_buffer.h	2008-09-30 20:48:32.000000000 -0400
+++ linux-tip.git/include/linux/ring_buffer.h	2008-09-30 20:49:30.000000000 -0400
@@ -63,9 +63,6 @@ ring_buffer_event_time_delta(struct ring
 	return event->time_delta;
 }
 
-void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags);
-void ring_buffer_unlock(struct ring_buffer *buffer, unsigned long flags);
-
 /*
  * size is in bytes for each per CPU buffer.
  */
Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-09-30 20:48:32.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-09-30 23:46:40.000000000 -0400
@@ -161,8 +161,10 @@ struct ring_buffer_per_cpu {
 	struct list_head		pages;
 	unsigned long			head;	/* read from head */
 	unsigned long			tail;	/* write to tail */
+	unsigned long			reader;
 	struct buffer_page		*head_page;
 	struct buffer_page		*tail_page;
+	struct buffer_page		*reader_page;
 	unsigned long			overrun;
 	unsigned long			entries;
 	u64				write_stamp;
@@ -260,6 +262,7 @@ static struct ring_buffer_per_cpu *
 rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long addr;
 	int ret;
 
 	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
@@ -272,9 +275,16 @@ rb_allocate_cpu_buffer(struct ring_buffe
 	spin_lock_init(&cpu_buffer->lock);
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
+	addr = __get_free_page(GFP_KERNEL);
+	if (!addr)
+		goto fail_free_buffer;
+	cpu_buffer->reader_page = (struct buffer_page *)virt_to_page(addr);
+	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	cpu_buffer->reader_page->size = 0;
+
 	ret = rb_allocate_pages(cpu_buffer, buffer->pages);
 	if (ret < 0)
-		goto fail_free_buffer;
+		goto fail_free_reader;
 
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
@@ -283,6 +293,9 @@ rb_allocate_cpu_buffer(struct ring_buffe
 
 	return cpu_buffer;
 
+ fail_free_reader:
+	free_buffer_page(cpu_buffer->reader_page);
+
  fail_free_buffer:
 	kfree(cpu_buffer);
 	return NULL;
@@ -293,6 +306,9 @@ static void rb_free_cpu_buffer(struct ri
 	struct list_head *head = &cpu_buffer->pages;
 	struct buffer_page *page, *tmp;
 
+	list_del_init(&cpu_buffer->reader_page->list);
+	free_buffer_page(cpu_buffer->reader_page);
+
 	list_for_each_entry_safe(page, tmp, head, list) {
 		list_del_init(&page->list);
 		free_buffer_page(page);
@@ -538,8 +554,10 @@ int ring_buffer_resize(struct ring_buffe
 
 static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	return cpu_buffer->head_page == cpu_buffer->tail_page &&
-		cpu_buffer->head == cpu_buffer->tail;
+	return (cpu_buffer->reader == cpu_buffer->reader_page->size &&
+		(cpu_buffer->tail_page == cpu_buffer->reader_page ||
+		 (cpu_buffer->tail_page == cpu_buffer->head_page &&
+		  cpu_buffer->head == cpu_buffer->tail)));
 }
 
 static inline int rb_null_event(struct ring_buffer_event *event)
@@ -555,10 +573,10 @@ static inline void *rb_page_index(struct
 }
 
 static inline struct ring_buffer_event *
-rb_head_event(struct ring_buffer_per_cpu *cpu_buffer)
+rb_reader_event(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	return rb_page_index(cpu_buffer->head_page,
-			     cpu_buffer->head);
+	return rb_page_index(cpu_buffer->reader_page,
+			     cpu_buffer->reader);
 }
 
 static inline struct ring_buffer_event *
@@ -610,15 +628,32 @@ rb_add_stamp(struct ring_buffer_per_cpu 
 	cpu_buffer->write_stamp = *ts;
 }
 
-static void rb_reset_read_page(struct ring_buffer_per_cpu *cpu_buffer)
+static void rb_reset_head_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	cpu_buffer->read_stamp = cpu_buffer->head_page->time_stamp;
 	cpu_buffer->head = 0;
 }
 
-static void
-rb_reset_iter_read_page(struct ring_buffer_iter *iter)
+static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
+	cpu_buffer->read_stamp = cpu_buffer->reader_page->time_stamp;
+	cpu_buffer->reader = 0;
+}
+
+static inline void rb_inc_iter(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+
+	/*
+	 * The iterator could be on the reader page (it starts there).
+	 * But the head could have moved, since the reader was
+	 * found. Check for this case and assign the iterator
+	 * to the head page instead of next.
+	 */
+	if (iter->head_page == cpu_buffer->reader_page)
+		iter->head_page = cpu_buffer->head_page;
+	else
+		rb_inc_page(cpu_buffer, &iter->head_page);
+
 	iter->read_stamp = iter->head_page->time_stamp;
 	iter->head = 0;
 }
@@ -693,30 +728,39 @@ static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		  unsigned type, unsigned long length, u64 *ts)
 {
-	struct buffer_page *head_page, *tail_page;
+	struct buffer_page *tail_page, *head_page, *reader_page;
 	unsigned long tail;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_event *event;
 
+	/* No locking needed for tail page */
 	tail_page = cpu_buffer->tail_page;
-	head_page = cpu_buffer->head_page;
 	tail = cpu_buffer->tail;
 
 	if (tail + length > BUF_PAGE_SIZE) {
 		struct buffer_page *next_page = tail_page;
 
+		spin_lock(&cpu_buffer->lock);
 		rb_inc_page(cpu_buffer, &next_page);
 
+		head_page = cpu_buffer->head_page;
+		reader_page = cpu_buffer->reader_page;
+
+		/* we grabbed the lock before incrementing */
+		WARN_ON(next_page == reader_page);
+
 		if (next_page == head_page) {
-			if (!(buffer->flags & RB_FL_OVERWRITE))
+			if (!(buffer->flags & RB_FL_OVERWRITE)) {
+				spin_unlock(&cpu_buffer->lock);
 				return NULL;
+			}
 
 			/* count overflows */
 			rb_update_overflow(cpu_buffer);
 
 			rb_inc_page(cpu_buffer, &head_page);
 			cpu_buffer->head_page = head_page;
-			rb_reset_read_page(cpu_buffer);
+			rb_reset_head_page(cpu_buffer);
 		}
 
 		if (tail != BUF_PAGE_SIZE) {
@@ -732,6 +776,7 @@ __rb_reserve_next(struct ring_buffer_per
 		cpu_buffer->tail_page = tail_page;
 		cpu_buffer->tail = tail;
 		rb_add_stamp(cpu_buffer, ts);
+		spin_unlock(&cpu_buffer->lock);
 	}
 
 	BUG_ON(tail + length > BUF_PAGE_SIZE);
@@ -802,7 +847,9 @@ rb_reserve_next_event(struct ring_buffer
 				return NULL;
 		}
 	} else {
+		spin_lock(&cpu_buffer->lock);
 		rb_add_stamp(cpu_buffer, &ts);
+		spin_unlock(&cpu_buffer->lock);
 		delta = 0;
 	}
 
@@ -851,13 +898,12 @@ ring_buffer_lock_reserve(struct ring_buf
 	cpu = raw_smp_processor_id();
 
 	if (!cpu_isset(cpu, buffer->cpumask))
-		goto out_irq;
+		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	spin_lock(&cpu_buffer->lock);
 
 	if (atomic_read(&cpu_buffer->record_disabled))
-		goto no_record;
+		goto out;
 
 	length = rb_calculate_event_length(length);
 	if (length > BUF_PAGE_SIZE)
@@ -865,13 +911,11 @@ ring_buffer_lock_reserve(struct ring_buf
 
 	event = rb_reserve_next_event(cpu_buffer, RINGBUF_TYPE_DATA, length);
 	if (!event)
-		goto no_record;
+		goto out;
 
 	return event;
 
- no_record:
-	spin_unlock(&cpu_buffer->lock);
- out_irq:
+ out:
 	local_irq_restore(*flags);
 	return NULL;
 }
@@ -904,11 +948,8 @@ int ring_buffer_unlock_commit(struct rin
 
 	cpu_buffer = buffer->buffers[cpu];
 
-	assert_spin_locked(&cpu_buffer->lock);
-
 	rb_commit(cpu_buffer, event);
 
-	spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 
 	return 0;
@@ -945,10 +986,9 @@ int ring_buffer_write(struct ring_buffer
 	cpu = raw_smp_processor_id();
 
 	if (!cpu_isset(cpu, buffer->cpumask))
-		goto out_irq;
+		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	spin_lock(&cpu_buffer->lock);
 
 	if (atomic_read(&cpu_buffer->record_disabled))
 		goto out;
@@ -967,56 +1007,12 @@ int ring_buffer_write(struct ring_buffer
 
 	ret = 0;
  out:
-	spin_unlock(&cpu_buffer->lock);
- out_irq:
 	local_irq_restore(flags);
 
 	return ret;
 }
 
 /**
- * ring_buffer_lock - lock the ring buffer
- * @buffer: The ring buffer to lock
- * @flags: The place to store the interrupt flags
- *
- * This locks all the per CPU buffers.
- *
- * Must be unlocked by ring_buffer_unlock.
- */
-void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags)
-{
-	struct ring_buffer_per_cpu *cpu_buffer;
-	int cpu;
-
-	local_irq_save(*flags);
-
-	for_each_buffer_cpu(buffer, cpu) {
-		cpu_buffer = buffer->buffers[cpu];
-		spin_lock(&cpu_buffer->lock);
-	}
-}
-
-/**
- * ring_buffer_unlock - unlock a locked buffer
- * @buffer: The locked buffer to unlock
- * @flags: The interrupt flags received by ring_buffer_lock
- */
-void ring_buffer_unlock(struct ring_buffer *buffer, unsigned long flags)
-{
-	struct ring_buffer_per_cpu *cpu_buffer;
-	int cpu;
-
-	for (cpu = buffer->cpus - 1; cpu >= 0; cpu--) {
-		if (!cpu_isset(cpu, buffer->cpumask))
-			continue;
-		cpu_buffer = buffer->buffers[cpu];
-		spin_unlock(&cpu_buffer->lock);
-	}
-
-	local_irq_restore(flags);
-}
-
-/**
  * ring_buffer_record_disable - stop all writes into the buffer
  * @buffer: The ring buffer to stop writes to.
  *
@@ -1169,9 +1165,18 @@ void ring_buffer_iter_reset(struct ring_
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 
-	iter->head_page = cpu_buffer->head_page;
-	iter->head = cpu_buffer->head;
-	rb_reset_iter_read_page(iter);
+	/* Iterator usage is expected to have record disabled */
+	if (list_empty(&cpu_buffer->reader_page->list)) {
+		iter->head_page = cpu_buffer->head_page;
+		iter->head = cpu_buffer->head;
+	} else {
+		iter->head_page = cpu_buffer->reader_page;
+		iter->head = cpu_buffer->reader;
+	}
+	if (iter->head)
+		iter->read_stamp = cpu_buffer->read_stamp;
+	else
+		iter->read_stamp = iter->head_page->time_stamp;
 }
 
 /**
@@ -1250,43 +1255,84 @@ rb_update_iter_read_stamp(struct ring_bu
 	return;
 }
 
-static void rb_advance_head(struct ring_buffer_per_cpu *cpu_buffer)
+static struct buffer_page *
+rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct ring_buffer_event *event;
-	unsigned length;
+	struct buffer_page *reader = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpu_buffer->lock, flags);
+
+ again:
+	reader = cpu_buffer->reader_page;
+
+	/* If there's more to read, return this page */
+	if (cpu_buffer->reader < reader->size)
+		goto out;
+
+	/* Never should we have an index greater than the size */
+	WARN_ON(cpu_buffer->reader > reader->size);
+
+	/* check if we caught up to the tail */
+	reader = NULL;
+	if (cpu_buffer->tail_page == cpu_buffer->reader_page)
+		goto out;
 
 	/*
-	 * Check if we are at the end of the buffer.
+	 * Splice the empty reader page into the list around the head.
+	 * Reset the reader page to size zero.
 	 */
-	if (cpu_buffer->head >= cpu_buffer->head_page->size) {
-		BUG_ON(cpu_buffer->head_page == cpu_buffer->tail_page);
+
+	reader = cpu_buffer->head_page;
+	cpu_buffer->reader_page->list.next = reader->list.next;
+	cpu_buffer->reader_page->list.prev = reader->list.prev;
+	cpu_buffer->reader_page->size = 0;
+
+	/* Make the reader page now replace the head */
+	reader->list.prev->next = &cpu_buffer->reader_page->list;
+	reader->list.next->prev = &cpu_buffer->reader_page->list;
+
+	/*
+	 * If the tail is on the reader, then we must set the head
+	 * to the inserted page, otherwise we set it one before.
+	 */
+	cpu_buffer->head_page = cpu_buffer->reader_page;
+
+	if (cpu_buffer->tail_page != reader)
 		rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
-		rb_reset_read_page(cpu_buffer);
-		return;
-	}
 
-	event = rb_head_event(cpu_buffer);
+	/* Finally update the reader page to the new head */
+	cpu_buffer->reader_page = reader;
+	rb_reset_reader_page(cpu_buffer);
 
-	if (event->type == RINGBUF_TYPE_DATA)
-		cpu_buffer->entries--;
+	goto again;
 
-	length = rb_event_length(event);
+ out:
+	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
 
-	/*
-	 * This should not be called to advance the header if we are
-	 * at the tail of the buffer.
-	 */
-	BUG_ON((cpu_buffer->head_page == cpu_buffer->tail_page) &&
-	       (cpu_buffer->head + length > cpu_buffer->tail));
+	return reader;
+}
 
-	rb_update_read_stamp(cpu_buffer, event);
+static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct ring_buffer_event *event;
+	struct buffer_page *reader;
+	unsigned length;
+
+	reader = rb_get_reader_page(cpu_buffer);
 
-	cpu_buffer->head += length;
+	/* This function should not be called when buffer is empty */
+	BUG_ON(!reader);
 
-	/* check for end of page */
-	if ((cpu_buffer->head >= cpu_buffer->head_page->size) &&
-	    (cpu_buffer->head_page != cpu_buffer->tail_page))
-		rb_advance_head(cpu_buffer);
+	event = rb_reader_event(cpu_buffer);
+
+	if (event->type == RINGBUF_TYPE_DATA)
+		cpu_buffer->entries--;
+
+	rb_update_read_stamp(cpu_buffer, event);
+
+	length = rb_event_length(event);
+	cpu_buffer->reader += length;
 }
 
 static void rb_advance_iter(struct ring_buffer_iter *iter)
@@ -1304,8 +1350,7 @@ static void rb_advance_iter(struct ring_
 	 */
 	if (iter->head >= iter->head_page->size) {
 		BUG_ON(iter->head_page == cpu_buffer->tail_page);
-		rb_inc_page(cpu_buffer, &iter->head_page);
-		rb_reset_iter_read_page(iter);
+		rb_inc_iter(iter);
 		return;
 	}
 
@@ -1344,6 +1389,7 @@ ring_buffer_peek(struct ring_buffer *buf
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
+	struct buffer_page *reader;
 
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return NULL;
@@ -1351,25 +1397,26 @@ ring_buffer_peek(struct ring_buffer *buf
 	cpu_buffer = buffer->buffers[cpu];
 
  again:
-	if (rb_per_cpu_empty(cpu_buffer))
+	reader = rb_get_reader_page(cpu_buffer);
+	if (!reader)
 		return NULL;
 
-	event = rb_head_event(cpu_buffer);
+	event = rb_reader_event(cpu_buffer);
 
 	switch (event->type) {
 	case RINGBUF_TYPE_PADDING:
-		rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
-		rb_reset_read_page(cpu_buffer);
-		goto again;
+		WARN_ON(1);
+		rb_advance_reader(cpu_buffer);
+		return NULL;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
 		/* Internal data, OK to advance */
-		rb_advance_head(cpu_buffer);
+		rb_advance_reader(cpu_buffer);
 		goto again;
 
 	case RINGBUF_TYPE_TIME_STAMP:
 		/* FIXME: not implemented */
-		rb_advance_head(cpu_buffer);
+		rb_advance_reader(cpu_buffer);
 		goto again;
 
 	case RINGBUF_TYPE_DATA:
@@ -1415,8 +1462,7 @@ ring_buffer_iter_peek(struct ring_buffer
 
 	switch (event->type) {
 	case RINGBUF_TYPE_PADDING:
-		rb_inc_page(cpu_buffer, &iter->head_page);
-		rb_reset_iter_read_page(iter);
+		rb_inc_iter(iter);
 		goto again;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
@@ -1465,7 +1511,7 @@ ring_buffer_consume(struct ring_buffer *
 		return NULL;
 
 	cpu_buffer = buffer->buffers[cpu];
-	rb_advance_head(cpu_buffer);
+	rb_advance_reader(cpu_buffer);
 
 	return event;
 }
@@ -1487,6 +1533,7 @@ ring_buffer_read_start(struct ring_buffe
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_iter *iter;
+	unsigned long flags;
 
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return NULL;
@@ -1502,11 +1549,9 @@ ring_buffer_read_start(struct ring_buffe
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
-	spin_lock(&cpu_buffer->lock);
-	iter->head = cpu_buffer->head;
-	iter->head_page = cpu_buffer->head_page;
-	rb_reset_iter_read_page(iter);
-	spin_unlock(&cpu_buffer->lock);
+	spin_lock_irqsave(&cpu_buffer->lock, flags);
+	ring_buffer_iter_reset(iter);
+	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
 
 	return iter;
 }
@@ -1562,10 +1607,14 @@ rb_reset_cpu(struct ring_buffer_per_cpu 
 {
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
-	cpu_buffer->tail_page
-		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
+	cpu_buffer->head_page->size = 0;
+	cpu_buffer->tail_page = cpu_buffer->head_page;
+	cpu_buffer->tail_page->size = 0;
+	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	cpu_buffer->reader_page->size = 0;
+
+	cpu_buffer->head = cpu_buffer->tail = cpu_buffer->reader = 0;
 
-	cpu_buffer->head = cpu_buffer->tail = 0;
 	cpu_buffer->overrun = 0;
 	cpu_buffer->entries = 0;
 }
@@ -1583,13 +1632,11 @@ void ring_buffer_reset_cpu(struct ring_b
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return;
 
-	local_irq_save(flags);
-	spin_lock(&cpu_buffer->lock);
+	spin_lock_irqsave(&cpu_buffer->lock, flags);
 
 	rb_reset_cpu(cpu_buffer);
 
-	spin_unlock(&cpu_buffer->lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
 }
 
 /**
@@ -1598,15 +1645,10 @@ void ring_buffer_reset_cpu(struct ring_b
  */
 void ring_buffer_reset(struct ring_buffer *buffer)
 {
-	unsigned long flags;
 	int cpu;
 
-	ring_buffer_lock(buffer, &flags);
-
 	for_each_buffer_cpu(buffer, cpu)
-		rb_reset_cpu(buffer->buffers[cpu]);
-
-	ring_buffer_unlock(buffer, flags);
+		ring_buffer_reset_cpu(buffer, cpu);
 }
 
 /**
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-09-30 20:48:32.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-01 00:04:28.000000000 -0400
@@ -42,6 +42,20 @@
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;
 
+static DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
+
+static inline void ftrace_disable_cpu(void)
+{
+	preempt_disable();
+	local_inc(&__get_cpu_var(ftrace_cpu_disabled));
+}
+
+static inline void ftrace_enable_cpu(void)
+{
+	local_dec(&__get_cpu_var(ftrace_cpu_disabled));
+	preempt_enable();
+}
+
 static cpumask_t __read_mostly		tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
@@ -406,7 +420,9 @@ update_max_tr(struct trace_array *tr, st
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 
+	ftrace_disable_cpu();
 	ring_buffer_reset(tr->buffer);
+	ftrace_enable_cpu();
 
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
@@ -428,9 +444,13 @@ update_max_tr_single(struct trace_array 
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
 
+	ftrace_disable_cpu();
+
 	ring_buffer_reset(max_tr.buffer);
 	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
 
+	ftrace_enable_cpu();
+
 	WARN_ON_ONCE(ret);
 
 	__update_max_tr(tr, tsk, cpu);
@@ -543,7 +563,9 @@ void unregister_tracer(struct tracer *ty
 
 void tracing_reset(struct trace_array *tr, int cpu)
 {
+	ftrace_disable_cpu();
 	ring_buffer_reset_cpu(tr->buffer, cpu);
+	ftrace_enable_cpu();
 }
 
 #define SAVED_CMDLINES 128
@@ -654,6 +676,10 @@ trace_function(struct trace_array *tr, s
 	struct ftrace_entry *entry;
 	unsigned long irq_flags;
 
+	/* If we are reading the ring buffer, don't trace */
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return;
+
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
 					 &irq_flags);
 	if (!event)
@@ -870,8 +896,14 @@ enum trace_file_type {
 
 static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
 {
+	/* Don't allow ftrace to trace into the ring buffers */
+	ftrace_disable_cpu();
+
 	iter->idx++;
-	ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+	if (iter->buffer_iter[iter->cpu])
+		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+
+	ftrace_enable_cpu();
 }
 
 static struct trace_entry *
@@ -880,9 +912,19 @@ peek_next_entry(struct trace_iterator *i
 	struct ring_buffer_event *event;
 	struct ring_buffer_iter *buf_iter = iter->buffer_iter[cpu];
 
-	event = ring_buffer_iter_peek(buf_iter, ts);
+	/* Don't allow ftrace to trace into the ring buffers */
+	ftrace_disable_cpu();
+
+	if (buf_iter)
+		event = ring_buffer_iter_peek(buf_iter, ts);
+	else
+		event = ring_buffer_peek(iter->tr->buffer, cpu, ts);
+
+	ftrace_enable_cpu();
+
 	return event ? ring_buffer_event_data(event) : NULL;
 }
+
 static struct trace_entry *
 __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 {
@@ -938,7 +980,10 @@ static void *find_next_entry_inc(struct 
 
 static void trace_consume(struct trace_iterator *iter)
 {
+	/* Don't allow ftrace to trace into the ring buffers */
+	ftrace_disable_cpu();
 	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts);
+	ftrace_enable_cpu();
 }
 
 static void *s_next(struct seq_file *m, void *v, loff_t *pos)
@@ -991,10 +1036,14 @@ static void *s_start(struct seq_file *m,
 		iter->cpu = 0;
 		iter->idx = -1;
 
+		ftrace_disable_cpu();
+
 		for_each_tracing_cpu(cpu) {
 			ring_buffer_iter_reset(iter->buffer_iter[cpu]);
 		}
 
+		ftrace_enable_cpu();
+
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
 			;
 
@@ -1242,7 +1291,16 @@ void trace_seq_print_cont(struct trace_s
 		cont = (struct trace_field_cont *)ent;
 		if (ok)
 			ok = (trace_seq_printf(s, "%s", cont->buf) > 0);
-		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+
+		ftrace_disable_cpu();
+
+		if (iter->buffer_iter[iter->cpu])
+			ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+		else
+			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+
+		ftrace_enable_cpu();
+
 		ent = peek_next_entry(iter, iter->cpu, NULL);
 	} while (ent && ent->type == TRACE_CONT);
 
@@ -1683,9 +1741,15 @@ static int trace_empty(struct trace_iter
 	int cpu;
 
 	for_each_tracing_cpu(cpu) {
-		if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
-			return 0;
+		if (iter->buffer_iter[cpu]) {
+			if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
+				return 0;
+		} else {
+			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
+				return 0;
+		}
 	}
+
 	return 1;
 }
 
@@ -1771,8 +1835,10 @@ __tracing_open(struct inode *inode, stru
 	iter->pos = -1;
 
 	for_each_tracing_cpu(cpu) {
+
 		iter->buffer_iter[cpu] =
 			ring_buffer_read_start(iter->tr->buffer, cpu);
+
 		if (!iter->buffer_iter[cpu])
 			goto fail_buffer;
 	}
@@ -2336,7 +2402,6 @@ static atomic_t tracing_reader;
 static int tracing_open_pipe(struct inode *inode, struct file *filp)
 {
 	struct trace_iterator *iter;
-	int cpu;
 
 	if (tracing_disabled)
 		return -ENODEV;
@@ -2357,38 +2422,17 @@ static int tracing_open_pipe(struct inod
 	iter->trace = current_trace;
 	filp->private_data = iter;
 
-	for_each_tracing_cpu(cpu) {
-		iter->buffer_iter[cpu] =
-			ring_buffer_read_start(iter->tr->buffer, cpu);
-		if (!iter->buffer_iter[cpu])
-			goto fail_buffer;
-	}
-
 	if (iter->trace->pipe_open)
 		iter->trace->pipe_open(iter);
 	mutex_unlock(&trace_types_lock);
 
 	return 0;
-
- fail_buffer:
-	for_each_tracing_cpu(cpu) {
-		if (iter->buffer_iter[cpu])
-			ring_buffer_read_finish(iter->buffer_iter[cpu]);
-	}
-	mutex_unlock(&trace_types_lock);
-
-	return -ENOMEM;
 }
 
 static int tracing_release_pipe(struct inode *inode, struct file *file)
 {
 	struct trace_iterator *iter = file->private_data;
-	int cpu;
 
-	for_each_tracing_cpu(cpu) {
-		if (iter->buffer_iter[cpu])
-			ring_buffer_read_finish(iter->buffer_iter[cpu]);
-	}
 	kfree(iter);
 	atomic_dec(&tracing_reader);
 
@@ -2424,7 +2468,6 @@ tracing_read_pipe(struct file *filp, cha
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	unsigned long flags;
 #ifdef CONFIG_FTRACE
 	int ftrace_save;
 #endif
@@ -2522,7 +2565,6 @@ tracing_read_pipe(struct file *filp, cha
 	ftrace_enabled = 0;
 #endif
 	smp_wmb();
-	ring_buffer_lock(iter->tr->buffer, &flags);
 
 	while (find_next_entry_inc(iter) != NULL) {
 		int ret;
@@ -2541,7 +2583,6 @@ tracing_read_pipe(struct file *filp, cha
 			break;
 	}
 
-	ring_buffer_unlock(iter->tr->buffer, flags);
 #ifdef CONFIG_FTRACE
 	ftrace_enabled = ftrace_save;
 #endif
@@ -2999,8 +3040,8 @@ void ftrace_dump(void)
 	static struct trace_iterator iter;
 	static cpumask_t mask;
 	static int dump_ran;
-	unsigned long flags, irq_flags;
-	int cnt = 0;
+	unsigned long flags;
+	int cnt = 0, cpu;
 
 	/* only one dump */
 	spin_lock_irqsave(&ftrace_dump_lock, flags);
@@ -3012,6 +3053,10 @@ void ftrace_dump(void)
 	/* No turning back! */
 	ftrace_kill_atomic();
 
+	for_each_tracing_cpu(cpu) {
+		atomic_inc(&global_trace.data[cpu]->disabled);
+	}
+
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
 	iter.tr = &global_trace;
@@ -3026,8 +3071,6 @@ void ftrace_dump(void)
 
 	cpus_clear(mask);
 
-	ring_buffer_lock(iter.tr->buffer, &irq_flags);
-
 	while (!trace_empty(&iter)) {
 
 		if (!cnt)
@@ -3055,8 +3098,6 @@ void ftrace_dump(void)
 	else
 		printk(KERN_TRACE "---------------------------------\n");
 
-	ring_buffer_unlock(iter.tr->buffer, irq_flags);
-
  out:
 	spin_unlock_irqrestore(&ftrace_dump_lock, flags);
 }

-- 
