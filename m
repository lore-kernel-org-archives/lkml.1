Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbXJYTyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbXJYTyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXJYTyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:54:10 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:57649 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbXJYTyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:54:08 -0400
Date: Thu, 25 Oct 2007 15:52:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 2/3] RT: Cache cpus_allowed weight for optimizing migration
In-Reply-To: <1193338312.4021.53.camel@ghaskins-t60p.haskins.net>
Message-ID: <Pine.LNX.4.58.0710251536190.5152@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net> 
 <20071025144628.19876.35583.stgit@novell1.haskins.net> 
 <Pine.LNX.4.58.0710251131060.5639@gandalf.stny.rr.com>
 <1193338312.4021.53.camel@ghaskins-t60p.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Thu, 25 Oct 2007, Gregory Haskins wrote:

> > >
> > > -	p->cpus_allowed = new_mask;
> > > +	if (p->sched_class->set_cpus_allowed)
> >
> > Not sure we need this optimization (not doing the nr_cpus_allowed
> > calculation). Since, due to priority boosting, we will need to calculate
> > then. Calculating it here is better.
>
> I think you are misunderstanding the code here.  The only optimization
> is that I didn't want to force every sched_class to define a default
> set_cpus_allowed member-fn.  So instead, it first checks if its defined
> and invokes it if true.  Else, the default behavior is to assign the
> mask and calculate the weight.
>
> If you look at the one and only implementation of this function
> (sched_rt.c:set_cpus_allowed_rt()), it also performs the assignment and
> calcs the mask.
>
> Or did I misunderstand your objection?

Actually, I say we do the calculation for all tasks regardless of class.
But you can have a function for each class (or NULL) that will do
something with the old and new values.

Reason why is that we don't want the calculation to happen during the
boosting of a tasks (when it goes from one class to another).

>
> >
> > > +		p->sched_class->set_cpus_allowed(p,
> > new_mask); > +	else {
> > > +		p->cpus_allowed    = new_mask;
> > > +		p->nr_cpus_allowed = cpus_weight(new_mask);
> > > +	}
> > > +
> > >  	/* Can the task run on the task's current CPU? If so, we're done */
> > >  	if (cpu_isset(task_cpu(p), new_mask))
> > >  		goto out;


> > >  /* Will lock the rq it finds */
> > >  static struct rq *find_lock_lowest_rq(struct task_struct *task,
> > >  				      struct rq *this_rq)
> > > @@ -295,6 +334,28 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
> > >  	int cpu;
> > >  	int tries;
> > >
> > > + 	/*
> > > + 	 * We can optimize if the hamming weight of the cpus_allowed mask
> > > + 	 * is 1 because the task has nowhere to go but one CPU.  So don't
> > > + 	 * waste the time trying to find the lowest RQ in this case.
> > > + 	 */
> >
> > This code should be in the pick_next_highest_rt and not here.
>
> I disagree, but I admit it is not apparent at this level of the series
> why.  The reason has to do with optimizing the wakeup path.  Unless I am
> missing something, I think this placement is optimal, and that will
> hopefully become apparent when you see the rest of my series.

Then move the code there then. One can't be analyzing patches when code
isn't apparent that determines changes.  Those changes need to be
together.  Especially since they may not be applied.

I would be happy to apply most of this patch but because of changes that
are here to help out to-be-announced patches, will keep this patch from
going into the tree.

IOW, break the patch up to the fixes that this patch is to do on its own.
It has plenty. Leave out the stuff that will help out later patches.
Add the stuff that is being recommended, and you can make a separate patch
to move things around in the patch series that does all the TBA stuff.

>
> >
> > > + 	if (task->nr_cpus_allowed == 1) {
> > > + 		/* If the task is already on the RQ, we are done */
> > > + 		if (cpu_isset(this_rq->cpu, task->cpus_allowed))
> > > + 			return NULL;
> > > +
> > > + 		cpu = first_cpu(task->cpus_allowed);
> > > +
> > > + 		lowest_rq = cpu_rq(cpu);
> > > + 		BUG_ON(this_rq == lowest_rq);
> > > +
> > > + 		/* Otherwise, we can simply grab the new RQ */
> > > + 		if (lock_migration_target(task, lowest_rq))
> > > + 			return lowest_rq;
> > > + 		else
> > > + 			return NULL;
> > > + 	}
> > > +
> > >  	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
> > >
> > >  	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
> > > @@ -324,22 +385,8 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
> > >  			break;
> > >
> > >  		/* if the prio of this runqueue changed, try again */
> > > -		if (double_lock_balance(this_rq, lowest_rq)) {
> > > -			/*
> > > -			 * We had to unlock the run queue. In
> > > -			 * the mean time, task could have
> > > -			 * migrated already or had its affinity changed.
> > > -			 * Also make sure that it wasn't scheduled on its rq.
> > > -			 */
> > > -			if (unlikely(task_rq(task) != this_rq ||
> > > -				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
> > > -				     task_running(this_rq, task) ||
> > > -				     !task->se.on_rq)) {
> > > -				spin_unlock(&lowest_rq->lock);
> > > -				lowest_rq = NULL;
> > > -				break;
> > > -			}
> > > -		}
> > > + 		if (!lock_migration_target(task, lowest_rq))
> > > + 			return NULL;
> >
> > I don't like this encapsulating of the doubl_lock_balance. There's a
> > reason I kept it out like this. Mainly because this is the source of most
> > (if not all) of the race condititions I fought. So this is a very
> > sensitive area to touch.
>
> Reducing code duplication is an effort to mitigate error propagation,
> not increase it ;)

