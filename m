Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZCVIb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZCVIb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 04:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZCVIa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 04:30:56 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:45572 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZCVIay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 04:30:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ZurLp59dauLYDgk33iA8MzC6UwEkfYq0rBZPATjvhVuxS2Xju0m4VQtsMX/HG9Z93P
         5/rOePt7vPrms1Z8WtoAgug+9Sl1Um4jpAGbrxNE41FOjH5fzTxNUhRV8Pz3BoxirFO5
         22kCdp1ZOFL1m8IngSatgo/8AzhSamjvkE2+s=
Subject: [PATCH 2/4] tracing: add ring_buffer_event_discard() to ring buffer
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 03:30:49 -0500
Message-Id: <1237710649.7703.47.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch overloads RINGBUF_TYPE_PADDING to provide a way to discard
events from the ring buffer, for the event-filtering mechanism
introduced in a subsequent patch.

I did the initial version but thanks to Steven Rostedt for adding the
parts that actually made it work. ;-)

---
 include/linux/ring_buffer.h |   11 +++-
 kernel/trace/ring_buffer.c  |  117 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 105 insertions(+), 23 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e20b886..ae5b210 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -22,10 +22,13 @@ struct ring_buffer_event {
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
@@ -69,6 +72,8 @@ ring_buffer_event_time_delta(struct ring_buffer_event *event)
 	return event->time_delta;
 }
 
+void ring_buffer_event_discard(struct ring_buffer_event *event);
+
 /*
  * size is in bytes for each per CPU buffer.
  */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7e05e2c..5cd2342 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -190,16 +190,65 @@ enum {
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
@@ -208,11 +257,7 @@ rb_event_length(struct ring_buffer_event *event)
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
@@ -846,11 +891,6 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
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
@@ -1221,7 +1261,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 			/* Mark the rest of the page with padding */
 			event = __rb_page_index(tail_page, tail);
 			kmemcheck_annotate_bitfield(event->bitfield);
-			event->type = RINGBUF_TYPE_PADDING;
+			rb_event_set_padding(event);
 		}
 
 		if (tail <= BUF_PAGE_SIZE)
@@ -1972,7 +2012,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	event = rb_reader_event(cpu_buffer);
 
-	if (event->type == RINGBUF_TYPE_DATA)
+	if (event->type == RINGBUF_TYPE_DATA || rb_discarded_event(event))
 		cpu_buffer->entries--;
 
 	rb_update_read_stamp(cpu_buffer, event);
@@ -2055,9 +2095,18 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 
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
@@ -2118,8 +2167,12 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
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
@@ -2166,10 +2219,16 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
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
 
@@ -2188,10 +2247,16 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
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
 
@@ -2210,6 +2275,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct ring_buffer_event *event = NULL;
 	unsigned long flags;
 
+ again:
 	/* might be called in atomic */
 	preempt_disable();
 
@@ -2231,6 +2297,11 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
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
@@ -2309,6 +2380,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
 
+ again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_iter_peek(iter, ts);
 	if (!event)
@@ -2318,6 +2390,11 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
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
-- 
1.5.6.3



