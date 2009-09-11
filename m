Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZIKSsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZIKSsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZIKSsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:48:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54016 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbZIKSsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:35 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/21] HWPOISON: Handle hardware poisoned pages in try_to_unmap
Message-Id: <20090911184838.24087B1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andi Kleen <ak@linux.intel.com>

When a page has the poison bit set replace the PTE with a poison entry.
This causes the right error handling to be done later when a process runs
into it.

v2: add a new flag to not do that (needed for the memory-failure handler
later) (Fengguang)
v3: remove unnecessary is_migration_entry() test (Fengguang, Minchan)

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/rmap.h |    1 +
 mm/rmap.c            |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

Index: linux/mm/rmap.c
===================================================================
--- linux.orig/mm/rmap.c
+++ linux/mm/rmap.c
@@ -820,7 +820,14 @@ static int try_to_unmap_one(struct page
 	/* Update high watermark before we lower rss */
 	update_hiwater_rss(mm);
 
-	if (PageAnon(page)) {
+	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
+		if (PageAnon(page))
+			dec_mm_counter(mm, anon_rss);
+		else
+			dec_mm_counter(mm, file_rss);
+		set_pte_at(mm, address, pte,
+				swp_entry_to_pte(make_hwpoison_entry(page)));
+	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
 		if (PageSwapCache(page)) {
Index: linux/include/linux/rmap.h
===================================================================
--- linux.orig/include/linux/rmap.h
+++ linux/include/linux/rmap.h
@@ -93,6 +93,7 @@ enum ttu_flags {
 
 	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
 	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
+	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
 };
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
