Return-Path: <linux-kernel-owner+w=401wt.eu-S935237AbYBGWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935237AbYBGWjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759869AbYBGWjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:39:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbYBGWjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:39:05 -0500
Message-ID: <47AB887E.7010000@zytor.com>
Date: Thu, 07 Feb 2008 14:38:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <200802070049.00461.rjw@sisk.pl> <200802072312.31430.rjw@sisk.pl>
In-Reply-To: <200802072312.31430.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.S
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.S
> @@ -0,0 +1,122 @@
> +/*
> + * ACPI wakeup real mode startup stub
> + */
> +#include <asm/segment.h>
> +#include <asm/msr-index.h>
> +#include <asm/page_64.h>
> +#include <asm/pgtable_64.h>
> +
> +	.code16
> +	.section ".header", "a"
> +
> +/* This should match the structure in wakeup.h */
> +		.globl	wakeup_header
> +wakeup_header:
> +video_mode:	.short	0	/* Video mode number */
> +pmode_return:	.byte	0x66, 0xea	/* ljmpl */
> +		.long	0	/* offset goes here */
> +		.short	__KERNEL_CS

Missing a .short pad here... Pavel fixed that at some point, I thought.

> +pmode_cr0:	.long	0	/* Saved %cr0 */
> +pmode_cr3:	.long	0	/* Saved %cr3 */
> +pmode_cr4:	.long	0	/* Saved %cr4 */
> +pmode_efer:	.quad	0	/* Saved EFER */
> +pmode_gdt:	.quad	0
> +realmode_flags:	.long	0
> +real_magic:	.long	0
> +trampoline_segment:	.word 0
> +signature:	.long	0x51ee1111
> +
> +	.text
> +	.globl	_start
> +	.code16
> +wakeup_code:
> +_start:
> +	cli
> +	cld
> +
> +	/* Set up segments */
> +	movw	%cs, %ax
> +	movw	%ax, %ds
> +	movw	%ax, %es
> +	movw	%ax, %ss
> +
> +	movl	$wakeup_stack_end, %esp
> +
> +	/* Clear the EFLAGS */
> +	pushl	$0
> +	popfl
> +
> +	/* Check header signature... */
> +	movl	signature, %eax
> +	cmpl	$0x51ee1111, %eax
> +	jne	bogus_real_magic
> +
> +	/* Check we really have everything... */
> +	movl	end_signature, %eax
> +	cmpl	$0x65a22c82, %eax
> +	jne	bogus_real_magic
> +
> +	/* Zero the bss */
> +	xorl	%eax, %eax
> +	movw	$__bss_start, %di
> +	movw	$__bss_end + 3, %cx
> +	subw	%di, %cx
> +	shrw	$2, %cx
> +	rep
> +	stosl
> +
> +	/* Call the C code */
> +	calll	main
> +
> +	/* Do any other stuff... */
> +
> +#ifndef CONFIG_64BIT
> +	/* This could also be done in C code... */
> +	movl	pmode_cr3, %eax
> +	movl	%eax, %cr3
> +
> +	movl	pmode_cr4, %ecx
> +	jecxz	1f
> +	movl	%ecx, %cr4
> +1:
> +	movl	pmode_efer, %eax
> +	movl	pmode_efer + 4, %edx
> +	movl	%eax, %ecx
> +	orl	%edx, %ecx
> +	jz	1f
> +	movl	$0xc0000080, %ecx
> +	wrmsr
> +1:
> +
> +	lgdtl	pmode_gdt
> +
> +	/* This really couldn't... */
> +	movl	pmode_cr0, %eax
> +	movl	%eax, %cr0
> +	jmp	pmode_return
> +#else
> +	pushw	$0
> +	pushw	trampoline_segment
> +	pushw	$0
> +	lret
> +#endif
> +
> +bogus_real_magic:
> +1:
> +	hlt
> +	jmp	1b
> +
> +	.data
> +	.balign	4
> +	.globl	HEAP, heap_end
> +HEAP:
> +	.long	wakeup_heap
> +heap_end:
> +	.long	wakeup_stack
> +
> +	.bss
> +wakeup_heap:
> +	.space	2048
> +wakeup_stack:
> +	.space	2048
> +wakeup_stack_end:
> Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.h
> @@ -0,0 +1,29 @@
> +/*
> + * Definitions for the wakeup data structure at the head of the
> + * wakeup code.
> + */
> +
> +#ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
> +#define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
> +
> +#include <linux/types.h>
> +
> +/* This must match data at wakeup.S */
> +struct wakeup_header {
> +	u16 video_mode;		/* Video mode number */
> +	u16 _jmp1;		/* ljmpl opcode, 32-bit only */
> +	u32 pmode_entry;	/* Protected mode resume point, 32-bit only */
> +	u16 _jmp2;		/* CS value, 32-bit only */
> +	u32 pmode_cr0;		/* Protected mode cr0 */
> +	u32 pmode_cr3;		/* Protected mode cr3 */
> +	u32 pmode_cr4;		/* Protected mode cr4 */
> +	u32 pmode_efer_low;	/* Protected mode EFER */
> +	u32 pmode_efer_high;
> +	u64 pmode_gdt;
> +	u32 realmode_flags;
> +	u32 real_magic;
> +	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
> +	u32 signature;		/* To check we have correct structure */
> +} __attribute__((__packed__));
> +
> +#endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
> Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.ld
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.ld
> @@ -0,0 +1,51 @@
> +/*
> + * wakeup.ld
> + *
> + * Linker script for the real-mode wakeup code
> + */
> +OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
> +OUTPUT_ARCH(i386)
> +ENTRY(_start)
> +
> +SECTIONS
> +{
> +	. = 0x3f00;
> +	.header		: { *(.header) }
> +
> +	. = 0;
> +	.text		: { *(.text*) }
> +
> +	. = ALIGN(16);
> +	.rodata		: { *(.rodata*) }
> +
> +	.videocards	: {
> +		video_cards = .;
> +		*(.videocards)
> +		video_cards_end = .;
> +	}
> +
> +	. = ALIGN(16);
> +	.data		: { *(.data*) }
> +
> +	.signature	: {
> +		end_signature = .;
> +		LONG(0x65a22c82)
> +	}
> +
> +	. = ALIGN(16);
> +	.bss		:
> +	{
> +		__bss_start = .;
> +		*(.bss)
> +		__bss_end = .;
> +	}
> +
> +	. = ALIGN(16);
> +	_end = .;
> +
> +	/DISCARD/ : { *(.note*) }
> +
> +	/* Adjust this as appropriate */
> +	/* This allows 4 pages (16K) */
> +	. = ASSERT(_end <= 0x4000, "Wakeup too big!");
> +}
> Index: linux-2.6/arch/x86/kernel/acpi/sleep.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
> +++ linux-2.6/arch/x86/kernel/acpi/sleep.c
> @@ -11,29 +11,84 @@
>  #include <linux/cpumask.h>
>  
>  #include <asm/smp.h>
> +#include "realmode/wakeup.h"
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
> +extern volatile unsigned long init_rsp;
> +extern void (*initial_code)(void);
> +#ifndef CONFIG_64BIT
> +extern int wakeup_pmode_return;
> +extern char swsusp_pg_dir[PAGE_SIZE];
> +#else
> +static char temp_stack[10240];
> +#endif
> +
> +extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
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
> +	if (!acpi_realmode) {
> +		printk(KERN_ERR "Could not allocate memory during boot, "
> +		       "S3 disabled\n");
>  		return -ENOMEM;
>  	}
> -	memcpy((void *)acpi_wakeup_address, &wakeup_start,
> -	       &wakeup_end - &wakeup_start);
> -	acpi_copy_wakeup_routine(acpi_wakeup_address);
> +	memcpy((void *)acpi_realmode, &wakeup_code_start, 4*PAGE_SIZE);

Using a PAGE_SIZE multiplier here isn't a good thing...

> +	header = (struct wakeup_header *)(acpi_realmode + 0x3f00);

... especially not with magic constants like this.

If you're putting the "header" at the end, then you should also replace 
the end_signature stuff since that's, then, redundant.  Furthermore, by 
doing so, you're also padding the binary out to its maximum length, so 
you might as well just remove the .bss-clearing stuff.

It's not really clear to me why to do this what way...

> +	if (header->signature != 0x51ee1111) {
> +		printk(KERN_ERR "wakeup header does not match\n");
> +		return -EINVAL;
> +	}
> +
> +	header->video_mode = saved_video_mode;
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

Yes, why not save EFER every time?

	-hpa
