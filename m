Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZKCQlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZKCQlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZKCQls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:41:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZKCQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:41:46 -0500
Subject: Re: [PATCH 1/14] cpumask: simplify sched_rt.c
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <200911031453.15350.rusty@rustcorp.com.au>
References: <200911031453.15350.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 03 Nov 2009 11:41:49 -0500
Message-Id: <1257266509.26028.3343.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I believe this was mostly your code. Can you review this change.

Thanks,

-- Steve


On Tue, 2009-11-03 at 14:53 +1030, Rusty Russell wrote:
> find_lowest_rq() wants to call pick_optimal_cpu() on the intersection
> of sched_domain_span(sd) and lowest_mask.  Rather than doing a cpus_and
> into a temporary, we can open-code it.
> 
> This actually makes the code slightly clearer, IMHO.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> To: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/sched_rt.c |   59 +++++++++++++++++++++---------------------------------
>  1 file changed, 23 insertions(+), 36 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1115,29 +1115,12 @@ static struct task_struct *pick_next_hig
>  
>  static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
>  
> -static inline int pick_optimal_cpu(int this_cpu,
> -				   const struct cpumask *mask)
> -{
> -	int first;
> -
> -	/* "this_cpu" is cheaper to preempt than a remote processor */
> -	if ((this_cpu != -1) && cpumask_test_cpu(this_cpu, mask))
> -		return this_cpu;
> -
> -	first = cpumask_first(mask);
> -	if (first < nr_cpu_ids)
> -		return first;
> -
> -	return -1;
> -}
> -
>  static int find_lowest_rq(struct task_struct *task)
>  {
>  	struct sched_domain *sd;
>  	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
>  	int this_cpu = smp_processor_id();
>  	int cpu      = task_cpu(task);
> -	cpumask_var_t domain_mask;
>  
>  	if (task->rt.nr_cpus_allowed == 1)
>  		return -1; /* No other targets possible */
> @@ -1167,28 +1150,26 @@ static int find_lowest_rq(struct task_st
>  	 * Otherwise, we consult the sched_domains span maps to figure
>  	 * out which cpu is logically closest to our hot cache data.
>  	 */
> -	if (this_cpu == cpu)
> -		this_cpu = -1; /* Skip this_cpu opt if the same */
> +	if (!cpumask_test_cpu(this_cpu, lowest_mask))
> +		this_cpu = -1; /* Skip this_cpu opt if not among lowest */
>  
> -	if (alloc_cpumask_var(&domain_mask, GFP_ATOMIC)) {
> -		for_each_domain(cpu, sd) {
> -			if (sd->flags & SD_WAKE_AFFINE) {
> -				int best_cpu;
> +	for_each_domain(cpu, sd) {
> +		if (sd->flags & SD_WAKE_AFFINE) {
> +			int best_cpu;
>  
> -				cpumask_and(domain_mask,
> -					    sched_domain_span(sd),
> -					    lowest_mask);
> +			/*
> +			 * "this_cpu" is cheaper to preempt than a
> +			 * remote processor.
> +			 */
> +			if (this_cpu != -1 &&
> +			    cpumask_test_cpu(this_cpu, sched_domain_span(sd)))
> +				return this_cpu;
>  
> -				best_cpu = pick_optimal_cpu(this_cpu,
> -							    domain_mask);
> -
> -				if (best_cpu != -1) {
> -					free_cpumask_var(domain_mask);
> -					return best_cpu;
> -				}
> -			}
> +			best_cpu = cpumask_first_and(lowest_mask,
> +						     sched_domain_span(sd));
> +			if (best_cpu < nr_cpu_ids)
> +				return best_cpu;
>  		}
> -		free_cpumask_var(domain_mask);
>  	}
>  
>  	/*
> @@ -1196,7 +1177,13 @@ static int find_lowest_rq(struct task_st
>  	 * just give the caller *something* to work with from the compatible
>  	 * locations.
>  	 */
> -	return pick_optimal_cpu(this_cpu, lowest_mask);
> +	if (this_cpu != -1)
> +		return this_cpu;
> +
> +	cpu = cpumask_any(lowest_mask);
> +	if (cpu < nr_cpu_ids)
> +		return cpu;
> +	return -1;
>  }
>  
>  /* Will lock the rq it finds */
> 

