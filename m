Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZLBEij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZLBEij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbZLBEiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:38:02 -0500
Received: from mga14.intel.com ([143.182.124.37]:57394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbZLBEh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764908"
Message-Id: <20091202043045.394560341@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/24] HWPOISON: return 0 if page is assured to be isolated
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-isolated.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce hpc.page_isolated to record if page is assured to be
isolated, ie. it won't be accessed in normal kernel code paths
and therefore won't trigger another MCE event.

__memory_failure() will now return 0 to indicate that page is
really isolated.  Note that the original used action result
RECOVERED is not a reliable criterion.

Note that we now don't bother to risk returning 0 for the
rare unpoison/truncated cases.

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- linux-mm.orig/mm/memory-failure.c	2009-11-30 20:35:49.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-30 20:40:56.000000000 +0800
@@ -332,6 +332,7 @@ struct hwpoison_control {
 	struct page *p;		/* raw corrupted page */
 	struct page *page;	/* compound page head */
 	int result;
+	unsigned page_isolated:1;
 };
 
 /*
@@ -529,9 +530,10 @@ static int me_swapcache_dirty(struct hwp
 	/* Trigger EIO in shmem: */
 	ClearPageUptodate(p);
 
-	if (!delete_from_lru_cache(p))
+	if (!delete_from_lru_cache(p)) {
+		hpc->page_isolated = 1;
 		return DELAYED;
-	else
+	} else
 		return FAILED;
 }
 
@@ -641,7 +643,7 @@ static void action_result(struct hwpoiso
 		msg, hwpoison_result_name[result]);
 }
 
-static int page_action(struct page_state *ps,
+static void page_action(struct page_state *ps,
 		       struct hwpoison_control *hpc)
 {
 	int result;
@@ -656,12 +658,15 @@ static int page_action(struct page_state
 		       "MCE %#lx: %s page still referenced by %d users\n",
 		       hpc->pfn, ps->msg, count);
 
+	if (result == RECOVERED)
+		hpc->page_isolated = 1;
+	if (count || page_mapcount(hpc->page))
+		hpc->page_isolated = 0;
+
 	/* Could do more checks here if page looks ok */
 	/*
 	 * Could adjust zone counters here to correct for the missing page.
 	 */
-
-	return result == RECOVERED ? 0 : -EBUSY;
 }
 
 #define N_UNMAP_TRIES 5
@@ -767,7 +772,6 @@ int __memory_failure(unsigned long pfn, 
 	struct page_state *ps;
 	struct page *p;
 	struct page *page;
-	int res;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure from trap %d on page %lx", trapno, pfn);
@@ -785,6 +789,7 @@ int __memory_failure(unsigned long pfn, 
 	hpc.pfn		= pfn;
 	hpc.p		= p;
 	hpc.page	= page;
+	hpc.page_isolated = 0;
 
 	if (TestSetPageHWPoison(p)) {
 		action_result(&hpc, "already hardware poisoned", IGNORED);
@@ -842,7 +847,6 @@ int __memory_failure(unsigned long pfn, 
 	 */
 	if (!PageHWPoison(p)) {
 		action_result(&hpc, "unpoisoned", IGNORED);
-		res = 0;
 		goto out;
 	}
 
@@ -852,30 +856,26 @@ int __memory_failure(unsigned long pfn, 
 	 * Now take care of user space mappings.
 	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
 	 */
-	if (hwpoison_user_mappings(&hpc, trapno) != SWAP_SUCCESS) {
-		res = -EBUSY;
+	if (hwpoison_user_mappings(&hpc, trapno) != SWAP_SUCCESS)
 		goto out;
-	}
 
 	/*
 	 * Torn down by someone else?
 	 */
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
 		action_result(&hpc, "already truncated LRU", IGNORED);
-		res = 0;
 		goto out;
 	}
 
-	res = -EBUSY;
 	for (ps = error_states;; ps++) {
 		if ((p->flags & ps->mask) == ps->res) {
-			res = page_action(ps, &hpc);
+			page_action(ps, &hpc);
 			break;
 		}
 	}
 out:
 	unlock_page(p);
-	return res;
+	return hpc.page_isolated ? 0 : -EBUSY;
 }
 EXPORT_SYMBOL_GPL(__memory_failure);
 


