Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYIYM0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYIYM0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYIYM0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:26:12 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:33561 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753029AbYIYM0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:26:11 -0400
Date: Thu, 25 Sep 2008 17:54:20 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v1 3/5] Collect statistics required for powersave
	balance
Message-ID: <20080925122420.GA4403@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080924161228.31581.57651.stgit@drishya.in.ibm.com> <20080924161809.31581.11013.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924161809.31581.11013.stgit@drishya.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 09:48:09PM +0530, Vaidyanathan Srinivasan wrote:
> Update sched domain level statistics with the minimum load and
> group leader who can pull more tasks. Also suggest a powersave
> movement if the domain is otherwise balanced.
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 97 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8c394a4..dd87061 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3219,6 +3219,103 @@ void update_sd_loads(struct sd_loads *sdl, struct group_loads *gl)
> 
>  }
> 
> +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +void update_powersavings_group_loads(struct sd_loads *sdl,
> +				     struct group_loads *gl,
> +				     enum cpu_idle_type idle)
> +{
> +	int group_capacity = gl->group->__cpu_power / SCHED_LOAD_SCALE;
> +
> +	/*
> +	 * Busy processors will not participate in power savings
> +	 * balance.
> +	 */
> +	if (idle == CPU_NOT_IDLE ||
> +			!(sdl->sd->flags & SD_POWERSAVINGS_BALANCE))
> +		return;
> +
> +	/*
> +	 * If the local group is idle or completely loaded
> +	 * no need to do power savings balance at this domain
> +	 * Same case of non-local groups as well
> +	 */
	Are there groups other than local and non-local ?
	If not, this comment can be condensed so that it can be applied
	to all groups :-)

> +	if (gl->nr_running >= group_capacity || gl->nr_running == 0)
> +		return;
> +
> +	/*
> +	 * Calculate the group which has the least non-idle load.
> +	 * This is the group from where we need to pick up the load
> +	 * for saving power
> +	 */
> +	if (!sdl->min_load_group.group)
> +		sdl->min_load_group = *gl;
> +	else {
> +		if (gl->nr_running < sdl->min_load_group.nr_running)
> +			sdl->min_load_group = *gl;
> +		/* If the loads are equal, then prefer the cpu with
> +		 * less logical number
> +		 */
> +		else if (gl->nr_running == sdl->min_load_group.nr_running &&
> +			 first_cpu(gl->group->cpumask) <
> +			 first_cpu(sdl->min_load_group.group->cpumask))
> +			sdl->min_load_group = *gl;
> +	}
> +
> +	/*
> +	 * Calculate the group which is almost near its
> +	 * capacity but still has some space to pick up some load
> +	 * from other group and save more power
> +	 */
> +
> +	if (gl->nr_running > 0 && gl->nr_running <= group_capacity - 1) {
> +		if (!sdl->power_save_leader_group.group)
> +			sdl->power_save_leader_group = *gl;
> +		else {
> +			if (gl->nr_running >
> +			    sdl->power_save_leader_group.nr_running)
> +				sdl->power_save_leader_group = *gl;
> +			else if (gl->nr_running ==
> +				 sdl->power_save_leader_group.nr_running &&
> +				 first_cpu(gl->group->cpumask) <
> +				 first_cpu(sdl->min_load_group.group->cpumask))
> +				sdl->power_save_leader_group = *gl;
> +		}
> +	}
> +}
> +
> +static struct sched_group *powersavings_balance_group(struct sd_loads *sdl,
> +	struct group_loads *gl, enum cpu_idle_type idle,
> +	unsigned long *imbalance)
> +{
> +	*imbalance = 0;
> +	if (idle == CPU_NOT_IDLE || !(sdl->sd->flags & SD_POWERSAVINGS_BALANCE))
> +		return NULL;
> +
> +	if (sdl->local.group == sdl->power_save_leader_group.group &&
> +		sdl->power_save_leader_group.group !=
> +		sdl->min_load_group.group) {
> +		*imbalance = sdl->min_load_group.avg_load_per_task;
> +		return sdl->min_load_group.group;
> +	}
> +
> +	return NULL;
> +}
> +#else
> +void update_powersavings_group_loads(struct sd_loads *sdl,
> +			struct group_loads *gl, enum cpu_idle_type idle)
> +{
> +	return;
> +}
> +
> +static struct sched_group *powersavings_balance_group(struct sd_loads *sdl,
> +	struct group_loads *gl, enum cpu_idle_type idle,
> +	unsigned long *imbalance)
> +{
> +	*imbalance = 0;
> +	return NULL;
> +}
> +#endif
> +
>  /*
>   * find_busiest_group finds and returns the busiest CPU group within the
>   * domain. It calculates and returns the amount of weighted load which

-- 
Thanks and Regards
gautham
