Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYKKUr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYKKUr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYKKUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:46:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYKKUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:46:34 -0500
Message-Id: <20081111204622.966918607@goodmis.org>
References: <20081111204555.890501283@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 11 Nov 2008 15:45:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ring-buffer: clean up warn ons
Content-Disposition: inline; filename=0003-ring-buffer-clean-up-warn-ons.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Restructure WARN_ONs in ring_buffer.c

The current WARN_ON macros in ring_buffer.c are quite ugly.

This patch cleans them up and uses a single RB_WARN_ON that returns
the value of the condition. This allows the caller to abort the
function if the condition is true.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |  143 +++++++++++++++++--------------------------
 1 files changed, 57 insertions(+), 86 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e3703b2..25d77f4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -218,60 +218,14 @@ struct ring_buffer_iter {
 
 /* buffer may be either ring_buffer or ring_buffer_per_cpu */
 #define RB_WARN_ON(buffer, cond)				\
-	do {							\
-		if (unlikely(cond)) {				\
+	({							\
+		int _____ret = unlikely(cond);			\
+		if (_____ret) {					\
 			atomic_inc(&buffer->record_disabled);	\
 			WARN_ON(1);				\
 		}						\
-	} while (0)
-
-#define RB_WARN_ON_RET(buffer, cond)				\
-	do {							\
-		if (unlikely(cond)) {				\
-			atomic_inc(&buffer->record_disabled);	\
-			WARN_ON(1);				\
-			return;					\
-		}						\
-	} while (0)
-
-#define RB_WARN_ON_RET_INT(buffer, cond)			\
-	do {							\
-		if (unlikely(cond)) {				\
-			atomic_inc(&buffer->record_disabled);	\
-			WARN_ON(1);				\
-			return -1;				\
-		}						\
-	} while (0)
-
-#define RB_WARN_ON_RET_NULL(buffer, cond)			\
-	do {							\
-		if (unlikely(cond)) {				\
-			atomic_inc(&buffer->record_disabled);	\
-			WARN_ON(1);				\
-			return NULL;				\
-		}						\
-	} while (0)
-
-#define RB_WARN_ON_ONCE(buffer, cond)				\
-	do {							\
-		static int once;				\
-		if (unlikely(cond) && !once) {			\
-			once++;					\
-			atomic_inc(&buffer->record_disabled);	\
-			WARN_ON(1);				\
-		}						\
-	} while (0)
-
-/* buffer must be ring_buffer not per_cpu */
-#define RB_WARN_ON_UNLOCK(buffer, cond)				\
-	do {							\
-		if (unlikely(cond)) {				\
-			mutex_unlock(&buffer->mutex);		\
-			atomic_inc(&buffer->record_disabled);	\
-			WARN_ON(1);				\
-			return -1;				\
-		}						\
-	} while (0)
+		_____ret;					\
+	})
 
 /**
  * check_pages - integrity check of buffer pages
@@ -285,14 +239,18 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 	struct list_head *head = &cpu_buffer->pages;
 	struct buffer_page *page, *tmp;
 
-	RB_WARN_ON_RET_INT(cpu_buffer, head->next->prev != head);
-	RB_WARN_ON_RET_INT(cpu_buffer, head->prev->next != head);
+	if (RB_WARN_ON(cpu_buffer, head->next->prev != head))
+		return -1;
+	if (RB_WARN_ON(cpu_buffer, head->prev->next != head))
+		return -1;
 
 	list_for_each_entry_safe(page, tmp, head, list) {
-		RB_WARN_ON_RET_INT(cpu_buffer,
-			       page->list.next->prev != &page->list);
-		RB_WARN_ON_RET_INT(cpu_buffer,
-			       page->list.prev->next != &page->list);
+		if (RB_WARN_ON(cpu_buffer,
+			       page->list.next->prev != &page->list))
+			return -1;
+		if (RB_WARN_ON(cpu_buffer,
+			       page->list.prev->next != &page->list))
+			return -1;
 	}
 
 	return 0;
@@ -499,13 +457,15 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	synchronize_sched();
 
 	for (i = 0; i < nr_pages; i++) {
-		RB_WARN_ON_RET(cpu_buffer, list_empty(&cpu_buffer->pages));
+		if (RB_WARN_ON(cpu_buffer, list_empty(&cpu_buffer->pages)))
+			return;
 		p = cpu_buffer->pages.next;
 		page = list_entry(p, struct buffer_page, list);
 		list_del_init(&page->list);
 		free_buffer_page(page);
 	}
-	RB_WARN_ON_RET(cpu_buffer, list_empty(&cpu_buffer->pages));
+	if (RB_WARN_ON(cpu_buffer, list_empty(&cpu_buffer->pages)))
+		return;
 
 	rb_reset_cpu(cpu_buffer);
 
@@ -527,7 +487,8 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	synchronize_sched();
 
 	for (i = 0; i < nr_pages; i++) {
-		RB_WARN_ON_RET(cpu_buffer, list_empty(pages));
+		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
+			return;
 		p = pages->next;
 		page = list_entry(p, struct buffer_page, list);
 		list_del_init(&page->list);
@@ -582,7 +543,10 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	if (size < buffer_size) {
 
 		/* easy case, just free pages */
-		RB_WARN_ON_UNLOCK(buffer, nr_pages >= buffer->pages);
+		if (RB_WARN_ON(buffer, nr_pages >= buffer->pages)) {
+			mutex_unlock(&buffer->mutex);
+			return -1;
+		}
 
 		rm_pages = buffer->pages - nr_pages;
 
@@ -601,7 +565,10 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	 * add these pages to the cpu_buffers. Otherwise we just free
 	 * them all and return -ENOMEM;
 	 */
-	RB_WARN_ON_UNLOCK(buffer, nr_pages <= buffer->pages);
+	if (RB_WARN_ON(buffer, nr_pages <= buffer->pages)) {
+		mutex_unlock(&buffer->mutex);
+		return -1;
+	}
 
 	new_pages = nr_pages - buffer->pages;
 
@@ -625,7 +592,10 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 		rb_insert_pages(cpu_buffer, &pages, new_pages);
 	}
 
-	RB_WARN_ON_UNLOCK(buffer, !list_empty(&pages));
+	if (RB_WARN_ON(buffer, !list_empty(&pages))) {
+		mutex_unlock(&buffer->mutex);
+		return -1;
+	}
 
  out:
 	buffer->pages = nr_pages;
@@ -713,7 +683,8 @@ static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
 	     head += rb_event_length(event)) {
 
 		event = __rb_page_index(cpu_buffer->head_page, head);
-		RB_WARN_ON_RET(cpu_buffer, rb_null_event(event));
+		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
+			return;
 		/* Only count data entries */
 		if (event->type != RINGBUF_TYPE_DATA)
 			continue;
@@ -766,8 +737,9 @@ rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
 	addr &= PAGE_MASK;
 
 	while (cpu_buffer->commit_page->page != (void *)addr) {
-		RB_WARN_ON(cpu_buffer,
-			   cpu_buffer->commit_page == cpu_buffer->tail_page);
+		if (RB_WARN_ON(cpu_buffer,
+			  cpu_buffer->commit_page == cpu_buffer->tail_page))
+			return;
 		cpu_buffer->commit_page->commit =
 			cpu_buffer->commit_page->write;
 		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
@@ -923,7 +895,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		reader_page = cpu_buffer->reader_page;
 
 		/* we grabbed the lock before incrementing */
-		RB_WARN_ON(cpu_buffer, next_page == reader_page);
+		if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
+			goto out_unlock;
 
 		/*
 		 * If for some reason, we had an interrupt storm that made
@@ -1000,7 +973,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 	/* We reserved something on the buffer */
 
-	RB_WARN_ON_RET_NULL(cpu_buffer, write > BUF_PAGE_SIZE);
+	if (RB_WARN_ON(cpu_buffer, write > BUF_PAGE_SIZE))
+		return NULL;
 
 	event = __rb_page_index(tail_page, tail);
 	rb_update_event(event, type, length);
@@ -1099,10 +1073,8 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	 * storm or we have something buggy.
 	 * Bail!
 	 */
-	if (unlikely(++nr_loops > 1000)) {
-		RB_WARN_ON(cpu_buffer, 1);
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 1000))
 		return NULL;
-	}
 
 	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
 
