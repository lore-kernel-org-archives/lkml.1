Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYHUMt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYHUMt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYHUMtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:49:46 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45731 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYHUMtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:49:45 -0400
Message-ID: <48AD63DD.7000701@novell.com>
Date: Thu, 21 Aug 2008 08:47:25 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       vatsa <vatsa@in.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
 load balancing
References: <1219310330.8651.93.camel@twins> <1219322602.8651.123.camel@twins>
In-Reply-To: <1219322602.8651.123.camel@twins>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig07175B77BD3E8E278BC16B55"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig07175B77BD3E8E278BC16B55
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> OK, how overboard is this? (utterly uncompiled and such)
>
> I realized while trying to do the (soft)irq accounting Ingo asked for,
> that IRQs can preempt SoftIRQs which can preempt RT tasks.
>
> Therefore we actually need to account all these times, so that we can
> subtract irq time from measured softirq time, etc.
>
> So this patch does all that.. we could even use this more accurate time=

> spend on the task delta to drive the scheduler.
>
> NOTE - for now I've only considered softirq from hardirq time, as
> ksoftirqd is its own task and is already accounted the regular way.
>  =20

Actually, if you really want to get crazy, you could account for each RT =

prio level as well ;)

e.g. RT98 tasks have to account for RT99 + softirqs + irqs, RT97 need to =

look at RT98, 99, softirqs, irqs, etc.

I'm not suggesting we do this, per se.   Just food for thought.  It=20
would have the benefit of allowing us to make even better routing=20
decisions for RT tasks.  E.g. if cores 2 and 6 both have the lowest=20
priority, we currently sort by sched-domain topology, but we could also=20
factor in the load that is "above" us.

BTW: this is probably not a bad idea even if its just to look at the=20
softirq/hardirq load.  Perhaps I will draft up a patch.

-Greg

