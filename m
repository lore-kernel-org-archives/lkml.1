Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZEIHfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZEIHfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZEIHfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:35:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:13299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZEIHfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:35:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,320,1239001200"; 
   d="scan'208";a="140976780"
Date: Sat, 9 May 2009 15:34:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "alan-jenkins@tuffmail.co.uk" <alan-jenkins@tuffmail.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-ID: <20090509073417.GB6487@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090508095010.GA26398@localhost> <200905081551.56577.rjw@sisk.pl> <200905090208.44381.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905090208.44381.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 08:08:43AM +0800, Rafael J. Wysocki wrote:
> On Friday 08 May 2009, Rafael J. Wysocki wrote:
> > On Friday 08 May 2009, Wu Fengguang wrote:
> [--snip--]
> > > But hey, that 'count' counts "savable+free" memory.
> > > We don't have a counter for an estimation of "free+freeable" memory,
> > > ie. we are sure we cannot preallocate above that threshold. 
> > > 
> > > One applicable situation is, when there are 800M anonymous memory,
> > > but only 500M image_size and no swap space.
> > > 
> > > In that case we will otherwise goto the oom code path. Sure oom is
> > > (and shall be) reliably disabled in hibernation, but still we shall be
> > > cautious enough not to create a low memory situation, which will hurt:
> > > - hibernation speed
> > >   (vmscan goes mad trying to squeeze the last free page)
> > > - user experiences after resume
> > >   (all *active* file data and metadata have to reloaded)
> > 
> > Strangely enough, my recent testing with this patch doesn't confirm the
> > theory. :-)  Namely, I set image_size too low on purpose and it only caused
> > preallocate_image_memory() to return NULL at one point and that was it.
> > 
> > It didn't even took too much time.
> > 
> > I'll carry out more testing to verify this observation.
> 
> I can confirm that even if image_size is below the minimum we can get,

Which minimum please?

> the second preallocate_image_memory() just returns after allocating fewer pages
> that it's been asked for (that's with the original __GFP_NO_OOM_KILL-based
> approach, as I wrote in the previous message in this thread) and nothing bad
> happens.
>
> That may be because we freeze the mm kernel threads, but I've also tested
> without freezing them and it's still worked the same way.
> 
> > > The current code simply tries *too hard* to meet image_size.
> > > I'd rather take that as a mild advice, and to only free
> > > "free+freeable-margin" pages when image_size is not approachable.
> > > 
> > > The safety margin can be totalreserve_pages, plus enough pages for
> > > retaining the "hard core working set".
> > 
> > How to compute the size of the "hard core working set", then?
> 
> Well, I'm still interested in the answer here. ;-)

A tough question ;-)

We can start with the following formula, this should be called *after*
the initial memory shrinking.

/* a typical desktop do not have more than 100MB mapped pages */
#define MAX_MMAP_PAGES  (100 << (20 - PAGE_SHIFT))
unsigned long hard_core_working_set(void)
{
        unsigned long nr;

        /*
         * mapped pages are normally small and precious,
         * but shall be bounded for safety.
         */
        nr = global_page_state(NR_FILE_MAPPED);
        nr = min_t(unsigned long, nr, MAX_MMAP_PAGES);

        /*
         * if no swap space, this is a hard request;
         * otherwise this is an optimization.
         * (the disk image IO can be much faster than swap IO)
         */
        nr += global_page_state(NR_ACTIVE_ANON);
        nr += global_page_state(NR_INACTIVE_ANON);

        /* hard (but normally small) memory requests */
        nr += global_page_state(NR_SLAB_UNRECLAIMABLE);
        nr += global_page_state(NR_UNEVICTABLE);
        nr += global_page_state(NR_PAGETABLE);

        return nr;
}

