Return-Path: <linux-kernel-owner+w=401wt.eu-S936724AbYEUS0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936724AbYEUS0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932826AbYEUSZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:25:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44138 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769AbYEUSZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:25:57 -0400
Date: Wed, 21 May 2008 21:25:56 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: clameter@sgi.com, mpm@selenic.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: [RFC/PATCH 2/3] SLUB: make ksize() more strict for page allocator
 pass-through
Message-ID: <Pine.LNX.4.64.0805212125310.22291@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch changes ksize() to be more strict with objets passed to it. We now
set PageSlab also for objects allocated with page allocator and use page->slab
to check whether page is a regular slab page or a pass-through page.

Also moves kmalloc_large() out-of-line as it's too big for inlining now.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slub_def.h |    5 +----
 mm/slub.c                |   34 ++++++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 71e43a1..542f828 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -201,10 +201,7 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
-{
-	return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
-}
+void *kmalloc_large(size_t, gfp_t);
 
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
diff --git a/mm/slub.c b/mm/slub.c
index a505a82..84b9689 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2687,15 +2687,29 @@ void *__kmalloc(size_t size, gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc);
 
+void *kmalloc_large(size_t size, gfp_t flags)
+{
+	struct page *page;
+
+	page = alloc_pages(flags | __GFP_COMP, get_order(size));
+	if (!page)
+		return NULL;
+
+	__SetPageSlab(page);
+	return page_address(page);
+}
+EXPORT_SYMBOL(kmalloc_large);
+
 static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
 	struct page *page = alloc_pages_node(node, flags | __GFP_COMP,
 						get_order(size));
 
-	if (page)
-		return page_address(page);
-	else
+	if (!page)
 		return NULL;
+
+	__SetPageSlab(page);
+	return page_address(page);
 }
 
 #ifdef CONFIG_NUMA
@@ -2725,12 +2739,12 @@ size_t ksize(const void *object)
 		return 0;
 
 	page = virt_to_head_page(object);
+	BUG_ON(!PageSlab(page));
+	s = page->slab;
 
-	if (unlikely(!PageSlab(page)))
+	if (unlikely(!s))
 		return PAGE_SIZE << compound_order(page);
 
-	s = page->slab;
-
 #ifdef CONFIG_SLUB_DEBUG
 	/*
 	 * Debugging requires use of the padding between object
@@ -2756,6 +2770,7 @@ EXPORT_SYMBOL(ksize);
 
 void kfree(const void *x)
 {
+	struct kmem_cache *s;
 	struct page *page;
 	void *object = (void *)x;
 
@@ -2763,11 +2778,14 @@ void kfree(const void *x)
 		return;
 
 	page = virt_to_head_page(x);
-	if (unlikely(!PageSlab(page))) {
+	BUG_ON(!PageSlab(page));
+	s = page->slab;
+	if (unlikely(!s)) {
+		__ClearPageSlab(page);
 		put_page(page);
 		return;
 	}
-	slab_free(page->slab, page, object, __builtin_return_address(0));
+	slab_free(s, page, object, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kfree);
 
-- 
1.5.2.5

