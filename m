Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbZEZDTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbZEZDTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 23:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZEZDSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 23:18:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56753 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZEZDSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 23:18:53 -0400
Date: Tue, 26 May 2009 12:17:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 4/5] memcg: fix swap account
Message-Id: <20090526121718.8d68ea86.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes mis-accounting of swap usage in memcg.

In current implementation, memcg's swap account is uncharged only when
swap is completely freed. But there are several cases where swap
cannot be freed cleanly. For handling that, this patch changes that
memcg uncharges swap account when swap has no references other than cache.

By this, memcg's swap entry accounting can be fully synchronous with
the application's behavior.
This patch also changes memcg's hooks for swap-out.
(If delete_from_swap_cache() is called but there is no swap-reference,
 charge to swaps doesn't occur.
 (the charge for mem+swap is attached to the page itself if mapped)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/swap.h |    5 +++--
 mm/memcontrol.c      |   17 ++++++++++++-----
 mm/swapfile.c        |   14 ++++++++++----
 3 files changed, 25 insertions(+), 11 deletions(-)

Index: new-trial-swapcount/include/linux/swap.h
===================================================================
--- new-trial-swapcount.orig/include/linux/swap.h
+++ new-trial-swapcount/include/linux/swap.h
@@ -340,10 +340,11 @@ static inline void disable_swap_token(vo
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-extern void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent);
+extern void
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout);
 #else
 static inline void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout)
 {
 }
 #endif
Index: new-trial-swapcount/mm/memcontrol.c
===================================================================
--- new-trial-swapcount.orig/mm/memcontrol.c
+++ new-trial-swapcount/mm/memcontrol.c
@@ -189,6 +189,7 @@ enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
 	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
+	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
 	NR_CHARGE_TYPE,
 };
 
@@ -1501,6 +1502,7 @@ __mem_cgroup_uncharge_common(struct page
 
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+	case MEM_CGROUP_CHARGE_TYPE_DROP:
 		if (page_mapped(page))
 			goto unlock_out;
 		break;
@@ -1564,18 +1566,23 @@ void mem_cgroup_uncharge_cache_page(stru
  * called after __delete_from_swap_cache() and drop "page" account.
  * memcg information is recorded to swap_cgroup of "ent"
  */
-void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
+void
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout)
 {
 	struct mem_cgroup *memcg;
+	int ctype = MEM_CGROUP_CHARGE_TYPE_SWAPOUT;
+
+	if (!swapout) /* this was a swap cache but the swap is unused ! */
+		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
+
+	memcg = __mem_cgroup_uncharge_common(page, ctype);
 
-	memcg = __mem_cgroup_uncharge_common(page,
-					MEM_CGROUP_CHARGE_TYPE_SWAPOUT);
 	/* record memcg information */
-	if (do_swap_account && memcg) {
+	if (do_swap_account && swapout && memcg) {
 		swap_cgroup_record(ent, css_id(&memcg->css));
 		mem_cgroup_get(memcg);
 	}
-	if (memcg)
+	if (swapout && memcg)
 		css_put(&memcg->css);
 }
 #endif
Index: new-trial-swapcount/mm/swapfile.c
===================================================================
--- new-trial-swapcount.orig/mm/swapfile.c
+++ new-trial-swapcount/mm/swapfile.c
@@ -533,8 +533,9 @@ static int swap_entry_free(struct swap_i
 			swap_list.next = p - swap_info;
 		nr_swap_pages++;
 		p->inuse_pages--;
-		mem_cgroup_uncharge_swap(ent);
 	}
+	if (!swap_count(count))
+		mem_cgroup_uncharge_swap(ent);
 	if (swap_has_cache(count) && !swap_count(count)) {
 		nr_cache_only_swaps++;
 		p->cache_only++;
@@ -564,12 +565,17 @@ void swap_free(swp_entry_t entry)
 void swapcache_free(swp_entry_t entry, struct page *page)
 {
 	struct swap_info_struct *p;
+	int ret;
 
-	if (page)
-		mem_cgroup_uncharge_swapcache(page, entry);
 	p = swap_info_get(entry);
 	if (p) {
-		swap_entry_free(p, entry, 1);
+		ret = swap_entry_free(p, entry, 1);
+		if (page) {
+			if (ret)
+				mem_cgroup_uncharge_swapcache(page, entry, 1);
+			else
+				mem_cgroup_uncharge_swapcache(page, entry, 0);
+		}
 		spin_unlock(&swap_lock);
 	}
 	return;

