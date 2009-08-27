Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZH0DDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZH0DDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZH0DDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:03:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53997 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbZH0DDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:03:32 -0400
Message-ID: <4A95F743.2090101@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 11:02:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing: make splice_read work when data is sufficient
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If a cpu ring_buffer has some pages which can be consumed,
but when a piece of the reader page is consumed, splice_read()
on per_cpu/cpu#/trace_pipe_raw will read nothing.

It's a incorrect behavior. A usespace tool which uses
splice_read() can't work when this situation occurs.

This patch changes the meaning of "full". It's not required
the reader page is full with data. It's just required
the reader page is full written/full committed.

So when a piece of data is consumed, the splice_read()
still works.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index da2c59d..f1e1533 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2782,7 +2782,7 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 }
 
 static struct buffer_page *
-rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
+rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer, int full)
 {
 	struct buffer_page *reader = NULL;
 	unsigned long flags;
@@ -2799,20 +2799,20 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * a case where we will loop three times. There should be no
 	 * reason to loop four times (that I know of).
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 3)) {
-		reader = NULL;
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 3))
+		goto out;
+
+	if (full && cpu_buffer->commit_page == cpu_buffer->reader_page)
 		goto out;
-	}
 
 	reader = cpu_buffer->reader_page;
 
 	/* If there's more to read, return this page */
-	if (cpu_buffer->reader_page->read < rb_page_size(reader))
+	if (reader->read < rb_page_size(reader))
 		goto out;
 
 	/* Never should we have an index greater than the size */
-	if (RB_WARN_ON(cpu_buffer,
-		       cpu_buffer->reader_page->read > rb_page_size(reader)))
+	if (RB_WARN_ON(cpu_buffer, reader->read > rb_page_size(reader)))
 		goto out;
 
 	/* check if we caught up to the tail */
@@ -2823,6 +2823,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	/*
 	 * Reset the reader page to size zero.
 	 */
+	cpu_buffer->reader_page->read = 0;
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
@@ -2832,6 +2833,11 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
+	if (full && cpu_buffer->commit_page == reader) {
+		reader = NULL;
+		goto out;
+	}
+
 	cpu_buffer->reader_page->list.next = reader->list.next;
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
@@ -2891,7 +2897,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 	struct buffer_page *reader;
 	unsigned length;
 
-	reader = rb_get_reader_page(cpu_buffer);
+	reader = rb_get_reader_page(cpu_buffer, 0);
 
 	/* This function should not be called when buffer is empty */
 	if (RB_WARN_ON(cpu_buffer, !reader))
@@ -2973,7 +2979,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > RB_TIMESTAMPS_PER_PAGE))
 		return NULL;
 
-	reader = rb_get_reader_page(cpu_buffer);
+	reader = rb_get_reader_page(cpu_buffer, 0);
 	if (!reader)
 		return NULL;
 
@@ -3642,7 +3648,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
-	reader = rb_get_reader_page(cpu_buffer);
+	reader = rb_get_reader_page(cpu_buffer, full);
 	if (!reader)
 		goto out_unlock;
 
@@ -3665,9 +3671,6 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		unsigned int pos = 0;
 		unsigned int size;
 
-		if (full)
-			goto out_unlock;
-
 		if (len > (commit - read))
 			len = (commit - read);
 





