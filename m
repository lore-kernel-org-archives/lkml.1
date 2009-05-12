Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbZELBrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbZELBrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 21:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbZELBri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 21:47:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35782 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbZELBrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 21:47:37 -0400
Date: Tue, 12 May 2009 10:46:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] fix swap cache account leak at swapin-readahead
Message-Id: <20090512104603.ac4ca1f4.kamezawa.hiroyu@jp.fujitsu.com>
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

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In general, Linux's swp_entry handling is done by combination of lazy techniques
and global LRU. It works well but when we use mem+swap controller, some more
strict control is appropriate. Otherwise, swp_entry used by a cgroup will be
never freed until global LRU works. In a system where memcg is well-configured,
global LRU doesn't work frequently.

  Example) Assume swapin-readahead.
	      CPU0			      CPU1
	   zap_pte()			  read_swap_cache_async()
					  swap_duplicate().
           swap_entry_free() = 1
	   find_get_page()=> NULL.
					  add_to_swap_cache().
					  issue swap I/O. 

There are many patterns of this kind of race (but no problems).

free_swap_and_cache() is called for freeing swp_entry. But it is a best-effort
function. If the swp_entry/page seems busy, swp_entry is not freed.
This is not a problem because global-LRU will find SwapCache at page reclaim.

If memcg is used, on the other hand, global LRU may not work. Then, above
unused SwapCache will not be freed.
(unmapped SwapCache occupy swp_entry but never be freed if not on memcg's LRU)

So, even if there are no tasks in a cgroup, swp_entry usage still remains.
In bad case, OOM by mem+swap controller is triggered by this "leak" of
swp_entry as Nishimura reported.

Considering this issue, swapin-readahead itself is not very good for memcg.
It read swap cache which will not be used. (and _unused_ swapcache will
not be accounted.) Even if we account swap cache at add_to_swap_cache(),
we need to account page to several _unrelated_ memcg. This is bad.

This patch tries to fix racy case of free_swap_and_cache() and page status.

After this patch applied, following test works well.

  # echo 1-2M > ../memory.limit_in_bytes
  # run tasks under memcg.
  # kill all tasks and make memory.tasks empty
  # check memory.memsw.usage_in_bytes == memory.usage_in_bytes and
    there is no _used_ swp_entry.

What this patch does is
 - avoid swapin-readahead when memcg is activated.

Changelog: v6 -> v7
 - just handle races in readahead.
 - races in writeback is handled in the next patch.

Changelog: v5 -> v6
 - works only when memcg is activated.
 - check after I/O works only after writeback.
 - avoid swapin-readahead when memcg is activated.
 - fixed page refcnt issue.
Changelog: v4->v5
 - completely new design.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/swap_state.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

Index: mmotm-2.6.30-May07/mm/swap_state.c
===================================================================
--- mmotm-2.6.30-May07.orig/mm/swap_state.c
+++ mmotm-2.6.30-May07/mm/swap_state.c
@@ -349,9 +349,9 @@ struct page *read_swap_cache_async(swp_e
 struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	int nr_pages;
+	int nr_pages = 1;
 	struct page *page;
-	unsigned long offset;
+	unsigned long offset = 0;
 	unsigned long end_offset;
 
 	/*
@@ -360,8 +360,22 @@ struct page *swapin_readahead(swp_entry_
 	 * No, it's very unlikely that swap layout would follow vma layout,
 	 * more likely that neighbouring swap pages came from the same node:
 	 * so use the same "addr" to choose the same node for each swap read.
+	 *
+	 * But, when memcg is used, swapin readahead give us some bad
+	 * effects. There are 2 big problems in general.
+	 * 1. Swapin readahead tend to use/read _not required_ memory.
+	 *    And _not required_ memory is only freed by global LRU.
+	 * 2. We can't charge pages for swap-cache readahead because
+	 *    we should avoid account memory in a cgroup which a
+	 *    thread call this function is not related to.
+	 * And swapin-readahead have racy condition with
+	 * free_swap_and_cache(). This also annoys memcg.
+	 * Then, if memcg is really used, we avoid readahead.
 	 */
-	nr_pages = valid_swaphandles(entry, &offset);
+
+	if (!mem_cgroup_activated())
+		nr_pages = valid_swaphandles(entry, &offset);
+
 	for (end_offset = offset + nr_pages; offset < end_offset; offset++) {
 		/* Ok, do the async read-ahead now */
 		page = read_swap_cache_async(swp_entry(swp_type(entry), offset),

