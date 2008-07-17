Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYGQHd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYGQHd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbYGQHav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759694AbYGQHau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 15/23] tracehook: job control
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Windows: ignorance is our most important resource.
Message-Id: <20080717073041.A3E6815411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:30:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines the tracehook_notify_jctl() hook to formalize
the ptrace effects on the job control notifications.
There is no change, only cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   20 ++++++++++++++++++++
 kernel/signal.c           |   10 +++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 42a0d7b..6dc428d 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -451,4 +451,24 @@ static inline int tracehook_get_signal(struct task_struct *task,
 	return 0;
 }
 
+/**
+ * tracehook_notify_jctl - report about job control stop/continue
+ * @notify:		nonzero if this is the last thread in the group to stop
+ * @why:		%CLD_STOPPED or %CLD_CONTINUED
+ *
+ * This is called when we might call do_notify_parent_cldstop().
+ * It's called when about to stop for job control; we are already in
+ * %TASK_STOPPED state, about to call schedule().  It's also called when
+ * a delayed %CLD_STOPPED or %CLD_CONTINUED report is ready to be made.
+ *
+ * Return nonzero to generate a %SIGCHLD with @why, which is
+ * normal if @notify is nonzero.
+ *
+ * Called with no locks held.
+ */
+static inline int tracehook_notify_jctl(int notify, int why)
+{
+	return notify || (current->ptrace & PT_PTRACED);
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/signal.c b/kernel/signal.c
index 1766c47..9b8d94a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -605,9 +605,6 @@ static int check_kill_permission(int sig, struct siginfo *info,
 	return security_task_kill(t, info, sig, 0);
 }
 
-/* forward decl */
-static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
-
 /*
  * Handle magic process-wide effects of stop/continue signals. Unlike
  * the signal actions, these happen immediately at signal-generation
@@ -1629,7 +1626,7 @@ finish_stop(int stop_count)
 	 * a group stop in progress and we are the last to stop,
 	 * report to the parent.  When ptraced, every thread reports itself.
 	 */
-	if (stop_count == 0 || (current->ptrace & PT_PTRACED)) {
+	if (tracehook_notify_jctl(stop_count == 0, CLD_STOPPED)) {
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current, CLD_STOPPED);
 		read_unlock(&tasklist_lock);
@@ -1766,6 +1763,9 @@ relock:
 		signal->flags &= ~SIGNAL_CLD_MASK;
 		spin_unlock_irq(&sighand->siglock);
 
+		if (unlikely(!tracehook_notify_jctl(1, why)))
+			goto relock;
+
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current->group_leader, why);
 		read_unlock(&tasklist_lock);
@@ -1931,7 +1931,7 @@ void exit_signals(struct task_struct *tsk)
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-	if (unlikely(group_stop)) {
+	if (unlikely(group_stop) && tracehook_notify_jctl(1, CLD_STOPPED)) {
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(tsk, CLD_STOPPED);
 		read_unlock(&tasklist_lock);
