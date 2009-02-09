Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZBIDe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZBIDe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 22:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZBIDeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 22:34:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZBIDeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 22:34:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Kaz Kylheku <kkylheku@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
In-Reply-To: Oleg Nesterov's message of  Friday, 6 February 2009 00:22:23 +0100 <20090205232223.GB10345@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	<20090201174159.4a52e15c.akpm@linux-foundation.org>
	<20090202064509.GA20237@redhat.com>
	<3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	<20090202165606.GA13346@redhat.com>
	<20090205030553.49650FC381@magilla.sf.frob.com>
	<3f43f78b0902042055p37ff9ab2u84840273b34c7373@mail.gmail.com>
	<20090205161544.GA24799@redhat.com>
	<20090205212234.934D1FC381@magilla.sf.frob.com>
	<20090205232223.GB10345@redhat.com>
Emacs: no job too big... no job.
Message-Id: <20090209033335.5DE77FC330@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 19:33:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know about other problems with the zombie leaders.

Ok, then we can just concentrate on the test case I posted.

> Except, I am worried whether the fix I have in mind is correct ;)
> It is simple, wait_task_stopped() should do

I think the first problem is we'll never even get into wait_task_stopped().
We'll be in wait_consider_task() on the group leader, which is EXIT_ZOMBIE.
First we need to adjust this:

	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
		return wait_task_zombie(p, options, infop, stat_addr, ru);

to maybe:

	if (p->exit_state == EXIT_ZOMBIE) {
		if (delay_group_leader(p))
			return wait_task_zombie_leader(p, options,
						       infop, stat_addr, ru);
		return wait_task_zombie(p, options, infop, stat_addr, ru);
	}

In wait_task_zombie_leader(), it will have to take the siglock and try to
figure out if there is a completed group stop to report.

> 	if we tracer:
> 
> 		check ->state, eat ->exit_code

Being the ptracer does not affect the delay_group_leader logic.
It just affects individual vs group stop reports.  So the existing
code path is right for ptrace.

> 	else:
> 		check SIGNAL_STOP_STOPPED, use ->group_exit_code

We don't want wait to change group_exit_code.  But we need the "reported as
stopped" tracking that wait_task_stopped() gets by clearing exit_code.  So
I think what we need is to get the zombie group_leader->exit_code to be set
to ->group_exit_code as it would have been if the leader were alive and had
participated in the group stop.

> This looks logical, and should fix the problem. But this is
> the user-visible change. For example,
> 
> 	$ sleep 100
> 	^Z
> 	[1]+  Stopped                 sleep 100
> 	$ strace -p `pidof sleep`
> 	Process 11442 attached - interrupt to quit
> 
> strace hangs in do_wait(). But after the fix strace will happily
> proceed. I can't know whether this behaviour change is bad or not.

I think this would only happen if the "reported as stopped" bookkeeping I
mentioned above were broken.  The "Stopped" line means that the shell just
did do_wait(WUNTRACED), so wait_task_stopped() cleared ->exit_code when
reporting it as stopped.  Now strace does PTRACE_ATTACH and then a wait;
it can't see a fresh wait result here because ->exit_code is still zero.

100% untested concept patch follows.


Thanks,
Roland

==========
diff --git a/kernel/exit.c b/kernel/exit.c
index f80dec3..0000000 100644  
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1437,7 +1437,8 @@ static int wait_task_stopped(int ptrace,
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
-	if (unlikely(!task_is_stopped_or_traced(p)))
+	if (unlikely(!task_is_stopped_or_traced(p)) &&
+	    (ptrace || p->exit_state != EXIT_ZOMBIE || !delay_group_leader(p)))
 		goto unlock_sig;
 
 	if (!ptrace && p->signal->group_stop_count > 0)
@@ -1598,9 +1599,20 @@ static int wait_consider_task(struct tas
 
 	/*
 	 * We don't reap group leaders with subthreads.
+	 * When the group leader is dead, it still serves as
+	 * a moniker for the whole group for stop and continue.
+	 * But for ptrace, stop and continue are reported per-thread.
 	 */
-	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
-		return wait_task_zombie(p, options, infop, stat_addr, ru);
+	if (p->exit_state == EXIT_ZOMBIE) {
+		if (!delay_group_leader(p))
+			return wait_task_zombie(p, options,
+						infop, stat_addr, ru);
+		*notask_error = 0;
+		if (unlikely(ptrace))
+			return 0;
+		return wait_task_stopped(p, options, infop, stat_addr, ru) ?:
+			wait_task_continued(p, options, infop, stat_addr, ru);
+	}
 
 	/*
 	 * It's stopped or running now, so it might
diff --git a/kernel/signal.c b/kernel/signal.c
index b6b3676..0000000 100644  
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1653,6 +1653,27 @@ finish_stop(int stop_count)
 }
 
 /*
+ * Complete group stop bookkeeping after decrementing sig->group_stop_count,
+ * to new value stop_count.  When it reaches zero, mark the process stopped.
+ *
+ * If the group leader is already dead, then it did not participate
+ * normally in the group stop.  But its ->exit_code stands for the whole
+ * group in do_wait() bookkeeping, so we need it to reflect the stop.
+ */
+static inline void complete_group_stop(struct task_struct *tsk,
+				       struct signal_struct *sig,
+				       int stop_count)
+{
+	if (stop_count)
+		return;
+
+	sig->flags = SIGNAL_STOP_STOPPED;
+
+	if (tsk->group_leader->exit_state)
+		tsk->group_leader->exit_code = sig->group_exit_code;
+}
+
+/*
  * This performs the stopping for SIGSTOP and other stop signals.
  * We have to stop all threads in the thread group.
  * Returns nonzero if we've actually stopped and released the siglock.
@@ -1696,8 +1717,7 @@ static int do_signal_stop(int signr)
 		sig->group_stop_count = stop_count;
 	}
 
-	if (stop_count == 0)
-		sig->flags = SIGNAL_STOP_STOPPED;
+	complete_group_stop(current, sig, stop_count);
 	current->exit_code = sig->group_exit_code;
 	__set_current_state(TASK_STOPPED);
 
@@ -1933,9 +1953,8 @@ void exit_signals(struct task_struct *ts
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
 			recalc_sigpending_and_wake(t);
 
-	if (unlikely(tsk->signal->group_stop_count) &&
-			!--tsk->signal->group_stop_count) {
-		tsk->signal->flags = SIGNAL_STOP_STOPPED;
+	if (unlikely(tsk->signal->group_stop_count)) {
+		complete_group_stop(tsk, sig, --tsk->signal->group_stop_count);
 		group_stop = 1;
 	}
 out:
