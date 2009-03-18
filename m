Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZCRCVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZCRCVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZCRCVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:21:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZCRCVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:21:44 -0400
Date: Tue, 17 Mar 2009 22:21:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 2/4] tracing: add rb_event_discard() hack
In-Reply-To: <alpine.DEB.2.00.0903172108160.10610@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903172220580.10610@gandalf.stny.rr.com>
References: <1237271018.8033.150.camel@charm-linux> <alpine.DEB.2.00.0903172108160.10610@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tom,

Here's an updated patch, could you see if this works for you?

Thanks,

-- Steve


>From tzanussi@gmail.com Tue Mar 17 02:30:09 2009
Date: Tue, 17 Mar 2009 01:23:38 -0500
From: Tom Zanussi <tzanussi@gmail.com>
Subject: [RFC][PATCH 2/4] tracing: add rb_event_discard() hack

This patch overloads RINGBUF_TYPE_PADDING to provide a way to discard
events from the ring buffer, for the event-filtering mechanism
introduced in a subsequent patch.

NOTE: this patch is a true hack and will likely either eventually crash
your machine or result in an endless loop of printed events.  But it
sometimes works, enough to show that the filtering apparently does what
it should.

I'm posting it only to solicit comments from any ringbuffer gurus who
might know know how to do it correctly, or more likely could suggest a
better approach.

[
 Modifications to fix timestamps and handle ring buffer peeking.
   - Steven Rostedt
]

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 include/linux/ring_buffer.h |   11 +++-
 kernel/trace/ring_buffer.c  |  117 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 105 insertions(+), 23 deletions(-)

