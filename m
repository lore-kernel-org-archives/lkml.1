Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbXBLDhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbXBLDhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbXBLDhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:37:31 -0500
Received: from ozlabs.org ([203.10.76.45]:50863 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932951AbXBLDha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:37:30 -0500
Subject: [PATCH 5/7] cleanup: Rename cpu_gdt_descr and remove extern
	declaration from smpboot.c
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1171251335.10409.10.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
	 <1171251185.10409.4.camel@localhost.localdomain>
	 <1171251258.10409.7.camel@localhost.localdomain>
	 <1171251335.10409.10.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:36:45 +1100
Message-Id: <1171251406.10409.13.camel@localhost.localdomain>
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


