Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYE0DLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYE0DLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 23:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYE0DLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 23:11:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:7292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbYE0DLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 23:11:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,546,1204531200"; 
   d="scan'208";a="568950090"
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI
	memory entries to kernel
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
	 <20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 27 May 2008 11:12:28 +0800
Message-Id: <1211857948.12819.84.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 27 May 2008 03:11:11.0080 (UTC) FILETIME=[507BE680:01C8BFA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul,

Sorry for my late. I am busy on something other these days.

Because EFI memory map are converted to E820 memory map in boot loader
if the converted E820 entry number is below 128 now, I think it is
better to do all the conversion in boot loader. The limitation lies in
the size of struct boot_params (zero page), which is 4k. But there is an
extension to struct boot_params named linked list of struct setup_data
in a previous patch:

http://lkml.org/lkml/2008/3/27/26

With the help of linked list of struct setup_data, the E820 memory map
with more than 128 entries in EFI system can be passed to kernel as
follow.

1. In boot loader, EFI memory map is converted to E820 memory map A
2. The low 128 map entries of map A is copied to e820_map of struct
boot_params.
3. A setup_data struct is constructed to hold the other E820 entries.

4. In Linux kernel, the E820 map entries from both struct boot_params
and setup_data are used.

Best Regards,
Huang Ying

On Wed, 2008-05-14 at 08:15 -0700, Paul Jackson wrote:
> From: Paul Jackson <pj@sgi.com>
> 
> Add to the kernels boot memory map 'memmap' entries found in
> the EFI memory descriptors passed in from the BIOS.
> 
> On EFI systems, up to E820MAX == 128 memory map entries can
> be passed via the legacy E820 interface (limited by the size
> of the 'zeropage').  These entries can be duplicated in the
> EFI descriptors also passed from the BIOS, and possibly more
> entries passed by the EFI interface, which does not have the
> E820MAX limit on number of memory map entries.
> 
> This code doesn't worry about the likely duplicate, overlapping
> or (unlikely) conflicting entries between the EFI map and the
> E820 map.  It just dumps all the EFI entries into the memmap[]
> array (which already has the E820 entries) and lets the existing
> routine sanitize_e820_map() sort the mess out.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> 
> ---
>  arch/x86/kernel/efi.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> --- linux.orig/arch/x86/kernel/efi.c	2008-05-06 06:44:32.332774433 -0700
> +++ linux/arch/x86/kernel/efi.c	2008-05-06 06:55:20.767816417 -0700
> @@ -213,6 +213,31 @@ unsigned long efi_get_time(void)
>  		      eft.minute, eft.second);
>  }
>  
> +/*
> + * Tell the kernel about the EFI memory map.  This might include
> + * more than the max 128 entries that can fit in the e820 legacy
> + * (zeropage) memory map.
> + */
> +
> +static void __init add_efi_memmap(void)
> +{
> +	void *p;
> +
> +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +		efi_memory_desc_t *md = p;
> +		unsigned long long start = md->phys_addr;
> +		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> +		int e820_type;
> +
> +		if (md->attribute & EFI_MEMORY_WB)
> +			e820_type = E820_RAM;
> +		else
> +			e820_type = E820_RESERVED;
> +		add_memory_region(start, size, e820_type);
> +	}
> +	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
> +}
> +
>  #if EFI_DEBUG
>  static void __init print_efi_memmap(void)
>  {
> @@ -370,6 +395,7 @@ void __init efi_init(void)
>  	if (memmap.desc_size != sizeof(efi_memory_desc_t))
>  		printk(KERN_WARNING "Kernel-defined memdesc"
>  		       "doesn't match the one from EFI!\n");
> +	add_efi_memmap();
>  
>  	/* Setup for EFI runtime service */
>  	reboot_type = BOOT_EFI;
> 
