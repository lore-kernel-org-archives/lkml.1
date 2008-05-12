Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYELFl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYELFl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 01:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYELFlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 01:41:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:27503 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYELFlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 01:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Z5l0IH4a5BRyNK858P1oTM678wDAEWCXNlg39QPYY0sUKfdFpWQDmE+bxPnrp7MaXAQxh2nwga0eOsVy1oryFIoAuDjXv49AV2V6bKkHHkwV5hLd5IOARfELXspmfvP7GTn+l9kL3JXZ0Q5I2T6aODUccen5whsU4/FADq7TsO8=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][-mm] Simple stats for cpu resource controller v4
Date: Mon, 12 May 2008 11:11:24 +0530
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, dhaval@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       menage@google.com, balbir@in.ibm.com, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, Eric Dumazet <dada1@cosmosbay.com>
References: <200804052339.46632.balajirrao@gmail.com> <200805120148.37856.balajirrao@gmail.com> <4827B175.1030802@cn.fujitsu.com>
In-Reply-To: <4827B175.1030802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805121111.25211.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2008 08:24:45 am Li Zefan wrote:
> Balaji Rao wrote:
> >  /*
> > @@ -3892,8 +3923,17 @@ void account_system_time(struct task_struct *p,
> > int hardirq_offset, cpustat->irq = cputime64_add(cpustat->irq, tmp);
> >  	else if (softirq_count())
> >  		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
> > -	else if (p != rq->idle)
> > +	else if (p != rq->idle) {
> >  		cpustat->system = cputime64_add(cpustat->system, tmp);
> > +#ifdef CONFIG_CGROUP_SCHED
> > +		{
> > +			struct task_group *tg;
> > +			tg = task_group(p);
> > +			__cpu_cgroup_stat_add(tg->stat, CPU_CGROUP_STAT_STIME,
> > +					cputime_to_msecs(cputime));
> > +		}
> > +	}
>
> You should put this '}' after '#endif'
>
Yes, my mistake. Will fix it.
> > +#endif
> >  	else if (atomic_read(&rq->nr_iowait) > 0)
> >  		cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
> >  	else
> > @@ -8179,10 +8219,26 @@ static inline struct task_group *cgroup_tg(struct
> > cgroup *cgrp) struct task_group, css);
> >  }
> >
> > +static void cpu_cgroup_initialize(int early)
> > +{
> > +	int i;
> > +	struct cpu_cgroup_stat *stat;
> > +
> > +	if (!early) {
> > +		stat = kmalloc(sizeof(struct cpu_cgroup_stat)
> > +				, GFP_KERNEL);
> > +		for (i = 0; i < CPU_CGROUP_STAT_NSTATS; i++)
> > +			percpu_counter_init(
> > +					&stat->cpustat[i], 0);
> > +		init_task_group.stat = stat;
> > +	}
> > +}
> > +
> >  static struct cgroup_subsys_state *
> >  cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
> >  {
> >  	struct task_group *tg;
> > +	int i;
> >
> >  	if (!cgrp->parent) {
> >  		/* This is early initialization for the top cgroup */
> > @@ -8198,6 +8254,10 @@ cpu_cgroup_create(struct cgroup_subsys *ss, struct
> > cgroup *cgrp) if (IS_ERR(tg))
> >  		return ERR_PTR(-ENOMEM);
> >
> > +	tg->stat = kmalloc(sizeof(struct cpu_cgroup_stat), GFP_KERNEL);
> > +	for (i = 0; i < CPU_CGROUP_STAT_NSTATS; i++)
> > +		percpu_counter_init(&tg->stat->cpustat[i], 0);
> > +
>
> I guess you forgot to free those things in cpu_cgroup_destroy().
Oh. Sorry, I totally missed it.
>
> >  	/* Bind the cgroup to task_group object we just created */

-- 
Warm Regards,

Balaji Rao
Dept. of Mechanical Engineering
NITK
