Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYBCXdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYBCXdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYBCXdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:33:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58714 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753656AbYBCXdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:33:03 -0500
Date: Mon, 4 Feb 2008 00:33:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: wakeup code translated to .c
Message-ID: <20080203233313.GF2799@elf.ucw.cz>
References: <20080130120111.GB22820@elf.ucw.cz> <20080203181648.GA1629@elf.ucw.cz> <200802032333.02821.rjw@sisk.pl> <200802040020.14836.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802040020.14836.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-04 00:20:14, Rafael J. Wysocki wrote:
> On Sunday, 3 of February 2008, Rafael J. Wysocki wrote:
> > On Sunday, 3 of February 2008, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > This version works on 32-bit, and builds on 64-bit (but I'm pretty
> > > > > sure it does not work. 32-bit code probably needs to go into rm/....)
> > > > > 
> > > > 
> > > > Do you have an updated version or is this the latest one?
> > > 
> > > I'm glad you ask ;-). Here's reasonably-recent version (I have
> > > slightly cleaner one, but it got obscured by 2.6.24-git merge), I
> > > eventually got it to work on 64-bit, by reusing trampoline.S code.
> > 
> > I needed to rebase it against the current mainline (Makefile conflict).
> > 
> > Some remarks:
> > 
> > - It looks like arch/x86/kernel/acpi/wakeup.S is not necessary any more.
> > 
> > - These warnings:
> > 
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c: In function ???acpi_save_state_mem???:
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:41: warning: initialization makes pointer from integer without a cast
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:50: warning: format ???%d??? expects type ???int???, but argument 2 has type ???long unsigned int???
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:50: warning: format ???%d??? expects type ???int???, but argument 3 has type ???long unsigned int???
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:70: warning: ISO C90 forbids mixed declarations and code
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:82: warning: assignment makes integer from pointer without a cast
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:83: warning: assignment makes integer from pointer without a cast
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:84: warning: ISO C90 forbids mixed declarations and code
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:87: warning: ISO C90 forbids mixed declarations and code
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:90: warning: assignment makes integer from pointer without a cast
> > /home/rafael/src/linux-2.6/arch/x86/kernel/acpi/sleep.c:91: warning: ISO C90 forbids mixed declarations and code
> > 
> > look pretty scary.
> 
> Below is the arch/x86/kernel/acpi/sleep.c part without the warnings (untested).
> 
> It still contains some hardcoded magic numbers and extern declarations, so
> I guess the #include list is not complete or another header is necessary.
> 
> BTW:
> 1) why exactly is acpi_wakeup_address not (void *)?

Well, it is physical address, not really a pointer.

> 2) header->level3_ident_pgt and header->level3_ident_pgt could be
(char *) IMO

Those are unused, they can be deleted ;-).
								Pavel

