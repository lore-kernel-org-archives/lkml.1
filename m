Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYGGR6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYGGR6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYGGR6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:58:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40257 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbYGGR6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:58:00 -0400
Date: Mon, 7 Jul 2008 22:00:45 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: simplify ptrace_stop()->sigkill_pending() path
Message-ID: <20080707180045.GA265@tv-sign.ru>
References: <20080706160252.GA4123@tv-sign.ru> <20080707045631.112EB154246@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707045631.112EB154246@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06, Roland McGrath wrote:
>
> When you sent your earlier patches, something I didn't find immediately
> clear was the exact list of problem scenarios you were considering.  So,
> let's look at the whole picture.
>
> The two paths into ptrace_stop() are ptrace_signal() and ptrace_notify().
>
> In the ptrace_signal() path, the siglock is held throughout.  If someone
> comes along later to post a SIGKILL, it will happen after ptrace_stop()
> enters TASK_TRACED and signal_wake_up() will do the right thing.  The
> problem scenario is when the SIGKILL was already posted before we took the
> siglock, but ptrace_signal() gets called on a different signal first, i.e.
> one numbered < 9 is dequeued first.
>
> In the ptrace_notify() path, we just took the siglock before ptrace_stop().
> There can have been a SIGKILL pending before that, and we'll stop anyway.
> The paths into ptrace_notify() are e.g. after fork, exec, or syscall exit,
> where there very well may have been a long time for the signal to be posted
> since the last time it was checked for.
>
> Now let's look at what we do and don't want, to call things "right".

(re-ordered)

> When there is a real SIGKILL from userland (sys_kill et al actually called
> with SIGKILL), then we should never stop.  A real SIGKILL trumps all else.
> We must die as quickly as we can, end of story.

OK, thanks,

> The prevailing default case should be that we stop.  We want to let the
> debugger do its job.  Consider exit tracing (PTRACE_O_TRACEEXIT).  If there
> is a normal exit_group syscall, every thread should stop for exit tracing.

OK,

> When there is an exec in progress, we should not stop.  This is something
> outside the debugger's power to prevent (now that it's started in another
> thread) and the thread doing exec will block uninterruptibly until we die.

Hmm. Yes, the execing thread will block, but why this is wrong? It waits
for the traced thread which stops, this looks "normal".

> If there is a run of the mill signal that causes termination, every thread
> should stop for exit tracing.

Just to be sure I got this right, you mean the fatal signal but not SIGKILL,
yes?

> When there is a coredump_wait in progress, we should not stop.  This is
> something outside the debugger's power to prevent (now that it's started in
> another thread) and the core-dump thread will block so it can't be forced
> to finish quickly, until we die.

This differs from the case above just because the signal is
sig_kernel_coredump(), looks a bit strange.

> If you work out all the cases from those "rules", there are several where
> we currently make the wrong choice (in one direction or the other), even
> without considering races.  The changes from your patch series also don't
> get it right in several cases, as I've defined "right" above.

Yes.

> Let's stop overloading SIGKILL for internal purposes.  At the same time,
> let's treat real SIGKILL as special up front with its own bookkeeping.
>
> We can check t->signal->flags in recalc_sigpending_tsk().  Let's replace
> "t->signal->group_stop_count > 0" with "signal_group_sigpending(t->signal)".
> In there we can stick the logic we come up with.  To start with, it can be
> (signal->group_stop_count > 0 || signal_group_exit(signal)).  That lets us
> remove the SIGKILL from zap_other_threads(), complete_signal(), and
> zap_process().  In get_signal_to_deliver(), first thing in the loop (before
> the group_stop_count check), check signal_group_exit() and if set go
> directly to do_group_exit() without dequeuing any signal.

Agreed, I also thought about that. Not that it matters, but we can safely
do this after the group_stop_count check, or we can change dequeue_signal()
to return SIGKILL if signal_group_exit().

