Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYLCAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYLCAz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYLCAzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:55:14 -0500
Received: from smtp-out.google.com ([216.239.45.13]:60688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbYLCAzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:55:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=i/gba1eENUnx7TOvMWEL4mQtF9+nZd9Ul/dDFfMFHxny7Fv3wDZE09CZhMZA8HcJn
	Uudf7kRUAljhqwKZY8iLA==
MIME-Version: 1.0
In-Reply-To: <5df78e1d0812021625q8a0d362i5d7a650543157864@mail.gmail.com>
References: <5df78e1d0812021625q8a0d362i5d7a650543157864@mail.gmail.com>
Date: Tue, 2 Dec 2008 16:55:09 -0800
Message-ID: <5df78e1d0812021655p6819d893v113848ae7bf4b4ee@mail.gmail.com>
Subject: [RFC PATCH 1/3] adding mmap support to the unified trace buffer
From: Jiaying Zhang <jiayingz@google.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>, Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refer to the previous email
"[RFC PATCH 0/3] A couple of feature requests to the unified trace buffer".

Add the mmap support to the unified trace buffer. The patch includes an
API that maps a page offset to a physical page in a trace buffer, APIs
that export the offset of the current produced/consumed data, and an
API to advance the consumed data pointer.

Index: linux-2.6.26/include/linux/ring_buffer.h
===================================================================
--- linux-2.6.26.orig/include/linux/ring_buffer.h       2008-12-01
14:46:11.000000000 -0800
+++ linux-2.6.26/include/linux/ring_buffer.h    2008-12-01
14:46:30.000000000 -0800
@@ -5,6 +5,7 @@
 #include <linux/seq_file.h>

 struct ring_buffer;
+struct ring_buffer_per_cpu;
 struct ring_buffer_iter;

 /*
@@ -108,6 +109,7 @@

 int ring_buffer_empty(struct ring_buffer *buffer);
 int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
+int ring_buffer_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer);

 void ring_buffer_record_disable(struct ring_buffer *buffer);
 void ring_buffer_record_enable(struct ring_buffer *buffer);
@@ -124,4 +126,12 @@
       RB_FL_OVERWRITE         = 1 << 0,
 };

+struct ring_buffer_per_cpu *ring_buffer_cpu(struct ring_buffer *buffer,
+               int cpu);
+struct page * ring_buffer_get_page(struct ring_buffer_per_cpu *cpu_buffer,
+               pgoff_t pgoff);
+void ring_buffer_advance_reader(struct ring_buffer_per_cpu *cpu_buffer,
+               int count_in);
+u32 ring_buffer_get_produced(struct ring_buffer_per_cpu *cpu_buffer);
+u32 ring_buffer_get_consumed(struct ring_buffer_per_cpu *cpu_buffer);
 #endif /* _LINUX_RING_BUFFER_H */
Index: linux-2.6.26/kernel/ktrace/ring_buffer.c
===================================================================
--- linux-2.6.26.orig/kernel/ktrace/ring_buffer.c       2008-12-01
14:46:11.000000000 -0800
+++ linux-2.6.26/kernel/ktrace/ring_buffer.c    2008-12-01
16:03:01.000000000 -0800
@@ -131,7 +131,6 @@
 {
       if (bpage->page)
               free_page((unsigned long)bpage->page);
-       kfree(bpage);
 }

 /*
@@ -155,6 +154,7 @@
       spinlock_t                      lock;
       struct lock_class_key           lock_key;
       struct list_head                pages;
+       struct buffer_page              *page_array;
       struct buffer_page              *head_page;     /* read from head */
       struct buffer_page              *tail_page;     /* write to tail */
       struct buffer_page              *commit_page;   /* commited pages */
@@ -186,6 +186,11 @@
       u64                             read_stamp;
 };

