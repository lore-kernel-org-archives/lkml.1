Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbYDNSWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbYDNSWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765441AbYDNSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:15:59 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57226 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765437AbYDNSP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:15:58 -0400
Date: Mon, 14 Apr 2008 21:14:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: wli@holomorphy.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/hugetlb.c: fix duplicate variable
Message-ID: <20080414181452.GY6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's confusing that set_max_huge_pages() contained two different 
variables named "ret", and although the code works correctly this should 
be fixed.

The inner of the two variables can simply be removed.

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 25 Feb 2008

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6/mm/hugetlb.c.old	2008-02-24 23:17:52.000000000 +0200
+++ linux-2.6/mm/hugetlb.c	2008-02-24 23:26:07.000000000 +0200
@@ -518,45 +518,44 @@
 static unsigned long set_max_huge_pages(unsigned long count)
 {
 	unsigned long min_count, ret;
 
 	/*
 	 * Increase the pool size
 	 * First take pages out of surplus state.  Then make up the
 	 * remaining difference by allocating fresh huge pages.
 	 *
 	 * We might race with alloc_buddy_huge_page() here and be unable
 	 * to convert a surplus huge page to a normal huge page. That is
 	 * not critical, though, it just means the overall size of the
 	 * pool might be one hugepage larger than it needs to be, but
 	 * within all the constraints specified by the sysctls.
 	 */
 	spin_lock(&hugetlb_lock);
 	while (surplus_huge_pages && count > persistent_huge_pages) {
 		if (!adjust_pool_surplus(-1))
 			break;
 	}
 
 	while (count > persistent_huge_pages) {
-		int ret;
 		/*
 		 * If this allocation races such that we no longer need the
 		 * page, free_huge_page will handle it by freeing the page
 		 * and reducing the surplus.
 		 */
 		spin_unlock(&hugetlb_lock);
 		ret = alloc_fresh_huge_page();
 		spin_lock(&hugetlb_lock);
 		if (!ret)
 			goto out;
 
 	}
 
 	/*
 	 * Decrease the pool size
 	 * First return free pages to the buddy allocator (being careful
 	 * to keep enough around to satisfy reservations).  Then place
 	 * pages into surplus state as needed so the pool will shrink
 	 * to the desired size as pages become free.
 	 *
 	 * By placing pages into the surplus state independent of the
 	 * overcommit value, we are allowing the surplus pool size to
