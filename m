Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbZHSMTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbZHSMTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZHSMTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:19:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:51416 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZHSMTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:19:14 -0400
Date: Wed, 19 Aug 2009 12:18:37 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, jbaron@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <tip-fb34a08c3469b2be9eae626ccb96476b4687b810@git.kernel.org>
References: <tip-fb34a08c3469b2be9eae626ccb96476b4687b810@git.kernel.org>
Subject: [tip:tracing/core] [S390] ftrace: update system call tracer support
Message-ID: <tip-5e9ad7df9fd056f1071af8aa91034a1c3170257d@git.kernel.org>
Git-Commit-ID: 5e9ad7df9fd056f1071af8aa91034a1c3170257d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 12:18:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e9ad7df9fd056f1071af8aa91034a1c3170257d
Gitweb:     http://git.kernel.org/tip/5e9ad7df9fd056f1071af8aa91034a1c3170257d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 18 Aug 2009 10:41:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Aug 2009 14:16:15 +0200

[S390] ftrace: update system call tracer support

Commit fb34a08c3 ("tracing: Add trace events for each syscall
entry/exit") changed the lowlevel API to ftrace syscall tracing
but did not update s390 which started making use of it recently.

This broke the s390 build, as reported by Paul Mundt.

Update the callbacks with the syscall number and the syscall
return code values. This allows per syscall tracepoints,
syscall argument enumeration /debug/tracing/events/syscalls/
and perfcounters support and integration on s390 too.

Reported-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <tip-fb34a08c3469b2be9eae626ccb96476b4687b810@git.kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/s390/kernel/ptrace.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 43acd73..c5e87d8 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -51,6 +51,9 @@
 #include "compat_ptrace.h"
 #endif
 
+DEFINE_TRACE(syscall_enter);
+DEFINE_TRACE(syscall_exit);
+
 enum s390_regset {
 	REGSET_GENERAL,
 	REGSET_FP,
@@ -662,7 +665,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	}
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_enter(regs);
+		trace_syscall_enter(regs, regs->gprs[2]);
 
 	if (unlikely(current->audit_context))
 		audit_syscall_entry(is_compat_task() ?
@@ -680,7 +683,7 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
 				   regs->gprs[2]);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_exit(regs);
+		trace_syscall_exit(regs, regs->gprs[2]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
