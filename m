Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZCaHbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZCaHbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZCaHax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:30:53 -0400
Received: from www.tglx.de ([62.245.132.106]:35220 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZCaHaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:30:52 -0400
Date: Tue, 31 Mar 2009 09:30:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 8/8] RFC: futex: add requeue_pi calls
In-Reply-To: <20090330213840.606.59261.stgit@Aeon>
Message-ID: <alpine.LFD.2.00.0903310902240.12916@localhost.localdomain>
References: <20090330213306.606.9540.stgit@Aeon> <20090330213840.606.59261.stgit@Aeon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Darren Hart wrote:
> +
> +	if (requeue_pi) {
> +		if (refill_pi_state_cache())
> +			return -ENOMEM;
> +		if (nr_wake != 1)
> +			return -EINVAL;
> +	}

  Needs a comment
  
>  retry:
> +	if (pi_state != NULL) {
> +		free_pi_state(pi_state);
> +		pi_state = NULL;
> +	}

  Ditto

> +	if (requeue_pi) {
> +		/* Attempt to acquire uaddr2 and wake the top_waiter. */
> +		ret = futex_proxy_trylock_atomic(uaddr2, hb1, hb2, &key1,
> +						 &key2, &pi_state);
> +
> +		/*
> +		 * At this point the top_waiter has either taken uaddr2 or is
> +		 * waiting on it.  If the former, then the pi_state will not
> +		 * exist yet, look it up one more time to ensure we have a
> +		 * reference to it.
> +		 */
> +		if (ret == 1 && !pi_state) {
> +			task_count++;
> +			ret = get_futex_value_locked(&curval2, uaddr2);
> +			if (!ret)
> +				ret = lookup_pi_state(curval2, hb2, &key2,
> +						      &pi_state);
> +		}
> +
> +		switch (ret) {
> +		case 0:
> +			break;
> +		case -EFAULT:
> +			double_unlock_hb(hb1, hb2);
> +			put_futex_key(fshared, &key2);
> +			put_futex_key(fshared, &key1);
> +			ret = get_user(curval2, uaddr2);
> +			if (!ret)
> +				goto retry;

  Hmm. What happens if futex_proxy_trylock_atomic() succeeds, but
  get_futex_value_locked() fails ? I guess its unlikely to happen, but
  in case it does are we sure that our state is correct ?

> +
> +		/* This can go after we're satisfied with testing. */
> +		if (!requeue_pi)
> +			WARN_ON(this->rt_waiter);

  Keep those WARN_ONs. they are useful when code is changed later. Just make it
  
	WARN_ON(!requeue_pi && this->rt_waiter);
	WARN_ON(requeue_pi && !this->rt_waiter);

> +		/*
> +		 * Requeue nr_requeue waiters and possibly one more in the case
> +		 * of requeue_pi if we couldn't acquire the lock atomically.
> +		 */
> +		if (requeue_pi) {
> +			/* This can go after we're satisfied with testing. */
> +			WARN_ON(!this->rt_waiter);
> +
> +			/* Prepare the waiter to take the rt_mutex. */
> +			atomic_inc(&pi_state->refcount);
> +			this->pi_state = pi_state;
> +			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
> +							this->rt_waiter,
> +							this->task, 1);
> +			if (ret) {
> +				this->pi_state = NULL;
> +				free_pi_state(pi_state);
> +				goto out_unlock;

  What are the reasons of dropping out here ?

> +	/*
> +	 * Ensure the requeue is atomic to avoid races while we process the
> +	 * wakeup.  We only need to hold hb->lock to ensure atomicity as the
> +	 * wakeup code can't change q.key from uaddr to uaddr2 if we hold that
> +	 * lock. It can't be requeued from uaddr2 to something else since we
> +	 * don't support a PI aware source futex for requeue.
> +	 */
> +	spin_lock(&hb->lock);
> +	if (!match_futex(&q.key, &key2)) {
> +		WARN_ON(q.lock_ptr && (&hb->lock != q.lock_ptr));
> +		/*
> +		 * We were not requeued, handle wakeup from futex1 (uaddr).  We
> +		 * cannot have been unqueued and already hold the lock, no need
> +		 * to call unqueue_me, just do it directly.
> +		 */
> +		plist_del(&q.list, &q.list.plist);
> +		drop_futex_key_refs(&q.key);
> +
> +		ret = -ETIMEDOUT;
> +		if (to && !to->task) {
> +			spin_unlock(&hb->lock);
> +			goto out_put_keys;
> +		}
> +
> +		/*
> +		 * We expect signal_pending(current), but another thread may
> +		 * have handled it for us already.
> +		 */
> +		ret = -ERESTARTSYS;
> +		if (!abs_time) {
> +			spin_unlock(&hb->lock);
> +			goto out_put_keys;
> +		}

  Hmm. Why do we use restart block here ? The timeout is absolute, so
  we can just restart the syscall, can't we ?

> +	ret = 0;
> +	/*
> +	 * Check if the waker acquired the second futex for us. If the lock_ptr
> +	 * is NULL, but our key is key2, then the requeue target futex was
> +	 * uncontended and the waker gave it to us.  This is safe without a lock
> +	 * as futex_requeue() will not release the hb lock until after it's
> +	 * nulled the lock_ptr and removed us from the hb.
> +	 */
> +	if (!q.lock_ptr)
> +		goto out_put_keys;

  At this point we hold the rt_mutex, the pi state is correct and the
  user space variable at *uaddr2 is updated, right ??

Thanks,

	tglx
