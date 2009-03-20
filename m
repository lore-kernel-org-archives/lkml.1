Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZCTEfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZCTEfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 00:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbZCTEe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 00:34:59 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:49523 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZCTEe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 00:34:58 -0400
Date: Fri, 20 Mar 2009 10:04:37 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 3 2/6] sched: Record the current active power savings
	level
Message-ID: <20090320043437.GA6603@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090318092054.24787.18730.stgit@sofia.in.ibm.com> <20090318092227.24787.22917.stgit@sofia.in.ibm.com> <20090319163205.GK2990@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319163205.GK2990@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:02:05PM +0530, Vaidyanathan Srinivasan wrote:
> * Gautham R Shenoy <ego@in.ibm.com> [2009-03-18 14:52:28]:
> 
> > The current active power savings level of a system is defined as the
> > maximum of the sched_mc_power_savings and the sched_smt_power_savings.
> > 
> > The decisions during power-aware loadbalancing, depend on this value.
> > 
> > Record this value in a read mostly global variable instead of having to
> > compute it everytime.
> > 
> > Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> > 
> >  include/linux/sched.h |    1 +
> >  kernel/sched.c        |    8 ++++++--
> >  kernel/sched_fair.c   |    2 +-
> >  3 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 37fecf7..7dc8aea 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -793,6 +793,7 @@ enum powersavings_balance_level {
> >  };
> > 
> >  extern int sched_mc_power_savings, sched_smt_power_savings;
> 
> Now we will need sched_mc_power_savings and sched_smt_power_savings
> only until we rebuild the sched domains.  These can be static
> variables and we can perhaps remove the extern for them? Better still
> if we can capture this information elsewhere until sched domain is
> built and SD_POWERSAVINGS_BALANCE flags are set so as to not
> have a need for these global variables.

Right now we need these variables outside sched.c only
while rebuilding the sched_domains, as you rightly pointed out. So, yes
these variables should be _read_only outside sched.c, but they are
required nevertheless.

However, like we had discussed in one of the earlier posts,
when we can have a single tunable that can capture in
essence what these two variables seek to achieve, we can get rid of
these variables. Till then I think we'll have to retain them.

> 
> > +extern enum powersavings_balance_level active_power_savings_level;
> >  enum sched_domain_level {
> >  	SD_LV_NONE = 0,
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 8e2558c..407ee03 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -3398,7 +3398,7 @@ out_balanced:
> > 
> >  	if (this == group_leader && group_leader != group_min) {
> >  		*imbalance = min_load_per_task;
> > -		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
> > +		if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
> >  			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
> >  				cpumask_first(sched_group_cpus(group_leader));
> >  		}
> > @@ -3683,7 +3683,7 @@ redo:
> >  		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
> >  			return -1;
> > 
> > -		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
> > +		if (active_power_savings_level < POWERSAVINGS_BALANCE_WAKEUP)
> >  			return -1;
> > 
> >  		if (sd->nr_balance_failed++ < 2)
> > @@ -7206,6 +7206,8 @@ static void sched_domain_node_span(int node, struct cpumask *span)
> >  #endif /* CONFIG_NUMA */
> > 
> >  int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
> > +/* Records the currently active power savings level */
> > +enum powersavings_balance_level __read_mostly active_power_savings_level;
> > 
> >  /*
> >   * The cpus mask in sched_group and sched_domain hangs off the end.
> > @@ -8040,6 +8042,8 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
> >  		sched_smt_power_savings = level;
> >  	else
> >  		sched_mc_power_savings = level;
> > +	active_power_savings_level = max(sched_smt_power_savings,
> > +						sched_mc_power_savings);
> > 
> >  	arch_reinit_sched_domains();
> > 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 0566f2a..a3583c6 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1054,7 +1054,7 @@ static int wake_idle(int cpu, struct task_struct *p)
> >  	chosen_wakeup_cpu =
> >  		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
> > 
> > -	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
> > +	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP &&
> >  		idle_cpu(cpu) && idle_cpu(this_cpu) &&
> >  		p->mm && !(p->flags & PF_KTHREAD) &&
> >  		cpu_isset(chosen_wakeup_cpu, p->cpus_allowed))
> > 
> 
> 
> Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

-- 
Thanks and Regards
gautham
