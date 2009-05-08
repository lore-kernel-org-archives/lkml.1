Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZEHFHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZEHFHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZEHFHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:07:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60265 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZEHFHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:07:01 -0400
Date: Fri, 8 May 2009 14:05:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] fix stale swap cache account leak  in memcg v6
Message-Id: <20090508140528.c34ae712.kamezawa.hiroyu@jp.fujitsu.com>
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


Considering Type-1, it's better to avoid swapin-readahead when memcg is used.
swapin-readahead just read swp_entries which are near to requested entry. So,
pages not to be used can be on memory (on global LRU). When memcg is used,
this is not good behavior anyway.

Considering Type-2, the page should be freed from SwapCache right after WriteBack.
Free swapped out pages as soon as possible is a good nature to memcg, anyway.

The patch set includes followng
 [1/2] add mem_cgroup_is_activated() function. which tell us memcg is _really_ used.
 [2/2] fix swap cache handling.


Test result is good under my test. Nishimura, could you try ?

Thanks,
-Kame

