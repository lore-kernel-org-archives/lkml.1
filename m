Return-Path: <linux-kernel-owner+w=401wt.eu-S965004AbXBLQv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004AbXBLQv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965006AbXBLQv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:51:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965002AbXBLQv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:56 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [27/29] i386: Rename cpu_gdt_descr and remove extern  declaration from smpboot.c
Message-Id: <20070212165148.419A813E1A@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>
When I implemented the DECLARE_PER_CPU(var) macros, I was careful that
people couldn't use "var" in a non-percpu context, by prepending
percpu__.  I never considered that this would allow them to overload
the same name for a per-cpu and a non-percpu variable.

It is only one of many horrors in the i386 boot code, but let's rename
the non-perpcu cpu_gdt_descr to early_gdt_descr (not boot_gdt_descr,
that's something else...)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

===================================================================
---
 arch/i386/kernel/head.S    |    6 +++---
 arch/i386/kernel/smpboot.c |    1 -
 include/asm-i386/desc.h    |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/head.S
===================================================================
--- linux.orig/arch/i386/kernel/head.S
+++ linux/arch/i386/kernel/head.S
@@ -319,7 +319,7 @@ is386:	movl $2,%ecx		# set MP
 
 	call check_x87
 	call setup_pda
-	lgdt cpu_gdt_descr
+	lgdt early_gdt_descr
 	lidt idt_descr
 	ljmp $(__KERNEL_CS),$1f
 1:	movl $(__KERNEL_DS),%eax	# reload all the segment registers
@@ -375,7 +375,7 @@ ENTRY(setup_pda)
 	movl start_pda, %eax
 
 	/* slot the PDA address into the GDT */
-	mov cpu_gdt_descr+2, %ecx
+	mov early_gdt_descr+2, %ecx
 	mov %ax, (__KERNEL_PDA+0+2)(%ecx)		/* base & 0x0000ffff */
 	shr $16, %eax
 	mov %al, (__KERNEL_PDA+4+0)(%ecx)		/* base & 0x00ff0000 */
@@ -597,7 +597,7 @@ idt_descr:
 
 # boot GDT descriptor (later on used by CPU#0):
 	.word 0				# 32 bit align gdt_desc.address
-ENTRY(cpu_gdt_descr)
+ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
 	.long cpu_gdt_table
 
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -622,7 +622,6 @@ extern struct {
 	unsigned short ss;
 } stack_start;
 extern struct i386_pda *start_pda;
-extern struct Xgt_desc_struct cpu_gdt_descr;
 
 #ifdef CONFIG_NUMA
 
Index: linux/include/asm-i386/desc.h
===================================================================
--- linux.orig/include/asm-i386/desc.h
+++ linux/include/asm-i386/desc.h
@@ -22,7 +22,7 @@ struct Xgt_desc_struct {
 
 extern struct Xgt_desc_struct idt_descr;
 DECLARE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
-
+extern struct Xgt_desc_struct early_gdt_descr;
 
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
