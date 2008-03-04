Return-Path: <linux-kernel-owner+w=401wt.eu-S1764190AbYCDM1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbYCDM1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYCDM1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:27:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbYCDM1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:27:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] orphaned pgrp fixes
In-Reply-To: Oleg Nesterov's message of  Sunday, 2 March 2008 21:44:30 +0300 <20080302184430.GA16362@tv-sign.ru>
References: <20080302184430.GA16362@tv-sign.ru>
X-Fcc: ~/Mail/linus
X-Zippy-Says: Am I SHOPLIFTING?
Message-Id: <20080304122654.7313227010A@magilla.localdomain>
Date: Tue,  4 Mar 2008 04:26:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This code is absolutely, completely broken. I guess this is because it
> wasn't updated when linux got threads.
> 
> I don't really understand this magic, and I don't know who maintains it
> Please review.

Noone has ever been officially designated as maintainer for this stuff.
Several people have always wanted to keep their fingers in this core code.

I understand what the job control semantics are supposed to be, if that's
the magic you mean.  The implementation of this particular part is from
before my time and I won't claim at the outset to know why it's the way it
is.  I began working on the thread (NPTL) semantics in the kernel after
pieces of the implementation had been around for a while.  I fixed various
things I knew were wrong, and things I came across.  But I didn't scour all
the corners of the existing code for related problems.  (The prevailing
tendencies now are rather more receptive to perturbations of the existing
code and substantial cleanups than they were at that time.)

I wonder if at one time the pid/pgrp hashing magic entrained each thread on
a pgrp-members list, and so that code did work.  (I think it must have,
since I do recall that various signals changes I made long ago had to do
with a wide variety of MT cases and ^Z.)

These patches all look like steps in the right direction.

About is_global_init, this is mechanically changed from an old ->pid == 1
check that was there from the dawn of time.  Not since shortly thereafter
has anyone thought about what it's really for.  So let's figure it out now.
The basic rule for an orphaned pgrp is that every member's parent is either
also a member of the pgrp or is not in the same session.  In a normal
system, no other processes are actually in init's session at all.  So if
init's your parent, your parent isn't in the same session.  That makes it
redundant to exclude init, since it never qualifies as a potential
"controller" (not having a controller is what makes a pgrp an orphan).
There are lots of special magical corners checking for init and pid 1, but
AFAIK the fact that noone is in init's session is just because init calls
setsid whenever it forks.  So imagine you were in init's session (SID 1).
The idea is you shouldn't stop (and should get SIGHUP's) when your original
controller died and you got reparented to init.  So the intent for this
check is that no process be considered to be in the same session as init.

What seems most pedantically right for this check is:
		is_my_init(p, p->real_parent)
i.e.
		if (task_session(p->real_parent) == task_session(p) &&
		    task_pgrp(p->real_parent) != pgrp &&
		    task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) != 1)
			return 0;
It's excluded from counting as in your session if you consider to to be init.


Now let's consider the other problems you've cited.  This is used in two
paths: the exit path (kill_orphaned_pgrp), and is_current_pgrp_orphaned.

The is_current_pgrp_orphaned path is called in two places.  The tty layer
calls it to decide whether to suppress generating a stop signal.  The
signals code calls it after dequeuing a stop signal to decide whether to
discard it rather than stop.  In races, these paths can stand a false
negative from this check given some specific ordering constraints.  

When we get as far as dequeuing a stop signal, this means
kill_orphaned_pgrp hasn't sent SIGCONT yet.  We know since posting a
SIGCONT would have cleared all stop signals from the queues.  When we
release the siglock to call is_current_pgrp_orphaned, no SIGCONT has come
yet, and SIGNAL_STOP_DEQUEUED is set in signal_struct.flags.  If that
orphaned check said negative, we retake the siglock to do the stop.  If a
SIGCONT came along, it cleared SIGNAL_STOP_DEQUEUED and so we don't stop.
If we do stop, then the SIGCONT is coming later and will wake us.  So here
we can stand any false negative from is_current_pgrp_orphaned.

