Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZDXEdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZDXEdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbZDXEbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:31:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44230 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbZDXEbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:31:18 -0400
Message-Id: <20090424043116.042509976@goodmis.org>
References: <20090424043005.338878133@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 24 Apr 2009 00:30:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/6] ring_buffer: compressed event header
Content-Disposition: inline; filename=0006-ring_buffer-compressed-event-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

RB_MAX_SMALL_DATA = 28bytes is too small for most tracers, it wastes
an 'u32' to save the actually length for events which data size > 28.

This fix uses compressed event header and enlarges RB_MAX_SMALL_DATA.

[ Impact: saves about 0%-12.5%(depends on tracer) memory in ring_buffer ]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <49F13189.3090000@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |   16 +++++----
 kernel/trace/ring_buffer.c  |   83 +++++++++++++++++++++----------------------
 2 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index fac8f1a..1c2f809 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -11,7 +11,7 @@ struct ring_buffer_iter;
  * Don't refer to this struct directly, use functions below.
  */
 struct ring_buffer_event {
-	u32		type:2, len:3, time_delta:27;
+	u32		type_len:5, time_delta:27;
 	u32		array[];
 };
 
@@ -24,7 +24,8 @@ struct ring_buffer_event {
  *				  size is variable depending on how much
  *				  padding is needed
  *				 If time_delta is non zero:
- *				  everything else same as RINGBUF_TYPE_DATA
+ *				  array[0] holds the actual length
+ *				  size = 4 + length (bytes)
  *
  * @RINGBUF_TYPE_TIME_EXTEND:	Extend the time delta
  *				 array[0] = time delta (28 .. 59)
@@ -35,22 +36,23 @@ struct ring_buffer_event {
  *				 array[1..2] = tv_sec
  *				 size = 16 bytes
  *
- * @RINGBUF_TYPE_DATA:		Data record
- *				 If len is zero:
+ * <= @RINGBUF_TYPE_DATA_TYPE_LEN_MAX:
+ *				Data record
+ *				 If type_len is zero:
  *				  array[0] holds the actual length
  *				  array[1..(length+3)/4] holds data
- *				  size = 4 + 4 + length (bytes)
+ *				  size = 4 + length (bytes)
  *				 else
- *				  length = len << 2
+ *				  length = type_len << 2
  *				  array[0..(length+3)/4-1] holds data
  *				  size = 4 + length (bytes)
  */
 enum ring_buffer_type {
+	RINGBUF_TYPE_DATA_TYPE_LEN_MAX = 28,
 	RINGBUF_TYPE_PADDING,
 	RINGBUF_TYPE_TIME_EXTEND,
 	/* FIXME: RINGBUF_TYPE_TIME_STAMP not implemented */
 	RINGBUF_TYPE_TIME_STAMP,
-	RINGBUF_TYPE_DATA,
 };
 
 unsigned ring_buffer_event_length(struct ring_buffer_event *event);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 61dbdf2..9692f10 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -28,8 +28,8 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
 {
 	int ret;
 
-	ret = trace_seq_printf(s, "\ttype        :    2 bits\n");
-	ret = trace_seq_printf(s, "\tlen         :    3 bits\n");
+	ret = trace_seq_printf(s, "# compressed entry header\n");
+	ret = trace_seq_printf(s, "\ttype_len    :    5 bits\n");
 	ret = trace_seq_printf(s, "\ttime_delta  :   27 bits\n");
 	ret = trace_seq_printf(s, "\tarray       :   32 bits\n");
 	ret = trace_seq_printf(s, "\n");
@@ -37,8 +37,8 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
 			       RINGBUF_TYPE_PADDING);
 	ret = trace_seq_printf(s, "\ttime_extend : type == %d\n",
 			       RINGBUF_TYPE_TIME_EXTEND);
-	ret = trace_seq_printf(s, "\tdata        : type == %d\n",
-			       RINGBUF_TYPE_DATA);
+	ret = trace_seq_printf(s, "\tdata max type_len  == %d\n",
+			       RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
 
 	return ret;
 }
@@ -204,7 +204,10 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
-#define RB_MAX_SMALL_DATA	28
+#define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
+
+/* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
+#define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 
 enum {
 	RB_LEN_TIME_EXTEND = 8,
@@ -213,17 +216,18 @@ enum {
 
 static inline int rb_null_event(struct ring_buffer_event *event)
 {
-	return event->type == RINGBUF_TYPE_PADDING && event->time_delta == 0;
+	return event->type_len == RINGBUF_TYPE_PADDING
+			&& event->time_delta == 0;
 }
 
 static inline int rb_discarded_event(struct ring_buffer_event *event)
 {
-	return event->type == RINGBUF_TYPE_PADDING && event->time_delta;
+	return event->type_len == RINGBUF_TYPE_PADDING && event->time_delta;
 }
 
 static void rb_event_set_padding(struct ring_buffer_event *event)
 {
-	event->type = RINGBUF_TYPE_PADDING;
+	event->type_len = RINGBUF_TYPE_PADDING;
 	event->time_delta = 0;
 }
 
@@ -232,8 +236,8 @@ rb_event_data_length(struct ring_buffer_event *event)
 {
 	unsigned length;
 
-	if (event->len)
-		length = event->len * RB_ALIGNMENT;
+	if (event->type_len)
+		length = event->type_len * RB_ALIGNMENT;
 	else
 		length = event->array[0];
 	return length + RB_EVNT_HDR_SIZE;
@@ -243,12 +247,12 @@ rb_event_data_length(struct ring_buffer_event *event)
 static unsigned
 rb_event_length(struct ring_buffer_event *event)
 {
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (rb_null_event(event))
 			/* undefined */
 			return -1;
-		return rb_event_data_length(event);
+		return  event->array[0] + RB_EVNT_HDR_SIZE;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
 		return RB_LEN_TIME_EXTEND;
@@ -272,7 +276,7 @@ rb_event_length(struct ring_buffer_event *event)
 unsigned ring_buffer_event_length(struct ring_buffer_event *event)
 {
 	unsigned length = rb_event_length(event);
-	if (event->type != RINGBUF_TYPE_DATA)
+	if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 		return length;
 	length -= RB_EVNT_HDR_SIZE;
 	if (length > RB_MAX_SMALL_DATA + sizeof(event->array[0]))
@@ -285,9 +289,9 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_length);
 static void *
 rb_event_data(struct ring_buffer_event *event)
 {
-	BUG_ON(event->type != RINGBUF_TYPE_DATA);
+	BUG_ON(event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
 	/* If length is in len field, then array[0] has the data */
-	if (event->len)
+	if (event->type_len)
 		return (void *)&event->array[0];
 	/* Otherwise length is in array[0] and array[1] has the data */
 	return (void *)&event->array[1];
@@ -988,7 +992,7 @@ static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
 		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
 			return;
 		/* Only count data entries */
-		if (event->type != RINGBUF_TYPE_DATA)
+		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 			continue;
 		cpu_buffer->overrun++;
 		cpu_buffer->entries--;
@@ -1133,28 +1137,21 @@ static void
 rb_update_event(struct ring_buffer_event *event,
 			 unsigned type, unsigned length)
 {
-	event->type = type;
+	event->type_len = type;
 
 	switch (type) {
 
 	case RINGBUF_TYPE_PADDING:
-		break;
-
 	case RINGBUF_TYPE_TIME_EXTEND:
-		event->len = DIV_ROUND_UP(RB_LEN_TIME_EXTEND, RB_ALIGNMENT);
-		break;
-
 	case RINGBUF_TYPE_TIME_STAMP:
-		event->len = DIV_ROUND_UP(RB_LEN_TIME_STAMP, RB_ALIGNMENT);
 		break;
 
-	case RINGBUF_TYPE_DATA:
+	case 0:
 		length -= RB_EVNT_HDR_SIZE;
-		if (length > RB_MAX_SMALL_DATA) {
-			event->len = 0;
+		if (length > RB_MAX_SMALL_DATA)
 			event->array[0] = length;
-		} else
-			event->len = DIV_ROUND_UP(length, RB_ALIGNMENT);
+		else
+			event->type_len = DIV_ROUND_UP(length, RB_ALIGNMENT);
 		break;
 	default:
 		BUG();
@@ -1562,7 +1559,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (length > BUF_PAGE_SIZE)
 		goto out;
 
-	event = rb_reserve_next_event(cpu_buffer, RINGBUF_TYPE_DATA, length);
+	event = rb_reserve_next_event(cpu_buffer, 0, length);
 	if (!event)
 		goto out;
 
@@ -1634,7 +1631,9 @@ EXPORT_SYMBOL_GPL(ring_buffer_unlock_commit);
 
 static inline void rb_event_discard(struct ring_buffer_event *event)
 {
-	event->type = RINGBUF_TYPE_PADDING;
+	/* array[0] holds the actual length for the discarded event */
+	event->array[0] = rb_event_data_length(event) - RB_EVNT_HDR_SIZE;
+	event->type_len = RINGBUF_TYPE_PADDING;
 	/* time delta must be non zero */
 	if (!event->time_delta)
 		event->time_delta = 1;
@@ -1786,8 +1785,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 		goto out;
 
 	event_length = rb_calculate_event_length(length);
-	event = rb_reserve_next_event(cpu_buffer,
-				      RINGBUF_TYPE_DATA, event_length);
+	event = rb_reserve_next_event(cpu_buffer, 0, event_length);
 	if (!event)
 		goto out;
 
@@ -2035,7 +2033,7 @@ rb_update_read_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	u64 delta;
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		return;
 
@@ -2066,7 +2064,7 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 {
 	u64 delta;
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		return;
 
@@ -2181,7 +2179,8 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	event = rb_reader_event(cpu_buffer);
 
-	if (event->type == RINGBUF_TYPE_DATA || rb_discarded_event(event))
+	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX
+			|| rb_discarded_event(event))
 		cpu_buffer->entries--;
 
 	rb_update_read_stamp(cpu_buffer, event);
@@ -2262,7 +2261,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	event = rb_reader_event(cpu_buffer);
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (rb_null_event(event))
 			RB_WARN_ON(cpu_buffer, 1);
@@ -2334,7 +2333,7 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
 	event = rb_iter_head_event(iter);
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (rb_null_event(event)) {
 			rb_inc_iter(iter);
@@ -2393,7 +2392,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	event = rb_buffer_peek(buffer, cpu, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2421,7 +2420,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	event = rb_iter_peek(iter, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2466,7 +2465,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
  out:
 	preempt_enable();
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2559,7 +2558,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2766,7 +2765,7 @@ static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
 		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
 			return;
 		/* Only count data entries */
-		if (event->type != RINGBUF_TYPE_DATA)
+		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 			continue;
 		cpu_buffer->entries--;
 	}
-- 
1.6.2.1

-- 
