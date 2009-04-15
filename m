Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbZDOJhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbZDOJhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZDOJhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:37:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:34073 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbZDOJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ssbZrJHQPbxLtTvXpLyDTTc0ju6Dc82NPg3oEu6+raoVqMvEkquclGDbDidCfm5Gvb
         Eb/JxMd0TYPCQZZMnYwpa1J4FXFmaAuMrux0VlNI3RmBjvUpZR35qx2LBtngvnIjhsbZ
         2/sw1g0rMqNshIA1x3G2h2f2602xs1sA4m4so=
Date: Wed, 15 Apr 2009 11:37:17 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Satoshi UCHIDA <s-uchida@ap.jp.nec.com>,
       subrata@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-ID: <20090415093716.GA5968@linux>
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ryo Tsuruta <ryov@valinux.co.jp>, Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
	akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
	Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
	Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
	fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
	Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, Satoshi UCHIDA <s-uchida@ap.jp.nec.com>,
	subrata@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-4-git-send-email-righi.andrea@gmail.com> <20090415111528.b796519a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415111528.b796519a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 11:15:28AM +0900, KAMEZAWA Hiroyuki wrote:
> >  /*
> >   * Page Cgroup can be considered as an extended mem_map.
> > @@ -12,9 +12,16 @@
> >   */
> >  struct page_cgroup {
> >  	unsigned long flags;
> > -	struct mem_cgroup *mem_cgroup;
> >  	struct page *page;
> > +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > +	struct mem_cgroup *mem_cgroup;
> > +#endif
> > +#ifdef CONFIG_CGROUP_BIO
> > +	int bio_cgroup_id;
> > +#endif
> > +#if defined(CONFIG_CGROUP_MEM_RES_CTLR) || defined(CONFIG_CGROUP_BIO)
> >  	struct list_head lru;		/* per cgroup LRU list */
> > +#endif
> >  };
> > 
> This #if is unnecessary..

OK.

> 
> And, now, CSS_ID is supported. I think it can be used and your own id is not
> necessary. (plz see swap accounting in memcontrol.c/page_cgroup.c if unsure.)

Agree. We can use css_id(&bio_cgroup->css), instead of introducing a new
custom id in the bio_cgroup structure.

> 
> And... I don't like to increase the size of struct page_cgroup.
> Could you find a way to encode bio_cgroup_id into "flags" ?
> unsigned long is too much now.

And also agree here. Maybe the lower 16 bits are enough for flags, now
only 3 bits are used and we can reserve the rest (upper 16 bits in
32-bit archs and 48 bits in 64-bit archs) for the bio_cgroup id. Or do
you think it's too much for any amount of reasonable cgroups we could
have in a system?

> > +/*
> > + * This function is used to make a given page have the bio-cgroup id of
> > + * the owner of this page.
> > + */
> > +void bio_cgroup_set_owner(struct page *page, struct mm_struct *mm)
> > +{
> > +	struct bio_cgroup *biog;
> > +	struct page_cgroup *pc;
> > +
> > +	if (bio_cgroup_disabled())
> > +		return;
> > +	pc = lookup_page_cgroup(page);
> > +	if (unlikely(!pc))
> > +		return;
> > +
> > +	pc->bio_cgroup_id = 0;	/* 0: default bio_cgroup id */
> > +	if (!mm)
> > +		return;
> > +	/*
> > +	 * Locking "pc" isn't necessary here since the current process is
> > +	 * the only one that can access the members related to bio_cgroup.
> > +	 */
> > +	rcu_read_lock();
> > +	biog = bio_cgroup_from_task(rcu_dereference(mm->owner));
> > +	if (unlikely(!biog))
> > +		goto out;
> > +	/*
> > +	 * css_get(&bio->css) isn't called to increment the reference
> > +	 * count of this bio_cgroup "biog" so pc->bio_cgroup_id might turn
> > +	 * invalid even if this page is still active.
> > +	 * This approach is chosen to minimize the overhead.
> > +	 */
> > +	pc->bio_cgroup_id = biog->id;
> > +out:
> > +	rcu_read_unlock();
> > +}
> > +
> > +/*
> > + * Change the owner of a given page if necessary.
> > + */
> > +void bio_cgroup_reset_owner(struct page *page, struct mm_struct *mm)
> > +{
> > +	/*
> > +	 * A little trick:
> > +	 * Just call bio_cgroup_set_owner() for pages which are already
> > +	 * active since the bio_cgroup_id member of page_cgroup can be
> > +	 * updated without any locks. This is because an integer type of
> > +	 * variable can be set a new value at once on modern cpus.
> > +	 */
> > +	bio_cgroup_set_owner(page, mm);
> > +}
> Hmm ? I think all operations are under lock_page() and there are no races.
> Isn't it ?
> 

We can check this with:

WARN_ON_ONCE(test_bit(PG_locked, &page->flags));

> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 3ecea98..c7ad256 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/backing-dev.h>
> >  #include <linux/pagevec.h>
> >  #include <linux/migrate.h>
> > +#include <linux/biotrack.h>
> >  #include <linux/page_cgroup.h>
> >  
> >  #include <asm/pgtable.h>
> > @@ -308,6 +309,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> >  		 */
> >  		__set_page_locked(new_page);
> >  		SetPageSwapBacked(new_page);
> > +		bio_cgroup_set_owner(new_page, current->mm);
> >  		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
> >  		if (likely(!err)) {
> 
> I bet this is dangerous. You can't guarantee current->mm is owner of this swap cache
> because this is "readahead". You can't find the owner of this swap-cache until
> it's mapped. I recommend you to ignore swap-in here because
> 
>   - swapin-readahead just read (1 << page_cluster) pages at once.
>   - until the end of swap-in, the process will make no progress.

OK.

> 
> I wonder it's better to delay bio-cgroup attaching to anon page until swap-out or
> direct-io. (add hook to try_to_unmap and catch owner there.)
> Maybe most of anon pages will have no I/O if swap-out doesn't occur.
> BTW, it seems DIO from HugeTLB is not handled.

Ryo, it would be great if you can look at this and fix/integrate into
the mainstream bio-cgroup. Otherwise I can try to to schedule this in my
work.

Thanks for your suggestions Kame!
-Andrea
