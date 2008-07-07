Return-Path: <linux-kernel-owner+w=401wt.eu-S1751028AbYGGE5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028AbYGGE5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 00:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYGGE5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 00:57:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYGGE5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 00:57:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: simplify ptrace_stop()->sigkill_pending() path
In-Reply-To: Oleg Nesterov's message of  Sunday, 6 July 2008 20:02:52 +0400 <20080706160252.GA4123@tv-sign.ru>
References: <20080706160252.GA4123@tv-sign.ru>
X-Zippy-Says: Loni Anderson's hair should be LEGALIZED!!
Message-Id: <20080707045631.112EB154246@magilla.localdomain>
Date: Sun,  6 Jul 2008 21:56:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I haven't replied sooner to your related patches about this recently.

I would rather not futz around the margins with the arch_ptrace_stop_needed
case.  That code path exists only on ia64.  Let's not worry about the
details of its current form.  We can just hash out the whole subject and
this bit will wind up irrelevant or quite different.

To give some perspective, the arch_ptrace_stop_needed path was added
(recently) for ia64 where there was a need to unlock the siglock where it
wasn't unlocked before.  Unlike the pure signals races, this new ia64 case
potentially works/blocks for a relatively long time (doing page faults)
while leaving the siglock unlocked in the path that always before held it
throughout.  The bad situation with a missed SIGKILL actually came up on
ia64 when someone tried adding the unlock+arch_ptrace_stop+lock sequence
without the extra check.  So the "killed" logic was added with a narrow
focus to redress just that case, and keep ia64 no worse than the status quo
of many years.  (The ia64 path can have real blocks, whereas any other
problems on this path have never been possible in uniprocessor no-preempt
kernels, for example.)

When you sent your earlier patches, something I didn't find immediately
clear was the exact list of problem scenarios you were considering.  So,
let's look at the whole picture.

The two paths into ptrace_stop() are ptrace_signal() and ptrace_notify().

In the ptrace_signal() path, the siglock is held throughout.  If someone
comes along later to post a SIGKILL, it will happen after ptrace_stop()
enters TASK_TRACED and signal_wake_up() will do the right thing.  The
problem scenario is when the SIGKILL was already posted before we took the
siglock, but ptrace_signal() gets called on a different signal first, i.e.
one numbered < 9 is dequeued first.

In the ptrace_notify() path, we just took the siglock before ptrace_stop().
There can have been a SIGKILL pending before that, and we'll stop anyway.
The paths into ptrace_notify() are e.g. after fork, exec, or syscall exit,
where there very well may have been a long time for the signal to be posted
since the last time it was checked for.

Now let's look at what we do and don't want, to call things "right".

The prevailing default case should be that we stop.  We want to let the
debugger do its job.  Consider exit tracing (PTRACE_O_TRACEEXIT).  If there
is a normal exit_group syscall, every thread should stop for exit tracing.
If there is a run of the mill signal that causes termination, every thread
should stop for exit tracing.

When there is a real SIGKILL from userland (sys_kill et al actually called
with SIGKILL), then we should never stop.  A real SIGKILL trumps all else.
We must die as quickly as we can, end of story.

When there is a coredump_wait in progress, we should not stop.  This is
something outside the debugger's power to prevent (now that it's started in
another thread) and the core-dump thread will block so it can't be forced
to finish quickly, until we die.

When there is an exec in progress, we should not stop.  This is something
outside the debugger's power to prevent (now that it's started in another
thread) and the thread doing exec will block uninterruptibly until we die.

If you work out all the cases from those "rules", there are several where
we currently make the wrong choice (in one direction or the other), even
without considering races.  The changes from your patch series also don't
get it right in several cases, as I've defined "right" above.

Long ago, I had wanted to introduce a signal_struct.flags bit for SIGKILL
and simplify some of this checking.  I then talked myself back out of
thinking it was required.  Now we have cleaned up the flags handling a lot,
and we have TASK_WAKEKILL.  I'm inclined again to go this route, but now to
take it further.

Let's stop overloading SIGKILL for internal purposes.  At the same time,
let's treat real SIGKILL as special up front with its own bookkeeping.

We can check t->signal->flags in recalc_sigpending_tsk().  Let's replace
"t->signal->group_stop_count > 0" with "signal_group_sigpending(t->signal)".
In there we can stick the logic we come up with.  To start with, it can be
(signal->group_stop_count > 0 || signal_group_exit(signal)).  That lets us
remove the SIGKILL from zap_other_threads(), complete_signal(), and
zap_process().  In get_signal_to_deliver(), first thing in the loop (before
the group_stop_count check), check signal_group_exit() and if set go
directly to do_group_exit() without dequeuing any signal.

Next, we can optimize signal_group_sigpending() by reducing it to a single
flags check.  Add a flag (maybe called SIGNAL_GROUP_INTERRUPT) meaning "all
threads must get into get_signal_to_deliver() ASAP".  Include this bit in
SIGNAL_GROUP_EXIT so it's set every place that sets it.  Also make
de_thread() set this bit when it sets group_exit_task (and clear it after).
Also make do_signal_stop() set it when it sets group_stop_count, and clear
it when it sets SIGNAL_STOP_STOPPED (which existing code would implicitly).

Now, the ptrace issues.  Add a flag SIGNAL_GROUP_KILLED meaning "must exit
ASAP, no waiting".  de_thread() sets this for exec, complete_signal() sets
it for SIGKILL, and coredump_wait() sets it.  de_thread() has to clear the
flag afterwards on success, which could hide that a real SIGKILL came in
the middle.  So add another flag SIGNAL_GROUP_SIGKILL that is only set for
a real SIGKILL.  de_thread() doesn't clear SIGNAL_GROUP_KILLED if that's set.

fatal_signal_pending() is only called on current, and only from places
that can't be on the exit path.  It can just check ->signal->flags.  Only
the schedule() case, i.e. signal_pending_state(), could conceivably be
called after exit_notify().  (At that point, release_task() can be racing
and clear/free ->signal so it's not safe to use the pointer.)  I really
don't think there ought to be any "optional" sleeps after exit_notify(),
i.e. anything interruptible or killable--just preemption and maybe some
uninterruptible wait inside one of the teardown calls.  So I doubt that
comes up, but it's easy to check for with ->exit_state.

What I have in mind is:

    /*
     * Only called on current.
     */
    static inline int fatal_signal_pending(struct task_struct *p)
    {
	    return (p->signal->flags & SIGNAL_GROUP_KILLED) != 0;
    }

    static inline int signal_pending_state(long state, struct task_struct *p)
    {
	    if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
		    return 0;
	    if (!signal_pending(p))
		    return 0;
	    if (state & TASK_INTERRUPTIBLE)
		    return 1;

	    if (unlikely(p->exit_state)) {
		    WARN_ON_ONCE(1);
		    return 1;
	    }

	    return fatal_signal_pending(p);
    }

(Btw, do_wait_for_common() should use signal_pending_state() too.)

Now we can rely on TASK_WAKEKILL to deal with all the races for us inside
schedule().  We can nix sigkill_pending() and simplify ptrace_stop()
without the core check as your patches did.  That alone is fine for
correctness.  It is fine to momentarily enter TASK_TRACED and then not
stop.  Worst case, a ptracer sees a wait succeed and then the task is on
its way to death so ptrace() refuses to work on it--it's just as if the
SIGKILL (or other thread's exec) came between the wait and ptrace calls.

We can add a short-circuit check at the top of ptrace_stop() to optimize
out arch_ptrace_stop() and other work when we're not going to stop.

I think that covers everything.  How do you like it?


Thanks,
Roland
