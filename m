Return-Path: <linux-kernel-owner+w=401wt.eu-S1761807AbZJIXSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807AbZJIXSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761796AbZJIXSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:18:10 -0400
Received: from kroah.org ([198.145.64.141]:36866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761790AbZJIXSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:18:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:02 2009
Message-Id: <20091009231002.768016040@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 21/26] mm: add_to_swap_cache() must not sleep
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=mm-add_to_swap_cache-must-not-sleep.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

commit 31a5639623a487d6db996c8138c9e53fef2e2d91 upstream.

After commit 355cfa73 ("mm: modify swap_map and add SWAP_HAS_CACHE flag"),
read_swap_cache_async() will busy-wait while a entry doesn't exist in swap
cache but it has SWAP_HAS_CACHE flag.

Such entries can exist on add/delete path of swap cache.  On add path,
add_to_swap_cache() is called soon after SWAP_HAS_CACHE flag is set, and
on delete path, swapcache_free() will be called (SWAP_HAS_CACHE flag is
cleared) soon after __delete_from_swap_cache() is called.  So, the
busy-wait works well in most cases.

But this mechanism can cause soft lockup if add_to_swap_cache() sleeps and
read_swap_cache_async() tries to swap-in the same entry on the same cpu.

This patch calls radix_tree_preload() before swapcache_prepare() and
divides add_to_swap_cache() into two part: radix_tree_preload() part and
radix_tree_insert() part(define it as __add_to_swap_cache()).

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/swap_state.c |   70 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 24 deletions(-)

--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -66,10 +66,10 @@ void show_swap_cache_info(void)
 }
 
 /*
- * add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
+ * __add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
+static int __add_to_swap_cache(struct page *page, swp_entry_t entry)
 {
 	int error;
 
@@ -77,28 +77,37 @@ int add_to_swap_cache(struct page *page,
 	VM_BUG_ON(PageSwapCache(page));
 	VM_BUG_ON(!PageSwapBacked(page));
 
+	page_cache_get(page);
+	SetPageSwapCache(page);
+	set_page_private(page, entry.val);
+
+	spin_lock_irq(&swapper_space.tree_lock);
+	error = radix_tree_insert(&swapper_space.page_tree, entry.val, page);
+	if (likely(!error)) {
+		total_swapcache_pages++;
+		__inc_zone_page_state(page, NR_FILE_PAGES);
+		INC_CACHE_INFO(add_total);
+	}
+	spin_unlock_irq(&swapper_space.tree_lock);
+
+	if (unlikely(error)) {
+		set_page_private(page, 0UL);
+		ClearPageSwapCache(page);
+		page_cache_release(page);
+	}
+
+	return error;
+}
+
+
+int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
+{
+	int error;
+
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
-		page_cache_get(page);
-		SetPageSwapCache(page);
-		set_page_private(page, entry.val);
-
-		spin_lock_irq(&swapper_space.tree_lock);
-		error = radix_tree_insert(&swapper_space.page_tree,
-						entry.val, page);
-		if (likely(!error)) {
-			total_swapcache_pages++;
-			__inc_zone_page_state(page, NR_FILE_PAGES);
-			INC_CACHE_INFO(add_total);
-		}
-		spin_unlock_irq(&swapper_space.tree_lock);
+		error = __add_to_swap_cache(page, entry);
 		radix_tree_preload_end();
-
-		if (unlikely(error)) {
-			set_page_private(page, 0UL);
-			ClearPageSwapCache(page);
-			page_cache_release(page);
-		}
 	}
 	return error;
 }
@@ -289,13 +298,24 @@ struct page *read_swap_cache_async(swp_e
 		}
 
 		/*
+		 * call radix_tree_preload() while we can wait.
+		 */
+		err = radix_tree_preload(gfp_mask & GFP_KERNEL);
+		if (err)
+			break;
+
+		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
-		if (err == -EEXIST) /* seems racy */
+		if (err == -EEXIST) {	/* seems racy */
+			radix_tree_preload_end();
 			continue;
-		if (err)           /* swp entry is obsolete ? */
+		}
+		if (err) {		/* swp entry is obsolete ? */
+			radix_tree_preload_end();
 			break;
+		}
 
 		/*
 		 * Associate the page with swap entry in the swap cache.
@@ -307,8 +327,9 @@ struct page *read_swap_cache_async(swp_e
 		 */
 		__set_page_locked(new_page);
 		SetPageSwapBacked(new_page);
-		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
+		err = __add_to_swap_cache(new_page, entry);
 		if (likely(!err)) {
+			radix_tree_preload_end();
 			/*
 			 * Initiate read into locked page and return.
 			 */
@@ -316,6 +337,7 @@ struct page *read_swap_cache_async(swp_e
 			swap_readpage(new_page);
 			return new_page;
 		}
+		radix_tree_preload_end();
 		ClearPageSwapBacked(new_page);
 		__clear_page_locked(new_page);
 		swapcache_free(entry, NULL);


