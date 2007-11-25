Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbXKYWBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbXKYWBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbXKYWAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:00:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbXKYWAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:00:36 -0500
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
Subject: [PATCH 08/27] x86: single_step: share code
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Shopping-List: (1) Illustrious Garden Weasel baskets
   (2) Fabulous hay
   (3) Various temptations
Message-Id: <20071125220031.32AC826F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:00:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This removes the single-step code from ptrace_32.c and uses the step.c code
shared with the 64-bit kernel.  The two versions of the code were nearly
identical already, so the shared code has only a couple of simple #ifdef's.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/Makefile_32 |    1 +
 arch/x86/kernel/ptrace_32.c |  125 -------------------------------------------
 arch/x86/kernel/step.c      |   14 +++++
 3 files changed, 15 insertions(+), 125 deletions(-)

diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index e660584..959ad3c 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -11,6 +11,7 @@ obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o
 
 obj-y				+= tls.o
+obj-y				+= step.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index d1d74e1..e599db5 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -137,131 +137,6 @@ static unsigned long getreg(struct task_struct *child,
 	return retval;
 }
 
-#define LDT_SEGMENT 4
-
-static unsigned long convert_eip_to_linear(struct task_struct *child, struct pt_regs *regs)
-{
-	unsigned long addr, seg;
-
-	addr = regs->eip;
-	seg = regs->xcs & 0xffff;
-	if (regs->eflags & VM_MASK) {
-		addr = (addr & 0xffff) + (seg << 4);
-		return addr;
-	}
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
-	return addr;
-}
-
-static inline int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
-{
-	int i, copied;
-	unsigned char opcode[15];
-	unsigned long addr = convert_eip_to_linear(child, regs);
-
-	copied = access_process_vm(child, addr, opcode, sizeof(opcode), 0);
-	for (i = 0; i < copied; i++) {
-		switch (opcode[i]) {
-		/* popf and iret */
-		case 0x9d: case 0xcf:
-			return 1;
-		/* opcode and address size prefixes */
-		case 0x66: case 0x67:
-			continue;
-		/* irrelevant prefixes (segment overrides and repeats) */
-		case 0x26: case 0x2e:
-		case 0x36: case 0x3e:
-		case 0x64: case 0x65:
-		case 0xf0: case 0xf2: case 0xf3:
-			continue;
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
-	struct pt_regs *regs = get_child_regs(child);
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
-		struct pt_regs *regs = get_child_regs(child);
-		regs->eflags &= ~X86_EFLAGS_TF;
-		child->ptrace &= ~PT_DTRACE;
-	}
-}
-
 /*
  * Called by kernel/ptrace.c when detaching..
  *
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 6a93b93..6732272 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -5,12 +5,24 @@
 #include <linux/mm.h>
 #include <linux/ptrace.h>
 
+#ifdef CONFIG_X86_32
+static
+#endif
 unsigned long convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs)
 {
 	unsigned long addr, seg;
 
+#ifdef CONFIG_X86_64
 	addr = regs->rip;
 	seg = regs->cs & 0xffff;
+#else
+	addr = regs->eip;
+	seg = regs->xcs & 0xffff;
+	if (regs->eflags & X86_EFLAGS_VM) {
+		addr = (addr & 0xffff) + (seg << 4);
+		return addr;
+	}
+#endif
 
 	/*
 	 * We'll assume that the code segments in the GDT
@@ -69,12 +81,14 @@ static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
 		case 0xf0: case 0xf2: case 0xf3:
 			continue;
 
+#ifdef CONFIG_X86_64
 		case 0x40 ... 0x4f:
 			if (regs->cs != __USER_CS)
 				/* 32-bit mode: register increment */
 				return 0;
 			/* 64-bit mode: REX prefix */
 			continue;
+#endif
 
 			/* CHECKME: f2, f3 */
 
