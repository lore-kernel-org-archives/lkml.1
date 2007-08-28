Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbXH1KBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbXH1KBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXH1KBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:01:04 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44567 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbXH1KBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:01:02 -0400
Date: Tue, 28 Aug 2007 14:01:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
Message-ID: <20070828100129.GA315@tv-sign.ru>
References: <20070820150727.GA304@tv-sign.ru> <20070828085453.4D73A4D04CC@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828085453.4D73A4D04CC@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Roland McGrath wrote:
>
> > I seem to understand what you mean... Yes, at first glance, we can consider
> > the sub-thread with ->exit_state != 0 as "dead enough" for de_thread. This
> > allows us to simplify the logic greatly.
> 
> I can't really think of any definite problem with that off hand.  Aside
> from stray BUG_ON's, that is.

Yes. The more I think about your idea, the more I like it.

> > But: we should somehow change the ->group_leader for all sub-threads which
> > didn't do release_task(self) yet, nasty. (Perhaps it makes sense to move
> > ->group_leader into signal_struct. It is not safe to use it if tsk already
> > did __exit_signal() anyway).
> 
> It's at least still safe to use ->group_leader->{pid,tgid} under
> rcu_read_lock if you checked for NULL.

No, if de_thread() changes does release_task(old_leader). Now, if another
sub-thread didn't to release_task(self), it has a valid sighand, could be
found by /proc, etc, but its ->group_leader points to nothing, this memory
could be freed. Note the proc_task_readdir() for example.

In fact, even the release_task(self) becomes unsafe.

> > Another problem, it is not easy to define when the ->group_exit_task (or
> > whatever) should be notified from exit_notify(), we need another atomic_t
> > for that (like signal_struct.live).
> 
> Off hand it seems to me that either signal->live or signal->count can serve.

I don't think they can work, the first one is too early, the second is too
late...

> > In fact, it is not necessary to put this counter into signal_struct,
> > de_thread() can count sub-threads (say, modify zap_other_threads() to
> > return "int") and put this info into the structure on stack, as you
> > pointed out.
> 
> Could be.

Yes, I think this can work.

> > But what do you think about this patch? Should we go with it for now,
> > or we should ignore the problem until we can cleanup the whole thing?
> > I do not claim this problem is very much important, but this yield()
> > is really buggy (perhaps it is always buggy).
> 
> I think we can probably come up with an incremental bit of cleanup
> soon that is not too invasive and solves the problem more cleanly.
> So I'd rather try to hash that out now than just use that patch.

OK, we can drop it, I agree.

> > But can't we first cleanup some other oddities with signal->flags? For example,
> > it would be nice to kill SIGNAL_STOP_DEQUEUED, but we can't because
> > handle_stop_signal(SIGKILL) clears ->signal->flags. And this is done because
> > tkill() doesn't do what __group_complete_signal() does for sig_fatal() signals
> > (I mean this big "if (sig_fatal(p, sig) ...").
> 
> This is an odd way to describe it.  Firstly, SIGNAL_STOP_DEQUEUED exists
> for other reasons, as I've just posted about in another thread.  SIGKILL
> clears ->signal->flags by design, because it overrides previous states.

Yes, yes, I meant that it would be nice to do it other way, see below...

> > Why? can't we split __group_complete_signal() into 2 functions, the new one
> > is used both by do_tkill() and __group_send_sig_info() ?
> 
> We can.  The new function (complete_signal?) could be called by
> __group_complete_signal on the selected target, and roughly replace the
> signal_wake_up calls in specific_send_sig_info and send_sigqueue.

Yes, thanks, this is what I meant, and implies that handle_stop_signal()
can do nothing for SIGKILL.

> > Just one example. Suppose that an application does
> > 
> > 	signal(SIGTERM, SIG_DFL);
> > 	sigtimedwait( {SIGTERM} );
> > 
> > Now,
> > 	tkill(SIGTERM)	=> sigtimedwait() succeeds
> > 
> > 	kill(SIGTERM)	=> application is killed UNLESS it has TIF_SIGPENDING
> > 
> > This looks really strange for me.
> 
> If that happens, it is a bug.  This check is supposed to prevent that:
> 
> 	    !sigismember(&t->real_blocked, sig) &&

Yes, but only if the signal was blocked before doing sigtimedwait().
Otherwise the behaviour is very different, and I don't know what
behaviour is correct. Perhaps, we can ignore the difference between
kill/tkill, at least this difference is always the same.

But TIF_SIGPENDING is "random", imho it is not good it can make the
difference. (In case I was unclear, note that wants_signal() checks
signal_pending(), so __group_complete_signal() may return without
"converting" sig_fatal() signal to SIGKILL).

> > Suppose that we have sub-threads T1 and T2, both do not block SIGXXX.
> > kill(SIGXXX) choose T1 as a target and does signal_wake_up(T1).
> > T1 can enter sys_sigprocmask(SIG_BLOCK, {SIGXXX}) before it sees the signal.
> > Now SIGXXX is delayed until T2 does recalc_sigpending().
> > 
> > Is it ok? This is easy to fix, for example sys_sigprocmask() can check
> > signal_pending() and return ERESTARTNOINTR.
> 
> I think this is a bug and needs to be fixed.  Scheduling delays in signal
> delivery are fine, but process signals must not sit pending while threads
> not blocking that sgianl run merrily along.  I think the fix you suggest
> will do fine for this case.

Great,

> We should consider any other places where
> ->blocked is affected, e.g. sigsuspend, pselect, ppoll.  If it's possible
> those can add signals to ->blocked before handling pending process signals,
> then it might be necessary to have them find another thread to do
> recalc_sigpending_and_wake on, as in exit_notify.  (Hopefully any such can
> just be made to handle pending signals before blocking any.)

Aha, I need to think about this, thanks!

Oleg.

