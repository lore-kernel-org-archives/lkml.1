Return-Path: <linux-kernel-owner+w=401wt.eu-S965741AbXAYJgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741AbXAYJgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965742AbXAYJgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:36:20 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:52512 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965741AbXAYJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:36:18 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 04:36:18 EST
Message-ID: <45B87873.3080207@freedesktop.org>
Date: Thu, 25 Jan 2007 01:29:23 -0800
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 1/2] RCU priority boosting that survives semi-vicious
 testing
References: <20070125021101.GA23428@linux.vnet.ibm.com> <20070125021444.GA22540@linux.vnet.ibm.com>
In-Reply-To: <20070125021444.GA22540@linux.vnet.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAED1FB7DE35EEC31209FDFFD"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAED1FB7DE35EEC31209FDFFD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Overall, this code looks sensible to me.  Some comments on the patch belo=
w.

Paul E. McKenney wrote:
> --- linux-2.6.20-rc4-rt1/include/linux/rcupreempt.h	2007-01-09 10:59:54=
=2E000000000 -0800
> +++ linux-2.6.20-rc4-rt1-rcub/include/linux/rcupreempt.h	2007-01-09 11:=
01:12.000000000 -0800
[...]
> +enum rcu_boost_state {
> +	RCU_BOOST_IDLE =3D 0,	   /* Not yet blocked if in RCU read-side. */
> +	RCU_BOOST_BLOCKED =3D 1,	   /* Blocked from RCU read-side. */
> +	RCU_BOOSTED =3D 2,	   /* Boosting complete. */
> +};
> +
> +#define N_RCU_BOOST_STATE (RCU_BOOSTED + 1)

Here, you define the three possible states, the number of states.  But
later...

> diff -urpNa -X dontdiff linux-2.6.20-rc4-rt1/kernel/rcupreempt.c linux-=
2.6.20-rc4-rt1-rcub/kernel/rcupreempt.c
> --- linux-2.6.20-rc4-rt1/kernel/rcupreempt.c	2007-01-09 10:59:54.000000=
000 -0800
> +++ linux-2.6.20-rc4-rt1-rcub/kernel/rcupreempt.c	2007-01-23 15:41:33.0=
00000000 -0800
> @@ -49,6 +49,7 @@
[...]
> +#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
> +	long rbs_stats[N_RCU_BOOST_DAT_EVENTS][N_RCU_BOOST_STATE + 1];
> +#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */

=2E..you declare this array to have space for one more than that, and the=
n...

> +#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
> +
> +/*
> + * Function to increment indicated ->rbs_stats[] element.
> + */
> +static inline void rcu_boost_dat_stat(struct rcu_boost_dat *rbdp,
> +				      int event,
> +				      enum rcu_boost_state oldstate)
> +{
> +	if (oldstate >=3D RCU_BOOST_IDLE &&
> +	    oldstate <=3D RCU_BOOSTED) {
> +		rbdp->rbs_stats[event][oldstate]++;
> +	} else {
> +		rbdp->rbs_stats[event][N_RCU_BOOST_STATE]++;

=2E..you use the last element as what looks like an "unknown" counter.  H=
ow
about instead defining the enum to have an "unknown" state, defining
N_RCU_BOOST_STATE accordingly, and using N_RCU_BOOST_STATE without the +1=
 in
rbs_stats?  I think that would make the code much more self-documenting, =
and
less error-prone.

> +#define rcu_boost_dat_stat_block(rbdp, oldstate) \
> +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_BLOCK, oldstate)
> +#define rcu_boost_dat_stat_boost(rbdp, oldstate) \
> +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_BOOST, oldstate)
> +#define rcu_boost_dat_stat_unlock(rbdp, oldstate) \
> +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_UNLOCK, oldstate)
> +
> +/*
> + * Prefix for kprint() strings for periodic statistics messages.
> + */
> +static char *rcu_boost_state_event[] =3D {
> +	"block:  ",
> +	"boost:  ",
> +	"unlock: ",
> +};

I don't know for sure, but I *think* that GCC may sometimes generate more=

efficient code if you use a char [][], rather than a char *[].

