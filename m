Return-Path: <linux-kernel-owner+w=401wt.eu-S1763541AbZE0HfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763541AbZE0HfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762576AbZE0H1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:27:39 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46949 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762572AbZE0H1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:27:37 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 17/29] microblaze_mmu_v2: Update exception handling - MMU exception
Date: Wed, 27 May 2009 08:47:42 +0200
Message-Id: <1243406874-3917-18-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-17-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
 <1243406874-3917-16-git-send-email-monstr@monstr.eu>
 <1243406874-3917-17-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/hw_exception_handler.S |  746 ++++++++++++++++++++++++-
 1 files changed, 739 insertions(+), 7 deletions(-)

diff --git a/arch/microblaze/kernel/hw_exception_handler.S b/arch/microblaze/kernel/hw_exception_handler.S
index cf9486d..9d591cd 100644
--- a/arch/microblaze/kernel/hw_exception_handler.S
+++ b/arch/microblaze/kernel/hw_exception_handler.S
@@ -53,6 +53,12 @@
  *   - Illegal instruction opcode
  *   - Divide-by-zero
  *
+ *   - Privileged instruction exception (MMU)
+ *   - Data storage exception (MMU)
+ *   - Instruction storage exception (MMU)
+ *   - Data TLB miss exception (MMU)
+ *   - Instruction TLB miss exception (MMU)
+ *
  * Note we disable interrupts during exception handling, otherwise we will
  * possibly get multiple re-entrancy if interrupt handles themselves cause
  * exceptions. JW
@@ -71,9 +77,24 @@
 #include <asm/asm-offsets.h>
 
 /* Helpful Macros */
+#ifndef CONFIG_MMU
 #define EX_HANDLER_STACK_SIZ	(4*19)
+#endif
 #define NUM_TO_REG(num)		r ## num
 
+#ifdef CONFIG_MMU
+/* FIXME you can't change first load of MSR because there is
+ * hardcoded jump bri 4 */
+	#define RESTORE_STATE			\
+		lwi	r3, r1, PT_R3;		\
+		lwi	r4, r1, PT_R4;		\
+		lwi	r5, r1, PT_R5;		\
+		lwi	r6, r1, PT_R6;		\
+		lwi	r11, r1, PT_R11;	\
+		lwi	r31, r1, PT_R31;	\
+		lwi	r1, r0, TOPHYS(r0_ram + 0);
+#endif /* CONFIG_MMU */
+
 #define LWREG_NOP			\
 	bri	ex_handler_unhandled;	\
 	nop;
@@ -106,6 +127,54 @@
 	or	r3, r0, NUM_TO_REG (regnum);		\
 	bri	ex_sw_tail;
 
+#ifdef CONFIG_MMU
+	#define R3_TO_LWREG_VM_V(regnum)		\
+		brid	ex_lw_end_vm;			\
+		swi	r3, r7, 4 * regnum;
+
+	#define R3_TO_LWREG_VM(regnum)			\
+		brid	ex_lw_end_vm;			\
+		or	NUM_TO_REG (regnum), r0, r3;
+
+	#define SWREG_TO_R3_VM_V(regnum)		\
+		brid	ex_sw_tail_vm;			\
+		lwi	r3, r7, 4 * regnum;
+
+	#define SWREG_TO_R3_VM(regnum)			\
+		brid	ex_sw_tail_vm;			\
+		or	r3, r0, NUM_TO_REG (regnum);
+
+	/* Shift right instruction depending on available configuration */
+	#if CONFIG_XILINX_MICROBLAZE0_USE_BARREL > 0
+	#define BSRLI(rD, rA, imm)	\
+		bsrli rD, rA, imm
+	#elif CONFIG_XILINX_MICROBLAZE0_USE_DIV > 0
+	#define BSRLI(rD, rA, imm)	\
+		ori rD, r0, (1 << imm);	\
+		idivu rD, rD, rA
+	#else
+	#define BSRLI(rD, rA, imm) BSRLI ## imm (rD, rA)
+	/* Only the used shift constants defined here - add more if needed */
+	#define BSRLI2(rD, rA)				\
+		srl rD, rA;		/* << 1 */	\
+		srl rD, rD;		/* << 2 */
+	#define BSRLI10(rD, rA)				\
+		srl rD, rA;		/* << 1 */	\
+		srl rD, rD;		/* << 2 */	\
+		srl rD, rD;		/* << 3 */	\
+		srl rD, rD;		/* << 4 */	\
+		srl rD, rD;		/* << 5 */	\
+		srl rD, rD;		/* << 6 */	\
+		srl rD, rD;		/* << 7 */	\
+		srl rD, rD;		/* << 8 */	\
+		srl rD, rD;		/* << 9 */	\
+		srl rD, rD		/* << 10 */
+	#define BSRLI20(rD, rA)		\
+		BSRLI10(rD, rA);	\
+		BSRLI10(rD, rD)
+	#endif
+#endif /* CONFIG_MMU */
+
 .extern other_exception_handler /* Defined in exception.c */
 
 /*
@@ -163,34 +232,119 @@
 
 /* wrappers to restore state before coming to entry.S */
 
