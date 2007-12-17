Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXLQFZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXLQFZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 00:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXLQFZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 00:25:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:29219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbXLQFZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 00:25:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,174,1196668800"; 
   d="scan'208";a="444023082"
Subject: Re: [PATCH] lib: proportion: fix underflow in prop_norm_percpu()
From: Jiang zhe <zhe.jiang@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1197648086.21927.13.camel@twins>
References: <1197516632.18076.5.camel@localhost.localdomain>
	 <1197582871.3430.1.camel@lappy>
	 <1197620803.22733.13.camel@localhost.localdomain>
	 <1197648086.21927.13.camel@twins>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 13:24:59 +0800
Message-Id: <1197869099.26969.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-14 at 17:01 +0100, Peter Zijlstra wrote:
> Subject: lib: proportion: fix underflow in prop_norm_percpu()
> 
> Zhe Jiang noticed that its possible to underflow pl->events in
> prop_norm_percpu() when the value returned by percpu_counter_read() is less
> than the error on that read and the period delay > 1. In that case half might
> not trigger the batch increment and the value will be identical on the next
> iteration, causing the same half to be subtracted again and again.
> 
> Fix this by rewriting the division as a single subtraction instead of a
> subtraction loop and using percpu_counter_sum() when the value returned
> by percpu_counter_read() is smaller than the error.
> 
> The latter is still needed if we want pl->events to shrink properly in the
> error region.
> 
> Jiang, can I get a Reviewed-by from you? - if you agree that is :-)
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: zhejiang <zhe.jiang@intel.com>
> ---
>  lib/proportions.c |   36 +++++++++++++++---------------------
>  1 file changed, 15 insertions(+), 21 deletions(-)
> 
> Index: linux-2.6/lib/proportions.c
> ===================================================================
> --- linux-2.6.orig/lib/proportions.c
> +++ linux-2.6/lib/proportions.c
> @@ -190,6 +190,8 @@ prop_adjust_shift(int *pl_shift, unsigne
>   * PERCPU
>   */
>  
> +#define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
> +
>  int prop_local_init_percpu(struct prop_local_percpu *pl)
>  {
>  	spin_lock_init(&pl->lock);
> @@ -230,31 +232,23 @@ void prop_norm_percpu(struct prop_global
>  
>  	spin_lock_irqsave(&pl->lock, flags);
>  	prop_adjust_shift(&pl->shift, &pl->period, pg->shift);
> +
>  	/*
>  	 * For each missed period, we half the local counter.
>  	 * basically:
>  	 *   pl->events >> (global_period - pl->period);
> -	 *
> -	 * but since the distributed nature of percpu counters make division
> -	 * rather hard, use a regular subtraction loop. This is safe, because
> -	 * the events will only every be incremented, hence the subtraction
> -	 * can never result in a negative number.
>  	 */
> -	while (pl->period != global_period) {
> -		unsigned long val = percpu_counter_read(&pl->events);
> -		unsigned long half = (val + 1) >> 1;
> -
> -		/*
> -		 * Half of zero won't be much less, break out.
> -		 * This limits the loop to shift iterations, even
> -		 * if we missed a million.
> -		 */
> -		if (!val)
> -			break;
> -
> -		percpu_counter_add(&pl->events, -half);
> -		pl->period += period;
> -	}
> +	period = (global_period - pl->period) >> (pg->shift - 1);
> +	if (period < BITS_PER_LONG) {
> +		s64 val = percpu_counter_read(&pl->events);
> +
> +		if (val < (nr_cpu_ids * PROP_BATCH))
> +			val = percpu_counter_sum(&pl->events);
> +
> +		__percpu_counter_add(&pl->events, -val + (val >> period), PROP_BATCH);
> +	} else
> +		percpu_counter_set(&pl->events, 0);
> +
>  	pl->period = global_period;
>  	spin_unlock_irqrestore(&pl->lock, flags);
>  }
> @@ -267,7 +261,7 @@ void __prop_inc_percpu(struct prop_descr
>  	struct prop_global *pg = prop_get_global(pd);
>  
>  	prop_norm_percpu(pg, pl);
> -	percpu_counter_add(&pl->events, 1);
> +	__percpu_counter_add(&pl->events, 1, PROP_BATCH);
>  	percpu_counter_add(&pg->events, 1);
>  	prop_put_global(pd, pg);
>  }
> 

Reviewed-by: Jiang Zhe <zhe.jiang@intel.com>

Thanks!



