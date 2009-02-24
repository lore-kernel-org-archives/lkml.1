Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZBXAK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZBXAK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZBXAKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:10:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZBXAKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:10:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ELKBgLH+3iVrZf44dD1jXnQMOIHXcCQmKRUbsJOgqSY5lEdrFNGkWSpnchmSZIthw
	FNUJy5cbQrSq13rfzU+3g==
MIME-Version: 1.0
Date: Mon, 23 Feb 2009 16:10:10 -0800
Message-ID: <5df78e1d0902231610u3193b11w90de9e5f62b945b@mail.gmail.com>
Subject: [RFC PATCH] Resubmit the patch to add mmap support to the unified 
	trace buffer
From: Jiaying Zhang <jiayingz@google.com>
To: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>,
       Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

I sent you a patch that adds the mmap support to the unified trace buffer
a couple of months ago. You mentioned that you had modified the trace buffer
code to move some of the meta data into the front of a buffer page. I realized
that now I can simply record the page offset in the buffer header with your
change, so here comes my modified patch.

(You also mentioned last time that you were working on adding the splice_read
support in the unified trace buffer. I think that would be a really nice feature
to include and would like to try it when the feature is ready. On the
other hand,
I guess it might be more convenient for users if unified trace buffer supports
both mmap and splice_read, because not many people are familiar with splice_read
interface.)

The following patch adds the mmap support to the unified trace buffer.
It includes an API that maps a page offset to a physical page in the
trace buffer,
APIs that export the offset of the current produced/consumed data, and an
API to advance the consumed data pointer.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>

Index: git-linux/include/linux/ring_buffer.h
===================================================================
--- git-linux.orig/include/linux/ring_buffer.h  2009-02-19
14:47:10.000000000 -0800
+++ git-linux/include/linux/ring_buffer.h       2009-02-19
14:49:00.000000000 -0800
@@ -5,6 +5,7 @@
 #include <linux/seq_file.h>

 struct ring_buffer;
+struct ring_buffer_per_cpu;
 struct ring_buffer_iter;

 /*
@@ -110,6 +111,10 @@

 int ring_buffer_empty(struct ring_buffer *buffer);
 int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
+int ring_buffer_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer);
+
+struct ring_buffer_per_cpu *ring_buffer_cpu(struct ring_buffer *buffer,
+                                               int cpu);

 void ring_buffer_record_disable(struct ring_buffer *buffer);
 void ring_buffer_record_enable(struct ring_buffer *buffer);
@@ -137,4 +142,10 @@
       RB_FL_OVERWRITE         = 1 << 0,
 };

+struct page *ring_buffer_get_page(struct ring_buffer_per_cpu *cpu_buffer,
+               pgoff_t pgoff);
+void ring_buffer_advance_reader(struct ring_buffer_per_cpu *cpu_buffer,
+               int count_in);
+u32 ring_buffer_get_produced(struct ring_buffer_per_cpu *cpu_buffer);
+u32 ring_buffer_get_consumed(struct ring_buffer_per_cpu *cpu_buffer);
 #endif /* _LINUX_RING_BUFFER_H */
Index: git-linux/kernel/trace/ring_buffer.c
===================================================================
--- git-linux.orig/kernel/trace/ring_buffer.c   2009-02-19
14:47:10.000000000 -0800
+++ git-linux/kernel/trace/ring_buffer.c        2009-02-19
14:47:47.000000000 -0800
@@ -216,6 +216,7 @@
 struct buffer_page {
       local_t          write;         /* index for next write */
       unsigned         read;          /* index for next read */
+       unsigned         pgoff;         /* page offset inside cpu_buffer */
       struct list_head list;          /* list of free pages */
       struct buffer_data_page *page;  /* Actual data page */
 };
@@ -288,6 +289,11 @@
       u64                             read_stamp;
 };

+struct ring_buffer_per_cpu *ring_buffer_cpu(struct ring_buffer
*buffer, int cpu)
+{
+       return buffer->buffers[cpu];
+}
+
 /* buffer may be either ring_buffer or ring_buffer_per_cpu */
 #define RB_WARN_ON(buffer, cond)                               \
       ({                                                      \
@@ -348,6 +354,7 @@
               if (!addr)
                       goto free_pages;
               bpage->page = (void *)addr;
+               bpage->pgoff = i;
               rb_init_page(bpage->page);
       }

@@ -394,11 +401,12 @@
       if (!addr)
               goto fail_free_reader;
       bpage->page = (void *)addr;
+       bpage->pgoff = buffer->pages - 1;
       rb_init_page(bpage->page);

       INIT_LIST_HEAD(&cpu_buffer->reader_page->list);

-       ret = rb_allocate_pages(cpu_buffer, buffer->pages);
+       ret = rb_allocate_pages(cpu_buffer, buffer->pages - 1);
       if (ret < 0)
               goto fail_free_reader;

@@ -1450,6 +1458,11 @@
                 head->read == rb_page_commit(commit)));
 }

+int ring_buffer_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+{
+       return rb_per_cpu_empty(cpu_buffer);
+}
+
 /**
 * ring_buffer_record_disable - stop all writes into the buffer
 * @buffer: The ring buffer to stop writes to.
@@ -1812,6 +1825,66 @@
       cpu_buffer->reader_page->read += length;
 }

+u32 ring_buffer_get_produced(struct ring_buffer_per_cpu *cpu_buffer)
+{
+       struct buffer_page *reader;
+
+       reader = rb_get_reader_page(cpu_buffer);
+       if (!reader)
+               return 0;
+       return reader->pgoff * PAGE_SIZE +
+               offsetof(struct buffer_data_page, data) +
+               rb_page_commit(reader);
+}
+
+u32 ring_buffer_get_consumed(struct ring_buffer_per_cpu *cpu_buffer)
+{
+       struct buffer_page *reader;
+
+       reader = rb_get_reader_page(cpu_buffer);
+       if (!reader)
+               return 0;
+       return reader->pgoff * PAGE_SIZE +
+               offsetof(struct buffer_data_page, data) + reader->read;
+}
+
+void ring_buffer_advance_reader(struct ring_buffer_per_cpu *cpu_buffer,
+               int count)
+{
+       unsigned long flags;
+       struct buffer_page *reader;
+
+       spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+       __raw_spin_lock(&cpu_buffer->lock);
+       reader = cpu_buffer->reader_page;
+       reader->read += count;
+       __raw_spin_unlock(&cpu_buffer->lock);
+       spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+}
+
+struct page *ring_buffer_get_page(struct ring_buffer_per_cpu *cpu_buffer,
+               pgoff_t pgoff)
+{
+       struct page *page;
+       struct buffer_page *bpage;
+
+       if (cpu_buffer->reader_page->pgoff == pgoff)
+               bpage = cpu_buffer->reader_page;
+       else
+               list_for_each_entry(bpage, &cpu_buffer->pages, list)
+                       if (bpage->pgoff == pgoff)
+                               break;
+       if (bpage->pgoff != pgoff) {
+               printk(KERN_WARNING
+                       "error: fail to find a page with offset %lu\n", pgoff);
+               return NULL;
+       }
+       page = virt_to_page(bpage->page);
+       if (!page)
+               printk(KERN_WARNING "error: fail to vmalloc page\n");
+       return page;
+}
+
 static void rb_advance_iter(struct ring_buffer_iter *iter)
 {
       struct ring_buffer *buffer;
