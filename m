Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZKKJOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZKKJOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZKKJOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:14:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:46447 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZKKJOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:14:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,722,1249282800"; 
   d="scan'208";a="745865250"
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
From: ykzhao <yakui.zhao@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <4AFA210B.3020207@kernel.org>
References: <4AF7D820.5040503@kernel.org> <200911091315.13151.rjw@sisk.pl>
	 <4AFA210B.3020207@kernel.org>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Wed, 11 Nov 2009 17:12:47 +0800
Message-Id: <1257930767.31183.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 10:27 +0800, Yinghai Lu wrote:
> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
> 
> to get area is below 1M
> 
> -v2: change function name to acpi_reserve_wakeup_memory according to Rafael
It seems that the function of find_e820_area is called in several
places.
   >Initmem_init: bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT,
bootmap_size, PAGE_SIZE);
   
If we also call it in the acpi_reserve_wakeup_memory, do we get the same
base address as that obtained in initmem_init?

Thanks.

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/acpi.h  |    2 +-
>  arch/x86/kernel/acpi/sleep.c |   15 +++++++++------
>  arch/x86/kernel/setup.c      |   13 +++++++------
>  3 files changed, 17 insertions(+), 13 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/acpi.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/acpi.h
> +++ linux-2.6/arch/x86/include/asm/acpi.h
> @@ -118,7 +118,7 @@ extern void acpi_restore_state_mem(void)
>  extern unsigned long acpi_wakeup_address;
>  
>  /* early initialization routine */
> -extern void acpi_reserve_bootmem(void);
> +extern void acpi_reserve_wakeup_memory(void);
>  
>  /*
>   * Check if the CPU can handle C2 and deeper
> Index: linux-2.6/arch/x86/kernel/acpi/sleep.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
> +++ linux-2.6/arch/x86/kernel/acpi/sleep.c
> @@ -119,29 +119,32 @@ void acpi_restore_state_mem(void)
>  
> 
>  /**
> - * acpi_reserve_bootmem - do _very_ early ACPI initialisation
> + * acpi_reserve_wakeup_memory - do _very_ early ACPI initialisation
>   *
>   * We allocate a page from the first 1MB of memory for the wakeup
>   * routine for when we come back from a sleep state. The
>   * runtime allocator allows specification of <16MB pages, but not
>   * <1MB pages.
>   */
> -void __init acpi_reserve_bootmem(void)
> +void __init acpi_reserve_wakeup_memory(void)
>  {
> +	unsigned long mem;
> +
>  	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
>  		printk(KERN_ERR
>  		       "ACPI: Wakeup code way too big, S3 disabled.\n");
>  		return;
>  	}
>  
> -	acpi_realmode = (unsigned long)alloc_bootmem_low(WAKEUP_SIZE);
> +	mem = find_e820_area(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
>  
> -	if (!acpi_realmode) {
> +	if (mem == -1L) {
>  		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
>  		return;
>  	}
> -
> -	acpi_wakeup_address = virt_to_phys((void *)acpi_realmode);
> +	acpi_realmode = (unsigned long) phys_to_virt(mem);
> +	acpi_wakeup_address = mem;
> +	reserve_early(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
>  }
>  
> 
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -905,6 +905,13 @@ void __init setup_arch(char **cmdline_p)
>  
>  	reserve_brk();
>  
> +#ifdef CONFIG_ACPI_SLEEP
> +	/*
> +	 * Reserve low memory region for sleep support.
> +	 * even before init_memory_mapping
> +	 */
> +	acpi_reserve_wakeup_memory();
> +#endif
>  	init_gbpages();
>  
>  	/* max_pfn_mapped is updated here */
> @@ -956,12 +963,6 @@ void __init setup_arch(char **cmdline_p)
>  
>  	initmem_init(0, max_pfn, acpi, k8);
>  
> -#ifdef CONFIG_ACPI_SLEEP
> -	/*
> -	 * Reserve low memory region for sleep support.
> -	 */
> -	acpi_reserve_bootmem();
> -#endif
>  	/*
>  	 * Find and reserve possible boot-time SMP configuration:
>  	 */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

