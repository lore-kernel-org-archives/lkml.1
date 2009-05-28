Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZE1FWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZE1FWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZE1FWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:22:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53943 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZE1FWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:22:22 -0400
Date: Thu, 28 May 2009 14:20:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 3/4] reuse unused swap entry if necessary
Message-Id: <20090528142047.3069543b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, we can know a swap entry is just used as SwapCache via swap_map,
without looking up swap cache.

Then, we have a chance to reuse swap-cache-only swap entries in
get_swap_pages().

This patch tries to free swap-cache-only swap entries if swap is
not enough.
Note: We hit following path when swap_cluster code cannot find
a free cluster. Then, vm_swap_full() is not only condition to allow
the kernel to reclaim unused swap.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/swapfile.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

Index: new-trial-swapcount2/mm/swapfile.c
===================================================================
--- new-trial-swapcount2.orig/mm/swapfile.c
+++ new-trial-swapcount2/mm/swapfile.c
@@ -73,6 +73,25 @@ static inline unsigned short make_swap_c
 	return ret;
 }
 
+static int
+try_to_reuse_swap(struct swap_info_struct *si, unsigned long offset)
+{
+	int type = si - swap_info;
+	swp_entry_t entry = swp_entry(type, offset);
+	struct page *page;
+	int ret = 0;
+
+	page = find_get_page(&swapper_space, entry.val);
+	if (!page)
+		return 0;
+	if (trylock_page(page)) {
+		ret = try_to_free_swap(page);
+		unlock_page(page);
+	}
+	page_cache_release(page);
+	return ret;
+}
+
 /*
  * We need this because the bdev->unplug_fn can sleep and we cannot
  * hold swap_lock while calling the unplug_fn. And swap_lock
@@ -294,6 +313,18 @@ checks:
 		goto no_page;
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
+
+	/* reuse swap entry of cache-only swap if not busy. */
+	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+		int ret;
+		spin_unlock(&swap_lock);
+		ret = try_to_reuse_swap(si, offset);
+		spin_lock(&swap_lock);
+		if (ret)
+			goto checks; /* we released swap_lock. retry. */
+		goto scan; /* In some racy case */
+	}
+
 	if (si->swap_map[offset])
 		goto scan;
 
@@ -375,6 +406,10 @@ scan:
 			spin_lock(&swap_lock);
 			goto checks;
 		}
+		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+			spin_lock(&swap_lock);
+			goto checks;
+		}
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
@@ -386,6 +421,10 @@ scan:
 			spin_lock(&swap_lock);
 			goto checks;
 		}
+		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+			spin_lock(&swap_lock);
+			goto checks;
+		}
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;

