Return-Path: <linux-kernel-owner+w=401wt.eu-S1761662AbXGTLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662AbXGTLnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXGTLnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:43:08 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:55336 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXGTLnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:43:07 -0400
Date: Fri, 20 Jul 2007 20:42:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mel Gorman <mel@skynet.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix memory hotplug oops from ZONE_MOVABLE changes.
Message-ID: <20070720114246.GA27391@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mel Gorman <mel@skynet.ie>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070720060342.GA24765@linux-sh.org> <20070720112025.GA14495@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720112025.GA14495@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 12:20:25PM +0100, Mel Gorman wrote:
> On (20/07/07 15:03), Paul Mundt didst pronounce:
> > zone_movable_pfn is presently marked as __initdata and referenced
> > from adjust_zone_range_for_zone_movable(), which in turn is
> > referenced by zone_spanned_pages_in_node(). Both of these are
> > __meminit annotated. When memory hotplug is enabled, this will oops
> > on a hot-add, due to zone_movable_pfn having been freed.
> > 
> 
> First, can you confirm this is node hot-add please? I'm haven't looked at
> the memory hot-add code in a while so I would like to be sure this problem
> path only exists on node hot-add. If it is node hot-add, then everything
> should be ok. The memory should get added to the same zone as it did in
> older kernels.
> 
> Even if this is node hot-add, can you confirm that "ordinary" memory hot-add
> is working as expected when ZONE_MOVABLE exists please? To test, add a boot
> parameter kernelcore=N where N == 80% of memory and hot-add some memory to
> an existing node.
> 
Normal memory hot-add does work as advertised. The problem in this case
is really a corner case, as I pointed out to Kamezawa-san. The only way
to enter the problematic code path (namely zone_spanned_pages_in_node())
is via free_area_init_node(), which in this case is only triggered by
hotadd_new_pgdat() if there's no existing pgdat.

Kamezawa-san wasn't able to reproduce this particular problem due to the
pgdat being preallocated, and I imagine that this is the common case for
most users. I have a slightly different use case where we might tear down
the node entirely, either to hand it off to another application, kernel,
or explicit power gating. In which case we have to start over via the new
pgdat path.

> I expect that the memory gets added to the same zone as historically but
> when ZONE_MOVABLE is set, you'll see a situation where zones are overlapping
> after memory hot-add.  i.e. Before memory hot-add, you'd see
> 
> DDDDMM
> 
> for ZONE_DMA and ZONE_MOVABLE and after hotadd, you'd see something like
> 
> DDDDMMDDDD
> 
> so /proc/zoneinfo will look unusual.  I'd like to be sure the memory exists
> where you expect it to exist and that there are no problems after hot-add. To
> test, a simple memory hot-add followed by a dd of a file the size of all
> physical memory followed by a delete should do the trick. Also make sure
> files like /proc/zoneinfo and /proc/meminfo are ok and particularly that
> sysrq+m produces sensible output.
> 
It'll be Monday before I'm by a system I can test this out on, so perhaps
someone else will beat me to it. If not, I'll give it some more testing
and follow up then.

> If other memory-hotadd users are watching, I'd appreciate a test and a report
> with a recent -git kernel to confirm you're ok. Is there a way currently
> of simulating memory-hotadd so I can try this out? Ages ago, one could boot
> with mem= and "add" the remaining memory at run-time.
> 
That's probably something worth resurrecting if it's broken in current
kernels. It should be pretty trivial to hook something like that up via
sparsemem anyways.