> ---
> Index: linux-2.6/kernel/sched.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -572,9 +572,17 @@ struct rq {
>  	struct task_struct *migration_thread;
>  	struct list_head migration_queue;
> =20
> -	u64 irq_stamp;
> -	unsigned long irq_time;
> -	unsigned long rt_time;
> +	u64 irq_clock_stamp;
> +	u64 sirq_clock_stamp, sirq_irq_stamp;
> +	u64 rt_sirq_stamp, rt_irq_stamp;
> +
> +	u64 rt_time;
> +	u64 sirq_time;
> +	u64 rt_time;
> +
> +	unsigned long irq_avg;
> +	unsigned long sirq_avg;
> +	unsigned long rt_avg;
>  	u64 age_stamp;
> =20
>  #endif
> @@ -1167,7 +1175,7 @@ void sched_irq_enter(void)
>  		struct rq *rq =3D this_rq();
> =20
>  		update_rq_clock(rq);
> -		rq->irq_stamp =3D rq->clock;
> +		rq->irq_clock_stamp =3D rq->clock;
>  	}
>  }
> =20
> @@ -1175,12 +1183,58 @@ void sched_irq_exit(void)
>  {
>  	if (!in_irq()) {
>  		struct rq *rq =3D this_rq();
> +		u64 irq_delta;
> =20
>  		update_rq_clock(rq);
> -		rq->irq_time +=3D rq->clock - rq->irq_stamp;
> +		irq_delta =3D rq->clock - rq->irq_clock_stamp;
> +		rq->irq_time +=3D irq_delta;
> +		rq->irq_avg +=3D irq_delta;
>  	}
>  }
> =20
> +void sched_softirq_enter(void)
> +{
> +	struct rq *rq =3D this_rq();
> +
> +	update_rq_clock(rq);
> +	rq->sirq_clock_stamp =3D rq->clock;
> +	rq->sirq_irq_stamp =3D rq->irq_time;
> +}
> +
> +void sched_softirq_exit(void)
> +{
> +	struct rq *rq =3D this_rq();
> +	u64 sirq_delta, irq_delta;
> +
> +	update_rq_clock(rq);
> +	sirq_delta =3D rq->clock - rq->sirq_clock_stamp;
> +	irq_delta =3D rq->irq_time - rq->sirq_irq_stamp;
> +	sirq_delta -=3D irq_delta;
> +	rq->sirq_time +=3D sirq_delta;
> +	rq->sirq_avg +=3D sirq_delta;
> +}
> +
> +void sched_rt_start(struct rq *rq)
> +{
> +	rq->rt_sirq_stamp =3D rq->sirt_time;
> +	rq->rt_irq_stamp =3D rq->irq_time;
> +}
> +
> +void sched_rt_update(struct rq *rq, u64 rt_delta)
> +{
> +	u64 sirq_delta, irq_delta;
> +
> +	sirq_delta =3D rq->sirq_time - rq->rt_sirq_stamp;
> +	irq_delta =3D rq->irq_time - rq->rt_irq_stamp;
> +
> +	rt_delta -=3D sirq_delta + irq_delta;
> +
> +	rq->rt_time +=3D rt_delta;
> +	rq->rt_avg +=3D rt_delta;
> +
> +	sched_rt_start(rq);
> +}
> +
>  static inline u64 sched_avg_period(void)
>  {
>  	return (u64)sysctl_sched_time_avg * (NSEC_PER_MSEC / 2);
> @@ -1192,8 +1246,9 @@ static inline u64 sched_avg_period(void)
>  static void sched_age_time(struct rq *rq)
>  {
>  	if (rq->clock - rq->age_stamp >=3D sched_avg_period()) {
> -		rq->irq_time /=3D 2;
> -		rq->rt_time /=3D 2;
> +		rq->rt_avg /=3D 2;
> +		rq->irq_avg /=3D 2;
> +		rq->sirq_avg /=3D 2;
>  		rq->age_stamp =3D rq->clock;
>  	}
>  }
> @@ -1207,7 +1262,7 @@ static void sched_age_time(struct rq *rq
>  static unsigned long sched_scale_load(struct rq *rq, u64 load)
>  {
>  	u64 total =3D sched_avg_period() + (rq->clock - rq->age_stamp);
> -	u64 available =3D total - rq->irq_time - rq->rt_time;
> +	u64 available =3D total - rq->sirq_avg - rq->irq_avg - rq->rt_avg;
> =20
>  	/*
>  	 * Shift back to roughly us scale, so that the divisor fits in u32.
> @@ -1227,9 +1282,22 @@ static unsigned long sched_scale_load(st
>  	return min_t(unsigned long, load, 1UL << 22);
>  }
>  #else
> +static inline void sched_rt_start(struct rq *rq)
> +{
> +}
> +
> +static inline void sched_rt_update(struct rq *rq, u64 delta)
> +{
> +}
> +
>  static inline void sched_age_time(struct rq *rq)
>  {
>  }
> +
> +static inline unsigned long sched_scale_load(unsigned long load)
> +{
> +	return load;
> +}
>  #endif
> =20
>  /*
> Index: linux-2.6/kernel/sched_rt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -478,13 +478,7 @@ static void update_curr_rt(struct rq *rq
>  	if (unlikely((s64)delta_exec < 0))
>  		delta_exec =3D 0;
> =20
> -#ifdef CONFIG_SMP
> -	/*
> -	 * Account the time spend running RT tasks on this rq. Used to inflat=
e
> -	 * this rq's load values.
> -	 */
> -	rq->rt_time +=3D delta_exec;
> -#endif
> +	sched_rt_update(rq, delta_exec);
> =20
>  	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));=

> =20
> @@ -678,8 +672,6 @@ static void enqueue_task_rt(struct rq *r
>  		rt_se->timeout =3D 0;
> =20
>  	enqueue_rt_entity(rt_se);
> -
> -	inc_cpu_load(rq, p->se.load.weight);
>  }
> =20
>  static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int =
sleep)
> @@ -688,8 +680,6 @@ static void dequeue_task_rt(struct rq *r
> =20
>  	update_curr_rt(rq);
>  	dequeue_rt_entity(rt_se);
> -
> -	dec_cpu_load(rq, p->se.load.weight);
>  }
> =20
>  /*
> @@ -1458,6 +1448,7 @@ static void set_curr_task_rt(struct rq *
>  	struct task_struct *p =3D rq->curr;
> =20
>  	p->se.exec_start =3D rq->clock;
> +	sched_rt_start(rq);
>  }
> =20
>  static const struct sched_class rt_sched_class =3D {
> Index: linux-2.6/kernel/softirq.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/softirq.c
> +++ linux-2.6/kernel/softirq.c
> @@ -272,6 +272,14 @@ void irq_enter(void)
>  # define invoke_softirq()	do_softirq()
>  #endif
> =20
> +#ifdef CONFIG_SMP
> +extern void sched_softirq_enter(void);
> +extern void sched_softirq_exit(void);
> +#else
> +#define sched_softirq_enter() do { } while (0)
> +#define sched_softirq_exit()  do { } while (0)
> +#endif
> +
>  /*
>   * Exit an interrupt context. Process softirqs if needed and possible:=

>   */
> @@ -281,8 +289,11 @@ void irq_exit(void)
>  	trace_hardirq_exit();
>  	sub_preempt_count(IRQ_EXIT_OFFSET);
>  	sched_irq_exit();
> -	if (!in_interrupt() && local_softirq_pending())
> +	if (!in_interrupt() && local_softirq_pending()) {
> +		sched_softirq_enter();
>  		invoke_softirq();
> +		sched_softirq_exit();
> +	}
> =20
>  #ifdef CONFIG_NO_HZ
>  	/* Make sure that timer wheel updates are propagated */
>
>
>  =20



--------------enig07175B77BD3E8E278BC16B55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkitY90ACgkQlOSOBdgZUxlfBwCfXjQEg2Cz7/J+IcUX1KtxJE6E
GagAn3NJ9jxaynQSEnCqOTxKtQH5KA8V
=//2t
-----END PGP SIGNATURE-----

--------------enig07175B77BD3E8E278BC16B55--
