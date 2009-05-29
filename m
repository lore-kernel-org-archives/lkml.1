Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbZE2ViE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbZE2ViE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbZE2Vfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:35:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60577 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbZE2Vft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:35:49 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200905291135.124267638@firstfloor.org>
In-Reply-To: <200905291135.124267638@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [10/16] HWPOISON: Handle hardware poisoned pages in try_to_unmap
Message-Id: <20090529213536.28DFA1D0291@basil.firstfloor.org>
Date: Fri, 29 May 2009 23:35:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When a page has the poison bit set replace the PTE with a poison entry. 
This causes the right error handling to be done later when a process runs 
into it.

Also add a new flag to not do that (needed for the memory-failure handler
later)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/rmap.h |    1 +
 mm/rmap.c            |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

Index: linux/mm/rmap.c
===================================================================
--- linux.orig/mm/rmap.c	2009-05-29 23:32:10.000000000 +0200
+++ linux/mm/rmap.c	2009-05-29 23:33:29.000000000 +0200
@@ -801,7 +801,14 @@
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
Index: linux/include/linux/rmap.h
===================================================================
--- linux.orig/include/linux/rmap.h	2009-05-29 23:32:10.000000000 +0200
+++ linux/include/linux/rmap.h	2009-05-29 23:32:10.000000000 +0200
@@ -93,6 +93,7 @@
 
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
 	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
+	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
 };
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
