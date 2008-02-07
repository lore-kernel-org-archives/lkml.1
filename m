Return-Path: <linux-kernel-owner+w=401wt.eu-S934529AbYBGWmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529AbYBGWmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758253AbYBGWlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:41:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40317 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402AbYBGWlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:41:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Thu, 7 Feb 2008 23:40:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080205190600.GB11613@elf.ucw.cz> <200802072312.31430.rjw@sisk.pl> <20080207222845.GA6096@elf.ucw.cz>
In-Reply-To: <20080207222845.GA6096@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802072340.06138.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of February 2008, Pavel Machek wrote:
> Hi!
> 
> > > > > This rewrites wakeup code to .c, and it fixes stack (should use movl
> > > > > ,%esp, not movw). Testers wanted. Makefile infrastructure was done by
> > > > > hpa, cleanups by rjw.
> > > > 
> > > > I'll test it tomorrow
> > > 
> > > Works on my nx6325 (good sign, the box is easy to break ;-)).
> > > 
> > > > and I still have some more cleanups (I was distracted by a nasty scheduler
> > > > issue in the current mainline).
> > > 
> > > The cleanups are still in the works (sorry).
> > 
> > Below is a version with some easy cleanups, rebased on top of the patches that
> > move the 64-bit hibernation code to arch/x86/power .
> 
> Can you post a delta against my versoin? I do not see any changes from
> a quick glance.

Appended (plus I removed two hunks, one in arch/x86/Makefile and one in
drivers/acpi/sleep/main.c that were unrelated to the rest of the patch).
 
> This is probably more acceptable version of beep; but there are
> probably even better ways to clean it...
> 
>         if (wakeup_header.realmode_flags & 4) {
>                 inb(97);
>                 outb(0, 0x80);
>                 outb(3, 97);
>                 outb(0, 0x80);
>                 outb(-74, 67);
>                 outb(0, 0x80);
>                 outb(-119, 66);
>                 outb(0, 0x80);
>                 outb(15, 66);
>         }
> 
> ...like the version that makes beep/pause/beep/pause, so that user can
> count them.

Can we move it into a separate function?

Rafael

---
 arch/x86/boot/video-vesa.c             |   12 
 arch/x86/kernel/acpi/Makefile          |    2 
 arch/x86/kernel/acpi/realmode/Makefile |    2 
 arch/x86/kernel/acpi/realmode/wakeup.S |   34 +-
 arch/x86/kernel/acpi/wakeup.S          |    1 
 arch/x86/kernel/acpi/wakeup_32.S       |   34 +-
 arch/x86/kernel/acpi/wakeup_64.S       |   21 -
 arch/x86/kernel/acpi/wakeup_rm.S       |    2 
 arch/x86_64/kernel/acpi/wakeup.S       |  425 ---------------------------------
 9 files changed, 50 insertions(+), 483 deletions(-)

