Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZCGR3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZCGR3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 12:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZCGR3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 12:29:10 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58949 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZCGR3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 12:29:09 -0500
Date: Sat, 7 Mar 2009 09:29:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu_barrier VS cpu_hotplug: Ensure callbacks in dead
	cpu are migrated to online cpu
Message-ID: <20090307172907.GH10625@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49B2526E.40106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B2526E.40106@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 06:54:38PM +0800, Lai Jiangshan wrote:
> [RFC]
> I don't like this patch, but I thought for some days and I can't
> thought out a better one.
> 
> I'm very hope rcu_barrier() can be called anywhere(any sleepable context).
> But get_online_cpus() is a very large lock, it limits rcu_barrier().
> 
> We can avoid get_online_cpus() easily for rcupreempt by using a new rcu_barrier:
> void rcu_barrier(void)
> {
> 	for each rcu_data {
> 		lock rcu_data;
> 		if rcu_data is not empty, queue a callback for rcu_barrier;
> 		unlock rcu_data;
> 	}
> }
> But we cannot use this algorithm for rcuclassic and rcutree,
> rcu_data in rcuclassic and rcutree have not a spinlock for queuing callback.
> 
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> cpu hotplug may be happened asynchronously, some rcu callbacks are maybe
> still in dead cpu, rcu_barrier() also needs to wait for these rcu callbacks
> to complete, so we must ensure callbacks in dead cpu are migrated to
> online cpu.

Hmmm...  I thought that on_each_cpu() took care of interlocking with
CPU hotplug via smp_call_function().  During a CPU-hotplug operation,
the RCU callbacks do get migrated from the CPU going offline.  Are you
seeing a sequence of events that finds a hole in this approach?

Now, if a CPU were to go offline in the middle of smp_call_function()
there could be trouble, but I was under the impression that the
preempt_disable() in on_each_cpu() prevented this from happening.

So, please tell me more!

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index cae8a05..4665d18 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -129,6 +129,8 @@ static void rcu_barrier_func(void *type)
>  static void _rcu_barrier(enum rcu_barrier type)
>  {
>  	BUG_ON(in_interrupt());
> +	/* Ensure callbacks in dead cpu are migrated to online cpu */
> +	get_online_cpus();
>  	/* Take cpucontrol mutex to protect against CPU hotplug */
>  	mutex_lock(&rcu_barrier_mutex);
>  	init_completion(&rcu_barrier_completion);
> @@ -147,6 +149,7 @@ static void _rcu_barrier(enum rcu_barrier type)
>  		complete(&rcu_barrier_completion);
>  	wait_for_completion(&rcu_barrier_completion);
>  	mutex_unlock(&rcu_barrier_mutex);
> +	put_online_cpus();
>  }
> 
>  /**
> 
