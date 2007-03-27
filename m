Return-Path: <linux-kernel-owner+w=401wt.eu-S934068AbXC0Rwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068AbXC0Rwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934072AbXC0Rwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:52:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934068AbXC0Rw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:52:29 -0400
Date: Tue, 27 Mar 2007 09:52:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070327095220.4bc76cdc.akpm@linux-foundation.org>
In-Reply-To: <E1HW7tS-0003em-00@dorka.pomaz.szeredi.hu>
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
	<20070326153153.817b6a82.akpm@linux-foundation.org>
	<E1HW5am-0003Mc-00@dorka.pomaz.szeredi.hu>
	<20070326232214.ee92d8c4.akpm@linux-foundation.org>
	<E1HW6Ec-0003Tv-00@dorka.pomaz.szeredi.hu>
	<20070326234957.6b287dda.akpm@linux-foundation.org>
	<E1HW6eb-0003WX-00@dorka.pomaz.szeredi.hu>
	<20070327001834.04dc375e.akpm@linux-foundation.org>
	<E1HW72O-0003ZB-00@dorka.pomaz.szeredi.hu>
	<20070327005150.9177ae02.akpm@linux-foundation.org>
	<E1HW7tS-0003em-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 11:23:06 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > > > But Peter Staubach says a RH custumer has files written thorugh mmap,
> > > > > which are not being backed up.
> > > > 
> > > > Yes, I expect the backup problem is the major real-world hurt arising from
> > > > this bug.
> > > > 
> > > > But I expect we could adequately plug that problem at munmap()-time.  Or,
> > > > better, do_wp_page().  As I said - half-assed.
> > > > 
> > > > It's a question if whether the backup problem is the only thing which is hurting
> > > > in the real-world, or if people have other problems.
> > > > 
> > > > (In fact, what's wrong with doing it in do_wp_page()?
> > > 
> > > It's rather more expensive, than just toggling a bit.
> > 
> > It shouldn't be, especially for filesystems which have one-second timestamp
> > granularity.
> > 
> > Filesystems which have s_time_gran=1 might hurt a bit, but no more than
> > they will with write().
> > 
> > Actually, no - we'd only update the mctime once per page per writeback
> > period (30 seconds by default) so the load will be small.
> 
> Why?  For each faulted page the times will be updated, no?

Yes, but only at pagefault-time.  And

- the faults are already "slow": we need to pull the page contents in
  from disk, or memset or cow the page

- we need to take the trap

compared to which, the cost of the timestamp update will (we hope) be
relatively low.

> Maybe it's acceptable, I don't really know the cost of
> file_update_time().
> 
> Tried this patch, and it seems to work.  It will even randomly update
> the time for tmpfs files (on initial fault, and on swapins).
> 
> Miklos
> 
> Index: linux/mm/memory.c
> ===================================================================
> --- linux.orig/mm/memory.c	2007-03-27 11:04:40.000000000 +0200
> +++ linux/mm/memory.c	2007-03-27 11:08:19.000000000 +0200
> @@ -1664,6 +1664,8 @@ gotten:
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
>  	if (dirty_page) {
> +		if (vma->vm_file)
> +			file_update_time(vma->vm_file);
>  		set_page_dirty_balance(dirty_page);
>  		put_page(dirty_page);
>  	}
> @@ -2316,6 +2318,8 @@ retry:
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
>  	if (dirty_page) {
> +		if (vma->vm_file)
> +			file_update_time(vma->vm_file);
>  		set_page_dirty_balance(dirty_page);
>  		put_page(dirty_page);
>  	}

that's simpler ;) Is it correct enough though?  The place where it will
become inaccurate is for repeated modification via an established map.  ie:

	p = mmap(..., MAP_SHARED);
	for ( ; ; )
		*p = 1;

in which case I think the timestamp will only get updated once per
writeback interval (ie: 30 seconds).


tmpfs files have an s_time_gran of 1, so benchmarking some workload on
tmpfs with this patch will tell us the worst-case overhead of the change. 

I guess we should arrange for multiple CPUs to perform write faults against
multiple pages of the same file in parallel.  Of course, that'd be a pretty
darn short benchmark because it'll run out of RAM.  Which reveals why we
probably won't have a performance problem in there.


