Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZEVFvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZEVFvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZEVFuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 01:50:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41185 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZEVFux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 01:50:53 -0400
Date: Fri, 22 May 2009 15:50:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip-core tree with Linus' tree
Message-Id: <20090522155050.91e025e3.sfr@canb.auug.org.au>
In-Reply-To: <20090522101939.0cba91da.sfr@canb.auug.org.au>
References: <20090521113902.3deb5031.sfr@canb.auug.org.au>
	<4A14D0FF.60202@us.ibm.com>
	<20090522101939.0cba91da.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren, Thomas,

On Fri, 22 May 2009 10:19:39 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> I have made the changes you suggested for today since the -tip stuff has
                                                                       ^^^
has not

> filtered through yet.

The resolution patch now looks like below.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/futex.c
index d546b2d,0c406a3..0000000
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@@ -813,13 -1092,43 +1094,44 @@@ static int futex_requeue(u32 __user *ua
  	struct futex_hash_bucket *hb1, *hb2;
  	struct plist_head *head1;
  	struct futex_q *this, *next;
- 	int ret, drop_count = 0;
+ 	u32 curval2;
+ 
+ 	if (requeue_pi) {
+ 		/*
+ 		 * requeue_pi requires a pi_state, try to allocate it now
+ 		 * without any locks in case it fails.
+ 		 */
+ 		if (refill_pi_state_cache())
+ 			return -ENOMEM;
+ 		/*
+ 		 * requeue_pi must wake as many tasks as it can, up to nr_wake
+ 		 * + nr_requeue, since it acquires the rt_mutex prior to
+ 		 * returning to userspace, so as to not leave the rt_mutex with
+ 		 * waiters and no owner.  However, second and third wake-ups
+ 		 * cannot be predicted as they involve race conditions with the
+ 		 * first wake and a fault while looking up the pi_state.  Both
+ 		 * pthread_cond_signal() and pthread_cond_broadcast() should
+ 		 * use nr_wake=1.
+ 		 */
+ 		if (nr_wake != 1)
+ 			return -EINVAL;
+ 	}
  
  retry:
+ 	if (pi_state != NULL) {
+ 		/*
+ 		 * We will have to lookup the pi_state again, so free this one
+ 		 * to keep the accounting correct.
+ 		 */
+ 		free_pi_state(pi_state);
+ 		pi_state = NULL;
+ 	}
+ 
 -	ret = get_futex_key(uaddr1, fshared, &key1);
 +	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
  	if (unlikely(ret != 0))
  		goto out;
- 	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_READ);
 -	ret = get_futex_key(uaddr2, fshared, &key2);
