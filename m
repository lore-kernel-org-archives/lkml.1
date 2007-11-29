Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbXK2L5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbXK2L5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 06:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbXK2L52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 06:57:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbXK2L51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 06:57:27 -0500
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
Subject: [PATCH x86/mm 01/11] x86-32 thread_struct.debugreg
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071129115711.9FC8526F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 03:57:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This replaces the debugreg[7] member of thread_struct with individual
members debugreg0, etc.  This saves two words for the dummies 4 and 5,
and harmonizes the code between 32 and 64.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/process_32.c   |   31 ++++++++++++++++++++-----------
 arch/x86/kernel/ptrace_32.c    |   29 ++++++++++++++++++++++++-----
 arch/x86/kernel/signal_32.c    |    4 ++--
 arch/x86/kernel/traps_32.c     |    4 ++--
 arch/x86/power/cpu.c           |   14 +++++++-------
 include/asm-x86/processor_32.h |    7 ++++++-
 6 files changed, 61 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8234054..d37bf10 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -425,7 +425,12 @@ void flush_thread(void)
 {
 	struct task_struct *tsk = current;
 
-	memset(tsk->thread.debugreg, 0, sizeof(unsigned long)*8);
+	tsk->thread.debugreg0 = 0;
+	tsk->thread.debugreg1 = 0;
+	tsk->thread.debugreg2 = 0;
+	tsk->thread.debugreg3 = 0;
+	tsk->thread.debugreg6 = 0;
+	tsk->thread.debugreg7 = 0;
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 	/*
@@ -502,7 +507,6 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
  */
 void dump_thread(struct pt_regs * regs, struct user * dump)
 {
-	int i;
 	u16 gs;
 
 /* changed the size calculations - should hopefully work better. lbt */
@@ -513,8 +517,14 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
-	for (i = 0; i < 8; i++)
-		dump->u_debugreg[i] = current->thread.debugreg[i];  
+	dump->u_debugreg[0] = current->thread.debugreg0;
+	dump->u_debugreg[1] = current->thread.debugreg1;
+	dump->u_debugreg[2] = current->thread.debugreg2;
+	dump->u_debugreg[3] = current->thread.debugreg3;
+	dump->u_debugreg[4] = 0;
+	dump->u_debugreg[5] = 0;
+	dump->u_debugreg[6] = current->thread.debugreg6;
+	dump->u_debugreg[7] = current->thread.debugreg7;
 
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
@@ -592,13 +602,13 @@ __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		wrmsr(MSR_IA32_DEBUGCTLMSR, next->debugctlmsr, 0);
 
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
-		set_debugreg(next->debugreg[0], 0);
-		set_debugreg(next->debugreg[1], 1);
-		set_debugreg(next->debugreg[2], 2);
-		set_debugreg(next->debugreg[3], 3);
+		set_debugreg(next->debugreg0, 0);
+		set_debugreg(next->debugreg1, 1);
+		set_debugreg(next->debugreg2, 2);
+		set_debugreg(next->debugreg3, 3);
 		/* no 4 and 5 */
-		set_debugreg(next->debugreg[6], 6);
-		set_debugreg(next->debugreg[7], 7);
+		set_debugreg(next->debugreg6, 6);
+		set_debugreg(next->debugreg7, 7);
 	}
 
 #ifdef CONFIG_SECCOMP
@@ -849,4 +859,3 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 	unsigned long range_end = mm->brk + 0x02000000;
 	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
 }
