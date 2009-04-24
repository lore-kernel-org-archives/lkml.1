Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbZDXQmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbZDXQmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbZDXQmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:03 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41488 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758094AbZDXQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:01 -0400
Subject: [PATCH 03/14] kmemleak: Add the slab memory allocation/freeing hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 24 Apr 2009 17:41:15 +0100
Message-ID: <20090424164115.4476.39183.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:41:59.0659 (UTC) FILETIME=[9670F3B0:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to kmemleak_(alloc|free) functions from
the slab allocator. The patch also adds the SLAB_NOLEAKTRACE flag to
avoid recursive calls to kmemleak when it allocates its own data
structures.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab.h |    2 ++
 mm/slab.c            |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 24c5602..4880306 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -62,6 +62,8 @@
 # define SLAB_DEBUG_OBJECTS	0x00000000UL
 #endif
 
+#define SLAB_NOLEAKTRACE	0x00800000UL	/* Avoid kmemleak tracing */
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff --git a/mm/slab.c b/mm/slab.c
index 9a90b00..d51454e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -107,6 +107,7 @@
 #include	<linux/string.h>
 #include	<linux/uaccess.h>
 #include	<linux/nodemask.h>
+#include	<linux/kmemleak.h>
 #include	<linux/mempolicy.h>
 #include	<linux/mutex.h>
 #include	<linux/fault-inject.h>
@@ -178,13 +179,13 @@
 			 SLAB_STORE_USER | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOLEAKTRACE)
 #else
 # define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOLEAKTRACE)
 #endif
 
 /*
@@ -964,6 +965,14 @@ static struct array_cache *alloc_arraycache(int node, int entries,
 	struct array_cache *nc = NULL;
 
 	nc = kmalloc_node(memsize, GFP_KERNEL, node);
+	/*
+	 * The array_cache structures contain pointers to free object.
+	 * However, when such objects are allocated or transfered to another
+	 * cache the pointers are not cleared and they could be counted as
+	 * valid references during a kmemleak scan. Therefore, kmemleak must
+	 * not scan such objects.
+	 */
+	kmemleak_no_scan(nc);
 	if (nc) {
 		nc->avail = 0;
 		nc->limit = entries;
@@ -2621,6 +2630,14 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
 					      local_flags, nodeid);
+		/*
+		 * If the first object in the slab is leaked (it's allocated
+		 * but no one has a reference to it), we want to make sure
+		 * kmemleak does not treat the ->s_mem pointer as a reference
+		 * to the object. Otherwise we will not report the leak.
+		 */
+		kmemleak_scan_area(slabp, offsetof(struct slab, list),
+				   sizeof(struct list_head), local_flags);
 		if (!slabp)
 			return NULL;
 	} else {
@@ -3141,6 +3158,12 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 		STATS_INC_ALLOCMISS(cachep);
 		objp = cache_alloc_refill(cachep, flags);
 	}
+	/*
+	 * To avoid a false negative, if an object that is in one of the
+	 * per-CPU caches is leaked, we need to make sure kmemleak doesn't
+	 * treat the array pointers as a reference to the object.
+	 */
+	kmemleak_erase(&ac->entry[ac->avail]);
 	return objp;
 }
 
@@ -3360,6 +3383,8 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
   out:
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
+	kmemleak_alloc_recursive(ptr, obj_size(cachep), 1, cachep->flags,
+				 flags);
 
 	if (unlikely((flags & __GFP_ZERO) && ptr))
 		memset(ptr, 0, obj_size(cachep));
@@ -3415,6 +3440,8 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	objp = __do_cache_alloc(cachep, flags);
 	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
+	kmemleak_alloc_recursive(objp, obj_size(cachep), 1, cachep->flags,
+				 flags);
 	prefetchw(objp);
 
 	if (unlikely((flags & __GFP_ZERO) && objp))
@@ -3530,6 +3557,7 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
+	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
 	/*

