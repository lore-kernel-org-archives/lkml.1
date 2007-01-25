Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXAYQWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXAYQWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030298AbXAYQWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:22:18 -0500
Received: from mail.screens.ru ([213.234.233.54]:39025 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030302AbXAYQWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:22:16 -0500
Date: Thu, 25 Jan 2007 19:21:41 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Sebastien Dugue <sebastien.dugue@bull.net>,
       Laurent Vivier <laurent.vivier@bull.net>
Cc: Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: + aio-completion-signal-notification.patch added to -mm tree
Message-ID: <20070125162141.GA226@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastien Dugue wrote:
>
> +static long aio_setup_sigevent(struct aio_notify *notify,
> +			       struct sigevent __user *user_event)
> +{
> +	sigevent_t event;
> +	struct task_struct *target;
> +
> +	if (copy_from_user(&event, user_event, sizeof(event)))
> +		return -EFAULT;
> +
> +	if (event.sigev_notify == SIGEV_NONE)
> +		return 0;
> +
> +	notify->notify = event.sigev_notify;
> +	notify->signo = event.sigev_signo;
> +	notify->value = event.sigev_value;
> +
> +	read_lock(&tasklist_lock);

We don't need tasklist_lock, we can use rcu_read_lock() instead.

> +	target = good_sigevent(&event);
> +
> +	if (unlikely(!target || (target->flags & PF_EXITING)))
> +		goto out_unlock;

PF_EXITING check is racy and unneded. In fact, it is wrong. If the main
thread is already died, we can only use SIGEV_THREAD_ID signals, because
otherwise good_sigevent() returns ->group_leader.

> @@ -994,6 +1077,15 @@ int fastcall aio_complete(struct kiocb *
>  	kunmap_atomic(ring, KM_IRQ1);
>
>  	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
> +
> +	if (iocb->ki_notify.notify != SIGEV_NONE) {
> +		ret = aio_send_signal(&iocb->ki_notify);
> +
> +		/* If signal generation failed, release the sigqueue */
> +		if (ret)
> +			sigqueue_free(iocb->ki_notify.sigq);

We should not use sigqueue_free() here. It takes current->sighand->siglock
to remove sigqueue from "struct sigpending". But current is just a "random"
process here.

Yes, if I understand this patch correctly, it is not possible that this
sigqueue is pending, but still this is bad imho.

>  static void __sigqueue_free(struct sigqueue *q)
>  {
> -	if (q->flags & SIGQUEUE_PREALLOC)
> +	if (q->flags & SIGQUEUE_PREALLOC && q->info.si_code != SI_ASYNCIO)
>  		return;

Oh, this is not nice. Could we change send_sigqueue/send_group_sigqueue
instead ?

-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC) && q->info.si_code != SI_ASYNCIO);

This way aio can use __sigqueue_alloc/__sigqueue_free directly and forget
about SIGQUEUE_PREALLOC.

On the other hand, imho this patch takes a wrong direction.

The purpose of SIGQUEUE_PREALLOC + send_sigqueue() is to re-use the same
sigqueue while sending a stream of signals. But in aio case we allocate
sigqueue to send only 1 signal, then it freed after the delivery like
the regular sigqueue. So what is the point?

I'd suggest to not use this interface. Just use group_send_sig_info() or
specific_send_sig_info(). Yes, this way we will do GFP_ATOMIC allocation
of sigqueue in interrupt context, but is this so bad in this case?

Oleg.

