Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbZA1DFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbZA1DFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZA1DFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:05:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50141 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZA1DFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:05:08 -0500
Date: Wed, 28 Jan 2009 04:02:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alasdair G Kergon <agk@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC v2][PATCH] create workqueue threads only when needed
Message-ID: <20090128030224.GA4867@redhat.com>
References: <20090128002714.GA5086@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128002714.GA5086@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Frederic Weisbecker wrote:
>
> +static void workqueue_unshadow(struct cpu_workqueue_struct *cwq)
> +{
> +	struct workqueue_shadow *ws;
> +
> +	/* Prevent from concurrent unshadowing */
> +	if (unlikely(atomic_inc_return(&cwq->unshadowed) != 1))
> +		goto already_unshadowed;
> +
> +	/*
> +	 * The work can be inserted whatever is the context.
> +	 * But such atomic allocation will be rare and freed soon.
> +	 */
> +	ws = kmalloc(sizeof(*ws), GFP_ATOMIC);
> +	if (!ws) {
> +		WARN_ON_ONCE(1);
> +		goto already_unshadowed;
> +	}
> +	INIT_DELAYED_WORK(&ws->work, workqueue_unshadow_work);
> +	ws->cwq = cwq;
> +	schedule_delayed_work(&ws->work, 0);
> +
> +	return;
> +
> +already_unshadowed:
> +	atomic_dec(&cwq->unshadowed);
> +}

Can't understand why do you use delayed work...

I must admit, I don't like this patch. Perhaps I am wrong, mostly I
dislike the complications it adds.

Anybody else please vote for this change?

Hmm. We never reset cwq->unshadowed, so cwq->thread becomes "non-lazy"
after cpu_down() + cpu_up().

And. Of course it is not good that queue_work() can silently fail just
because GFP_ATOMIC fails. This is not acceptable, imho. But fixable.

What is not fixable is that this patch adds a subtle lock-ordering
problem. With this patch any flush_work() or flush_workqueue() or
destroy_workqueue() depend on keventd, and can deadlock if the caller
shares the lock with any work_struct on keventd.

Or. let's suppose keventd has a sleeping work_struct which waits
for the event. Now we queue the work which should "implement"
this event on !unshadowed wq - deadlock.

Another problem. workqueue_unshadow_work() populates cwq->thread and
binds it to smp_processor_id(). This is not safe, CPU can go away
after smp_processor_id() but before wake_up_process().

Oh, and schedule_delayed_work() is not right, think about queue_work_on().

>  static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
>  {
> +	DEFINE_WAIT(wait);
> +	long timeout = 0;
> +	int unshadowed = atomic_read(&cwq->unshadowed);
> +
> +	/* Shadowed => no thread has been created */
> +	if (!unshadowed)
> +		return;

This is not right, if the previous workqueue_unshadow() failed, we
can return with the pending works.

> +
>  	/*
> -	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
> -	 * cpu_add_remove_lock protects cwq->thread.
> +	 * If it's unshadowed, we want to ensure the thread creation
> +	 * has been completed.
>  	 */
> -	if (cwq->thread == NULL)
> -		return;
> +	prepare_to_wait(&cwq->thread_creation, &wait, TASK_UNINTERRUPTIBLE);
> +	if (!cwq->thread)
> +		timeout = schedule_timeout_interruptible(HZ * 3);
> +	finish_wait(&cwq->thread_creation, &wait);
> +
> +	/* We waited for 3 seconds, this is likely a soft lockup */
> +	WARN_ON(timeout);

Can't understand... If timeout != 0, then we were woken by
workqueue_unshadow_work() ?

Anyway. We should not proceed if we failed to create cwq->thread.
The kernel can crash. And of course this is not good too. Yes,
you modified flush_cpu_workqueue() to call workqueue_unshadow(),
but this can fail too. And if another thread cancels the pending
works, flush_cpu_workqueue() just returns, and we crash. Or we
can hang forever.

Also. Please note that cleanup_workqueue_thread() can also be
called by CPU_UP_CANCELED when cwq->thread == NULL because it
was never created. We should do nothing in this case, but we
will hang if cwq->unshadowed != 0.

>  		switch (action) {
>  		case CPU_UP_PREPARE:
> +			/* Will be created during the first work insertion */
> +			if (!atomic_read(&cwq->unshadowed))
> +				break;
>  			if (!create_workqueue_thread(cwq, cpu))
>  				break;
>  			printk(KERN_ERR "workqueue [%s] for %i failed\n",
> @@ -964,6 +1086,8 @@ undo:
>  			goto undo;
>
>  		case CPU_ONLINE:
> +			if (!atomic_read(&cwq->unshadowed))
> +				break;
>  			start_workqueue_thread(cwq, cpu);
>  			break;

Suppose that we have some strange cpu_callback(action, cpu)
which does:

		case CPU_UP_PREPARE:
			queue_work_on(cpu, my_wq, percpu_work);
			break;
		case CPU_UP_CANCELED:
			cancel_work_sync(percpu_work);

Currently this works. But with this patch, queue_work_on() above
can leak workqueue_shadow.

Oleg.