+struct ring_buffer_per_cpu *ring_buffer_cpu(struct ring_buffer
*buffer, int cpu)
+{
+       return buffer->buffers[cpu];
+}
+
 #define RB_WARN_ON(buffer, cond)                               \
       do {                                                    \
               if (unlikely(cond)) {                           \
@@ -238,25 +243,26 @@
       return 0;
 }

+#define BP_HEADER_SIZE  ALIGN(sizeof(struct buffer_page), cache_line_size())
+
 static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
                            unsigned nr_pages)
 {
       struct list_head *head = &cpu_buffer->pages;
-       struct buffer_page *page, *tmp;
+       struct buffer_page *page;
+       void *array;
       unsigned long addr;
       LIST_HEAD(pages);
       unsigned i;

+       array = cpu_buffer->page_array;
       for (i = 0; i < nr_pages; i++) {
-               page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
-                                   GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
-               if (!page)
-                       goto free_pages;
-               list_add(&page->list, &pages);
+               page = (struct buffer_page *) (array + i * BP_HEADER_SIZE);
+               list_add_tail(&page->list, &pages);

               addr = __get_free_page(GFP_KERNEL);
               if (!addr)
-                       goto free_pages;
+                       return -ENOMEM;
               page->page = (void *)addr;
       }

@@ -265,13 +271,6 @@
       rb_check_pages(cpu_buffer);

       return 0;
-
- free_pages:
-       list_for_each_entry_safe(page, tmp, &pages, list) {
-               list_del_init(&page->list);
-               free_buffer_page(page);
-       }
-       return -ENOMEM;
 }

 static struct ring_buffer_per_cpu *
@@ -292,22 +291,23 @@
       spin_lock_init(&cpu_buffer->lock);
       INIT_LIST_HEAD(&cpu_buffer->pages);

-       page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
-                           GFP_KERNEL, cpu_to_node(cpu));
-       if (!page)
+       cpu_buffer->page_array = kzalloc_node(BP_HEADER_SIZE * buffer->pages,
+                       GFP_KERNEL, cpu_to_node(cpu));
+       if (!cpu_buffer->page_array)
               goto fail_free_buffer;

+       page = (struct buffer_page *) ((void *) cpu_buffer->page_array +
+                       BP_HEADER_SIZE * (buffer->pages -1));
       cpu_buffer->reader_page = page;
       addr = __get_free_page(GFP_KERNEL);
       if (!addr)
-               goto fail_free_reader;
+               goto fail_free_array;
       page->page = (void *)addr;
-
       INIT_LIST_HEAD(&cpu_buffer->reader_page->list);

-       ret = rb_allocate_pages(cpu_buffer, buffer->pages);
+       ret = rb_allocate_pages(cpu_buffer, buffer->pages - 1);
       if (ret < 0)
-               goto fail_free_reader;
+               goto fail_free_array;

       cpu_buffer->head_page
               = list_entry(cpu_buffer->pages.next, struct buffer_page, list);
@@ -315,8 +315,8 @@

       return cpu_buffer;

- fail_free_reader:
-       free_buffer_page(cpu_buffer->reader_page);
+ fail_free_array:
+       kfree(cpu_buffer->page_array);

 fail_free_buffer:
       kfree(cpu_buffer);
@@ -335,6 +335,7 @@
               list_del_init(&page->list);
               free_buffer_page(page);
       }
+       kfree(cpu_buffer->page_array);
       kfree(cpu_buffer);
 }

