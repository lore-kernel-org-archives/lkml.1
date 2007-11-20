Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbXKTB00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbXKTB00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbXKTBOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:16 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49883 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755895AbXKTBNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:41 -0500
Message-Id: <20071120011341.032661723@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:11 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 39/45] x86_64: Remove the data_offset field from the pda.
Content-Disposition: inline; filename=remove_data_offset
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is useless now since gs can always stand in for data_offset.

Move active_mm into the available slot in order to not upset the
established offsets.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/entry_64.S       |    7 ++-----
 arch/x86/kernel/setup64.c        |    2 --
 include/asm-x86/pda.h            |    4 +---
 4 files changed, 3 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/asm-offsets_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/asm-offsets_64.c	2007-11-19 15:45:03.902390058 -0800
+++ linux-2.6/arch/x86/kernel/asm-offsets_64.c	2007-11-19 16:13:29.241640104 -0800
@@ -56,7 +56,6 @@ int main(void)
 	ENTRY(irqcount);
 	ENTRY(cpunumber);
 	ENTRY(irqstackptr);
-	ENTRY(data_offset);
 	BLANK();
 #undef ENTRY
 #ifdef CONFIG_IA32_EMULATION
Index: linux-2.6/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/entry_64.S	2007-11-19 15:45:03.910390570 -0800
+++ linux-2.6/arch/x86/kernel/entry_64.S	2007-11-19 16:13:29.241640104 -0800
@@ -734,18 +734,15 @@ END(spurious_interrupt)
 	swapgs
 	xorl  %ebx,%ebx
 1:
-	.if \ist
-	movq	%gs:pda_data_offset, %rbp
-	.endif
 	movq %rsp,%rdi
 	movq ORIG_RAX(%rsp),%rsi
 	movq $-1,ORIG_RAX(%rsp)
 	.if \ist
-	subq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	subq	$EXCEPTION_STKSZ, %gs: per_cpu__init_tss + TSS_ist
 	.endif
 	call \sym
 	.if \ist
-	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	addq	$EXCEPTION_STKSZ, %gs: per_cpu__init_tss + TSS_ist
 	.endif
 	cli
 	.if \irqtrace
Index: linux-2.6/arch/x86/kernel/setup64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup64.c	2007-11-19 16:06:50.162390389 -0800
+++ linux-2.6/arch/x86/kernel/setup64.c	2007-11-19 16:13:29.245640006 -0800
@@ -103,8 +103,6 @@ void __init setup_per_cpu_areas(void)
 	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
 					PERCPU_ENOUGH_ROOM);
 	for_each_cpu_mask (i, cpu_possible_map) {
-		cpu_pda(i)->data_offset = cpu_offset(i);
-
 		memcpy(CPU_PTR(base, i), __load_per_cpu_start,
 				__per_cpu_end - __per_cpu_start);
 
Index: linux-2.6/include/asm-x86/pda.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pda.h	2007-11-19 16:06:15.301390091 -0800
+++ linux-2.6/include/asm-x86/pda.h	2007-11-19 16:13:29.245640006 -0800
@@ -10,8 +10,7 @@
 /* Per processor datastructure. %gs points to it while the kernel runs */ 
 struct x8664_pda {
 	struct task_struct *pcurrent;	/* 0  Current process */
-	unsigned long data_offset;	/* 8 Per cpu data offset from linker
-					   address */
+	struct mm_struct *active_mm;
 	unsigned long kernelstack;  /* 16 top of kernel stack for current */
 	unsigned long oldrsp; 	    /* 24 user rsp for system call */
         int irqcount;		    /* 32 Irq nesting counter. Starts with -1 */
@@ -27,7 +26,6 @@ struct x8664_pda {
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
 	short isidle;
-	struct mm_struct *active_mm;
 	unsigned apic_timer_irqs;
 	unsigned irq0_irqs;
 	unsigned irq_resched_count;

-- 
