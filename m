Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbZFPRxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbZFPRxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZFPRxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:53:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZFPRxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:53:22 -0400
Message-Id: <20090616175323.602459158@goodmis.org>
References: <20090616175133.317996432@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 16 Jun 2009 13:51:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] ring-buffer: use commit counters for commit pointer accounting
Content-Disposition: inline; filename=0003-ring-buffer-use-commit-counters-for-commit-pointer-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring buffer is made up of three sets of pointers.

The head page pointer, which points to the next page for the reader to
get.

The commit pointer and commit index, which points to the page and index
of the last committed write respectively.

The tail pointer and tail index, which points to the page and the index
of the last reserved data respectively (non committed).

The commit pointer is only moved forward by the outer most writer.
If a nested writer comes in, it will not move the pointer forward.

The current implementation has a flaw. It assumes that the outer most
writer successfully reserved data. There's a small race window where
the outer most writer could find the tail pointer, but a nested
writer could come in (via interrupt) and move the tail forward, and
even the commit forward.

The outer writer would not realized the commit moved forward and the
accounting will break.

This patch changes the design to use counters in the per cpu buffers
to keep track of commits. The counters are incremented at the start
of the commit, and decremented at the end. If the end commit counter
is 1, then it moves the commit pointers. A loop is made to check for
races between checking and moving the commit pointers. Only the outer
commit should move the pointers anyway.

The test of knowing if a reserve is equal to the last commit update
is still needed to know for time keeping. The time code is much less
racey than the commit updates.

This change not only solves the mentioned race, but also makes the
code simpler.

[ Impact: fix commit race and simplify code ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |  154 +++++++++++++++++++++----------------------
 1 files changed, 75 insertions(+), 79 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e857e94..ed35599 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -415,6 +415,8 @@ struct ring_buffer_per_cpu {
 	unsigned long			overrun;
 	unsigned long			read;
 	local_t				entries;
+	local_t				committing;
+	local_t				commits;
 	u64				write_stamp;
 	u64				read_stamp;
 	atomic_t			record_disabled;
@@ -1015,8 +1017,8 @@ rb_event_index(struct ring_buffer_event *event)
 }
 
 static inline int
-rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
-	     struct ring_buffer_event *event)
+rb_event_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
+		   struct ring_buffer_event *event)
 {
 	unsigned long addr = (unsigned long)event;
 	unsigned long index;
@@ -1029,31 +1031,6 @@ rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 }
 
 static void
-rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
-		    struct ring_buffer_event *event)
-{
-	unsigned long addr = (unsigned long)event;
-	unsigned long index;
-
-	index = rb_event_index(event);
-	addr &= PAGE_MASK;
-
-	while (cpu_buffer->commit_page->page != (void *)addr) {
-		if (RB_WARN_ON(cpu_buffer,
-			  cpu_buffer->commit_page == cpu_buffer->tail_page))
-			return;
-		cpu_buffer->commit_page->page->commit =
-			cpu_buffer->commit_page->write;
-		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
-		cpu_buffer->write_stamp =
-			cpu_buffer->commit_page->page->time_stamp;
-	}
-
-	/* Now set the commit to the event's index */
-	local_set(&cpu_buffer->commit_page->page->commit, index);
-}
-
-static void
 rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	/*
@@ -1319,15 +1296,6 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 
 	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
-	/*
-	 * If this was a commit entry that failed,
-	 * increment that too
-	 */
-	if (tail_page == cpu_buffer->commit_page &&
-	    tail == rb_commit_index(cpu_buffer)) {
-		rb_set_commit_to_write(cpu_buffer);
-	}
-
 	__raw_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 
@@ -1377,11 +1345,11 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		local_inc(&tail_page->entries);
 
 	/*
-	 * If this is a commit and the tail is zero, then update
-	 * this page's time stamp.
+	 * If this is the first commit on the page, then update
+	 * its timestamp.
 	 */
-	if (!tail && rb_is_commit(cpu_buffer, event))
-		cpu_buffer->commit_page->page->time_stamp = *ts;
+	if (!tail)
+		tail_page->page->time_stamp = *ts;
 
 	return event;
 }
@@ -1450,16 +1418,16 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		return -EAGAIN;
 
 	/* Only a commited time event can update the write stamp */
