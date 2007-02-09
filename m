Return-Path: <linux-kernel-owner+w=401wt.eu-S1946505AbXBIPEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946505AbXBIPEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946501AbXBIPEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:04:41 -0500
Received: from ozlabs.org ([203.10.76.45]:47140 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946505AbXBIPEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:04:40 -0500
Subject: [PATCH 2 of 7]  lguest: Rename cpu_gdt_descr and remove extern
	declaration from smpboot.c
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <1171033383.2718.163.camel@localhost.localdomain>
References: <1171033146.2718.157.camel@localhost.localdomain>
	 <1171033383.2718.163.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 02:03:56 +1100
Message-Id: <1171033436.2718.165.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I implemented the DECLARE_PER_CPU(var) macros, I was careful that
people couldn't use "var" in a non-percpu context, by prepending
percpu__.  I never considered that this would allow them to overload
the same name for a per-cpu and a non-percpu variable.

It is only one of many horrors in the i386 boot code, but let's rename
the non-perpcu cpu_gdt_descr to early_gdt_descr (not boot_gdt_descr,
that's something else...)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -309,7 +309,7 @@ 2:	movl %cr0,%eax
 
 	call check_x87
 	call setup_pda
-	lgdt cpu_gdt_descr
+	lgdt early_gdt_descr
 	lidt idt_descr
 	ljmp $(__KERNEL_CS),$1f
 1:	movl $(__KERNEL_DS),%eax	# reload all the segment registers
@@ -365,7 +365,7 @@ setup_pda:
 	movl start_pda, %eax
 
 	/* slot the PDA address into the GDT */
-	mov cpu_gdt_descr+2, %ecx
+	mov early_gdt_descr+2, %ecx
 	mov %ax, (__KERNEL_PDA+0+2)(%ecx)		/* base & 0x0000ffff */
 	shr $16, %eax
 	mov %al, (__KERNEL_PDA+4+0)(%ecx)		/* base & 0x00ff0000 */
@@ -588,7 +588,7 @@ idt_descr:
 
 # boot GDT descriptor (later on used by CPU#0):
 	.word 0				# 32 bit align gdt_desc.address
-ENTRY(cpu_gdt_descr)
+ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
 	.long cpu_gdt_table
 
===================================================================
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -619,7 +619,6 @@ extern struct {
 	unsigned short ss;
 } stack_start;
 extern struct i386_pda *start_pda;
-extern struct Xgt_desc_struct cpu_gdt_descr;
 
 #ifdef CONFIG_NUMA
 
===================================================================
--- a/include/asm-i386/desc.h
+++ b/include/asm-i386/desc.h
@@ -22,7 +22,7 @@ struct Xgt_desc_struct {
 
 extern struct Xgt_desc_struct idt_descr;
 DECLARE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
-
+extern struct Xgt_desc_struct early_gdt_descr;
 
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {


