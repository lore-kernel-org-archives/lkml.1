Return-Path: <linux-kernel-owner+w=401wt.eu-S1163393AbXD1SGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163393AbXD1SGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163326AbXD1SBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163343AbXD1R7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:59:00 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [12/22] x86_64: wakeup.S misc cleanups
Message-Id: <20070428175859.51F56151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


o Various cleanups. One of the main purpose of cleanups is that make
  wakeup.S as close as possible to trampoline.S.

o Following are the changes
	- Indentations for comments.
	- Changed the gdt table to compact form and to resemble the
	  one in trampoline.S
	- Take the jump to 32bit from real mode using ljmpl. Makes code
	  more readable.
	- After enabling long mode, directly take a long jump for 64bit
	  mode. No need to take an extra jump to "reach_comaptibility_mode"
	- Stack is not used after real mode. So don't load stack in
 	  32 bit mode.
	- No need to enable PGE here.
	- No need to do extra EFER read, anyway we trash the read contents.
	- No need to enable system call (EFER_SCE). Anyway it will be 
	  enabled when original EFER is restored.
	- No need to set MP, ET, NE, WP, AM bits in cr0. Very soon we will
  	  reload the original cr0 while restroing the processor state.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/acpi/wakeup.S |  112 +++++++++++++--------------------------
 1 file changed, 40 insertions(+), 72 deletions(-)

Index: linux/arch/x86_64/kernel/acpi/wakeup.S
===================================================================
--- linux.orig/arch/x86_64/kernel/acpi/wakeup.S
+++ linux/arch/x86_64/kernel/acpi/wakeup.S
@@ -30,11 +30,12 @@ wakeup_code:
 	cld
 	# setup data segment
 	movw	%cs, %ax
-	movw	%ax, %ds					# Make ds:0 point to wakeup_start
+	movw	%ax, %ds		# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
-	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
+					# Private stack is needed for ASUS board
+	mov	$(wakeup_stack - wakeup_code), %sp
 
-	pushl	$0						# Kill any dangerous flags
+	pushl	$0			# Kill any dangerous flags
 	popfl
 
 	movl	real_magic - wakeup_code, %eax
@@ -45,7 +46,7 @@ wakeup_code:
 	jz	1f
 	lcall   $0xc000,$3
 	movw	%cs, %ax
-	movw	%ax, %ds					# Bios might have played with that
+	movw	%ax, %ds		# Bios might have played with that
 	movw	%ax, %ss
 1:
 
@@ -75,9 +76,12 @@ wakeup_code:
 	jmp	1f
 1:
 
-	.byte 0x66, 0xea			# prefix + jmpi-opcode
-	.long	wakeup_32 - __START_KERNEL_map
-	.word	__KERNEL_CS
+	ljmpl   *(wakeup_32_vector - wakeup_code)
+
+	.balign 4
+wakeup_32_vector:
+	.long   wakeup_32 - __START_KERNEL_map
+	.word   __KERNEL32_CS, 0
 
 	.code32
 wakeup_32:
@@ -96,65 +100,50 @@ wakeup_32:
 	jnc	bogus_cpu
 	movl	%edx,%edi
 	
-	movw	$__KERNEL_DS, %ax
-	movw	%ax, %ds
-	movw	%ax, %es
-	movw	%ax, %fs
-	movw	%ax, %gs
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
 
-	movw	$__KERNEL_DS, %ax	
-	movw	%ax, %ss
-
-	mov	$(wakeup_stack - __START_KERNEL_map), %esp
 	movl	saved_magic - __START_KERNEL_map, %eax
 	cmpl	$0x9abcdef0, %eax
 	jne	bogus_32_magic
 
+	movw	$0x0e00 + 'i', %ds:(0xb8012)
+	movb	$0xa8, %al	;  outb %al, $0x80;
+
 	/*
 	 * Prepare for entering 64bits mode
 	 */
 
-	/* Enable PAE mode and PGE */
+	/* Enable PAE */
 	xorl	%eax, %eax
 	btsl	$5, %eax
-	btsl	$7, %eax
 	movl	%eax, %cr4
 
 	/* Setup early boot stage 4 level pagetables */
 	movl	$(wakeup_level4_pgt - __START_KERNEL_map), %eax
 	movl	%eax, %cr3
 
-	/* Setup EFER (Extended Feature Enable Register) */
-	movl	$MSR_EFER, %ecx
-	rdmsr
-	/* Fool rdmsr and reset %eax to avoid dependences */
-	xorl	%eax, %eax
 	/* Enable Long Mode */
+	xorl    %eax, %eax
 	btsl	$_EFER_LME, %eax
-	/* Enable System Call */
-	btsl	$_EFER_SCE, %eax
 
-	/* No Execute supported? */	
+	/* No Execute supported? */
 	btl	$20,%edi
 	jnc     1f
 	btsl	$_EFER_NX, %eax
-1:	
 				
 	/* Make changes effective */
