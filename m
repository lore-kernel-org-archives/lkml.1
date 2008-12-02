Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYLBUfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYLBUfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYLBUea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:34:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63411 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYLBUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:34:27 -0500
Message-Id: <20081202203424.839099180@goodmis.org>
References: <20081202203404.496794864@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:34:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] ring-buffer: move some metadata into buffer page
Content-Disposition: inline; filename=0002-ring-buffer-move-some-metadata-into-buffer-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: get ready for splice changes

This patch moves the commit and timestamp into the beginning of each
data page of the buffer. This change will allow the page to be moved
to another location (disk, network, etc) and still have information
in the page to be able to read it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   63 +++++++++++++++++++++++++-------------------
 1 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e206951..8619c53 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -195,20 +195,24 @@ void *ring_buffer_event_data(struct ring_buffer_event *event)
 #define TS_MASK		((1ULL << TS_SHIFT) - 1)
 #define TS_DELTA_TEST	(~TS_MASK)
 
-/*
- * This hack stolen from mm/slob.c.
- * We can store per page timing information in the page frame of the page.
- * Thanks to Peter Zijlstra for suggesting this idea.
- */
-struct buffer_page {
+struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
-	local_t		 write;		/* index for next write */
 	local_t		 commit;	/* write commited index */
+	unsigned char	 data[];	/* data of buffer page */
+};
+
+struct buffer_page {
+	local_t		 write;		/* index for next write */
 	unsigned	 read;		/* index for next read */
 	struct list_head list;		/* list of free pages */
-	void *page;			/* Actual data page */
+	struct buffer_data_page *page;	/* Actual data page */
 };
 
+static void rb_init_page(struct buffer_data_page *page)
+{
+	local_set(&page->commit, 0);
+}
+
 /*
  * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
  * this issue out.
@@ -230,7 +234,7 @@ static inline int test_time_stamp(u64 delta)
 	return 0;
 }
 
-#define BUF_PAGE_SIZE PAGE_SIZE
+#define BUF_PAGE_SIZE (PAGE_SIZE - sizeof(struct buffer_data_page))
 
 /*
  * head_page == tail_page && head == tail then buffer is empty.
@@ -333,6 +337,7 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		if (!addr)
 			goto free_pages;
 		page->page = (void *)addr;
+		rb_init_page(page->page);
 	}
 
 	list_splice(&pages, head);
@@ -378,6 +383,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	if (!addr)
 		goto fail_free_reader;
 	page->page = (void *)addr;
+	rb_init_page(page->page);
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 
@@ -647,6 +653,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 			if (!addr)
 				goto free_pages;
 			page->page = (void *)addr;
+			rb_init_page(page->page);
 		}
 	}
 
@@ -682,7 +689,7 @@ static inline int rb_null_event(struct ring_buffer_event *event)
 
 static inline void *__rb_page_index(struct buffer_page *page, unsigned index)
 {
-	return page->page + index;
+	return page->page->data + index;
 }
 
 static inline struct ring_buffer_event *
@@ -712,7 +719,7 @@ static inline unsigned rb_page_write(struct buffer_page *bpage)
 
 static inline unsigned rb_page_commit(struct buffer_page *bpage)
 {
-	return local_read(&bpage->commit);
+	return local_read(&bpage->page->commit);
 }
 
 /* Size is determined by what has been commited */
@@ -804,14 +811,15 @@ rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
 		if (RB_WARN_ON(cpu_buffer,
 			  cpu_buffer->commit_page == cpu_buffer->tail_page))
 			return;
-		cpu_buffer->commit_page->commit =
+		cpu_buffer->commit_page->page->commit =
 			cpu_buffer->commit_page->write;
 		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
-		cpu_buffer->write_stamp = cpu_buffer->commit_page->time_stamp;
+		cpu_buffer->write_stamp =
+			cpu_buffer->commit_page->page->time_stamp;
 	}
 
 	/* Now set the commit to the event's index */
-	local_set(&cpu_buffer->commit_page->commit, index);
+	local_set(&cpu_buffer->commit_page->page->commit, index);
 }
 
 static inline void
