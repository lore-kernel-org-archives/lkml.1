Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZDUHXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZDUHXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZDUHW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:22:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54366 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZDUHWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:22:55 -0400
Date: Tue, 21 Apr 2009 16:21:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: [RFC][PATCH] fix swap entries is not reclaimed in proper way for
 mem+swap controller
Message-Id: <20090421162121.1a1d15fe.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe this patch covers almost all cases of swap-leak of memcg, Nishimura-san
reported. There are many callers of lock_page() but lock_page() which can
be racy with free_swap_and_cache() is not so much, I think.

Nishimura-san, How about this ?

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

free_swap_and_cache(), which is called under various spin_lock,
is designed to be best-effort function and it does nothing if the page
is locked, under I/O. But it's ok because global lru will find the page finally.

But, when it comes to memory+swap cgroup, global LRU may not work and
swap entry can be alive as "not used but not freed" state for very very long time
because memory cgroup's LRU routine scans its own LRU only.
(Such stale swap-cache is out of memcg's LRU)

Nishimura repoted such kind of swap cache makes memcg unstable and
 - we can never free mem_cgroup object (....it's big) even if no users.
 - OOM killer can happen because amounts of charge-to-swap is leaked.

This patch tries to fix the problem by adding PageCgroupStale() flag.
If a page which is under zappped is busy swap cache, recored it as Stale.
At the end of swap I/O, Stale flag is checked and swap and swapcache is
freed if necessary. Page migration case is also checked.


Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/page_cgroup.h |    4 +++
 include/linux/swap.h        |    8 ++++++
 mm/memcontrol.c             |   51 ++++++++++++++++++++++++++++++++++++++++----
 mm/page_io.c                |    2 +
 mm/swapfile.c               |    1 
 5 files changed, 62 insertions(+), 4 deletions(-)

Index: linux-2.6.30-rc2/include/linux/page_cgroup.h
===================================================================
--- linux-2.6.30-rc2.orig/include/linux/page_cgroup.h
+++ linux-2.6.30-rc2/include/linux/page_cgroup.h
@@ -26,6 +26,7 @@ enum {
 	PCG_LOCK,  /* page cgroup is locked */
 	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
+	PCG_STALE, /* may be a stale swap-cache */
 };
 
 #define TESTPCGFLAG(uname, lname)			\
@@ -46,6 +47,9 @@ TESTPCGFLAG(Cache, CACHE)
 TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 
+TESTPCGFLAG(Stale, STALE)
+SETPCGFLAG(Stale, STALE)
+
 static inline int page_cgroup_nid(struct page_cgroup *pc)
 {
 	return page_to_nid(pc->page);
Index: linux-2.6.30-rc2/include/linux/swap.h
===================================================================
--- linux-2.6.30-rc2.orig/include/linux/swap.h
+++ linux-2.6.30-rc2/include/linux/swap.h
@@ -344,10 +344,18 @@ mem_cgroup_uncharge_swapcache(struct pag
 #endif
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
+extern void mem_cgroup_mark_swapcache_stale(struct page *page);
+extern void mem_cgroup_fixup_swapcache(struct page *page);
 #else
 static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
 {
 }
+static void mem_cgroup_check_mark_swapcache_stale(struct page *page)
+{
+}
+static void mem_cgroup_fixup_swapcache(struct page *page)
+{
+}
 #endif
 
 #else /* CONFIG_SWAP */
Index: linux-2.6.30-rc2/mm/memcontrol.c
===================================================================
--- linux-2.6.30-rc2.orig/mm/memcontrol.c
+++ linux-2.6.30-rc2/mm/memcontrol.c
@@ -1534,6 +1534,47 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	}
 	rcu_read_unlock();
 }
+
+/*
+ * free_swap_and_cache() is an best-effort function and it doesn't free
+ * swapent if the swapcache seems to be busy (ex. the page is locked.)
+ * This behavior is designed to be as is but mem+swap cgroup has to handle it.
+ * Otherwise, swp_entry seems to be leaked (for very long time)
+ */
+void mem_cgroup_mark_swapcache_stale(struct page *page)
+{
+	struct page_cgroup *pc;
+
+	if (!PageSwapCache(page) || page_mapped(page))
+		return;
+
+	pc = lookup_page_cgroup(page);
+	lock_page_cgroup(pc);
+
+	/*
+	 * This "Stale" flag will be cleared when the page is reused
+	 * somewhere.
+	 */
+	if (!PageCgroupUsed(pc))
+		SetPageCgroupStale(pc);
+	unlock_page_cgroup(pc);
+}
+
+void mem_cgroup_fixup_swapcache(struct page *page)
+{
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+
+	/* Stale flag will be cleared automatically */
+	if (unlikely(PageCgroupStale(pc))) {
+		if (get_page_unless_zero(page)) {
+			lock_page(page);
+			try_to_free_swap(page);
+			unlock_page(page);
+			page_cache_release(page);
+		}
+	}
+}
+
 #endif
 
 /*
@@ -1604,17 +1645,19 @@ void mem_cgroup_end_migration(struct mem
 	__mem_cgroup_commit_charge(mem, pc, ctype);
 
 	/*
-	 * Both of oldpage and newpage are still under lock_page().
-	 * Then, we don't have to care about race in radix-tree.
-	 * But we have to be careful that this page is unmapped or not.
+	 * oldpage is under lock_page() at migration. Then, we don't have to
+	 * care about race in radix-tree. But we have to be careful
+	 * that this page is unmapped or not.
 	 *
 	 * There is a case for !page_mapped(). At the start of
 	 * migration, oldpage was mapped. But now, it's zapped.
 	 * But we know *target* page is not freed/reused under us.
 	 * mem_cgroup_uncharge_page() does all necessary checks.
 	 */
-	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED) {
 		mem_cgroup_uncharge_page(target);
+		mem_cgroup_fixup_swapcache(target);
+	}
 }
 
 /*
Index: linux-2.6.30-rc2/mm/page_io.c
===================================================================
--- linux-2.6.30-rc2.orig/mm/page_io.c
+++ linux-2.6.30-rc2/mm/page_io.c
@@ -68,6 +68,7 @@ static void end_swap_bio_write(struct bi
 	}
 	end_page_writeback(page);
 	bio_put(bio);
+	mem_cgroup_fixup_swapcache(page);
 }
 
 void end_swap_bio_read(struct bio *bio, int err)
@@ -87,6 +88,7 @@ void end_swap_bio_read(struct bio *bio, 
 	}
 	unlock_page(page);
 	bio_put(bio);
+	mem_cgroup_fixup_swapcache(page);
 }
 
 /*
Index: linux-2.6.30-rc2/mm/swapfile.c
===================================================================
--- linux-2.6.30-rc2.orig/mm/swapfile.c
+++ linux-2.6.30-rc2/mm/swapfile.c
@@ -587,6 +587,7 @@ int free_swap_and_cache(swp_entry_t entr
 		if (swap_entry_free(p, entry) == 1) {
 			page = find_get_page(&swapper_space, entry.val);
 			if (page && !trylock_page(page)) {
+				mem_cgroup_mark_swapcache_stale(page);
 				page_cache_release(page);
 				page = NULL;
 			}

