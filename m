Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759199AbYLQHKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbYLQHKK (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYLQHJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:09:56 -0500
Received: from mx1.suse.de ([195.135.220.2]:54053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYLQHJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:09:55 -0500
Date: Wed, 17 Dec 2008 08:09:54 +0100
From: Nick Piggin <npiggin@suse.de>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc][patch] SLQB slab allocator
Message-ID: <20081217070954.GB26179@wotan.suse.de>
References: <20081212002518.GH8294@wotan.suse.de> <28c262360812151542g2ac032fay6c5b03d846d05a77@mail.gmail.com> <20081217064238.GA26179@wotan.suse.de> <28c262360812162301i58c9fe9l4a1ee89ca0a6a56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28c262360812162301i58c9fe9l4a1ee89ca0a6a56@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 04:01:06PM +0900, MinChan Kim wrote:
> On Wed, Dec 17, 2008 at 3:42 PM, Nick Piggin <npiggin@suse.de> wrote:
> >> Below is average for ten time test.
> >>
> >> slab :
> >> user : 2376.484, system : 192.616 elapsed : 12:22.0
> >> slub :
> >> user : 2378.439, system : 194.989 elapsed : 12:22.4
> >> slqb :
> >> user : 2380.556, system : 194.801 elapsed : 12:23.0
> >>
> >> so, slqb is rather slow although it is a big difference.
> >> Interestingly, slqb consumes less time than slub in system.
> >
> > Thanks, interesting test. kbuild is not very slab allocator intensive,
> 
> Let me know what is popular benchmark program in slab allocator.
> I will try with it. :)

That's not to say it is a bad benchmark :) If it shows up a difference
and is a useful workload like kbuild, then it is a good benchmark.

Allocator changes tend to show up more when there is a lot of network
or disk IO happening. But it is good to see other tets too, so any
numbers you get are welcome.

 
> > so I hadn't thought of trying it. Possibly the object cacheline layout
> > of longer lived allocations changes the behaviour (increased user time
> > could indicate that).
> 
> What mean "object cacheline layout of loger lived allocations" ?

For example, different allocation schemes will alter the chances of
getting different ways (colours), or false sharing. SLUB and SLQB
for example allow as fine as 8 byte allocation granularity wheras
SLAB goes down to 32 bytes, so small objects *could* be more prone
to false sharing. I don't know for sure at this stage, just guessing ;)

The difference doesn't show up significantly on my system, so profiling
doesn't reveal anything (I guess even on your system it would be
difficult to profile because it is not a huge difference).

 
> > I've been making a few changes to that, and hopefully slqb is slightly
> > improved now (the margin is much closer, seems within the noise with
> > SLUB on my NUMA opteron now, although that's a very different system).
> >
> > The biggest bug I fixed was that the NUMA path wasn't being taken in
> > kmem_cache_free on NUMA systems (oops), but that wouldn't change your
> > result. But I did make some other changes too, eg in prefetching.
> 
> OK. I will review and test your new patch in my machine.

Thanks! Code style and comments should be improved quite a bit now.

