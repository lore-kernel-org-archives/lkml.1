Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYLJS2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYLJS2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYLJS12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:27:28 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33197 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbYLJS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:27:27 -0500
Subject: [PATCH 04/15] kmemleak: Add the slob memory allocation/freeing hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Date: Wed, 10 Dec 2008 18:27:16 +0000
Message-ID: <20081210182716.30323.13359.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:27:16.0513 (UTC) FILETIME=[EDD02110:01C95AF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to memleak_(alloc|free) functions from the
slob allocator.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slob.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index cb675d1..ff5a98d 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -60,6 +60,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/memleak.h>
 #include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -463,6 +464,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
 	unsigned int *m;
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	void *ret;
 
 	if (size < PAGE_SIZE - align) {
 		if (!size)
@@ -472,18 +474,18 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 		if (!m)
 			return NULL;
 		*m = size;
-		return (void *)m + align;
+		ret = (void *)m + align;
 	} else {
-		void *ret;
-
 		ret = slob_new_page(gfp | __GFP_COMP, get_order(size), node);
 		if (ret) {
 			struct page *page;
 			page = virt_to_page(ret);
 			page->private = size;
 		}
-		return ret;
 	}
+
+	memleak_alloc(ret, size, 1, gfp);
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 
@@ -493,6 +495,7 @@ void kfree(const void *block)
 
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
+	memleak_free(block);
 
 	sp = (struct slob_page *)virt_to_page(block);
 	if (slob_page(sp)) {
@@ -555,12 +558,14 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	} else if (flags & SLAB_PANIC)
 		panic("Cannot create slab cache %s\n", name);
 
+	memleak_alloc(c, sizeof(struct kmem_cache), 1, GFP_KERNEL);
 	return c;
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *c)
 {
+	memleak_free(c);
 	slob_free(c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
@@ -577,6 +582,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 	if (c->ctor)
 		c->ctor(b);
 
+	memleak_alloc_recursive(b, c->size, 1, c->flags, flags);
 	return b;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
@@ -599,6 +605,7 @@ static void kmem_rcu_free(struct rcu_head *head)
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
+	memleak_free_recursive(b, c->flags);
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));

