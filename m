Return-Path: <linux-kernel-owner+w=401wt.eu-S936420AbXJSTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936420AbXJSTsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbXJSTsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:48:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49660 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695AbXJSTs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:48:26 -0400
Subject: Re: [patch 2/8] track highest prio queued on runqueue
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20071019184336.349767581@goodmis.org>
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.349767581@goodmis.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b+C0aWD+euClYJ+orEqs"
Date: Fri, 19 Oct 2007 15:45:51 -0400
Message-Id: <1192823151.9564.30.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b+C0aWD+euClYJ+orEqs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-19 at 14:42 -0400, Steven Rostedt wrote:
> plain text document attachment (add-rq-highest-prio.patch)
> This patch adds accounting to each runqueue to keep track of the
> highest prio task queued on the run queue. We only care about
> RT tasks, so if the run queue does not contain any active RT tasks
> its priority will be considered MAX_RT_PRIO.
>=20
> This information will be used for later patches.
>=20
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>=20
> ---
>  kernel/sched.c    |    7 +++++++
>  kernel/sched_rt.c |   25 +++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
>=20
> Index: linux-test.git/kernel/sched.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-test.git.orig/kernel/sched.c	2007-10-19 12:33:09.000000000 -040=
0
> +++ linux-test.git/kernel/sched.c	2007-10-19 12:34:32.000000000 -0400
> @@ -324,6 +324,8 @@ struct rq {
>  	int push_cpu;
>  	/* cpu of this runqueue: */
>  	int cpu;
> +	/* highest queued rt task prio */
> +	int highest_prio;
> =20
>  	struct task_struct *migration_thread;
>  	struct list_head migration_queue;
> @@ -972,6 +974,8 @@ static void activate_task(struct rq *rq,
> =20
>  	enqueue_task(rq, p, wakeup);
>  	inc_nr_running(p, rq);
> +
> +	rq_prio_add_task(rq, p);
>  }

We are better off doing this in enqueue_task() or PI boosting will fail
to alter the prio of the RQ.

> =20
>  /*
> @@ -984,6 +988,8 @@ static void deactivate_task(struct rq *r
> =20
>  	dequeue_task(rq, p, sleep);
>  	dec_nr_running(p, rq);
> +
> +	rq_prio_remove_task(rq, p);

Ditto for dequeue_task()

>  }
> =20
>  /**
> @@ -6619,6 +6625,7 @@ void __init sched_init(void)
>  		rq->cpu =3D i;
>  		rq->migration_thread =3D NULL;
>  		INIT_LIST_HEAD(&rq->migration_queue);
> +		rq->highest_prio =3D MAX_RT_PRIO;
>  #endif
>  		atomic_set(&rq->nr_iowait, 0);
> =20
> Index: linux-test.git/kernel/sched_rt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-test.git.orig/kernel/sched_rt.c	2007-10-19 12:33:09.000000000 -=
0400
> +++ linux-test.git/kernel/sched_rt.c	2007-10-19 12:33:23.000000000 -0400
> @@ -110,6 +110,31 @@ static struct task_struct *pick_next_tas
>  	return next;
>  }
> =20
> +#ifdef CONFIG_SMP
> +static inline void rq_prio_add_task(struct rq *rq, struct task_struct *p=
)
> +{
> +	if (unlikely(rt_task(p)) && p->prio < rq->highest_prio)
> +		rq->highest_prio =3D p->prio;
> +}
> +
> +static inline void rq_prio_remove_task(struct rq *rq, struct task_struct=
 *p)
> +{
> +	struct rt_prio_array *array;
> +
> +	if (unlikely(rt_task(p))) {
> +		if (rq->rt_nr_running) {
> +			if (p->prio >=3D rq->highest_prio) {

<=3D ?

We only need to recalc if the task being removed was the highest prio
(or higher, if that were possible but it shouldnt be).

I think this logic will technically work as-is because every task is
always >=3D highest in a properly accounted system, so you will just
simply recalc for every remove.  But I do like the optimization that you
were trying to add.

So for the paranoid:

				BUG_ON(p->prio < rq->highest_prio);
				if (p->prio =3D=3D rq->highest_prio) {
					/* recalc */
				}


> +				/* recalculate */
> +				array =3D &rq->rt.active;
> +				rq->highest_prio =3D
> +					sched_find_first_bit(array->bitmap);
> +			} /* otherwise leave rq->highest prio alone */
> +		} else
> +			rq->highest_prio =3D MAX_RT_PRIO;
> +	}
> +}
> +#endif /* CONFIG_SMP */
> +
>  static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
>  {
>  	update_curr_rt(rq);
>=20

--=-b+C0aWD+euClYJ+orEqs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHGQlvSW61Ku6jJPkRAq9gAKCMnSQZYZXSFClMNsrgWGSo+l2yCwCeMiXV
Sn/Mg0qi2LyXumkfyAZHrck=
=NZGL
-----END PGP SIGNATURE-----

--=-b+C0aWD+euClYJ+orEqs--

