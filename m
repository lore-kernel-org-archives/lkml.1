Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZCJEu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZCJEu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZCJEuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:50:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46892 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZCJEuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:50:10 -0400
Message-ID: <49B5F17C.8020100@us.ibm.com>
Date: Mon, 09 Mar 2009 21:50:04 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 6/7] futex: add requeue_pi calls
References: <49AC73A9.4040804@us.ibm.com> <49AC77D1.6090106@us.ibm.com> <alpine.LFD.2.00.0903071652350.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903071652350.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 2 Mar 2009, Darren Hart wrote:
>> From: Darren Hart <dvhltc@us.ibm.com>
>>
>> PI Futexes must have an owner at all times, so the standard requeue commands
>> aren't sufficient.
> 
> That's wrong. The point is that PI Futexes and the kernel internal
> rt_mutexes need to have an owner if there are waiters simply because
> the PI boosting can not operate on nothing.

Yup, sorry - old patch header comment.  Fixed.

> 
>> +		/* For futex_wait and futex_wait_requeue_pi */
>> 		struct {
>> 			u32 *uaddr;
>> 			u32 val;
>> 			u32 flags;
>> 			u32 bitset;
>> +			int has_timeout;
> 
> Hmm. time == 0 perhaps or just add another flag bit to the flags field ?

I've created FLAGS_HAS_TIMEOUT and use that instead.  I opted for this 
approach instead of using time==0 as that seemed like it could be 
confused for an expired timer.

> 
>> +/* dvhart: FIXME: some commentary here would help to clarify that hb->chain
>> is
>> + * actually the queue which contains multiple instances of futex_q - one per
>> + * waiter.  The naming is extremely unfortunate as it refects the
>> datastructure
>> + * more than its usage. */
> 
> Please either do a separate patch which fixes/adds the comment or just
> leave it as is. This change has nothing to do with requeue_pi and just
> makes review harder.

My apologies, I had removed all of these types of FIXMEs into another 
branch, but produced this patchset from the wrong git tree.  We'll call 
this "Figure 1" and I'll refer to it often below ;-)

> 
>> /*
>>  * Split the global futex_lock into every hash list lock.
>>  */
>> @@ -189,6 +196,7 @@ static void drop_futex_key_refs(union futex_key *key)
>> /**
>>  * get_futex_key - Get parameters which are the keys for a futex.
>>  * @uaddr: virtual address of the futex
>> + * dvhart FIXME: incorrent shared comment (fshared, and it's a boolean int)
>> + * dvhart FIXME: incorrent shared comment (fshared, and it's a boolean int)
> 
> LOL. The time it took to add the FIXME comments would have been enough
> to make a separate patch which fixes the existing comment


See Figure 1


> 
>> /*
>> + * futex_requeue_pi_cleanup - cleanup after futex_requeue_pi_init after
>> failed
>> + *                            lock acquisition.
> 
> "after after cleanup". Shudder. Instead of this useless comment the code
> could do with some explanatory comments
> 


This function looks like it could do with an overhaul.  I wrote it early 
on and kind of forgot about it :/  Thanks for the catch.


>> + * @q: the futex_q of the futex we failed to acquire
>> + */
>> +static void futex_requeue_pi_cleanup(struct futex_q *q)
>> +{
>> +	if (!q->pi_state)
>> +		return;
>> +	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
>> +		rt_mutex_unlock(&q->pi_state->pi_mutex);
>> +	else
>> +		free_pi_state(q->pi_state);
>> +}
>> +
>> +/*
>>  * Look up the task based on what TID userspace gave us.
>>  * We dont trust it.
>>  */
>> @@ -736,6 +760,7 @@ static void wake_futex(struct futex_q *q)
>> 	 * at the end of wake_up_all() does not prevent this store from
>> 	 * moving.
>> 	 */
>> +	/* dvhart FIXME: "end of wake_up()" */
> 
> Sigh.


See Figure 1


> 
>> 	smp_wmb();
>> 	q->lock_ptr = NULL;
>> }
>> @@ -834,6 +859,12 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct
>> futex_hash_bucket *hb2)
>> 	}
>> }
>>
>> +/* dvhart FIXME: the wording here is inaccurate as both the physical page and
>> + * the offset are required for the hashing, it is also non-intuitve as most
>> + * will be thinking of "the futex" not "the physical page and offset this
>> + * virtual address points to".  Used throughout - consider wholesale cleanup
>> of
>> + * function commentary.
>> + */
> 
> /me throws a handful of FIXMEs at dvhart


See Figure 1


