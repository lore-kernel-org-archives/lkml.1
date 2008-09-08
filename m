Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYIHNWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYIHNWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYIHNWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:22:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYIHNWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:22:00 -0400
Subject: Re: [RFC PATCH v2 5/7] sched: nominate preferred wakeup cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <20080908132132.3221.6102.stgit@drishya.in.ibm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
	 <20080908132132.3221.6102.stgit@drishya.in.ibm.com>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 15:21:31 +0200
Message-Id: <1220880091.12278.16.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 18:51 +0530, Vaidyanathan Srinivasan wrote:
> When the system utilisation is low and more cpus are idle,
> then the process waking up from sleep should prefer to
> wakeup an idle cpu from semi-idle cpu package (multi core
> package) rather than a completely idle cpu package which
> would waste power.
> 
> Use the sched_mc balance logic in find_busiest_group() to
> nominate a preferred wakeup cpu.
> 
> This info can be sored in appropriate sched_domain, but
> updating this info in all copies of sched_domain is not
> practical.  For now lets try with a global variable.
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 569fc8d..4ae79f5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3380,6 +3380,9 @@ out_balanced:
>  
>  	if (this == group_leader && group_leader != group_min) {
>  		*imbalance = min_load_per_task;
> +		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP)
> +			sched_mc_preferred_wakeup_cpu =
> +					first_cpu(group_leader->cpumask);
>  		return group_min;
>  	}
>  #endif
> @@ -6911,6 +6914,13 @@ static void sched_domain_node_span(int node, cpumask_t *span)
>  int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
>  
>  /*
> + * Preferred wake up cpu nominated by sched_mc balance that will be used when
> + * most cpus are idle in the system indicating overall very low system
> + * utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP (2).
> + */
> +unsigned int sched_mc_preferred_wakeup_cpu;

This cannot be a global variable, what happens when we have two disjoint
load-balance domains?

> +/*
>   * SMT sched-domains:
>   */
>  #ifdef CONFIG_SCHED_SMT
> 

