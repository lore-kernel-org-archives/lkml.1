Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZEFEZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZEFEZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZEFEXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZEFEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:34 -0400
Message-Id: <20090506042334.036756181@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/11] ring-buffer: have read page swap increment counter with page entries
Content-Disposition: inline; filename=0006-ring-buffer-have-read-page-swap-increment-counter-w.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In the swap page ring buffer code that is used by the ftrace splice code,
we scan the page to increment the counter of entries read.

With the number of entries already in the page we simply need to add it.

[ Impact: speed up reading page from ring buffer ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   28 +++-------------------------
 1 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 342eacc..9e42a74 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2785,28 +2785,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
 
-static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
-			      struct buffer_data_page *bpage,
-			      unsigned int offset)
-{
-	struct ring_buffer_event *event;
-	unsigned long head;
-
-	__raw_spin_lock(&cpu_buffer->lock);
-	for (head = offset; head < local_read(&bpage->commit);
-	     head += rb_event_length(event)) {
-
-		event = __rb_data_page_index(bpage, head);
-		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
-			return;
-		/* Only count data entries */
-		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
-			continue;
-		cpu_buffer->read++;
-	}
-	__raw_spin_unlock(&cpu_buffer->lock);
-}
-
 /**
  * ring_buffer_alloc_read_page - allocate a page to read from buffer
  * @buffer: the buffer to allocate for.
@@ -2977,6 +2955,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		/* we copied everything to the beginning */
 		read = 0;
 	} else {
+		/* update the entry counter */
+		cpu_buffer->read += local_read(&reader->entries);
+
 		/* swap the pages */
 		rb_init_page(bpage);
 		bpage = reader->page;
@@ -2985,9 +2966,6 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		local_set(&reader->entries, 0);
 		reader->read = 0;
 		*data_page = bpage;
-
-		/* update the entry counter */
-		rb_remove_entries(cpu_buffer, bpage, read);
 	}
 	ret = read;
 
-- 
1.6.2.4

-- 
