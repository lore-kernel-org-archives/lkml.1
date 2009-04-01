Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbZDAMhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbZDAMhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbZDAMgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:36:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60630 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbZDAMgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:36:48 -0400
Date: Wed, 1 Apr 2009 14:36:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, roland@redhat.com, oleg@redhat.com
Subject: Re: + signals-tracehook_notify_jctl-change.patch added to -mm tree
Message-ID: <20090401123634.GI12966@elte.hu>
References: <200903302218.n2UMIvEb004737@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903302218.n2UMIvEb004737@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> Subject: signals: tracehook_notify_jctl change
> From: Roland McGrath <roland@redhat.com>
> 
> This changes tracehook_notify_jctl() so it's called with the siglock held,
> and changes its argument and return value definition.  These clean-ups
> make it a better fit for what new tracing hooks need to check.
> 
> Tracing needs the siglock here, held from the time TASK_STOPPED was set,
> to avoid potential SIGCONT races if it wants to allow any blocking in its
> tracing hooks.
> 
> This also folds the finish_stop() function into its caller
> do_signal_stop().  The function is short, called only once and only
> unconditionally.  It aids readability to fold it in.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Roland: as i have asked you before, i'd like to see explicit Ack's 
from Oleg for all ptrace patches you submit.

For example with the patch above you've brushed aside the concerns 
pointed out by Oleg - full discussion thread attached below. Does 
Oleg accept your incomplete patch? Does he ack this approach? It 
might be so but there is no trace of that in the patch and there 
should be - we use Acked-by for good reasons.

Andrew: if you start applying these patches to -mm then please make 
sure you follow and are aware of the full discussion context and 
dont queue up incomplete patches.

Thanks,

	Ingo


----- Forwarded message from Oleg Nesterov <oleg@redhat.com> -----

Date: Wed, 18 Mar 2009 19:15:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Subject: [PATCH] simplify do_signal_stop() && utrace_report_jctl()
	interaction
Cc: utrace-devel@redhat.com

On 03/18, Roland McGrath wrote:
>
> It's OK to change the tracehook definition.  I did this on the new git
> branch tracehook, then utrace branch commit 7b0be6e4 merges that and uses it.

Roland, I think it better to change tracehook definition more, please
see below.

> This drops all the JCTL bit kludgery and utrace_report_jctl just backs out
> of TASK_STOPPED before dropping the siglock in the first place.  I think
> the bookkeeping covers all the angles, but please check it in the new code.

Heh. I was thinking about the very similar change. But I have problems
with tracehook_notify_jctl().

Please find the patch below, on top of your changes. At the cost of
one additional ->group_stop_count != 0 in do_signal_stop(), we can
avoid playing with state/group_stop_count/flags twice.

But, with or without this patch we have a small problem: we can wrongly
send SIGCHLD twice. I'll write a separate email.

> Also please verify if you think all ->stopped bookkeeping is bulletproof
> now.  I fiddled utrace_get_signal() a little because I wasn't quite sure
> that all possibly paths there after TASK_STOPPED were resetting it.

Will do. I didn't study the signal part of utrace yet.

> I want to post it
> to LKML in the next day or two so it has aired before the 2.6.30 merge
> window.

Yes! I think it should be posted really soon.

BTW. exit_signals() calls tracehook_notify_jctl(why => CLD_STOPPED),
could you confirm this is right?

-------------------------------------------------------------------------
[PATCH] simplify do_signal_stop() && utrace_report_jctl() interaction

do_signal_stop() can call utrace_report_jctl() before decrementing
->group_stop_count and setting TASK_STOPPED/SIGNAL_STOP_STOPPED.
This allow to greatly simplify utrace_report_jctl() and avoid playing
with group-stop bookkeeping twice.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 signal.c |   29 +++++++++++------------------
 utrace.c |   20 --------------------
 2 files changed, 11 insertions(+), 38 deletions(-)

--- xxx/kernel/signal.c~JCTL_SIMPLIFY	2009-03-18 14:50:06.000000000 +0100
+++ xxx/kernel/signal.c	2009-03-18 18:20:35.000000000 +0100
@@ -1638,16 +1638,9 @@ void ptrace_notify(int exit_code)
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
@@ -1659,7 +1652,7 @@ static int do_signal_stop(int signr)
 		 */
 		sig->group_exit_code = signr;
 
-		stop_count = 0;
+		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current; t = next_thread(t))
 			/*
 			 * Setting state to TASK_STOPPED for a group
@@ -1668,25 +1661,25 @@ static int do_signal_stop(int signr)
 			 */
 			if (!(t->flags & PF_EXITING) &&
 			    !task_is_stopped_or_traced(t)) {
-				stop_count++;
+				sig->group_stop_count++;
 				signal_wake_up(t, 0);
 			}
