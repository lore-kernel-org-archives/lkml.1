Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYB2L5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYB2L5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbYB2L5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:57:10 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59051 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbYB2L5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:57:08 -0500
Date: Fri, 29 Feb 2008 15:01:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
Message-ID: <20080229120101.GA1410@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz> <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz> <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru> <20080229023902.D93E12700FD@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229023902.D93E12700FD@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry Roland, re-sending with cc's)

On 02/28, Roland McGrath wrote:
>
> > BTW, I think we have the same problem when handle_stop_signal() does
> > do_notify_parent_cldstop(p, CLD_STOPPED) above. The multithreaded app
> > in the middle of the group stop can resume without actually seeing
> > SIGCONT, no?
>
> I don't think I follow the scenario you have in mind there.  When siglock
> is dropped there, noone has been woken up yet.  It's just as if the sending
> of SIGCONT had not begun yet.

Yes.

> > Note also sig_needs_tasklist(), we take tasklist_lock() exactly because
> > we will probably drop siglock.
>
> do_notify_parent_cldstop will always need tasklist_lock because of its
> parent link.  With my patch below, the signal-posting path should never
> drop and reacquire the siglock any more.  So we could just make
> do_notify_parent_cldstop take the lock (read_lock nests anyway) and the
> signal-posting path callers don't need to take it.

We have to take tasklist in advance to make sure that the target task
can't go away once we drop its ->siglock.

Otherwise, finish_signal() can do:

	read_lock(tasklist);
	if (p->signal)
		do_notify_parent_cldstop(p, notify);
	read_unlock(tasklist);

but the parent can miss the notification. Is it OK?

> > What do you think about the approach at least?
>
> My first reaction was that it would have the wrong semantics.  The special
> effect of SIGCONT to resume the process happens at the time of signal
> generation, not at signal delivery.  The CLD_CONTINUED notification to the
> parent has to happen when the resumption happens.  If SIGCONT is blocked or
> ignored, then the process is woken up but may never dequeue the signal.
> However, in fact it will always already been in get_signal_to_deliver by
> definition, since that's where stopping happens.  So it will indeed always
> come out and see your check before it resumes.  The only difference then is
> whether the SIGCHLD gets sent immediately at post time or only when the
> resumed child actually gets scheduled.  I don't think that's a problem.

Another difference is that the notification may come from another thread,
not from the signalled one. (this only matters if the task is ptraced).
Hopefully not a problem too?

> Certainly it should just be a flag or two in signal_struct.flags.  The
> extra field is really too ugly.  We need to think carefully about all the
> places that clear/reset ->signal->flags, though.

Yes, exactly.

> Note that doing two
> do_notify_parent_cldstop calls in a two is redundant, since the signals
> don't queue and the parent is not often going to respond so quickly that
> the second one ever actually posts.  I'd be inclined to just make that an
> else if.

Yes, I also thought about that.

> > Hmm... Can't we make a simpler patch for the start? See below.
> > We can notify the parent earlier, before waking the TASK_STOPPED
> > child. This should fix this race, no?
>
> That is exactly what my first impulse was and what I described as opening
> another can of worms.  (I almost sent the identical patch yesterday.)  Here
> is what I was concerned about.  This does the CLD_CONTINUED SIGCHLD before
> any wakeups, so task_struct.state is still TASK_STOPPED.  The parent can
> see the SIGCHLD, call wait, and see the child still in TASK_STOPPED.  In
> wait_task_stopped, a few things can happen.  It might by then have gotten
> to the signal-sender's retaking of the siglock and wake_up_state; if so, it
> sees p->state no longer TASK_STOPPED and/or p->exit_code no longer nonzero,
> and returns 0.  Then the parent's wait goes back to sleep (or reports
> nothing for WNOHANG), and it never gets a wakeup corresponding to the
> CLD_CONTINUED notification, which it expects in a call using WCONTINUED.
> This is why the notification comes after the wakeup.

Yes, you are right, thanks. But please note that do_wait() is very wrong
here, see http://marc.info/?l=linux-kernel&m=119713909207444 (the patch
needs more work, of course).


Btw, I tried to read the comment many times, but still I can't understand
why handle_stop_signal() reports CLD_STOPPED.

Let's look at your patch:

	notify = ((p->signal->flags & SIGNAL_STOP_STOPPED) ?
		CLD_CONTINUED : CLD_STOPPED);

Q: why can't we do

	if (p->signal->flags & SIGNAL_STOP_STOPPED)
		notify = CLD_CONTINUED;

instead?

IOW. Suppose that SIGCONT comes after SIGSTOP. Now, if SIGSTOP was not
dequeued yet, we report nothing. If it was dequeued by some thread which
initiates ->group_stop_count we report CLD_STOPPED. What is the difference?

> Here is
> another version of my patch, that also eliminates the lock-drop for the
> CLD_STOPPED notification when a group stop is still in progress.
> (Though I still haven't yet grokked how that case introduced any bug.)
> What do you think?

My only concern is that it complicates the code :(

However,

> I don't dislike the direction of your flag-setting approach above.  But
> it does introduce more new subtleties that warrant more thought.

Yes sure.

>  /*
> + * This is called by a few places outside this file.
> + */
> +int
> +__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
> +{
> +	int notify;
> +	int ret = generate_group_signal(sig, info, p, &notify);
> +	if (unlikely(notify)) {
> +		spin_unlock(&p->sighand->siglock);
> +		do_notify_parent_cldstop(p, notify);
> +		spin_lock(&p->sighand->siglock);
> +	}
> +	return ret;
> +}

Perhaps it is better to export generate_group_signal() instead (not right now
of course). There is only one caller which does __group_send_sig_info(SIGCONT),
do_tty_hangup(). Any function which does unlock+lock is dangerous, the user
can miss the fact it doesn't hold the lock throughout.

Oleg.

