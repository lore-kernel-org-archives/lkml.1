Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbXEQKLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbXEQKLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXEQKLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:11:06 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:46203 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXEQKLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:11:05 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070517101102.3113.35356.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070517101022.3113.15456.sendpatchset@skynet.skynet.ie>
References: <20070517101022.3113.15456.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 2/5] Do not annotate shmem allocations explicitly
Date: Thu, 17 May 2007 11:11:02 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


shmem support allocates pages for two purposes. Firstly, shmem_dir_alloc()
allocates pages to track swap vectors. These are not movable so this
patch clears all mobility-flags related to the allocation. Secondly,
shmem_alloc_pages() allocates pages on behalf of shmem_getpage(), whose
flags come from a file mapping which already sets the appropriate mobility
flags. These allocations do not need to be explicitly flagged so this patch
removes the unnecessary annotations.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
---

 shmem.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.22-rc1-mm1-010_biomovable/mm/shmem.c linux-2.6.22-rc1-mm1-012_shmem/mm/shmem.c
--- linux-2.6.22-rc1-mm1-010_biomovable/mm/shmem.c	2007-05-16 10:54:18.000000000 +0100
+++ linux-2.6.22-rc1-mm1-012_shmem/mm/shmem.c	2007-05-16 23:02:37.000000000 +0100
@@ -96,9 +96,9 @@ static inline struct page *shmem_dir_all
 	 * BLOCKS_PER_PAGE on indirect pages, assume PAGE_CACHE_SIZE:
 	 * might be reconsidered if it ever diverges from PAGE_SIZE.
 	 *
-	 * __GFP_MOVABLE is masked out as swap vectors cannot move
+	 * Mobility flags are masked out as swap vectors cannot move
 	 */
-	return alloc_pages((gfp_mask & ~__GFP_MOVABLE) | __GFP_ZERO,
+	return alloc_pages((gfp_mask & ~GFP_MOVABLE_MASK) | __GFP_ZERO,
 				PAGE_CACHE_SHIFT-PAGE_SHIFT);
 }
 
@@ -1054,9 +1054,7 @@ shmem_alloc_page(gfp_t gfp, struct shmem
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
 	pvma.vm_pgoff = idx;
 	pvma.vm_end = PAGE_SIZE;
-	page = alloc_page_vma(
-			set_migrateflags(gfp | __GFP_ZERO, __GFP_RECLAIMABLE),
-								&pvma, 0);
+	page = alloc_page_vma(gfp | __GFP_ZERO, &pvma, 0);
 	mpol_free(pvma.vm_policy);
 	return page;
 }
@@ -1076,8 +1074,7 @@ shmem_swapin(struct shmem_inode_info *in
 static inline struct page *
 shmem_alloc_page(gfp_t gfp,struct shmem_inode_info *info, unsigned long idx)
 {
-	return alloc_page(
-			set_migrateflags(gfp | __GFP_ZERO, __GFP_RECLAIMABLE));
+	return alloc_page(gfp | __GFP_ZERO);
 }
 #endif
 
