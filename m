Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYC1KRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYC1KRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYC1KR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:17:28 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:38040 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYC1KR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:17:27 -0400
Subject: Re: [RFC][-mm] [1/2] Simple stats for cpu resource controller
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-kernel@vger.kernel.org, menage@google.com, balbir@in.ibm.com,
       containers@lists.osdl.org, dhaval@linux.vnet.ibm.com
In-Reply-To: <200803281532.37670.balajirrao@gmail.com>
References: <200803262348.45219.balajirrao@gmail.com>
	 <1206561490.24529.2.camel@lappy>  <200803281532.37670.balajirrao@gmail.com>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 11:17:16 +0100
Message-Id: <1206699436.8514.617.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 15:32 +0530, Balaji Rao wrote:
> On Thursday 27 March 2008 01:28:10 am Peter Zijlstra wrote:
> > On Wed, 2008-03-26 at 23:48 +0530, Balaji Rao wrote:
> <snip>
> > > +/* Called under irq disable. */
> > > +static void __cpu_cgroup_stat_add_safe(struct cpu_cgroup_stat *stat,
> > > +		enum cpu_cgroup_stat_index idx, int val)
> > 
> > What is safe about this function?
> > 
> That it can be called only from an interrupt context.

It can be called from any context that has hardirqs disabled. And the __
prefix suggests as much, no need to tag _safe to the end as well, we
never do that.

> > > +{
> > > +	int cpu = smp_processor_id();
> > > +
> > > +	BUG_ON(!irqs_disabled());
> > > +	stat->cpustat[cpu].count[idx] += val;
> > > +}
> > > +#endif
> > > +
> > >  /* task group related information */
> > >  struct task_group {
> > >  #ifdef CONFIG_CGROUP_SCHED
> > >  	struct cgroup_subsys_state css;
> > > +	struct cpu_cgroup_stat stat;
> > >  #endif
> > >  
> > >  #ifdef CONFIG_FAIR_GROUP_SCHED
> > > @@ -3670,6 +3698,16 @@ void account_user_time(struct task_struct *p, cputime_t cputime)
> > >  		cpustat->nice = cputime64_add(cpustat->nice, tmp);
> > >  	else
> > >  		cpustat->user = cputime64_add(cpustat->user, tmp);
> > > +
> > > +	/* Charge the task's group */
> > > +#ifdef CONFIG_CGROUP_SCHED 
> > > +	{
> > > +	struct task_group *tg;
> > > +	tg = task_group(p);
> > > +	__cpu_cgroup_stat_add_safe(&tg->stat, CPU_CGROUP_STAT_UTIME,
> > > +			cputime_to_msecs(cputime));
> > > +	}
> > > +#endif
> > >  }
> > >  
> > >  /*
> > > @@ -3733,6 +3771,15 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
> > >  		cpustat->idle = cputime64_add(cpustat->idle, tmp);
> > >  	/* Account for system time used */
> > >  	acct_update_integrals(p);
> > > +
> > > +#ifdef CONFIG_CGROUP_SCHED
> > > +	{
> > > +	struct task_group *tg;
> > > +	tg = task_group(p);
> > > +	__cpu_cgroup_stat_add_safe(&tg->stat, CPU_CGROUP_STAT_STIME,
> > > +			cputime_to_msecs(cputime));
> > > +	}
> > > +#endif
> > >  }
> > 
> > So both of these are tick based? The normal CFS [us]time stats are not.
> > 
> Hmmm.. Yea, right. So I should use the approach used by task_utime and task_stime when reporting it, right ?

Not sure what you want to use this for, but yeah, that makes most sense.

That is, I do know _what_ you want to use it for, just not sure which
requirements you put on it. The pure tick based thing might be good
enough for most purposes, the runtime proportion thing is just more
accurate.

> > >  /*
> > > @@ -7939,6 +7986,40 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
> > >  
> > >  	return (u64) tg->shares;
> > >  }
> > > +
> 
> Thanks for the review.

