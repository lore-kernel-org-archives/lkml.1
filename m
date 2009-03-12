Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZCLNh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZCLNh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZCLNgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:36:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:39575 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753740AbZCLNgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:36:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19QH69dnINQ8yePBmfZZyx5hCcqTsi9mQyMWzgk8q
	dtjH1ElmEEseMh
Subject: Re: [PATCH] (latest tip) make dequeue_task less confusing
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Newall <davidn@davidnewall.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090312095518.GB16721@elte.hu>
References: <49B8CE2B.8070402@davidnewall.com>
	 <20090312095518.GB16721@elte.hu>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 14:36:37 +0100
Message-Id: <1236864997.6075.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 10:55 +0100, Ingo Molnar wrote:
> * David Newall <davidn@davidnewall.com> wrote:
> 
> > The dequeue_patch function in kernel/sched.c is complicated by
        ^^^^^^^^^^^^^
>  
> > including a sleep parameter.  This parameter is always zero 
> > except in one instance.  This patch clarifies the task of 
> > dequeue_patch by removing the sleep parameter and moving the 
> > code that handles non-zero sleep to that one place where it is 
> > needed.
> > 
> 
> > --- kernel/sched.c	2009-03-12 18:41:41.000000000 +1030
> > +++ kernel/sched.c.dn	2009-03-12 18:45:18.000000000 +1030
> > @@ -1791,21 +1791,10 @@
> >  	p->se.on_rq = 1;
> >  }
> >  
> > -static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
> > +static void dequeue_task(struct rq *rq, struct task_struct *p)
> >  {
> > -	if (sleep) {
> > -		if (p->se.last_wakeup) {
> > -			update_avg(&p->se.avg_overlap,
> > -				p->se.sum_exec_runtime - p->se.last_wakeup);
> > -			p->se.last_wakeup = 0;
> > -		} else {
> > -			update_avg(&p->se.avg_wakeup,
> > -				sysctl_sched_wakeup_granularity);
> > -		}
> > -	}
> > -
> >  	sched_info_dequeued(p);
> > -	p->sched_class->dequeue_task(rq, p, sleep);
> > +	p->sched_class->dequeue_task(rq, p, 0);
> >  	p->se.on_rq = 0;
> >  }
> >  
> > @@ -1875,7 +1864,22 @@
> >  	if (task_contributes_to_load(p))
> >  		rq->nr_uninterruptible++;
> >  
> > -	dequeue_task(rq, p, sleep);
> > +	if (sleep) {
> > +		if (p->se.last_wakeup) {
> > +			update_avg(&p->se.avg_overlap,
> > +				p->se.sum_exec_runtime - p->se.last_wakeup);
> > +			p->se.last_wakeup = 0;
> > +		} else {
> > +			update_avg(&p->se.avg_wakeup,
> > +				sysctl_sched_wakeup_granularity);
> > +		}
> > +	}
> > +
> > +	/*dequeue_task(rq, p, sleep);*/
> > +	sched_info_dequeued(p);
> > +	p->sched_class->dequeue_task(rq, p, sleep);
> > +	p->se.on_rq = 0;
> > +
> >  	dec_nr_running(rq);
> >  }
> >  
> > @@ -5323,7 +5327,7 @@
> >  	on_rq = p->se.on_rq;
> >  	running = task_current(rq, p);
> >  	if (on_rq)
> > -		dequeue_task(rq, p, 0);
> > +		dequeue_task(rq, p);
> >  	if (running)
> >  		p->sched_class->put_prev_task(rq, p);
> >  
> > @@ -5372,7 +5376,7 @@
> >  	}
> >  	on_rq = p->se.on_rq;
> >  	if (on_rq)
> > -		dequeue_task(rq, p, 0);
> > +		dequeue_task(rq, p);
> >  
> >  	p->static_prio = NICE_TO_PRIO(nice);
> >  	set_load_weight(p);
> > @@ -9189,7 +9193,7 @@
> >  	on_rq = tsk->se.on_rq;
> >  
> >  	if (on_rq)
> > -		dequeue_task(rq, tsk, 0);
> > +		dequeue_task(rq, tsk);
> >  	if (unlikely(running))
> >  		tsk->sched_class->put_prev_task(rq, tsk);
> 
> It would be cleaner to achieve this by introducing a 
> __dequeue_task() inline function that does not have the sleep 
> parameter and is a thin wrapper over 
> p->sched_class->dequeue_task, and keep dequeue_task() with the 
> sleep parameter - but update it to use __dequeue_task() and mark 
> it an inline function.

Is there any real gain from doing this?  It messes up the symmetry of
enqueue/dequeue.

	-Mike

