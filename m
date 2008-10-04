Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbYJDGCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbYJDGCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 02:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYJDGCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 02:02:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYJDGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 02:02:13 -0400
Message-Id: <20081004060211.528071315@goodmis.org>
References: <20081004060057.660306328@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 04 Oct 2008 02:00:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ring-buffer: move page indexes into page headers
Content-Disposition: inline; filename=ring-buffer-move-index-in-page-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global head and tail indexes and move them into the
page header. Each page will now keep track of where the last
write and read was made. We also rename the head and tail to read
and write for better clarification.

This patch is needed for future enhancements to move the ring buffer
to a lockless solution.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   75 ++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 34 deletions(-)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-04 01:14:30.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-04 01:18:17.000000000 -0400
@@ -117,6 +117,8 @@ void *ring_buffer_event_data(struct ring
 struct buffer_page {
 	u64		 time_stamp;	/* page time stamp */
 	unsigned	 size;		/* size of page data */
+	unsigned	 write;		/* index for next write */
+	unsigned	 read;		/* index for next read */
 	struct list_head list;		/* list of free pages */
 	void *page;			/* Actual data page */
 };
@@ -153,11 +155,8 @@ struct ring_buffer_per_cpu {
 	spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		pages;
-	unsigned long			head;	/* read from head */
-	unsigned long			tail;	/* write to tail */
-	unsigned long			reader;
-	struct buffer_page		*head_page;
-	struct buffer_page		*tail_page;
+	struct buffer_page		*head_page;	/* read from head */
+	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*reader_page;
 	unsigned long			overrun;
 	unsigned long			entries;
@@ -566,10 +565,11 @@ int ring_buffer_resize(struct ring_buffe
 
 static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	return (cpu_buffer->reader == cpu_buffer->reader_page->size &&
+	return cpu_buffer->reader_page->read == cpu_buffer->reader_page->size &&
 		(cpu_buffer->tail_page == cpu_buffer->reader_page ||
 		 (cpu_buffer->tail_page == cpu_buffer->head_page &&
-		  cpu_buffer->head == cpu_buffer->tail)));
+		  cpu_buffer->head_page->read ==
+		  cpu_buffer->tail_page->write));
 }
 
 static inline int rb_null_event(struct ring_buffer_event *event)
@@ -577,7 +577,7 @@ static inline int rb_null_event(struct r
 	return event->type == RINGBUF_TYPE_PADDING;
 }
 
-static inline void *rb_page_index(struct buffer_page *page, unsigned index)
+static inline void *__rb_page_index(struct buffer_page *page, unsigned index)
 {
 	return page->page + index;
 }
@@ -585,15 +585,21 @@ static inline void *rb_page_index(struct
 static inline struct ring_buffer_event *
 rb_reader_event(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	return rb_page_index(cpu_buffer->reader_page,
-			     cpu_buffer->reader);
+	return __rb_page_index(cpu_buffer->reader_page,
+			       cpu_buffer->reader_page->read);
+}
+
+static inline struct ring_buffer_event *
+rb_head_event(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return __rb_page_index(cpu_buffer->head_page,
+			       cpu_buffer->head_page->read);
 }
 
 static inline struct ring_buffer_event *
 rb_iter_head_event(struct ring_buffer_iter *iter)
 {
-	return rb_page_index(iter->head_page,
-			     iter->head);
+	return __rb_page_index(iter->head_page, iter->head);
 }
 
 /*
@@ -610,7 +616,7 @@ static void rb_update_overflow(struct ri
 	for (head = 0; head < rb_head_size(cpu_buffer);
 	     head += rb_event_length(event)) {
 
-		event = rb_page_index(cpu_buffer->head_page, head);
+		event = __rb_page_index(cpu_buffer->head_page, head);
 		BUG_ON(rb_null_event(event));
 		/* Only count data entries */
 		if (event->type != RINGBUF_TYPE_DATA)
@@ -640,13 +646,13 @@ rb_add_stamp(struct ring_buffer_per_cpu 
 
 static void rb_reset_head_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	cpu_buffer->head = 0;
+	cpu_buffer->head_page->read = 0;
 }
 
 static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	cpu_buffer->read_stamp = cpu_buffer->reader_page->time_stamp;
-	cpu_buffer->reader = 0;
+	cpu_buffer->reader_page->read = 0;
 }
 
 static inline void rb_inc_iter(struct ring_buffer_iter *iter)
