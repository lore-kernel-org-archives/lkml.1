Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZCDCyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZCDCyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZCDCw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:52:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZCDCw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:52:56 -0500
Message-Id: <20090304025250.781058363@goodmis.org>
References: <20090304024921.153061228@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 21:49:25 -0500
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
Subject: [PATCH 4/5] ring-buffer: make ring_buffer_read_page read from start on partial page
Content-Disposition: inline; filename=0004-ring-buffer-make-ring_buffer_read_page-read-from-st.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: dont leave holes in read buffer page

The ring_buffer_read_page swaps a given page with the reader page
of the ring buffer, if certain conditions are set:

 1) requested length is big enough to hold entire page data

 2) a writer is not currently on the page

 3) the page is not partially consumed.

Instead of swapping with the supplied page. It copies the data to
the supplied page instead. But currently the data is copied in the
same offset as the source page. This causes a hole at the start
of the reader page. This complicates the use of this function.
Instead, it should copy the data at the beginning of the function
and update the index fields accordingly.

Other small clean ups are also done in this patch.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   43 +++++++++++++++++++++++++++++++++----------
 1 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 27cf834..f2a163d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -61,6 +61,8 @@ enum {
 
 static unsigned long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
 
+#define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
+
 /**
  * tracing_on - enable all tracing buffers
  *
@@ -234,9 +236,16 @@ static void rb_init_page(struct buffer_data_page *bpage)
 	local_set(&bpage->commit, 0);
 }
 
+/**
+ * ring_buffer_page_len - the size of data on the page.
+ * @page: The page to read
+ *
+ * Returns the amount of data on the page, including buffer page header.
+ */
 size_t ring_buffer_page_len(void *page)
 {
-	return local_read(&((struct buffer_data_page *)page)->commit);
+	return local_read(&((struct buffer_data_page *)page)->commit)
+		+ BUF_PAGE_HDR_SIZE;
 }
 
 /*
@@ -259,7 +268,7 @@ static inline int test_time_stamp(u64 delta)
 	return 0;
 }
 
-#define BUF_PAGE_SIZE (PAGE_SIZE - offsetof(struct buffer_data_page, data))
+#define BUF_PAGE_SIZE (PAGE_SIZE - BUF_PAGE_HDR_SIZE)
 
 /*
  * head_page == tail_page && head == tail then buffer is empty.
@@ -2454,6 +2463,15 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	unsigned int read;
 	int ret = -1;
 
+	/*
+	 * If len is not big enough to hold the page header, then
+	 * we can not copy anything.
+	 */
+	if (len <= BUF_PAGE_HDR_SIZE)
+		return -1;
+
+	len -= BUF_PAGE_HDR_SIZE;
+
 	if (!data_page)
 		return -1;
 
@@ -2473,15 +2491,17 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	commit = rb_page_commit(reader);
 
 	/*
-	 * If len > what's left on the page, and the writer is also off of
-	 * the read page, then simply switch the read page with the given
-	 * page. Otherwise we need to copy the data from the reader to the
-	 * writer.
+	 * If this page has been partially read or
+	 * if len is not big enough to read the rest of the page or
+	 * a writer is still on the page, then
+	 * we must copy the data from the page to the buffer.
+	 * Otherwise, we can simply swap the page with the one passed in.
 	 */
-	if ((len < (commit - read)) ||
+	if (read || (len < (commit - read)) ||
 	    cpu_buffer->reader_page == cpu_buffer->commit_page) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
-		unsigned int pos = read;
+		unsigned int rpos = read;
+		unsigned int pos = 0;
 		unsigned int size;
 
 		if (full)
@@ -2497,12 +2517,13 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 
 		/* Need to copy one event at a time */
 		do {
-			memcpy(bpage->data + pos, rpage->data + pos, size);
+			memcpy(bpage->data + pos, rpage->data + rpos, size);
 
 			len -= size;
 
 			rb_advance_reader(cpu_buffer);
-			pos = reader->read;
+			rpos = reader->read;
+			pos += size;
 
 			event = rb_reader_event(cpu_buffer);
 			size = rb_event_length(event);
@@ -2512,6 +2533,8 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		local_set(&bpage->commit, pos);
 		bpage->time_stamp = rpage->time_stamp;
 
+		/* we copied everything to the beginning */
+		read = 0;
 	} else {
 		/* swap the pages */
 		rb_init_page(bpage);
-- 
1.5.6.5

-- 
