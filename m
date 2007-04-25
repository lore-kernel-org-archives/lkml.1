Return-Path: <linux-kernel-owner+w=401wt.eu-S1423220AbXDYGGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423220AbXDYGGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423222AbXDYGGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:06:38 -0400
Received: from mx12.go2.pl ([193.17.41.142]:39271 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423220AbXDYGGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:06:37 -0400
Date: Wed, 25 Apr 2007 08:12:26 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070425061226.GA1613@ff.dom.local>
References: <20070419002548.72689f0e.akpm@linux-foundation.org> <20070419102122.GA93@tv-sign.ru> <20070420092201.GC1695@ff.dom.local> <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424185537.GA5029@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 10:55:37PM +0400, Oleg Nesterov wrote:
> On 04/24, Jarek Poplawski wrote:
> >
> > This looks fine. Of course, it requires to remove some debugging
> > currently done with _PENDING flag
> 
> For example?

Sorry!!! I don't know where I've seen those flags - maybe it's
something with my coffee...

> 
> >                                    and it's hard to estimate this
> > all before you do more, but it should be more foreseeable than
> > current way. But the races with _PENDING could be really "funny"
> > without locking it everywhere.
> 
> Please see the patch below. Do you see any problems? I'll send it
> when I have time to re-read the code and write some tests. I still
> hope we can find a way to avoid the change in run_workqueue()...
> 
> Note that cancel_rearming_delayed_work() now can handle the works
> which re-arm itself via queue_work(), not only queue_delayed_work().
> 
> Note also we can change cancel_work_sync(), so it can deal with the
> self rearming work_structs.
> 
> >                                 BTW - are a few locks more a real
> > problem, while serving a "sleeping" path? And I don't think there
> > is any reason to hurry... 
> 
> Sorry, could you clarify what you mean?

I don't understand your unwillingnes e.g. with this run_workqueue
lock. If it's about performance, do you think the clients of
workqueue could care very much?

> 
> > > > Yes, but currently you cannot to behave like this e.g. with
> > > > "rearming" work.
> > > 
> > > Why?
> > 
> > OK, it's not impossible, but needs some bothering: if I simply
> > set some flag and my work function exits before rearming -
> > cancel_rearming_delayed_work can loop.
> 
> Yes sure. I meant "after we fix the problems you pointed out".
> 
> Oleg.
> 
> --- OLD/kernel/workqueue.c~1_CRDW	2007-04-13 17:43:23.000000000 +0400
> +++ OLD/kernel/workqueue.c	2007-04-24 22:41:15.000000000 +0400
> @@ -242,11 +242,11 @@ static void run_workqueue(struct cpu_wor
>  		work_func_t f = work->func;
>  
>  		cwq->current_work = work;
> -		list_del_init(cwq->worklist.next);
> +		list_del_init(&work->entry);
> +		work_clear_pending(work);
>  		spin_unlock_irq(&cwq->lock);
>  
>  		BUG_ON(get_wq_data(work) != cwq);
> -		work_clear_pending(work);
>  		f(work);
>  
>  		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
> @@ -398,6 +398,16 @@ static void wait_on_work(struct cpu_work
>  		wait_for_completion(&barr.done);
>  }
>  
> +static void needs_a_good_name(struct workqueue_struct *wq,
> +				struct work_struct *work)
> +{
> +	const cpumask_t *cpu_map = wq_cpu_map(wq);
> +	int cpu;
> +
> +	for_each_cpu_mask(cpu, *cpu_map)
> +		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
> +}
> +
>  /**
>   * cancel_work_sync - block until a work_struct's callback has terminated
>   * @work: the work which is to be flushed
> @@ -414,9 +424,6 @@ static void wait_on_work(struct cpu_work
>  void cancel_work_sync(struct work_struct *work)
>  {
>  	struct cpu_workqueue_struct *cwq;
> -	struct workqueue_struct *wq;
> -	const cpumask_t *cpu_map;
> -	int cpu;
>  
>  	might_sleep();
>  
> @@ -434,15 +441,10 @@ void cancel_work_sync(struct work_struct
>  	work_clear_pending(work);
>  	spin_unlock_irq(&cwq->lock);
>  
> -	wq = cwq->wq;
> -	cpu_map = wq_cpu_map(wq);
> -
> -	for_each_cpu_mask(cpu, *cpu_map)
> -		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
> +	needs_a_good_name(cwq->wq, work);
>  }
>  EXPORT_SYMBOL_GPL(cancel_work_sync);
>  
> -
>  static struct workqueue_struct *keventd_wq;
>  
>  /**
> @@ -532,22 +534,34 @@ EXPORT_SYMBOL(flush_scheduled_work);
>  /**
>   * cancel_rearming_delayed_work - kill off a delayed work whose handler rearms the delayed work.
>   * @dwork: the delayed work struct
> - *
> - * Note that the work callback function may still be running on return from
> - * cancel_delayed_work(). Run flush_workqueue() or cancel_work_sync() to wait
> - * on it.
>   */
>  void cancel_rearming_delayed_work(struct delayed_work *dwork)
>  {
> -	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
> -
> -	/* Was it ever queued ? */
> -	if (cwq != NULL) {
> -		struct workqueue_struct *wq = cwq->wq;
> -
> -		while (!cancel_delayed_work(dwork))
> -			flush_workqueue(wq);
> -	}
> +	struct work_struct *work = &dwork->work;
> +	struct cpu_workqueue_struct *cwq = get_wq_data(work);
> +	int retry;
> +
> +	if (!cwq)
> +		return;
> +
> +	do {
> +		retry = 1;
> +		spin_lock_irq(&cwq->lock);
> +		/* CPU_DEAD in progress may change cwq */
> +		if (likely(cwq == get_wq_data(work))) {
> +			list_del_init(&work->entry);
> +			__set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
> +			retry = try_to_del_timer_sync(&dwork->timer) < 0;
> +		}
> +		spin_unlock_irq(&cwq->lock);
> +	} while (unlikely(retry));
> +
> +	/*
> +	 * Nobody can clear WORK_STRUCT_PENDING. This means that the
> +	 * work can't be re-queued and the timer can't be re-started.
> +	 */

I've some doubts, yet. Probably there are two week places:

1. If delayed_work_timer_fn of this work is fired and is waiting
on the above spin_lock then, after above spin_unlock, the work
will be queued. Probably this is also possible without timer i.e.
with queue_work.

2. If this function is fired after setting _PENDING flag in
queue_delayed_work_on, but before add_timer, this
try_to_del_timer_sync loop would miss this, too.

I found this analysing your first proposal, so I can miss
something new, but at the first glance this looks alike.

> +	needs_a_good_name(cwq->wq, work);
> +	work_clear_pending(work);
>  }
>  EXPORT_SYMBOL(cancel_rearming_delayed_work);

So, if you could clear my doubts plus some more time,
for new things, and I'll be happy with this tomorrow,
I hope!

Regards,
Jarek P.
