Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbYF3Txf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbYF3Txf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYF3Tx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:53:27 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34833 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbYF3Tx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:53:26 -0400
Date: Mon, 30 Jun 2008 20:52:23 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] memcg: change shmem handler.
In-Reply-To: <20080630173631.a252bb0e.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0806302024050.27080@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
 <Pine.LNX.4.64.0806290120270.21758@blonde.site>
 <20080630173631.a252bb0e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, KAMEZAWA Hiroyuki wrote:
> 
> How about a patch like this ?
> ==
> a RFC patch: memcg-change-shmem-handler. 
> 
> Should be divided into 2-4 patches, and may have some problem.
> (I did many careless misses today.....)
> 
> But please see idea/concepts. Maybe right way.

As you say, should be divided.  In particular, some changes are
assuming the splitlru patches (e.g. SwapBacked), and other changes
are independent of them.  Those very much have to be separated.

> 
> shmem has following characteristics.
> In general.
>   - seems like file cache
>   - swap-backed
>   - when it's swapped out, it's removed from radix-tree and added to swap.
>   - when it's swapped in, it's removed from swap and added to radix-tree.

True (aside from swap pages being in a radix-tree of their own).
Though splitlru is muddying the "seems like file cache".

> 
> With memcg.
>   - shmem is treted just as a file-cache. So, started from inactive list.

Depends on what set of patches we're talking about.

>   - shmem's page fault routine is sensitive to GFP_xxx in which used.
>     (GFP_NOWAIT is used) and pre-charge is done before add_to_page_cache.

Nothing particular to shmem or page fault routine, I think; but
shmem implementation is peculiar in calling add_to_page_cache etc.
while holding a spinlock, so needs to precharge, yes.

>   - shmem's page is removed by mem_cgroup_uncharge_cache_page(), So,
>     shmem's swapcache is not charged.

Ah, that's interesting: I'd assumed you'd changed that in your
no-refcount patches, and had been surprised not to notice a slowdown
(waiting for swap to be written and freed before coming under limit).
Now you want to make them wait: not entirely an improvement,
but I see your point.

> 
> This patch fixes some mess by
>   - PAGE_CGROUP_FLAG_CACHE is deleted (and replaced by FLAG_FILE)

That's good.

>   - PAGE_CGROUP_FLAG_SHMEM is added.

That's not good.

>   - add_to_page_cache_nocharge() is added.
>     This avoids mem_cgroup_charge_cache_page(). This is useful when page is
>     pre-charged.

Do you have to?  I get so sick of such variants.  I agree the GFP_NOWAIT
test looked rather a hack, but it's really quite appropriate.  Fragile
in that it relies on the right thing having been done; but there's a
lot of fragility in the way the memcg microcosm is hoping to mimic
the global macrocosm.  (Sorry if I'm being pretentiously obscure!)

>   - uses add_to_page_cache_nocharge() also in hugemem.
>     (I think hugemem controller should be independent from memcg.
>      Balbir, how do you think ?)
>   - PageSwapBacked() is checked.
>     (A imported patch from Hugh Dickins)

Nothing to do with the rest of it?

> 
> As result.
>   - shmem will be in SwapBacked/Active list at first.

Assuming splitlru.  Didn't my two-liner deal with that?

>   - memcg has "shmem/tmpfs" counter.

Is that a good thing?  If we really decide that globally we
need such a counter, then fine for memcg to follow; but I've
not yet heard it asked for.

> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> --
>  include/linux/pagemap.h |   16 +++++++++
>  mm/filemap.c            |   49 ++++++++++++++++++++++--------
>  mm/hugetlb.c            |    3 +
>  mm/memcontrol.c         |   78 +++++++++++++++++++++++++-----------------------
>  mm/shmem.c              |   17 ++++++----
>  5 files changed, 107 insertions(+), 56 deletions(-)

Not so good (though hardly the end of the world).

Hugh