++	ret = get_futex_key(uaddr2, fshared, &key2,
++			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
  	if (unlikely(ret != 0))
  		goto out_put_key1;
  
@@@ -1165,14 -1668,20 +1671,20 @@@ static int futex_wait_setup(u32 __user 
  	 * A consequence is that futex_wait() can return zero and absorb
  	 * a wakeup when *uaddr != val on entry to the syscall.  This is
  	 * rare, but normal.
- 	 *
- 	 * For shared futexes, we hold the mmap semaphore, so the mapping
- 	 * cannot have changed since we looked it up in get_futex_key.
  	 */
+ retry:
+ 	q->key = FUTEX_KEY_INIT;
 -	ret = get_futex_key(uaddr, fshared, &q->key);
++	ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
+ 	if (unlikely(ret != 0))
+ 		return ret;
+ 
+ retry_private:
+ 	*hb = queue_lock(q);
+ 
  	ret = get_futex_value_locked(&uval, uaddr);
  
- 	if (unlikely(ret)) {
- 		queue_unlock(&q, hb);
+ 	if (ret) {
+ 		queue_unlock(q, *hb);
  
  		ret = get_user(uval, uaddr);
  		if (ret)
@@@ -1330,9 -1828,10 +1831,10 @@@ static int futex_lock_pi(u32 __user *ua
  	}
  
  	q.pi_state = NULL;
+ 	q.rt_waiter = NULL;
  retry:
  	q.key = FUTEX_KEY_INIT;
 -	ret = get_futex_key(uaddr, fshared, &q.key);
 +	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
  	if (unlikely(ret != 0))
  		goto out;
  
@@@ -1674,6 -2050,253 +2053,253 @@@ pi_faulted
  	return ret;
  }
  
+ /**
+  * handle_early_requeue_pi_wakeup() - Detect early wakeup on the initial futex
+  * @hb:		the hash_bucket futex_q was original enqueued on
+  * @q:		the futex_q woken while waiting to be requeued
+  * @key2:	the futex_key of the requeue target futex
+  * @timeout:	the timeout associated with the wait (NULL if none)
+  *
+  * Detect if the task was woken on the initial futex as opposed to the requeue
+  * target futex.  If so, determine if it was a timeout or a signal that caused
+  * the wakeup and return the appropriate error code to the caller.  Must be
+  * called with the hb lock held.
+  *
+  * Returns
+  *  0 - no early wakeup detected
+  * <0 - -ETIMEDOUT or -ERESTARTSYS (FIXME: or ERESTARTNOINTR?)
+  */
+ static inline
+ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
+ 				   struct futex_q *q, union futex_key *key2,
+ 				   struct hrtimer_sleeper *timeout)
+ {
+ 	int ret = 0;
+ 
+ 	/*
+ 	 * With the hb lock held, we avoid races while we process the wakeup.
+ 	 * We only need to hold hb (and not hb2) to ensure atomicity as the
+ 	 * wakeup code can't change q.key from uaddr to uaddr2 if we hold hb.
+ 	 * It can't be requeued from uaddr2 to something else since we don't
+ 	 * support a PI aware source futex for requeue.
+ 	 */
+ 	if (!match_futex(&q->key, key2)) {
+ 		WARN_ON(q->lock_ptr && (&hb->lock != q->lock_ptr));
+ 		/*
+ 		 * We were woken prior to requeue by a timeout or a signal.
+ 		 * Unqueue the futex_q and determine which it was.
+ 		 */
+ 		plist_del(&q->list, &q->list.plist);
+ 		drop_futex_key_refs(&q->key);
+ 
+ 		if (timeout && !timeout->task)
+ 			ret = -ETIMEDOUT;
+ 		else {
+ 			/*
+ 			 * We expect signal_pending(current), but another
+ 			 * thread may have handled it for us already.
+ 			 */
+ 			/* FIXME: ERESTARTSYS or ERESTARTNOINTR?  Do we care if
+ 			 * the user specified SA_RESTART or not? */
+ 			ret = -ERESTARTSYS;
+ 		}
+ 	}
+ 	return ret;
+ }
+ 
+ /**
+  * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
+  * @uaddr:	the futex we initialyl wait on (non-pi)
+  * @fshared:	whether the futexes are shared (1) or not (0).  They must be
+  * 		the same type, no requeueing from private to shared, etc.
+  * @val:	the expected value of uaddr
+  * @abs_time:	absolute timeout
+  * @bitset:	32 bit wakeup bitset set by userspace, defaults to all.
+  * @clockrt:	whether to use CLOCK_REALTIME (1) or CLOCK_MONOTONIC (0)
+  * @uaddr2:	the pi futex we will take prior to returning to user-space
+  *
+  * The caller will wait on uaddr and will be requeued by futex_requeue() to
+  * uaddr2 which must be PI aware.  Normal wakeup will wake on uaddr2 and
+  * complete the acquisition of the rt_mutex prior to returning to userspace.
+  * This ensures the rt_mutex maintains an owner when it has waiters; without
+  * one, the pi logic wouldn't know which task to boost/deboost, if there was a
+  * need to.
+  *
+  * We call schedule in futex_wait_queue_me() when we enqueue and return there
+  * via the following:
+  * 1) wakeup on uaddr2 after an atomic lock acquisition by futex_requeue()
+  * 2) wakeup on uaddr2 after a requeue and subsequent unlock
+  * 3) signal (before or after requeue)
+  * 4) timeout (before or after requeue)
+  *
+  * If 3, we setup a restart_block with futex_wait_requeue_pi() as the function.
+  *
+  * If 2, we may then block on trying to take the rt_mutex and return via:
+  * 5) successful lock
+  * 6) signal
+  * 7) timeout
+  * 8) other lock acquisition failure
+  *
+  * If 6, we setup a restart_block with futex_lock_pi() as the function.
+  *
+  * If 4 or 7, we cleanup and return with -ETIMEDOUT.
+  *
+  * Returns:
+  *  0 - On success
+  * <0 - On error
+  */
+ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
+ 				 u32 val, ktime_t *abs_time, u32 bitset,
+ 				 int clockrt, u32 __user *uaddr2)
+ {
+ 	struct hrtimer_sleeper timeout, *to = NULL;
+ 	struct rt_mutex_waiter rt_waiter;
+ 	struct rt_mutex *pi_mutex = NULL;
+ 	DECLARE_WAITQUEUE(wait, current);
+ 	struct restart_block *restart;
+ 	struct futex_hash_bucket *hb;
+ 	union futex_key key2;
+ 	struct futex_q q;
+ 	int res, ret;
+ 	u32 uval;
+ 
+ 	if (!bitset)
+ 		return -EINVAL;
+ 
+ 	if (abs_time) {
+ 		to = &timeout;
+ 		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
+ 				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+ 		hrtimer_init_sleeper(to, current);
+ 		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
+ 					     current->timer_slack_ns);
+ 	}
+ 
+ 	/*
+ 	 * The waiter is allocated on our stack, manipulated by the requeue
+ 	 * code while we sleep on uaddr.
+ 	 */
+ 	debug_rt_mutex_init_waiter(&rt_waiter);
+ 	rt_waiter.task = NULL;
+ 
+ 	q.pi_state = NULL;
+ 	q.bitset = bitset;
+ 	q.rt_waiter = &rt_waiter;
+ 
+ 	key2 = FUTEX_KEY_INIT;
 -	ret = get_futex_key(uaddr2, fshared, &key2);
++	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
+ 	if (unlikely(ret != 0))
+ 		goto out;
+ 
+ 	/* Prepare to wait on uaddr. */
+ 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+ 	if (ret) {
+ 		put_futex_key(fshared, &key2);
+ 		goto out;
+ 	}
+ 
+ 	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
+ 	futex_wait_queue_me(hb, &q, to, &wait);
+ 
+ 	spin_lock(&hb->lock);
+ 	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
+ 	spin_unlock(&hb->lock);
+ 	if (ret)
+ 		goto out_put_keys;
+ 
+ 	/*
+ 	 * In order for us to be here, we know our q.key == key2, and since
+ 	 * we took the hb->lock above, we also know that futex_requeue() has
+ 	 * completed and we no longer have to concern ourselves with a wakeup
+ 	 * race with the atomic proxy lock acquition by the requeue code.
+ 	 */
+ 
+ 	/* Check if the requeue code acquired the second futex for us. */
+ 	if (!q.rt_waiter) {
+ 		/*
+ 		 * Got the lock. We might not be the anticipated owner if we
+ 		 * did a lock-steal - fix up the PI-state in that case.
+ 		 */
+ 		if (q.pi_state && (q.pi_state->owner != current)) {
+ 			spin_lock(q.lock_ptr);
+ 			ret = fixup_pi_state_owner(uaddr2, &q, current,
+ 						   fshared);
+ 			spin_unlock(q.lock_ptr);
+ 		}
+ 	} else {
+ 		/*
+ 		 * We have been woken up by futex_unlock_pi(), a timeout, or a
+ 		 * signal.  futex_unlock_pi() will not destroy the lock_ptr nor
+ 		 * the pi_state.
+ 		 */
+ 		WARN_ON(!&q.pi_state);
+ 		pi_mutex = &q.pi_state->pi_mutex;
+ 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
+ 		debug_rt_mutex_free_waiter(&rt_waiter);
+ 
+ 		spin_lock(q.lock_ptr);
+ 		/*
+ 		 * Fixup the pi_state owner and possibly acquire the lock if we
+ 		 * haven't already.
+ 		 */
+ 		res = fixup_owner(uaddr2, fshared, &q, !ret);
+ 		/*
+ 		 * If fixup_owner() returned an error, proprogate that.  If it
+ 		 * acquired the lock, clear our -ETIMEDOUT or -EINTR.
+ 		 */
+ 		if (res)
+ 			ret = (res < 0) ? res : 0;
+ 
+ 		/* Unqueue and drop the lock. */
+ 		unqueue_me_pi(&q);
+ 	}
+ 
+ 	/*
+ 	 * If fixup_pi_state_owner() faulted and was unable to handle the
+ 	 * fault, unlock the rt_mutex and return the fault to userspace.
+ 	 */
+ 	if (ret == -EFAULT) {
+ 		if (rt_mutex_owner(pi_mutex) == current)
+ 			rt_mutex_unlock(pi_mutex);
+ 	} else if (ret == -EINTR) {
+ 		ret = -EFAULT;
+ 		if (get_user(uval, uaddr2))
+ 			goto out_put_keys;
+ 
+ 		/*
+ 		 * We've already been requeued, so restart by calling
+ 		 * futex_lock_pi() directly, rather then returning to this
+ 		 * function.
+ 		 */
+ 		ret = -ERESTART_RESTARTBLOCK;
+ 		restart = &current_thread_info()->restart_block;
+ 		restart->fn = futex_lock_pi_restart;
+ 		restart->futex.uaddr = (u32 *)uaddr2;
+ 		restart->futex.val = uval;
+ 		restart->futex.flags = 0;
+ 		if (abs_time) {
+ 			restart->futex.flags |= FLAGS_HAS_TIMEOUT;
+ 			restart->futex.time = abs_time->tv64;
+ 		}
+ 
+ 		if (fshared)
+ 			restart->futex.flags |= FLAGS_SHARED;
+ 		if (clockrt)
+ 			restart->futex.flags |= FLAGS_CLOCKRT;
+ 	}
+ 
+ out_put_keys:
+ 	put_futex_key(fshared, &q.key);
+ 	put_futex_key(fshared, &key2);
+ 
+ out:
+ 	if (to) {
+ 		hrtimer_cancel(&to->timer);
+ 		destroy_hrtimer_on_stack(&to->timer);
+ 	}
+ 	return ret;
+ }
+ 
  /*
   * Support for robust futexes: the kernel cleans up held futexes at
   * thread exit time.
