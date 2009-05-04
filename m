Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbZEDPW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbZEDPW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZEDPU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:20:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZEDPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:20:21 -0400
Message-Id: <20090504152020.762521195@goodmis.org>
References: <20090504151933.728781787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 04 May 2009 11:19:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/6] ring-buffer: record page entries in buffer page descriptor
Content-Disposition: inline; filename=0004-ring-buffer-record-page-entries-in-buffer-page-desc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, when the ring buffer writer overflows the buffer and must
write over non consumed data, we increment the overrun counter by
reading the entries on the page we are about to overwrite. This reads
the entries one by one.

This is not very effecient. This patch adds another entry counter
into each buffer page descriptor that keeps track of the number of
entries on the page. Now on overwrite, the overrun counter simply
needs to add the number of entries that is on the page it is about
to overwrite.

[ Impact: speed up of ring buffer in overwrite mode ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   39 +++++++++++++--------------------------
 1 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f2d56e9..18e87b5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -321,9 +321,10 @@ struct buffer_data_page {
 };
 
 struct buffer_page {
+	struct list_head list;		/* list of buffer pages */
 	local_t		 write;		/* index for next write */
 	unsigned	 read;		/* index for next read */
-	struct list_head list;		/* list of free pages */
+	local_t		 entries;	/* entries on this page */
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
@@ -977,30 +978,6 @@ static inline unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
 	return rb_page_commit(cpu_buffer->head_page);
 }
 
-/*
- * When the tail hits the head and the buffer is in overwrite mode,
- * the head jumps to the next page and all content on the previous
- * page is discarded. But before doing so, we update the overrun
- * variable of the buffer.
- */
-static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	struct ring_buffer_event *event;
-	unsigned long head;
-
-	for (head = 0; head < rb_head_size(cpu_buffer);
-	     head += rb_event_length(event)) {
-
-		event = __rb_page_index(cpu_buffer->head_page, head);
-		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
-			return;
-		/* Only count data entries */
-		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
-			continue;
-		cpu_buffer->overrun++;
-	}
-}
-
 static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
 			       struct buffer_page **bpage)
 {
@@ -1253,7 +1230,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 			/* tail_page has not moved yet? */
 			if (tail_page == cpu_buffer->tail_page) {
 				/* count overflows */
-				rb_update_overflow(cpu_buffer);
+				cpu_buffer->overrun +=
+					local_read(&head_page->entries);
 
 				rb_inc_page(cpu_buffer, &head_page);
 				cpu_buffer->head_page = head_page;
@@ -1268,6 +1246,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		if (tail_page == cpu_buffer->tail_page) {
 			local_set(&next_page->write, 0);
+			local_set(&next_page->entries, 0);
 			local_set(&next_page->page->commit, 0);
 			cpu_buffer->tail_page = next_page;
 
@@ -1313,6 +1292,10 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	event = __rb_page_index(tail_page, tail);
 	rb_update_event(event, type, length);
 
+	/* The passed in type is zero for DATA */
+	if (likely(!type))
+		local_inc(&tail_page->entries);
+
 	/*
 	 * If this is a commit and the tail is zero, then update
 	 * this page's time stamp.
@@ -2182,6 +2165,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
 	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 
 	/* Make the reader page now replace the head */
@@ -2628,6 +2612,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
 	local_set(&cpu_buffer->head_page->write, 0);
+	local_set(&cpu_buffer->head_page->entries, 0);
 	local_set(&cpu_buffer->head_page->page->commit, 0);
 
 	cpu_buffer->head_page->read = 0;
@@ -2637,6 +2622,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
@@ -2993,6 +2979,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		bpage = reader->page;
 		reader->page = *data_page;
 		local_set(&reader->write, 0);
+		local_set(&reader->entries, 0);
 		reader->read = 0;
 		*data_page = bpage;
 
-- 
1.6.2.4

-- 
