Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbYGPA0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbYGPA0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbYGPAYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:24:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312AbYGPAYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=SILgn1mkObpL6IiteKeeldl9+vxTtPkKJGooMF27OXKesoQmSqiLL0jgmolOMv5gvI
         S+T6VkFgobazBJicWgTZutaXtsdFN/xVcpymXw/adL25+RRXyo1J6vJEI7c3m3K1W58H
         GIXBctlOGG4xt5cSrEqynYCmCnsOnKdh+QBo4=
Date: Wed, 16 Jul 2008 02:24:23 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] slub: add hooks for kmemcheck
Message-ID: <20080716002423.GL12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b147926bb9bfad0adf7872fd4ea4745ce9346aef Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 4 Apr 2008 00:54:48 +0200
Subject: [PATCH 11/13] slub: add hooks for kmemcheck

Parts of this patch were contributed by Pekka Enberg but merged for
atomicity.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
 mm/slub.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 315c392..dbbd455 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -23,6 +23,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
 #include <linux/math64.h>
+#include <linux/kmemcheck.h>
 
 /*
  * Lock order:
@@ -174,7 +175,7 @@ static inline void ClearSlabDebug(struct page *page)
 		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA)
+		SLAB_CACHE_DMA | SLAB_NOTRACK)
 
 #ifndef ARCH_KMALLOC_MINALIGN
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
@@ -1122,6 +1123,13 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 		stat(get_cpu_slab(s, raw_smp_processor_id()), ORDER_FALLBACK);
 	}
+
+	if (kmemcheck_enabled
+		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS)))
+	{
+		kmemcheck_alloc_shadow(s, flags, node, page, compound_order(page));
+	}
+
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -1195,6 +1203,9 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		ClearSlabDebug(page);
 	}
 
+	if (kmemcheck_page_is_tracked(page))
+		kmemcheck_free_shadow(s, page, compound_order(page));
+
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
@@ -1647,6 +1658,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, objsize);
 
+	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
 	return object;
 }
 
@@ -1751,6 +1763,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
+	kmemcheck_slab_free(s, object, c->objsize);
 	debug_check_no_locks_freed(object, c->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(object, s->objsize);
@@ -2602,7 +2615,8 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 
 	if (!s || !text || !kmem_cache_open(s, flags, text,
 			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
+			SLAB_CACHE_DMA|SLAB_NOTRACK|__SYSFS_ADD_DEFERRED,
+			NULL)) {
 		kfree(s);
 		kfree(text);
 		goto unlock_out;
@@ -4308,6 +4322,8 @@ static char *create_unique_id(struct kmem_cache *s)
 		*p++ = 'a';
 	if (s->flags & SLAB_DEBUG_FREE)
 		*p++ = 'F';
+	if (!(s->flags & SLAB_NOTRACK))
+		*p++ = 't';
 	if (p != name + 1)
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
-- 
1.5.5.1

