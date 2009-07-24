Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZGXKkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZGXKkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZGXKkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:40:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51811 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZGXKkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:40:17 -0400
Message-ID: <4A699038.6060907@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 18:43:04 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 1/3] Add walltime support for ring-buffer
References: <4A698F90.90501@cn.fujitsu.com>
In-Reply-To: <4A698F90.90501@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note:
It is only a prototype patch to for demostrate what is result
looks like.
There still have many works to do(bug to fix) before apply.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 drivers/oprofile/cpu_buffer.c        |    4 +-
 include/linux/ring_buffer.h          |   12 ++-
 kernel/trace/ring_buffer.c           |  159 ++++++++++++++++++++++++++++++----
 kernel/trace/ring_buffer_benchmark.c |    3 +-
 kernel/trace/trace.c                 |    8 +-
 kernel/trace/trace_functions_graph.c |    8 +-
 kernel/trace/trace_selftest.c        |    2 +-
 7 files changed, 161 insertions(+), 35 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index a7aae24..1b9b36d 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -187,14 +187,14 @@ int op_cpu_buffer_write_commit(struct op_entry *entry)
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu)
 {
 	struct ring_buffer_event *e;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL, NULL);
 	if (e)
 		goto event;
 	if (ring_buffer_swap_cpu(op_ring_buffer_read,
 				 op_ring_buffer_write,
 				 cpu))
 		return NULL;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL, NULL);
 	if (e)
 		goto event;
 	return NULL;
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 7fca716..eafffca 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -134,18 +134,22 @@ int ring_buffer_write(struct ring_buffer *buffer,
 		      unsigned long length, void *data);
 
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+		 struct timespec *timespec);
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts);
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+		    struct timespec *timespec);
 
 struct ring_buffer_iter *
 ring_buffer_read_start(struct ring_buffer *buffer, int cpu);
 void ring_buffer_read_finish(struct ring_buffer_iter *iter);
 
 struct ring_buffer_event *
-ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts);
+ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts,
+		      struct timespec *timespec);
 struct ring_buffer_event *
-ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts);
+ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts,
+		 struct timespec *timespec);
 void ring_buffer_iter_reset(struct ring_buffer_iter *iter);
 int ring_buffer_iter_empty(struct ring_buffer_iter *iter);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 51633d7..698e47f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -318,6 +318,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
+	u32		 walltime[3];	/* page wall time */
 	local_t		 commit;	/* write committed index */
 	unsigned char	 data[];	/* data of buffer page */
 };
@@ -442,6 +443,8 @@ struct ring_buffer_per_cpu {
 	unsigned long			read;
 	u64				write_stamp;
 	u64				read_stamp;
+	u64				read_walltimestamp;
+	u32				read_walltime[3];
 	atomic_t			record_disabled;
 };
 
@@ -469,6 +472,8 @@ struct ring_buffer_iter {
 	unsigned long			head;
 	struct buffer_page		*head_page;
 	u64				read_stamp;
+	u64				read_walltimestamp;
+	u32				read_walltime[3];
 };
 
 /* buffer may be either ring_buffer or ring_buffer_per_cpu */
@@ -1499,6 +1504,14 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
+	cpu_buffer->read_walltimestamp =
+		cpu_buffer->reader_page->page->time_stamp;
+	cpu_buffer->read_walltime[0] =
+		cpu_buffer->reader_page->page->walltime[0];
+	cpu_buffer->read_walltime[1] =
+		cpu_buffer->reader_page->page->walltime[1];
+	cpu_buffer->read_walltime[2] =
+		cpu_buffer->reader_page->page->walltime[2];
 	cpu_buffer->reader_page->read = 0;
 }
 
@@ -1518,6 +1531,10 @@ static void rb_inc_iter(struct ring_buffer_iter *iter)
 		rb_inc_page(cpu_buffer, &iter->head_page);
 
 	iter->read_stamp = iter->head_page->page->time_stamp;
+	iter->read_walltimestamp = iter->head_page->page->time_stamp;
+	iter->read_walltime[0] = iter->head_page->page->walltime[0];
+	iter->read_walltime[1] = iter->head_page->page->walltime[1];
+	iter->read_walltime[2] = iter->head_page->page->walltime[2];
 	iter->head = 0;
 }
 
@@ -1927,8 +1944,48 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	 * If this is the first commit on the page, then update
 	 * its timestamp.
 	 */
