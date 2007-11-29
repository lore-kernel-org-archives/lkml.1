Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbXK2MCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbXK2MCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762747AbXK2MBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:01:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762642AbXK2MBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:01:03 -0500
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
Subject: [PATCH x86/mm 07/11] x86 ptrace merge syscall trace
In-Reply-To: Roland McGrath's message of  Thursday, 29 November 2007 03:57:11 -0800 <20071129115711.9FC8526F8E7@magilla.localdomain>
References: <20071129115711.9FC8526F8E7@magilla.localdomain>
X-Shopping-List: (1) Musical pigs
   (2) Ubiquitous gold
   (3) Ostentatious carrion miscreants
   (4) Archaic selectors
Message-Id: <20071129120022.28DE826F8EA@magilla.localdomain>
Date: Thu, 29 Nov 2007 04:00:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This moves the 64-bit syscall tracing functions into ptrace.c,
so that ptrace_64.c becomes entirely obsolete.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index f4355f3..2eac631 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -632,6 +632,8 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	return ret;
 }
 
+#ifdef CONFIG_X86_32
+
 void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 {
 	struct siginfo info;
@@ -729,3 +731,65 @@ out:
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 	return 1;
 }
+
+#else  /* CONFIG_X86_64 */
+
+static void syscall_trace(struct pt_regs *regs)
+{
+
+#if 0
+	printk("trace %s ip %lx sp %lx ax %d origrax %d caller %lx tiflags %x ptrace %x\n",
+	       current->comm,
+	       regs->ip, regs->sp, regs->ax, regs->orig_ax, __builtin_return_address(0),
+	       current_thread_info()->flags, current->ptrace);
+#endif
+
+	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
+				? 0x80 : 0));
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
+
+asmlinkage void syscall_trace_enter(struct pt_regs *regs)
+{
+	/* do the secure computing check first */
+	secure_computing(regs->orig_ax);
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE)
+	    && (current->ptrace & PT_PTRACED))
+		syscall_trace(regs);
+
+	if (unlikely(current->audit_context)) {
+		if (test_thread_flag(TIF_IA32)) {
+			audit_syscall_entry(AUDIT_ARCH_I386,
+					    regs->orig_ax,
+					    regs->bx, regs->cx,
+					    regs->dx, regs->si);
+		} else {
+			audit_syscall_entry(AUDIT_ARCH_X86_64,
+					    regs->orig_ax,
+					    regs->di, regs->si,
+					    regs->dx, regs->r10);
+		}
+	}
+}
+
+asmlinkage void syscall_trace_leave(struct pt_regs *regs)
+{
+	if (unlikely(current->audit_context))
+		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
+
+	if ((test_thread_flag(TIF_SYSCALL_TRACE)
+	     || test_thread_flag(TIF_SINGLESTEP))
+	    && (current->ptrace & PT_PTRACED))
+		syscall_trace(regs);
+}
+
+#endif	/* CONFIG_X86_32 */
