Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYDRBoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYDRBoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 21:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYDRBop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 21:44:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbYDRBoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 21:44:44 -0400
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace_signal subroutine
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Repugnant consoles
   (2) Grandiloquent oblivion
   (3) Archaic ambition
   (4) Expeditious ponderous dice
   (5) Fragrant translation exhibitions
Message-Id: <20080418014438.1C93C27037D@magilla.localdomain>
Date: Thu, 17 Apr 2008 18:44:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This breaks out the ptrace handling from get_signal_to_deliver
into a new subroutine.  The actual code there doesn't change, and
it gets inlined into nearly identical compiled code.  This makes
the function substantially shorter and thus easier to read, and
it nicely isolates the ptrace magic.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |   71 ++++++++++++++++++++++++++++++++----------------------
 1 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 977b3cd..144590c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1757,6 +1757,45 @@ static int do_signal_stop(int signr)
 	return 1;
 }
 
+static int ptrace_signal(int signr, siginfo_t *info,
+			 struct pt_regs *regs, void *cookie)
+{
+	if (!(current->ptrace & PT_PTRACED))
+		return signr;
+
+	ptrace_signal_deliver(regs, cookie);
+
+	/* Let the debugger run.  */
+	ptrace_stop(signr, 0, info);
+
+	/* We're back.  Did the debugger cancel the sig?  */
+	signr = current->exit_code;
+	if (signr == 0)
+		return signr;
+
+	current->exit_code = 0;
+
+	/* Update the siginfo structure if the signal has
+	   changed.  If the debugger wanted something
+	   specific in the siginfo structure then it should
+	   have updated *info via PTRACE_SETSIGINFO.  */
+	if (signr != info->si_signo) {
+		info->si_signo = signr;
+		info->si_errno = 0;
+		info->si_code = SI_USER;
+		info->si_pid = task_pid_vnr(current->parent);
+		info->si_uid = current->parent->uid;
+	}
+
+	/* If the (new) signal is now blocked, requeue it.  */
+	if (sigismember(&current->blocked, signr)) {
+		specific_send_sig_info(signr, info, current);
+		signr = 0;
+	}
+
+	return signr;
+}
+
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
@@ -1785,36 +1824,10 @@ relock:
 		if (!signr)
 			break; /* will return 0 */
 
-		if ((current->ptrace & PT_PTRACED) && signr != SIGKILL) {
-			ptrace_signal_deliver(regs, cookie);
-
-			/* Let the debugger run.  */
-			ptrace_stop(signr, 0, info);
-
-			/* We're back.  Did the debugger cancel the sig?  */
-			signr = current->exit_code;
-			if (signr == 0)
-				continue;
-
-			current->exit_code = 0;
-
-			/* Update the siginfo structure if the signal has
-			   changed.  If the debugger wanted something
-			   specific in the siginfo structure then it should
-			   have updated *info via PTRACE_SETSIGINFO.  */
-			if (signr != info->si_signo) {
-				info->si_signo = signr;
-				info->si_errno = 0;
-				info->si_code = SI_USER;
-				info->si_pid = task_pid_vnr(current->parent);
-				info->si_uid = current->parent->uid;
-			}
-
-			/* If the (new) signal is now blocked, requeue it.  */
-			if (sigismember(&current->blocked, signr)) {
-				specific_send_sig_info(signr, info, current);
+		if (signr != SIGKILL) {
+			signr = ptrace_signal(signr, info, regs, cookie);
+			if (!signr)
 				continue;
-			}
 		}
 
 		ka = &current->sighand->action[signr-1];
