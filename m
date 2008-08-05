Return-Path: <linux-kernel-owner+w=401wt.eu-S1762301AbYHEDDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762301AbYHEDDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbYHEDDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:03:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40418 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYHEDDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:03:36 -0400
Message-ID: <4897C281.6090701@novell.com>
Date: Mon, 04 Aug 2008 23:01:21 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rosted@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, gregory.haskins@gmail.com,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>
Subject: Re: [PATCH RT RFC 7/7] rtmutex: pi-boost locks as late as possible
References: <20080801210945.3469.1183.stgit@lsg.lsg.lab.novell.com> <20080801211722.3469.55953.stgit@lsg.lsg.lab.novell.com> <4897024D.9010400@novell.com>
In-Reply-To: <4897024D.9010400@novell.com>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCE994CF394078151C43ECDBC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE994CF394078151C43ECDBC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Gregory Haskins wrote:
>> Adaptive-locking technology often times acquires the lock by
>> spinning on a running-owner instead of sleeping.  It is unecessary
>> to go through pi-boosting if the owner is of equal or (logically)
>> lower priority. Therefore, we can save some significant overhead
>> by deferring the boost until absolutely necessary.  This has shown
>> to improve overall performance in PREEMPT_RT
>>
>> Special thanks to Peter Morreale for suggesting the optimization to
>> only consider skipping the boost if the owner is >=3D to current
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Peter Morreale <pmorreale@novell.com>
>>  =20
>
> I received feedback that this prologue was too vague to accurately=20
> describe what this patch does and why it is not broken to use this=20
> optimization.  Therefore, here is the new prologue:
>
> -----------------------
> From: Gregory Haskins <ghaskins@novell.com>
>
> rtmutex: pi-boost locks as late as possible
>
> PREEMPT_RT replaces most spinlock_t instances with a preemptible
> real-time lock that supports priority inheritance.  An uncontended
> (fastpath) acquisition of this lock has no more overhead than
> its non-rt spinlock_t counterpart.  However, the contended case
> has considerably more overhead so that the lock can maintain
> proper priority queue order and support pi-boosting of the lock
> owner, yet remaining fully preemptible.
>
> Instrumentation shows that the majority of acquisitions under most
> workloads falls either into the fastpath category, or the adaptive
> spin category within the slowpath.  The necessity to pi-boost a
> lock-owner should be sufficiently rare, yet the slow-path path
> blindly incurs this overhead in 100% of contentions.
>
> Therefore, this patch intends to capitalize on this observation
> in order to reduce overhead and improve acquisition throughput.
> It is important to note that real-time latency is still treated
> as a higher order constraint than throughput, so the full
> pi-protocol is observed using new carefully constructed rules
> around the old concepts.
>
> 1) We check the priority of the owner relative to the waiter on
>   each spin of the lock (if we are not boosted already).  If the
>   owner's effective priority is logically less than the waiters
>   priority, we must boost them.
>
> 2) We check the priority of ourselves against our current queue
>   position on the waiters-list (if we are not boosted already).
>   If our priority was changed, we need to re-queue ourselves to
>   update our position.
>
> 3) We break out of the adaptive-spin if either of the above
>   conditions (1), (2) change so that we can re-evaluate the
>   lock conditions.
>
> 4) We must enter pi-boost mode if, at any time, we decide to
>   voluntarily preempt since we are losing our ability to
>   dynamically process the conditions above.
>
> Note: We still fully support priority inheritance with this
> protocol, even if we defer the low-level calls to adjust priority.
> The difference is really in terms of being a pro-active protocol
> (boost on entry), verses a reactive protocol (boost when
> necessary).  The upside to the latter is that we don't take a
> penalty for pi when it is not necessary.  The downside is that we
> technically leave the owner exposed to getting preempted, even if
> our waiter is the highest priority task in the system.

