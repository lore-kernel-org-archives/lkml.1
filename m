Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZLBEiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZLBEiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZLBEiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:38:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:35897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbZLBEh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764896"
Message-Id: <20091202043044.067424289@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/24] HWPOISON: return ENXIO on invalid pfn
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-action_result-valid-pfn.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return ENXIO to indicate "No such device or address".
This also avoids calling action_result() with invalid pfn.

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-mm.orig/mm/memory-failure.c	2009-11-02 10:26:17.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-02 10:26:17.000000000 +0800
@@ -598,13 +598,11 @@ static struct page_state {
 
 static void action_result(unsigned long pfn, char *msg, int result)
 {
-	struct page *page = NULL;
-	if (pfn_valid(pfn))
-		page = pfn_to_page(pfn);
+	struct page *page = pfn_to_page(pfn);
 
 	printk(KERN_ERR "MCE %#lx: %s%s page recovery: %s\n",
 		pfn,
-		page && PageDirty(page) ? "dirty " : "",
+		PageDirty(page) ? "dirty " : "",
 		msg, action_name[result]);
 }
 
@@ -730,8 +728,10 @@ int __memory_failure(unsigned long pfn, 
 		panic("Memory failure from trap %d on page %lx", trapno, pfn);
 
 	if (!pfn_valid(pfn)) {
-		action_result(pfn, "memory outside kernel control", IGNORED);
-		return -EIO;
+		printk(KERN_ERR
+		       "MCE %#lx: memory outside kernel control\n",
+		       pfn);
+		return -ENXIO;
 	}
 
 	p = pfn_to_page(pfn);


