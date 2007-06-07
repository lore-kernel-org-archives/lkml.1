Return-Path: <linux-kernel-owner+w=401wt.eu-S966045AbXFGWxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966045AbXFGWxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965681AbXFGWxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:53:44 -0400
Received: from lucidpixels.com ([75.144.35.66]:51131 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965380AbXFGWxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:53:43 -0400
Date: Thu, 7 Jun 2007 18:53:42 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706071530.51552.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706071853170.16563@p34.internal.lan>
References: <200706071530.51552.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

p34:/usr/src/linux# patch -p1 < ../mtrr-v2.patch
patching file Documentation/kernel-parameters.txt
patching file arch/i386/kernel/cpu/mtrr/generic.c
patching file arch/i386/kernel/cpu/mtrr/if.c
patching file arch/i386/kernel/cpu/mtrr/main.c
patching file arch/i386/kernel/cpu/mtrr/mtrr.h
patching file arch/x86_64/kernel/bugs.c
patching file arch/x86_64/kernel/setup.c
patching file include/asm-x86_64/mtrr.h
p34:/usr/src/linux#

Applies clean to 2.6.22-rc4, verifying shortly.

On Thu, 7 Jun 2007, Jesse Barnes wrote:

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
> This patch incorporates the feedback from Eric and Andi:
>  - use MAX_VAR_RANGES instead of NUM_VAR_RANGES
>  - move array declaration to header file as an extern
>  - add command line disable option "disable_mtrr_trim"
>  - don't run the trim code if the MTRR default type is cacheable
>  - don't run the trim code on non-Intel machines
>
> Justin, feel free to test again if you have time and add your
> "Tested-by" signoff.
>
> Andi, as for large pages, do you think this is ok as is, or should
> I trim a larger granularity?  If so, what granularity?
>
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
>
> Thanks,
> Jesse
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 5d0283c..cb728a8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -553,6 +553,12 @@ and is between 256 and 4096 characters. It is defined in the file
> 			See drivers/char/README.epca and
> 			Documentation/digiepca.txt.
>
> +	disable_mtrr_trim [X86-64]
> +			By default the kernel will trim any uncacheable
> +			memory out of your available memory pool based on
> +			MTRR settings.  This parameter disables that behavior,
> +			possibly causing your machine to run very slowly.
> +
> 	dmascc=		[HW,AX25,SERIAL] AX.25 Z80SCC driver with DMA
> 			support available.
> 			Format: <io_dev0>[,<io_dev1>[,..<io_dev32>]]
> diff --git a/arch/i386/kernel/cpu/mtrr/generic.c b/arch/i386/kernel/cpu/mtrr/generic.c
> index c4ebb51..8eb3085 100644
> --- a/arch/i386/kernel/cpu/mtrr/generic.c
> +++ b/arch/i386/kernel/cpu/mtrr/generic.c
> @@ -13,7 +13,7 @@
> #include "mtrr.h"
>
> struct mtrr_state {
> -	struct mtrr_var_range *var_ranges;
> +	struct mtrr_var_range var_ranges[MAX_VAR_RANGES];
> 	mtrr_type fixed_ranges[NUM_FIXED_RANGES];
> 	unsigned char enabled;
> 	unsigned char have_fixed;
> @@ -84,12 +84,6 @@ void get_mtrr_state(void)
> 	struct mtrr_var_range *vrs;
> 	unsigned lo, dummy;
>
> -	if (!mtrr_state.var_ranges) {
> -		mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct mtrr_var_range),
> -						GFP_KERNEL);
> -		if (!mtrr_state.var_ranges)
> -			return;
> -	}
> 	vrs = mtrr_state.var_ranges;
>
> 	rdmsr(MTRRcap_MSR, lo, dummy);
> diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/i386/kernel/cpu/mtrr/if.c
> index c7d8f17..0e34a67 100644
> --- a/arch/i386/kernel/cpu/mtrr/if.c
> +++ b/arch/i386/kernel/cpu/mtrr/if.c
> @@ -11,10 +11,6 @@
> #include <asm/mtrr.h>
> #include "mtrr.h"
>
> -/* RED-PEN: this is accessed without any locking */
> -extern unsigned int *usage_table;
> -
> -
> #define FILE_FCOUNT(f) (((struct seq_file *)((f)->private_data))->private)
>
> static const char *const mtrr_strings[MTRR_NUM_TYPES] =
> diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
> index 7202b98..ef552ba 100644
> --- a/arch/i386/kernel/cpu/mtrr/main.c
> +++ b/arch/i386/kernel/cpu/mtrr/main.c
> @@ -38,8 +38,8 @@
> #include <linux/cpu.h>
> #include <linux/mutex.h>
>
> +#include <asm/e820.h>
> #include <asm/mtrr.h>
> -
> #include <asm/uaccess.h>
> #include <asm/processor.h>
> #include <asm/msr.h>
> @@ -47,7 +47,7 @@
>
> u32 num_var_ranges = 0;
>
> -unsigned int *usage_table;
> +unsigned int usage_table[MAX_VAR_RANGES];
> static DEFINE_MUTEX(mtrr_mutex);
>
> u64 size_or_mask, size_and_mask;
> @@ -121,11 +121,6 @@ static void __init init_table(void)
> 	int i, max;
>
> 	max = num_var_ranges;
> -	if ((usage_table = kmalloc(max * sizeof *usage_table, GFP_KERNEL))
> -	    == NULL) {
> -		printk(KERN_ERR "mtrr: could not allocate\n");
> -		return;
> -	}
> 	for (i = 0; i < max; i++)
> 		usage_table[i] = 1;
> }
> @@ -589,16 +584,11 @@ struct mtrr_value {
> 	unsigned long	lsize;
> };
>
> -static struct mtrr_value * mtrr_state;
> +static struct mtrr_value mtrr_state[MAX_VAR_RANGES];
>
> static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
> {
> 	int i;
> -	int size = num_var_ranges * sizeof(struct mtrr_value);
> -
> -	mtrr_state = kzalloc(size,GFP_ATOMIC);
> -	if (!mtrr_state)
> -		return -ENOMEM;
>
> 	for (i = 0; i < num_var_ranges; i++) {
> 		mtrr_if->get(i,
> @@ -620,7 +610,6 @@ static int mtrr_restore(struct sys_device * sysdev)
> 				 mtrr_state[i].lsize,
> 				 mtrr_state[i].ltype);
> 	}
> -	kfree(mtrr_state);
> 	return 0;
> }
>
> @@ -631,6 +620,57 @@ static struct sysdev_driver mtrr_sysdev_driver = {
> 	.resume		= mtrr_restore,
> };
>
> +static int disable_mtrr_trim;
> +
> +static int __init disable_mtrr_trim_setup(char *str)
> +{
> +	disable_mtrr_trim = 1;
> +	return 0;
> +}
> +early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
> +
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
> +	unsigned long i, base, size, highest_addr = 0, def, dummy;
> +	mtrr_type type;
> +
> +	/* Make sure we only trim uncachable memory on Intel machines */
> +	rdmsr(MTRRdefType_MSR, def, dummy);
> +	def &= 0xff;
> +	if (!use_intel() || disable_mtrr_trim || def != MTRR_TYPE_UNCACHABLE)
> +		return;
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
> /**
>  * mtrr_bp_init - initialize mtrrs on the boot CPU
> diff --git a/arch/i386/kernel/cpu/mtrr/mtrr.h b/arch/i386/kernel/cpu/mtrr/mtrr.h
> index 289dfe6..627b339 100644
> --- a/arch/i386/kernel/cpu/mtrr/mtrr.h
> +++ b/arch/i386/kernel/cpu/mtrr/mtrr.h
> @@ -14,6 +14,7 @@
> #define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
>
> #define NUM_FIXED_RANGES 88
> +#define MAX_VAR_RANGES 256
> #define MTRRfix64K_00000_MSR 0x250
> #define MTRRfix16K_80000_MSR 0x258
> #define MTRRfix16K_A0000_MSR 0x259
> @@ -34,6 +35,8 @@
>    an 8 bit field: */
> typedef u8 mtrr_type;
>
> +extern unsigned int usage_table[MAX_VAR_RANGES];
> +
> struct mtrr_ops {
> 	u32	vendor;
> 	u32	use_intel_if;
> diff --git a/arch/x86_64/kernel/bugs.c b/arch/x86_64/kernel/bugs.c
> index c3c6b91..c138eac 100644
> --- a/arch/x86_64/kernel/bugs.c
> +++ b/arch/x86_64/kernel/bugs.c
> @@ -14,7 +14,6 @@
> void __init check_bugs(void)
> {
> 	identify_cpu(&boot_cpu_data);
> -	mtrr_bp_init();
> #if !defined(CONFIG_SMP)
> 	printk("CPU: ");
> 	print_cpu_info(&boot_cpu_data);
> diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
> index eb6524f..409b63c 100644
> --- a/arch/x86_64/kernel/setup.c
> +++ b/arch/x86_64/kernel/setup.c
> @@ -266,6 +266,10 @@ void __init setup_arch(char **cmdline_p)
> 	 * we are rounding upwards:
> 	 */
> 	end_pfn = e820_end_of_ram();
> +	/* Trim memory not covered by WB MTRRs */
> +	mtrr_bp_init();
> +	mtrr_trim_uncached_memory();
> +
> 	num_physpages = end_pfn;
>
> 	check_efer();
> diff --git a/include/asm-x86_64/mtrr.h b/include/asm-x86_64/mtrr.h
> index b557c48..cc62bd8 100644
> --- a/include/asm-x86_64/mtrr.h
> +++ b/include/asm-x86_64/mtrr.h
> @@ -78,6 +78,7 @@ extern int mtrr_add_page (unsigned long base, unsigned long size,
> 		     unsigned int type, char increment);
> extern int mtrr_del (int reg, unsigned long base, unsigned long size);
> extern int mtrr_del_page (int reg, unsigned long base, unsigned long size);
> +extern void mtrr_trim_uncached_memory(void);
> #  else
> static __inline__ int mtrr_add (unsigned long base, unsigned long size,
> 				unsigned int type, char increment)
>
