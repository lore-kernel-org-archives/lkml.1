Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbYEHVD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbYEHVD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761358AbYEHVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:03:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48560 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760753AbYEHVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:03:44 -0400
Date: Fri, 9 May 2008 00:03:43 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
cc: clameter@sgi.com, akpm@linux-foundation.org, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] slab: add kmemcheck hooks
Message-ID: <Pine.LNX.4.64.0805090003120.28488@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Add kmemcheck hooks to SLAB. Note: this only works if you force SLAB to use
compound pages manually. I didn't change SLAB to use them though as Vegard has
a fix on the way to make kmemcheck work with non-compound pages.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/Kconfig.debug |    2 +-
 mm/slab.c              |   21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

Index: kmemcheck/arch/x86/Kconfig.debug
===================================================================
--- kmemcheck.orig/arch/x86/Kconfig.debug	2008-05-08 23:50:38.000000000 +0300
+++ kmemcheck/arch/x86/Kconfig.debug	2008-05-08 23:50:46.000000000 +0300
@@ -247,7 +247,7 @@
 	depends on X86
 	depends on !X86_USE_3DNOW
 	depends on !CC_OPTIMIZE_FOR_SIZE
-	depends on !DEBUG_PAGEALLOC && SLUB
+	depends on !DEBUG_PAGEALLOC && (SLUB || SLAB)
 	select FRAME_POINTER
 	select STACKTRACE
 	default n
Index: kmemcheck/mm/slab.c
===================================================================
--- kmemcheck.orig/mm/slab.c	2008-05-08 23:50:45.000000000 +0300
+++ kmemcheck/mm/slab.c	2008-05-08 23:50:46.000000000 +0300
@@ -111,6 +111,8 @@
 #include	<linux/rtmutex.h>
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
+#include	<linux/kmemcheck.h>
+#include	<linux/slub_kmemcheck.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -176,13 +178,13 @@
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
@@ -1611,6 +1613,10 @@
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 	for (i = 0; i < nr_pages; i++)
 		__SetPageSlab(page + i);
+
+	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK))
+		kmemcheck_alloc_shadow(cachep, flags, nodeid, page, cachep->gfporder);
+
 	return page_address(page);
 }
 
@@ -1623,6 +1629,9 @@
 	struct page *page = virt_to_page(addr);
 	const unsigned long nr_freed = i;
 
+	if (kmemcheck_page_is_tracked(page) && !(cachep->flags & SLAB_NOTRACK))
+		kmemcheck_free_shadow(cachep, page, cachep->gfporder);
+
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		sub_zone_page_state(page_zone(page),
 				NR_SLAB_RECLAIMABLE, nr_freed);
@@ -3337,6 +3346,9 @@
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 
+	if (likely(ptr))
+		kmemcheck_slab_alloc(cachep, flags, ptr, obj_size(cachep));
+
 	if (unlikely((flags & __GFP_ZERO) && ptr))
 		memset(ptr, 0, obj_size(cachep));
 
@@ -3391,6 +3403,9 @@
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	prefetchw(objp);
 
+	if (likely(objp))
+		kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
+
 	if (unlikely((flags & __GFP_ZERO) && objp))
 		memset(objp, 0, obj_size(cachep));
 
@@ -3506,6 +3521,8 @@
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
+	kmemcheck_slab_free(cachep, objp, obj_size(cachep));
+
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
 	 * This will avoid cache misses that happen while accessing slabp (which
