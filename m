Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZEZDST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZEZDST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 23:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZEZDSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 23:18:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56721 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZEZDSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 23:18:12 -0400
Date: Tue, 26 May 2009 12:16:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 3/5] count cache-only swaps
Message-Id: <20090526121638.398c6951.kamezawa.hiroyu@jp.fujitsu.com>
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

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch adds a counter for unused swap caches.
Maybe useful to see "we're really under shortage of swap".

The value can be seen as kernel message at Sysrq-m etc.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/swap.h |    3 +++
 mm/swap_state.c      |    2 ++
 mm/swapfile.c        |   23 ++++++++++++++++++++---
 3 files changed, 25 insertions(+), 3 deletions(-)

Index: new-trial-swapcount/include/linux/swap.h
===================================================================
--- new-trial-swapcount.orig/include/linux/swap.h
+++ new-trial-swapcount/include/linux/swap.h
@@ -155,6 +155,7 @@ struct swap_info_struct {
 	unsigned int max;
 	unsigned int inuse_pages;
 	unsigned int old_block_size;
+	unsigned int cache_only;
 };
 
 struct swap_list_t {
@@ -298,6 +299,7 @@ extern struct page *swapin_readahead(swp
 /* linux/mm/swapfile.c */
 extern long nr_swap_pages;
 extern long total_swap_pages;
+extern long nr_cache_only_swaps;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -358,6 +360,7 @@ static inline void mem_cgroup_uncharge_s
 #define nr_swap_pages				0L
 #define total_swap_pages			0L
 #define total_swapcache_pages			0UL
+#define nr_cache_only_swaps			0UL
 
 #define si_swapinfo(val) \
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
Index: new-trial-swapcount/mm/swapfile.c
===================================================================
--- new-trial-swapcount.orig/mm/swapfile.c
+++ new-trial-swapcount/mm/swapfile.c
@@ -39,6 +39,7 @@ static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 long nr_swap_pages;
 long total_swap_pages;
+long nr_cache_only_swaps;
 static int swap_overflow;
 static int least_priority;
 
@@ -306,9 +307,11 @@ checks:
 		si->lowest_bit = si->max;
 		si->highest_bit = 0;
 	}
-	if (cache) /* at usual swap-out via vmscan.c */
+	if (cache) {/* at usual swap-out via vmscan.c */
 		si->swap_map[offset] = make_swap_count(0, 1);
-	else /* at suspend */
+		si->cache_only++;
+		nr_cache_only_swaps++;
+	} else /* at suspend */
 		si->swap_map[offset] = make_swap_count(1, 0);
 	si->cluster_next = offset + 1;
 	si->flags -= SWP_SCANNING;
@@ -513,7 +516,10 @@ static int swap_entry_free(struct swap_i
 	} else { /* dropping swap cache flag */
 		VM_BUG_ON(!has_cache);
 		p->swap_map[offset] = make_swap_count(count, 0);
-
+		if (!count) {
+			p->cache_only--;
+			nr_cache_only_swaps--;
+		}
 	}
 	/* return code. */
 	count = p->swap_map[offset];
@@ -529,6 +535,11 @@ static int swap_entry_free(struct swap_i
 		p->inuse_pages--;
 		mem_cgroup_uncharge_swap(ent);
 	}
+	if (swap_has_cache(count) && !swap_count(count)) {
+		nr_cache_only_swaps++;
+		p->cache_only++;
+	}
+
 	return count;
 }
 
@@ -1128,6 +1139,8 @@ static int try_to_unuse(unsigned int typ
 		if (swap_count(*swap_map) == SWAP_MAP_MAX) {
 			spin_lock(&swap_lock);
 			*swap_map = make_swap_count(0, 1);
+			si->cache_only++;
+			nr_cache_only_swaps++;
 			spin_unlock(&swap_lock);
 			reset_overflow = 1;
 		}
@@ -2033,6 +2046,10 @@ static int __swap_duplicate(swp_entry_t 
 		if (count < SWAP_MAP_MAX - 1) {
 			p->swap_map[offset] = make_swap_count(count + 1,
 							      has_cache);
+			if (has_cache && !count) {
+				p->cache_only--;
+				nr_cache_only_swaps--;
+			}
 			result = 1;
 		} else if (count <= SWAP_MAP_MAX) {
 			if (swap_overflow++ < 5)
Index: new-trial-swapcount/mm/swap_state.c
===================================================================
--- new-trial-swapcount.orig/mm/swap_state.c
+++ new-trial-swapcount/mm/swap_state.c
@@ -63,6 +63,8 @@ void show_swap_cache_info(void)
 		swap_cache_info.find_success, swap_cache_info.find_total);
 	printk("Free swap  = %ldkB\n", nr_swap_pages << (PAGE_SHIFT - 10));
 	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
+	printk("Cache only swap = %lukB\n",
+	       nr_cache_only_swaps << (PAGE_SHIFT - 10));
 }
 
 /*

