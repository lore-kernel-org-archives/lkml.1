Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbXKYWAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbXKYWAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbXKYWAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:00:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358AbXKYWAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:00:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 05/27] x86: single_step moved
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Shopping-List: (1) Heretical gold baskets
   (2) Political lieutenant sycophants
   (3) Pernicious skeptical detectors
   (4) Serious nutrition friction
Message-Id: <20071125215939.3EA2826F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 13:59:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This moves the single-step support code from ptrace_64.c into a new file
step.c, verbatim.  This paves the way for consolidating this code between
64-bit and 32-bit versions.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/Makefile_64 |    2 +
 arch/x86/kernel/ptrace_64.c |  134 -----------------------------------------
 arch/x86/kernel/step.c      |  140 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+), 134 deletions(-)

diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 203a9d8..d35ee6f 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -13,6 +13,8 @@ obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
 		i8253.o
 
+obj-y				+= step.o
+
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index c2e1a13..52479b1 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -80,140 +80,6 @@ static inline long put_stack_long(struct task_struct *task, int offset,
 	return 0;
 }
 
-#define LDT_SEGMENT 4
-
-unsigned long convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs)
-{
-	unsigned long addr, seg;
-
-	addr = regs->rip;
-	seg = regs->cs & 0xffff;
-
-	/*
-	 * We'll assume that the code segments in the GDT
-	 * are all zero-based. That is largely true: the
-	 * TLS segments are used for data, and the PNPBIOS
-	 * and APM bios ones we just ignore here.
-	 */
-	if (seg & LDT_SEGMENT) {
-		u32 *desc;
-		unsigned long base;
-
-		seg &= ~7UL;
-
-		mutex_lock(&child->mm->context.lock);
-		if (unlikely((seg >> 3) >= child->mm->context.size))
-			addr = -1L; /* bogus selector, access would fault */
-		else {
-			desc = child->mm->context.ldt + seg;
-			base = ((desc[0] >> 16) |
-				((desc[1] & 0xff) << 16) |
-				(desc[1] & 0xff000000));
-
-			/* 16-bit code segment? */
-			if (!((desc[1] >> 22) & 1))
-				addr &= 0xffff;
-			addr += base;
-		}
-		mutex_unlock(&child->mm->context.lock);
-	}
-
-	return addr;
-}
-
-static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
-{
-	int i, copied;
-	unsigned char opcode[15];
-	unsigned long addr = convert_rip_to_linear(child, regs);
-
-	copied = access_process_vm(child, addr, opcode, sizeof(opcode), 0);
-	for (i = 0; i < copied; i++) {
-		switch (opcode[i]) {
-		/* popf and iret */
-		case 0x9d: case 0xcf:
-			return 1;
-
-			/* CHECKME: 64 65 */
-
-		/* opcode and address size prefixes */
-		case 0x66: case 0x67:
-			continue;
-		/* irrelevant prefixes (segment overrides and repeats) */
-		case 0x26: case 0x2e:
-		case 0x36: case 0x3e:
-		case 0x64: case 0x65:
-		case 0xf2: case 0xf3:
-			continue;
-
-		case 0x40 ... 0x4f:
-			if (regs->cs != __USER_CS)
-				/* 32-bit mode: register increment */
-				return 0;
-			/* 64-bit mode: REX prefix */
-			continue;
-
-			/* CHECKME: f2, f3 */
-
-		/*
-		 * pushf: NOTE! We should probably not let
-		 * the user see the TF bit being set. But
-		 * it's more pain than it's worth to avoid
-		 * it, and a debugger could emulate this
-		 * all in user space if it _really_ cares.
-		 */
-		case 0x9c:
-		default:
-			return 0;
-		}
-	}
-	return 0;
-}
-
-void user_enable_single_step(struct task_struct *child)
-{
-	struct pt_regs *regs = task_pt_regs(child);
-
-	/*
-	 * Always set TIF_SINGLESTEP - this guarantees that
-	 * we single-step system calls etc..  This will also
-	 * cause us to set TF when returning to user mode.
-	 */
-	set_tsk_thread_flag(child, TIF_SINGLESTEP);
-
-	/*
-	 * If TF was already set, don't do anything else
-	 */
-	if (regs->eflags & X86_EFLAGS_TF)
-		return;
-
-	/* Set TF on the kernel stack.. */
-	regs->eflags |= X86_EFLAGS_TF;
-
-	/*
-	 * ..but if TF is changed by the instruction we will trace,
-	 * don't mark it as being "us" that set it, so that we
-	 * won't clear it by hand later.
-	 */
-	if (is_setting_trap_flag(child, regs))
-		return;
-
-	child->ptrace |= PT_DTRACE;
-}
-
-void user_disable_single_step(struct task_struct *child)
-{
-	/* Always clear TIF_SINGLESTEP... */
-	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
-
-	/* But touch TF only if it was set by us.. */
-	if (child->ptrace & PT_DTRACE) {
-		struct pt_regs *regs = task_pt_regs(child);
-		regs->eflags &= ~X86_EFLAGS_TF;
-		child->ptrace &= ~PT_DTRACE;
-	}
-}
-
 /*
  * Called by kernel/ptrace.c when detaching..
  *
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
new file mode 100644
index 0000000..cb3c8bc
--- /dev/null
+++ b/arch/x86/kernel/step.c
@@ -0,0 +1,140 @@
+/*
+ * x86 single-step support code, common to 32-bit and 64-bit.
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/ptrace.h>
+
+#define LDT_SEGMENT 4
+
+unsigned long convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs)
+{
+	unsigned long addr, seg;
+
+	addr = regs->rip;
+	seg = regs->cs & 0xffff;
+
+	/*
+	 * We'll assume that the code segments in the GDT
+	 * are all zero-based. That is largely true: the
+	 * TLS segments are used for data, and the PNPBIOS
+	 * and APM bios ones we just ignore here.
+	 */
+	if (seg & LDT_SEGMENT) {
+		u32 *desc;
+		unsigned long base;
+
+		seg &= ~7UL;
+
+		mutex_lock(&child->mm->context.lock);
+		if (unlikely((seg >> 3) >= child->mm->context.size))
+			addr = -1L; /* bogus selector, access would fault */
+		else {
+			desc = child->mm->context.ldt + seg;
+			base = ((desc[0] >> 16) |
+				((desc[1] & 0xff) << 16) |
+				(desc[1] & 0xff000000));
+
+			/* 16-bit code segment? */
+			if (!((desc[1] >> 22) & 1))
+				addr &= 0xffff;
+			addr += base;
+		}
+		mutex_unlock(&child->mm->context.lock);
+	}
+
+	return addr;
+}
+
+static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
+{
+	int i, copied;
+	unsigned char opcode[15];
+	unsigned long addr = convert_rip_to_linear(child, regs);
+
+	copied = access_process_vm(child, addr, opcode, sizeof(opcode), 0);
+	for (i = 0; i < copied; i++) {
+		switch (opcode[i]) {
+		/* popf and iret */
+		case 0x9d: case 0xcf:
+			return 1;
+
+			/* CHECKME: 64 65 */
+
+		/* opcode and address size prefixes */
+		case 0x66: case 0x67:
+			continue;
+		/* irrelevant prefixes (segment overrides and repeats) */
+		case 0x26: case 0x2e:
+		case 0x36: case 0x3e:
+		case 0x64: case 0x65:
+		case 0xf2: case 0xf3:
+			continue;
+
+		case 0x40 ... 0x4f:
+			if (regs->cs != __USER_CS)
+				/* 32-bit mode: register increment */
+				return 0;
+			/* 64-bit mode: REX prefix */
+			continue;
+
+			/* CHECKME: f2, f3 */
+
+		/*
+		 * pushf: NOTE! We should probably not let
+		 * the user see the TF bit being set. But
+		 * it's more pain than it's worth to avoid
+		 * it, and a debugger could emulate this
+		 * all in user space if it _really_ cares.
+		 */
+		case 0x9c:
+		default:
+			return 0;
+		}
+	}
+	return 0;
+}
+
+void user_enable_single_step(struct task_struct *child)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+
+	/*
+	 * Always set TIF_SINGLESTEP - this guarantees that
+	 * we single-step system calls etc..  This will also
+	 * cause us to set TF when returning to user mode.
+	 */
+	set_tsk_thread_flag(child, TIF_SINGLESTEP);
+
+	/*
+	 * If TF was already set, don't do anything else
+	 */
+	if (regs->eflags & X86_EFLAGS_TF)
+		return;
+
+	/* Set TF on the kernel stack.. */
+	regs->eflags |= X86_EFLAGS_TF;
+
+	/*
+	 * ..but if TF is changed by the instruction we will trace,
+	 * don't mark it as being "us" that set it, so that we
+	 * won't clear it by hand later.
+	 */
+	if (is_setting_trap_flag(child, regs))
+		return;
+
+	child->ptrace |= PT_DTRACE;
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	/* Always clear TIF_SINGLESTEP... */
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
+
+	/* But touch TF only if it was set by us.. */
+	if (child->ptrace & PT_DTRACE) {
+		struct pt_regs *regs = task_pt_regs(child);
+		regs->eflags &= ~X86_EFLAGS_TF;
+		child->ptrace &= ~PT_DTRACE;
+	}
+}
