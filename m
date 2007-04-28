Return-Path: <linux-kernel-owner+w=401wt.eu-S1163366AbXD1R7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163366AbXD1R7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163339AbXD1R70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:59:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163342AbXD1R66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:58 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [10/22] x86_64: Get rid of dead code in suspend resume
Message-Id: <20070428175857.2E4C4151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


o Get rid of dead code in wakeup.S

o We never restore from saved_gdt, saved_idt, saved_ltd, saved_tss, saved_cr3,
  saved_cr4, saved_cr0, real_save_gdt, saved_efer, saved_efer2. Get rid
  of of associated code.

o Get rid of bogus_magic, bogus_31_magic and bogus_magic2. No longer being
  used.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/acpi/wakeup.S |   57 ---------------------------------------
 1 file changed, 1 insertion(+), 56 deletions(-)

Index: linux/arch/x86_64/kernel/acpi/wakeup.S
===================================================================
--- linux.orig/arch/x86_64/kernel/acpi/wakeup.S
+++ linux/arch/x86_64/kernel/acpi/wakeup.S
@@ -258,8 +258,6 @@ gdt_48a:
 	.word	0, 0				# gdt base (filled in later)
 	
 	
-real_save_gdt:	.word 0
-		.quad 0
 real_magic:	.quad 0
 video_mode:	.quad 0
 video_flags:	.quad 0
@@ -272,10 +270,6 @@ bogus_32_magic:
 	movb	$0xb3,%al	;  outb %al,$0x80
 	jmp bogus_32_magic
 
-bogus_31_magic:
-	movb	$0xb1,%al	;  outb %al,$0x80
-	jmp bogus_31_magic
-
 bogus_cpu:
 	movb	$0xbc,%al	;  outb %al,$0x80
 	jmp bogus_cpu
@@ -346,16 +340,6 @@ check_vesaa:
 
 _setbada: jmp setbada
 
-	.code64
-bogus_magic:
-	movw	$0x0e00 + 'B', %ds:(0xb8018)
-	jmp bogus_magic
-
-bogus_magic2:
-	movw	$0x0e00 + '2', %ds:(0xb8018)
-	jmp bogus_magic2
-	
-
 wakeup_stack_begin:	# Stack grows down
 
 .org	0xff0
@@ -373,28 +357,11 @@ ENTRY(wakeup_end)
 #
 # Returned address is location of code in low memory (past data and stack)
 #
+	.code64
 ENTRY(acpi_copy_wakeup_routine)
 	pushq	%rax
-	pushq	%rcx
 	pushq	%rdx
 
-	sgdt	saved_gdt
-	sidt	saved_idt
-	sldt	saved_ldt
-	str	saved_tss
-
-	movq    %cr3, %rdx
-	movq    %rdx, saved_cr3
-	movq    %cr4, %rdx
-	movq    %rdx, saved_cr4
-	movq	%cr0, %rdx
-	movq	%rdx, saved_cr0
-	sgdt    real_save_gdt - wakeup_start (,%rdi)
-	movl	$MSR_EFER, %ecx
-	rdmsr
-	movl	%eax, saved_efer
-	movl	%edx, saved_efer2
-
 	movl	saved_video_mode, %edx
 	movl	%edx, video_mode - wakeup_start (,%rdi)
 	movl	acpi_video_flags, %edx
@@ -407,17 +374,8 @@ ENTRY(acpi_copy_wakeup_routine)
 	cmpl	$0x9abcdef0, %eax
 	jne	bogus_32_magic
 
-	# make sure %cr4 is set correctly (features, etc)
-	movl	saved_cr4 - __START_KERNEL_map, %eax
-	movq	%rax, %cr4
-
-	movl	saved_cr0 - __START_KERNEL_map, %eax
-	movq	%rax, %cr0
-	jmp	1f		# Flush pipelines
-1:
 	# restore the regs we used
 	popq	%rdx
-	popq	%rcx
 	popq	%rax
 ENTRY(do_suspend_lowlevel_s4bios)
 	ret
@@ -512,16 +470,3 @@ ENTRY(saved_eip)	.quad	0
 ENTRY(saved_esp)	.quad	0
 
 ENTRY(saved_magic)	.quad	0
-
-ALIGN
-# saved registers
-saved_gdt:	.quad	0,0
-saved_idt:	.quad	0,0
-saved_ldt:	.quad	0
-saved_tss:	.quad	0
-
-saved_cr0:	.quad 0
-saved_cr3:	.quad 0
-saved_cr4:	.quad 0
-saved_efer:	.quad 0
-saved_efer2:	.quad 0
