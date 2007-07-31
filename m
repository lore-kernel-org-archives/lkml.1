Return-Path: <linux-kernel-owner+w=401wt.eu-S1762975AbXGaNOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975AbXGaNOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762042AbXGaNLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:11:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57861 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762069AbXGaNLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:11:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [rft] Kill junk from s2ram resume paths
Date: Tue, 31 Jul 2007 15:20:27 +0200
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>,
       suspend-devel@lists.sourceforge.net, seife@suse.de
References: <20070731121246.GF2087@elf.ucw.cz>
In-Reply-To: <20070731121246.GF2087@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311520.28003.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 31 July 2007 14:12, Pavel Machek wrote:
> Hi!
> 
> This removes some stale debugging infrastructure from s2ram
> paths. Also, there's no need to verify_cpu on x86-64 -- cpu can't
> change during s2ram, and removed #if 0-ed code. Some testing would be
> useful, perpahs it will even fix someone's machine :-). (VGA accesses
> could theoretically hurt if vga is not present / if it is in some
> strange state).
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
> index 1415da1..9719bd6 100644
> --- a/arch/i386/kernel/acpi/wakeup.S
> +++ b/arch/i386/kernel/acpi/wakeup.S
> @@ -53,9 +38,6 @@ wakeup_code:
>  # Uncomment this to make your computer start producing ugly noise as soon
>  # as BIOS returns to this real-mode entry point.
>  #	BEEP
> - 	movw	$0xb800, %ax
> -	movw	%ax,%fs
> -	movw	$0x0e00 + 'L', %fs:(0x10)

Hmm, was this a part of that yellow "Linux" string?

>  	cli
>  	cld
> @@ -70,7 +52,6 @@ #	BEEP
>  	BEEP
>  1:
>  	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
> -	movw	$0x0e00 + 'S', %fs:(0x12)
>  
>  	pushl	$0						# Kill any dangerous flags
>  	popfl
> @@ -108,9 +89,6 @@ #	BEEP
>  	# make sure %cr4 is set correctly (features, etc)
>  	movl	real_save_cr4 - wakeup_code, %eax
>  	movl	%eax, %cr4
> -	movw	$0xb800, %ax
> -	movw	%ax,%fs
> -	movw	$0x0e00 + 'i', %fs:(0x12)

And this?

>  	# need a gdt -- use lgdtl to force 32-bit operands, in case
>  	# the GDT is located past 16 megabytes.
> @@ -120,8 +98,6 @@ #	BEEP
>  	movl	%eax, %cr0
>  	jmp 1f
>  1:
> -	movw	$0x0e00 + 'n', %fs:(0x14)
> -

And this?

