Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZIPQZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZIPQZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbZIPQZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:25:46 -0400
Received: from mail.pawisda.de ([213.157.4.156]:38957 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594AbZIPQZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:25:45 -0400
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 12:25:45 EDT
Subject: Re: RCU callbacks and TREE_PREEMPT_RCU
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: paulmck@linux.vnet.ibm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090916155719.GA10588@linux.vnet.ibm.com>
References: <1253110641.31751.92.camel@pc1117.cambridge.arm.com>
	 <20090916152929.GA6737@linux.vnet.ibm.com>
	 <1253115255.31751.96.camel@pc1117.cambridge.arm.com>
	 <20090916154716.GC6737@linux.vnet.ibm.com>
	 <20090916155719.GA10588@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-g4RHcn6Lqoy28Gb8Vwx/"
Date: Wed, 16 Sep 2009 18:00:50 +0200
Message-Id: <1253116850.3493.12.camel@queen>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-g4RHcn6Lqoy28Gb8Vwx/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-16 at 08:57 -0700, Paul E. McKenney wrote:
> On Wed, Sep 16, 2009 at 08:47:16AM -0700, Paul E. McKenney wrote:
> > On Wed, Sep 16, 2009 at 04:34:15PM +0100, Catalin Marinas wrote:
> > > On Wed, 2009-09-16 at 08:29 -0700, Paul E. McKenney wrote:
> > > > On Wed, Sep 16, 2009 at 03:17:21PM +0100, Catalin Marinas wrote:
> > > > > When TREE_PREEMPT_RCU is enabled, the rcu list traversing above f=
ails
> > > > > with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=3D=
n and
> > > > > TREE_RCU=3Dy. During clean-up, kmemleak objects should no longer =
be freed
> > > > > by other means since kmemleak was disabled and all callbacks are
> > > > > ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=3Dn.
> > > > >=20
> > > > > Is there something I'm doing wrong in kmemleak or a bug with RCU
> > > > > preemption? The kernel oops looks like this:
> > > >=20
> > > > From your description and the code above, I must suspect a bug with
> > > > RCU preemption.  A new one, as the only bugs I am currently chasing
> > > > involve NR_CPUS>32 (>64 on 64-bit systems).
> > > >=20
> > > > CONFIG_SMP=3Dn implies NR_CPUS=3D=3D1 in your build, correct?
> > >=20
> > > CONFIG_NR_CPUS=3D1.
> >=20
> > I was afraid of that.  ;-)
>=20
> PS to previous -- there -is- a bug in mainline for TREE_PREEMPT_RCU for
> single-CPU operation, but it is with synchronize_rcu() rather than
> call_rcu().  The fix is in tip/core/urgent, commit #366b04ca.  Or see
> the following patch.
>=20
> So, could you please give the following patch a try?

I'll give it a try.

Thanks, Eric

