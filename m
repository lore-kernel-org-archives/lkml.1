Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbXHWGs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbXHWGs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 02:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbXHWGri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 02:47:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49769 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754724AbXHWGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 02:47:35 -0400
Message-Id: <20070823064734.099970139@sgi.com>
References: <20070823064653.081843729@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 23:46:55 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 2/6] SLUB: Do not use page->mapping
Content-Disposition: inline; filename=0006-SLUB-Do-not-use-page-mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After moving the lockless_freelist to kmem_cache_cpu we no longer need
page->lockless_freelist. Restructure the use of the struct page fields in
such a way that we never touch the mapping field.

This is turn allows us to remove the special casing of SLUB when determining
the mapping of a page (needed for corner cases of virtual caches machines that
need to flush caches of processors mapping a page).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/mm_types.h |    9 ++-------
 mm/slub.c                |    2 --
 2 files changed, 2 insertions(+), 9 deletions(-)

Index: linux-2.6.23-rc3-mm1/include/linux/mm_types.h
===================================================================
--- linux-2.6.23-rc3-mm1.orig/include/linux/mm_types.h	2007-08-22 17:14:32.000000000 -0700
+++ linux-2.6.23-rc3-mm1/include/linux/mm_types.h	2007-08-22 17:20:13.000000000 -0700
@@ -62,13 +62,8 @@ struct page {
 #if NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS
 	    spinlock_t ptl;
 #endif
-	    struct {			/* SLUB uses */
-	    	void **lockless_freelist;
-		struct kmem_cache *slab;	/* Pointer to slab */
-	    };
-	    struct {
-		struct page *first_page;	/* Compound pages */
-	    };
+	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
+	    struct page *first_page;	/* Compound tail pages */
 	};
 	union {
 		pgoff_t index;		/* Our offset within mapping. */
Index: linux-2.6.23-rc3-mm1/mm/slub.c
===================================================================
--- linux-2.6.23-rc3-mm1.orig/mm/slub.c	2007-08-22 17:20:05.000000000 -0700
+++ linux-2.6.23-rc3-mm1/mm/slub.c	2007-08-22 17:20:13.000000000 -0700
@@ -1125,7 +1125,6 @@ static struct page *new_slab(struct kmem
 	set_freepointer(s, last, NULL);
 
 	page->freelist = start;
-	page->lockless_freelist = NULL;
 	page->inuse = 0;
 out:
 	if (flags & __GFP_WAIT)
@@ -1151,7 +1150,6 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		- pages);
 
-	page->mapping = NULL;
 	__free_pages(page, s->order);
 }
 

-- 
