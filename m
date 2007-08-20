Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbXHTPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbXHTPFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbXHTPF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:05:28 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33571 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbXHTPF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:05:27 -0400
Date: Mon, 20 Aug 2007 19:07:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
Message-ID: <20070820150727.GA304@tv-sign.ru>
References: <20070819201012.GA113@tv-sign.ru> <20070819203112.8553A4D058C@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070819203112.8553A4D058C@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Roland McGrath wrote:
>
> I had in mind unifying this need with what's now done by the notify_count
> check that's in __exit_signal.  Aside from those BUG_ON's, I'm not sure
> de_thread really cares whether the other non-leader threads are finished
> self reaping, or only if they are dead.  Adding some field to signal_struct
> for this new mechanism is certainly fine if it goes along with removing a
> word or two from task_struct (notify_count, group_exit_task).  (The single
> other use overloaded on group_exit_task is for a similar need in the
> pre-coredump synchronization.  So maybe that can be done more cleanly too.)
> Any new field could be kept to a single pointer; since it's only needed
> while one given thread is blocking, it can point to something larger on its
> stack if necessary.

I seem to understand what you mean... Yes, at first glance, we can consider
the sub-thread with ->exit_state != 0 as "dead enough" for de_thread. This
allows us to simplify the logic greatly.

But: we should somehow change the ->group_leader for all sub-threads which
didn't do release_task(self) yet, nasty. (Perhaps it makes sense to move
->group_leader into signal_struct. It is not safe to use it if tsk already
did __exit_signal() anyway).

Another problem, it is not easy to define when the ->group_exit_task (or
whatever) should be notified from exit_notify(), we need another atomic_t
for that (like signal_struct.live).

In fact, it is not necessary to put this counter into signal_struct,
de_thread() can count sub-threads (say, modify zap_other_threads() to
return "int") and put this info into the structure on stack, as you
pointed out.

Imho, this definitely worth thinking. See also below.


But what do you think about this patch? Should we go with it for now,
or we should ignore the problem until we can cleanup the whole thing?
I do not claim this problem is very much important, but this yield()
is really buggy (perhaps it is always buggy).


> While we are considering cleaning up the exec synchronization, there is a
> long-standing issue it would be nice to address.  That is, the race of a
> group fatal signal with exec. (I've mentioned this before, but never come
> up with an adequate solution.)
>
> An obvious path to a fix for that is to avoid overloading SIGNAL_GROUP_EXIT
> in de_thread.  In coming up with different synchronization method we might
> find a way that cleans that up too.

Yes, yes, yes, these problems are really connected, and I also thought about
that.

But can't we first cleanup some other oddities with signal->flags? For example,
it would be nice to kill SIGNAL_STOP_DEQUEUED, but we can't because
handle_stop_signal(SIGKILL) clears ->signal->flags. And this is done because
tkill() doesn't do what __group_complete_signal() does for sig_fatal() signals
(I mean this big "if (sig_fatal(p, sig) ...").

Why? can't we split __group_complete_signal() into 2 functions, the new one
is used both by do_tkill() and __group_send_sig_info() ?

Just one example. Suppose that an application does

	signal(SIGTERM, SIG_DFL);
	sigtimedwait( {SIGTERM} );

Now,
	tkill(SIGTERM)	=> sigtimedwait() succeeds

	kill(SIGTERM)	=> application is killed UNLESS it has TIF_SIGPENDING

This looks really strange for me.


While we are here, I'd like to ask another question (sorry for the long and
somewhat off-topic post :)

Suppose that we have sub-threads T1 and T2, both do not block SIGXXX.
kill(SIGXXX) choose T1 as a target and does signal_wake_up(T1).
T1 can enter sys_sigprocmask(SIG_BLOCK, {SIGXXX}) before it sees the signal.
Now SIGXXX is delayed until T2 does recalc_sigpending().

Is it ok? This is easy to fix, for example sys_sigprocmask() can check
signal_pending() and return ERESTARTNOINTR.

Oleg.

