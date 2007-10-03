Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbXJCVdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbXJCVdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXJCVcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:32:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50673 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbXJCVcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:32:52 -0400
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH] hugetlb: Fix pool resizing corner case V2
Date: Wed, 03 Oct 2007 14:32:27 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Adam Litke <agl@us.ibm.com>, Ken Chen <kenchen@google.com>,
       Dave Hansen <haveblue@us.ibm.com>
Message-Id: <20071003213227.28925.49934.stgit@kernel>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Changes in V2:
 - Removed now unnecessary check as suggested by Ken Chen

When shrinking the size of the hugetlb pool via the nr_hugepages sysctl, we
are careful to keep enough pages around to satisfy reservations.  But the
calculation is flawed for the following scenario:

Action                          Pool Counters (Total, Free, Resv)
======                          =============
Set pool to 1 page              1 1 0
Map 1 page MAP_PRIVATE          1 1 0
Touch the page to fault it in   1 0 0
Set pool to 3 pages             3 2 0
Map 2 pages MAP_SHARED          3 2 2
Set pool to 2 pages             2 1 2 <-- Mistake, should be 3 2 2
Touch the 2 shared pages        2 0 1 <-- Program crashes here

The last touch above will terminate the process due to lack of huge pages.

This patch corrects the calculation so that it factors in pages being used
for private mappings.  Andrew, this is a standalone fix suitable for
mainline.  It is also now corrected in my latest dynamic pool resizing
patchset which I will send out soon.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Ken Chen <kenchen@google.com>
---

 mm/hugetlb.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 84c795e..b6b3b64 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -224,14 +224,14 @@ static void try_to_free_low(unsigned long count)
 	for (i = 0; i < MAX_NUMNODES; ++i) {
 		struct page *page, *next;
 		list_for_each_entry_safe(page, next, &hugepage_freelists[i], lru) {
+			if (count >= nr_huge_pages)
+				return;
 			if (PageHighMem(page))
 				continue;
 			list_del(&page->lru);
 			update_and_free_page(page);
 			free_huge_pages--;
 			free_huge_pages_node[page_to_nid(page)]--;
-			if (count >= nr_huge_pages)
-				return;
 		}
 	}
 }
@@ -247,11 +247,9 @@ static unsigned long set_max_huge_pages(unsigned long count)
 		if (!alloc_fresh_huge_page())
 			return nr_huge_pages;
 	}
-	if (count >= nr_huge_pages)
-		return nr_huge_pages;
 
 	spin_lock(&hugetlb_lock);
-	count = max(count, resv_huge_pages);
+	count = max(count, resv_huge_pages + nr_huge_pages - free_huge_pages);
 	try_to_free_low(count);
 	while (count < nr_huge_pages) {
 		struct page *page = dequeue_huge_page(NULL, 0);
