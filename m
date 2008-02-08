Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYBHWDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYBHWDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYBHWDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:03:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbYBHWDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:03:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Fri, 8 Feb 2008 23:01:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20080205190600.GB11613@elf.ucw.cz> <47AB887E.7010000@zytor.com> <20080208215809.GN12923@elf.ucw.cz>
In-Reply-To: <20080208215809.GN12923@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802082301.51582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 8 of February 2008, Pavel Machek wrote:
> Hi!
> 
> Rafael, this is for you.

Thanks.

> My cleanups, relative to your cleanup patch. You may need manual patching
> around rep/stosd.

OK, I'll try to merge it.

Rafael


> diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
> index b239f0f..0e4742b 100644
> --- a/arch/x86/kernel/acpi/realmode/Makefile
> +++ b/arch/x86/kernel/acpi/realmode/Makefile
> @@ -46,7 +46,10 @@ KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__AS
>  WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
>  
>  LDFLAGS_wakeup.elf	:= -T
> -$(obj)/wakeup.elf: $(src)/wakeup.ld $(WAKEUP_OBJS) FORCE
> +
> +CPPFLAGS_wakeup.lds += -P -C
> +
> +$(obj)/wakeup.elf: $(src)/wakeup.lds $(WAKEUP_OBJS) FORCE
>  	$(call if_changed,ld)
>  
>  OBJCOPYFLAGS_wakeup.bin	:= -O binary
> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
> index 26145c0..edff763 100644
> --- a/arch/x86/kernel/acpi/realmode/wakeup.S
> +++ b/arch/x86/kernel/acpi/realmode/wakeup.S
> @@ -56,14 +56,6 @@ _start:
>  	cmpl	$0x65a22c82, %eax
>  	jne	bogus_real_magic
>  
> -	/* Zero the bss */
> -	xorl	%eax, %eax
> -	movw	$__bss_start, %di
> -	movw	$__bss_end + 3, %cx
> -	subw	%di, %cx
> -	shrw	$2, %cx
> -	rep; stosl
> -
>  	/* Call the C code */
>  	calll	main
>  
> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
> index 4a26e27..6a49435 100644
> --- a/arch/x86/kernel/acpi/realmode/wakeup.h
> +++ b/arch/x86/kernel/acpi/realmode/wakeup.h
> @@ -6,12 +6,11 @@
>  #ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
>  #define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
>  
> +#ifndef __ASSEMBLY__
>  #include <linux/types.h>
>  
>  /* This must match data at wakeup.S */
>  struct wakeup_header {
> -	u16 entry;		/* unused */
> -	u16 total;		/* unused */
>  	u16 video_mode;		/* Video mode number */
>  	u16 _jmp1;
>  	u32 pmode_entry;	/* Protected mode resume point */
> @@ -27,5 +26,10 @@ struct wakeup_header {
>  	u16 trampoline_segment;
>  	u32 signature;		/* To check we have correct structure */
>  } __attribute__((__packed__));
> +#endif
> +
> +#define HEADER_OFFSET 0x3f00
> +#define WAKEUP_SIZE   0x4000
> +
>  
>  #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.ld b/arch/x86/kernel/acpi/realmode/wakeup.ld
> deleted file mode 100644
> index 5dff2f0..0000000
> --- a/arch/x86/kernel/acpi/realmode/wakeup.ld
> +++ /dev/null
> @@ -1,51 +0,0 @@
> -/*
> - * wakeup.ld
> - *
> - * Linker script for the real-mode wakeup code
> - */
> -OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
> -OUTPUT_ARCH(i386)
> -ENTRY(_start)
> -
> -SECTIONS
> -{
> -	. = 0x3f00;
> -	.header		: { *(.header) }
> -
> -	. = 0;
> -	.text		: { *(.text*) }
> -
> -	. = ALIGN(16);
> -	.rodata		: { *(.rodata*) }
> -
> -	.videocards	: {
> -		video_cards = .;
> -		*(.videocards)
> -		video_cards_end = .;
> -	}
> -
> -	. = ALIGN(16);
> -	.data		: { *(.data*) }
> -
> -	.signature	: {
> -		end_signature = .;
> -		LONG(0x65a22c82)
> -	}
> -
> -	. = ALIGN(16);
> -	.bss		:
> -	{
> -		__bss_start = .;
> -		*(.bss)
> -		__bss_end = .;
> -	}
> -
> -	. = ALIGN(16);
> -	_end = .;
> -
> -	/DISCARD/ : { *(.note*) }
> -
> -	/* Adjust this as appropriate */
> -	/* This allows 4 pages (16K) */
> -	. = ASSERT(_end <= 0x4000, "Wakeup too big!");
> -}
> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> new file mode 100644
> index 0000000..22fab6c
> --- /dev/null
> +++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> @@ -0,0 +1,61 @@
> +/*
> + * wakeup.ld
> + *
> + * Linker script for the real-mode wakeup code
> + */
> +#undef i386
> +#include "wakeup.h"
> +
> +OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
> +OUTPUT_ARCH(i386)
> +ENTRY(_start)
> +
> +SECTIONS
> +{
> +	. = HEADER_OFFSET;
> +	.header : {
> +		 *(.header)
> +	}
> +
> +	. = 0;
> +	.text : {
> +		 *(.text*)
> +	}
> +
> +	. = ALIGN(16);
> +	.rodata : {
> +		*(.rodata*)
> +	}
> +
> +	.videocards : {
> +		video_cards = .;
> +		*(.videocards)
> +		video_cards_end = .;
> +	}
> +
> +	. = ALIGN(16);
> +	.data : {
> +		 *(.data*)
> +	}
> +
> +	.signature : {
> +		end_signature = .;
> +		LONG(0x65a22c82)
> +	}
> +
> +	. = ALIGN(16);
> +	.bss :	{
> +		__bss_start = .;
> +		*(.bss)
> +		__bss_end = .;
> +	}
> +
> +	. = ALIGN(16);
> +	_end = .;
> +
> +	/DISCARD/ : {
> +		*(.note*)
> +	}
> +
> +	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
> +}
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 1b282b1..561565e 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -53,9 +53,9 @@ int acpi_save_state_mem(void)
>  		       "S3 disabled\n");
>  		return -ENOMEM;
>  	}
> -	memcpy((void *)acpi_realmode, &wakeup_code_start, 4*PAGE_SIZE);
> +	memcpy((void *)acpi_realmode, &wakeup_code_start, WAKEUP_SIZE);
>  
> -	header = (struct wakeup_header *)(acpi_realmode + 0x3f00);
> +	header = (struct wakeup_header *)(acpi_realmode + HEADER_OFFSET);
>  	if (header->signature != 0x51ee1111) {
>  		printk(KERN_ERR "wakeup header does not match\n");
>  		return -EINVAL;
> @@ -111,13 +111,13 @@ void acpi_restore_state_mem(void)
>   */
>  void __init acpi_reserve_bootmem(void)
>  {
> -	if ((&wakeup_code_end - &wakeup_code_start) > PAGE_SIZE*4) {
> +	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
>  		printk(KERN_ERR
>  		       "ACPI: Wakeup code way too big, S3 disabled.\n");
>  		return;
>  	}
>  
> -	acpi_realmode = (unsigned long)alloc_bootmem_low(PAGE_SIZE*4);
> +	acpi_realmode = (unsigned long)alloc_bootmem_low(WAKEUP_SIZE);
>  
>  	if (!acpi_realmode) {
>  		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
