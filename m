Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXK1S4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXK1S4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbXK1S4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:56:34 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59636 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbXK1S4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:56:31 -0500
Date: Wed, 28 Nov 2007 18:55:10 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Willy Tarreau <wtarreau@hera.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tmpfs: restore missing clear_highpage
Message-ID: <Pine.LNX.4.64.0711281844370.25292@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tmpfs was misconverted to __GFP_ZERO in 2.6.11.  There's an unusual case in
which shmem_getpage receives the page from its caller instead of allocating.
We must cover this case by clear_highpage before SetPageUptodate, as before.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Desirable in 2.6.23-stable and 2.6.22-stable and 2.6.16-stable
(and any other 2.6-stable if not already at end of life).

 mm/shmem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- 2.6.24-rc3-git/mm/shmem.c	2007-10-31 06:18:05.000000000 +0000
+++ linux/mm/shmem.c	2007-11-28 17:01:20.000000000 +0000
@@ -1072,7 +1072,7 @@ shmem_alloc_page(gfp_t gfp, struct shmem
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
 	pvma.vm_pgoff = idx;
 	pvma.vm_end = PAGE_SIZE;
-	page = alloc_page_vma(gfp | __GFP_ZERO, &pvma, 0);
+	page = alloc_page_vma(gfp, &pvma, 0);
 	mpol_free(pvma.vm_policy);
 	return page;
 }
@@ -1093,7 +1093,7 @@ shmem_swapin(struct shmem_inode_info *in
 static inline struct page *
 shmem_alloc_page(gfp_t gfp,struct shmem_inode_info *info, unsigned long idx)
 {
-	return alloc_page(gfp | __GFP_ZERO);
+	return alloc_page(gfp);
 }
 #endif
 
@@ -1306,6 +1306,7 @@ repeat:
 
 		info->alloced++;
 		spin_unlock(&info->lock);
+		clear_highpage(filepage);
 		flush_dcache_page(filepage);
 		SetPageUptodate(filepage);
 	}
