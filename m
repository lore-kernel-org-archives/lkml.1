Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbXLRN6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbXLRN6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXLRN6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:58:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55949 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbXLRN6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:58:32 -0500
Date: Tue, 18 Dec 2007 13:58:28 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org, Bob Picco <bob.picco@hp.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Andi Kleen <ak@muc.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Keith Mannthey <kmannth@gmail.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@osdl.org>, ralf@linux-mips.org
Subject: Re: [PATCH] Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
Message-ID: <20071218135828.GB24917@csn.ul.ie>
References: <20071218120300.7565AE3030@solo.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071218120300.7565AE3030@solo.franken.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/12/07 13:03), Thomas Bogendoerfer didst pronounce:
> When using FLAT_MEMORY and ARCH_PFN_OFFSET is not 0, the kernel
> crashes in memmap_init_zone(). This bug got introduced by
> commit c713216deebd95d2b0ab38fef8bb2361c0180c2d
> 

That commit is over a year old and it initially distressed me that it
would take this long to show up on a boot test. However, you said this was
to fix MIPS in a follow-on mail and I never made it use arch-independent
zone-sizing which is where CONFIG_ARCH_POPULATES_NODE_MAP comes from. Support
for arch-independent zone-sizing was added for MIPS on Nov 3rd 2007 by commit
cce335ae47e231398269fb05fa48e0e9cbf289e0 (relevant cc added) which is a much
more reasonable timeframe for catching this sort of problem. I believe the
real bug might be in there.

Can you post a full dmesg log with loglevel=8 so I can see what the layout
looks like? My aim is to find out why the start of your mem_map is not at
the start of node 0's mem_map which is what I generally expected with the
FLATMEM model.

Thanks.

> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
> 
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b5a58d4..496f7f3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3427,7 +3427,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
>  		mem_map = NODE_DATA(0)->node_mem_map;
>  #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
>  		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
> -			mem_map -= pgdat->node_start_pfn;
> +			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
>  #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
>  	}
>  #endif
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