> Next, we can optimize signal_group_sigpending() by reducing it to a single
> flags check.  Add a flag (maybe called SIGNAL_GROUP_INTERRUPT) meaning "all
> threads must get into get_signal_to_deliver() ASAP".  Include this bit in
> SIGNAL_GROUP_EXIT so it's set every place that sets it.  Also make
> de_thread() set this bit when it sets group_exit_task (and clear it after).
> Also make do_signal_stop() set it when it sets group_stop_count, and clear
> it when it sets SIGNAL_STOP_STOPPED (which existing code would implicitly).

(this is only optimization, let's ignore this issue for now)

> Now, the ptrace issues.  Add a flag SIGNAL_GROUP_KILLED meaning "must exit
> ASAP, no waiting".  de_thread() sets this for exec, complete_signal() sets
> it for SIGKILL, and coredump_wait() sets it.  de_thread() has to clear the
> flag afterwards on success, which could hide that a real SIGKILL came in
> the middle.  So add another flag SIGNAL_GROUP_SIGKILL that is only set for
> a real SIGKILL.  de_thread() doesn't clear SIGNAL_GROUP_KILLED if that's set.
>
[...]
>
>     static inline int fatal_signal_pending(struct task_struct *p)
>     {
> 	    return (p->signal->flags & SIGNAL_GROUP_KILLED) != 0;
>     }

Well, this is OK for ptrace (but see below), but doesn't look right
in general. complete_signal() sets this flag only for SIGKILL, what
about other fatal signals which cause SIGNAL_GROUP_EXIT? In that
case fatal_signal_pending() must be true as well.

The same for sys_exit_group(), it also must set this flag. So I can't
understand how SIGNAL_GROUP_KILLED can differ from signal_group_exit().
Apart from optimization, of course.

But signal_group_exit() doesn't suit for ptrace_stop() case.

Confused.

> fatal_signal_pending() is only called on current, and only from places
> that can't be on the exit path.  It can just check ->signal->flags.  Only
> the schedule() case, i.e. signal_pending_state(), could conceivably be
> called after exit_notify().  (At that point, release_task() can be racing
> and clear/free ->signal so it's not safe to use the pointer.)  I really
> don't think there ought to be any "optional" sleeps after exit_notify(),

(off-topic: any sleep after exit_notify() is not good, CPU_DEAD can't
 in general find this task for migration. However this is possible.)

> i.e. anything interruptible or killable--just preemption and maybe some
> uninterruptible wait inside one of the teardown calls.  So I doubt that
> comes up, but it's easy to check for with ->exit_state.

Agreed. In fact I have already thought about changing fatal_signal_pending()
to use signal_group_exit(), see http://marc.info/?l=linux-kernel&m=121267953524149
This also fixes the issues with /sbin/init. But again, this is not good
for PT_TRACE_EXIT.

And I was worried about schedule in TASK_KILLABLE after exit_notify().
This doesn't look possible currently, probably not a problem.

>     static inline int signal_pending_state(long state, struct task_struct *p)
>     {
> 	    if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
> 		    return 0;
> 	    if (!signal_pending(p))
> 		    return 0;
> 	    if (state & TASK_INTERRUPTIBLE)
> 		    return 1;
>
> 	    if (unlikely(p->exit_state)) {
> 		    WARN_ON_ONCE(1);
> 		    return 1;
> 	    }
>
> 	    return fatal_signal_pending(p);
>     }
>
> Now we can rely on TASK_WAKEKILL to deal with all the races for us inside
> schedule().  We can nix sigkill_pending() and simplify ptrace_stop()
> without the core check as your patches did.

Well yes, but PT_TRACE_EXIT is special again. signal_pending() can be
false, so we can sleep even if the task was SIGKILL'ed.

> (Btw, do_wait_for_common() should use signal_pending_state() too.)

Completely agreed, I was going to do this from the very beginning.
And __down_common() too.

Oleg.