-	if (rb_is_commit(cpu_buffer, event)) {
+	if (rb_event_is_commit(cpu_buffer, event)) {
 		/*
-		 * If this is the first on the page, then we need to
-		 * update the page itself, and just put in a zero.
+		 * If this is the first on the page, then it was
+		 * updated with the page itself. Try to discard it
+		 * and if we can't just make it zero.
 		 */
 		if (rb_event_index(event)) {
 			event->time_delta = *delta & TS_MASK;
 			event->array[0] = *delta >> TS_SHIFT;
 		} else {
-			cpu_buffer->commit_page->page->time_stamp = *ts;
 			/* try to discard, since we do not need this */
 			if (!rb_try_to_discard(cpu_buffer, event)) {
 				/* nope, just zero it */
@@ -1485,6 +1453,44 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 	return ret;
 }
 
+static void rb_start_commit(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	local_inc(&cpu_buffer->committing);
+	local_inc(&cpu_buffer->commits);
+}
+
+static void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	unsigned long commits;
+
+	if (RB_WARN_ON(cpu_buffer,
+		       !local_read(&cpu_buffer->committing)))
+		return;
+
+ again:
+	commits = local_read(&cpu_buffer->commits);
+	/* synchronize with interrupts */
+	barrier();
+	if (local_read(&cpu_buffer->committing) == 1)
+		rb_set_commit_to_write(cpu_buffer);
+
+	local_dec(&cpu_buffer->committing);
+
+	/* synchronize with interrupts */
+	barrier();
+
+	/*
+	 * Need to account for interrupts coming in between the
+	 * updating of the commit page and the clearing of the
+	 * committing counter.
+	 */
+	if (unlikely(local_read(&cpu_buffer->commits) != commits) &&
+	    !local_read(&cpu_buffer->committing)) {
+		local_inc(&cpu_buffer->committing);
+		goto again;
+	}
+}
+
 static struct ring_buffer_event *
 rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 		      unsigned long length)
@@ -1494,6 +1500,8 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	int commit = 0;
 	int nr_loops = 0;
 
+	rb_start_commit(cpu_buffer);
+
 	length = rb_calculate_event_length(length);
  again:
 	/*
@@ -1506,7 +1514,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	 * Bail!
 	 */
 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 1000))
-		return NULL;
+		goto out_fail;
 
 	ts = rb_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
 
@@ -1537,7 +1545,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
 			if (commit == -EBUSY)
-				return NULL;
+				goto out_fail;
 
 			if (commit == -EAGAIN)
 				goto again;
@@ -1551,28 +1559,19 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	if (unlikely(PTR_ERR(event) == -EAGAIN))
 		goto again;
 
-	if (!event) {
-		if (unlikely(commit))
-			/*
-			 * Ouch! We needed a timestamp and it was commited. But
-			 * we didn't get our event reserved.
-			 */
-			rb_set_commit_to_write(cpu_buffer);
-		return NULL;
-	}
+	if (!event)
+		goto out_fail;
 
-	/*
-	 * If the timestamp was commited, make the commit our entry
-	 * now so that we will update it when needed.
-	 */
-	if (unlikely(commit))
-		rb_set_commit_event(cpu_buffer, event);
-	else if (!rb_is_commit(cpu_buffer, event))
+	if (!rb_event_is_commit(cpu_buffer, event))
 		delta = 0;
 
 	event->time_delta = delta;
 
 	return event;
+
+ out_fail:
+	rb_end_commit(cpu_buffer);
+	return NULL;
 }
 
 #define TRACE_RECURSIVE_DEPTH 16
@@ -1682,13 +1681,14 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	local_inc(&cpu_buffer->entries);
 
-	/* Only process further if we own the commit */
-	if (!rb_is_commit(cpu_buffer, event))
-		return;
-
-	cpu_buffer->write_stamp += event->time_delta;
+	/*
+	 * The event first in the commit queue updates the
+	 * time stamp.
+	 */
+	if (rb_event_is_commit(cpu_buffer, event))
+		cpu_buffer->write_stamp += event->time_delta;
 
-	rb_set_commit_to_write(cpu_buffer);
+	rb_end_commit(cpu_buffer);
 }
 
 /**
@@ -1777,15 +1777,15 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	/* The event is discarded regardless */
 	rb_event_discard(event);
 
+	cpu = smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+
 	/*
 	 * This must only be called if the event has not been
 	 * committed yet. Thus we can assume that preemption
 	 * is still disabled.
 	 */
-	RB_WARN_ON(buffer, preemptible());
-
-	cpu = smp_processor_id();
-	cpu_buffer = buffer->buffers[cpu];
+	RB_WARN_ON(buffer, !local_read(&cpu_buffer->committing));
 
 	if (!rb_try_to_discard(cpu_buffer, event))
 		goto out;
@@ -1796,13 +1796,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 */
 	local_inc(&cpu_buffer->entries);
  out:
-	/*
-	 * If a write came in and pushed the tail page
-	 * we still need to update the commit pointer
-	 * if we were the commit.
-	 */
-	if (rb_is_commit(cpu_buffer, event))
-		rb_set_commit_to_write(cpu_buffer);
+	rb_end_commit(cpu_buffer);
 
 	trace_recursive_unlock();
 
@@ -2720,6 +2714,8 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->overrun = 0;
 	cpu_buffer->read = 0;
 	local_set(&cpu_buffer->entries, 0);
+	local_set(&cpu_buffer->committing, 0);
+	local_set(&cpu_buffer->commits, 0);
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
-- 
1.6.3.1

-- 