+#ifdef CONFIG_MMU
+.section .rodata
+.align 4
+_MB_HW_ExceptionVectorTable:
+/*  0 - Undefined */
+	.long	TOPHYS(ex_handler_unhandled)
+/*  1 - Unaligned data access exception */
+	.long	TOPHYS(handle_unaligned_ex)
+/*  2 - Illegal op-code exception */
+	.long	TOPHYS(full_exception_trapw)
+/*  3 - Instruction bus error exception */
+	.long	TOPHYS(full_exception_trapw)
+/*  4 - Data bus error exception */
+	.long	TOPHYS(full_exception_trapw)
+/*  5 - Divide by zero exception */
+	.long	TOPHYS(full_exception_trapw)
+/*  6 - Floating point unit exception */
+	.long	TOPHYS(full_exception_trapw)
+/*  7 - Privileged instruction exception */
+	.long	TOPHYS(full_exception_trapw)
+/*  8 - 15 - Undefined */
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+/* 16 - Data storage exception */
+	.long	TOPHYS(handle_data_storage_exception)
+/* 17 - Instruction storage exception */
+	.long	TOPHYS(handle_instruction_storage_exception)
+/* 18 - Data TLB miss exception */
+	.long	TOPHYS(handle_data_tlb_miss_exception)
+/* 19 - Instruction TLB miss exception */
+	.long	TOPHYS(handle_instruction_tlb_miss_exception)
+/* 20 - 31 - Undefined */
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+	.long	TOPHYS(ex_handler_unhandled)
+#endif
+
 .global _hw_exception_handler
 .section .text
 .align 4
 .ent _hw_exception_handler
 _hw_exception_handler:
+#ifndef CONFIG_MMU
 	addik	r1, r1, -(EX_HANDLER_STACK_SIZ); /* Create stack frame */
+#else
+	swi	r1, r0, TOPHYS(r0_ram + 0); /* GET_SP */
+	/* Save date to kernel memory. Here is the problem
+	 * when you came from user space */
+	ori	r1, r0, TOPHYS(r0_ram + 28);
+#endif
 	swi	r3, r1, PT_R3
 	swi	r4, r1, PT_R4
 	swi	r5, r1, PT_R5
 	swi	r6, r1, PT_R6
 
-	mfs	r5, rmsr;
-	nop
-	swi	r5, r1, 0;
-	mfs	r4, rbtr	/* Save BTR before jumping to handler */
-	nop
+#ifdef CONFIG_MMU
+	swi	r11, r1, PT_R11
+	swi	r31, r1, PT_R31
+	lwi	r31, r0, TOPHYS(PER_CPU(CURRENT_SAVE)) /* get saved current */
+#endif
+
 	mfs	r3, resr
 	nop
+	mfs	r4, rear;
+	nop
 
+#ifndef CONFIG_MMU
 	andi	r5, r3, 0x1000;		/* Check ESR[DS] */
 	beqi	r5, not_in_delay_slot;	/* Branch if ESR[DS] not set */
 	mfs	r17, rbtr;	/* ESR[DS] set - return address in BTR */
 	nop
 not_in_delay_slot:
 	swi	r17, r1, PT_R17
+#endif
 
 	andi	r5, r3, 0x1F;		/* Extract ESR[EXC] */
 
+#ifdef CONFIG_MMU
+	/* Calculate exception vector offset = r5 << 2 */
+	addk	r6, r5, r5; /* << 1 */
+	addk	r6, r6, r6; /* << 2 */
+
+/* counting which exception happen */
+	lwi	r5, r0, 0x200 + TOPHYS(r0_ram)
+	addi	r5, r5, 1
+	swi	r5, r0, 0x200 + TOPHYS(r0_ram)
+	lwi	r5, r6, 0x200 + TOPHYS(r0_ram)
+	addi	r5, r5, 1
+	swi	r5, r6, 0x200 + TOPHYS(r0_ram)
+/* end */
+	/* Load the HW Exception vector */
+	lwi	r6, r6, TOPHYS(_MB_HW_ExceptionVectorTable)
+	bra	r6
+
+full_exception_trapw:
+	RESTORE_STATE
+	bri	full_exception_trap
+#else
 	/* Exceptions enabled here. This will allow nested exceptions */
 	mfs	r6, rmsr;
 	nop
