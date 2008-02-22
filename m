Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYBVOiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYBVOiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYBVOiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:38:12 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:47113 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYBVOiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:38:11 -0500
Date: Fri, 22 Feb 2008 17:41:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
Message-ID: <20080222144155.GA4349@tv-sign.ru>
References: <47BEC663.7050904@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BEC663.7050904@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Pavel Emelyanov wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1291,10 +1291,33 @@ void sigqueue_free(struct sigqueue *q)
>  	__sigqueue_free(q);
>  }
>  
> +static int do_send_sigqueue(int sig, struct sigqueue *q, struct task_struct *t,
> +		struct sigpending *pending)
> +{
> +	if (unlikely(!list_empty(&q->list))) {
> +		/*
> +		 * If an SI_TIMER entry is already queue just increment
> +		 * the overrun count.
> +		 */
> +
> +		BUG_ON(q->info.si_code != SI_TIMER);
> +		q->info.si_overrun++;
> +		return 0;
> +	}
> +
> +	if (sig_ignored(t, sig))
> +		return 1;
> +
> +	signalfd_notify(t, sig);
> +	list_add_tail(&q->list, &pending->list);
> +	sigaddset(&pending->signal, sig);
> +	return 0;
> +}
> +
>  int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
>  {
>  	unsigned long flags;
> -	int ret = 0;
> +	int ret = -1;
>  
>  	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>  
> @@ -1308,37 +1331,14 @@ int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
>  	 */
>  	rcu_read_lock();
>  
> -	if (!likely(lock_task_sighand(p, &flags))) {
> -		ret = -1;
> +	if (!likely(lock_task_sighand(p, &flags)))
>  		goto out_err;
> -	}
>  
> -	if (unlikely(!list_empty(&q->list))) {
> -		/*
> -		 * If an SI_TIMER entry is already queue just increment
> -		 * the overrun count.
> -		 */
> -		BUG_ON(q->info.si_code != SI_TIMER);
> -		q->info.si_overrun++;
> -		goto out;
> -	}
> -	/* Short-circuit ignored signals.  */
> -	if (sig_ignored(p, sig)) {
> -		ret = 1;
> -		goto out;
> -	}
> -	/*
> -	 * Deliver the signal to listening signalfds. This must be called
> -	 * with the sighand lock held.
> -	 */
> -	signalfd_notify(p, sig);
> +	ret = do_send_sigqueue(sig, q, p, &p->pending);
>  
> -	list_add_tail(&q->list, &p->pending.list);
> -	sigaddset(&p->pending.signal, sig);
>  	if (!sigismember(&p->blocked, sig))
>  		signal_wake_up(p, sig == SIGKILL);
>  
> -out:
>  	unlock_task_sighand(p, &flags);
>  out_err:
>  	rcu_read_unlock();
> @@ -1350,7 +1350,7 @@ int
>  send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
>  {
>  	unsigned long flags;
> -	int ret = 0;
> +	int ret;
>  
>  	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>  
> @@ -1359,38 +1359,10 @@ send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
>  	spin_lock_irqsave(&p->sighand->siglock, flags);
>  	handle_stop_signal(sig, p);
>  
> -	/* Short-circuit ignored signals.  */
> -	if (sig_ignored(p, sig)) {
> -		ret = 1;
> -		goto out;
> -	}
> -
> -	if (unlikely(!list_empty(&q->list))) {
> -		/*
> -		 * If an SI_TIMER entry is already queue just increment
> -		 * the overrun count.  Other uses should not try to
> -		 * send the signal multiple times.
> -		 */
> -		BUG_ON(q->info.si_code != SI_TIMER);
> -		q->info.si_overrun++;
> -		goto out;
> -	} 
> -	/*
> -	 * Deliver the signal to listening signalfds. This must be called
> -	 * with the sighand lock held.
> -	 */
> -	signalfd_notify(p, sig);
> -
> -	/*
> -	 * Put this signal on the shared-pending queue.
> -	 * We always use the shared queue for process-wide signals,
> -	 * to avoid several races.
> -	 */
> -	list_add_tail(&q->list, &p->signal->shared_pending.list);
> -	sigaddset(&p->signal->shared_pending.signal, sig);
> +	ret = do_send_sigqueue(sig, q, p, &p->signal->shared_pending);
>  
>  	__group_complete_signal(sig, p);
> -out:
> +
>  	spin_unlock_irqrestore(&p->sighand->siglock, flags);
>  	read_unlock(&tasklist_lock);
>  	return ret;
> -- 

Personally, I think this change is very good. But send_sigqueue() and
send_group_sigqueue() have a very subtle difference which I was never
able to understand.

Let's suppose that sigqueue is already queued, and the signal is ignored
(the latter means we should re-schedule cpu timer or handle overrruns).
In that case send_sigqueue() returns 0, but send_group_sigqueue() returns 1.

I think this is not the problem (in fact, I think this patch makes the
behaviour more correct), but I hope Thomas can take a look and confirm.

Oleg.

