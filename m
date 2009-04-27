Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbZD0TRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbZD0TRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZD0TRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:17:34 -0400
Received: from mail-qy0-f112.google.com ([209.85.221.112]:41733 "EHLO
	mail-qy0-f112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZD0TRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FjDqXYdIWg42T+gipODCaWVKkIe74h57rMvjirSaqL2qtbEguodHwU0IYqnNt+7AZU
         HU6OsMfhL9rwSI1W9+1lPE0xDEWdpmaiREH5r1ZJpjWQI98FvAaRB20AuWgOYpxsxw1C
         QkbBkWyGZBwXokGXVXutxzc9x0ChcPu9q9jRk=
MIME-Version: 1.0
In-Reply-To: <20090427203535.4e3f970b.d-nishimura@mtf.biglobe.ne.jp>
References: <20090427181259.6efec90b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090427101323.GK4454@balbir.in.ibm.com>
	 <20090427203535.4e3f970b.d-nishimura@mtf.biglobe.ne.jp>
Date: Tue, 28 Apr 2009 00:47:31 +0530
X-Google-Sender-Auth: 6c9ad2e394fd76a9
Message-ID: <661de9470904271217t7ef9e300x1e40bbf0362ca14f@mail.gmail.com>
Subject: Re: [PATCH] fix leak of swap accounting as stale swap cache under 
	memcg
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 5:05 PM, Daisuke Nishimura
<d-nishimura@mtf.biglobe.ne.jp> wrote:
> On Mon, 27 Apr 2009 15:43:23 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-27 18:12:59]:
>>
>> > Works very well under my test as following.
>> >   prepare a program which does malloc, touch pages repeatedly.
>> >
>> >   # echo 2M > /cgroup/A/memory.limit_in_bytes  # set limit to 2M.
>> >   # echo 0 > /cgroup/A/tasks.                  # add shell to the group.
>> >
>> >   while true; do
>> >     malloc_and_touch 1M &                       # run malloc and touch program.
>> >     malloc_and_touch 1M &
>> >     malloc_and_touch 1M &
>> >     sleep 3
>> >     pkill malloc_and_touch                      # kill them
>> >   done
>> >
>> > Then, you can see memory.memsw.usage_in_bytes increase gradually and exceeds 3M bytes.
>> > This means account for swp_entry is not reclaimed at kill -> exit-> zap_pte()
>> > because of race with swap-ops and zap_pte() under memcg.
>> >
>> > ==
>> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >
>> > Because free_swap_and_cache() function is called under spinlocks,
>> > it can't sleep and use trylock_page() instead of lock_page().
>> > By this, swp_entry which is not used after zap_xx can exists as
>> > SwapCache, which will be never used.
>> > This kind of SwapCache is reclaimed by global LRU when it's found
>> > at LRU rotation. Typical case is following.
>> >
>>
>> The changelog is not clear, this is the typical case for?
>>
> Okey, let me summarise the problem.
>
> First of all, what I think is problematic is "!PageCgroupUsed
> swap cache without the owner process".
> Those swap caches cannot be reclaimed by memcg's reclaim
> because they are not on memcg's LRU(!PageCgroupUsed pages are not
> linked to memcg's LRU).
> Moreover, the owner prcess has already gone, only global LRU scanning
> can free those swap caches.
>
> Those swap caches causes some problems like:
> (1) pressure the memsw.usage(only when MEM_RES_CTLR_SWAP).
> (2) make struct mem_cgroup unfreeable even after rmdir, because
>    we call mem_cgroup_get() when a page is swaped out(only when MEM_RES_CTLR_SWAP).
> (3) pressure the usage of swap entry.
>
> Those swap caches can be created in paths like:
>
> Type-1) race between exit and swap-in path
>  Assume processA is exiting and pte has swap entry of swaped out page.
>  And processB is trying to swap in the entry by readahead.
>  This entry holds memsw.usage and refcnt to struct mem_cgroup.
>
> Type-1.1)
>            processA                   |           processB
>  -------------------------------------+-------------------------------------
>    (free_swap_and_cache())            |  (read_swap_cache_async())
>                                       |    swap_duplicate()
>                                       |    __set_page_locked()
>                                       |    add_to_swap_cache()
>      swap_entry_free() == 1           |
>      find_get_page() -> found         |
>      try_lock_page() -> fail & return |
>                                       |    lru_cache_add_anon()
>                                       |      doesn't link this page to memcg's
>                                       |      LRU, because of !PageCgroupUsed.
>
> Type-1.2)
>            processA                   |           processB
>  -------------------------------------+-------------------------------------
>    (free_swap_and_cache())            |  (read_swap_cache_async())
>                                       |    swap_duplicate()
>      swap_entry_free() == 1           |
>      find_get_page() -> not found     |
>                         & return      |    __set_page_locked()
>                                       |    add_to_swap_cache()
>                                       |    lru_cache_add_anon()
>                                       |      doesn't link this page to memcg's
>                                       |      LRU, because of !PageCgroupUsed.
>
> Type-2) race between exit and swap-out path
>  Assume processA is exiting and pte points to a page(!PageSwapCache).
>  And processB is trying reclaim the page.
>
>            processA                   |           processB
>  -------------------------------------+-------------------------------------
>    (page_remove_rmap())               |  (shrink_page_list())
>       mem_cgroup_uncharge_page()      |
>          ->uncharged because it's not |
>            PageSwapCache yet.         |
>            So, both mem/memsw.usage   |
>            are decremented.           |
>                                       |    add_to_swap() -> added to swap cache.
>
>  If this page goes thorough without being freed for some reason, this page
>  doesn't goes back to memcg's LRU because of !PageCgroupUsed.

Thanks for the detailed explanation of the possible race conditions. I
am beginning to wonder why we don't have any hooks in add_to_swap.*.
for charging a page. If the page is already charged and if it is a
context issue (charging it to the right cgroup) that is already
handled from what I see. Won't that help us solve the !PageCgroupUsed
issue?

Balbir
