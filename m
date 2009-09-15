Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbZIOUdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbZIOUdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZIOUdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:33:45 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:49736 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbZIOUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:33:44 -0400
X-Trace: 262458437/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFABaXr0pPRVRK/2dsb2JhbACBU95/hBcF
X-IronPort-AV: E=Sophos;i="4.44,391,1249254000"; 
   d="scan'208";a="262458437"
Date: Tue, 15 Sep 2009 21:33:02 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/4] mm: hugetlbfs_pagecache_present
In-Reply-To: <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909152131530.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <Pine.LNX.4.64.0909152127240.22199@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename hugetlbfs_backed() to hugetlbfs_pagecache_present()
and add more comments, as suggested by Mel Gorman.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/hugetlb.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- mm1/mm/hugetlb.c	2009-09-14 16:34:37.000000000 +0100
+++ mm2/mm/hugetlb.c	2009-09-15 17:32:12.000000000 +0100
@@ -2016,8 +2016,11 @@ static struct page *hugetlbfs_pagecache_
 	return find_lock_page(mapping, idx);
 }
 
-/* Return whether there is a pagecache page to back given address within VMA */
-static bool hugetlbfs_backed(struct hstate *h,
+/*
+ * Return whether there is a pagecache page to back given address within VMA.
+ * Caller follow_hugetlb_page() holds page_table_lock so we cannot lock_page.
+ */
+static bool hugetlbfs_pagecache_present(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address)
 {
 	struct address_space *mapping;
@@ -2254,10 +2257,13 @@ int follow_hugetlb_page(struct mm_struct
 
 		/*
 		 * When coredumping, it suits get_dump_page if we just return
-		 * an error if there's a hole and no huge pagecache to back it.
+		 * an error where there's an empty slot with no huge pagecache
+		 * to back it.  This way, we avoid allocating a hugepage, and
+		 * the sparse dumpfile avoids allocating disk blocks, but its
+		 * huge holes still show up with zeroes where they need to be.
 		 */
-		if (absent &&
-		    ((flags & FOLL_DUMP) && !hugetlbfs_backed(h, vma, vaddr))) {
+		if (absent && (flags & FOLL_DUMP) &&
+		    !hugetlbfs_pagecache_present(h, vma, vaddr)) {
 			remainder = 0;
 			break;
 		}
