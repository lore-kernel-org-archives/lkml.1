Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZKFE1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZKFE1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 23:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759212AbZKFE1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 23:27:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:44786 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755081AbZKFE1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 23:27:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX182tNAZKAg2BEyK/yN76dNBTUCy6o72TOa6WF3oFe
	Dhme8R0lQh9HC1
Subject: Re: [patch] Re: There is something with scheduler (was Re: [patch]
 Re: [regression bisect -next] BUG: using smp_processor_id() in preemptible
 [00000000] code: rmmod)
From: Mike Galbraith <efault@gmx.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <4AF38A72.9000900@cn.fujitsu.com>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
	 <1256807967.7158.58.camel@marge.simson.net>
	 <1256813310.7574.3.camel@marge.simson.net> <20091102182808.GA8950@elte.hu>
	 <1257190811.19608.2.camel@marge.simson.net>
	 <4AF2AC30.4000003@cn.fujitsu.com>
	 <1257430388.6437.31.camel@marge.simson.net>
	 <1257431437.7016.3.camel@marge.simson.net>
	 <1257462632.6560.8.camel@marge.simson.net>
	 <4AF38A72.9000900@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 05:27:47 +0100
Message-Id: <1257481667.6394.54.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 10:31 +0800, Lai Jiangshan wrote:
> Mike Galbraith wrote:
> > A bit of late night cut/paste fixed it right up, so tomorrow, I can redo
> > benchmarks etc etc.
> > 
> > Lai, mind giving this a try?  I believe this will fix your problem as
> > well as mine.
> 
> My problem: a bound task is run on a different cpu. You haven't describe
> how does it happen, how do you think this patch will fix my problem?

That's an easy one.  I haven't figured out exactly how it happens, made
8x10 color glossies with circles and arrows etc, but read on anyway.

My problem is bound tasks doubling their throughput.  How do they do
that while staying bound to CPUs that do not share a cache?  If I make a
shortcut in select_rq() for bound tasks, so we don't waste time looking
for a place to put a pinned task, why does throughput decrease?  I
haven't made film and analyzed it, but that's what is happening.  We are
diddling the task struct with zero protection, and that is causing the
bad thing to happen, which is what I care about.

Now that I've fixed the problem, here's the throughput of the same
netperf run when bound to cache affine CPUs.

Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

 65536    4096   60.00     15102830      0    8248.16
 65536           60.00     15101813           8247.60

Convinced enough now to try the patch, despite it's beauty mark?

> > +	for (;;) {
> > +		local_irq_save(*flags);
> > +		rq = cpu_rq(cpu);
> > +		spin_lock(&rq->lock);
> > +		if (likely(rq == cpu_rq(cpu)))
> > +			return rq;
> > +		spin_unlock_irqrestore(&rq->lock, *flags);
> > +	}
> > +}
> > +
> > +static inline void cpu_rq_unlock(struct rq *rq, unsigned long *flags)
> > +	__releases(rq->lock)
> > +{
> > +	spin_unlock_irqrestore(&rq->lock, *flags);
> > +}
> > +
> 
> The above code is totally garbage, cpu_rq(cpu) is constant.

Yeah, the hazards of late late night cut/paste sessions.

> >  #ifdef CONFIG_SCHED_HRTICK
> >  /*
> >   * Use HR-timers to deliver accurate preemption points.
> > @@ -2345,13 +2371,12 @@ static int try_to_wake_up(struct task_st
> >  	task_rq_unlock(rq, &flags);
> >  
> >  	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
> > -	if (cpu != orig_cpu)
> > -		set_task_cpu(p, cpu);
> > -
> > -	rq = task_rq_lock(p, &flags);
> > -
> > -	if (rq != orig_rq)
> > +	if (cpu != orig_cpu) {
> > +		rq = cpu_rq_lock(cpu, &flags);
> >  		update_rq_clock(rq);
> > +		set_task_cpu(p, cpu);
> 
> Process p's runqueue may not have been locked.

Process p is being held hostage by TASK_WAKING.  It's going nowhere but
where select_task_rq() tells us to put it, and that's the runqueue we
must lock.  If you lock p's old runqueue, and it's not the runqueue
you're about to queue it to, nothing good is gonna happen.

In fact, now that I think about it more, seems I want to disable preempt
across the call to select_task_rq().  Concurrency sounds nice, but when
when waker is preempted, the hostage, who may well have earned the right
to instant cpu access will wait until the waker returns, and finishes
looking for a runqueue.  We want to get wakee onto the runqueue asap.
What happens if say a SCHED_IDLE task gets CPU on a busy box long enough
to wake kjournald?

	-Mike