+1:	movl    $MSR_EFER, %ecx
+	xorl    %edx, %edx
 	wrmsr
-	wbinvd
 
 	xorl	%eax, %eax
 	btsl	$31, %eax			/* Enable paging and in turn activate Long Mode */
 	btsl	$0, %eax			/* Enable protected mode */
-	btsl	$1, %eax			/* Enable MP */
-	btsl	$4, %eax			/* Enable ET */
-	btsl	$5, %eax			/* Enable NE */
-	btsl	$16, %eax			/* Enable WP */
-	btsl	$18, %eax			/* Enable AM */
 
 	/* Make changes effective */
 	movl	%eax, %cr0
+
 	/* At this point:
 		CR4.PAE must be 1
 		CS.L must be 0
@@ -162,11 +151,6 @@ wakeup_32:
 		Next instruction must be a branch
 		This must be on identity-mapped page
 	*/
-	jmp	reach_compatibility_mode
-reach_compatibility_mode:
-	movw	$0x0e00 + 'i', %ds:(0xb8012)
-	movb	$0xa8, %al	;  outb %al, $0x80; 	
-		
 	/*
 	 * At this point we're in long mode but in 32bit compatibility mode
 	 * with EFER.LME = 1, CS.L = 0, CS.D = 1 (and in turn
@@ -174,24 +158,19 @@ reach_compatibility_mode:
 	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
 	 */
 
-	movw	$0x0e00 + 'n', %ds:(0xb8014)
-	movb	$0xa9, %al	;  outb %al, $0x80
-	
-	/* Load new GDT with the 64bit segment using 32bit descriptor */
-	movl	$(pGDT32 - __START_KERNEL_map), %eax
-	lgdt	(%eax)
-
-	movl    $(wakeup_jumpvector - __START_KERNEL_map), %eax
 	/* Finally jump in 64bit mode */
-	ljmp	*(%eax)
+	ljmp	*(wakeup_long64_vector - __START_KERNEL_map)
 
-wakeup_jumpvector:
-	.long	wakeup_long64 - __START_KERNEL_map
-	.word	__KERNEL_CS
+	.balign 4
+wakeup_long64_vector:
+	.long   wakeup_long64 - __START_KERNEL_map
+	.word   __KERNEL_CS, 0
 
 .code64
 
-	/*	Hooray, we are in Long 64-bit mode (but still running in low memory) */
+	/* Hooray, we are in Long 64-bit mode (but still running in
+	 * low memory)
+	 */
 wakeup_long64:
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
@@ -201,6 +180,9 @@ wakeup_long64:
 	 */
 	lgdt	cpu_gdt_descr - __START_KERNEL_map
 
+	movw	$0x0e00 + 'n', %ds:(0xb8014)
+	movb	$0xa9, %al	;  outb %al, $0x80
+
 	movw	$0x0e00 + 'u', %ds:(0xb8016)
 	
 	nop
@@ -227,33 +209,19 @@ wakeup_long64:
 
 	.align	64	
 gdta:
+	/* Its good to keep gdt in sync with one in trampoline.S */
 	.word	0, 0, 0, 0			# dummy
-
-	.word	0, 0, 0, 0			# unused
-
-	.word	0xFFFF				# 4Gb - (0x100000*0x1000 = 4Gb)
-	.word	0				# base address = 0
-	.word	0x9B00				# code read/exec. ??? Why I need 0x9B00 (as opposed to 0x9A00 in order for this to work?)
-	.word	0x00CF				# granularity = 4096, 386
-						#  (+5th nibble of limit)
-
-	.word	0xFFFF				# 4Gb - (0x100000*0x1000 = 4Gb)
-	.word	0				# base address = 0
-	.word	0x9200				# data read/write
-	.word	0x00CF				# granularity = 4096, 386
-						#  (+5th nibble of limit)
-# this is 64bit descriptor for code
-	.word	0xFFFF
-	.word	0
-	.word	0x9A00				# code read/exec
-	.word	0x00AF				# as above, but it is long mode and with D=0
+	/* ??? Why I need the accessed bit set in order for this to work? */
+	.quad   0x00cf9b000000ffff              # __KERNEL32_CS
+	.quad   0x00af9b000000ffff              # __KERNEL_CS
+	.quad   0x00cf93000000ffff              # __KERNEL_DS
 
 idt_48a:
 	.word	0				# idt limit = 0
 	.word	0, 0				# idt base = 0L
 
 gdt_48a:
-	.word	0x8000				# gdt limit=2048,
+	.word	0x800				# gdt limit=2048,
 						#  256 GDT entries
 	.word	0, 0				# gdt base (filled in later)
 	
@@ -263,7 +231,7 @@ video_mode:	.quad 0
 video_flags:	.quad 0
 
 bogus_real_magic:
-	movb	$0xba,%al	;  outb %al,$0x80		
+	movb	$0xba,%al	;  outb %al,$0x80
 	jmp bogus_real_magic
 
 bogus_32_magic:
