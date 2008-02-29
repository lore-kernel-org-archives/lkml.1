Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYB2Cjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYB2Cjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYB2Cjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:39:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbYB2Cjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:39:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 February 2008 18:30:43 +0300 <20080228153043.GA11484@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
	<20080227210038.93AFC2700FD@magilla.localdomain>
	<Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
	<20080228102649.071572700FD@magilla.localdomain>
	<20080228153043.GA11484@tv-sign.ru>
X-Shopping-List: (1) Mexican Whip mispronunciations
   (2) Disorienting soil auctions
   (3) Incompetent welt scorpions
Message-Id: <20080229023902.D93E12700FD@magilla.localdomain>
Date: Thu, 28 Feb 2008 18:39:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, I think we have the same problem when handle_stop_signal() does
> do_notify_parent_cldstop(p, CLD_STOPPED) above. The multithreaded app
> in the middle of the group stop can resume without actually seeing
> SIGCONT, no?

I don't think I follow the scenario you have in mind there.  When siglock
is dropped there, noone has been woken up yet.  It's just as if the sending
of SIGCONT had not begun yet.

> Currently I have the very vagues idea, please see the "patch" below
> (it is not right of course, just for illustration).

Hmm.  It's an interesting idea.

> These unlock(->siglock)'s on the signal sending path are really nasty,
> it would be wonderfull to avoid them. 

I agree.

> Note also sig_needs_tasklist(), we take tasklist_lock() exactly because
> we will probably drop siglock.

do_notify_parent_cldstop will always need tasklist_lock because of its
parent link.  With my patch below, the signal-posting path should never
drop and reacquire the siglock any more.  So we could just make
do_notify_parent_cldstop take the lock (read_lock nests anyway) and the
signal-posting path callers don't need to take it.

> What do you think about the approach at least?

My first reaction was that it would have the wrong semantics.  The special
effect of SIGCONT to resume the process happens at the time of signal
generation, not at signal delivery.  The CLD_CONTINUED notification to the
parent has to happen when the resumption happens.  If SIGCONT is blocked or
ignored, then the process is woken up but may never dequeue the signal.
However, in fact it will always already been in get_signal_to_deliver by
definition, since that's where stopping happens.  So it will indeed always
come out and see your check before it resumes.  The only difference then is
whether the SIGCHLD gets sent immediately at post time or only when the
resumed child actually gets scheduled.  I don't think that's a problem.

Certainly it should just be a flag or two in signal_struct.flags.  The
extra field is really too ugly.  We need to think carefully about all the
places that clear/reset ->signal->flags, though.  Note that doing two
do_notify_parent_cldstop calls in a two is redundant, since the signals
don't queue and the parent is not often going to respond so quickly that
the second one ever actually posts.  I'd be inclined to just make that an
else if.

> Hmm... Can't we make a simpler patch for the start? See below.
> We can notify the parent earlier, before waking the TASK_STOPPED
> child. This should fix this race, no?

That is exactly what my first impulse was and what I described as opening
another can of worms.  (I almost sent the identical patch yesterday.)  Here
is what I was concerned about.  This does the CLD_CONTINUED SIGCHLD before
any wakeups, so task_struct.state is still TASK_STOPPED.  The parent can
see the SIGCHLD, call wait, and see the child still in TASK_STOPPED.  In
wait_task_stopped, a few things can happen.  It might by then have gotten
to the signal-sender's retaking of the siglock and wake_up_state; if so, it
sees p->state no longer TASK_STOPPED and/or p->exit_code no longer nonzero,
and returns 0.  Then the parent's wait goes back to sleep (or reports
nothing for WNOHANG), and it never gets a wakeup corresponding to the
CLD_CONTINUED notification, which it expects in a call using WCONTINUED.
This is why the notification comes after the wakeup.  It might be feasible
to get the right semantics with changes in wait.  But like I said, a new
can of worms.