> 
>> /*
>>  * Wake up all waiters hashed on the physical page that is mapped
>>  * to this virtual address:
>> @@ -988,19 +1019,123 @@ out:
>> }
>>
>> /*
>> - * Requeue all waiters hashed on one physical page to another
>> - * physical page.
>> + * futex_requeue_pi_init - prepare the top waiter to lock the pi futex on
>> wake
>> + * @pifutex: the user address of the to futex
>> + * @hb1: the from futex hash bucket, must be locked by the caller
>> + * @hb2: the to futex hash bucket, must be locked by the caller
>> + * @key1: the from futex key
>> + * @key2: the to futex key
>> + *
>> + * Returns 0 on success, a negative error code on failure.
>> + *
>> + * Prepare the top_waiter and the pi_futex for requeing.  We handle
>> + * the userspace r/w here so that we can handle any faults prior
>> + * to entering the requeue loop.  hb1 and hb2 must be held by the caller.
>> + *
>> + * Faults occur for two primary reasons at this point:
>> + * 1) The address isn't mapped (what? you didn't use mlock() in your
>> real-time
>> + *    application code? *gasp*)
>> + * 2) The address isn't writeable
>> + *
>> + * We return EFAULT on either of these cases and rely on futex_requeue to
>> + * handle them.
>> + */
>> +static int futex_requeue_pi_init(u32 __user *pifutex,
>> +				 struct futex_hash_bucket *hb1,
>> +				 struct futex_hash_bucket *hb2,
>> +				 union futex_key *key1, union futex_key *key2,
>> +				 struct futex_pi_state **ps)
>> +{
>> +	u32 curval;
>> +	struct futex_q *top_waiter;
>> +	pid_t pid;
>> +	int ret;
>> +
>> +	if (get_futex_value_locked(&curval, pifutex))
>> +		return -EFAULT;
>> +
>> +	top_waiter = futex_top_waiter(hb1, key1);
>> +
>> +	/* There are no waiters, nothing for us to do. */
>> +	if (!top_waiter)
>> +		return 0;
>> +
>> +	/*
>> +	 * The pifutex has an owner, make sure it's us, if not complain
>> +	 * to userspace.
>> +	 * FIXME_LATER: handle this gracefully
> 
> We should do this right now. It's not that hard.


Hrm. So if another task owns the futex then POSIX says undefined 
scheduling be should be expected.  So failing here seems like a good way 
to encourage proper usage of the cond vars.  Or can you think of a sane 
scenario in which the outer mutex should not be held prior to the call 
to cond_signal() or cond_broadcast()?  If you are thinking outside of 
glibc cond vars, then there are likely other gaps with this patch, such 
as only being able to requeue from non-pi to pi futexes.

That being said... now that this is more or less implemented, I'm not 
sure there is really anything I'd need to do different to support this. 
  I'll pour over this for a while and see if there are any gotchas that 
I'm missing right now.


> 
>> +	 */
>> +	pid = curval & FUTEX_TID_MASK;
>> +	if (pid && pid != task_pid_vnr(current))
>> +		return -EMORON;
> 
> Though it's a pity that we lose EMORON :)


Does that mean I'll have to forfeit the nickname bestowed upon me by 
LWN?  I've received numerous comments on this line - all of them in 
favor.  Apparently lots of kernel developers are eager for a way to 
slyly mock users from within the context of the kernel.  ;-)


> 
>> +	/*
>> +	 * Current should own pifutex, but it could be uncontended.  Here we
>> +	 * either take the lock for top_waiter or set the FUTEX_WAITERS bit.
>> +	 * The pi_state is also looked up, but we don't care about the return
>> +	 * code as we'll have to look that up during requeue for each waiter
>> +	 * anyway.
>> +	 */
>> +	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task);
> 
>   Why do we ignore the retunr value here ???


-EMORON

We should just return ret if < 0 and let futex_requeue() process it. 
This is basically what we did before, but it wasn't obvious since the 
code just moved on to testing !pi.  There was the potential to lose the 
return code however, so that is now fixed.  Running with this fix, will 
appear in V6.


> 
>> +	/*
>> +	 * At this point the top_waiter has either taken the pifutex or it is
>> +	 * waiting on it.  If the former, then the pi_state will not exist
>> yet,
>> +	 * look it up one more time to ensure we have a reference to it.
>> +	 */
>> +	if (!ps /* FIXME && some ret values in here I think ... */)
>> +		ret = lookup_pi_state(curval, hb2, key2, ps);
>> +	return ret;
>> +}
>> +
>> +static inline
>> +void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
>> +		   struct futex_hash_bucket *hb2, union futex_key *key2)
>> +{
>> +
>> +	/*
>> +	 * If key1 and key2 hash to the same bucket, no need to
>> +	 * requeue.
>> +	 */
>> +	if (likely(&hb1->chain != &hb2->chain)) {
>> +		plist_del(&q->list, &hb1->chain);
>> +		plist_add(&q->list, &hb2->chain);
>> +		q->lock_ptr = &hb2->lock;
>> +#ifdef CONFIG_DEBUG_PI_LIST
>> +		q->list.plist.lock = &hb2->lock;
>> +#endif
>> +	}
>> +	get_futex_key_refs(key2);
>> +	q->key = *key2;
>> +}
> 
> Can you please split out such changes to the existing requeue code
> into a separate patch ?


Should have from the start, updated for V6.


