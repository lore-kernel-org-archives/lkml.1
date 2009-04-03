Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbZDCR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbZDCR2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761167AbZDCR2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:28:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35698 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZDCR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:28:33 -0400
Date: Fri, 3 Apr 2009 19:28:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH v2] x86: access to efi reserved memory type
Message-ID: <20090403172814.GN19982@elte.hu>
References: <E1LoP6G-0001i2-N4@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LoP6G-0001i2-N4@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> Replaces version 1 of this patch:
> http://marc.info/?l=linux-kernel&m=123792413205578&w=2
> 
> Create a new e820 memory type (E820_VENDOR_RESERVED) for areas
> of memory reserved by the BIOS.
> (An example use of this functionality is the coming UV system, which
>  will access extremely large areas of memory with a memory engine
>  that allows a user to address beyond the processor's range.)
> 
> The EFI type EFI_RESERVED_TYPE memory reservations are passed to the
> e820 table as type E820_VENDOR_RESERVED ranges.
> 
> [The elilo loader may combine regions of like type as it builds the e820
>  table in boot_params (regular RAM and vendor reserved areas are combined).
>  But do_add_efi_memmap() separates the RESERVED regions into separate
>  e820 entries.]
> 
> The call to do_add_efi_memmap() is only made if "add_efi_memmap" is specified
> on the kernel command line.
> 
> This patch also provides an exported function to allow a driver to find e820
> entries of a specified type.
> 
> [
>  Version 1 accessed these regions from the EFI table.  A major problem with
>  that patch is that if "add_efi_memmap" is not specified on the boot command
>  line, the EFI table is not merged into the e820, so the kernel also uses
>  these regions for regular memory.  Then subsequent use of the regions by
>  the driver corrupts system or user memory, which causes a head-scratcher
>  of a panic or of user exceptions.
>  With this version no reserved regions are visible to the calling driver
>  if that boot option is not specified.
> ]
> 
> Diffed against 2.6.29-rc7
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> 
> ---
>  arch/x86/include/asm/e820.h |    2 ++
>  arch/x86/kernel/e820.c      |   34 +++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/efi.c       |    4 +++-
>  3 files changed, 38 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/kernel/e820.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/e820.c
> +++ linux/arch/x86/kernel/e820.c
> @@ -74,6 +74,33 @@ e820_any_mapped(u64 start, u64 end, unsi
>  EXPORT_SYMBOL_GPL(e820_any_mapped);
>  
>  /*
> + * This function returns the start (and end) of any range lying within the
> + * range <start,end> of a given type.
> + * Returns 0xffffffffffffffff if there is no such range of that type.
> + */
> +u64
> +e820_mapped_type(u64 start, u64 end, unsigned type, u64 *returned_end)
> +{
> +	int i;
> +
> +	if (returned_end == NULL)
> +		return 0xffffffffffffffffUL;
> +
> +	for (i = 0; i < e820.nr_map; i++) {
> +		struct e820entry *ei = &e820.map[i];
> +
> +		if (type && ei->type != type)
> +			continue;
> +		if (ei->addr >= end || ei->addr + ei->size <= start)
> +			continue;
> +		*returned_end = ei->addr + ei->size;
> +		return ei->addr;;
> +	}
> +	return 0xffffffffffffffffUL;

hm, will this compile fine on 32-bit?

> +}
> +EXPORT_SYMBOL_GPL(e820_mapped_type);
> +
> +/*
>   * This function checks if the entire range <start,end> is mapped with type.
>   *
>   * Note: this function only works correct if the e820 table is sorted and
> @@ -142,6 +169,9 @@ void __init e820_print_map(char *who)
>  		case E820_RESERVED:
>  			printk(KERN_CONT "(reserved)\n");
>  			break;
> +		case E820_VENDOR_RESERVED:
> +			printk(KERN_CONT "(vendor reserved)\n");
> +			break;
>  		case E820_ACPI:
>  			printk(KERN_CONT "(ACPI data)\n");
>  			break;
> @@ -343,8 +373,10 @@ int __init sanitize_e820_map(struct e820
>  		/*
>  		 * continue building up new bios map based on this
>  		 * information
> +		 * (do not consolidate the E820_VENDOR_RESERVED ranges)
>  		 */
> -		if (current_type != last_type)	{
> +		if ((current_type != last_type) ||
> +		    (current_type == E820_VENDOR_RESERVED)) {
>  			if (last_type != 0)	 {
>  				new_bios[new_bios_entry].size =
>  					change_point[chgidx]->addr - last_addr;
> Index: linux/arch/x86/kernel/efi.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/efi.c
> +++ linux/arch/x86/kernel/efi.c
> @@ -240,7 +240,9 @@ static void __init do_add_efi_memmap(voi
>  		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
>  		int e820_type;
>  
> -		if (md->attribute & EFI_MEMORY_WB)
> +		if (md->type == EFI_RESERVED_TYPE)
> +			e820_type = E820_VENDOR_RESERVED;
> +		else if (md->attribute & EFI_MEMORY_WB)
>  			e820_type = E820_RAM;
>  		else
>  			e820_type = E820_RESERVED;
> Index: linux/arch/x86/include/asm/e820.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/e820.h
> +++ linux/arch/x86/include/asm/e820.h
> @@ -44,6 +44,7 @@
>  #define E820_ACPI	3
>  #define E820_NVS	4
>  #define E820_UNUSABLE	5
> +#define E820_VENDOR_RESERVED 6

But this now looks like a reasonably clean extension.

Peter, what do you think?

	Ingo
