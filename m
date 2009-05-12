Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbZELBtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbZELBtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 21:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbZELBtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 21:49:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55210 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbZELBtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 21:49:06 -0400
Date: Tue, 12 May 2009 10:47:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] fix stale swap cache at writeback.
Message-Id: <20090512104730.78bf5ab0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090512104401.28edc0a8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090512104401.28edc0a8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

memcg: free unused swapcache on swapout path

Recaliming anonymous memory in vmscan.c does following 2 steps.
  1. add to swap and unmap.
  2. pageout
But above 2 steps doesn't occur at once. There are many chances
to avoid pageout and _really_ unused pages are swapped out by
visit-and-check-again logic of LRU rotation.
But this behavior has troubles with memcg.

memcg cannot handle !PageCgroupUsed swapcache the owner process of which
has been exited.

This patch is for handling such swap caches created by a race like below:

    Assume processA is exiting and pte points to a page(!PageSwapCache).
    And processB is trying reclaim the page.

              processA                   |           processB
    -------------------------------------+-------------------------------------
      (page_remove_rmap())               |  (shrink_page_list())
         mem_cgroup_uncharge_page()      |
            ->uncharged because it's not |
              PageSwapCache yet.         |
              So, both mem/memsw.usage   |
              are decremented.           |
                                         |    add_to_swap() -> added to swap cache.

    If this page goes thorough without being freed for some reason, this page
    doesn't goes back to memcg's LRU because of !PageCgroupUsed.

These swap cache cannot be freed in memcg's LRU scanning, and swp_entry cannot
be freed properly as a result.
This patch adds a hook after add_to_swap() to check the page is mapped by a
process or not, and frees it if it has been unmapped already.

If a page has been on swap cache already when the owner process calls
page_remove_rmap() -> mem_cgroup_uncharge_page(), the page is not uncharged.
It goes back to memcg's LRU even if it goes through shrink_page_list()
without being freed, so this patch ignores these case.

Changelog: from Nishimura's original one.
 - moved functions to vmscan.c

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
Index: mmotm-2.6.30-May07/mm/vmscan.c
===================================================================
--- mmotm-2.6.30-May07.orig/mm/vmscan.c
+++ mmotm-2.6.30-May07/mm/vmscan.c
@@ -586,6 +586,32 @@ void putback_lru_page(struct page *page)
 }
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
+#if defined(CONFIG_CGROUP_MEM_RES_CTLR) && defined(CONFIG_SWAP)
+
+static int memcg_free_unused_swapcache(struct page *page)
+{
+	VM_BUG_ON(!PageLocked(page));
+	VM_BUG_ON(!PageSwapCache(page));
+
+	if (mem_cgroup_disabled())
+		return 0;
+	/*
+	 * What we do here is checking the page is accounted by memcg or not.
+	 * page_mapped() is enough check for avoding race.
+	 */
+	if (!PageAnon(page) || page_mapped(page))
+		return 0;
+	return try_to_free_swap(page);	/* checks page_swapcount */
+}
+
+#else
+
+static int memcg_free_unused_swapcache(struct page *page)
+{
+	return 0;
+}
+
+#endif
 
 /*
  * shrink_page_list() returns the number of reclaimed pages
@@ -663,6 +689,14 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 			if (!add_to_swap(page))
 				goto activate_locked;
+			/*
+			 * The owner process might have uncharged the page
+			 * (by page_remove_rmap()) before it has been added
+			 * to swap cache.
+			 * Check it here to avoid making it stale.
+			 */
+			if (memcg_free_unused_swapcache(page))
+				goto keep_locked;
 			may_enter_fs = 1;
 		}
 

