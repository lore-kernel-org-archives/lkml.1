Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbXCECfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbXCECfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXCECfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:35:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbXCECfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:35:47 -0500
Date: Mon, 5 Mar 2007 03:35:34 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: optimize siblings status check logic in wake_idle()
Message-ID: <20070305023534.GB16666@wotan.suse.de>
References: <20070302202331.B27368@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302202331.B27368@unix-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 08:23:32PM -0800, Suresh B wrote:
> When a logical cpu 'x' already has more than one process running, then most likely
> the siblings of that cpu 'x' must be busy. Otherwise the idle siblings
> would have likely(in most of the scenarios) picked up the extra load making
> the load on 'x' atmost one.

Do you have any stats on this?

> Use this logic to eliminate the siblings status check and minimize the cache
> misses encountered on a heavily loaded system.

Well it does increase the cacheline footprint a bit, but all cachelines
should be local to our L1 cache, presuming you don't have any CPUs where
threads have seperate caches.

What sort of numbers do you have?

> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0dc7572..d1ecc56 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1368,7 +1368,16 @@ static int wake_idle(int cpu, struct task_struct *p)
>  	struct sched_domain *sd;
>  	int i;
>  
> -	if (idle_cpu(cpu))
> +	/*
> +	 * If it is idle, then it is the best cpu to run this task.
> +	 *
> +	 * This cpu is also the best, if it has more than one task already.
> +	 * Siblings must be also busy(in most cases) as they didn't already
> +	 * pickup the extra load from this cpu and hence we need not check
> +	 * sibling runqueue info. This will avoid the checks and cache miss
> +	 * penalities associated with that.
> +	 */
> +	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
>  		return cpu;
>  
>  	for_each_domain(cpu, sd) {
