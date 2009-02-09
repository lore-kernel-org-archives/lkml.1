Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZBIGVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZBIGVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZBIGVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:21:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62354 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZBIGVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:21:31 -0500
Message-ID: <498FCB5D.5000304@cn.fujitsu.com>
Date: Mon, 09 Feb 2009 14:21:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ring_buffer: fix ring_buffer_read_page()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: change API and init bpage when copy

ring_buffer_read_page()/rb_remove_entries() may be called for
a partial consumed page.

Add a parameter for rb_remove_entries(), make it updates
cpu_buffer->entries correctly for partial consumed page.

ring_buffer_read_page() return the offset of events.

init bpage's time_stamp which caller needs when return value is 0.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 ring_buffer.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e97acae..eaec7e5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2303,13 +2303,14 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
 
 static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
-			      struct buffer_data_page *bpage)
+			      struct buffer_data_page *bpage,
+			      unsigned int offset)
 {
 	struct ring_buffer_event *event;
 	unsigned long head;
 
 	__raw_spin_lock(&cpu_buffer->lock);
-	for (head = 0; head < local_read(&bpage->commit);
+	for (head = offset; head < local_read(&bpage->commit);
 	     head += rb_event_length(event)) {
 
 		event = __rb_data_page_index(bpage, head);
@@ -2381,8 +2382,8 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
  *	if (!rpage)
  *		return error;
  *	ret = ring_buffer_read_page(buffer, &rpage, cpu, 0);
- *	if (ret)
- *		process_page(rpage);
+ *	if (ret >= 0)
+ *		process_page(rpage, ret);
  *
  * When @full is set, the function will not return true unless
  * the writer is off the reader page.
@@ -2393,8 +2394,8 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
  *  responsible for that.
  *
  * Returns:
- *  1 if data has been transferred
- *  0 if no data has been transferred.
+ *  >=0 if data has been transferred, returns the offset of consumed data.
+ *  <0 if no data has been transferred.
  */
 int ring_buffer_read_page(struct ring_buffer *buffer,
 			    void **data_page, int cpu, int full)
@@ -2403,7 +2404,8 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	struct buffer_data_page *bpage;
 	unsigned long flags;
-	int ret = 0;
+	unsigned int read;
+	int ret = -1;
 
 	if (!data_page)
 		return 0;
@@ -2425,24 +2427,29 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	/* check for data */
 	if (!local_read(&cpu_buffer->reader_page->page->commit))
 		goto out;
+
+	read = cpu_buffer->reader_page->read;
 	/*
 	 * If the writer is already off of the read page, then simply
 	 * switch the read page with the given page. Otherwise
 	 * we need to copy the data from the reader to the writer.
 	 */
 	if (cpu_buffer->reader_page == cpu_buffer->commit_page) {
-		unsigned int read = cpu_buffer->reader_page->read;
 		unsigned int commit = rb_page_commit(cpu_buffer->reader_page);
+		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
 
 		if (full)
 			goto out;
 		/* The writer is still on the reader page, we must copy */
-		memcpy(bpage->data,
-		       cpu_buffer->reader_page->page->data + read,
-		       commit - read);
+		memcpy(bpage->data + read, rpage->data + read, commit - read);
 
 		/* consume what was read */
 		cpu_buffer->reader_page->read = commit;
+
+		/* update bpage */
+		local_set(&bpage->commit, commit);
+		if (!read)
+			bpage->time_stamp = rpage->time_stamp;
 	} else {
 		/* swap the pages */
 		rb_init_page(bpage);
@@ -2451,10 +2458,10 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		cpu_buffer->reader_page->read = 0;
 		*data_page = bpage;
 	}
-	ret = 1;
+	ret = read;
 
 	/* update the entry counter */
-	rb_remove_entries(cpu_buffer, bpage);
+	rb_remove_entries(cpu_buffer, bpage, read);
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 


