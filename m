Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbYGPXF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbYGPXF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbYGPXFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:05:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305AbYGPXFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:05:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 2/4] x86 ptrace: unify TIF_SINGLESTEP
In-Reply-To: Roland McGrath's message of  Wednesday, 16 July 2008 16:02:17 -0700 <20080716230217.3C25715410D@magilla.localdomain>
References: <20080716230217.3C25715410D@magilla.localdomain>
X-Zippy-Says: Alright, you!!  Imitate a WOUNDED SEAL pleading for a PARKING SPACE!!
Message-Id: <20080716230437.499BC15410D@magilla.localdomain>
Date: Wed, 16 Jul 2008 16:04:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This unifies the treatment of TIF_SINGLESTEP on i386 and x86_64.
The bit is now excluded from _TIF_WORK_MASK on i386 as it has been
on x86_64.  This means the do_notify_resume() path using it is never
used, so TIF_SINGLESTEP is not cleared on returning to user mode.

Both now leave TIF_SINGLESTEP set when returning to user, so that
it's already set on an int $0x80 system call entry.  This removes
the need for testing TF on the system_call path.  Doing it this way
fixes the regression for PTRACE_SINGLESTEP into a sigreturn syscall,
introduced by commit 1e2e99f0e4aa6363e8515ed17011c210c8f1b52a.

The clear_TF_reenable case that sets TIF_SINGLESTEP can only happen
on a non-exception kernel entry, i.e. sysenter/syscall instruction.
That will always get to the syscall exit tracing path.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_32.S    |    4 ----
 arch/x86/kernel/signal_32.c   |    6 ------
 arch/x86/kernel/signal_64.c   |    6 ------
 include/asm-x86/thread_info.h |    4 ++--
 4 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 6bc07f0..0ad987d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -383,10 +383,6 @@ syscall_exit:
 					# setting need_resched or sigpending
 					# between sampling and the iret
 	TRACE_IRQS_OFF
-	testl $X86_EFLAGS_TF,PT_EFLAGS(%esp)	# If tracing set singlestep flag on exit
-	jz no_singlestep
-	orl $_TIF_SINGLESTEP,TI_flags(%ebp)
-no_singlestep:
 	movl TI_flags(%ebp), %ecx
 	testw $_TIF_ALLWORK_MASK, %cx	# current->work
 	jne syscall_exit_work
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d923736..295b5f5 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -657,12 +657,6 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-	/* Pending single-step? */
-	if (thread_info_flags & _TIF_SINGLESTEP) {
-		regs->flags |= X86_EFLAGS_TF;
-		clear_thread_flag(TIF_SINGLESTEP);
-	}
-
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index e53b267..bf87684 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -487,12 +487,6 @@ static void do_signal(struct pt_regs *regs)
 void do_notify_resume(struct pt_regs *regs, void *unused,
 		      __u32 thread_info_flags)
 {
-	/* Pending single-step? */
-	if (thread_info_flags & _TIF_SINGLESTEP) {
-		regs->flags |= X86_EFLAGS_TF;
-		clear_thread_flag(TIF_SINGLESTEP);
-	}
-
 #ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index 895339d..fb8d3cd 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -124,7 +124,7 @@ struct thread_info {
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
 	(0x0000FFFF &							\
-	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|	\
+	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|			\
 	 _TIF_SECCOMP|_TIF_SYSCALL_EMU))
 
 /* work to do on any return to user space */
@@ -132,7 +132,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
