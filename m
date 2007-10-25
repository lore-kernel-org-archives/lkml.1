Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbXJYSyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbXJYSyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJYSye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:54:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49111 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbXJYSyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:54:33 -0400
Subject: Re: [PATCH 2/3] RT: Cache cpus_allowed weight for optimizing
	migration
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <Pine.LNX.4.58.0710251131060.5639@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net>
	 <20071025144628.19876.35583.stgit@novell1.haskins.net>
	 <Pine.LNX.4.58.0710251131060.5639@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8R7tYXKNHdWZjFew/MRi"
Date: Thu, 25 Oct 2007 14:51:52 -0400
Message-Id: <1193338312.4021.53.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8R7tYXKNHdWZjFew/MRi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-25 at 11:48 -0400, Steven Rostedt wrote:
> --
> On Thu, 25 Oct 2007, Gregory Haskins wrote:
>=20
> > Some RT tasks (particularly kthreads) are bound to one specific CPU.
> > It is fairly common for one or more bound tasks to get queued up at the
> > same time.  Consider, for instance, softirq_timer and softirq_sched.  A
> > timer goes off in an ISR which schedules softirq_thread to run at RT50.
> > Then during the handling of the timer, the system determines that it's
> > time to smp-rebalance the system so it schedules softirq_sched to run
> > from within the softirq_timer kthread context. So we are in a situation
> > where we have two RT50 tasks queued, and the system will go into
> > rt-overload condition to request other CPUs for help.
> >
> > The problem is that these tasks cannot ever be pulled away since they
> > are already running on their one and only valid RQ.  However, the other
> > CPUs cannot determine that the tasks are unpullable without going
> > through expensive checks/locking.  Therefore the helping CPUS
> > experience unecessary overhead/latencies regardless as they
> > ineffectively try to process the overload condition.
> >
> > This patch tries to optimize the situation by utilizing the hamming
> > weight of the task->cpus_allowed mask.  A weight of 1 indicates that
> > the task cannot be migrated, which may be utilized by the overload
> > handling code to eliminate uncessary rebalance attempts.  We also
> > introduce a per-rq variable to count the number of migratable tasks
> > that are currently running.  We only go into overload if we have more
> > than one rt task, AND at least one of them is migratable.
> >
> > Calculating the weight is probably relatively expensive, so it is only
> > done when the cpus_allowed mask is updated (which should be relatively
> > infrequent, especially compared to scheduling frequency) and cached in
> > the task_struct.
> >
> >
> > Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> > ---
> >
> >  include/linux/sched.h |    2 +
> >  kernel/fork.c         |    1
> >  kernel/sched.c        |    9 +++-
> >  kernel/sched_rt.c     |  116 +++++++++++++++++++++++++++++++++++++++++=
--------
> >  4 files changed, 107 insertions(+), 21 deletions(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 7a3829f..829de6f 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1048,6 +1048,7 @@ struct sched_class {
> >  	void (*set_curr_task) (struct rq *rq);
> >  	void (*task_tick) (struct rq *rq, struct task_struct *p);
> >  	void (*task_new) (struct rq *rq, struct task_struct *p);
> > +	void (*set_cpus_allowed)(struct task_struct *p, cpumask_t newmask);
> >  };
> >
> >  struct load_weight {
> > @@ -1144,6 +1145,7 @@ struct task_struct {
> >
> >  	unsigned int policy;
> >  	cpumask_t cpus_allowed;
> > +	int nr_cpus_allowed;
> >  	unsigned int time_slice;
> >
> >  #ifdef CONFIG_PREEMPT_RCU
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 5f11f23..f808e18 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1257,6 +1257,7 @@ static struct task_struct *copy_process(unsigned =
long clone_flags,
> >  	 */
> >  	preempt_disable();
> >  	p->cpus_allowed =3D current->cpus_allowed;
> > +	p->nr_cpus_allowed =3D current->nr_cpus_allowed;
> >  	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
> >  			!cpu_online(task_cpu(p))))
> >  		set_task_cpu(p, smp_processor_id());
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 30fa531..6c90093 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -262,6 +262,7 @@ struct rt_rq {
> >  	int rt_load_balance_idx;
> >  	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
> >  	unsigned long rt_nr_running;
> > +	unsigned long rt_nr_migratory;
> >  	unsigned long rt_nr_uninterruptible;
> >  	/* highest queued rt task prio */
> >  	int highest_prio;
> > @@ -5371,7 +5372,13 @@ int set_cpus_allowed(struct task_struct *p, cpum=
ask_t new_mask)
> >  		goto out;
> >  	}
> >
> > -	p->cpus_allowed =3D new_mask;
> > +	if (p->sched_class->set_cpus_allowed)
>=20
> Not sure we need this optimization (not doing the nr_cpus_allowed
> calculation). Since, due to priority boosting, we will need to calculate
> then. Calculating it here is better.

I think you are misunderstanding the code here.  The only optimization
is that I didn't want to force every sched_class to define a default
set_cpus_allowed member-fn.  So instead, it first checks if its defined
and invokes it if true.  Else, the default behavior is to assign the
mask and calculate the weight.

If you look at the one and only implementation of this function
(sched_rt.c:set_cpus_allowed_rt()), it also performs the assignment and
calcs the mask.

Or did I misunderstand your objection?

>=20
> > +		p->sched_class->set_cpus_allowed(p,
> new_mask); > +	else {
> > +		p->cpus_allowed    =3D new_mask;
> > +		p->nr_cpus_allowed =3D cpus_weight(new_mask);
> > +	}
> > +
> >  	/* Can the task run on the task's current CPU? If so, we're done */
> >  	if (cpu_isset(task_cpu(p), new_mask))
> >  		goto out;
> > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> > index b59dc20..ad35c89 100644
> > --- a/kernel/sched_rt.c
> > +++ b/kernel/sched_rt.c
> > @@ -50,6 +50,24 @@ static inline void update_curr_rt(struct rq *rq)
> >  	curr->se.sum_exec_runtime +=3D delta_exec;
> >  	curr->se.exec_start =3D rq->clock;
> >  }
> > +#ifdef CONFIG_SMP
> > +static void inc_rt_migration(struct task_struct *p, struct rq *rq)
> > +{
> > +	rq->rt.rt_nr_migratory++;
> > +
> > +	if (rq->rt.rt_nr_running > 1)
> > +		rt_set_overload(p, rq->cpu);
> > +}
> > +
> > +static void dec_rt_migration(struct task_struct *p, struct rq *rq)
> > +{
> > +	WARN_ON(!rq->rt.rt_nr_migratory);
> > +	rq->rt.rt_nr_migratory--;
> > +
> > +	if ((rq->rt.rt_nr_running < 2) || !rq->rt.rt_nr_migratory)
> > +		rt_clear_overload(p, rq->cpu);
> > +}
> > +#endif
> >
> >  static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
> >  {
> > @@ -58,8 +76,8 @@ static inline void inc_rt_tasks(struct task_struct *p=
, struct rq *rq)
> >  #ifdef CONFIG_SMP
> >  	if (p->prio < rq->rt.highest_prio)
> >  		rq->rt.highest_prio =3D p->prio;
> > -	if (rq->rt.rt_nr_running > 1)
> > -		rt_set_overload(p, rq->cpu);
> > +	if (p->nr_cpus_allowed > 1)
> > +		inc_rt_migration(p, rq);
> >  #endif /* CONFIG_SMP */
> >  }
> >
> > @@ -81,8 +99,8 @@ static inline void dec_rt_tasks(struct task_struct *p=
, struct rq *rq)
> >  		} /* otherwise leave rq->highest prio alone */
> >  	} else
> >  		rq->rt.highest_prio =3D MAX_RT_PRIO;
> > -	if (rq->rt.rt_nr_running < 2)
> > -		rt_clear_overload(p, rq->cpu);
> > +	if (p->nr_cpus_allowed > 1)
> > +		dec_rt_migration(p, rq);
> >  #endif /* CONFIG_SMP */
> >  }
> >
> > @@ -286,6 +304,27 @@ static struct task_struct *pick_next_highest_task_=
rt(struct rq *rq,
> >  	return next;
> >  }
> >
> > +static int lock_migration_target(struct task_struct *p, struct rq *tar=
get_rq)
> > +{
> > +	struct rq *this_rq =3D task_rq(p);
> > +
> > +	if (double_lock_balance(this_rq, target_rq)) {
> > +		/*
> > +		 * We had to unlock the run queue. In
> > +		 * the mean time, task could have
> > +		 * migrated already or had its affinity changed.
> > +		 */
> > +		if (unlikely(task_running(this_rq, p) ||
> > +			     task_rq(p) !=3D this_rq ||
> > +			     !cpu_isset(target_rq->cpu, p->cpus_allowed))) {
> > +			spin_unlock(&target_rq->lock);
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> >  /* Will lock the rq it finds */
> >  static struct rq *find_lock_lowest_rq(struct task_struct *task,
> >  				      struct rq *this_rq)
> > @@ -295,6 +334,28 @@ static struct rq *find_lock_lowest_rq(struct task_=
struct *task,
> >  	int cpu;
> >  	int tries;
> >
> > + 	/*
> > + 	 * We can optimize if the hamming weight of the cpus_allowed mask
> > + 	 * is 1 because the task has nowhere to go but one CPU.  So don't
> > + 	 * waste the time trying to find the lowest RQ in this case.
> > + 	 */
>=20
> This code should be in the pick_next_highest_rt and not here.

I disagree, but I admit it is not apparent at this level of the series
why.  The reason has to do with optimizing the wakeup path.  Unless I am
missing something, I think this placement is optimal, and that will
hopefully become apparent when you see the rest of my series.


>=20
> > + 	if (task->nr_cpus_allowed =3D=3D 1) {
> > + 		/* If the task is already on the RQ, we are done */
> > + 		if (cpu_isset(this_rq->cpu, task->cpus_allowed))
> > + 			return NULL;
> > +
> > + 		cpu =3D first_cpu(task->cpus_allowed);
> > +
> > + 		lowest_rq =3D cpu_rq(cpu);
> > + 		BUG_ON(this_rq =3D=3D lowest_rq);
> > +
> > + 		/* Otherwise, we can simply grab the new RQ */
> > + 		if (lock_migration_target(task, lowest_rq))
> > + 			return lowest_rq;
> > + 		else
> > + 			return NULL;
> > + 	}
> > +
> >  	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
> >
> >  	for (tries =3D 0; tries < RT_MAX_TRIES; tries++) {
> > @@ -324,22 +385,8 @@ static struct rq *find_lock_lowest_rq(struct task_=
struct *task,
> >  			break;
> >
> >  		/* if the prio of this runqueue changed, try again */
> > -		if (double_lock_balance(this_rq, lowest_rq)) {
> > -			/*
> > -			 * We had to unlock the run queue. In
> > -			 * the mean time, task could have
> > -			 * migrated already or had its affinity changed.
> > -			 * Also make sure that it wasn't scheduled on its rq.
> > -			 */
> > -			if (unlikely(task_rq(task) !=3D this_rq ||
> > -				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
> > -				     task_running(this_rq, task) ||
> > -				     !task->se.on_rq)) {
> > -				spin_unlock(&lowest_rq->lock);
> > -				lowest_rq =3D NULL;
> > -				break;
> > -			}
> > -		}
> > + 		if (!lock_migration_target(task, lowest_rq))
> > + 			return NULL;
>=20
> I don't like this encapsulating of the doubl_lock_balance. There's a
> reason I kept it out like this. Mainly because this is the source of most
> (if not all) of the race condititions I fought. So this is a very
> sensitive area to touch.

Reducing code duplication is an effort to mitigate error propagation,
not increase it ;)

> In fact, I see a few races already introduced by
> this patch. One is that you took out the "!task->se.or_rq" test.

This was intentional, but perhaps I should have been more explicit on
the reason why.  This is again related to future optimizations that I
have yet to reveal.  Namely, this code path can be invoked before the
task has been woken up, and it is therefore normal for it to not be on a
RQ.

>  Which
> means that a task could have ran and deactivated itself
> (TASK_UNINTERRUPTIBLE) and you just added it to a run queue. (I hit that
> race ;-)

Hmm.. This is a good point.  Perhaps we should check to see that the
task doesnt change state instead of if its on a RQ.

>=20
> So keep that code out in the open where it belongs.

You aren't the first person to say something like that, and I always
scratch my head at that one.  It *is* open..its right there -40 lines
from where it used to be.  Its not like I gave you a obfuscated .o
blackbox ;)

>  Its very sensitive.

Agreed.  You weren't aware of my issue, as I wasn't aware of yours.  I
think that means we both failed to comment tricky code properly ;)

>=20
>=20
> >
> >  		/* If this rq is still suitable use it. */
> >  		if (lowest_rq->rt.highest_prio > task->prio)
> > @@ -658,6 +705,31 @@ static void task_tick_rt(struct rq *rq, struct tas=
k_struct *p)
> >  	}
> >  }
> >
> > +#ifdef CONFIG_SMP
> > +static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t new_m=
ask)
> > +{
> > +	int weight =3D cpus_weight(new_mask);
> > +
> > +	BUG_ON(!rt_task(p));
> > +
> > +	/*
> > +	 * Update the migration status of the RQ if we have an RT task
> > +	 * which is running AND changing its weight value.
> > +	 */
> > +	if (p->se.on_rq && (weight !=3D p->nr_cpus_allowed)) {
> > +		struct rq *rq =3D task_rq(p);
> > +
> > +		if ((p->nr_cpus_allowed <=3D 1) && (weight > 1))
> > +			inc_rt_migration(p, rq);
> > +		else if((p->nr_cpus_allowed > 1) && (weight <=3D 1))
> > +			dec_rt_migration(p, rq);
> > +	}
> > +
> > +	p->cpus_allowed    =3D new_mask;
> > +	p->nr_cpus_allowed =3D weight;
> > +}
> > +#endif
> > +
> >  static struct sched_class rt_sched_class __read_mostly =3D {
> >  	.enqueue_task		=3D enqueue_task_rt,
> >  	.dequeue_task		=3D dequeue_task_rt,
> > @@ -671,4 +743,8 @@ static struct sched_class rt_sched_class __read_mos=
tly =3D {
> >  	.load_balance		=3D load_balance_rt,
> >
> >  	.task_tick		=3D task_tick_rt,
> > +
> > +#ifdef CONFIG_SMP
> > +	.set_cpus_allowed       =3D set_cpus_allowed_rt,
> > +#endif
>=20
> Hmm, I must have missed where you update the mask at time of boosting.

?  I don't understand what you mean.  Are you referring to PI boosting?
What does that have to do with the mask?

Are you referring to when we change the mask?  We already invoke this
handler from the sched.c:set_cpus_allowed().  Can you clarify this
point?

> Anyway, we shouldn't. The set_cpus_allowed should be done for all tasks.

It is.  Im just lazy and had the default case handled inside the
sched_c:set_cpus_allowed() call.  Perhaps I should just let all
sched_classes define a handler instead of such trickery.

> Now you can have a handler to call for when a task changes class

Well, at least for what I am designing here, we are already covered.  If
the task changes class, it would be dequeued in one class, and enqueued
in the new one.  This would properly update the migration state.
Likewise, if it had its mask changed the set_cpus_allowed_rt() would
update the migration state.

Regards,
-Greg

--=-8R7tYXKNHdWZjFew/MRi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHIOXISW61Ku6jJPkRApO2AJ9pYRJU51SBnH/yXeCi2pHmfOZZ4QCfVlk7
KpeH+xBew48z28NbU3BQfgA=
=Woyx
-----END PGP SIGNATURE-----

--=-8R7tYXKNHdWZjFew/MRi--

