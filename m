Return-Path: <linux-kernel-owner+w=401wt.eu-S1765474AbYHFI4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765474AbYHFI4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764440AbYHFIsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:48:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33150 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763079AbYHFIsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:48:04 -0400
Date: Wed, 6 Aug 2008 17:53:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Cc: linux-mm@kvack.org, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
Message-Id: <20080806175352.6330c00a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080806082046.349BE5A5F@siro.lan>
References: <20080711175213.dc69f068.kamezawa.hiroyu@jp.fujitsu.com>
	<20080806082046.349BE5A5F@siro.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Aug 2008 17:20:46 +0900 (JST)
yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:

> hi,
> 
> > On Fri, 11 Jul 2008 17:34:46 +0900 (JST)
> > yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:
> > 
> > > hi,
> > > 
> > > > > my patch penalizes heavy-writer cgroups as task_dirty_limit does
> > > > > for heavy-writer tasks.  i don't think that it's necessary to be
> > > > > tied to the memory subsystem because i merely want to group writers.
> > > > > 
> > > > Hmm, maybe what I need is different from this ;)
> > > > Does not seem to be a help for memory reclaim under memcg.
> > > 
> > > to implement what you need, i think that we need to keep track of
> > > the numbers of dirty-pages in each memory cgroups as a first step.
> > > do you agree?
> > > 
> > yes, I think so, now.
> > 
> > may be not difficult but will add extra overhead ;( Sigh..
> 
> the following is a patch to add the overhead. :)
> any comments?
> 
Do you have some numbers ? ;) 
I like this because this seems very straightforward. thank you.


> @@ -485,7 +502,10 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>  		if (PageUnevictable(page) ||
>  		    (PageActive(page) && !active) ||
>  		    (!PageActive(page) && active)) {
> -			__mem_cgroup_move_lists(pc, page_lru(page));
> +			if (try_lock_page_cgroup(page)) {
> +				__mem_cgroup_move_lists(pc, page_lru(page));
> +				unlock_page_cgroup(page);
> +			}
>  			continue;
>  		}
>  

Hmm..ok, there will be new race between Dirty Bit and LRU bits.


> @@ -772,6 +792,38 @@ void mem_cgroup_end_migration(struct page *newpage)
>  		mem_cgroup_uncharge_page(newpage);
>  }
>  
> +void mem_cgroup_set_page_dirty(struct page *pg)
> +{
> +	struct page_cgroup *pc;
> +
> +	lock_page_cgroup(pg);
> +	pc = page_get_page_cgroup(pg);
> +	if (pc != NULL && (pc->flags & PAGE_CGROUP_FLAG_DIRTY) == 0) {
> +		struct mem_cgroup *mem = pc->mem_cgroup;
> +		struct mem_cgroup_stat *stat = &mem->stat;
> +
> +		pc->flags |= PAGE_CGROUP_FLAG_DIRTY;
> +		__mem_cgroup_stat_add(stat, MEM_CGROUP_STAT_DIRTY, 1);
> +	}
> +	unlock_page_cgroup(pg);
> +}
> +
> +void mem_cgroup_clear_page_dirty(struct page *pg)
> +{
> +	struct page_cgroup *pc;
> +
> +	lock_page_cgroup(pg);
> +	pc = page_get_page_cgroup(pg);
> +	if (pc != NULL && (pc->flags & PAGE_CGROUP_FLAG_DIRTY) != 0) {
> +		struct mem_cgroup *mem = pc->mem_cgroup;
> +		struct mem_cgroup_stat *stat = &mem->stat;
> +
> +		pc->flags &= ~PAGE_CGROUP_FLAG_DIRTY;
> +		__mem_cgroup_stat_add(stat, MEM_CGROUP_STAT_DIRTY, -1);
> +	}
> +	unlock_page_cgroup(pg);
> +}
> +

How about changing these to be

==
void mem_cgroup_test_set_page_dirty()
{
	if (try_lock_page_cgroup(pg)) {
		pc = page_get_page_cgroup(pg);
		if (pc ......) {
		}
		unlock_page_cgroup(pg)
	}
}
==


Off-topic: I wonder we can delete this "lock" in future.

Because page->page_cgroup is
 1. attached at first use.(Obiously no race with set_dirty)
 2. deleted at removal. (force_empty is problematic here..)

But, now, we need this lock.

Thanks,
-Kame

