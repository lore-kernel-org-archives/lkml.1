Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbZBEKKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbZBEKKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZBEKK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:10:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46343 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZBEKK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:10:26 -0500
Date: Thu, 5 Feb 2009 10:10:23 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: David Miller <davem@davemloft.net>
Cc: kamezawa.hiroyu@jp.fujitsu.com, heiko.carstens@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
Message-ID: <20090205101023.GD26878@csn.ul.ie>
References: <20090204.222651.26527737.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090204.222651.26527737.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 10:26:51PM -0800, David Miller wrote:
> 
> So I've been fighting mysterious crashes on my main sparc64 devel
> machine.  What's happening is that the assertion in
> mm/page_alloc.c:move_freepages() is triggering:
> 
> 	BUG_ON(page_zone(start_page) != page_zone(end_page));
> 
> Once I knew this is what was happening, I added some annotations:
> 
> 	if (unlikely(page_zone(start_page) != page_zone(end_page))) {
> 		printk(KERN_ERR "move_freepages: Bogus zones: "
> 		       "start_page[%p] end_page[%p] zone[%p]\n",
> 		       start_page, end_page, zone);
> 		printk(KERN_ERR "move_freepages: "
> 		       "start_zone[%p] end_zone[%p]\n",
> 		       page_zone(start_page), page_zone(end_page));
> 		printk(KERN_ERR "move_freepages: "
> 		       "start_pfn[0x%lx] end_pfn[0x%lx]\n",
> 		       page_to_pfn(start_page), page_to_pfn(end_page));
> 		printk(KERN_ERR "move_freepages: "
> 		       "start_nid[%d] end_nid[%d]\n",
> 		       page_to_nid(start_page), page_to_nid(end_page));
>  ...
> 
> And here's what I got:
> 
> 	move_freepages: Bogus zones: start_page[2207d0000] end_page[2207dffc0] zone[fffff8103effcb00]
> 	move_freepages: start_zone[fffff8103effcb00] end_zone[fffff8003fffeb00]
> 	move_freepages: start_pfn[0x81f600] end_pfn[0x81f7ff]
> 	move_freepages: start_nid[1] end_nid[0]
> 
> My memory layout on this box is:
> 
> [    0.000000] Zone PFN ranges:
> [    0.000000]   Normal   0x00000000 -> 0x0081ff5d
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[8] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x00020000
> [    0.000000]     1: 0x00800000 -> 0x0081f7ff
> [    0.000000]     1: 0x0081f800 -> 0x0081fe50
> [    0.000000]     1: 0x0081fed1 -> 0x0081fed8
> [    0.000000]     1: 0x0081feda -> 0x0081fedb
> [    0.000000]     1: 0x0081fedd -> 0x0081fee5
> [    0.000000]     1: 0x0081fee7 -> 0x0081ff51
> [    0.000000]     1: 0x0081ff59 -> 0x0081ff5d

Based on your memory layout, it would appear that end_pfn was not
initialised at startup. What is the full dmesg output when
CONFIG_MEMORY_INIT is set and mminit_loglevel=4? It'll tell me what
ranges of memory were actually initialised.

> 
> So it's a block move in that 0x81f600-->0x81f7ff region which triggers
> the problem.
> 
> So I did a lot (and I do mean _A LOT_) of digging.  And it seems that
> unless you set HOLES_IN_ZONE you have to make sure that all of the
> memmap regions of free space in a zone begin and end on an HPAGE_SIZE
> boundary (the requirement used to be that it had to be MAX_ORDER
> sized).
> 

hmm, it still should be a MAX_ORDER boundary. HPAGE_SIZE defines
pageblock_order and it should be smaller than MAX_ORDER. Has this
changed?

> Well, this assumption enterred the tree back in 2005 (!!!) from
> the following commit in the history-2.6 tree:
> 
> commit 69fba2dd0335abec0b0de9ac53d5bbb67c31fc60
> Author: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date:   Fri Jan 7 22:01:35 2005 -0800
> 
>     [PATCH] no buddy bitmap patch revisit: for mm/page_alloc.c
> 
> At the time only IA64 had HOLES_IN_ZONE added, this happens in the
> commit right after the above one.
> 
> So in theory Sparc64 has been broken since that commit and subject to
> potential memory corruption and other unnice things.
> 

Potentially, but unlikely. The number of areas that read a block of
pages are fairly small and relatively recent. move_freepages() is one
obviously and it had that BUG_ON() in place just in case this assumption
triggered. Conceivably, you might also be able to trigger badness with 
"cat /proc/pagetypeinfo".

The real badness happens when pages belonging to different zones or node are
considered to be buddies of each other and merged but that situation would
not have triggered on your machine at least.

> I also noticed that when S390 got virtual memmap support, it acquired
> the HOLES_IN_ZONE setting as well, in this commit:
> 
> commit f4eb07c17df2e6cf9bd58bfcd9cc9e05e9489d07
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Fri Dec 8 15:56:07 2006 +0100
> 
>     [S390] Virtual memmap for s390.
> 
> This is confusing.  Is HOLES_IN_ZONE only required when virtual mmap
> is being used?  If so, why is that?  This is a very poorly documented
> flag, and I'm saying this after pouring over every commit referencing
> it.
> 

!HOLES_IN_ZONE
	If any one PFN within a MAX_ORDER_NR_PAGES is valid, then you
	can assume all PFNs in there are valid.

HOLES_IN_ZONE
	Due to memory holes or unaligned zones, all PFNs within a
	MAX_ORDER_NR_PAGE may not be valid.

What this affects in practice is what pfn_valid_within() does. If you are
walking all the PFNs within a MAX_ORDER block, you need to call pfn_valid()
once per MAX_ORDER and pfn_valid_within() for each PFN. When
!HOLES_IN_ZONE, this becomes a no-op.

> Later this HOLES_IN_ZONE requirement was removed on s390 by commit:
> 
> commit 9f4b0ba81f158df459fa2cfc98ab1475c090f29c
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Sat Jan 26 14:11:02 2008 +0100
> 
>     [S390] Get rid of HOLES_IN_ZONE requirement.
> 
> Anyways...
> 
> The point of this email is, do I really need to set this thing on
> sparc64? I've never seen this check triggered before, it only seems
> to have started triggering in 2.6.27 or so but I obviously can't find
> anything that would influence something of this nature.
> 

Possibly not. If we ensure there is valid memmap for each PFN within a
MAX_ORDER block, then they would get marked reserved and never merged.
Other walkers should just ignore them in that case and you don't need
HOLES_IN_ZONE.

> It takes a lot of stressing to get that specific chunk of pages to
> attempt to be freed up in a group like that :-/
> 

It'd be down to luck.

> As a suggestion, it would have been a lot more pleasant if the code
> validated this requirement (in the !HOLES_IN_ZONE case) at boot time
> instead of after 2 hours of stress testing :-(
> 

Nice maybe, but we'd take a hit on pfn_valid_within() which goes from
being compiled-away on architectures that don't need it to being
a read of a shared cacheline and a branch.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