@@ -743,9 +749,8 @@ __rb_reserve_next(struct ring_buffer_per
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_event *event;
 
-	/* No locking needed for tail page */
 	tail_page = cpu_buffer->tail_page;
-	tail = cpu_buffer->tail;
+	tail = cpu_buffer->tail_page->write;
 
 	if (tail + length > BUF_PAGE_SIZE) {
 		struct buffer_page *next_page = tail_page;
@@ -774,7 +779,7 @@ __rb_reserve_next(struct ring_buffer_per
 		}
 
 		if (tail != BUF_PAGE_SIZE) {
-			event = rb_page_index(tail_page, tail);
+			event = __rb_page_index(tail_page, tail);
 			/* page padding */
 			event->type = RINGBUF_TYPE_PADDING;
 		}
@@ -784,14 +789,14 @@ __rb_reserve_next(struct ring_buffer_per
 		tail_page->size = 0;
 		tail = 0;
 		cpu_buffer->tail_page = tail_page;
-		cpu_buffer->tail = tail;
+		cpu_buffer->tail_page->write = tail;
 		rb_add_stamp(cpu_buffer, ts);
 		spin_unlock(&cpu_buffer->lock);
 	}
 
 	BUG_ON(tail + length > BUF_PAGE_SIZE);
 
-	event = rb_page_index(tail_page, tail);
+	event = __rb_page_index(tail_page, tail);
 	rb_update_event(event, type, length);
 
 	return event;
@@ -823,12 +828,12 @@ rb_add_time_stamp(struct ring_buffer_per
 		return -1;
 
 	/* check to see if we went to the next page */
-	if (cpu_buffer->tail) {
+	if (cpu_buffer->tail_page->write) {
 		/* Still on same page, update timestamp */
 		event->time_delta = *delta & TS_MASK;
 		event->array[0] = *delta >> TS_SHIFT;
 		/* commit the time event */
-		cpu_buffer->tail +=
+		cpu_buffer->tail_page->write +=
 			rb_event_length(event);
 		cpu_buffer->write_stamp = *ts;
 		*delta = 0;
@@ -846,7 +851,7 @@ rb_reserve_next_event(struct ring_buffer
 
 	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
 
-	if (cpu_buffer->tail) {
+	if (cpu_buffer->tail_page->write) {
 		delta = ts - cpu_buffer->write_stamp;
 
 		if (test_time_stamp(delta)) {
@@ -868,7 +873,7 @@ rb_reserve_next_event(struct ring_buffer
 		return NULL;
 
 	/* If the reserve went to the next page, our delta is zero */
-	if (!cpu_buffer->tail)
+	if (!cpu_buffer->tail_page->write)
 		delta = 0;
 
 	event->time_delta = delta;
@@ -933,8 +938,8 @@ ring_buffer_lock_reserve(struct ring_buf
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
-	cpu_buffer->tail += rb_event_length(event);
-	cpu_buffer->tail_page->size = cpu_buffer->tail;
+	cpu_buffer->tail_page->write += rb_event_length(event);
+	cpu_buffer->tail_page->size = cpu_buffer->tail_page->write;
 	cpu_buffer->write_stamp += event->time_delta;
 	cpu_buffer->entries++;
 }
@@ -1178,10 +1183,10 @@ void ring_buffer_iter_reset(struct ring_
 	/* Iterator usage is expected to have record disabled */
 	if (list_empty(&cpu_buffer->reader_page->list)) {
 		iter->head_page = cpu_buffer->head_page;
-		iter->head = cpu_buffer->head;
+		iter->head = cpu_buffer->head_page->read;
 	} else {
 		iter->head_page = cpu_buffer->reader_page;
-		iter->head = cpu_buffer->reader;
+		iter->head = cpu_buffer->reader_page->read;
 	}
 	if (iter->head)
 		iter->read_stamp = cpu_buffer->read_stamp;
@@ -1200,7 +1205,7 @@ int ring_buffer_iter_empty(struct ring_b
 	cpu_buffer = iter->cpu_buffer;
 
 	return iter->head_page == cpu_buffer->tail_page &&
-		iter->head == cpu_buffer->tail;
+		iter->head == cpu_buffer->tail_page->write;
 }
 
 static void
@@ -1277,11 +1282,11 @@ rb_get_reader_page(struct ring_buffer_pe
 	reader = cpu_buffer->reader_page;
 
 	/* If there's more to read, return this page */
-	if (cpu_buffer->reader < reader->size)
+	if (cpu_buffer->reader_page->read < reader->size)
 		goto out;
 
 	/* Never should we have an index greater than the size */
-	WARN_ON(cpu_buffer->reader > reader->size);
+	WARN_ON(cpu_buffer->reader_page->read > reader->size);
 
 	/* check if we caught up to the tail */
 	reader = NULL;
@@ -1342,7 +1347,7 @@ static void rb_advance_reader(struct rin
 	rb_update_read_stamp(cpu_buffer, event);
 
 	length = rb_event_length(event);
-	cpu_buffer->reader += length;
+	cpu_buffer->reader_page->read += length;
 }
 
 static void rb_advance_iter(struct ring_buffer_iter *iter)
@@ -1373,7 +1378,7 @@ static void rb_advance_iter(struct ring_
 	 * at the tail of the buffer.
 	 */
 	BUG_ON((iter->head_page == cpu_buffer->tail_page) &&
-	       (iter->head + length > cpu_buffer->tail));
+	       (iter->head + length > cpu_buffer->tail_page->write));
 
 	rb_update_iter_read_stamp(iter, event);
 
@@ -1623,7 +1628,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 	cpu_buffer->reader_page->size = 0;
 
-	cpu_buffer->head = cpu_buffer->tail = cpu_buffer->reader = 0;
+	cpu_buffer->head_page->read = 0;
+	cpu_buffer->tail_page->write = 0;
+	cpu_buffer->reader_page->read = 0;
 
 	cpu_buffer->overrun = 0;
 	cpu_buffer->entries = 0;

-- 
