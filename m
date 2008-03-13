Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYCMWAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYCMWAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbYCMV7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:59:53 -0400
Received: from mail.suse.de ([195.135.220.2]:42663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191AbYCMV7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:59:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Date: Thu, 13 Mar 2008 22:59:46 +0100
User-Agent: KMail/1.9.6
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, mingo@elte.hu, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com> <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com> <20080312182240.db32c858.akpm@linux-foundation.org>
In-Reply-To: <20080312182240.db32c858.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132259.47063.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 02:22:40 Andrew Morton wrote:
> On Wed, 12 Mar 2008 18:11:41 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> 
> > >  <looks at it>
> > >
> > >  Sorry, but I find the changelog very hard to amke sense of.  I presently
> > >  have:
> > >
> > >
> > >   So call it when numa is enabled, we don't know which node have that
> > >   range.  and make it more robust.
> > >
> > >   Try to trim it to get valid sidx, and eidx.
> > >
> > >  Could you please expand on this?
> > 
> > please check following...
> > 
> 
> Heaps better, thanks ;)  Below is what I now have.
> 
> (cc's people)
> 
> Guys, could you please review this?  Maybe test it a bit?
> 
> Thanks.
> 
> 
> From: "Yinghai Lu" <yhlu.kernel@gmail.com>
> 
> With numa enabled, some callers could have a range o fmemory on one node but
> try to free that on other node.  This can cause some pages to be freed
> wrongly.

Concrete examples?

If that happens it's really just a problem that the bootmem API
is wrong. I was always annoyed by the hardcoded NODE_DATA(0)s in
free_bootmem. 

I would suggest if that happens you just fix free_bootmem to search
for the correct node instead of hardcoding 0 and then eliminate
free_bootmem_node() everywhere and replace it with free_bootmem()
> 
> For example: when we try to allocate 128g boot ram early for gart/swiotlb, and
> free that range later so gart/swiotlb can get some range afterwards.

I'm confused by the example. AFAIK there is no memory freeing in either
gart nor swiotlb. At least there wasn't until very recently.

> 
> With this patch, we don't need to care which node holds the range, just loop
> to call free_bootmem_node for all online nodes.
> 
> This patch make free_bootmem_core() more robust by trimming the sidx and eidx
> according the ram range that the node has.

I think you should just kill free_bootmem_node() and replace it everywhere
with your improved free_bootmem()


> @@ -125,6 +125,7 @@ static int __init reserve_bootmem_core(b
>  	BUG_ON(!size);
>  	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
>  	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
> +	BUG_ON(addr < bdata->node_boot_start);

That seems unrelated?

>  
>  	sidx = PFN_DOWN(addr - bdata->node_boot_start);
>  	eidx = PFN_UP(addr + size - bdata->node_boot_start);
> @@ -156,21 +157,31 @@ static void __init free_bootmem_core(boo
>  	unsigned long sidx, eidx;
>  	unsigned long i;
>  
> +	BUG_ON(!size);
> +
> +	/* out range */
> +	if (addr + size < bdata->node_boot_start ||
> +		PFN_DOWN(addr) > bdata->node_low_pfn)
> +		return;

I don't really like this silent return without error value.
There should be a BUG() or something for someone passing addresses
outside any node. This check should be probably in the caller.

>  	/*
>  	 * round down end of usable mem, partially free pages are
>  	 * considered reserved.
>  	 */
> -	BUG_ON(!size);
> -	BUG_ON(PFN_DOWN(addr + size) > bdata->node_low_pfn);
>  
> -	if (addr < bdata->last_success)
> +	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
>  		bdata->last_success = addr;
>  
>  	/*
> -	 * Round up the beginning of the address.
> +	 * Round up to index to the range.
>  	 */
> -	sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
> +	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
> +		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
> +	else
> +		sidx = 0;
> +
>  	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
> +	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
> +		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);

I'm not sure for what these other changes are needed?  Just adding the
initial range check should be enough.

If you want to fix something else unrelated please do separate patches.

-Andi