Index: linux-2.6/arch/x86_64/kernel/acpi/wakeup.S
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/acpi/wakeup.S
+++ /dev/null
@@ -1,425 +0,0 @@
-.text
-#include <linux/linkage.h>
-#include <asm/segment.h>
-#include <asm/pgtable.h>
-#include <asm/page.h>
-#include <asm/msr.h>
-
-# Copyright 2003 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
-#
-# wakeup_code runs in real mode, and at unknown address (determined at run-time).
-# Therefore it must only use relative jumps/calls. 
-#
-# Do we need to deal with A20? It is okay: ACPI specs says A20 must be enabled
-#
-# If physical address of wakeup_code is 0x12345, BIOS should call us with
-# cs = 0x1234, eip = 0x05
-#
-
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
-
-ALIGN
-	.align	16
-ENTRY(wakeup_start)
-wakeup_code:
-	wakeup_code_start = .
-	.code16
-
-# Running in *copy* of this code, somewhere in low 1MB.
-
-	cli
-	cld
-	# setup data segment
-	movw	%cs, %ax
-	movw	%ax, %ds		# Make ds:0 point to wakeup_start
-	movw	%ax, %ss
-
-	# Data segment must be set up before we can see whether to beep.
-	testl   $4, realmode_flags - wakeup_code
-	jz      1f
-	BEEP
-1:
-
-					# Private stack is needed for ASUS board
-	mov	$(wakeup_stack - wakeup_code), %sp
-
-	pushl	$0			# Kill any dangerous flags
-	popfl
-
-	movl	real_magic - wakeup_code, %eax
-	cmpl	$0x12345678, %eax
-	jne	bogus_real_magic
-
-	testl	$1, realmode_flags - wakeup_code
-	jz	1f
-	lcall   $0xc000,$3
-	movw	%cs, %ax
-	movw	%ax, %ds		# Bios might have played with that
-	movw	%ax, %ss
-1:
-
-	testl	$2, realmode_flags - wakeup_code
-	jz	1f
-	mov	video_mode - wakeup_code, %ax
-	call	mode_set
-1:
-
-	mov	%ds, %ax			# Find 32bit wakeup_code addr
-	movzx   %ax, %esi			# (Convert %ds:gdt to a liner ptr)
-	shll    $4, %esi
-						# Fix up the vectors
-	addl    %esi, wakeup_32_vector - wakeup_code
-	addl    %esi, wakeup_long64_vector - wakeup_code
-	addl    %esi, gdt_48a + 2 - wakeup_code # Fixup the gdt pointer
-
-	lidtl	%ds:idt_48a - wakeup_code
-	lgdtl	%ds:gdt_48a - wakeup_code	# load gdt with whatever is
-						# appropriate
-
-	movl	$1, %eax			# protected mode (PE) bit
-	lmsw	%ax				# This is it!
-	jmp	1f
-1:
-
-	ljmpl   *(wakeup_32_vector - wakeup_code)
-
-	.balign 4
-wakeup_32_vector:
-	.long   wakeup_32 - wakeup_code
-	.word   __KERNEL32_CS, 0
-
-	.code32
-wakeup_32:
-# Running in this code, but at low address; paging is not yet turned on.
-
-	movl	$__KERNEL_DS, %eax
-	movl	%eax, %ds
-
-	/*
-	 * Prepare for entering 64bits mode
-	 */
-
-	/* Enable PAE */
-	xorl	%eax, %eax
-	btsl	$5, %eax
-	movl	%eax, %cr4
-
-	/* Setup early boot stage 4 level pagetables */
-	leal    (wakeup_level4_pgt - wakeup_code)(%esi), %eax
-	movl	%eax, %cr3
-
-        /* Check if nx is implemented */
-        movl    $0x80000001, %eax
-        cpuid
-        movl    %edx,%edi
-
-	/* Enable Long Mode */
-	xorl    %eax, %eax
-	btsl	$_EFER_LME, %eax
-
-	/* No Execute supported? */
-	btl	$20,%edi
-	jnc     1f
-	btsl	$_EFER_NX, %eax
-				
-	/* Make changes effective */
-1:	movl    $MSR_EFER, %ecx
-	xorl    %edx, %edx
-	wrmsr
-
-	xorl	%eax, %eax
-	btsl	$31, %eax			/* Enable paging and in turn activate Long Mode */
-	btsl	$0, %eax			/* Enable protected mode */
-
-	/* Make changes effective */
-	movl	%eax, %cr0
-
-	/* At this point:
-		CR4.PAE must be 1
-		CS.L must be 0
-		CR3 must point to PML4
-		Next instruction must be a branch
-		This must be on identity-mapped page
-	*/
-	/*
-	 * At this point we're in long mode but in 32bit compatibility mode
-	 * with EFER.LME = 1, CS.L = 0, CS.D = 1 (and in turn
-	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we load
-	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
-	 */
-
-	/* Finally jump in 64bit mode */
-        ljmp    *(wakeup_long64_vector - wakeup_code)(%esi)
-
-	.balign 4
-wakeup_long64_vector:
-	.long   wakeup_long64 - wakeup_code
-	.word   __KERNEL_CS, 0
-
-.code64
-
-	/* Hooray, we are in Long 64-bit mode (but still running in
-	 * low memory)
-	 */
-wakeup_long64:
-	/*
-	 * We must switch to a new descriptor in kernel space for the GDT
-	 * because soon the kernel won't have access anymore to the userspace
-	 * addresses where we're currently running on. We have to do that here
-	 * because in 32bit we couldn't load a 64bit linear address.
-	 */
-	lgdt	cpu_gdt_descr
-
-	movq    saved_magic, %rax
-	movq    $0x123456789abcdef0, %rdx
-	cmpq    %rdx, %rax
-	jne     bogus_64_magic
-
-	nop
-	nop
-	movw	$__KERNEL_DS, %ax
-	movw	%ax, %ss	
-	movw	%ax, %ds
-	movw	%ax, %es
-	movw	%ax, %fs
-	movw	%ax, %gs
-	movq	saved_rsp, %rsp
-
-	movq	saved_rbx, %rbx
-	movq	saved_rdi, %rdi
-	movq	saved_rsi, %rsi
-	movq	saved_rbp, %rbp
-
-	movq	saved_rip, %rax
-	jmp	*%rax
-
-.code32
-
-	.align	64	
-gdta:
-	/* Its good to keep gdt in sync with one in trampoline.S */
-	.word	0, 0, 0, 0			# dummy
-	/* ??? Why I need the accessed bit set in order for this to work? */
-	.quad   0x00cf9b000000ffff              # __KERNEL32_CS
-	.quad   0x00af9b000000ffff              # __KERNEL_CS
-	.quad   0x00cf93000000ffff              # __KERNEL_DS
-
-idt_48a:
-	.word	0				# idt limit = 0
-	.word	0, 0				# idt base = 0L
-
-gdt_48a:
-	.word	0x800				# gdt limit=2048,
-						#  256 GDT entries
-	.long   gdta - wakeup_code              # gdt base (relocated in later)
-	
-real_magic:	.quad 0
-video_mode:	.quad 0
-realmode_flags:	.quad 0
-
-.code16
-bogus_real_magic:
-	jmp bogus_real_magic
-
-.code64
-bogus_64_magic:
-	jmp bogus_64_magic
-
-	
-/* This code uses an extended set of video mode numbers. These include:
- * Aliases for standard modes
- *	NORMAL_VGA (-1)
- *	EXTENDED_VGA (-2)
- *	ASK_VGA (-3)
- * Video modes numbered by menu position -- NOT RECOMMENDED because of lack
- * of compatibility when extending the table. These are between 0x00 and 0xff.
- */
-#define VIDEO_FIRST_MENU 0x0000
-
-/* Standard BIOS video modes (BIOS number + 0x0100) */
-#define VIDEO_FIRST_BIOS 0x0100
-
-/* VESA BIOS video modes (VESA number + 0x0200) */
-#define VIDEO_FIRST_VESA 0x0200
-
-/* Video7 special modes (BIOS number + 0x0900) */
-#define VIDEO_FIRST_V7 0x0900
-
-# Setting of user mode (AX=mode ID) => CF=success
-
-# For now, we only handle VESA modes (0x0200..0x03ff).  To handle other
-# modes, we should probably compile in the video code from the boot
-# directory.
-.code16
-mode_set:
-	movw	%ax, %bx
-	subb	$VIDEO_FIRST_VESA>>8, %bh
-	cmpb	$2, %bh
-	jb	check_vesa
-
-setbad:
-	clc
-	ret
-
-check_vesa:
-	orw	$0x4000, %bx			# Use linear frame buffer
-	movw	$0x4f02, %ax			# VESA BIOS mode set call
-	int	$0x10
-	cmpw	$0x004f, %ax			# AL=4f if implemented
-	jnz	setbad				# AH=0 if OK
-
-	stc
-	ret
-
-wakeup_stack_begin:	# Stack grows down
-
-.org	0xff0
-wakeup_stack:		# Just below end of page
-
-.org   0x1000
-ENTRY(wakeup_level4_pgt)
-	.quad   level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill   510,8,0
-	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
-	.quad   level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
-
-ENTRY(wakeup_end)
-	
-##
-# acpi_copy_wakeup_routine
-#
-# Copy the above routine to low memory.
-#
-# Parameters:
-# %rdi:	place to copy wakeup routine to
-#
-# Returned address is location of code in low memory (past data and stack)
-#
-	.code64
-ENTRY(acpi_copy_wakeup_routine)
-	pushq	%rax
-	pushq	%rdx
-
-	movl	saved_video_mode, %edx
-	movl	%edx, video_mode - wakeup_start (,%rdi)
-	movl	acpi_realmode_flags, %edx
-	movl	%edx, realmode_flags - wakeup_start (,%rdi)
-	movq	$0x12345678, real_magic - wakeup_start (,%rdi)
-	movq	$0x123456789abcdef0, %rdx
-	movq	%rdx, saved_magic
-
-	movq    saved_magic, %rax
-	movq    $0x123456789abcdef0, %rdx
-	cmpq    %rdx, %rax
-	jne     bogus_64_magic
-
-	# restore the regs we used
-	popq	%rdx
-	popq	%rax
-ENTRY(do_suspend_lowlevel_s4bios)
-	ret
-
-	.align 2
-	.p2align 4,,15
-.globl do_suspend_lowlevel
-	.type	do_suspend_lowlevel,@function
-do_suspend_lowlevel:
-.LFB5:
-	subq	$8, %rsp
-	xorl	%eax, %eax
-	call	save_processor_state
-
-	movq %rsp, saved_context_esp(%rip)
-	movq %rax, saved_context_eax(%rip)
-	movq %rbx, saved_context_ebx(%rip)
-	movq %rcx, saved_context_ecx(%rip)
-	movq %rdx, saved_context_edx(%rip)
-	movq %rbp, saved_context_ebp(%rip)
-	movq %rsi, saved_context_esi(%rip)
-	movq %rdi, saved_context_edi(%rip)
-	movq %r8,  saved_context_r08(%rip)
-	movq %r9,  saved_context_r09(%rip)
-	movq %r10, saved_context_r10(%rip)
-	movq %r11, saved_context_r11(%rip)
-	movq %r12, saved_context_r12(%rip)
-	movq %r13, saved_context_r13(%rip)
-	movq %r14, saved_context_r14(%rip)
-	movq %r15, saved_context_r15(%rip)
-	pushfq ; popq saved_context_eflags(%rip)
-
-	movq	$.L97, saved_rip(%rip)
-
-	movq %rsp,saved_rsp
-	movq %rbp,saved_rbp
-	movq %rbx,saved_rbx
-	movq %rdi,saved_rdi
-	movq %rsi,saved_rsi
-
-	addq	$8, %rsp
-	movl	$3, %edi
-	xorl	%eax, %eax
-	jmp	acpi_enter_sleep_state
-.L97:
-	.p2align 4,,7
-.L99:
-	.align 4
-	movl	$24, %eax
-	movw %ax, %ds
-	movq	saved_context+58(%rip), %rax
-	movq %rax, %cr4
-	movq	saved_context+50(%rip), %rax
-	movq %rax, %cr3
-	movq	saved_context+42(%rip), %rax
-	movq %rax, %cr2
-	movq	saved_context+34(%rip), %rax
-	movq %rax, %cr0
-	pushq saved_context_eflags(%rip) ; popfq
-	movq saved_context_esp(%rip), %rsp
-	movq saved_context_ebp(%rip), %rbp
-	movq saved_context_eax(%rip), %rax
-	movq saved_context_ebx(%rip), %rbx
-	movq saved_context_ecx(%rip), %rcx
-	movq saved_context_edx(%rip), %rdx
-	movq saved_context_esi(%rip), %rsi
-	movq saved_context_edi(%rip), %rdi
-	movq saved_context_r08(%rip), %r8
-	movq saved_context_r09(%rip), %r9
-	movq saved_context_r10(%rip), %r10
-	movq saved_context_r11(%rip), %r11
-	movq saved_context_r12(%rip), %r12
-	movq saved_context_r13(%rip), %r13
-	movq saved_context_r14(%rip), %r14
-	movq saved_context_r15(%rip), %r15
-
-	xorl	%eax, %eax
-	addq	$8, %rsp
-	jmp	restore_processor_state
-.LFE5:
-.Lfe5:
-	.size	do_suspend_lowlevel,.Lfe5-do_suspend_lowlevel
-	
-.data
-ALIGN
-ENTRY(saved_rbp)	.quad	0
-ENTRY(saved_rsi)	.quad	0
-ENTRY(saved_rdi)	.quad	0
-ENTRY(saved_rbx)	.quad	0
-
-ENTRY(saved_rip)	.quad	0
-ENTRY(saved_rsp)	.quad	0
-
-ENTRY(saved_magic)	.quad	0
Index: linux-2.6/arch/x86/kernel/acpi/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/Makefile
+++ linux-2.6/arch/x86/kernel/acpi/Makefile
@@ -8,7 +8,7 @@ obj-y				+= cstate.o processor.o
 endif
 
 $(obj)/wakeup_rm.o:    $(obj)/realmode/wakeup.bin
