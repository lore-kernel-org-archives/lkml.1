Return-Path: <linux-kernel-owner+w=401wt.eu-S1760906AbYDPChd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906AbYDPChd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYDPCh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:37:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbYDPChZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:37:25 -0400
From: Roland McGrath <roland@redhat.com>
To: jason.wessel@windriver.com
X-Fcc: ~/Mail/linus
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: i386 single-step vs int $0x80 issues
X-Zippy-Says: ..  My vaseline is RUNNING...
Message-Id: <20080416023650.E3CBDEFFEA@magilla.localdomain>
Date: Tue, 15 Apr 2008 19:36:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason made a change, 1e2e99f0e4aa6363e8515ed17011c210c8f1b52a on 2007-7-6:

    i386: fix regression, endless loop in ptrace singlestep over an int80

I'm trying to figure out what the full story behind that was.  The
log message includes source for a test program.  I cannot reproduce
anything like the problem described.  I tried it when building the
kernel sources from the state just before that commit, as well as
the current kernel with that commit's patch reverted.

The list traffic I found about this did not seem to say it was an
intermittent problem.  I really cannot understand how the failure
mode described could have been happening (except in one racy way on
SMP only, that I don't know how to provoke).  The logic of the
change is wrong IMHO, and it broke some cases that worked before it
(stepping into sigreturn).

The description of the behavior of the test suggests it assumed
that libc calls like write would use an int $0x80 syscall, which
is not something you can rely on.  I replaced the "write" call in
the test with:

    asm volatile ("push %%ebx; mov %1,%%ebx; int $0x80; pop %%ebx"
		  : "=a" (ret)
		  : "g" (1), "a" (4), "c" (str), "d" (sizeof str - 1)
		  : "ebx");

But still I could not find any way to reproduce the failure mode
that Jason's report described.

The patch below and the comments it includes describe what's going
on, why the 1e2e99f0... change was wrong, and revert it while fixing
the one thing I saw wrong with Chuck's 635cf99a... change.

But I'm not submitting this change now.  Firstly, I really want to
understand what it was that Jason saw and if there is some scenario
here I have overlooked.  Secondly, while doing this I realized there
are some 32/64 differences in how all this handling works, and I
think I'll rejigger it all some more to clean it up.


Thanks,
Roland

---

[PATCH] i386 single-step int80 fix

The change in commit 1e2e99f0e4aa6363e8515ed17011c210c8f1b52a did not
make sense.  It claimed to fix a regression introduced by commit
635cf99a80f4ebee59d70eb64bb85ce829e4591f, but I cannot reproduce any
such problem or understand what failure might have been happening.
The later change caused regressions of its own and did not fix
anything AFAICT.  The only thing I see wrong with the earlier fix was
for CONFIG_SMP, the use of "orl" without "lock" on thread_info.flags.

This restores the behavior of 1e2e99f0e4aa6363e8515ed17011c210c8f1b52a,
but with slightly different new code.  It adds a lengthy comment
explaining the situation thoroughly to prevent future confusion.  It
uses the standard set_bit code sequence for touching thread_info.flags,
which ensures robust SMP-safe access to the field.

---

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 4b87c32..0000000 100644  
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -51,6 +51,7 @@
 #include <asm/desc.h>
 #include <asm/percpu.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 #include "irq_vectors.h"
 
 /*
@@ -369,6 +370,52 @@ ENTRY(system_call)
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
+
+	/*
+	 * If the user's eflags had TF set, we are single-stepping the
+	 * system call instruction and should stop immediately upon
+	 * returning to user mode (we must not execute the following user
+	 * instruction first).
+	 *
+	 * When we enter via "int", the processor automatically clears
+	 * the kernel-mode TF for the mode switch, leaving TF set in the
+	 * eflags image in the user trap frame.
+	 *
+	 * When we enter via sysenter, the processor does not
+	 * clear TF.  So in those cases, we actually take the single-step
+	 * trap after the first kernel-mode instruction, before it has
+	 * saved the user-mode eflags value, and get into the trap handler
+	 * for a kernel-mode trap.  That handler (do_debug) sets
+	 * TIF_SINGLESTEP, clears TF, and resumes the unfinished kernel
+	 * entry code, so we have a saved eflags image with no TF in it
+	 * but do have the TIF_SINGLESTEP flag set.  When we're exiting
+	 * the system call with TIF_SINGLESTEP set, we emulate a
+	 * single-step trap as if the system call instruction had been a
+	 * normal user instruction that just completed.  We also check
+	 * that flag on any kind of return to user mode, and set TF back
+	 * into the user eflags image.
+	 *
+	 * A system call like sigreturn can change the user-mode eflags
+	 * directly.  It can clear TF when we had single-stepped into the
+	 * system call instruction; then we should still emulate a
+	 * single-step trap before returning to user mode at the current
+	 * PC.  Or it can set TF when we were not single-stepping before;
+	 * then it should behave as if the user had set TF with "popf":
+	 * execute one more user-mode instruction before taking the trap,
+	 * not take it immediately after the system call instruction.
+	 * Ergo, we must check whether the user-mode state had TF set when
+	 * it executed the system call instruction, not after the system
+	 * call does its work.  When TF was set in user mode, we set
+	 * TIF_SINGLESTEP here just like do_debug does.  Here, it's not
+	 * needed to set TF in the user eflags image (TF is already there).
+	 * But it's needed just the same to drive syscall_exit_work (below).
+	 */
+	testw $TF_MASK,PT_EFLAGS(%esp)
+	jz 1f
+	LOCK_PREFIX
+	bts $TIF_SINGLESTEP,TI_flags(%ebp)
+1:
+
 					# system call tracing in operation / emulation
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
 	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
@@ -384,10 +431,6 @@ syscall_exit:
 					# setting need_resched or sigpending
 					# between sampling and the iret
 	TRACE_IRQS_OFF
-	testl $TF_MASK,PT_EFLAGS(%esp)	# If tracing set singlestep flag on exit
-	jz no_singlestep
-	orl $_TIF_SINGLESTEP,TI_flags(%ebp)
-no_singlestep:
 	movl TI_flags(%ebp), %ecx
 	testw $_TIF_ALLWORK_MASK, %cx	# current->work
 	jne syscall_exit_work
