Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZEFE1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZEFE1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZEFEXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39829 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZEFEXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:36 -0400
Message-Id: <20090506042334.938331281@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/11] ring-buffer: move big if statement down
Content-Disposition: inline; filename=0010-ring-buffer-move-big-if-statement-down.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In the hot path of the ring buffer "__rb_reserve_next" there's a big
if statement that does not even return back to the work flow.

	code;

	if (cross to next page) {

		[ lots of code ]

		return;
	}

	more code;

The condition is even the unlikely path, although we do not denote it
with an unlikely because gcc is fine with it. The condition is true when
the write crosses a page boundary, and we need to start at a new page.

Having this if statement makes it hard to read, but calling another
function to do the work is also not appropriate, because we are using a lot
of variables that were set before the if statement, and we do not want to
send them as parameters.

This patch changes it to a goto:

	code;

	if (cross to next page)
		goto next_page;

	more code;

	return;

next_page:

	[ lots of code]

This makes the code easier to understand, and a bit more obvious.

The output from gcc is practically identical. For some reason, gcc decided
to use different registers when I switched it to a goto. But other than that,
the logic is the same.

[ Impact: easier to read code ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |  224 ++++++++++++++++++++++----------------------
 1 files changed, 114 insertions(+), 110 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7876df0..424129e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1159,6 +1159,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		  unsigned type, unsigned long length, u64 *ts)
 {
 	struct buffer_page *tail_page, *head_page, *reader_page, *commit_page;
+	struct buffer_page *next_page;
 	unsigned long tail, write;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_event *event;
@@ -1173,137 +1174,140 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	tail = write - length;
 
 	/* See if we shot pass the end of this buffer page */
-	if (write > BUF_PAGE_SIZE) {
-		struct buffer_page *next_page = tail_page;
+	if (write > BUF_PAGE_SIZE)
+		goto next_page;
 
-		local_irq_save(flags);
-		/*
-		 * Since the write to the buffer is still not
-		 * fully lockless, we must be careful with NMIs.
-		 * The locks in the writers are taken when a write
-		 * crosses to a new page. The locks protect against
-		 * races with the readers (this will soon be fixed
-		 * with a lockless solution).
-		 *
-		 * Because we can not protect against NMIs, and we
-		 * want to keep traces reentrant, we need to manage
-		 * what happens when we are in an NMI.
-		 *
-		 * NMIs can happen after we take the lock.
-		 * If we are in an NMI, only take the lock
-		 * if it is not already taken. Otherwise
-		 * simply fail.
-		 */
-		if (unlikely(in_nmi())) {
-			if (!__raw_spin_trylock(&cpu_buffer->lock)) {
-				cpu_buffer->nmi_dropped++;
-				goto out_reset;
-			}
-		} else
-			__raw_spin_lock(&cpu_buffer->lock);
-
-		lock_taken = true;
+	/* We reserved something on the buffer */
 
-		rb_inc_page(cpu_buffer, &next_page);
+	if (RB_WARN_ON(cpu_buffer, write > BUF_PAGE_SIZE))
+		return NULL;
 
-		head_page = cpu_buffer->head_page;
-		reader_page = cpu_buffer->reader_page;
+	event = __rb_page_index(tail_page, tail);
+	rb_update_event(event, type, length);
 
-		/* we grabbed the lock before incrementing */
-		if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
-			goto out_reset;
+	/* The passed in type is zero for DATA */
+	if (likely(!type))
+		local_inc(&tail_page->entries);
 
-		/*
-		 * If for some reason, we had an interrupt storm that made
-		 * it all the way around the buffer, bail, and warn
-		 * about it.
-		 */
-		if (unlikely(next_page == commit_page)) {
-			cpu_buffer->commit_overrun++;
-			goto out_reset;
-		}
+	/*
+	 * If this is a commit and the tail is zero, then update
+	 * this page's time stamp.
+	 */
+	if (!tail && rb_is_commit(cpu_buffer, event))
+		cpu_buffer->commit_page->page->time_stamp = *ts;
 
-		if (next_page == head_page) {
-			if (!(buffer->flags & RB_FL_OVERWRITE))
-				goto out_reset;
+	return event;
 
-			/* tail_page has not moved yet? */
-			if (tail_page == cpu_buffer->tail_page) {
-				/* count overflows */
-				cpu_buffer->overrun +=
-					local_read(&head_page->entries);
+ next_page:
 
-				rb_inc_page(cpu_buffer, &head_page);
-				cpu_buffer->head_page = head_page;
-				cpu_buffer->head_page->read = 0;
-			}
-		}
+	next_page = tail_page;
 
-		/*
-		 * If the tail page is still the same as what we think
-		 * it is, then it is up to us to update the tail
-		 * pointer.
-		 */
-		if (tail_page == cpu_buffer->tail_page) {
-			local_set(&next_page->write, 0);
-			local_set(&next_page->entries, 0);
-			local_set(&next_page->page->commit, 0);
-			cpu_buffer->tail_page = next_page;
-
-			/* reread the time stamp */
-			*ts = ring_buffer_time_stamp(buffer, cpu_buffer->cpu);
-			cpu_buffer->tail_page->page->time_stamp = *ts;
+	local_irq_save(flags);
+	/*
+	 * Since the write to the buffer is still not
+	 * fully lockless, we must be careful with NMIs.
+	 * The locks in the writers are taken when a write
+	 * crosses to a new page. The locks protect against
+	 * races with the readers (this will soon be fixed
+	 * with a lockless solution).
+	 *
+	 * Because we can not protect against NMIs, and we
+	 * want to keep traces reentrant, we need to manage
+	 * what happens when we are in an NMI.
+	 *
+	 * NMIs can happen after we take the lock.
+	 * If we are in an NMI, only take the lock
+	 * if it is not already taken. Otherwise
+	 * simply fail.
+	 */
+	if (unlikely(in_nmi())) {
+		if (!__raw_spin_trylock(&cpu_buffer->lock)) {
+			cpu_buffer->nmi_dropped++;
+			goto out_reset;
 		}
+	} else
+		__raw_spin_lock(&cpu_buffer->lock);
 
-		/*
-		 * The actual tail page has moved forward.
-		 */
-		if (tail < BUF_PAGE_SIZE) {
-			/* Mark the rest of the page with padding */
-			event = __rb_page_index(tail_page, tail);
-			rb_event_set_padding(event);
-		}
+	lock_taken = true;
 
-		if (tail <= BUF_PAGE_SIZE)
-			/* Set the write back to the previous setting */
-			local_set(&tail_page->write, tail);
+	rb_inc_page(cpu_buffer, &next_page);
 
-		/*
-		 * If this was a commit entry that failed,
-		 * increment that too
-		 */
-		if (tail_page == cpu_buffer->commit_page &&
-		    tail == rb_commit_index(cpu_buffer)) {
-			rb_set_commit_to_write(cpu_buffer);
-		}
+	head_page = cpu_buffer->head_page;
+	reader_page = cpu_buffer->reader_page;
 
-		__raw_spin_unlock(&cpu_buffer->lock);
-		local_irq_restore(flags);
+	/* we grabbed the lock before incrementing */
+	if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
+		goto out_reset;
 
-		/* fail and let the caller try again */
-		return ERR_PTR(-EAGAIN);
+	/*
+	 * If for some reason, we had an interrupt storm that made
+	 * it all the way around the buffer, bail, and warn
+	 * about it.
+	 */
+	if (unlikely(next_page == commit_page)) {
+		cpu_buffer->commit_overrun++;
+		goto out_reset;
 	}
 
-	/* We reserved something on the buffer */
+	if (next_page == head_page) {
+		if (!(buffer->flags & RB_FL_OVERWRITE))
+			goto out_reset;
 
-	if (RB_WARN_ON(cpu_buffer, write > BUF_PAGE_SIZE))
-		return NULL;
+		/* tail_page has not moved yet? */
+		if (tail_page == cpu_buffer->tail_page) {
+			/* count overflows */
+			cpu_buffer->overrun +=
+				local_read(&head_page->entries);
 
-	event = __rb_page_index(tail_page, tail);
-	rb_update_event(event, type, length);
+			rb_inc_page(cpu_buffer, &head_page);
+			cpu_buffer->head_page = head_page;
+			cpu_buffer->head_page->read = 0;
+		}
+	}
 
-	/* The passed in type is zero for DATA */
-	if (likely(!type))
-		local_inc(&tail_page->entries);
+	/*
+	 * If the tail page is still the same as what we think
+	 * it is, then it is up to us to update the tail
+	 * pointer.
+	 */
+	if (tail_page == cpu_buffer->tail_page) {
+		local_set(&next_page->write, 0);
+		local_set(&next_page->entries, 0);
+		local_set(&next_page->page->commit, 0);
+		cpu_buffer->tail_page = next_page;
+
+		/* reread the time stamp */
+		*ts = ring_buffer_time_stamp(buffer, cpu_buffer->cpu);
+		cpu_buffer->tail_page->page->time_stamp = *ts;
+	}
 
 	/*
-	 * If this is a commit and the tail is zero, then update
-	 * this page's time stamp.
+	 * The actual tail page has moved forward.
 	 */
-	if (!tail && rb_is_commit(cpu_buffer, event))
-		cpu_buffer->commit_page->page->time_stamp = *ts;
+	if (tail < BUF_PAGE_SIZE) {
+		/* Mark the rest of the page with padding */
+		event = __rb_page_index(tail_page, tail);
+		rb_event_set_padding(event);
+	}
 
-	return event;
+	if (tail <= BUF_PAGE_SIZE)
+		/* Set the write back to the previous setting */
+		local_set(&tail_page->write, tail);
+
+	/*
+	 * If this was a commit entry that failed,
+	 * increment that too
+	 */
+	if (tail_page == cpu_buffer->commit_page &&
+	    tail == rb_commit_index(cpu_buffer)) {
+		rb_set_commit_to_write(cpu_buffer);
+	}
+
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(flags);
+
+	/* fail and let the caller try again */
+	return ERR_PTR(-EAGAIN);
 
  out_reset:
 	/* reset write */
-- 
1.6.2.4

-- 
