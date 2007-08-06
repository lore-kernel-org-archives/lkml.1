Return-Path: <linux-kernel-owner+w=401wt.eu-S1764299AbXHFKqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764299AbXHFKqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXHFKo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:44:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbXHFKo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:44:57 -0400
Message-Id: <20070806103659.527197000@chello.nl>
References: <20070806102922.907530000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 06 Aug 2007 12:29:32 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: [PATCH 10/10] mm: __GFP_MEMALLOC
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

Index: linux-2.6-2/include/linux/gfp.h
===================================================================
--- linux-2.6-2.orig/include/linux/gfp.h
+++ linux-2.6-2/include/linux/gfp.h
@@ -43,6 +43,7 @@ struct vm_area_struct;
 #define __GFP_REPEAT	((__force gfp_t)0x400u)	/* Retry the allocation.  Might fail */
 #define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* Retry for ever.  Cannot fail */
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* Do not retry.  Might fail */
+#define __GFP_MEMALLOC  ((__force gfp_t)0x2000u)/* Use emergency reserves */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
@@ -56,7 +57,7 @@ struct vm_area_struct;
 /* if you forget to add the bitmask here kernel will crash, period */
 #define GFP_LEVEL_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS| \
 			__GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
-			__GFP_NOFAIL|__GFP_NORETRY|__GFP_COMP| \
+			__GFP_NOFAIL|__GFP_NORETRY|__GFP_MEMALLOC|__GFP_COMP| \
 			__GFP_NOMEMALLOC|__GFP_HARDWALL|__GFP_THISNODE| \
 			__GFP_MOVABLE)
 
Index: linux-2.6-2/mm/page_alloc.c
===================================================================
--- linux-2.6-2.orig/mm/page_alloc.c
+++ linux-2.6-2/mm/page_alloc.c
@@ -1242,7 +1242,9 @@ int gfp_to_alloc_flags(gfp_t gfp_mask)
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

