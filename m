Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbXDXTGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbXDXTGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXDXTGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:06:44 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56567 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbXDXTGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:06:43 -0400
X-AuditID: d80ac287-ad0c9bb00000590d-4d-462e5542fcc1 
Date: Tue, 24 Apr 2007 20:06:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <20070424101116.1cb7512e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704241954050.28487@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <20070424101116.1cb7512e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Apr 2007 19:06:36.0487 (UTC) FILETIME=[AE449570:01C786A3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Andrew Morton wrote:
> 
> From my reading it would be pretty simple to teach unmap_and_move()
> to pass mapping_gfp_mask(page_mapping(page)) down into
> (*get_new_page)() to get the correct type of page.

Or even simpler, since they're already passed the source page,
just get it from that.  However, I'm much less able to test this
patch in a hurry: it looks plausible, builds and runs okay in my
non-NUMA testing; but whether it does what I intend it to do,
without causing unexpected side-effects, I don't know.

Whereas I did check the previous little vma_migratable() patch
did the right thing, and think it more suitable for lastminute
and -stable.  This one would need real testing by real migrants
with real NUMA.

Or Christoph may prevail in persuading there's no such problem.


Is there a problem with page migration to HIGHMEM, if pages were
mapped from a GFP_USER block device?  I failed to demonstrate any
problem, but here's a quick fix if needed.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/migrate.h |    1 +
 mm/mempolicy.c          |    4 ++--
 mm/migrate.c            |   12 +++++++++---
 mm/swap_state.c         |    1 +
 4 files changed, 13 insertions(+), 5 deletions(-)

--- 2.6.21-rc7/include/linux/migrate.h	2007-03-07 14:17:59.000000000 +0000
+++ linux/include/linux/migrate.h	2007-04-24 19:19:01.000000000 +0100
@@ -14,6 +14,7 @@ static inline int vma_migratable(struct 
 }
 
 #ifdef CONFIG_MIGRATION
+extern gfp_t page_gfp_mask(struct page *page);
 extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
 extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
--- 2.6.21-rc7/mm/mempolicy.c	2007-03-07 14:18:01.000000000 +0000
+++ linux/mm/mempolicy.c	2007-04-24 19:19:01.000000000 +0100
@@ -594,7 +594,7 @@ static void migrate_page_add(struct page
 
 static struct page *new_node_page(struct page *page, unsigned long node, int **x)
 {
-	return alloc_pages_node(node, GFP_HIGHUSER, 0);
+	return alloc_pages_node(node, page_gfp_mask(page), 0);
 }
 
 /*
@@ -710,7 +710,7 @@ static struct page *new_vma_page(struct 
 {
 	struct vm_area_struct *vma = (struct vm_area_struct *)private;
 
-	return alloc_page_vma(GFP_HIGHUSER, vma, page_address_in_vma(page, vma));
+	return alloc_page_vma(page_gfp_mask(page), vma, page_address_in_vma(page, vma));
 }
 #else
 
--- 2.6.21-rc7/mm/migrate.c	2007-03-07 14:18:01.000000000 +0000
+++ linux/mm/migrate.c	2007-04-24 19:19:01.000000000 +0100
@@ -735,12 +735,18 @@ struct page_to_node {
 	int status;
 };
 
-static struct page *new_page_node(struct page *p, unsigned long private,
+gfp_t page_gfp_mask(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+	return mapping? mapping_gfp_mask(mapping): GFP_HIGHUSER;
+}
+
+static struct page *new_page_node(struct page *page, unsigned long private,
 		int **result)
 {
 	struct page_to_node *pm = (struct page_to_node *)private;
 
-	while (pm->node != MAX_NUMNODES && pm->page != p)
+	while (pm->node != MAX_NUMNODES && pm->page != page)
 		pm++;
 
 	if (pm->node == MAX_NUMNODES)
@@ -748,7 +754,7 @@ static struct page *new_page_node(struct
 
 	*result = &pm->status;
 
-	return alloc_pages_node(pm->node, GFP_HIGHUSER | GFP_THISNODE, 0);
+	return alloc_pages_node(pm->node, page_gfp_mask(page) | GFP_THISNODE, 0);
 }
 
 /*
--- 2.6.21-rc7/mm/swap_state.c	2006-09-20 04:42:06.000000000 +0100
+++ linux/mm/swap_state.c	2007-04-24 19:19:01.000000000 +0100
@@ -40,6 +40,7 @@ struct address_space swapper_space = {
 	.page_tree	= RADIX_TREE_INIT(GFP_ATOMIC|__GFP_NOWARN),
 	.tree_lock	= __RW_LOCK_UNLOCKED(swapper_space.tree_lock),
 	.a_ops		= &swap_aops,
+	.flags		= (__force unsigned long) GFP_HIGHUSER,
 	.i_mmap_nonlinear = LIST_HEAD_INIT(swapper_space.i_mmap_nonlinear),
 	.backing_dev_info = &swap_backing_dev_info,
 };
