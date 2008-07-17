Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbYGQHsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbYGQHsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbYGQHsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:48:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbYGQHsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:48:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 2/6] x86: tracehook syscall
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:45:50 -0700 <20080717074550.EE1E215411D@magilla.localdomain>
References: <20080717074550.EE1E215411D@magilla.localdomain>
X-Windows: it was hard to write; it should be hard to use.
Message-Id: <20080717074809.C87D715411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:48:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes x86 syscall tracing to use the new tracehook.h entry points.
There is no change, only cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   34 ++++++----------------------------
 1 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index e37dccc..19a7d2c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/regset.h>
+#include <linux/tracehook.h>
 #include <linux/user.h>
 #include <linux/elf.h>
 #include <linux/security.h>
@@ -1375,30 +1376,6 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
-static void syscall_trace(struct pt_regs *regs)
-{
-	if (!(current->ptrace & PT_PTRACED))
-		return;
-
-#if 0
-	printk("trace %s ip %lx sp %lx ax %d origrax %d caller %lx tiflags %x ptrace %x\n",
-	       current->comm,
-	       regs->ip, regs->sp, regs->ax, regs->orig_ax, __builtin_return_address(0),
-	       current_thread_info()->flags, current->ptrace);
-#endif
-
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				? 0x80 : 0));
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
-}
 
 #ifdef CONFIG_X86_32
 # define IS_IA32	1
@@ -1432,8 +1409,9 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
 		ret = -1L;
 
-	if (ret || test_thread_flag(TIF_SYSCALL_TRACE))
-		syscall_trace(regs);
+	if ((ret || test_thread_flag(TIF_SYSCALL_TRACE)) &&
+	    tracehook_report_syscall_entry(regs))
+		ret = -1L;
 
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
@@ -1459,7 +1437,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		syscall_trace(regs);
+		tracehook_report_syscall_exit(regs, 0);
 
 	/*
 	 * If TIF_SYSCALL_EMU is set, we only get here because of
@@ -1475,6 +1453,6 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 	 * system call instruction.
 	 */
 	if (test_thread_flag(TIF_SINGLESTEP) &&
-	    (current->ptrace & PT_PTRACED))
+	    tracehook_consider_fatal_signal(current, SIGTRAP, SIG_DFL))
 		send_sigtrap(current, regs, 0);
 }
