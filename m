Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbXKVR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbXKVR4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 12:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXKVR4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 12:56:07 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:50312 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbXKVR4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 12:56:06 -0500
Date: Thu, 22 Nov 2007 20:56:22 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Scott James Remnant <scott@ubuntu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 4/2] ptrace_stop: fix racy nonstop_code setting
Message-ID: <20071122175622.GA7051@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the tracer is gone and we are not going to stop, ptrace_stop() sets
->exit_code = nostop_code. However, the tracer could actually clear the
exit code before detaching. In that case get_signal_to_deliver() "resends"
the signal which was cancelled by the debugger. For example, it is possible
that a quick PTRACE_ATTACH + PTRACE_DETACH can leave the tracee in STOPPED
state.

Change the behaviour of ptrace_stop(). If the caller is ptrace notify(), we
should always clear ->exit_code. If the caller is get_signal_to_deliver(), we
should not touch it at all. To do so, change the nonstop_code parameter to
"bool clear_code" and change the callers accordingly.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/signal.c~4_non_stop	2007-11-22 16:59:35.000000000 +0300
+++ PT/kernel/signal.c	2007-11-22 20:29:11.000000000 +0300
@@ -1601,10 +1601,10 @@ static inline int may_ptrace_stop(void)
  * That makes it a way to test a stopped process for
  * being ptrace-stopped vs being job-control-stopped.
  *
- * If we actually decide not to stop at all because the tracer is gone,
- * we leave nostop_code in current->exit_code.
+ * If we actually decide not to stop at all because the tracer
+ * is gone, we keep current->exit_code unless clear_code.
  */
-static void ptrace_stop(int exit_code, int nostop_code, siginfo_t *info)
+static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 {
 	/*
 	 * If there is a group stop in progress,
@@ -1631,7 +1631,8 @@ static void ptrace_stop(int exit_code, i
 		 * Don't drop the lock yet, another tracer may come.
 		 */
 		__set_current_state(TASK_RUNNING);
-		current->exit_code = nostop_code;
+		if (clear_code)
+			current->exit_code = 0;
 		read_unlock(&tasklist_lock);
 	}
 
@@ -1665,7 +1666,7 @@ void ptrace_notify(int exit_code)
 
 	/* Let the debugger run.  */
 	spin_lock_irq(&current->sighand->siglock);
-	ptrace_stop(exit_code, 0, &info);
+	ptrace_stop(exit_code, 1, &info);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -1813,7 +1814,7 @@ relock:
 			ptrace_signal_deliver(regs, cookie);
 
 			/* Let the debugger run.  */
-			ptrace_stop(signr, signr, info);
+			ptrace_stop(signr, 0, info);
 
 			/* We're back.  Did the debugger cancel the sig?  */
 			signr = current->exit_code;

