Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZBJRgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZBJRgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZBJRgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:36:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZBJRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:36:19 -0500
Message-Id: <20090210173618.176893556@goodmis.org>
References: <20090210173504.973802731@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Feb 2009 12:35:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/7] ring_buffer: fix ring_buffer_read_page()
Content-Disposition: inline; filename=0002-ring_buffer-fix-ring_buffer_read_page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Impact: change API and init bpage when copy

ring_buffer_read_page()/rb_remove_entries() may be called for
a partially consumed page.

Add a parameter for rb_remove_entries() and make it update
cpu_buffer->entries correctly for partially consumed pages.

ring_buffer_read_page() now returns the offset to the next event.

Init the bpage's time_stamp when return value is 0.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   33 ++++++++++++++++++++-------------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index eca2827..10d202e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2332,13 +2332,14 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
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
@@ -2410,8 +2411,8 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
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
@@ -2422,8 +2423,8 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
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
@@ -2432,7 +2433,8 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	struct buffer_data_page *bpage;
 	unsigned long flags;
-	int ret = 0;
+	unsigned int read;
+	int ret = -1;
 
 	if (!data_page)
 		return 0;
@@ -2454,24 +2456,29 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
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
@@ -2480,10 +2487,10 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
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
 
-- 
1.5.6.5

-- 