@@ -254,6 +408,7 @@ handle_other_ex: /* Handle Other exceptions here */
 	lwi	r18, r1, PT_R18
 
 	bri	ex_handler_done; /* Complete exception handling */
+#endif
 
 /* 0x01 - Unaligned data access exception
  * This occurs when a word access is not aligned on a word boundary,
@@ -265,11 +420,28 @@ handle_other_ex: /* Handle Other exceptions here */
 handle_unaligned_ex:
 	/* Working registers already saved: R3, R4, R5, R6
 	 *  R3 = ESR
-	 *  R4 = BTR
+	 *  R4 = EAR
 	 */
-	mfs	r4, rear;
+#ifdef CONFIG_MMU
+	andi	r6, r3, 0x1000			/* Check ESR[DS] */
+	beqi	r6, _no_delayslot		/* Branch if ESR[DS] not set */
+	mfs	r17, rbtr;	/* ESR[DS] set - return address in BTR */
 	nop
+_no_delayslot:
+#endif
+
+#ifdef CONFIG_MMU
+	/* Check if unaligned address is last on a 4k page */
+		andi	r5, r4, 0xffc
+		xori	r5, r5, 0xffc
+		bnei	r5, _unaligned_ex2
+	_unaligned_ex1:
+		RESTORE_STATE;
+/* Another page must be accessed or physical address not in page table */
+		bri	unaligned_data_trap
 
+	_unaligned_ex2:
+#endif
 	andi	r6, r3, 0x3E0; /* Mask and extract the register operand */
 	srl	r6, r6; /* r6 >> 5 */
 	srl	r6, r6;
@@ -278,6 +450,45 @@ handle_unaligned_ex:
 	srl	r6, r6;
 	/* Store the register operand in a temporary location */
 	sbi	r6, r0, TOPHYS(ex_reg_op);
+#ifdef CONFIG_MMU
+	/* Get physical address */
+	/* If we are faulting a kernel address, we have to use the
+	 * kernel page tables.
+	 */
+	ori	r5, r0, CONFIG_KERNEL_START
+	cmpu	r5, r4, r5
+	bgti	r5, _unaligned_ex3
+	ori	r5, r0, swapper_pg_dir
+	bri	_unaligned_ex4
+
+	/* Get the PGD for the current thread. */
+_unaligned_ex3: /* user thread */
+	addi	r5 ,CURRENT_TASK, TOPHYS(0); /* get current task address */
+	lwi	r5, r5, TASK_THREAD + PGDIR
+_unaligned_ex4:
+	tophys(r5,r5)
+	BSRLI(r6,r4,20)			/* Create L1 (pgdir/pmd) address */
+	andi	r6, r6, 0xffc
+/* Assume pgdir aligned on 4K boundary, no need for "andi r5,r5,0xfffff003" */
+	or	r5, r5, r6
+	lwi	r6, r5, 0		/* Get L1 entry */
+	andi	r5, r6, 0xfffff000	/* Extract L2 (pte) base address. */
+	beqi	r5, _unaligned_ex1	/* Bail if no table */
+
+	tophys(r5,r5)
+	BSRLI(r6,r4,10)			/* Compute PTE address */
+	andi	r6, r6, 0xffc
+	andi	r5, r5, 0xfffff003
+	or	r5, r5, r6
+	lwi	r5, r5, 0		/* Get Linux PTE */
+
+	andi	r6, r5, _PAGE_PRESENT
+	beqi	r6, _unaligned_ex1	/* Bail if no page */
+
+	andi	r5, r5, 0xfffff000	/* Extract RPN */
+	andi	r4, r4, 0x00000fff	/* Extract offset */
+	or	r4, r4, r5		/* Create physical address */
+#endif /* CONFIG_MMU */
 
 	andi	r6, r3, 0x400; /* Extract ESR[S] */
 	bnei	r6, ex_sw;
@@ -355,6 +566,7 @@ ex_shw:
 ex_sw_end: /* Exception handling of store word, ends. */
 
 ex_handler_done:
+#ifndef CONFIG_MMU
 	lwi	r5, r1, 0 /* RMSR */
 	mts	rmsr, r5
 	nop
@@ -366,13 +578,455 @@ ex_handler_done:
 
 	rted	r17, 0
 	addik	r1, r1, (EX_HANDLER_STACK_SIZ); /* Restore stack frame */
