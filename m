Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYB2KjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYB2KjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 05:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbYB2Ki7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 05:38:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47106 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbYB2Ki6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:38:58 -0500
Subject: Re: [RFC, PATCH 1/2] sched: change the fairness model of the CFS
	group scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
       serue@us.ibm.com, menage@google.com
In-Reply-To: <20080229090400.GD15328@linux.vnet.ibm.com>
References: <20080225141504.GA27746@linux.vnet.ibm.com>
	 <20080225141604.GA29213@linux.vnet.ibm.com>
	 <1204227768.6243.42.camel@lappy>
	 <20080229090400.GD15328@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 11:37:55 +0100
Message-Id: <1204281475.6243.73.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 14:34 +0530, Dhaval Giani wrote:

> > > +#elif defined CONFIG_USER_SCHED
> > > +		/*
> > > +		 * In case of task-groups formed thr' the user id of tasks,
> > > +		 * init_task_group represents tasks belonging to root user.
> > > +		 * Hence it forms a sibling of all subsequent groups formed.
> > > +		 * In this case, init_task_group gets only a fraction of overall
> > > +		 * system cpu resource, based on the weight assigned to root
> > > +		 * user's cpu share (INIT_TASK_GROUP_LOAD). This is accomplished
> > > +		 * by letting tasks of init_task_group sit in a separate cfs_rq
> > > +		 * (init_cfs_rq) and having one entity represent this group of
> > > +		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
> > > +		 */
> > >  		init_tg_cfs_entry(rq, &init_task_group,
> > >  				&per_cpu(init_cfs_rq, i),
> > >  				&per_cpu(init_sched_entity, i), i, 1);
> > 
> > But I fail to parse this lengthy comment. What does it do:
> > 
> >     init_group
> >    /     |    \
> > uid-0 uid-1000 uid-n
> > 
> > or does it blend uid-0 into the init_group?
> > 
> 
> It blends uid-0 (root) into init_group.

Any particular reason why? It seems to me uid-0 should be treated like
any other uid.

> > > @@ -1100,6 +1127,27 @@ static void check_preempt_wakeup(struct 
> > >  	if (!sched_feat(WAKEUP_PREEMPT))
> > >  		return;
> > >  
> > > +	/*
> > > +	 * preemption test can be made between sibling entities who are in the
> > > +	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
> > > +	 * both tasks untill we find their ancestors who are siblings of common
> > > +	 * parent.
> > > +	 */
> > > +
> > > +	/* First walk up until both entities are at same depth */
> > > +	se_depth = depth_se(se);
> > > +	pse_depth = depth_se(pse);
> > > +
> > > +	while (se_depth > pse_depth) {
> > > +		se_depth--;
> > > +		se = parent_entity(se);
> > > +	}
> > > +
> > > +	while (pse_depth > se_depth) {
> > > +		pse_depth--;
> > > +		pse = parent_entity(pse);
> > > +	}
> > 
> > Sad, but needed.. for now..
> > 
> 
> better ideas if any are welcome! Cannot think of anything right now :(

Single rq can do without :-) If only I could get that latency isolation
going...

