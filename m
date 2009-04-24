Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbZDXQng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbZDXQng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759649AbZDXQmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:23 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41574 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759676AbZDXQmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:22 -0400
Subject: [PATCH 04/14] kmemleak: Add the slob memory allocation/freeing hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Date: Fri, 24 Apr 2009 17:41:20 +0100
Message-ID: <20090424164120.4476.94110.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:05.0299 (UTC) FILETIME=[99CD8C30:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to kmemleak_(alloc|free) functions from the
slob allocator.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slob.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index a2d4ab3..3e7acbc 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -60,6 +60,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/kmemleak.h>
 #include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -506,6 +507,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 				   size, PAGE_SIZE << order, gfp, node);
 	}
 
+	kmemleak_alloc(ret, size, 1, gfp);
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
@@ -518,6 +520,7 @@ void kfree(const void *block)
 
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
+	kmemleak_free(block);
 
 	sp = slob_page(block);
 	if (is_slob_page(sp)) {
@@ -581,12 +584,14 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	} else if (flags & SLAB_PANIC)
 		panic("Cannot create slab cache %s\n", name);
 
+	kmemleak_alloc(c, sizeof(struct kmem_cache), 1, GFP_KERNEL);
 	return c;
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *c)
 {
+	kmemleak_free(c);
 	slob_free(c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
@@ -610,6 +615,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 	if (c->ctor)
 		c->ctor(b);
 
+	kmemleak_alloc_recursive(b, c->size, 1, c->flags, flags);
 	return b;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
@@ -632,6 +638,7 @@ static void kmem_rcu_free(struct rcu_head *head)
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
+	kmemleak_free_recursive(b, c->flags);
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));

