Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYCNAQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYCNAQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYCNAPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:15:51 -0400
Received: from saeurebad.de ([85.214.36.134]:56649 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYCNAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:15:50 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
Date: Fri, 14 Mar 2008 01:13:30 +0100
In-Reply-To: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 13 Mar 2008 16:45:42 -0700")
Message-ID: <87iqzq40yd.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> Index: linux-2.6/mm/bootmem.c
> ===================================================================
> --- linux-2.6.orig/mm/bootmem.c
> +++ linux-2.6/mm/bootmem.c
> @@ -111,44 +111,69 @@ static unsigned long __init init_bootmem
>   * might be used for boot-time allocations - or it might get added
>   * to the free page pool later on.
>   */
> -static int __init reserve_bootmem_core(bootmem_data_t *bdata,
> +static int __init can_reserve_bootmem_core(bootmem_data_t *bdata,
>  			unsigned long addr, unsigned long size, int flags)
>  {
>  	unsigned long sidx, eidx;
>  	unsigned long i;
> -	int ret;
> +
> +	BUG_ON(!size);
> +
> +	/* out of range, don't hold other */
> +	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
> +		return 0;
>  
>  	/*
> -	 * round up, partially reserved pages are considered
> -	 * fully reserved.
> +	 * Round up to index to the range.
>  	 */
> +	if (addr > bdata->node_boot_start)
> +		sidx= PFN_DOWN(addr - bdata->node_boot_start);
> +	else
> +		sidx = 0;
> +
> +	eidx = PFN_UP(addr + size - bdata->node_boot_start);
> +	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
> +		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
> +
> +	for (i = sidx; i < eidx; i++)
> +		if (test_bit(i, bdata->node_bootmem_map)) {
> +			if (flags & BOOTMEM_EXCLUSIVE)
> +				return -EBUSY;
> +		}
> +
> +	return 0;
> +
> +}
> +static void __init reserve_bootmem_core(bootmem_data_t *bdata,
> +			unsigned long addr, unsigned long size, int flags)
> +{
> +	unsigned long sidx, eidx;
> +	unsigned long i;
> +
>  	BUG_ON(!size);
> -	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
> -	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
> -	BUG_ON(addr < bdata->node_boot_start);
>  
> -	sidx = PFN_DOWN(addr - bdata->node_boot_start);
> +	/* out of range */
> +	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
> +		return;
> +
> +	/*
> +	 * Round up to index to the range.
> +	 */
> +	if (addr > bdata->node_boot_start)
> +		sidx= PFN_DOWN(addr - bdata->node_boot_start);
> +	else
> +		sidx = 0;
> +
>  	eidx = PFN_UP(addr + size - bdata->node_boot_start);
> +	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
> +		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
>  
>  	for (i = sidx; i < eidx; i++)
>  		if (test_and_set_bit(i, bdata->node_bootmem_map)) {
>  #ifdef CONFIG_DEBUG_BOOTMEM
>  			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
>  #endif
> -			if (flags & BOOTMEM_EXCLUSIVE) {
> -				ret = -EBUSY;
> -				goto err;
> -			}
>  		}
> -
> -	return 0;
> -
> -err:
> -	/* unreserve memory we accidentally reserved */
> -	for (i--; i >= sidx; i--)
> -		clear_bit(i, bdata->node_bootmem_map);
> -
> -	return ret;
>  }
>  
>  static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
> @@ -407,6 +432,11 @@ unsigned long __init init_bootmem_node(p
>  void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
>  				 unsigned long size, int flags)
>  {
> +	int ret;
> +
> +	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
> +	if (ret < 0)
> +		return;
>  	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);

I don't get it.  Sorry.  What is the purpose of
can_reserve_bootmem_core()?  It does exactly what reserve_bootmem_core
does besides actually setting the bits.  All the pre-checking you wanted
to have out of the way is repeated again in reserve_bootmem_core()
(well, almost all).

	Hannes