-       
+
 $(obj)/realmode/wakeup.bin: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/realmode $@
 
Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/realmode/wakeup.S
+++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -12,16 +12,14 @@
 /* This should match the structure in wakeup.h */
 		.globl	wakeup_header
 wakeup_header:
-entry:		.short	_start	/* unused */
-total:		.short	_end	/* unused */
 video_mode:	.short	0	/* Video mode number */
 pmode_return:	.byte	0x66, 0xea	/* ljmpl */
-		.long	0		/* offset goes here */
+		.long	0	/* offset goes here */
 		.short	__KERNEL_CS
-pmode_cr0:	.long	0		/* Saved %cr0 */
-pmode_cr3:	.long	0		/* Saved %cr3 */
-pmode_cr4:	.long	0		/* Saved %cr4 */
-pmode_efer:	.quad	0		/* Saved EFER */
+pmode_cr0:	.long	0	/* Saved %cr0 */
+pmode_cr3:	.long	0	/* Saved %cr3 */
+pmode_cr4:	.long	0	/* Saved %cr4 */
+pmode_efer:	.quad	0	/* Saved EFER */
 pmode_gdt:	.quad	0
 realmode_flags:	.long	0
 real_magic:	.long	0
@@ -37,10 +35,10 @@ _start:
 	cld
 
 	/* Set up segments */
