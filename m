Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYB2JEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYB2JEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYB2JER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:04:17 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48726 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYB2JEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:04:14 -0500
Date: Fri, 29 Feb 2008 14:34:00 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
       serue@us.ibm.com, menage@google.com
Subject: Re: [RFC, PATCH 1/2] sched: change the fairness model of the CFS
	group scheduler
Message-ID: <20080229090400.GD15328@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080225141504.GA27746@linux.vnet.ibm.com> <20080225141604.GA29213@linux.vnet.ibm.com> <1204227768.6243.42.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204227768.6243.42.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 08:42:48PM +0100, Peter Zijlstra wrote:
> 
> On Mon, 2008-02-25 at 19:46 +0530, Dhaval Giani wrote:
> > This patch allows tasks and groups to exist in the same cfs_rq. With this
> > change the CFS group scheduling follows a 1/(M+N) model from a 1/(1+N)
> > fairness model where M tasks and N groups exist at the cfs_rq level.
> 
> Good. You know I agree with this direction.
> 
> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > ---
> >  kernel/sched.c      |   46 +++++++++++++++++++++
> >  kernel/sched_fair.c |  113 +++++++++++++++++++++++++++++++++++++++++-----------
> >  2 files changed, 137 insertions(+), 22 deletions(-)
> > 
> > Index: linux-2.6.25-rc2/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.25-rc2.orig/kernel/sched.c
> > +++ linux-2.6.25-rc2/kernel/sched.c
> > @@ -224,10 +224,13 @@ struct task_group {
> >  };
> >  
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> > +
> > +#ifdef CONFIG_USER_SCHED
> >  /* Default task group's sched entity on each cpu */
> >  static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
> >  /* Default task group's cfs_rq on each cpu */
> >  static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
> > +#endif
> >  
> >  static struct sched_entity *init_sched_entity_p[NR_CPUS];
> >  static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
> > @@ -7163,6 +7166,10 @@ static void init_tg_cfs_entry(struct rq 
> >  		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
> >  
> >  	tg->se[cpu] = se;
> > +	/* se could be NULL for init_task_group */
> > +	if (!se)
> > +		return;
> > +
> >  	se->cfs_rq = &rq->cfs;
> >  	se->my_q = cfs_rq;
> >  	se->load.weight = tg->shares;
> > @@ -7217,11 +7224,46 @@ void __init sched_init(void)
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> >  		init_task_group.shares = init_task_group_load;
> >  		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
> > +#ifdef CONFIG_CGROUP_SCHED
> > +		/*
> > +		 * How much cpu bandwidth does init_task_group get?
> > +		 *
> > +		 * In case of task-groups formed thr' the cgroup filesystem, it
> > +		 * gets 100% of the cpu resources in the system. This overall
> > +		 * system cpu resource is divided among the tasks of
> > +		 * init_task_group and its child task-groups in a fair manner,
> > +		 * based on each entity's (task or task-group's) weight
> > +		 * (se->load.weight).
> > +		 *
> > +		 * In other words, if init_task_group has 10 tasks of weight
> > +		 * 1024) and two child groups A0 and A1 (of weight 1024 each),
> > +		 * then A0's share of the cpu resource is:
> > +		 *
> > +		 * 	A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
> > +		 *
> > +		 * We achieve this by letting init_task_group's tasks sit
> > +		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
> > +		 */
> > +		init_tg_cfs_entry(rq, &init_task_group, &rq->cfs, NULL, i, 1);
> > +		init_tg_rt_entry(rq, &init_task_group, &rq->rt, NULL, i, 1);
> 
> That seems to agree with that.
> 
> > +#elif defined CONFIG_USER_SCHED
> > +		/*
> > +		 * In case of task-groups formed thr' the user id of tasks,
> > +		 * init_task_group represents tasks belonging to root user.
> > +		 * Hence it forms a sibling of all subsequent groups formed.
> > +		 * In this case, init_task_group gets only a fraction of overall
> > +		 * system cpu resource, based on the weight assigned to root
> > +		 * user's cpu share (INIT_TASK_GROUP_LOAD). This is accomplished
> > +		 * by letting tasks of init_task_group sit in a separate cfs_rq
> > +		 * (init_cfs_rq) and having one entity represent this group of
> > +		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
> > +		 */
> >  		init_tg_cfs_entry(rq, &init_task_group,
> >  				&per_cpu(init_cfs_rq, i),
> >  				&per_cpu(init_sched_entity, i), i, 1);
> 
> But I fail to parse this lengthy comment. What does it do:
> 
>     init_group
>    /     |    \
> uid-0 uid-1000 uid-n
> 
> or does it blend uid-0 into the init_group?
> 

It blends uid-0 (root) into init_group.

<snip>

> > @@ -1100,6 +1127,27 @@ static void check_preempt_wakeup(struct 
> >  	if (!sched_feat(WAKEUP_PREEMPT))
> >  		return;
> >  
> > +	/*
> > +	 * preemption test can be made between sibling entities who are in the
> > +	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
> > +	 * both tasks untill we find their ancestors who are siblings of common
> > +	 * parent.
> > +	 */
> > +
> > +	/* First walk up until both entities are at same depth */
> > +	se_depth = depth_se(se);
> > +	pse_depth = depth_se(pse);
> > +
> > +	while (se_depth > pse_depth) {
> > +		se_depth--;
> > +		se = parent_entity(se);
> > +	}
> > +
> > +	while (pse_depth > se_depth) {
> > +		pse_depth--;
> > +		pse = parent_entity(pse);
> > +	}
> 
> Sad, but needed.. for now..
> 

better ideas if any are welcome! Cannot think of anything right now :(

-- 
regards,
Dhaval
