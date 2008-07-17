Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbYGQAtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbYGQAtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759939AbYGQAs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:48:29 -0400
Received: from ag-out-0708.google.com ([72.14.246.249]:37632 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598AbYGQAs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=bMZe4S+uGvp58Lb5LWS5PGY71q33h3GAWfX6IBwXcWaUoGu6/68sLcUTxLim87gRJ/
         W5Nqd9f3Pbso9CaXl59YFiHkQ6EfXJRZYxr/nHN4ibmOMQv83vRx9SMprFP2lk1oaINv
         Ez+lLs+b1N3Tlig7v5foiFAuHpUXvTcf0KApo=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/4] kmemtrace: SLUB hooks.
Date: Thu, 17 Jul 2008 03:46:47 +0300
Message-Id: <017a63e6be64502c36ede4733f0cc4e5ede75db2.1216255035.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <99a4b0edd280049b57a400b5934714ad66ea5788.1216255035.git.eduard.munteanu@linux360.ro>
References: <cover.1216255034.git.eduard.munteanu@linux360.ro>
 <4472a3f883b0d9026bb2d8c490233b3eadf9b55e.1216255035.git.eduard.munteanu@linux360.ro>
 <99a4b0edd280049b57a400b5934714ad66ea5788.1216255035.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1216255034.git.eduard.munteanu@linux360.ro>
References: <cover.1216255034.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds hooks for the SLUB allocator, to allow tracing with kmemtrace.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/slub_def.h |    9 +++++++-
 mm/slub.c                |   47 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index d117ea2..0cef121 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -10,6 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
+#include <linux/kmemtrace.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
@@ -205,7 +206,13 @@ void *__kmalloc(size_t size, gfp_t flags);
 
 static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 {
-	return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
+	unsigned int order = get_order(size);
+	void *ret = (void *) __get_free_pages(flags, order);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KERNEL, _THIS_IP_, ret,
+			     size, PAGE_SIZE << order, flags);
+
+	return ret;
 }
 
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
diff --git a/mm/slub.c b/mm/slub.c
index 315c392..a6f930f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -23,6 +23,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
 #include <linux/math64.h>
+#include <linux/kmemtrace.h>
 
 /*
  * Lock order:
@@ -1652,14 +1653,25 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+	void *ret = slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			     s->objsize, s->size, gfpflags);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	void *ret = slab_alloc(s, gfpflags, node,
+			       __builtin_return_address(0));
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+				  s->objsize, s->size, gfpflags, node);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -1771,6 +1783,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 	page = virt_to_head_page(x);
 
 	slab_free(s, page, x, __builtin_return_address(0));
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2676,6 +2690,7 @@ static struct kmem_cache *get_slab(size_t size, gfp_t flags)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large(size, flags);
@@ -2685,7 +2700,12 @@ void *__kmalloc(size_t size, gfp_t flags)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, -1, __builtin_return_address(0));
+	ret = slab_alloc(s, flags, -1, __builtin_return_address(0));
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KERNEL, _RET_IP_, ret,
+			     size, (size_t) s->size, (unsigned long) flags);
+
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2704,16 +2724,29 @@ static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	struct kmem_cache *s;
+	void *ret;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large_node(size, flags, node);
+	if (unlikely(size > PAGE_SIZE)) {
+		ret = kmalloc_large_node(size, flags, node);
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KERNEL, _RET_IP_, ret,
+					  size, PAGE_SIZE << get_order(size),
+					  (unsigned long) flags, node);
+
+		return ret;
+	}
 
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, node, __builtin_return_address(0));
+	ret = slab_alloc(s, flags, node, __builtin_return_address(0));
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KERNEL, _RET_IP_, ret,
+				  size, s->size, (unsigned long) flags, node);
+
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2771,6 +2804,8 @@ void kfree(const void *x)
 		return;
 	}
 	slab_free(page->slab, page, object, __builtin_return_address(0));
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_KERNEL, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
-- 
1.5.6.1

