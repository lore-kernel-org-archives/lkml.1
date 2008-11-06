Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbYKFQlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbYKFQlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYKFQll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:41:41 -0500
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:60841 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYKFQlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:41:40 -0500
Date: Thu, 6 Nov 2008 22:03:32 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, linux-mm@kvack.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] get rid of lru_add_drain_all() in munlock path
Message-ID: <20081106163332.GA4639@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <2f11576a0810290017g310e4469gd27aa857866849bd@mail.gmail.com> <1225284014.8257.36.camel@lts-notebook> <20081106085147.0D28.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081106085147.0D28.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2008-11-06 09:14:07]:

> > > > Now, in the current upstream version of the unevictable mlocked pages
> > > > patches, we just count any mlocked pages [vmstat] that make their way to
> > > > free*page() instead of BUGging out, as we were doing earlier during
> > > > development.  So, maybe we can drop the lru_drain_add()s in the
> > > > unevictable mlocked pages work and live with the occasional freed
> > > > mlocked page, or mlocked page on the active/inactive lists to be dealt
> > > > with by vmscan.
> > > 
> > > hm, okey.
> > > maybe, I was wrong.
> > > 
> > > I'll make "dropping lru_add_drain_all()" patch soon.
> > > I expect I need few days.
> > >   make the patch:                  1 day
> > >   confirm by stress workload:  2-3 days
> > > 
> > > because rik's original problem only happend on heavy wokload, I think.
> > 
> > Indeed.  It was an ad hoc test program [2 versions attached] written
> > specifically to beat on COW of shared pages mlocked by parent then COWed
> > by parent or child and unmapped explicitly or via exit.  We were trying
> > to find all the ways the we could end up freeing mlocked pages--and
> > there were several.  Most of these turned out to be genuine
> > coding/design defects [as difficult as that may be to believe :-)], so
> > tracking them down was worthwhile.  And, I think that, in general,
> > clearing a page's mlocked state and rescuing from the unevictable lru
> > list on COW--to prevent the mlocked page from ending up mapped into some
> > task's non-VM_LOCKED vma--is a good thing to strive for.  
> 
> 
> 
> > Now, looking at the current code [28-rc1] in [__]clear_page_mlock():
> > We've already cleared the PG_mlocked flag, we've decremented the mlocked
> > pages stats, and we're just trying to rescue the page from the
> > unevictable list to the in/active list.  If we fail to isolate the page,
> > then either some other task has it isolated and will return it to an
> > appropriate lru or it resides in a pagevec heading for an in/active lru
> > list.  We don't use pagevec for unevictable list.  Any other cases?  If
> > not, then we can probably dispense with the "try harder" logic--the
> > lru_add_drain()--in __clear_page_mlock().
> > 
> > Do you agree?  Or have I missed something?
> 
> Yup.
> you are perfectly right.
> 
> Honestly, I thought lazy rescue isn't so good because it cause statics difference of
> # of mlocked pages and # of unevictalble pages in past time.
> and, I tought i can avoid it.
> 
> but it is wrong.
> 
> I made its patch actually, but it introduce many and unnecessary messyness.
> So, I believe simple lru_add_drain_all() dropping patch is better.
> 
> Again, you are right.
> 
> 
> In these days, I've run stress workload and I confirm my patch doesn't
> cause mlocked page leak.
> 
> this patch also solve Heiko and Kamalesh rtnl 
> circular dependency problem (I think).
> http://marc.info/?l=linux-kernel&m=122460208308785&w=2
> http://marc.info/?l=linux-netdev&m=122586921407698&w=2
> 
> 
> -------------------------------------------------------------------------
> lockdep warns about following message at boot time on one of my test machine.
> Then, schedule_on_each_cpu() sholdn't be called when the task have mmap_sem.
> 
> Actually, lru_add_drain_all() exist to prevent the unevictalble pages stay on reclaimable lru list.
> but currenct unevictable code can rescue unevictable pages although it stay on reclaimable list.
> 
> So removing is better.
> 
> In addition, this patch add lru_add_drain_all() to sys_mlock() and sys_mlockall().
> it isn't must.
> but it reduce the failure of moving to unevictable list.
> its failure can rescue in vmscan later. but reducing is better.
> 
> 
> Note, if above rescuing happend, the Mlocked and the Unevictable field mismatching happend in /proc/meminfo.
> but it doesn't cause any real trouble.
> 
> 
<snip warning>

Hi Kosaki-san,

 Thanks, the patch fixes the circular locking dependency warning, while
booting up.

  Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/mlock.c |   16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> Index: b/mm/mlock.c
> ===================================================================
> --- a/mm/mlock.c	2008-11-02 20:23:38.000000000 +0900
> +++ b/mm/mlock.c	2008-11-02 21:00:21.000000000 +0900
> @@ -66,14 +66,10 @@ void __clear_page_mlock(struct page *pag
>  		putback_lru_page(page);
>  	} else {
>  		/*
> -		 * Page not on the LRU yet.  Flush all pagevecs and retry.
> +		 * We lost the race. the page already moved to evictable list.
>  		 */
> -		lru_add_drain_all();
> -		if (!isolate_lru_page(page))
> -			putback_lru_page(page);
> -		else if (PageUnevictable(page))
> +		if (PageUnevictable(page))
>  			count_vm_event(UNEVICTABLE_PGSTRANDED);
> -
>  	}
>  }
> 
> @@ -187,8 +183,6 @@ static long __mlock_vma_pages_range(stru
>  	if (vma->vm_flags & VM_WRITE)
>  		gup_flags |= GUP_FLAGS_WRITE;
> 
> -	lru_add_drain_all();	/* push cached pages to LRU */
> -
>  	while (nr_pages > 0) {
>  		int i;
> 
> @@ -251,8 +245,6 @@ static long __mlock_vma_pages_range(stru
>  		ret = 0;
>  	}
> 
> -	lru_add_drain_all();	/* to update stats */
> -
>  	return ret;	/* count entire vma as locked_vm */
>  }
> 
> @@ -546,6 +538,8 @@ asmlinkage long sys_mlock(unsigned long 
>  	if (!can_do_mlock())
>  		return -EPERM;
> 
> +	lru_add_drain_all();	/* flush pagevec */
> +
>  	down_write(&current->mm->mmap_sem);
>  	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
>  	start &= PAGE_MASK;
> @@ -612,6 +606,8 @@ asmlinkage long sys_mlockall(int flags)
>  	if (!can_do_mlock())
>  		goto out;
> 
> +	lru_add_drain_all();	/* flush pagevec */
> +
>  	down_write(&current->mm->mmap_sem);
> 
>  	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> 
> 
> 

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
