Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZE0Bss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZE0Bss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbZE0Bsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:48:39 -0400
Received: from cmpxchg.org ([85.214.51.133]:43998 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbZE0Bsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:48:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [patch] mm: release swap slots for actively used pages
Date: Wed, 27 May 2009 03:47:39 +0200
Message-Id: <1243388859-9760-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For anonymous pages activated by the reclaim scan or faulted from an
evicted page table entry we should always try to free up swap space.

Both events indicate that the page is in active use and a possible
change in the working set.  Thus removing the slot association from
the page increases the chance of the page being placed near its new
LRU buddies on the next eviction and helps keeping the amount of stale
swap cache entries low.

try_to_free_swap() inherently only succeeds when the last user of the
swap slot vanishes so it is safe to use from places where that single
mapping just brought the page back to life.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 mm/memory.c |    3 +--
 mm/vmscan.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8b4e40e..407ebf7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2671,8 +2671,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
 	swap_free(entry);
-	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
-		try_to_free_swap(page);
+	try_to_free_swap(page);
 	unlock_page(page);
 
 	if (write_access) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 621708f..2f0549d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -788,7 +788,7 @@ cull_mlocked:
 
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
-		if (PageSwapCache(page) && vm_swap_full())
+		if (PageSwapCache(page))
 			try_to_free_swap(page);
 		VM_BUG_ON(PageActive(page));
 		SetPageActive(page);
-- 
1.6.3

