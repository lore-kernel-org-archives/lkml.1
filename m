Return-Path: <linux-kernel-owner+w=401wt.eu-S1764472AbYB1VKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764472AbYB1VKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbYB1VKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:10:33 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:14105 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbYB1VKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:10:32 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080228131341.GA25213@mailshack.com>
References: <20080224174605.GA21661@mailshack.com>
	 <47C22568.1010405@zytor.com>
	 <1203958478.20033.1239002461@webmail.messagingengine.com>
	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 21:09:56 +0000
Message-Id: <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 14:13 +0100, Alexander van Heukelum wrote:
> The 32-bit code still uses reserve_bootmem, so this is not really
> a unification with the 64-bit version of the ebda reservation code,
> but at least it provides the same detection logic and reserves the
> same areas.
> 
> This does not crash immediately on qemu. No further testing was
> done! Otherwise:

I haven't tested extensively either but it does seem to solve the
problem for Xen.

Thanks!
Ian

> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> ---
> 
> Hello Ian, Ingo,
> 
> This patch should do the same reservations as the reserve_early
> patch for 64 bit. Maybe you could try if this solves the problems
> you are seeing with Xen?
> 
> On the other hand, Xen should be able to use those legacy ranges
> as normal memory. Why doesn't it work? Does Xen use a special
> bootloader? In that case it could just add the reservation to
> the e820 memory map that is provided.
> 
> Another possible approach to the whole problem is just to ammend
> the e820 memory map in the boot-code. Thanks to hpa, it is now easy
> to change this code. Then the kernel can just trust the e820 memory
> map, and only 'sophisticated' bootloaders need to do something
> similar by themselves.
> 
> Greetings,
>     Alexander
> 
> diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
> index a1d7071..e12cc31 100644
> --- a/arch/x86/kernel/setup_32.c
> +++ b/arch/x86/kernel/setup_32.c
> @@ -385,15 +385,47 @@ unsigned long __init find_max_low_pfn(void)
>  	return max_low_pfn;
>  }
>  
> +#define BIOS_EBDA_SEGMENT 0x40E
> +#define BIOS_LOWMEM_KILOBYTES 0x413
> +
>  /*
> - * workaround for Dell systems that neglect to reserve EBDA
> + * The BIOS places the EBDA/XBDA at the top of conventional
> + * memory, and usually decreases the reported amount of
> + * conventional memory (int 0x12) too. This also contains a
> + * workaround for Dell systems that neglect to reserve EBDA.
> + * The same workaround also avoids a problem with the AMD768MPX
> + * chipset: reserve a page before VGA to prevent PCI prefetch
> + * into it (errata #56). Usually the page is reserved anyways,
> + * unless you have no PS/2 mouse plugged in.
>   */
>  static void __init reserve_ebda_region(void)
>  {
> -	unsigned int addr;
> -	addr = get_bios_ebda();
> -	if (addr)
> -		reserve_bootmem(addr, PAGE_SIZE, BOOTMEM_DEFAULT);
> +	unsigned int lowmem, ebda_addr;
> +
> +	/* end of low (conventional) memory */
> +	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
> +	lowmem <<= 10;
> +
> +	/* start of EBDA area */
> +	ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
> +	ebda_addr <<= 4;
> +
> +	/* Fixup: bios puts an EBDA in the top 64K segment */
> +	/* of conventional memory, but does not adjust lowmem. */
> +	if ((lowmem - ebda_addr) <= 0x10000)
> +		lowmem = ebda_addr;
> +
> +	/* Fixup: bios does not report an EBDA at all. */
> +	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
> +	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
> +		lowmem = 0x9f000;
> +
> +	/* Paranoia: should never happen, but... */
> +	if (lowmem >= 0x100000)
> +		lowmem = 0xa0000;
> +
> +	/* reserve all memory between lowmem and the 1MB mark */
> +	reserve_bootmem(lowmem, 0x100000 - lowmem, BOOTMEM_DEFAULT);
>  }
>  
>  #ifndef CONFIG_NEED_MULTIPLE_NODES
> @@ -619,16 +651,9 @@ void __init setup_bootmem_allocator(void)
>  	 */
>  	reserve_bootmem(0, PAGE_SIZE, BOOTMEM_DEFAULT);
>  
> -	/* reserve EBDA region, it's a 4K region */
> +	/* reserve EBDA region */
>  	reserve_ebda_region();
>  
> -    /* could be an AMD 768MPX chipset. Reserve a page  before VGA to prevent
> -       PCI prefetch into it (errata #56). Usually the page is reserved anyways,
> -       unless you have no PS/2 mouse plugged in. */
> -	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
> -	    boot_cpu_data.x86 == 6)
> -	     reserve_bootmem(0xa0000 - 4096, 4096, BOOTMEM_DEFAULT);
> -
>  #ifdef CONFIG_SMP
>  	/*
>  	 * But first pinch a few for the stack/trampoline stuff
> 
-- 
Ian Campbell

In spite of everything, I still believe that people are good at heart.
		-- Anne Frank