> +
> +/*
> + * Indicators for numbers in kprint() strings.  "!" indicates a state-=
event
> + * pair that should not happen, while "?" indicates a state that shoul=
d
> + * not happen.
> + */
> +static char *rcu_boost_state_error[] =3D {
> +       /*ibBe*/
> +	"   ?",  /* block */
> +	"!  ?",  /* boost */
> +	"?  ?",  /* unlock */
> +};

Likewise.  Also, the columns here don't seem to line up, probably because=
 the
comment uses spaces and the other lines use a tab.

> +static void rcu_boost_dat_stat_print(void)
> +{
> +	char buf[N_RCU_BOOST_STATE * (sizeof(long) * 3 + 2) + 2];

This expression really begs for some constants in place of the magic numb=
ers,
or failing that, a comment.

> +	int cpu;
> +	int event;
> +	int i;
> +	static time_t lastprint =3D 0;
> +	struct rcu_boost_dat *rbdp;
> +	int state;
> +	struct rcu_boost_dat sum;
> +
> +	/* Wait a graceful interval between printk spamming. */
> +
> +	if (xtime.tv_sec - lastprint <
> +	    CONFIG_PREEMPT_RCU_BOOST_STATS_INTERVAL)
> +		return;

How about printk_ratelimit?  It takes a parameter for the rate.  (On the =
other
hand, it also takes a spinlock, which you might not want here, even in th=
e
stats code.)

> +	/* Print them out! */
> +
> +	printk(KERN_ALERT
> +	       "rcu_boost_dat: idx=3D%d "
> +	       "b=3D%ld ul=3D%ld ub=3D%ld boost: a=3D%ld b=3D%ld\n",
> +	       rcu_boost_idx,
> +	       sum.rbs_blocked, sum.rbs_unlock, sum.rbs_unboosted,
> +	       sum.rbs_boost_attempt, sum.rbs_boost);
> +	for (event =3D 0; event < N_RCU_BOOST_DAT_EVENTS; event++) {
> +		i =3D 0;
> +		for (state =3D 0; state <=3D N_RCU_BOOST_STATE; state++) {
> +			i +=3D sprintf(&buf[i], " %ld%c",
> +				     sum.rbs_stats[event][state],
> +				     rcu_boost_state_error[event][state]);
> +		}
> +		printk(KERN_ALERT "rcu_boost_dat %s %s\n",
> +		       rcu_boost_state_event[event], buf);
> +	}

Most or all of these counters could likely become unsigned, since negativ=
e
values don't make sense for them.

> +	/* Go away and don't come back for awhile. */
> +
> +	lastprint =3D xtime.tv_sec;
> +}
> +

> +/*
> + * Return the current boost index for boosting target tasks.
> + * May only be invoked by the booster task, so guaranteed to
> + * already be initialized.
> + */
> +static inline int rcu_boost_idx_boosting(void)
> +{
> +	return (rcu_boost_idx + 1) & (RCU_BOOST_ELEMENTS - 1);
> +}

Quoted for later reference.

> +/*
> + * Initialize RCU-boost state.  This happens early in the boot process=
,
> + * when the scheduler does not yet exist.  So don't try to use it.
> + */
> +static void init_rcu_boost_early(void)
> +{
> +	struct rcu_boost_dat *rbdp;
> +	int cpu;
> +	int i;
> +
> +	for_each_possible_cpu(cpu) {
> +		rbdp =3D per_cpu(rcu_boost_dat, cpu);
> +		for (i =3D 0; i < RCU_BOOST_ELEMENTS; i++) {
> +			rbdp[i].rbs_mutex =3D
> +				RAW_SPIN_LOCK_UNLOCKED(rbdp[i].rbs_mutex);
> +			INIT_LIST_HEAD(&rbdp[i].rbs_toboost);
> +			INIT_LIST_HEAD(&rbdp[i].rbs_boosted);
> +			rbdp[i].rbs_blocked =3D 0;
> +			rbdp[i].rbs_boost_attempt =3D 0;
> +			rbdp[i].rbs_boost =3D 0;
> +			rbdp[i].rbs_unlock =3D 0;
> +			rbdp[i].rbs_unboosted =3D 0;
> +#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
> +			{
> +				int j, k;
> +
> +				for (j =3D 0; j < N_RCU_BOOST_DAT_EVENTS; j++)
> +					for (k =3D 0; k <=3D N_RCU_BOOST_STATE; k++)
> +						rbdp[i].rbs_stats[j][k] =3D 0;
> +			}
> +#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
> +		}
> +		smp_wmb();

Barrier without an accompanying comment.  You want to make sure the struc=
ture
gets initialized before setting rcu_boost_idx and thus allowing boosting,=

right?

> +		rcu_boost_idx =3D 0;
> +	}
> +}

