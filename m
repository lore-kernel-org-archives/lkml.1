Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbXGTM4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbXGTM4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXGTM4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:56:32 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:38723 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbXGTM4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:56:31 -0400
Date: Fri, 20 Jul 2007 13:56:29 +0100
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix memory hotplug oops from ZONE_MOVABLE changes.
Message-ID: <20070720125629.GB14495@skynet.ie>
References: <20070720060342.GA24765@linux-sh.org> <20070720112025.GA14495@skynet.ie> <20070720114246.GA27391@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070720114246.GA27391@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/07/07 20:42), Paul Mundt didst pronounce:
> On Fri, Jul 20, 2007 at 12:20:25PM +0100, Mel Gorman wrote:
> > On (20/07/07 15:03), Paul Mundt didst pronounce:
> > > zone_movable_pfn is presently marked as __initdata and referenced
> > > from adjust_zone_range_for_zone_movable(), which in turn is
> > > referenced by zone_spanned_pages_in_node(). Both of these are
> > > __meminit annotated. When memory hotplug is enabled, this will oops
> > > on a hot-add, due to zone_movable_pfn having been freed.
> > > 
> > 
> > First, can you confirm this is node hot-add please? I'm haven't looked at
> > the memory hot-add code in a while so I would like to be sure this problem
> > path only exists on node hot-add. If it is node hot-add, then everything
> > should be ok. The memory should get added to the same zone as it did in
> > older kernels.
> > 
> > Even if this is node hot-add, can you confirm that "ordinary" memory hot-add
> > is working as expected when ZONE_MOVABLE exists please? To test, add a boot
> > parameter kernelcore=N where N == 80% of memory and hot-add some memory to
> > an existing node.
> > 
> Normal memory hot-add does work as advertised. The problem in this case
> is really a corner case, as I pointed out to Kamezawa-san. The only way
> to enter the problematic code path (namely zone_spanned_pages_in_node())
> is via free_area_init_node(), which in this case is only triggered by
> hotadd_new_pgdat() if there's no existing pgdat.
> 

Right, all sounds fair and right. In that case for your patch

Acked-by: Mel Gorman <mel@csn.ul.ie>

Point is moot as Andrew already picked it up but what harm :)

> Kamezawa-san wasn't able to reproduce this particular problem due to the
> pgdat being preallocated, and I imagine that this is the common case for
> most users.

Probably. I suspect that Kamezawa-san's usecases for node-hotadd are the
only cases currently out there.

> I have a slightly different use case where we might tear down
> the node entirely, either to hand it off to another application, kernel,
> or explicit power gating. In which case we have to start over via the new
> pgdat path.
> 

Fun stuff!

> > I expect that the memory gets added to the same zone as historically but
> > when ZONE_MOVABLE is set, you'll see a situation where zones are overlapping
> > after memory hot-add.  i.e. Before memory hot-add, you'd see
> > 
> > DDDDMM
> > 
> > for ZONE_DMA and ZONE_MOVABLE and after hotadd, you'd see something like
> > 
> > DDDDMMDDDD
> > 
> > so /proc/zoneinfo will look unusual.  I'd like to be sure the memory exists
> > where you expect it to exist and that there are no problems after hot-add. To
> > test, a simple memory hot-add followed by a dd of a file the size of all
> > physical memory followed by a delete should do the trick. Also make sure
> > files like /proc/zoneinfo and /proc/meminfo are ok and particularly that
> > sysrq+m produces sensible output.
> > 
> It'll be Monday before I'm by a system I can test this out on, so perhaps
> someone else will beat me to it. If not, I'll give it some more testing
> and follow up then.
> 

Thanks.

> > If other memory-hotadd users are watching, I'd appreciate a test and a report
> > with a recent -git kernel to confirm you're ok. Is there a way currently
> > of simulating memory-hotadd so I can try this out? Ages ago, one could boot
> > with mem= and "add" the remaining memory at run-time.
> > 
> That's probably something worth resurrecting if it's broken in current
> kernels. It should be pretty trivial to hook something like that up via
> sparsemem anyways.

I'll take a look around and see can I come up with a basic testcase that
uses "normal" hardware to test the hot-add paths if no one else comes up
with a generally approved approach.

Thanks Paul.
-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
