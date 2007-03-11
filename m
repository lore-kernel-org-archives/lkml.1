Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXCKMCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXCKMCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbXCKMCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:02:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:57738 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933264AbXCKMCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:02:30 -0400
Date: Sun, 11 Mar 2007 15:02:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/9] signalfd/timerfd - signalfd core ...
Message-ID: <20070311120242.GA103@tv-sign.ru>
References: <Pine.LNX.4.64.0703101821580.3613@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703101821580.3613@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Davide Libenzi wrote:
>
> +static void signalfd_put_sighand(struct signalfd_ctx *ctx,
> +				 struct sighand_struct *sighand,
> +				 unsigned long *flags)
> +{
> +	unlock_task_sighand(ctx->tsk, flags);
> +}

Note that signalfd_put_sighand() doesn't need "sighand" parameter, please
see below.

> +int signalfd_deliver(struct sighand_struct *sighand, int sig,
> +		     struct siginfo *info)
> +{
> +	int nsig = 0;
> +	struct signalfd_ctx *ctx, *tmp;
> +
> +	list_for_each_entry_safe(ctx, tmp, &sighand->sfdlist, lnk) {
> +		/*
> +		 * We use a negative signal value as a way to broadcast that the
> +		 * sighand has been orphaned, so that we can notify all the
> +		 * listeners about this. Remeber the ctx->sigmask is inverted,
> +		 * so if the user is interested in a signal, that corresponding
> +		 * bit will be zero.
> +		 */
> +		if (sig < 0)
> +			list_del_init(&ctx->lnk);

I'm afraid this is not right. This should be per-thread.

Suppose we have threads T1 and T2 from the same thread group. sighand->sfdlist
contains ctx1 and ctx2 "linked" to T1 and T2. Now, T1 exits, __exit_signal()
does signalfd_notify(sighand, -1), and "unlinks" all threads, not just T1.

IOW, we should do

	if (ctx->tsk == current) {
		list_del_init(&ctx->lnk);
		wake_up(&ctx->wqh);
	}

Perhaps it makes sense to not re-use signalfd_deliver(), but introduce
a new signalfd_xxx(sighand, tsk) helper for de_thread/exit_signal.

Btw, signalfd_deliver() doesn't use "info" parameter.

> +		if (sig < 0 || !sigismember(&ctx->sigmask, sig)) {
> +			wake_up(&ctx->wqh);

Minor nit. Perhaps it makes sense to do

	void signalfd_deliver(struct task_struct *tsk, int sig, struct sigpending *pending)
	{
		struct sighand_struct *sighand = tsk->sighand;
		int private = (tsk->pending == pending);

		list_for_each_entry_safe(ctx, tmp, &sighand->sfdlist, lnk) {
			if (private && ctx->tsk != tsk)
				continue;
			if (!sigismember(&ctx->sigmask, sig))
				wake_up(&ctx->wqh);
		}
	}

Even better: signalfd_deliver(struct task_struct *tsk, int sig, int private).
This way specific_send_sig_info/send_sigqueue won't do a "false" wakeup.

> +asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
> +{
> ...
> +		if ((sighand = signalfd_get_sighand(ctx, &flags)) != NULL) {
> +			ctx->sigmask = sigmask;
> +			signalfd_put_sighand(ctx, sighand, &flags);
> +		}

This looks like unneeded complication to me, I'd suggest

		if (signalfd_get_sighand(ctx, &flags)) {
			ctx->sigmask = sigmask;
			signalfd_put_sighand(ctx, flags);
		}

unlock_task_sighand() (and thus signalfd_put_sighand) doesn't need "sighand"
parameter. signalfd_get_sighand() is in fact boolean. It makes sense to return
sighand, it may be useful, but this patch only needs != NULL.

Every usage of signalfd_get_sighand() could be simplified accordingly.

> --- linux-2.6.20.ep2.orig/fs/exec.c	2007-03-10 15:57:00.000000000 -0800
> +++ linux-2.6.20.ep2/fs/exec.c	2007-03-10 15:57:51.000000000 -0800
> @@ -50,6 +50,7 @@
>  #include <linux/tsacct_kern.h>
>  #include <linux/cn_proc.h>
>  #include <linux/audit.h>
> +#include <linux/signalfd.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/mmu_context.h>
> @@ -583,6 +584,17 @@
>  	int count;
>  
>  	/*
> +	 * Tell all the sighand listeners that this sighand has
> +	 * been detached. Needs to be called with the sighand lock
> +	 * held.
> +	 */
> +	if (unlikely(!list_empty(&oldsighand->sfdlist))) {
> +		spin_lock_irq(&oldsighand->siglock);
> +		signalfd_notify(oldsighand, -1, NULL);
> +		spin_unlock_irq(&oldsighand->siglock);
> +	}

Very minor nit. I'd suggest to make a new helper and put it in signalfd.h
(like signalfd_notify()). This will help CONFIG_SIGNALFD.

I still think that we should do this only for suid-exec. If application
passes a signalfd to another process with unix socket, it should know
what it does. But yes, I agree, we can change this later if needed.
(in that case the caller of the above helper should be flush_old_exec).

Oleg.

