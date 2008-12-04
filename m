Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYLDETO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYLDETO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYLDES4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:18:56 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:60545 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYLDESz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:18:55 -0500
Message-ID: <49375AFF.2070307@novell.com>
Date: Wed, 03 Dec 2008 23:22:23 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: mingo@elte.hu
CC: peterz@infradead.org, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH v2 2/4] sched: track the next-highest priority on each
 runqueue
References: <20081203220628.11729.42174.stgit@dev.haskins.net> <20081203220940.11729.49405.stgit@dev.haskins.net>
In-Reply-To: <20081203220940.11729.49405.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig436726C73D2079E95CF90DB0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig436726C73D2079E95CF90DB0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> We will use this later in the series to reduce the amount of rq-lock
> contention during a pull operation
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  kernel/sched.c    |    8 ++++-
>  kernel/sched_rt.c |   81 ++++++++++++++++++++++++++++++++++++++++-----=
--------
>  2 files changed, 67 insertions(+), 22 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6237b9b..24b11eb 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -463,7 +463,10 @@ struct rt_rq {
>  	struct rt_prio_array active;
>  	unsigned long rt_nr_running;
>  #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
> -	int highest_prio; /* highest queued rt task prio */
> +	struct {
> +		int curr; /* highest queued rt task prio */
> +		int next; /* next highest */
> +	} highest_prio;
>  #endif
>  #ifdef CONFIG_SMP
>  	unsigned long rt_nr_migratory;
> @@ -8073,7 +8076,8 @@ static void init_rt_rq(struct rt_rq *rt_rq, struc=
t rq *rq)
>  	__set_bit(MAX_RT_PRIO, array->bitmap);
> =20
>  #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
> -	rt_rq->highest_prio =3D MAX_RT_PRIO;
> +	rt_rq->highest_prio.curr =3D MAX_RT_PRIO;
> +	rt_rq->highest_prio.next =3D MAX_RT_PRIO;
>  #endif
>  #ifdef CONFIG_SMP
>  	rt_rq->rt_nr_migratory =3D 0;
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index fb1d4d7..a4022b6 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -108,7 +108,7 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq=
)
>  	if (rt_rq->rt_nr_running) {
>  		if (rt_se && !on_rt_rq(rt_se))
>  			enqueue_rt_entity(rt_se);
> -		if (rt_rq->highest_prio < curr->prio)
> +		if (rt_rq->highest_prio.curr < curr->prio)
>  			resched_task(curr);
>  	}
>  }
> @@ -473,7 +473,7 @@ static inline int rt_se_prio(struct sched_rt_entity=
 *rt_se)
