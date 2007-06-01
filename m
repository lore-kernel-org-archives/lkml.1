Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbXFALOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbXFALOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbXFALOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:14:09 -0400
Received: from rex.snapgear.com ([203.143.235.140]:48567 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757431AbXFALOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:14:07 -0400
Date: Fri, 1 Jun 2007 21:12:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200706011112.l51BCsef023581@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: remove old cache management cruft from mm code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove cache management cruft. This code is dead, all the cache
manangement functions for the ColdFire exist in the header file
include/asm-m68knommu/cacheflush.h.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---



diff -Naur linux-2.6.21/arch/m68knommu/mm/memory.c linux-2.6.21-uc0/arch/m68knommu/mm/memory.c
--- linux-2.6.21/arch/m68knommu/mm/memory.c	2007-05-01 17:12:42.000000000 +1000
+++ linux-2.6.21-uc0/arch/m68knommu/mm/memory.c	2007-05-01 17:16:11.000000000 +1000
@@ -17,90 +17,14 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
-#include <asm/setup.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/traps.h>
-#include <asm/io.h>
 
 /*
- * cache_clear() semantics: Clear any cache entries for the area in question,
- * without writing back dirty entries first. This is useful if the data will
- * be overwritten anyway, e.g. by DMA to memory. The range is defined by a
- * _physical_ address.
- */
-
-void cache_clear (unsigned long paddr, int len)
-{
-}
-
-
-/*
- *	Define cache invalidate functions. The ColdFire 5407 is really
- *	the only processor that needs to do some work here. Anything
- *	that has separate data and instruction caches will be a problem.
- */
-#ifdef CONFIG_M5407
-
-static __inline__ void cache_invalidate_lines(unsigned long paddr, int len)
-{
-	unsigned long	sset, eset;
-
-	sset = (paddr & 0x00000ff0);
-	eset = ((paddr + len) & 0x0000ff0) + 0x10;
-
-	__asm__ __volatile__ (
-		"nop\n\t"
-		"clrl	%%d0\n\t"
-		"1:\n\t"
-		"movel	%0,%%a0\n\t"
-		"addl	%%d0,%%a0\n\t"
-		"2:\n\t"
-		".word	0xf4e8\n\t"
-		"addl	#0x10,%%a0\n\t"
-		"cmpl	%1,%%a0\n\t"
-		"blt	2b\n\t"
-		"addql	#1,%%d0\n\t"
-		"cmpil	#4,%%d0\n\t"
-		"bne	1b"
-		: : "a" (sset), "a" (eset) : "d0", "a0" );
-}
-
-#else
-#define	cache_invalidate_lines(a,b)
-#endif
-
-
-/*
- * cache_push() semantics: Write back any dirty cache data in the given area,
- * and invalidate the range in the instruction cache. It needs not (but may)
- * invalidate those entries also in the data cache. The range is defined by a
- * _physical_ address.
- */
-
-void cache_push (unsigned long paddr, int len)
-{
-	cache_invalidate_lines(paddr, len);
-}
-
-
-/*
- * cache_push_v() semantics: Write back any dirty cache data in the given
- * area, and invalidate those entries at least in the instruction cache. This
- * is intended to be used after data has been written that can be executed as
- * code later. The range is defined by a _user_mode_ _virtual_ address  (or,
- * more exactly, the space is defined by the %sfc/%dfc register.)
- */
-
-void cache_push_v (unsigned long vaddr, int len)
-{
-	cache_invalidate_lines(vaddr, len);
-}
-
-/* Map some physical address range into the kernel address space. The
- * code is copied and adapted from map_chunk().
+ * Map some physical address range into the kernel address space.
+ * The code is copied and adapted from map_chunk().
  */
 
 unsigned long kernel_map(unsigned long paddr, unsigned long size,
