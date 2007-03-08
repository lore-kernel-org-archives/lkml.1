Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbXCHUnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbXCHUnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933188AbXCHUnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:43:49 -0500
Received: from mail.screens.ru ([213.234.233.54]:42739 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbXCHUnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:43:47 -0500
Date: Thu, 8 Mar 2007 23:43:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@argo.co.il>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
Message-ID: <20070308204353.GA6733@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
>
> +int signalfd_deliver(struct sighand_struct *sighand, int sig, struct siginfo *info)
> +{
> +	int nsig = 0;
> +	struct list_head *pos;
> +	struct signalfd_ctx *ctx;
> +	struct signalfd_sq *sq;
> +
> +	list_for_each(pos, &sighand->sfdlist) {
> +		ctx = list_entry(pos, struct signalfd_ctx, lnk);
> +		/*
> +		 * We use a negative signal value as a way to broadcast that the
> +		 * sighand has been orphaned, so that we can notify all the
> +		 * listeners about this.
> +		 */
> +		if (sig < 0)
> +			__wake_up_locked(&ctx->wqh, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);
> +		else if (sigismember(&ctx->sigmask, sig) &&
> +			 (sig >= SIGRTMIN || !sigismember(&ctx->pending, sig))) {
> +			sigaddset(&ctx->pending, sig);

I don't understand the "(sig >= SIGRTMIN || !sigismember(&ctx->pending, sig))"
check. This mimics the LEGACY_QUEUE() check, but seems strange. The signal may
be pending in ctx->pending just because it was not signalfd_fetchsig()ed, yes?

Please also see below.

> +asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
> +{
>
> [...snip...]
>
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

Can't this race with sys_signalfd_dequeue() which use lockless __add_wait_queue()?
Looks like we should do __wake_up_locked() under ctx->sighand->siglock.

> --- linux-2.6.20.ep2.orig/kernel/signal.c	2007-03-07 15:55:43.000000000 -0800
> +++ linux-2.6.20.ep2/kernel/signal.c	2007-03-07 15:59:01.000000000 -0800
>
> [...snip...]
>
> @@ -780,6 +785,11 @@
>  	BUG_ON(!irqs_disabled());
>  	assert_spin_locked(&t->sighand->siglock);
>  
> +	/*
> +	 * Deliver the signal to listening signalfds ...
> +	 */
> +	signalfd_notify(t->sighand, sig, info);
> +
>  	/* Short-circuit ignored signals.  */
>  	if (sig_ignored(t, sig))
>  		goto out;
> @@ -968,6 +978,11 @@
>  	assert_spin_locked(&p->sighand->siglock);
>  	handle_stop_signal(sig, p);
>  
> +	/*
> +	 * Deliver the signal to listening signalfds ...
> +	 */
> +	signalfd_notify(p->sighand, sig, info);
> +
>  	/* Short-circuit ignored signals.  */
>  	if (sig_ignored(p, sig))
>  		return ret;

It is strange that we are doing signalfd_notify() even if the signal is ignored.
Isn't it better to shift signalfd_notify() into send_signal() ? This way we do
not need the special check in signalfd_deliver() above.

Also, this patch doesn't take send_sigqueue/send_group_sigqueue into account.

Oleg.

