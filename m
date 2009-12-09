Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbZLIIHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbZLIIHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZLIIG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:06:59 -0500
Received: from www.tglx.de ([62.245.132.106]:34337 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZLIIG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:06:59 -0500
Date: Wed, 9 Dec 2009 09:06:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] sched: Protect sched_rr_get_param access to
 task->sched_class
In-Reply-To: <1260345798.5489.70.camel@laptop>
Message-ID: <alpine.LFD.2.00.0912090905210.3089@localhost.localdomain>
References: <20091208202026.804386447@linutronix.de>  <1260345648.5489.65.camel@laptop> <1260345798.5489.70.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Peter Zijlstra wrote:

> On Wed, 2009-12-09 at 09:00 +0100, Peter Zijlstra wrote:
> > On Tue, 2009-12-08 at 20:24 +0000, Thomas Gleixner wrote:
> > > plain text document attachment
> > > (sched-fix-sched-get-rr-param-race.patch)
> > > sched_rr_get_param calls task->sched_class->get_rr_interval(task)
> > > without protection against a concurrent sched_setscheduler() call
> > > which modifies task->sched_class.
> > > 
> > > Serialize the access with task_rq_lock(task);
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > ---
> > >  kernel/sched.c |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > Index: linux-2.6-tip/kernel/sched.c
> > > ===================================================================
> > > --- linux-2.6-tip.orig/kernel/sched.c
> > > +++ linux-2.6-tip/kernel/sched.c
> > > @@ -6887,6 +6887,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
> > >  {
> > >  	struct task_struct *p;
> > >  	unsigned int time_slice;
> > > +	unsigned long flags;
> > > +	struct rq *rq;
> > >  	int retval;
> > >  	struct timespec t;
> > >  
> > > @@ -6903,7 +6905,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
> > >  	if (retval)
> > >  		goto out_unlock;
> > >  
> > > +	rq = task_rq_lock(p, &flags);
> > >  	time_slice = p->sched_class->get_rr_interval(p);
> > > +	task_rq_unlock(rq, &flags);
> > >  
> > >  	read_unlock(&tasklist_lock);
> > >  	jiffies_to_timespec(time_slice, &t);
> > > 
> > 
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Oh, that was too quick, get_rr_interval_fair() actually takes the
> rq->lock, so lets add this:
> 
>  unsigned int get_rr_interval_fair(struct task_struct *task)
>  {
>         struct sched_entity *se = &task->se;
> -       unsigned long flags;
> -       struct rq *rq;
>         unsigned int rr_interval = 0;
> 
>         /*
>          * Time slice is 0 for SCHED_OTHER tasks that are on an otherwise
>          * idle runqueue:
>          */
> -       rq = task_rq_lock(task, &flags);
>         if (rq->cfs.load.weight)
>                 rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
> -       task_rq_unlock(rq, &flags);
> -
>         return rr_interval;
>  }

Duh, yes. I looked at that actually and made a mental note to remove it. :(

Thanks for catching that,

       tglx
