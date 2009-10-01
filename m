Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbZJAOF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbZJAOF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZJAOFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:05:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36114 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbZJAOFV (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Thu, 1 Oct 2009 10:05:21 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH 10/31] mm: __GFP_MEMALLOC
Date: Thu,  1 Oct 2009 19:36:33 +0530
Message-Id: <1254405993-16012-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl> 

__GFP_MEMALLOC will allow the allocation to disregard the watermarks, 
much like PF_MEMALLOC.

It allows one to pass along the memalloc state in object related allocation
flags as opposed to task related flags, such as sk->sk_allocation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 include/linux/gfp.h |    3 ++-
 mm/page_alloc.c     |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: mmotm/include/linux/gfp.h
===================================================================
--- mmotm.orig/include/linux/gfp.h
+++ mmotm/include/linux/gfp.h
@@ -46,6 +46,7 @@ struct vm_area_struct;
 #define __GFP_REPEAT	((__force gfp_t)0x400u)	/* See above */
 #define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* See above */
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* See above */
+#define __GFP_MEMALLOC  ((__force gfp_t)0x2000u)/* Use emergency reserves */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
@@ -96,7 +97,7 @@ struct vm_area_struct;
 /* Control page allocator reclaim behavior */
 #define GFP_RECLAIM_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS|\
 			__GFP_NOWARN|__GFP_REPEAT|__GFP_NOFAIL|\
-			__GFP_NORETRY|__GFP_NOMEMALLOC)
+			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
 
 /* Control slab gfp mask during early boot */
 #define GFP_BOOT_MASK __GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS)
Index: mmotm/mm/page_alloc.c
===================================================================
--- mmotm.orig/mm/page_alloc.c
+++ mmotm/mm/page_alloc.c
@@ -1710,7 +1710,9 @@ int gfp_to_alloc_flags(gfp_t gfp_mask)
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
-		if (!in_irq() && (p->flags & PF_MEMALLOC))
+		if (gfp_mask & __GFP_MEMALLOC)
+			alloc_flags |= ALLOC_NO_WATERMARKS;
+		else if (!in_irq() && (p->flags & PF_MEMALLOC))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 		else if (!in_interrupt() &&
 				unlikely(test_thread_flag(TIF_MEMDIE)))