-	movw	%cs,%ax
-	movw	%ax,%ds
-	movw	%ax,%es
-	movw	%ax,%ss
+	movw	%cs, %ax
+	movw	%ax, %ds
+	movw	%ax, %es
+	movw	%ax, %ss
 
 	movl	$wakeup_stack_end, %esp
 
@@ -61,16 +59,17 @@ _start:
 	/* Zero the bss */
 	xorl	%eax, %eax
 	movw	$__bss_start, %di
-	movw	$__bss_end+3, %cx
+	movw	$__bss_end + 3, %cx
 	subw	%di, %cx
 	shrw	$2, %cx
-	rep; stosl
+	rep
+	stosl
 
 	/* Call the C code */
 	calll	main
 
 	/* Do any other stuff... */
-	
+
 #ifndef CONFIG_64BIT
 	/* This could also be done in C code... */
 	movl	pmode_cr3, %eax
@@ -81,7 +80,7 @@ _start:
 	movl	%ecx, %cr4
 1:
 	movl	pmode_efer, %eax
-	movl	pmode_efer+4, %edx
+	movl	pmode_efer + 4, %edx
 	movl	%eax, %ecx
 	orl	%edx, %ecx
 	jz	1f
@@ -99,14 +98,14 @@ _start:
 	pushw	$0
 	pushw	trampoline_segment
 	pushw	$0
