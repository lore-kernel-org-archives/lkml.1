Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbXJYVPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbXJYVPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXJYVPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:15:47 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52301 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXJYVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:15:45 -0400
Subject: Re: [PATCH 2/3] RT: Cache cpus_allowed weight for optimizing
	migration
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <Pine.LNX.4.58.0710251536190.5152@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net>
	 <20071025144628.19876.35583.stgit@novell1.haskins.net>
	 <Pine.LNX.4.58.0710251131060.5639@gandalf.stny.rr.com>
	 <1193338312.4021.53.camel@ghaskins-t60p.haskins.net>
	 <Pine.LNX.4.58.0710251536190.5152@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vWB8coQ50LHqakyvjDDn"
Date: Thu, 25 Oct 2007 17:12:57 -0400
Message-Id: <1193346777.7561.47.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vWB8coQ50LHqakyvjDDn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-25 at 15:52 -0400, Steven Rostedt wrote:

> >
> > >
> > > > +		p->sched_class->set_cpus_allowed(p,
> > > new_mask); > +	else {
> > > > +		p->cpus_allowed    =3D new_mask;
> > > > +		p->nr_cpus_allowed =3D cpus_weight(new_mask);
> > > > +	}
> > > > +
> > > >  	/* Can the task run on the task's current CPU? If so, we're done =
*/
> > > >  	if (cpu_isset(task_cpu(p), new_mask))
> > > >  		goto out;
>=20
>=20
> > > >  /* Will lock the rq it finds */
> > > >  static struct rq *find_lock_lowest_rq(struct task_struct *task,
> > > >  				      struct rq *this_rq)
> > > > @@ -295,6 +334,28 @@ static struct rq *find_lock_lowest_rq(struct t=
ask_struct *task,
> > > >  	int cpu;
> > > >  	int tries;
> > > >
> > > > + 	/*
> > > > + 	 * We can optimize if the hamming weight of the cpus_allowed mas=
k
> > > > + 	 * is 1 because the task has nowhere to go but one CPU.  So don'=
t
> > > > + 	 * waste the time trying to find the lowest RQ in this case.
> > > > + 	 */
> > >
> > > This code should be in the pick_next_highest_rt and not here.
> >
> > I disagree, but I admit it is not apparent at this level of the series
> > why.  The reason has to do with optimizing the wakeup path.  Unless I a=
m
> > missing something, I think this placement is optimal, and that will
> > hopefully become apparent when you see the rest of my series.
>=20
> Then move the code there then. One can't be analyzing patches when code
> isn't apparent that determines changes.  Those changes need to be
> together.  Especially since they may not be applied.

The correctness of this particular change (IMO) is not predicated on the
later patches, otherwise I would have done just that.  It accomplishes
what I intended as is here in this patch.

Why do you think moving the logic to pick_next_highest is a better
design?  To be honest, I haven't really studied your new logic in
push_rt_tasks to understand why you might feel this way.  If you can
make the case that it is better in the other location then I agree with
you that we should move it there in this patch, and potentially adjust
it later.  Until then, I see no problem with it being here.

>=20
> I would be happy to apply most of this patch but because of changes that
> are here to help out to-be-announced patches, will keep this patch from
> going into the tree.
>=20
> IOW, break the patch up to the fixes that this patch is to do on its own.
> It has plenty. Leave out the stuff that will help out later patches.
> Add the stuff that is being recommended, and you can make a separate patc=
h
> to move things around in the patch series that does all the TBA stuff.

I think the only one real solid case of that is the removal of on_rq
from the double_lock conditions.  I agree with your point that it should
come later.  I'll put it back in and adjust it later.  I'll wait to hear
your argument on the pick_highest_task before moving the other one.

>=20
> >
> > >
> > > > + 	if (task->nr_cpus_allowed =3D=3D 1) {
> > > > + 		/* If the task is already on the RQ, we are done */
> > > > + 		if (cpu_isset(this_rq->cpu, task->cpus_allowed))
> > > > + 			return NULL;
> > > > +
> > > > + 		cpu =3D first_cpu(task->cpus_allowed);
> > > > +
> > > > + 		lowest_rq =3D cpu_rq(cpu);
> > > > + 		BUG_ON(this_rq =3D=3D lowest_rq);
> > > > +
> > > > + 		/* Otherwise, we can simply grab the new RQ */
> > > > + 		if (lock_migration_target(task, lowest_rq))
> > > > + 			return lowest_rq;
> > > > + 		else
> > > > + 			return NULL;
> > > > + 	}
> > > > +
> > > >  	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
> > > >
> > > >  	for (tries =3D 0; tries < RT_MAX_TRIES; tries++) {
> > > > @@ -324,22 +385,8 @@ static struct rq *find_lock_lowest_rq(struct t=
ask_struct *task,
> > > >  			break;
> > > >
> > > >  		/* if the prio of this runqueue changed, try again */
> > > > -		if (double_lock_balance(this_rq, lowest_rq)) {
> > > > -			/*
> > > > -			 * We had to unlock the run queue. In
> > > > -			 * the mean time, task could have
> > > > -			 * migrated already or had its affinity changed.
> > > > -			 * Also make sure that it wasn't scheduled on its rq.
> > > > -			 */
> > > > -			if (unlikely(task_rq(task) !=3D this_rq ||
> > > > -				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
> > > > -				     task_running(this_rq, task) ||
> > > > -				     !task->se.on_rq)) {
> > > > -				spin_unlock(&lowest_rq->lock);
> > > > -				lowest_rq =3D NULL;
> > > > -				break;
> > > > -			}
> > > > -		}
> > > > + 		if (!lock_migration_target(task, lowest_rq))
> > > > + 			return NULL;
> > >
> > > I don't like this encapsulating of the doubl_lock_balance. There's a
> > > reason I kept it out like this. Mainly because this is the source of =
most
> > > (if not all) of the race condititions I fought. So this is a very
> > > sensitive area to touch.
> >
> > Reducing code duplication is an effort to mitigate error propagation,
> > not increase it ;)
>=20
> Actually that's not the point. The side effects of the double_lock_balanc=
e
> are unique to each location. So it doesn't really make sense to modulize
> this code. That was why I didn't do it.

?

I generalized the core functionality so it worked as I believed it
should in the two places that I used it.  I don't follow your objection
here.  Did I break something (besides the on_rq thing?).  My feeling is
that both need the same locking semantics, but we don't need the check
for the priority shift in the optimized case as we do in the loop.  So
that is where I delineated the common code from the specialized.

>=20
> >
> > > In fact, I see a few races already introduced by
> > > this patch. One is that you took out the "!task->se.or_rq" test.
> >
> > This was intentional, but perhaps I should have been more explicit on
> > the reason why.  This is again related to future optimizations that I
> > have yet to reveal.  Namely, this code path can be invoked before the
> > task has been woken up, and it is therefore normal for it to not be on =
a
> > RQ.
> >
> > >  Which
> > > means that a task could have ran and deactivated itself
> > > (TASK_UNINTERRUPTIBLE) and you just added it to a run queue. (I hit t=
hat
> > > race ;-)
> >
> > Hmm.. This is a good point.  Perhaps we should check to see that the
> > task doesnt change state instead of if its on a RQ.
>=20
> Hence why I said the balance before activate task is very racy.

If that's the case then you are already broken if we hit the wake_idle()
case, no?  We can drop the lock there too.

But I am not convinced it cannot be done in a race free way.  I can be
convinced otherwise.=20

>   Looking
> at the state is not enough. A RT task may be in the TASK_UNINTERRUPTIBLE
> state and about to check a condition that will have it wake itself up. So
> just looking at the state is not enough to determine if we should skip it
> or not.

Hmm...I'm not sure I follow.  Can you elaborate more?

>=20
> >
> > >
> > > So keep that code out in the open where it belongs.
> >
> > You aren't the first person to say something like that, and I always
> > scratch my head at that one.  It *is* open..its right there -40 lines
> > from where it used to be.  Its not like I gave you a obfuscated .o
> > blackbox ;)
>=20
> My point is that the side effect that the double_lock_balance causes is
> not apparent in the encapsulated function.
>=20
> >
> > >  Its very sensitive.
> >
> > Agreed.  You weren't aware of my issue, as I wasn't aware of yours.  I
> > think that means we both failed to comment tricky code properly ;)
>=20
> But your issues are on patches not yet sent ;-)