@@ -439,7 +440,7 @@

       for (i = 0; i < nr_pages; i++) {
               BUG_ON(list_empty(&cpu_buffer->pages));
-               p = cpu_buffer->pages.next;
+               p = cpu_buffer->pages.prev;
               page = list_entry(p, struct buffer_page, list);
               list_del_init(&page->list);
               free_buffer_page(page);
@@ -497,7 +498,7 @@
 {
       struct ring_buffer_per_cpu *cpu_buffer;
       unsigned nr_pages, rm_pages, new_pages;
-       struct buffer_page *page, *tmp;
+       struct buffer_page *page, *array;
       unsigned long buffer_size;
       unsigned long addr;
       LIST_HEAD(pages);
@@ -544,23 +545,23 @@
       new_pages = nr_pages - buffer->pages;

       for_each_buffer_cpu(buffer, cpu) {
+               cpu_buffer = buffer->buffers[cpu];
+               array = kzalloc_node(BP_HEADER_SIZE * nr_pages,
+                       GFP_KERNEL, cpu_to_node(cpu));
+               memcpy(array, cpu_buffer->page_array,
+                               BP_HEADER_SIZE * buffer->pages);
               for (i = 0; i < new_pages; i++) {
-                       page = kzalloc_node(ALIGN(sizeof(*page),
-                                                 cache_line_size()),
-                                           GFP_KERNEL, cpu_to_node(cpu));
-                       if (!page)
-                               goto free_pages;
-                       list_add(&page->list, &pages);
+                       page = (struct buffer_page *) ((void *) array +
+                                       (buffer->pages + i) * BP_HEADER_SIZE);
                       addr = __get_free_page(GFP_KERNEL);
                       if (!addr)
-                               goto free_pages;
+                               return -ENOMEM;
                       page->page = (void *)addr;
+                       list_add_tail(&page->list, &pages);
               }
-       }
-
-       for_each_buffer_cpu(buffer, cpu) {
-               cpu_buffer = buffer->buffers[cpu];
               rb_insert_pages(cpu_buffer, &pages, new_pages);
+               kfree(cpu_buffer->page_array);
+               cpu_buffer->page_array = array;
       }

       BUG_ON(!list_empty(&pages));
@@ -570,13 +571,6 @@
       mutex_unlock(&buffer->mutex);

       return size;
-
- free_pages:
-       list_for_each_entry_safe(page, tmp, &pages, list) {
-               list_del_init(&page->list);
-               free_buffer_page(page);
-       }
-       return -ENOMEM;
 }

 static inline int rb_null_event(struct ring_buffer_event *event)
@@ -1299,6 +1293,11 @@
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
@@ -1638,6 +1637,58 @@
       cpu_buffer->reader_page->read += length;
 }

+u32 ring_buffer_get_produced(struct ring_buffer_per_cpu *cpu_buffer)
+{
+       struct buffer_page *reader;
+       unsigned pgoff;
+
+       reader = rb_get_reader_page(cpu_buffer);
+       if (!reader)
+               return 0;
+       pgoff = ((void *) reader - (void *) cpu_buffer->page_array) /
+               BP_HEADER_SIZE;
+       return pgoff * BUF_PAGE_SIZE + rb_page_commit(reader);
+}
+
+u32 ring_buffer_get_consumed(struct ring_buffer_per_cpu *cpu_buffer)
+{
+       struct buffer_page *reader;
+       unsigned pgoff;
+
+       reader = rb_get_reader_page(cpu_buffer);
+       if (!reader)
+               return 0;
+       pgoff = ((void *) reader - (void *) cpu_buffer->page_array) /
+               BP_HEADER_SIZE;
+       return pgoff * BUF_PAGE_SIZE + reader->read;
+}
+
+void ring_buffer_advance_reader(struct ring_buffer_per_cpu *cpu_buffer,
+               int count)
+{
+       unsigned long flags;
+       struct buffer_page *reader;
+
+       spin_lock_irqsave(&cpu_buffer->lock, flags);
+       reader = cpu_buffer->reader_page;
+       reader->read += count;
+       spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+}
+
+struct page * ring_buffer_get_page(struct ring_buffer_per_cpu *cpu_buffer,
+               pgoff_t pgoff)
+{
+       struct page *page;
+       struct buffer_page *bpage;
+
+       bpage = (struct buffer_page *) ((void *) cpu_buffer->page_array +
+                       pgoff * BP_HEADER_SIZE);
+       page = virt_to_page(bpage->page);
+       if (!page)
+               printk("error: fail to vmalloc page\n");
+       return page;
+}
+
 static void rb_advance_iter(struct ring_buffer_iter *iter)
 {
       struct ring_buffer *buffer;
