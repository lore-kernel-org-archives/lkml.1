Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbYCUUA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbYCUUA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYCUUAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:00:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58084 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYCUUAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:00:48 -0400
Date: Fri, 21 Mar 2008 21:00:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, andi@firstfloor.org, ak@suse.de,
       clameter@sgi.com, linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Message-ID: <20080321200030.GD16179@elte.hu>
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com> <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com> <20080312182240.db32c858.akpm@linux-foundation.org> <200803132259.47063.ak@suse.de> <86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com> <87iqzp5xfv.fsf@basil.nowhere.org> <86802c440803140944p302b300fy7515fb758221932b@mail.gmail.com> <20080314165336.GS2522@one.firstfloor.org> <86802c440803141036m4a508a91o2cf6706157231429@mail.gmail.com> <20080321124404.f9d74052.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321124404.f9d74052.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> diff -puN mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core mm/bootmem.c
> --- a/mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core
> +++ a/mm/bootmem.c
> @@ -125,6 +125,7 @@ static int __init reserve_bootmem_core(b
>  	BUG_ON(!size);
>  	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
>  	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
> +	BUG_ON(addr < bdata->node_boot_start);
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
>  
>  	for (i = sidx; i < eidx; i++) {
>  		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
> @@ -421,7 +432,9 @@ int __init reserve_bootmem(unsigned long
>  
>  void __init free_bootmem(unsigned long addr, unsigned long size)
>  {
> -	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
> +	bootmem_data_t *bdata;
> +	list_for_each_entry(bdata, &bdata_list, list)
> +		free_bootmem_core(bdata, addr, size);
>  }
>  
>  unsigned long __init free_all_bootmem(void)

note, this combination is quite well tested now, on various x86 systems, 
small and large alike, and about a 100 randconfigs booted up.

Acked-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
