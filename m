Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbYJ0F1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbYJ0F1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 01:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYJ0F1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 01:27:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42927 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYJ0F1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 01:27:07 -0400
Date: Sun, 26 Oct 2008 14:55:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: reduce sys's overhead when rcu_barrier()s
	called simultaneous
Message-ID: <20081026215531.GA6236@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49015F45.1070002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49015F45.1070002@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 01:38:13PM +0800, Lai Jiangshan wrote:
> 
> rcu_barrier() queues rcu_head on all cpus, it will brings
> large overhead for a large system which has a lots cpu.
> this fix reduces sys's overhead when rcu_barrier()s called
> simultaneous.

Hello, Jiangshan,

If we were to have problems with many concurrent rcu_barrier()
calls stacking up, this patch looks like it would be a reasonable
was of addressing those problems.

But do we really have problems with this at the moment?

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index ad63af8..734850b 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -53,6 +53,9 @@ enum rcu_barrier {
> 
>  static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
>  static atomic_t rcu_barrier_cpu_count;
> +static unsigned long rcu_barrier_completed;
> +static unsigned long rcu_barrier_completed_bh;
> +static unsigned long rcu_barrier_completed_sched;
>  static DEFINE_MUTEX(rcu_barrier_mutex);
>  static struct completion rcu_barrier_completion;
> 
> @@ -60,7 +63,7 @@ static struct completion rcu_barrier_completion;
>   * Awaken the corresponding synchronize_rcu() instance now that a
>   * grace period has elapsed.
>   */
> -void wakeme_after_rcu(struct rcu_head  *head)
> +void wakeme_after_rcu(struct rcu_head *head)
>  {
>  	struct rcu_synchronize *rcu;
> 
> @@ -113,11 +116,20 @@ static void rcu_barrier_func(void *type)
>   * Orchestrate the specified type of RCU barrier, waiting for all
>   * RCU callbacks of the specified type to complete.
>   */
> -static void _rcu_barrier(enum rcu_barrier type)
> +static void _rcu_barrier(enum rcu_barrier type, unsigned long *completed)
>  {
> +	unsigned long batch = ACCESS_ONCE(*completed);
>  	BUG_ON(in_interrupt());
>  	/* Take cpucontrol mutex to protect against CPU hotplug */
>  	mutex_lock(&rcu_barrier_mutex);
> +
> +	BUG_ON(*completed & 1);
> +	if ((*completed - batch) >= 2) {
> +		mutex_unlock(&rcu_barrier_mutex);
> +		return;
> +	}
> +	(*completed)++;
> +
>  	init_completion(&rcu_barrier_completion);
>  	/*
>  	 * Initialize rcu_barrier_cpu_count to 1, then invoke
> @@ -133,6 +145,7 @@ static void _rcu_barrier(enum rcu_barrier type)
>  	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
>  		complete(&rcu_barrier_completion);
>  	wait_for_completion(&rcu_barrier_completion);
> +	(*completed)++;
>  	mutex_unlock(&rcu_barrier_mutex);
>  }
> 
> @@ -141,7 +154,7 @@ static void _rcu_barrier(enum rcu_barrier type)
>   */
>  void rcu_barrier(void)
>  {
> -	_rcu_barrier(RCU_BARRIER_STD);
> +	_rcu_barrier(RCU_BARRIER_STD, &rcu_barrier_completed);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier);
> 
> @@ -150,7 +163,7 @@ EXPORT_SYMBOL_GPL(rcu_barrier);
>   */
>  void rcu_barrier_bh(void)
>  {
> -	_rcu_barrier(RCU_BARRIER_BH);
> +	_rcu_barrier(RCU_BARRIER_BH, &rcu_barrier_completed_bh);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_bh);
> 
> @@ -159,7 +172,7 @@ EXPORT_SYMBOL_GPL(rcu_barrier_bh);
>   */
>  void rcu_barrier_sched(void)
>  {
> -	_rcu_barrier(RCU_BARRIER_SCHED);
> +	_rcu_barrier(RCU_BARRIER_SCHED, &rcu_barrier_completed_sched);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> 
> 
> 
