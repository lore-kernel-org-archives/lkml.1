Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbYLBUf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbYLBUf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYLBUea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:34:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYLBUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:34:27 -0500
Message-Id: <20081202203425.040910271@goodmis.org>
References: <20081202203404.496794864@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:34:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ring-buffer: read page interface
Content-Disposition: inline; filename=0003-ring-buffer-read-page-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: new API to ring buffer

This patch adds a new interface into the ring buffer that allows a
page to be read from the ring buffer on a given CPU. For every page
read, one must also be given to allow for a "swap" of the pages.

 rpage = ring_buffer_alloc_read_page(buffer);
 if (!rpage)
	goto err;
 ret = ring_buffer_read_page(buffer, &rpage, cpu, full);
 if (!ret)
	goto empty;
 process_page(rpage);
 ring_buffer_free_read_page(rpage);

The caller of these functions must handle any waits that are
needed to wait for new data. The ring_buffer_read_page will simply
return 0 if there is no data, or if "full" is set and the writer
is still on the current page.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    5 ++
 kernel/trace/ring_buffer.c  |  166 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+), 0 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 3bb87a7..1a350a8 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -124,6 +124,11 @@ void tracing_on(void);
 void tracing_off(void);
 void tracing_off_permanent(void);
 
+void *ring_buffer_alloc_read_page(struct ring_buffer *buffer);
+void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
+int ring_buffer_read_page(struct ring_buffer *buffer,
+			  void **data_page, int cpu, int full);
+
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
 };
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8619c53..50b74d3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -687,6 +687,12 @@ static inline int rb_null_event(struct ring_buffer_event *event)
 	return event->type == RINGBUF_TYPE_PADDING;
 }
 
+static inline void *
+__rb_data_page_index(struct buffer_data_page *page, unsigned index)
+{
+	return page->data + index;
+}
+
 static inline void *__rb_page_index(struct buffer_page *page, unsigned index)
 {
 	return page->page->data + index;
@@ -2232,6 +2238,166 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	return 0;
 }
 
+static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
+			      struct buffer_data_page *page)
+{
+	struct ring_buffer_event *event;
+	unsigned long head;
+
+	__raw_spin_lock(&cpu_buffer->lock);
+	for (head = 0; head < local_read(&page->commit);
+	     head += rb_event_length(event)) {
+
+		event = __rb_data_page_index(page, head);
+		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
+			return;
+		/* Only count data entries */
+		if (event->type != RINGBUF_TYPE_DATA)
+			continue;
+		cpu_buffer->entries--;
+	}
+	__raw_spin_unlock(&cpu_buffer->lock);
+}
+
+/**
+ * ring_buffer_alloc_read_page - allocate a page to read from buffer
+ * @buffer: the buffer to allocate for.
+ *
+ * This function is used in conjunction with ring_buffer_read_page.
+ * When reading a full page from the ring buffer, these functions
+ * can be used to speed up the process. The calling function should
+ * allocate a few pages first with this function. Then when it
+ * needs to get pages from the ring buffer, it passes the result
+ * of this function into ring_buffer_read_page, which will swap
+ * the page that was allocated, with the read page of the buffer.
+ *
+ * Returns:
+ *  The page allocated, or NULL on error.
+ */
+void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
+{
+	unsigned long addr;
+	struct buffer_data_page *page;
+
+	addr = __get_free_page(GFP_KERNEL);
+	if (!addr)
+		return NULL;
+
+	page = (void *)addr;
+
+	return page;
+}
+
+/**
+ * ring_buffer_free_read_page - free an allocated read page
+ * @buffer: the buffer the page was allocate for
+ * @data: the page to free
+ *
+ * Free a page allocated from ring_buffer_alloc_read_page.
+ */
+void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
+{
+	free_page((unsigned long)data);
+}
+
+/**
+ * ring_buffer_read_page - extract a page from the ring buffer
+ * @buffer: buffer to extract from
+ * @data_page: the page to use allocated from ring_buffer_alloc_read_page
+ * @cpu: the cpu of the buffer to extract
+ * @full: should the extraction only happen when the page is full.
+ *
+ * This function will pull out a page from the ring buffer and consume it.
+ * @data_page must be the address of the variable that was returned
+ * from ring_buffer_alloc_read_page. This is because the page might be used
+ * to swap with a page in the ring buffer.
+ *
+ * for example:
+ *	rpage = ring_buffer_alloc_page(buffer);
+ *	if (!rpage)
+ *		return error;
+ *	ret = ring_buffer_read_page(buffer, &rpage, cpu, 0);
+ *	if (ret)
+ *		process_page(rpage);
+ *
+ * When @full is set, the function will not return true unless
+ * the writer is off the reader page.
+ *
+ * Note: it is up to the calling functions to handle sleeps and wakeups.
+ *  The ring buffer can be used anywhere in the kernel and can not
+ *  blindly call wake_up. The layer that uses the ring buffer must be
+ *  responsible for that.
+ *
+ * Returns:
+ *  1 if data has been transferred
+ *  0 if no data has been transferred.
+ */
+int ring_buffer_read_page(struct ring_buffer *buffer,
+			    void **data_page, int cpu, int full)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	struct ring_buffer_event *event;
+	struct buffer_data_page *page;
+	unsigned long flags;
+	int ret = 0;
+
+	if (!data_page)
+		return 0;
+
+	page = *data_page;
+	if (!page)
+		return 0;
+
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+
+	/*
+	 * rb_buffer_peek will get the next ring buffer if
+	 * the current reader page is empty.
+	 */
+	event = rb_buffer_peek(buffer, cpu, NULL);
+	if (!event)
+		goto out;
+
+	/* check for data */
+	if (!local_read(&cpu_buffer->reader_page->page->commit))
+		goto out;
+	/*
+	 * If the writer is already off of the read page, then simply
+	 * switch the read page with the given page. Otherwise
+	 * we need to copy the data from the reader to the writer.
+	 */
+	if (cpu_buffer->reader_page == cpu_buffer->commit_page) {
+		unsigned int read = cpu_buffer->reader_page->read;
+
+		if (full)
+			goto out;
+		/* The writer is still on the reader page, we must copy */
+		page = cpu_buffer->reader_page->page;
+		memcpy(page->data,
+		       cpu_buffer->reader_page->page->data + read,
+		       local_read(&page->commit) - read);
+
+		/* consume what was read */
+		cpu_buffer->reader_page += read;
+
+	} else {
+		/* swap the pages */
+		rb_init_page(page);
+		page = cpu_buffer->reader_page->page;
+		cpu_buffer->reader_page->page = *data_page;
+		cpu_buffer->reader_page->read = 0;
+		*data_page = page;
+	}
+	ret = 1;
+
+	/* update the entry counter */
+	rb_remove_entries(cpu_buffer, page);
+ out:
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+	return ret;
+}
+
 static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
-- 
1.5.6.5

-- 
