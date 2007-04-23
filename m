Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbXDWQd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbXDWQd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbXDWQd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:33:27 -0400
Received: from mail.screens.ru ([213.234.233.54]:40297 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbXDWQd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:33:26 -0400
Date: Mon, 23 Apr 2007 20:33:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070423163312.GA129@tv-sign.ru>
References: <20070419002548.72689f0e.akpm@linux-foundation.org> <20070419102122.GA93@tv-sign.ru> <20070420092201.GC1695@ff.dom.local> <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423090030.GC1684@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Jarek Poplawski wrote:
>
> On Fri, Apr 20, 2007 at 09:08:36PM +0400, Oleg Nesterov wrote:
> > 
> > First, this flag should be cleared after return from cancel_rearming_delayed_work().
> 
> I think this flag, if at all, probably should be cleared only
> consciously by the owner of a work, maybe as a schedule_xxx_work
> parameter, (but shouldn't be used from work handlers for rearming).
> Mostly it should mean: we are closing (and have no time to chase
> our work)...

This will change the API. Currently it is possible to do:

	cancel_delayed_work(dwork);
	schedule_delayed_work(dwork, delay);

and we have such a code. With the change you propose this can't work.

> > Also, we should add a lot of nasty checks to workqueue.c
> 
> Checking a flag isn't nasty - it's clear. IMHO current way of checking,
> whether cancel succeeded, is nasty.
> 
> > 
> > I _think_ we can re-use WORK_STRUCT_PENDING to improve this interface.
> > Note that if we set WORK_STRUCT_PENDING, the work can't be queued, and
> > dwork->timer can't be started. The only problem is that it is not so
> > trivial to avoid races.
> 
> If there were no place, it would be better, then current way.
> But WORK_STRUCT_PENDING couldn't be used for some error checking,
> as it's now.

Look,

	void cancel_rearming_delayed_work(struct delayed_work *dwork)
	{
		struct work_struct *work = &dwork->work;
		struct cpu_workqueue_struct *cwq = get_wq_data(work);
		struct workqueue_struct *wq;
		const cpumask_t *cpu_map;
		int retry;
		int cpu;

		if (!cwq)
			return;

	retry:
		spin_lock_irq(&cwq->lock);
		list_del_init(&work->entry);
		__set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
		retry = try_to_del_timer_sync(&dwork->timer) < 0;
		spin_unlock_irq(&cwq->lock);

		if (unlikely(retry))
			goto retry;

		// the work can't be re-queued and the timer can't
		// be re-started due to WORK_STRUCT_PENDING

		wq = cwq->wq;
		cpu_map = wq_cpu_map(wq);

		for_each_cpu_mask(cpu, *cpu_map)
			wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);

		work_clear_pending(work);
	}

I think this almost works, except:

	- we should change run_workqueue() to call work_clear_pending()
	  under cwq->lock. I'd like to avoid this.

	- this is racy wrt cpu-hotplug. We should re-check get_wq_data()
	  when we take the lock. This is easy.

	- we should factor out the common code with cancel_work_sync().

I may be wrong, still had no time to concentrate on this with a "clear head".
May be tomorrow.

> > > - for a work function: to stop execution as soon as possible,
> > > even without completing the usual job, at first possible check.
> > 
> > I doubt we need this "in general". It is easy to add some flag to the
> > work_struct's container and check it in work->func() when needed.
> 
> Yes, but currently you cannot to behave like this e.g. with
> "rearming" work.

Why?

>                   And maybe a common api could save some work.

May be you are right, but still I don't think we should introduce
the new flag to implement this imho not-so-useful feature.

Oleg.

