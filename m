Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbYL1JW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbYL1JW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 04:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYL1JWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 04:22:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43996 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYL1JWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 04:22:16 -0500
Date: Sun, 28 Dec 2008 10:20:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [RFC][PATCH] Notify init when processes are reparented to it
Message-ID: <20081228092024.GA21673@redhat.com>
References: <1230378128.7026.50.camel@quest> <20081227114452.GA2919@zelda.netsplit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227114452.GA2919@zelda.netsplit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27, Scott James Remnant wrote:
>
> Allow the init daemon to be notified by signal when processes are
> reparented to it.  The signal has the same form as SIGCHLD except that
> the si_status field contains the original parent proecss id.

I think the changelog should explain why this change is useful.

I can't judge the usefulness, just a couple of nits about the
code.

> +++ b/include/linux/sched.h
> @@ -1133,6 +1133,7 @@ struct task_struct {
>  	int exit_state;
>  	int exit_code, exit_signal;
>  	int pdeath_signal;  /*  The signal sent when the parent dies  */
> +	int adopt_signal;  /*  The signal sent when a process is reparented  */

Should be cleared in copy_process() ?

And what if init is multithreaded? This should be per-process, not
per-thread.

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -813,6 +813,9 @@ static void reparent_thread(struct task_struct *p, struct task_struct *father)
>  		/* We already hold the tasklist_lock here.  */
>  		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
>
> +	if (p->real_parent->adopt_signal)
> +		do_notify_parent_adopted(p, father);
> +

Please note that we notify the new parent even if we re-parent to our
sub-thread, not to the new process. This means that a multithreaded
init can have the false notifications.

And, given that ->adopt_signal is per-thread, a multithreaded init
should be very careful with prctl(PR_SET_ADOPTSIG) if it does not
want to miss the notification.

> +void do_notify_parent_adopted(struct task_struct *tsk, struct task_struct *father)
> +{
> +	struct siginfo info;
> +	unsigned long flags;
> +	struct task_struct *reaper;
> +	struct sighand_struct *sighand;
> +	int ret;
> +
> +	reaper = tsk->real_parent;
> +
> +	memset (&info, 0, sizeof info);

Unneeded? This function seems to fill all interesting fields.

> +	info.si_signo = reaper->adopt_signal;
> +	/*
> +	 * set code to the same range as SIGCHLD so the right bits of
> +	 * siginfo_t get copied, to userspace this will appear as si_code=0
> +	 */
> +	info.si_code = __SI_CHLD;
> +	/*
> +	 * see comment in do_notify_parent() about the following 4 lines
> +	 */
> +	rcu_read_lock();
> +	info.si_pid = task_pid_nr_ns(tsk, reaper->nsproxy->pid_ns);
> +	info.si_status = task_pid_nr_ns(father, reaper->nsproxy->pid_ns);

perhaps it is better to use task_active_pid_ns(reaper).

> +	rcu_read_unlock();
> +
> +	info.si_uid = tsk->uid;
> +
> +	info.si_utime = cputime_to_clock_t(tsk->utime);
> +	info.si_stime = cputime_to_clock_t(tsk->stime);
> +
> +	sighand = reaper->sighand;
> +	spin_lock_irqsave(&sighand->siglock, flags);
> +	__group_send_sig_info(reaper->adopt_signal, &info, reaper);

This looks unsafe.

At this point reaper can already change its ->adopt_signal. For example
if it was cleared, send_signal() can crash while doing (say) sigismember().

Oleg.