>  	movl	real_magic - wakeup_code, %eax
>  	cmpl	$0x12345678, %eax
>  	jne	bogus_real_magic
> @@ -145,7 +121,6 @@ real_save_efer_edx: 	.long 0
>  real_save_efer_eax: 	.long 0
>  
>  bogus_real_magic:
> -	movw	$0x0e00 + 'B', %fs:(0x12)
>
>  	jmp bogus_real_magic
>  
>  /* This code uses an extended set of video mode numbers. These include:
> @@ -170,29 +145,9 @@ #define VIDEO_FIRST_V7 0x0900
>  # Setting of user mode (AX=mode ID) => CF=success
>  mode_set:
>  	movw	%ax, %bx
> -#if 0
> -	cmpb	$0xff, %ah
> -	jz	setalias
> -
> -	testb	$VIDEO_RECALC>>8, %ah
> -	jnz	_setrec
> -
> -	cmpb	$VIDEO_FIRST_RESOLUTION>>8, %ah
> -	jnc	setres
> -	
> -	cmpb	$VIDEO_FIRST_SPECIAL>>8, %ah
> -	jz	setspc
> -
> -	cmpb	$VIDEO_FIRST_V7>>8, %ah
> -	jz	setv7
> -#endif
>  	
>  	cmpb	$VIDEO_FIRST_VESA>>8, %ah
>  	jnc	check_vesa
> -#if 0	
> -	orb	%ah, %ah
> -	jz	setmenu
> -#endif
>  	
>  	decb	%ah
>  #	jz	setbios				  Add bios modes later
> @@ -232,7 +187,6 @@ wakeup_pmode_return:
>  	movw	%ax, %es
>  	movw	%ax, %fs
>  	movw	%ax, %gs
> -	movw	$0x0e00 + 'u', 0xb8016
>  
>  	# reload the gdt, as we need the full 32 bit address
>  	lgdt	saved_gdt
> diff --git a/arch/x86_64/kernel/acpi/wakeup.S b/arch/x86_64/kernel/acpi/wakeup.S
> index 13f1480..bc9af5d 100644
> --- a/arch/x86_64/kernel/acpi/wakeup.S
> +++ b/arch/x86_64/kernel/acpi/wakeup.S
> @@ -41,7 +41,6 @@ wakeup_code:
>  
>  # Running in *copy* of this code, somewhere in low 1MB.
>  
> -	movb	$0xa1, %al	;  outb %al, $0x80

Well, what was this for?

>  	cli
>  	cld
>  	# setup data segment
> @@ -65,11 +64,6 @@ # Running in *copy* of this code, somewh
>  	cmpl	$0x12345678, %eax
>  	jne	bogus_real_magic
>  
> -  	call	verify_cpu			# Verify the cpu supports long
> -						# mode
> -	testl	%eax, %eax
> -	jnz	no_longmode
> -

Yup, good idea.

>  	testl	$1, realmode_flags - wakeup_code
>  	jz	1f
>  	lcall   $0xc000,$3
> @@ -88,8 +82,6 @@ # Running in *copy* of this code, somewh
>  	movw	%ax,%fs
>  	movw	$0x0e00 + 'L', %fs:(0x10)

Why aren't you removing this line?

> -	movb	$0xa2, %al	;  outb %al, $0x80
> -	
>  	mov	%ds, %ax			# Find 32bit wakeup_code addr
>  	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
>  	shll    $4, %esi
> @@ -117,14 +109,10 @@ wakeup_32_vector:
>  	.code32
>  wakeup_32:
>  # Running in this code, but at low address; paging is not yet turned on.
> -	movb	$0xa5, %al	;  outb %al, $0x80
>
>  	movl	$__KERNEL_DS, %eax
>  	movl	%eax, %ds
>  
> -	movw	$0x0e00 + 'i', %ds:(0xb8012)
> -	movb	$0xa8, %al	;  outb %al, $0x80;
> -
>  	/*
>  	 * Prepare for entering 64bits mode
>  	 */
> @@ -200,16 +188,11 @@ wakeup_long64:
>  	 */
>  	lgdt	cpu_gdt_descr
>  
> -	movw	$0x0e00 + 'n', %ds:(0xb8014)
> -	movb	$0xa9, %al	;  outb %al, $0x80
> -
>  	movq    saved_magic, %rax
>  	movq    $0x123456789abcdef0, %rdx
>  	cmpq    %rdx, %rax
>  	jne     bogus_64_magic
>  
> -	movw	$0x0e00 + 'u', %ds:(0xb8016)
> -	
>  	nop
>  	nop
>  	movw	$__KERNEL_DS, %ax
> @@ -256,20 +239,12 @@ realmode_flags:	.quad 0
>  
>  .code16
>  bogus_real_magic:
> -	movb	$0xba,%al	;  outb %al,$0x80
>  	jmp bogus_real_magic
>  
>  .code64
>  bogus_64_magic:
> -	movb	$0xb3,%al	;  outb %al,$0x80
>  	jmp bogus_64_magic
>  
> -.code16
> -no_longmode:
> -	movb    $0xbc,%al       ;  outb %al,$0x80
> -	jmp no_longmode
> -
> -#include "../verify_cpu.S"
>  	
>  /* This code uses an extended set of video mode numbers. These include:
>   * Aliases for standard modes
> @@ -294,29 +269,9 @@ # Setting of user mode (AX=mode ID) => C
>  .code16
>  mode_seta:
>  	movw	%ax, %bx
> -#if 0
> -	cmpb	$0xff, %ah
> -	jz	setalias
> -
> -	testb	$VIDEO_RECALC>>8, %ah
> -	jnz	_setrec
> -
> -	cmpb	$VIDEO_FIRST_RESOLUTION>>8, %ah
> -	jnc	setres
> -	
> -	cmpb	$VIDEO_FIRST_SPECIAL>>8, %ah
> -	jz	setspc
> -
> -	cmpb	$VIDEO_FIRST_V7>>8, %ah
> -	jz	setv7
> -#endif
>  	
>  	cmpb	$VIDEO_FIRST_VESA>>8, %ah
>  	jnc	check_vesaa
> -#if 0	
> -	orb	%ah, %ah
> -	jz	setmenu
> -#endif
>  	
>  	decb	%ah
>  #	jz	setbios				  Add bios modes later
> 

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
