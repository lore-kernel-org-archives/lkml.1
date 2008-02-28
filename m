Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYB1K1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYB1K1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYB1K1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:27:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbYB1K12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:27:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: Jiri Kosina's message of  Wednesday, 27 February 2008 23:04:38 +0100 <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
	<20080227210038.93AFC2700FD@magilla.localdomain>
	<Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
Emacs: because one operating system isn't enough.
Message-Id: <20080228102649.071572700FD@magilla.localdomain>
Date: Thu, 28 Feb 2008 02:26:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies!  I misread your original message and was looking only at the
do_notify_parent_cldstop before the wakeup (CLD_STOPPED case), and not the
one afterwards (CLD_CONTINUED) that you were referring to.  I do now
understand the problem and see how it can happen as you describe.

I'm not very fond of your patch, though I think its behavior is probably
correct.  I was hoping to find a solution that did not require changes
outside handle_stop_signal, as those additions make the code that much more
intricate and hard to follow.  But I haven't found one yet; an idea like
moving the CLD_CONTINUED notification and its troublesome lock-dropping to
before the wakeups is attractive, but I think it opens another can of worms
not worth the trouble.  Perhaps Oleg can think of something simpler.

I prefer at least to do some cleanup while taking the same essential
approach, and change the control flow only of the part that needs to move
to fix this problem.  What do you think about the patch below?  (I have not
tested this with your test case, nor much testing for other regressions.)


Thanks,
Roland

---
[PATCH] clean up and fix SIGCONT

This reorganizes some of the signals code, replacing handle_stop_signal()
with prepare_signal() and finish_signal(), called as a pair before and
after generating any signal.  The CLD_CONTINUED notification to parent is
moved into finish_signal(), taking place after the signal is made pending
and siglock dropped.  This fixes a race where a process waking from SIGCONT
could resume application code without running its SIGCONT handler first.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |   74 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 84917fe..3a94657 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -555,16 +555,20 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
  * time regardless of blocking, ignoring, or handling.  This does the
  * actual continuing for SIGCONT, but not the actual stopping for stop
  * signals.  The process stop is done as a signal action for SIG_DFL.
+ * Returns nonzero if CLD_CONTINUED notification should be done.
+ * finish_signal() should always be called with our return value
+ * after posting the signal (or failing to do so).
  */
-static void handle_stop_signal(int sig, struct task_struct *p)
+static int prepare_signal(int sig, struct task_struct *p)
 {
 	struct task_struct *t;
+	int cont = 0;
 
 	if (p->signal->flags & SIGNAL_GROUP_EXIT)
 		/*
 		 * The process is in the middle of dying already.
 		 */
-		return;
+		return cont;
 
 	if (sig_kernel_stop(sig)) {
 		/*
@@ -635,11 +639,9 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 			 * We were in fact stopped, and are now continued.
 			 * Notify the parent with CLD_CONTINUED.
 			 */
+			cont = 1;
 			p->signal->flags = SIGNAL_STOP_CONTINUED;
 			p->signal->group_exit_code = 0;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_CONTINUED);
-			spin_lock(&p->sighand->siglock);
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
@@ -655,6 +657,18 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 		 */
 		p->signal->flags = 0;
 	}
+
+	return cont;
+}
+
+/*
+ * This pairs with prepare_signal() and must always be called afterward,
+ * with the siglock already unlocked, but tasklist_lock still held.
+ */
+static void finish_signal(int cont, struct task_struct *p)
+{
+	if (cont)
+		do_notify_parent_cldstop(p, CLD_CONTINUED);
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
@@ -921,13 +935,17 @@ __group_complete_signal(int sig, struct task_struct *p)
 	return;
 }
 