> 
>> +/*
>> + * Requeue all waiters hashed on one physical page to another physical page.
>> + * In the requeue_pi case, either takeover uaddr2 or set FUTEX_WAITERS and
>> + * setup the pistate.  FUTEX_REQUEUE_PI only supports requeueing from a
>> non-pi
>> + * futex to a pi futex.
>>  */
>> static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
>> -			 int nr_wake, int nr_requeue, u32 *cmpval)
>> +			 int nr_wake, int nr_requeue, u32 *cmpval,
>> +			 int requeue_pi)
>> {
>> 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
>> 	struct futex_hash_bucket *hb1, *hb2;
>> 	struct plist_head *head1;
>> 	struct futex_q *this, *next;
>> -	int ret, drop_count = 0;
>> +	u32 curval2;
>> +	struct futex_pi_state *pi_state = NULL;
>> +	int drop_count = 0, attempt = 0, task_count = 0, ret;
>> +
>> +	if (requeue_pi && refill_pi_state_cache())
>> +		return -ENOMEM;
> 
>   Why do you want to refill the pi_state_cache of current ? current is
>   not going to wait for the pi_futex.


I may need to allocate a pi_state during 
futex_requeue_pi_init()->futex_lock_pi_atomic()->lookup_pi_state(). 
Making use of this current->pi_cache seemed like the best way to do it. 
  Is there a more appropriate place to store a preallocated pi_state?


> 
>> retry:
>> +	if (pi_state != NULL) {
>> +		free_pi_state(pi_state);
>> +		pi_state = NULL;
>> +	}
>> +
>> 	ret = get_futex_key(uaddr1, fshared, &key1);
>> 	if (unlikely(ret != 0))
>> 		goto out;
>> @@ -1023,12 +1158,15 @@ retry:
>> 			if (hb1 != hb2)
>> 				spin_unlock(&hb2->lock);
>>
>> +			put_futex_key(fshared, &key2);
>> +			put_futex_key(fshared, &key1);
>> +
> 
>   Isn't this a reference leak in mainline as well, which needs to be
>   fixed separate ?


Huh, I didn't intend to do that.  I'll submit separately.


> 
>> 			ret = get_user(curval, uaddr1);
>>
>> 			if (!ret)
>> 				goto retry;
>>
>> -			goto out_put_keys;
>> +			goto out;
>> 		}
>> 		if (curval != *cmpval) {
>> 			ret = -EAGAIN;
>> @@ -1036,32 +1174,104 @@ retry:
>> 		}
>> 	}
>>
>> +	if (requeue_pi) {
>> +		/* FIXME: should we handle the no waiters case special? */
> 
>   If there are no waiters then we should drop out here right away. Why
>   should we do more if we know already that there is nothing to do.


Well, looking at this again, I don't think it's worth testing this 
separately.  As it is we'll call get_futex_value_locked() then move to 
plist_fort_each_entry_safe() since there are no waiters to iterate over, 
and exit.  So I think this is handled adequately and I'll just axe the 
comment and move on.


> 
>> +		ret = futex_requeue_pi_init(uaddr2, hb1, hb2, &key1, &key2,
>> +					    &pi_state);
>> +
>> +		if (!ret)
>> +			ret = get_futex_value_locked(&curval2, uaddr2);
>> +
>> +		switch (ret) {
>> +		case 0:
>> +			break;
>> +		case 1:
>> +			/* we got the lock */
>> +			ret = 0;
>> +			break;
>> +		case -EFAULT:
>> +			/*
>> +			 * We handle the fault here instead of in
>> +			 * futex_requeue_pi_init because we have to reacquire
>> +			 * both locks to avoid deadlock.
>> +			 */
>> +			spin_unlock(&hb1->lock);
>> +			if (hb1 != hb2)
>> +				spin_unlock(&hb2->lock);
> 
>   Can we please put that sequeuence into an inline function
>   e.g. double_unlock_hb(). We have at least 5 instances of it.


Hrm... looking at this it seems we already have a double_lock_hb() which 
uses the pointer values to decide which it order it locks them in. 
Using that in combination with this name-order unlock looks like an ABBA 
deadlock waiting to happen to me.

futex: double_unlock_hb() coming up in my futex-fixes branch which 
contains the other broken out non requeue_pi related patches and I'll 
rebase this series on that.


> 
>> +			put_futex_key(fshared, &key2);
>> +			put_futex_key(fshared, &key1);
>> +
>> +			if (attempt++) {
>> +				ret = futex_handle_fault((unsigned
>> long)uaddr2,
>> +							 attempt);
>> +				if (ret)
>> +					goto out;
>> +				goto retry;
>> +			}
>> +
>> +			ret = get_user(curval2, uaddr2);
>> +
>> +			if (!ret)
>> +				goto retry;
>> +			goto out;
>> +		case -EAGAIN:
>> +			/* The owner was exiting, try again. */
>> +			spin_unlock(&hb1->lock);
>> +			if (hb1 != hb2)
>> +				spin_unlock(&hb2->lock);
>> +			put_futex_key(fshared, &key2);
>> +			put_futex_key(fshared, &key1);
>> +			cond_resched();
>> +			goto retry;
>> +		default:
>> +			goto out_unlock;
>> +		}
>> +	}
>> +
>> 	head1 = &hb1->chain;
>> 	plist_for_each_entry_safe(this, next, head1, list) {
>> 		if (!match_futex (&this->key, &key1))
>> 			continue;
>> -		if (++ret <= nr_wake) {
>> -			wake_futex(this);
>> +		/*
>> +		 * Regardless of if we are waking or requeueing, we need to
>> +		 * prepare the waiting task to take the rt_mutex in the
>> +		 * requeue_pi case. If we gave the lock to the top_waiter in
>> +		 * futex_requeue_pi_init() then don't enqueue that task as a
>> +		 * waiter on the rt_mutex (it already owns it).
>> +		 */
>> +		if (requeue_pi &&
>> +		    ((curval2 & FUTEX_TID_MASK) != task_pid_vnr(this->task)))
>> {
> 
>   Why don't you check the owner of the rtmutex, which we installed
>   already ? Then we can drop this curval2 business altogether.


Because we can own the futex without an rt_mutex existing.  The first 
time through this loop we consider the top_waiter of uaddr1.  If uaddr2 
had no owner, then it is now owned by the top_waiter, but since there 
are still no waiters on uaddr2, the rt_mutex has not been initialized. 
Once we know we are not the owner, then we also know the 
pi_state->pi_mutex exists.

Hrm.... I suppose a test for "!this->pi_state" is equivalent to
"(curval2 & FUTEX_TID_MASK) != task_pid_vnr(this->task)" then isn't 
it...?  Seems like a rather fragile test though doesn't it?

We wouldn't save much by eliminating the curval2 here though since 
futex_requeue_pi_init needs it for the atomic_lock, so we still need the 
fault logic... unfortunatley.

Thoughts?


> 
>> +			atomic_inc(&pi_state->refcount);
>> +			this->pi_state = pi_state;
>> +			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
>> +							this->rt_waiter,
>> +							this->task, 1);
>> +			if (ret)
>> +				goto out_unlock;
>> +		}
>> +
>> +		if (++task_count <= nr_wake) {
>> +			if (requeue_pi) {
>> +				/*
>> +				 * In the case of requeue_pi we need to know
>> if
>> +				 * we were requeued or not, so do the requeue
>> +				 * regardless if we are to wake this task.
>> +				 */
>> +				requeue_futex(this, hb1, hb2, &key2);
>> +				drop_count++;
>> +				/* FIXME: look into altering wake_futex so we
>> +				 * can use it (we can't null the lock_ptr) */
> 
>  Err, no. wake_futex() does a plist_del(&q->list, &q->list.plist);
>  What's wrong with using wake_up() ?


Nothing I guess, just trying to use the existing futex infrastructure as 
much as possible without implementing a bunch of lower level calls 
inline.  But if everyone is alright with this approach, we'll leave it be.


> 
>> +				wake_up(&this->waiter);
>> +			} else
>> +				wake_futex(this);
>> 		} else {
>> -			/*
>> -			 * If key1 and key2 hash to the same bucket, no need
>> to
>> -			 * requeue.
>> -			 */
>> -			if (likely(head1 != &hb2->chain)) {
>> -				plist_del(&this->list, &hb1->chain);
>> -				plist_add(&this->list, &hb2->chain);
>> -				this->lock_ptr = &hb2->lock;
>> -#ifdef CONFIG_DEBUG_PI_LIST
>> -				this->list.plist.lock = &hb2->lock;
>> -#endif
>> -			}
>> -			this->key = key2;
>> -			get_futex_key_refs(&key2);
>> +			requeue_futex(this, hb1, hb2, &key2);
>> 			drop_count++;
>> -
>> -			if (ret - nr_wake >= nr_requeue)
>> -				break;
>> 		}
>> +
>> +		if (task_count - nr_wake >= nr_requeue)
>> +			break;
>> 	}
>>
>> out_unlock:
>> @@ -1073,12 +1283,13 @@ out_unlock:
>> 	while (--drop_count >= 0)
>> 		drop_futex_key_refs(&key1);
>>
>> -out_put_keys:
>> 	put_futex_key(fshared, &key2);
>> out_put_key1:
>> 	put_futex_key(fshared, &key1);
>> out:
>> -	return ret;
>> +	if (pi_state != NULL)
>> +		free_pi_state(pi_state);
>> +	return ret ? ret : task_count;
>> }
>>
>> /* The key must be already stored in q->key. */
>> @@ -1180,6 +1391,7 @@ retry:
>>  */
>> static void unqueue_me_pi(struct futex_q *q)
>> {
>> +	/* FIXME: hitting this warning for requeue_pi */
> 
>   And why ?


Old comment I believe.  I no longer see this in my testing.  Removed.


> 
>> 	WARN_ON(plist_node_empty(&q->list));
>> 	plist_del(&q->list, &q->list.plist);
>>
>> @@ -1302,6 +1514,8 @@ handle_fault:
>> #define FLAGS_CLOCKRT		0x02
>>
>> static long futex_wait_restart(struct restart_block *restart);
>> +static long futex_wait_requeue_pi_restart(struct restart_block *restart);
>> +static long futex_lock_pi_restart(struct restart_block *restart);
>>
>> /* finish_futex_lock_pi - post lock pi_state and corner case management
>>  * @uaddr: the user address of the futex
>> @@ -1466,6 +1680,9 @@ retry:
>>
>> 	hb = queue_lock(&q);
>>
>> +	/* dvhart FIXME: we access the page before it is queued... obsolete
>> +	 * comments? */
>> +
> 
>   I think so.
> 


See Figure 1


>> 	/*
>> 	 * Access the page AFTER the futex is queued.
>> 	 * Order is important:
>> @@ -1529,6 +1746,7 @@ retry:
>> 		restart->fn = futex_wait_restart;
>> 		restart->futex.uaddr = (u32 *)uaddr;
>> 		restart->futex.val = val;
>> +		restart->futex.has_timeout = 1;
>> 		restart->futex.time = abs_time->tv64;
>> 		restart->futex.bitset = bitset;
>> 		restart->futex.flags = 0;
>> @@ -1559,12 +1777,16 @@ static long futex_wait_restart(struct restart_block
>> *restart)
>> 	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
>> 	int fshared = 0;
>> 	ktime_t t;
>> +	ktime_t *tp = NULL;
> 
>   One line please
> 


Done in broken out patch for the FLAGS_HAS_TIMEOUT


>> -	t.tv64 = restart->futex.time;
>> +	if (restart->futex.has_timeout) {
>> +		t.tv64 = restart->futex.time;
>> +		tp = &t;
>> +	}
>> 	restart->fn = do_no_restart_syscall;
>> 	if (restart->futex.flags & FLAGS_SHARED)
>> 		fshared = 1;
>> -	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t,
>> +	return (long)futex_wait(uaddr, fshared, restart->futex.val, tp,
>> 				restart->futex.bitset,
>> 				restart->futex.flags & FLAGS_CLOCKRT);
>> }
>> @@ -1621,6 +1843,7 @@ retry_unlocked:
>> 			 * complete.
>> 			 */
>> 			queue_unlock(&q, hb);
>> +			/* FIXME: need to put_futex_key() ? */
> 
>   Yes. Needs to be fixed in mainline as well.


Added to futex-fixes branch.


> 
>> 			cond_resched();
>> 			goto retry;
>> 		default:
>> @@ -1653,16 +1876,6 @@ retry_unlocked:
>>
>> 	goto out;
>>
>> -out_unlock_put_key:
>> -	queue_unlock(&q, hb);
>> -
>> -out_put_key:
>> -	put_futex_key(fshared, &q.key);
>> -out:
>> -	if (to)
>> -		destroy_hrtimer_on_stack(&to->timer);
>> -	return ret;
>> -
>> uaddr_faulted:
>> 	/*
>> 	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
>> @@ -1685,6 +1898,34 @@ uaddr_faulted:
>> 		goto retry;
>>
>> 	goto out;
>> +
>> +out_unlock_put_key:
>> +	queue_unlock(&q, hb);
>> +
>> +out_put_key:
>> +	put_futex_key(fshared, &q.key);
>> +
>> +out:
>> +	if (to)
>> +		destroy_hrtimer_on_stack(&to->timer);
>> +	return ret;
>> +
>> +}
>> +
>> +static long futex_lock_pi_restart(struct restart_block *restart)
>> +{
>> +	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
>> +	ktime_t t;
>> +	ktime_t *tp = NULL;
>> +	int fshared = restart->futex.flags & FLAGS_SHARED;
>> +
>> +	if (restart->futex.has_timeout) {
>> +		t.tv64 = restart->futex.time;
>> +		tp = &t;
>> +	}
>> +	restart->fn = do_no_restart_syscall;
>> +
>> +	return (long)futex_lock_pi(uaddr, fshared, restart->futex.val, tp, 0);
>> }
>>
>> /*
>> @@ -1797,6 +2038,316 @@ pi_faulted:
>> }
>>
>> /*
>> + * futex_wait_requeue_pi - wait on futex1 (uaddr) and take the futex2
>> (uaddr2)
>> + *                         before returning
>> + * @uaddr: the futex we initialyl wait on (possibly non-pi)
>> + * @fshared: whether the futexes are shared (1) or not (0).  They must be the
>> + *           same type, no requeueing from private to shared, etc.
>> + * @val: the expected value of uaddr
>> + * @abs_time: absolute timeout
>> + * @bitset: FIXME ???
>> + * @clockrt: whether to use CLOCK_REALTIME (1) or CLOCK_MONOTONIC (0)
>> + * @uaddr2: the pi futex we will take prior to returning to user-space
>> + *
>> + * The caller will wait on futex1 (uaddr) and will be requeued by
>> + * futex_requeue() to futex2 (uaddr2) which must be PI aware.  Normal wakeup
>> + * will wake on futex2 and then proceed to take the underlying rt_mutex prior
>> + * to returning to userspace.  This ensures the rt_mutex maintains an owner
>> + * when it has waiters.  Without one we won't know who to boost/deboost, if
>> + * there was a need to.
>> + *
>> + * We call schedule in futex_wait_queue_me() when we enqueue and return there
>> + * via the following:
>> + * 1) signal
>> + * 2) timeout
>> + * 3) wakeup on the first futex (uaddr)
>> + * 4) wakeup on the second futex (uaddr2, the pi futex) after a requeue
>> + *
>> + * If 1 or 2, we need to check if we got the rtmutex, setup the pi_state, or
>> + * were enqueued on the rt_mutex via futex_requeue_pi_init() just before the
>> + * signal or timeout arrived.  If so, we need to clean that up.  Note: the
>> + * setting of FUTEX_WAITERS will be handled when the owner unlocks the
>> + * rt_mutex.
>> + *
>> + * If 3, userspace wrongly called FUTEX_WAKE on the first futex (uaddr)
>> rather
>> + * than using the FUTEX_REQUEUE_PI call with nr_requeue=0.  Return -EINVAL.
>> + *
>> + * If 4, we may then block on trying to take the rt_mutex and return via:
>> + * 5) signal
>> + * 6) timeout
>> + * 7) successful lock
>> + *
>> + * If 5, we setup a restart_block with futex_lock_pi() as the function.
>> + *
>> + * If 6, we cleanup and return with -ETIMEDOUT.
>> + *
>> + * TODO:
>> + *   o once we have the all the return points correct, we need to collect
>> + *     common code into exit labels.
>> + *
>> + * Returns:
>> + * 0				Success
>> + * -EFAULT			For various faults
>> + * -EWOULDBLOCK			uaddr has an unexpected value (it
>> changed
>> + *  				before we got going)
>> + * -ETIMEDOUT			timeout (from either wait on futex1 or locking
>> + *				futex2)
>> + * -ERESTARTSYS			Signal received (during wait on
>> futex1) with no
>> + *				timeout
>> + * -ERESTART_RESTARTBLOCK	Signal received (during wait on futex1)
>> + * -RESTARTNOINTR		Signal received (during lock of futex2)
>> + * -EINVAL			No bitset, woke via FUTEX_WAKE, etc.
>> + *
>> + * May also passthrough the follpowing return codes (not exhaustive):
>> + * -EPERM		see get_futex_key()
>> + * -EACCESS		see get_futex_key()
>> + * -ENOMEM		see get_user_pages()
>> + *
>> + */
>> +static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
>> +				 u32 val, ktime_t *abs_time, u32 bitset,
>> +				 int clockrt, u32 __user *uaddr2)
>> +{
>> +	struct futex_hash_bucket *hb;
>> +	struct futex_q q;
>> +	union futex_key key2 = FUTEX_KEY_INIT;
>> +	u32 uval;
>> +	struct rt_mutex *pi_mutex;
>> +	struct rt_mutex_waiter rt_waiter;
>> +	struct hrtimer_sleeper timeout, *to = NULL;
>> +	int requeued = 0;
>> +	int ret;
> 
>   All ints in a line please. And please order the lines in descending
>   line length. Makes it much easier to read.


OK, done.


> 
>> +	if (!bitset)
>> +		return -EINVAL;
>> +
>> +	if (abs_time) {
>> +		unsigned long slack;
> 
>   Missing new line. Also this is nonsense. A rt task should have set
>   its timer_slack_ns to 0, so we can just use current->timer_slack_ns
>   in the hrtimer_set_expires_range_ns(). If the timer_slack_ns is
>   random for rt_tasks then we need to fix this in general.
> 


Added a WARN_ON(!current->timer_slack_ns) to my debug patch and used 
that value here.  I'll create a patch to futex-fixes to address the 
existing calls that I copied this approach from.


>> +		to = &timeout;
>> +		slack = current->timer_slack_ns;
>> +		if (rt_task(current))
>> +			slack = 0;
>> +		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
>> +				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
>> +		hrtimer_init_sleeper(to, current);
>> +		hrtimer_set_expires_range_ns(&to->timer, *abs_time, slack);
>> +	}
>> +
>> +	/*
>> +	 * The waiter is allocated on our stack, manipulated by the requeue
>> +	 * code while we sleep on the initial futex (uaddr).
>> +	 */
>> +	debug_rt_mutex_init_waiter(&rt_waiter);
>> +	rt_waiter.task = NULL;
>> +
>> +	q.pi_state = NULL;
>> +	q.bitset = bitset;
>> +	q.rt_waiter = &rt_waiter;
>> +
>> +retry:
>> +	q.key = FUTEX_KEY_INIT;
>> +	ret = get_futex_key(uaddr, fshared, &q.key);
>> +	if (unlikely(ret != 0))
>> +		goto out;
>> +
>> +	ret = get_futex_key(uaddr2, fshared, &key2);
>> +	if (unlikely(ret != 0)) {
>> +		drop_futex_key_refs(&q.key);
>> +		goto out;
>> +	}
>> +
>> +	hb = queue_lock(&q);
>> +
>> +	/* dvhart FIXME: we access the page before it is queued... obsolete
>> +	 * comments? */
> 
>   Yes. The reason is the serializing via hb->lock.


Ack, thanks.  (and see Figure 1)


> 
>> +	/*
>> +	 * Access the page AFTER the futex is queued.
>> +	 * Order is important:
>> +	 *
>> +	 *   Userspace waiter: val = var; if (cond(val)) futex_wait(&var,
>> val);
>> +	 *   Userspace waker:  if (cond(var)) { var = new; futex_wake(&var); }
>> +	 *
>> +	 * The basic logical guarantee of a futex is that it blocks ONLY
>> +	 * if cond(var) is known to be true at the time of blocking, for
>> +	 * any cond.  If we queued after testing *uaddr, that would open
>> +	 * a race condition where we could block indefinitely with
>> +	 * cond(var) false, which would violate the guarantee.
>> +	 *
>> +	 * A consequence is that futex_wait() can return zero and absorb
>> +	 * a wakeup when *uaddr != val on entry to the syscall.  This is
>> +	 * rare, but normal.
>> +	 *
>> +	 * for shared futexes, we hold the mmap semaphore, so the mapping
>> +	 * cannot have changed since we looked it up in get_futex_key.
>> +	 */
>> +	ret = get_futex_value_locked(&uval, uaddr);
>> +
>> +	if (unlikely(ret)) {
>> +		queue_unlock(&q, hb);
>> +		put_futex_key(fshared, &q.key);
>> +
>> +		ret = get_user(uval, uaddr);
>> +
>> +		if (!ret)
>> +			goto retry;
>> +		goto out;
>> +	}
>> +	ret = -EWOULDBLOCK;
>> +
>> +	/* Only actually queue if *uaddr contained val.  */
>> +	if (uval != val) {
>> +		queue_unlock(&q, hb);
>> +		put_futex_key(fshared, &q.key);
>> +		goto out;
>> +	}
>> +
>> +	/* queue_me and wait for wakeup, timeout, or a signal. */
>> +	futex_wait_queue_me(hb, &q, to);
>> +
>> +	/*
>> +	 * Upon return from futex_wait_queue_me, we no longer hold the hb
>> lock,
>> +	 * but do still hold a key reference.  unqueue_me* will drop a key
>> +	 * reference to q.key.
>> +	 */
>> +
>> +	requeued = match_futex(&q.key, &key2);
>> +	drop_futex_key_refs(&key2);
> 
>   Why do we drop the ref to key2 here ? What if we were requeued ?


Hrm.  I remember adding this and it being necessary - but I can't see it 
know.  I suspect I changed up where I get the futex key  or the exit 
logic, making this unecessary (and wrong).  Nice catch.  Removed.


> 
>> +	if (!requeued) {
>> +		/* Handle wakeup from futex1 (uaddr). */
>> +		ret = unqueue_me(&q);
>> +		if (unlikely(ret)) { /* signal */
> 
>   Please put the comment into a separate line if a comment is
>   neccesary for the condition. This one is pretty useless.
> 


Removed :)


>   Also the logic is completely backwards here. It has to be the same
>   as in futex_wait()


Is it broken?  I believe the reason I wrote it as I did was because the 
ret == 0 case should be very rare here.  Infact, it is an error.  The 
only reason we should wake on the first futex (uaddr) is on a signal or 
a timeout, otherwise the user most likely paired a FUTEX_WAKE_REQUEUE_PI 
  with FUTEX_WAKE, instead of FUTEX_REQUEUE_PI.

I can change it around if you have a strong preference though (or if 
it's broken in some way I'm missing of course).


> 
>   if (!unqueue_me()) {
>      handle_futex_wakeup();
>   } else {
>      if (timeout happened) {
>      	handle_timeout;
>      } else {
>         prepare_restart();
>      }
>   }
> 
>> +			/*
>> +			 * We expect signal_pending(current), but another
>> +			 * thread may have handled it for us already.
>> +			 */
>> +			if (!abs_time) {
>> +				ret = -ERESTARTSYS;
>> +			} else {
>> +				struct restart_block *restart;
>> +				restart =
>> &current_thread_info()->restart_block;
>> +				restart->fn = futex_wait_requeue_pi_restart;
>> +				restart->futex.uaddr = (u32 *)uaddr;
>> +				restart->futex.val = val;
>> +				restart->futex.has_timeout = 1;
>> +				restart->futex.time = abs_time->tv64;
>> +				restart->futex.bitset = bitset;
>> +				restart->futex.flags = 0;
>> +				restart->futex.uaddr2 = (u32 *)uaddr2;
>> +
>> +				if (fshared)
>> +					restart->futex.flags |= FLAGS_SHARED;
>> +				if (clockrt)
>> +					restart->futex.flags |= FLAGS_CLOCKRT;
>> +				ret = -ERESTART_RESTARTBLOCK;
>> +			}
>> +		} else if (to && !to->task) {/* timeout */
>> +			ret = -ETIMEDOUT;
>> +		} else {
>> +			/*
>> +			 * We woke on uaddr, so userspace probably paired a
>> +			 * FUTEX_WAKE with FUTEX_WAIT_REQUEUE_PI, which is not
>> +			 * valid.
>> +			 */
>> +			ret = -EINVAL;
>> +		}
>> +		goto out;
>> +	}
>> +
>> +	/* Handle wakeup from rt_mutex of futex2 (uaddr2). */
>> +
>> +	/* FIXME: this test is REALLY scary... gotta be a better way...
>> +	 * If the pi futex was uncontended, futex_requeue_pi_init() gave us
>> +	 * the lock.
>> +	 */
> 
>   Didn't we take the rtmutex as well ??


