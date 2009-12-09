Return-Path: <linux-kernel-owner+w=401wt.eu-S1751158AbZLIIDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbZLIIDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZLIIDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:03:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZLIIDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:03:19 -0500
Subject: Re: [patch 2/2] sched: Protect sched_rr_get_param access to
 task->sched_class
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1260345648.5489.65.camel@laptop>
References: <20091208202026.804386447@linutronix.de>
	 <1260345648.5489.65.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 09:03:18 +0100
Message-ID: <1260345798.5489.70.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 09:00 +0100, Peter Zijlstra wrote:
> On Tue, 2009-12-08 at 20:24 +0000, Thomas Gleixner wrote:
> > plain text document attachment
> > (sched-fix-sched-get-rr-param-race.patch)
> > sched_rr_get_param calls task->sched_class->get_rr_interval(task)
> > without protection against a concurrent sched_setscheduler() call
> > which modifies task->sched_class.
> > 
> > Serialize the access with task_rq_lock(task);
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  kernel/sched.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > Index: linux-2.6-tip/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-tip.orig/kernel/sched.c
> > +++ linux-2.6-tip/kernel/sched.c
> > @@ -6887,6 +6887,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
> >  {
> >  	struct task_struct *p;
> >  	unsigned int time_slice;
> > +	unsigned long flags;
> > +	struct rq *rq;
> >  	int retval;
> >  	struct timespec t;
> >  
> > @@ -6903,7 +6905,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
> >  	if (retval)
> >  		goto out_unlock;
> >  
> > +	rq = task_rq_lock(p, &flags);
> >  	time_slice = p->sched_class->get_rr_interval(p);
> > +	task_rq_unlock(rq, &flags);
> >  
> >  	read_unlock(&tasklist_lock);
> >  	jiffies_to_timespec(time_slice, &t);
> > 
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Oh, that was too quick, get_rr_interval_fair() actually takes the
rq->lock, so lets add this:

 unsigned int get_rr_interval_fair(struct task_struct *task)
 {
        struct sched_entity *se = &task->se;
-       unsigned long flags;
-       struct rq *rq;
        unsigned int rr_interval = 0;

        /*
         * Time slice is 0 for SCHED_OTHER tasks that are on an otherwise
         * idle runqueue:
         */
-       rq = task_rq_lock(task, &flags);
        if (rq->cfs.load.weight)
                rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
-       task_rq_unlock(rq, &flags);
-
        return rr_interval;
 }


