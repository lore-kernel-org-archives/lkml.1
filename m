Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXH1IzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXH1IzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXH1Iy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:54:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbXH1Iy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:54:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
In-Reply-To: Oleg Nesterov's message of  Monday, 20 August 2007 19:07:27 +0400 <20070820150727.GA304@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070828085453.4D73A4D04CC@magilla.localdomain>
Date: Tue, 28 Aug 2007 01:54:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I seem to understand what you mean... Yes, at first glance, we can consider
> the sub-thread with ->exit_state != 0 as "dead enough" for de_thread. This
> allows us to simplify the logic greatly.

I can't really think of any definite problem with that off hand.  Aside
from stray BUG_ON's, that is.  It occurs to me to worry about waiting
for the __exit_signal work of accumulating [us]time in signal_struct to
be finished before the exec fully completes and the new program can use
getrusage et al.  But I don't think there really is any problem there.
For each thread whose __exit_signal isn't finished yet, the normal
summing in k_getrusage will work.

> But: we should somehow change the ->group_leader for all sub-threads which
> didn't do release_task(self) yet, nasty. (Perhaps it makes sense to move
> ->group_leader into signal_struct. It is not safe to use it if tsk already
> did __exit_signal() anyway).

It's at least still safe to use ->group_leader->{pid,tgid} under
rcu_read_lock if you checked for NULL.  So I'm concerned there could be
some strange cases that make changing this a pain in ways we haven't
thought of.  But I have long thought that between group_leader, signal,
pid, and tgid, we have some redundancy.  ->signal->tsk is used only for
itimers, but is effectively ->group_leader already.  Likewise ->tgid is
->group_leader->pid and it's hard to see a real reason for the field.
But there are probably some strange corners.  

Cleanups aside, why does it matter if their ->group_leader pointer is
stale while they are on the way to dying and self-reaping?  Off hand,
I think it only matters that the old leader is release_task'd last (as
now) in case an old pointer is used.  But I'm not sure what in that
circumstance would really care about getting stale data from whatever
fields it examines in ->group_leader. 

> Another problem, it is not easy to define when the ->group_exit_task (or
> whatever) should be notified from exit_notify(), we need another atomic_t
> for that (like signal_struct.live).

Off hand it seems to me that either signal->live or signal->count can serve.

> In fact, it is not necessary to put this counter into signal_struct,
> de_thread() can count sub-threads (say, modify zap_other_threads() to
> return "int") and put this info into the structure on stack, as you
> pointed out.

Could be.

> But what do you think about this patch? Should we go with it for now,
> or we should ignore the problem until we can cleanup the whole thing?
> I do not claim this problem is very much important, but this yield()
> is really buggy (perhaps it is always buggy).

I think we can probably come up with an incremental bit of cleanup
soon that is not too invasive and solves the problem more cleanly.
So I'd rather try to hash that out now than just use that patch.

> But can't we first cleanup some other oddities with signal->flags? For example,
> it would be nice to kill SIGNAL_STOP_DEQUEUED, but we can't because
> handle_stop_signal(SIGKILL) clears ->signal->flags. And this is done because
> tkill() doesn't do what __group_complete_signal() does for sig_fatal() signals
> (I mean this big "if (sig_fatal(p, sig) ...").

This is an odd way to describe it.  Firstly, SIGNAL_STOP_DEQUEUED exists
for other reasons, as I've just posted about in another thread.  SIGKILL
clears ->signal->flags by design, because it overrides previous states.
It's certainly not "because tkill doesn't do ...".  The sig_fatal code in
__group_complete_signal was added as an optimization.  The intent was
always that the behavior already be correct without it, just sometimes
subject to more scheduling delay than a user might like.

Perhaps with complex scheduling policies it is now the case that the
unoptimized behavior can sometimes select so wrong a thread to dequeue a
process signal that the quality of implementation of process signal
delivery drops to effectively incorrect because you can't make a thing die
any time soon.

> Why? can't we split __group_complete_signal() into 2 functions, the new one
> is used both by do_tkill() and __group_send_sig_info() ?

We can.  The new function (complete_signal?) could be called by
__group_complete_signal on the selected target, and roughly replace the
signal_wake_up calls in specific_send_sig_info and send_sigqueue.

> Just one example. Suppose that an application does
> 
> 	signal(SIGTERM, SIG_DFL);
> 	sigtimedwait( {SIGTERM} );
> 
> Now,
> 	tkill(SIGTERM)	=> sigtimedwait() succeeds
> 
> 	kill(SIGTERM)	=> application is killed UNLESS it has TIF_SIGPENDING
> 
> This looks really strange for me.

If that happens, it is a bug.  This check is supposed to prevent that:

	    !sigismember(&t->real_blocked, sig) &&

> While we are here, I'd like to ask another question (sorry for the long and
> somewhat off-topic post :)

I would prefer separate threads about each issue, but I'm certainly
glad for the discussion.

> Suppose that we have sub-threads T1 and T2, both do not block SIGXXX.
> kill(SIGXXX) choose T1 as a target and does signal_wake_up(T1).
> T1 can enter sys_sigprocmask(SIG_BLOCK, {SIGXXX}) before it sees the signal.
> Now SIGXXX is delayed until T2 does recalc_sigpending().
> 
> Is it ok? This is easy to fix, for example sys_sigprocmask() can check
> signal_pending() and return ERESTARTNOINTR.

I think this is a bug and needs to be fixed.  Scheduling delays in signal
delivery are fine, but process signals must not sit pending while threads
not blocking that sgianl run merrily along.  I think the fix you suggest
will do fine for this case.  We should consider any other places where
->blocked is affected, e.g. sigsuspend, pselect, ppoll.  If it's possible
those can add signals to ->blocked before handling pending process signals,
then it might be necessary to have them find another thread to do
recalc_sigpending_and_wake on, as in exit_notify.  (Hopefully any such can
just be made to handle pending signals before blocking any.)


Thanks,
Roland
