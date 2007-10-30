Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbXJ3QTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbXJ3QTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXJ3QOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:14:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbXJ3QON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:14:13 -0400
Message-Id: <20071030160912.533392000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:11 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/33] mm: __GFP_MEMALLOC
Content-Disposition: inline; filename=mm-page_alloc-GFP_EMERGENCY.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__GFP_MEMALLOC will allow the allocation to disregard the watermarks, 
much like PF_MEMALLOC.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/gfp.h |    3 ++-
 mm/page_alloc.c     |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/gfp.h
===================================================================
--- linux-2.6.orig/include/linux/gfp.h
+++ linux-2.6/include/linux/gfp.h
@@ -43,6 +43,7 @@ struct vm_area_struct;
 #define __GFP_REPEAT	((__force gfp_t)0x400u)	/* Retry the allocation.  Might fail */
 #define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* Retry for ever.  Cannot fail */
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* Do not retry.  Might fail */
+#define __GFP_MEMALLOC  ((__force gfp_t)0x2000u)/* Use emergency reserves */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
@@ -88,7 +89,7 @@ struct vm_area_struct;
 /* Control page allocator reclaim behavior */
 #define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
 			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
-			__GFP_NORETRY|__GFP_NOMEMALLOC)
+			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
 
 /* Control allocation constraints */
 #define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -1560,7 +1560,9 @@ int gfp_to_alloc_flags(gfp_t gfp_mask)
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
-		if (!in_irq() && (p->flags & PF_MEMALLOC))
+		if (gfp_mask & __GFP_MEMALLOC)
+			alloc_flags |= ALLOC_NO_WATERMARKS;
+		else if (!in_irq() && (p->flags & PF_MEMALLOC))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 		else if (!in_interrupt() &&
 				unlikely(test_thread_flag(TIF_MEMDIE)))

--

