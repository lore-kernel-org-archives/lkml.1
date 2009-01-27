Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZA0Btk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZA0Btk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 20:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZA0Btc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 20:49:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33219 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbZA0Btb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 20:49:31 -0500
Date: Tue, 27 Jan 2009 02:46:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090127014651.GA13861@redhat.com>
References: <20090127001708.GA4815@nowhere> <20090126162807.1131c777.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126162807.1131c777.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>  static void insert_work(struct cpu_workqueue_struct *cwq,
>  			struct work_struct *work, struct list_head *head)
>  {
> -	trace_workqueue_insertion(cwq->thread, work);
> +	trace_workqueue_insertion(cwq->thread, work, cwq->wq->singlethread);
>
>  	set_wq_data(work, cwq);
>  	/*
> @@ -148,6 +176,9 @@ static void __queue_work(struct cpu_workqueue_struct *cwq,
>  {
>  	unsigned long flags;
>
> +	if (!cwq->thread)
> +		create_wq_thread_late(cwq);
> +

[...snip...]

> +static void create_wq_thread_late_work(struct work_struct *work)
> +{
> +	struct late_workqueue_creation_data *l;
> +	struct cpu_workqueue_struct *cwq;
> +	int cpu = smp_processor_id();
> +	int err = 0;
> +
> +	l = container_of(work, struct late_workqueue_creation_data, work);
> +	cwq = l->cwq;
> +
> +	if (is_wq_single_threaded(cwq->wq)) {
> +		err = create_workqueue_thread(cwq, singlethread_cpu);
> +		start_workqueue_thread(cwq, -1);
> +	} else {
> +		err = create_workqueue_thread(cwq, cpu);
> +		start_workqueue_thread(cwq, cpu);
> +	}
> +	WARN_ON_ONCE(err);
> +	kfree(l);
> +}

Let's suppose the workqueue was just created, and cwq->thared == NULL
on (say) CPU 0.

Then CPU 0 does

	queue_work(wq, work1);
	queue_work(wq, work2);

Both these calls will notice cwq->thread == NULL, both will schedule
the work wilth ->func = create_wq_thread_late_work.

The first work correctly creates cwq->thread, the second one creates
the new thread too and replaces cwq->thread? Now we have two threads
which run in parallel doing the same work, but the first thread is
"stealth", no?

> @@ -904,9 +967,12 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
>  	 * checks list_empty(), and a "normal" queue_work() can't use
>  	 * a dead CPU.
>  	 */
> -	trace_workqueue_destruction(cwq->thread);
> -	kthread_stop(cwq->thread);
> -	cwq->thread = NULL;
> +
> +	if (cwq->thread) {
> +		trace_workqueue_destruction(cwq->thread, cwq->wq->singlethread);
> +		kthread_stop(cwq->thread);
> +		cwq->thread = NULL;
> +	}

cleanup_workqueue_thread() has already checked cwq->thread != NULL,
how can it become NULL ?

And let's suppose a user does:

	wq = create_workqueue(...., when_needed => 1);
	queue_work(wq, some_work);
	destroy_workqueue(wq);

This can return before create_wq_thread_late() populates the necessary
cwq->thread. We can destroy/free workqueue with the pending work_structs,
no?

Oleg.