+#else
+	RESTORE_STATE;
+	rted	r17, 0
+	nop
+#endif
+
+#ifdef CONFIG_MMU
+	/* Exception vector entry code. This code runs with address translation
+	 * turned off (i.e. using physical addresses). */
+
+	/* Exception vectors. */
+
+	/* 0x10 - Data Storage Exception
+	 * This happens for just a few reasons. U0 set (but we don't do that),
+	 * or zone protection fault (user violation, write to protected page).
+	 * If this is just an update of modified status, we do that quickly
+	 * and exit. Otherwise, we call heavyweight functions to do the work.
+	 */
+	handle_data_storage_exception:
+		/* Working registers already saved: R3, R4, R5, R6
+		 * R3 = ESR
+		 */
+		mfs	r11, rpid
+		nop
+		bri	4
+		mfs	r3, rear		/* Get faulting address */
+		nop
+		/* If we are faulting a kernel address, we have to use the
+		 * kernel page tables.
+		 */
+		ori	r4, r0, CONFIG_KERNEL_START
+		cmpu	r4, r3, r4
+		bgti	r4, ex3
+		/* First, check if it was a zone fault (which means a user
+		 * tried to access a kernel or read-protected page - always
+		 * a SEGV). All other faults here must be stores, so no
+		 * need to check ESR_S as well. */
+		mfs	r4, resr
+		nop
+		andi	r4, r4, 0x800		/* ESR_Z - zone protection */
+		bnei	r4, ex2
+
+		ori	r4, r0, swapper_pg_dir
+		mts	rpid, r0		/* TLB will have 0 TID */
+		nop
+		bri	ex4
+
+		/* Get the PGD for the current thread. */
+	ex3:
+		/* First, check if it was a zone fault (which means a user
+		 * tried to access a kernel or read-protected page - always
+		 * a SEGV). All other faults here must be stores, so no
+		 * need to check ESR_S as well. */
+		mfs	r4, resr
+		nop
+		andi	r4, r4, 0x800		/* ESR_Z */
+		bnei	r4, ex2
+		/* get current task address */
+		addi	r4 ,CURRENT_TASK, TOPHYS(0);
+		lwi	r4, r4, TASK_THREAD+PGDIR
+	ex4:
+		tophys(r4,r4)
+		BSRLI(r5,r3,20)		/* Create L1 (pgdir/pmd) address */
+		andi	r5, r5, 0xffc
+/* Assume pgdir aligned on 4K boundary, no need for "andi r4,r4,0xfffff003" */
+		or	r4, r4, r5
+		lwi	r4, r4, 0		/* Get L1 entry */
+		andi	r5, r4, 0xfffff000 /* Extract L2 (pte) base address */
+		beqi	r5, ex2			/* Bail if no table */
+
+		tophys(r5,r5)
+		BSRLI(r6,r3,10)			/* Compute PTE address */
+		andi	r6, r6, 0xffc
+		andi	r5, r5, 0xfffff003
+		or	r5, r5, r6
+		lwi	r4, r5, 0		/* Get Linux PTE */
+
+		andi	r6, r4, _PAGE_RW	/* Is it writeable? */
+		beqi	r6, ex2			/* Bail if not */
+
+		/* Update 'changed' */
+		ori	r4, r4, _PAGE_DIRTY|_PAGE_ACCESSED|_PAGE_HWWRITE
+		swi	r4, r5, 0		/* Update Linux page table */
+
+		/* Most of the Linux PTE is ready to load into the TLB LO.
+		 * We set ZSEL, where only the LS-bit determines user access.
+		 * We set execute, because we don't have the granularity to
+		 * properly set this at the page level (Linux problem).
+		 * If shared is set, we cause a zero PID->TID load.
+		 * Many of these bits are software only. Bits we don't set
+		 * here we (properly should) assume have the appropriate value.
+		 */
+		andni	r4, r4, 0x0ce2		/* Make sure 20, 21 are zero */
+		ori	r4, r4, _PAGE_HWEXEC	/* make it executable */
+
+		/* find the TLB index that caused the fault. It has to be here*/
+		mts	rtlbsx, r3
+		nop
+		mfs	r5, rtlbx		/* DEBUG: TBD */
+		nop
+		mts	rtlblo, r4		/* Load TLB LO */
+		nop
+						/* Will sync shadow TLBs */
+
+		/* Done...restore registers and get out of here. */
+		mts	rpid, r11
+		nop
+		bri 4
+
+		RESTORE_STATE;
+		rted	r17, 0
+		nop
+	ex2:
+		/* The bailout. Restore registers to pre-exception conditions
+		 * and call the heavyweights to help us out. */
+		mts	rpid, r11
+		nop
+		bri 4
+		RESTORE_STATE;
+		bri	page_fault_data_trap
+
+
+	/* 0x11 - Instruction Storage Exception
+	 * This is caused by a fetch from non-execute or guarded pages. */
+	handle_instruction_storage_exception:
+		/* Working registers already saved: R3, R4, R5, R6
+		 * R3 = ESR
+		 */
+
+		mfs	r3, rear		/* Get faulting address */
+		nop
+		RESTORE_STATE;
+		bri	page_fault_instr_trap
+
+	/* 0x12 - Data TLB Miss Exception
+	 * As the name implies, translation is not in the MMU, so search the
+	 * page tables and fix it. The only purpose of this function is to
+	 * load TLB entries from the page table if they exist.
+	 */
+	handle_data_tlb_miss_exception:
+		/* Working registers already saved: R3, R4, R5, R6
+		 * R3 = ESR
+		 */
+		mfs	r11, rpid
+		nop
+		bri	4
+		mfs	r3, rear		/* Get faulting address */
+		nop
+
+		/* If we are faulting a kernel address, we have to use the
+		 * kernel page tables. */
+		ori	r4, r0, CONFIG_KERNEL_START
+		cmpu	r4, r3, r4
+		bgti	r4, ex5
+		ori	r4, r0, swapper_pg_dir
+		mts	rpid, r0		/* TLB will have 0 TID */
+		nop
+		bri	ex6
 
