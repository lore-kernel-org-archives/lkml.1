Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZEJMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZEJMyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 08:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZEJMyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 08:54:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZEJMx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 08:53:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Sun, 10 May 2009 14:52:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
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
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905092122.58640.rjw@sisk.pl> <20090510045216.GA5794@localhost>
In-Reply-To: <20090510045216.GA5794@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101452.57707.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 May 2009, Wu Fengguang wrote:
> On Sun, May 10, 2009 at 03:22:57AM +0800, Rafael J. Wysocki wrote:
> > On Saturday 09 May 2009, Wu Fengguang wrote:
> > > On Sat, May 09, 2009 at 08:08:43AM +0800, Rafael J. Wysocki wrote:
> > > > On Friday 08 May 2009, Rafael J. Wysocki wrote:
> > > > > On Friday 08 May 2009, Wu Fengguang wrote:
> > > > [--snip--]
> > > > > > But hey, that 'count' counts "savable+free" memory.
> > > > > > We don't have a counter for an estimation of "free+freeable" memory,
> > > > > > ie. we are sure we cannot preallocate above that threshold. 
> > > > > > 
> > > > > > One applicable situation is, when there are 800M anonymous memory,
> > > > > > but only 500M image_size and no swap space.
> > > > > > 
> > > > > > In that case we will otherwise goto the oom code path. Sure oom is
> > > > > > (and shall be) reliably disabled in hibernation, but still we shall be
> > > > > > cautious enough not to create a low memory situation, which will hurt:
> > > > > > - hibernation speed
> > > > > >   (vmscan goes mad trying to squeeze the last free page)
> > > > > > - user experiences after resume
> > > > > >   (all *active* file data and metadata have to reloaded)
> > > > > 
> > > > > Strangely enough, my recent testing with this patch doesn't confirm the
> > > > > theory. :-)  Namely, I set image_size too low on purpose and it only caused
> > > > > preallocate_image_memory() to return NULL at one point and that was it.
> > > > > 
> > > > > It didn't even took too much time.
> > > > > 
> > > > > I'll carry out more testing to verify this observation.
> > > > 
> > > > I can confirm that even if image_size is below the minimum we can get,
> > > 
> > > Which minimum please?
> > 
> > That was supposed to be an alternative way of saying "below any reasonable
> > value", but it wasn't very precise indeed.
> > 
> > I should have said that for given system there was a minimum number of saveable
> > pages that hibernate_preallocate_memory() leaved in memory and it just couldn't
> > go below that limit.  If image_size is set below this number, the
> > preallocate_image_memory(max_size - size) call returns fewer pages that it's
> > been requested to allocate and that's it.  No disasters, no anything wrong.
> 
> "preallocate_image_memory(max_size - size) returning fewer pages"
> would better be avoided, and possibly can be avoided by checking
> hard_core_working_set(), right?

Yes, but your formula doesn't seem to be suitable for that, because the number
it returns it too low.

On an x86_64 test box the minimum image size I can get (by setting
image_size=1000) is about 24000 pages, while the formula for the hard core
working set size returns about 12000, so it is not very useful.

On an i386 test box it's even worse, as the minimum image size I can get is
about 48000 pages.

Besides, while testing this I noticed that on i386 preallocate_image_memory()
didn't allocate from highmem, so I changed it to do so.  As a result of this I
had to change the patches, so I'm going to post the new patchset shortly.

> > > > the second preallocate_image_memory() just returns after allocating fewer pages
> > > > that it's been asked for (that's with the original __GFP_NO_OOM_KILL-based
> > > > approach, as I wrote in the previous message in this thread) and nothing bad
> > > > happens.
> > > >
> > > > That may be because we freeze the mm kernel threads, but I've also tested
> > > > without freezing them and it's still worked the same way.
> > > > 
> > > > > > The current code simply tries *too hard* to meet image_size.
> > > > > > I'd rather take that as a mild advice, and to only free
> > > > > > "free+freeable-margin" pages when image_size is not approachable.
> > > > > > 
> > > > > > The safety margin can be totalreserve_pages, plus enough pages for
> > > > > > retaining the "hard core working set".
> > > > > 
> > > > > How to compute the size of the "hard core working set", then?
> > > > 
> > > > Well, I'm still interested in the answer here. ;-)
> > > 
> > > A tough question ;-)
> > > 
> > > We can start with the following formula, this should be called *after*
> > > the initial memory shrinking.
> > 
> > OK
> > 
> > > /* a typical desktop do not have more than 100MB mapped pages */
> > > #define MAX_MMAP_PAGES  (100 << (20 - PAGE_SHIFT))
> > > unsigned long hard_core_working_set(void)
> > > {
> > >         unsigned long nr;
> > > 
> > >         /*
> > >          * mapped pages are normally small and precious,
> > >          * but shall be bounded for safety.
> > >          */
> > >         nr = global_page_state(NR_FILE_MAPPED);
> > >         nr = min_t(unsigned long, nr, MAX_MMAP_PAGES);
> > > 
> > >         /*
> > >          * if no swap space, this is a hard request;
> > >          * otherwise this is an optimization.
> > >          * (the disk image IO can be much faster than swap IO)
> > 
> > Well, if there's no swap space at this point, we won't be able to save the
> > image anyway, so this always is an optimization IMO. :-)
> 
> Ah OK. Do you think the anonymous pages optimization should be limited?

That depends.

> My desktop normally consumes 200-400MB anonymous pages, but when some
> virtual machine is running, the anonymous pages can go beyond 1GB,

That's too much IMO, so there should be a limit.

> with mapped file pages go slightly beyond 100MB.
> 
> The image-write vs. swapout-write speeds should be equal,

They aren't, really.  Image write is way faster, even without compression.

> however the hibernate tool may be able to compress the dataset.

Sure.

> The image-read will be much faster than swapin-read for *rotational*
> disks. It may take more time to resume, however the user experiences
> after completion will be much better.

Agreed.

> I don't think "populating memory with useless data" would be a major
> concern, since we already freed up half of the total memory. It's all
> about the speed one can get back to work.

Agreed again.

> > 
> > >          */
> > >         nr += global_page_state(NR_ACTIVE_ANON);
> > >         nr += global_page_state(NR_INACTIVE_ANON);
> > > 
> > >         /* hard (but normally small) memory requests */
> > >         nr += global_page_state(NR_SLAB_UNRECLAIMABLE);
> > >         nr += global_page_state(NR_UNEVICTABLE);
> > >         nr += global_page_state(NR_PAGETABLE);
> > > 
> > >         return nr;
> > > }
> > 
> > OK, thanks.
> > 
> > I'll create a separate patch adding this function and we'll see how it works.
> 
> OK, thanks!

Actually it doesn't work too well as I said above.  Arguably that's because the
number of anonymous pages was probably lower than average in my test cases,
but I also think that our hard core working set formula should be suitable for
all test cases.

> btw, if the shrink_all_memory() functions cannot go away because of
> performance problems, I can help clean it up.  (FYI: I happen to be
> doing so just before you submitted this patchset.:)

That would be great, thanks a lot!

I'm going to post updated patchset in a while, let's move the discussion to
the new thread.

Best,
Rafael
