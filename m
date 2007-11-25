Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbXKYWEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbXKYWEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758132AbXKYWE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:04:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756921AbXKYWEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:04:25 -0500
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
Subject: [PATCH 15/27] x86-32 ptrace: use task_pt_regs
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071125220420.2924626F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:04:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the 32-bit ptrace code to use task_pt_regs instead of its
own redundant code that does the same thing a different way.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_32.c |   68 ++++++++++--------------------------------
 1 files changed, 16 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index 50882b3..7c33244 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -37,53 +37,20 @@
  */
 #define FLAG_MASK 0x00050dd5
 
-/*
- * Offset of eflags on child stack..
- */
-#define EFL_OFFSET offsetof(struct pt_regs, eflags)
-
-static inline struct pt_regs *get_child_regs(struct task_struct *task)
-{
-	void *stack_top = (void *)task->thread.esp0;
-	return stack_top - sizeof(struct pt_regs);
-}
-
-/*
- * This routine will get a word off of the processes privileged stack.
- * the offset is bytes into the pt_regs structure on the stack.
- * This routine assumes that all the privileged stacks are in our
- * data space.
- */
-static inline int get_stack_long(struct task_struct *task, int offset)
+static long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
-	unsigned char *stack;
-
-	stack = (unsigned char *)task->thread.esp0 - sizeof(struct pt_regs);
-	stack += offset;
-	return (*((int *)stack));
-}
-
-/*
- * This routine will put a word on the processes privileged stack.
- * the offset is bytes into the pt_regs structure on the stack.
- * This routine assumes that all the privileged stacks are in our
- * data space.
- */
-static inline int put_stack_long(struct task_struct *task, int offset,
-	unsigned long data)
-{
-	unsigned char * stack;
-
-	stack = (unsigned char *)task->thread.esp0 - sizeof(struct pt_regs);
-	stack += offset;
-	*(unsigned long *) stack = data;
-	return 0;
+	BUILD_BUG_ON(offsetof(struct pt_regs, ebx) != 0);
+	if (regno > FS)
+		--regno;
+	return &regs->ebx + regno;
 }
 
 static int putreg(struct task_struct *child,
 	unsigned long regno, unsigned long value)
 {
-	switch (regno >> 2) {
+	struct pt_regs *regs = task_pt_regs(child);
+	regno >>= 2;
+	switch (regno) {
 		case GS:
 			if (value && (value & 3) != 3)
 				return -EIO;
@@ -113,26 +80,25 @@ static int putreg(struct task_struct *child,
 				clear_tsk_thread_flag(child, TIF_FORCED_TF);
 			else if (test_tsk_thread_flag(child, TIF_FORCED_TF))
 				value |= X86_EFLAGS_TF;
-			value |= get_stack_long(child, EFL_OFFSET) & ~FLAG_MASK;
+			value |= regs->eflags & ~FLAG_MASK;
 			break;
 	}
-	if (regno > FS*4)
-		regno -= 1*4;
-	put_stack_long(child, regno, value);
+	*pt_regs_access(regs, regno) = value;
 	return 0;
 }
 
-static unsigned long getreg(struct task_struct *child,
-	unsigned long regno)
+static unsigned long getreg(struct task_struct *child, unsigned long regno)
 {
+	struct pt_regs *regs = task_pt_regs(child);
 	unsigned long retval = ~0UL;
 
-	switch (regno >> 2) {
+	regno >>= 2;
+	switch (regno) {
 		case EFL:
 			/*
 			 * If the debugger set TF, hide it from the readout.
 			 */
-			retval = get_stack_long(child, EFL_OFFSET);
+			retval = regs->eflags;
 			if (test_tsk_thread_flag(child, TIF_FORCED_TF))
 				retval &= ~X86_EFLAGS_TF;
 			break;
@@ -147,9 +113,7 @@ static unsigned long getreg(struct task_struct *child,
 			retval = 0xffff;
 			/* fall through */
 		default:
-			if (regno > FS*4)
-				regno -= 1*4;
-			retval &= get_stack_long(child, regno);
+			retval &= *pt_regs_access(regs, regno);
 	}
 	return retval;
 }
