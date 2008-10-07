Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYJGCAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYJGCAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 22:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYJGB7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:59:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:52587 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbYJGB7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:59:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,370,1220252400"; 
   d="scan'208";a="388340194"
Date: Mon, 6 Oct 2008 18:58:35 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/7] x86, cpa: make the kernel physical mapping initialization a two pass sequence
Message-ID: <20081007015833.GO15609@linux-os.sc.intel.com>
References: <20080923210035.413932000@linux-os.sc.intel.com> <20080923211444.369122000@linux-os.sc.intel.com> <48EA798D.1090303@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EA798D.1090303@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 01:48:13PM -0700, Jeremy Fitzhardinge wrote:
> Suresh Siddha wrote:
> > In the first pass, kernel physical mapping will be setup using large or
> > small pages but uses the same PTE attributes as that of the early
> > PTE attributes setup by early boot code in head_[32|64].S
> >
> > After flushing TLB's, we go through the second pass, which setups the
> > direct mapped PTE's with the appropriate attributes (like NX, GLOBAL etc)
> > which are runtime detectable.
> >
> > This two pass mechanism conforms to the TLB app note which says:
> >
> > "Software should not write to a paging-structure entry in a way that would
> >  change, for any linear address, both the page size and either the page frame
> >  or attributes."
> >
> 
> I'd noticed that current tip/master hasn't been booting under Xen, and I
> just got around to bisecting it down to this change.
> 
> This patch is causing Xen to fail various pagetable updates because it
> ends up remapping pagetables to RW, which Xen explicitly prohibits (as
> that would allow guests to make arbitrary changes to pagetables, rather
> than have them mediated by the hypervisor).

Jeremy, hi. This dependency is not documented or explicitly called anywhere
in the mm/init_64.c code. I would have expected to see a big comment near this
kind of code :(

	if (pte_val(*pte))
		continue;

> A few things strike me about this patch:
> 
>    1. It's high time we unified the physical memory mapping code, and it
>       would have been better to do so before making a change of this
>       kind to the code.
>    2. The existing code already avoided overwriting a pagetable entry
>       unless the page size changed. Wouldn't it be easier to construct
>       the mappings first, using the old code, then do a CPA call to set
>       the NX bit appropriately?

It is not just the NX bit that we change. For DEBUG_PAGEALLOC, we want
use 4k pages instead of large page mappings during the identity mapping
(as this will clean some of the cpa pool code avoiding the cpa and hence
 the page allocations for splitting the big pages from interrupt context's).
In this case will will split the static large page mappings.

>    3. The actual implementation is pretty ugly; adding a global variable
>       and hopping about with goto does not improve this code.

This is very early init code and I can't be fancy like calling cpa()
which need mm to be up and running. And also, cpa's on individual chunks
for entire identity mapping will make the boot slow.

Now that I am aware of this xen failure, I will try to clean up this in a better
fashion.

> What are the downsides of not following the TLB app note's advice?  Does

App notes says that cpu behavior is undefined. We will  probably see more
issues with attribute changes like UC/WB etc, as far as the other attributes
are concerned we are paranoid and wanted to fix all the violations while
we are at it.

> it cause real failures?  Could we revert this patch and address the
> problem some other way?  Which app note is this, BTW?  The one I have on
> hand, "TLBs, Paging-Structure Caches, and Their Invalidation", Apr 2007,
> does not seem to mention this restriction.

http://developer.intel.com/design/processor/applnots/317080.pdf
Section 6 page 26

> As it is, I suspect it will take a non-trivial amount of work to restore

I didn't get much time today to think about this. Let me think a bit
more tonight and will get back to you tomorrow with a patch fixing
this or a request to Ingo to revert this(if we revert we have to revert
the whole patchset otherwise, we will break DEBUG_PAGEALLOC etc).

> Xen with this code in place (touching this code is always non-trivial).
> I haven't looked into it in depth yet, but there's a few stand out "bad
> for Xen" pieces of code here.  (And I haven't tested 32-bit yet.)
> 
> Quick rules for keeping Xen happy here:
> 
>    1. Xen provides its own initial pagetable; the head_64.S one is
>       unused when booting under Xen.
>    2. Xen requires that any pagetable page must always be mapped RO, so
>       we're careful to not replace an existing mapping with a new one,
>       in case the existing mapping is a pagetable one.
>    3. Xen never uses large pages, and the hypervisor will fail any
>       attempt to do so.

Thanks for this info. Will get back to you tomorrow.

thanks,
suresh
