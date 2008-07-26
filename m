Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYGZEZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYGZEZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 00:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYGZEZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 00:25:34 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:35241 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751038AbYGZEZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 00:25:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4/O0gUxzL+FwwzTRFvzbxImsa2NRYP9sF9y63Q2pTvPxaJKCsPXQs2uZC5Qt5AP6JhnT+PEzfsGdQ/H+j3jWcEtsU7RwYjYYshppjfVU2JI6fLrGf7pzuCTnR8vbLFLo9elyCj8XN7sDWv06s67vXQXgtkHl3P9kMLGsY51ceoY=  ;
X-YMail-OSG: BR_HQEwVM1lEXYt.Zjc4cGBcUMiZd3aRTlQ1BsghBTr3rk1CZWEHqPevdv.lC8JQEGAfPe8jRbQoLAOmXtLzkCrHDySCFwWQDkiViG0_WuO.zrHzo5F28B.snEqMBdTfWZ0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: How to get a sense of VM pressure
Date: Sat, 26 Jul 2008 14:25:26 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Memory Management List <linux-mm@kvack.org>
References: <488A1398.7020004@goop.org>
In-Reply-To: <488A1398.7020004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807261425.26318.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 July 2008 03:55, Jeremy Fitzhardinge wrote:
> I'm thinking about ways to improve the Xen balloon driver.  This is the
> driver which allows the guest domain to expand or contract by either
> asking for more memory from the hypervisor, or giving unneeded memory
> back.  From the kernel's perspective, it simply looks like a driver
> which allocates and frees pages; when it allocates memory it gives the
> underlying physical page back to the hypervisor.  And conversely, when
> it gets a page from the hypervisor, it glues it under a given pfn and
> releases that page back to the kernel for reuse.
>
> At the moment it's very dumb, and is pure mechanism.  It's told how much
> memory to target, and it either allocates or frees memory until the
> target is reached.  Unfortunately, that means if it's asked to shrink to
> an unreasonably small size, it will do so without question, killing the
> domain in a thrash-storm in the process.

It's really hard to know "how much memory can I take away from the system"
because lots of the data required is only evaluated during reclaim.

Google I think and maybe IBM (can't remember) is using the proc pagemap
interfaces to help with this. Probably it is super secret code that can't
be released though -- but it gives you somewhere to look.


> There are several problems:
>
>    1. it doesn't know what a reasonable lower limit is, and
>    2. it doesn't moderate the rate of shrinkage to give the rest of the
>       VM time to adjust to having less memory (by paging out, dropping
>       inactive, etc)
>
> And possibly the third point is that the only mechanism it has for
> applying memory pressure to the system is by allocating memory.  It
> allocates with (GFP_HIGHUSER | __GFP_NOWARN | __GFP_NORETRY |
> __GFP_NOMEMALLOC), trying not to steal memory away from things that
> really need it.  But in practice, it can still easy drive the machine
> into a massive unrecoverable swap storm.

A good start would be to register a "shrinker" (look at dcache or inode
cache for examples). Start off by allocating pages, and slow down or
stop or even release some of the pages back as you start getting feedback
back through your shrinker callback.

Not perfect, but it should prevent livelocks.


> So I guess what I need is some measurement of "memory use" which is
> perhaps akin to a system-wide RSS; a measure of the number of pages
> being actively used, that if non-resident would cause a large amount of
> paging.  If you shrink the domain down to that number of pages + some
> padding (x%?), then the system will run happily in a stable state.  If
> that number increases, then the system will need new memory soon, to
> stop it from thrashing.  And if that number goes way below the domain's
> actual memory allocation, then it has "too much" memory.

Yeah that's really hard to know :P

I would start with simple heuristics.

- You can allocate up to the amount of memory free, minus watermarks
(but as always you have to keep an eye on your shrinker callback in case
the system suddenly gets a burst of pressure while you're allocating
pages).

- File backed pagecache tends to be fairly easy to reclaim (unless
something unusual like mlock). So you might be able to try taking away
say 1/Nth of the amount of pagecache -- if, after reaching a steady
state, you don't see a disproportionate surge on your shrinker, that
indicates it isn't thrashing. If you don't see *any* activity after
some time, then it shows the memory was actually not being used.

- Swap is probably best not to be pushed too hard. You could
experiment, but I hope you have enough to go by to start a
reasonable approach.


> Is this what "Active" accounts for?  Is Active just active
> usermode/pagecache pages, or does it also include kernel allocations?
> Presumably Inactive Clean memory can be freed very easily with little
> impact on the system, Inactive Dirty memory isn't needed but needs IO to
> free; is there some way to measure how big each class of memory is?

Active is just user and pagecache. Pages may be able to be easily freed,
but that doesn't mean they don't form part of the working set and have
to be paged in again...

/proc/meminfo?


> If you wanted to apply gentle memory pressure on the system to attempt
> to accelerate freeing memory, how would you go about doing that?  Would
> simply allocating memory at a controlled rate achieve it?

I'd experiment with trying to balance allocation with shrinker input.
When you actually allocate some pages, you expect to see shrinker input
as the kernel frees some memory for your request. If the shrinker input
then drops back to its pre-allocation level, then you might assume
you haven't hurt performance (of course, memory pressure may have changed
while you were allocating, so it isn't that simple, but...).

And if shrinker input never happens or stops completely, then the system
should not be entering reclaim.


> I guess it also gets more complex when you bring nodes and zones into
> the picture.  Does it mean that this computation would need to be done
> per node+zone rather than system-wide?

Yes it is very complex. IMO that's why you have to start simple. AFAIKS,
shrinker (and more or less ignoring zones and nodes too much), should be
the simplest way to get a _reasonable_ chance of something working.
After that you can try different things and see if you get better
results?

Post prototype or rfc on linux-mm if you like.
