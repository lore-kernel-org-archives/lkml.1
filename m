Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZFODSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZFODSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZFODPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:15:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:42714 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZFODO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:14:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="154267346"
Message-Id: <20090615031254.862669832@intel.com>
References: <20090615024520.786814520@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 10:45:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>
cc: Mel Gorman <mel@csn.ul.ie>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 18/22] HWPOISON: use compound head page
Content-Disposition: inline; filename=hwpoison-compound-page-head.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In most places we want to test/operate on the compound head page. 
The raw poisoned page is recorded in hwpoison_control.p for others.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- sound-2.6.orig/mm/memory-failure.c
+++ sound-2.6/mm/memory-failure.c
@@ -314,7 +314,8 @@ static const char *hwpoison_outcome_name
 
 struct hwpoison_control {
 	unsigned long pfn;
-	struct page *page;
+	struct page *p;		/* corrupted page */
+	struct page *page;	/* compound page head */
 	int outcome;
 };
 
@@ -732,13 +733,17 @@ void memory_failure(unsigned long pfn, i
 	}
 
 	p = pfn_to_page(pfn);
-	hpc.pfn = pfn;
-	hpc.page = p;
 	if (TestSetPageHWPoison(p)) {
-		action_result(&hpc, "already hardware poisoned", IGNORED);
+		printk(KERN_ERR
+		       "MCE %#lx: already hardware poisoned: Ignored\n",
+		       pfn);
 		return;
 	}
 
+	hpc.pfn  = pfn;
+	hpc.p    = p;
+	hpc.page = p = compound_head(p);
+
 	/*
 	 * We need/can do nothing about count=0 pages.
 	 * 1) it's a free page, and therefore in safe hand:
@@ -750,7 +755,7 @@ void memory_failure(unsigned long pfn, i
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_freeze_refs()/page_unfreeze_refs() mismatch.
 	 */
-	if (!get_page_unless_zero(compound_head(p))) {
+	if (!get_page_unless_zero(p)) {
 		action_result(&hpc, "free or high order kernel", IGNORED);
 		return;
 	}

-- 

