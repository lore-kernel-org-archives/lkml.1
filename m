Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZDXD26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZDXD26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 23:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZDXD2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 23:28:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZDXD2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 23:28:49 -0400
Message-ID: <49F13189.3090000@cn.fujitsu.com>
Date: Fri, 24 Apr 2009 11:27:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring_buffer: compressed event header
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



RB_MAX_SMALL_DATA = 28bytes is too small for most tracers, it wastes
an 'u32' to save the actually length for events which data size > 28.

This fix uses compressed event header and enlarges RB_MAX_SMALL_DATA.

Impact: saves about 0%-12.5%(depends on tracer) memory in ring_buffer

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index a6196b5..d936eb9 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -13,7 +13,7 @@ struct ring_buffer_iter;
  */
 struct ring_buffer_event {
 	kmemcheck_define_bitfield(bitfield, {
-		u32		type:2, len:3, time_delta:27;
+		u32		type_len:5, time_delta:27;
 	});
 
 	u32		array[];
@@ -28,7 +28,8 @@ struct ring_buffer_event {
  *				  size is variable depending on how much
  *				  padding is needed
  *				 If time_delta is non zero:
- *				  everything else same as RINGBUF_TYPE_DATA
+ *				  array[0] holds the actual length
+ *				  size = 4 + length (bytes)
  *
  * @RINGBUF_TYPE_TIME_EXTEND:	Extend the time delta
  *				 array[0] = time delta (28 .. 59)
@@ -39,22 +40,23 @@ struct ring_buffer_event {
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
index e1e6879..814c351 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -29,8 +29,8 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
 {
 	int ret;
 
-	ret = trace_seq_printf(s, "\ttype        :    2 bits\n");
-	ret = trace_seq_printf(s, "\tlen         :    3 bits\n");
+	ret = trace_seq_printf(s, "# compressed entry header\n");
+	ret = trace_seq_printf(s, "\ttype_len    :    5 bits\n");
 	ret = trace_seq_printf(s, "\ttime_delta  :   27 bits\n");
 	ret = trace_seq_printf(s, "\tarray       :   32 bits\n");
 	ret = trace_seq_printf(s, "\n");
@@ -38,8 +38,8 @@ int ring_buffer_print_entry_header(struct trace_seq *s)
 			       RINGBUF_TYPE_PADDING);
 	ret = trace_seq_printf(s, "\ttime_extend : type == %d\n",
 			       RINGBUF_TYPE_TIME_EXTEND);
-	ret = trace_seq_printf(s, "\tdata        : type == %d\n",
-			       RINGBUF_TYPE_DATA);
+	ret = trace_seq_printf(s, "\tdata max type_len  == %d\n",
+			       RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
 
 	return ret;
 }
@@ -205,7 +205,10 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
-#define RB_MAX_SMALL_DATA	28
+#define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
+
+/* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
+#define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 
 enum {
 	RB_LEN_TIME_EXTEND = 8,
@@ -214,17 +217,18 @@ enum {
 
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
 
@@ -233,8 +237,8 @@ rb_event_data_length(struct ring_buffer_event *event)
 {
 	unsigned length;
 
-	if (event->len)
-		length = event->len * RB_ALIGNMENT;
+	if (event->type_len)
+		length = event->type_len * RB_ALIGNMENT;
 	else
 		length = event->array[0];
 	return length + RB_EVNT_HDR_SIZE;
@@ -244,12 +248,12 @@ rb_event_data_length(struct ring_buffer_event *event)
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
@@ -273,7 +277,7 @@ rb_event_length(struct ring_buffer_event *event)
 unsigned ring_buffer_event_length(struct ring_buffer_event *event)
 {
 	unsigned length = rb_event_length(event);
-	if (event->type != RINGBUF_TYPE_DATA)
+	if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 		return length;
 	length -= RB_EVNT_HDR_SIZE;
 	if (length > RB_MAX_SMALL_DATA + sizeof(event->array[0]))
@@ -286,9 +290,9 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_length);
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
@@ -989,7 +993,7 @@ static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
 		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
 			return;
 		/* Only count data entries */
-		if (event->type != RINGBUF_TYPE_DATA)
+		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 			continue;
 		cpu_buffer->overrun++;
 		cpu_buffer->entries--;
@@ -1134,28 +1138,21 @@ static void
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
@@ -1565,7 +1562,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (length > BUF_PAGE_SIZE)
 		goto out;
 
-	event = rb_reserve_next_event(cpu_buffer, RINGBUF_TYPE_DATA, length);
+	event = rb_reserve_next_event(cpu_buffer, 0, length);
 	if (!event)
 		goto out;
 
@@ -1637,7 +1634,9 @@ EXPORT_SYMBOL_GPL(ring_buffer_unlock_commit);
 
 static inline void rb_event_discard(struct ring_buffer_event *event)
 {
-	event->type = RINGBUF_TYPE_PADDING;
+	/* array[0] holds the actual length for the discarded event */
+	event->array[0] = rb_event_data_length(event) - RB_EVNT_HDR_SIZE;
+	event->type_len = RINGBUF_TYPE_PADDING;
 	/* time delta must be non zero */
 	if (!event->time_delta)
 		event->time_delta = 1;
@@ -1789,8 +1788,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 		goto out;
 
 	event_length = rb_calculate_event_length(length);
-	event = rb_reserve_next_event(cpu_buffer,
-				      RINGBUF_TYPE_DATA, event_length);
+	event = rb_reserve_next_event(cpu_buffer, 0, event_length);
 	if (!event)
 		goto out;
 
@@ -2038,7 +2036,7 @@ rb_update_read_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	u64 delta;
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		return;
 
@@ -2069,7 +2067,7 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 {
 	u64 delta;
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		return;
 
@@ -2184,7 +2182,8 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	event = rb_reader_event(cpu_buffer);
 
-	if (event->type == RINGBUF_TYPE_DATA || rb_discarded_event(event))
+	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX
+			|| rb_discarded_event(event))
 		cpu_buffer->entries--;
 
 	rb_update_read_stamp(cpu_buffer, event);
@@ -2265,7 +2264,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	event = rb_reader_event(cpu_buffer);
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (rb_null_event(event))
 			RB_WARN_ON(cpu_buffer, 1);
@@ -2337,7 +2336,7 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
 	event = rb_iter_head_event(iter);
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (rb_null_event(event)) {
 			rb_inc_iter(iter);
@@ -2396,7 +2395,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	event = rb_buffer_peek(buffer, cpu, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2424,7 +2423,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	event = rb_iter_peek(iter, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2469,7 +2468,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
  out:
 	preempt_enable();
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2562,7 +2561,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2769,7 +2768,7 @@ static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
 		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
 			return;
 		/* Only count data entries */
-		if (event->type != RINGBUF_TYPE_DATA)
+		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 			continue;
 		cpu_buffer->entries--;
 	}

