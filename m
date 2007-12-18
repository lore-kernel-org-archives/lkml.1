Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXLRWV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXLRWV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXLRWVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:21:20 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55625 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbXLRWVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:21:19 -0500
Date: Tue, 18 Dec 2007 22:20:25 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] memcgroup: tidy up mem_cgroup_charge_common
In-Reply-To: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182219290.29209@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tidy up mem_cgroup_charge_common before extending it.  Adjust some
comments, but mainly clean up its loop: I've an aversion to loops
full of continues, then a break or a goto at the bottom.  And the
is_atomic test should be on the __GFP_WAIT bit, not GFP_ATOMIC bits.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/memcontrol.c |   44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

--- 2.6.24-rc5-mm1/mm/memcontrol.c	2007-12-05 10:38:45.000000000 +0000
+++ memcgroup1/mm/memcontrol.c	2007-12-06 19:35:52.000000000 +0000
@@ -604,23 +604,22 @@ retry:
 			goto done;
 		}
 	}
-
 	unlock_page_cgroup(page);
 
 	pc = kzalloc(sizeof(struct page_cgroup), gfp_mask);
 	if (pc == NULL)
 		goto err;
 
-	rcu_read_lock();
 	/*
-	 * We always charge the cgroup the mm_struct belongs to
-	 * the mm_struct's mem_cgroup changes on task migration if the
+	 * We always charge the cgroup the mm_struct belongs to.
+	 * The mm_struct's mem_cgroup changes on task migration if the
 	 * thread group leader migrates. It's possible that mm is not
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
 	if (!mm)
 		mm = &init_mm;
 
+	rcu_read_lock();
 	mem = rcu_dereference(mm->mem_cgroup);
 	/*
 	 * For every charge from the cgroup, increment reference
@@ -634,12 +633,8 @@ retry:
 	 * the cgroup limit.
 	 */
 	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
-		bool is_atomic = gfp_mask & GFP_ATOMIC;
-		/*
-		 * We cannot reclaim under GFP_ATOMIC, fail the charge
-		 */
-		if (is_atomic)
-			goto noreclaim;
+		if (!(gfp_mask & __GFP_WAIT))
+			goto out;
 
 		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
 			continue;
@@ -653,23 +648,12 @@ retry:
  		 */
 		if (res_counter_check_under_limit(&mem->res))
 			continue;
-			/*
-			 * Since we control both RSS and cache, we end up with a
-			 * very interesting scenario where we end up reclaiming
-			 * memory (essentially RSS), since the memory is pushed
-			 * to swap cache, we eventually end up adding those
-			 * pages back to our list. Hence we give ourselves a
-			 * few chances before we fail
-			 */
-		else if (nr_retries--) {
-			congestion_wait(WRITE, HZ/10);
-			continue;
+
+		if (!nr_retries--) {
+			mem_cgroup_out_of_memory(mem, gfp_mask);
+			goto out;
 		}
-noreclaim:
-		css_put(&mem->css);
-		if (!is_atomic)
-			mem_cgroup_out_of_memory(mem, GFP_KERNEL);
-		goto free_pc;
+		congestion_wait(WRITE, HZ/10);
 	}
 
 	atomic_set(&pc->ref_cnt, 1);
@@ -678,10 +662,11 @@ noreclaim:
 	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
+
 	if (page_cgroup_assign_new_page_cgroup(page, pc)) {
 		/*
-		 * an another charge is added to this page already.
-		 * we do take lock_page_cgroup(page) again and read
+		 * Another charge has been added to this page already.
+		 * We take lock_page_cgroup(page) again and read
 		 * page->cgroup, increment refcnt.... just retry is OK.
 		 */
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
@@ -698,7 +683,8 @@ noreclaim:
 
 done:
 	return 0;
-free_pc:
+out:
+	css_put(&mem->css);
 	kfree(pc);
 err:
 	return -ENOMEM;
