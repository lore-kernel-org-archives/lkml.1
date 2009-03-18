Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZCRUhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZCRUhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZCRUcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:32:02 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56239 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753593AbZCRUbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:46 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 15/57] microblaze_v7: assembler files head.S, entry-nommu.S, syscall_table.S
Date: Wed, 18 Mar 2009 21:30:42 +0100
Message-Id: <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/entry-nommu.S   |  594 ++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/head.S          |   55 +++
 arch/microblaze/kernel/syscall_table.S |  365 ++++++++++++++++++++
 3 files changed, 1014 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/entry-nommu.S
 create mode 100644 arch/microblaze/kernel/head.S
 create mode 100644 arch/microblaze/kernel/syscall_table.S

diff --git a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
new file mode 100644
index 0000000..5678f17
--- /dev/null
+++ b/arch/microblaze/kernel/entry-nommu.S
@@ -0,0 +1,594 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+#include <asm/errno.h>
+#include <asm/entry.h>
+#include <asm/asm-offsets.h>
+#include <asm/registers.h>
+#include <asm/unistd.h>
+#include <asm/percpu.h>
+#include <asm/signal.h>
+
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+	.macro	disable_irq
+	msrclr r0, MSR_IE
+	.endm
+
+	.macro	enable_irq
+	msrset r0, MSR_IE
+	.endm
+
+	.macro	clear_bip
+	msrclr r0, MSR_BIP
+	.endm
+#else
+	.macro	disable_irq
+	mfs r11, rmsr
+	andi r11, r11, ~MSR_IE
+	mts rmsr, r11
+	.endm
+
+	.macro	enable_irq
+	mfs r11, rmsr
+	ori r11, r11, MSR_IE
+	mts rmsr, r11
+	.endm
+
+	.macro	clear_bip
+	mfs r11, rmsr
+	andi r11, r11, ~MSR_BIP
+	mts rmsr, r11
+	.endm
+#endif
+
+ENTRY(_interrupt)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+	beqid	r11, 1f
+	nop
+	brid	2f				/* jump over */
+	addik	r1, r1, (-PT_SIZE)	/* room for pt_regs (delay slot) */
+1:						/* switch to kernel stack */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	/* calculate kernel stack pointer */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE
+2:
+	swi	r11, r1, PT_MODE		/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3
+	swi	r4, r1, PT_R4
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	swi	r14, r1, PT_R14
+	swi	r14, r1, PT_PC
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* prepare the link register, the argument and jump */
+	la	r15, r0, ret_from_intr - 8
+	addk	r6, r0, r15
+	braid	do_IRQ
+	add	r5, r0, r1
+
+ret_from_intr:
+	lwi	r11, r1, PT_MODE
+	bneid	r11, 3f
+
+	lwi	r6, r31, TS_THREAD_INFO	/* get thread info */
+	lwi	r19, r6, TI_FLAGS	/* get flags in thread info */
+				/* do an extra work if any bits are set */
+
+	andi	r11, r19, _TIF_NEED_RESCHED
+	beqi	r11, 1f
+	bralid	r15, schedule
+	nop
+1:	andi	r11, r19, _TIF_SIGPENDING
+	beqid	r11, no_intr_reshed
+	addk	r5, r1, r0
+	addk	r7, r0, r0
+	bralid	r15, do_signal
+	addk	r6, r0, r0
+
+no_intr_reshed:
+	/* save mode indicator */
+	lwi	r11, r1, PT_MODE
+3:
+	swi	r11, r0, PER_CPU(KM)
+
+	/* save r31 */
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+restore_context:
+	/* special purpose registers */
+	lwi	r11, r1, PT_FSR
+	mts	rfsr, r11
+	lwi	r11, r1, PT_ESR
+	mts	resr, r11
+	lwi	r11, r1, PT_EAR
+	mts	rear, r11
+	lwi	r11, r1, PT_MSR
+	mts	rmsr, r11
+
+	lwi	r31, r1, PT_R31
+	lwi	r30, r1, PT_R30
+	lwi	r29, r1, PT_R29
+	lwi	r28, r1, PT_R28
+	lwi	r27, r1, PT_R27
+	lwi	r26, r1, PT_R26
+	lwi	r25, r1, PT_R25
+	lwi	r24, r1, PT_R24
+	lwi	r23, r1, PT_R23
+	lwi	r22, r1, PT_R22
+	lwi	r21, r1, PT_R21
+	lwi	r20, r1, PT_R20
+	lwi	r19, r1, PT_R19
+	lwi	r18, r1, PT_R18
+	lwi	r17, r1, PT_R17
+	lwi	r16, r1, PT_R16
+	lwi	r15, r1, PT_R15
+	lwi	r14, r1, PT_PC
+	lwi	r13, r1, PT_R13
+	lwi	r12, r1, PT_R12
+	lwi	r11, r1, PT_R11
+	lwi	r10, r1, PT_R10
+	lwi	r9, r1, PT_R9
+	lwi	r8, r1, PT_R8
+	lwi	r7, r1, PT_R7
+	lwi	r6, r1, PT_R6
+	lwi	r5, r1, PT_R5
+	lwi	r4, r1, PT_R4
+	lwi	r3, r1, PT_R3
+	lwi	r2, r1, PT_R2
+	lwi	r1, r1, PT_R1
+	rtid	r14, 0
+	nop
+
+ENTRY(_reset)
+	brai	0;
+
+ENTRY(_user_exception)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+	beqid	r11, 1f				/* Already in kernel mode? */
+	nop
+	brid	2f				/* jump over */
+	addik	r1, r1, (-PT_SIZE)	/* Room for pt_regs (delay slot) */
+1:						/* Switch to kernel stack */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	/* calculate kernel stack pointer */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+2:
+	swi	r11, r1, PT_MODE		/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	/* save them on stack */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3 /* r3: _always_ in clobber list; see unistd.h */
+	swi	r4, r1, PT_R4 /* r4: _always_ in clobber list; see unistd.h */
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	/* r12: _always_ in clobber list; see unistd.h */
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	/* r14: _always_ in clobber list; see unistd.h */
+	swi	r14, r1, PT_R14
+	/* but we want to return to the next inst. */
+	addik	r14, r14, 0x4
+	swi	r14, r1, PT_PC		/* increment by 4 and store in pc */
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+
+	disable_irq
+	nop		/* make sure IE bit is in effect */
+	clear_bip	/* once IE is in effect it is safe to clear BIP */
+	nop
+
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* re-enable interrupts now we are in kernel mode */
+	enable_irq
+
+	/* See if the system call number is valid. */
+	addi	r11, r12, -__NR_syscalls
+	bgei	r11, 1f			/* return to user if not valid */
+	/* Figure out which function to use for this system call. */
+	/* Note Microblaze barrel shift is optional, so don't rely on it */
+	add	r12, r12, r12			/* convert num -> ptr */
+	add	r12, r12, r12
+	lwi	r12, r12, sys_call_table	/* Get function pointer */
+	la	r15, r0, ret_to_user-8		/* set return address */
+	bra	r12				/* Make the system call. */
+	bri	0				/* won't reach here */
+1:
+	brid	ret_to_user			/* jump to syscall epilogue */
+	addi	r3, r0, -ENOSYS			/* set errno in delay slot */
+
+/*
+ * Debug traps are like a system call, but entered via brki r14, 0x60
+ * All we need to do is send the SIGTRAP signal to current, ptrace and do_signal
+ * will handle the rest
+ */
+ENTRY(_debug_exception)
+	swi	r1, r0, PER_CPU(ENTRY_SP)	/* save the current sp */
+	lwi	r1, r0, PER_CPU(CURRENT_SAVE)	/* get the saved current */
+	lwi	r1, r1, TS_THREAD_INFO		/* get the thread info */
+	addik	r1, r1, THREAD_SIZE - PT_SIZE	/* get the kernel stack */
+	swi	r11, r0, PER_CPU(R11_SAVE)	/* temporarily save r11 */
+	lwi	r11, r0, PER_CPU(KM)		/* load mode indicator */
+//save_context:
+	swi	r11, r1, PT_MODE	/* store the mode */
+	lwi	r11, r0, PER_CPU(R11_SAVE)	/* reload r11 */
+	/* save them on stack */
+	swi	r2, r1, PT_R2
+	swi	r3, r1, PT_R3 /* r3: _always_ in clobber list; see unistd.h */
+	swi	r4, r1, PT_R4 /* r4: _always_ in clobber list; see unistd.h */
+	swi	r5, r1, PT_R5
+	swi	r6, r1, PT_R6
+	swi	r7, r1, PT_R7
+	swi	r8, r1, PT_R8
+	swi	r9, r1, PT_R9
+	swi	r10, r1, PT_R10
+	swi	r11, r1, PT_R11
+	/* r12: _always_ in clobber list; see unistd.h */
+	swi	r12, r1, PT_R12
+	swi	r13, r1, PT_R13
+	/* r14: _always_ in clobber list; see unistd.h */
+	swi	r14, r1, PT_R14
+	swi	r14, r1, PT_PC /* Will return to interrupted instruction */
+	swi	r15, r1, PT_R15
+	swi	r16, r1, PT_R16
+	swi	r17, r1, PT_R17
+	swi	r18, r1, PT_R18
+	swi	r19, r1, PT_R19
+	swi	r20, r1, PT_R20
+	swi	r21, r1, PT_R21
+	swi	r22, r1, PT_R22
+	swi	r23, r1, PT_R23
+	swi	r24, r1, PT_R24
+	swi	r25, r1, PT_R25
+	swi	r26, r1, PT_R26
+	swi	r27, r1, PT_R27
+	swi	r28, r1, PT_R28
+	swi	r29, r1, PT_R29
+	swi	r30, r1, PT_R30
+	swi	r31, r1, PT_R31
+
+	disable_irq
+	nop		/* make sure IE bit is in effect */
+	clear_bip	/* once IE is in effect it is safe to clear BIP */
+	nop
+
+	/* special purpose registers */
+	mfs	r11, rmsr
+	swi	r11, r1, PT_MSR
+	mfs	r11, rear
+	swi	r11, r1, PT_EAR
+	mfs	r11, resr
+	swi	r11, r1, PT_ESR
+	mfs	r11, rfsr
+	swi	r11, r1, PT_FSR
+	/* reload original stack pointer and save it */
+	lwi	r11, r0, PER_CPU(ENTRY_SP)
+	swi	r11, r1, PT_R1
+	/* update mode indicator we are in kernel mode */
+	addik	r11, r0, 1
+	swi	r11, r0, PER_CPU(KM)
+	/* restore r31 */
+	lwi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* re-enable interrupts now we are in kernel mode */
+	enable_irq
+
+	addi	r5, r0, SIGTRAP			/* sending the trap signal */
+	add	r6, r0, r31			/* to current */
+	bralid	r15, send_sig
+	add	r7, r0, r0			/* 3rd param zero */
+
+	/* Restore r3/r4 to work around how ret_to_user works */
+	lwi	r3, r1, PT_R3
+	lwi	r4, r1, PT_R4
+	bri	ret_to_user
+
+ENTRY(_break)
+	bri	0
+
+/* struct task_struct *_switch_to(struct thread_info *prev,
+					struct thread_info *next); */
+ENTRY(_switch_to)
+	/* prepare return value */
+	addk	r3, r0, r31
+
+	/* save registers in cpu_context */
+	/* use r11 and r12, volatile registers, as temp register */
+	addik	r11, r5, TI_CPU_CONTEXT
+	swi	r1, r11, CC_R1
+	swi	r2, r11, CC_R2
+	/* skip volatile registers.
+	 * they are saved on stack when we jumped to _switch_to() */
+	/* dedicated registers */
+	swi	r13, r11, CC_R13
+	swi	r14, r11, CC_R14
+	swi	r15, r11, CC_R15
+	swi	r16, r11, CC_R16
+	swi	r17, r11, CC_R17
+	swi	r18, r11, CC_R18
+	/* save non-volatile registers */
+	swi	r19, r11, CC_R19
+	swi	r20, r11, CC_R20
+	swi	r21, r11, CC_R21
+	swi	r22, r11, CC_R22
+	swi	r23, r11, CC_R23
+	swi	r24, r11, CC_R24
+	swi	r25, r11, CC_R25
+	swi	r26, r11, CC_R26
+	swi	r27, r11, CC_R27
+	swi	r28, r11, CC_R28
+	swi	r29, r11, CC_R29
+	swi	r30, r11, CC_R30
+	/* special purpose registers */
+	mfs	r12, rmsr
+	swi	r12, r11, CC_MSR
+	mfs	r12, rear
+	swi	r12, r11, CC_EAR
+	mfs	r12, resr
+	swi	r12, r11, CC_ESR
+	mfs	r12, rfsr
+	swi	r12, r11, CC_FSR
+
+	/* update r31, the current */
+	lwi	r31, r6, TI_TASK
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+
+	/* get new process' cpu context and restore */
+	addik	r11, r6, TI_CPU_CONTEXT
+
+	/* special purpose registers */
+	lwi	r12, r11, CC_FSR
+	mts	rfsr, r12
+	lwi	r12, r11, CC_ESR
+	mts	resr, r12
+	lwi	r12, r11, CC_EAR
+	mts	rear, r12
+	lwi	r12, r11, CC_MSR
+	mts	rmsr, r12
+	/* non-volatile registers */
+	lwi	r30, r11, CC_R30
+	lwi	r29, r11, CC_R29
+	lwi	r28, r11, CC_R28
+	lwi	r27, r11, CC_R27
+	lwi	r26, r11, CC_R26
+	lwi	r25, r11, CC_R25
+	lwi	r24, r11, CC_R24
+	lwi	r23, r11, CC_R23
+	lwi	r22, r11, CC_R22
+	lwi	r21, r11, CC_R21
+	lwi	r20, r11, CC_R20
+	lwi	r19, r11, CC_R19
+	/* dedicated registers */
+	lwi	r18, r11, CC_R18
+	lwi	r17, r11, CC_R17
+	lwi	r16, r11, CC_R16
+	lwi	r15, r11, CC_R15
+	lwi	r14, r11, CC_R14
+	lwi	r13, r11, CC_R13
+	/* skip volatile registers */
+	lwi	r2, r11, CC_R2
+	lwi	r1, r11, CC_R1
+
+	rtsd	r15, 8
+	nop
+
+ENTRY(ret_from_fork)
+	addk	r5, r0, r3
+	addk	r6, r0, r1
+	brlid	r15, schedule_tail
+	nop
+	swi	r31, r1, PT_R31		/* save r31 in user context. */
+			/* will soon be restored to r31 in ret_to_user */
+	addk	r3, r0, r0
+	brid	ret_to_user
+	nop
+
+work_pending:
+	andi	r11, r19, _TIF_NEED_RESCHED
+	beqi	r11, 1f
+	bralid	r15, schedule
+	nop
+1:	andi	r11, r19, _TIF_SIGPENDING
+	beqi	r11, no_work_pending
+	addk	r5, r1, r0
+	addik	r7, r0, 1
+	bralid	r15, do_signal
+	addk	r6, r0, r0
+	bri	no_work_pending
+
+ENTRY(ret_to_user)
+	disable_irq
+
+	swi	r4, r1, PT_R4		/* return val */
+	swi	r3, r1, PT_R3		/* return val */
+
+	lwi	r6, r31, TS_THREAD_INFO /* get thread info */
+	lwi	r19, r6, TI_FLAGS /* get flags in thread info */
+	bnei	r19, work_pending /* do an extra work if any bits are set */
+no_work_pending:
+	disable_irq
+
+	/* save r31 */
+	swi	r31, r0, PER_CPU(CURRENT_SAVE)
+	/* save mode indicator */
+	lwi	r18, r1, PT_MODE
+	swi	r18, r0, PER_CPU(KM)
+//restore_context:
+	/* special purpose registers */
+	lwi	r18, r1, PT_FSR
+	mts	rfsr, r18
+	lwi	r18, r1, PT_ESR
+	mts	resr, r18
+	lwi	r18, r1, PT_EAR
+	mts	rear, r18
+	lwi	r18, r1, PT_MSR
+	mts	rmsr, r18
+
+	lwi	r31, r1, PT_R31
+	lwi	r30, r1, PT_R30
+	lwi	r29, r1, PT_R29
+	lwi	r28, r1, PT_R28
+	lwi	r27, r1, PT_R27
+	lwi	r26, r1, PT_R26
+	lwi	r25, r1, PT_R25
+	lwi	r24, r1, PT_R24
+	lwi	r23, r1, PT_R23
+	lwi	r22, r1, PT_R22
+	lwi	r21, r1, PT_R21
+	lwi	r20, r1, PT_R20
+	lwi	r19, r1, PT_R19
+	lwi	r18, r1, PT_R18
+	lwi	r17, r1, PT_R17
+	lwi	r16, r1, PT_R16
+	lwi	r15, r1, PT_R15
+	lwi	r14, r1, PT_PC
+	lwi	r13, r1, PT_R13
+	lwi	r12, r1, PT_R12
+	lwi	r11, r1, PT_R11
+	lwi	r10, r1, PT_R10
+	lwi	r9, r1, PT_R9
+	lwi	r8, r1, PT_R8
+	lwi	r7, r1, PT_R7
+	lwi	r6, r1, PT_R6
+	lwi	r5, r1, PT_R5
+	lwi	r4, r1, PT_R4		/* return val */
+	lwi	r3, r1, PT_R3		/* return val */
+	lwi	r2, r1, PT_R2
+	lwi	r1, r1, PT_R1
+
+	rtid	r14, 0
+	nop
+
+sys_vfork_wrapper:
+	brid	sys_vfork
+	addk	r5, r1, r0
+
+sys_clone_wrapper:
+	brid	sys_clone
+	addk	r7, r1, r0
+
+sys_execve_wrapper:
+	brid	sys_execve
+	addk	r8, r1, r0
+
+sys_sigreturn_wrapper:
+	brid	sys_sigreturn
+	addk	r5, r1, r0
+
+sys_rt_sigreturn_wrapper:
+	brid	sys_rt_sigreturn
+	addk	r5, r1, r0
+
+sys_sigsuspend_wrapper:
+	brid	sys_rt_sigsuspend
+	addk	r6, r1, r0
+
+sys_rt_sigsuspend_wrapper:
+	brid	sys_rt_sigsuspend
+	addk	r7, r1, r0
+
+	/* Interrupt vector table */
+	.section	.init.ivt, "ax"
+	.org 0x0
+	brai	_reset
+	brai	_user_exception
+	brai	_interrupt
+	brai	_break
+	brai	_hw_exception_handler
+	.org 0x60
+	brai	_debug_exception
+
+.section .rodata,"a"
+#include "syscall_table.S"
+
+syscall_table_size=(.-sys_call_table)
diff --git a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/head.S
new file mode 100644
index 0000000..434b8cb
--- /dev/null
+++ b/arch/microblaze/kernel/head.S
@@ -0,0 +1,55 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+#include <asm/page.h>
+
+	.text
+ENTRY(_start)
+	mfs	r1, rmsr
+	andi	r1, r1, ~2
+	mts	rmsr, r1
+
+/* save fdt to kernel location */
+/* r7 stores pointer to fdt blob */
+	beqi	r7, no_fdt_arg
+	or	r11, r0, r0 /* incremment */
+	ori	r4, r0, TOPHYS(_fdt_start) /* save bram context */
+	ori	r3, r0, (0x4000 - 4)
+_copy_fdt:
+	lw	r12, r7, r11 /* r12 = r7 + r11 */
+	sw	r12, r4, r11 /* addr[r4 + r11] = r12 */
+	addik	r11, r11, 4 /* increment counting */
+	bgtid	r3, _copy_fdt /* loop for all entries */
+	addik	r3, r3, -4 /* descrement loop */
+no_fdt_arg:
+
+	/* Initialize small data anchors */
+	la	r13, r0, _KERNEL_SDA_BASE_
+	la	r2, r0, _KERNEL_SDA2_BASE_
+
+	/* Initialize stack pointer */
+	la	r1, r0, init_thread_union + THREAD_SIZE - 4
+
+	/* Initialize r31 with current task address */
+	la	r31, r0, init_task
+
+	/*
+	 * Call platform dependent initialize function.
+	 * Please see $(ARCH)/mach-$(SUBARCH)/setup.c for
+	 * the function.
+	 */
+	la	r8, r0, machine_early_init
+	brald	r15, r8
+	nop
+
+	la	r15, r0, machine_halt
+	braid	start_kernel
+	nop
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
new file mode 100644
index 0000000..695710b
--- /dev/null
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -0,0 +1,365 @@
+ENTRY(sys_call_table)
+	.long sys_restart_syscall	/* 0 - old "setup()" system call,
+					 * used for restarting */
+	.long sys_exit
+	.long sys_ni_syscall		/* was fork */
+	.long sys_read
+	.long sys_write
+	.long sys_open			/* 5 */
+	.long sys_close
+	.long sys_waitpid
+	.long sys_creat
+	.long sys_link
+	.long sys_unlink		/* 10 */
+	.long sys_execve_wrapper
+	.long sys_chdir
+	.long sys_time
+	.long sys_mknod
+	.long sys_chmod			/* 15 */
+	.long sys_lchown
+	.long sys_ni_syscall		/* old break syscall holder */
+	.long sys_ni_syscall		/* old stat */
+	.long sys_lseek
+	.long sys_getpid		/* 20 */
+	.long sys_mount
+	.long sys_oldumount
+	.long sys_setuid
+	.long sys_getuid
+	.long sys_stime			/* 25 */
+	.long sys_ptrace
+	.long sys_alarm
+	.long sys_ni_syscall		/* oldfstat */
+	.long sys_pause
+	.long sys_utime			/* 30 */
+	.long sys_ni_syscall		/* old stty syscall holder */
+	.long sys_ni_syscall		/* old gtty syscall holder */
+	.long sys_access
+	.long sys_nice
+	.long sys_ni_syscall		/* 35 - old ftime syscall holder */
+	.long sys_sync
+	.long sys_kill
+	.long sys_rename
+	.long sys_mkdir
+	.long sys_rmdir			/* 40 */
+	.long sys_dup
+	.long sys_pipe
+	.long sys_times
+	.long sys_ni_syscall		/* old prof syscall holder */
+	.long sys_brk			/* 45 */
+	.long sys_setgid
+	.long sys_getgid
+	.long sys_signal
+	.long sys_geteuid
+	.long sys_getegid		/* 50 */
+	.long sys_acct
+	.long sys_umount		/* recycled never used phys() */
+	.long sys_ni_syscall		/* old lock syscall holder */
+	.long sys_ioctl
+	.long sys_fcntl			/* 55 */
+	.long sys_ni_syscall		/* old mpx syscall holder */
+	.long sys_setpgid
+	.long sys_ni_syscall		/* old ulimit syscall holder */
+	.long sys_ni_syscall		/* olduname */
+	.long sys_umask			/* 60 */
+	.long sys_chroot
+	.long sys_ustat
+	.long sys_dup2
+	.long sys_getppid
+	.long sys_getpgrp		/* 65 */
+	.long sys_setsid
+	.long sys_sigaction
+	.long sys_sgetmask
+	.long sys_ssetmask
+	.long sys_setreuid		/* 70 */
+	.long sys_setregid
+	.long sys_sigsuspend_wrapper
+	.long sys_sigpending
+	.long sys_sethostname
+	.long sys_setrlimit		/* 75 */
+	.long sys_ni_syscall		/* old_getrlimit */
+	.long sys_getrusage
+	.long sys_gettimeofday
+	.long sys_settimeofday
+	.long sys_getgroups		/* 80 */
+	.long sys_setgroups
+	.long sys_ni_syscall		/* old_select */
+	.long sys_symlink
+	.long sys_ni_syscall		/* oldlstat */
+	.long sys_readlink		/* 85 */
+	.long sys_uselib
+	.long sys_swapon
+	.long sys_reboot
+	.long sys_ni_syscall		/* old_readdir */
+	.long sys_mmap			/* 90 */ /* old_mmap */
+	.long sys_munmap
+	.long sys_truncate
+	.long sys_ftruncate
+	.long sys_fchmod
+	.long sys_fchown		/* 95 */
+	.long sys_getpriority
+	.long sys_setpriority
+	.long sys_ni_syscall		/* old profil syscall holder */
+	.long sys_statfs
+	.long sys_fstatfs		/* 100 */
+	.long sys_ni_syscall		/* ioperm */
+	.long sys_socketcall
+	.long sys_syslog		/* operation with system console */
+	.long sys_setitimer
+	.long sys_getitimer		/* 105 */
+	.long sys_newstat
+	.long sys_newlstat
+	.long sys_newfstat
+	.long sys_ni_syscall		/* uname */
+	.long sys_ni_syscall		/* 110 */ /* iopl */
+	.long sys_vhangup
+	.long sys_ni_syscall		/* old "idle" system call */
+	.long sys_ni_syscall		/* old sys_vm86old */
+	.long sys_wait4
+	.long sys_swapoff		/* 115 */
+	.long sys_sysinfo
+	.long sys_ipc
+	.long sys_fsync
+	.long sys_sigreturn_wrapper
+	.long sys_clone_wrapper		/* 120 */
+	.long sys_setdomainname
+	.long sys_newuname
+	.long sys_ni_syscall		/* modify_ldt */
+	.long sys_adjtimex
+	.long sys_mprotect		/* 125:	sys_mprotect */
+	.long sys_sigprocmask
+	.long sys_ni_syscall		/* old "create_module" */
+	.long sys_init_module
+	.long sys_delete_module
+	.long sys_ni_syscall		/* 130:	old "get_kernel_syms" */
+	.long sys_quotactl
+	.long sys_getpgid
+	.long sys_fchdir
+	.long sys_bdflush
+	.long sys_sysfs			/* 135 */
+	.long sys_personality
+	.long sys_ni_syscall		/* reserved for afs_syscall */
+	.long sys_setfsuid
+	.long sys_setfsgid
+	.long sys_llseek		/* 140 */
+	.long sys_getdents
+	.long sys_select
+	.long sys_flock
+	.long sys_msync
+	.long sys_readv			/* 145 */
+	.long sys_writev
+	.long sys_getsid
+	.long sys_fdatasync
+	.long sys_sysctl
+	.long sys_mlock		/* 150:	sys_mlock */
+	.long sys_munlock
+	.long sys_mlockall
+	.long sys_munlockall
+	.long sys_sched_setparam
+	.long sys_sched_getparam	/* 155 */
+	.long sys_sched_setscheduler
+	.long sys_sched_getscheduler
+	.long sys_sched_yield
+	.long sys_sched_get_priority_max
+	.long sys_sched_get_priority_min	/* 160 */
+	.long sys_sched_rr_get_interval
+	.long sys_nanosleep
+	.long sys_mremap
+	.long sys_setresuid
+	.long sys_getresuid		/* 165 */
+	.long sys_ni_syscall		/* sys_vm86 */
+	.long sys_ni_syscall		/* Old sys_query_module */
+	.long sys_poll
+	.long sys_nfsservctl
+	.long sys_setresgid		/* 170 */
+	.long sys_getresgid
+	.long sys_prctl
+	.long sys_rt_sigreturn_wrapper
+	.long sys_rt_sigaction
+	.long sys_rt_sigprocmask	/* 175 */
+	.long sys_rt_sigpending
+	.long sys_rt_sigtimedwait
+	.long sys_rt_sigqueueinfo
+	.long sys_rt_sigsuspend_wrapper
+	.long sys_pread64		/* 180 */
+	.long sys_pwrite64
+	.long sys_chown
+	.long sys_getcwd
+	.long sys_capget
+	.long sys_capset		/* 185 */
+	.long sys_ni_syscall		/* sigaltstack */
+	.long sys_sendfile
+	.long sys_ni_syscall		/* reserved for streams1 */
+	.long sys_ni_syscall		/* reserved for streams2 */
+	.long sys_vfork_wrapper		/* 190 */
+	.long sys_getrlimit
+	.long sys_mmap2			/* mmap2 */
+	.long sys_truncate64
+	.long sys_ftruncate64
+	.long sys_stat64		/* 195 */
+	.long sys_lstat64
+	.long sys_fstat64
+	.long sys_lchown
+	.long sys_getuid
+	.long sys_getgid		/* 200 */
+	.long sys_geteuid
+	.long sys_getegid
+	.long sys_setreuid
+	.long sys_setregid
+	.long sys_getgroups		/* 205 */
+	.long sys_setgroups
+	.long sys_fchown
+	.long sys_setresuid
+	.long sys_getresuid
+	.long sys_setresgid		/* 210 */
+	.long sys_getresgid
+	.long sys_chown
+	.long sys_setuid
+	.long sys_setgid
+	.long sys_setfsuid		/* 215 */
+	.long sys_setfsgid
+	.long sys_pivot_root
+	.long sys_mincore
+	.long sys_madvise
+	.long sys_getdents64		/* 220 */
+	.long sys_fcntl64
+	.long sys_ni_syscall		/* reserved for TUX */
+	.long sys_ni_syscall
+	.long sys_gettid
+	.long sys_readahead		/* 225 */
+	.long sys_setxattr
+	.long sys_lsetxattr
+	.long sys_fsetxattr
+	.long sys_getxattr
+	.long sys_lgetxattr		/* 230 */
+	.long sys_fgetxattr
+	.long sys_listxattr
+	.long sys_llistxattr
+	.long sys_flistxattr
+	.long sys_removexattr		/* 235 */
+	.long sys_lremovexattr
+	.long sys_fremovexattr
+	.long sys_tkill
+	.long sys_sendfile64
+	.long sys_futex			/* 240 */
+	.long sys_sched_setaffinity
+	.long sys_sched_getaffinity
+	.long sys_ni_syscall		/* set_thread_area */
+	.long sys_ni_syscall		/* get_thread_area */
+	.long sys_io_setup		/* 245 */
+	.long sys_io_destroy
+	.long sys_io_getevents
+	.long sys_io_submit
+	.long sys_io_cancel
+	.long sys_fadvise64		/* 250 */
+	.long sys_ni_syscall
+	.long sys_exit_group
+	.long sys_lookup_dcookie
+	.long sys_epoll_create
+	.long sys_epoll_ctl		/* 255 */
+	.long sys_epoll_wait
+	.long sys_remap_file_pages
+	.long sys_set_tid_address
+	.long sys_timer_create
+	.long sys_timer_settime		/* 260 */
+	.long sys_timer_gettime
+	.long sys_timer_getoverrun
+	.long sys_timer_delete
+	.long sys_clock_settime
+	.long sys_clock_gettime		/* 265 */
+	.long sys_clock_getres
+	.long sys_clock_nanosleep
+	.long sys_statfs64
+	.long sys_fstatfs64
+	.long sys_tgkill		/* 270 */
+	.long sys_utimes
+	.long sys_fadvise64_64
+	.long sys_ni_syscall		/* sys_vserver */
+	.long sys_mbind
+	.long sys_get_mempolicy
+	.long sys_set_mempolicy
+	.long sys_mq_open
+	.long sys_mq_unlink
+	.long sys_mq_timedsend
+	.long sys_mq_timedreceive	/* 280 */
+	.long sys_mq_notify
+	.long sys_mq_getsetattr
+	.long sys_kexec_load
+	.long sys_waitid
+	.long sys_ni_syscall		/* 285 */ /* available */
+	.long sys_add_key
+	.long sys_request_key
+	.long sys_keyctl
+	.long sys_ioprio_set
+	.long sys_ioprio_get		/* 290 */
+	.long sys_inotify_init
+	.long sys_inotify_add_watch
+	.long sys_inotify_rm_watch
+	.long sys_ni_syscall		/* sys_migrate_pages */
+	.long sys_openat	/* 295 */ 
+	.long sys_mkdirat
+	.long sys_mknodat
+	.long sys_fchownat
+	.long sys_ni_syscall
+	.long sys_fstatat64		/* 300 */
+	.long sys_unlinkat
+	.long sys_renameat
+	.long sys_linkat
+	.long sys_symlinkat
+	.long sys_readlinkat		/* 305 */
+	.long sys_fchmodat
+	.long sys_faccessat
+	.long sys_ni_syscall /* pselect6 */
+	.long sys_ni_syscall /* sys_ppoll */
+	.long sys_unshare		/* 310 */
+	.long sys_set_robust_list
+	.long sys_get_robust_list
+	.long sys_splice
+	.long sys_sync_file_range
+	.long sys_tee 			/* 315 */
+	.long sys_vmsplice
+	.long sys_move_pages
+	.long sys_getcpu
+	.long sys_epoll_pwait
+	.long sys_utimensat		/* 320 */
+	.long sys_signalfd
+	.long sys_timerfd_create
+	.long sys_eventfd
+	.long sys_fallocate
+	.long sys_semtimedop		/* 325 */
+	.long sys_timerfd_settime
+	.long sys_timerfd_gettime
+	.long sys_semctl
+	.long sys_semget
+	.long sys_semop			/* 330 */
+	.long sys_msgctl
+	.long sys_msgget
+	.long sys_msgrcv
+	.long sys_msgsnd
+	.long sys_shmat			/* 335 */
+	.long sys_shmctl
+	.long sys_shmdt
+	.long sys_shmget
+	.long sys_signalfd4	/* new syscall */
+	.long sys_eventfd2		/* 340 */
+	.long sys_epoll_create1
+	.long sys_dup3
+	.long sys_pipe2
+	.long sys_inotify_init1
+	.long sys_socket		/* 345 */
+	.long sys_socketpair
+	.long sys_bind
+	.long sys_listen
+	.long sys_accept
+	.long sys_connect		/* 350 */
+	.long sys_getsockname
+	.long sys_getpeername
+	.long sys_sendto
+	.long sys_send
+	.long sys_recvfrom		/* 355 */
+	.long sys_recv
+	.long sys_setsockopt
+	.long sys_getsockopt
+	.long sys_shutdown
+	.long sys_sendmsg		/* 360 */
+	.long sys_recvmsg
+	.long sys_ni_syscall
-- 
1.5.5.1

