Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZELIPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZELIPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZELIPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:15:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40107 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZELIPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:15:30 -0400
Date: Tue, 12 May 2009 17:13:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH][BUGFIX] memcg: fix for deadlock between lock_page_cgroup
 and mapping tree_lock
Message-Id: <20090512171356.3d3a7554.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090512170007.ad7f5c7b.nishimura@mxp.nes.nec.co.jp>
References: <20090512104401.28edc0a8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090512140648.0974cb10.nishimura@mxp.nes.nec.co.jp>
	<20090512160901.8a6c5f64.kamezawa.hiroyu@jp.fujitsu.com>
	<20090512170007.ad7f5c7b.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 17:00:07 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> hmm, I see.
> cache_charge is outside of tree_lock, so moving uncharge would make sense.
> IMHO, we should make the period of spinlock as small as possible,
> and charge/uncharge of pagecache/swapcache is protected by page lock, not tree_lock.
> 
How about this ?
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

As Nishimura pointed out, mapping->tree_lock can be aquired from interrupt
context. Then, following dead lock can occur.
Assume "A" as a page.

 CPU0:
       lock_page_cgroup(A)
		interrupted
			-> take mapping->tree_lock.
 CPU1:
       take mapping->tree_lock
		-> lock_page_cgroup(A)

This patch tries to fix above deadlock by moving memcg's hook to out of
mapping->tree_lock.

After this patch, lock_page_cgroup() is not called under mapping->tree_lock.

Making Nishimura's first fix more fundamanetal for avoiding to add special case.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/filemap.c    |    6 +++---
 mm/swap_state.c |    2 +-
 mm/truncate.c   |    1 +
 mm/vmscan.c     |    2 ++
 4 files changed, 7 insertions(+), 4 deletions(-)

Index: mmotm-2.6.30-May07/mm/filemap.c
===================================================================
--- mmotm-2.6.30-May07.orig/mm/filemap.c
+++ mmotm-2.6.30-May07/mm/filemap.c
@@ -121,7 +121,6 @@ void __remove_from_page_cache(struct pag
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	BUG_ON(page_mapped(page));
-	mem_cgroup_uncharge_cache_page(page);
 
 	/*
 	 * Some filesystems seem to re-dirty the page even after
@@ -145,6 +144,7 @@ void remove_from_page_cache(struct page 
 	spin_lock_irq(&mapping->tree_lock);
 	__remove_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
+	mem_cgroup_uncharge_cache_page(page);
 }
 
 static int sync_page(void *word)
@@ -476,13 +476,13 @@ int add_to_page_cache_locked(struct page
 		if (likely(!error)) {
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
+			spin_unlock_irq(&mapping->tree_lock);
 		} else {
 			page->mapping = NULL;
+			spin_unlock_irq(&mapping->tree_lock);
 			mem_cgroup_uncharge_cache_page(page);
 			page_cache_release(page);
 		}
-
-		spin_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
 	} else
 		mem_cgroup_uncharge_cache_page(page);
Index: mmotm-2.6.30-May07/mm/swap_state.c
===================================================================
--- mmotm-2.6.30-May07.orig/mm/swap_state.c
+++ mmotm-2.6.30-May07/mm/swap_state.c
@@ -121,7 +121,6 @@ void __delete_from_swap_cache(struct pag
 	total_swapcache_pages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
-	mem_cgroup_uncharge_swapcache(page, ent);
 }
 
 /**
@@ -191,6 +190,7 @@ void delete_from_swap_cache(struct page 
 	__delete_from_swap_cache(page);
 	spin_unlock_irq(&swapper_space.tree_lock);
 
+	mem_cgroup_uncharge_swapcache(page, ent);
 	swap_free(entry);
 	page_cache_release(page);
 }
Index: mmotm-2.6.30-May07/mm/truncate.c
===================================================================
--- mmotm-2.6.30-May07.orig/mm/truncate.c
+++ mmotm-2.6.30-May07/mm/truncate.c
@@ -359,6 +359,7 @@ invalidate_complete_page2(struct address
 	BUG_ON(page_has_private(page));
 	__remove_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
+	mem_cgroup_uncharge_cache_page(page);
 	page_cache_release(page);	/* pagecache ref */
 	return 1;
 failed:
Index: mmotm-2.6.30-May07/mm/vmscan.c
===================================================================
--- mmotm-2.6.30-May07.orig/mm/vmscan.c
+++ mmotm-2.6.30-May07/mm/vmscan.c
@@ -477,10 +477,12 @@ static int __remove_mapping(struct addre
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
+		mem_cgroup_uncharge_swapcache(page);
 		swap_free(swap);
 	} else {
 		__remove_from_page_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
+		mem_cgroup_uncharge_cache_page(page);
 	}
 
 	return 1;

