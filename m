Return-Path: <linux-kernel-owner+w=401wt.eu-S1761789AbZDBFhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789AbZDBFhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762366AbZDBFf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:35:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47123 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbZDBFfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:35:25 -0400
Message-Id: <20090402053522.594497414@goodmis.org>
References: <20090402052721.013878388@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 01:27:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] ring-buffer: add ring_buffer_discard_commit
Content-Disposition: inline; filename=0003-ring-buffer-add-ring_buffer_discard_commit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring_buffer_discard_commit is similar to ring_buffer_event_discard
but it can only be done on an event that has yet to be commited.
Unpredictable results can happen otherwise.

The main difference between ring_buffer_discard_commit and
ring_buffer_event_discard is that ring_buffer_discard_commit will try
to free the data in the ring buffer if nothing has addded data
after the reserved event. If something did, then it acts almost the
same as ring_buffer_event_discard followed by a
ring_buffer_unlock_commit.

Note, either ring_buffer_commit_discard and ring_buffer_unlock_commit
can be called on an event, not both.

This commit also exports both discard functions to be usable by
GPL modules.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |   29 ++++++++++
 kernel/trace/ring_buffer.c  |  125 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 133 insertions(+), 21 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e1b7b21..f0aa486 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -68,9 +68,38 @@ ring_buffer_event_time_delta(struct ring_buffer_event *event)
 	return event->time_delta;
 }
 
+/*
+ * ring_buffer_event_discard can discard any event in the ring buffer.
+ *   it is up to the caller to protect against a reader from
+ *   consuming it or a writer from wrapping and replacing it.
+ *
+ * No external protection is needed if this is called before
+ * the event is commited. But in that case it would be better to
+ * use ring_buffer_discard_commit.
+ *
+ * Note, if an event that has not been committed is discarded
+ * with ring_buffer_event_discard, it must still be committed.
+ */
 void ring_buffer_event_discard(struct ring_buffer_event *event);
 
 /*
+ * ring_buffer_discard_commit will remove an event that has not
+ *   ben committed yet. If this is used, then ring_buffer_unlock_commit
+ *   must not be called on the discarded event. This function
+ *   will try to remove the event from the ring buffer completely
+ *   if another event has not been written after it.
+ *
+ * Example use:
+ *
+ *  if (some_condition)
+ *    ring_buffer_discard_commit(buffer, event);
+ *  else
+ *    ring_buffer_unlock_commit(buffer, event);
+ */
+void ring_buffer_discard_commit(struct ring_buffer *buffer,
+				struct ring_buffer_event *event);
+
+/*
  * size is in bytes for each per CPU buffer.
  */
 struct ring_buffer *
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index edce2ff..4d0ff54 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -205,27 +205,6 @@ static void rb_event_set_padding(struct ring_buffer_event *event)
 	event->time_delta = 0;
 }
 
-/**
- * ring_buffer_event_discard - discard an event in the ring buffer
- * @buffer: the ring buffer
- * @event: the event to discard
- *
- * Sometimes a event that is in the ring buffer needs to be ignored.
- * This function lets the user discard an event in the ring buffer
- * and then that event will not be read later.
- *
- * Note, it is up to the user to be careful with this, and protect
- * against races. If the user discards an event that has been consumed
- * it is possible that it could corrupt the ring buffer.
- */
-void ring_buffer_event_discard(struct ring_buffer_event *event)
-{
-	event->type = RINGBUF_TYPE_PADDING;
-	/* time delta must be non zero */
-	if (!event->time_delta)
-		event->time_delta = 1;
-}
-
 static unsigned
 rb_event_data_length(struct ring_buffer_event *event)
 {
@@ -1572,6 +1551,110 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 EXPORT_SYMBOL_GPL(ring_buffer_unlock_commit);
 
 /**
+ * ring_buffer_event_discard - discard any event in the ring buffer
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
+EXPORT_SYMBOL_GPL(ring_buffer_event_discard);
+
+/**
+ * ring_buffer_commit_discard - discard an event that has not been committed
+ * @buffer: the ring buffer
+ * @event: non committed event to discard
+ *
+ * This is similar to ring_buffer_event_discard but must only be
+ * performed on an event that has not been committed yet. The difference
+ * is that this will also try to free the event from the ring buffer
+ * if another event has not been added behind it.
+ *
+ * If another event has been added behind it, it will set the event
+ * up as discarded, and perform the commit.
+ *
+ * If this function is called, do not call ring_buffer_unlock_commit on
+ * the event.
+ */
+void ring_buffer_discard_commit(struct ring_buffer *buffer,
+				struct ring_buffer_event *event)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long new_index, old_index;
+	struct buffer_page *bpage;
+	unsigned long index;
+	unsigned long addr;
+	int cpu;
+
+	/* The event is discarded regardless */
+	ring_buffer_event_discard(event);
+
+	/*
+	 * This must only be called if the event has not been
+	 * committed yet. Thus we can assume that preemption
+	 * is still disabled.
+	 */
+	RB_WARN_ON(buffer, !preempt_count());
+
+	cpu = smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+
+	new_index = rb_event_index(event);
+	old_index = new_index + rb_event_length(event);
+	addr = (unsigned long)event;
+	addr &= PAGE_MASK;
+
+	bpage = cpu_buffer->tail_page;
+
+	if (bpage == (void *)addr && rb_page_write(bpage) == old_index) {
+		/*
+		 * This is on the tail page. It is possible that
+		 * a write could come in and move the tail page
+		 * and write to the next page. That is fine
+		 * because we just shorten what is on this page.
+		 */
+		index = local_cmpxchg(&bpage->write, old_index, new_index);
+		if (index == old_index)
+			goto out;
+	}
+
+	/*
+	 * The commit is still visible by the reader, so we
+	 * must increment entries.
+	 */
+	cpu_buffer->entries++;
+ out:
+	/*
+	 * If a write came in and pushed the tail page
+	 * we still need to update the commit pointer
+	 * if we were the commit.
+	 */
+	if (rb_is_commit(cpu_buffer, event))
+		rb_set_commit_to_write(cpu_buffer);
+
+	/*
+	 * Only the last preempt count needs to restore preemption.
+	 */
+	if (preempt_count() == 1)
+		ftrace_preempt_enable(per_cpu(rb_need_resched, cpu));
+	else
+		preempt_enable_no_resched_notrace();
+
+}
+EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
+
+/**
  * ring_buffer_write - write data to the buffer without reserving
  * @buffer: The ring buffer to write to.
  * @length: The length of the data being written (excluding the event header)
-- 
1.6.2.1

-- 
