Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZFODVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZFODVC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZFODPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:15:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:42714 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZFODPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:15:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="154267410"
Message-Id: <20090615031253.530308256@intel.com>
References: <20090615024520.786814520@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 10:45:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>
cc: Mel Gorman <mel@csn.ul.ie>
cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 09/22] HWPOISON: Handle hardware poisoned pages in try_to_unmap
Content-Disposition: inline; filename=try-to-unmap-poison
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When a page has the poison bit set replace the PTE with a poison entry.
This causes the right error handling to be done later when a process runs
into it.

Also add a new flag to not do that (needed for the memory-failure handler
later)

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/rmap.h |    1 +
 mm/rmap.c            |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- sound-2.6.orig/mm/rmap.c
+++ sound-2.6/mm/rmap.c
@@ -958,7 +958,14 @@ static int try_to_unmap_one(struct page 
 	/* Update high watermark before we lower rss */
 	update_hiwater_rss(mm);
 
-	if (PageAnon(page)) {
+	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
+		if (PageAnon(page))
+			dec_mm_counter(mm, anon_rss);
+		else if (!is_migration_entry(pte_to_swp_entry(*pte)))
+			dec_mm_counter(mm, file_rss);
+		set_pte_at(mm, address, pte,
+				swp_entry_to_pte(make_hwpoison_entry(page)));
+	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
 		if (PageSwapCache(page)) {
--- sound-2.6.orig/include/linux/rmap.h
+++ sound-2.6/include/linux/rmap.h
@@ -94,6 +94,7 @@ enum ttu_flags {
 
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
 	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
+	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
 };
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 

-- 

