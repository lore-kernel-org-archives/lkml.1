Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbYCACAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbYCACAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 21:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYCACAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 21:00:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760778AbYCACAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 21:00:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: Oleg Nesterov's message of  Friday, 29 February 2008 15:01:01 +0300 <20080229120101.GA1410@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
	<20080227210038.93AFC2700FD@magilla.localdomain>
	<Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
	<20080228102649.071572700FD@magilla.localdomain>
	<20080228153043.GA11484@tv-sign.ru>
	<20080229023902.D93E12700FD@magilla.localdomain>
	<20080229120101.GA1410@tv-sign.ru>
X-Shopping-List: (1) Luxurious redeemer miscreants
   (2) Bent irrelevant scorpion perversions
   (3) Wet lion holidays
   (4) Ingenuous tape
Message-Id: <20080301015956.A0D262700FE@magilla.localdomain>
Date: Fri, 29 Feb 2008 17:59:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't think I follow the scenario you have in mind there.  When siglock
> > is dropped there, noone has been woken up yet.  It's just as if the sending
> > of SIGCONT had not begun yet.
> 
> Yes.

So you concur that there is no misbehavior from that lock-drop?
(I'm all for getting rid of it, just don't want to have a wrong
thought in my head about what the precise issues are.)

> We have to take tasklist in advance to make sure that the target task
> can't go away once we drop its ->siglock.

I see.

> Otherwise, finish_signal() can do:
> 
> 	read_lock(tasklist);
> 	if (p->signal)
> 		do_notify_parent_cldstop(p, notify);
> 	read_unlock(tasklist);
> 
> but the parent can miss the notification. Is it OK?

I certainly didn't have in mind permitting that.  But if the only thing
that can happen is that if the parent called wait already to reap the
child, it never gets the SIGCHLD for it, then technically that is fine.
(In fact, we are not POSIX-conforming now because pending SIGCHLDs are
supposed to be cleared by a wait call made with SIGCHLD blocked when there
are no more unwaited-for children ready.)  It seemed relevant to share that
nit, but I don't think we want to perturb the behavior here any time soon.

> Another difference is that the notification may come from another thread,
> not from the signalled one. (this only matters if the task is ptraced).
> Hopefully not a problem too?

The status quo is that the CLD_CONTINUED signal-sending call is made by an
unrelated task, the one sending the SIGCONT to the child, rather than with
child==current as other SIGCHLD's are.  I don't think that should matter,
because nothing in the do_notify_parent_cldstop code path consults current
for anything.  With your new plan, that path will be entered instead by
some thread in the group that was woken by generating SIGCONT.  If it did
matter, that would presumably only be better.

I guess the issue you meant was that the task_struct argument to
do_notify_parent_cldstop is whichever thread woke up and took the siglock
first, rather than the recipient of the SIGCONT (usually the group leader).
Now I understand your reference to ptrace--it does tsk = tsk->group_leader
unless ptraced.  AFAICT, what this affects is only the si_pid, si_uid,
si_[us]time values in the siginfo_t for the SIGCHLD with si_code =
CLD_CONTINUED.  Not that ptracers really care one way or the other, but I
think the ptrace special case really only sensibly applies to CLD_STOPPED.
There aren't going to be CLD_CONTINUED notifications for each and every
thread anyway (and I don't think they would be all that useful to a ptracer).

So independent of all this, even as things stand now I would do:

	if (why == CLD_STOPPED && (tsk->ptrace & PT_PTRACED))

to clear that up.

> Yes, you are right, thanks. But please note that do_wait() is very wrong
> here, see http://marc.info/?l=linux-kernel&m=119713909207444 (the patch
> needs more work, of course).

I haven't really reviewed that stuff properly (sorry about that, behind on
many things).  Let's not tie up this can of worms with that one for now.

> Btw, I tried to read the comment many times, but still I can't understand
> why handle_stop_signal() reports CLD_STOPPED.
> 
> Let's look at your patch:
> 
> 	notify = ((p->signal->flags & SIGNAL_STOP_STOPPED) ?
> 		CLD_CONTINUED : CLD_STOPPED);
> 
> Q: why can't we do
> 
> 	if (p->signal->flags & SIGNAL_STOP_STOPPED)
> 		notify = CLD_CONTINUED;
> 
> instead?
> 
> IOW. Suppose that SIGCONT comes after SIGSTOP. Now, if SIGSTOP was not
> dequeued yet, we report nothing. If it was dequeued by some thread which
> initiates ->group_stop_count we report CLD_STOPPED. What is the difference?

