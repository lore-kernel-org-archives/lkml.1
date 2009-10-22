Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbZJVGCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbZJVGCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZJVGCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:02:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39456 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbZJVGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:02:29 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] HWPOISON: return early on non-LRU pages
Date: Thu, 22 Oct 2009 08:02:27 +0200
Message-Id: <1256191352-6903-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1256191352-6903-3-git-send-email-andi@firstfloor.org>
References: <i>
 <1256191352-6903-1-git-send-email-andi@firstfloor.org>
 <1256191352-6903-2-git-send-email-andi@firstfloor.org>
 <1256191352-6903-3-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

Right now we have some trouble with non atomic access
to page flags when locking the page. To plug this hole
for now, limit error recovery to LRU pages for now.

This could be better fixed by defining a suitable protocol,
but let's go this simple way for now

This avoids unnecessary races with __set_page_locked() and
__SetPageSlab*() and maybe more non-atomic page flag operations.

This loses isolated pages which are currently in page reclaim, but these
are relatively limited compared to the total memory.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[AK: new description, bug fixes, cleanups]
---
 mm/memory-failure.c |   49 ++++++++++++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 729d4b1..e17ec3f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -370,9 +370,6 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 	int ret = FAILED;
 	struct address_space *mapping;
 
-	if (!isolate_lru_page(p))
-		page_cache_release(p);
-
 	/*
 	 * For anonymous pages we're done the only reference left
 	 * should be the one m_f() holds.
@@ -498,30 +495,18 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
  */
 static int me_swapcache_dirty(struct page *p, unsigned long pfn)
 {
-	int ret = FAILED;
-
 	ClearPageDirty(p);
 	/* Trigger EIO in shmem: */
 	ClearPageUptodate(p);
 
-	if (!isolate_lru_page(p)) {
-		page_cache_release(p);
-		ret = DELAYED;
-	}
-
-	return ret;
+	return DELAYED;
 }
 
 static int me_swapcache_clean(struct page *p, unsigned long pfn)
 {
-	int ret = FAILED;
-
-	if (!isolate_lru_page(p)) {
-		page_cache_release(p);
-		ret = RECOVERED;
-	}
 	delete_from_swap_cache(p);
-	return ret;
+
+	return RECOVERED;
 }
 
 /*
@@ -611,8 +596,6 @@ static struct page_state {
 	{ 0,		0,		"unknown page state",	me_unknown },
 };
 
-#undef lru
-
 static void action_result(unsigned long pfn, char *msg, int result)
 {
 	struct page *page = NULL;
@@ -664,9 +647,6 @@ static void hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	if (PageReserved(p) || PageCompound(p) || PageSlab(p))
 		return;
 
-	if (!PageLRU(p))
-		lru_add_drain_all();
-
 	/*
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
@@ -738,6 +718,7 @@ static void hwpoison_user_mappings(struct page *p, unsigned long pfn,
 
 int __memory_failure(unsigned long pfn, int trapno, int ref)
 {
+	unsigned long lru_flag;
 	struct page_state *ps;
 	struct page *p;
 	int res;
@@ -775,6 +756,24 @@ int __memory_failure(unsigned long pfn, int trapno, int ref)
 	}
 
 	/*
+	 * We ignore non-LRU pages for good reasons.
+	 * - PG_locked is only well defined for LRU pages and a few others
+	 * - to avoid races with __set_page_locked()
+	 * - to avoid races with __SetPageSlab*() (and more non-atomic ops)
+	 * The check (unnecessarily) ignores LRU pages being isolated and
+	 * walked by the page reclaim code, however that's not a big loss.
+	 */
+	if (!PageLRU(p))
+		lru_add_drain_all();
+	lru_flag = p->flags & lru;
+	if (isolate_lru_page(p)) {
+		action_result(pfn, "non LRU", IGNORED);
+		put_page(p);
+		return -EBUSY;
+	}
+	page_cache_release(p);
+
+	/*
 	 * Lock the page and wait for writeback to finish.
 	 * It's very difficult to mess with pages currently under IO
 	 * and in many cases impossible, so we just avoid it here.
@@ -790,7 +789,7 @@ int __memory_failure(unsigned long pfn, int trapno, int ref)
 	/*
 	 * Torn down by someone else?
 	 */
-	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
+	if ((lru_flag & lru) && !PageSwapCache(p) && p->mapping == NULL) {
 		action_result(pfn, "already truncated LRU", IGNORED);
 		res = 0;
 		goto out;
@@ -798,7 +797,7 @@ int __memory_failure(unsigned long pfn, int trapno, int ref)
 
 	res = -EBUSY;
 	for (ps = error_states;; ps++) {
-		if ((p->flags & ps->mask) == ps->res) {
+		if (((p->flags | lru_flag)& ps->mask) == ps->res) {
 			res = page_action(ps, p, pfn, ref);
 			break;
 		}
-- 
1.6.0.2