> +/*
> + * Return the list on which the calling task should add itself, or
> + * NULL if too early during initialization.
> + */
> +static inline struct rcu_boost_dat *rcu_rbd_new(void)
> +{
> +	int cpu =3D raw_smp_processor_id();  /* locks used, so preemption OK.=
 */
> +	int idx =3D rcu_boost_idx;
> +
> +	smp_read_barrier_depends(); barrier();

Barriers without accompanying comments, though in this case they seem fai=
rly
obvious.

> +	if (unlikely(idx < 0))
> +		return (NULL);
> +	return &per_cpu(rcu_boost_dat, cpu)[idx];
> +}
> +
> +/*
> + * Return the list from which to boost target tasks.
> + * May only be invoked by the booster task, so guaranteed to
> + * already be initialized.
> + */
> +static inline struct rcu_boost_dat *rcu_rbd_boosting(int cpu)
> +{
> +	int idx =3D (rcu_boost_idx + 1) & (RCU_BOOST_ELEMENTS - 1);

You defined rcu_boost_idx_boosting for exactly this expression.

> +	return &per_cpu(rcu_boost_dat, cpu)[idx];

For that matter, since you wrapped it in the function, you could just cal=
l it
directly in this array index operation.

> +}

> +/*
> + * Priority-boost tasks stuck in RCU read-side critical sections as
> + * needed (presumably rarely).
> + */
> +static int rcu_booster(void *arg)
> +{
> +	int cpu;
> +	struct sched_param sp;
> +
> +	sp.sched_priority =3D PREEMPT_RCU_BOOSTER_PRIO;
> +	sched_setscheduler(current, SCHED_RR, &sp);
> +	current->flags |=3D PF_NOFREEZE;
> +
> +	do {
> +
> +		/* Advance the lists of tasks. */
> +
> +		rcu_boost_idx =3D (rcu_boost_idx + 1) % RCU_BOOST_ELEMENTS;
> +		for_each_possible_cpu(cpu) {
> +
> +			/*
> +			 * Boost all sufficiently aged readers.
> +			 * Readers must first be preempted or block
> +			 * on a mutex in an RCU read-side critical section,
> +			 * then remain in that critical section for
> +			 * RCU_BOOST_ELEMENTS-1 time intervals.
> +			 * So most of the time we should end up doing
> +			 * nothing.
> +			 */
> +
> +			rcu_boost_one_reader_list(rcu_rbd_boosting(cpu));
> +
> +			/*
> +			 * Large SMP systems may need to sleep sometimes
> +			 * in this loop.  Or have multiple RCU-boost tasks.
> +			 */

The idea of multiple RCU-boost tasks gives me an idea: what about having
per-CPU boost queues, and using that to eliminate the need to lock the qu=
eues?
It might not do quite as good a job of scheduling, but it would eliminate=

locking overhead *and* solve the problem you describe here.

> +		}
> +
> +		/*
> +		 * Sleep to allow any unstalled RCU read-side critical
> +		 * sections to age out of the list.  @@@ FIXME: reduce,
> +		 * adjust, or eliminate in case of OOM.
> +		 */
> +
> +		schedule_timeout_uninterruptible(HZ / 100);
> +
> +		/* Print stats if enough time has passed. */
> +
> +		rcu_boost_dat_stat_print();
> +
> +	} while (!kthread_should_stop());
> +
> +	return 0;
> +}
> +
> +/*
> + * Perform the portions of RCU-boost initialization that require the
> + * scheduler to be up and running.
> + */
> +void init_rcu_boost_late(void)
> +{
> +	int i;
> +
> +	/* Spawn RCU-boost task. */
> +
> +	printk(KERN_ALERT "Starting RCU priority booster\n");

Judging by other initialization code, I think this belongs at KERN_INFO o=
r
similar.

> +	rcu_boost_task =3D kthread_run(rcu_booster, NULL, "RCU Prio Booster")=
;
> +	if (IS_ERR(rcu_boost_task)) {
> +		i =3D PTR_ERR(rcu_boost_task);
> +		printk(KERN_ALERT
> +		       "Unable to create RCU Priority Booster, errno %d\n", -i);

No need for a temporary here.

> +
> +		/*
> +		 * Continue running, but tasks permanently blocked
> +		 * in RCU read-side critical sections will be able
> +		 * to stall grace-period processing, potentially
> +		 * OOMing the machine.
> +		 */
> +
> +		rcu_boost_task =3D NULL;
> +	}
> +}
> +
> +/*
> + * Update task's RCU-boost state to reflect blocking in RCU read-side
> + * critical section, so that the RCU-boost task can find it in case it=

> + * later needs its priority boosted.
> + */
> +void __rcu_preempt_boost(void)
> +{
> +	struct rcu_boost_dat *rbdp;
> +	unsigned long oldirq;
> +
> +	/* Identify list to place task on for possible later boosting. */
> +
> +	local_irq_save(oldirq);
> +	rbdp =3D rcu_rbd_new();
> +	if (rbdp =3D=3D NULL) {
> +		local_irq_restore(oldirq);
> +		printk("Preempted RCU read-side critical section too early.\n");

This printk lacks a priority.

> +		return;
> +	}
> +	spin_lock(&rbdp->rbs_mutex);
> +	rbdp->rbs_blocked++;
> +
> +	/*
> +	 * Update state.  We hold the lock and aren't yet on the list,
> +	 * so the booster cannot mess with us yet.
> +	 */
> +
> +	rcu_boost_dat_stat_block(rbdp, current->rcub_state);
> +	if (current->rcub_state !=3D RCU_BOOST_IDLE) {
> +
> +		/*
> +		 * We have been here before, so just update stats.
> +		 * It may seem strange to do all this work just to
> +		 * accumulate statistics, but this is such a
> +		 * low-probability code path that we shouldn't care.
> +		 * If it becomes a problem, it can be fixed.
> +		 */
> +
> +		spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
> +		return;
> +	}
> +	current->rcub_state =3D RCU_BOOST_BLOCKED;
> +
> +	/* Now add ourselves to the list so that the booster can find use. */=


Typo: s/use/us/

> +
> +	list_add_tail(&current->rcub_entry, &rbdp->rbs_toboost);
> +	current->rcub_rbdp =3D rbdp;
> +	spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
> +}