> Commit-ID:  366b04ca60c70479e2959fe8485b87ff380fdbbf
> Gitweb:     http://git.kernel.org/tip/366b04ca60c70479e2959fe8485b87ff380=
fdbbf
> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> AuthorDate: Sun, 13 Sep 2009 09:15:11 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 15 Sep 2009 08:43:59 +0200
>=20
> rcu: Fix synchronize_rcu() for TREE_PREEMPT_RCU
>=20
> The redirection of synchronize_sched() to synchronize_rcu() was
> appropriate for TREE_RCU, but not for TREE_PREEMPT_RCU.
>=20
> Fix this by creating an underlying synchronize_sched().  TREE_RCU
> then redirects synchronize_rcu() to synchronize_sched(), while
> TREE_PREEMPT_RCU has its own version of synchronize_rcu().
>=20
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: laijs@cn.fujitsu.com
> Cc: dipankar@in.ibm.com
> Cc: akpm@linux-foundation.org
> Cc: mathieu.desnoyers@polymtl.ca
> Cc: josh@joshtriplett.org
> Cc: dvhltc@us.ibm.com
> Cc: niv@us.ibm.com
> Cc: peterz@infradead.org
> Cc: rostedt@goodmis.org
> Cc: Valdis.Kletnieks@vt.edu
> LKML-Reference: <12528585111916-git-send-email->
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>=20
>=20
> ---
>  include/linux/rcupdate.h |   23 +++++------------------
>  include/linux/rcutree.h  |    4 ++--
>  kernel/rcupdate.c        |   44 ++++++++++++++++++++++++++++++++++++++++=
+++-
>  3 files changed, 50 insertions(+), 21 deletions(-)
>=20
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 95e0615..39dce83 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -52,8 +52,13 @@ struct rcu_head {
>  };
>=20
>  /* Exported common interfaces */
> +#ifdef CONFIG_TREE_PREEMPT_RCU
>  extern void synchronize_rcu(void);
> +#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +#define synchronize_rcu synchronize_sched
> +#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
>  extern void synchronize_rcu_bh(void);
> +extern void synchronize_sched(void);
>  extern void rcu_barrier(void);
>  extern void rcu_barrier_bh(void);
>  extern void rcu_barrier_sched(void);
> @@ -262,24 +267,6 @@ struct rcu_synchronize {
>  extern void wakeme_after_rcu(struct rcu_head  *head);
>=20
>  /**
> - * synchronize_sched - block until all CPUs have exited any non-preempti=
ve
> - * kernel code sequences.
> - *
> - * This means that all preempt_disable code sequences, including NMI and
> - * hardware-interrupt handlers, in progress on entry will have completed
> - * before this primitive returns.  However, this does not guarantee that
> - * softirq handlers will have completed, since in some kernels, these
> - * handlers can run in process context, and can block.
> - *
> - * This primitive provides the guarantees made by the (now removed)
> - * synchronize_kernel() API.  In contrast, synchronize_rcu() only
> - * guarantees that rcu_read_lock() sections will have completed.
> - * In "classic RCU", these two guarantees happen to be one and
> - * the same, but can differ in realtime RCU implementations.
> - */
> -#define synchronize_sched() __synchronize_sched()
> -
> -/**
>   * call_rcu - Queue an RCU callback for invocation after a grace period.
>   * @head: structure to be used for queueing the RCU updates.
>   * @func: actual update function to be invoked after the grace period
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index a893077..00d08c0 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -53,6 +53,8 @@ static inline void __rcu_read_unlock(void)
>  	preempt_enable();
>  }
>=20
> +#define __synchronize_sched() synchronize_rcu()
> +
>  static inline void exit_rcu(void)
>  {
>  }
> @@ -68,8 +70,6 @@ static inline void __rcu_read_unlock_bh(void)
>  	local_bh_enable();
>  }
>=20
> -#define __synchronize_sched() synchronize_rcu()
> -
>  extern void call_rcu_sched(struct rcu_head *head,
>  			   void (*func)(struct rcu_head *rcu));
>=20
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index bd5d5c8..28d2f24 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -74,6 +74,8 @@ void wakeme_after_rcu(struct rcu_head  *head)
>  	complete(&rcu->completion);
>  }
>=20
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +
>  /**
>   * synchronize_rcu - wait until a grace period has elapsed.
>   *
> @@ -87,7 +89,7 @@ void synchronize_rcu(void)
>  {
>  	struct rcu_synchronize rcu;
>=20
> -	if (rcu_blocking_is_gp())
> +	if (!rcu_scheduler_active)
>  		return;
>=20
>  	init_completion(&rcu.completion);
> @@ -98,6 +100,46 @@ void synchronize_rcu(void)
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu);
>=20
> +#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +
> +/**
> + * synchronize_sched - wait until an rcu-sched grace period has elapsed.
> + *
> + * Control will return to the caller some time after a full rcu-sched
> + * grace period has elapsed, in other words after all currently executin=
g
> + * rcu-sched read-side critical sections have completed.   These read-si=
de
> + * critical sections are delimited by rcu_read_lock_sched() and
> + * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disabl=
e(),
> + * local_irq_disable(), and so on may be used in place of
> + * rcu_read_lock_sched().
> + *
> + * This means that all preempt_disable code sequences, including NMI and
> + * hardware-interrupt handlers, in progress on entry will have completed
> + * before this primitive returns.  However, this does not guarantee that
> + * softirq handlers will have completed, since in some kernels, these
> + * handlers can run in process context, and can block.
> + *
> + * This primitive provides the guarantees made by the (now removed)
> + * synchronize_kernel() API.  In contrast, synchronize_rcu() only
> + * guarantees that rcu_read_lock() sections will have completed.
> + * In "classic RCU", these two guarantees happen to be one and
> + * the same, but can differ in realtime RCU implementations.
> + */
> +void synchronize_sched(void)
> +{
> +	struct rcu_synchronize rcu;
> +
> +	if (rcu_blocking_is_gp())
> +		return;
> +
> +	init_completion(&rcu.completion);
> +	/* Will wake me after RCU finished. */
> +	call_rcu_sched(&rcu.head, wakeme_after_rcu);
> +	/* Wait for it. */
> +	wait_for_completion(&rcu.completion);
> +}
> +EXPORT_SYMBOL_GPL(synchronize_sched);
> +
>  /**
>   * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
>   *
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=-g4RHcn6Lqoy28Gb8Vwx/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqxC7AACgkQgT9PqHll51X0xgCeKwKdQGRIbTn6R1IhfdihboFC
i3IAniWKr5PTvfaaCJ6d40ckc3f1/wDt
=/AKb
-----END PGP SIGNATURE-----

--=-g4RHcn6Lqoy28Gb8Vwx/--

