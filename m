Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbZHJC7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbZHJC7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 22:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZHJC7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 22:59:18 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36972 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZHJC7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 22:59:17 -0400
Date: Mon, 10 Aug 2009 11:26:41 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [BUGFIX][1/2] mm: add_to_swap_cache() must not sleep
Message-Id: <20090810112641.02e1db72.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090810112326.3526b11d.nishimura@mxp.nes.nec.co.jp>
References: <20090810112326.3526b11d.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 355cfa73(mm: modify swap_map and add SWAP_HAS_CACHE flag),
read_swap_cache_async() will busy-wait while a entry doesn't on swap cache
but it has SWAP_HAS_CACHE flag.

Such entries can exist on add/delete path of swap cache.
On add path, add_to_swap_cache() is called soon after SWAP_HAS_CACHE flag
is set, and on delete path, swapcache_free() will be called (SWAP_HAS_CACHE
flag is cleared) soon after __delete_from_swap_cache() is called.
So, the busy-wait works well in most cases.

But this mechanism can cause soft lockup if add_to_swap_cache() sleeps
and read_swap_cache_async() tries to swap-in the same entry on the same cpu.

add_to_swap() and shmem_writepage() call add_to_swap_cache() w/o __GFP_WAIT,
but read_swap_cache_async() can call it w/ __GFP_WAIT, so it can cause
soft lockup.

This patch changes the gfp_mask of add_to_swap_cache() in read_swap_cache_async().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/swap_state.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 42cd38e..3e6dd72 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -76,6 +76,7 @@ int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageSwapCache(page));
 	VM_BUG_ON(!PageSwapBacked(page));
+	VM_BUG_ON(gfp_mask & __GFP_WAIT);
 
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
@@ -307,7 +308,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 */
 		__set_page_locked(new_page);
 		SetPageSwapBacked(new_page);
-		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
+		err = add_to_swap_cache(new_page, entry, GFP_ATOMIC);
 		if (likely(!err)) {
 			/*
 			 * Initiate read into locked page and return.