-
diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index 2607130..fed83d0 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -133,19 +133,39 @@ static unsigned long getreg(struct task_struct *child, unsigned long regno)
  */
 static unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
 {
-	return child->thread.debugreg[n];
+	switch (n) {
+	case 0:		return child->thread.debugreg0;
+	case 1:		return child->thread.debugreg1;
+	case 2:		return child->thread.debugreg2;
+	case 3:		return child->thread.debugreg3;
+	case 6:		return child->thread.debugreg6;
+	case 7:		return child->thread.debugreg7;
+	}
+	return 0;
 }
 
 static int ptrace_set_debugreg(struct task_struct *child,
 			       int n, unsigned long data)
 {
+	int i;
+
 	if (unlikely(n == 4 || n == 5))
 		return -EIO;
 
 	if (n < 4 && unlikely(data >= TASK_SIZE - 3))
 		return -EIO;
 
-	if (n == 7) {
+	switch (n) {
+	case 0:		child->thread.debugreg0 = data; break;
+	case 1:		child->thread.debugreg1 = data; break;
+	case 2:		child->thread.debugreg2 = data; break;
+	case 3:		child->thread.debugreg3 = data; break;
+
+	case 6:
+		child->thread.debugreg6 = data;
+		break;
+
+	case 7:
 		/*
 		 * Sanity-check data. Take one half-byte at once with
 		 * check = (val >> (16 + 4*i)) & 0xf. It contains the
@@ -176,19 +196,18 @@ static int ptrace_set_debugreg(struct task_struct *child,
 		 * 64-bit kernel), so the x86_64 mask value is 0x5454.
 		 * See the AMD manual no. 24593 (AMD64 System Programming)
 		 */
-		int i;
 		data &= ~DR_CONTROL_RESERVED;
 		for (i = 0; i < 4; i++)
 			if ((0x5f54 >> ((data >> (16 + 4*i)) & 0xf)) & 1)
 				return -EIO;
+		child->thread.debugreg7 = data;
 		if (data)
 			set_tsk_thread_flag(child, TIF_DEBUG);
 		else
 			clear_tsk_thread_flag(child, TIF_DEBUG);
+		break;
 	}
 
-	child->thread.debugreg[n] = data;
-
 	return 0;
 }
 
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index e8ab332..985c197 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -605,8 +605,8 @@ static void fastcall do_signal(struct pt_regs *regs)
 		 * have been cleared if the watchpoint triggered
 		 * inside the kernel.
 		 */
-		if (unlikely(current->thread.debugreg[7]))
-			set_debugreg(current->thread.debugreg[7], 7);
+		if (unlikely(current->thread.debugreg7))
+			set_debugreg(current->thread.debugreg7, 7);
 
 		/* Whee!  Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index f34842a..7858ccb 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -853,7 +853,7 @@ fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
 
 	/* Mask out spurious debug traps due to lazy DR7 setting */
 	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
-		if (!tsk->thread.debugreg[7])
+		if (!tsk->thread.debugreg7)
 			goto clear_dr7;
 	}
 
@@ -861,7 +861,7 @@ fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
 		goto debug_vm86;
 
 	/* Save debug status register where ptrace can see it */
-	tsk->thread.debugreg[6] = condition;
+	tsk->thread.debugreg6 = condition;
 
 	/*
 	 * Single-stepping through TF: make sure we ignore any events in
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 998fd3e..5a98dc3 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -74,14 +74,14 @@ static void fix_processor_context(void)
 	/*
 	 * Now maybe reload the debug registers
 	 */
-	if (current->thread.debugreg[7]){
-		set_debugreg(current->thread.debugreg[0], 0);
-		set_debugreg(current->thread.debugreg[1], 1);
-		set_debugreg(current->thread.debugreg[2], 2);
-		set_debugreg(current->thread.debugreg[3], 3);
+	if (current->thread.debugreg7) {
+		set_debugreg(current->thread.debugreg0, 0);
+		set_debugreg(current->thread.debugreg1, 1);
+		set_debugreg(current->thread.debugreg2, 2);
+		set_debugreg(current->thread.debugreg3, 3);
 		/* no 4 and 5 */
-		set_debugreg(current->thread.debugreg[6], 6);
-		set_debugreg(current->thread.debugreg[7], 7);
+		set_debugreg(current->thread.debugreg6, 6);
+		set_debugreg(current->thread.debugreg7, 7);
 	}
 
 }
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index c85400f..d50a4b4 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -353,7 +353,12 @@ struct thread_struct {
 	unsigned long	fs;
 	unsigned long	gs;
 /* Hardware debugging registers */
-	unsigned long	debugreg[8];  /* %%db0-7 debug registers */
+	unsigned long	debugreg0;
+	unsigned long	debugreg1;
+	unsigned long	debugreg2;
+	unsigned long	debugreg3;
+	unsigned long	debugreg6;
+	unsigned long	debugreg7;
 /* fault info */
 	unsigned long	cr2, trap_no, error_code;
 /* floating point info */
