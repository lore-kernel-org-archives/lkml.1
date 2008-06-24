Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYFXKNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYFXKNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYFXKNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:13:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:50741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYFXKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:13:37 -0400
Subject: Re: [PATCH 1/3] sched: enable interrupts and drop rq-lock during
	newidle balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       dbahi@novell.com
In-Reply-To: <20080623230440.31515.97377.stgit@lsg.lsg.lab.novell.com>
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
	 <20080623230440.31515.97377.stgit@lsg.lsg.lab.novell.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 12:13:25 +0200
Message-Id: <1214302405.4351.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 17:04 -0600, Gregory Haskins wrote:
> We do find_busiest_groups() et. al. without locks held for normal balancing,
> so lets do it for newidle as well.  It will allow other cpus to make
> forward progress (against our RQ) while we try to balance and allow 
> some interrupts to occur.

Is running f_b_g really that expensive? I was under the impression that
move_tasks() is the expensive one...

> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  kernel/sched.c |   44 ++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 31f91d9..490e6bc 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3333,6 +3333,16 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
>  	int sd_idle = 0;
>  	int all_pinned = 0;
>  	cpumask_t cpus = CPU_MASK_ALL;
> +	int nr_running;
> +
> +	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
> +
> +	/*
> +	 * We are in a preempt-disabled section, so dropping the lock/irq
> +	 * here simply means that other cores may acquire the lock,
> +	 * and interrupts may occur.
> +	 */
> +	spin_unlock_irq(&this_rq->lock);
>  
>  	/*
>  	 * When power savings policy is enabled for the parent domain, idle
> @@ -3344,7 +3354,6 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
>  	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
>  		sd_idle = 1;
>  
> -	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
>  redo:
>  	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
>  				   &sd_idle, &cpus, NULL);
> @@ -3366,14 +3375,33 @@ redo:
>  
>  	ld_moved = 0;
>  	if (busiest->nr_running > 1) {
> -		/* Attempt to move tasks */
> -		double_lock_balance(this_rq, busiest);
> -		/* this_rq->clock is already updated */
> -		update_rq_clock(busiest);
> +		local_irq_disable();
> +		double_rq_lock(this_rq, busiest);
> +
> +		BUG_ON(this_cpu != smp_processor_id());
> +
> +		/*
> +		 * Checking rq->nr_running covers both the case where
> +		 * newidle-balancing pulls a task, as well as if something
> +		 * else issued a NEEDS_RESCHED (since we would only need
> +		 * a reschedule if something was moved to us)
> +		 */
> +		if (this_rq->nr_running) {
> +			double_rq_unlock(this_rq, busiest);
> +			local_irq_enable();
> +			goto out_balanced;
> +		}
> +
>  		ld_moved = move_tasks(this_rq, this_cpu, busiest,
>  					imbalance, sd, CPU_NEWLY_IDLE,
>  					&all_pinned);
> -		spin_unlock(&busiest->lock);
> +
> +		nr_running = this_rq->nr_running;
> +		double_rq_unlock(this_rq, busiest);
> +		local_irq_enable();
> +
> +		if (nr_running)
> +			goto out_balanced;
>  
>  		if (unlikely(all_pinned)) {
>  			cpu_clear(cpu_of(busiest), cpus);
> @@ -3382,6 +3410,8 @@ redo:
>  		}
>  	}
>  
> +	spin_lock_irq(&this_rq->lock);
> +
>  	if (!ld_moved) {
>  		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
>  		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
> @@ -3393,6 +3423,8 @@ redo:
>  	return ld_moved;
>  
>  out_balanced:
> +	spin_lock_irq(&this_rq->lock);
> +
>  	schedstat_inc(sd, lb_balanced[CPU_NEWLY_IDLE]);
>  	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
>  	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
> 

