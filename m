Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbXFGHrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbXFGHrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXFGHqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:46:52 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59505 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXFGHqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:46:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706061229.24486.jesse.barnes@intel.com>
Date: Thu, 07 Jun 2007 01:45:32 -0600
In-Reply-To: <200706061229.24486.jesse.barnes@intel.com> (Jesse Barnes's
	message of "Wed, 6 Jun 2007 12:29:23 -0700")
Message-ID: <m1wsygryw3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jesse.barnes@intel.com> writes:

> On some machines, buggy BIOSes don't properly setup WB MTRRs to
> cover all available RAM, meaning the last few megs (or even gigs)
> of memory will be marked uncached.  Since Linux tends to allocate
> from high memory addresses first, this causes the machine to be
> unusably slow as soon as the kernel starts really using memory
> (i.e. right around init time).
>
> This patch works around the problem by scanning the MTRRs at
> boot and figuring out whether the current end_pfn value (setup
> by early e820 code) goes beyond the highest WB MTRR range, and
> if so, trimming it to match.  A fairly obnoxious KERN_WARNING
> is printed too, letting the user know that not all of their
> memory is available due to a likely BIOS bug.
>
> Something similar could be done on i386 if needed, but the boot
> ordering would be slightly different, since the MTRR code on i386
> depends on the boot_cpu_data structure being setup.
>
> Justin, can you please test and make sure this patch works for
> you too?  It'll only work around the problem, but it's better
> than having to do mem= by hand or waiting for a fix from your
> BIOS vendor.

Ok.  Overall this feels good but a few nits below.
Would it make sense to split this into two patches.
The first to just do the cleanup that removes the allocations
for holding the mttr ranges?

> Thanks,
> Jesse
>
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
>
> diff --git a/arch/i386/kernel/cpu/mtrr/generic.c
> b/arch/i386/kernel/cpu/mtrr/generic.c
> index c4ebb51..71fc768 100644
> --- a/arch/i386/kernel/cpu/mtrr/generic.c
> +++ b/arch/i386/kernel/cpu/mtrr/generic.c
> @@ -13,7 +13,7 @@
>  #include "mtrr.h"
>
>  
>  struct mtrr_state {
> -	struct mtrr_var_range *var_ranges;
> +	struct mtrr_var_range var_ranges[NUM_VAR_RANGES];

Could we name it MAX_VAR_RANGES and not NUM_VAR_RANGES.
In practices this is going to be 8 for every cpu I know of,
so calling this NUM_VAR_RANGES may be a little confusing.

>  	mtrr_type fixed_ranges[NUM_FIXED_RANGES];
>  	unsigned char enabled;
>  	unsigned char have_fixed;
> @@ -84,12 +84,6 @@ void get_mtrr_state(void)
>  	struct mtrr_var_range *vrs;
>  	unsigned lo, dummy;
>  
> -	if (!mtrr_state.var_ranges) {
> - mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct
> mtrr_var_range),
> -						GFP_KERNEL);
> -		if (!mtrr_state.var_ranges)
> -			return;
> -	} 
>  	vrs = mtrr_state.var_ranges;
>  
>  	rdmsr(MTRRcap_MSR, lo, dummy);
> diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/i386/kernel/cpu/mtrr/if.c
> index c7d8f17..d7922ce 100644
> --- a/arch/i386/kernel/cpu/mtrr/if.c
> +++ b/arch/i386/kernel/cpu/mtrr/if.c
> @@ -12,7 +12,7 @@
>  #include "mtrr.h"
>  
>  /* RED-PEN: this is accessed without any locking */
> -extern unsigned int *usage_table;
> +extern unsigned int usage_table[];
I think that should be:
> +extern unsigned int usage_table[NUM_VAR_RANGES];
Or even better yet the declaration moved to a header file.


>  
> +/**
> + * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
> + *
> + * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
> + * memory configurations.  This routine checks to make sure the MTRRs having
> + * a write back type cover all of the memory the kernel is intending to use.
> + * If not, it'll trim any memory off the end by adjusting end_pfn, removing
> + * it from the kernel's allocation pools, warning the user with an obnoxious
> + * message.
> + */
> +void __init mtrr_trim_uncached_memory(void)
> +{
> +	unsigned long i, base, size, highest_addr = 0;
> +	mtrr_type type;
> +
> +	/* Find highest cached pfn */
> +	for (i = 0; i < num_var_ranges; i++) {
> +		mtrr_if->get(i, &base, &size, &type);
> +		if (type != MTRR_TYPE_WRBACK)
> +			continue;
> +		base <<= PAGE_SHIFT;
> +		size <<= PAGE_SHIFT;
> +		if (highest_addr < base + size)
> +			highest_addr = base + size;
> +	}

This looks like it will handle the common case, so I have no major objections
to this code.

At least in theory and possibly in practice there are a couple of corner
cases we have missed her.

- Overlapping MTRRs.
- What happens if we have uncached memory lower down?
  Except for performance problems I guess that case is relatively harmless.
- Is it possible and worth it to amend the e820 map, so it shows the
  problem area as Reserved or otherwise not usable RAM?


> +
> +	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
> +		printk(KERN_WARNING "***************\n");
> +		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
> +		printk(KERN_WARNING "**** MTRRs don't cover all of "
> +		       "memory, trimmed %ld pages\n", end_pfn -
> +		       (highest_addr >> PAGE_SHIFT));
> +		printk(KERN_WARNING "***************\n");
> +		end_pfn = highest_addr >> PAGE_SHIFT;
> +	}
> +}
>  
>  /**
>   * mtrr_bp_init - initialize mtrrs on the boot CPU
> diff --git a/arch/i386/kernel/cpu/mtrr/mtrr.h b/arch/i386/kernel/cpu/mtrr/mtrr.h
> index 289dfe6..a29dcba 100644
> --- a/arch/i386/kernel/cpu/mtrr/mtrr.h
> +++ b/arch/i386/kernel/cpu/mtrr/mtrr.h
> @@ -14,6 +14,7 @@
>  #define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
>  
>  #define NUM_FIXED_RANGES 88
> +#define NUM_VAR_RANGES 256
MAX_VAR_RANGES?

>  #define MTRRfix64K_00000_MSR 0x250
>  #define MTRRfix16K_80000_MSR 0x258
>  #define MTRRfix16K_A0000_MSR 0x259

Eric
