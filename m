Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbYJPPxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbYJPPxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYJPPxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:53:33 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39925 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbYJPPxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:53:32 -0400
Date: Thu, 16 Oct 2008 08:45:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: fix 2 bugs of rcu_barrier*()
Message-ID: <20081016154548.GC6772@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48F700AC.1080405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F700AC.1080405@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 04:51:56PM +0800, Lai Jiangshan wrote:
> 
> current rcu_barrier_bh() is like this:
> 
> void rcu_barrier_bh(void)
> {
> 	BUG_ON(in_interrupt());
> 	/* Take cpucontrol mutex to protect against CPU hotplug */
> 	mutex_lock(&rcu_barrier_mutex);
> 	init_completion(&rcu_barrier_completion);
> 	atomic_set(&rcu_barrier_cpu_count, 0);
> 	/*
> 	 * The queueing of callbacks in all CPUs must be atomic with
> 	 * respect to RCU, otherwise one CPU may queue a callback,
> 	 * wait for a grace period, decrement barrier count and call
> 	 * complete(), while other CPUs have not yet queued anything.
> 	 * So, we need to make sure that grace periods cannot complete
> 	 * until all the callbacks are queued.
> 	 */
> 	rcu_read_lock();
> 	on_each_cpu(rcu_barrier_func, (void *)RCU_BARRIER_BH, 1);
> 	rcu_read_unlock();
> 	wait_for_completion(&rcu_barrier_completion);
> 	mutex_unlock(&rcu_barrier_mutex);
> }
> 
> this is bug, rcu_read_lock() cannot make sure that "grace periods for RCU_BH
> cannot complete until all the callbacks are queued".
> it only make sure that race periods for RCU cannot complete
> until all the callbacks are queued.
> 
> so we must use rcu_read_lock_bh() for rcu_barrier_bh().
> like this:
> 
> void rcu_barrier_bh(void)
> {
> 	......
> 	rcu_read_lock_bh();
> 	on_each_cpu(rcu_barrier_func, (void *)RCU_BARRIER_BH, 1);
> 	rcu_read_unlock_bh();
> 	......
> }
> 
> and also rcu_barrier() rcu_barrier_sched() are implemented like this.
> it will bring a lot of duplicate code. My patch uses another way to
> fix this bug, please see the comment of my patch.

Excellent catch!!!  I had incorrectly convinced myself that because RCU
read-side implies an RCU_BH and RCU_SCHED that I could simply use an
RCU read-side critical section.  Thank you for finding this!

Just out of curiosity, did an actual oops/hang lead you to this bug, or
did you find it by inspection?

> Bug 2:
> on_each_cpu() do not imply wmb, so we need a explicit wmb.
> I became a paranoid too.

Actually, there is a memory barrier in the list_add_tail_rcu() in the
implementation of smp_call_function(), and furthermore, the way that
atomic operations work on all architectures I am aware of removes the need
for the memory barrier.  Nevertheless, I have absolutely no objection
to adding this memory barrier.  This code path is used infrequently and
has high overhead anyway, so I agree that making it easy to understand
is the correct approach.  If it were on the read side, I would argue.  ;-)

In any case, I must agree that you are doing a good job of learning to
be paranoid!

The only change I suggest is to rewrite the comments as shown below.

With that update, this change should be applied.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index 467d594..a667e21 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -119,18 +119,23 @@ static void _rcu_barrier(enum rcu_barrier type)
>  	/* Take cpucontrol mutex to protect against CPU hotplug */
>  	mutex_lock(&rcu_barrier_mutex);
>  	init_completion(&rcu_barrier_completion);
> -	atomic_set(&rcu_barrier_cpu_count, 0);
>  	/*
> -	 * The queueing of callbacks in all CPUs must be atomic with
> -	 * respect to RCU, otherwise one CPU may queue a callback,
> -	 * wait for a grace period, decrement barrier count and call
> -	 * complete(), while other CPUs have not yet queued anything.
> -	 * So, we need to make sure that grace periods cannot complete
> -	 * until all the callbacks are queued.
> +	 * init and set rcu_barrier_cpu_count to 1, otherwise(set it to 0)
> +	 * one CPU may queue a callback, wait for a grace period, decrement
> +	 * barrier count and call complete(), while other CPUs have not yet
> +	 * queued anything.
> +	 * So, we need to make sure that rcu_barrier_cpu_count cannot become
> +	 * 0 until all the callbacks are queued.

	 * Initialize rcu_barrier_cpu_count to 1, then invoke
	 * rcu_barrier_func() on each CPU, so that each CPU also has
	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
	 * might complete its grace period before all of the other CPUs
	 * did their increment, causing this function to return too
	 * early.

>  	 */
> -	rcu_read_lock();
> +	atomic_set(&rcu_barrier_cpu_count, 1);
> +	/*
> +	 * rcu_barrier_cpu_count = 1 must be visible to cpus before
> +	 * them call rcu_barrier_func().
> +	 */
> +	smp_wmb();

	smp_wmb(); /* atomic_set() must precede all rcu_barrier_func()s. */

>  	on_each_cpu(rcu_barrier_func, (void *)type, 1);
> -	rcu_read_unlock();
> +	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
> +		complete(&rcu_barrier_completion);
>  	wait_for_completion(&rcu_barrier_completion);
>  	mutex_unlock(&rcu_barrier_mutex);
>  }
> 
> 
> 