+		/* Get the PGD for the current thread. */
+	ex5:
+		/* get current task address */
+		addi	r4 ,CURRENT_TASK, TOPHYS(0);
+		lwi	r4, r4, TASK_THREAD+PGDIR
+	ex6:
+		tophys(r4,r4)
+		BSRLI(r5,r3,20)		/* Create L1 (pgdir/pmd) address */
+		andi	r5, r5, 0xffc
+/* Assume pgdir aligned on 4K boundary, no need for "andi r4,r4,0xfffff003" */
+		or	r4, r4, r5
+		lwi	r4, r4, 0		/* Get L1 entry */
+		andi	r5, r4, 0xfffff000 /* Extract L2 (pte) base address */
+		beqi	r5, ex7			/* Bail if no table */
+
+		tophys(r5,r5)
+		BSRLI(r6,r3,10)			/* Compute PTE address */
+		andi	r6, r6, 0xffc
+		andi	r5, r5, 0xfffff003
+		or	r5, r5, r6
+		lwi	r4, r5, 0		/* Get Linux PTE */
+
+		andi	r6, r4, _PAGE_PRESENT
+		beqi	r6, ex7
+
+		ori	r4, r4, _PAGE_ACCESSED
+		swi	r4, r5, 0
+
+		/* Most of the Linux PTE is ready to load into the TLB LO.
+		 * We set ZSEL, where only the LS-bit determines user access.
+		 * We set execute, because we don't have the granularity to
+		 * properly set this at the page level (Linux problem).
+		 * If shared is set, we cause a zero PID->TID load.
+		 * Many of these bits are software only. Bits we don't set
+		 * here we (properly should) assume have the appropriate value.
+		 */
+		andni	r4, r4, 0x0ce2		/* Make sure 20, 21 are zero */
+
+		bri	finish_tlb_load
+	ex7:
+		/* The bailout. Restore registers to pre-exception conditions
+		 * and call the heavyweights to help us out.
+		 */
+		mts	rpid, r11
+		nop
+		bri	4
+		RESTORE_STATE;
+		bri	page_fault_data_trap
+
+	/* 0x13 - Instruction TLB Miss Exception
+	 * Nearly the same as above, except we get our information from
+	 * different registers and bailout to a different point.
+	 */
+	handle_instruction_tlb_miss_exception:
+		/* Working registers already saved: R3, R4, R5, R6
+		 *  R3 = ESR
+		 */
+		mfs	r11, rpid
+		nop
+		bri	4
+		mfs	r3, rear		/* Get faulting address */
+		nop
+
+		/* If we are faulting a kernel address, we have to use the
+		 * kernel page tables.
+		 */
+		ori	r4, r0, CONFIG_KERNEL_START
+		cmpu	r4, r3, r4
+		bgti	r4, ex8
+		ori	r4, r0, swapper_pg_dir
+		mts	rpid, r0		/* TLB will have 0 TID */
+		nop
+		bri	ex9
+
+		/* Get the PGD for the current thread. */
+	ex8:
+		/* get current task address */
+		addi	r4 ,CURRENT_TASK, TOPHYS(0);
+		lwi	r4, r4, TASK_THREAD+PGDIR
+	ex9:
+		tophys(r4,r4)
+		BSRLI(r5,r3,20)		/* Create L1 (pgdir/pmd) address */
+		andi	r5, r5, 0xffc
+/* Assume pgdir aligned on 4K boundary, no need for "andi r4,r4,0xfffff003" */
+		or	r4, r4, r5
+		lwi	r4, r4, 0		/* Get L1 entry */
+		andi	r5, r4, 0xfffff000 /* Extract L2 (pte) base address */
+		beqi	r5, ex10		/* Bail if no table */
+
+		tophys(r5,r5)
+		BSRLI(r6,r3,10)			/* Compute PTE address */
+		andi	r6, r6, 0xffc
+		andi	r5, r5, 0xfffff003
+		or	r5, r5, r6
+		lwi	r4, r5, 0		/* Get Linux PTE */
+
+		andi	r6, r4, _PAGE_PRESENT
+		beqi	r6, ex7
+
+		ori	r4, r4, _PAGE_ACCESSED
+		swi	r4, r5, 0
+
+		/* Most of the Linux PTE is ready to load into the TLB LO.
+		 * We set ZSEL, where only the LS-bit determines user access.
+		 * We set execute, because we don't have the granularity to
+		 * properly set this at the page level (Linux problem).
+		 * If shared is set, we cause a zero PID->TID load.
+		 * Many of these bits are software only. Bits we don't set
+		 * here we (properly should) assume have the appropriate value.
+		 */
+		andni	r4, r4, 0x0ce2		/* Make sure 20, 21 are zero */
+
+		bri	finish_tlb_load
+	ex10:
+		/* The bailout. Restore registers to pre-exception conditions
+		 * and call the heavyweights to help us out.
+		 */
+		mts	rpid, r11
+		nop
+		bri 4
+		RESTORE_STATE;
+		bri	page_fault_instr_trap
+
+/* Both the instruction and data TLB miss get to this point to load the TLB.
+ *	r3 - EA of fault
+ *	r4 - TLB LO (info from Linux PTE)
+ *	r5, r6 - available to use
+ *	PID - loaded with proper value when we get here
+ *	Upon exit, we reload everything and RFI.
+ * A common place to load the TLB.
+ */
+	tlb_index:
+		.long	1 /* MS: storing last used tlb index */
+	finish_tlb_load:
+		/* MS: load the last used TLB index. */
+		lwi	r5, r0, TOPHYS(tlb_index)
+		addik	r5, r5, 1 /* MS: inc tlb_index -> use next one */
+
+/* MS: FIXME this is potential fault, because this is mask not count */
+		andi	r5, r5, (MICROBLAZE_TLB_SIZE-1)
+		ori	r6, r0, 1
+		cmp	r31, r5, r6
+		blti	r31, sem
+		addik	r5, r6, 1
+	sem:
+		/* MS: save back current TLB index */
+		swi	r5, r0, TOPHYS(tlb_index)
+
+		ori	r4, r4, _PAGE_HWEXEC	/* make it executable */
+		mts	rtlbx, r5		/* MS: save current TLB */
+		nop
+		mts	rtlblo,	r4		/* MS: save to TLB LO */
+		nop
+
+		/* Create EPN. This is the faulting address plus a static
+		 * set of bits. These are size, valid, E, U0, and ensure
+		 * bits 20 and 21 are zero.
+		 */
+		andi	r3, r3, 0xfffff000
+		ori	r3, r3, 0x0c0
+		mts	rtlbhi,	r3		/* Load TLB HI */
+		nop
+
+		/* Done...restore registers and get out of here. */
+	ex12:
+		mts	rpid, r11
+		nop
+		bri 4
+		RESTORE_STATE;
+		rted	r17, 0
+		nop
+
+	/* extern void giveup_fpu(struct task_struct *prev)
+	 *
+	 * The MicroBlaze processor may have an FPU, so this should not just
+	 * return: TBD.
+	 */
+	.globl giveup_fpu;
+	.align 4;
+	giveup_fpu:
+		bralid	r15,0			/* TBD */
+		nop
+
+	/* At present, this routine just hangs. - extern void abort(void) */
+	.globl abort;
+	.align 4;
+	abort:
+		br	r0
+
+	.globl set_context;
+	.align 4;
+	set_context:
+		mts	rpid, r5	/* Shadow TLBs are automatically */
+		nop
+		bri	4		/* flushed by changing PID */
+		rtsd	r15,8
+		nop
+
+#endif
 .end _hw_exception_handler
 