David Holmes (CC'd) pointed out that this statement is a little vague=20
and confusing as well.  The question is: how could the owner be exposed=20
to preemption since it would presumably be running at or above the=20
waiters priority or we would have boosted it already?  The answer is=20
that this is in reference to the fact that the owner may have its=20
priority lowered after we have already made the decision to defer boostin=
g.

Therefore, my updated statement should read:

"The downside is that we technically leave the owner exposed to getting=20
preempted *should it get asynchronously deprioritized*, even if ...."  =20
As I go on to explain below, this deboosting could only happen as the=20
result of a setscheduler() call, which I assert should not be cause for=20
concern. However, I wanted to highlight this phenomenon in the interest=20
of full disclosure since it is technically a difference in behavior from =

the original algorithm.  I will update the header with this edit for=20
clarity.

Thanks for the review, David!

-Greg

>   When this
> happens, the owner would be immediately boosted (because we would
> hit the "oncpu" condition, and subsequently follow the voluntary
> preempt path which boosts the owner).  Therefore, inversion is
> fully prevented, but we have the extra latency of the
> preempt/boost/wakeup that could have been avoided in the proactive
> model.
>
> However, the design of the algorithm described above constrains the
> probability of this phenomenon occurring to setscheduler()
> operations. Since rt-locks do not support being interrupted by
> signals or timeouts, waiters only depart via the acquisition path.
> And while acquisitions do deboost the owner, the owner also
> changes simultaneously, rending the deboost moot relative to the
> other waiters.
>
> What this all means is that the downside to this implementation is
> that a high-priority waiter *may* see an extra latency (equivalent
> to roughly two wake-ups) if the owner has its priority reduced via
> setscheduler() while it holds the lock.  The penalty is
> deterministic, arguably small enough, and sufficiently rare that I
> do not believe it should be an issue.
>
> Note: If the concept of other exit paths are ever introduced in the
> future, simply adapting the condition to look at owner->normal_prio
> instead of owner->prio should once again constrain the limitation
> to setscheduler().
>
> Special thanks to Peter Morreale for suggesting the optimization to
> only consider skipping the boost if the owner is >=3D to current.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Peter Morreale <pmorreale@novell.com>
>
>
>> ---
>>
>>  include/linux/rtmutex.h |    1  kernel/rtmutex.c        |  195=20
>> ++++++++++++++++++++++++++++++++++++-----------
>>  kernel/rtmutex_common.h |    1  3 files changed, 153 insertions(+),=20
>> 44 deletions(-)
>>
>> diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
>> index d984244..1d98107 100644
>> --- a/include/linux/rtmutex.h
>> +++ b/include/linux/rtmutex.h
>> @@ -33,6 +33,7 @@ struct rt_mutex {
>>          struct pi_node   node;
>>          struct pi_sink   snk;
>>          int              prio;
>> +        int              boosters;
>>      } pi;
>>  #ifdef CONFIG_DEBUG_RT_MUTEXES
>>      int            save_state;
>> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
>> index 0f64298..de213ac 100644
>> --- a/kernel/rtmutex.c
>> +++ b/kernel/rtmutex.c
>> @@ -76,14 +76,15 @@ rt_mutex_set_owner(struct rt_mutex *lock, struct=20
>> task_struct *owner,
>>  {
>>      unsigned long val =3D (unsigned long)owner | mask;
>> =20
>> -    if (rt_mutex_has_waiters(lock)) {
>> +    if (lock->pi.boosters) {
>>          struct task_struct *prev_owner =3D rt_mutex_owner(lock);
>> =20
>>          rtmutex_pi_owner(lock, prev_owner, 0);
>>          rtmutex_pi_owner(lock, owner, 1);
>> +    }
>> =20
>> +    if (rt_mutex_has_waiters(lock))
>>          val |=3D RT_MUTEX_HAS_WAITERS;
>> -    }
>> =20
>>      lock->owner =3D (struct task_struct *)val;
>>  }
>> @@ -177,7 +178,7 @@ static inline int rtmutex_pi_update(struct=20
>> pi_sink *snk,
>> =20
>>      spin_lock_irqsave(&lock->wait_lock, iflags);
>> =20
>> -    if (rt_mutex_has_waiters(lock)) {
>> +    if (lock->pi.boosters) {
>>          owner =3D rt_mutex_owner(lock);
>> =20
>>          if (owner && owner !=3D RT_RW_READER) {
>> @@ -206,6 +207,7 @@ static void init_pi(struct rt_mutex *lock)
>>      pi_node_init(&lock->pi.node);
>> =20
>>      lock->pi.prio =3D MAX_PRIO;
>> +    lock->pi.boosters =3D 0;
>>      pi_source_init(&lock->pi.src, &lock->pi.prio);
>>      lock->pi.snk =3D rtmutex_pi_snk;
>> =20
>> @@ -303,6 +305,16 @@ static inline int try_to_take_rt_mutex(struct=20
>> rt_mutex *lock)
>>      return do_try_to_take_rt_mutex(lock, STEAL_NORMAL);
>>  }
>> =20
>> +static inline void requeue_waiter(struct rt_mutex *lock,
>> +                  struct rt_mutex_waiter *waiter)
>> +{
>> +    BUG_ON(!waiter->task);
>> +
>> +    plist_del(&waiter->list_entry, &lock->wait_list);
>> +    plist_node_init(&waiter->list_entry, waiter->pi.prio);
>> +    plist_add(&waiter->list_entry, &lock->wait_list);
>> +}
>> +
>>  /*
>>   * These callbacks are invoked whenever a waiter has changed priority=
=2E
>>   * So we should requeue it within the lock->wait_list
>> @@ -343,11 +355,8 @@ static inline int=20
>> rtmutex_waiter_pi_update(struct pi_sink *snk,
>>       * pi list.  Therefore, if waiter->pi.prio has changed since we
>>       * queued ourselves, requeue it.
>>       */
>> -    if (waiter->task && waiter->list_entry.prio !=3D waiter->pi.prio)=
 {
>> -        plist_del(&waiter->list_entry, &lock->wait_list);
>> -        plist_node_init(&waiter->list_entry, waiter->pi.prio);
>> -        plist_add(&waiter->list_entry, &lock->wait_list);
>> -    }
>> +    if (waiter->task && waiter->list_entry.prio !=3D waiter->pi.prio)=

>> +        requeue_waiter(lock, waiter);
>> =20
>>      spin_unlock_irqrestore(&lock->wait_lock, iflags);
>> =20
>> @@ -359,20 +368,9 @@ static struct pi_sink rtmutex_waiter_pi_snk =3D {=

>>      .update =3D rtmutex_waiter_pi_update,
>>  };
>> =20
>> -/*
>> - * This must be called with lock->wait_lock held.
>> - */
>> -static int add_waiter(struct rt_mutex *lock,
>> -              struct rt_mutex_waiter *waiter,
>> -              unsigned long *flags)
>> +static void boost_lock(struct rt_mutex *lock,
>> +               struct rt_mutex_waiter *waiter)
>>  {
>> -    int has_waiters =3D rt_mutex_has_waiters(lock);
>> -
>> -    waiter->task =3D current;
>> -    waiter->lock =3D lock;
>> -    waiter->pi.prio =3D current->prio;
>> -    plist_node_init(&waiter->list_entry, waiter->pi.prio);
>> -    plist_add(&waiter->list_entry, &lock->wait_list);
>>      waiter->pi.snk =3D rtmutex_waiter_pi_snk;
>> =20
>>      /*
>> @@ -397,35 +395,28 @@ static int add_waiter(struct rt_mutex *lock,
>>       * If we previously had no waiters, we are transitioning to
>>       * a mode where we need to boost the owner
>>       */
>> -    if (!has_waiters) {
>> +    if (!lock->pi.boosters) {
>>          struct task_struct *owner =3D rt_mutex_owner(lock);
>>          rtmutex_pi_owner(lock, owner, 1);
>>      }
>> =20
>> -    spin_unlock_irqrestore(&lock->wait_lock, *flags);
>> -    task_pi_update(current, 0);
>> -    spin_lock_irqsave(&lock->wait_lock, *flags);
>> -
>> -    return 0;
>> +    lock->pi.boosters++;
>> +    waiter->pi.boosted =3D 1;
>>  }
>> =20
>> -/*
>> - * Remove a waiter from a lock
>> - *
>> - * Must be called with lock->wait_lock held
>> - */
>> -static void remove_waiter(struct rt_mutex *lock,
>> -              struct rt_mutex_waiter *waiter)
>> +static void deboost_lock(struct rt_mutex *lock,
>> +             struct rt_mutex_waiter *waiter,
>> +             struct task_struct *p)
>>  {
>> -    struct task_struct *p =3D waiter->task;
>> +    BUG_ON(!waiter->pi.boosted);
>> =20
>> -    plist_del(&waiter->list_entry, &lock->wait_list);
>> -    waiter->task =3D NULL;
>> +    waiter->pi.boosted =3D 0;
>> +    lock->pi.boosters--;
>> =20
>>      /*
>>       * We can stop boosting the owner if there are no more waiters
>>       */
>> -    if (!rt_mutex_has_waiters(lock)) {
>> +    if (!lock->pi.boosters) {
>>          struct task_struct *owner =3D rt_mutex_owner(lock);
>>          rtmutex_pi_owner(lock, owner, 0);
>>      }
>> @@ -446,6 +437,51 @@ static void remove_waiter(struct rt_mutex *lock,
>>  }
>> =20
>>  /*
>> + * This must be called with lock->wait_lock held.
>> + */
>> +static void _add_waiter(struct rt_mutex *lock,
>> +            struct rt_mutex_waiter *waiter)
>> +{
>> +    waiter->task =3D current;
>> +    waiter->lock =3D lock;
>> +    waiter->pi.prio =3D current->prio;
>> +    plist_node_init(&waiter->list_entry, waiter->pi.prio);
>> +    plist_add(&waiter->list_entry, &lock->wait_list);
>> +}
>> +
>> +static int add_waiter(struct rt_mutex *lock,
>> +              struct rt_mutex_waiter *waiter,
>> +              unsigned long *flags)
>> +{
>> +    _add_waiter(lock, waiter);
>> +
>> +    boost_lock(lock, waiter);
>> +
>> +    spin_unlock_irqrestore(&lock->wait_lock, *flags);
>> +    task_pi_update(current, 0);
>> +    spin_lock_irqsave(&lock->wait_lock, *flags);
>> +
>> +    return 0;
>> +}
>> +
>> +/*
>> + * Remove a waiter from a lock
>> + *
>> + * Must be called with lock->wait_lock held
>> + */
>> +static void remove_waiter(struct rt_mutex *lock,
>> +               struct rt_mutex_waiter *waiter)
>> +{
>> +    struct task_struct *p =3D waiter->task;
>> +
>> +    plist_del(&waiter->list_entry, &lock->wait_list);
>> +    waiter->task =3D NULL;
>> +
>> +    if (waiter->pi.boosted)
>> +        deboost_lock(lock, waiter, p);
>> +}
>> +
>> +/*
>>   * Wake up the next waiter on the lock.
>>   *
>>   * Remove the top waiter from the current tasks waiter list and from
>> @@ -558,6 +594,24 @@ static int adaptive_wait(struct rt_mutex_waiter=20
>> *waiter,
>>          if (orig_owner !=3D rt_mutex_owner(waiter->lock))
>>              return 0;
>> =20
>> +        /* Special handling for when we are not in pi-boost mode */
>> +        if (!waiter->pi.boosted) {
>> +            /*
>> +             * Are we higher priority than the owner?  If so
>> +             * we should bail out immediately so that we can
>> +             * pi boost them.
>> +             */
>> +            if (current->prio < orig_owner->prio)
>> +                return 0;
>> +
>> +            /*
>> +             * Did our priority change? If so, we need to
>> +             * requeue our position in the list
>> +             */
>> +            if (waiter->pi.prio !=3D current->prio)
>> +                return 0;
>> +        }
>> +
>>          /* Owner went to bed, so should we */
>>          if (!task_is_current(orig_owner))
>>              return 1;
>> @@ -599,6 +653,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>>      unsigned long saved_state, state, flags;
>>      struct task_struct *orig_owner;
>>      int missed =3D 0;
>> +    int boosted =3D 0;
>> =20
>>      init_waiter(&waiter);
>> =20
>> @@ -631,26 +686,54 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>>          }
>>          missed =3D 1;
>> =20
>> +        orig_owner =3D rt_mutex_owner(lock);
>> +
>>          /*
>>           * waiter.task is NULL the first time we come here and
>>           * when we have been woken up by the previous owner
>>           * but the lock got stolen by an higher prio task.
>>           */
>> -        if (!waiter.task) {
>> -            add_waiter(lock, &waiter, &flags);
>> +        if (!waiter.task)
>> +            _add_waiter(lock, &waiter);
>> +
>> +        /*
>> +         * We only need to pi-boost the owner if they are lower
>> +         * priority than us.  We dont care if this is racy
>> +         * against priority changes as we will break out of
>> +         * the adaptive spin anytime any priority changes occur
>> +         * without boosting enabled.
>> +         */
>> +        if (!waiter.pi.boosted && current->prio < orig_owner->prio) {=

>> +            boost_lock(lock, &waiter);
>> +            boosted =3D 1;
>> +
>> +            spin_unlock_irqrestore(&lock->wait_lock, flags);
>> +            task_pi_update(current, 0);
>> +            spin_lock_irqsave(&lock->wait_lock, flags);
>> +
>>              /* Wakeup during boost ? */
>>              if (unlikely(!waiter.task))
>>                  continue;
>>          }
>> =20
>>          /*
>> +         * If we are not currently pi-boosting the lock, we have to
>> +         * monitor whether our priority changed since the last
>> +         * time it was recorded and requeue ourselves if it moves.
>> +         */
>> +        if (!waiter.pi.boosted && waiter.pi.prio !=3D current->prio) =
{
>> +            waiter.pi.prio =3D current->prio;
>> +
>> +            requeue_waiter(lock, &waiter);
>> +        }
>> +
>> +        /*
>>           * Prevent schedule() to drop BKL, while waiting for
>>           * the lock ! We restore lock_depth when we come back.
>>           */
>>          saved_flags =3D current->flags & PF_NOSCHED;
>>          current->lock_depth =3D -1;
>>          current->flags &=3D ~PF_NOSCHED;
>> -        orig_owner =3D rt_mutex_owner(lock);
>>          get_task_struct(orig_owner);
>>          spin_unlock_irqrestore(&lock->wait_lock, flags);
>> =20
>> @@ -664,6 +747,24 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>>               * barrier which we rely upon to ensure current->state
>>               * is visible before we test waiter.task.
>>               */
>> +            if (waiter.task && !waiter.pi.boosted) {
>> +                spin_lock_irqsave(&lock->wait_lock, flags);
>> +
>> +                /*
>> +                 * We get here if we have not yet boosted
>> +                 * the lock, yet we are going to sleep. If
>> +                 * we are still pending (waiter.task !=3D 0),
>> +                 * then go ahead and boost them now
>> +                 */
>> +                if (waiter.task) {
>> +                    boost_lock(lock, &waiter);
>> +                    boosted =3D 1;
>> +                }
>> +
>> +                spin_unlock_irqrestore(&lock->wait_lock, flags);
>> +                task_pi_update(current, 0);
>> +            }
>> +
>>              if (waiter.task)
>>                  schedule_rt_mutex(lock);
>>          } else
>> @@ -696,7 +797,8 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>>      spin_unlock_irqrestore(&lock->wait_lock, flags);
>> =20
>>      /* Undo any pi boosting, if necessary */
>> -    task_pi_update(current, 0);
>> +    if (boosted)
>> +        task_pi_update(current, 0);
>> =20
>>      debug_rt_mutex_free_waiter(&waiter);
>>  }
>> @@ -708,6 +810,7 @@ static void  noinline __sched
>>  rt_spin_lock_slowunlock(struct rt_mutex *lock)
>>  {
>>      unsigned long flags;
>> +    int deboost =3D 0;
>> =20
>>      spin_lock_irqsave(&lock->wait_lock, flags);
>> =20
>> @@ -721,12 +824,16 @@ rt_spin_lock_slowunlock(struct rt_mutex *lock)
>>          return;
>>      }
>> =20
>> +    if (lock->pi.boosters)
>> +        deboost =3D 1;
>> +
>>      wakeup_next_waiter(lock, 1);
>> =20
>>      spin_unlock_irqrestore(&lock->wait_lock, flags);
>> =20
>> -    /* Undo pi boosting when necessary */
>> -    task_pi_update(current, 0);
>> +    if (deboost)
>> +        /* Undo pi boosting when necessary */
>> +        task_pi_update(current, 0);
>>  }
>> =20
>>  void __lockfunc rt_spin_lock(spinlock_t *lock)
>> diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
>> index 7bf32d0..34e2381 100644
>> --- a/kernel/rtmutex_common.h
>> +++ b/kernel/rtmutex_common.h
>> @@ -55,6 +55,7 @@ struct rt_mutex_waiter {
>>      struct {
>>          struct pi_sink   snk;
>>          int              prio;
>> +        int              boosted;
>>      } pi;
>>  #ifdef CONFIG_DEBUG_RT_MUTEXES
>>      unsigned long        ip;
>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe=20
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>  =20
>
>



--------------enigCE994CF394078151C43ECDBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkiXwoEACgkQlOSOBdgZUxlOyACfQrgY8fWbMNdqTLNMTrCbAjts
9KcAnjdlVFieqW3KR4FMXybDlN5eazK1
=/wyE
-----END PGP SIGNATURE-----

--------------enigCE994CF394078151C43ECDBC--
