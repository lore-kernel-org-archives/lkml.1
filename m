Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbXKHMUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbXKHMUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 07:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbXKHMT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 07:19:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48079 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842AbXKHMTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 07:19:55 -0500
Date: Thu, 8 Nov 2007 12:19:52 +0000
To: Zou Nan hai <nanhai.zou@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: Patch]Add strict_goal parameter to __alloc_bootmem_core
Message-ID: <20071108121952.GA21652@skynet.ie>
References: <1194483110.3046.1469.camel@linux-znh>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1194483110.3046.1469.camel@linux-znh>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/11/07 08:51), Zou Nan hai didst pronounce:
> Resend the patch for more people to review.
> 
> If __alloc_bootmem_core was given a goal, it will first try to allocate
> memory above that goal. If failed, it will try from the low pages.
> 
> Sometimes we don't want this behavior, we want the goal to be strict.
> 

For the sake of the changelog, why?

> This patch introduce a strict_goal parameter to __alloc_bootmem_core, 
> 
> If strict_goal is set, __alloc_bootmem_core will return NULL to indicate
> it can't allocate memory above that goal.
> 
> Note we do not scan from last_success if strict_goal is set, it will
> scan from the beginning of the goal instead
> We skip this optimization to keep the code simple because strict_goal is
> not supposed to be used in hot path.
> 
> Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff -Nraup a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> --- a/arch/x86/mm/numa_64.c	2007-10-24 11:50:57.000000000 +0800
> +++ b/arch/x86/mm/numa_64.c	2007-11-07 13:06:50.000000000 +0800
> @@ -247,7 +247,7 @@ void __init setup_node_zones(int nodeid)
>  		__alloc_bootmem_core(NODE_DATA(nodeid)->bdata, 
>  				memmapsize, SMP_CACHE_BYTES, 
>  				round_down(limit - memmapsize, PAGE_SIZE), 
> -				limit);
> +				limit, 1);

Magic number alert. That 1 needs to be #defined

#define BOOTMEM_STRICT_GOAL	1

or something. I know it's semi-obvious from the parameter name what it
means but even so. The #define will make it easier for someone to
convert that parameter into a flags bitmap later like gfp flags if that
ever became necessary.

>  #endif
>  } 
>  
> diff -Nraup a/include/linux/bootmem.h b/include/linux/bootmem.h
> --- a/include/linux/bootmem.h	2007-11-07 13:06:35.000000000 +0800
> +++ b/include/linux/bootmem.h	2007-11-07 13:06:04.000000000 +0800
> @@ -58,7 +58,8 @@ extern void *__alloc_bootmem_core(struct
>  				  unsigned long size,
>  				  unsigned long align,
>  				  unsigned long goal,
> -				  unsigned long limit);
> +				  unsigned long limit,
> +				  int strict_goal);
>  
>  #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
>  extern void reserve_bootmem(unsigned long addr, unsigned long size);
> diff -Nraup a/mm/bootmem.c b/mm/bootmem.c
> --- a/mm/bootmem.c	2007-11-07 13:06:35.000000000 +0800
> +++ b/mm/bootmem.c	2007-11-07 13:06:18.000000000 +0800
> @@ -179,7 +179,7 @@ static void __init free_bootmem_core(boo
>   */
>  void * __init
>  __alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
> -	      unsigned long align, unsigned long goal, unsigned long limit)
> +	      unsigned long align, unsigned long goal, unsigned long limit, int strict_goal)

80 char limit violation there. It's not a hard limit but this doesn't
look like a case where the code is much better looking by breaking it.

>  {
>  	unsigned long offset, remaining_size, areasize, preferred;
>  	unsigned long i, start = 0, incr, eidx, end_pfn;
> @@ -212,15 +212,20 @@ __alloc_bootmem_core(struct bootmem_data
>  	/*
>  	 * We try to allocate bootmem pages above 'goal'
>  	 * first, then we try to allocate lower pages.
> -	 */
> -	if (goal && goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
> -		preferred = goal - bdata->node_boot_start;
> +	 * if the goal is not strict.
> +         */

Tabs vs spaces there.

> +
> +	preferred = 0;
> +	if (goal) {
> +		if (goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
> +			preferred = goal - bdata->node_boot_start;
>  
>  		if (bdata->last_success >= preferred)
> -			if (!limit || (limit && limit > bdata->last_success))
> +			if (!strict_goal && (!limit || (limit && limit > bdata->last_success)))

Aside, it's not obvious why there is a check that looks like

!limit || (limit ...)

if it's not one, it's the other surely :/

>  				preferred = bdata->last_success;

Not clear at all why strict_goal is checked here.

> -	} else
> -		preferred = 0;
> +		} else if (strict_goal)
> +                        return NULL;

tabs vs spaces again. Consider using checkpatch.pl. Its report is not
something that has to be strictly obeyed in all cases but for simply
styling issues like this, it is almost always right.

That aside, this is pretty ugly lookin and it's not clear why setting no
goal and asking for strict_goal results in NULL being returned. Maybe I
am missing the point and this needs commenting. Minimally, multi-statement
lines are frowned upon. For example

if (condition)
	x++;

is preferred to

if (condition) x++;

While the current code could be nicer looking, I don't see why it needs
to change at all. If goal is specified, preferred should start as a
higher value than goal whether strict_goal is set or not. Even if you
want to avoid last_success, it's easier to read

	/*
	 * Start searching from last_success unless strict_goal is
	 * set or the last allocation was over the upper limit. If
	 * we are being strict about allocating above goal, we will
	 * assume the caller does not mind a more expensive search
	 */
	if (!strict_goal && bdata->last_success >= preferred)
		if (!limit || limit > bdata->last_success)
			preferred = bdata->last_success;

or something.

> +	}
>  
>  	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
>  	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
> @@ -247,7 +252,7 @@ restart_scan:
>  		i = ALIGN(j, incr);
>  	}
>  
> -	if (preferred > offset) {
> +	if (preferred > offset && !strict_goal) {

again, not immediately clear why strict_goal is checked here.

>  		preferred = offset;
>  		goto restart_scan;
>  	}
> @@ -421,7 +426,7 @@ void * __init __alloc_bootmem_nopanic(un
>  	void *ptr;
>  
>  	list_for_each_entry(bdata, &bdata_list, list) {
> -		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0);
> +		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0, 0);

Magic number alert again - use BOOTMEM_ANY_ADDRESS or something. I suck at
naming but once you select a, someone with better naming taste will complain
and give better suggestions.

>  		if (ptr)
>  			return ptr;
>  	}
> @@ -449,7 +454,7 @@ void * __init __alloc_bootmem_node(pg_da
>  {
>  	void *ptr;
>  
> -	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
> +	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0, 0);
>  	if (ptr)
>  		return ptr;
>  
> @@ -468,7 +473,7 @@ void * __init __alloc_bootmem_low(unsign
>  
>  	list_for_each_entry(bdata, &bdata_list, list) {
>  		ptr = __alloc_bootmem_core(bdata, size, align, goal,
> -						ARCH_LOW_ADDRESS_LIMIT);
> +						ARCH_LOW_ADDRESS_LIMIT, 0);
>  		if (ptr)
>  			return ptr;
>  	}
> @@ -485,5 +490,5 @@ void * __init __alloc_bootmem_low_node(p
>  				       unsigned long align, unsigned long goal)
>  {
>  	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
> -				    ARCH_LOW_ADDRESS_LIMIT);
> +				    ARCH_LOW_ADDRESS_LIMIT, 0);
>  }
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
