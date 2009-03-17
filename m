Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbZCQGYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbZCQGYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762768AbZCQGXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:23:44 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:52357 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762771AbZCQGXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=G0eCprDI+Gtf9cDRLDR71/1GszN8R1M2g9P769cK9DMp6fEr8uh05S78sXvkmu65nC
         WTuokjg2vMQ/sYLzmFpWCmb3L+Mlm674IKV0u2fp0YqAkxR7TBtURTKK0tjyIKK2gBqq
         D0XnvqmXhOWmhPOwP2qNUk7s3zYcvJX5VbRvc=
Subject: [RFC][PATCH 2/4] tracing: add rb_event_discard() hack
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 01:23:38 -0500
Message-Id: <1237271018.8033.150.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 include/linux/ring_buffer.h |    9 ++++-
 kernel/trace/ring_buffer.c  |   73 ++++++++++++++++++++++++++++++-------------
 2 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index b237e20..4292774 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -22,10 +22,13 @@ struct ring_buffer_event {
 /**
  * enum ring_buffer_type - internal ring buffer types
  *
- * @RINGBUF_TYPE_PADDING:	Left over page padding
+ * @RINGBUF_TYPE_PADDING:	Left over page padding or discarded event
  *				 array is ignored
- *				 size is variable depending on how much
+ *				 If time_delta is 0:
+ *				  size is variable depending on how much
  *				  padding is needed
+ *				 If time_delta is 1:
+ *				  everything else same as RINGBUF_TYPE_DATA
  *
  * @RINGBUF_TYPE_TIME_EXTEND:	Extend the time delta
  *				 array[0] = time delta (28 .. 59)
@@ -69,6 +72,8 @@ ring_buffer_event_time_delta(struct ring_buffer_event *event)
 	return event->time_delta;
 }
 
+void rb_event_discard(struct ring_buffer_event *event);
+
 /*
  * size is in bytes for each per CPU buffer.
  */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d3b07d..c59e910 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -213,16 +213,50 @@ enum {
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
+	return event->type == RINGBUF_TYPE_PADDING && event->time_delta == 1;
+}
+
+static void rb_event_set_padding(struct ring_buffer_event *event)
+{
+	event->type = RINGBUF_TYPE_PADDING;
+	event->time_delta = 0;
+}
+
+void rb_event_discard(struct ring_buffer_event *event)
+{
+	event->type = RINGBUF_TYPE_PADDING;
+	event->time_delta = 1;
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
@@ -231,11 +265,7 @@ rb_event_length(struct ring_buffer_event *event)
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
@@ -828,11 +858,6 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
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
@@ -1203,7 +1228,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 			/* Mark the rest of the page with padding */
 			event = __rb_page_index(tail_page, tail);
 			kmemcheck_annotate_bitfield(event->bitfield);
-			event->type = RINGBUF_TYPE_PADDING;
+			rb_event_set_padding(event);
 		}
 
 		if (tail <= BUF_PAGE_SIZE)
@@ -1954,7 +1979,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	event = rb_reader_event(cpu_buffer);
 
-	if (event->type == RINGBUF_TYPE_DATA)
+	if (event->type == RINGBUF_TYPE_DATA || rb_discarded_event(event))
 		cpu_buffer->entries--;
 
 	rb_update_read_stamp(cpu_buffer, event);
@@ -2026,8 +2051,8 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	 * can have.  Nesting 10 deep of interrupts is clearly
 	 * an anomaly.
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
-		return NULL;
+//	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
+//		return NULL;
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
@@ -2037,7 +2062,8 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	switch (event->type) {
 	case RINGBUF_TYPE_PADDING:
-		RB_WARN_ON(cpu_buffer, 1);
+		if (rb_null_event(event))
+			RB_WARN_ON(cpu_buffer, 1);
 		rb_advance_reader(cpu_buffer);
 		return NULL;
 
@@ -2089,8 +2115,8 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	 * can have. Nesting 10 deep of interrupts is clearly
 	 * an anomaly.
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
-		return NULL;
+//	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
+//		return NULL;
 
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
@@ -2099,7 +2125,10 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
 	switch (event->type) {
 	case RINGBUF_TYPE_PADDING:
-		rb_inc_iter(iter);
+		if (rb_null_event(event))
+			rb_inc_iter(iter);
+		else
+			rb_advance_iter(iter);
 		goto again;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
-- 
1.5.6.3



