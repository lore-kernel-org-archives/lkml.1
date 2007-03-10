Return-Path: <linux-kernel-owner+w=401wt.eu-S933499AbXCJRnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbXCJRnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 12:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933500AbXCJRnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 12:43:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45876 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933499AbXCJRnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 12:43:03 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 09:42:55 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/9] signalfd/timerfd v1 - signalfd core ...
In-Reply-To: <20070310155638.GA192@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703100929020.29266@alien.or.mcafeemobile.com>
References: <20070310155638.GA192@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Oleg Nesterov wrote:

> Davide Libenzi wrote:
> >
> > +int signalfd_deliver(struct sighand_struct *sighand, int sig,
> > +		     struct siginfo *info)
> > +{
> > +	int nsig = 0;
> > +	struct list_head *pos;
> > +	struct signalfd_ctx *ctx;
> > +
> > +	list_for_each(pos, &sighand->sfdlist) {
> > +		ctx = list_entry(pos, struct signalfd_ctx, lnk);
> 
> list_for_each_entry()

Will do, thx!



> > +		/*
> > +		 * We use a negative signal value as a way to broadcast that the
> > +		 * sighand has been orphaned, so that we can notify all the
> > +		 * listeners about this. Remeber the ctx->sigmask is inverted,
> > +		 * so if the user is interested in a signal, that corresponding
> > +		 * bit will be zero.
> > +		 */
> > +		if (sig < 0 || !sigismember(&ctx->sigmask, sig)) {
> > +			__wake_up_locked(&ctx->wqh,
> > +					 TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);
> 
> wake_up_locked(&ctx->wqh)

Yeah, will do.



> > +		ctx->sighand = current->sighand;
> > +		atomic_inc(&ctx->sighand->count);
> 
> I personally don't like this. de_thread() was/is the source of numerous
> problems, and this patch adds yet another subtle dependency. The usage of
> "private" __cleanup_sighand() is not good per se, imho.

This we agree ...



> Also, this is not so flexible, we can't take S_ISUID into account. It seems
> logical to preserve ctx after a "normal" exec.

This, not really. I'm not sure we want to leak this out of an exec.



> > +		spin_lock_irq(&ctx->sighand->siglock);
> > +		ctx->sigmask = sigmask;
> > +		spin_unlock_irq(&ctx->sighand->siglock);
> > +		wake_up(&ctx->wqh);
> 
> Race with signalfd_read()->__add_wait_queue().

Ack.



> > +	if (sighand != ctx->tsk->sighand || ctx->tsk->signal == NULL ||
> 
> We don't need "ctx->tsk->signal == NULL". tsk->signal == NULL (when checked
> under ->siglock) implies tsk->sighand == NULL. This is covered by the first
> "sighand != ctx->tsk->sighand"  check.

Extra check, due to rely less on the exit_signal code.


> > +		__remove_wait_queue(&ctx->wqh, &wait);
> > +		set_current_state(TASK_RUNNING);
> 
> We don't need mb() here.

Ack.


> > +void signal_fill_info(struct siginfo *dinfo, int sig, struct siginfo *sinfo)
> > +{
> > +	switch ((unsigned long) sinfo) {
> > +	case (unsigned long) SEND_SIG_NOINFO:
> > +		dinfo->si_signo = sig;
> > +		dinfo->si_errno = 0;
> > +		dinfo->si_code = SI_USER;
> > +		dinfo->si_pid = current->pid;
> > +		dinfo->si_uid = current->uid;
> > +		break;
> > +	case (unsigned long) SEND_SIG_PRIV:
> > +		dinfo->si_signo = sig;
> > +		dinfo->si_errno = 0;
> > +		dinfo->si_code = SI_KERNEL;
> > +		dinfo->si_pid = 0;
> > +		dinfo->si_uid = 0;
> > +		break;
> > +	default:
> > +		copy_siginfo(dinfo, sinfo);
> > +	}
> > +}
> 
> This change seems unneeded?

Yes, it leaked out from the version of signalfd that had its own queue.


> I'd suggest to remove signalfd_ctx->sighand. de_thread()/exit_signal() call
> 
> 	signalfd_exit_task(struct sighand_struct *sighand)
> 	{
> 		list_for_each_entry_safe(ctx, sighand->sfdlist)
> 			if (ctx->tsk == current) {
> 				wake_up_locked(ctx->wqh);
> 				list_del_init(ctx->lnk);
> 			}
> 	}
> 
> signalfd_read()/signalfd_poll use
> 
> 	static struct sighand_struct *ctx_try_to_lock(struct signalfd_ctx *ctx, flags)
> 	{
> 		struct sighand_struct *ret;
> 
> 		rcu_read_lock();
> 		ret = lock_task_sighand(ctx->task);
> 		rcu_read_unlock();
> 
> 		if (ret && list_empty(ctx->lnk)) {
> 			unlock_task_sighand(ctx->task);
> 			ret = NULL;
> 		}
> 
> 		return ret;
> 	}
> 
> instead of "spin_lock_irq(ctx->sighand)" + "if (ctx->sighand != ctx->tsk->sighand)".
> 
> Possible?
> 
> Note that signalfd_exit_task() is generic, could be used in another context,
> de_thread() can avoid the call if !suid.

I think it looks good to me. Will give it a spin today.



> How about CONFIG_SIGNALFD, btw?

Yes, I was already planning it.


> Davide, could you please cc me? I am not subscribed to lkml, noticed the new
> version by accident.

Will do, thx!



- Davide


