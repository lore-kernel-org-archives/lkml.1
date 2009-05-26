Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZEZDOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZEZDOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 23:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZEZDOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 23:14:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36316 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZEZDOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 23:14:37 -0400
Date: Tue, 26 May 2009 12:12:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] memcg: fix swap account (26/May)[0/5]
Message-Id: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As Nishimura reported, there is a race at handling swap cache.

Typical cases are following (from Nishimura's mail)


== Type-1 ==
  If some pages of processA has been swapped out, it calls free_swap_and_cache().
  And if at the same time, processB is calling read_swap_cache_async() about
  a swap entry *that is used by processA*, a race like below can happen.

            processA                   |           processB
  -------------------------------------+-------------------------------------
    (free_swap_and_cache())            |  (read_swap_cache_async())
                                       |    swap_duplicate()
                                       |    __set_page_locked()
                                       |    add_to_swap_cache()
      swap_entry_free() == 0           |
      find_get_page() -> found         |
      try_lock_page() -> fail & return |
                                       |    lru_cache_add_anon()
                                       |      doesn't link this page to memcg's
                                       |      LRU, because of !PageCgroupUsed.

  This type of leak can be avoided by setting /proc/sys/vm/page-cluster to 0.


== Type-2 ==
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
==

This patch is a trial for fixing above problems by fixing memcg's swap account logic.
But this requires some amount of changes in swap.

Comaparing with my previous post (22/May)
(http://marc.info/?l=linux-mm&m=124297915418698&w=2),
I think this one is much easier to read...


[1/5] change interface of swap_duplicate()/swap_free()
    Adds an function swapcache_prepare() and swapcache_free().

[2/5] add SWAP_HAS_CACHE flag to swap_map
    Add SWAP_HAS_CACHE flag to swap_map array for knowing an information that
    "there is an only swap cache and swap has no reference" 
    without calling find_get_page().

[3/5] Count the number of swap-cache-only swaps
    After repeating swap-in/out, there are tons of cache-only swaps.
   (via a mapped swapcache under vm_swap_full()==false)
    This patch counts the number of entry and show it in debug information.
   (for example, sysrq-m)

[4/5] fix memcg's swap accounting.
    change the memcg's swap accounting logic to see # of references to swap.

[5/5] experimental garbage collection for cache-only swaps.
    reclaim swap enty which is not used.

patch [4/5] is for type-1
patch [5/5] is for type-2 and sanity of swaps control...

Thank you for all helps. Any comments are welcome.

Thanks,
-Kame