Fair enough...I'll fix it.  But my point still stands that a decent
comment from you would have stopped my "cleverness" ;)

>=20
> > >
> > >
> > > >
> > > >  		/* If this rq is still suitable use it. */
> > > >  		if (lowest_rq->rt.highest_prio > task->prio)
> > > > @@ -658,6 +705,31 @@ static void task_tick_rt(struct rq *rq, struct=
 task_struct *p)
> > > >  	}
> > > >  }
> > > >
> > > > +#ifdef CONFIG_SMP
> > > > +static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t n=
ew_mask)
> > > > +{
> > > > +	int weight =3D cpus_weight(new_mask);
> > > > +
> > > > +	BUG_ON(!rt_task(p));
> > > > +
> > > > +	/*
> > > > +	 * Update the migration status of the RQ if we have an RT task
> > > > +	 * which is running AND changing its weight value.
> > > > +	 */
> > > > +	if (p->se.on_rq && (weight !=3D p->nr_cpus_allowed)) {
> > > > +		struct rq *rq =3D task_rq(p);
> > > > +
> > > > +		if ((p->nr_cpus_allowed <=3D 1) && (weight > 1))
> > > > +			inc_rt_migration(p, rq);
> > > > +		else if((p->nr_cpus_allowed > 1) && (weight <=3D 1))
> > > > +			dec_rt_migration(p, rq);
> > > > +	}
> > > > +
> > > > +	p->cpus_allowed    =3D new_mask;
> > > > +	p->nr_cpus_allowed =3D weight;
> > > > +}
> > > > +#endif
> > > > +
> > > >  static struct sched_class rt_sched_class __read_mostly =3D {
> > > >  	.enqueue_task		=3D enqueue_task_rt,
> > > >  	.dequeue_task		=3D dequeue_task_rt,
> > > > @@ -671,4 +743,8 @@ static struct sched_class rt_sched_class __read=
_mostly =3D {
> > > >  	.load_balance		=3D load_balance_rt,
> > > >
> > > >  	.task_tick		=3D task_tick_rt,
> > > > +
> > > > +#ifdef CONFIG_SMP
> > > > +	.set_cpus_allowed       =3D set_cpus_allowed_rt,
> > > > +#endif
> > >
> > > Hmm, I must have missed where you update the mask at time of boosting=
.
> >
> > ?  I don't understand what you mean.  Are you referring to PI boosting?
> > What does that have to do with the mask?
>=20
> No but a boosting can change classes. And going from fair to rt we don't
> have a nr_cpus_allowed set up yet.

Sure we do! (unless I introduced a bug)

task->cpus_allowed and task->nr_cpus_allowed is updated for *all*
classes.  It is only acted upon to change the migration state if the
task is of an RT class.

>=20
> >
> > Are you referring to when we change the mask?  We already invoke this
> > handler from the sched.c:set_cpus_allowed().  Can you clarify this
> > point?
> >
> > > Anyway, we shouldn't. The set_cpus_allowed should be done for all tas=
ks.
> >
> > It is.  Im just lazy and had the default case handled inside the
> > sched_c:set_cpus_allowed() call.  Perhaps I should just let all
> > sched_classes define a handler instead of such trickery.
> >
> > > Now you can have a handler to call for when a task changes class
> >
> > Well, at least for what I am designing here, we are already covered.  I=
f
> > the task changes class, it would be dequeued in one class, and enqueued
> > in the new one.  This would properly update the migration state.
> > Likewise, if it had its mask changed the set_cpus_allowed_rt() would
> > update the migration state.
>=20
> That is what I think I'm missing. I have to go back and look at the patch
> (I admit I may have missed it). Switching the migration state will update
> the processes nr_cpus_allowed? Of course I think that's not a good idea.

No, other way around.  (de)queuing an RT task, or changing an RT tasks
mask will change the migration state.  So if you have a normal task, its
tracking its hamming-weight...and then you convert it to RT, it would
update migration state on the enqueue.

Likewise, if you alter the mask of an RT task, it would update the
migration state right away.  It never would flow the other way.

Regards,
-Greg



--=-vWB8coQ50LHqakyvjDDn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHIQbZSW61Ku6jJPkRAgzbAKCtz/Asz1c45ZNKc11J7rsYJjiYvQCgj2BE
LTLGiQeDV3TgIkROTGPe38Y=
=1iFm
-----END PGP SIGNATURE-----

--=-vWB8coQ50LHqakyvjDDn--

