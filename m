Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXCTAMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXCTAMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXCTAMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:12:55 -0400
Received: from mail.screens.ru ([213.234.233.54]:34128 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030776AbXCTAMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:12:54 -0400
Date: Tue, 20 Mar 2007 03:13:10 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 2/13] signal/timer/event fds v7 - signalfd core ...
Message-ID: <20070320001310.GA327@tv-sign.ru>
References: <send-serie.davidel@xmailserver.org.15249.1174348071.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <send-serie.davidel@xmailserver.org.15249.1174348071.2>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Davide Libenzi wrote:
>
> +struct signalfd_lockctx {
> +	struct task_struct *tsk;
> +	struct sighand_struct *sighand;
> +	unsigned long flags;
> +};

signalfd_lockctx is "private" to signalfd_lock/signalfd_unlock. But lk->sighand
is used only by signalfd_lock(). I'd suggest to remove it.

> +void signalfd_deliver(struct task_struct *tsk, int sig)
> +{
> +	struct sighand_struct *sighand = tsk->sighand;
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
> +		if (sig < 0) {
> +			if (ctx->tsk == tsk) {
> +				ctx->tsk = NULL;
> +				list_del_init(&ctx->lnk);
> +				wake_up(&ctx->wqh);
> +			}
> +		} else if (sig > 0) {
> +			if (!sigismember(&ctx->sigmask, sig))
> +				wake_up(&ctx->wqh);
> +		}
> +	}
> +}

I tried to avoid this comment, but can't help myself :)

This is a matter of taste, of course, but imho this is a classical "hide the
problem" example.

Why "else if (sig > 0)" ? sig can't be == 0. In my opinion, it is better to
add BUG_ON(!sig), but use just "else".

Oleg.

