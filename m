Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbYCFJGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbYCFJGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYCFJFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:05:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbYCFJFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:05:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: Oleg Nesterov's message of  Saturday, 1 March 2008 19:41:02 +0300 <20080301164102.GA171@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
	<20080227210038.93AFC2700FD@magilla.localdomain>
	<Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
	<20080228102649.071572700FD@magilla.localdomain>
	<20080228153043.GA11484@tv-sign.ru>
	<20080229023902.D93E12700FD@magilla.localdomain>
	<20080229120101.GA1410@tv-sign.ru>
	<20080301015956.A0D262700FE@magilla.localdomain>
	<20080301164102.GA171@tv-sign.ru>
X-Zippy-Says: You mean you don't want to watch WRESTLING from ATLANTA?
Message-Id: <20080306090514.F3FD02700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 01:05:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, I'm responding to all your messages mostly in chronological order.  I
have seen the later ones with new code and ideas.  But I like to follow up
each point so we continue to double-check each other's logic and rationale.

Here we're talking about the first drop of siglock in handle_stop_signal,
where it calls do_notify_parent_cldstop with CLD_STOPPED.

> Let me first clarify what I meant when I said "I think we have the same
> problem".  Suppose that we have the "int sigcont_received" flag which is
> set by the SIGCONT handler. Now, the main thread sends SIGSTOP to itself,
> and another thread does:
> 
> 	if (this_task_is_stopped("/proc/self/status") {
> 		// If I'am here and running, I was woken by SIGCONT.
> 		// Otherwise I must see the group-stop-in-progress
> 		// "signal" after syscall
> 		ASSERT(sigcont_received == 1);
> 	}
>
> This assertion abibe may fail. But of course, this example is completely
> artificial, there is no real problem.

Here you mean testing that the main thread got into TASK_STOPPED (and could
be so seen via /proc) while the group stop was still in progress but the
second thread running that read+assert has not stopped yet.  Before
dropping the siglock, we abort the group stop in progress.  So the second
thread never stops, and runs before the SIGCONT handler.  What /proc
reports about individual threads is not something I'm trying to make
guarantees about.  But I see there is a problem there because
wait_task_stopped checks group_stop_count and not SIGNAL_STOP_STOPPED,
so it would report the process as stopped to WUNTRACED wait.

> However, I think this lock-drop is really wrong by another reason. Suppose
> that another sig_kernel_stop() signal comes when we drop ->siglock. The new
> signal should dismiss the "pending" SIGCONT, but this doesn't happen.
> When handle_stop_signal() re-takes ->siglock it removes the new signal.

I don't think this is really a problem.  This just means the SIGCONT is
effectively "after" the new signal, and the SIGCONT clears it rather than
vice versa.

> Worse. Let's suppose that the new signal was already deueued by some thread
> before handle_stop_signal() re-takes ->siglock. This thread initiates the
> new group stop (note that we cleared ->group_stop_count). Now we are waking
> up all TASK_STOPPED threads, but we don't clear ->group_stop_count. This
> means that eventually the thread group will have SIGNAL_STOP_STOPPED set
> but not all threads are stopped.

This is indeed a problem.

> > > Otherwise, finish_signal() can do:
> > >
> > > 	read_lock(tasklist);
> > > 	if (p->signal)
> > > 		do_notify_parent_cldstop(p, notify);
> > > 	read_unlock(tasklist);
> > >
> > > but the parent can miss the notification. Is it OK?
> >
> > I certainly didn't have in mind permitting that.  But if the only thing
> > that can happen is that if the parent called wait already to reap the
> > child, it never gets the SIGCHLD for it, then technically that is fine.
> 
> Well yes, but what if CLONE_THREAD task autoreaps itself?

Indeed then p->signal will be null and so we'll send no signal.
So no go.  (No loss, we didn't like this road much anyway.)

> > So independent of all this, even as things stand now I would do:
> >
> > 	if (why == CLD_STOPPED && (tsk->ptrace & PT_PTRACED))
> >
> > to clear that up.
> 
> This breaks ptrace_stop()->do_notify_parent_cldstop(CLD_TRAPPED) but I see
> what you mean.

Sure, so why != CLD_CONTINUED then.

> Anyway, I think we can clean up this separately. This CLD_STOPPED reported
> from handle_stop_signal() is "group wide" anyway. Actually, I think that
> get_signal_to_deliver() can just do
> 
> 	do_notify_parent_cldstop(current->group_leader, why);
> 
> , this even looks more sane to me.

Quite so.

> OK, thanks. But let's look at this scenario with the different angle.
> We pretend that the group stop was already finished, and report CLD_STOPPED.
> But at the same time, this SIGCONT "cancels" this group stop, so what we have
> is "stopped and then continued". Isn't it better to always report CLD_CONTINUED?
> (yes, this looks as if the preceding CLD_STOPPED was somehow lost, but still).

I think "stopped and then continued" means do exactly what would happen if
you really finished stopping and then continued without this race hitting.
If you did that and the parent had SIGCHLD blocked the whole time, then
waits two minutes, and then unblocks or sigwaits to get the siginfo_t, the
parent would see only CLD_STOPPED.  (This is because SIGCHLD doesn't queue
and the first siginfo_t pending wins.)  The other non-racy scenario that
could be is that the stop signal never got delivered at all before the
SIGCONT cleared it, when there would be no SIGCHLDs at all.  As I said
before, I exclude that version of events from being what we represent to
userland as having happened because the syscall-interruption effects on some
threads may already have happened, and give the lie to this story.  There is
only one story consistent with some sequence of events as specified in
POSIX, that explains all the possible userland-visible ramifications of this
particular internal race scenario.  Seeing a CLD_CONTINUED without a
preceding CLD_STOPPED is a new sequence for userland that was never possible
before.  In an application following POSIX there is no scenario possible
under the specification in which it could observe that sequence of events.
(Except that last one is probably not really true because I suspect it's
unspecified or implementation-defined whether when a non-queued signal is
posted twice, the first or second siginfo_t survives.)  That is my pedantic
rationale.  (Are you sorry you were curious? ;-)


Thanks,
Roland
