Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbYEHVsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbYEHVsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYEHVsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:48:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50867 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551AbYEHVsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:48:12 -0400
Date: Fri, 9 May 2008 00:48:00 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: mingo@elte.hu, clameter@sgi.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slab: add kmemcheck hooks
In-Reply-To: <19f34abd0805081424v2a42d8c6t2ee795287eace3ae@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805090045440.5126@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0805090003120.28488@sbz-30.cs.Helsinki.FI>
 <19f34abd0805081424v2a42d8c6t2ee795287eace3ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Vegard Nossum wrote:
> slab.c is probably unlikely to be changed anyway, but Andrew suggested
> to insert these things not at the end, but somewhere in the middle, as
> it is less likely to conflict.

[snip]

> (And put it in the middle to keep Andrew happy.)
> 
> Probably needless to say, but this is GREAT work... Such a small patch too...

Well, Andrew is supposed to send patches that touch mm/slab.c to me so I 
didn't change those #include directives ;-)

I've fixed up other problems you pointed out in the following patch. 
Thanks!

			Pekka

[PATCH 3/3] slab: add kmemcheck hooks
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
 arch/x86/Kconfig.debug |    3 ++-
 mm/Makefile            |    5 +----
 mm/slab.c              |   21 +++++++++++++++++++--
 3 files changed, 22 insertions(+), 7 deletions(-)

Index: kmemcheck/arch/x86/Kconfig.debug
===================================================================
--- kmemcheck.orig/arch/x86/Kconfig.debug	2008-05-09 00:44:29.000000000 +0300
+++ kmemcheck/arch/x86/Kconfig.debug	2008-05-09 00:44:40.000000000 +0300
@@ -246,8 +246,9 @@
 	bool "kmemcheck: trap use of uninitialized memory"
 	depends on X86_32
 	depends on !X86_USE_3DNOW
+	depends on SLUB || SLAB
 	depends on !CC_OPTIMIZE_FOR_SIZE
-	depends on !DEBUG_PAGEALLOC && SLUB
+	depends on !DEBUG_PAGEALLOC
 	select FRAME_POINTER
 	select STACKTRACE
 	default n
Index: kmemcheck/mm/slab.c
===================================================================
--- kmemcheck.orig/mm/slab.c	2008-05-09 00:44:37.000000000 +0300
+++ kmemcheck/mm/slab.c	2008-05-09 00:44:40.000000000 +0300
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
Index: kmemcheck/mm/Makefile
===================================================================
--- kmemcheck.orig/mm/Makefile	2008-05-09 00:44:29.000000000 +0300
+++ kmemcheck/mm/Makefile	2008-05-09 00:45:01.000000000 +0300
@@ -27,13 +27,10 @@
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_KMEMCHECK) += slub_kmemcheck.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
-
-ifeq ($(CONFIG_KMEMCHECK),y)
-obj-$(CONFIG_SLUB) += slub_kmemcheck.o
-endif
