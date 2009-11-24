Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbZKXUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbZKXUMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932915AbZKXUMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:12:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbZKXUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:12:14 -0500
Date: Tue, 24 Nov 2009 21:01:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 07/14] ptrace: x86: change syscall_trace_leave() to
	rely on tracehook when stepping
Message-ID: <20091124200152.GA5789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(already in mm: ptrace-x86-change-syscall_trace_leave-to-rely-on-tracehook-when-stepping.patch)

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

--- V1/arch/x86/kernel/ptrace.c~7_X86_CONVERT_SYSCALL_LEAVE	2009-11-24 19:52:11.000000000 +0100
+++ V1/arch/x86/kernel/ptrace.c	2009-11-24 19:52:12.000000000 +0100
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

