Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYFZMwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYFZMwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbYFZMhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:37:18 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:20704 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758479AbYFZMhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:37:09 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 28/60] microblaze_v4: ptrace support
Date: Thu, 26 Jun 2008 14:29:57 +0200
Message-Id: <1214483429-32360-29-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-28-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/ptrace.c |  206 +++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/ptrace.h |   68 +++++++++++++
 2 files changed, 274 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/ptrace.c
 create mode 100644 include/asm-microblaze/ptrace.h

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
new file mode 100644
index 0000000..834d463
--- /dev/null
+++ b/arch/microblaze/kernel/ptrace.c
@@ -0,0 +1,206 @@
+/*
+ * `ptrace' system call
+ *
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
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
+		pr_debug("PEEKTEXT/PEEKDATA at %08lX\n", addr);
+		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
+		rval = -EIO;
+		if (copied != sizeof(val))
+			break;
+		rval = put_user(val, (unsigned long *)data);
+		goto out;
+
+	case PTRACE_POKETEXT: /* write the word at location addr. */
+	case PTRACE_POKEDATA:
+		pr_debug("POKETEXT/POKEDATA to %08lX\n", addr);
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
+		pr_debug("PEEKUSR/POKEUSR : 0x%08lx\n", addr);
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
+			if (request == PTRACE_PEEKUSR)
+				val = *reg_addr;
+			else
+				*reg_addr = data;
+		} else
+			rval = -EIO;
+
+		if (rval == 0 && request == PTRACE_PEEKUSR)
+			rval = put_user(val, (unsigned long *)data);
+		goto out;
+
+	/* Continue and stop at next (return from) syscall */
+	case PTRACE_SYSCALL:
+		pr_debug("PTRACE_SYSCALL\n");
+	case PTRACE_SINGLESTEP:
+		pr_debug("PTRACE_SINGLESTEP\n");
+	/* Restart after a signal. */
+	case PTRACE_CONT:
+		pr_debug("PTRACE_CONT\n");
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
+		pr_debug("wakeup_process\n");
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
+		pr_debug("PTRACE_KILL\n");
+		rval = 0;
+		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
+			break;
+		child->exit_code = SIGKILL;
+		wake_up_process(child);
+		break;
+
+	case PTRACE_DETACH: /* detach a process that was attached. */
+		pr_debug("PTRACE_DETACH\n");
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
index 0000000..122f4af
--- /dev/null
+++ b/include/asm-microblaze/ptrace.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_PTRACE_H
+#define _ASM_MICROBLAZE_PTRACE_H
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
+#endif /* _ASM_MICROBLAZE_PTRACE_H */
-- 
1.5.4.GIT

