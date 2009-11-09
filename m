Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZKIMNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZKIMNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZKIMNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:13:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49817 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbZKIMNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:13:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC PATCH] x86: make sure wakeup code is below 1M
Date: Mon, 9 Nov 2009 13:15:13 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <4AF7D820.5040503@kernel.org>
In-Reply-To: <4AF7D820.5040503@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091315.13151.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Yinghai Lu wrote:
> 
> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
> 
> to get area is below 1M
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I generally like it, two comments below.

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
> +extern void acpi_reserve_memory(void);

If you change the name of the function, IMO it would be better to call it
something like acpi_reserve_wakeup_memory().  This way it would be clear what
the memory is reserved for.
  
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
> + * acpi_reserve_memory - do _very_ early ACPI initialisation
>   *
>   * We allocate a page from the first 1MB of memory for the wakeup
>   * routine for when we come back from a sleep state. The
>   * runtime allocator allows specification of <16MB pages, but not
>   * <1MB pages.
>   */
> -void __init acpi_reserve_bootmem(void)
> +void __init acpi_reserve_memory(void)
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

Could we change the condition to avoid the "-1L" here?  It doesn't look very
nice.

>  		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
>  		return;
>  	}
> -
> -	acpi_wakeup_address = virt_to_phys((void *)acpi_realmode);
> +	acpi_realmode = (unsigned long) phys_to_virt(mem);
> +	acpi_wakeup_address = mem;
> +	reserve_early(mem, mem + WAKEUP_SIZE, "WAKEUP");
>  }

Thanks,
Rafael