If SIGSTOP was not dequeued yet, then it was pending and was cleared by
generating SIGCONT, so nothing happened: no stop, no continue, just a SIGCONT
is now pending.  (There is also the example where it's SIGTSTP and it was
blocked, so there's a case that does not depend on a race happening.)  If the
group stop has begun, then at least one thread has already begun stopping,
and experienced effects like a syscall returning -EINTR.  Those effects
shouldn't be seen if "nothing happened".  But they are expected if the
process stopped and then continued very quickly.  If that's what happened,
then the CLD_STOPPED SIGCHLD was posted before the continue happened.

So that was my original rationale.  But there are still races.  (This can't
come up in the blocked-SIGTSTP case, where the behavior is reliably testable
from the application perspective.)  An unblocked stop signal might have
caused a signal_wake_up on some thread that then lost the race for the
siglock.  The SIGCONT-sender clears the pending SIGSTOP that was the reason
that thread's syscall got interrupted.  Then that thread will see -EINTR and
such effects, but there will never be any CLD_STOPPED report to justify it.
If that same thread is not the one to immediately run the SIGCONT handler,
there is no other excuse for the side effects.  Since that possibility still
exists (and is probably impossible to avoid), maybe I shouldn't worry about
the group-stop-in-progress case.  Clearly this isn't something anyone else
ever really worries about but me.

Still, when group_stop_count > 0 that means that we know for sure that every
thread has TIF_SIGPENDING and so all those that were in syscalls will for
sure see -EINTR and such side effects.  So I do lean towards having that
situation reported as "stopped and then continued" rather than "nothing
happened".

> Perhaps it is better to export generate_group_signal() instead (not right now
> of course). There is only one caller which does __group_send_sig_info(SIGCONT),
> do_tty_hangup(). Any function which does unlock+lock is dangerous, the user
> can miss the fact it doesn't hold the lock throughout.

I certainly think we should clean up all the callers to __group_send_sig_info
from outside signal.c, but I did not want to get into that cleanup in the
middle of this change.  Once we finish hashing out any changes to the locking
requirements for calling into the signals code, we can clean those uses up.

> Still. The more I think about it, the more I like it. It is so simple,
> and allows us to do further cleanups. Please look at the patch below.
> Now we don't need tasklist to send the signal.

I like it too.  My inclination is still to do the other cleanup first, and
also do enough other cleanups first so that we're confident of using a
signal_struct.flags bit for this right off.

> I am worried about ptrace, but hopefully there is no problem.

In practice no ptracer ever wanted a CLD_CONTINUED notification or cares
about them now.  So even "breaking" it wouldn't get us in much trouble.
But I don't see any problem at all, especially if we change the
do_notify_parent_cldstop behavior to use tsk = tsk->group_leader as 
I discussed above.

> @@ -1748,6 +1744,21 @@ static int do_signal_stop(int signr)
>  	return 1;
>  }
>  
> +static int handle_notify_parent(void)
> +{
> +	int why = current->signal->notify_parent;
> +	if (likely(!why))
> +		return 0;
> +	current->signal->notify_parent = 0;
> +	spin_unlock_irq(&current->sighand->siglock);
> +
> +	read_lock(&tasklist_lock);
> +	do_notify_parent_cldstop(current, why);
> +	read_unlock(&tasklist_lock);
> +
> +	return 1;
> +}
> +
>  int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
>  			  struct pt_regs *regs, void *cookie)
>  {
> @@ -1761,6 +1772,9 @@ relock:
>  	for (;;) {
>  		struct k_sigaction *ka;
>  
> +		if (unlikely(handle_notify_parent()))
> +			goto relock;
> +
>  		if (unlikely(current->signal->group_stop_count > 0) &&
>  		    do_signal_stop(0))
>  			goto relock;

This is only ever needed after we have just been in do_signal_stop and it
actually stopped (returned 1).  That always gets to a goto relock.  So this
could be outside the for loop.  I'd just inline it rather than have another
function that conditionally unlocks, which sparse hates.

So: 

	spin_lock_irq(&current->sighand->siglock);

	/*
	 * long and helpful comment
	 */
	if (unlikely(current->signal->notify_parent)) {
		int why = current->signal->notify_parent;
		current->signal->notify_parent = 0;
		spin_unlock_irq(&current->sighand->siglock);
		read_lock(&tasklist_lock);
		do_notify_parent_cldstop(current, why);
		read_unlock(&tasklist_lock);
		goto relock;
	}

	for (;;) {


Thanks,
Roland
