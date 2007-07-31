Return-Path: <linux-kernel-owner+w=401wt.eu-S1762490AbXGaOBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490AbXGaOBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXGaOBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:01:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58148 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755324AbXGaOBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:01:42 -0400
Date: Tue, 31 Jul 2007 16:01:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: suspend-devel@lists.sourceforge.net, seife@suse.de,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [rft] Kill junk from s2ram resume paths
Message-ID: <20070731140140.GJ2087@elf.ucw.cz>
References: <20070731121246.GF2087@elf.ucw.cz> <200707311520.28003.rjw@sisk.pl> <20070731131814.GI2087@elf.ucw.cz> <200707311549.54863.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707311549.54863.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >  # Running in *copy* of this code, somewhere in low 1MB.
> > > >  
> > > > -	movb	$0xa1, %al	;  outb %al, $0x80
> > > 
> > > Well, what was this for?
> > 
> > Debugging leds on port 80. I still have that card somewhere
> > :-). Interesting parties can reinsert it.
> 
> Ah, I see.
> 
> Hmm, can you please write about that in the chanelog more explicitly?
> Or just comment it out with a "uncomment this to get ..." text?

I still need someone with x86-64 to test it for me before I submit it
properly ;-). Updated patch follows.
								Pavel

diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
index 1415da1..9cebef7 100644
--- a/arch/i386/kernel/acpi/wakeup.S
+++ b/arch/i386/kernel/acpi/wakeup.S
@@ -28,21 +28,6 @@ #define BEEP \
 	movb	$15, %al; 	\
 	outb	%al, $66;
 
-#define BEEP \
-	inb	$97, %al; 	\
-	outb	%al, $0x80; 	\
-	movb	$3, %al; 	\
-	outb	%al, $97; 	\
-	outb	%al, $0x80; 	\
-	movb	$-74, %al; 	\
-	outb	%al, $67; 	\
-	outb	%al, $0x80; 	\
-	movb	$-119, %al; 	\
-	outb	%al, $66; 	\
-	outb	%al, $0x80; 	\
-	movb	$15, %al; 	\
-	outb	%al, $66;
-
 ALIGN
 	.align	4096
 ENTRY(wakeup_start)
@@ -53,9 +38,6 @@ wakeup_code:
 # Uncomment this to make your computer start producing ugly noise as soon
 # as BIOS returns to this real-mode entry point.
 #	BEEP
- 	movw	$0xb800, %ax
-	movw	%ax,%fs
-	movw	$0x0e00 + 'L', %fs:(0x10)
 
 	cli
 	cld
@@ -70,7 +52,6 @@ #	BEEP
 	BEEP
 1:
 	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
-	movw	$0x0e00 + 'S', %fs:(0x12)
 
 	pushl	$0						# Kill any dangerous flags
 	popfl
@@ -108,9 +89,6 @@ #	BEEP
 	# make sure %cr4 is set correctly (features, etc)
 	movl	real_save_cr4 - wakeup_code, %eax
 	movl	%eax, %cr4
-	movw	$0xb800, %ax
-	movw	%ax,%fs
-	movw	$0x0e00 + 'i', %fs:(0x12)
 	
 	# need a gdt -- use lgdtl to force 32-bit operands, in case
 	# the GDT is located past 16 megabytes.
@@ -120,8 +98,6 @@ #	BEEP
 	movl	%eax, %cr0
 	jmp 1f
 1:
-	movw	$0x0e00 + 'n', %fs:(0x14)
-
 	movl	real_magic - wakeup_code, %eax
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
@@ -145,7 +121,6 @@ real_save_efer_edx: 	.long 0
 real_save_efer_eax: 	.long 0
 
 bogus_real_magic:
