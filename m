Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYCAQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYCAQh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYCAQhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:37:07 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:35905 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbYCAQhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:37:05 -0500
Date: Sat, 1 Mar 2008 19:41:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
Message-ID: <20080301164102.GA171@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz> <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz> <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru> <20080229023902.D93E12700FD@magilla.localdomain> <20080229120101.GA1410@tv-sign.ru> <20080301015956.A0D262700FE@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301015956.A0D262700FE@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29, Roland McGrath wrote:
>
> > > I don't think I follow the scenario you have in mind there.  When siglock
> > > is dropped there, noone has been woken up yet.  It's just as if the sending
> > > of SIGCONT had not begun yet.
> >
> > Yes.
>
> So you concur that there is no misbehavior from that lock-drop?
> (I'm all for getting rid of it, just don't want to have a wrong
> thought in my head about what the precise issues are.)

Let me first clarify what I meant when I said "I think we have the same problem".
Suppose that we have the "int sigcont_received" flag which is set by the SIGCONT
handler. Now, the main thread sends SIGSTOP to itself, and another thread does:

	if (this_task_is_stopped("/proc/self/status") {
		// If I'am here and running, I was woken by SIGCONT.
		// Otherwise I must see the group-stop-in-progress
		// "signal" after syscall
		ASSERT(sigcont_received == 1);
	}

This assertion abibe may fail. But of course, this example is completely
artificial, there is no real problem.

However, I think this lock-drop is really wrong by another reason. Suppose
that another sig_kernel_stop() signal comes when we drop ->siglock. The new
signal should dismiss the "pending" SIGCONT, but this doesn't happen.
When handle_stop_signal() re-takes ->siglock it removes the new signal.

Worse. Let's suppose that the new signal was already deueued by some thread
before handle_stop_signal() re-takes ->siglock. This thread initiates the
new group stop (note that we cleared ->group_stop_count). Now we are waking
up all TASK_STOPPED threads, but we don't clear ->group_stop_count. This
means that eventually the thread group will have SIGNAL_STOP_STOPPED set
but not all threads are stopped.

> > Otherwise, finish_signal() can do:
> >
> > 	read_lock(tasklist);
> > 	if (p->signal)
> > 		do_notify_parent_cldstop(p, notify);
> > 	read_unlock(tasklist);
> >
> > but the parent can miss the notification. Is it OK?
>
> I certainly didn't have in mind permitting that.  But if the only thing
> that can happen is that if the parent called wait already to reap the
> child, it never gets the SIGCHLD for it, then technically that is fine.

Well yes, but what if CLONE_THREAD task autoreaps itself?

> > Another difference is that the notification may come from another thread,
> > not from the signalled one. (this only matters if the task is ptraced).
> > Hopefully not a problem too?
>
> I guess the issue you meant was that the task_struct argument to
> do_notify_parent_cldstop is whichever thread woke up and took the siglock
> first, rather than the recipient of the SIGCONT (usually the group leader).
> Now I understand your reference to ptrace--it does tsk = tsk->group_leader
> unless ptraced.  AFAICT, what this affects is only the si_pid, si_uid,
> si_[us]time values in the siginfo_t for the SIGCHLD with si_code =
> CLD_CONTINUED.  Not that ptracers really care one way or the other, but I
> think the ptrace special case really only sensibly applies to CLD_STOPPED.
> There aren't going to be CLD_CONTINUED notifications for each and every
> thread anyway (and I don't think they would be all that useful to a ptracer).

Thanks! I really hoped the answer will be like that.

> So independent of all this, even as things stand now I would do:
>
> 	if (why == CLD_STOPPED && (tsk->ptrace & PT_PTRACED))
>
> to clear that up.

This breaks ptrace_stop()->do_notify_parent_cldstop(CLD_TRAPPED) but I see
what you mean.

Anyway, I think we can clean up this separately. This CLD_STOPPED reported
from handle_stop_signal() is "group wide" anyway. Actually, I think that
get_signal_to_deliver() can just do

	do_notify_parent_cldstop(current->group_leader, why);

, this even looks more sane to me.

> > IOW. Suppose that SIGCONT comes after SIGSTOP. Now, if SIGSTOP was not
> > dequeued yet, we report nothing. If it was dequeued by some thread which
> > initiates ->group_stop_count we report CLD_STOPPED. What is the difference?
>
> If SIGSTOP was not dequeued yet, then it was pending and was cleared by
> generating SIGCONT, so nothing happened: no stop, no continue, just a SIGCONT
> is now pending.  (There is also the example where it's SIGTSTP and it was
> blocked, so there's a case that does not depend on a race happening.)  If the
> group stop has begun, then at least one thread has already begun stopping,
> and experienced effects like a syscall returning -EINTR.  Those effects
> shouldn't be seen if "nothing happened".  But they are expected if the
> process stopped and then continued very quickly.  If that's what happened,
> then the CLD_STOPPED SIGCHLD was posted before the continue happened.

OK, thanks. But let's look at this scenario with the different angle.
We pretend that the group stop was already finished, and report CLD_STOPPED.
But at the same time, this SIGCONT "cancels" this group stop, so what we have
is "stopped and then continued". Isn't it better to always report CLD_CONTINUED?
(yes, this looks as if the preceding CLD_STOPPED was somehow lost, but still).

To avoid a possible confusing, I am not really arguing, just curious. This
issue is minor anyway.

> >  int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
> >  			  struct pt_regs *regs, void *cookie)
> >  {
> > @@ -1761,6 +1772,9 @@ relock:
> >  	for (;;) {
> >  		struct k_sigaction *ka;
> >
> > +		if (unlikely(handle_notify_parent()))
> > +			goto relock;
> > +
> >  		if (unlikely(current->signal->group_stop_count > 0) &&
> >  		    do_signal_stop(0))
> >  			goto relock;
>
> This is only ever needed after we have just been in do_signal_stop and it
> actually stopped (returned 1).  That always gets to a goto relock.  So this
> could be outside the for loop.  I'd just inline it rather than have another
> function that conditionally unlocks, which sparse hates.
>
> So:
>
> 	spin_lock_irq(&current->sighand->siglock);
>
> 	/*
> 	 * long and helpful comment
> 	 */
> 	if (unlikely(current->signal->notify_parent)) {
> 		int why = current->signal->notify_parent;
> 		current->signal->notify_parent = 0;
> 		spin_unlock_irq(&current->sighand->siglock);
> 		read_lock(&tasklist_lock);
> 		do_notify_parent_cldstop(current, why);
> 		read_unlock(&tasklist_lock);
> 		goto relock;
> 	}
>
> 	for (;;) {

Agreed, thanks!

Oleg.

