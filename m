Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbZE1Dkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbZE1Dkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZE1Dk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:40:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39758 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbZE1Dk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:40:27 -0400
Date: Thu, 28 May 2009 13:40:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: linux-next: manual merge of the timers tree with the sched tree
Message-Id: <20090528134018.2aebb49f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the timers tree got a conflict in
kernel/sched.c between commit f711f6090a81cbd396b63de90f415d33f563af9b
("sched: Nominate idle load balancer from a semi-idle package") from the
sched tree and commit eea08f32adb3f97553d49a4f79a119833036000a ("timers:
Logic to move non pinned timers") from the timers tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched.c
index 39a24b0,ff23723..0000000
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@@ -4296,121 -4244,11 +4296,126 @@@ static struct 
  	.load_balancer = ATOMIC_INIT(-1),
  };
  
 +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 +/**
 + * lowest_flag_domain - Return lowest sched_domain containing flag.
 + * @cpu:	The cpu whose lowest level of sched domain is to
 + *		be returned.
 + * @flag:	The flag to check for the lowest sched_domain
 + *		for the given cpu.
 + *
 + * Returns the lowest sched_domain of a cpu which contains the given flag.
 + */
 +static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 +{
 +	struct sched_domain *sd;
 +
 +	for_each_domain(cpu, sd)
 +		if (sd && (sd->flags & flag))
 +			break;
 +
 +	return sd;
 +}
 +
 +/**
 + * for_each_flag_domain - Iterates over sched_domains containing the flag.
 + * @cpu:	The cpu whose domains we're iterating over.
 + * @sd:		variable holding the value of the power_savings_sd
 + *		for cpu.
 + * @flag:	The flag to filter the sched_domains to be iterated.
 + *
 + * Iterates over all the scheduler domains for a given cpu that has the 'flag'
 + * set, starting from the lowest sched_domain to the highest.
 + */
 +#define for_each_flag_domain(cpu, sd, flag) \
 +	for (sd = lowest_flag_domain(cpu, flag); \
 +		(sd && (sd->flags & flag)); sd = sd->parent)
 +
 +/**
 + * is_semi_idle_group - Checks if the given sched_group is semi-idle.
 + * @ilb_group:	group to be checked for semi-idleness
 + *
 + * Returns:	1 if the group is semi-idle. 0 otherwise.
 + *
 + * We define a sched_group to be semi idle if it has atleast one idle-CPU
 + * and atleast one non-idle CPU. This helper function checks if the given
 + * sched_group is semi-idle or not.
 + */
 +static inline int is_semi_idle_group(struct sched_group *ilb_group)
 +{
 +	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
 +					sched_group_cpus(ilb_group));
 +
 +	/*
 +	 * A sched_group is semi-idle when it has atleast one busy cpu
 +	 * and atleast one idle cpu.
 +	 */
 +	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
 +		return 0;
 +
 +	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
 +		return 0;
 +
 +	return 1;
 +}
 +/**
 + * find_new_ilb - Finds the optimum idle load balancer for nomination.
 + * @cpu:	The cpu which is nominating a new idle_load_balancer.
 + *
 + * Returns:	Returns the id of the idle load balancer if it exists,
 + *		Else, returns >= nr_cpu_ids.
 + *
 + * This algorithm picks the idle load balancer such that it belongs to a
 + * semi-idle powersavings sched_domain. The idea is to try and avoid
 + * completely idle packages/cores just for the purpose of idle load balancing
 + * when there are other idle cpu's which are better suited for that job.
 + */
 +static int find_new_ilb(int cpu)
 +{
 +	struct sched_domain *sd;
 +	struct sched_group *ilb_group;
 +
 +	/*
 +	 * Have idle load balancer selection from semi-idle packages only
 +	 * when power-aware load balancing is enabled
 +	 */
 +	if (!(sched_smt_power_savings || sched_mc_power_savings))
 +		goto out_done;
 +
 +	/*
 +	 * Optimize for the case when we have no idle CPUs or only one
 +	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
 +	 */
 +	if (cpumask_weight(nohz.cpu_mask) < 2)
 +		goto out_done;
 +
 +	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
 +		ilb_group = sd->groups;
 +
 +		do {
 +			if (is_semi_idle_group(ilb_group))
 +				return cpumask_first(nohz.ilb_grp_nohz_mask);
 +
 +			ilb_group = ilb_group->next;
 +
 +		} while (ilb_group != sd->groups);
 +	}
 +
 +out_done:
 +	return cpumask_first(nohz.cpu_mask);
 +}
 +#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 +static inline int find_new_ilb(int call_cpu)
 +{
 +	return cpumask_first(nohz.cpu_mask);
 +}
 +#endif
 +
+ int get_nohz_load_balancer(void)
+ {
+ 	return atomic_read(&nohz.load_balancer);
+ }
+ 
  /*
   * This routine will try to nominate the ilb (idle load balancing)
   * owner among the cpus whose ticks are stopped. ilb owner will do the idle
