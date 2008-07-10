Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbYGJRav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbYGJRav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbYGJRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:30:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59090 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361AbYGJRam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:30:42 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: apw@shadowen.org, linux-mm@kvack.org, agl@us.ibm.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Message-Id: <20080710173041.16433.21192.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20080710173001.16433.87538.sendpatchset@skynet.skynet.ie>
References: <20080710173001.16433.87538.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 2/2] [PATCH] Align faulting address to a hugepage boundary before unmapping
Date: Thu, 10 Jul 2008 18:30:41 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When taking a fault for COW on a private mapping it is possible that the
parent will have to steal the original page from its children due to an
insufficient hugepage pool.  In this case, unmap_ref_private() is called
for the faulting address to unmap via unmap_hugepage_range(). This patch
ensures that the address used for unmapping is hugepage-aligned.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.26-rc8-mm1-clean/mm/hugetlb.c linux-2.6.26-rc8-mm1-fix-needsreserve-check/mm/hugetlb.c
--- linux-2.6.26-rc8-mm1-clean/mm/hugetlb.c	2008-07-08 11:54:34.000000000 -0700
+++ linux-2.6.26-rc8-mm1-fix-needsreserve-check/mm/hugetlb.c	2008-07-08 15:50:00.000000000 -0700
@@ -1767,6 +1767,7 @@ int unmap_ref_private(struct mm_struct *
 	 * vm_pgoff is in PAGE_SIZE units, hence the different calculation
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
+	address = address & huge_page_mask(hstate_vma(vma));
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
 		+ (vma->vm_pgoff >> PAGE_SHIFT);
 	mapping = (struct address_space *)page_private(page);