-	lret	
+	lret
 #endif
 
 bogus_real_magic:
 1:
 	hlt
 	jmp	1b
-	
+
 	.data
 	.balign	4
 	.globl	HEAP, heap_end
@@ -121,4 +120,3 @@ wakeup_heap:
 wakeup_stack:
 	.space	2048
 wakeup_stack_end:
-
Index: linux-2.6/arch/x86/kernel/acpi/wakeup_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/wakeup_32.S
+++ linux-2.6/arch/x86/kernel/acpi/wakeup_32.S
@@ -5,8 +5,6 @@
 
 # Copyright 2003, 2008 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
 
-#include "wakeup.S"
-
 	.code32
 	ALIGN
 
@@ -23,7 +21,7 @@ wakeup_pmode_return:
 	lgdt	saved_gdt
 	lidt	saved_idt
 	lldt	saved_ldt
-	ljmp	$(__KERNEL_CS),$1f
+	ljmp	$(__KERNEL_CS), $1f
 1:
 	movl	%cr3, %eax
 	movl	%eax, %cr3
@@ -37,7 +35,7 @@ wakeup_pmode_return:
 	jne	bogus_magic
 
 	# jump to place where we left off
-	movl	saved_eip,%eax
+	movl	saved_eip, %eax
 	jmp	*%eax
 
 bogus_magic:
