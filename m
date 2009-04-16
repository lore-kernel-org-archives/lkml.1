Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbZDPX4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbZDPX4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbZDPX4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:56:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47743 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZDPX4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:56:08 -0400
Date: Fri, 17 Apr 2009 01:54:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090416235452.GE21405@elte.hu>
References: <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 16 Apr 2009, Yinghai Lu wrote:
> >
> > please check.
> > 
> > [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
> 
> I like the approach. That said, I think that rather than do the "modify 
> the e820 array" thing, why not just do it in the in the resource tree, and 
> do it at "e820_reserve_resources_late()" time?
> 
> IOW, something like this.
> 
> TOTALLY UNTESTED! The point is to take all RAM resources we haev, and 
> _after_ we've added all the resources we've seen in the E820 tree, we then 
> _also_ try to add fake reserved entries for any "round up to X" at the end 
> of the RAM resources.
> 
> NOTE! I really didn't want to use "reserve_region_with_split()". I didn't 
> want to recurse into any conflicting resources, I really wanted to just do 
> the other failure cases. 
> 
> THIS PATCH IS NOT MEANT TO BE USED. Just a rough "almost like this" kind 
> of thing. That includes the rough draft of how much to round things up to 
> based on where the end of RAM region is etc. I'm really throwing this out 
> more as a "wouldn't this be a readable way to handle any missing reserved 
> entries" kind of thing..
> 
> 			Linus
> 
> ---
>  arch/x86/kernel/e820.c |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index ef2c356..e8b8d33 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -1370,6 +1370,23 @@ void __init e820_reserve_resources(void)
>  	}
>  }
>  
> +/* How much should we pad RAM ending depending on where it is? */
> +static unsigned long ram_alignment(resource_size_t pos)
> +{
> +	unsigned long mb = pos >> 20;
> +
> +	/* To 64kB in the first megabyte */
> +	if (!mb)
> +		return 64*1024;

Could we perhaps round up to 1MB in this case too?

This would mean that we would never dynamically allocate into the 
640k..1MB hole - but even if it's free it's probably a good idea to 
avoid that range - it's usually quite special.

So we'd just have two ganularities for round-up: 1MB and 32MB. Nice, 
predictable scheme.

> +
> +	/* To 1MB in the first 16MB */
> +	if (mb < 16)
> +		return 1024*1024;
> +
> +	/* To 32MB for anything above that */
> +	return 32*1024*1024;
> +}
> +
>  void __init e820_reserve_resources_late(void)
>  {
>  	int i;
> @@ -1381,6 +1398,23 @@ void __init e820_reserve_resources_late(void)
>  			insert_resource_expand_to_fit(&iomem_resource, res);
>  		res++;
>  	}
> +
> +	/*
> +	 * Try to bump up RAM regions to reasonable boundaries to
> +	 * avoid stolen RAM
> +	 */
> +	for (i = 0; i < e820.nr_map; i++) {
> +		struct e820entry *entry = &e820_saved.map[i];
> +		resource_size_t start, end;
> +
> +		if (entry->type != E820_RAM)
> +			continue;

Would it make sense to round up everything that is listed in the 
E820 map? Just in case the BIOS is not entirely honest about the 
true extent of that area.

It might even make sense to add a small 'guard' area next to such 
ranges (even if they are aligned well): to prevent the BIOS from 
accidentally overruning into a device BAR we allocate next to it.

> +		start = entry->addr + entry->size;
> +		end = round_up(start, ram_alignment(start));
> +		if (start == end)
> +			continue;

Hm, indeed, the continue is needed - reserve_region_with_split() 
lets zero-sized resources be inserted silently. I'd have missed this 
case. Do zero-sized memory resources have a special role somewhere?

[ Plus i dont see any protection against negative-size resources in 
  kernel/resource.c either. OTOH inserting a negative size resource 
  just locks down the tree for all future resources, so it would be 
  noticed for sure.

  Zero-size is not an issue it appears, it goes in and prevents only 
  the exactly same-position zero-size resource to be inserted.

  But it might sense to silently ignore zero-size resources (if we 
  dont rely on them elsewhere), or to WARN() about them and about 
  negative size resources.
]

> +		reserve_region_with_split(&iomem_resource, start, end, "RAM buffer");

	Ingo
