Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbZCaSRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbZCaSRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZCaSQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:16:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33901 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZCaSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:16:55 -0400
Message-ID: <49D25E0E.2050407@us.ibm.com>
Date: Tue, 31 Mar 2009 11:16:46 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 8/8] RFC: futex: add requeue_pi calls
References: <20090330213306.606.9540.stgit@Aeon> <20090330213840.606.59261.stgit@Aeon> <alpine.LFD.2.00.0903310902240.12916@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903310902240.12916@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 30 Mar 2009, Darren Hart wrote:
>> +
>> +	if (requeue_pi) {
>> +		if (refill_pi_state_cache())
>> +			return -ENOMEM;
>> +		if (nr_wake != 1)
>> +			return -EINVAL;
>> +	}
> 
>   Needs a comment

	/*
	 * requeue_pi requires a pi_state, try to allocate it now in case it
	 * fails.  requeue_pi can wake at most one task since it acquires the
	 * rt_mutex prior to returning to userspace, and must wake it if it can
	 * so as to not leave the rt_mutex with waiters and no owner.
	 */

>   
>>  retry:
>> +	if (pi_state != NULL) {
>> +		free_pi_state(pi_state);
>> +		pi_state = NULL;
>> +	}
> 
>   Ditto


	/*
	 * We will have to lookup the pi_state again, so
	 * free this one to keep the accounting correct.
	 */


 
