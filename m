Return-Path: <linux-kernel-owner+w=401wt.eu-S1764196AbXLNJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764196AbXLNJtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXLNJtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:49:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55664 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXLNJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:49:39 -0500
Subject: Re: [PATCH]Avoid the overflow when calculate the proportion of bdi
	quota
From: Peter Zijlstra <peterz@infradead.org>
To: zhejiang <zhe.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
In-Reply-To: <1197622070.6895.33.camel@twins>
References: <1197516632.18076.5.camel@localhost.localdomain>
	 <1197582871.3430.1.camel@lappy>
	 <1197620803.22733.13.camel@localhost.localdomain>
	 <1197622070.6895.33.camel@twins>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 10:49:36 +0100
Message-Id: <1197625776.6895.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-14 at 09:47 +0100, Peter Zijlstra wrote:

> How about something like this:
> 
> diff --git a/lib/proportions.c b/lib/proportions.c
> index 332d8c5..4afb330 100644
> --- a/lib/proportions.c
> +++ b/lib/proportions.c
> @@ -190,6 +190,8 @@ prop_adjust_shift(int *pl_shift, unsigned long *pl_period, int new_shift)
>   * PERCPU
>   */
>  
> +#define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
> +
>  int prop_local_init_percpu(struct prop_local_percpu *pl)
>  {
>  	spin_lock_init(&pl->lock);
> @@ -203,6 +205,16 @@ void prop_local_destroy_percpu(struct prop_local_percpu *pl)
>  	percpu_counter_destroy(&pl->events);
>  }
>  
> +static unsigned long prop_percpu_read(struct prop_local_percpu *pl)
> +{
> +	unsigned long val = percpu_counter_read(&pl->events);
> +
> +	if (val < (nr_cpu_ids * PROP_BATCH))
> +		val = percpu_counter_sum(&pl->events);
> +
> +	return val;
> +}
> +
>  /*
>   * Catch up with missed period expirations.
>   *
> @@ -241,7 +253,7 @@ void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu *pl)
>  	 * can never result in a negative number.
>  	 */
>  	while (pl->period != global_period) {
> -		unsigned long val = percpu_counter_read(&pl->events);
> +		unsigned long val = prop_percpu_read(pl);
>  		unsigned long half = (val + 1) >> 1;
>  
>  		/*
> @@ -252,7 +264,7 @@ void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu *pl)
>  		if (!val)
>  			break;
>  
> -		percpu_counter_add(&pl->events, -half);
> +		__percpu_counter_add(&pl->events, -half, PROP_BATCH);
>  		pl->period += period;
>  	}
>  	pl->period = global_period;
> @@ -267,7 +279,7 @@ void __prop_inc_percpu(struct prop_descriptor *pd, struct prop_local_percpu *pl)
>  	struct prop_global *pg = prop_get_global(pd);
>  
>  	prop_norm_percpu(pg, pl);
> -	percpu_counter_add(&pl->events, 1);
> +	__percpu_counter_add(&pl->events, 1, PROP_BATCH);
>  	percpu_counter_add(&pg->events, 1);
>  	prop_put_global(pd, pg);
>  }
> 

Might as well stack something like this on top:

Index: linux-2.6/lib/proportions.c
===================================================================
--- linux-2.6.orig/lib/proportions.c
+++ linux-2.6/lib/proportions.c
@@ -242,31 +242,19 @@ void prop_norm_percpu(struct prop_global
 
 	spin_lock_irqsave(&pl->lock, flags);
 	prop_adjust_shift(&pl->shift, &pl->period, pg->shift);
+
 	/*
 	 * For each missed period, we half the local counter.
 	 * basically:
 	 *   pl->events >> (global_period - pl->period);
-	 *
-	 * but since the distributed nature of percpu counters make division
-	 * rather hard, use a regular subtraction loop. This is safe, because
-	 * the events will only every be incremented, hence the subtraction
-	 * can never result in a negative number.
 	 */
-	while (pl->period != global_period) {
-		unsigned long val = prop_local_read_percpu(pl);
-		unsigned long half = (val + 1) >> 1;
-
-		/*
-		 * Half of zero won't be much less, break out.
-		 * This limits the loop to shift iterations, even
-		 * if we missed a million.
-		 */
-		if (!val)
-			break;
-
-		__percpu_counter_add(&pl->events, -half, PROP_BATCH);
-		pl->period += period;
-	}
+	period = (global_period - pl->period) >> (pg->shift - 1);
+	if (period < BITS_PER_LONG) {
+		s64 val = (u64)prop_local_read_percpu(pl);
+		__percpu_counter_add(&pl->events, -val + (val >> period), PROP_BATCH);
+	} else
+		percpu_counter_set(&pl->events, 0);
+
 	pl->period = global_period;
 	spin_unlock_irqrestore(&pl->lock, flags);
 }


