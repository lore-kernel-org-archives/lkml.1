Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYJDGDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYJDGDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 02:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYJDGCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 02:02:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYJDGCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 02:02:14 -0400
Message-Id: <20081004060211.680031522@goodmis.org>
References: <20081004060057.660306328@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 04 Oct 2008 02:00:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ring-buffer: make reentrant
Content-Disposition: inline; filename=ring-buffer-reentrant.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the local_irq_save/restore with preempt_disable/
enable. This allows for interrupts to enter while recording.
To write to the ring buffer, you must reserve data, and then
commit it. During this time, an interrupt may call a trace function
that will also record into the buffer before the commit is made.

The interrupt will reserve its entry after the first entry, even
though the first entry did not finish yet.

The time stamp delta of the interrupt entry will be zero, since
in the view of the trace, the interrupt happened during the
first field anyway.

Locking still takes place when the tail/write moves from one page
to the next. The reader always takes the locks.

A new page pointer is added, called the commit. The write/tail will
always point to the end of all entries. The commit field will
point to the last committed entry. Only this commit entry may
update the write time stamp.

The reader can only go up to the commit. It cannot go past it.

If a lot of interrupts come in during a commit that fills up the
buffer, and it happens to make it all the way around the buffer
back to the commit, then a warning is printed and new events will
be dropped.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |  485 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 373 insertions(+), 112 deletions(-)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-04 01:18:17.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-04 01:33:27.000000000 -0400
@@ -116,8 +116,8 @@ void *ring_buffer_event_data(struct ring
  */
 struct buffer_page {
 	u64		 time_stamp;	/* page time stamp */
-	unsigned	 size;		/* size of page data */
-	unsigned	 write;		/* index for next write */
+	local_t		 write;		/* index for next write */
+	local_t		 commit;	/* write commited index */
 	unsigned	 read;		/* index for next read */
 	struct list_head list;		/* list of free pages */
 	void *page;			/* Actual data page */
@@ -157,6 +157,7 @@ struct ring_buffer_per_cpu {
 	struct list_head		pages;
 	struct buffer_page		*head_page;	/* read from head */
 	struct buffer_page		*tail_page;	/* write to tail */
+	struct buffer_page		*commit_page;	/* commited pages */
 	struct buffer_page		*reader_page;
 	unsigned long			overrun;
 	unsigned long			entries;
@@ -185,12 +186,32 @@ struct ring_buffer_iter {
 	u64				read_stamp;
 };
 
-#define RB_WARN_ON(buffer, cond)			\
-	if (unlikely(cond)) {				\
-		atomic_inc(&buffer->record_disabled);	\
-		WARN_ON(1);				\
-		return -1;				\
-	}
+#define RB_WARN_ON(buffer, cond)				\
+	do {							\
+		if (unlikely(cond)) {				\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
+		}						\
+	} while (0)
+
+#define RB_WARN_ON_RET(buffer, cond)				\
+	do {							\
+		if (unlikely(cond)) {				\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
+			return -1;				\
+		}						\
+	} while (0)
+
+#define RB_WARN_ON_ONCE(buffer, cond)				\
+	do {							\
+		static int once;				\
+		if (unlikely(cond) && !once) {			\
+			once++;					\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
+		}						\
+	} while (0)
 
 /**
  * check_pages - integrity check of buffer pages
@@ -204,22 +225,19 @@ static int rb_check_pages(struct ring_bu
 	struct list_head *head = &cpu_buffer->pages;
 	struct buffer_page *page, *tmp;
 
-	RB_WARN_ON(cpu_buffer, head->next->prev != head);
-	RB_WARN_ON(cpu_buffer, head->prev->next != head);
+	RB_WARN_ON_RET(cpu_buffer, head->next->prev != head);
+	RB_WARN_ON_RET(cpu_buffer, head->prev->next != head);
 
 	list_for_each_entry_safe(page, tmp, head, list) {
-		RB_WARN_ON(cpu_buffer, page->list.next->prev != &page->list);
-		RB_WARN_ON(cpu_buffer, page->list.prev->next != &page->list);
+		RB_WARN_ON_RET(cpu_buffer,
+			       page->list.next->prev != &page->list);
+		RB_WARN_ON_RET(cpu_buffer,
+			       page->list.prev->next != &page->list);
 	}
 
 	return 0;
 }
 
-static unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	return cpu_buffer->head_page->size;
-}
-
 static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned nr_pages)
 {
@@ -286,7 +304,6 @@ rb_allocate_cpu_buffer(struct ring_buffe
 	page->page = (void *)addr;
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
-	cpu_buffer->reader_page->size = 0;
 
 	ret = rb_allocate_pages(cpu_buffer, buffer->pages);
 	if (ret < 0)
@@ -294,8 +311,7 @@ rb_allocate_cpu_buffer(struct ring_buffe
 
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
-	cpu_buffer->tail_page
-		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
+	cpu_buffer->tail_page = cpu_buffer->commit_page = cpu_buffer->head_page;
 
 	return cpu_buffer;
 
@@ -563,15 +579,6 @@ int ring_buffer_resize(struct ring_buffe
 	return -ENOMEM;
 }
 
-static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	return cpu_buffer->reader_page->read == cpu_buffer->reader_page->size &&
-		(cpu_buffer->tail_page == cpu_buffer->reader_page ||
-		 (cpu_buffer->tail_page == cpu_buffer->head_page &&
-		  cpu_buffer->head_page->read ==
-		  cpu_buffer->tail_page->write));
-}
-
 static inline int rb_null_event(struct ring_buffer_event *event)
 {
 	return event->type == RINGBUF_TYPE_PADDING;
@@ -602,6 +609,33 @@ rb_iter_head_event(struct ring_buffer_it
 	return __rb_page_index(iter->head_page, iter->head);
 }
 
+static inline unsigned rb_page_write(struct buffer_page *bpage)
+{
+	return local_read(&bpage->write);
+}
+
+static inline unsigned rb_page_commit(struct buffer_page *bpage)
+{
+	return local_read(&bpage->commit);
+}
+
+/* Size is determined by what has been commited */
+static inline unsigned rb_page_size(struct buffer_page *bpage)
+{
+	return rb_page_commit(bpage);
+}
+
+static inline unsigned
+rb_commit_index(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return rb_page_commit(cpu_buffer->commit_page);
+}
+
+static inline unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return rb_page_commit(cpu_buffer->head_page);
+}
+
 /*
  * When the tail hits the head and the buffer is in overwrite mode,
  * the head jumps to the next page and all content on the previous
@@ -637,16 +671,76 @@ static inline void rb_inc_page(struct ri
 	*page = list_entry(p, struct buffer_page, list);
 }
 
+static inline unsigned
+rb_event_index(struct ring_buffer_event *event)
+{
+	unsigned long addr = (unsigned long)event;
+
+	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
+}
+
+static inline int
+rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
+	     struct ring_buffer_event *event)
+{
+	unsigned long addr = (unsigned long)event;
+	unsigned long index;
+
+	index = rb_event_index(event);
+	addr &= PAGE_MASK;
+
+	return cpu_buffer->commit_page->page == (void *)addr &&
+		rb_commit_index(cpu_buffer) == index;
+}
+
 static inline void
-rb_add_stamp(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
+rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
+		    struct ring_buffer_event *event)
 {
-	cpu_buffer->tail_page->time_stamp = *ts;
-	cpu_buffer->write_stamp = *ts;
+	unsigned long addr = (unsigned long)event;
+	unsigned long index;
+
+	index = rb_event_index(event);
+	addr &= PAGE_MASK;
+
+	while (cpu_buffer->commit_page->page != (void *)addr) {
+		RB_WARN_ON(cpu_buffer,
+			   cpu_buffer->commit_page == cpu_buffer->tail_page);
+		cpu_buffer->commit_page->commit =
+			cpu_buffer->commit_page->write;
+		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
+		cpu_buffer->write_stamp = cpu_buffer->commit_page->time_stamp;
+	}
+
+	/* Now set the commit to the event's index */
+	local_set(&cpu_buffer->commit_page->commit, index);
 }
 
-static void rb_reset_head_page(struct ring_buffer_per_cpu *cpu_buffer)
+static inline void
+rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	cpu_buffer->head_page->read = 0;
+	/*
+	 * We only race with interrupts and NMIs on this CPU.
+	 * If we own the commit event, then we can commit
+	 * all others that interrupted us, since the interruptions
+	 * are in stack format (they finish before they come
+	 * back to us). This allows us to do a simple loop to
+	 * assign the commit to the tail.
+	 */
+	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
+		cpu_buffer->commit_page->commit =
+			cpu_buffer->commit_page->write;
+		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
+		cpu_buffer->write_stamp = cpu_buffer->commit_page->time_stamp;
+		/* add barrier to keep gcc from optimizing too much */
+		barrier();
+	}
+	while (rb_commit_index(cpu_buffer) !=
+	       rb_page_write(cpu_buffer->commit_page)) {
+		cpu_buffer->commit_page->commit =
+			cpu_buffer->commit_page->write;
+		barrier();
+	}
 }
 
 static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
