Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZLBEiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZLBEiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbZLBEiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:38:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:36773 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbZLBEh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764892"
Message-Id: <20091202043044.182459372@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/24] HWPOISON: avoid grabbing page for two times
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-no-double-ref.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If page is double referenced in madvise_hwpoison() and __memory_failure(),
remove_mapping() will fail because it expects page_count=2. Fix it by
not grabbing extra page count in __memory_failure().

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/madvise.c        |    1 -
 mm/memory-failure.c |    8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

--- linux-mm.orig/mm/madvise.c	2009-11-02 11:12:02.000000000 +0800
+++ linux-mm/mm/madvise.c	2009-11-02 12:31:52.000000000 +0800
@@ -238,7 +238,6 @@ static int madvise_hwpoison(unsigned lon
 		       page_to_pfn(p), start);
 		/* Ignore return value for now */
 		__memory_failure(page_to_pfn(p), 0, 1);
-		put_page(p);
 	}
 	return ret;
 }
--- linux-mm.orig/mm/memory-failure.c	2009-11-02 12:31:49.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-02 13:53:41.000000000 +0800
@@ -607,7 +607,7 @@ static void action_result(unsigned long 
 }
 
 static int page_action(struct page_state *ps, struct page *p,
-			unsigned long pfn, int ref)
+			unsigned long pfn)
 {
 	int result;
 	int count;
@@ -615,7 +615,7 @@ static int page_action(struct page_state
 	result = ps->action(p, pfn);
 	action_result(pfn, ps->msg, result);
 
-	count = page_count(p) - 1 - ref;
+	count = page_count(p) - 1;
 	if (count != 0)
 		printk(KERN_ERR
 		       "MCE %#lx: %s page still referenced by %d users\n",
@@ -753,7 +753,7 @@ int __memory_failure(unsigned long pfn, 
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_freeze_refs()/page_unfreeze_refs() mismatch.
 	 */
-	if (!get_page_unless_zero(compound_head(p))) {
+	if (!ref && !get_page_unless_zero(compound_head(p))) {
 		action_result(pfn, "free or high order kernel", IGNORED);
 		return PageBuddy(compound_head(p)) ? 0 : -EBUSY;
 	}
@@ -801,7 +801,7 @@ int __memory_failure(unsigned long pfn, 
 	res = -EBUSY;
 	for (ps = error_states;; ps++) {
 		if (((p->flags | lru_flag)& ps->mask) == ps->res) {
-			res = page_action(ps, p, pfn, ref);
+			res = page_action(ps, p, pfn);
 			break;
 		}
 	}


