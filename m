Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751826AbYLQSq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbYLQSq3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYLQSqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:46:16 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:35943 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYLQSqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:46:14 -0500
Date: Wed, 17 Dec 2008 23:40:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH v6 1/7] sched: Framework for
	sched_mc/smt_power_savings=N
Message-ID: <20081217181033.GC26572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>,
	Pavel Machek <pavel@suse.cz>
References: <20081217172309.534.28847.stgit@drishya.in.ibm.com> <20081217172635.534.50541.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081217172635.534.50541.stgit@drishya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-17 22:56:35]:

> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> Currently the sched_mc/smt_power_savings variable is a boolean,
> which either enables or disables topology based power savings.
> This patch extends the behaviour of the variable from boolean to
> multivalued, such that based on the value, we decide how
> aggressively do we want to perform powersavings balance at
> appropriate sched domain based on topology.
> 
> Variable levels of power saving tunable would benefit end user to
> match the required level of power savings vs performance
> trade-off depending on the system configuration and workloads.
> 
> This version makes the sched_mc_power_savings global variable to
> take more values (0,1,2).  Later versions can have a single
> tunable called sched_power_savings instead of
> sched_{mc,smt}_power_savings.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> ---
> 
>  include/linux/sched.h |   11 +++++++++++
>  kernel/sched.c        |   17 ++++++++++++++---
>  2 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 55e30d1..888f2b2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -764,6 +764,17 @@ enum cpu_idle_type {
>  #define SD_SERIALIZE		1024	/* Only a single load balancing instance */
>  #define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
> 
> +enum powersavings_balance_level {
> +	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
> +	POWERSAVINGS_BALANCE_BASIC,	/* Fill one thread/core/package
> +					 * first for long running threads
> +					 */
> +	POWERSAVINGS_BALANCE_WAKEUP,	/* Also bias task wakeups to semi-idle
> +					 * cpu package for power savings
> +					 */
> +	MAX_POWERSAVINGS_BALANCE_LEVELS
> +};
> +
>  #define BALANCE_FOR_MC_POWER	\
>  	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e4bb1dd..16897ab 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7879,14 +7879,25 @@ int arch_reinit_sched_domains(void)
>  static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
>  {
>  	int ret;
> +	unsigned int level = 0;
> 
> -	if (buf[0] != '0' && buf[0] != '1')
> +	if (sscanf(buf, "%u", &level) != 1)
> +		return -EINVAL;
> +
> +	/*
> +	 * level is always be positive so don't check for
> +	 * level < POWERSAVINGS_BALANCE_NONE which is 0
> +	 * What happens on 0 or 1 byte write,
> +	 * need to check for count as well?
> +	 */
> +
> +	if (level >= MAX_POWERSAVINGS_BALANCE_LEVELS)
>  		return -EINVAL;
> 
>  	if (smt)
> -		sched_smt_power_savings = (buf[0] == '1');
> +		sched_smt_power_savings = level;
>  	else
> -		sched_mc_power_savings = (buf[0] == '1');
> +		sched_mc_power_savings = level;
> 
>  	ret = arch_reinit_sched_domains();
>

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 

-- 
	Balbir