>  	struct rt_rq *rt_rq =3D group_rt_rq(rt_se);
> =20
>  	if (rt_rq)
> -		return rt_rq->highest_prio;
> +		return rt_rq->highest_prio.curr;
>  #endif
> =20
>  	return rt_task_of(rt_se)->prio;
> @@ -547,6 +547,21 @@ static void update_curr_rt(struct rq *rq)
>  	}
>  }
> =20
> +#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
> +
> +static struct task_struct *pick_next_highest_task_rt(struct rq *rq, in=
t cpu);
> +
> +static inline int next_prio(struct rq *rq)
> +{
> +	struct task_struct *next =3D pick_next_highest_task_rt(rq, rq->cpu);
> +
> +	if (next && rt_prio(next->prio))
> +		return next->prio;
> +	else
> +		return MAX_RT_PRIO;
> +}
> +#endif
> +
>  static inline
>  void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>  {
> @@ -560,14 +575,32 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, =
struct rt_rq *rt_rq)
>  	WARN_ON(!rt_prio(prio));
>  	rt_rq->rt_nr_running++;
>  #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
> -	if (prio < rt_rq->highest_prio) {
> +	if (prio < rt_rq->highest_prio.curr) {
> =20
> -		rt_rq->highest_prio =3D prio;
> +		/*
> +		 * If the new task is higher in priority than anything on the
> +		 * run-queue, we have a new high that must be published to
> +		 * the world.  We also know that the previous high becomes
> +		 * our next-highest.
> +		 */
> +		rt_rq->highest_prio.next =3D rt_rq->highest_prio.curr;
> +		rt_rq->highest_prio.curr =3D prio;
>  #ifdef CONFIG_SMP
>  		if (rq->online)
>  			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
>  #endif
> -	}
> +	} else if (prio =3D=3D rt_rq->highest_prio.curr)
> +		/*
> +		 * If the next task is equal in priority to the highest on
> +		 * the run-queue, then we implicitly know that the next highest
> +		 * task cannot be any lower than current
> +		 */
> +		rt_rq->highest_prio.next =3D prio;
> +	else if (prio < rt_rq->highest_prio.next)
> +		/*
> +		 * Otherwise, we need to recompute next-highest
> +		 */
> +		rt_rq->highest_prio.next =3D next_prio(rq);
>  #endif
>  #ifdef CONFIG_SMP
>  	if (rt_se->nr_cpus_allowed > 1)
> @@ -591,7 +624,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, st=
ruct rt_rq *rt_rq)
>  {
>  #ifdef CONFIG_SMP
>  	struct rq *rq =3D rq_of_rt_rq(rt_rq);
> -	int highest_prio =3D rt_rq->highest_prio;
> +	int highest_prio =3D rt_rq->highest_prio.curr;
>  #endif
> =20
>  	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
> @@ -599,24 +632,32 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, =
struct rt_rq *rt_rq)
>  	rt_rq->rt_nr_running--;
>  #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
>  	if (rt_rq->rt_nr_running) {
> -		struct rt_prio_array *array;
> +		int prio =3D rt_se_prio(rt_se);
> +
> +		WARN_ON(prio < rt_rq->highest_prio.curr);
> =20
> -		WARN_ON(rt_se_prio(rt_se) < rt_rq->highest_prio);
> -		if (rt_se_prio(rt_se) =3D=3D rt_rq->highest_prio) {
> -			/* recalculate */
> -			array =3D &rt_rq->active;
> -			rt_rq->highest_prio =3D
> +		/*
> +		 * This may have been our highest or next-highest priority
> +		 * task and therefore we may have some recomputation to do
> +		 */
> +		if (prio =3D=3D rt_rq->highest_prio.curr) {
> +			struct rt_prio_array *array =3D &rt_rq->active;
> +
> +			rt_rq->highest_prio.curr =3D
>  				sched_find_first_bit(array->bitmap);
> -		} /* otherwise leave rq->highest prio alone */
> +		}
> +
> +		if (prio =3D=3D rt_rq->highest_prio.next)
>  =20

Crap.  Trying to fall asleep tonight, I realized this is a bug I think.=20
Looks like I will need a v3

It should be "prio <=3D rt_rq->highest_prio.next" or we can miss updating=

=2Enext properly.

> +			rt_rq->highest_prio.next =3D next_prio(rq);
>  	} else
> -		rt_rq->highest_prio =3D MAX_RT_PRIO;
> +		rt_rq->highest_prio.curr =3D MAX_RT_PRIO;
>  #endif
>  #ifdef CONFIG_SMP
>  	if (rt_se->nr_cpus_allowed > 1)
>  		rq->rt.rt_nr_migratory--;
> =20
> -	if (rq->online && rt_rq->highest_prio !=3D highest_prio)
> -		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio);
> +	if (rq->online && rt_rq->highest_prio.curr !=3D highest_prio)
> +		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
> =20
>  	update_rt_migration(rq);
>  #endif /* CONFIG_SMP */
> @@ -1066,7 +1107,7 @@ static struct rq *find_lock_lowest_rq(struct task=
_struct *task, struct rq *rq)
>  		}
> =20
>  		/* If this rq is still suitable use it. */
> -		if (lowest_rq->rt.highest_prio > task->prio)
> +		if (lowest_rq->rt.highest_prio.curr > task->prio)
>  			break;
> =20
>  		/* try again */
> @@ -1254,7 +1295,7 @@ static int pull_rt_task(struct rq *this_rq)
>  static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
>  {
>  	/* Try to pull RT tasks here if we lower this rq's prio */
> -	if (unlikely(rt_task(prev)) && rq->rt.highest_prio > prev->prio)
> +	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)=

>  		pull_rt_task(rq);
>  }
> =20
> @@ -1340,7 +1381,7 @@ static void rq_online_rt(struct rq *rq)
> =20
>  	__enable_runtime(rq);
> =20
> -	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
> +	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio.curr);
>  }
> =20
>  /* Assumes rq->lock is held */
> @@ -1431,7 +1472,7 @@ static void prio_changed_rt(struct rq *rq, struct=
 task_struct *p,
>  		 * can release the rq lock and p could migrate.
>  		 * Only reschedule if p is still on the same runqueue.
>  		 */
> -		if (p->prio > rq->rt.highest_prio && rq->curr =3D=3D p)
> +		if (p->prio > rq->rt.highest_prio.curr && rq->curr =3D=3D p)
>  			resched_task(p);
>  #else
>  		/* For UP simply resched on drop of prio */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-user=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig436726C73D2079E95CF90DB0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkk3WwAACgkQlOSOBdgZUxkWsgCfflsWEuhjFECORMg1NrhQ2xDG
5b4An1m0+zs++WY5Py1ZEQ9vgWBhdWO3
=bjE/
-----END PGP SIGNATURE-----

--------------enig436726C73D2079E95CF90DB0--
