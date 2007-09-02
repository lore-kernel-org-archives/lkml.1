Return-Path: <linux-kernel-owner+w=401wt.eu-S965383AbXIBMQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965383AbXIBMQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbXIBMQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:16:31 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48331 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbXIBMQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:16:30 -0400
Date: Sun, 2 Sep 2007 16:19:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: [RFC + PATCH] signalfd simplification
Message-ID: <20070902121943.GA141@tv-sign.ru>
References: <Pine.LNX.4.64.0709011618280.4045@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709011618280.4045@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Davide Libenzi wrote:
>
> I'm playing at the moment with this patch, that recall Ben's idea  of 
> attaching to the sighand only during read/poll, and calling dequeue_signal()
> only with "current". This simplifies the signalfd logic quite a bit.
> If this patch is applied, a task calling signalfd can read its own private 
> signals, and its own group signals.
>
>  fs/exec.c                 |    3 
>  fs/signalfd.c             |  186 +++++++---------------------------------------
>  include/linux/init_task.h |    2 
>  include/linux/sched.h     |    2 
>  include/linux/signalfd.h  |   29 -------
>  kernel/exit.c             |    9 --
>  kernel/fork.c             |    2 
>  kernel/signal.c           |    8 -
>  8 files changed, 40 insertions(+), 201 deletions(-)

Imho, very very nice. We lose the ability to read the cross-process signals,
but I doubt very much we should regret about that.

I cc'ed Michael, because it makes sense to document a user-visible change.
With this patch, the forked child reads its own signals (not parent's) via
the inherited signalfd (or if it was passed with unix socket).

Small problem: unless I missed something, signalfd_deliver() and sys_signalfd()
should use wake_up_all(), not wake_up() which implies nr_exclusive == 1.

It is possible that we have multiple threads waiting on ->signalfd_wqh with
the the different ->sigmask. In this case, the first woken thread can ignore
the signal, we should wake up all of them.

We can optimize this later, using a "clever" wait_queue_func_t if needed.

> +	spin_lock_irq(&current->sighand->siglock);
> +	if (next_signal(&current->pending, &ctx->sigmask) > 0 ||
> +	    next_signal(&current->signal->shared_pending,
> +			&ctx->sigmask) > 0)

Very minor nit: next_signal() always returns the value >= 0, imho the "> 0"
check looks a bit confusing.

Oleg.

