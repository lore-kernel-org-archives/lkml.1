Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbZEGDQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbZEGDQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbZEGDOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:14:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55256 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZEGDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:14:34 -0400
Message-Id: <20090507031434.018038090@goodmis.org>
References: <20090507031335.815354104@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 23:13:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] ring-buffer: make moving the tail page a separate function
Content-Disposition: inline; filename=0003-ring-buffer-make-moving-the-tail-page-a-separate-fu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Ingo Molnar thought the code would be cleaner if we used a function call
instead of a goto for moving the tail page. After implementing this,
it seems that gcc still inlines the result and the output is pretty much
the same. Since this is considered a cleaner approach, might as well
implement it.

[ Impact: code clean up ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   89 ++++++++++++++++++++++++--------------------
 1 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 03ed52b..3ae5ccf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1154,51 +1154,18 @@ static unsigned rb_calculate_event_length(unsigned length)
 	return length;
 }
 
+
 static struct ring_buffer_event *
-__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
-		  unsigned type, unsigned long length, u64 *ts)
+rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
+	     unsigned long length, unsigned long tail,
+	     struct buffer_page *commit_page,
+	     struct buffer_page *tail_page, u64 *ts)
 {
-	struct buffer_page *tail_page, *head_page, *reader_page, *commit_page;
-	struct buffer_page *next_page;
-	unsigned long tail, write;
+	struct buffer_page *next_page, *head_page, *reader_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_event *event;
-	unsigned long flags;
 	bool lock_taken = false;
-
-	commit_page = cpu_buffer->commit_page;
-	/* we just need to protect against interrupts */
-	barrier();
-	tail_page = cpu_buffer->tail_page;
-	write = local_add_return(length, &tail_page->write);
-	tail = write - length;
-
-	/* See if we shot pass the end of this buffer page */
-	if (write > BUF_PAGE_SIZE)
-		goto next_page;
-
-	/* We reserved something on the buffer */
-
-	if (RB_WARN_ON(cpu_buffer, write > BUF_PAGE_SIZE))
-		return NULL;
-
-	event = __rb_page_index(tail_page, tail);
-	rb_update_event(event, type, length);
-
-	/* The passed in type is zero for DATA */
-	if (likely(!type))
-		local_inc(&tail_page->entries);
-
-	/*
-	 * If this is a commit and the tail is zero, then update
-	 * this page's time stamp.
-	 */
-	if (!tail && rb_is_commit(cpu_buffer, event))
-		cpu_buffer->commit_page->page->time_stamp = *ts;
-
-	return event;
-
- next_page:
+	unsigned long flags;
 
 	next_page = tail_page;
 
@@ -1318,6 +1285,48 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	return NULL;
 }
 
+static struct ring_buffer_event *
+__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
+		  unsigned type, unsigned long length, u64 *ts)
+{
+	struct buffer_page *tail_page, *commit_page;
+	struct ring_buffer_event *event;
+	unsigned long tail, write;
+
+	commit_page = cpu_buffer->commit_page;
+	/* we just need to protect against interrupts */
+	barrier();
+	tail_page = cpu_buffer->tail_page;
+	write = local_add_return(length, &tail_page->write);
+	tail = write - length;
+
+	/* See if we shot pass the end of this buffer page */
+	if (write > BUF_PAGE_SIZE)
+		return rb_move_tail(cpu_buffer, length, tail,
+				    commit_page, tail_page, ts);
+
+	/* We reserved something on the buffer */
+
+	if (RB_WARN_ON(cpu_buffer, write > BUF_PAGE_SIZE))
+		return NULL;
+
+	event = __rb_page_index(tail_page, tail);
+	rb_update_event(event, type, length);
+
+	/* The passed in type is zero for DATA */
+	if (likely(!type))
+		local_inc(&tail_page->entries);
+
+	/*
+	 * If this is a commit and the tail is zero, then update
+	 * this page's time stamp.
+	 */
+	if (!tail && rb_is_commit(cpu_buffer, event))
+		cpu_buffer->commit_page->page->time_stamp = *ts;
+
+	return event;
+}
+
 static int
 rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		  u64 *ts, u64 *delta)
-- 
1.6.2.4

-- 
