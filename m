Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbZG2Bvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbZG2Bvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZG2Bvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:51:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52821 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZG2Bvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:51:35 -0400
Date: Wed, 29 Jul 2009 03:48:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] do_signal_stop: do not call tracehook_notify_jctl() in
	TASK_STOPPED state
Message-ID: <20090729014822.GA6201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal_stop() can call tracehook_notify_jctl() before decrementing
->group_stop_count and setting TASK_STOPPED/SIGNAL_STOP_STOPPED.

This way the tracing hooks can drop and reacquire the siglock freely
and do any blocking hooks without potential SIGCONT races.

With this patch TASK_STOPPED/SIGNAL_STOP_STOPPED is set only when we
know for sure we are going to schedule() after unlock(siglock).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- __UTRACE/kernel/signal.c~1_DO_SIGNAL_STOP	2009-07-29 03:10:15.000000000 +0200
+++ __UTRACE/kernel/signal.c	2009-07-29 03:17:49.000000000 +0200
@@ -1682,16 +1682,9 @@ void ptrace_notify(int exit_code)
 static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
-	int stop_count;
 	int notify;
 
-	if (sig->group_stop_count > 0) {
-		/*
-		 * There is a group stop in progress.  We don't need to
-		 * start another one.
-		 */
-		stop_count = --sig->group_stop_count;
-	} else {
+	if (!sig->group_stop_count) {
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
@@ -1703,7 +1696,7 @@ static int do_signal_stop(int signr)
 		 */
 		sig->group_exit_code = signr;
 
-		stop_count = 0;
+		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current; t = next_thread(t))
 			/*
 			 * Setting state to TASK_STOPPED for a group
@@ -1712,25 +1705,28 @@ static int do_signal_stop(int signr)
 			 */
 			if (!(t->flags & PF_EXITING) &&
 			    !task_is_stopped_or_traced(t)) {
-				stop_count++;
+				sig->group_stop_count++;
 				signal_wake_up(t, 0);
 			}
-		sig->group_stop_count = stop_count;
 	}
-
-	if (stop_count == 0)
-		sig->flags = SIGNAL_STOP_STOPPED;
-	current->exit_code = sig->group_exit_code;
-	__set_current_state(TASK_STOPPED);
-
 	/*
 	 * If there are no other threads in the group, or if there is
-	 * a group stop in progress and we are the last to stop,
-	 * report to the parent.  When ptraced, every thread reports itself.
+	 * a group stop in progress and we are the last to stop, report
+	 * to the parent.  When ptraced, every thread reports itself.
 	 */
-	notify = tracehook_notify_jctl(stop_count == 0 ? CLD_STOPPED : 0,
-				       CLD_STOPPED);
-
+	notify = sig->group_stop_count == 1 ? CLD_STOPPED : 0;
+	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
+	/*
+	 * tracehook_notify_jctl() can drop and reacquire siglock, so
+	 * we keep ->group_stop_count != 0 before the call. If SIGCONT
+	 * or SIGKILL comes in between ->group_stop_count == 0.
+	 */
+	if (sig->group_stop_count) {
+		if (!--sig->group_stop_count)
+			sig->flags = SIGNAL_STOP_STOPPED;
+		current->exit_code = sig->group_exit_code;
+		__set_current_state(TASK_STOPPED);
+	}
 	spin_unlock_irq(&current->sighand->siglock);
 
 	if (notify) {