It's ok in the tty syscalls to post the signal and return -ERESTARTSYS
while the pgrp becomes orphaned.  If the tty code's kill_pgrp comes before
the SIGHUP+SIGCONT, then the SIGCONT generation will clear the pending stop
signal as if it never happened.  The syscall will restart and then the
orphaned-pgrp check will fire.  If the kill_pgrp comes after the
SIGHUP+SIGCONT, then the stop signal generation will clear that pending
SIGCONT.  Ideally we would not permit this ordering, and by the letter of
POSIX it would seem to require that e.g. a SIGCONT handler run as well as
the SIGHUP handler in a just-orphaned process that catches both (and
doesn't exit before seeing all signals).  But in practical terms it doesn't
hurt because that missed SIGCONT handler is the only problem.  When we
dequeue that stop signal, since it's after that SIGHUP+SIGCONT it's by
definition after when is_current_pgrp_orphaned starts reporting positive,
and so we won't stop.

In the main exit_notify path, we are considering whether our own
departure from the pgrp caused it to become an orphan.  In this call,
our group_leader is excluded from consideration, so there is no
concern about any thread in our own group contributing to a false
negative in will_become_orphaned_pgrp.  The write lock on
tasklist_lock strictly serializes all exiting process's calls from
exit_notify.  This call is after group_dead hits.  If some other
process in the pgrp has ->signal->live > 0 then it has not exited yet
and when it does it will do this same check, guaranteed to be after
ours, and after our ->signal->live == 0.  Since it's after our own
group_dead hit, the "ignored_task" check for our own group leader is
redundant with that.  So perhaps it's:

	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
		if (task_session(p->real_parent) == task_session(p) &&
		    task_pgrp(p->real_parent) != pgrp &&
 		    atomic_read(&p->signal->live) > 0 &&
		    task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) != 1)
			return 0;
	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);

In the reparent_thread path, we are considering for one of our children
whether our death caused the child's pgrp (not ours) to become an orphan.
The same logic above applies about the ordering given the signal->live check.

Importantly all that happens with tasklist_lock write-locked.  This orders
any is_current_pgrp_orphaned strictly either before it--so the SIGCONT
will come after the stop and wake it, or after it--so it too will consider
the pgrp orphaned and never try to stop.

Please check me, but I think this covers any race issues in
will_become_orphaned_pgrp.

Now, about has_stopped_jobs.  It's a waste for it to be a separate loop
across the pgrp just after we did one in will_become_orphaned_pgrp.  They
should be merged together.

static int check_orphaned_pgrp(struct pid *pgrp, int ignore_stopped)
{
	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
		if (task_session(p->real_parent) == task_session(p) &&
		    task_pgrp(p->real_parent) != pgrp &&
 		    atomic_read(&p->signal->live) > 0 &&
		    task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) != 1)
			return 0;
		if (!ignore_stopped)
			ignore_stopped = group_is_really_stopped(p);
	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
	return ignore_stopped;
}

The ordering that matters is that if we decided the pgrp was orphaned and
had no stopped jobs, then no process in the pgrp should stop later.

I'm not sure there is a way to make the stopped check robust without
taking the siglock.  Then the only hole I see is between releasing the
tasklist_lock in is_current_pgrp_orphaned and reacquiring the siglock
(after a negative check).  In that interval, we want to consider that
process to be a "stopped job" (because it shortly will be).  For that:

static int group_is_really_stopped(struct task_struct *p)
{
	int ret = 0;
	spin_lock(&p->sighand->siglock);
	ret = (p->signal->flags & (SIGNAL_STOP_STOPPING|SIGNAL_STOP_STOPPED)) ||
		p->signal->group_stop_count > 0;
	spin_unlock(&p->sighand->siglock);
	return ret;
}

along with:

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1802,6 +1802,7 @@ int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 
 relock:
 	spin_lock_irq(&current->sighand->siglock);
+	current->signal->flags &= ~SIGNAL_STOP_STOPPING;
 	for (;;) {
 		struct k_sigaction *ka;
 
@@ -1883,6 +1884,7 @@ relock:
 			 * We need to check for that and bail out if necessary.
 			 */
 			if (signr != SIGSTOP) {
+				current->signal->flags |= SIGNAL_STOP_STOPPING;
 				spin_unlock_irq(&current->sighand->siglock);
 
 				/* signals can be posted during this window */
@@ -1891,6 +1893,7 @@ relock:
 					goto relock;
 
 				spin_lock_irq(&current->sighand->siglock);
+				current->signal->flags &= ~SIGNAL_STOP_STOPPING;
 			}
 
 			if (likely(do_signal_stop(signr))) {


What do you think?


Thanks,
Roland