> --- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
> +++ linux-2.6/arch/x86/kernel/acpi/sleep.c
> @@ -11,29 +11,92 @@
>  #include <linux/cpumask.h>
>  
>  #include <asm/smp.h>
> +#include "rm/wakeup.h"
>  
>  /* address in low memory of the wakeup routine. */
> -unsigned long acpi_wakeup_address = 0;
> +static unsigned long acpi_realmode;
> +unsigned long acpi_wakeup_address;
>  unsigned long acpi_realmode_flags;
> -extern char wakeup_start, wakeup_end;
>  
> +extern char wakeup_code_start, wakeup_code_end;
>  extern unsigned long acpi_copy_wakeup_routine(unsigned long);
> +extern unsigned long setup_trampoline(void);
> +extern void wakeup_long64(void);
> +
> +extern unsigned long saved_video_mode;
> +extern long saved_magic;
> +extern char level3_ident_pgt[PAGE_SIZE];
> +extern char level3_kernel_pgt[PAGE_SIZE];
> +extern volatile unsigned long init_rsp;
> +extern void (*initial_code)(void);
> +#ifndef CONFIG_64BIT
> +extern int wakeup_pmode_return;
> +extern char swsusp_pg_dir[PAGE_SIZE];
> +#endif
> +
> +static char temp_stack[10240];
>  
>  /**
>   * acpi_save_state_mem - save kernel state
>   *
>   * Create an identity mapped page table and copy the wakeup routine to
>   * low memory.
> + *
> + * Note that this is too late to change acpi_wakeup_address.
>   */
>  int acpi_save_state_mem(void)
>  {
> -	if (!acpi_wakeup_address) {
> -		printk(KERN_ERR "Could not allocate memory during boot, S3 disabled\n");
> +	struct wakeup_header *header;
> +
> +	printk("acpi_save_state_mem\n");
> +
> +	if (!acpi_realmode) {
> +		printk(KERN_ERR "Could not allocate memory during boot, "
> +				"S3 disabled\n");
>  		return -ENOMEM;
>  	}
> -	memcpy((void *)acpi_wakeup_address, &wakeup_start,
> -	       &wakeup_end - &wakeup_start);
> -	acpi_copy_wakeup_routine(acpi_wakeup_address);
> +
> +	memcpy((void *)acpi_realmode, &wakeup_code_start, 4*PAGE_SIZE);
> +
> +	header = (struct wakeup_header *)(acpi_realmode + 0x3f00);
> +	if (header->signature != 0x51ee1111) {
> +		printk(KERN_ERR "wakeup header does not match\n");
> +		return -EINVAL;
> +	}
> +
> +	header->video_mode = saved_video_mode;
> +	printk("Video mode = %lu, realmode flags = %lu\n",
> +		saved_video_mode, acpi_realmode_flags);
> +	mdelay(1000);
> +
> +#ifndef CONFIG_64BIT
> +	store_gdt(&header->pmode_gdt);
> +
> +	header->pmode_efer_low = nx_enabled;
> +	if (header->pmode_efer_low & 1) {
> +		/* This is strange, why not save efer, always? */
> +		rdmsr(MSR_EFER, header->pmode_efer_low,
> +			header->pmode_efer_high);
> +	}
> +#endif /* !CONFIG_64BIT */
> +
> +	header->pmode_cr0 = read_cr0();
> +	header->pmode_cr4 = read_cr4();
> +	header->realmode_flags = acpi_realmode_flags;
> +	header->real_magic = 0x12345678;
> +
> +#ifndef CONFIG_64BIT
> +	header->pmode_entry = &wakeup_pmode_return;
> +	header->pmode_cr3 = swsusp_pg_dir - __PAGE_OFFSET;
> +	saved_magic = 0x12345678;
> +#else /* CONFIG_64BIT */
> +	header->level3_ident_pgt = (u64)level3_ident_pgt;
> +	header->level3_kernel_pgt = (u64)level3_kernel_pgt;
> +	header->trampoline_segment = setup_trampoline() >> 4;
> +	init_rsp = (unsigned long)temp_stack + 4096;
> +	initial_code = wakeup_long64;
> +	saved_magic = 0x123456789abcdef0;
> +#endif /* CONFIG_64BIT */
>  
>  	return 0;
>  }
> @@ -56,15 +119,20 @@ void acpi_restore_state_mem(void)
>   */
>  void __init acpi_reserve_bootmem(void)
>  {
> -	if ((&wakeup_end - &wakeup_start) > PAGE_SIZE*2) {
> +	if ((&wakeup_code_end - &wakeup_code_start) > PAGE_SIZE*4) {
>  		printk(KERN_ERR
>  		       "ACPI: Wakeup code way too big, S3 disabled.\n");
>  		return;
>  	}
>  
> -	acpi_wakeup_address = (unsigned long)alloc_bootmem_low(PAGE_SIZE*2);
> -	if (!acpi_wakeup_address)
> +	acpi_realmode = (unsigned long)alloc_bootmem_low(PAGE_SIZE*4);
> +
> +	if (!acpi_realmode) {
>  		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
> +		return;
> +	}
> +
> +	acpi_wakeup_address = acpi_realmode;
>  }
>  
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
