Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYG0GvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYG0GvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYG0GvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:51:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787AbYG0GvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:51:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] powerpc: tracehook syscall
In-Reply-To: Roland McGrath's message of  Saturday, 26 July 2008 23:48:59 -0700 <20080727064859.69692154280@magilla.localdomain>
References: <20080727064859.69692154280@magilla.localdomain>
X-Windows: graphics hacking :: Roman numerals : sqrt (pi)
Message-Id: <20080727065103.3E894154280@magilla.localdomain>
Date: Sat, 26 Jul 2008 23:51:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes powerpc syscall tracing to use the new tracehook.h entry
points.  There is no change, only cleanup.

The assembly changes allow do_syscall_trace_enter() to abort the
syscall without losing the information about the original r0 value.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/entry_32.S |    7 +++++-
 arch/powerpc/kernel/entry_64.S |    7 +++++-
 arch/powerpc/kernel/ptrace.c   |   47 ++++++++++++++++++---------------------
 3 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 81c8324..0efc1e6 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -343,7 +343,12 @@ syscall_dotrace:
 	stw	r0,_TRAP(r1)
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	do_syscall_trace_enter
-	lwz	r0,GPR0(r1)	/* Restore original registers */
+	/*
+	 * Restore argument registers possibly just changed.
+	 * We use the return value of do_syscall_trace_enter
+	 * for call number to look up in the table (r0).
+	 */
+	mr	r0,r3
 	lwz	r3,GPR3(r1)
 	lwz	r4,GPR4(r1)
 	lwz	r5,GPR5(r1)
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index d736924..79c089e 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -214,7 +214,12 @@ syscall_dotrace:
 	bl	.save_nvgprs
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	.do_syscall_trace_enter
-	ld	r0,GPR0(r1)	/* Restore original registers */
+	/*
+	 * Restore argument registers possibly just changed.
+	 * We use the return value of do_syscall_trace_enter
+	 * for the call number to look up in the table (r0).
+	 */
+	mr	r0,r3
 	ld	r3,GPR3(r1)
 	ld	r4,GPR4(r1)
 	ld	r5,GPR5(r1)
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index a5d0e78..3f9a942 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/regset.h>
+#include <linux/tracehook.h>
 #include <linux/elf.h>
 #include <linux/user.h>
 #include <linux/security.h>
@@ -1013,31 +1014,24 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	return ret;
 }
 
-static void do_syscall_trace(void)
+/*
+ * We must return the syscall number to actually look up in the table.
+ * This can be -1L to skip running any syscall at all.
+ */
+long do_syscall_trace_enter(struct pt_regs *regs)
 {
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				 ? 0x80 : 0));
-
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
+	long ret = 0;
 
-void do_syscall_trace_enter(struct pt_regs *regs)
-{
 	secure_computing(regs->gpr[0]);
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE)
-	    && (current->ptrace & PT_PTRACED))
-		do_syscall_trace();
+	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
+	    tracehook_report_syscall_entry(regs))
+		/*
+		 * Tracing decided this syscall should not happen.
+		 * We'll return a bogus call number to get an ENOSYS
+		 * error, but leave the original number in regs->gpr[0].
+		 */
+		ret = -1L;
 
 	if (unlikely(current->audit_context)) {
 #ifdef CONFIG_PPC64
@@ -1055,16 +1049,19 @@ void do_syscall_trace_enter(struct pt_regs *regs)
 					    regs->gpr[5] & 0xffffffff,
 					    regs->gpr[6] & 0xffffffff);
 	}
+
+	return ret ?: regs->gpr[0];
 }
 
 void do_syscall_trace_leave(struct pt_regs *regs)
 {
+	int step;
+
 	if (unlikely(current->audit_context))
 		audit_syscall_exit((regs->ccr&0x10000000)?AUDITSC_FAILURE:AUDITSC_SUCCESS,
 				   regs->result);
 
-	if ((test_thread_flag(TIF_SYSCALL_TRACE)
-	     || test_thread_flag(TIF_SINGLESTEP))
-	    && (current->ptrace & PT_PTRACED))
-		do_syscall_trace();
+	step = test_thread_flag(TIF_SINGLESTEP);
+	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall_exit(regs, step);
 }