@@ -826,16 +834,17 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	 * assign the commit to the tail.
 	 */
 	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
-		cpu_buffer->commit_page->commit =
+		cpu_buffer->commit_page->page->commit =
 			cpu_buffer->commit_page->write;
 		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
-		cpu_buffer->write_stamp = cpu_buffer->commit_page->time_stamp;
+		cpu_buffer->write_stamp =
+			cpu_buffer->commit_page->page->time_stamp;
 		/* add barrier to keep gcc from optimizing too much */
 		barrier();
 	}
 	while (rb_commit_index(cpu_buffer) !=
 	       rb_page_write(cpu_buffer->commit_page)) {
-		cpu_buffer->commit_page->commit =
+		cpu_buffer->commit_page->page->commit =
 			cpu_buffer->commit_page->write;
 		barrier();
 	}
@@ -843,7 +852,7 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 
 static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	cpu_buffer->read_stamp = cpu_buffer->reader_page->time_stamp;
+	cpu_buffer->read_stamp = cpu_buffer->reader_page->page->time_stamp;
 	cpu_buffer->reader_page->read = 0;
 }
 
@@ -862,7 +871,7 @@ static inline void rb_inc_iter(struct ring_buffer_iter *iter)
 	else
 		rb_inc_page(cpu_buffer, &iter->head_page);
 
-	iter->read_stamp = iter->head_page->time_stamp;
+	iter->read_stamp = iter->head_page->page->time_stamp;
 	iter->head = 0;
 }
 
@@ -998,12 +1007,12 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		if (tail_page == cpu_buffer->tail_page) {
 			local_set(&next_page->write, 0);
-			local_set(&next_page->commit, 0);
+			local_set(&next_page->page->commit, 0);
 			cpu_buffer->tail_page = next_page;
 
 			/* reread the time stamp */
 			*ts = ring_buffer_time_stamp(cpu_buffer->cpu);
-			cpu_buffer->tail_page->time_stamp = *ts;
+			cpu_buffer->tail_page->page->time_stamp = *ts;
 		}
 
 		/*
@@ -1048,7 +1057,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	 * this page's time stamp.
 	 */
 	if (!tail && rb_is_commit(cpu_buffer, event))
-		cpu_buffer->commit_page->time_stamp = *ts;
+		cpu_buffer->commit_page->page->time_stamp = *ts;
 
 	return event;
 
@@ -1099,7 +1108,7 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 			event->time_delta = *delta & TS_MASK;
 			event->array[0] = *delta >> TS_SHIFT;
 		} else {
-			cpu_buffer->commit_page->time_stamp = *ts;
+			cpu_buffer->commit_page->page->time_stamp = *ts;
 			event->time_delta = 0;
 			event->array[0] = 0;
 		}
@@ -1552,7 +1561,7 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
 	if (iter->head)
 		iter->read_stamp = cpu_buffer->read_stamp;
 	else
-		iter->read_stamp = iter->head_page->time_stamp;
+		iter->read_stamp = iter->head_page->page->time_stamp;
 }
 
 /**
@@ -1696,7 +1705,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
 	local_set(&cpu_buffer->reader_page->write, 0);
-	local_set(&cpu_buffer->reader_page->commit, 0);
+	local_set(&cpu_buffer->reader_page->page->commit, 0);
 
 	/* Make the reader page now replace the head */
 	reader->list.prev->next = &cpu_buffer->reader_page->list;
@@ -2088,7 +2097,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
 	local_set(&cpu_buffer->head_page->write, 0);
-	local_set(&cpu_buffer->head_page->commit, 0);
+	local_set(&cpu_buffer->head_page->page->commit, 0);
 
 	cpu_buffer->head_page->read = 0;
 
@@ -2097,7 +2106,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 	local_set(&cpu_buffer->reader_page->write, 0);
-	local_set(&cpu_buffer->reader_page->commit, 0);
+	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
 	cpu_buffer->overrun = 0;
-- 
1.5.6.5

-- 
