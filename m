Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYB2F5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYB2F5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 00:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYB2F5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 00:57:38 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:39741 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYB2F5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 00:57:37 -0500
Date: Fri, 29 Feb 2008 11:27:30 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
       serue@us.ibm.com, menage@google.com
Subject: Re: [RFC, PATCH 1/2] sched: allow the CFS group scheduler to have
	multiple levels
Message-ID: <20080229055730.GA5478@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080225141504.GA27746@linux.vnet.ibm.com> <20080225141703.GB29213@linux.vnet.ibm.com> <1204227766.6243.41.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204227766.6243.41.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 08:42:46PM +0100, Peter Zijlstra wrote:
> 
> On Mon, 2008-02-25 at 19:47 +0530, Dhaval Giani wrote:
> > This patch makes the group scheduler multi hierarchy aware.
> 
> Ok, good thing to do in principle
> 

thanks!

> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 
> > ---
> >  include/linux/sched.h |    2 +-
> >  kernel/sched.c        |   41 ++++++++++++++++++++++++-----------------
> >  2 files changed, 25 insertions(+), 18 deletions(-)
> > 
> > Index: linux-2.6.25-rc2/include/linux/sched.h
> > ===================================================================
> > --- linux-2.6.25-rc2.orig/include/linux/sched.h
> > +++ linux-2.6.25-rc2/include/linux/sched.h
> > @@ -2031,7 +2031,7 @@ extern void normalize_rt_tasks(void);
> >  
> >  extern struct task_group init_task_group;
> >  
> > -extern struct task_group *sched_create_group(void);
> > +extern struct task_group *sched_create_group(struct task_group *parent);
> >  extern void sched_destroy_group(struct task_group *tg);
> >  extern void sched_move_task(struct task_struct *tsk);
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> > Index: linux-2.6.25-rc2/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.25-rc2.orig/kernel/sched.c
> > +++ linux-2.6.25-rc2/kernel/sched.c
> > @@ -7155,10 +7155,11 @@ static void init_rt_rq(struct rt_rq *rt_
> >  }
> >  
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> > -static void init_tg_cfs_entry(struct rq *rq, struct task_group *tg,
> > -		struct cfs_rq *cfs_rq, struct sched_entity *se,
> > -		int cpu, int add)
> > +static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
> > +				struct sched_entity *se, int cpu, int add,
> > +				struct sched_entity *parent)
> >  {
> > +	struct rq *rq = cpu_rq(cpu);
> >  	tg->cfs_rq[cpu] = cfs_rq;
> >  	init_cfs_rq(cfs_rq, rq);
> >  	cfs_rq->tg = tg;
> > @@ -7170,7 +7171,11 @@ static void init_tg_cfs_entry(struct rq 
> >  	if (!se)
> >  		return;
> >  
> > -	se->cfs_rq = &rq->cfs;
> > +	if (parent == NULL)
> 
> !parent ?
> 

Will do. (need to start remembering to doing this one!)

> > +		se->cfs_rq = &rq->cfs;
> > +	else
> > +		se->cfs_rq = parent->my_q;
> > +
> >  	se->my_q = cfs_rq;
> >  	se->load.weight = tg->shares;
> >  	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
> > @@ -7244,7 +7249,8 @@ void __init sched_init(void)
> >  		 * We achieve this by letting init_task_group's tasks sit
> >  		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
> >  		 */
> > -		init_tg_cfs_entry(rq, &init_task_group, &rq->cfs, NULL, i, 1);
> > +		init_tg_cfs_entry(&init_task_group, &rq->cfs,
> > +							NULL, i, 1, NULL);
> >  		init_tg_rt_entry(rq, &init_task_group, &rq->rt, NULL, i, 1);
> >  #elif defined CONFIG_USER_SCHED
> >  		/*
> > @@ -7260,7 +7266,7 @@ void __init sched_init(void)
> >  		 */
> >  		init_tg_cfs_entry(rq, &init_task_group,
> >  				&per_cpu(init_cfs_rq, i),
> > -				&per_cpu(init_sched_entity, i), i, 1);
> > +				&per_cpu(init_sched_entity, i), i, 1, NULL);
> >  
> >  #endif
> >  #endif /* CONFIG_FAIR_GROUP_SCHED */
> > @@ -7630,7 +7636,8 @@ static void free_fair_sched_group(struct
> >  	kfree(tg->se);
> >  }
> >  
> > -static int alloc_fair_sched_group(struct task_group *tg)
> > +static int alloc_fair_sched_group(struct task_group *tg,
> > +					struct task_group *parent)
> >  {
> >  	struct cfs_rq *cfs_rq;
> >  	struct sched_entity *se;
> > @@ -7658,8 +7665,11 @@ static int alloc_fair_sched_group(struct
> >  				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
> >  		if (!se)
> >  			goto err;
> > -
> > -		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
> > +		if (!parent) {
> > +			init_tg_cfs_entry(tg, cfs_rq, se, i, 0,	parent->se[i]);
> > +		} else {
> > +			init_tg_cfs_entry(tg, cfs_rq, se, i, 0, NULL);
> > +		}
> 
> Looks like you got the cases switched, this looks like an instant NULL
> deref.
> 

eeeks! Yeah, you are right. Funny though how I did not hit it while
testing.
 

-- 
regards,
Dhaval
