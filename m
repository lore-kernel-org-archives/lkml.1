Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbZFHKRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbZFHKRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZFHKRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:17:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51675 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbZFHKRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:17:41 -0400
Date: Mon, 8 Jun 2009 11:17:40 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
Message-ID: <20090608101739.GA15377@csn.ul.ie>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 05:32:52PM +0300, Pekka Enberg wrote:
> On Sun, Jun 7, 2009 at 5:19 PM, Rik van Riel <riel@redhat.com> wrote:
> > Pekka Enberg wrote:
> >>
> >> Hi Larry,
> >>
> >> On Sun, Jun 7, 2009 at 4:10 PM, Larry Finger <Larry.Finger@lwfinger.net>
> >> wrote:
> >>>
> >>> Rafael J. Wysocki wrote:
> >>>>
> >>>> This message has been generated automatically as a part of a report
> >>>> of recent regressions.
> >>>>
> >>>> The following bug entry is on the current list of known regressions
> >>>> from 2.6.29.  Please verify if it still should be listed and let me know
> >>>> (either way).
> >>>>
> >>>>
> >>>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13319
> >>>> Subject               : Page allocation failures with b43 and p54usb
> >>>> Submitter     : Larry Finger <Larry.Finger@lwfinger.net>
> >>>> Date          : 2009-04-29 21:01 (40 days old)
> >>>> References    : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> >>>> Handled-By    : Johannes Berg <johannes@sipsolutions.net>
> >>>
> >>> This bug is extremely difficult to pin down. I cannot reproduce it at
> >>> will. The system has to be up for a long time, which is difficult with
> >>> testing the late RC's of 2.6.30 and the code in wireless-testing so
> >>> that new bugs don't end up in 2.6.31-RCX. That said, it still was in
> >>> 2.6.30-RC6 and I'm not aware of any changes since that would fix it.
> >>>
> >>> My operating kernel is patched with additional diagnostics to help me
> >>> understand why a kmalloc request for a buffer of 1390 bytes suddenly
> >>> ends up as an O(1) request. Unfortunately, I don't have any answers.
> >>
> >> Looking at the out-of-memory trace, there's still memory available but
> >> the pskb_expand_head() allocation is GFP_ATOMIC so there's not much
> >> the page allocator can do here. The amount of memory consumed by
> >> inactive_file is pretty high so maybe the problem is related to the
> >> recent mm/vmscan.c changes. Lets copy some more mm developers and see
> >> if they can help out.
> >
> > That is a very strange trace.  The Mem-Info indicates
> > that the system has more than enough memory free, and
> > also enough memory in higher-order free blocks.
> >
> > This would indicate a bug somewhere in the page
> > allocator - this memory should have been given to this
> > allocation request.
> 
> Aha, I always have difficulties deciphering the traces. But lets
> invite Mel to the party then!
> 

Nothing like a party on Monday morning to get the week started!

What we appear to have is

o Allocation failure is high-order, high-priority, compound and atomic.
o swap is mostly unused, but we cannot enter direct reclaim.
o ZONE_DMA32 can be used
o The allocation path is in the slub allocator
o Are way above the order-0 watermarks so kswapd is probably not awake
o The minimum watermark for an order-0 page was about 647 pages in ZONE_DMA32
o The minimum watermark for an order-1 page was about 323 pages in ZONE_DMA32
o There are 10244 pages free at the time of the failure
o With the order-0 pages taken out for watermark calculation, there are
  182 free pages which is below the watermark of 323 pages for an
  order-1 allocation

While there is enough free memory overall, the zone watermark calculation
takes into account the order of the request. As this is an order-1 allocation,
the free order-0 pages are taken out of consideration and so the allocation
fails.

We've encountered this before and the conclusion was that the current
adjustments for watermark calculations of high-order allocations is right,
or at least there is no better alternative. In other words, the page
allocator in this instance is behaving as expected. Do we want to
revisit that discussion as to whether the watermark calculations for
high-order allocation should change? I think we'll reach the same
conclusion or at least decide that allowing the order-1 atomic
allocation to succeed here would just postpone the problem.

So the question is why are we doing a high-order atomic allocation in
this path? According to an earlier discussion on this problemn

> I think something happened to change the allocation as I never saw these
> O(1) failures before with these particular drivers. I put in a few test
> printk's and the buffers were 700-800 bytes long, and I would not expect
> them to require more than an O(0) allocation.

So, SLUB is deciding to use order-1 pages for the slab allocation.
Ordinarily, it'll get away with that because order-1 pages will be
allocated from a path that can direct reclaim. However, if a slab is
being used for atomic allocations, there is a chance that it's the
atomic request that allocates a new page for the slab.

Larry, can you post the contents of /proc/slabinfo so we can see
what size pages are being used for the kmalloc() buckets please?

Larry, you say the buffer is 700-800 bytes. Can you confirm that 800 bytes
is roughly the request size being made by ieee80211_skb_resize()?

Pekka, assuming the request size is 800 bytes, and SLUB is using order-1
pages for allocations of that size, what happened order-1 allocations
falling back to order-0 allocations as necessary. That logic exists,
right? If so, could it be broken?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