Not necessarily.  If the pi futex was ownerless and there was only one 
task requeued, then there is no rtmutex as it is created by the first 
waiter.

It is possible that other tasks have since tried to take this mutex and 
now there is an rtmutex, but we have to catch the case where there might 
not be one.


> 
>> +	if (!q.pi_state) {
>> +		ret = 0;
>> +		goto out;
>> +	}
>> +	pi_mutex = &q.pi_state->pi_mutex;
>> +
>> +	ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
> 
> 
>   Eeek. We got a wakeup _after_ we have been requeued. So now you go
>   back to sleep on the pi_mutex ?


Yes.  The futex_requeue() calls wake_up() which allows the waiter here 
to wake and continue processing it's half of the rt_mutex acquisition 
loop that I split out of rt_mutex_slowlock() in 
rt_mutex_finish_proxy_lock().


> 
>> +	debug_rt_mutex_free_waiter(&waiter);
>> +
>> +	if (ret) {
>> +		if (get_user(uval, uaddr2))
>> +			ret = -EFAULT;
> 
>   Why drop we out here w/o retrying ?
> 


At this point we have already been requeued and woken.  There is no need 
to continue with futex_wait_requeue_pi(), we can just call 
futex_lock_pi() directly.  However, I see that we don't do that, we just 
return -EFAULT to userspace.  I'll spend some more time on this exit 
path and see if I can make it more robust, as well as easier to follow.


>   Also why do we have a separate handling of "ret" here ? This logic
>   is fundamentally different from futex_lock_pi().


At this point ret can be:

0: we don't get here
EINTR:     We need to restart
ETIMEDOUT: We should return that to userspace (well we should... looks
            like that isn't handled quite right either...)
EFAULT:    I guess I felt if we start faulting at this point we're in
            trouble, but you are correct, it should retry.  I'll add this
            in.
EDEADLOCK: We should return that to userspace (same story as
            ETIMEDOUT)

So... plenty of dope jokes are warranted here.  I'll clean this error 
path up.  It's just broken.


>> +		if (ret == -EINTR) {
>> +			/*
>> +			 * We've already been requeued and enqueued on the
>> +			 * rt_mutex, so restart by calling futex_lock_pi()
>> +			 * directly, rather then returning to this function.
>> +			 */
>> +			struct restart_block *restart;
>> +			restart = &current_thread_info()->restart_block;
>> +			restart->fn = futex_lock_pi_restart;
>> +			restart->futex.uaddr = (u32 *)uaddr2;
>> +			restart->futex.val = uval;
>> +			if (abs_time) {
>> +				restart->futex.has_timeout = 1;
>> +				restart->futex.time = abs_time->tv64;
>> +			} else
>> +				restart->futex.has_timeout = 0;
>> +			restart->futex.flags = 0;
>> +
>> +			if (fshared)
>> +				restart->futex.flags |= FLAGS_SHARED;
>> +			if (clockrt)
>> +				restart->futex.flags |= FLAGS_CLOCKRT;
>> +			ret = -ERESTART_RESTARTBLOCK;
>> +		}
>> +	}
>> +
>> +	spin_lock(q.lock_ptr);
>> +	ret = finish_futex_lock_pi(uaddr, fshared, &q, ret);
>> +
>> +	/* Unqueue and drop the lock. */
>> +	unqueue_me_pi(&q);
>> +
>> +out:
>> +	if (to) {
>> +		hrtimer_cancel(&to->timer);
>> +		destroy_hrtimer_on_stack(&to->timer);
>> +	}
>> +	if (requeued) {
>> +		/* We were requeued, so we now have two reference to key2,
>> +		 * unqueue_me_pi releases one of them, we must release the
>> +		 * other. */
>> +		drop_futex_key_refs(&key2);
>> +		if (ret) {
> 
>   This whole "ret" logic is confusing. 


I agree.  As I said above, I'll if I can think of something more robust 
as well as easier to follow.  If you have some ideas, please share.

Many thanks for the review.  I've addressed most of the above while 
responding to this review, but I have a few items that will take me some 
time to address.  I hope to have V6 out and tested this week.

--
Darren

> 
>> +			futex_requeue_pi_cleanup(&q);
>> +			if (get_user(uval, uaddr2))
>> +				ret = -EFAULT;
>> +			if (ret != -ERESTART_RESTARTBLOCK && ret != -EFAULT)
>> +				ret = futex_lock_pi(uaddr2, fshared, uval,
>> +						    abs_time, 0);
>> +		}
>> +	}
>> +	return ret;
>> +}
> 
> Thanks,
> 
> 	tglx


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