Actually that's not the point. The side effects of the double_lock_balance
are unique to each location. So it doesn't really make sense to modulize
this code. That was why I didn't do it.

>
> > In fact, I see a few races already introduced by
> > this patch. One is that you took out the "!task->se.or_rq" test.
>
> This was intentional, but perhaps I should have been more explicit on
> the reason why.  This is again related to future optimizations that I
> have yet to reveal.  Namely, this code path can be invoked before the
> task has been woken up, and it is therefore normal for it to not be on a
> RQ.
>
> >  Which
> > means that a task could have ran and deactivated itself
> > (TASK_UNINTERRUPTIBLE) and you just added it to a run queue. (I hit that
> > race ;-)
>
> Hmm.. This is a good point.  Perhaps we should check to see that the
> task doesnt change state instead of if its on a RQ.

Hence why I said the balance before activate task is very racy.  Looking
at the state is not enough. A RT task may be in the TASK_UNINTERRUPTIBLE
state and about to check a condition that will have it wake itself up. So
just looking at the state is not enough to determine if we should skip it
or not.

>
> >
> > So keep that code out in the open where it belongs.
>
> You aren't the first person to say something like that, and I always
> scratch my head at that one.  It *is* open..its right there -40 lines
> from where it used to be.  Its not like I gave you a obfuscated .o
> blackbox ;)

My point is that the side effect that the double_lock_balance causes is
not apparent in the encapsulated function.

>
> >  Its very sensitive.
>
> Agreed.  You weren't aware of my issue, as I wasn't aware of yours.  I
> think that means we both failed to comment tricky code properly ;)

But your issues are on patches not yet sent ;-)

> >
> >
> > >
> > >  		/* If this rq is still suitable use it. */
> > >  		if (lowest_rq->rt.highest_prio > task->prio)
> > > @@ -658,6 +705,31 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p)
> > >  	}
> > >  }
> > >
> > > +#ifdef CONFIG_SMP
> > > +static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t new_mask)
> > > +{
> > > +	int weight = cpus_weight(new_mask);
> > > +
> > > +	BUG_ON(!rt_task(p));
> > > +
> > > +	/*
> > > +	 * Update the migration status of the RQ if we have an RT task
> > > +	 * which is running AND changing its weight value.
> > > +	 */
> > > +	if (p->se.on_rq && (weight != p->nr_cpus_allowed)) {
> > > +		struct rq *rq = task_rq(p);
> > > +
> > > +		if ((p->nr_cpus_allowed <= 1) && (weight > 1))
> > > +			inc_rt_migration(p, rq);
> > > +		else if((p->nr_cpus_allowed > 1) && (weight <= 1))
> > > +			dec_rt_migration(p, rq);
> > > +	}
> > > +
> > > +	p->cpus_allowed    = new_mask;
> > > +	p->nr_cpus_allowed = weight;
> > > +}
> > > +#endif
> > > +
> > >  static struct sched_class rt_sched_class __read_mostly = {
> > >  	.enqueue_task		= enqueue_task_rt,
> > >  	.dequeue_task		= dequeue_task_rt,
> > > @@ -671,4 +743,8 @@ static struct sched_class rt_sched_class __read_mostly = {
> > >  	.load_balance		= load_balance_rt,
> > >
> > >  	.task_tick		= task_tick_rt,
> > > +
> > > +#ifdef CONFIG_SMP
> > > +	.set_cpus_allowed       = set_cpus_allowed_rt,
> > > +#endif
> >
> > Hmm, I must have missed where you update the mask at time of boosting.
>
> ?  I don't understand what you mean.  Are you referring to PI boosting?
> What does that have to do with the mask?

No but a boosting can change classes. And going from fair to rt we don't
have a nr_cpus_allowed set up yet.

>
> Are you referring to when we change the mask?  We already invoke this
> handler from the sched.c:set_cpus_allowed().  Can you clarify this
> point?
>
> > Anyway, we shouldn't. The set_cpus_allowed should be done for all tasks.
>
> It is.  Im just lazy and had the default case handled inside the
> sched_c:set_cpus_allowed() call.  Perhaps I should just let all
> sched_classes define a handler instead of such trickery.
>
> > Now you can have a handler to call for when a task changes class
>
> Well, at least for what I am designing here, we are already covered.  If
> the task changes class, it would be dequeued in one class, and enqueued
> in the new one.  This would properly update the migration state.
> Likewise, if it had its mask changed the set_cpus_allowed_rt() would
> update the migration state.

That is what I think I'm missing. I have to go back and look at the patch
(I admit I may have missed it). Switching the migration state will update
the processes nr_cpus_allowed? Of course I think that's not a good idea.

/me looks.

-- Steve

