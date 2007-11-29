Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbXK2AjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbXK2AjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXK2AjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:39:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXK2AjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:39:01 -0500
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
Subject: [PATCH x86/mm 1/6] x86-64 ia32 ptrace pt_regs cleanup
X-Zippy-Says: I'll clean your ROOM!!  I know some GOOD stories, too!!  All about
    ROAD Island's, HUSH Puppies, and how LUKE finds GOLD on his LAND!!
Message-Id: <20071129003849.428E026F8E7@magilla.localdomain>
Date: Wed, 28 Nov 2007 16:38:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the getreg32/putreg32 functions to use struct pt_regs in a
straightforward fashion, instead of equivalent ugly pointer arithmetic.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ptrace32.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index 1e382e3..c52d066 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -37,11 +37,11 @@
 
 #define R32(l,q)							\
 	case offsetof(struct user32, regs.l):				\
-		stack[offsetof(struct pt_regs, q) / 8] = val; break
+		regs->q = val; break;
 
 static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 {
-	__u64 *stack = (__u64 *)task_pt_regs(child);
+	struct pt_regs *regs = task_pt_regs(child);
 
 	switch (regno) {
 	case offsetof(struct user32, regs.fs):
@@ -65,12 +65,12 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 	case offsetof(struct user32, regs.ss):
 		if ((val & 3) != 3)
 			return -EIO;
-		stack[offsetof(struct pt_regs, ss)/8] = val & 0xffff;
+		regs->ss = val & 0xffff;
 		break;
 	case offsetof(struct user32, regs.cs):
 		if ((val & 3) != 3)
 			return -EIO;
-		stack[offsetof(struct pt_regs, cs)/8] = val & 0xffff;
+		regs->cs = val & 0xffff;
 		break;
 
 	R32(ebx, bx);
@@ -84,9 +84,7 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 	R32(eip, ip);
 	R32(esp, sp);
 
-	case offsetof(struct user32, regs.eflags): {
-		__u64 *flags = &stack[offsetof(struct pt_regs, flags)/8];
-
+	case offsetof(struct user32, regs.eflags):
 		val &= FLAG_MASK;
 		/*
 		 * If the user value contains TF, mark that
@@ -97,9 +95,8 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 			clear_tsk_thread_flag(child, TIF_FORCED_TF);
 		else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
 			val |= X86_EFLAGS_TF;
-		*flags = val | (*flags & ~FLAG_MASK);
+		regs->flags = val | (regs->flags & ~FLAG_MASK);
 		break;
-	}
 
 	case offsetof(struct user32, u_debugreg[0]) ...
 		offsetof(struct user32, u_debugreg[7]):
@@ -123,11 +120,11 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 
 #define R32(l,q)							\
 	case offsetof(struct user32, regs.l):				\
-		*val = stack[offsetof(struct pt_regs, q)/8]; break
+		*val = regs->q; break
 
 static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 {
-	__u64 *stack = (__u64 *)task_pt_regs(child);
+	struct pt_regs *regs = task_pt_regs(child);
 
 	switch (regno) {
 	case offsetof(struct user32, regs.fs):
@@ -160,7 +157,7 @@ static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 		/*
 		 * If the debugger set TF, hide it from the readout.
 		 */
-		*val = stack[offsetof(struct pt_regs, flags)/8];
+		*val = regs->flags;
 		if (test_tsk_thread_flag(child, TIF_FORCED_TF))
 			*val &= ~X86_EFLAGS_TF;
 		break;
