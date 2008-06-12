Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYFLSj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYFLSj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYFLSjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:39:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:45608 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbYFLSjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:39:17 -0400
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of
	"int tail"
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080612174433.GA12204@tv-sign.ru>
References: <20080612165120.GA12177@tv-sign.ru>
	 <20080612165550.GA12183@tv-sign.ru> <1213290074.31518.136.camel@twins>
	 <20080612174433.GA12204@tv-sign.ru>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 20:38:59 +0200
Message-Id: <1213295939.31518.159.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 21:44 +0400, Oleg Nesterov wrote:

> > Hence that idea of flush context and completions.
> 
> Do you mean something like (just for example) below? If yes, then yes
> sure, flush_work() is limited. But I can't see how it is possible to
> "generalize" this idea.
> 
> (hmm... actually, if we add flush_work(), we can speedup schedule_on_each_cpu(),
>  instead of flush_workqueue(keventd_wq) we can do
> 
> 	for_each_online_cpu(cpu)
> 		flush_work(per_cpu_ptr(works, cpu));
> 
>  not sure this really makes sense though).

Speedups are always nice ;-), but the below also gets us there.

> Oleg.
> 
> --- kernel/workqueue.c~	2007-07-28 16:58:17.000000000 +0400
> +++ kernel/workqueue.c	2007-08-06 20:33:25.000000000 +0400
> @@ -590,25 +590,54 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
>   *
>   * schedule_on_each_cpu() is very slow.
>   */
> +
> +struct xxx
> +{
> +	atomic_t count;
> +	struct completion done;
> +	work_func_t func;
> +};
> +
> +struct yyy
> +{
> +	struct work_struct work;
> +	struct xxx *xxx;
> +};
> +
> +static void yyy_func(struct work_struct *work)
> +{
> +	struct xxx *xxx = container_of(work, struct yyy, work)->xxx;
> +	xxx->func(work);
> +
> +	if (atomic_dec_and_test(&xxx->count))
> +		complete(&xxx->done);
> +}
> +
>  int schedule_on_each_cpu(work_func_t func)
>  {
>  	int cpu;
> -	struct work_struct *works;
> +	struct xxx xxx;
> +	struct yyy *works;
>  
> -	works = alloc_percpu(struct work_struct);
> +	init_completion(&xxx.done);
> +	xxx.func = func;
> +
> +	works = alloc_percpu(struct yyy);
>  	if (!works)
>  		return -ENOMEM;
>  
>  	get_online_cpus();
> +	atomic_set(&xxx.count, num_online_cpus());
>  	for_each_online_cpu(cpu) {
> -		struct work_struct *work = per_cpu_ptr(works, cpu);
> +		struct yyy *yyy = per_cpu_ptr(works, cpu);
>  
> -		INIT_WORK(work, func);
> -		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
> -		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
> +		yyy->xxx = &xxx;
> +		INIT_WORK(&yyy->work, yyy_func);
> +		set_bit(WORK_STRUCT_PENDING, work_data_bits(&yyy->work));
> +		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), &yyy->work);
>  	}
> -	flush_workqueue(keventd_wq);
>  	put_online_cpus();
> +	wait_for_completion(&xxx.done);
>  	free_percpu(works);
>  	return 0;
>  }

Yes, along those lines.

you can call xxx a flush_context and create an interface like:

int queue_work_contex(struct workqueue_struct *wq, 
		      struct flush_context *fc, struct work_struct *work)
{
	work->context = fc;
	return queue_work(wq, work);
}

void flush_workqueue_context(struct workqueue_strucy *wq, t
			     struct flush_context *fc)
{
	if (atomic_read(&context->count))
		wait_for_completion(&fc->completion);
	/* except that the above is racy, wait_event() comes to mind */
}

of course run_workqueue() would then need to be augmented with something
like:

  context = work->context;
  ...
  f(work);
  ...
  if (context && atomic_dec_and_test(&context->count))
    complete(&context->done);

making all this PI savvy for -rt is going to be fun though.. I guess we
can just queue a normal barrier of the flusher's priority, and cancel it
once we complete.. hey - that doesn't sound hard at all :-)

also, I seem to have quitely ignored the fact that struct work doesn't
have the context pointer, and growing it unconditionally like this isn't
nice - hummm,. perhaps we have a bit left in data and can signify a
larger struct work_struct.. ?



