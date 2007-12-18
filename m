Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXLRV6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXLRV6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXLRV6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:58:47 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59674 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbXLRV6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:58:46 -0500
Date: Tue, 18 Dec 2007 21:57:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] tmpfs: move swap_state stats update
In-Reply-To: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182156450.27165@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both unionfs and memcgroups pose challenges to tmpfs and shmem.  To help
fix, it's best to move the swap swizzling functions from swap_state.c
to shmem.c.  As a preliminary to that, move swap stats updating down
into __add_to_swap_cache, which will remain internal to swap_state.c.

Well, actually, just move down the incrementation of add_total: remove
noent_race and exist_race completely, they are relics of my 2.4.11 testing.
Alt-SysRq-m users will be thrilled if 2.6.25 is at last free of "race M+N"s.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
checkpatch.pl would like me to add a KERN_level to the printk, but that's
not something I want to get into here: this is one of a sequence of printks,
some of which are per-arch, with different KERN_levels in different archs.

Perhaps the remaining add/delete/find swap stats should be junked too;
but they are of more general significance, so leave them for now.  Nor do I
want to get into removing that irritatingly repeated "Free swap" right now.

 mm/swap_state.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- 2.6.24-rc5-mm1/mm/swap_state.c	2007-12-05 10:38:45.000000000 +0000
+++ tmpfs1/mm/swap_state.c	2007-12-05 16:42:16.000000000 +0000
@@ -52,16 +52,13 @@ static struct {
 	unsigned long del_total;
 	unsigned long find_success;
 	unsigned long find_total;
-	unsigned long noent_race;
-	unsigned long exist_race;
 } swap_cache_info;
 
 void show_swap_cache_info(void)
 {
-	printk("Swap cache: add %lu, delete %lu, find %lu/%lu, race %lu+%lu\n",
+	printk("Swap cache: add %lu, delete %lu, find %lu/%lu\n",
 		swap_cache_info.add_total, swap_cache_info.del_total,
-		swap_cache_info.find_success, swap_cache_info.find_total,
-		swap_cache_info.noent_race, swap_cache_info.exist_race);
+		swap_cache_info.find_success, swap_cache_info.find_total);
 	printk("Free swap  = %lukB\n", nr_swap_pages << (PAGE_SHIFT - 10));
 	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
 }
@@ -89,6 +86,7 @@ static int __add_to_swap_cache(struct pa
 			set_page_private(page, entry.val);
 			total_swapcache_pages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
+			INC_CACHE_INFO(add_total);
 		}
 		write_unlock_irq(&swapper_space.tree_lock);
 		radix_tree_preload_end();
@@ -102,10 +100,9 @@ static int add_to_swap_cache(struct page
 	int error;
 
 	BUG_ON(PageLocked(page));
-	if (!swap_duplicate(entry)) {
-		INC_CACHE_INFO(noent_race);
+	if (!swap_duplicate(entry))
 		return -ENOENT;
-	}
+
 	SetPageLocked(page);
 	error = __add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL);
 	/*
@@ -114,11 +111,8 @@ static int add_to_swap_cache(struct page
 	if (error) {
 		ClearPageLocked(page);
 		swap_free(entry);
-		if (error == -EEXIST)
-			INC_CACHE_INFO(exist_race);
 		return error;
 	}
-	INC_CACHE_INFO(add_total);
 	return 0;
 }
 
@@ -178,11 +172,9 @@ int add_to_swap(struct page * page, gfp_
 		case 0:				/* Success */
 			SetPageUptodate(page);
 			SetPageDirty(page);
-			INC_CACHE_INFO(add_total);
 			return 1;
 		case -EEXIST:
 			/* Raced with "speculative" read_swap_cache_async */
-			INC_CACHE_INFO(exist_race);
 			swap_free(entry);
 			continue;
 		default:
@@ -225,9 +217,7 @@ int move_to_swap_cache(struct page *page
 		if (!swap_duplicate(entry))
 			BUG();
 		SetPageDirty(page);
-		INC_CACHE_INFO(add_total);
-	} else if (err == -EEXIST)
-		INC_CACHE_INFO(exist_race);
+	}
 	return err;
 }
 