Index: linux-trace.git/include/linux/ring_buffer.h
===================================================================
--- linux-trace.git.orig/include/linux/ring_buffer.h	2009-03-17 13:38:41.000000000 -0400
+++ linux-trace.git/include/linux/ring_buffer.h	2009-03-17 21:44:36.000000000 -0400
@@ -18,10 +18,13 @@ struct ring_buffer_event {
 /**
  * enum ring_buffer_type - internal ring buffer types
  *
- * @RINGBUF_TYPE_PADDING:	Left over page padding
- *				 array is ignored
- *				 size is variable depending on how much
+ * @RINGBUF_TYPE_PADDING:	Left over page padding or discarded event
+ *				 If time_delta is 0:
+ *				  array is ignored
+ *				  size is variable depending on how much
  *				  padding is needed
+ *				 If time_delta is non zero:
+ *				  everything else same as RINGBUF_TYPE_DATA
  *
  * @RINGBUF_TYPE_TIME_EXTEND:	Extend the time delta
  *				 array[0] = time delta (28 .. 59)
@@ -65,6 +68,8 @@ ring_buffer_event_time_delta(struct ring
 	return event->time_delta;
 }
 
+void ring_buffer_event_discard(struct ring_buffer_event *event);
+
 /*
  * size is in bytes for each per CPU buffer.
  */
Index: linux-trace.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-trace.git.orig/kernel/trace/ring_buffer.c	2009-03-17 13:49:03.000000000 -0400
+++ linux-trace.git/kernel/trace/ring_buffer.c	2009-03-17 22:10:23.000000000 -0400
@@ -189,16 +189,65 @@ enum {
 	RB_LEN_TIME_STAMP = 16,
 };
 
-/* inline for ring buffer fast paths */
+static inline int rb_null_event(struct ring_buffer_event *event)
+{
+	return event->type == RINGBUF_TYPE_PADDING && event->time_delta == 0;
+}
+
+static inline int rb_discarded_event(struct ring_buffer_event *event)
+{
+	return event->type == RINGBUF_TYPE_PADDING && event->time_delta;
+}
+
+static void rb_event_set_padding(struct ring_buffer_event *event)
+{
+	event->type = RINGBUF_TYPE_PADDING;
+	event->time_delta = 0;
+}
+
+/**
+ * ring_buffer_event_discard - discard an event in the ring buffer
+ * @buffer: the ring buffer
+ * @event: the event to discard
+ *
+ * Sometimes a event that is in the ring buffer needs to be ignored.
+ * This function lets the user discard an event in the ring buffer
+ * and then that event will not be read later.
+ *
+ * Note, it is up to the user to be careful with this, and protect
+ * against races. If the user discards an event that has been consumed
+ * it is possible that it could corrupt the ring buffer.
+ */
+void ring_buffer_event_discard(struct ring_buffer_event *event)
+{
+	event->type = RINGBUF_TYPE_PADDING;
+	/* time delta must be non zero */
+	if (!event->time_delta)
+		event->time_delta = 1;
+}
+
 static unsigned
-rb_event_length(struct ring_buffer_event *event)
+rb_event_data_length(struct ring_buffer_event *event)
 {
 	unsigned length;
 
+	if (event->len)
+		length = event->len * RB_ALIGNMENT;
+	else
+		length = event->array[0];
+	return length + RB_EVNT_HDR_SIZE;
+}
+
+/* inline for ring buffer fast paths */
+static unsigned
+rb_event_length(struct ring_buffer_event *event)
+{
 	switch (event->type) {
 	case RINGBUF_TYPE_PADDING:
-		/* undefined */
-		return -1;
+		if (rb_null_event(event))
+			/* undefined */
+			return -1;
+		return rb_event_data_length(event);
 
 	case RINGBUF_TYPE_TIME_EXTEND:
 		return RB_LEN_TIME_EXTEND;
@@ -207,11 +256,7 @@ rb_event_length(struct ring_buffer_event
 		return RB_LEN_TIME_STAMP;
 
 	case RINGBUF_TYPE_DATA:
-		if (event->len)
-			length = event->len * RB_ALIGNMENT;
-		else
-			length = event->array[0];
-		return length + RB_EVNT_HDR_SIZE;
+		return rb_event_data_length(event);
 	default:
 		BUG();
 	}
@@ -836,11 +881,6 @@ int ring_buffer_resize(struct ring_buffe
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
 
-static inline int rb_null_event(struct ring_buffer_event *event)
-{
-	return event->type == RINGBUF_TYPE_PADDING;
-}
-
 static inline void *
 __rb_data_page_index(struct buffer_data_page *bpage, unsigned index)
 {
@@ -1210,7 +1250,7 @@ __rb_reserve_next(struct ring_buffer_per
 		if (tail < BUF_PAGE_SIZE) {
 			/* Mark the rest of the page with padding */
 			event = __rb_page_index(tail_page, tail);
-			event->type = RINGBUF_TYPE_PADDING;
+			rb_event_set_padding(event);
 		}
 
 		if (tail <= BUF_PAGE_SIZE)
@@ -1960,7 +2000,7 @@ static void rb_advance_reader(struct rin
 
 	event = rb_reader_event(cpu_buffer);
 
-	if (event->type == RINGBUF_TYPE_DATA)
+	if (event->type == RINGBUF_TYPE_DATA || rb_discarded_event(event))
 		cpu_buffer->entries--;
 
 	rb_update_read_stamp(cpu_buffer, event);
@@ -2043,9 +2083,18 @@ rb_buffer_peek(struct ring_buffer *buffe
 
 	switch (event->type) {
 	case RINGBUF_TYPE_PADDING:
-		RB_WARN_ON(cpu_buffer, 1);
+		if (rb_null_event(event))
+			RB_WARN_ON(cpu_buffer, 1);
+		/*
+		 * Because the writer could be discarding every
+		 * event it creates (which would probably be bad)
+		 * if we were to go back to "again" then we may never
+		 * catch up, and will trigger the warn on, or lock
+		 * the box. Return the padding, and we will release
+		 * the current locks, and try again.
+		 */
 		rb_advance_reader(cpu_buffer);
-		return NULL;
+		return event;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
 		/* Internal data, OK to advance */
@@ -2106,8 +2155,12 @@ rb_iter_peek(struct ring_buffer_iter *it
 
 	switch (event->type) {
 	case RINGBUF_TYPE_PADDING:
-		rb_inc_iter(iter);
-		goto again;
+		if (rb_null_event(event)) {
+			rb_inc_iter(iter);
+			goto again;
+		}
+		rb_advance_iter(iter);
+		return event;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
 		/* Internal data, OK to advance */
@@ -2154,10 +2207,16 @@ ring_buffer_peek(struct ring_buffer *buf
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
+ again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_buffer_peek(buffer, cpu, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
+	if (event && event->type == RINGBUF_TYPE_PADDING) {
+		cpu_relax();
+		goto again;
+	}
+
 	return event;
 }
 
@@ -2176,10 +2235,16 @@ ring_buffer_iter_peek(struct ring_buffer
 	struct ring_buffer_event *event;
 	unsigned long flags;
 
+ again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_iter_peek(iter, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
+	if (event && event->type == RINGBUF_TYPE_PADDING) {
+		cpu_relax();
+		goto again;
+	}
+
 	return event;
 }
 
@@ -2198,6 +2263,7 @@ ring_buffer_consume(struct ring_buffer *
 	struct ring_buffer_event *event = NULL;
 	unsigned long flags;
 
+ again:
 	/* might be called in atomic */
 	preempt_disable();
 
@@ -2219,6 +2285,11 @@ ring_buffer_consume(struct ring_buffer *
  out:
 	preempt_enable();
 
+	if (event && event->type == RINGBUF_TYPE_PADDING) {
+		cpu_relax();
+		goto again;
+	}
+
 	return event;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_consume);
@@ -2297,6 +2368,7 @@ ring_buffer_read(struct ring_buffer_iter
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
 
+ again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_iter_peek(iter, ts);
 	if (!event)
@@ -2306,6 +2378,11 @@ ring_buffer_read(struct ring_buffer_iter
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
+	if (event && event->type == RINGBUF_TYPE_PADDING) {
+		cpu_relax();
+		goto again;
+	}
+
 	return event;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read);


