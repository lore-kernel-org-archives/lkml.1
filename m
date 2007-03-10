Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbXCJPxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbXCJPxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933472AbXCJPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:53:00 -0500
Received: from mail.screens.ru ([213.234.233.54]:49330 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbXCJPw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:52:59 -0500
Date: Sat, 10 Mar 2007 18:56:38 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] signalfd/timerfd v1 - signalfd core ...
Message-ID: <20070310155638.GA192@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
>
> +int signalfd_deliver(struct sighand_struct *sighand, int sig,
> +		     struct siginfo *info)
> +{
> +	int nsig = 0;
> +	struct list_head *pos;
> +	struct signalfd_ctx *ctx;
> +
> +	list_for_each(pos, &sighand->sfdlist) {
> +		ctx = list_entry(pos, struct signalfd_ctx, lnk);

list_for_each_entry()

> +		/*
> +		 * We use a negative signal value as a way to broadcast that the
> +		 * sighand has been orphaned, so that we can notify all the
> +		 * listeners about this. Remeber the ctx->sigmask is inverted,
> +		 * so if the user is interested in a signal, that corresponding
> +		 * bit will be zero.
> +		 */
> +		if (sig < 0 || !sigismember(&ctx->sigmask, sig)) {
> +			__wake_up_locked(&ctx->wqh,
> +					 TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);

wake_up_locked(&ctx->wqh)

> +asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
> +{
> [...snip...]
> +	if (ufd == -1) {
> +		error = -ENOMEM;
> +		ctx = kmem_cache_alloc(signalfd_ctx_cachep, GFP_KERNEL);
> +		if (!ctx)
> +			goto err_exit;
> +
> +		init_waitqueue_head(&ctx->wqh);
> +		ctx->sigmask = sigmask;
> +		ctx->tsk = current;
> +		get_task_struct(current);
> +
> +		/*
> +		 * We also increment the sighand count to make sure
> +		 * it doesn't go away from us in poll() when the task
> +		 * exits (which can happen if the fd is passed to
> +		 * another process with unix domain sockets.
> +		 *
> +		 * This also guarantees that an execve() will reallocate
> +		 * the signal state, and thus avoids security concerns
> +		 * with a untrusted process that passes off the signal
> +		 * queue fd to another, and then does a suid execve.
> +		 */
> +		ctx->sighand = current->sighand;
> +		atomic_inc(&ctx->sighand->count);

I personally don't like this. de_thread() was/is the source of numerous
problems, and this patch adds yet another subtle dependency. The usage of
"private" __cleanup_sighand() is not good per se, imho.

Also, this is not so flexible, we can't take S_ISUID into account. It seems
logical to preserve ctx after a "normal" exec.

I think, we don't need signalfd_ctx->sighand at all, please see below.

> +	} else {
> +		error = -EBADF;
> +		file = fget(ufd);
> +		if (!file)
> +			goto err_exit;
> +		ctx = file->private_data;
> +		error = -EINVAL;
> +		if (file->f_op != &signalfd_fops) {
> +			fput(file);
> +			goto err_exit;
> +		}
> +		spin_lock_irq(&ctx->sighand->siglock);
> +		ctx->sigmask = sigmask;
> +		spin_unlock_irq(&ctx->sighand->siglock);
> +		wake_up(&ctx->wqh);

Race with signalfd_read()->__add_wait_queue().

> +static unsigned int signalfd_poll(struct file *file, poll_table *wait)
> +{
> +	struct signalfd_ctx *ctx = file->private_data;
> +	struct sighand_struct *sighand = ctx->sighand;
> +	unsigned int events = 0;
> +	unsigned long flags;
> +
> +	poll_wait(file, &ctx->wqh, wait);
> +
> +	spin_lock_irqsave(&sighand->siglock, flags);
> +	/*
> +	 * Let the caller get a POLLIN in this case, ala socket recv() when
> +	 * the peer disconnect. The check for the changed sighand must be
> +	 * done before calling next_signal(), since if sighand changed, a call
> +	 * to next_signal() would crash. It'd be possible to avoid grabbing a
> +	 * lock by incrementing the tsk->signal count like we do with the
> +	 * tsk->sighand, but the code in __exit_signal() assumes that the
> +	 * tsk->signal can be freed only there, and this would require
> +	 * some code restructuring that I'm living out at this time.
> +	 */
> +	if (sighand != ctx->tsk->sighand || ctx->tsk->signal == NULL ||

We don't need "ctx->tsk->signal == NULL". tsk->signal == NULL (when checked
under ->siglock) implies tsk->sighand == NULL. This is covered by the first
"sighand != ctx->tsk->sighand"  check.

> +static ssize_t signalfd_read(struct file *file, char *buf, size_t count,
> +			     loff_t *ppos)
> +{
> [...snip...]
> +		for (;;) {
> +			if (sighand != ctx->tsk->sighand) {
> +				/*
> +				 * Let the caller read zero byte, ala socket recv()
> +				 * when the peer disconnect. This test must be done
> +				 * before doing a dequeue_signal(), because if the
> +				 * task's sighand changed, a dequeue_signal() is going
> +				 * to crash (tsk->signal is set to NULL).
> +				 */
> +				res = 0;
> +				break;
> +			}
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			if ((signo = dequeue_signal(ctx->tsk, &ctx->sigmask,
> +						    &info)) != 0)
> +				break;
> +			if (signal_pending(current)) {
> +				res = -EINTR;

-ERESTARTSYS ?

> +				break;
> +			}
> +			spin_unlock_irq(&sighand->siglock);
> +			schedule();
> +			spin_lock_irq(&sighand->siglock);
> +		}
> +		__remove_wait_queue(&ctx->wqh, &wait);
> +		set_current_state(TASK_RUNNING);

We don't need mb() here.

> +void signal_fill_info(struct siginfo *dinfo, int sig, struct siginfo *sinfo)
> +{
> +	switch ((unsigned long) sinfo) {
> +	case (unsigned long) SEND_SIG_NOINFO:
> +		dinfo->si_signo = sig;
> +		dinfo->si_errno = 0;
> +		dinfo->si_code = SI_USER;
> +		dinfo->si_pid = current->pid;
> +		dinfo->si_uid = current->uid;
> +		break;
> +	case (unsigned long) SEND_SIG_PRIV:
> +		dinfo->si_signo = sig;
> +		dinfo->si_errno = 0;
> +		dinfo->si_code = SI_KERNEL;
> +		dinfo->si_pid = 0;
> +		dinfo->si_uid = 0;
> +		break;
> +	default:
> +		copy_siginfo(dinfo, sinfo);
> +	}
> +}

This change seems unneeded?


I'd suggest to remove signalfd_ctx->sighand. de_thread()/exit_signal() call

	signalfd_exit_task(struct sighand_struct *sighand)
	{
		list_for_each_entry_safe(ctx, sighand->sfdlist)
			if (ctx->tsk == current) {
				wake_up_locked(ctx->wqh);
				list_del_init(ctx->lnk);
			}
	}

signalfd_read()/signalfd_poll use

	static struct sighand_struct *ctx_try_to_lock(struct signalfd_ctx *ctx, flags)
	{
		struct sighand_struct *ret;

		rcu_read_lock();
		ret = lock_task_sighand(ctx->task);
		rcu_read_unlock();

		if (ret && list_empty(ctx->lnk)) {
			unlock_task_sighand(ctx->task);
			ret = NULL;
		}

		return ret;
	}

instead of "spin_lock_irq(ctx->sighand)" + "if (ctx->sighand != ctx->tsk->sighand)".

Possible?

Note that signalfd_exit_task() is generic, could be used in another context,
de_thread() can avoid the call if !suid.

How about CONFIG_SIGNALFD, btw?

Davide, could you please cc me? I am not subscribed to lkml, noticed the new
version by accident.

Oleg.

