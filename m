Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZHXPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZHXPW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZHXPW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:22:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZHXPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:22:27 -0400
Subject: Re: [PATCH 11/15] sched: Pass unlimited __cpu_power information to
 upper domain level groups
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham Shenoy <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20090820134155.GZ29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134155.GZ29327@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 17:21:37 +0200
Message-Id: <1251127297.7538.291.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:41 +0200, Andreas Herrmann wrote:
> For performance reasons __cpu_power in a sched_group might be limited
> such that the group can handle only one task. To correctly calculate
> the capacity in upper domain level groups the unlimited power
> information is required. This patch stores unlimited __cpu_power
> information in sched_groups.orig_power and uses this when calculating
> __cpu_power in upper domain level groups.

OK, so this tries to fix the cpu_power wreckage?

ok, so let me try this with an example:


Suppose we have a dual-core with shared cache and SMT

  0-3     MC
0-1 2-3   SMT

Then both levels fancy setting SHARED_RESOURCES and both levels end up
normalizing the cpu_power to 1, so when we unplug cpu 2, load-balancing
gets all screwy because the whole system doesn't get normalized
properly.

What you propose here is every time we muck with cpu_power we keep the
real stuff in orig_power and use that to compute the level above.

Except you don't use it in the load-balancer proper, so normalization is
still hosed.

Its a creative solution, but I'd rather see cpu_power returned to a
straight sum of actual power to normalize the inter-cpu runqueue weights
and do the placement decision using something else.

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  include/linux/sched.h |    8 +++++++-
>  kernel/sched.c        |   36 ++++++++++++++++++++++++------------
>  2 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c53bdd8..d230717 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -890,7 +890,13 @@ struct sched_group {
>  	 * (see include/linux/reciprocal_div.h)
>  	 */
>  	u32 reciprocal_cpu_power;
> -
> +	/*
> +	 * Backup of original power for this group.
> +	 * It is used to pass correct power information to upper
> +	 * domain level groups in case __cpu_power is limited for
> +	 * performance reasons.
> +	 */
> +	unsigned int orig_power;
>  	/*
>  	 * The CPUs this group covers.
>  	 *
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 7a0d710..464b6ba 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8376,6 +8376,7 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
>  
>  			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
>  		}
> +		sg->orig_power = sg->__cpu_power;
>  		sg = sg->next;
>  	} while (sg != group_head);
>  }
> @@ -8514,18 +8515,9 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>  	child = sd->child;
>  
>  	sd->groups->__cpu_power = 0;
> -
> -	/*
> -	 * For perf policy, if the groups in child domain share resources
> -	 * (for example cores sharing some portions of the cache hierarchy
> -	 * or SMT), then set this domain groups cpu_power such that each group
> -	 * can handle only one task, when there are other idle groups in the
> -	 * same sched domain.
> -	 */
> -	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
> -		       (child->flags &
> -			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
> +	if (!child) {
>  		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
> +		sd->groups->orig_power = sd->groups->__cpu_power;
>  		return;
>  	}
>  
> @@ -8534,9 +8526,29 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>  	 */
>  	group = child->groups;
>  	do {
> -		sg_inc_cpu_power(sd->groups, group->__cpu_power);
> +		sg_inc_cpu_power(sd->groups, group->orig_power);
>  		group = group->next;
>  	} while (group != child->groups);
> +	sd->groups->orig_power = sd->groups->__cpu_power;
> +
> +	/*
> +	 * For perf policy, if the groups in child domain share resources
> +	 * (for example cores sharing some portions of the cache hierarchy
> +	 * or SMT), then set this domain groups cpu_power such that each group
> +	 * can handle only one task, when there are other idle groups in the
> +	 * same sched domain.
> +	 * Note: Unmodified power information is kept in orig_power and
> +	 *       can be used in higher domain levels to calculate
> +	 *       and reflect the correct capacity of a sched_group.
> +	 *       This is required for power_savings scheduling.
> +	 */
> +	if (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
> +	    ((child->flags &
> +	      (SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
> +		sd->groups->__cpu_power = 0;
> +		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
> +	}
> +
>  }
>  
>  /*
