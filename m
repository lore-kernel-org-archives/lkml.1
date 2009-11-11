Return-Path: <linux-kernel-owner+w=401wt.eu-S932075AbZKKVhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbZKKVhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759353AbZKKVhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:37:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759335AbZKKVhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:37:03 -0500
Date: Wed, 11 Nov 2009 22:32:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ptrace: x86: change syscall_trace_leave() to rely on
	tracehook when stepping
Message-ID: <20091111213206.GA10663@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Roland.

Unlike powepc, x86 always calls tracehook_report_syscall_exit(step)
with step = 0, and sends the trap by hand.

This results in unnecessary SIGTRAP when PTRACE_SINGLESTEP follows
the syscall-exit stop.

Change syscall_trace_leave() to pass the correct "step" argument to
tracehook and remove the send_sigtrap() logic.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 arch/x86/kernel/ptrace.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- TH/arch/x86/kernel/ptrace.c~5_X86_CONVERT_SYSCALL_LEAVE	2009-11-10 22:21:42.000000000 +0100
+++ TH/arch/x86/kernel/ptrace.c	2009-11-10 22:29:54.000000000 +0100
@@ -1528,29 +1528,22 @@ asmregparm long syscall_trace_enter(stru
 
 asmregparm void syscall_trace_leave(struct pt_regs *regs)
 {
+	bool step;
+
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_exit(regs, regs->ax);
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		tracehook_report_syscall_exit(regs, 0);
-
 	/*
 	 * If TIF_SYSCALL_EMU is set, we only get here because of
 	 * TIF_SINGLESTEP (i.e. this is PTRACE_SYSEMU_SINGLESTEP).
 	 * We already reported this syscall instruction in
-	 * syscall_trace_enter(), so don't do any more now.
-	 */
-	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
-		return;
-
-	/*
-	 * If we are single-stepping, synthesize a trap to follow the
-	 * system call instruction.
+	 * syscall_trace_enter().
 	 */
-	if (test_thread_flag(TIF_SINGLESTEP) &&
-	    tracehook_consider_fatal_signal(current, SIGTRAP))
-		send_sigtrap(current, regs, 0, TRAP_BRKPT);
+	step = unlikely(test_thread_flag(TIF_SINGLESTEP)) &&
+			!test_thread_flag(TIF_SYSCALL_EMU);
+	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
+		tracehook_report_syscall_exit(regs, step);
 }

