Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZEZDUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZEZDUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 23:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZEZDUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 23:20:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51434 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZEZDUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 23:20:08 -0400
Date: Tue, 26 May 2009 12:18:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 5/5] (experimental) chase and free cache only swap
Message-Id: <20090526121834.dd9a4193.kamezawa.hiroyu@jp.fujitsu.com>
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

Just a trial/example patch.
I'd like to consider more. Better implementation idea is welcome.

When the system does swap-in/swap-out repeatedly, there are 
cache-only swaps in general.
Typically,
 - swapped out in past but on memory now while vm_swap_full() returns true
pages are cache-only swaps. (swap_map has no references.)

This cache-only swaps can be an obstacles for smooth page reclaiming.
Current implemantation is very naive, just scan & free.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/swap.h |    1 
 mm/swapfile.c        |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

Index: new-trial-swapcount/mm/swapfile.c
===================================================================
--- new-trial-swapcount.orig/mm/swapfile.c
+++ new-trial-swapcount/mm/swapfile.c
@@ -74,6 +74,8 @@ static inline unsigned short make_swap_c
 	return ret;
 }
 
+static void call_gc_cache_only_swap(void);
+
 /*
  * We need this because the bdev->unplug_fn can sleep and we cannot
  * hold swap_lock while calling the unplug_fn. And swap_lock
@@ -432,6 +434,8 @@ swp_entry_t get_swap_page(void)
 		offset = scan_swap_map(si, 1);
 		if (offset) {
 			spin_unlock(&swap_lock);
+			/* reclaim cache-only swaps if vm_swap_full() */
+			call_gc_cache_only_swap();
 			return swp_entry(type, offset);
 		}
 		next = swap_list.next;
@@ -2147,3 +2151,87 @@ int valid_swaphandles(swp_entry_t entry,
 	*offset = ++toff;
 	return nr_pages? ++nr_pages: 0;
 }
+
+/*
+ * Following code is for freeing Cache-only swap entries. These are calle in
+ * vm_swap_full() situation, and freeing cache-only swap and make some swap
+ * entries usable.
+ */
+
+static int find_free_cache_only_swap(int type)
+{
+	unsigned long buf[SWAP_CLUSTER_MAX];
+	int nr, offset, i;
+	unsigned short count;
+	struct swap_info_struct *si = swap_info + type;
+	int ret = 0;
+
+	spin_lock(&swap_lock);
+	nr = 0;
+	if (!(si->flags & SWP_WRITEOK) || si->cache_only == 0) {
+		ret = 1;
+		goto unlock;
+	}
+	offset = si->garbage_scan_offset;
+	/* Scan 2048 entries at most and free up to 32 entries per scan.*/
+	for (i = 2048; i > 0 && nr < 32; i--, offset++) {
+		if (offset >= si->max) {
+			offset = 0;
+			ret = 1;
+			break;
+		}
+		count = si->swap_map[offset];
+		if (count == SWAP_HAS_CACHE)
+			buf[nr++] = offset;
+	}
+	si->garbage_scan_offset = offset;
+unlock:
+	spin_unlock(&swap_lock);
+
+	for (i = 0; i < nr; i++) {
+		swp_entry_t ent;
+		struct page *page;
+
+		ent = swp_entry(type, buf[i]);
+
+		page = find_get_page(&swapper_space, ent.val);
+		if (page) {
+			lock_page(page);
+			try_to_free_swap(page);
+			unlock_page(page);
+		}
+	}
+	return ret;
+}
+
+#define SWAP_GC_THRESH	(4096)
+static void scan_and_free_cache_only_swap_work(struct work_struct *work);
+DECLARE_DELAYED_WORK(swap_gc_work, scan_and_free_cache_only_swap_work);
+static int swap_gc_last_scan;
+
+static void scan_and_free_cache_only_swap_work(struct work_struct *work)
+{
+	int type = swap_gc_last_scan;
+	int i;
+
+	spin_lock(&swap_lock);
+	for (i = type; i < MAX_SWAPFILES; i++) {
+		if (swap_info[i].flags & SWP_WRITEOK)
+			break;
+	}
+	if (i >= MAX_SWAPFILES)
+		i = 0;
+	spin_unlock(&swap_lock);
+	if (find_free_cache_only_swap(i))
+		swap_gc_last_scan = i + 1;
+
+	if (vm_swap_full() && (nr_cache_only_swaps > SWAP_GC_THRESH))
+		schedule_delayed_work(&swap_gc_work, HZ/10);
+}
+
+static void call_gc_cache_only_swap(void)
+{
+	if (vm_swap_full()  && (nr_cache_only_swaps > SWAP_GC_THRESH))
+		schedule_delayed_work(&swap_gc_work, HZ/10);
+}
+
Index: new-trial-swapcount/include/linux/swap.h
===================================================================
--- new-trial-swapcount.orig/include/linux/swap.h
+++ new-trial-swapcount/include/linux/swap.h
@@ -156,6 +156,7 @@ struct swap_info_struct {
 	unsigned int inuse_pages;
 	unsigned int old_block_size;
 	unsigned int cache_only;
+	unsigned int garbage_scan_offset;
 };
 
 struct swap_list_t {