>> +	if (requeue_pi) {
>> +		/* Attempt to acquire uaddr2 and wake the top_waiter. */
>> +		ret = futex_proxy_trylock_atomic(uaddr2, hb1, hb2, &key1,
>> +						 &key2, &pi_state);
>> +
>> +		/*
>> +		 * At this point the top_waiter has either taken uaddr2 or is
>> +		 * waiting on it.  If the former, then the pi_state will not
>> +		 * exist yet, look it up one more time to ensure we have a
>> +		 * reference to it.
>> +		 */
>> +		if (ret == 1 && !pi_state) {
>> +			task_count++;
>> +			ret = get_futex_value_locked(&curval2, uaddr2);
>> +			if (!ret)
>> +				ret = lookup_pi_state(curval2, hb2, &key2,
>> +						      &pi_state);
>> +		}
>> +
>> +		switch (ret) {
>> +		case 0:
>> +			break;
>> +		case -EFAULT:
>> +			double_unlock_hb(hb1, hb2);
>> +			put_futex_key(fshared, &key2);
>> +			put_futex_key(fshared, &key1);
>> +			ret = get_user(curval2, uaddr2);
>> +			if (!ret)
>> +				goto retry;
> 
>   Hmm. What happens if futex_proxy_trylock_atomic() succeeds, but
>   get_futex_value_locked() fails ? I guess its unlikely to happen, but
>   in case it does are we sure that our state is correct ?

Right so...

First, I suppose the !pi_state in that if block above should be turned
into a WARN_ON as ret == 1 should imply !pi_state.

If get_futex_value_locked() faults, the uaddr2 still contains the
top_waiter's pid and that task is on it's way waking up.  We unlock hash
buckets which will allow for unlocking (maybe the top_waiter is REALLY
fast) or for additional waiters to be added.  If we fault while not
atomic (get_user() above) then we goto out, returning a fatal fault to
userspace, but the top_waiter will continue to wake.  I think this is
OK.  We can't return both the number woken AND an error code without
passing another userspace variable for the number woken/requeued (which
might not be a bad idea actually).

If we don't fault (most likely) we goto retry which will not free the
pi_state since it will be NULL.  We grab the keys and the hb locks, do
the cmpval test (un uaddr, not uaddr2, so we're still ok).  We'll then
try to take the lock atomically again.  We may actually succeed again if
the top_waiter was really fast and dropped uaddr2 already...

HRM... this means we might wake additional tasks... so for requeue_pi
nr_wake is really ignored... we'll wake however many waiters we can/have
to in order to ensure a contended rt_mutex always has an owner... which
raises the question of is it ok to return >1 when user called with
nr_wake=1 and nr_requeue=0 (for cond_signal)?

If the lock is still contended, the next futex_proxy_trylock_atomic()
will fail and we'll continue to requeue the remaining tasks.

So the only concern is the muddied relevance of nr_wake.... Any thoughts
on how we should treat nr_wake?  I suppose if nr_wake=1 and
nr_requeue=0, then we should avoid calling futex_proxy_trylock_atomic()
a second time... something like this:

	if (requeue_pi && (task_count - nr_wake < nr_requeue)) {
		/* Attempt to acquire uaddr2 and wake the top_waiter. */
		ret = futex_proxy_trylock_atomic(uaddr2, hb1, hb2, &key1,
						 &key2, &pi_state);



> 
>> +
>> +		/* This can go after we're satisfied with testing. */
>> +		if (!requeue_pi)
>> +			WARN_ON(this->rt_waiter);
> 
>   Keep those WARN_ONs. they are useful when code is changed later. Just make it
>   
> 	WARN_ON(!requeue_pi && this->rt_waiter);
> 	WARN_ON(requeue_pi && !this->rt_waiter);

Makes sense, done.

> 
>> +		/*
>> +		 * Requeue nr_requeue waiters and possibly one more in the case
>> +		 * of requeue_pi if we couldn't acquire the lock atomically.
>> +		 */
>> +		if (requeue_pi) {
>> +			/* This can go after we're satisfied with testing. */
>> +			WARN_ON(!this->rt_waiter);
>> +
>> +			/* Prepare the waiter to take the rt_mutex. */
>> +			atomic_inc(&pi_state->refcount);
>> +			this->pi_state = pi_state;
>> +			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
>> +							this->rt_waiter,
>> +							this->task, 1);
>> +			if (ret) {
>> +				this->pi_state = NULL;
>> +				free_pi_state(pi_state);
>> +				goto out_unlock;
> 
>   What are the reasons of dropping out here ?

Eeek.  Good catch.

if ret == 1, then we need to wake-up the waiter much like we do in
futex_proxy_trylock_atomic().

if ret < 0 (-EDEADLK), I think we should return the error to userspace
immediately, aborting any pending requeues - thoughts?

> 
>> +	/*
>> +	 * Ensure the requeue is atomic to avoid races while we process the
>> +	 * wakeup.  We only need to hold hb->lock to ensure atomicity as the
>> +	 * wakeup code can't change q.key from uaddr to uaddr2 if we hold that
>> +	 * lock. It can't be requeued from uaddr2 to something else since we
>> +	 * don't support a PI aware source futex for requeue.
>> +	 */
>> +	spin_lock(&hb->lock);
>> +	if (!match_futex(&q.key, &key2)) {
>> +		WARN_ON(q.lock_ptr && (&hb->lock != q.lock_ptr));
>> +		/*
>> +		 * We were not requeued, handle wakeup from futex1 (uaddr).  We
>> +		 * cannot have been unqueued and already hold the lock, no need
>> +		 * to call unqueue_me, just do it directly.
>> +		 */
>> +		plist_del(&q.list, &q.list.plist);
>> +		drop_futex_key_refs(&q.key);
>> +
>> +		ret = -ETIMEDOUT;
>> +		if (to && !to->task) {
>> +			spin_unlock(&hb->lock);
>> +			goto out_put_keys;
>> +		}
>> +
>> +		/*
>> +		 * We expect signal_pending(current), but another thread may
>> +		 * have handled it for us already.
>> +		 */
>> +		ret = -ERESTARTSYS;
>> +		if (!abs_time) {
>> +			spin_unlock(&hb->lock);
>> +			goto out_put_keys;
>> +		}
> 
>   Hmm. Why do we use restart block here ? The timeout is absolute, so
>   we can just restart the syscall, can't we ?

Yup, I caught this last night too.  I'll update.

> 
>> +	ret = 0;
>> +	/*
>> +	 * Check if the waker acquired the second futex for us. If the lock_ptr
>> +	 * is NULL, but our key is key2, then the requeue target futex was
>> +	 * uncontended and the waker gave it to us.  This is safe without a lock
>> +	 * as futex_requeue() will not release the hb lock until after it's
>> +	 * nulled the lock_ptr and removed us from the hb.
>> +	 */
>> +	if (!q.lock_ptr)
>> +		goto out_put_keys;
> 
>   At this point we hold the rt_mutex, the pi state is correct and the
>   user space variable at *uaddr2 is updated, right ??

uaddr2 has already been updated by futex_lock_pi_atomic()

we do hold the rt_mutex if there is one (a waiter would have to have
been added after we look the lock and setup the pi_state, creating the
rt_mutex, and assigning us as the owner)

we only get to this point if we acquired the uncontended lock, so there is no lock stealing to worry about, I believe this means we can avoid the corner case cleanup of finish_futex_lock_pi().  I'll pour over this a bit more though and make sure I can convince myself of that.

Thanks you for the review!



> 
> Thanks,
> 
> 	tglx


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
