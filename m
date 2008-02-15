Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbYBOQrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbYBOQrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYBOQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:46:50 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:40911 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbYBOQqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=Ti+c+pU+d7fqrQMHYfSMrWcBolQfJMFQ2VtBJImSNDbk12YFqbXl6PXD9Gv55GXpCo4WgI9KuYlhc8IHDs5irVE37uJjZCZptk2jfZq8LvHOZggsqGCJOGtP++8KqEmHHmlPCbND9iT5ycz1XshQixPr5O0aNd+xx2QKH40Axac=
Message-ID: <47B5C1E1.5090706@gmail.com>
Date: Fri, 15 Feb 2008 11:46:25 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] sched: fair-group: per root-domain load balancing
References: <20080214155724.772744000@chello.nl> <20080214160234.681387000@chello.nl>
In-Reply-To: <20080214160234.681387000@chello.nl>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig71DF01CA98A44B63AA163905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig71DF01CA98A44B63AA163905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> Currently the lb_monitor will walk all the domains/cpus from a single
> cpu's timer interrupt. This will cause massive cache-trashing and cache=
-line
> bouncing on larger machines.
>=20
> Split the lb_monitor into root_domain (disjoint sched-domains).
>=20
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Gregory Haskins <gregory.haskins.ml@gmail.com>
> ---
>  kernel/sched.c      |  106 ++++++++++++++++++++++++++++---------------=
---------
>  kernel/sched_fair.c |    2=20
>  2 files changed, 59 insertions(+), 49 deletions(-)
>=20
> Index: linux-2.6/kernel/sched.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -357,8 +357,6 @@ struct lb_monitor {
>  	spinlock_t lock;
>  };
> =20
> -static struct lb_monitor lb_monitor;
> -
>  /*
>   * How frequently should we rebalance_shares() across cpus?
>   *
> @@ -417,6 +415,9 @@ static void lb_monitor_wake(struct lb_mo
>  	if (hrtimer_active(&lb_monitor->timer))
>  		return;
> =20
> +	/*
> +	 * XXX: rd->load_balance && weight(rd->span) > 1
> +	 */
>  	if (nr_cpu_ids =3D=3D 1)
>  		return;
> =20
> @@ -444,6 +445,11 @@ static void lb_monitor_init(struct lb_mo
> =20
>  	spin_lock_init(&lb_monitor->lock);
>  }
> +
> +static int lb_monitor_destroy(struct lb_monitor *lb_monitor)
> +{
> +	return hrtimer_cancel(&lb_monitor->timer);
> +}
>  #endif
> =20
>  static void set_se_shares(struct sched_entity *se, unsigned long share=
s);
> @@ -607,6 +613,8 @@ struct root_domain {
>  	 */
>  	cpumask_t rto_mask;
>  	atomic_t rto_count;
> +
> +	struct lb_monitor lb_monitor;
>  };
> =20
>  /*
> @@ -6328,6 +6336,7 @@ static void rq_attach_root(struct rq *rq
>  {
>  	unsigned long flags;
>  	const struct sched_class *class;
> +	int active =3D 0;
> =20
>  	spin_lock_irqsave(&rq->lock, flags);
> =20
> @@ -6342,8 +6351,14 @@ static void rq_attach_root(struct rq *rq
>  		cpu_clear(rq->cpu, old_rd->span);
>  		cpu_clear(rq->cpu, old_rd->online);
> =20
> -		if (atomic_dec_and_test(&old_rd->refcount))
> +		if (atomic_dec_and_test(&old_rd->refcount)) {
> +			/*
> +			 * sync with active timers.
> +			 */
> +			active =3D lb_monitor_destroy(&old_rd->lb_monitor);
> +
>  			kfree(old_rd);

Note that this works out to be a bug in my code on -rt since you cannot=20
kfree() while the raw rq->lock is held.  This isn't your problem, per=20
se, but just a heads up that I might need to patch this area ASAP.

