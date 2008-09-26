Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbYIZBDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbYIZBDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYIZBCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:02:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40380 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYIZBCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:02:49 -0400
Date: Thu, 25 Sep 2008 21:02:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH v4] Unified trace buffer
In-Reply-To: <20080925185236.244343232@goodmis.org>
Message-ID: <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This version has been cleaned up a bit. I've been running it as
a back end to ftrace, and it has been handling pretty well.

I did not implement the GTOD sync part and will leave that for later.
But this is the basic design that I like and will be the basis
of my future work.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |  178 ++++++
 kernel/trace/Kconfig        |    4 
 kernel/trace/Makefile       |    1 
 kernel/trace/ring_buffer.c  | 1252 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1435 insertions(+)

Index: linux-trace.git/include/linux/ring_buffer.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-trace.git/include/linux/ring_buffer.h	2008-09-25 20:36:12.000000000 -0400
@@ -0,0 +1,178 @@
+#ifndef _LINUX_RING_BUFFER_H
+#define _LINUX_RING_BUFFER_H
+
+#include <linux/mm.h>
+#include <linux/seq_file.h>
+
+struct ring_buffer;
+struct ring_buffer_iter;
+
+/*
+ * Don't reference this struct directly, use the inline items below.
+ */
+struct ring_buffer_event {
+	u32		type:2, len:3, time_delta:27;
+	u32		array[];
+} __attribute__((__packed__));
+
+enum {
+	RB_TYPE_PADDING,	/* Left over page padding
+				 * array is ignored
+				 * size is variable depending on
+				 */
+	RB_TYPE_TIME_EXTENT,	/* Extent the time delta
+				 * array[0] = time delta (28 .. 59)
+				 * size = 8 bytes
+				 */
+	/* FIXME: RB_TYPE_TIME_STAMP not implemented */
+	RB_TYPE_TIME_STAMP,	/* Sync time stamp with external clock
+				 * array[0] = tv_nsec
+				 * array[1] = tv_sec
+				 * size = 16 bytes
+				 */
+
+	RB_TYPE_DATA,		/* Data record
+				 * If len is zero:
+				 *  array[0] holds the actual length
+				 *  array[1..(length+3)/4] holds data
+				 * else
+				 *  length = len << 2
+				 *  array[0..(length+3)/4] holds data
+				 */
+};
+
+#define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
+#define RB_ALIGNMENT_SHIFT	2
+#define RB_ALIGNMENT		(1 << RB_ALIGNMENT_SHIFT)
+#define RB_MAX_SMALL_DATA	(28)
+
+enum {
+	RB_LEN_TIME_EXTENT = 8,
+	RB_LEN_TIME_STAMP = 16,
+};
+
+/**
+ * ring_buffer_event_length - return the length of the event
+ * @event: the event to get the length of
+ */
+static inline unsigned
+ring_buffer_event_length(struct ring_buffer_event *event)
+{
+	unsigned length;
+
+	switch (event->type) {
+	case RB_TYPE_PADDING:
+		/* undefined */
+		return -1;
+
+	case RB_TYPE_TIME_EXTENT:
+		return RB_LEN_TIME_EXTENT;
+
+	case RB_TYPE_TIME_STAMP:
+		return RB_LEN_TIME_STAMP;
+
+	case RB_TYPE_DATA:
+		if (event->len)
+			length = event->len << RB_ALIGNMENT_SHIFT;
+		else
+			length = event->array[0];
+		return length + RB_EVNT_HDR_SIZE;
+	default:
+		BUG();
+	}
+	/* not hit */
+	return 0;
+}
+
+/**
+ * ring_buffer_event_time_delta - return the delta timestamp of the event
+ * @event: the event to get the delta timestamp of
+ *
+ * The delta timestamp is the 27 bit timestamp since the last event.
+ */
+static inline unsigned
+ring_buffer_event_time_delta(struct ring_buffer_event *event)
+{
+	return event->time_delta;
+}
+
+/**
+ * ring_buffer_event_data - return the data of the event
+ * @event: the event to get the data from
+ */
+static inline void *
+ring_buffer_event_data(struct ring_buffer_event *event)
+{
+	BUG_ON(event->type != RB_TYPE_DATA);
+	/* If length is in len field, then array[0] has the data */
+	if (event->len)
+		return (void *)&event->array[0];
+	/* Otherwise length is in array[0] and array[1] has the data */
+	return (void *)&event->array[1];
+}
+
+void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags);
+void ring_buffer_unlock(struct ring_buffer *buffer, unsigned long flags);
+
+/*
+ * size is in bytes for each per CPU buffer.
+ */
+struct ring_buffer *
+ring_buffer_alloc(unsigned long size, unsigned flags);
+void ring_buffer_free(struct ring_buffer *buffer);
+
+int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
+
+struct ring_buffer_event *
+ring_buffer_lock_reserve(struct ring_buffer *buffer,
+			 unsigned long length,
+			 unsigned long *flags);
+int ring_buffer_unlock_commit(struct ring_buffer *buffer,
+			      struct ring_buffer_event *event,
+			      unsigned long flags);
+int ring_buffer_write(struct ring_buffer *buffer,
+		      unsigned long length, void *data);
+
+struct ring_buffer_event *
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
+struct ring_buffer_event *
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts);
+
+struct ring_buffer_iter *
+ring_buffer_read_start(struct ring_buffer *buffer, int cpu);
+void ring_buffer_read_finish(struct ring_buffer_iter *iter);
+
+struct ring_buffer_event *
+ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts);
+struct ring_buffer_event *
+ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts);
+void ring_buffer_iter_reset(struct ring_buffer_iter *iter);
+int ring_buffer_iter_empty(struct ring_buffer_iter *iter);
+
+unsigned long ring_buffer_size(struct ring_buffer *buffer);
+
+void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
+void ring_buffer_reset(struct ring_buffer *buffer);
+
+int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
+			 struct ring_buffer *buffer_b, int cpu);
+
+int ring_buffer_empty(struct ring_buffer *buffer);
+int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
+
+void ring_buffer_record_disable(struct ring_buffer *buffer);
+void ring_buffer_record_enable(struct ring_buffer *buffer);
+void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
+void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
+
+unsigned long ring_buffer_entries(struct ring_buffer *buffer);
+unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
+
+u64 ring_buffer_time_stamp(int cpu);
+void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
+
+enum ring_buffer_flags {
+	RB_FL_OVERWRITE		= 1 << 0,
+};
+
+#endif /* _LINUX_RING_BUFFER_H */
Index: linux-trace.git/kernel/trace/ring_buffer.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-trace.git/kernel/trace/ring_buffer.c	2008-09-25 20:35:44.000000000 -0400
@@ -0,0 +1,1252 @@
+/*
+ * Generic ring buffer
+ *
+ * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
+ */
+#include <linux/ring_buffer.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <linux/hash.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+
+#include "trace.h"
+
+/* FIXME!!! */
+u64 ring_buffer_time_stamp(int cpu)
+{
+	/* mult -1 to test normalize */
+	return sched_clock() * -1;
+}
+void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
+{
+	*ts *= -1;
+}
+
+#define TS_SHIFT	27
+#define TS_MASK		((1ULL << TS_SHIFT) - 1)
+#define TS_DELTA_TEST	~TS_MASK
+
+/*
+ * We need to fit the time_stamp delta into 27 bits.
+ */
+static inline int
+test_time_stamp(unsigned long long delta)
+{
+	if (delta & TS_DELTA_TEST)
+		return 1;
+	return 0;
+}
+
+struct buffer_page {
+	u64		time_stamp;
+	unsigned char	body[];
+};
+
+#define BUF_PAGE_SIZE (PAGE_SIZE - sizeof(u64))
+
+/*
+ * head_page == tail_page && head == tail then buffer is empty.
+ */
+struct ring_buffer_per_cpu {
+	int			cpu;
+	struct ring_buffer	*buffer;
+	raw_spinlock_t		lock;
+	struct lock_class_key	lock_key;
+	struct buffer_page	**pages;
+	unsigned long		head;	/* read from head */
+	unsigned long		tail;	/* write to tail */
+	unsigned long		head_page;
+	unsigned long		tail_page;
+	unsigned long		overrun;
+	unsigned long		entries;
+	u64			write_stamp;
+	u64			read_stamp;
+	atomic_t		record_disabled;
+};
+
+struct ring_buffer {
+	unsigned long		size;
+	unsigned		pages;
+	unsigned		flags;
+	int			cpus;
+	atomic_t		record_disabled;
+
+	spinlock_t		lock;
+
+	/* FIXME: this should be online CPUS */
+	struct ring_buffer_per_cpu *buffers[NR_CPUS];
+};
+
+struct ring_buffer_iter {
+	struct ring_buffer_per_cpu	*cpu_buffer;
+	unsigned long			head;
+	unsigned long			head_page;
+	u64				read_stamp;
+};
+
+static struct ring_buffer_per_cpu *
+ring_buffer_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int pages = buffer->pages;
+	int i;
+
+	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
+				  GFP_KERNEL, cpu_to_node(cpu));
+	if (!cpu_buffer)
+		return NULL;
+
+	cpu_buffer->cpu = cpu;
+	cpu_buffer->buffer = buffer;
+	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
+	cpu_buffer->pages = kzalloc_node(ALIGN(sizeof(void *) * pages,
+					       cache_line_size()), GFP_KERNEL,
+					 cpu_to_node(cpu));
+	if (!cpu_buffer->pages)
+		goto fail_free_buffer;
+
+	for (i = 0; i < pages; i++) {
+		cpu_buffer->pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!cpu_buffer->pages[i])
+			goto fail_free_pages;
+	}
+
+	return cpu_buffer;
+
+ fail_free_pages:
+	for (i = 0; i < pages; i++) {
+		if (cpu_buffer->pages[i])
+			free_page((unsigned long)cpu_buffer->pages[i]);
+	}
+	kfree(cpu_buffer->pages);
+
+ fail_free_buffer:
+	kfree(cpu_buffer);
+	return NULL;
+}
+
+static void
+ring_buffer_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	int i;
+
+	for (i = 0; i < cpu_buffer->buffer->pages; i++) {
+		if (cpu_buffer->pages[i])
+			free_page((unsigned long)cpu_buffer->pages[i]);
+	}
+	kfree(cpu_buffer->pages);
+	kfree(cpu_buffer);
+}
+
+/**
+ * ring_buffer_alloc - allocate a new ring_buffer
+ * @size: the size in bytes that is needed.
+ * @flags: attributes to set for the ring buffer.
+ *
+ * Currently the only flag that is available is the RB_FL_OVERWRITE
+ * flag. This flag means that the buffer will overwrite old data
+ * when the buffer wraps. If this flag is not set, the buffer will
+ * drop data when the tail hits the head.
+ */
+struct ring_buffer *
+ring_buffer_alloc(unsigned long size, unsigned flags)
+{
+	struct ring_buffer *buffer;
+	int cpu;
+
+	/* keep it in its own cache line */
+	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
+			 GFP_KERNEL);
+	if (!buffer)
+		return NULL;
+
+	buffer->pages = (size + (PAGE_SIZE - 1)) / PAGE_SIZE;
+	buffer->flags = flags;
+
+	/* need at least two pages */
+	if (buffer->pages == 1)
+		buffer->pages++;
+
+	/* FIXME: do for only online CPUS */
+	buffer->cpus = num_possible_cpus();
+	for_each_possible_cpu(cpu) {
+		if (cpu >= buffer->cpus)
+			continue;
+		buffer->buffers[cpu] =
+			ring_buffer_allocate_cpu_buffer(buffer, cpu);
+		if (!buffer->buffers[cpu])
+			goto fail_free_buffers;
+	}
+
+	spin_lock_init(&buffer->lock);
+
+	return buffer;
+
+ fail_free_buffers:
+	for_each_possible_cpu(cpu) {
+		if (cpu >= buffer->cpus)
+			continue;
+		if (buffer->buffers[cpu])
+			ring_buffer_free_cpu_buffer(buffer->buffers[cpu]);
+	}
+
+	kfree(buffer);
+	return NULL;
+}
+
+/**
+ * ring_buffer_free - free a ring buffer.
+ * @buffer: the buffer to free.
+ */
+void
+ring_buffer_free(struct ring_buffer *buffer)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++)
+		ring_buffer_free_cpu_buffer(buffer->buffers[cpu]);
+
+	kfree(buffer);
+}
+
+/**
+ * ring_buffer_resize - resize the ring buffer
+ * @buffer: the buffer to resize.
+ * @size: the new size.
+ *
+ * Returns -1 on failure.
+ */
+int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
+{
+	/* FIXME: */
+	return -1;
+}
+
+static inline int
+ring_buffer_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_buffer->head_page == cpu_buffer->tail_page &&
+		cpu_buffer->head == cpu_buffer->tail;
+}
+
+static inline int
+ring_buffer_null_event(struct ring_buffer_event *event)
+{
+	return event->type == RB_TYPE_PADDING;
+}
+
+static inline void *
+rb_page_body(struct ring_buffer_per_cpu *cpu_buffer,
+		      unsigned long page, unsigned index)
+{
+	return cpu_buffer->pages[page]->body + index;
+}
+
+static inline struct ring_buffer_event *
+ring_buffer_head_event(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return rb_page_body(cpu_buffer,cpu_buffer->head_page,
+			    cpu_buffer->head);
+}
+
+static inline struct ring_buffer_event *
+ring_buffer_iter_head_event(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+
+	return rb_page_body(cpu_buffer, iter->head_page,
+			    iter->head);
+}
+
+/*
+ * When the tail hits the head and the buffer is in overwrite mode,
+ * the head jumps to the next page and all content on the previous
+ * page is discarded. But before doing so, we update the overrun
+ * variable of the buffer.
+ */
+static void
+ring_buffer_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct ring_buffer_event *event;
+	unsigned long head;
+
+	for (head = 0; head < BUF_PAGE_SIZE;
+	     head += ring_buffer_event_length(event)) {
+		event = rb_page_body(cpu_buffer, cpu_buffer->head_page, head);
+		if (ring_buffer_null_event(event))
+			break;
+		cpu_buffer->overrun++;
+		cpu_buffer->entries--;
+	}
+}
+
+static inline void
+ring_buffer_inc_page(struct ring_buffer *buffer,
+		     unsigned long *page)
+{
+	(*page)++;
+	if (*page >= buffer->pages)
+		*page = 0;
+}
+
+static inline void
+rb_add_stamp(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
+{
+	struct buffer_page *bpage;
+
+	bpage = cpu_buffer->pages[cpu_buffer->tail_page];
+	bpage->time_stamp = *ts;
+}
+
+static void
+rb_reset_read_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *bpage;
+
+	cpu_buffer->head = 0;
+	bpage = cpu_buffer->pages[cpu_buffer->head_page];
+	cpu_buffer->read_stamp = bpage->time_stamp;
+}
+
+static void
+rb_reset_iter_read_page(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+	struct buffer_page *bpage;
+
+	iter->head = 0;
+	bpage = cpu_buffer->pages[iter->head_page];
+	iter->read_stamp = bpage->time_stamp;
+}
+
+/**
+ * ring_buffer_update_event - update event type and data
+ * @event: the even to update
+ * @type: the type of event
+ * @length: the size of the event field in the ring buffer
+ *
+ * Update the type and data fields of the event. The length
+ * is the actual size that is written to the ring buffer,
+ * and with this, we can determine what to place into the
+ * data field.
+ */
+static inline void
+ring_buffer_update_event(struct ring_buffer_event *event,
+			 unsigned type, unsigned length)
+{
+	event->type = type;
+
+	switch (type) {
+
+	case RB_TYPE_PADDING:
+		break;
+
+	case RB_TYPE_TIME_EXTENT:
+		event->len =
+			(RB_LEN_TIME_EXTENT + (RB_ALIGNMENT-1))
+			>> RB_ALIGNMENT_SHIFT;
+		break;
+
+	case RB_TYPE_TIME_STAMP:
+		event->len =
+			(RB_LEN_TIME_STAMP + (RB_ALIGNMENT-1))
+			>> RB_ALIGNMENT_SHIFT;
+		break;
+
+	case RB_TYPE_DATA:
+		length -= RB_EVNT_HDR_SIZE;
+		if (length > RB_MAX_SMALL_DATA) {
+			event->len = 0;
+			event->array[0] = length;
+		} else
+			event->len =
+				(length + (RB_ALIGNMENT-1))
+				>> RB_ALIGNMENT_SHIFT;
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline unsigned rb_calculate_event_length(unsigned length)
+{
+	struct ring_buffer_event event; /* Used only for sizeof array */
+
+	/* zero length can cause confusions */
+	if (!length)
+		length = 1;
+
+	if (length > RB_MAX_SMALL_DATA)
+		length += sizeof(event.array[0]);
+
+	length += RB_EVNT_HDR_SIZE;
+	length = ALIGN(length, RB_ALIGNMENT);
+
+	return length;
+}
+
+static struct ring_buffer_event *
+__ring_buffer_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
+			   unsigned type, unsigned long length, u64 *ts)
+{
+	unsigned long head_page, tail_page, tail;
+	struct ring_buffer *buffer = cpu_buffer->buffer;
+	struct ring_buffer_event *event;
+
+	tail_page = cpu_buffer->tail_page;
+	head_page = cpu_buffer->head_page;
+	tail = cpu_buffer->tail;
+
+	BUG_ON(tail_page >= buffer->pages);
+	BUG_ON(head_page >= buffer->pages);
+
+	if (tail + length > BUF_PAGE_SIZE) {
+		unsigned long next_page = tail_page;
+
+		ring_buffer_inc_page(buffer, &next_page);
+
+		if (next_page == head_page) {
+			if (!(buffer->flags & RB_FL_OVERWRITE))
+				return NULL;
+
+			/* count overflows */
+			ring_buffer_update_overflow(cpu_buffer);
+
+			ring_buffer_inc_page(buffer, &head_page);
+			cpu_buffer->head_page = head_page;
+			rb_reset_read_page(cpu_buffer);
+		}
+
+		if (tail != BUF_PAGE_SIZE) {
+			event = rb_page_body(cpu_buffer, tail_page, tail);
+			/* page padding */
+			event->type = RB_TYPE_PADDING;
+		}
+
+		tail = 0;
+		tail_page = next_page;
+		cpu_buffer->tail_page = tail_page;
+		cpu_buffer->tail = tail;
+		rb_add_stamp(cpu_buffer, ts);
+	}
+
+	BUG_ON(tail_page >= buffer->pages);
+	BUG_ON(tail + length > BUF_PAGE_SIZE);
+
+	event = rb_page_body(cpu_buffer, tail_page, tail);
+	ring_buffer_update_event(event, type, length);
+	cpu_buffer->entries++;
+
+	return event;
+}
+
+static struct ring_buffer_event *
+ring_buffer_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
+			       unsigned type, unsigned long length)
+{
+	unsigned long long ts, delta;
+	struct ring_buffer_event *event;
+
+	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
+
+	if (cpu_buffer->tail) {
+		delta = ts - cpu_buffer->write_stamp;
+
+		if (test_time_stamp(delta)) {
+			/*
+			 * The delta is too big, we to add a
+			 * new timestamp.
+			 */
+			event = __ring_buffer_reserve_next(cpu_buffer,
+							   RB_TYPE_TIME_EXTENT,
+							   RB_LEN_TIME_EXTENT,
+							   &ts);
+			if (!event)
+				return NULL;
+
+			/* check to see if we went to the next page */
+			if (!cpu_buffer->tail) {
+				/*
+				 * new page, dont commit this and add the
+				 * time stamp to the page instead.
+				 */
+				rb_add_stamp(cpu_buffer, &ts);
+			} else {
+				event->time_delta = delta & TS_MASK;
+				event->array[0] = delta >> TS_SHIFT;
+			}
+
+			cpu_buffer->write_stamp = ts;
+			delta = 0;
+		}
+	} else {
+		rb_add_stamp(cpu_buffer, &ts);
+		delta = 0;
+	}
+
+	event = __ring_buffer_reserve_next(cpu_buffer, type, length, &ts);
+	if (!event)
+		return NULL;
+
+	event->time_delta = delta;
+	cpu_buffer->write_stamp = ts;
+
+	return event;
+}
+
+/**
+ * ring_buffer_lock_reserve - reserve a part of the buffer
+ * @buffer: the ring buffer to reserve from
+ * @length: the length of the data to reserve (excluding event header)
+ * @flags: a pointer to save the interrupt flags
+ *
+ * Returns a reseverd event on the ring buffer to copy directly to.
+ * The user of this interface will need to get the body to write into
+ * and can use the ring_buffer_event_data() interface.
+ *
+ * The length is the length of the data needed, not the event length
+ * which also includes the event header.
+ *
+ * Must be paired with ring_buffer_unlock_commit, unless NULL is returned.
+ * If NULL is returned, then nothing has been allocated or locked.
+ */
+struct ring_buffer_event *
+ring_buffer_lock_reserve(struct ring_buffer *buffer,
+			 unsigned long length,
+			 unsigned long *flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	int cpu;
+
+	if (atomic_read(&buffer->record_disabled))
+		return NULL;
+
+	raw_local_irq_save(*flags);
+	cpu = raw_smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+	__raw_spin_lock(&cpu_buffer->lock);
+
+	if (atomic_read(&cpu_buffer->record_disabled))
+		goto no_record;
+
+	length = rb_calculate_event_length(length);
+	if (length > BUF_PAGE_SIZE)
+		return NULL;
+
+	event = ring_buffer_reserve_next_event(cpu_buffer,
+					       RB_TYPE_DATA, length);
+	if (!event)
+		goto no_record;
+
+	return event;
+
+ no_record:
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(*flags);
+	return NULL;
+}
+
+/**
+ * ring_buffer_unlock_commit - commit a reserved
+ * @buffer: The buffer to commit to
+ * @event: The event pointer to commit.
+ * @flags: the interrupt flags received from ring_buffer_lock_reserve.
+ *
+ * This commits the data to the ring buffer, and releases any locks held.
+ *
+ * Must be paired with ring_buffer_lock_reserve.
+ */
+int ring_buffer_unlock_commit(struct ring_buffer *buffer,
+			      struct ring_buffer_event *event,
+			      unsigned long flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu = raw_smp_processor_id();
+
+	cpu_buffer = buffer->buffers[cpu];
+	cpu_buffer->tail += ring_buffer_event_length(event);
+
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
+
+	return 0;
+}
+
+/**
+ * ring_buffer_write - write data to the buffer without reserving
+ * @buffer: The ring buffer to write to.
+ * @length: The length of the data being written (excluding the event header)
+ * @data: The data to write to the buffer.
+ *
+ * This is like ring_buffer_lock_reserve and ring_buffer_unlock_commit as
+ * one function. If you already have the data to write to the buffer, it
+ * may be easier to simply call this function.
+ *
+ * Note, like ring_buffer_lock_reserve, the length is the length of the data
+ * and not the length of the event which would hold the header.
+ */
+int ring_buffer_write(struct ring_buffer *buffer,
+			unsigned long length,
+			void *data)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	unsigned long event_length, flags;
+	void *body;
+	int ret = 0;
+	int cpu;
+
+	if (atomic_read(&buffer->record_disabled))
+		return -EBUSY;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+	__raw_spin_lock(&cpu_buffer->lock);
+
+	if (atomic_read(&cpu_buffer->record_disabled))
+		goto out;
+
+	event_length = rb_calculate_event_length(length);
+	event = ring_buffer_reserve_next_event(cpu_buffer,
+					       RB_TYPE_DATA, event_length);
+	if (!event)
+		goto out;
+
+	body = ring_buffer_event_data(event);
+
+	memcpy(body, data, length);
+	cpu_buffer->tail += event_length;
+
+ out:
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+/**
+ * ring_buffer_lock - lock the ring buffer
+ * @buffer: The ring buffer to lock
+ * @flags: The place to store the interrupt flags
+ *
+ * This locks all the per CPU buffers.
+ *
+ * Must be unlocked by ring_buffer_unlock.
+ */
+void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	local_irq_save(*flags);
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+
+		cpu_buffer = buffer->buffers[cpu];
+		__raw_spin_lock(&cpu_buffer->lock);
+	}
+}
+
+/**
+ * ring_buffer_unlock - unlock a locked buffer
+ * @buffer: The locked buffer to unlock
+ * @flags: The interrupt flags received by ring_buffer_lock
+ */
+void ring_buffer_unlock(struct ring_buffer *buffer, unsigned long flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	for (cpu = buffer->cpus - 1; cpu >= 0; cpu--) {
+
+		cpu_buffer = buffer->buffers[cpu];
+		__raw_spin_unlock(&cpu_buffer->lock);
+	}
+
+	local_irq_restore(flags);
+}
+
+/**
+ * ring_buffer_record_disable - stop all writes into the buffer
+ * @buffer: The ring buffer to stop writes to.
+ *
+ * This prevents all writes to the buffer. Any attempt to write
+ * to the buffer after this will fail and return NULL.
+ */
+void ring_buffer_record_disable(struct ring_buffer *buffer)
+{
+	atomic_inc(&buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_record_enable - enable writes to the buffer
+ * @buffer: The ring buffer to enable writes
+ *
+ * Note, multiple disables will need the same number of enables
+ * to truely enable the writing (much like preempt_disable).
+ */
+void ring_buffer_record_enable(struct ring_buffer *buffer)
+{
+	atomic_dec(&buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_record_disable_cpu - stop all writes into the cpu_buffer
+ * @buffer: The ring buffer to stop writes to.
+ * @cpu: The CPU buffer to stop
+ *
+ * This prevents all writes to the buffer. Any attempt to write
+ * to the buffer after this will fail and return NULL.
+ */
+void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = buffer->buffers[cpu];
+	atomic_inc(&cpu_buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_record_enable_cpu - enable writes to the buffer
+ * @buffer: The ring buffer to enable writes
+ * @cpu: The CPU to enable.
+ *
+ * Note, multiple disables will need the same number of enables
+ * to truely enable the writing (much like preempt_disable).
+ */
+void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = buffer->buffers[cpu];
+	atomic_dec(&cpu_buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the entries from.
+ */
+unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = buffer->buffers[cpu];
+	return cpu_buffer->entries;
+}
+
+/**
+ * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = buffer->buffers[cpu];
+	return cpu_buffer->overrun;
+}
+
+/**
+ * ring_buffer_entries - get the number of entries in a buffer
+ * @buffer: The ring buffer
+ *
+ * Returns the total number of entries in the ring buffer
+ * (all CPU entries)
+ */
+unsigned long ring_buffer_entries(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long entries = 0;
+	int cpu;
+
+	/* if you care about this being correct, lock the buffer */
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+		entries += cpu_buffer->entries;
+	}
+
+	return entries;
+}
+
+/**
+ * ring_buffer_overrun_cpu - get the number of overruns in buffer
+ * @buffer: The ring buffer
+ *
+ * Returns the total number of overruns in the ring buffer
+ * (all CPU entries)
+ */
+unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long overruns = 0;
+	int cpu;
+
+	/* if you care about this being correct, lock the buffer */
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+		overruns += cpu_buffer->overrun;
+	}
+
+	return overruns;
+}
+
+/**
+ * ring_buffer_iter_reset - reset an iterator
+ * @iter: The iterator to reset
+ *
+ * Resets the iterator, so that it will start from the beginning
+ * again.
+ */
+void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+
+	iter->head_page = cpu_buffer->head_page;
+	iter->head = cpu_buffer->head;
+	rb_reset_iter_read_page(iter);
+}
+
+/**
+ * ring_buffer_iter_empty - check if an iterator has no more to read
+ * @iter: The iterator to check
+ */
+int ring_buffer_iter_empty(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = iter->cpu_buffer;
+
+	return iter->head_page == cpu_buffer->tail_page &&
+		iter->head == cpu_buffer->tail;
+}
+
+static void
+ring_buffer_advance_head(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct ring_buffer *buffer = cpu_buffer->buffer;
+	struct ring_buffer_event *event;
+	unsigned length;
+
+	event = ring_buffer_head_event(cpu_buffer);
+	/*
+	 * Check if we are at the end of the buffer.
+	 */
+	if (ring_buffer_null_event(event)) {
+		BUG_ON(cpu_buffer->head_page == cpu_buffer->tail_page);
+		ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
+		rb_reset_read_page(cpu_buffer);
+		return;
+	}
+
+	length = ring_buffer_event_length(event);
+
+	/*
+	 * This should not be called to advance the header if we are
+	 * at the tail of the buffer.
+	 */
+	BUG_ON((cpu_buffer->head_page == cpu_buffer->tail_page) &&
+	       (cpu_buffer->head + length > cpu_buffer->tail));
+
+	cpu_buffer->head += length;
+
+	/* check for end of page padding */
+	event = ring_buffer_head_event(cpu_buffer);
+	if (ring_buffer_null_event(event) &&
+	    (cpu_buffer->head_page != cpu_buffer->tail_page))
+		ring_buffer_advance_head(cpu_buffer);
+}
+
+static void
+ring_buffer_advance_iter(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer *buffer;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	unsigned length;
+
+	cpu_buffer = iter->cpu_buffer;
+	buffer = cpu_buffer->buffer;
+
+	event = ring_buffer_iter_head_event(iter);
+
+	/*
+	 * Check if we are at the end of the buffer.
+	 */
+	if (ring_buffer_null_event(event)) {
+		BUG_ON(iter->head_page == cpu_buffer->tail_page);
+		ring_buffer_inc_page(buffer, &iter->head_page);
+		rb_reset_iter_read_page(iter);
+		return;
+	}
+
+	length = ring_buffer_event_length(event);
+
+	/*
+	 * This should not be called to advance the header if we are
+	 * at the tail of the buffer.
+	 */
+	BUG_ON((iter->head_page == cpu_buffer->tail_page) &&
+	       (iter->head + length > cpu_buffer->tail));
+
+	iter->head += length;
+
+	/* check for end of page padding */
+	event = ring_buffer_iter_head_event(iter);
+	if (ring_buffer_null_event(event) &&
+	    (iter->head_page != cpu_buffer->tail_page))
+		ring_buffer_advance_iter(iter);
+}
+
+/**
+ * ring_buffer_peek - peek at the next event to be read
+ * @buffer: The ring buffer to read
+ * @cpu: The cpu to peak at
+ * @ts: The timestamp counter of this event.
+ *
+ * This will return the event that will be read next, but does
+ * not consume the data.
+ */
+struct ring_buffer_event *
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	u64 delta;
+
+	cpu_buffer = buffer->buffers[cpu];
+
+ again:
+	if (ring_buffer_per_cpu_empty(cpu_buffer))
+		return NULL;
+
+	event = ring_buffer_head_event(cpu_buffer);
+
+	switch (event->type) {
+	case RB_TYPE_PADDING:
+		ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
+		rb_reset_read_page(cpu_buffer);
+		goto again;
+
+	case RB_TYPE_TIME_EXTENT:
+		delta = event->array[0];
+		delta <<= TS_SHIFT;
+		delta += event->time_delta;
+		cpu_buffer->read_stamp += delta;
+		/* Internal data, OK to advance */
+		ring_buffer_advance_head(cpu_buffer);
+		goto again;
+
+	case RB_TYPE_TIME_STAMP:
+		/* FIXME: not implemented */
+		ring_buffer_advance_head(cpu_buffer);
+		goto again;
+
+	case RB_TYPE_DATA:
+		if (ts) {
+			*ts = cpu_buffer->read_stamp + event->time_delta;
+			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
+		}
+		return event;
+
+	default:
+		BUG();
+	}
+
+	return NULL;
+}
+
+/**
+ * ring_buffer_iter_peek - peek at the next event to be read
+ * @iter: The ring buffer iterator
+ * @ts: The timestamp counter of this event.
+ *
+ * This will return the event that will be read next, but does
+ * not increment the iterator.
+ */
+struct ring_buffer_event *
+ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
+{
+	struct ring_buffer *buffer;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	u64 delta;
+
+	if (ring_buffer_iter_empty(iter))
+		return NULL;
+
+	cpu_buffer = iter->cpu_buffer;
+	buffer = cpu_buffer->buffer;
+
+ again:
+	if (ring_buffer_per_cpu_empty(cpu_buffer))
+		return NULL;
+
+	event = ring_buffer_iter_head_event(iter);
+
+	switch (event->type) {
+	case RB_TYPE_PADDING:
+		ring_buffer_inc_page(buffer, &iter->head_page);
+		rb_reset_iter_read_page(iter);
+		goto again;
+
+	case RB_TYPE_TIME_EXTENT:
+		delta = event->array[0];
+		delta <<= TS_SHIFT;
+		delta += event->time_delta;
+		iter->read_stamp += delta;
+		/* Internal data, OK to advance */
+		ring_buffer_advance_iter(iter);
+		goto again;
+
+	case RB_TYPE_TIME_STAMP:
+		/* FIXME: not implemented */
+		ring_buffer_advance_iter(iter);
+		goto again;
+
+	case RB_TYPE_DATA:
+		if (ts) {
+			*ts = iter->read_stamp + event->time_delta;
+			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
+		}
+		return event;
+
+	default:
+		BUG();
+	}
+
+	return NULL;
+}
+
+/**
+ * ring_buffer_consume - return an event and consume it
+ * @buffer: The ring buffer to get the next event from
+ *
+ * Returns the next event in the ring buffer, and that event is consumed.
+ * Meaning, that sequential reads will keep returning a different event,
+ * and eventually empty the ring buffer if the producer is slower.
+ */
+struct ring_buffer_event *
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+
+	event = ring_buffer_peek(buffer, cpu, ts);
+	if (!event)
+		return NULL;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ring_buffer_advance_head(cpu_buffer);
+
+	return event;
+}
+
+/**
+ * ring_buffer_read_start - start a non consuming read of the buffer
+ * @buffer: The ring buffer to read from
+ * @cpu: The cpu buffer to iterate over
+ *
+ * This starts up an iteration through the buffer. It also disables
+ * the recording to the buffer until the reading is finished.
+ * This prevents the reading from being corrupted. This is not
+ * a consuming read, so a producer is not expected.
+ *
+ * Must be paired with ring_buffer_finish.
+ */
+struct ring_buffer_iter *
+ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_iter *iter;
+
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return NULL;
+
+	cpu_buffer = buffer->buffers[cpu];
+
+	iter->cpu_buffer = cpu_buffer;
+
+	atomic_inc(&cpu_buffer->record_disabled);
+
+	__raw_spin_lock(&cpu_buffer->lock);
+	iter->head = cpu_buffer->head;
+	iter->head_page = cpu_buffer->head_page;
+	rb_reset_iter_read_page(iter);
+	__raw_spin_unlock(&cpu_buffer->lock);
+
+	return iter;
+}
+
+/**
+ * ring_buffer_finish - finish reading the iterator of the buffer
+ * @iter: The iterator retrieved by ring_buffer_start
+ *
+ * This re-enables the recording to the buffer, and frees the
+ * iterator.
+ */
+void
+ring_buffer_read_finish(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+
+	atomic_dec(&cpu_buffer->record_disabled);
+	kfree(iter);
+}
+
+/**
+ * ring_buffer_read - read the next item in the ring buffer by the iterator
+ * @iter: The ring buffer iterator
+ * @ts: The time stamp of the event read.
+ *
+ * This reads the next event in the ring buffer and increments the iterator.
+ */
+struct ring_buffer_event *
+ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
+{
+	struct ring_buffer_event *event;
+
+	event = ring_buffer_iter_peek(iter, ts);
+	if (!event)
+		return NULL;
+
+	ring_buffer_advance_iter(iter);
+
+	return event;
+}
+
+/**
+ * ring_buffer_size - return the size of the ring buffer (in bytes)
+ * @buffer: The ring buffer.
+ */
+unsigned long ring_buffer_size(struct ring_buffer *buffer)
+{
+	return BUF_PAGE_SIZE * buffer->pages;
+}
+
+static void
+__ring_buffer_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	cpu_buffer->head_page = cpu_buffer->tail_page = 0;
+	cpu_buffer->head = cpu_buffer->tail = 0;
+	cpu_buffer->overrun = 0;
+	cpu_buffer->entries = 0;
+}
+
+/**
+ * ring_buffer_reset_cpu - reset a ring buffer per CPU buffer
+ * @buffer: The ring buffer to reset a per cpu buffer of
+ * @cpu: The CPU buffer to be reset
+ */
+void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&cpu_buffer->lock);
+
+	__ring_buffer_reset_cpu(cpu_buffer);
+
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
+}
+
+/**
+ * ring_buffer_reset_cpu - reset a ring buffer per CPU buffer
+ * @buffer: The ring buffer to reset a per cpu buffer of
+ * @cpu: The CPU buffer to be reset
+ */
+void ring_buffer_reset(struct ring_buffer *buffer)
+{
+	unsigned long flags;
+	int cpu;
+
+	ring_buffer_lock(buffer, &flags);
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++)
+		__ring_buffer_reset_cpu(buffer->buffers[cpu]);
+
+	ring_buffer_unlock(buffer, flags);
+}
+
+/**
+ * rind_buffer_empty - is the ring buffer empty?
+ * @buffer: The ring buffer to test
+ */
+int ring_buffer_empty(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	/* yes this is racy, but if you don't like the race, lock the buffer */
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+		if (!ring_buffer_per_cpu_empty(cpu_buffer))
+			return 0;
+	}
+	return 1;
+}
+
+/**
+ * ring_buffer_empty_cpu - is a cpu buffer of a ring buffer empty?
+ * @buffer: The ring buffer
+ * @cpu: The CPU buffer to test
+ */
+int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = buffer->buffers[cpu];
+	return ring_buffer_per_cpu_empty(cpu_buffer);
+}
+
+/**
+ * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
+ * @buffer_a: One buffer to swap with
+ * @buffer_b: The other buffer to swap with
+ *
+ * This function is useful for tracers that want to take a "snapshot"
+ * of a CPU buffer and has another back up buffer lying around.
+ * it is expected that the tracer handles the cpu buffer not being
+ * used at the moment.
+ */
+int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
+			 struct ring_buffer *buffer_b, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer_a;
+	struct ring_buffer_per_cpu *cpu_buffer_b;
+
+	/* At least make sure the two buffers are somewhat the same */
+	if (buffer_a->size != buffer_b->size ||
+	    buffer_a->pages != buffer_b->pages)
+		return -EINVAL;
+
+	cpu_buffer_a = buffer_a->buffers[cpu];
+	cpu_buffer_b = buffer_b->buffers[cpu];
+
+	atomic_inc(&cpu_buffer_a->record_disabled);
+	atomic_inc(&cpu_buffer_b->record_disabled);
+
+	buffer_a->buffers[cpu] = cpu_buffer_b;
+	buffer_b->buffers[cpu] = cpu_buffer_a;
+
+	cpu_buffer_b->buffer = buffer_a;
+	cpu_buffer_a->buffer = buffer_b;
+
+	atomic_dec(&cpu_buffer_a->record_disabled);
+	atomic_dec(&cpu_buffer_b->record_disabled);
+
+	return 0;
+}
+
Index: linux-trace.git/kernel/trace/Kconfig
===================================================================
--- linux-trace.git.orig/kernel/trace/Kconfig	2008-09-25 18:26:10.000000000 -0400
+++ linux-trace.git/kernel/trace/Kconfig	2008-09-25 18:30:51.000000000 -0400
@@ -10,10 +10,14 @@ config HAVE_DYNAMIC_FTRACE
 config TRACER_MAX_TRACE
 	bool
 
+config RING_BUFFER
+	bool
+
 config TRACING
 	bool
 	select DEBUG_FS
 	select STACKTRACE
+	select RING_BUFFER
 
 config FTRACE
 	bool "Kernel Function Tracer"
Index: linux-trace.git/kernel/trace/Makefile
===================================================================
--- linux-trace.git.orig/kernel/trace/Makefile	2008-09-25 18:26:10.000000000 -0400
+++ linux-trace.git/kernel/trace/Makefile	2008-09-25 18:29:07.000000000 -0400
@@ -11,6 +11,7 @@ obj-y += trace_selftest_dynamic.o
 endif
 
 obj-$(CONFIG_FTRACE) += libftrace.o
+obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o


