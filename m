Return-Path: <linux-kernel-owner+w=401wt.eu-S1760458AbYAZQDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458AbYAZQDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbYAZPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:59 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756816AbYAZPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:57 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 25/52] [microblaze] ptrace support
Date: Thu, 24 Jan 2008 16:03:00 +0100
Message-Id: <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/ptrace.c |  212 +++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/ptrace.h |   70 +++++++++++++
 2 files changed, 282 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/ptrace.c
 create mode 100644 include/asm-microblaze/ptrace.h

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
new file mode 100644
index 0000000..f2939ea
--- /dev/null
+++ b/arch/microblaze/kernel/ptrace.c
@@ -0,0 +1,212 @@
+/*
+ * arch/microblaze/kernel/ptrace.c -- `ptrace' system call
+ *
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2004-07 John Williams <john.williams@petalogix.com>
+ *
+ * derived from arch/v850/kernel/ptrace.c
+ *
+ * Copyright (C) 2002,03 NEC Electronics Corporation
+ * Copyright (C) 2002,03 Miles Bader <miles@gnu.org>
+ *
+ * Derived from arch/mips/kernel/ptrace.c:
+ *
+ * Copyright (C) 1992 Ross Biro
+ * Copyright (C) Linus Torvalds
+ * Copyright (C) 1994, 95, 96, 97, 98, 2000 Ralf Baechle
+ * Copyright (C) 1996 David S. Miller
+ * Kevin D. Kissell, kevink@mips.com and Carsten Langgaard, carstenl@mips.com
+ * Copyright (C) 1999 MIPS Technologies, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/smp_lock.h>
+#include <linux/ptrace.h>
+#include <linux/signal.h>
+
+#include <asm/errno.h>
+#include <asm/ptrace.h>
+#include <asm/processor.h>
+#include <asm/uaccess.h>
+#include <asm/asm-offsets.h>
+
+#if 0
+#define DBPRINTK(...) printk(__VA_ARGS__)
+#else
+#define DBPRINTK(...)
+#endif
+
+/* Returns the address where the register at REG_OFFS in P is stashed away. */
+static microblaze_reg_t *reg_save_addr(unsigned reg_offs,
+					struct task_struct *t)
+{
+	struct pt_regs *regs;
+
+	/*
+	 * Three basic cases:
+	 *
+	 * (1)	A register normally saved before calling the scheduler, is
+	 *	available in the kernel entry pt_regs structure at the top
+	 *	of the kernel stack. The kernel trap/irq exit path takes
+	 *	care to save/restore almost all registers for ptrace'd
+	 *	processes.
+	 *
+	 * (2)	A call-clobbered register, where the process P entered the
+	 *	kernel via [syscall] trap, is not stored anywhere; that's
+	 *	OK, because such registers are not expected to be preserved
+	 *	when the trap returns anyway (so we don't actually bother to
+	 *	test for this case).
+	 *
+	 * (3)	A few registers not used at all by the kernel, and so
+	 *	normally never saved except by context-switches, are in the
+	 *	context switch state.
+	 */
+
+	/* Register saved during kernel entry (or not available). */
+	regs = task_pt_regs(t);
+
+	return (microblaze_reg_t *)((char *)regs + reg_offs);
+}
+
+long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+{
+	int rval;
+
+	switch (request) {
+		unsigned long val, copied;
+
+	case PTRACE_PEEKTEXT: /* read word at location addr. */
+	case PTRACE_PEEKDATA:
+		DBPRINTK("PEEKTEXT/PEEKDATA at %08lX\n", addr);
+		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
+		rval = -EIO;
+		if (copied != sizeof(val))
+			break;
+		rval = put_user(val, (unsigned long *)data);
+		goto out;
+
+	case PTRACE_POKETEXT: /* write the word at location addr. */
+	case PTRACE_POKEDATA:
+		DBPRINTK("POKETEXT/POKEDATA to %08lX\n", addr);
+		rval = 0;
+		if (access_process_vm(child, addr, &data, sizeof(data), 1)
+			== sizeof(data))
+			break;
+		rval = -EIO;
+		goto out;
+
+	/* Read/write the word at location ADDR in the registers. */
+	case PTRACE_PEEKUSR:
+	case PTRACE_POKEUSR:
+		DBPRINTK("PEEKUSR/POKEUSR : 0x%08lx\n", addr);
+		rval = 0;
+		if (addr >= PT_SIZE && request == PTRACE_PEEKUSR) {
+			/* Special requests that don't actually correspond
+			 to offsets in struct pt_regs. */
+			if (addr == PT_TEXT_ADDR) {
+				val = child->mm->start_code;
+			} else if (addr == PT_DATA_ADDR) {
+				val = child->mm->start_data;
+			} else if (addr == PT_TEXT_LEN) {
+				val = child->mm->end_code
+					- child->mm->start_code;
+			} else {
+				rval = -EIO;
+			}
+		} else if (addr >= 0 && addr < PT_SIZE && (addr & 0x3) == 0) {
+			microblaze_reg_t *reg_addr = reg_save_addr(addr, child);
+			if (request == PTRACE_PEEKUSR) {
+				val = *reg_addr;
+			} else {
+				*reg_addr = data;
+			}
+		} else
+			rval = -EIO;
+
+		if (rval == 0 && request == PTRACE_PEEKUSR)
+			rval = put_user(val, (unsigned long *)data);
+		goto out;
+
+	/* Continue and stop at next (return from) syscall */
+	case PTRACE_SYSCALL:
+		DBPRINTK("PTRACE_SYSCALL\n");
+	case PTRACE_SINGLESTEP:
+		DBPRINTK("PTRACE_SINGLESTEP\n");
+	/* Restart after a signal. */
+	case PTRACE_CONT:
+		DBPRINTK("PTRACE_CONT\n");
+		rval = -EIO;
+		if (!valid_signal(data))
+			break;
+
+		if (request == PTRACE_SYSCALL)
+			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+		else
+			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+
+		child->exit_code = data;
+		DBPRINTK("wakeup_process\n");
+		wake_up_process(child);
+		rval = 0;
+		break;
+
+	/*
+	 * make the child exit. Best I can do is send it a sigkill.
+	 * perhaps it should be put in the status that it wants to
+	 * exit.
+	 */
+	case PTRACE_KILL:
+		DBPRINTK("PTRACE_KILL\n");
+		rval = 0;
+		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
+			break;
+		child->exit_code = SIGKILL;
+		wake_up_process(child);
+		break;
+
+	case PTRACE_DETACH: /* detach a process that was attached. */
+		DBPRINTK("PTRACE_DETACH\n");
+		rval = ptrace_detach(child, data);
+		break;
+
+	default:
+		rval = -EIO;
+		goto out;
+	}
+ out:
+	return rval;
+}
+
+#if 0
+static asmlinkage void syscall_trace(void)
+{
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return;
+	if (!(current->ptrace & PT_PTRACED))
+		return;
+	/* The 0x80 provides a way for the tracing parent to distinguish
+	 between a syscall stop and SIGTRAP delivery */
+	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
+				? 0x80 : 0));
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use. strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP. -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
+#endif
+
+void ptrace_disable(struct task_struct *child)
+{
+	/* nothing to do */
+}
diff --git a/include/asm-microblaze/ptrace.h b/include/asm-microblaze/ptrace.h
new file mode 100644
index 0000000..f583d72
--- /dev/null
+++ b/include/asm-microblaze/ptrace.h
@@ -0,0 +1,70 @@
+/*
+ * include/asm-microblaze/ptrace.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_PTRACE_H
+#define _ASM_PTRACE_H
+
+#ifndef __ASSEMBLY__
+#include <asm/types.h>
+
+typedef unsigned long microblaze_reg_t;
+
+struct pt_regs {
+	microblaze_reg_t r0;
+	microblaze_reg_t r1;
+	microblaze_reg_t r2;
+	microblaze_reg_t r3;
+	microblaze_reg_t r4;
+	microblaze_reg_t r5;
+	microblaze_reg_t r6;
+	microblaze_reg_t r7;
+	microblaze_reg_t r8;
+	microblaze_reg_t r9;
+	microblaze_reg_t r10;
+	microblaze_reg_t r11;
+	microblaze_reg_t r12;
+	microblaze_reg_t r13;
+	microblaze_reg_t r14;
+	microblaze_reg_t r15;
+	microblaze_reg_t r16;
+	microblaze_reg_t r17;
+	microblaze_reg_t r18;
+	microblaze_reg_t r19;
+	microblaze_reg_t r20;
+	microblaze_reg_t r21;
+	microblaze_reg_t r22;
+	microblaze_reg_t r23;
+	microblaze_reg_t r24;
+	microblaze_reg_t r25;
+	microblaze_reg_t r26;
+	microblaze_reg_t r27;
+	microblaze_reg_t r28;
+	microblaze_reg_t r29;
+	microblaze_reg_t r30;
+	microblaze_reg_t r31;
+	microblaze_reg_t pc;
+	microblaze_reg_t msr;
+	microblaze_reg_t ear;
+	microblaze_reg_t esr;
+	microblaze_reg_t fsr;
+	int kernel_mode;
+};
+
+#define kernel_mode(regs)		((regs)->kernel_mode)
+#define user_mode(regs)			(!kernel_mode(regs))
+
+#define instruction_pointer(regs)	((regs)->pc)
+#define profile_pc(regs)		instruction_pointer(regs)
+
+extern void show_regs(struct pt_regs *);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_PTRACE_H */
-- 
1.5.4.rc4.14.g6fc74

