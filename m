Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759917AbYLQJwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbYLQJwH (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYLQJvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:51:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYLQJvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:51:52 -0500
Message-ID: <4948CADF.6050205@cn.fujitsu.com>
Date: Wed, 17 Dec 2008 17:48:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring_bufer: fix BUF_PAGE_SIZE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


impact: make BUF_PAGE_SIZE changeable.

Except allocating/freeing page and the code using PAGE_MASK,
all code expect buffer_page's length is BUF_PAGE_SIZE.

This patch make this behavior more concordant.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 668bbb5..0cf6caf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -158,6 +158,10 @@ struct buffer_page {
 	void *page;			/* Actual data page */
 };
 
+#define BUF_PAGE_ORDER 0
+#define BUF_PAGE_SIZE (PAGE_SIZE << BUF_PAGE_ORDER)
+#define BUF_PAGE_MASK (~(BUF_PAGE_SIZE - 1))
+
 /*
  * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
  * this issue out.
@@ -165,7 +169,7 @@ struct buffer_page {
 static inline void free_buffer_page(struct buffer_page *bpage)
 {
 	if (bpage->page)
-		free_page((unsigned long)bpage->page);
+		free_pages((unsigned long)bpage->page, BUF_PAGE_ORDER);
 	kfree(bpage);
 }
 
@@ -179,8 +183,6 @@ static inline int test_time_stamp(u64 delta)
 	return 0;
 }
 
-#define BUF_PAGE_SIZE PAGE_SIZE
-
 /*
  * head_page == tail_page && head == tail then buffer is empty.
  */
@@ -289,7 +291,7 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			goto free_pages;
 		list_add(&page->list, &pages);
 
-		addr = __get_free_page(GFP_KERNEL);
+		addr = __get_free_pages(GFP_KERNEL, BUF_PAGE_ORDER);
 		if (!addr)
 			goto free_pages;
 		page->page = (void *)addr;
@@ -333,7 +335,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 		goto fail_free_buffer;
 
 	cpu_buffer->reader_page = page;
-	addr = __get_free_page(GFP_KERNEL);
+	addr = __get_free_pages(GFP_KERNEL, BUF_PAGE_ORDER);
 	if (!addr)
 		goto fail_free_reader;
 	page->page = (void *)addr;
@@ -592,7 +594,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 			if (!page)
 				goto free_pages;
 			list_add(&page->list, &pages);
-			addr = __get_free_page(GFP_KERNEL);
+			addr = __get_free_pages(GFP_KERNEL, BUF_PAGE_ORDER);
 			if (!addr)
 				goto free_pages;
 			page->page = (void *)addr;
@@ -718,7 +720,7 @@ rb_event_index(struct ring_buffer_event *event)
 {
 	unsigned long addr = (unsigned long)event;
 
-	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
+	return addr & ~BUF_PAGE_MASK;
 }
 
 static inline int
@@ -729,7 +731,7 @@ rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 	unsigned long index;
 
 	index = rb_event_index(event);
-	addr &= PAGE_MASK;
+	addr &= BUF_PAGE_MASK;
 
 	return cpu_buffer->commit_page->page == (void *)addr &&
 		rb_commit_index(cpu_buffer) == index;
@@ -743,7 +745,7 @@ rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
 	unsigned long index;
 
 	index = rb_event_index(event);
-	addr &= PAGE_MASK;
+	addr &= BUF_PAGE_MASK;
 
 	while (cpu_buffer->commit_page->page != (void *)addr) {
 		RB_WARN_ON(cpu_buffer,