-int
-__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+/*
+ * Internal entry point for sending group-wide signals.
+ * This must always be followed by finish_signal(*continued, p).
+ */
+static int generate_group_signal(int sig, struct siginfo *info,
+				 struct task_struct *p, int *continued)
 {
 	int ret = 0;
 
 	assert_spin_locked(&p->sighand->siglock);
-	handle_stop_signal(sig, p);
+	*continued = prepare_signal(sig, p);
 
 	/* Short-circuit ignored signals.  */
 	if (sig_ignored(p, sig))
@@ -951,6 +969,22 @@ __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 }
 
 /*
+ * This is called by a few places outside this file.
+ */
+int
+__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+{
+	int cont;
+	int ret = generate_group_signal(sig, info, p, &cont);
+	if (unlikely(cont)) {
+		spin_unlock(&p->sighand->siglock);
+		do_notify_parent_cldstop(p, CLD_CONTINUED);
+		spin_lock(&p->sighand->siglock);
+	}
+	return ret;
+}
+
+/*
  * Nuke all other threads in the group.
  */
 void zap_other_threads(struct task_struct *p)
@@ -1009,8 +1043,10 @@ int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 	if (!ret && sig) {
 		ret = -ESRCH;
 		if (lock_task_sighand(p, &flags)) {
-			ret = __group_send_sig_info(sig, info, p);
+			int cont;
+			ret = generate_group_signal(sig, info, p, &cont);
 			unlock_task_sighand(p, &flags);
+			finish_signal(cont, p);
 		}
 	}
 
@@ -1102,10 +1138,12 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 	if (ret)
 		goto out_unlock;
 	if (sig && p->sighand) {
+		int cont;
 		unsigned long flags;
 		spin_lock_irqsave(&p->sighand->siglock, flags);
-		ret = __group_send_sig_info(sig, info, p);
+		ret = generate_group_signal(sig, info, p, &cont);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		finish_signal(cont, p);
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -1351,13 +1389,14 @@ send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
 	unsigned long flags;
 	int ret = 0;
+	int cont;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
 	read_lock(&tasklist_lock);
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
-	handle_stop_signal(sig, p);
+	cont = prepare_signal(sig, p);
 
 	/* Short-circuit ignored signals.  */
 	if (sig_ignored(p, sig)) {
@@ -1392,6 +1431,7 @@ send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 	__group_complete_signal(sig, p);
 out:
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	finish_signal(cont, p);
 	read_unlock(&tasklist_lock);
 	return ret;
 }
@@ -1415,6 +1455,7 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 	struct siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
+	int cont = 0;
 
 	BUG_ON(sig == -1);
 
@@ -1485,9 +1526,10 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 			sig = 0;
 	}
 	if (valid_signal(sig) && sig > 0)
-		__group_send_sig_info(sig, &info, tsk->parent);
+		generate_group_signal(sig, &info, tsk->parent, &cont);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
+	finish_signal(cont, tsk->parent);
 }
 
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
@@ -1496,6 +1538,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
+	int cont = 0;
 
 	if (tsk->ptrace & PT_PTRACED)
 		parent = tsk->parent;
@@ -1538,12 +1581,13 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	spin_lock_irqsave(&sighand->siglock, flags);
 	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
 	    !(sighand->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDSTOP))
-		__group_send_sig_info(SIGCHLD, &info, parent);
+		generate_group_signal(SIGCHLD, &info, parent, &cont);
 	/*
 	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.
 	 */
 	__wake_up_parent(tsk, parent);
 	spin_unlock_irqrestore(&sighand->siglock, flags);
+	finish_signal(cont, parent);
 }
 
 static inline int may_ptrace_stop(void)
@@ -2251,10 +2295,12 @@ static int do_tkill(int tgid, int pid, int sig)
 		 * probe.  No signal is actually delivered.
 		 */
 		if (!error && sig && p->sighand) {
+			int cont;
 			spin_lock_irq(&p->sighand->siglock);
-			handle_stop_signal(sig, p);
+			cont = prepare_signal(sig, p);
 			error = specific_send_sig_info(sig, &info, p);
 			spin_unlock_irq(&p->sighand->siglock);
+			finish_signal(cont, p);
 		}
 	}
 	read_unlock(&tasklist_lock);
