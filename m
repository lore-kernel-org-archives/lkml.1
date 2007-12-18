Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbXLRWYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbXLRWYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXLRWYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:24:00 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:33289 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbXLRWYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:24:00 -0500
Date: Tue, 18 Dec 2007 22:22:57 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] memcgroup: fix hang with shmem/tmpfs
In-Reply-To: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182220310.29209@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memcgroup regime relies upon a cgroup reclaiming pages from itself
within add_to_page_cache: which may involve some waiting.  Whereas shmem
and tmpfs rely upon using add_to_page_cache while holding a spinlock:
when it cannot wait.  The consequence is that when a cgroup reaches its
limit, shmem_getpage just hangs - unless there is outside memory pressure
too, neither kswapd nor radix_tree_preload get it out of the retry loop.

In most cases we can mem_cgroup_cache_charge the page waitably first,
to attach the page_cgroup in advance, so add_to_page_cache will do no
more than increment a count; then mem_cgroup_uncharge_page after (in
both success and failure cases) to balance the books again.

And where there used to be a congestion_wait for kswapd (recently made
redundant by radix_tree_preload), use mem_cgroup_cache_charge with NULL
page to go through a cycle of allocation and freeing, without accounting
to any particular page, and without updating the statistics vector.
This brings the cgroup below its limit so the next try usually succeeds.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I'm struggling to remember why I added the NULL page thing: why not use
the swappage there, and charge then uncharge it?  That would distort the
statistics, yes, but does that make the NULL handling worthwhile?  But
the patch below is what I've been testing, and I must push these forward
now: overnight I'll try charging and uncharging the swappage instead.

I don't like the ~__GFP_HIGHMEM masking below: I think that would better
be enforced inside mem_cgroup_charge_common (radix_tree_preload likewise).
But I've not made that change here because it affects more files, and it's
not obvious what the correct mask should be - we need to consult Mel on
that - what category of movability should such allocations be given?

 mm/memcontrol.c |   37 +++++++++++++++++++++----------------
 mm/shmem.c      |   28 +++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 17 deletions(-)

--- memcgroup1+tmpfs9/mm/memcontrol.c	2007-12-06 19:35:52.000000000 +0000
+++ memcgroup2/mm/memcontrol.c	2007-12-06 19:49:24.000000000 +0000
@@ -588,23 +588,26 @@ static int mem_cgroup_charge_common(stru
 	 * with it
 	 */
 retry:
-	lock_page_cgroup(page);
-	pc = page_get_page_cgroup(page);
-	/*
-	 * The page_cgroup exists and the page has already been accounted
-	 */
-	if (pc) {
-		if (unlikely(!atomic_inc_not_zero(&pc->ref_cnt))) {
-			/* this page is under being uncharged ? */
-			unlock_page_cgroup(page);
-			cpu_relax();
-			goto retry;
-		} else {
-			unlock_page_cgroup(page);
-			goto done;
+	if (page) {
+		lock_page_cgroup(page);
+		pc = page_get_page_cgroup(page);
+		/*
+		 * The page_cgroup exists and
+		 * the page has already been accounted.
+		 */
+		if (pc) {
+			if (unlikely(!atomic_inc_not_zero(&pc->ref_cnt))) {
+				/* this page is under being uncharged ? */
+				unlock_page_cgroup(page);
+				cpu_relax();
+				goto retry;
+			} else {
+				unlock_page_cgroup(page);
+				goto done;
+			}
 		}
+		unlock_page_cgroup(page);
 	}
-	unlock_page_cgroup(page);
 
 	pc = kzalloc(sizeof(struct page_cgroup), gfp_mask);
 	if (pc == NULL)
@@ -663,7 +666,7 @@ retry:
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
 
-	if (page_cgroup_assign_new_page_cgroup(page, pc)) {
+	if (!page || page_cgroup_assign_new_page_cgroup(page, pc)) {
 		/*
 		 * Another charge has been added to this page already.
 		 * We take lock_page_cgroup(page) again and read
@@ -672,6 +675,8 @@ retry:
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
 		kfree(pc);
+		if (!page)
+			goto done;
 		goto retry;
 	}
 
--- memcgroup1+tmpfs9/mm/shmem.c	2007-12-15 19:15:10.000000000 +0000
+++ memcgroup2/mm/shmem.c	2007-12-15 19:21:34.000000000 +0000
@@ -912,9 +912,13 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
-	error = radix_tree_preload(GFP_KERNEL);
+	/* Precharge page while we can wait, compensate afterwards */
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
 		goto out;
+	error = radix_tree_preload(GFP_KERNEL);
+	if (error)
+		goto uncharge;
 	error = 1;
 
 	spin_lock(&info->lock);
@@ -947,6 +951,8 @@ found:
 		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
 	radix_tree_preload_end();
+uncharge:
+	mem_cgroup_uncharge_page(page);
 out:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1308,6 +1314,13 @@ repeat:
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
 			page_cache_release(swappage);
+			if (error == -ENOMEM) {
+				/* allow reclaim from this memory cgroup */
+				error = mem_cgroup_cache_charge(NULL,
+					current->mm, gfp & ~__GFP_HIGHMEM);
+				if (error)
+					goto failed;
+			}
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
@@ -1353,6 +1366,17 @@ repeat:
 				goto failed;
 			}
 
+			/* Precharge page while we can wait, compensate after */
+			error = mem_cgroup_cache_charge(filepage, current->mm,
+							gfp & ~__GFP_HIGHMEM);
+			if (error) {
+				page_cache_release(filepage);
+				shmem_unacct_blocks(info->flags, 1);
+				shmem_free_blocks(inode, 1);
+				filepage = NULL;
+				goto failed;
+			}
+
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
@@ -1364,6 +1388,7 @@ repeat:
 			if (error || swap.val || 0 != add_to_page_cache_lru(
 					filepage, mapping, idx, GFP_NOWAIT)) {
 				spin_unlock(&info->lock);
+				mem_cgroup_uncharge_page(filepage);
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
 				shmem_free_blocks(inode, 1);
@@ -1372,6 +1397,7 @@ repeat:
 					goto failed;
 				goto repeat;
 			}
+			mem_cgroup_uncharge_page(filepage);
 			info->flags |= SHMEM_PAGEIN;
 		}
 
