Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYLUAyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYLUAyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYLUAyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:54:09 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37143 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbYLUAyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:54:06 -0500
Date: Sat, 20 Dec 2008 16:52:49 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 1/6][v3] Remove 'handler' parameter to tracehook
	functions
Message-ID: <20081221005249.GA5025@us.ibm.com>
References: <20081221005106.GA4912@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221005106.GA4912@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 19 Dec 2008 13:33:46 -0800
Subject:[RFC][PATCH 1/6][v3] Remove 'handler' parameter to tracehook functions

Based on an earlier patch submitted by Oleg Nesterov and comments
from Roland McGrath (http://lkml.org/lkml/2008/11/19/258).

The handler parameter is currently unused in the tracehook functions.
Besides, the tracehook functions are called with siglock held, so the
functions can check the handler if they later need to.

Removing the parameter simiplifies changes to sig_ignored() in a follow-on
patch.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/x86/kernel/ptrace.c  |    2 +-
 include/linux/tracehook.h |   13 ++++---------
 kernel/signal.c           |    6 +++---
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0a6d8c1..d6ef716 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1585,6 +1585,6 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 	 * system call instruction.
 	 */
 	if (test_thread_flag(TIF_SINGLESTEP) &&
-	    tracehook_consider_fatal_signal(current, SIGTRAP, SIG_DFL))
+	    tracehook_consider_fatal_signal(current, SIGTRAP))
 		send_sigtrap(current, regs, 0, TRAP_BRKPT);
 }
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6186a78..eb4c654 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -388,17 +388,14 @@ static inline void tracehook_signal_handler(int sig, siginfo_t *info,
  * tracehook_consider_ignored_signal - suppress short-circuit of ignored signal
  * @task:		task receiving the signal
  * @sig:		signal number being sent
- * @handler:		%SIG_IGN or %SIG_DFL
  *
  * Return zero iff tracing doesn't care to examine this ignored signal,
  * so it can short-circuit normal delivery and never even get queued.
- * Either @handler is %SIG_DFL and @sig's default is ignore, or it's %SIG_IGN.
  *
  * Called with @task->sighand->siglock held.
  */
 static inline int tracehook_consider_ignored_signal(struct task_struct *task,
-						    int sig,
-						    void __user *handler)
+						    int sig)
 {
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
@@ -407,19 +404,17 @@ static inline int tracehook_consider_ignored_signal(struct task_struct *task,
  * tracehook_consider_fatal_signal - suppress special handling of fatal signal
  * @task:		task receiving the signal
  * @sig:		signal number being sent
- * @handler:		%SIG_DFL or %SIG_IGN
  *
  * Return nonzero to prevent special handling of this termination signal.
- * Normally @handler is %SIG_DFL.  It can be %SIG_IGN if @sig is ignored,
- * in which case force_sig() is about to reset it to %SIG_DFL.
+ * Normally handler for signal is %SIG_DFL.  It can be %SIG_IGN if @sig is
+ * ignored, in which case force_sig() is about to reset it to %SIG_DFL.
  * When this returns zero, this signal might cause a quick termination
  * that does not give the debugger a chance to intercept the signal.
  *
  * Called with or without @task->sighand->siglock held.
  */
 static inline int tracehook_consider_fatal_signal(struct task_struct *task,
-						  int sig,
-						  void __user *handler)
+						  int sig)
 {
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index 2a64304..7945e71 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -72,7 +72,7 @@ static int sig_ignored(struct task_struct *t, int sig)
 	/*
 	 * Tracers may want to know about even ignored signals.
 	 */
-	return !tracehook_consider_ignored_signal(t, sig, handler);
+	return !tracehook_consider_ignored_signal(t, sig);
 }
 
 /*
@@ -316,7 +316,7 @@ int unhandled_signal(struct task_struct *tsk, int sig)
 		return 1;
 	if (handler != SIG_IGN && handler != SIG_DFL)
 		return 0;
-	return !tracehook_consider_fatal_signal(tsk, sig, handler);
+	return !tracehook_consider_fatal_signal(tsk, sig);
 }
 
 
@@ -775,7 +775,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL ||
-	     !tracehook_consider_fatal_signal(t, sig, SIG_DFL))) {
+	     !tracehook_consider_fatal_signal(t, sig))) {
 		/*
 		 * This signal will be fatal to the whole group.
 		 */
-- 
1.5.2.5

