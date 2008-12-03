Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbYLCEvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbYLCEvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYLCEus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:50:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbYLCEup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:50:45 -0500
Message-Id: <20081203045043.573535694@goodmis.org>
References: <20081203045001.367443457@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 23:50:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] ring-buffer: change page variables to bpage
Content-Disposition: inline; filename=0002-ring-buffer-change-page-variables-to-bpage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Andrew Morton pointed out that the kernel convention of a variable
named page should be of type page struct. The ring buffer uses
a variable named page for a pointer to something else. This patch converts
those to be called bpage.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |  130 ++++++++++++++++++++++----------------------
 1 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 50b74d3..7f69cfe 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -208,9 +208,9 @@ struct buffer_page {
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
-static void rb_init_page(struct buffer_data_page *page)
+static void rb_init_page(struct buffer_data_page *bpage)
 {
-	local_set(&page->commit, 0);
+	local_set(&bpage->commit, 0);
 }
 
 /*
@@ -298,19 +298,19 @@ struct ring_buffer_iter {
 static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct list_head *head = &cpu_buffer->pages;
-	struct buffer_page *page, *tmp;
+	struct buffer_page *bpage, *tmp;
 
 	if (RB_WARN_ON(cpu_buffer, head->next->prev != head))
 		return -1;
 	if (RB_WARN_ON(cpu_buffer, head->prev->next != head))
 		return -1;
 
-	list_for_each_entry_safe(page, tmp, head, list) {
+	list_for_each_entry_safe(bpage, tmp, head, list) {
 		if (RB_WARN_ON(cpu_buffer,
-			       page->list.next->prev != &page->list))
+			       bpage->list.next->prev != &bpage->list))
 			return -1;
 		if (RB_WARN_ON(cpu_buffer,
-			       page->list.prev->next != &page->list))
+			       bpage->list.prev->next != &bpage->list))
 			return -1;
 	}
 
@@ -321,23 +321,23 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned nr_pages)
 {
 	struct list_head *head = &cpu_buffer->pages;
-	struct buffer_page *page, *tmp;
+	struct buffer_page *bpage, *tmp;
 	unsigned long addr;
 	LIST_HEAD(pages);
 	unsigned i;
 
 	for (i = 0; i < nr_pages; i++) {
-		page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
+		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
-		if (!page)
+		if (!bpage)
 			goto free_pages;
-		list_add(&page->list, &pages);
+		list_add(&bpage->list, &pages);
 
 		addr = __get_free_page(GFP_KERNEL);
 		if (!addr)
 			goto free_pages;
-		page->page = (void *)addr;
-		rb_init_page(page->page);
+		bpage->page = (void *)addr;
+		rb_init_page(bpage->page);
 	}
 
 	list_splice(&pages, head);
@@ -347,9 +347,9 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	return 0;
 
  free_pages:
-	list_for_each_entry_safe(page, tmp, &pages, list) {
-		list_del_init(&page->list);
-		free_buffer_page(page);
+	list_for_each_entry_safe(bpage, tmp, &pages, list) {
+		list_del_init(&bpage->list);
+		free_buffer_page(bpage);
 	}
 	return -ENOMEM;
 }
@@ -358,7 +358,7 @@ static struct ring_buffer_per_cpu *
 rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	struct buffer_page *page;
+	struct buffer_page *bpage;
 	unsigned long addr;
 	int ret;
 
@@ -373,17 +373,17 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
-	page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
+	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
-	if (!page)
+	if (!bpage)
 		goto fail_free_buffer;
 
-	cpu_buffer->reader_page = page;
+	cpu_buffer->reader_page = bpage;
 	addr = __get_free_page(GFP_KERNEL);
 	if (!addr)
 		goto fail_free_reader;
-	page->page = (void *)addr;
-	rb_init_page(page->page);
+	bpage->page = (void *)addr;
+	rb_init_page(bpage->page);
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 
@@ -408,14 +408,14 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct list_head *head = &cpu_buffer->pages;
-	struct buffer_page *page, *tmp;
+	struct buffer_page *bpage, *tmp;
 
 	list_del_init(&cpu_buffer->reader_page->list);
 	free_buffer_page(cpu_buffer->reader_page);
 
-	list_for_each_entry_safe(page, tmp, head, list) {
-		list_del_init(&page->list);
-		free_buffer_page(page);
+	list_for_each_entry_safe(bpage, tmp, head, list) {
+		list_del_init(&bpage->list);
+		free_buffer_page(bpage);
 	}
 	kfree(cpu_buffer);
 }
@@ -512,7 +512,7 @@ static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
 static void
 rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 {
-	struct buffer_page *page;
+	struct buffer_page *bpage;
 	struct list_head *p;
 	unsigned i;
 
@@ -523,9 +523,9 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 		if (RB_WARN_ON(cpu_buffer, list_empty(&cpu_buffer->pages)))
 			return;
 		p = cpu_buffer->pages.next;
-		page = list_entry(p, struct buffer_page, list);
-		list_del_init(&page->list);
-		free_buffer_page(page);
+		bpage = list_entry(p, struct buffer_page, list);
+		list_del_init(&bpage->list);
+		free_buffer_page(bpage);
 	}
 	if (RB_WARN_ON(cpu_buffer, list_empty(&cpu_buffer->pages)))
 		return;
@@ -542,7 +542,7 @@ static void
 rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		struct list_head *pages, unsigned nr_pages)
 {
-	struct buffer_page *page;
+	struct buffer_page *bpage;
 	struct list_head *p;
 	unsigned i;
 
@@ -553,9 +553,9 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
 			return;
 		p = pages->next;
-		page = list_entry(p, struct buffer_page, list);
-		list_del_init(&page->list);
-		list_add_tail(&page->list, &cpu_buffer->pages);
+		bpage = list_entry(p, struct buffer_page, list);
+		list_del_init(&bpage->list);
+		list_add_tail(&bpage->list, &cpu_buffer->pages);
 	}
 	rb_reset_cpu(cpu_buffer);
 
@@ -582,7 +582,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned nr_pages, rm_pages, new_pages;
-	struct buffer_page *page, *tmp;
+	struct buffer_page *bpage, *tmp;
 	unsigned long buffer_size;
 	unsigned long addr;
 	LIST_HEAD(pages);
@@ -643,17 +643,17 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 
 	for_each_buffer_cpu(buffer, cpu) {
 		for (i = 0; i < new_pages; i++) {
-			page = kzalloc_node(ALIGN(sizeof(*page),
+			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
 						  cache_line_size()),
 					    GFP_KERNEL, cpu_to_node(cpu));
-			if (!page)
+			if (!bpage)
 				goto free_pages;
-			list_add(&page->list, &pages);
+			list_add(&bpage->list, &pages);
 			addr = __get_free_page(GFP_KERNEL);
 			if (!addr)
 				goto free_pages;
-			page->page = (void *)addr;
-			rb_init_page(page->page);
+			bpage->page = (void *)addr;
+			rb_init_page(bpage->page);
 		}
 	}
 
@@ -674,9 +674,9 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	return size;
 
  free_pages:
-	list_for_each_entry_safe(page, tmp, &pages, list) {
-		list_del_init(&page->list);
-		free_buffer_page(page);
+	list_for_each_entry_safe(bpage, tmp, &pages, list) {
+		list_del_init(&bpage->list);
+		free_buffer_page(bpage);
 	}
 	mutex_unlock(&buffer->mutex);
 	return -ENOMEM;
@@ -688,14 +688,14 @@ static inline int rb_null_event(struct ring_buffer_event *event)
 }
 
 static inline void *
-__rb_data_page_index(struct buffer_data_page *page, unsigned index)
+__rb_data_page_index(struct buffer_data_page *bpage, unsigned index)
 {
-	return page->data + index;
+	return bpage->data + index;
 }
 
-static inline void *__rb_page_index(struct buffer_page *page, unsigned index)
+static inline void *__rb_page_index(struct buffer_page *bpage, unsigned index)
 {
-	return page->page->data + index;
+	return bpage->page->data + index;
 }
 
 static inline struct ring_buffer_event *
@@ -771,14 +771,14 @@ static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
-			       struct buffer_page **page)
+			       struct buffer_page **bpage)
 {
-	struct list_head *p = (*page)->list.next;
+	struct list_head *p = (*bpage)->list.next;
 
 	if (p == &cpu_buffer->pages)
 		p = p->next;
 
-	*page = list_entry(p, struct buffer_page, list);
+	*bpage = list_entry(p, struct buffer_page, list);
 }
 
 static inline unsigned
@@ -2239,16 +2239,16 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 }
 
 static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
-			      struct buffer_data_page *page)
+			      struct buffer_data_page *bpage)
 {
 	struct ring_buffer_event *event;
 	unsigned long head;
 
 	__raw_spin_lock(&cpu_buffer->lock);
-	for (head = 0; head < local_read(&page->commit);
+	for (head = 0; head < local_read(&bpage->commit);
 	     head += rb_event_length(event)) {
 
-		event = __rb_data_page_index(page, head);
+		event = __rb_data_page_index(bpage, head);
 		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
 			return;
 		/* Only count data entries */
@@ -2277,15 +2277,15 @@ static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
 void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
 {
 	unsigned long addr;
-	struct buffer_data_page *page;
+	struct buffer_data_page *bpage;
 
 	addr = __get_free_page(GFP_KERNEL);
 	if (!addr)
 		return NULL;
 
-	page = (void *)addr;
+	bpage = (void *)addr;
 
-	return page;
+	return bpage;
 }
 
 /**
@@ -2337,15 +2337,15 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
-	struct buffer_data_page *page;
+	struct buffer_data_page *bpage;
 	unsigned long flags;
 	int ret = 0;
 
 	if (!data_page)
 		return 0;
 
-	page = *data_page;
-	if (!page)
+	bpage = *data_page;
+	if (!bpage)
 		return 0;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
@@ -2372,26 +2372,26 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		if (full)
 			goto out;
 		/* The writer is still on the reader page, we must copy */
-		page = cpu_buffer->reader_page->page;
-		memcpy(page->data,
+		bpage = cpu_buffer->reader_page->page;
+		memcpy(bpage->data,
 		       cpu_buffer->reader_page->page->data + read,
-		       local_read(&page->commit) - read);
+		       local_read(&bpage->commit) - read);
 
 		/* consume what was read */
 		cpu_buffer->reader_page += read;
 
 	} else {
 		/* swap the pages */
-		rb_init_page(page);
-		page = cpu_buffer->reader_page->page;
+		rb_init_page(bpage);
+		bpage = cpu_buffer->reader_page->page;
 		cpu_buffer->reader_page->page = *data_page;
 		cpu_buffer->reader_page->read = 0;
-		*data_page = page;
+		*data_page = bpage;
 	}
 	ret = 1;
 
 	/* update the entry counter */
-	rb_remove_entries(cpu_buffer, page);
+	rb_remove_entries(cpu_buffer, bpage);
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-- 
1.5.6.5

-- 
