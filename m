Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbXBFA16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbXBFA16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933105AbXBFA16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:27:58 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40740 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbXBFA15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:27:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org, "Richard Gooch" <rgooch@safe-mbox.com>
Subject: Re: [patch] mtrr: fix issues with large addresses
References: <20070205171959.GF8665@alberich.amd.com>
Date: Mon, 05 Feb 2007 17:26:12 -0700
In-Reply-To: <20070205171959.GF8665@alberich.amd.com> (Andreas Herrmann's
	message of "Mon, 5 Feb 2007 18:19:59 +0100")
Message-ID: <m13b5kw2qj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Andreas Herrmann" <andreas.herrmann3@amd.com> writes:

> Hi,
>
> This is a repost of a mail sent to Richard Gooch and lkml some time
> ago. Meanwhile I noticed that Richard has a new email address. And it
> seems that he does not maintain the mtrr code anymore. (So how about
> updating the MAINTAINERS file?)
>
> Here we go again -- with new recipient and a slightly modified
> version of the patch.
>
>
> Regards,
>
> Andreas
>
>
> mtrr: fix issues with large addresses
>
> Fixes some issues with /proc/mtrr interface:
> o If physical address size crosses the 44 bit boundary
>   size_or_mask is evaluated wrong
> o size_and_mask limits physical base
>   address for an MTRR to be less than 44 bit
> o added check to restrict base address to 36 bit on i386

The limit is per cpu not per architecture.  So if you run a
cpu that can run in 64bit mode in 32bit mode the limit
is not 36 bits.  Even PAE in 32bit mode doesn't have that limit.

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>
> --
> diff --git a/arch/i386/kernel/cpu/mtrr/generic.c
> b/arch/i386/kernel/cpu/mtrr/generic.c
> index f77fc53..aa21d15 100644
> --- a/arch/i386/kernel/cpu/mtrr/generic.c
> +++ b/arch/i386/kernel/cpu/mtrr/generic.c
> @@ -172,7 +172,7 @@ int generic_get_free_region(unsigned long base, unsigned
> long size, int replace_
>  static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>  			     unsigned long *size, mtrr_type *type)
>  {
> -	unsigned int mask_lo, mask_hi, base_lo, base_hi;
> +	unsigned long mask_lo, mask_hi, base_lo, base_hi;

Why?  Given the low and the high I am assuming these are all implicitly
32bit quantities.  unsigned int is fine.
  
>  	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
>  	if ((mask_lo & 0x800) == 0) {
> diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/i386/kernel/cpu/mtrr/if.c
> index 5ae1705..3abc3f1 100644
> --- a/arch/i386/kernel/cpu/mtrr/if.c
> +++ b/arch/i386/kernel/cpu/mtrr/if.c
> @@ -137,6 +137,10 @@ mtrr_write(struct file *file, const char __user *buf,
> size_t len, loff_t * ppos)
>  	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
>  		if (strcmp(ptr, mtrr_strings[i]))
>  			continue;
> +#ifndef CONFIG_X86_64
> +		if (base > 0xfffffffffULL)
> +			return -EINVAL;
> +#endif

That is just silly.  If the cpu is running in long mode or should
not affect this capability.

>  		base >>= PAGE_SHIFT;
>  		size >>= PAGE_SHIFT;
>  		err =
> diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
> index 16bb7ea..0acfb6a 100644
> --- a/arch/i386/kernel/cpu/mtrr/main.c
> +++ b/arch/i386/kernel/cpu/mtrr/main.c
> @@ -50,7 +50,7 @@ u32 num_var_ranges = 0;
>  unsigned int *usage_table;
>  static DEFINE_MUTEX(mtrr_mutex);
>  
> -u32 size_or_mask, size_and_mask;
> +u64 size_or_mask, size_and_mask;
>  
>  static struct mtrr_ops * mtrr_ops[X86_VENDOR_NUM] = {};
>  
> @@ -662,8 +662,8 @@ void __init mtrr_bp_init(void)
>  			     boot_cpu_data.x86_mask == 0x4))
>  				phys_addr = 36;
>  
> -			size_or_mask = ~((1 << (phys_addr - PAGE_SHIFT)) - 1);
> -			size_and_mask = ~size_or_mask & 0xfff00000;
> + size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
> +			size_and_mask = ~size_or_mask & 0xfffff00000ULL;

Don't you want to make this hard coded mask 0xfffffffffff00000ULL?

Eric
