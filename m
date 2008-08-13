Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbYHMTcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbYHMTcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYHMTcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:32:25 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:64411 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYHMTcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:32:24 -0400
X-BigFish: VPS-43(zz10e3M3b49K1432R98dR4015M1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5K0X9-02-KZQ-01
Date: Wed, 13 Aug 2008 21:31:58 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] alloc_bootmem_core: fix misaligned allocation of 1G
	page
Message-ID: <20080813193158.GB5985@alberich.amd.com>
References: <20080812095336.GE5952@alberich.amd.com> <877iam41bk.fsf@skyscraper.fehenstaub.lan> <20080813164121.GA5985@alberich.amd.com> <87tzdo93tv.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87tzdo93tv.fsf@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Aug 2008 19:32:03.0419 (UTC) FILETIME=[436EAAB0:01C8FD7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 08:18:04PM +0200, Johannes Weiner wrote:
> Andreas Herrmann <andreas.herrmann3@amd.com> writes:

> > Otherwise the function can't allocate the first possible page. For
> > example, assuming that
> >
> >   node_min_pfn = 130000
> >   align = 0x40000000  (1GByte)
> >
> > allocating a 1G page on this node will result in
> >
> >   sidx=0x40000
> >   min_pfn=0x140000
> >
> > Both are properly aligned. But the resulting super-page will be at
> > address 0x180000000 whereas the first possible 1G page would be at
> > address 0x140000000.
> 
> I can not follow this example.  Is there a typo somewhere?  In this
> example, the resulting address is aligned but it shouldn't even be so.

No typo. I guess the confusion is just my ambiguous wording.
It's what your previous patch generated. At the end it "aligned" the first
1G page on node 1 at 0x180000000 (== the return value of alloc_bootmem_core)
but it reserved the region from 0x170000000:

  Aug 13 16:05:49 brandon bootmem::alloc_bootmem_core nid=1 size=40000000
    [262144 pages] align=40000000 goal=0 limit=0
  Aug 13 16:05:49 brandon bootmem::__reserve nid=1 start=170000 end=1b0000 flags=1
  Aug 13 16:05:49 brandon addr:ffff880180000000, paddr:0000000180000000, size: 1073741824

... and after some time ...

  BUG: unable to handle kernel NULL pointer dereference at 000000000000000a
  IP: [<ffffffff80261a87>] get_page_from_freelist+0x403/0x5ed
  PGD 22f108067 PUD 22dc3d067 PMD 0
  Oops: 0000 [1] SMP
  ...


> Attached is a version that should be easier to read.  Please
> double-check.

Nice.
That's the preferred solution and should replace my initial fix.

Reviewed-and-tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>


Thanks,

Andreas


> commit ec5b91737d0be242a6a9b255fa1749962f978188
> Author: Johannes Weiner <hannes@saeurebad.de>
> Date:   Wed Aug 13 19:59:43 2008 +0200
> 
>     bootmem: fix aligning of node-relative indexes and offsets
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 4af15d0..8620832 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -405,6 +405,30 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
>  }
>  #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
>  
> +static unsigned long align_idx(struct bootmem_data *bdata, unsigned long idx,
> +			unsigned long step)
> +{
> +	unsigned long base = bdata->node_min_pfn;
> +
> +	/*
> +	 * Align the index with respect to the node start so that the
> +	 * resulting absolute PFN (node-start + index) is properly
> +	 * aligned.
> +	 */
> +
> +	return ALIGN(base + idx, step) - base;
> +}
> +
> +static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
> +			unsigned long align)
> +{
> +	unsigned long base = PFN_PHYS(bdata->node_min_pfn);
> +
> +	/* Same as align_idx for byte offsets */
> +
> +	return ALIGN(base + off, align) - base;
> +}
> +
>  static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
>  				unsigned long size, unsigned long align,
>  				unsigned long goal, unsigned long limit)
> @@ -441,16 +465,23 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
>  	else
>  		start = ALIGN(min, step);
>  
> -	sidx = start - bdata->node_min_pfn;;
> +	sidx = start - bdata->node_min_pfn;
>  	midx = max - bdata->node_min_pfn;
>  
> +	/*
> +	 * Because the indexes are relative to the node, all alignment
> +	 * below has to be done with respect to the node's start in
> +	 * order to have the resulting PFNs and addresses properly
> +	 * aligned.
> +	 */
> +
>  	if (bdata->hint_idx > sidx) {
>  		/*
>  		 * Handle the valid case of sidx being zero and still
>  		 * catch the fallback below.
>  		 */
>  		fallback = sidx + 1;
> -		sidx = ALIGN(bdata->hint_idx, step);
> +		sidx = align_idx(bdata, bdata->hint_idx, step);
>  	}
>  
>  	while (1) {
> @@ -459,7 +490,7 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
>  		unsigned long eidx, i, start_off, end_off;
>  find_block:
>  		sidx = find_next_zero_bit(bdata->node_bootmem_map, midx, sidx);
> -		sidx = ALIGN(sidx, step);
> +		sidx = align_idx(bdata, sidx, step);
>  		eidx = sidx + PFN_UP(size);
>  
>  		if (sidx >= midx || eidx > midx)
> @@ -467,7 +498,7 @@ find_block:
>  
>  		for (i = sidx; i < eidx; i++)
>  			if (test_bit(i, bdata->node_bootmem_map)) {
> -				sidx = ALIGN(i, step);
> +				sidx = align_idx(bdata, i, step);
>  				if (sidx == i)
>  					sidx += step;
>  				goto find_block;
> @@ -475,7 +506,7 @@ find_block:
>  
>  		if (bdata->last_end_off &&
>  				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
> -			start_off = ALIGN(bdata->last_end_off, align);
> +			start_off = align_off(bdata, bdata->last_end_off, align);
>  		else
>  			start_off = PFN_PHYS(sidx);
>  
> @@ -499,7 +530,7 @@ find_block:
>  	}
>  
>  	if (fallback) {
> -		sidx = ALIGN(fallback - 1, step);
> +		sidx = align_idx(bdata, fallback - 1, step);
>  		fallback = 0;
>  		goto find_block;
>  	}
> 


