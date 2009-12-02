Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZLBEjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZLBEjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZLBEjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:39:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:35897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbZLBEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764903"
Message-Id: <20091202043044.709570707@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/24] HWPOISON: introduce delete_from_lru_cache()
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=lru-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce delete_from_lru_cache() to
- clear PG_active, PG_unevictable to avoid complains at unpoison time
- move the isolate_lru_page() call back to the handlers instead of the
  entrance of __memory_failure(), this is more hwpoison filter friendly

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   45 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

--- linux-mm.orig/mm/memory-failure.c	2009-11-30 11:12:41.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-30 20:04:43.000000000 +0800
@@ -328,6 +328,30 @@ static const char *action_name[] = {
 };
 
 /*
+ * XXX: It is possible that a page is isolated from LRU cache,
+ * and then kept in swap cache or failed to remove from page cache.
+ * The page count will stop it from being freed by unpoison.
+ * Stress tests should be aware of this memory leak problem.
+ */
+static int delete_from_lru_cache(struct page *p)
+{
+	if (!isolate_lru_page(p)) {
+		/*
+		 * Clear sensible page flags, so that the buddy system won't
+		 * complain when the page is unpoison-and-freed.
+		 */
+		ClearPageActive(p);
+		ClearPageUnevictable(p);
+		/*
+		 * drop the page count elevated by isolate_lru_page()
+		 */
+		page_cache_release(p);
+		return 0;
+	}
+	return -EIO;
+}
+
+/*
  * Error hit kernel page.
  * Do nothing, try to be lucky and not touch this instead. For a few cases we
  * could be more sophisticated.
@@ -371,6 +395,8 @@ static int me_pagecache_clean(struct pag
 	int ret = FAILED;
 	struct address_space *mapping;
 
+	delete_from_lru_cache(p);
+
 	/*
 	 * For anonymous pages we're done the only reference left
 	 * should be the one m_f() holds.
@@ -500,14 +526,20 @@ static int me_swapcache_dirty(struct pag
 	/* Trigger EIO in shmem: */
 	ClearPageUptodate(p);
 
-	return DELAYED;
+	if (!delete_from_lru_cache(p))
+		return DELAYED;
+	else
+		return FAILED;
 }
 
 static int me_swapcache_clean(struct page *p, unsigned long pfn)
 {
 	delete_from_swap_cache(p);
 
-	return RECOVERED;
+	if (!delete_from_lru_cache(p))
+		return RECOVERED;
+	else
+		return FAILED;
 }
 
 /*
@@ -726,7 +758,6 @@ static int hwpoison_user_mappings(struct
 
 int __memory_failure(unsigned long pfn, int trapno, int ref)
 {
-	unsigned long lru_flag;
 	struct page_state *ps;
 	struct page *p;
 	int res;
@@ -775,13 +806,11 @@ int __memory_failure(unsigned long pfn, 
 	 */
 	if (!PageLRU(p))
 		lru_add_drain_all();
-	lru_flag = p->flags & lru;
-	if (isolate_lru_page(p)) {
+	if (!PageLRU(p)) {
 		action_result(pfn, "non LRU", IGNORED);
 		put_page(p);
 		return -EBUSY;
 	}
-	page_cache_release(p);
 
 	/*
 	 * Lock the page and wait for writeback to finish.
@@ -803,7 +832,7 @@ int __memory_failure(unsigned long pfn, 
 	/*
 	 * Torn down by someone else?
 	 */
-	if ((lru_flag & lru) && !PageSwapCache(p) && p->mapping == NULL) {
+	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
 		action_result(pfn, "already truncated LRU", IGNORED);
 		res = 0;
 		goto out;
@@ -811,7 +840,7 @@ int __memory_failure(unsigned long pfn, 
 
 	res = -EBUSY;
 	for (ps = error_states;; ps++) {
-		if (((p->flags | lru_flag)& ps->mask) == ps->res) {
+		if ((p->flags & ps->mask) == ps->res) {
 			res = page_action(ps, p, pfn);
 			break;
 		}


