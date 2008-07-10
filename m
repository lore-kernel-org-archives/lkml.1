Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYGJRag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYGJRag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbYGJRaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:30:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59049 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbYGJRaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:30:22 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>, agl@us.ibm.com,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Message-Id: <20080710173021.16433.90661.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20080710173001.16433.87538.sendpatchset@skynet.skynet.ie>
References: <20080710173001.16433.87538.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 1/2] [PATCH] Fix a hugepage reservation check for MAP_SHARED
Date: Thu, 10 Jul 2008 18:30:21 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When removing a huge page from the hugepage pool for a fault the system
checks to see if the mapping requires additional pages to be reserved, and
if it does whether there are any unreserved pages remaining.  If not, the
allocation fails without even attempting to get a page. In order to determine
whether to apply this check we call vma_has_private_reserves() which tells us
if this vma is MAP_PRIVATE and is the owner.  This incorrectly triggers the
remaining reservation test for MAP_SHARED mappings which prevents allocation
of the final page in the pool even though it is reserved for this mapping.

In reality we only want to check this for MAP_PRIVATE mappings where the
process is not the original mapper.  Replace vma_has_private_reserves() with
vma_has_reserves() which indicates whether further reserves are required,
and update the caller.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.26-rc8-mm1-clean/mm/hugetlb.c linux-2.6.26-rc8-mm1-fix-needsreserve-check/mm/hugetlb.c
--- linux-2.6.26-rc8-mm1-clean/mm/hugetlb.c	2008-07-08 11:54:34.000000000 -0700
+++ linux-2.6.26-rc8-mm1-fix-needsreserve-check/mm/hugetlb.c	2008-07-08 12:41:36.000000000 -0700
@@ -343,13 +343,13 @@ void reset_vma_resv_huge_pages(struct vm
 }
 
 /* Returns true if the VMA has associated reserve pages */
-static int vma_has_private_reserves(struct vm_area_struct *vma)
+static int vma_has_reserves(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & VM_SHARED)
-		return 0;
-	if (!is_vma_resv_set(vma, HPAGE_RESV_OWNER))
-		return 0;
-	return 1;
+		return 1;
+	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+		return 1;
+	return 0;
 }
 
 static void clear_huge_page(struct page *page,
@@ -421,7 +421,7 @@ static struct page *dequeue_huge_page_vm
 	 * have no page reserves. This check ensures that reservations are
 	 * not "stolen". The child may still get SIGKILLed
 	 */
-	if (!vma_has_private_reserves(vma) &&
+	if (!vma_has_reserves(vma) &&
 			h->free_huge_pages - h->resv_huge_pages == 0)
 		return NULL;
 
