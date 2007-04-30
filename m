Return-Path: <linux-kernel-owner+w=401wt.eu-S1422975AbXD3ExU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422975AbXD3ExU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422984AbXD3ExU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:53:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46445 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422975AbXD3ExT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:53:19 -0400
Date: Sun, 29 Apr 2007 21:53:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org
Subject: Slab allocators: Remove useless __GFP_NO_GROW flag (fwd)
Message-ID: <Pine.LNX.4.64.0704292152430.1788@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to CC lkml.

---------- Forwarded message ----------
Date: Sun, 29 Apr 2007 21:52:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Subject: Slab allocators: Remove useless __GFP_NO_GROW flag

There is no user remaining and I have never seen any use of that flag.

Sorry, I overlooked it when reviewing slab flags. It was hidden in the
GFP flags and I only spotted it when looking at the antifrag patches. The
"Slab internal use" comment got my attention because there is no such 
internal use. It is never set. I could also find no outside user.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/gfp.h |    3 +--
 mm/slab.c           |    6 ++----
 mm/slub.c           |    3 ---
 3 files changed, 3 insertions(+), 9 deletions(-)

Index: slub/include/linux/gfp.h
===================================================================
--- slub.orig/include/linux/gfp.h	2007-04-29 21:33:53.000000000 -0700
+++ slub/include/linux/gfp.h	2007-04-29 21:41:05.000000000 -0700
@@ -43,7 +43,6 @@ struct vm_area_struct;
 #define __GFP_REPEAT	((__force gfp_t)0x400u)	/* Retry the allocation.  Might fail */
 #define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* Retry for ever.  Cannot fail */
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* Do not retry.  Might fail */
-#define __GFP_NO_GROW	((__force gfp_t)0x2000u)/* Slab internal usage */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
@@ -58,7 +57,7 @@ struct vm_area_struct;
 /* if you forget to add the bitmask here kernel will crash, period */
 #define GFP_LEVEL_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS| \
 			__GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
-			__GFP_NOFAIL|__GFP_NORETRY|__GFP_NO_GROW|__GFP_COMP| \
+			__GFP_NOFAIL|__GFP_NORETRY|__GFP_COMP| \
 			__GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE| \
 			__GFP_RECLAIMABLE|__GFP_MOVABLE)
 
Index: slub/mm/slab.c
===================================================================
--- slub.orig/mm/slab.c	2007-04-29 21:34:24.000000000 -0700
+++ slub/mm/slab.c	2007-04-29 21:34:49.000000000 -0700
@@ -2722,9 +2722,7 @@ static int cache_grow(struct kmem_cache 
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK | __GFP_NO_GROW));
-	if (flags & __GFP_NO_GROW)
-		return 0;
+	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
 
 	ctor_flags = SLAB_CTOR_CONSTRUCTOR;
 	local_flags = (flags & GFP_LEVEL_MASK);
@@ -3228,7 +3226,7 @@ retry:
 					flags | GFP_THISNODE, nid);
 	}
 
-	if (!obj && !(flags & __GFP_NO_GROW)) {
+	if (!obj) {
 		/*
 		 * This allocation will be performed within the constraints
 		 * of the current cpuset / memory policy requirements.
Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-04-29 21:34:13.000000000 -0700
+++ slub/mm/slub.c	2007-04-29 21:34:20.000000000 -0700
@@ -822,9 +822,6 @@ static struct page *new_slab(struct kmem
 	void *last;
 	void *p;
 
-	if (flags & __GFP_NO_GROW)
-		return NULL;
-
 	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
 
 	if (flags & __GFP_WAIT)