@@ -50,26 +48,28 @@ save_registers:
 	sidt	saved_idt
 	sldt	saved_ldt
 	str	saved_tss
-	
+
 	leal	4(%esp), %eax
 	movl	%eax, saved_context_esp
-	movl %ebx, saved_context_ebx
-	movl %ebp, saved_context_ebp
-	movl %esi, saved_context_esi
-	movl %edi, saved_context_edi
-	pushfl ; popl saved_context_eflags
+	movl	%ebx, saved_context_ebx
+	movl	%ebp, saved_context_ebp
+	movl	%esi, saved_context_esi
+	movl	%edi, saved_context_edi
+	pushfl
+	popl	saved_context_eflags
 
-	movl $ret_point, saved_eip
+	movl	$ret_point, saved_eip
 	ret
 
 
 restore_registers:
-	movl saved_context_ebp, %ebp
-	movl saved_context_ebx, %ebx
-	movl saved_context_esi, %esi
-	movl saved_context_edi, %edi
-	pushl saved_context_eflags ; popfl
-	ret	
+	movl	saved_context_ebp, %ebp
+	movl	saved_context_ebx, %ebx
+	movl	saved_context_esi, %esi
+	movl	saved_context_edi, %edi
+	pushl	saved_context_eflags
+	popfl
+	ret
 
 ENTRY(do_suspend_lowlevel)
 	call	save_processor_state
Index: linux-2.6/arch/x86/boot/video-vesa.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/video-vesa.c
+++ linux-2.6/arch/x86/boot/video-vesa.c
@@ -24,7 +24,11 @@ static struct vesa_mode_info vminfo;
 
 __videocard video_vesa;
 
+#ifndef _WAKEUP
 static void vesa_store_mode_params_graphics(void);
+#else /* _WAKEUP */
+static inline void vesa_store_mode_params_graphics(void) {}
+#endif /* _WAKEUP */
 
 static int vesa_probe(void)
 {
@@ -160,15 +164,15 @@ static int vesa_set_mode(struct mode_inf
 		do_restore = 1;
 	} else {
 		/* Graphics mode */
-#ifndef _WAKEUP
 		vesa_store_mode_params_graphics();
-#endif
 	}
 
 	return 0;
 }
 
 
