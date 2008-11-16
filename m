Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYKPEiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYKPEiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbYKPEhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:37:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbYKPEhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:37:10 -0500
Message-ID: <491FA2AF.3090304@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 12:33:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] relay: use simple_malloc()/simple_free()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


simple_malloc()/simple_free() are same as current code.
so we simple_malloc()/simple_free() instead of current code.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/relay.c b/kernel/relay.c
index 8d13a78..718dd60 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -65,35 +65,6 @@ static struct vm_operations_struct relay_file_mmap_ops = {
 	.close = relay_file_mmap_close,
 };
 
-/*
- * allocate an array of pointers of struct page
- */
-static struct page **relay_alloc_page_array(unsigned int n_pages)
-{
-	struct page **array;
-	size_t pa_size = n_pages * sizeof(struct page *);
-
-	if (pa_size > PAGE_SIZE) {
-		array = vmalloc(pa_size);
-		if (array)
-			memset(array, 0, pa_size);
-	} else {
-		array = kzalloc(pa_size, GFP_KERNEL);
-	}
-	return array;
-}
-
-/*
- * free an array of pointers of struct page
- */
-static void relay_free_page_array(struct page **array)
-{
-	if (is_vmalloc_addr(array))
-		vfree(array);
-	else
-		kfree(array);
-}
-
 /**
  *	relay_mmap_buf: - mmap channel buffer to process address space
  *	@buf: relay channel buffer
@@ -138,9 +109,10 @@ static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
 	*size = PAGE_ALIGN(*size);
 	n_pages = *size >> PAGE_SHIFT;
 
-	buf->page_array = relay_alloc_page_array(n_pages);
+	buf->page_array = simple_malloc(sizeof(struct page *) * n_pages);
 	if (!buf->page_array)
 		return NULL;
+	memset(buf->page_array, 0, sizeof(struct page *) * n_pages);
 
 	for (i = 0; i < n_pages; i++) {
 		buf->page_array[i] = alloc_page(GFP_KERNEL);
@@ -159,7 +131,7 @@ static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
 depopulate:
 	for (j = 0; j < i; j++)
 		__free_page(buf->page_array[j]);
-	relay_free_page_array(buf->page_array);
+	simple_free(buf->page_array);
 	return NULL;
 }
 
@@ -218,7 +190,7 @@ static void relay_destroy_buf(struct rchan_buf *buf)
 		vunmap(buf->start);
 		for (i = 0; i < buf->page_count; i++)
 			__free_page(buf->page_array[i]);
-		relay_free_page_array(buf->page_array);
+		simple_free(buf->page_array);
 	}
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf->padding);


