Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYKKEMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYKKEMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYKKEMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:12:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYKKEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:12:11 -0500
Message-Id: <20081111041209.104332033@goodmis.org>
References: <20081111041114.360885196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Nov 2008 23:11:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ring-buffer: replace most bug ons with warn on and disable buffer
Content-Disposition: inline; filename=0002-ring-buffer-replace-most-bug-ons-with-warn-on-and-d.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces most of the BUG_ONs in the ring_buffer code with
RB_WARN_ON variants. It adds some more variants as needed for the
replacement. This lets the buffer die nicely and still warn the user.

One BUG_ON remains in the code, and that is because it detects a
bad pointer passed in by the calling function, and not a bug by
the ring buffer code itself.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   65 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ee9b93d..a6b8f9d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -188,6 +188,7 @@ struct ring_buffer_iter {
 	u64				read_stamp;
 };
 
+/* buffer may be either ring_buffer or ring_buffer_per_cpu */
 #define RB_WARN_ON(buffer, cond)				\
 	do {							\
 		if (unlikely(cond)) {				\
@@ -201,10 +202,28 @@ struct ring_buffer_iter {
 		if (unlikely(cond)) {				\
 			atomic_inc(&buffer->record_disabled);	\
 			WARN_ON(1);				\
+			return;					\
+		}						\
+	} while (0)
+
+#define RB_WARN_ON_RET_INT(buffer, cond)			\
+	do {							\
+		if (unlikely(cond)) {				\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
 			return -1;				\
 		}						\
 	} while (0)
 
+#define RB_WARN_ON_RET_NULL(buffer, cond)			\
+	do {							\
+		if (unlikely(cond)) {				\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
+			return NULL;				\
+		}						\
+	} while (0)
+
 #define RB_WARN_ON_ONCE(buffer, cond)				\
 	do {							\
 		static int once;				\
@@ -215,6 +234,17 @@ struct ring_buffer_iter {
 		}						\
 	} while (0)
 
+/* buffer must be ring_buffer not per_cpu */
+#define RB_WARN_ON_UNLOCK(buffer, cond)				\
+	do {							\
+		if (unlikely(cond)) {				\
+			mutex_unlock(&buffer->mutex);		\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
+			return -1;				\
+		}						\
+	} while (0)
+
 /**
  * check_pages - integrity check of buffer pages
  * @cpu_buffer: CPU buffer with pages to test
@@ -227,13 +257,13 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 	struct list_head *head = &cpu_buffer->pages;
 	struct buffer_page *page, *tmp;
 
-	RB_WARN_ON_RET(cpu_buffer, head->next->prev != head);
-	RB_WARN_ON_RET(cpu_buffer, head->prev->next != head);
+	RB_WARN_ON_RET_INT(cpu_buffer, head->next->prev != head);
+	RB_WARN_ON_RET_INT(cpu_buffer, head->prev->next != head);
 
 	list_for_each_entry_safe(page, tmp, head, list) {
-		RB_WARN_ON_RET(cpu_buffer,
+		RB_WARN_ON_RET_INT(cpu_buffer,
 			       page->list.next->prev != &page->list);
-		RB_WARN_ON_RET(cpu_buffer,
+		RB_WARN_ON_RET_INT(cpu_buffer,
 			       page->list.prev->next != &page->list);
 	}
 
@@ -440,13 +470,13 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	synchronize_sched();
 
 	for (i = 0; i < nr_pages; i++) {
-		BUG_ON(list_empty(&cpu_buffer->pages));
+		RB_WARN_ON_RET(cpu_buffer, list_empty(&cpu_buffer->pages));
 		p = cpu_buffer->pages.next;
 		page = list_entry(p, struct buffer_page, list);
 		list_del_init(&page->list);
 		free_buffer_page(page);
 	}
-	BUG_ON(list_empty(&cpu_buffer->pages));
+	RB_WARN_ON_RET(cpu_buffer, list_empty(&cpu_buffer->pages));
 
 	rb_reset_cpu(cpu_buffer);
 
@@ -468,7 +498,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	synchronize_sched();
 
 	for (i = 0; i < nr_pages; i++) {
-		BUG_ON(list_empty(pages));
+		RB_WARN_ON_RET(cpu_buffer, list_empty(pages));
 		p = pages->next;
 		page = list_entry(p, struct buffer_page, list);
 		list_del_init(&page->list);
@@ -523,7 +553,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	if (size < buffer_size) {
 
 		/* easy case, just free pages */
-		BUG_ON(nr_pages >= buffer->pages);
+		RB_WARN_ON_UNLOCK(buffer, nr_pages >= buffer->pages);
 
 		rm_pages = buffer->pages - nr_pages;
 
@@ -542,7 +572,8 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	 * add these pages to the cpu_buffers. Otherwise we just free
 	 * them all and return -ENOMEM;
 	 */
-	BUG_ON(nr_pages <= buffer->pages);
+	RB_WARN_ON_UNLOCK(buffer, nr_pages <= buffer->pages);
+
 	new_pages = nr_pages - buffer->pages;
 
 	for_each_buffer_cpu(buffer, cpu) {
@@ -565,7 +596,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 		rb_insert_pages(cpu_buffer, &pages, new_pages);
 	}
 
-	BUG_ON(!list_empty(&pages));
+	RB_WARN_ON_UNLOCK(buffer, !list_empty(&pages));
 
  out:
 	buffer->pages = nr_pages;
@@ -653,7 +684,7 @@ static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
 	     head += rb_event_length(event)) {
 
 		event = __rb_page_index(cpu_buffer->head_page, head);
-		BUG_ON(rb_null_event(event));
+		RB_WARN_ON_RET(cpu_buffer, rb_null_event(event));
 		/* Only count data entries */
 		if (event->type != RINGBUF_TYPE_DATA)
 			continue;
@@ -940,7 +971,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 	/* We reserved something on the buffer */
 
-	BUG_ON(write > BUF_PAGE_SIZE);
+	RB_WARN_ON_RET_NULL(cpu_buffer, write > BUF_PAGE_SIZE);
 
 	event = __rb_page_index(tail_page, tail);
 	rb_update_event(event, type, length);
@@ -1621,7 +1652,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 	reader = rb_get_reader_page(cpu_buffer);
 
 	/* This function should not be called when buffer is empty */
-	BUG_ON(!reader);
+	RB_WARN_ON_RET(cpu_buffer, !reader);
 
 	event = rb_reader_event(cpu_buffer);
 
@@ -1648,7 +1679,8 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 	 * Check if we are at the end of the buffer.
 	 */
 	if (iter->head >= rb_page_size(iter->head_page)) {
-		BUG_ON(iter->head_page == cpu_buffer->commit_page);
+		RB_WARN_ON_RET(buffer,
+			       iter->head_page == cpu_buffer->commit_page);
 		rb_inc_iter(iter);
 		return;
 	}
@@ -1661,8 +1693,9 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 	 * This should not be called to advance the header if we are
 	 * at the tail of the buffer.
 	 */
-	BUG_ON((iter->head_page == cpu_buffer->commit_page) &&
-	       (iter->head + length > rb_commit_index(cpu_buffer)));
+	RB_WARN_ON_RET(cpu_buffer,
+		       (iter->head_page == cpu_buffer->commit_page) &&
+		       (iter->head + length > rb_commit_index(cpu_buffer)));
 
 	rb_update_iter_read_stamp(iter, event);
 
-- 
1.5.6.5

-- 
