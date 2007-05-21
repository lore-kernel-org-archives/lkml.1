Return-Path: <linux-kernel-owner+w=401wt.eu-S934937AbXEUTk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937AbXEUTk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933537AbXEUT07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:26:59 -0400
Received: from mail.screens.ru ([213.234.233.54]:50212 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933536AbXEUT05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:26:57 -0400
Date: Mon, 21 May 2007 23:25:51 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Davi E. M. Arnaut" <davi@haxent.com.br>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + signalfd-retrieve-multiple-signals-with-one-read-call.patch added to -mm tree
Message-ID: <20070521192551.GA153@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of very minor nits,

> +static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
> +				int nonblock)
> +{
> +	int locked;
> +	ssize_t ret;
> +	struct signalfd_lockctx lk;
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	locked = signalfd_lock(ctx, &lk);
> +	if (!locked)
> +		return 0;
> +
> +	ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
> +	switch (ret) {
> +	case 0:
> +		if (!nonblock)
> +			break;
> +		ret = -EAGAIN;
> +	default:
> +		signalfd_unlock(&lk);
> +		return ret;
> +	}
> +
> +	add_wait_queue(&ctx->wqh, &wait);
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
> +		if (ret != 0)
> +			break;
> +		if (signal_pending(current)) {
> +			ret = -ERESTARTSYS;
> +			break;
> +		}
> +		signalfd_unlock(&lk);

The locking looks a bit overcomplicated. We don't need signalfd_lock() to
check ret != 0 or signal_pending(), we can drop it earlier. This way we
always leave the loop in "unlocked" state.

> +		schedule();
> +		locked = signalfd_lock(ctx, &lk);
> +		if (unlikely(!locked)) {
> +			/*
> +			 * Let the caller read zero byte, ala socket
> +			 * recv() when the peer disconnect. This test
> +			 * must be done before doing a dequeue_signal(),
> +			 * because if the sighand has been orphaned,
> +			 * the dequeue_signal() call is going to crash.
> +			 */

Imho, the comment is a bit confusing. dequeue_signal() needs ->siglock
even if signalfd_ctx is not orphaned.

> +			 ret = 0;
> +			 break;
> +		}
> +	}
> +
> +	remove_wait_queue(&ctx->wqh, &wait);
> +	__set_current_state(TASK_RUNNING);
> +
> +	if (likely(locked))
> +		signalfd_unlock(&lk);
> +
> +	return ret;
> +}

IOW, how about this?

	static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
					int nonblock)
	{
		ssize_t ret;
		struct signalfd_lockctx lk;
		DECLARE_WAITQUEUE(wait, current);

		if (!signalfd_lock(ctx, &lk))
			return 0;

		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
		switch (ret) {
		case 0:
			if (!nonblock)
				break;
			ret = -EAGAIN;
		default:
			signalfd_unlock(&lk);
			return ret;
		}

		add_wait_queue(&ctx->wqh, &wait);
		for (;;) {
			set_current_state(TASK_INTERRUPTIBLE);
			ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
			signalfd_unlock(&lk);

			if (ret != 0)
				break;

			ret = -ERESTARTSYS;
			if (signal_pending(current))
				break;

			schedule();

			ret = 0;
			if (!signalfd_lock(ctx, &lk))
				break;
		}

		remove_wait_queue(&ctx->wqh, &wait);
		__set_current_state(TASK_RUNNING);

		return ret;
	}

Oleg.

