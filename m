Return-Path: <linux-kernel-owner+w=401wt.eu-S934349AbZIEADv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbZIEADv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934264AbZIEADr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:03:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33539 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060AbZIEABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:21 -0400
Message-Id: <20090905000122.657369106@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/18] ring-buffer: do not count discarded events
Content-Disposition: inline; filename=0006-ring-buffer-do-not-count-discarded-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The latency tracers report the number of items in the trace buffer.
This uses the ring buffer data to calculate this. Because discarded
events are also counted, the numbers do not match the number of items
that are printed. The ring buffer also adds a "padding" item to the
end of each buffer page which also gets counted as a discarded item.

This patch decrements the counter to the page entries on a discard.
This allows us to ignore discarded entries while reading the buffer.

Decrementing the counter is still safe since it can only happen while
the committing flag is still set.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   71 +++++++++++++++++++++++++++++++++----------
 1 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 092fe0c..c8d2a66 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -218,17 +218,12 @@ enum {
 
 static inline int rb_null_event(struct ring_buffer_event *event)
 {
-	return event->type_len == RINGBUF_TYPE_PADDING
-			&& event->time_delta == 0;
-}
-
-static inline int rb_discarded_event(struct ring_buffer_event *event)
-{
-	return event->type_len == RINGBUF_TYPE_PADDING && event->time_delta;
+	return event->type_len == RINGBUF_TYPE_PADDING && !event->time_delta;
 }
 
 static void rb_event_set_padding(struct ring_buffer_event *event)
 {
+	/* padding has a NULL time_delta */
 	event->type_len = RINGBUF_TYPE_PADDING;
 	event->time_delta = 0;
 }
@@ -1778,9 +1773,6 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	event->type_len = RINGBUF_TYPE_PADDING;
 	/* time delta must be non zero */
 	event->time_delta = 1;
-	/* Account for this as an entry */
-	local_inc(&tail_page->entries);
-	local_inc(&cpu_buffer->entries);
 
 	/* Set write to end of buffer */
 	length = (tail + length) - BUF_PAGE_SIZE;
@@ -2269,18 +2261,23 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_lock_reserve);
 
-static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
+static void
+rb_update_write_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
-	local_inc(&cpu_buffer->entries);
-
 	/*
 	 * The event first in the commit queue updates the
 	 * time stamp.
 	 */
 	if (rb_event_is_commit(cpu_buffer, event))
 		cpu_buffer->write_stamp += event->time_delta;
+}
 
+static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
+		      struct ring_buffer_event *event)
+{
+	local_inc(&cpu_buffer->entries);
+	rb_update_write_stamp(cpu_buffer, event);
 	rb_end_commit(cpu_buffer);
 }
 
@@ -2327,6 +2324,46 @@ static inline void rb_event_discard(struct ring_buffer_event *event)
 		event->time_delta = 1;
 }
 
+/*
+ * Decrement the entries to the page that an event is on.
+ * The event does not even need to exist, only the pointer
+ * to the page it is on. This may only be called before the commit
+ * takes place.
+ */
+static inline void
+rb_decrement_entry(struct ring_buffer_per_cpu *cpu_buffer,
+		   struct ring_buffer_event *event)
+{
+	unsigned long addr = (unsigned long)event;
+	struct buffer_page *bpage = cpu_buffer->commit_page;
+	struct buffer_page *start;
+
+	addr &= PAGE_MASK;
+
+	/* Do the likely case first */
+	if (likely(bpage->page == (void *)addr)) {
+		local_dec(&bpage->entries);
+		return;
+	}
+
+	/*
+	 * Because the commit page may be on the reader page we
+	 * start with the next page and check the end loop there.
+	 */
+	rb_inc_page(cpu_buffer, &bpage);
+	start = bpage;
+	do {
+		if (bpage->page == (void *)addr) {
+			local_dec(&bpage->entries);
+			return;
+		}
+		rb_inc_page(cpu_buffer, &bpage);
+	} while (bpage != start);
+
+	/* commit not part of this buffer?? */
+	RB_WARN_ON(cpu_buffer, 1);
+}
+
 /**
  * ring_buffer_commit_discard - discard an event that has not been committed
  * @buffer: the ring buffer
@@ -2365,14 +2402,15 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 */
 	RB_WARN_ON(buffer, !local_read(&cpu_buffer->committing));
 
+	rb_decrement_entry(cpu_buffer, event);
 	if (rb_try_to_discard(cpu_buffer, event))
 		goto out;
 
 	/*
 	 * The commit is still visible by the reader, so we
-	 * must increment entries.
+	 * must still update the timestamp.
 	 */
-	local_inc(&cpu_buffer->entries);
+	rb_update_write_stamp(cpu_buffer, event);
  out:
 	rb_end_commit(cpu_buffer);
 
@@ -2884,8 +2922,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	event = rb_reader_event(cpu_buffer);
 
-	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX
-			|| rb_discarded_event(event))
+	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 		cpu_buffer->read++;
 
 	rb_update_read_stamp(cpu_buffer, event);
-- 
1.6.3.3

-- 