> diff -urpNa -X dontdiff linux-2.6.20-rc4-rt1/kernel/rtmutex.c linux-2.6=
=2E20-rc4-rt1-rcub/kernel/rtmutex.c
> --- linux-2.6.20-rc4-rt1/kernel/rtmutex.c	2007-01-09 10:59:54.000000000=
 -0800
> +++ linux-2.6.20-rc4-rt1-rcub/kernel/rtmutex.c	2007-01-09 11:01:12.0000=
00000 -0800
> @@ -105,11 +105,14 @@ static inline void init_lists(struct rt_
>   */
>  int rt_mutex_getprio(struct task_struct *task)
>  {
> +	int prio =3D task->normal_prio;
> +
> +	if (get_rcu_prio(task) < prio)
> +		prio =3D get_rcu_prio(task);

int prio =3D min(task->normal_prio, get_rcu_prio(task)); ?

>  	if (likely(!task_has_pi_waiters(task)))
> -		return task->normal_prio;
> +		return prio;
> =20
> -	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
> -		   task->normal_prio);
> +	return min(task_top_pi_waiter(task)->pi_list_entry.prio, prio);
>  }

- Josh Triplett


--------------enigAED1FB7DE35EEC31209FDFFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFuHh+GJuZRtD+evsRAl9eAJ9L2moBqzDI70iYRdH617R8bstFrgCfWVSp
d8dqCPn/VhLSF+5bz3W7o08=
=3s7x
-----END PGP SIGNATURE-----

--------------enigAED1FB7DE35EEC31209FDFFD--
