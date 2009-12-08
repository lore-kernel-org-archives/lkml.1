Return-Path: <linux-kernel-owner+w=401wt.eu-S966329AbZLHVRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966329AbZLHVRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966282AbZLHVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:16:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49537 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966271AbZLHVQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:25 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [15/31] HWPOISON: make semantics of IGNORED/DELAYED clear
Message-Id: <20091208211631.6B8A1B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

Change semantics for
- IGNORED: not handled; it may well be _unsafe_
- DELAYED: to be handled later; it is _safe_

With this change,
- IGNORED/FAILED mean (maybe) Error
- DELAYED/RECOVERED mean Success

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory-failure.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -336,16 +336,16 @@ static void collect_procs(struct page *p
  */
 
 enum outcome {
-	FAILED,		/* Error handling failed */
+	IGNORED,	/* Error: cannot be handled */
+	FAILED,		/* Error: handling failed */
 	DELAYED,	/* Will be handled later */
-	IGNORED,	/* Error safely ignored */
 	RECOVERED,	/* Successfully recovered */
 };
 
 static const char *action_name[] = {
+	[IGNORED] = "Ignored",
 	[FAILED] = "Failed",
 	[DELAYED] = "Delayed",
-	[IGNORED] = "Ignored",
 	[RECOVERED] = "Recovered",
 };
 
@@ -380,14 +380,6 @@ static int delete_from_lru_cache(struct
  */
 static int me_kernel(struct page *p, unsigned long pfn)
 {
-	return DELAYED;
-}
-
-/*
- * Already poisoned page.
- */
-static int me_ignore(struct page *p, unsigned long pfn)
-{
 	return IGNORED;
 }
 
@@ -604,7 +596,7 @@ static struct page_state {
 	char *msg;
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
-	{ reserved,	reserved,	"reserved kernel",	me_ignore },
+	{ reserved,	reserved,	"reserved kernel",	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -790,7 +782,7 @@ int __memory_failure(unsigned long pfn,
 
 	p = pfn_to_page(pfn);
 	if (TestSetPageHWPoison(p)) {
-		action_result(pfn, "already hardware poisoned", IGNORED);
+		printk(KERN_ERR "MCE %#lx: already hardware poisoned\n", pfn);
 		return 0;
 	}
 
@@ -845,7 +837,7 @@ int __memory_failure(unsigned long pfn,
 	 * unpoison always clear PG_hwpoison inside page lock
 	 */
 	if (!PageHWPoison(p)) {
-		action_result(pfn, "unpoisoned", IGNORED);
+		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
 		res = 0;
 		goto out;
 	}
@@ -867,7 +859,7 @@ int __memory_failure(unsigned long pfn,
 	 */
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
 		action_result(pfn, "already truncated LRU", IGNORED);
-		res = 0;
+		res = -EBUSY;
 		goto out;
 	}
 