+#ifdef CONFIG_MMU
+/* Unaligned data access exception last on a 4k page for MMU.
+ * When this is called, we are in virtual mode with exceptions enabled
+ * and registers 1-13,15,17,18 saved.
+ *
+ * R3 = ESR
+ * R4 = EAR
+ * R7 = pointer to saved registers (struct pt_regs *regs)
+ *
+ * This handler perform the access, and returns via ret_from_exc.
+ */
+.global _unaligned_data_exception
+.ent _unaligned_data_exception
+_unaligned_data_exception:
+	andi	r8, r3, 0x3E0;	/* Mask and extract the register operand */
+	BSRLI(r8,r8,2);		/* r8 >> 2 = register operand * 8 */
+	andi	r6, r3, 0x400;	/* Extract ESR[S] */
+	bneid	r6, ex_sw_vm;
+	andi	r6, r3, 0x800;	/* Extract ESR[W] - delay slot */
+ex_lw_vm:
+	beqid	r6, ex_lhw_vm;
+	lbui	r5, r4, 0;	/* Exception address in r4 - delay slot */
+/* Load a word, byte-by-byte from destination address and save it in tmp space*/
+	la	r6, r0, ex_tmp_data_loc_0;
+	sbi	r5, r6, 0;
+	lbui	r5, r4, 1;
+	sbi	r5, r6, 1;
+	lbui	r5, r4, 2;
+	sbi	r5, r6, 2;
+	lbui	r5, r4, 3;
+	sbi	r5, r6, 3;
+	brid	ex_lw_tail_vm;
+/* Get the destination register value into r3 - delay slot */
+	lwi	r3, r6, 0;
+ex_lhw_vm:
+	/* Load a half-word, byte-by-byte from destination address and
+	 * save it in tmp space */
+	la	r6, r0, ex_tmp_data_loc_0;
+	sbi	r5, r6, 0;
+	lbui	r5, r4, 1;
+	sbi	r5, r6, 1;
+	lhui	r3, r6, 0;	/* Get the destination register value into r3 */
+ex_lw_tail_vm:
+	/* Form load_word jump table offset (lw_table_vm + (8 * regnum)) */
+	addik	r5, r8, lw_table_vm;
+	bra	r5;
+ex_lw_end_vm:			/* Exception handling of load word, ends */
+	brai	ret_from_exc;
+ex_sw_vm:
+/* Form store_word jump table offset (sw_table_vm + (8 * regnum)) */
+	addik	r5, r8, sw_table_vm;
+	bra	r5;
+ex_sw_tail_vm:
+	la	r5, r0, ex_tmp_data_loc_0;
+	beqid	r6, ex_shw_vm;
+	swi	r3, r5, 0;	/* Get the word - delay slot */
+	/* Store the word, byte-by-byte into destination address */
+	lbui	r3, r5, 0;
+	sbi	r3, r4, 0;
+	lbui	r3, r5, 1;
+	sbi	r3, r4, 1;
+	lbui	r3, r5, 2;
+	sbi	r3, r4, 2;
+	lbui	r3, r5, 3;
+	brid	ret_from_exc;
+	sbi	r3, r4, 3;	/* Delay slot */
+ex_shw_vm:
+	/* Store the lower half-word, byte-by-byte into destination address */
+	lbui	r3, r5, 2;
+	sbi	r3, r4, 0;
+	lbui	r3, r5, 3;
+	brid	ret_from_exc;
+	sbi	r3, r4, 1;	/* Delay slot */
+ex_sw_end_vm:			/* Exception handling of store word, ends. */
+.end _unaligned_data_exception
+#endif /* CONFIG_MMU */
+
 ex_handler_unhandled:
 /* FIXME add handle function for unhandled exception - dump register */
 	bri 0
 
