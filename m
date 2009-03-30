Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZC3XcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZC3XcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZC3XcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:32:15 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46588 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbZC3XcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:32:13 -0400
Message-ID: <49D15667.9050307@us.ibm.com>
Date: Mon, 30 Mar 2009 16:31:51 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 8/8] RFC: futex: add requeue_pi calls
References: <20090330213306.606.9540.stgit@Aeon> <20090330213840.606.59261.stgit@Aeon> <49D13DDB.7010302@cosmosbay.com> <49D14B3D.4020107@us.ibm.com>
In-Reply-To: <49D14B3D.4020107@us.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Eric Dumazet wrote:
> 
> Two more nice catches, thanks.  Corrected patch below.

If anyone is still wanting to pull these from git, you can grab them 
from my -dev branch.  Note: I pop and push branches to this branch, 
whereas the versioned branches will remain constant.

http://git.kernel.org/?p=linux/kernel/git/dvhart/linux-2.6-tip-hacks.git;a=shortlog;h=requeue-pi-dev

Thanks,

Darren

> 
>>> +static long futex_lock_pi_restart(struct restart_block *restart)
>>> +{
>>> +    u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
>>> +    ktime_t t, *tp = NULL;
>>> +    int fshared = restart->futex.flags & FLAGS_SHARED;
>>> +
>>> +    if (restart->futex.flags | FLAGS_HAS_TIMEOUT) {
>>
>> if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
> 
> 
>> if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
>>
>>> +        t.tv64 = restart->futex.time;
>>> +        tp = &t;
>>> +    }
>>> +    restart->fn = do_no_restart_syscall;
>>> +
>>
>>
>> Strange your compiler dit not complains...
> 
> Well, the comparison with an "|" is still valid - just happens to always
> be true :-)  I didn't get any errors - perhaps I should be compiling
> with some addition options?
> 
> 
> RFC: futex: add requeue_pi calls
> 
> From: Darren Hart <dvhltc@us.ibm.com>
> 
> PI Futexes and their underlying rt_mutex cannot be left ownerless if 
> there are
> pending waiters as this will break the PI boosting logic, so the standard
> requeue commands aren't sufficient.  The new commands properly manage pi 
> futex
> ownership by ensuring a futex with waiters has an owner at all times.  This
> will allow glibc to properly handle pi mutexes with pthread_condvars.
> 
> The approach taken here is to create two new futex op codes:
> 
> FUTEX_WAIT_REQUEUE_PI:
> Tasks will use this op code to wait on a futex (such as a non-pi waitqueue)
> and wake after they have been requeued to a pi futex.  Prior to 
> returning to
> userspace, they will acquire this pi futex (and the underlying rt_mutex).
> 
> futex_wait_requeue_pi() is the result of a high speed collision between
> futex_wait() and futex_lock_pi() (with the first part of futex_lock_pi() 
> being
> done by futex_proxy_trylock_atomic() on behalf of the top_waiter).
> 
> FUTEX_REQUEUE_PI (and FUTEX_CMP_REQUEUE_PI):
> This call must be used to wake tasks waiting with FUTEX_WAIT_REQUEUE_PI,
> regardless of how many tasks the caller intends to wake or requeue.
> pthread_cond_broadcast() should call this with nr_wake=1 and
> nr_requeue=INT_MAX.  pthread_cond_signal() should call this with 
> nr_wake=1 and
> nr_requeue=0.  The reason being we need both callers to get the benefit 
> of the
> futex_proxy_trylock_atomic() routine.  futex_requeue() also enqueues the
> top_waiter on the rt_mutex via rt_mutex_start_proxy_lock().
> 
> Changelog:
> V7pre: -Corrected FLAGS_HAS_TIMEOUT flag detection logic per Eric Dumazet
> V6: -Moved non requeue_pi related fixes/changes into separate patches
>    -Make use of new double_unlock_hb()
>    -Futex key management updates
>    -Removed unnecessary futex_requeue_pi_cleanup() routine
>    -Return -EINVAL if futex_wake is called with q.rt_waiter != NULL
>    -Rewrote futex_wait_requeue_pi() wakeup logic
>    -Rewrote requeue/wakeup loop
>    -Renamed futex_requeue_pi_init() to futex_proxy_trylock_atomic()
>    -Handle third party owner, removed -EMORON :-(
>    -Comment updates
> V5: -Update futex_requeue to allow for nr_requeue == 0
>    -Whitespace cleanup
>    -Added task_count var to futex_requeue to avoid confusion between
>     ret, res, and ret used to count wakes and requeues
> V4: -Cleanups to pass checkpatch.pl
>    -Added missing goto out; in futex_wait_requeue_pi()
>    -Moved rt_mutex_handle_wakeup to the rt_mutex_enqueue_task patch as they
>     are a functional pair.
>    -Fixed several error exit paths that failed to unqueue the futex_q, 
> which
>     not only would leave the futex_q on the hb, but would have caused an 
> exit
>     race with the waiter since they weren't synchonized on the hb lock.  
> Thanks
>     Sripathi for catching this.
>    -Fix pi_state handling in futex_requeue
>    -Several other minor fixes to futex_requeue_pi
>    -add requeue_futex function and force the requeue in requeue_pi even 
> for the
>     task we wake in the requeue loop
>    -refill the pi state cache at the beginning of futex_requeue for 
> requeue_pi
>    -have futex_requeue_pi_init ensure it stores off the pi_state for use in
>     futex_requeue
>    - Delayed starting the hrtimer until after TASK_INTERRUPTIBLE is set
>    - Fixed NULL pointer bug when futex_wait_requeue_pi() has no timer and
>      receives a signal after waking on uaddr2.  Added has_timeout to the
>      restart->futex structure.
> V3: -Added FUTEX_CMP_REQUEUE_PI op
>    -Put fshared support back.  So long as it is encoded in the op code, we
>     assume both the uaddr's are either private or share, but not mixed.
>    -Fixed access to expected value of uaddr2 in futex_wait_requeue_pi()
> V2: -Added rt_mutex enqueueing to futex_requeue_pi_init
>    -Updated fault handling and exit logic
> V1: -Initial verion
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sripathi Kodi <sripathik@in.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Dinakar Guniguntala <dino@in.ibm.com>
> Cc: Ulrich Drepper <drepper@redhat.com>
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jakub Jelinek <jakub@redhat.com>
> ---
> 
> include/linux/futex.h       |    8 +
> include/linux/thread_info.h |    3 kernel/futex.c              |  533 
> +++++++++++++++++++++++++++++++++++++++++--
> 3 files changed, 524 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/include/linux/futex.h b/include/linux/futex.h
> index 3bf5bb5..b05519c 100644
> --- a/include/linux/futex.h
> +++ b/include/linux/futex.h
> @@ -23,6 +23,9 @@ union ktime;
> #define FUTEX_TRYLOCK_PI    8
> #define FUTEX_WAIT_BITSET    9
> #define FUTEX_WAKE_BITSET    10
> +#define FUTEX_WAIT_REQUEUE_PI    11
> +#define FUTEX_REQUEUE_PI    12
> +#define FUTEX_CMP_REQUEUE_PI    13
> 
> #define FUTEX_PRIVATE_FLAG    128
> #define FUTEX_CLOCK_REALTIME    256
> @@ -38,6 +41,11 @@ union ktime;
> #define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLAG)
> #define FUTEX_WAIT_BITSET_PRIVATE    (FUTEX_WAIT_BITS | FUTEX_PRIVATE_FLAG)
> #define FUTEX_WAKE_BITSET_PRIVATE    (FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
> +#define FUTEX_WAIT_REQUEUE_PI_PRIVATE    (FUTEX_WAIT_REQUEUE_PI | \
> +                     FUTEX_PRIVATE_FLAG)
> +#define FUTEX_REQUEUE_PI_PRIVATE    (FUTEX_REQUEUE_PI | 
> FUTEX_PRIVATE_FLAG)
> +#define FUTEX_CMP_REQUEUE_PI_PRIVATE    (FUTEX_CMP_REQUEUE_PI | \
> +                     FUTEX_PRIVATE_FLAG)
> 
> /*
>  * Support for robust futexes: the kernel cleans up held futexes at
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index e6b820f..a8cc4e1 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -21,13 +21,14 @@ struct restart_block {
>         struct {
>             unsigned long arg0, arg1, arg2, arg3;
>         };
> -        /* For futex_wait */
> +        /* For futex_wait and futex_wait_requeue_pi */
>         struct {
>             u32 *uaddr;
>             u32 val;
>             u32 flags;
>             u32 bitset;
>             u64 time;
> +            u32 *uaddr2;
>         } futex;
>         /* For nanosleep */
>         struct {
> diff --git a/kernel/futex.c b/kernel/futex.c
> index a9c7da1..115ec52 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -19,6 +19,10 @@
>  *  PRIVATE futexes by Eric Dumazet
>  *  Copyright (C) 2007 Eric Dumazet <dada1@cosmosbay.com>
>  *
> + *  Requeue-PI support by Darren Hart <dvhltc@us.ibm.com>
> + *  Copyright (C) IBM Corporation, 2009
> + *  Thanks to Thomas Gleixner for conceptual design and careful reviews.
> + *
>  *  Thanks to Ben LaHaise for yelling "hashed waitqueues" loudly
>  *  enough at me, Linus for the original (flawed) idea, Matthew
>  *  Kirkwood for proof-of-concept implementation.
> @@ -109,6 +113,9 @@ struct futex_q {
>     struct futex_pi_state *pi_state;
>     struct task_struct *task;
> 
> +    /* rt_waiter storage for requeue_pi: */
> +    struct rt_mutex_waiter *rt_waiter;
> +
>     /* Bitset for the optional bitmasked wakeup */
>     u32 bitset;
> };
> @@ -829,7 +836,7 @@ static int futex_wake(u32 __user *uaddr, int 
> fshared, int nr_wake, u32 bitset)
> 
>     plist_for_each_entry_safe(this, next, head, list) {
>         if (match_futex (&this->key, &key)) {
> -            if (this->pi_state) {
> +            if (this->pi_state || this->rt_waiter) {
>                 ret = -EINVAL;
>                 break;
>             }
> @@ -970,20 +977,116 @@ void requeue_futex(struct futex_q *q, struct 
> futex_hash_bucket *hb1,
>     q->key = *key2;
> }
> 
> -/*
> - * Requeue all waiters hashed on one physical page to another
> - * physical page.
> +/**
> + * futex_proxy_trylock_atomic() - Attempt an atomic lock for the top 
> waiter
> + * @pifutex:    the user address of the to futex
> + * @hb1:    the from futex hash bucket, must be locked by the caller
> + * @hb2:    the to futex hash bucket, must be locked by the caller
> + * @key1:    the from futex key
> + * @key2:    the to futex key
> + *
> + * Try and get the lock on behalf of the top waiter if we can do it 
> atomically.
> + * Wake the top waiter if we succeed.  hb1 and hb2 must be held by the 
> caller.
> + *
> + * Faults occur for two primary reasons at this point:
> + * 1) The address isn't mapped
> + * 2) The address isn't writeable
> + *
> + * We return EFAULT on either of these cases and rely on the caller to 
> handle
> + * them.
> + *
> + * Returns:
> + *  0 - failed to acquire the lock atomicly
> + *  1 - acquired the lock
> + * <0 - error
> + */
> +static int futex_proxy_trylock_atomic(u32 __user *pifutex,
> +                 struct futex_hash_bucket *hb1,
> +                 struct futex_hash_bucket *hb2,
> +                 union futex_key *key1, union futex_key *key2,
> +                 struct futex_pi_state **ps)
> +{
> +    struct futex_q *top_waiter;
> +    u32 curval;
> +    int ret;
> +
> +    if (get_futex_value_locked(&curval, pifutex))
> +        return -EFAULT;
> +
> +    top_waiter = futex_top_waiter(hb1, key1);
> +
> +    /* There are no waiters, nothing for us to do. */
> +    if (!top_waiter)
> +        return 0;
> +
> +    /*
> +     * Either take the lock for top_waiter or set the FUTEX_WAITERS bit.
> +     * The pi_state is returned in ps in contended cases.
> +     */
> +    ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task);
> +    if (ret == 1) {
> +        /*
> +         * Set the top_waiter key for the requeue target futex so the
> +         * waiter can detect the wakeup on the right futex, but remove
> +         * it from the hb so it can detect atomic lock acquisition.
> +         */
> +        drop_futex_key_refs(&top_waiter->key);
> +        get_futex_key_refs(key2);
> +        top_waiter->key = *key2;
> +        WARN_ON(plist_node_empty(&top_waiter->list));
> +        plist_del(&top_waiter->list, &top_waiter->list.plist);
> +        /*
> +         * FIXME: wake_futex() wakes first, then nulls the lock_ptr,
> +         * and uses a memory barrier.  Do we need to?
> +         */
> +        top_waiter->lock_ptr = NULL;
> +        wake_up(&top_waiter->waiter);
> +    }
> +
> +    return ret;
> +}
> +
> +/**
> + * futex_requeue() - Requeue waiters from uaddr1 to uaddr2
> + * uaddr1:    source futex user address
> + * uaddr2:    target futex user address
> + * nr_wake:    number of waiters to wake (must be 1 for requeue_pi)
> + * nr_requeue:    number of waiters to requeue (0-INT_MAX)
> + * requeue_pi:    if we are attempting to requeue from a non-pi futex to a
> + *         pi futex (pi to pi requeue is not supported)
> + *
> + * Requeue waiters on uaddr1 to uaddr2. In the requeue_pi case, try to 
> acquire
> + * uaddr2 atomically on behalf of the top waiter.
> + *
> + * Returns:
> + * >=0: on success, the number of tasks requeued or woken
> + *  <0: on error
>  */
> static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user 
> *uaddr2,
> -             int nr_wake, int nr_requeue, u32 *cmpval)
> +             int nr_wake, int nr_requeue, u32 *cmpval,
> +             int requeue_pi)
> {
>     union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
> +    int drop_count = 0, task_count = 0, ret;
> +    struct futex_pi_state *pi_state = NULL;
>     struct futex_hash_bucket *hb1, *hb2;
>     struct plist_head *head1;
>     struct futex_q *this, *next;
> -    int ret, drop_count = 0;
> +    u32 curval2;
> +
> +    if (requeue_pi) {
> +        if (refill_pi_state_cache())
> +            return -ENOMEM;
> +        if (nr_wake != 1)
> +            return -EINVAL;
> +    }
> 
> retry:
> +    if (pi_state != NULL) {
> +        free_pi_state(pi_state);
> +        pi_state = NULL;
> +    }
> +
>     ret = get_futex_key(uaddr1, fshared, &key1);
>     if (unlikely(ret != 0))
>         goto out;
> @@ -1022,19 +1125,92 @@ retry_private:
>         }
>     }
> 
> +    if (requeue_pi) {
> +        /* Attempt to acquire uaddr2 and wake the top_waiter. */
> +        ret = futex_proxy_trylock_atomic(uaddr2, hb1, hb2, &key1,
> +                         &key2, &pi_state);
> +
> +        /*
> +         * At this point the top_waiter has either taken uaddr2 or is
> +         * waiting on it.  If the former, then the pi_state will not
> +         * exist yet, look it up one more time to ensure we have a
> +         * reference to it.
> +         */
> +        if (ret == 1 && !pi_state) {
> +            task_count++;
> +            ret = get_futex_value_locked(&curval2, uaddr2);
> +            if (!ret)
> +                ret = lookup_pi_state(curval2, hb2, &key2,
> +                              &pi_state);
> +        }
> +
> +        switch (ret) {
> +        case 0:
> +            break;
> +        case -EFAULT:
> +            double_unlock_hb(hb1, hb2);
> +            put_futex_key(fshared, &key2);
> +            put_futex_key(fshared, &key1);
> +            ret = get_user(curval2, uaddr2);
> +            if (!ret)
> +                goto retry;
> +            goto out;
> +        case -EAGAIN:
> +            /* The owner was exiting, try again. */
> +            double_unlock_hb(hb1, hb2);
> +            put_futex_key(fshared, &key2);
> +            put_futex_key(fshared, &key1);
> +            cond_resched();
> +            goto retry;
> +        default:
> +            goto out_unlock;
> +        }
> +    }
> +
>     head1 = &hb1->chain;
>     plist_for_each_entry_safe(this, next, head1, list) {
> -        if (!match_futex (&this->key, &key1))
> +        if (task_count - nr_wake >= nr_requeue)
> +            break;
> +
> +        if (!match_futex(&this->key, &key1))
>             continue;
> -        if (++ret <= nr_wake) {
> +
> +        /* This can go after we're satisfied with testing. */
> +        if (!requeue_pi)
> +            WARN_ON(this->rt_waiter);
> +
> +        /*
> +         * Wake nr_wake waiters.  For requeue_pi, if we acquired the
> +         * lock, we already woke the top_waiter.  If not, it will be
> +         * woken by futex_unlock_pi().
> +         */
> +        if (++task_count <= nr_wake && !requeue_pi) {
>             wake_futex(this);
> -        } else {
> -            requeue_futex(this, hb1, hb2, &key2);
> -            drop_count++;
> +            continue;
> +        }
> 
> -            if (ret - nr_wake >= nr_requeue)
> -                break;
> +        /*
> +         * Requeue nr_requeue waiters and possibly one more in the case
> +         * of requeue_pi if we couldn't acquire the lock atomically.
> +         */
> +        if (requeue_pi) {
> +            /* This can go after we're satisfied with testing. */
> +            WARN_ON(!this->rt_waiter);
> +
> +            /* Prepare the waiter to take the rt_mutex. */
> +            atomic_inc(&pi_state->refcount);
> +            this->pi_state = pi_state;
> +            ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
> +                            this->rt_waiter,
> +                            this->task, 1);
> +            if (ret) {
> +                this->pi_state = NULL;
> +                free_pi_state(pi_state);
> +                goto out_unlock;
> +            }
>         }
> +        requeue_futex(this, hb1, hb2, &key2);
> +        drop_count++;
>     }
> 
> out_unlock:
> @@ -1049,7 +1225,9 @@ out_put_keys:
> out_put_key1:
>     put_futex_key(fshared, &key1);
> out:
> -    return ret;
> +    if (pi_state != NULL)
> +        free_pi_state(pi_state);
> +    return ret ? ret : task_count;
> }
> 
> /* The key must be already stored in q->key. */
> @@ -1272,6 +1450,8 @@ handle_fault:
> #define FLAGS_HAS_TIMEOUT    0x04
> 
> static long futex_wait_restart(struct restart_block *restart);
> +static long futex_wait_requeue_pi_restart(struct restart_block *restart);
> +static long futex_lock_pi_restart(struct restart_block *restart);
> 
> /**
>  * finish_futex_lock_pi() - Post lock pi_state and corner case management
> @@ -1419,6 +1599,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
> 
>     q.pi_state = NULL;
>     q.bitset = bitset;
> +    q.rt_waiter = NULL;
> 
>     if (abs_time) {
>         unsigned long slack;
> @@ -1575,6 +1756,7 @@ static int futex_lock_pi(u32 __user *uaddr, int 
> fshared,
>     }
> 
>     q.pi_state = NULL;
> +    q.rt_waiter = NULL;
> retry:
>     q.key = FUTEX_KEY_INIT;
>     ret = get_futex_key(uaddr, fshared, &q.key);
> @@ -1670,6 +1852,20 @@ uaddr_faulted:
>     goto retry;
> }
> 
> +static long futex_lock_pi_restart(struct restart_block *restart)
> +{
> +    u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
> +    ktime_t t, *tp = NULL;
> +    int fshared = restart->futex.flags & FLAGS_SHARED;
> +
> +    if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
> +        t.tv64 = restart->futex.time;
> +        tp = &t;
> +    }
> +    restart->fn = do_no_restart_syscall;
> +
> +    return (long)futex_lock_pi(uaddr, fshared, restart->futex.val, tp, 0);
> +}
> 
> /*
>  * Userspace attempted a TID -> 0 atomic transition, and failed.
> @@ -1772,6 +1968,290 @@ pi_faulted:
>     return ret;
> }
> 
> +/**
> + * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
> + * @uaddr:    the futex we initialyl wait on (non-pi)
> + * @fshared:    whether the futexes are shared (1) or not (0).  They 
> must be
> + *         the same type, no requeueing from private to shared, etc.
> + * @val:    the expected value of uaddr
> + * @abs_time:    absolute timeout
> + * @bitset:    32 bit wakeup bitset set by userspace, defaults to all.
> + * @clockrt:    whether to use CLOCK_REALTIME (1) or CLOCK_MONOTONIC (0)
> + * @uaddr2:    the pi futex we will take prior to returning to user-space
> + *
> + * The caller will wait on uaddr and will be requeued by 
> futex_requeue() to
> + * uaddr2 which must be PI aware.  Normal wakeup will wake on uaddr2 and
> + * complete the acquisition of the rt_mutex prior to returning to 
> userspace.
> + * This ensures the rt_mutex maintains an owner when it has waiters; 
> without
> + * one, the pi logic wouldn't know which task to boost/deboost, if 
> there was a
> + * need to.
> + *
> + * We call schedule in futex_wait_queue_me() when we enqueue and return 
> there
> + * via the following:
> + * 1) wakeup on uaddr2 after an atomic lock acquisition by futex_requeue()
> + * 2) wakeup on uaddr2 after a requeue and subsequent unlock
> + * 3) signal (before or after requeue)
> + * 4) timeout (before or after requeue)
> + *
> + * If 3, we setup a restart_block with futex_wait_requeue_pi() as the 
> function.
> + *
> + * If 2, we may then block on trying to take the rt_mutex and return via:
> + * 5) successful lock
> + * 6) signal
> + * 7) timeout
> + * 8) other lock acquisition failure
> + *
> + * If 6, we setup a restart_block with futex_lock_pi() as the function.
> + *
> + * If 4 or 7, we cleanup and return with -ETIMEDOUT.
> + *
> + * Returns:
> + *  0 - On success
> + * <0 - On error
> + */
> +static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
> +                 u32 val, ktime_t *abs_time, u32 bitset,
> +                 int clockrt, u32 __user *uaddr2)
> +{
> +    struct hrtimer_sleeper timeout, *to = NULL;
> +    struct rt_mutex_waiter rt_waiter;
> +    struct restart_block *restart;
> +    struct futex_hash_bucket *hb;
> +    struct rt_mutex *pi_mutex;
> +    union futex_key key2;
> +    struct futex_q q;
> +    u32 uval;
> +    int ret;
> +
> +    if (!bitset)
> +        return -EINVAL;
> +
> +    if (abs_time) {
> +        to = &timeout;
> +        hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
> +                      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> +        hrtimer_init_sleeper(to, current);
> +        hrtimer_set_expires_range_ns(&to->timer, *abs_time,
> +                         current->timer_slack_ns);
> +    }
> +
> +    /*
> +     * The waiter is allocated on our stack, manipulated by the requeue
> +     * code while we sleep on uaddr.
> +     */
> +    debug_rt_mutex_init_waiter(&rt_waiter);
> +    rt_waiter.task = NULL;
> +
> +    q.pi_state = NULL;
> +    q.bitset = bitset;
> +    q.rt_waiter = &rt_waiter;
> +
> +retry:
> +    q.key = FUTEX_KEY_INIT;
> +    ret = get_futex_key(uaddr, fshared, &q.key);
> +    if (unlikely(ret != 0))
> +        goto out;
> +
> +    key2 = FUTEX_KEY_INIT;
> +    ret = get_futex_key(uaddr2, fshared, &key2);
> +    if (unlikely(ret != 0)) {
> +        put_futex_key(fshared, &q.key);
> +        goto out;
> +    }
> +
> +    hb = queue_lock(&q);
> +
> +    /*
> +     * Access the page AFTER the hash-bucket is locked.
> +     * Order is important:
> +     *
> +     *   Userspace waiter: val = var; if (cond(val)) futex_wait(&var, 
> val);
> +     *   Userspace waker:  if (cond(var)) { var = new; futex_wake(&var); }
> +     *
> +     * The basic logical guarantee of a futex is that it blocks ONLY
> +     * if cond(var) is known to be true at the time of blocking, for
> +     * any cond.  If we queued after testing *uaddr, that would open
> +     * a race condition where we could block indefinitely with
> +     * cond(var) false, which would violate the guarantee.
> +     *
> +     * A consequence is that futex_wait() can return zero and absorb
> +     * a wakeup when *uaddr != val on entry to the syscall.  This is
> +     * rare, but normal.
> +     */
> +    ret = get_futex_value_locked(&uval, uaddr);
> +
> +    if (unlikely(ret)) {
> +        queue_unlock(&q, hb);
> +        put_futex_key(fshared, &q.key);
> +        put_futex_key(fshared, &key2);
> +
> +        ret = get_user(uval, uaddr);
> +        if (!ret)
> +            goto retry;
> +        goto out;
> +    }
> +
> +    /* Only actually queue if *uaddr contained val.  */
> +    ret = -EWOULDBLOCK;
> +    if (uval != val) {
> +        queue_unlock(&q, hb);
> +        put_futex_key(fshared, &q.key);
> +        put_futex_key(fshared, &key2);
> +        goto out;
> +    }
> +
> +    /* Queue the futex_q, drop the hb lock, wait for wakeup. */
> +    futex_wait_queue_me(hb, &q, to);
> +
> +    /*
> +     * Ensure the requeue is atomic to avoid races while we process the
> +     * wakeup.  We only need to hold hb->lock to ensure atomicity as the
> +     * wakeup code can't change q.key from uaddr to uaddr2 if we hold that
> +     * lock. It can't be requeued from uaddr2 to something else since we
> +     * don't support a PI aware source futex for requeue.
> +     */
> +    spin_lock(&hb->lock);
> +    if (!match_futex(&q.key, &key2)) {
> +        WARN_ON(q.lock_ptr && (&hb->lock != q.lock_ptr));
> +        /*
> +         * We were not requeued, handle wakeup from futex1 (uaddr).  We
> +         * cannot have been unqueued and already hold the lock, no need
> +         * to call unqueue_me, just do it directly.
> +         */
> +        plist_del(&q.list, &q.list.plist);
> +        drop_futex_key_refs(&q.key);
> +
> +        ret = -ETIMEDOUT;
> +        if (to && !to->task) {
> +            spin_unlock(&hb->lock);
> +            goto out_put_keys;
> +        }
> +
> +        /*
> +         * We expect signal_pending(current), but another thread may
> +         * have handled it for us already.
> +         */
> +        ret = -ERESTARTSYS;
> +        if (!abs_time) {
> +            spin_unlock(&hb->lock);
> +            goto out_put_keys;
> +        }
> +
> +        restart = &current_thread_info()->restart_block;
> +        restart->fn = futex_wait_requeue_pi_restart;
> +        restart->futex.uaddr = (u32 *)uaddr;
> +        restart->futex.val = val;
> +        restart->futex.time = abs_time->tv64;
> +        restart->futex.bitset = bitset;
> +        restart->futex.flags = 0;
> +        restart->futex.uaddr2 = (u32 *)uaddr2;
> +        restart->futex.flags = FLAGS_HAS_TIMEOUT;
> +
> +        if (fshared)
> +            restart->futex.flags |= FLAGS_SHARED;
> +        if (clockrt)
> +            restart->futex.flags |= FLAGS_CLOCKRT;
> +
> +        ret = -ERESTART_RESTARTBLOCK;
> +
> +        spin_unlock(&hb->lock);
> +        goto out_put_keys;
> +    }
> +    spin_unlock(&hb->lock);
> +
> +    ret = 0;
> +    /*
> +     * Check if the waker acquired the second futex for us. If the 
> lock_ptr
> +     * is NULL, but our key is key2, then the requeue target futex was
> +     * uncontended and the waker gave it to us.  This is safe without a 
> lock
> +     * as futex_requeue() will not release the hb lock until after it's
> +     * nulled the lock_ptr and removed us from the hb.
> +     */
> +    if (!q.lock_ptr)
> +        goto out_put_keys;
> +
> +    /*
> +     * At this point we have been requeued.  We have been woken up by
> +     * futex_unlock_pi(), a timeout, or a signal, but not futex_requeue().
> +     * futex_unlock_pi() will not destroy the lock_ptr nor the pi_state.
> +     */
> +    WARN_ON(!&q.pi_state);
> +    pi_mutex = &q.pi_state->pi_mutex;
> +    ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
> +    debug_rt_mutex_free_waiter(&waiter);
> +
> +    spin_lock(q.lock_ptr);
> +    ret = finish_futex_lock_pi(uaddr, fshared, &q, ret);
> +
> +    /* Unqueue and drop the lock. */
> +    unqueue_me_pi(&q);
> +
> +    /*
> +     * If fixup_pi_state_owner() faulted and was unable to handle the
> +     * fault, unlock it and return the fault to userspace.
> +     */
> +    if (ret == -EFAULT) {
> +        if (rt_mutex_owner(pi_mutex) == current)
> +            rt_mutex_unlock(pi_mutex);
> +    } else if (ret == -EINTR) {
> +        if (get_user(uval, uaddr2)) {
> +            ret = -EFAULT;
> +            goto out_put_keys;
> +        }
> +
> +        /*
> +         * We've already been requeued, so restart by calling
> +         * futex_lock_pi() directly, rather then returning to this
> +         * function.
> +         */
> +        restart = &current_thread_info()->restart_block;
> +        restart->fn = futex_lock_pi_restart;
> +        restart->futex.uaddr = (u32 *)uaddr2;
> +        restart->futex.val = uval;
> +        restart->futex.flags = 0;
> +        if (abs_time) {
> +            restart->futex.flags |= FLAGS_HAS_TIMEOUT;
> +            restart->futex.time = abs_time->tv64;
> +        }
> +
> +        if (fshared)
> +            restart->futex.flags |= FLAGS_SHARED;
> +        if (clockrt)
> +            restart->futex.flags |= FLAGS_CLOCKRT;
> +        ret = -ERESTART_RESTARTBLOCK;
> +    }
> +
> +out_put_keys:
> +    put_futex_key(fshared, &q.key);
> +    put_futex_key(fshared, &key2);
> +
> +out:
> +    if (to) {
> +        hrtimer_cancel(&to->timer);
> +        destroy_hrtimer_on_stack(&to->timer);
> +    }
> +    return ret;
> +}
> +
> +static long futex_wait_requeue_pi_restart(struct restart_block *restart)
> +{
> +    u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
> +    u32 __user *uaddr2 = (u32 __user *)restart->futex.uaddr2;
> +    int fshared = restart->futex.flags & FLAGS_SHARED;
> +    int clockrt = restart->futex.flags & FLAGS_CLOCKRT;
> +    ktime_t t, *tp = NULL;
> +
> +    if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
> +        t.tv64 = restart->futex.time;
> +        tp = &t;
> +    }
> +    restart->fn = do_no_restart_syscall;
> +
> +    return (long)futex_wait_requeue_pi(uaddr, fshared, restart->futex.val,
> +                       tp, restart->futex.bitset, clockrt,
> +                       uaddr2);
> +}
> +
> /*
>  * Support for robust futexes: the kernel cleans up held futexes at
>  * thread exit time.
> @@ -1994,7 +2474,7 @@ long do_futex(u32 __user *uaddr, int op, u32 val, 
> ktime_t *timeout,
>         fshared = 1;
> 
>     clockrt = op & FUTEX_CLOCK_REALTIME;
> -    if (clockrt && cmd != FUTEX_WAIT_BITSET)
> +    if (clockrt && cmd != FUTEX_WAIT_BITSET && cmd != 
> FUTEX_WAIT_REQUEUE_PI)
>         return -ENOSYS;
> 
>     switch (cmd) {
> @@ -2009,10 +2489,11 @@ long do_futex(u32 __user *uaddr, int op, u32 
> val, ktime_t *timeout,
>         ret = futex_wake(uaddr, fshared, val, val3);
>         break;
>     case FUTEX_REQUEUE:
> -        ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL);
> +        ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL, 0);
>         break;
>     case FUTEX_CMP_REQUEUE:
> -        ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3);
> +        ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
> +                    0);
>         break;
>     case FUTEX_WAKE_OP:
>         ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
> @@ -2029,6 +2510,18 @@ long do_futex(u32 __user *uaddr, int op, u32 val, 
> ktime_t *timeout,
>         if (futex_cmpxchg_enabled)
>             ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
>         break;
> +    case FUTEX_WAIT_REQUEUE_PI:
> +        val3 = FUTEX_BITSET_MATCH_ANY;
> +        ret = futex_wait_requeue_pi(uaddr, fshared, val, timeout, val3,
> +                        clockrt, uaddr2);
> +        break;
> +    case FUTEX_REQUEUE_PI:
> +        ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL, 1);
> +        break;
> +    case FUTEX_CMP_REQUEUE_PI:
> +        ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
> +                    1);
> +        break;
>     default:
>         ret = -ENOSYS;
>     }
> @@ -2046,7 +2539,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, 
> op, u32, val,
>     int cmd = op & FUTEX_CMD_MASK;
> 
>     if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
> -              cmd == FUTEX_WAIT_BITSET)) {
> +              cmd == FUTEX_WAIT_BITSET ||
> +              cmd == FUTEX_WAIT_REQUEUE_PI)) {
>         if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
>             return -EFAULT;
>         if (!timespec_valid(&ts))
> @@ -2058,10 +2552,11 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, 
> op, u32, val,
>         tp = &t;
>     }
>     /*
> -     * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
> +     * requeue parameter in 'utime' if cmd == FUTEX_*_REQUEUE_*.
>      * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
>      */
>     if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
> +        cmd == FUTEX_REQUEUE_PI || cmd == FUTEX_CMP_REQUEUE_PI ||
>         cmd == FUTEX_WAKE_OP)
>         val2 = (u32) (unsigned long) utime;
> 
> 
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
