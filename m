Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbXKYWFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbXKYWFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbXKYWFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:05:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758154AbXKYWFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:05:04 -0500
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
Subject: [PATCH 16/27] x86-64 ptrace: use task_pt_regs
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071125220429.0EBAA26F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:04:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the 64-bit ptrace code to use task_pt_regs instead of its
own redundant code that does the same thing a different way.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_64.c |   60 ++++++++----------------------------------
 1 files changed, 12 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 85fba7b..8123ecb 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -43,44 +43,6 @@
 #define FLAG_MASK 0x54dd5UL
 
 /*
- * eflags and offset of eflags on child stack..
- */
-#define EFLAGS offsetof(struct pt_regs, eflags)
-#define EFL_OFFSET ((int)(EFLAGS-sizeof(struct pt_regs)))
-
-/*
- * this routine will get a word off of the processes privileged stack.
- * the offset is how far from the base addr as stored in the TSS.
- * this routine assumes that all the privileged stacks are in our
- * data space.
- */
-static inline unsigned long get_stack_long(struct task_struct *task, int offset)
-{
-	unsigned char *stack;
-
-	stack = (unsigned char *)task->thread.rsp0;
-	stack += offset;
-	return (*((unsigned long *)stack));
-}
-
-/*
- * this routine will put a word on the processes privileged stack.
- * the offset is how far from the base addr as stored in the TSS.
- * this routine assumes that all the privileged stacks are in our
- * data space.
- */
-static inline long put_stack_long(struct task_struct *task, int offset,
-	unsigned long data)
-{
-	unsigned char * stack;
-
-	stack = (unsigned char *) task->thread.rsp0;
-	stack += offset;
-	*(unsigned long *) stack = data;
-	return 0;
-}
-
-/*
  * Called by kernel/ptrace.c when detaching..
  *
  * Make sure the single step bit is not set.
@@ -90,11 +52,16 @@ void ptrace_disable(struct task_struct *child)
 	user_disable_single_step(child);
 }
 
+static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long offset)
+{
+	BUILD_BUG_ON(offsetof(struct pt_regs, r15) != 0);
+	return &regs->r15 + (offset / sizeof(regs->r15));
+}
+
 static int putreg(struct task_struct *child,
 	unsigned long regno, unsigned long value)
 {
-	unsigned long tmp;
-
+	struct pt_regs *regs = task_pt_regs(child);
 	switch (regno) {
 		case offsetof(struct user_regs_struct,fs):
 			if (value && (value & 3) != 3)
@@ -152,9 +119,7 @@ static int putreg(struct task_struct *child,
 				clear_tsk_thread_flag(child, TIF_FORCED_TF);
 			else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
 				value |= X86_EFLAGS_TF;
-			tmp = get_stack_long(child, EFL_OFFSET);
-			tmp &= ~FLAG_MASK;
-			value |= tmp;
+			value |= regs->eflags & ~FLAG_MASK;
 			break;
 		case offsetof(struct user_regs_struct,cs):
 			if ((value & 3) != 3)
@@ -162,12 +127,13 @@ static int putreg(struct task_struct *child,
 			value &= 0xffff;
 			break;
 	}
-	put_stack_long(child, regno - sizeof(struct pt_regs), value);
+	*pt_regs_access(regs, regno) = value;
 	return 0;
 }
 
 static unsigned long getreg(struct task_struct *child, unsigned long regno)
 {
+	struct pt_regs *regs = task_pt_regs(child);
 	unsigned long val;
 	switch (regno) {
 		case offsetof(struct user_regs_struct, fs):
@@ -202,16 +168,14 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
 			/*
 			 * If the debugger set TF, hide it from the readout.
 			 */
-			regno = regno - sizeof(struct pt_regs);
-			val = get_stack_long(child, regno);
+			val = regs->eflags;
 			if (test_tsk_thread_flag(child, TIF_IA32))
 				val &= 0xffffffff;
 			if (test_tsk_thread_flag(child, TIF_FORCED_TF))
 				val &= ~X86_EFLAGS_TF;
 			return val;
 		default:
-			regno = regno - sizeof(struct pt_regs);
-			val = get_stack_long(child, regno);
+			val = *pt_regs_access(regs, regno);
 			if (test_tsk_thread_flag(child, TIF_IA32))
 				val &= 0xffffffff;
 			return val;
