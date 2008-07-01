Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbYGAA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbYGAA62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbYGAA6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:58:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45756 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbYGAA6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:58:07 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <25019527.1214873805265.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 1 Jul 2008 09:56:45 +0900 (JST)
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: Re: [RFC][PATCH] memcg: change shmem handler.
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806302024050.27080@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <Pine.LNX.4.64.0806302024050.27080@blonde.site>
 <Pine.LNX.4.64.0806290117510.21758@blonde.site>
 <Pine.LNX.4.64.0806290120270.21758@blonde.site>
 <20080630173631.a252bb0e.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>> 
>> With memcg.
>>   - shmem is treted just as a file-cache. So, started from inactive list.
>
>Depends on what set of patches we're talking about.
>
just means it's charged by mem_cgroup_cache_charge()

>>   - shmem's page fault routine is sensitive to GFP_xxx in which used.
>>     (GFP_NOWAIT is used) and pre-charge is done before add_to_page_cache.
>
>Nothing particular to shmem or page fault routine, I think; but
>shmem implementation is peculiar in calling add_to_page_cache etc.
>while holding a spinlock, so needs to precharge, yes.
>
>>   - shmem's page is removed by mem_cgroup_uncharge_cache_page(), So,
>>     shmem's swapcache is not charged.
>
>Ah, that's interesting: I'd assumed you'd changed that in your
>no-refcount patches, and had been surprised not to notice a slowdown
>(waiting for swap to be written and freed before coming under limit).
>Now you want to make them wait: not entirely an improvement,
>but I see your point.
>
To do this is (maybe) a few line patch. I'll CC you if I wrote some.

>> 
>> This patch fixes some mess by
>>   - PAGE_CGROUP_FLAG_CACHE is deleted (and replaced by FLAG_FILE)
>
>That's good.
>
will do as an independent patch.

>>   - PAGE_CGROUP_FLAG_SHMEM is added.
>
>That's not good.
>
Hmm

>>   - add_to_page_cache_nocharge() is added.
>>     This avoids mem_cgroup_charge_cache_page(). This is useful when page is
>>     pre-charged.
>
>Do you have to?  I get so sick of such variants.  I agree the GFP_NOWAIT
>test looked rather a hack, but it's really quite appropriate.  Fragile
>in that it relies on the right thing having been done; but there's a
>lot of fragility in the way the memcg microcosm is hoping to mimic
>the global macrocosm.  (Sorry if I'm being pretentiously obscure!)
>
Hmm..okay, find a way to detect precharged case without adding anything.

>>   - uses add_to_page_cache_nocharge() also in hugemem.
>>     (I think hugemem controller should be independent from memcg.
>>      Balbir, how do you think ?)
>>   - PageSwapBacked() is checked.
>>     (A imported patch from Hugh Dickins)
>
>Nothing to do with the rest of it?
>
Just imported I need it to this. I'm sorry if I don't catch what you mean.


>> 
>> As result.
>>   - shmem will be in SwapBacked/Active list at first.
>
>Assuming splitlru.  Didn't my two-liner deal with that?
>
yes. yours do. just want to use switch-case rather than unclear "if" s.

>>   - memcg has "shmem/tmpfs" counter.
>
>Is that a good thing?  If we really decide that globally we
>need such a counter, then fine for memcg to follow; but I've
>not yet heard it asked for.
After swap-controller is introduced, I can imagine there will be a
swap-full/swap-less cgroup. And shmem will be able to be swapped out.
memcg handles limit of memory usage and Admin/Middleware will want to
know current limit is good or bad. So, showing amount of tmpfs 
will be good (It's now shown as Cache...a pages easily kicked out ;)

>
>> 
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> 
>> --
>>  include/linux/pagemap.h |   16 +++++++++
>>  mm/filemap.c            |   49 ++++++++++++++++++++++--------
>>  mm/hugetlb.c            |    3 +
>>  mm/memcontrol.c         |   78 +++++++++++++++++++++++++------------------
-----
>>  mm/shmem.c              |   17 ++++++----
>>  5 files changed, 107 insertions(+), 56 deletions(-)
>
>Not so good (though hardly the end of the world).
>
I'll divide and make this clearer.
Anyway I want to wait until -mm's VMM seems stable.

Thanks,
-Kame

