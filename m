Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbXGTLUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbXGTLUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbXGTLU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:20:29 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:57676 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbXGTLU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:20:28 -0400
Date: Fri, 20 Jul 2007 12:20:25 +0100
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix memory hotplug oops from ZONE_MOVABLE changes.
Message-ID: <20070720112025.GA14495@skynet.ie>
References: <20070720060342.GA24765@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070720060342.GA24765@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/07/07 15:03), Paul Mundt didst pronounce:
> zone_movable_pfn is presently marked as __initdata and referenced
> from adjust_zone_range_for_zone_movable(), which in turn is
> referenced by zone_spanned_pages_in_node(). Both of these are
> __meminit annotated. When memory hotplug is enabled, this will oops
> on a hot-add, due to zone_movable_pfn having been freed.
> 

Ouch. Thanks for catching, your patch looks good. Before I add the ack though,
I would like to get more details of the error in case there are other gremlins
I haven't thought of and the fix for memory-hotadd is more complex.

First, can you confirm this is node hot-add please? I'm haven't looked at
the memory hot-add code in a while so I would like to be sure this problem
path only exists on node hot-add. If it is node hot-add, then everything
should be ok. The memory should get added to the same zone as it did in
older kernels.

Even if this is node hot-add, can you confirm that "ordinary" memory hot-add
is working as expected when ZONE_MOVABLE exists please? To test, add a boot
parameter kernelcore=N where N == 80% of memory and hot-add some memory to
an existing node.

I expect that the memory gets added to the same zone as historically but
when ZONE_MOVABLE is set, you'll see a situation where zones are overlapping
after memory hot-add.  i.e. Before memory hot-add, you'd see

DDDDMM

for ZONE_DMA and ZONE_MOVABLE and after hotadd, you'd see something like

DDDDMMDDDD

so /proc/zoneinfo will look unusual.  I'd like to be sure the memory exists
where you expect it to exist and that there are no problems after hot-add. To
test, a simple memory hot-add followed by a dd of a file the size of all
physical memory followed by a delete should do the trick. Also make sure
files like /proc/zoneinfo and /proc/meminfo are ok and particularly that
sysrq+m produces sensible output.

The only in-kernel user that should notice is one that is trying to walk the
whole of memmap and is using page_zone() changing to detect boundaries. The
existing users I am aware of only walk within a MAX_ORDER_NR_PAGES boundary
usually and a memory section boundary at most. Those users will be ok even
if zones overlap.

Thanks a lot.

If other memory-hotadd users are watching, I'd appreciate a test and a report
with a recent -git kernel to confirm you're ok. Is there a way currently
of simulating memory-hotadd so I can try this out? Ages ago, one could boot
with mem= and "add" the remaining memory at run-time.

> __meminitdata annotation gives the desired behaviour.
> 
> This will only impact platforms that enable both memory hotplug
> and ARCH_POPULATES_NODE_MAP.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> --
> 
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 43cb3b3..40954fb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -138,7 +138,7 @@ static unsigned long __meminitdata dma_reserve;
>  #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
>    unsigned long __initdata required_kernelcore;
>    unsigned long __initdata required_movablecore;
> -  unsigned long __initdata zone_movable_pfn[MAX_NUMNODES];
> +  unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
>  
>    /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
>    int movable_zone;

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
