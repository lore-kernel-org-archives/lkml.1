Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZCDCxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZCDCxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZCDCwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:52:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZCDCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:52:53 -0500
Message-Id: <20090304025250.358688432@goodmis.org>
References: <20090304024921.153061228@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 21:49:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] ring-buffer: fix ring_buffer_read_page
Content-Disposition: inline; filename=0002-ring-buffer-fix-ring_buffer_read_page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring_buffer_read_page was broken if it were to only copy part
of the page. This patch fixes that up as well as adds a parameter
to allow a length field, in order to only copy part of the buffer page.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    7 ++-
 kernel/trace/ring_buffer.c  |   92 +++++++++++++++++++++++++++---------------
 2 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index f5e793d..79fcbc4 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -121,6 +121,9 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 u64 ring_buffer_time_stamp(int cpu);
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
 
+size_t ring_buffer_page_len(void *page);
+
+
 /*
  * The below functions are fine to use outside the tracing facility.
  */
@@ -138,8 +141,8 @@ static inline int tracing_is_on(void) { return 0; }
 
 void *ring_buffer_alloc_read_page(struct ring_buffer *buffer);
 void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
-int ring_buffer_read_page(struct ring_buffer *buffer,
-			  void **data_page, int cpu, int full);
+int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
+			  size_t len, int cpu, int full);
 
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9baad7e..2ad6bae 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -234,6 +234,11 @@ static void rb_init_page(struct buffer_data_page *bpage)
 	local_set(&bpage->commit, 0);
 }
 
+size_t ring_buffer_page_len(void *page)
+{
+	return local_read(&((struct buffer_data_page *)page)->commit);
+}
+
 /*
  * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
  * this issue out.
@@ -2378,8 +2383,8 @@ static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
  */
 void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
 {
-	unsigned long addr;
 	struct buffer_data_page *bpage;
+	unsigned long addr;
 
 	addr = __get_free_page(GFP_KERNEL);
 	if (!addr)
@@ -2387,6 +2392,8 @@ void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
 
 	bpage = (void *)addr;
 
+	rb_init_page(bpage);
+
 	return bpage;
 }
 
@@ -2406,6 +2413,7 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
  * ring_buffer_read_page - extract a page from the ring buffer
  * @buffer: buffer to extract from
  * @data_page: the page to use allocated from ring_buffer_alloc_read_page
+ * @len: amount to extract
  * @cpu: the cpu of the buffer to extract
  * @full: should the extraction only happen when the page is full.
  *
@@ -2418,7 +2426,7 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
  *	rpage = ring_buffer_alloc_read_page(buffer);
  *	if (!rpage)
  *		return error;
- *	ret = ring_buffer_read_page(buffer, &rpage, cpu, 0);
+ *	ret = ring_buffer_read_page(buffer, &rpage, len, cpu, 0);
  *	if (ret >= 0)
  *		process_page(rpage, ret);
  *
@@ -2435,71 +2443,89 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
  *  <0 if no data has been transferred.
  */
 int ring_buffer_read_page(struct ring_buffer *buffer,
-			    void **data_page, int cpu, int full)
+			  void **data_page, size_t len, int cpu, int full)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
 	struct buffer_data_page *bpage;
+	struct buffer_page *reader;
 	unsigned long flags;
+	unsigned int commit;
 	unsigned int read;
 	int ret = -1;
 
 	if (!data_page)
-		return 0;
+		return -1;
 
 	bpage = *data_page;
 	if (!bpage)
-		return 0;
+		return -1;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
-	/*
-	 * rb_buffer_peek will get the next ring buffer if
-	 * the current reader page is empty.
-	 */
-	event = rb_buffer_peek(buffer, cpu, NULL);
-	if (!event)
+	reader = rb_get_reader_page(cpu_buffer);
+	if (!reader)
 		goto out;
 
-	/* check for data */
-	if (!local_read(&cpu_buffer->reader_page->page->commit))
-		goto out;
+	event = rb_reader_event(cpu_buffer);
+
+	read = reader->read;
+	commit = rb_page_commit(reader);
 
-	read = cpu_buffer->reader_page->read;
 	/*
-	 * If the writer is already off of the read page, then simply
-	 * switch the read page with the given page. Otherwise
-	 * we need to copy the data from the reader to the writer.
+	 * If len > what's left on the page, and the writer is also off of
+	 * the read page, then simply switch the read page with the given
+	 * page. Otherwise we need to copy the data from the reader to the
+	 * writer.
 	 */
-	if (cpu_buffer->reader_page == cpu_buffer->commit_page) {
-		unsigned int commit = rb_page_commit(cpu_buffer->reader_page);
+	if ((len < (commit - read)) ||
+	    cpu_buffer->reader_page == cpu_buffer->commit_page) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
+		unsigned int pos = read;
+		unsigned int size;
 
 		if (full)
 			goto out;
-		/* The writer is still on the reader page, we must copy */
-		memcpy(bpage->data + read, rpage->data + read, commit - read);
 
-		/* consume what was read */
-		cpu_buffer->reader_page->read = commit;
+		if (len > (commit - read))
+			len = (commit - read);
+
+		size = rb_event_length(event);
+
+		if (len < size)
+			goto out;
+
+		/* Need to copy one event at a time */
+		do {
+			memcpy(bpage->data + pos, rpage->data + pos, size);
+
+			len -= size;
+
+			rb_advance_reader(cpu_buffer);
+			pos = reader->read;
+
+			event = rb_reader_event(cpu_buffer);
+			size = rb_event_length(event);
+		} while (len > size);
 
 		/* update bpage */
-		local_set(&bpage->commit, commit);
-		if (!read)
-			bpage->time_stamp = rpage->time_stamp;
+		local_set(&bpage->commit, pos);
+		bpage->time_stamp = rpage->time_stamp;
+
 	} else {
 		/* swap the pages */
 		rb_init_page(bpage);
-		bpage = cpu_buffer->reader_page->page;
-		cpu_buffer->reader_page->page = *data_page;
-		local_set(&cpu_buffer->reader_page->write, 0);
-		cpu_buffer->reader_page->read = 0;
+		bpage = reader->page;
+		reader->page = *data_page;
+		local_set(&reader->write, 0);
+		reader->read = 0;
 		*data_page = bpage;
+
+		/* update the entry counter */
+		rb_remove_entries(cpu_buffer, bpage, read);
 	}
 	ret = read;
 
-	/* update the entry counter */
-	rb_remove_entries(cpu_buffer, bpage, read);
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-- 
1.5.6.5

-- 
