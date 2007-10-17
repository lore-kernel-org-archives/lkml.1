Return-Path: <linux-kernel-owner+w=401wt.eu-S935042AbXJQLG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935042AbXJQLG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934505AbXJQLFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:05:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59434 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636AbXJQLFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:05:54 -0400
Date: Wed, 17 Oct 2007 16:35:51 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org, ak@suse.de
Subject: Re: [patch 2/3] Introduce BOOTMEM_EXCLUSIVE
Message-ID: <20071017110550.GB17565@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20071016162857.635479952@strauss.suse.de> <20071016162858.545617122@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016162858.545617122@strauss.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[..]
> +/*
> + * If flags is 0, then the return value is always 0 (success). If
> + * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
> + * memory already was reserved.
> + */
> +extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
>  #define alloc_bootmem(x) \
>  	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
>  #define alloc_bootmem_low(x) \
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -111,8 +111,8 @@ static unsigned long __init init_bootmem
>   * might be used for boot-time allocations - or it might get added
>   * to the free page pool later on.
>   */
> -static void __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
> -					unsigned long size)
> +static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
> +					unsigned long size, int flags)
>  {
>  	unsigned long sidx, eidx;
>  	unsigned long i;
> @@ -133,7 +133,11 @@ static void __init reserve_bootmem_core(
>  #ifdef CONFIG_DEBUG_BOOTMEM
>  			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
>  #endif
> +			if (flags & BOOTMEM_EXCLUSIVE)
> +				return -EBUSY;

I think we should unreserve the chunks of memory we have reserved so
far (Memory reserved from sidx to i), in case of error.

Thanks
Vivek