-	if (!tail)
+	if (!tail) {
+		struct timespec timespec;
 		tail_page->page->time_stamp = *ts;
+		/*
+		 * Fixme:
+		 * 1: Get walltime close to get timestamp
+		 * 2: don't need to set timestamp in rb_move_tail(), timestamp
+		 *    will be rewrited here
+		 */
+		/*
+		 * Fixme:
+		 * We can't call getnstimeofday() here,
+		 * because when when a function called with xtime_lock holded,
+		 * kernel will run to here by function_trace, then
+		 * getnstimeofday() will run into infinite loop, fox ex:
+		 * tick_do_update_jiffies64()  * write_seqlock(xtime_lock) *
+		 * ->do_timer()
+		 * ->update_wall_time()
+		 * ->update_xtime_cache()
+		 * ->ftrace_call()  * here into function trace *
+		 * ->function_test_events_call()
+		 * ->trace_current_buffer_lock_reserve()
+		 * -> ...
+		 * -> here
+		 *
+		 * So we use get_seconds() when xtime_lock is holded,
+		 * it is only a temporary way just to get walltime function
+		 * work, we must fix it.
+		 *
+		 * Another way is call ftrace_disable_cpu() before
+		 * write_seqlock().
+		 */
+		if (xtime_lock.sequence & 1) {
+			timespec.tv_sec = get_seconds();
+			timespec.tv_nsec = 0;
+		} else {
+			getnstimeofday(&timespec);
+		}
+		tail_page->page->walltime[0] = timespec.tv_nsec;
+		*(__kernel_time_t *)(tail_page->page->walltime + 1) =
+			timespec.tv_sec;
+	}
 
 	return event;
 }
@@ -2674,10 +2731,19 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
 		iter->head_page = cpu_buffer->reader_page;
 		iter->head = cpu_buffer->reader_page->read;
 	}
-	if (iter->head)
+	if (iter->head) {
 		iter->read_stamp = cpu_buffer->read_stamp;
-	else
+		iter->read_walltimestamp = cpu_buffer->read_walltimestamp;
+		iter->read_walltime[0] = cpu_buffer->read_walltime[0];
+		iter->read_walltime[1] = cpu_buffer->read_walltime[1];
+		iter->read_walltime[2] = cpu_buffer->read_walltime[2];
+	} else {
 		iter->read_stamp = iter->head_page->page->time_stamp;
+		iter->read_walltimestamp = iter->head_page->page->time_stamp;
+		iter->read_walltime[0] = iter->head_page->page->walltime[0];
+		iter->read_walltime[1] = iter->head_page->page->walltime[1];
+		iter->read_walltime[2] = iter->head_page->page->walltime[2];
+	}
 }
 
 /**
@@ -2780,6 +2846,21 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 	return;
 }
 
+static void rb_cal_walltime(u32 *walltime, u64 ts, u32 *base_walltime,
+			    u64 base_ts)
+{
+	u64 sec;
+	u64 nsec;
+	sec = *(__kernel_time_t *)(base_walltime + 1);
+	nsec = base_walltime[0] + ts - base_ts;
+	while (nsec >= NSEC_PER_SEC) {
+		nsec -= NSEC_PER_SEC;
+		++sec;
+	}
+	walltime[0] = nsec;
+	*(__kernel_time_t *)(walltime + 1) = sec;
+}
+
 static struct buffer_page *
 rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
@@ -2953,12 +3034,14 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 }
 
 static struct ring_buffer_event *
-rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+	       struct timespec *timespec)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
 	int nr_loops = 0;
+	u64 timestamp;
 
 	cpu_buffer = buffer->buffers[cpu];
 
@@ -3004,10 +3087,21 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 		goto again;
 
 	case RINGBUF_TYPE_DATA:
-		if (ts) {
-			*ts = cpu_buffer->read_stamp + event->time_delta;
+		if (ts || timespec) {
+			timestamp = cpu_buffer->read_stamp + event->time_delta;
 			ring_buffer_normalize_time_stamp(buffer,
-							 cpu_buffer->cpu, ts);
+							 cpu_buffer->cpu,
+							 &timestamp);
+		}
+		if (ts)
+			*ts = timestamp;
+		if (timespec) {
+			u32 walltime[3];
+			rb_cal_walltime(walltime, timestamp,
+				cpu_buffer->read_walltime,
+				cpu_buffer->read_walltimestamp);
+			timespec->tv_nsec = walltime[0];
+			timespec->tv_sec = *(__kernel_time_t *)(walltime + 1);
 		}
 		return event;
 
@@ -3020,12 +3114,13 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 EXPORT_SYMBOL_GPL(ring_buffer_peek);
 
 static struct ring_buffer_event *
-rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
+rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts, struct timespec *timespec)
 {
 	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	int nr_loops = 0;
+	u64 timestamp;
 
 	if (ring_buffer_iter_empty(iter))
 		return NULL;
@@ -3070,10 +3165,20 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 		goto again;
 
 	case RINGBUF_TYPE_DATA:
-		if (ts) {
-			*ts = iter->read_stamp + event->time_delta;
+		if (ts || timespec) {
+			timestamp = iter->read_stamp + event->time_delta;
 			ring_buffer_normalize_time_stamp(buffer,
-							 cpu_buffer->cpu, ts);
+							 cpu_buffer->cpu,
+							 &timestamp);
+		}
+		if (ts)
+			*ts = timestamp;
+		if (timespec) {
+			u32 walltime[3];
+			rb_cal_walltime(walltime, timestamp,
+				iter->read_walltime, iter->read_walltimestamp);
+			timespec->tv_nsec = walltime[0];
+			timespec->tv_sec = *(__kernel_time_t *)(walltime + 1);
 		}
 		return event;
 
@@ -3110,7 +3215,8 @@ static inline int rb_ok_to_lock(void)
  * not consume the data.
  */
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+		 struct timespec *timespec)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
@@ -3125,7 +3231,8 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	local_irq_save(flags);
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_buffer_peek(buffer, cpu, ts, timespec);
+
 	if (dolock)
 		spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
