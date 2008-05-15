Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYEOGv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYEOGv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYEOGvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:51:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:44584 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYEOGvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:51:17 -0400
Subject: Re: [PATCH 4/5] [PPC] update lmb for hotplug memory add/remove
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>
In-Reply-To: <1206664759.19368.11.camel@dyn9047017100.beaverton.ibm.com>
References: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com>
	 <1206664759.19368.11.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 23:49:50 -0700
Message-Id: <1210834190.8297.82.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-27 at 16:39 -0800, Badari Pulavarty wrote:
> ppc kernel maintains information about logical memory blocks in
> lmb.memory structure at the boot time. Its not updated for
> hotplug memory add/remove. hotplug memory notifier for memory
> add/remove now updates lmb.memory.
> 
> This information is useful for eHEA driver to find out the memory 
> layout and holes.
> 
> NOTE: No special locking is needed for lmb_add() and lmb_remove().
> Calls to these are serialized by caller. (pSeries_reconfig_chain).

My worry here is the lack of locking...

> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/hotplug-memory.c |   43 +++++++++++++++
>  include/linux/lmb.h                             |    3 -
>  lib/lmb.c                                       |   66 ++++++++++++++++++++----
>  3 files changed, 102 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6.25-rc3/lib/lmb.c
> ===================================================================
> --- linux-2.6.25-rc3.orig/lib/lmb.c	2008-03-05 10:44:29.000000000 -0800
> +++ linux-2.6.25-rc3/lib/lmb.c	2008-03-05 10:44:56.000000000 -0800
> @@ -54,14 +54,13 @@ void lmb_dump_all(void)
>  #endif /* DEBUG */
>  }
>  
> -static unsigned long __init lmb_addrs_overlap(u64 base1,
> -		u64 size1, u64 base2, u64 size2)
> +static unsigned long lmb_addrs_overlap(u64 base1, u64 size1, u64 base2,
> +		u64 size2)
>  {
>  	return ((base1 < (base2+size2)) && (base2 < (base1+size1)));
>  }
>  
> -static long __init lmb_addrs_adjacent(u64 base1, u64 size1,
> -		u64 base2, u64 size2)
> +static long lmb_addrs_adjacent(u64 base1, u64 size1, u64 base2, u64 size2)
>  {
>  	if (base2 == base1 + size1)
>  		return 1;
> @@ -71,7 +70,7 @@ static long __init lmb_addrs_adjacent(u6
>  	return 0;
>  }
>  
> -static long __init lmb_regions_adjacent(struct lmb_region *rgn,
> +static long lmb_regions_adjacent(struct lmb_region *rgn,
>  		unsigned long r1, unsigned long r2)
>  {
>  	u64 base1 = rgn->region[r1].base;
> @@ -82,7 +81,7 @@ static long __init lmb_regions_adjacent(
>  	return lmb_addrs_adjacent(base1, size1, base2, size2);
>  }
>  
> -static void __init lmb_remove_region(struct lmb_region *rgn, unsigned long r)
> +static void lmb_remove_region(struct lmb_region *rgn, unsigned long r)
>  {
>  	unsigned long i;
>  
> @@ -94,7 +93,7 @@ static void __init lmb_remove_region(str
>  }
>  
>  /* Assumption: base addr of region 1 < base addr of region 2 */
> -static void __init lmb_coalesce_regions(struct lmb_region *rgn,
> +static void lmb_coalesce_regions(struct lmb_region *rgn,
>  		unsigned long r1, unsigned long r2)
>  {
>  	rgn->region[r1].size += rgn->region[r2].size;
> @@ -129,7 +128,7 @@ void __init lmb_analyze(void)
>  }
>  
>  /* This routine called with relocation disabled. */
> -static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
> +static long lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
>  {
>  	unsigned long coalesced = 0;
>  	long adjacent, i;
> @@ -195,7 +194,7 @@ static long __init lmb_add_region(struct
>  }
>  
>  /* This routine may be called with relocation disabled. */
> -long __init lmb_add(u64 base, u64 size)
> +long lmb_add(u64 base, u64 size)
>  {
>  	struct lmb_region *_rgn = &(lmb.memory);
>  
> @@ -207,6 +206,55 @@ long __init lmb_add(u64 base, u64 size)
>  
>  }
>  
> +long lmb_remove(u64 base, u64 size)
> +{
> +	struct lmb_region *rgn = &(lmb.memory);
> +	u64 rgnbegin, rgnend;
> +	u64 end = base + size;
> +	int i;
> +
> +	rgnbegin = rgnend = 0; /* supress gcc warnings */
> +
> +	/* Find the region where (base, size) belongs to */
> +	for (i=0; i < rgn->cnt; i++) {
> +		rgnbegin = rgn->region[i].base;
> +		rgnend = rgnbegin + rgn->region[i].size;
> +
> +		if ((rgnbegin <= base) && (end <= rgnend))
> +			break;
> +	}
> +
> +	/* Didn't find the region */
> +	if (i == rgn->cnt)
> +		return -1;
> +
> +	/* Check to see if we are removing entire region */
> +	if ((rgnbegin == base) && (rgnend == end)) {
> +		lmb_remove_region(rgn, i);
> +		return 0;
> +	}
> +
> +	/* Check to see if region is matching at the front */
> +	if (rgnbegin == base) {
> +		rgn->region[i].base = end;
> +		rgn->region[i].size -= size;
> +		return 0;
> +	}
> +
> +	/* Check to see if the region is matching at the end */
> +	if (rgnend == end) {
> +		rgn->region[i].size -= size;
> +		return 0;
> +	}
> +
> +	/*
> +	 * We need to split the entry -  adjust the current one to the
> +	 * beginging of the hole and add the region after hole.
> +	 */
> +	rgn->region[i].size = base - rgn->region[i].base;
> +	return lmb_add_region(rgn, end, rgnend - end);
> +}
> +
>  long __init lmb_reserve(u64 base, u64 size)
>  {
>  	struct lmb_region *_rgn = &(lmb.reserved);
> Index: linux-2.6.25-rc3/arch/powerpc/platforms/pseries/hotplug-memory.c
> ===================================================================
> --- linux-2.6.25-rc3.orig/arch/powerpc/platforms/pseries/hotplug-memory.c	2008-03-05 10:44:51.000000000 -0800
> +++ linux-2.6.25-rc3/arch/powerpc/platforms/pseries/hotplug-memory.c	2008-03-05 10:45:06.000000000 -0800
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/of.h>
> +#include <linux/lmb.h>
>  #include <asm/firmware.h>
>  #include <asm/machdep.h>
>  #include <asm/pSeries_reconfig.h>
> @@ -58,6 +59,11 @@ static int pseries_remove_memory(struct 
>  		return ret;
>  
>  	/*
> +	 * Update memory regions for memory remove
> +	 */
> +	lmb_remove(start_pfn << PAGE_SHIFT, regs[3]);
> +
> +	/*
>  	 * Remove htab bolted mappings for this section of memory
>  	 */
>   	start = (unsigned long)__va(start_pfn << PAGE_SHIFT);
> @@ -65,6 +71,41 @@ static int pseries_remove_memory(struct 
>  	return ret;
>  }
>  
> +static int pseries_add_memory(struct device_node *np)
> +{
> +	const char *type;
> +	const unsigned int *my_index;
> +	const unsigned int *regs;
> +	u64 start_pfn;
> +	int ret = -EINVAL;
> +
> +	/*
> +	 * Check to see if we are actually adding memory
> +	 */
> +	type = of_get_property(np, "device_type", NULL);
> +	if (type == NULL || strcmp(type, "memory") != 0)
> +		return 0;
> +
> +	/*
> +	 * Find the memory index and size of the removing section
> +	 */
> +	my_index = of_get_property(np, "ibm,my-drc-index", NULL);
> +	if (!my_index)
> +		return ret;
> +
> +	regs = of_get_property(np, "reg", NULL);
> +	if (!regs)
> +		return ret;
> +
> +	start_pfn = section_nr_to_pfn(*my_index & 0xffff);
> +
> +	/*
> +	 * Update memory region to represent the memory add
> +	 */
> +	lmb_add(start_pfn << PAGE_SHIFT, regs[3]);
> +	return 0;
> +}
> +
>  static int pseries_memory_notifier(struct notifier_block *nb,
>  				unsigned long action, void *node)
>  {
> @@ -72,6 +113,8 @@ static int pseries_memory_notifier(struc
>  
>  	switch (action) {
>  	case PSERIES_RECONFIG_ADD:
> +		if (pseries_add_memory(node))
> +			err = NOTIFY_BAD;
>  		break;
>  	case PSERIES_RECONFIG_REMOVE:
>  		if (pseries_remove_memory(node))
> Index: linux-2.6.25-rc3/include/linux/lmb.h
> ===================================================================
> --- linux-2.6.25-rc3.orig/include/linux/lmb.h	2008-03-05 10:44:29.000000000 -0800
> +++ linux-2.6.25-rc3/include/linux/lmb.h	2008-03-05 10:44:56.000000000 -0800
> @@ -40,7 +40,8 @@ extern struct lmb lmb;
>  
>  extern void __init lmb_init(void);
>  extern void __init lmb_analyze(void);
> -extern long __init lmb_add(u64 base, u64 size);
> +extern long lmb_add(u64 base, u64 size);
> +extern long lmb_remove(u64 base, u64 size);
>  extern long __init lmb_reserve(u64 base, u64 size);
>  extern u64 __init lmb_alloc(u64 size, u64 align);
>  extern u64 __init lmb_alloc_base(u64 size,
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

