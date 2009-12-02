Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZLBEiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZLBEiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZLBEh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:35897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262AbZLBEh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764899"
Message-Id: <20091202043044.293905787@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/24] HWPOISON: abort on failed unmap
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-abort-on-failed-unmap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try to isolate a still mapped page. Otherwise we will hit the
BUG_ON(page_mapped(page)) in __remove_from_page_cache().

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- linux-mm.orig/mm/memory-failure.c	2009-11-30 10:35:38.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-30 11:11:25.000000000 +0800
@@ -635,7 +635,7 @@ static int page_action(struct page_state
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
-static void hwpoison_user_mappings(struct page *p, unsigned long pfn,
+static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int trapno)
 {
 	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
@@ -645,15 +645,18 @@ static void hwpoison_user_mappings(struc
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
@@ -715,6 +718,8 @@ static void hwpoison_user_mappings(struc
 	 */
 	kill_procs_ao(&tokill, !!PageDirty(p), trapno,
 		      ret != SWAP_SUCCESS, pfn);
+
+	return ret;
 }
 
 int __memory_failure(unsigned long pfn, int trapno, int ref)
@@ -786,8 +791,12 @@ int __memory_failure(unsigned long pfn, 
 
 	/*
 	 * Now take care of user space mappings.
+	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
 	 */
-	hwpoison_user_mappings(p, pfn, trapno);
+	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
+		res = -EBUSY;
+		goto out;
+	}
 
 	/*
 	 * Torn down by someone else?