@@ -3147,7 +3254,8 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
  * not increment the iterator.
  */
 struct ring_buffer_event *
-ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
+ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts,
+		      struct timespec *timespec)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	struct ring_buffer_event *event;
@@ -3155,7 +3263,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
  again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-	event = rb_iter_peek(iter, ts);
+	event = rb_iter_peek(iter, ts, timespec);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
@@ -3175,7 +3283,8 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
  * and eventually empty the ring buffer if the producer is slower.
  */
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+		    struct timespec *timespec)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event = NULL;
@@ -3196,7 +3305,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_buffer_peek(buffer, cpu, ts, timespec);
 	if (!event)
 		goto out_unlock;
 
@@ -3287,7 +3396,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_read_finish);
  * This reads the next event in the ring buffer and increments the iterator.
  */
 struct ring_buffer_event *
-ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
+ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts,
+		 struct timespec *timespec)
 {
 	struct ring_buffer_event *event;
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
@@ -3295,7 +3405,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 
  again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-	event = rb_iter_peek(iter, ts);
+	event = rb_iter_peek(iter, ts, timespec);
 	if (!event)
 		goto out;
 
@@ -3353,6 +3463,10 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
+	cpu_buffer->read_walltimestamp = 0;
+	cpu_buffer->read_walltime[0] = 0;
+	cpu_buffer->read_walltime[1] = 0;
+	cpu_buffer->read_walltime[2] = 0;
 
 	rb_head_page_activate(cpu_buffer);
 }
@@ -3620,6 +3734,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
+	u32 save_walltime[3];
 	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -3679,6 +3794,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 
 		/* save the current timestamp, since the user will need it */
 		save_timestamp = cpu_buffer->read_stamp;
+		rb_cal_walltime(save_walltime, cpu_buffer->read_stamp,
+				cpu_buffer->read_walltime,
+				cpu_buffer->read_walltimestamp);
 
 		/* Need to copy one event at a time */
 		do {
@@ -3697,6 +3815,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		/* update bpage */
 		local_set(&bpage->commit, pos);
 		bpage->time_stamp = save_timestamp;
+		bpage->walltime[0] = save_walltime[0];
+		bpage->walltime[1] = save_walltime[1];
+		bpage->walltime[2] = save_walltime[2];
 
 		/* we copied everything to the beginning */
 		read = 0;
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 573d3cc..059a728 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -57,8 +57,9 @@ static enum event_status read_event(int cpu)
 	struct ring_buffer_event *event;
 	int *entry;
 	u64 ts;
+	struct timespec timespec;
 
-	event = ring_buffer_consume(buffer, cpu, &ts);
+	event = ring_buffer_consume(buffer, cpu, &ts, &timespec);
 	if (!event)
 		return EVENT_DROPPED;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e30e6b1..22787b3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1393,7 +1393,7 @@ static void trace_iterator_increment(struct trace_iterator *iter)
 
 	iter->idx++;
 	if (iter->buffer_iter[iter->cpu])
-		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL, NULL);
 
 	ftrace_enable_cpu();
 }
@@ -1408,9 +1408,9 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 	ftrace_disable_cpu();
 
 	if (buf_iter)
-		event = ring_buffer_iter_peek(buf_iter, ts);
+		event = ring_buffer_iter_peek(buf_iter, ts, NULL);
 	else
-		event = ring_buffer_peek(iter->tr->buffer, cpu, ts);
+		event = ring_buffer_peek(iter->tr->buffer, cpu, ts, NULL);
 
 	ftrace_enable_cpu();
 
@@ -1489,7 +1489,7 @@ static void trace_consume(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
 	ftrace_disable_cpu();
-	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts);
+	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts, NULL);
 	ftrace_enable_cpu();
 }
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index abf7c4a..03520a5 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -340,12 +340,12 @@ get_return_for_leaf(struct trace_iterator *iter,
 
 	/* First peek to compare current entry and the next one */
 	if (ring_iter)
-		event = ring_buffer_iter_peek(ring_iter, NULL);
+		event = ring_buffer_iter_peek(ring_iter, NULL, NULL);
 	else {
 	/* We need to consume the current entry to see the next one */
-		ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+		ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL, NULL);
 		event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
-					NULL);
+					NULL, NULL);
 	}
 
 	if (!event)
@@ -362,7 +362,7 @@ get_return_for_leaf(struct trace_iterator *iter,
 
 	/* this is a leaf, now advance the iterator */
 	if (ring_iter)
-		ring_buffer_read(ring_iter, NULL);
+		ring_buffer_read(ring_iter, NULL, NULL);
 
 	return next;
 }
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 71f2edb..e6fa0d1 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -29,7 +29,7 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
 	struct trace_entry *entry;
 	unsigned int loops = 0;
 
-	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
+	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL, NULL))) {
 		entry = ring_buffer_event_data(event);
 
 		/*
-- 
1.5.5.3