-	movw	$0x0e00 + 'B', %fs:(0x12)
 	jmp bogus_real_magic
 
 /* This code uses an extended set of video mode numbers. These include:
@@ -170,29 +145,9 @@ #define VIDEO_FIRST_V7 0x0900
 # Setting of user mode (AX=mode ID) => CF=success
 mode_set:
 	movw	%ax, %bx
-#if 0
-	cmpb	$0xff, %ah
-	jz	setalias
-
-	testb	$VIDEO_RECALC>>8, %ah
-	jnz	_setrec
-
-	cmpb	$VIDEO_FIRST_RESOLUTION>>8, %ah
-	jnc	setres
-	
-	cmpb	$VIDEO_FIRST_SPECIAL>>8, %ah
-	jz	setspc
-
-	cmpb	$VIDEO_FIRST_V7>>8, %ah
-	jz	setv7
-#endif
 	
 	cmpb	$VIDEO_FIRST_VESA>>8, %ah
 	jnc	check_vesa
-#if 0	
-	orb	%ah, %ah
-	jz	setmenu
-#endif
 	
 	decb	%ah
 #	jz	setbios				  Add bios modes later
@@ -232,7 +187,6 @@ wakeup_pmode_return:
 	movw	%ax, %es
 	movw	%ax, %fs
 	movw	%ax, %gs
-	movw	$0x0e00 + 'u', 0xb8016
 
 	# reload the gdt, as we need the full 32 bit address
 	lgdt	saved_gdt
@@ -256,7 +210,6 @@ wakeup_pmode_return:
 	jmp	*%eax
 
 bogus_magic:
-	movw	$0x0e00 + 'B', 0xb8018
 	jmp	bogus_magic
 
 
diff --git a/arch/x86_64/kernel/acpi/wakeup.S b/arch/x86_64/kernel/acpi/wakeup.S
index 13f1480..fd09434 100644
--- a/arch/x86_64/kernel/acpi/wakeup.S
+++ b/arch/x86_64/kernel/acpi/wakeup.S
@@ -41,7 +41,6 @@ wakeup_code:
 
 # Running in *copy* of this code, somewhere in low 1MB.
 
-	movb	$0xa1, %al	;  outb %al, $0x80
 	cli
 	cld
 	# setup data segment
@@ -65,11 +64,6 @@ # Running in *copy* of this code, somewh
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
-  	call	verify_cpu			# Verify the cpu supports long
-						# mode
-	testl	%eax, %eax
-	jnz	no_longmode
-
 	testl	$1, realmode_flags - wakeup_code
 	jz	1f
 	lcall   $0xc000,$3
@@ -84,12 +78,6 @@ # Running in *copy* of this code, somewh
 	call	mode_seta
 1:
 
- 	movw	$0xb800, %ax
-	movw	%ax,%fs
-	movw	$0x0e00 + 'L', %fs:(0x10)
-
-	movb	$0xa2, %al	;  outb %al, $0x80
-	
 	mov	%ds, %ax			# Find 32bit wakeup_code addr
 	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
 	shll    $4, %esi
@@ -117,14 +105,10 @@ wakeup_32_vector:
 	.code32
 wakeup_32:
 # Running in this code, but at low address; paging is not yet turned on.
-	movb	$0xa5, %al	;  outb %al, $0x80
 
 	movl	$__KERNEL_DS, %eax
 	movl	%eax, %ds
 
-	movw	$0x0e00 + 'i', %ds:(0xb8012)
-	movb	$0xa8, %al	;  outb %al, $0x80;
-
 	/*
 	 * Prepare for entering 64bits mode
 	 */
@@ -200,16 +184,11 @@ wakeup_long64:
 	 */
 	lgdt	cpu_gdt_descr
 
-	movw	$0x0e00 + 'n', %ds:(0xb8014)
-	movb	$0xa9, %al	;  outb %al, $0x80
-
 	movq    saved_magic, %rax
 	movq    $0x123456789abcdef0, %rdx
 	cmpq    %rdx, %rax
 	jne     bogus_64_magic
 
-	movw	$0x0e00 + 'u', %ds:(0xb8016)
-	
 	nop
 	nop
 	movw	$__KERNEL_DS, %ax
@@ -220,13 +199,11 @@ wakeup_long64:
 	movw	%ax, %gs
 	movq	saved_rsp, %rsp
 
-	movw	$0x0e00 + 'x', %ds:(0xb8018)
 	movq	saved_rbx, %rbx
 	movq	saved_rdi, %rdi
 	movq	saved_rsi, %rsi
 	movq	saved_rbp, %rbp
 
-	movw	$0x0e00 + '!', %ds:(0xb801a)
 	movq	saved_rip, %rax
 	jmp	*%rax
 
@@ -256,20 +233,12 @@ realmode_flags:	.quad 0
 
 .code16
 bogus_real_magic:
-	movb	$0xba,%al	;  outb %al,$0x80
 	jmp bogus_real_magic
 
 .code64
 bogus_64_magic:
-	movb	$0xb3,%al	;  outb %al,$0x80
 	jmp bogus_64_magic
 
-.code16
-no_longmode:
-	movb    $0xbc,%al       ;  outb %al,$0x80
-	jmp no_longmode
-
-#include "../verify_cpu.S"
 	
 /* This code uses an extended set of video mode numbers. These include:
  * Aliases for standard modes
@@ -294,29 +263,9 @@ # Setting of user mode (AX=mode ID) => C
 .code16
 mode_seta:
 	movw	%ax, %bx
-#if 0
-	cmpb	$0xff, %ah
-	jz	setalias
-
-	testb	$VIDEO_RECALC>>8, %ah
-	jnz	_setrec
-
-	cmpb	$VIDEO_FIRST_RESOLUTION>>8, %ah
-	jnc	setres
-	
-	cmpb	$VIDEO_FIRST_SPECIAL>>8, %ah
-	jz	setspc
-
-	cmpb	$VIDEO_FIRST_V7>>8, %ah
-	jz	setv7
-#endif
 	
 	cmpb	$VIDEO_FIRST_VESA>>8, %ah
 	jnc	check_vesaa
-#if 0	
-	orb	%ah, %ah
-	jz	setmenu
-#endif
 	
 	decb	%ah
 #	jz	setbios				  Add bios modes later

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