+/*
+ * hw_exception_handler Jump Table
+ * - Contains code snippets for each register that caused the unalign exception
+ * - Hence exception handler is NOT self-modifying
+ * - Separate table for load exceptions and store exceptions.
+ * - Each table is of size: (8 * 32) = 256 bytes
+ */
+
 .section .text
 .align 4
 lw_table:
@@ -407,7 +1061,11 @@ lw_r27:		R3_TO_LWREG	(27);
 lw_r28:		R3_TO_LWREG	(28);
 lw_r29:		R3_TO_LWREG	(29);
 lw_r30:		R3_TO_LWREG	(30);
+#ifdef CONFIG_MMU
+lw_r31: 	R3_TO_LWREG_V	(31);
+#else
 lw_r31:		R3_TO_LWREG	(31);
+#endif
 
 sw_table:
 sw_r0:		SWREG_TO_R3	(0);
@@ -441,7 +1099,81 @@ sw_r27:		SWREG_TO_R3	(27);
 sw_r28:		SWREG_TO_R3	(28);
 sw_r29:		SWREG_TO_R3	(29);
 sw_r30:		SWREG_TO_R3	(30);
+#ifdef CONFIG_MMU
+sw_r31:		SWREG_TO_R3_V	(31);
+#else
 sw_r31:		SWREG_TO_R3	(31);