@@ -1624,8 +1596,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * a case where we will loop three times. There should be no
 	 * reason to loop four times (that I know of).
 	 */
-	if (unlikely(++nr_loops > 3)) {
-		RB_WARN_ON(cpu_buffer, 1);
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 3)) {
 		reader = NULL;
 		goto out;
 	}
@@ -1637,8 +1608,9 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 		goto out;
 
 	/* Never should we have an index greater than the size */
-	RB_WARN_ON(cpu_buffer,
-		   cpu_buffer->reader_page->read > rb_page_size(reader));
+	if (RB_WARN_ON(cpu_buffer,
+		       cpu_buffer->reader_page->read > rb_page_size(reader)))
+		goto out;
 
 	/* check if we caught up to the tail */
 	reader = NULL;
@@ -1692,7 +1664,8 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 	reader = rb_get_reader_page(cpu_buffer);
 
 	/* This function should not be called when buffer is empty */
-	RB_WARN_ON_RET(cpu_buffer, !reader);
+	if (RB_WARN_ON(cpu_buffer, !reader))
+		return;
 
 	event = rb_reader_event(cpu_buffer);
 
@@ -1719,8 +1692,9 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 	 * Check if we are at the end of the buffer.
 	 */
 	if (iter->head >= rb_page_size(iter->head_page)) {
-		RB_WARN_ON_RET(buffer,
-			       iter->head_page == cpu_buffer->commit_page);
+		if (RB_WARN_ON(buffer,
+			       iter->head_page == cpu_buffer->commit_page))
+			return;
 		rb_inc_iter(iter);
 		return;
 	}
@@ -1733,9 +1707,10 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 	 * This should not be called to advance the header if we are
 	 * at the tail of the buffer.
 	 */
-	RB_WARN_ON_RET(cpu_buffer,
+	if (RB_WARN_ON(cpu_buffer,
 		       (iter->head_page == cpu_buffer->commit_page) &&
-		       (iter->head + length > rb_commit_index(cpu_buffer)));
+		       (iter->head + length > rb_commit_index(cpu_buffer))))
+		return;
 
 	rb_update_iter_read_stamp(iter, event);
 
@@ -1769,10 +1744,8 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	 * can have.  Nesting 10 deep of interrupts is clearly
 	 * an anomaly.
 	 */
-	if (unlikely(++nr_loops > 10)) {
-		RB_WARN_ON(cpu_buffer, 1);
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
 		return NULL;
-	}
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
@@ -1833,10 +1806,8 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	 * can have. Nesting 10 deep of interrupts is clearly
 	 * an anomaly.
 	 */
-	if (unlikely(++nr_loops > 10)) {
-		RB_WARN_ON(cpu_buffer, 1);
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
 		return NULL;
-	}
 
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
-- 
1.5.6.5

-- 
