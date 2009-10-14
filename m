Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZJNDuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZJNDuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZJNDug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:50:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45074 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZJNDug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:50:36 -0400
Date: Wed, 14 Oct 2009 09:19:48 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 3/8] sched: Bandwidth initialization for fair
	task groups
Message-ID: <20091014034948.GC3568@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com> <20090930125204.GD19951@in.ibm.com> <1255444021.8392.363.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255444021.8392.363.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:27:01PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-09-30 at 18:22 +0530, Bharata B Rao wrote:
> 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index c283d0f..0147f6f 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -262,6 +262,15 @@ static DEFINE_MUTEX(sched_domains_mutex);
> >  
> >  #include <linux/cgroup.h>
> >  
> > +#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_CFS_HARD_LIMITS)
> > +struct cfs_bandwidth {
> > +	spinlock_t		cfs_runtime_lock;
> > +	ktime_t			cfs_period;
> > +	u64			cfs_runtime;
> > +	struct hrtimer		cfs_period_timer;
> > +};
> > +#endif
> 
> too much cfs here..

Right, this will eventually be merged with rt_bandwidth. Dhaval already has
patches for bandwidth code unification b/n cfs and rt. As I said, the initial
focus is to show how the hard limit code looks like.

> 
> >  struct cfs_rq;
> >  
> >  static LIST_HEAD(task_groups);
> > @@ -282,6 +291,11 @@ struct task_group {
> >  	/* runqueue "owned" by this group on each cpu */
> >  	struct cfs_rq **cfs_rq;
> >  	unsigned long shares;
> > +#ifdef CONFIG_CFS_HARD_LIMITS
> > +	struct cfs_bandwidth cfs_bandwidth;
> > +	/* If set, throttle when the group exceeds its bandwidth */
> > +	int hard_limit_enabled;
> > +#endif
> 
> What's wrong with doing something like cfs_bandwidth.cfs_runtime ==
> RUNTIME_INF ?

Can be done.

> 
> >  #endif
> >  
> >  #ifdef CONFIG_RT_GROUP_SCHED
> > @@ -477,6 +491,16 @@ struct cfs_rq {
> >  	unsigned long rq_weight;
> >  #endif
> >  #endif
> > +#ifdef CONFIG_CFS_HARD_LIMITS
> > +	/* set when the group is throttled  on this cpu */
> > +	int cfs_throttled;
> > +
> > +	/* runtime currently consumed by the group on this rq */
> > +	u64 cfs_time;
> > +
> > +	/* runtime available to the group on this rq */
> > +	u64 cfs_runtime;
> > +#endif
> 
> too much cfs_ again.

But this is needed. It is present in rt also.

> 
> >  	/*
> >  	 * Number of tasks at this heirarchy.
> >  	 */
> > @@ -665,6 +689,11 @@ struct rq {
> >  	/* BKL stats */
> >  	unsigned int bkl_count;
> >  #endif
> > +	/*
> > +	 * Protects the cfs runtime related fields of all cfs_rqs under
> > +	 * this rq
> > +	 */
> > +	spinlock_t runtime_lock;
> >  };
> >  
> >  static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
> 
> 
> > +static inline void rq_runtime_lock(struct rq *rq)
> > +{
> > +	spin_lock(&rq->runtime_lock);
> > +}
> > +
> > +static inline void rq_runtime_unlock(struct rq *rq)
> > +{
> > +	spin_unlock(&rq->runtime_lock);
> > +}
> 
> needless obfuscation.

This is needed to keep the code clean for !CFS_HARD_LIMITS case.

> 
> > CONFIG_RT_GROUP_SCHED
> > @@ -10317,6 +10617,23 @@ static struct cftype cpu_files[] = {
> >  		.read_u64 = cpu_shares_read_u64,
> >  		.write_u64 = cpu_shares_write_u64,
> >  	},
> > +#ifdef CONFIG_CFS_HARD_LIMITS
> > +	{
> > +		.name = "cfs_runtime_us",
> > +		.read_s64 = cpu_cfs_runtime_read_s64,
> > +		.write_s64 = cpu_cfs_runtime_write_s64,
> > +	},
> > +	{
> > +		.name = "cfs_period_us",
> > +		.read_u64 = cpu_cfs_period_read_u64,
> > +		.write_u64 = cpu_cfs_period_write_u64,
> > +	},
> > +	{
> > +		.name = "cfs_hard_limit",
> > +		.read_u64 = cpu_cfs_hard_limit_read_u64,
> > +		.write_u64 = cpu_cfs_hard_limit_write_u64,
> > +	},
> > +#endif /* CONFIG_CFS_HARD_LIMITS */
> >  #endif
> >  #ifdef CONFIG_RT_GROUP_SCHED
> >  	{
> 
> I guess that cfs_hard_limit thing is superfluous as well.

Ok, will try to remove this control and will treat the case when
runtime != RUNTIME_INF as hard limits enabled case.

Regards,
Bharata.
