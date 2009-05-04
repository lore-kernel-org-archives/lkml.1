Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbZEDPVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbZEDPVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbZEDPUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:20:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZEDPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:20:21 -0400
Message-Id: <20090504152021.060513657@goodmis.org>
References: <20090504151933.728781787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 04 May 2009 11:19:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/6] ring-buffer: have read page swap increment counter with page entries
Content-Disposition: inline; filename=0005-ring-buffer-have-read-page-swap-increment-counter-w.patch
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
index 18e87b5..7ff1f57 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2784,28 +2784,6 @@ out:
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
@@ -2974,6 +2952,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		/* we copied everything to the beginning */
 		read = 0;
 	} else {
+		/* update the entry counter */
+		cpu_buffer->read += local_read(&reader->entries);
+
 		/* swap the pages */
 		rb_init_page(bpage);
 		bpage = reader->page;
@@ -2982,9 +2963,6 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
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