-		sig->group_stop_count = stop_count;
 	}
 
-	if (stop_count == 0)
-		sig->flags = SIGNAL_STOP_STOPPED;
-	current->exit_code = sig->group_exit_code;
-	__set_current_state(TASK_STOPPED);
-
 	/*
 	 * If there are no other threads in the group, or if there is
 	 * a group stop in progress and we are the last to stop,
 	 * report to the parent.  When ptraced, every thread reports itself.
 	 */
-	notify = tracehook_notify_jctl(stop_count == 0 ? CLD_STOPPED : 0,
-				       CLD_STOPPED);
+	notify = sig->group_stop_count == 1 ? CLD_STOPPED : 0;
+	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
 
+	if (sig->group_stop_count) {
+		if (!--sig->group_stop_count)
+			sig->flags = SIGNAL_STOP_STOPPED;
+		current->exit_code = sig->group_exit_code;
+		__set_current_state(TASK_STOPPED);
+	}
 	spin_unlock_irq(&current->sighand->siglock);
 
 	if (notify) {
--- xxx/kernel/utrace.c~JCTL_SIMPLIFY	2009-03-18 14:50:06.000000000 +0100
+++ xxx/kernel/utrace.c	2009-03-18 18:23:01.000000000 +0100
@@ -1618,18 +1618,7 @@ void utrace_report_jctl(int notify, int 
 	struct task_struct *task = current;
 	struct utrace *utrace = task_utrace_struct(task);
 	INIT_REPORT(report);
-	bool stop = task_is_stopped(task);
 
-	/*
-	 * We have to come out of TASK_STOPPED in case the event report
-	 * hooks might block.  Since we held the siglock throughout, it's
-	 * as if we were never in TASK_STOPPED yet at all.
-	 */
-	if (stop) {
-		__set_current_state(TASK_RUNNING);
-		task->signal->flags &= ~SIGNAL_STOP_STOPPED;
-		++task->signal->group_stop_count;
-	}
 	spin_unlock_irq(&task->sighand->siglock);
 
 	/*
@@ -1654,16 +1643,7 @@ void utrace_report_jctl(int notify, int 
 	REPORT(task, utrace, &report, UTRACE_EVENT(JCTL),
 	       report_jctl, what, notify);
 
-	/*
-	 * Retake the lock, and go back into TASK_STOPPED
-	 * unless the stop was just cleared.
-	 */
 	spin_lock_irq(&task->sighand->siglock);
-	if (stop && task->signal->group_stop_count > 0) {
-		__set_current_state(TASK_STOPPED);
-		if (--task->signal->group_stop_count == 0)
-			task->signal->flags |= SIGNAL_STOP_STOPPED;
-	}
 }
 
 /*

----- End forwarded message -----

----- Forwarded message from Oleg Nesterov <oleg@redhat.com> -----

Date: Wed, 18 Mar 2009 20:49:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Subject: PATCH? tracehook_notify_jctl && SIGCONT
Cc: utrace-devel@redhat.com

On 03/18, Oleg Nesterov wrote:
>
> On 03/18, Roland McGrath wrote:
> >
> > It's OK to change the tracehook definition.  I did this on the new git
> > branch tracehook, then utrace branch commit 7b0be6e4 merges that and uses it.
>
> Roland, I think it better to change tracehook definition more, please
> see below.

The problem is that, since utrace_report_jctl() drops ->siglock,
tracehook_notify_jctl() can return false positive. This is easy
to fix, but then we have to check PT_PTRACED twice, not good.

Suppose we have 2 threads, T1 and T2, T1 has JCTL in ->utrace_flags.

T2 dequeues SIGSTOP, calls do_signal_stop(), and sleeps in TASK_STOPPED.

T1 calls do_signal_stop(). ->group_stop_count == 1, so it does
notify = tracehook_notify_jctl(notify => CLD_STOPPED), this means
that notify always becomes CLD_STOPPED.

When tracehook_notify_jctl()->utrace_notify_jctl() drops siglock,
SIGCONT comes, notices ->group_stop_count != 0, and adds SIGNAL_CLD_STOPPED
to signal flags.

Now we send SIGCHLD with si_code = CLD_STOPPED twice. By T1 from
do_signal_stop(), and by T1 or T2 from get_signal_to_deliver() which
checks SIGNAL_CLD_MASK.

I'd suggest something like the patch below. At least for now.

Oleg.

--- xxx/include/linux/tracehook.h~JCTL_NOTIFY	2009-03-18 14:50:05.000000000 +0100
+++ xxx/include/linux/tracehook.h	2009-03-18 20:18:54.000000000 +0100
@@ -520,11 +520,10 @@ static inline int tracehook_get_signal(s
  *
  * Called with the siglock held.
  */
-static inline int tracehook_notify_jctl(int notify, int why)
+static inline void tracehook_notify_jctl(int notify, int why)
 {
 	if (task_utrace_flags(current) & UTRACE_EVENT(JCTL))
 		utrace_report_jctl(notify, why);
-	return notify ?: (current->ptrace & PT_PTRACED) ? why : 0;
 }
 
 #define DEATH_REAP			-1
--- xxx/kernel/signal.c~JCTL_NOTIFY	2009-03-18 18:20:35.000000000 +0100
+++ xxx/kernel/signal.c	2009-03-18 20:28:39.000000000 +0100
@@ -1671,18 +1671,21 @@ static int do_signal_stop(int signr)
 	 * a group stop in progress and we are the last to stop,
 	 * report to the parent.  When ptraced, every thread reports itself.
 	 */
-	notify = sig->group_stop_count == 1 ? CLD_STOPPED : 0;
-	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
+	tracehook_notify_jctl(sig->group_stop_count == 1 ? CLD_STOPPED : 0,
+				CLD_STOPPED);
 
+	notify = 0;
 	if (sig->group_stop_count) {
-		if (!--sig->group_stop_count)
+		if (!--sig->group_stop_count) {
 			sig->flags = SIGNAL_STOP_STOPPED;
+			notify = 1;
+		}
 		current->exit_code = sig->group_exit_code;
 		__set_current_state(TASK_STOPPED);
 	}
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (notify) {
+	if (notify || (current->ptrace & PT_PTRACED)) {
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current, notify);
 		read_unlock(&tasklist_lock);
@@ -1765,14 +1768,12 @@ relock:
 				? CLD_CONTINUED : CLD_STOPPED;
 		signal->flags &= ~SIGNAL_CLD_MASK;
 
-		why = tracehook_notify_jctl(why, CLD_CONTINUED);
+		tracehook_notify_jctl(why, CLD_CONTINUED);
 		spin_unlock_irq(&sighand->siglock);
 
-		if (why) {
-			read_lock(&tasklist_lock);
-			do_notify_parent_cldstop(current->group_leader, why);
-			read_unlock(&tasklist_lock);
-		}
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(current->group_leader, why);
+		read_unlock(&tasklist_lock);
 		goto relock;
 	}
 
@@ -1930,7 +1931,8 @@ void exit_signals(struct task_struct *ts
 	if (unlikely(tsk->signal->group_stop_count) &&
 			!--tsk->signal->group_stop_count) {
 		tsk->signal->flags = SIGNAL_STOP_STOPPED;
-		group_stop = tracehook_notify_jctl(CLD_STOPPED, CLD_STOPPED);
+		tracehook_notify_jctl(CLD_STOPPED, CLD_STOPPED);
+		group_stop = 1;
 	}
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);

----- End forwarded message -----

----- Forwarded message from Roland McGrath <roland@redhat.com> -----

Date: Thu, 19 Mar 2009 00:47:50 -0700 (PDT)
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: PATCH? tracehook_notify_jctl && SIGCONT
Cc: utrace-devel@redhat.com

> Now we send SIGCHLD with si_code = CLD_STOPPED twice. By T1 from
> do_signal_stop(), and by T1 or T2 from get_signal_to_deliver() which
> checks SIGNAL_CLD_MASK.

Yes, I considered this problem.  It's just not so big a deal as to worry
overmuch about this corner case in the first version.  What seems to me
will be the obvious and straightforward way to address it is to give
utrace_report_jctl() a return value that tracehook_notify_jctl() uses.
Then we can omit a notification that has been superceded.

Your patch does not seem very straightforward to me.  Moreover, you moved
some ptrace magic out of the tracehook function back into core signals code.
That is going in the wrong direction and we won't have any of that.


Thanks,
Roland

----- End forwarded message -----

----- Forwarded message from Roland McGrath <roland@redhat.com> -----

Date: Thu, 19 Mar 2009 00:43:16 -0700 (PDT)
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] simplify do_signal_stop() && utrace_report_jctl()
	interaction
Cc: utrace-devel@redhat.com

> Roland, I think it better to change tracehook definition more, please
> see below.

I don't really object to this in principle.  But this touches signal.c a
lot more in less obviously-trivial ways than my tracehook patch.  That is
more of an issue at the outset than some extra fiddling in the utrace code.
I think we should consider this for a later clean-up after merging.

> BTW. exit_signals() calls tracehook_notify_jctl(why => CLD_STOPPED),
> could you confirm this is right?

Yes, it's right.  I considered passing CLD_EXITED here to distinguish this
odd case, but that would make the vanilla tracehook_notify_jctl()
definition less simple.  Instead, we put the onus on a ->report_jctl hook
to check for PF_EXITING to tell if it's really going to stop.


Thanks,
Roland

----- End forwarded message -----
