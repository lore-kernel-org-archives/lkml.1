Return-Path: <linux-kernel-owner+w=401wt.eu-S966257AbZLHVWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257AbZLHVWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966328AbZLHVVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:21:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49520 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966247AbZLHVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:18 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [8/31] HWPOISON: abort on failed unmap
Message-Id: <20091208211624.5884DB151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

Don't try to isolate a still mapped page. Otherwise we will hit the
BUG_ON(page_mapped(page)) in __remove_from_page_cache().

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory-failure.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -657,7 +657,7 @@ static int page_action(struct page_state
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
-static void hwpoison_user_mappings(struct page *p, unsigned long pfn,
+static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int trapno)
 {
 	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
@@ -667,15 +667,18 @@ static void hwpoison_user_mappings(struc
 	int i;
 	int kill = 1;
 
-	if (PageReserved(p) || PageCompound(p) || PageSlab(p) || PageKsm(p))
-		return;
+	if (PageReserved(p) || PageSlab(p))
+		return SWAP_SUCCESS;
 
 	/*
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
 	if (!page_mapped(p))
-		return;
+		return SWAP_SUCCESS;
+
+	if (PageCompound(p) || PageKsm(p))
+		return SWAP_FAIL;
 
 	if (PageSwapCache(p)) {
 		printk(KERN_ERR
@@ -737,6 +740,8 @@ static void hwpoison_user_mappings(struc
 	 */
 	kill_procs_ao(&tokill, !!PageDirty(p), trapno,
 		      ret != SWAP_SUCCESS, pfn);
+
+	return ret;
 }
 
 int __memory_failure(unsigned long pfn, int trapno, int flags)
@@ -809,8 +814,13 @@ int __memory_failure(unsigned long pfn,
 
 	/*
 	 * Now take care of user space mappings.
+	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
 	 */
-	hwpoison_user_mappings(p, pfn, trapno);
+	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
+		printk(KERN_ERR "MCE %#lx: cannot unmap page, give up\n", pfn);
+		res = -EBUSY;
+		goto out;
+	}
 
 	/*
 	 * Torn down by someone else?
