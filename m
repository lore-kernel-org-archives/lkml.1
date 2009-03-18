Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZCRUdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZCRUdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZCRUbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:46 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56213 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752718AbZCRUbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:40 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 06/57] microblaze_v7: exception handling
Date: Wed, 18 Mar 2009 21:30:33 +0100
Message-Id: <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/exceptions.h      |   65 ++++
 arch/microblaze/kernel/exceptions.c           |  157 ++++++++
 arch/microblaze/kernel/hw_exception_handler.S |  470 +++++++++++++++++++++++++
 3 files changed, 692 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/exceptions.h
 create mode 100644 arch/microblaze/kernel/exceptions.c
 create mode 100644 arch/microblaze/kernel/hw_exception_handler.S

diff --git a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
new file mode 100644
index 0000000..cd41f6c
--- /dev/null
+++ b/arch/microblaze/include/asm/exceptions.h
@@ -0,0 +1,65 @@
+/*
+ * Preliminary support for HW exception handing for Microblaze
+ *
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2005 John Williams <jwilliams@itee.uq.edu.au>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_EXCEPTIONS_H
+#define _ASM_MICROBLAZE_EXCEPTIONS_H
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+/* Macros to enable and disable HW exceptions in the MSR */
+/* Define MSR enable bit for HW exceptions */
+#define HWEX_MSR_BIT (1 << 8)
+
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+#define __enable_hw_exceptions()					\
+	__asm__ __volatile__ ("	msrset	r0, %0;				\
+				nop;"					\
+				:					\
+				: "i" (HWEX_MSR_BIT)			\
+				: "memory")
+
+#define __disable_hw_exceptions()					\
+	__asm__ __volatile__ ("	msrclr r0, %0;				\
+				nop;"					\
+				:					\
+				: "i" (HWEX_MSR_BIT)			\
+				: "memory")
+#else /* !CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR */
+#define __enable_hw_exceptions()					\
+	__asm__ __volatile__ ("						\
+				mfs	r12, rmsr;			\
+				nop;					\
+				ori	r12, r12, %0;			\
+				mts	rmsr, r12;			\
+				nop;"					\
+				:					\
+				: "i" (HWEX_MSR_BIT)			\
+				: "memory", "r12")
+
+#define __disable_hw_exceptions()					\
+	__asm__ __volatile__ ("						\
+				mfs	r12, rmsr;			\
+				nop;					\
+				andi	r12, r12, ~%0;			\
+				mts	rmsr, r12;			\
+				nop;"					\
+				:					\
+				: "i" (HWEX_MSR_BIT)			\
+				: "memory", "r12")
+#endif /* CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR */
+
+asmlinkage void full_exception(struct pt_regs *regs, unsigned int type, int fsr, int addr);
+
+#endif /*__ASSEMBLY__ */
+#endif /* __KERNEL__ */
+#endif /* _ASM_MICROBLAZE_EXCEPTIONS_H */
diff --git a/arch/microblaze/kernel/exceptions.c b/arch/microblaze/kernel/exceptions.c
new file mode 100644
index 0000000..223ce19
--- /dev/null
+++ b/arch/microblaze/kernel/exceptions.c
@@ -0,0 +1,157 @@
+/*
+ *	arch/microblaze/kernel/exceptions.c - HW exception handling
+ *
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2008 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+/*
+ * This file handles the architecture-dependent parts of hardware exceptions
+ */
+
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+
+#include <asm/exceptions.h>
+#include <asm/entry.h>		/* For KM CPU var */
+#include <asm/uaccess.h>
+#include <asm/errno.h>
+#include <asm/ptrace.h>
+#include <asm/current.h>
+
+#ifdef CONFIG_XMON
+extern void xmon(struct pt_regs *regs);
+extern int xmon_bpt(struct pt_regs *regs);
+extern int xmon_sstep(struct pt_regs *regs);
+extern int xmon_iabr_match(struct pt_regs *regs);
+extern int xmon_dabr_match(struct pt_regs *regs);
+extern void (*xmon_fault_handler)(struct pt_regs *regs);
+#endif
+
+#ifdef CONFIG_XMON
+void (*debugger)(struct pt_regs *regs) = xmon;
+int (*debugger_bpt)(struct pt_regs *regs) = xmon_bpt;
+int (*debugger_sstep)(struct pt_regs *regs) = xmon_sstep;
+int (*debugger_iabr_match)(struct pt_regs *regs) = xmon_iabr_match;
+int (*debugger_dabr_match)(struct pt_regs *regs) = xmon_dabr_match;
+void (*debugger_fault_handler)(struct pt_regs *regs);
+#else
+#ifdef CONFIG_KGDB
+void (*debugger)(struct pt_regs *regs);
+int (*debugger_bpt)(struct pt_regs *regs);
+int (*debugger_sstep)(struct pt_regs *regs);
+int (*debugger_iabr_match)(struct pt_regs *regs);
+int (*debugger_dabr_match)(struct pt_regs *regs);
+void (*debugger_fault_handler)(struct pt_regs *regs);
+#else
+#define debugger(regs)			do { } while (0)
+#define debugger_bpt(regs)		0
+#define debugger_sstep(regs)		0
+#define debugger_iabr_match(regs)	0
+#define debugger_dabr_match(regs)	0
+#define debugger_fault_handler		((void (*)(struct pt_regs *))0)
+#endif
+#endif
+
+#define MICROBLAZE_ILL_OPCODE_EXCEPTION	0x02
+#define MICROBLAZE_IBUS_EXCEPTION	0x03
+#define MICROBLAZE_DBUS_EXCEPTION	0x04
+#define MICROBLAZE_DIV_ZERO_EXCEPTION	0x05
+#define MICROBLAZE_FPU_EXCEPTION	0x06
+#define MICROBLAZE_PRIVILEG_EXCEPTION	0x07
+
+static spinlock_t die_lock = SPIN_LOCK_UNLOCKED;
+
+void die(const char* str, struct pt_regs* fp, long err)
+{
+	console_verbose();
+	spin_lock_irq(&die_lock);
+	printk("Oops: %s, sig: %ld\n", str, err);
+	show_regs(fp);
+	spin_unlock_irq(&die_lock);
+	/* do_exit() should take care of panic'ing from an interrupt
+	 * context so we don't handle it here
+	 */
+	do_exit(err);
+}
+
+void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr)
+{
+	siginfo_t info;
+
+	if (kernel_mode(regs)) {
+		debugger(regs);
+		die("Exception in kernel mode", regs, signr);
+	}
+	info.si_signo = signr;
+	info.si_errno = 0;
+	info.si_code = code;
+	info.si_addr = (void __user *) addr;
+	force_sig_info(signr, &info, current);
+}
+
+asmlinkage void full_exception(struct pt_regs *regs, unsigned int type, int fsr, int addr)
+{
+#if 0
+	printk(KERN_WARNING "Exception %02x in %s mode, FSR=%08x PC=%08x ESR=%08x\n",
+			type, user_mode(regs) ? "user" : "kernel", fsr,
+			(unsigned int) regs->pc, (unsigned int) regs->esr);
+#endif
+
+	switch (type & 0x1F) {
+	case MICROBLAZE_ILL_OPCODE_EXCEPTION:
+		_exception(SIGILL, regs, ILL_ILLOPC, addr);
+		break;
+	case MICROBLAZE_IBUS_EXCEPTION:
+		if (user_mode(regs)) {
+			printk("Instruction bus error exception in user mode.\n");
+			_exception(SIGBUS, regs, BUS_ADRERR, addr);
+			return;
+		}
+		printk("Instruction bus error exception in kernel mode.\n");
+		die("bus exception", regs, SIGBUS);
+		break;
+	case MICROBLAZE_DBUS_EXCEPTION:
+		if (user_mode(regs)) {
+			printk("Data bus error exception in user mode.\n");
+			_exception(SIGBUS, regs, BUS_ADRERR, addr);
+			return;
+		}
+		printk("Data bus error exception in kernel mode.\n");
+		die("bus exception", regs, SIGBUS);
+		break;
+	case MICROBLAZE_DIV_ZERO_EXCEPTION:
+		printk("Divide by zero exception\n");
+		_exception(SIGILL, regs, ILL_ILLOPC, addr);
+		break;
+
+	case MICROBLAZE_FPU_EXCEPTION:
+		/* IEEE FP exception */
+		/* I removed fsr variable and use code var for storing fsr */
+		if (fsr & FSR_IO)
+			fsr = FPE_FLTINV;
+		else if (fsr & FSR_OF)
+			fsr = FPE_FLTOVF;
+		else if (fsr & FSR_UF)
+			fsr = FPE_FLTUND;
+		else if (fsr & FSR_DZ)
+			fsr = FPE_FLTDIV;
+		else if (fsr & FSR_DO)
+			fsr = FPE_FLTRES;
+		_exception(SIGFPE, regs, fsr, addr);
+		break;
+
+	default:
+		printk(KERN_WARNING "Unexpected exception %02x in %s mode, PC=%08x\n",
+			type, kernel_mode(regs) ? "kernel" : "user",(unsigned int) addr);
+	}
+	return;
+}
diff --git a/arch/microblaze/kernel/hw_exception_handler.S b/arch/microblaze/kernel/hw_exception_handler.S
new file mode 100644
index 0000000..b6dd3ae
--- /dev/null
+++ b/arch/microblaze/kernel/hw_exception_handler.S
@@ -0,0 +1,470 @@
+/*
+ * arch/microblaze/kernel/hw_exception_handler.S
+ *
+ * Exception handling for Microblaze
+ *
+ * Rewriten interrupt handling
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2008 PetaLogix
+ *
+ * uClinux customisation (C) 2005 John Williams
+ *
+ * MMU code derived from arch/ppc/kernel/head_4xx.S:
+ *	Copyright (C) 1995-1996 Gary Thomas <gdt@linuxppc.org>
+ *		Initial PowerPC version.
+ *	Copyright (C) 1996 Cort Dougan <cort@cs.nmt.edu>
+ *		Rewritten for PReP
+ *	Copyright (C) 1996 Paul Mackerras <paulus@cs.anu.edu.au>
+ *		Low-level exception handers, MMU support, and rewrite.
+ *	Copyright (C) 1997 Dan Malek <dmalek@jlc.net>
+ *		PowerPC 8xx modifications.
+ *	Copyright (C) 1998-1999 TiVo, Inc.
+ *		PowerPC 403GCX modifications.
+ *	Copyright (C) 1999 Grant Erickson <grant@lcse.umn.edu>
+ *		PowerPC 403GCX/405GP modifications.
+ *	Copyright 2000 MontaVista Software Inc.
+ *		PPC405 modifications
+ *	PowerPC 403GCX/405GP modifications.
+ *		Author: MontaVista Software, Inc.
+ *		frank_rowand@mvista.com or source@mvista.com
+ *		debbie_chu@mvista.com
+ *
+ * Original code
+ * Copyright (C) 2004 Xilinx, Inc. All rights reserved.
+ *
+ * Xilinx, Inc.
+ * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
+ * COURTESY TO YOU. BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
+ * ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
+ * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
+ * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
+ * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
+ * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
+ * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
+ * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
+ * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
+ * AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * $Id: hw_exception_handler.S,v 1.1.2.9 2007/12/07 10:41:28 vvlasov Exp $
+ *
+ *
+ * Here are the handlers which don't require enabling translation and calling other kernel code
+ * thus we can keep their design very simple and do all processing in real mode.
+ * All what they need is a valid current (that is an issue for the CONFIG_REGISTER_TASK_PTR case)
+ * This handlers use r3,r4,r5,r6 and optionally r[current] to work therefore these registers are saved/restored
+ * The handlers which require translation are in entry.S --KAA
+ *
+ * Microblaze HW Exception Handler
+ * - Non self-modifying exception handler for the following exception conditions
+ *   - Unalignment
+ *   - Instruction bus error
+ *   - Data bus error
+ *   - Illegal instruction opcode
+ *   - Divide-by-zero
+ *
+ * Note we disable interrupts during exception handling, otherwise we will possibly
+ * get multiple re-entrancy if interrupt handles themselves cause exceptions. JW
+ */
+
+#include <asm/exceptions.h>
+#include <asm/unistd.h>
+#include <asm/page.h>
+
+#include <asm/entry.h>
+#include <asm/current.h>
+#include <linux/linkage.h>
+
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+#include <asm/asm-offsets.h>
+
+/* Helpful Macros */
+#define EX_HANDLER_STACK_SIZ	(4*19)
+#define NUM_TO_REG(num)		r ## num
+
+#define LWREG_NOP			\
+	bri	ex_handler_unhandled;	\
+	nop;
+
+#define SWREG_NOP			\
+	bri	ex_handler_unhandled;	\
+	nop;
+
+/* FIXME this is weird - for noMMU kernel is not possible to use brid 
+ * instruction which can shorten executed time
+ */
+
+/* r3 is the source */
+#define R3_TO_LWREG_V(regnum)				\
+	swi	r3, r1, 4 * regnum;				\
+	bri	ex_handler_done;
+
+/* r3 is the source */
+#define R3_TO_LWREG(regnum)				\
+	or	NUM_TO_REG (regnum), r0, r3;		\
+	bri	ex_handler_done;
+
+/* r3 is the target */
+#define SWREG_TO_R3_V(regnum)				\
+	lwi	r3, r1, 4 * regnum;				\
+	bri	ex_sw_tail;
+
+/* r3 is the target */
+#define SWREG_TO_R3(regnum)				\
+	or	r3, r0, NUM_TO_REG (regnum);		\
+	bri	ex_sw_tail;
+
+.extern other_exception_handler /* Defined in exception.c */
+
+/*
+ * hw_exception_handler - Handler for exceptions
+ *
+ * Exception handler notes:
+ * - Handles all exceptions
+ * - Does not handle unaligned exceptions during load into r17, r1, r0.
+ * - Does not handle unaligned exceptions during store from r17 (cannot be
+ *   done) and r1 (slows down common case)
+ *
+ *  Relevant register structures
+ *
+ *  EAR - |----|----|----|----|----|----|----|----|
+ *      - <  ##   32 bit faulting address     ##  >
+ *
+ *  ESR - |----|----|----|----|----| - | - |-----|-----|
+ *      -                            W   S   REG   EXC
+ *
+ *
+ * STACK FRAME STRUCTURE (for NO_MMU)
+ * ---------------------------------
+ *
+ *      +-------------+         + 0
+ *      |     MSR     |
+ *      +-------------+         + 4
+ *      |     r1      |
+ *      |      .      |
+ *      |      .      |
+ *      |      .      |
+ *      |      .      |
+ *      |     r18     |
+ *      +-------------+         + 76
+ *      |      .      |
+ *      |      .      |
+ *
+ * NO_MMU kernel use the same r0_ram pointed space - look to vmlinux.lds.S
+ * which is used for storing register values - old style was, that value were
+ * stored in stack but in case of failure you lost information about register.
+ * Currently you can see register value in memory in specific place.
+ * In compare to with previous solution the speed should be the same.
+ *
+ * MMU exception handler has different handling compare to no MMU kernel.
+ * Exception handler use jump table for directing of what happen. For MMU kernel
+ * is this approach better because MMU relate exception are handled by asm code
+ * in this file. In compare to with MMU expect of unaligned exception is everything
+ * handled by C code.
+ */
+
+/* every of these handlers is entered having R3/4/5/6/11/current saved on stack and clobbered
+ * so care should be taken to restore them if someone is going to return from exception */
+
+/* wrappers to restore state before coming to entry.S */
+
+.global _hw_exception_handler
+.section .text
+.align 4
+.ent _hw_exception_handler
+_hw_exception_handler:
+	addik	r1, r1, -(EX_HANDLER_STACK_SIZ); /* Create stack frame */
+	swi	r3, r1, PT_R3
+	swi	r4, r1, PT_R4
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+
+	mfs	r5, rmsr;
+	nop
+	swi	r5, r1, 0;
+	mfs	r4, rbtr		/* Save BTR before jumping to handler */
+	nop
+	mfs	r3, resr
+	nop
+
+	andi	r5, r3, 0x1000;		/* Check ESR[DS] */
+	beqi	r5, not_in_delay_slot;	/* Branch if ESR[DS] not set */
+	mfs	r17, rbtr;		/* ESR[DS] set - return address in BTR */
+	nop
+not_in_delay_slot:
+	swi	r17, r1, PT_R17
+
+	andi	r5, r3, 0x1F;		/* Extract ESR[EXC] */
+
+	/* Exceptions enabled here. This will allow nested exceptions */
+	mfs	r6, rmsr;
+	nop
+	swi	r6, r1, 0; /* RMSR_OFFSET */
+	ori	r6, r6, 0x100; /* Turn ON the EE bit */
+	andi	r6, r6, ~2; /* Disable interrupts */
+	mts	rmsr, r6;
+	nop
+
+	xori	r6, r5, 1; /* 00001 = Unaligned Exception */
+	/* Jump to unalignment exception handler */
+	beqi	r6, handle_unaligned_ex;
+
+handle_other_ex: /* Handle Other exceptions here */
+	/* Save other volatiles before we make procedure calls below */
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	swi	r12, r1, PT_R12
+	swi	r14, r1, PT_R14
+	swi	r15, r1, PT_R15
+	swi	r18, r1, PT_R18
+
+	or	r5, r1, r0
+	andi	r6, r3, 0x1F; /* Load ESR[EC] */
+	lwi	r7, r0, PER_CPU(KM) /* MS: saving current kernel mode to regs */
+	swi	r7, r1, PT_MODE
+	mfs	r7, rfsr
+	nop
+	addk	r8, r17, r0; /* Load exception address */
+	bralid	r15, full_exception; /* Branch to the handler */
+	nop;
+
+	/*
+	 * Trigger execution of the signal handler by enabling
+	 * interrupts and calling an invalid syscall.
+	 */
+	mfs	r5, rmsr;
+	nop
+	ori	r5, r5, 2;
+	mts	rmsr, r5; /* enable interrupt */
+	nop
+	addi	r12, r0, __NR_syscalls;
+	brki	r14, 0x08;
+	mfs	r5, rmsr; /* disable interrupt */
+	nop
+	andi	r5, r5, ~2;
+	mts	rmsr, r5;
+	nop
+
+	lwi	r7, r1, PT_R7
+	lwi	r8, r1, PT_R8
+	lwi	r9, r1, PT_R9
+	lwi	r10, r1, PT_R10
+	lwi	r11, r1, PT_R11
+	lwi	r12, r1, PT_R12
+	lwi	r14, r1, PT_R14
+	lwi	r15, r1, PT_R15
+	lwi	r18, r1, PT_R18
+
+	bri	ex_handler_done; /* Complete exception handling */
+
+/* 0x01 - Unaligned data access exception
+ * This occurs when a word access is not aligned on a word boundary,
+ * or when a 16-bit access is not aligned on a 16-bit boundary.
+ * This handler perform the access, and returns, except for MMU when
+ * the unaligned address is last on a 4k page or the physical address is
+ * not found in the page table, in which case unaligned_data_trap is called.
+ */
+handle_unaligned_ex:
+	/* Working registers already saved: R3, R4, R5, R6
+	 *  R3 = ESR
+	 *  R4 = BTR
+	 */
+	mfs	r4, rear;
+	nop
+
+	andi	r6, r3, 0x3E0; /* Mask and extract the register operand */
+	srl	r6, r6; /* r6 >> 5 */
+	srl	r6, r6;
+	srl	r6, r6;
+	srl	r6, r6;
+	srl	r6, r6;
+	/* Store the register operand in a temporary location */
+	sbi	r6, r0, ex_reg_op;
+
+	andi	r6, r3, 0x400; /* Extract ESR[S] */
+	bnei	r6, ex_sw;
+ex_lw:
+	andi	r6, r3, 0x800; /* Extract ESR[W] */
+	beqi	r6, ex_lhw;
+	lbui	r5, r4, 0; /* Exception address in r4 */
+	/* Load a word, byte-by-byte from destination address
+		and save it in tmp space */
+	sbi	r5, r0, TOPHYS(ex_tmp_data_loc_0);
+	lbui	r5, r4, 1;
+	sbi	r5, r0, TOPHYS(ex_tmp_data_loc_1);
+	lbui	r5, r4, 2;
+	sbi	r5, r0, TOPHYS(ex_tmp_data_loc_2);
+	lbui	r5, r4, 3;
+	sbi	r5, r0, TOPHYS(ex_tmp_data_loc_3);
+	/* Get the destination register value into r3 */
+	lwi	r3, r0, TOPHYS(ex_tmp_data_loc_0);
+	bri	ex_lw_tail;
+ex_lhw:
+	lbui	r5, r4, 0; /* Exception address in r4 */
+	/* Load a half-word, byte-by-byte from destination
+		address and save it in tmp space */
+	sbi	r5, r0, TOPHYS(ex_tmp_data_loc_0);
+	lbui	r5, r4, 1;
+	sbi	r5, r0, TOPHYS(ex_tmp_data_loc_1);
+	/* Get the destination register value into r3 */
+	lhui	r3, r0, TOPHYS(ex_tmp_data_loc_0);
+ex_lw_tail:
+	/* Get the destination register number into r5 */
+	lbui	r5, r0, TOPHYS(ex_reg_op);
+	/* Form load_word jump table offset (lw_table + (8 * regnum)) */
+	la	r6, r0, TOPHYS(lw_table);
+	addk	r5, r5, r5;
+	addk	r5, r5, r5;
+	addk	r5, r5, r5;
+	addk	r5, r5, r6;
+	bra	r5;
+ex_lw_end: /* Exception handling of load word, ends */
+ex_sw:
+	/* Get the destination register number into r5 */
+	lbui	r5, r0, TOPHYS(ex_reg_op);
+	/* Form store_word jump table offset (sw_table + (8 * regnum)) */
+	la	r6, r0, TOPHYS(sw_table);
+	add	r5, r5, r5;
+	add	r5, r5, r5;
+	add	r5, r5, r5;
+	add	r5, r5, r6;
+	bra	r5;
+ex_sw_tail:
+	mfs	r6, resr;
+	nop
+	andi	r6, r6, 0x800; /* Extract ESR[W] */
+	beqi	r6, ex_shw;
+	swi	r3, r0, TOPHYS(ex_tmp_data_loc_0); /* Get the word - delay slot */
+	/* Store the word, byte-by-byte into destination address */
+	lbui	r3, r0, TOPHYS(ex_tmp_data_loc_0);
+	sbi	r3, r4, 0;
+	lbui	r3, r0, TOPHYS(ex_tmp_data_loc_1);
+	sbi	r3, r4, 1;
+	lbui	r3, r0, TOPHYS(ex_tmp_data_loc_2);
+	sbi	r3, r4, 2;
+	lbui	r3, r0, TOPHYS(ex_tmp_data_loc_3);
+	sbi	r3, r4, 3;
+	bri	ex_handler_done;
+
+ex_shw:
+	/* Store the lower half-word, byte-by-byte into destination address */
+	swi	r3, r0, TOPHYS(ex_tmp_data_loc_0);
+	lbui	r3, r0, TOPHYS(ex_tmp_data_loc_2);
+	sbi	r3, r4, 0;
+	lbui	r3, r0, TOPHYS(ex_tmp_data_loc_3);
+	sbi	r3, r4, 1;
+ex_sw_end: /* Exception handling of store word, ends. */
+
+ex_handler_done:
+	lwi	r5, r1, 0 /* RMSR */
+	mts	rmsr, r5
+	nop
+	lwi	r3, r1, PT_R3
+	lwi	r4, r1, PT_R4
+	lwi	r5, r1, PT_R5
+	lwi	r6, r1, PT_R6
+	lwi	r17, r1, PT_R17
+
+	rted	r17, 0
+	addik	r1, r1, (EX_HANDLER_STACK_SIZ); /* Restore stack frame */
+
+.end _hw_exception_handler
+
+ex_handler_unhandled:
+/* FIXME add handle function for unhandled exception - for example dump register */
+	bri 0
+
+/*
+ * hw_exception_handler Jump Table
+ * - Contains code snippets for each register that caused the unaligned exception
+ * - Hence exception handler is NOT self-modifying
+ * - Separate table for load exceptions and store exceptions.
+ * - Each table is of size: (8 * 32) = 256 bytes
+ */
+
+.section .text
+.align 4
+lw_table:
+lw_r0:		R3_TO_LWREG	(0);
+lw_r1:		LWREG_NOP;
+lw_r2:		R3_TO_LWREG	(2);
+lw_r3:		R3_TO_LWREG_V	(3);
+lw_r4:		R3_TO_LWREG_V	(4);
+lw_r5:		R3_TO_LWREG_V	(5);
+lw_r6:		R3_TO_LWREG_V	(6);
+lw_r7:		R3_TO_LWREG	(7);
+lw_r8:		R3_TO_LWREG	(8);
+lw_r9:		R3_TO_LWREG	(9);
+lw_r10:		R3_TO_LWREG	(10);
+lw_r11:		R3_TO_LWREG	(11);
+lw_r12:		R3_TO_LWREG	(12);
+lw_r13:		R3_TO_LWREG	(13);
+lw_r14:		R3_TO_LWREG	(14);
+lw_r15:		R3_TO_LWREG	(15);
+lw_r16:		R3_TO_LWREG	(16);
+lw_r17:		LWREG_NOP;
+lw_r18:		R3_TO_LWREG	(18);
+lw_r19:		R3_TO_LWREG	(19);
+lw_r20:		R3_TO_LWREG	(20);
+lw_r21:		R3_TO_LWREG	(21);
+lw_r22:		R3_TO_LWREG	(22);
+lw_r23:		R3_TO_LWREG	(23);
+lw_r24:		R3_TO_LWREG	(24);
+lw_r25:		R3_TO_LWREG	(25);
+lw_r26:		R3_TO_LWREG	(26);
+lw_r27:		R3_TO_LWREG	(27);
+lw_r28:		R3_TO_LWREG	(28);
+lw_r29:		R3_TO_LWREG	(29);
+lw_r30:		R3_TO_LWREG	(30);
+lw_r31:		R3_TO_LWREG	(31);
+
+sw_table:
+sw_r0:		SWREG_TO_R3	(0);
+sw_r1:		SWREG_NOP;
+sw_r2:		SWREG_TO_R3	(2);
+sw_r3:		SWREG_TO_R3_V	(3);
+sw_r4:		SWREG_TO_R3_V	(4);
+sw_r5:		SWREG_TO_R3_V	(5);
+sw_r6:		SWREG_TO_R3_V	(6);
+sw_r7:		SWREG_TO_R3	(7);
+sw_r8:		SWREG_TO_R3	(8);
+sw_r9:		SWREG_TO_R3	(9);
+sw_r10:		SWREG_TO_R3	(10);
+sw_r11:		SWREG_TO_R3	(11);
+sw_r12:		SWREG_TO_R3	(12);
+sw_r13:		SWREG_TO_R3	(13);
+sw_r14:		SWREG_TO_R3	(14);
+sw_r15:		SWREG_TO_R3	(15);
+sw_r16:		SWREG_TO_R3	(16);
+sw_r17:		SWREG_NOP;
+sw_r18:		SWREG_TO_R3	(18);
+sw_r19:		SWREG_TO_R3	(19);
+sw_r20:		SWREG_TO_R3	(20);
+sw_r21:		SWREG_TO_R3	(21);
+sw_r22:		SWREG_TO_R3	(22);
+sw_r23:		SWREG_TO_R3	(23);
+sw_r24:		SWREG_TO_R3	(24);
+sw_r25:		SWREG_TO_R3	(25);
+sw_r26:		SWREG_TO_R3	(26);
+sw_r27:		SWREG_TO_R3	(27);
+sw_r28:		SWREG_TO_R3	(28);
+sw_r29:		SWREG_TO_R3	(29);
+sw_r30:		SWREG_TO_R3	(30);
+sw_r31:		SWREG_TO_R3	(31);
+
+/* Temporary data structures used in the handler */
+.section .data
+.align 4
+ex_tmp_data_loc_0:
+	.byte 0
+ex_tmp_data_loc_1:
+	.byte 0
+ex_tmp_data_loc_2:
+	.byte 0
+ex_tmp_data_loc_3:
+	.byte 0
+ex_reg_op:
+	.byte 0
-- 
1.5.5.1

