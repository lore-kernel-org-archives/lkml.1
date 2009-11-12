Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZKLQzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZKLQzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZKLQzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:55:20 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:54497 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZKLQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:55:14 -0500
X-Greylist: delayed 1549 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 11:55:14 EST
Date: Thu, 12 Nov 2009 08:36:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
Message-ID: <20091112073616.GA11365@elf.ucw.cz>
References: <4AF7D820.5040503@kernel.org>
 <200911091315.13151.rjw@sisk.pl>
 <4AFA210B.3020207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA210B.3020207@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-10 18:27:23, Yinghai Lu wrote:
> 
> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
> 
> to get area is below 1M

Does it fix anything? I can't tell from the changelog...

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Please CC me on suspend patches.
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

How is it better then old code?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
