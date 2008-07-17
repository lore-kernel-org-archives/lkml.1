Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYGQHdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYGQHdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759755AbYGQHaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759699AbYGQHau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 14/23] tracehook: get_signal_to_deliver
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
Emacs: Lovecraft was an optimist.
Message-Id: <20080717073036.D721215411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:30:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines the tracehook_get_signal() hook to allow tracing code to
slip in before normal signal dequeuing.  This lays the groundwork for
new tracing features that can inject synthetic signals outside the
normal queue or control the disposition of delivered signals.  The
calling convention lets tracehook_get_signal() decide both exactly
what will happen and what signal number to report in the handler/exit.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   29 +++++++++++++++++++++++++++++
 kernel/signal.c           |   38 +++++++++++++++++++++++++++-----------
 2 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 3548694..42a0d7b 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -422,4 +422,33 @@ static inline int tracehook_consider_fatal_signal(struct task_struct *task,
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
+/**
+ * tracehook_get_signal - deliver synthetic signal to traced task
+ * @task:		@current
+ * @regs:		task_pt_regs(@current)
+ * @info:		details of synthetic signal
+ * @return_ka:		sigaction for synthetic signal
+ *
+ * Return zero to check for a real pending signal normally.
+ * Return -1 after releasing the siglock to repeat the check.
+ * Return a signal number to induce an artifical signal delivery,
+ * setting *@info and *@return_ka to specify its details and behavior.
+ *
+ * The @return_ka->sa_handler value controls the disposition of the
+ * signal, no matter the signal number.  For %SIG_DFL, the return value
+ * is a representative signal to indicate the behavior (e.g. %SIGTERM
+ * for death, %SIGQUIT for core dump, %SIGSTOP for job control stop,
+ * %SIGTSTP for stop unless in an orphaned pgrp), but the signal number
+ * reported will be @info->si_signo instead.
+ *
+ * Called with @task->sighand->siglock held, before dequeuing pending signals.
+ */
+static inline int tracehook_get_signal(struct task_struct *task,
+				       struct pt_regs *regs,
+				       siginfo_t *info,
+				       struct k_sigaction *return_ka)
+{
+	return 0;
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/signal.c b/kernel/signal.c
index 860afb8..1766c47 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1779,17 +1779,33 @@ relock:
 		    do_signal_stop(0))
 			goto relock;
 
-		signr = dequeue_signal(current, &current->blocked, info);
-		if (!signr)
-			break; /* will return 0 */
+		/*
+		 * Tracing can induce an artifical signal and choose sigaction.
+		 * The return value in @signr determines the default action,
+		 * but @info->si_signo is the signal number we will report.
+		 */
+		signr = tracehook_get_signal(current, regs, info, return_ka);
+		if (unlikely(signr < 0))
+			goto relock;
+		if (unlikely(signr != 0))
+			ka = return_ka;
+		else {
+			signr = dequeue_signal(current, &current->blocked,
+					       info);
 
-		if (signr != SIGKILL) {
-			signr = ptrace_signal(signr, info, regs, cookie);
 			if (!signr)
-				continue;
+				break; /* will return 0 */
+
+			if (signr != SIGKILL) {
+				signr = ptrace_signal(signr, info,
+						      regs, cookie);
+				if (!signr)
+					continue;
+			}
+
+			ka = &sighand->action[signr-1];
 		}
 
-		ka = &sighand->action[signr-1];
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {
@@ -1837,7 +1853,7 @@ relock:
 				spin_lock_irq(&sighand->siglock);
 			}
 
-			if (likely(do_signal_stop(signr))) {
+			if (likely(do_signal_stop(info->si_signo))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
@@ -1858,7 +1874,7 @@ relock:
 
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
-				print_fatal_signal(regs, signr);
+				print_fatal_signal(regs, info->si_signo);
 			/*
 			 * If it was able to dump core, this kills all
 			 * other threads in the group and synchronizes with
@@ -1867,13 +1883,13 @@ relock:
 			 * first and our do_group_exit call below will use
 			 * that value and ignore the one we pass it.
 			 */
-			do_coredump((long)signr, signr, regs);
+			do_coredump(info->si_signo, info->si_signo, regs);
 		}
 
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(signr);
+		do_group_exit(info->si_signo);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
