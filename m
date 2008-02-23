Return-Path: <linux-kernel-owner+w=401wt.eu-S1760189AbYBWQXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbYBWQXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYBWQXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:23:10 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:38225 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbYBWQXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:23:09 -0500
Date: Sat, 23 Feb 2008 19:27:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dmitry.adamushko@gmail.com,
       a.p.zijlstra@chello.nl, apw@shadowen.org, mingo@elte.hu,
       nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch added to -mm tree
Message-ID: <20080223162705.GA7686@tv-sign.ru>
References: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(s/mm-commits/lkml, cc Steven and Linus).

On 02/22, Andrew Morton wrote:
> 
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> We must ensure that kthread_stop_info.k has been updated before kthread's
> wakeup.  This is required to properly support the use of kthread_should_stop()
> in the main loop of kthread.
> 
> wake_up_process() doesn't imply a full memory barrier,
> so we add an explicit one.

I tried to raise the similar issue twice without success.

> --- a/kernel/kthread.c~kthread-add-a-missing-memory-barrier-to-kthread_stop
> +++ a/kernel/kthread.c
> @@ -53,6 +53,19 @@ static struct kthread_stop_info kthread_
>   * When someone calls kthread_stop() on your kthread, it will be woken
>   * and this will return true.  You should then return, and your return
>   * value will be passed through to kthread_stop().
> + *
> + * In order to safely use kthread_stop() for kthread, there is a requirement
> + * on how its main loop has to be orginized. Namely, the sequence of
> + * events that lead to kthread being blocked (schedule()) has to be
> + * ordered as follows:
> + *
> + * - set_current_state(TASK_INTERRUPTIBLE);
> + * - if (kthread_should_stop()) break;
> + * - schedule() or similar.
> + *
> + * set_current_state() implies a full memory barrier. kthread_stop()
> + * has a matching barrier right after an update of kthread_stop_info.k
> + * and before kthread's wakeup.
>   */
>  int kthread_should_stop(void)
>  {
> @@ -211,6 +224,15 @@ int kthread_stop(struct task_struct *k)
>  
>  	/* Now set kthread_should_stop() to true, and wake it up. */
>  	kthread_stop_info.k = k;
> +
> +	/*
> +	 * We must ensure that kthread_stop_info.k has been updated before
> +	 * the following wakeup. This is required to properly support the use
> +	 * of kthread_should_stop() in the main loop of kthread
> +	 * (see description of kthread_should_stop() for more details).
> +	 */
> +	smp_mb();
> +
>  	wake_up_process(k);
>  	put_task_struct(k);

I think we should fix wake_up_process() instead.

Please look at http://marc.info/?l=linux-kernel&m=118503598307267
and at this thread: http://marc.info/?t=116275561700001

In short: wake_up_process() doesn't imply mb(), this means that _in theory_
the commonly used code like

	set_current_state(TASK_INTERRUPTIBLE);
	if (CONDITION)
		return;
	schedule();

is racy wrt

	CONDITION = 1;
	wake_up_process(p);

I'll be happy to be wrong though, please correct me.

Oleg.

