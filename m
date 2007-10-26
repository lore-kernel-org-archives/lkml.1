Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbXJZPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbXJZPCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXJZPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:02:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46254 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXJZPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:02:11 -0400
Subject: Re: [PATCH] RT: Cache cpus_allowed weight for optimizing migration
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <Pine.LNX.4.58.0710261035310.18997@gandalf.stny.rr.com>
References: 1193346777.7561.47.camel@ghaskins-t60p.haskins.net <20071026132440.5370.78235.stgit@novell1.haskins.net>
	 <Pine.LNX.4.58.0710261035310.18997@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ESlkxl1OZFdfEJyko8YD"
Date: Fri, 26 Oct 2007 10:59:30 -0400
Message-Id: <1193410770.3959.8.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ESlkxl1OZFdfEJyko8YD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-26 at 10:47 -0400, Steven Rostedt wrote:
> --
> On Fri, 26 Oct 2007, Gregory Haskins wrote:
>=20
> > This version has the feedback from Steve's review incorporated
> >
> > -----------------------------------------
> >
> > RT: Cache cpus_allowed weight for optimizing migration
> >
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
>=20
> A little exageration there ;-)  We don't need to go through locking (at
> least my code doesn't), and the checks are not that expensive (could caus=
e
> some unneeded cache bouncing though).

Well, its all relative.  Not going into overload to begin with, and
therefore not hitting the pull_rt_tasks() logic outright should be
faster than lockless scanning tricks ;)

But I digress.  I don't think the original code had your optimization,
so you are right:  It's perhaps a bit of an exaggeration in HEAD.  I'll
be less dramatic for the next drop ;)

>=20
> > experience unecessary overhead/latencies regardless as they
> > ineffectively try to process the overload condition.
> >
> > This patch tries to optimize the situation by utilizing the hamming
> > weight of the task->cpus_allowed mask.  A weight of 1 indicates that
> > the task cannot be migrated, which may be utilized by the overload
>=20
> s/may/will/

ack

>=20
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
> >  include/linux/sched.h |    2 ++
> >  kernel/fork.c         |    1 +
> >  kernel/sched.c        |    9 +++++++-
> >  kernel/sched_rt.c     |   58 +++++++++++++++++++++++++++++++++++++++++=
++++----
> >  4 files changed, 64 insertions(+), 6 deletions(-)
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
> > +		p->sched_class->set_cpus_allowed(p, new_mask);
> > +	else {
> > +		p->cpus_allowed    =3D new_mask;
> > +		p->nr_cpus_allowed =3D cpus_weight(new_mask);
> > +	}
> > +
> >  	/* Can the task run on the task's current CPU? If so, we're done */
> >  	if (cpu_isset(task_cpu(p), new_mask))
> >  		goto out;
> > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> > index b59dc20..6d293bd 100644
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
>=20
> I think we can have a race here. If we schedule a task that can migrate,
> and it's the only RT task, but before that task actually makes it to the
> scheduler, we schedule a higher priority task that can't migrate, we miss
> setting the overload on that CPU.

Ah, yes.  Good eye.  I will devise a fix.

Regards,
-Greg



--=-ESlkxl1OZFdfEJyko8YD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHIgDSSW61Ku6jJPkRAq9LAKCJ5AsdezhZ4KgI2j0NSjDNSePTQwCfV917
ay1mMduESPLWC6BraPdXAZw=
=665Q
-----END PGP SIGNATURE-----

--=-ESlkxl1OZFdfEJyko8YD--

