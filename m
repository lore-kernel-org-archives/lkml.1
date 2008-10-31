Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYJaCvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYJaCvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYJaCvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:51:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55246 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYJaCvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:51:31 -0400
Date: Fri, 31 Oct 2008 11:50:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, taka@valinux.co.jp
Subject: [RFC][PATCH 0/5] memcg : some patches related to swap.
Message-Id: <20081031115057.6da3dafd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is memcg update set. (the last post was 23/Oct)

This patch is agaisnt 2.6.28-rc2-mm1. (mmotm at 30/Oct)

Major changes from previous one.
 - dropped lazy_lru related patches. It's complicated and I'd like to
   design it again. (Nishimura-san reported a bug to me.)
   Fortunately, no big Hunk.

 - added a patch for swap_cache. (cut out from mem+swap controller.)
   IMHO, this is necessary to do. But previous trial (in summer) caused tons of
   troubles. I think currrent memcg's code is better than old ones and I hope
   this trial will be much easier.
 
and fixed typos and logics.

brief patch description is here. I'd like to send [1/5] in the next week.
Review and test is welcome. [2-5/5] of patches should be tested more.
And I'd like to clean up them before sending...

[1/5] change force_empty to do move account.
  - current force_empty just drops page_cgroup reference. But this means
    leak of accounting. After this patch, remaining pages at rmdir() will be
    moved to parent group.

[2/5] account swap cache
  - when processes exceed limit of memory, swap-cache can be created.
    Now, swap-cache is not accounted and can be spread over hundreds of mega
    bytes. I don't think this is sane. This patch makes swap_cache to be accounted.

[3/5] mem+swap controller config.
  - add Kconfig for mem+swap controller.

[4/5] swap_cgroup
  - create a buffer to remember account information of swap.
    Because my x86-32 test environment is poor, x86-32 test report is welcome.
    This patch uses HIGHMEM to rememver information.

[5/5]
  - mem+swap controller.
  After this patch, a page swapped-in will be accounted against an original group
  which allocated memory swapped-out.
  This is not swap controller but mem+swap controller. This limits sum of
  pages + swaps_on_disk. By this,
  - global LRU's swap-out will not hit the limit. (page is converted to swap.)
  - a group of processes leaking memory will be effectively blocked.

TODO list:
 - more optimization
 - add "shrink_usage" file
 - remove mem_cgroup_per_zone->lock and use zone->lru_lock ?
 - consider behavior of oom-kill again.
 - need some notifier to tell memory shortage as mem_notity ?
 - dirty page accountng and throttle.
 - we have to decied how to handle HUGE_PAGE
 - kernel support for hierarchy ?
 - help bio_cgroup people.

Oh, too long ;)

Thanks,
-Kame  




  




