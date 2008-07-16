Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbYGPA05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbYGPA05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758406AbYGPAZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:25:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099AbYGPAZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=pFAkuPewI6/9j+FQsBESTAxB4QQN/ufEWNaD1TDTLtUJVFpC5W7VeQaRi/GYgmiueN
         9OjQnr/ADwPHvX7aQvMQaNG/3DSVS01WZFGH3Huq9MMAN6My6WPSJYkj3v35GNSQbI9I
         EQ8OWhoDdYSIzyagOUdos4V/nAx42sUX9v0Yw=
Date: Wed, 16 Jul 2008 02:24:44 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/13] slab: add hooks for kmemcheck
Message-ID: <20080716002444.GM12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4676a60f81caf87e9c0e0e71af49bdaf83fbb567 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 9 May 2008 20:35:53 +0200
Subject: [PATCH 12/13] slab: add hooks for kmemcheck

We now have SLAB support for kmemcheck! This means that it doesn't matter
whether one chooses SLAB or SLUB, or indeed whether Linus chooses to chuck
SLAB or SLUB.. ;-)

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 mm/slab.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 8986265..9c44366 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -111,6 +111,7 @@
 #include	<linux/rtmutex.h>
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
+#include	<linux/kmemcheck.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -176,13 +177,13 @@
 			 SLAB_STORE_USER | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
 #else
 # define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
 #endif
 
 /*
@@ -1611,6 +1612,10 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 	for (i = 0; i < nr_pages; i++)
 		__SetPageSlab(page + i);
+
+	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK))
+		kmemcheck_alloc_shadow(cachep, flags, nodeid, page, cachep->gfporder);
+
 	return page_address(page);
 }
 
@@ -1623,6 +1628,9 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 	struct page *page = virt_to_page(addr);
 	const unsigned long nr_freed = i;
 
+	if (kmemcheck_page_is_tracked(page))
+		kmemcheck_free_shadow(cachep, page, cachep->gfporder);
+
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		sub_zone_page_state(page_zone(page),
 				NR_SLAB_RECLAIMABLE, nr_freed);
@@ -3340,6 +3348,9 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 
+	if (likely(ptr))
+		kmemcheck_slab_alloc(cachep, flags, ptr, obj_size(cachep));
+
 	if (unlikely((flags & __GFP_ZERO) && ptr))
 		memset(ptr, 0, obj_size(cachep));
 
@@ -3394,6 +3405,9 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	prefetchw(objp);
 
+	if (likely(objp))
+		kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
+
 	if (unlikely((flags & __GFP_ZERO) && objp))
 		memset(objp, 0, obj_size(cachep));
 
@@ -3509,6 +3523,8 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
+	kmemcheck_slab_free(cachep, objp, obj_size(cachep));
+
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
 	 * This will avoid cache misses that happen while accessing slabp (which
-- 
1.5.5.1

