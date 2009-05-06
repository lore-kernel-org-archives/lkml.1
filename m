Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbZEFNx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbZEFNx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZEFNxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:53:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:8807 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZEFNxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ehwb42eu560uhudo0MS+sskp/fxh6NVnXQatqpqq3jtv48SLPoI/Z6vUzLwXenCgCC
         zHiiS31UlBe+JSkvHwt3ljbyIFKD+KsX10tuzDzNYdxaC7mYvBpXOhOpwxjCPd7l6Lhl
         wWc0D3am9Bztrni8qxHKk+7/T/0++KQHssj3o=
Date: Wed, 6 May 2009 21:52:53 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "alan-jenkins@tuffmail.co.uk" <alan-jenkins@tuffmail.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/5] PM/Hibernate: Do not release preallocated memory
	unnecessarily (rev. 2)
Message-ID: <20090506135253.GA26233@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905040222.39062.rjw@sisk.pl> <20090505022427.GA10880@localhost> <200905060105.10800.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905060105.10800.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 07:05:09AM +0800, Rafael J. Wysocki wrote:
> On Tuesday 05 May 2009, Wu Fengguang wrote:
> > On Mon, May 04, 2009 at 08:22:38AM +0800, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Since the hibernation code is now going to use allocations of memory
> > > to create enough room for the image, it can also use the page frames
> > > allocated at this stage as image page frames.  The low-level
> > > hibernation code needs to be rearranged for this purpose, but it
> > > allows us to avoid freeing a great number of pages and allocating
> > > these same pages once again later, so it generally is worth doing.
> > > 
> > > [rev. 2: Change the strategy of preallocating memory to allocate as
> > >  many pages as needed to get the right image size in one shot (the
> > >  excessive allocated pages are released afterwards).]
> > 
> > Rafael, I tried out your patches and found doubled memory shrink speed!
> >
> > [  579.641781] PM: Preallocating image memory ... done (allocated 383900 pages, 128000 image pages kept)
> > [  583.087875] PM: Allocated 1535600 kbytes in 3.43 seconds (447.69 MB/s)
> 
> Unfortunately, I'm observing a regression and a huge one.
> 
> On my Atom-based test box with 1 GB of RAM after a fresh boot and starting X
> with KDE 4 there are ~256 MB free.  To create an image we need to free ~300 MB
> and that takes ~2 s with the old code and ~15 s with the new one.
> 
> It helps to call shrink_all_memory() once with a sufficiently large argument
> before the preallocation.

Yes there are some strange behaviors. I tried to populate the page
cache with 1/30 mapped file pages and others normal file pages, all
referenced once. I get this on "echo disk > /sys/power/state":

[  462.820098] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
[  462.827161] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  462.834249] PM: Basic memory bitmaps created
[  462.838631] PM: Syncing filesystems ... done.
[  463.167805] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  463.175738] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  463.183834] PM: Preallocating image memory ... done (allocated 383898 pages, 128000 image pages kept)
[  469.605741] PM: Allocated 1535592 kbytes in 6.41 seconds (239.56 MB/s)
[  469.612325]
[  469.768796] Restarting tasks ... done.
[  469.775044] PM: Basic memory bitmaps freed

Immediately after that, I copied a big sparse file into memory, and get this:

[  508.097913] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
[  508.104799] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  508.111702] PM: Basic memory bitmaps created
[  508.116073] PM: Syncing filesystems ... done.
[  509.208608] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  509.216692] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  509.224708] PM: Preallocating image memory ... done (allocated 383872 pages, 128000 image pages kept)
[  520.951882] PM: Allocated 1535488 kbytes in 11.71 seconds (131.12 MB/s)

It's much worse.

Your patches are really interesting exercises for the vmscan code ;-)

> > +       error = memory_bm_create(&orig_bm, GFP_IMAGE, PG_ANY);
> > +       if (error)
> > +               goto err_out;
> > +
> > +       error = memory_bm_create(&copy_bm, GFP_IMAGE, PG_ANY);
> > +       if (error)
> > +               goto err_out;
> > 
> > memory_bm_create() is called a number of times, each time it will
> > call create_mem_extents()/memory_bm_free(). Can they be optimized to
> > be called only once?
> 
> Possibly, but not right now if you please?  This is just moving code BTW.

OK.

> 
> > A side note: there are somehow duplicated *_extent_*() logics in the
> > filesystems, is it possible that we abstract out some of the common code?
> 
> I think we can do it, but it really is low priority to me at the moment.

OK. Just was a wild thought.

> 
> > +       for_each_populated_zone(zone) {
> > +               size += snapshot_additional_pages(zone);
> > +               count += zone_page_state(zone, NR_FREE_PAGES);
> > +               if (!is_highmem(zone))
> > +                       count -= zone->lowmem_reserve[ZONE_NORMAL];
> > +       }
> > 
> > Why [ZONE_NORMAL] instead of [zone]? ZONE_NORMAL may not always be the largest zone,
> > for example, My 4GB laptop has a tiny ZONE_NORMAL and a large ZONE_DMA32.
> 
> Ah, this is a leftover and it should be changed or even dropped.  Can you
> please remind me how exactly lowmem_reserve[] is supposed to work?

totalreserve_pages could be better. When free memory drops below that
threshold(it actually works per zone), kswapd will wake up trying to
reclaim pages. If the total reclaimable+free pages are as low as
totalreserve_pages, that would drive kswapd mad - scanning the whole
zones, trying to squeeze the last pages out of them.  Sure kswapd will
stop somewhere, but the resulting scan:reclaim ratio would be pretty
high and therefore hurt performance.

So we shall stop preallocation when reclaimable pages go down to
something like (5*totalreserve_pages). The vmscan mad may come earlier
because of unbalanced distributions of reclaimable pages among the zones.

> > At last, I'd express my major concern about the transition to preallocate
> > based memory shrinking: will it lead to more random swapping IOs?
> 
> Hmm.  I don't see immediately why would it.  Maybe the regression I'm seeing
> is related to that ...

OK. Anyway a preallocate based shrinking policy could be far from optimal. 
I'd suggest to switch to user space directed shrinking via fadvise(DONTNEED),
and leave the kernel one a fail safe path.  The user space tool could
gather page information from the filecache interface which I've been
maintaining out of tree, and to drop inactive/active pages from large
files first. That should be a better policy at least for rotational disks.

Thanks,
Fengguang

