Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYLJS1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYLJS1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYLJS1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:27:15 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33156 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730AbYLJS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:27:13 -0500
Subject: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 10 Dec 2008 18:27:10 +0000
Message-ID: <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:27:10.0888 (UTC) FILETIME=[EA75D280:01C95AF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to memleak_(alloc|free) functions from the
slab allocator. The patch also adds the SLAB_NOLEAKTRACE flag to avoid
recursive calls to kmemleak when it allocates its own data structures.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab.h |    2 ++
 mm/slab.c            |   18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 000da12..d72ad0b 100644
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
index 0918751..d11112f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -106,6 +106,7 @@
 #include	<linux/string.h>
 #include	<linux/uaccess.h>
 #include	<linux/nodemask.h>
+#include	<linux/memleak.h>
 #include	<linux/mempolicy.h>
 #include	<linux/mutex.h>
 #include	<linux/fault-inject.h>
@@ -177,13 +178,13 @@
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
@@ -2610,6 +2611,13 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
 					      local_flags & ~GFP_THISNODE, nodeid);
+		/*
+		 * Only scan the list member to avoid false negatives
+		 * (especially caused by the s_mem pointer)
+		 */
+		memleak_scan_area(slabp, offsetof(struct slab, list),
+				  sizeof(struct list_head),
+				  local_flags & ~GFP_THISNODE);
 		if (!slabp)
 			return NULL;
 	} else {
@@ -3195,6 +3203,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 		STATS_INC_ALLOCMISS(cachep);
 		objp = cache_alloc_refill(cachep, flags);
 	}
+	/* avoid false negatives */
+	memleak_erase(&ac->entry[ac->avail]);
 	return objp;
 }
 
@@ -3412,6 +3422,7 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
   out:
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
+	memleak_alloc_recursive(ptr, obj_size(cachep), 1, cachep->flags, flags);
 
 	if (unlikely((flags & __GFP_ZERO) && ptr))
 		memset(ptr, 0, obj_size(cachep));
@@ -3465,6 +3476,8 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	objp = __do_cache_alloc(cachep, flags);
 	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
+	memleak_alloc_recursive(objp, obj_size(cachep), 1, cachep->flags,
+				flags);
 	prefetchw(objp);
 
 	if (unlikely((flags & __GFP_ZERO) && objp))
@@ -3580,6 +3593,7 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
+	memleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
 	/*