+#endif
+
+#ifdef CONFIG_MMU
+lw_table_vm:
+lw_r0_vm:	R3_TO_LWREG_VM		(0);
+lw_r1_vm:	R3_TO_LWREG_VM_V	(1);
+lw_r2_vm:	R3_TO_LWREG_VM_V	(2);
+lw_r3_vm:	R3_TO_LWREG_VM_V	(3);
+lw_r4_vm:	R3_TO_LWREG_VM_V	(4);
+lw_r5_vm:	R3_TO_LWREG_VM_V	(5);
+lw_r6_vm:	R3_TO_LWREG_VM_V	(6);
+lw_r7_vm:	R3_TO_LWREG_VM_V	(7);
+lw_r8_vm:	R3_TO_LWREG_VM_V	(8);
+lw_r9_vm:	R3_TO_LWREG_VM_V	(9);
+lw_r10_vm:	R3_TO_LWREG_VM_V	(10);
+lw_r11_vm:	R3_TO_LWREG_VM_V	(11);
+lw_r12_vm:	R3_TO_LWREG_VM_V	(12);
+lw_r13_vm:	R3_TO_LWREG_VM_V	(13);
+lw_r14_vm:	R3_TO_LWREG_VM		(14);
+lw_r15_vm:	R3_TO_LWREG_VM_V	(15);
+lw_r16_vm:	R3_TO_LWREG_VM		(16);
+lw_r17_vm:	R3_TO_LWREG_VM_V	(17);
+lw_r18_vm:	R3_TO_LWREG_VM_V	(18);
+lw_r19_vm:	R3_TO_LWREG_VM		(19);
+lw_r20_vm:	R3_TO_LWREG_VM		(20);
+lw_r21_vm:	R3_TO_LWREG_VM		(21);
+lw_r22_vm:	R3_TO_LWREG_VM		(22);
+lw_r23_vm:	R3_TO_LWREG_VM		(23);
+lw_r24_vm:	R3_TO_LWREG_VM		(24);
+lw_r25_vm:	R3_TO_LWREG_VM		(25);
+lw_r26_vm:	R3_TO_LWREG_VM		(26);
+lw_r27_vm:	R3_TO_LWREG_VM		(27);
+lw_r28_vm:	R3_TO_LWREG_VM		(28);
+lw_r29_vm:	R3_TO_LWREG_VM		(29);
+lw_r30_vm:	R3_TO_LWREG_VM		(30);
+lw_r31_vm:	R3_TO_LWREG_VM_V	(31);
+
+sw_table_vm:
+sw_r0_vm:	SWREG_TO_R3_VM		(0);
+sw_r1_vm:	SWREG_TO_R3_VM_V	(1);
+sw_r2_vm:	SWREG_TO_R3_VM_V	(2);
+sw_r3_vm:	SWREG_TO_R3_VM_V	(3);
+sw_r4_vm:	SWREG_TO_R3_VM_V	(4);
+sw_r5_vm:	SWREG_TO_R3_VM_V	(5);
+sw_r6_vm:	SWREG_TO_R3_VM_V	(6);
+sw_r7_vm:	SWREG_TO_R3_VM_V	(7);
+sw_r8_vm:	SWREG_TO_R3_VM_V	(8);
+sw_r9_vm:	SWREG_TO_R3_VM_V	(9);
+sw_r10_vm:	SWREG_TO_R3_VM_V	(10);
+sw_r11_vm:	SWREG_TO_R3_VM_V	(11);
+sw_r12_vm:	SWREG_TO_R3_VM_V	(12);
+sw_r13_vm:	SWREG_TO_R3_VM_V	(13);
+sw_r14_vm:	SWREG_TO_R3_VM		(14);
+sw_r15_vm:	SWREG_TO_R3_VM_V	(15);
+sw_r16_vm:	SWREG_TO_R3_VM		(16);
+sw_r17_vm:	SWREG_TO_R3_VM_V	(17);
+sw_r18_vm:	SWREG_TO_R3_VM_V	(18);
+sw_r19_vm:	SWREG_TO_R3_VM		(19);
+sw_r20_vm:	SWREG_TO_R3_VM		(20);
+sw_r21_vm:	SWREG_TO_R3_VM		(21);
+sw_r22_vm:	SWREG_TO_R3_VM		(22);
+sw_r23_vm:	SWREG_TO_R3_VM		(23);
+sw_r24_vm:	SWREG_TO_R3_VM		(24);
+sw_r25_vm:	SWREG_TO_R3_VM		(25);
+sw_r26_vm:	SWREG_TO_R3_VM		(26);
+sw_r27_vm:	SWREG_TO_R3_VM		(27);
+sw_r28_vm:	SWREG_TO_R3_VM		(28);
+sw_r29_vm:	SWREG_TO_R3_VM		(29);
+sw_r30_vm:	SWREG_TO_R3_VM		(30);
+sw_r31_vm:	SWREG_TO_R3_VM_V	(31);
+#endif /* CONFIG_MMU */
 
 /* Temporary data structures used in the handler */
 .section .data
-- 
1.5.5.1

