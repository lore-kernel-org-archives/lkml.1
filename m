Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYGPXG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYGPXG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760017AbYGPXFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:05:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512AbYGPXFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:05:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 4/4] x86 ptrace: user-sets-TF nits
In-Reply-To: Roland McGrath's message of  Wednesday, 16 July 2008 16:02:17 -0700 <20080716230217.3C25715410D@magilla.localdomain>
References: <20080716230217.3C25715410D@magilla.localdomain>
X-Shopping-List: (1) Amphibious important consolation fruit
   (2) Garden-variety lesion pretenders
   (3) Resonant scenarios
   (4) Magnificent rotators
   (5) Specious esoteric destroyer porno
Message-Id: <20080716230548.70C4815410D@magilla.localdomain>
Date: Wed, 16 Jul 2008 16:05:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This closes some arcane holes in single-step handling that can arise
only when user programs set TF directly (via popf or sigreturn) and
then use vDSO (syscall/sysenter) system call entry.  In those entry
paths, the clear_TF_reenable case hits and we must check TIF_SINGLESTEP
to be sure our bookkeeping stays correct wrt the user's view of TF.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c      |   10 ++++++++++
 arch/x86/kernel/step.c        |   13 +++++++++++++
 include/asm-x86/thread_info.h |    2 +-
 3 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 34e77b1..e37dccc 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1416,6 +1416,16 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
+	/*
+	 * If we stepped into a sysenter/syscall insn, it trapped in
+	 * kernel mode; do_debug() cleared TF and set TIF_SINGLESTEP.
+	 * If user-mode had set TF itself, then it's still clear from
+	 * do_debug() and we need to set it again to restore the user
+	 * state.  If we entered on the slow path, TF was already set.
+	 */
+	if (test_thread_flag(TIF_SINGLESTEP))
+		regs->flags |= X86_EFLAGS_TF;
+
 	/* do the secure computing check first */
 	secure_computing(regs->orig_ax);
 
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 0d2cb36..e8b9863 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -108,6 +108,19 @@ static int enable_single_step(struct task_struct *child)
 	unsigned long oflags;
 
 	/*
+	 * If we stepped into a sysenter/syscall insn, it trapped in
+	 * kernel mode; do_debug() cleared TF and set TIF_SINGLESTEP.
+	 * If user-mode had set TF itself, then it's still clear from
+	 * do_debug() and we need to set it again to restore the user
+	 * state so we don't wrongly set TIF_FORCED_TF below.
+	 * If enable_single_step() was used last and that is what
+	 * set TIF_SINGLESTEP, then both TF and TIF_FORCED_TF are
+	 * already set and our bookkeeping is fine.
+	 */
+	if (unlikely(test_tsk_thread_flag(child, TIF_SINGLESTEP)))
+		regs->flags |= X86_EFLAGS_TF;
+
+	/*
 	 * Always set TIF_SINGLESTEP - this guarantees that
 	 * we single-step system calls etc..  This will also
 	 * cause us to set TF when returning to user mode.
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index b2702a1..0a8f27d 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -118,7 +118,7 @@ struct thread_info {
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | \
-	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
+	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\