I don't dislike the direction of your flag-setting approach above.  But
it does introduce more new subtleties that warrant more thought.  Here is
another version of my patch, that also eliminates the lock-drop for the
CLD_STOPPED notification when a group stop is still in progress.  
(Though I still haven't yet grokked how that case introduced any bug.)
What do you think?


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
 kernel/signal.c |  111 ++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 77 insertions(+), 34 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 84917fe..3a74955 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -555,16 +555,20 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
  * time regardless of blocking, ignoring, or handling.  This does the
  * actual continuing for SIGCONT, but not the actual stopping for stop
  * signals.  The process stop is done as a signal action for SIG_DFL.
+ * Returns a (nonzero) CLD_* value if notification should be done.
+ * finish_signal() should always be called with our return value
+ * after posting the signal (or failing to do so).
  */
-static void handle_stop_signal(int sig, struct task_struct *p)
+static int prepare_signal(int sig, struct task_struct *p)
 {
 	struct task_struct *t;
+	int notify = 0;
 
 	if (p->signal->flags & SIGNAL_GROUP_EXIT)
 		/*
 		 * The process is in the middle of dying already.
 		 */
-		return;
+		return notify;
 
 	if (sig_kernel_stop(sig)) {
 		/*
@@ -581,25 +585,6 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 		 * Remove all stop signals from all queues,
 		 * and wake all threads.
 		 */
-		if (unlikely(p->signal->group_stop_count > 0)) {
-			/*
-			 * There was a group stop in progress.  We'll
-			 * pretend it finished before we got here.  We are
-			 * obliged to report it to the parent: if the
-			 * SIGSTOP happened "after" this SIGCONT, then it
-			 * would have cleared this pending SIGCONT.  If it
-			 * happened "before" this SIGCONT, then the parent
-			 * got the SIGCHLD about the stop finishing before
-			 * the continue happened.  We do the notification
-			 * now, and it's as if the stop had finished and
-			 * the SIGCHLD was pending on entry to this kill.
-			 */
-			p->signal->group_stop_count = 0;
-			p->signal->flags = SIGNAL_STOP_CONTINUED;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_STOPPED);
-			spin_lock(&p->sighand->siglock);
-		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
 		do {
@@ -630,16 +615,30 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 			t = next_thread(t);
 		} while (t != p);
 
-		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
+		if ((p->signal->flags & SIGNAL_STOP_STOPPED) ||
+		    p->signal->group_stop_count > 0) {
 			/*
 			 * We were in fact stopped, and are now continued.
 			 * Notify the parent with CLD_CONTINUED.
+			 *
+			 * If we were in the middle of a group stop,
+			 * we treat this as if we had already finished
+			 * stopping.  We are obliged to report that
+			 * stop to the parent: if the SIGSTOP happened
+			 * "after" this SIGCONT, then it would have
+			 * cleared this pending SIGCONT.  But since
+			 * SIGCHLD does not queue, the CLD_STOPPED
+			 * notification would have stayed and the new
+			 * signal with CLD_CONTINUED would have been
+			 * dropped.  So make this notification be
+			 * CLD_CONTINUED if the stop was complete, and
+			 * CLD_STOPPED if it was in progress.
 			 */
+			notify = ((p->signal->flags & SIGNAL_STOP_STOPPED) ?
+				  CLD_CONTINUED : CLD_STOPPED);
 			p->signal->flags = SIGNAL_STOP_CONTINUED;
+			p->signal->group_stop_count = 0;
 			p->signal->group_exit_code = 0;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_CONTINUED);
-			spin_lock(&p->sighand->siglock);
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
@@ -655,6 +654,18 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 		 */
 		p->signal->flags = 0;
 	}
+
+	return notify;
+}
+
+/*
+ * This pairs with prepare_signal() and must always be called afterward,
+ * with the siglock already unlocked, but tasklist_lock still held.
+ */
+static void finish_signal(int notify, struct task_struct *p)
+{
+	if (notify)
+		do_notify_parent_cldstop(p, notify);
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
@@ -921,13 +932,17 @@ __group_complete_signal(int sig, struct task_struct *p)
 	return;
 }
 
-int
-__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+/*
+ * Internal entry point for sending group-wide signals.
+ * This must always be followed by finish_signal(*notify, p).
+ */
+static int generate_group_signal(int sig, struct siginfo *info,
+				 struct task_struct *p, int *notify)
 {
 	int ret = 0;
 
 	assert_spin_locked(&p->sighand->siglock);
-	handle_stop_signal(sig, p);
+	*notify = prepare_signal(sig, p);
 
 	/* Short-circuit ignored signals.  */
 	if (sig_ignored(p, sig))
@@ -951,6 +966,22 @@ __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 }
 
 /*
+ * This is called by a few places outside this file.
+ */
+int
+__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+{
+	int notify;
+	int ret = generate_group_signal(sig, info, p, &notify);
+	if (unlikely(notify)) {
+		spin_unlock(&p->sighand->siglock);
+		do_notify_parent_cldstop(p, notify);
+		spin_lock(&p->sighand->siglock);
+	}
+	return ret;
+}
+
+/*
  * Nuke all other threads in the group.
  */
 void zap_other_threads(struct task_struct *p)
@@ -1009,8 +1040,10 @@ int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 	if (!ret && sig) {
 		ret = -ESRCH;
 		if (lock_task_sighand(p, &flags)) {
-			ret = __group_send_sig_info(sig, info, p);
+			int notify;
+			ret = generate_group_signal(sig, info, p, &notify);
 			unlock_task_sighand(p, &flags);
+			finish_signal(notify, p);
 		}
 	}
 
@@ -1102,10 +1135,12 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 	if (ret)
 		goto out_unlock;
 	if (sig && p->sighand) {
+		int notify;
 		unsigned long flags;
 		spin_lock_irqsave(&p->sighand->siglock, flags);
-		ret = __group_send_sig_info(sig, info, p);
+		ret = generate_group_signal(sig, info, p, &notify);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		finish_signal(notify, p);
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -1351,13 +1386,14 @@ send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 {
 	unsigned long flags;
 	int ret = 0;
+	int notify;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
 	read_lock(&tasklist_lock);
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
-	handle_stop_signal(sig, p);
+	notify = prepare_signal(sig, p);
 
 	/* Short-circuit ignored signals.  */
 	if (sig_ignored(p, sig)) {
@@ -1392,6 +1428,7 @@ send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 	__group_complete_signal(sig, p);
 out:
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	finish_signal(notify, p);
 	read_unlock(&tasklist_lock);
 	return ret;
 }
@@ -1415,6 +1452,7 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 	struct siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
+	int notify = 0;
 
 	BUG_ON(sig == -1);
 
@@ -1485,9 +1523,10 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 			sig = 0;
 	}
 	if (valid_signal(sig) && sig > 0)
-		__group_send_sig_info(sig, &info, tsk->parent);
+		generate_group_signal(sig, &info, tsk->parent, &notify);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
+	finish_signal(notify, tsk->parent);
 }
 
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
@@ -1496,6 +1535,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
+	int notify = 0;
 
 	if (tsk->ptrace & PT_PTRACED)
 		parent = tsk->parent;
@@ -1538,12 +1578,13 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	spin_lock_irqsave(&sighand->siglock, flags);
 	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
 	    !(sighand->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDSTOP))
-		__group_send_sig_info(SIGCHLD, &info, parent);
+		generate_group_signal(SIGCHLD, &info, parent, &notify);
 	/*
 	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.
 	 */
 	__wake_up_parent(tsk, parent);
 	spin_unlock_irqrestore(&sighand->siglock, flags);
+	finish_signal(notify, parent);
 }
 
 static inline int may_ptrace_stop(void)
@@ -2251,10 +2292,12 @@ static int do_tkill(int tgid, int pid, int sig)
 		 * probe.  No signal is actually delivered.
 		 */
 		if (!error && sig && p->sighand) {
+			int notify;
 			spin_lock_irq(&p->sighand->siglock);
-			handle_stop_signal(sig, p);
+			notify = prepare_signal(sig, p);
 			error = specific_send_sig_info(sig, &info, p);
 			spin_unlock_irq(&p->sighand->siglock);
+			finish_signal(notify, p);
 		}
 	}
 	read_unlock(&tasklist_lock);
