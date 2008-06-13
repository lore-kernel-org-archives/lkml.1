Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYFMOZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYFMOZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYFMOZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:25:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51048 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbYFMOZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:25:04 -0400
Date: Fri, 13 Jun 2008 18:26:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of "int tail"
Message-ID: <20080613142658.GA9147@tv-sign.ru>
References: <20080612165120.GA12177@tv-sign.ru> <20080612165550.GA12183@tv-sign.ru> <1213290074.31518.136.camel@twins> <20080612174433.GA12204@tv-sign.ru> <1213295939.31518.159.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213295939.31518.159.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Peter Zijlstra wrote:
>
> On Thu, 2008-06-12 at 21:44 +0400, Oleg Nesterov wrote:
>
> > > Hence that idea of flush context and completions.
> >
> > Do you mean something like (just for example) below? If yes, then yes
> > sure, flush_work() is limited. But I can't see how it is possible to
> > "generalize" this idea.
> >
> > (hmm... actually, if we add flush_work(), we can speedup schedule_on_each_cpu(),
> >  instead of flush_workqueue(keventd_wq) we can do
> >
> > 	for_each_online_cpu(cpu)
> > 		flush_work(per_cpu_ptr(works, cpu));
> >
> >  not sure this really makes sense though).
>
> Speedups are always nice ;-),

OK, I'm sending the patch.

> but the below also gets us there.

yeah, and it needs only 1 wakeup. But otoh it is much more complex :(

> > +struct xxx
> > +{
> > +	atomic_t count;
> > +	struct completion done;
> > +	work_func_t func;
> > +};
> > +
> > +struct yyy
> > +{
> > +	struct work_struct work;
> > +	struct xxx *xxx;
> > +};
> > +
> > +static void yyy_func(struct work_struct *work)
> > +{
> > +	struct xxx *xxx = container_of(work, struct yyy, work)->xxx;
> > +	xxx->func(work);
> > +
> > +	if (atomic_dec_and_test(&xxx->count))
> > +		complete(&xxx->done);
> > +}
> > ...
>
> Yes, along those lines.
>
> you can call xxx a flush_context and create an interface like:
>
> int queue_work_contex(struct workqueue_struct *wq,
> 		      struct flush_context *fc, struct work_struct *work)
> {
> 	work->context = fc;
> 	return queue_work(wq, work);
> }
>
> void flush_workqueue_context(struct workqueue_strucy *wq, t
> 			     struct flush_context *fc)
> {
> 	if (atomic_read(&context->count))
> 		wait_for_completion(&fc->completion);
> 	/* except that the above is racy, wait_event() comes to mind */
> }
>
> of course run_workqueue() would then need to be augmented with something
> like:
>
>   context = work->context;
>   ...
>   f(work);
>   ...
>   if (context && atomic_dec_and_test(&context->count))
>     complete(&context->done);

> also, I seem to have quitely ignored the fact that struct work doesn't
> have the context pointer, and growing it unconditionally like this isn't
> nice - hummm,. perhaps we have a bit left in data and can signify a
> larger struct work_struct.. ?

Yes, we have a free bit... but afaics we can do better.

	struct context_barrier {
		struct work_struct   work;
		struct flush_context *fc;
		...
	}

	void context_barrier_barrier_func(struct work_struct *work)
	{
		struct flush_context *fc = container_of();
		if (atomic_dec_and_test())
			...
	}

	void insert_context_barrier(work, barr)
	{
		...insert barr after work, like flush_work() does...
	}

	queue_work_contex(struct workqueue_struct *wq,
			  struct work_struct *work,
			  struct flush_context *fc)
	{
		int ret = queue_work(wq, work);
		if (ret)
			insert_context_barrier(work, barr);
		return ret;
	}

this way we shouldn't change run_workqueue() and introduce a "parallel"
larger work_struct which needs its own INIT_()/etc.

However I'm a bit sceptical this will be widely used... I may be wrong.

> making all this PI savvy for -rt is going to be fun though.. I guess we
> can just queue a normal barrier of the flusher's priority, and cancel it
> once we complete.. hey - that doesn't sound hard at all :-)

Yes!!! I think this is much better (because _much_ simple) than re-ordering
the pending work_struct's, we can just boost the whole ->worklist. We can
implement flush_work_pi() in the same manner as queue_work_contex() above.
That is why I said previously that flush_() should govern the priority,
not queue.

But we can also implement queue_work_pi(struct work_struct_pi *work).

Oleg.