> +		}
>  	}
> =20
>  	atomic_inc(&rd->refcount);
> @@ -6358,6 +6373,9 @@ static void rq_attach_root(struct rq *rq
>  			class->join_domain(rq);
>  	}
> =20
> +	if (active)
> +		lb_monitor_wake(&rd->lb_monitor);
> +
>  	spin_unlock_irqrestore(&rq->lock, flags);
>  }
> =20
> @@ -6367,6 +6385,8 @@ static void init_rootdomain(struct root_
> =20
>  	cpus_clear(rd->span);
>  	cpus_clear(rd->online);
> +
> +	lb_monitor_init(&rd->lb_monitor);
>  }
> =20
>  static void init_defrootdomain(void)
> @@ -7398,10 +7418,6 @@ void __init sched_init(void)
> =20
>  #ifdef CONFIG_SMP
>  	init_defrootdomain();
> -
> -#ifdef CONFIG_FAIR_GROUP_SCHED
> -	lb_monitor_init(&lb_monitor);
> -#endif
>  #endif
>  	init_rt_bandwidth(&def_rt_bandwidth,
>  			global_rt_period(), global_rt_runtime());
> @@ -7631,11 +7647,11 @@ void set_curr_task(int cpu, struct task_
>   * distribute shares of all task groups among their schedulable entiti=
es,
>   * to reflect load distribution across cpus.
>   */
> -static int rebalance_shares(struct sched_domain *sd, int this_cpu)
> +static int rebalance_shares(struct root_domain *rd, int this_cpu)
>  {
>  	struct cfs_rq *cfs_rq;
>  	struct rq *rq =3D cpu_rq(this_cpu);
> -	cpumask_t sdspan =3D sd->span;
> +	cpumask_t sdspan =3D rd->span;
>  	int state =3D shares_idle;
> =20
>  	/* Walk thr' all the task groups that we have */
> @@ -7685,50 +7701,12 @@ static int rebalance_shares(struct sched
>  	return state;
>  }
> =20
> -static int load_balance_shares(struct lb_monitor *lb_monitor)
> +static void set_lb_monitor_timeout(struct lb_monitor *lb_monitor, int =
state)
>  {
> -	int i, cpu, state =3D shares_idle;
>  	u64 max_timeout =3D (u64)sysctl_sched_max_bal_int_shares * NSEC_PER_M=
SEC;
>  	u64 min_timeout =3D (u64)sysctl_sched_min_bal_int_shares * NSEC_PER_M=
SEC;
>  	u64 timeout;
> =20
> -	/* Prevent cpus going down or coming up */
> -	/* get_online_cpus(); */
> -	/* lockout changes to doms_cur[] array */
> -	/* lock_doms_cur(); */
> -	/*
> -	 * Enter a rcu read-side critical section to safely walk rq->sd
> -	 * chain on various cpus and to walk task group list
> -	 * (rq->leaf_cfs_rq_list) in rebalance_shares().
> -	 */
> -	rcu_read_lock();
> -
> -	for (i =3D 0; i < ndoms_cur; i++) {
> -		cpumask_t cpumap =3D doms_cur[i];
> -		struct sched_domain *sd =3D NULL, *sd_prev =3D NULL;
> -
> -		cpu =3D first_cpu(cpumap);
> -
> -		/* Find the highest domain at which to balance shares */
> -		for_each_domain(cpu, sd) {
> -			if (!(sd->flags & SD_LOAD_BALANCE))
> -				continue;
> -			sd_prev =3D sd;
> -		}
> -
> -		sd =3D sd_prev;
> -		/* sd =3D=3D NULL? No load balance reqd in this domain */
> -		if (!sd)
> -			continue;
> -
> -		state =3D max(state, rebalance_shares(sd, cpu));
> -	}
> -
> -	rcu_read_unlock();
> -
> -	/* unlock_doms_cur(); */
> -	/* put_online_cpus(); */
> -
>  	timeout =3D ktime_to_ns(lb_monitor->timeout);
>  	switch (state) {
>  	case shares_balanced:
> @@ -7741,6 +7719,38 @@ static int load_balance_shares(struct lb
>  		break;
>  	}
>  	lb_monitor->timeout =3D ns_to_ktime(timeout);
> +}
> +
> +static int load_balance_shares(struct lb_monitor *lb_monitor)
> +{
> +	int cpu =3D smp_processor_id();
> +	struct rq *rq =3D cpu_rq(cpu);
> +	struct root_domain *rd;
> +	struct sched_domain *sd, *sd_prev =3D NULL;
> +	int state =3D shares_idle;
> +
> +	spin_lock(&rq->lock);
> +	/*
> +	 * root_domain will stay valid until timer exits - synchronized by
> +	 * hrtimer_cancel().
> +	 */
> +	rd =3D rq->rd;
> +	spin_unlock(&rq->lock);

I know we talked about this on IRC, I'm am still skeptical about this=20
part of the code.  Normally we only guarantee the stability of the=20
rq->rd pointer while the rq->lock is held or a rd->refcount is added.=20
It would be "safer" to bracket this code with an up/down sequence on the =

rd->refcount, but perhaps you can convince me that it is not needed?=20
(i.e. I am still not understanding how the timer guarantees the stability=
).

[up-ref]

> +
> +	/*
> +	 * complicated way to find rd->load_balance
> +	 */
> +	rcu_read_lock();
> +	for_each_domain(cpu, sd) {
> +		if (!(sd->flags & SD_LOAD_BALANCE))
> +			continue;
> +		sd_prev =3D sd;
> +	}
> +	if (sd_prev)
> +		state =3D max(state, rebalance_shares(rd, cpu));
> +	rcu_read_unlock();
> +

[down-ref]

We would of course need to re-work the drop-ref code so it could be=20
freed independent of the rq_attach_root() function, but that should be=20
trivial.

> +	set_lb_monitor_timeout(lb_monitor, state);
> =20
>  	return state;
>  }
> Index: linux-2.6/kernel/sched_fair.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -553,7 +553,7 @@ account_entity_enqueue(struct cfs_rq *cf
>  	se->on_rq =3D 1;
>  	list_add(&se->group_node, &cfs_rq->tasks);
>  #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
> -	lb_monitor_wake(&lb_monitor);
> +	lb_monitor_wake(&rq_of(cfs_rq)->rd->lb_monitor);
>  #endif
>  }
> =20
>=20
> --
>=20
>=20



--------------enig71DF01CA98A44B63AA163905
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHtcHmP5K2CMvXmqERAoUxAJ9XbjAk/Bxunl/DIonvWfWM5n9nagCdFrCL
1g0/fWRnAUlkrlPhjwRoejo=
=NkES
-----END PGP SIGNATURE-----

--------------enig71DF01CA98A44B63AA163905--