@@ -745,61 +839,120 @@ __rb_reserve_next(struct ring_buffer_per
 		  unsigned type, unsigned long length, u64 *ts)
 {
 	struct buffer_page *tail_page, *head_page, *reader_page;
-	unsigned long tail;
+	unsigned long tail, write;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_event *event;
+	unsigned long flags;
 
 	tail_page = cpu_buffer->tail_page;
-	tail = cpu_buffer->tail_page->write;
+	write = local_add_return(length, &tail_page->write);
+	tail = write - length;
 
-	if (tail + length > BUF_PAGE_SIZE) {
+	/* See if we shot pass the end of this buffer page */
+	if (write > BUF_PAGE_SIZE) {
 		struct buffer_page *next_page = tail_page;
 
-		spin_lock(&cpu_buffer->lock);
+		spin_lock_irqsave(&cpu_buffer->lock, flags);
+
 		rb_inc_page(cpu_buffer, &next_page);
 
 		head_page = cpu_buffer->head_page;
 		reader_page = cpu_buffer->reader_page;
 
 		/* we grabbed the lock before incrementing */
-		WARN_ON(next_page == reader_page);
+		RB_WARN_ON(cpu_buffer, next_page == reader_page);
+
+		/*
+		 * If for some reason, we had an interrupt storm that made
+		 * it all the way around the buffer, bail, and warn
+		 * about it.
+		 */
+		if (unlikely(next_page == cpu_buffer->commit_page)) {
+			WARN_ON_ONCE(1);
+			goto out_unlock;
+		}
 
 		if (next_page == head_page) {
 			if (!(buffer->flags & RB_FL_OVERWRITE)) {
-				spin_unlock(&cpu_buffer->lock);
-				return NULL;
+				/* reset write */
+				if (tail <= BUF_PAGE_SIZE)
+					local_set(&tail_page->write, tail);
+				goto out_unlock;
 			}
 
-			/* count overflows */
-			rb_update_overflow(cpu_buffer);
+			/* tail_page has not moved yet? */
+			if (tail_page == cpu_buffer->tail_page) {
+				/* count overflows */
+				rb_update_overflow(cpu_buffer);
+
+				rb_inc_page(cpu_buffer, &head_page);
+				cpu_buffer->head_page = head_page;
+				cpu_buffer->head_page->read = 0;
+			}
+		}
 
-			rb_inc_page(cpu_buffer, &head_page);
-			cpu_buffer->head_page = head_page;
-			rb_reset_head_page(cpu_buffer);
+		/*
+		 * If the tail page is still the same as what we think
+		 * it is, then it is up to us to update the tail
+		 * pointer.
+		 */
+		if (tail_page == cpu_buffer->tail_page) {
+			local_set(&next_page->write, 0);
+			local_set(&next_page->commit, 0);
+			cpu_buffer->tail_page = next_page;
+
+			/* reread the time stamp */
+			*ts = ring_buffer_time_stamp(cpu_buffer->cpu);
+			cpu_buffer->tail_page->time_stamp = *ts;
 		}
 
-		if (tail != BUF_PAGE_SIZE) {
+		/*
+		 * The actual tail page has moved forward.
+		 */
+		if (tail < BUF_PAGE_SIZE) {
+			/* Mark the rest of the page with padding */
 			event = __rb_page_index(tail_page, tail);
-			/* page padding */
 			event->type = RINGBUF_TYPE_PADDING;
 		}
 
-		tail_page->size = tail;
-		tail_page = next_page;
-		tail_page->size = 0;
-		tail = 0;
-		cpu_buffer->tail_page = tail_page;
-		cpu_buffer->tail_page->write = tail;
-		rb_add_stamp(cpu_buffer, ts);
-		spin_unlock(&cpu_buffer->lock);
+		if (tail <= BUF_PAGE_SIZE)
+			/* Set the write back to the previous setting */
+			local_set(&tail_page->write, tail);
+
+		/*
+		 * If this was a commit entry that failed,
+		 * increment that too
+		 */
+		if (tail_page == cpu_buffer->commit_page &&
+		    tail == rb_commit_index(cpu_buffer)) {
+			rb_set_commit_to_write(cpu_buffer);
+		}
+
+		spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+
+		/* fail and let the caller try again */
+		return ERR_PTR(-EAGAIN);
 	}
 
-	BUG_ON(tail + length > BUF_PAGE_SIZE);
+	/* We reserved something on the buffer */
+
+	BUG_ON(write > BUF_PAGE_SIZE);
 
 	event = __rb_page_index(tail_page, tail);
 	rb_update_event(event, type, length);
 
+	/*
+	 * If this is a commit and the tail is zero, then update
+	 * this page's time stamp.
+	 */
+	if (!tail && rb_is_commit(cpu_buffer, event))
+		cpu_buffer->commit_page->time_stamp = *ts;
+
 	return event;
+
+ out_unlock:
+	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	return NULL;
 }
 
 static int
@@ -808,6 +961,7 @@ rb_add_time_stamp(struct ring_buffer_per
 {
 	struct ring_buffer_event *event;
 	static int once;
+	int ret;
 
 	if (unlikely(*delta > (1ULL << 59) && !once++)) {
 		printk(KERN_WARNING "Delta way too big! %llu"
@@ -825,21 +979,38 @@ rb_add_time_stamp(struct ring_buffer_per
 				  RB_LEN_TIME_EXTEND,
 				  ts);
 	if (!event)
-		return -1;
+		return -EBUSY;
 
-	/* check to see if we went to the next page */
-	if (cpu_buffer->tail_page->write) {
-		/* Still on same page, update timestamp */
-		event->time_delta = *delta & TS_MASK;
-		event->array[0] = *delta >> TS_SHIFT;
-		/* commit the time event */
-		cpu_buffer->tail_page->write +=
-			rb_event_length(event);
+	if (PTR_ERR(event) == -EAGAIN)
+		return -EAGAIN;
+
+	/* Only a commited time event can update the write stamp */
+	if (rb_is_commit(cpu_buffer, event)) {
+		/*
+		 * If this is the first on the page, then we need to
+		 * update the page itself, and just put in a zero.
+		 */
+		if (rb_event_index(event)) {
+			event->time_delta = *delta & TS_MASK;
+			event->array[0] = *delta >> TS_SHIFT;
+		} else {
+			cpu_buffer->commit_page->time_stamp = *ts;
+			event->time_delta = 0;
+			event->array[0] = 0;
+		}
 		cpu_buffer->write_stamp = *ts;
-		*delta = 0;
+		/* let the caller know this was the commit */
+		ret = 1;
+	} else {
+		/* Darn, this is just wasted space */
+		event->time_delta = 0;
+		event->array[0] = 0;
+		ret = 0;
 	}
 
-	return 0;
+	*delta = 0;
+
+	return ret;
 }
 
 static struct ring_buffer_event *
@@ -848,32 +1019,69 @@ rb_reserve_next_event(struct ring_buffer
 {
 	struct ring_buffer_event *event;
 	u64 ts, delta;
+	int commit = 0;
 
+ again:
 	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
 
-	if (cpu_buffer->tail_page->write) {
+	/*
+	 * Only the first commit can update the timestamp.
+	 * Yes there is a race here. If an interrupt comes in
+	 * just after the conditional and it traces too, then it
+	 * will also check the deltas. More than one timestamp may
+	 * also be made. But only the entry that did the actual
+	 * commit will be something other than zero.
+	 */
+	if (cpu_buffer->tail_page == cpu_buffer->commit_page &&
+	    rb_page_write(cpu_buffer->tail_page) ==
+	    rb_commit_index(cpu_buffer)) {
+
 		delta = ts - cpu_buffer->write_stamp;
 
+		/* make sure this delta is calculated here */
+		barrier();
+
+		/* Did the write stamp get updated already? */
+		if (unlikely(ts < cpu_buffer->write_stamp))
+			goto again;
+
 		if (test_time_stamp(delta)) {
-			int ret;
 
-			ret = rb_add_time_stamp(cpu_buffer, &ts, &delta);
-			if (ret < 0)
+			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
+
+			if (commit == -EBUSY)
 				return NULL;
+
+			if (commit == -EAGAIN)
+				goto again;
+
+			RB_WARN_ON(cpu_buffer, commit < 0);
 		}
-	} else {
-		spin_lock(&cpu_buffer->lock);
-		rb_add_stamp(cpu_buffer, &ts);
-		spin_unlock(&cpu_buffer->lock);
+	} else
+		/* Non commits have zero deltas */
 		delta = 0;
-	}
 
 	event = __rb_reserve_next(cpu_buffer, type, length, &ts);
-	if (!event)
+	if (PTR_ERR(event) == -EAGAIN)
+		goto again;
+
+	if (!event) {
+		if (unlikely(commit))
+			/*
+			 * Ouch! We needed a timestamp and it was commited. But
+			 * we didn't get our event reserved.
+			 */
+			rb_set_commit_to_write(cpu_buffer);
 		return NULL;
+	}
 
-	/* If the reserve went to the next page, our delta is zero */
-	if (!cpu_buffer->tail_page->write)
+	/*
+	 * If the timestamp was commited, make the commit our entry
+	 * now so that we will update it when needed.
+	 */
+	if (commit)
+		rb_set_commit_event(cpu_buffer, event);
+	else if (!rb_is_commit(cpu_buffer, event))
 		delta = 0;
 
 	event->time_delta = delta;
@@ -881,6 +1089,8 @@ rb_reserve_next_event(struct ring_buffer
 	return event;
 }
 
+static DEFINE_PER_CPU(int, rb_need_resched);
+
 /**
  * ring_buffer_lock_reserve - reserve a part of the buffer
  * @buffer: the ring buffer to reserve from
@@ -904,12 +1114,15 @@ ring_buffer_lock_reserve(struct ring_buf
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
-	int cpu;
+	int cpu, resched;
 
 	if (atomic_read(&buffer->record_disabled))
 		return NULL;
 
-	local_irq_save(*flags);
+	/* If we are tracing schedule, we don't want to recurse */
+	resched = need_resched();
+	preempt_disable_notrace();
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpu_isset(cpu, buffer->cpumask))
@@ -922,26 +1135,42 @@ ring_buffer_lock_reserve(struct ring_buf
 
 	length = rb_calculate_event_length(length);
 	if (length > BUF_PAGE_SIZE)
-		return NULL;
+		goto out;
 
 	event = rb_reserve_next_event(cpu_buffer, RINGBUF_TYPE_DATA, length);
 	if (!event)
 		goto out;
 
+	/*
+	 * Need to store resched state on this cpu.
+	 * Only the first needs to.
+	 */
+
+	if (preempt_count() == 1)
+		per_cpu(rb_need_resched, cpu) = resched;
+
 	return event;
 
  out:
-	local_irq_restore(*flags);
+	if (resched)
+		preempt_enable_notrace();
+	else
+		preempt_enable_notrace();
 	return NULL;
 }
 
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
-	cpu_buffer->tail_page->write += rb_event_length(event);
-	cpu_buffer->tail_page->size = cpu_buffer->tail_page->write;
-	cpu_buffer->write_stamp += event->time_delta;
 	cpu_buffer->entries++;
+
+	/* Only process further if we own the commit */
+	if (!rb_is_commit(cpu_buffer, event))
+		return;
+
+	cpu_buffer->write_stamp += event->time_delta;
+
+	rb_set_commit_to_write(cpu_buffer);
 }
 
 /**
@@ -965,7 +1194,16 @@ int ring_buffer_unlock_commit(struct rin
 
 	rb_commit(cpu_buffer, event);
 
-	local_irq_restore(flags);
+	/*
+	 * Only the last preempt count needs to restore preemption.
+	 */
+	if (preempt_count() == 1) {
+		if (per_cpu(rb_need_resched, cpu))
+			preempt_enable_no_resched_notrace();
+		else
+			preempt_enable_notrace();
+	} else
+		preempt_enable_no_resched_notrace();
 
 	return 0;
 }
@@ -989,15 +1227,17 @@ int ring_buffer_write(struct ring_buffer
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
-	unsigned long event_length, flags;
+	unsigned long event_length;
 	void *body;
 	int ret = -EBUSY;
-	int cpu;
+	int cpu, resched;
 
 	if (atomic_read(&buffer->record_disabled))
 		return -EBUSY;
 
-	local_irq_save(flags);
+	resched = need_resched();
+	preempt_disable_notrace();
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpu_isset(cpu, buffer->cpumask))
@@ -1022,11 +1262,26 @@ int ring_buffer_write(struct ring_buffer
 
 	ret = 0;
  out:
-	local_irq_restore(flags);
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
 
 	return ret;
 }
 
+static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *reader = cpu_buffer->reader_page;
+	struct buffer_page *head = cpu_buffer->head_page;
+	struct buffer_page *commit = cpu_buffer->commit_page;
+
+	return reader->read == rb_page_commit(reader) &&
+		(commit == reader ||
+		 (commit == head &&
+		  head->read == rb_page_commit(commit)));
+}
+
 /**
  * ring_buffer_record_disable - stop all writes into the buffer
  * @buffer: The ring buffer to stop writes to.
@@ -1204,8 +1459,8 @@ int ring_buffer_iter_empty(struct ring_b
 
 	cpu_buffer = iter->cpu_buffer;
 
-	return iter->head_page == cpu_buffer->tail_page &&
-		iter->head == cpu_buffer->tail_page->write;
+	return iter->head_page == cpu_buffer->commit_page &&
+		iter->head == rb_commit_index(cpu_buffer);
 }
 
 static void
@@ -1282,15 +1537,16 @@ rb_get_reader_page(struct ring_buffer_pe
 	reader = cpu_buffer->reader_page;
 
 	/* If there's more to read, return this page */
-	if (cpu_buffer->reader_page->read < reader->size)
+	if (cpu_buffer->reader_page->read < rb_page_size(reader))
 		goto out;
 
 	/* Never should we have an index greater than the size */
-	WARN_ON(cpu_buffer->reader_page->read > reader->size);
+	RB_WARN_ON(cpu_buffer,
+		   cpu_buffer->reader_page->read > rb_page_size(reader));
 
 	/* check if we caught up to the tail */
 	reader = NULL;
-	if (cpu_buffer->tail_page == cpu_buffer->reader_page)
+	if (cpu_buffer->commit_page == cpu_buffer->reader_page)
 		goto out;
 
 	/*
@@ -1301,7 +1557,9 @@ rb_get_reader_page(struct ring_buffer_pe
 	reader = cpu_buffer->head_page;
 	cpu_buffer->reader_page->list.next = reader->list.next;
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
-	cpu_buffer->reader_page->size = 0;
+
+	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->commit, 0);
 
 	/* Make the reader page now replace the head */
 	reader->list.prev->next = &cpu_buffer->reader_page->list;
@@ -1313,7 +1571,7 @@ rb_get_reader_page(struct ring_buffer_pe
 	 */
 	cpu_buffer->head_page = cpu_buffer->reader_page;
 
-	if (cpu_buffer->tail_page != reader)
+	if (cpu_buffer->commit_page != reader)
 		rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
 
 	/* Finally update the reader page to the new head */
@@ -1363,8 +1621,8 @@ static void rb_advance_iter(struct ring_
 	/*
 	 * Check if we are at the end of the buffer.
 	 */
-	if (iter->head >= iter->head_page->size) {
-		BUG_ON(iter->head_page == cpu_buffer->tail_page);
+	if (iter->head >= rb_page_size(iter->head_page)) {
+		BUG_ON(iter->head_page == cpu_buffer->commit_page);
 		rb_inc_iter(iter);
 		return;
 	}
@@ -1377,16 +1635,16 @@ static void rb_advance_iter(struct ring_
 	 * This should not be called to advance the header if we are
 	 * at the tail of the buffer.
 	 */
-	BUG_ON((iter->head_page == cpu_buffer->tail_page) &&
-	       (iter->head + length > cpu_buffer->tail_page->write));
+	BUG_ON((iter->head_page == cpu_buffer->commit_page) &&
+	       (iter->head + length > rb_commit_index(cpu_buffer)));
 
 	rb_update_iter_read_stamp(iter, event);
 
 	iter->head += length;
 
 	/* check for end of page padding */
-	if ((iter->head >= iter->head_page->size) &&
-	    (iter->head_page != cpu_buffer->tail_page))
+	if ((iter->head >= rb_page_size(iter->head_page)) &&
+	    (iter->head_page != cpu_buffer->commit_page))
 		rb_advance_iter(iter);
 }
 
@@ -1420,7 +1678,7 @@ ring_buffer_peek(struct ring_buffer *buf
 
 	switch (event->type) {
 	case RINGBUF_TYPE_PADDING:
-		WARN_ON(1);
+		RB_WARN_ON(cpu_buffer, 1);
 		rb_advance_reader(cpu_buffer);
 		return NULL;
 
@@ -1622,14 +1880,17 @@ rb_reset_cpu(struct ring_buffer_per_cpu 
 {
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
-	cpu_buffer->head_page->size = 0;
-	cpu_buffer->tail_page = cpu_buffer->head_page;
-	cpu_buffer->tail_page->size = 0;
-	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
-	cpu_buffer->reader_page->size = 0;
+	local_set(&cpu_buffer->head_page->write, 0);
+	local_set(&cpu_buffer->head_page->commit, 0);
 
 	cpu_buffer->head_page->read = 0;
-	cpu_buffer->tail_page->write = 0;
+
+	cpu_buffer->tail_page = cpu_buffer->head_page;
+	cpu_buffer->commit_page = cpu_buffer->head_page;
+
+	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
 	cpu_buffer->overrun = 0;

-- 