+#ifndef _WAKEUP
+
 /* Switch DAC to 8-bit mode */
 static void vesa_dac_set_8bits(void)
 {
@@ -189,7 +193,6 @@ static void vesa_dac_set_8bits(void)
 	}
 
 	/* Set the color sizes to the DAC size, and offsets to 0 */
-#ifndef _WAKEUP
 	boot_params.screen_info.red_size = dac_size;
 	boot_params.screen_info.green_size = dac_size;
 	boot_params.screen_info.blue_size = dac_size;
@@ -199,11 +202,8 @@ static void vesa_dac_set_8bits(void)
 	boot_params.screen_info.green_pos = 0;
 	boot_params.screen_info.blue_pos = 0;
 	boot_params.screen_info.rsvd_pos = 0;
-#endif
 }
 
-#ifndef _WAKEUP
-
 /* Save the VESA protected mode info */
 static void vesa_store_pm_info(void)
 {
Index: linux-2.6/arch/x86/kernel/acpi/realmode/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/realmode/Makefile
+++ linux-2.6/arch/x86/kernel/acpi/realmode/Makefile
@@ -1,5 +1,5 @@
 #
-# arch/x86/kernel/acpi/rm/Makefile
+# arch/x86/kernel/acpi/realmode/Makefile
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
Index: linux-2.6/arch/x86/kernel/acpi/wakeup_rm.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/wakeup_rm.S
+++ linux-2.6/arch/x86/kernel/acpi/wakeup_rm.S
@@ -5,6 +5,6 @@
 	.section ".rodata","a"
 	.globl	wakeup_code_start, wakeup_code_end
 wakeup_code_start:
-	.incbin	"arch/x86/kernel/acpi/rm/wakeup.bin"
+	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
 wakeup_code_end:
 	.size	wakeup_code_start, .-wakeup_code_start
Index: linux-2.6/arch/x86/kernel/acpi/wakeup.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/wakeup.S
+++ /dev/null
@@ -1 +0,0 @@
-# Copyright 2003, 2008 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
Index: linux-2.6/arch/x86/kernel/acpi/wakeup_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/wakeup_64.S
+++ linux-2.6/arch/x86/kernel/acpi/wakeup_64.S
@@ -8,21 +8,16 @@
 
 # Copyright 2003 Pavel Machek <pavel@suse.cz>, distribute under GPLv2
 
-#include "wakeup.S"
-
-# Running in this code, but at low address; paging is not yet turned on.
-
 .code64
-
-	/* Hooray, we are in Long 64-bit mode (but still running in
-	 * low memory)
+	/*
+	 * Hooray, we are in Long 64-bit mode (but still running in low memory)
 	 */
 ENTRY(wakeup_long64)
 wakeup_long64:
-	movq    saved_magic, %rax
-	movq    $0x123456789abcdef0, %rdx
-	cmpq    %rdx, %rax
-	jne     bogus_64_magic
+	movq	saved_magic, %rax
+	movq	$0x123456789abcdef0, %rdx
+	cmpq	%rdx, %rax
+	jne	bogus_64_magic
 
 	movw	$__KERNEL_DS, %ax
 	movw	%ax, %ss	
@@ -41,7 +36,7 @@ wakeup_long64:
 	jmp	*%rax
 
 bogus_64_magic:
-	jmp bogus_64_magic
+	jmp	bogus_64_magic
 
 	.align 2
 	.p2align 4,,15
@@ -124,7 +119,7 @@ do_suspend_lowlevel:
 	jmp	restore_processor_state
 .LFE5:
 .Lfe5:
-	.size	do_suspend_lowlevel,.Lfe5-do_suspend_lowlevel
+	.size	do_suspend_lowlevel, .Lfe5-do_suspend_lowlevel
 	
 .data
 ALIGN
