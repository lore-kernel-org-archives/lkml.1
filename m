Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZCFCWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZCFCWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 21:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZCFCVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 21:21:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZCFCVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 21:21:54 -0500
Date: Thu, 5 Mar 2009 21:21:50 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [TIP][RFC 6/7] futex: add requeue_pi calls
In-Reply-To: <49B07F87.2020808@us.ibm.com>
Message-ID: <alpine.DEB.2.00.0903052119300.14535@gandalf.stny.rr.com>
References: <49AC73A9.4040804@us.ibm.com> <49AC77D1.6090106@us.ibm.com> <49AE3386.1070604@us.ibm.com> <49B00302.5000607@us.ibm.com> <49B07F87.2020808@us.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 5 Mar 2009, Darren Hart wrote:
> 
> As it turns out I missed setting RT_MUTEX_HAS_WAITERS on the rt_mutex in
> rt_mutex_start_proxy_lock() - seems awfully silly in retrospect - but a
> little non-obvious while writing it.  I added mark_rt_mutex_waiters()
> after the call to task_blocks_on_rt_mutex() and the test has completed
> more than 400 iterations successfully (it would fail after no more than
> 2 most of the time before).
> 
> Steven, there are several ways to set RT_MUTEX_HAS_WAITERS - but this
> seemed like a reasonable approach, would you agree?  Since I'm holding
> the wait_lock I don't technically need the atomic cmpxchg and could
> probably just set it explicity - do you have a preference?
> 

> +
> +/**
> + * rt_mutex_finish_proxy_lock - Complete the taking of the lock initialized
> on
> + *                              our behalf by another thread.
> + * @lock: the rt_mutex we were woken on
> + * @to: the timeout, null if none. hrtimer should already have been started.
> + * @waiter: the pre-initialized rt_mutex_waiter
> + * @detect_deadlock: for use by __rt_mutex_slowlock
> + *
> + * Special API call for PI-futex requeue support
> + */
> +int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
> +			       struct hrtimer_sleeper *to,
> +			       struct rt_mutex_waiter *waiter,
> +			       int detect_deadlock)
> +{
> +	int ret;
> +
> +	if (waiter->task)
> +		schedule_rt_mutex(lock);
> +
> +	spin_lock(&lock->wait_lock);
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +
> +	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
> +				  detect_deadlock);
> +
> +	set_current_state(TASK_RUNNING);
> +
> +	if (unlikely(waiter->task))
> +		remove_waiter(lock, waiter);
> +
> +	/*
> +	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We
> might
> +	 * have to fix that up.
> +	 */
> +	fixup_rt_mutex_waiters(lock);

Darren,

I take it you are talking about the above.

 static void fixup_rt_mutex_waiters(struct rt_mutex *lock)
 {
	if (!rt_mutex_has_waiters(lock))
		clear_rt_mutex_waiters(lock);
 }

So it only clears the bit if there are no waiters. Yep, that should be 
fine. The task clearing the bit is the owner and you have the wait_lock. 
This should work.

-- Steve


> +
> +	spin_unlock(&lock->wait_lock);
> +
> +	/*
> +	 * Readjust priority, when we did not get the lock. We might have been
> +	 * the pending owner and boosted. Since we did not take the lock, the
> +	 * PI boost has to go.
> +	 */
> +	if (unlikely(ret))
> +		rt_mutex_adjust_prio(current);
> +
> +	return ret;
> +}


