Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZE1E4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZE1E4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 00:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZE1E43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 00:56:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39363 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZE1E42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 00:56:28 -0400
Date: Thu, 28 May 2009 13:54:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 0/4] memcg fix swap accounting (28/May)
Message-Id: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed "RFC"

This patch series is restructured as following. some bugs are fixed.
Thank you for all your helps.

[1/4] ....change interface of swap_duplicate()/swap_free()
    Adds an function swapcache_prepare() and swapcache_free().

[2/4] ....add SWAP_HAS_CACHE flag and modify reference counting in swap_map
    Add SWAP_HAS_CACHE flag to swap_map array for knowing an information that
    "there is an only swap cache and swap has no reference" 
    without extra call of find_get_page().

[3/4] ....reclaim swap-cache-only swap_entry when get_swap_page() find it.
    Now, swap_map can tell "there is no reference other than cache", we
    can reclaim it if necessary.
    This code reclaim swap entries if
    - vm_swap_full()==ture
    && there is no free swap cluster
    && get_swap_page() finds unused swap entry.

[4/4].... fix memcg's swap accounting
    This is for fixing memcg's swap account leak. like this
==
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
==
    This patch tries to fix this by uncharging account when swap's refcnt goes
    to 0 even if there is an unused swap-cache.

    Works quite well in my test.

Thanks,
-Kame


