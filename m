Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbXK2MAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbXK2MAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762737AbXK2L7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:59:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762729AbXK2L7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:59:50 -0500
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
Subject: [PATCH x86/mm 04/11] x86 ptrace getreg/putreg cleanup
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20071129115939.88B9626F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 03:59:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the getreg/putreg functions to move the special cases
(segment registers and eflags) out into their own subroutines.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |  162 +++++++++++++++++++++++++++-------------------
 1 files changed, 96 insertions(+), 66 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b71226d..eaec75a 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -45,92 +45,122 @@
 static long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
 	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
+	regno >>= 2;
 	if (regno > FS)
 		--regno;
 	return &regs->bx + regno;
 }
 
-static int putreg(struct task_struct *child,
-	unsigned long regno, unsigned long value)
+static u16 get_segment_reg(struct task_struct *task, unsigned long offset)
 {
-	struct pt_regs *regs = task_pt_regs(child);
-	regno >>= 2;
-	switch (regno) {
-	case GS:
-		if (value && (value & 3) != 3)
-			return -EIO;
-		child->thread.gs = value;
-		if (child == current)
+	/*
+	 * Returning the value truncates it to 16 bits.
+	 */
+	unsigned int retval;
+	if (offset != offsetof(struct user_regs_struct, gs))
+		retval = *pt_regs_access(task_pt_regs(task), offset);
+	else {
+		retval = task->thread.gs;
+		if (task == current)
+			savesegment(gs, retval);
+	}
+	return retval;
+}
+
+static int set_segment_reg(struct task_struct *task,
+			   unsigned long offset, u16 value)
+{
+	/*
+	 * The value argument was already truncated to 16 bits.
+	 */
+	if (value && (value & 3) != 3)
+		return -EIO;
+
+	if (offset != offsetof(struct user_regs_struct, gs))
+		*pt_regs_access(task_pt_regs(task), offset) = value;
+	else {
+		task->thread.gs = value;
+		if (task == current)
 			/*
 			 * The user-mode %gs is not affected by
 			 * kernel entry, so we must update the CPU.
 			 */
 			loadsegment(gs, value);
-		return 0;
-	case DS:
-	case ES:
-	case FS:
-		if (value && (value & 3) != 3)
-			return -EIO;
-		value &= 0xffff;
-		break;
-	case SS:
-	case CS:
-		if ((value & 3) != 3)
-			return -EIO;
-		value &= 0xffff;
-		break;
-	case EFL:
-		value &= FLAG_MASK;
-		/*
-		 * If the user value contains TF, mark that
-		 * it was not "us" (the debugger) that set it.
-		 * If not, make sure it stays set if we had.
-		 */
-		if (value & X86_EFLAGS_TF)
-			clear_tsk_thread_flag(child, TIF_FORCED_TF);
-		else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
-			value |= X86_EFLAGS_TF;
-		value |= regs->flags & ~FLAG_MASK;
-		break;
 	}
-	*pt_regs_access(regs, regno) = value;
+
 	return 0;
 }
 
-static unsigned long getreg(struct task_struct *child, unsigned long regno)
+static unsigned long get_flags(struct task_struct *task)
 {
-	struct pt_regs *regs = task_pt_regs(child);
-	unsigned long retval = ~0UL;
+	unsigned long retval = task_pt_regs(task)->flags;
+
+	/*
+	 * If the debugger set TF, hide it from the readout.
+	 */
+	if (test_tsk_thread_flag(task, TIF_FORCED_TF))
+		retval &= ~X86_EFLAGS_TF;
 
-	regno >>= 2;
-	switch (regno) {
-	case EFL:
-		/*
-		 * If the debugger set TF, hide it from the readout.
-		 */
-		retval = regs->flags;
-		if (test_tsk_thread_flag(child, TIF_FORCED_TF))
-			retval &= ~X86_EFLAGS_TF;
-		break;
-	case GS:
-		retval = child->thread.gs;
-		if (child == current)
-			savesegment(gs, retval);
-		break;
-	case DS:
-	case ES:
-	case FS:
-	case SS:
-	case CS:
-		retval = 0xffff;
-		/* fall through */
-	default:
-		retval &= *pt_regs_access(regs, regno);
-	}
 	return retval;
 }
 
+static int set_flags(struct task_struct *task, unsigned long value)
+{
+	struct pt_regs *regs = task_pt_regs(task);
+
+	/*
+	 * If the user value contains TF, mark that
+	 * it was not "us" (the debugger) that set it.
+	 * If not, make sure it stays set if we had.
+	 */
+	if (value & X86_EFLAGS_TF)
+		clear_tsk_thread_flag(task, TIF_FORCED_TF);
+	else if (test_tsk_thread_flag(task, TIF_FORCED_TF))
+		value |= X86_EFLAGS_TF;
+
+	regs->flags = (regs->flags & ~FLAG_MASK) | (value & FLAG_MASK);
+
+	return 0;
+}
+
+static int putreg(struct task_struct *child,
+		  unsigned long offset, unsigned long value)
+{
+	switch (offset) {
+	case offsetof(struct user_regs_struct, cs):
+	case offsetof(struct user_regs_struct, ds):
+	case offsetof(struct user_regs_struct, es):
+	case offsetof(struct user_regs_struct, fs):
+	case offsetof(struct user_regs_struct, gs):
+	case offsetof(struct user_regs_struct, ss):
+		return set_segment_reg(child, offset, value);
+
+	case offsetof(struct user_regs_struct, flags):
+		return set_flags(child, value);
+	}
+
+	*pt_regs_access(task_pt_regs(child), offset) = value;
+	return 0;
+}
+
+static unsigned long getreg(struct task_struct *task, unsigned long offset)
+{
+	switch (offset) {
+	case offsetof(struct user_regs_struct, cs):
+	case offsetof(struct user_regs_struct, ds):
+	case offsetof(struct user_regs_struct, es):
+	case offsetof(struct user_regs_struct, fs):
+	case offsetof(struct user_regs_struct, gs):
+	case offsetof(struct user_regs_struct, ss):
+		return get_segment_reg(task, offset);
+
+	case offsetof(struct user_regs_struct, flags):
+		return get_flags(task);
+	}
+
+	return *pt_regs_access(task_pt_regs(task), offset);
+}
+
 /*
  * This function is trivial and will be inlined by the compiler.
  * Having it separates the implementation details of debug
