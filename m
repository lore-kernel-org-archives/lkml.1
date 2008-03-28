Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYC1KIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYC1KIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYC1KId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:08:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:41774 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYC1KIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MqbrE+neMvXvDM/emm2sFDFXEdMriidCsUeckt86QL4WzzXIdnThQUyEpTAAnCtcqMQiBFpOq0Ofag2B6amGZ63RdDOnGCHf82aBFt0B+VB4PO/xhuhqLZ78PbS+V414xFrIu6ud0G4FqJ4Y1KQs2DLvyW4afsyRA3maJPFBGDY=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][-mm] [1/2] Simple stats for cpu resource controller
Date: Fri, 28 Mar 2008 15:32:37 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, menage@google.com, balbir@in.ibm.com,
       containers@lists.osdl.org, dhaval@linux.vnet.ibm.com
References: <200803262348.45219.balajirrao@gmail.com> <1206561490.24529.2.camel@lappy>
In-Reply-To: <1206561490.24529.2.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281532.37670.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008 01:28:10 am Peter Zijlstra wrote:
> On Wed, 2008-03-26 at 23:48 +0530, Balaji Rao wrote:
<snip>
> > +/* Called under irq disable. */
> > +static void __cpu_cgroup_stat_add_safe(struct cpu_cgroup_stat *stat,
> > +		enum cpu_cgroup_stat_index idx, int val)
> 
> What is safe about this function?
> 
That it can be called only from an interrupt context.
> > +{
> > +	int cpu = smp_processor_id();
> > +
> > +	BUG_ON(!irqs_disabled());
> > +	stat->cpustat[cpu].count[idx] += val;
> > +}
> > +#endif
> > +
> >  /* task group related information */
> >  struct task_group {
> >  #ifdef CONFIG_CGROUP_SCHED
> >  	struct cgroup_subsys_state css;
> > +	struct cpu_cgroup_stat stat;
> >  #endif
> >  
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> > @@ -3670,6 +3698,16 @@ void account_user_time(struct task_struct *p, cputime_t cputime)
> >  		cpustat->nice = cputime64_add(cpustat->nice, tmp);
> >  	else
> >  		cpustat->user = cputime64_add(cpustat->user, tmp);
> > +
> > +	/* Charge the task's group */
> > +#ifdef CONFIG_CGROUP_SCHED 
> > +	{
> > +	struct task_group *tg;
> > +	tg = task_group(p);
> > +	__cpu_cgroup_stat_add_safe(&tg->stat, CPU_CGROUP_STAT_UTIME,
> > +			cputime_to_msecs(cputime));
> > +	}
> > +#endif
> >  }
> >  
> >  /*
> > @@ -3733,6 +3771,15 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
> >  		cpustat->idle = cputime64_add(cpustat->idle, tmp);
> >  	/* Account for system time used */
> >  	acct_update_integrals(p);
> > +
> > +#ifdef CONFIG_CGROUP_SCHED
> > +	{
> > +	struct task_group *tg;
> > +	tg = task_group(p);
> > +	__cpu_cgroup_stat_add_safe(&tg->stat, CPU_CGROUP_STAT_STIME,
> > +			cputime_to_msecs(cputime));
> > +	}
> > +#endif
> >  }
> 
> So both of these are tick based? The normal CFS [us]time stats are not.
> 
Hmmm.. Yea, right. So I should use the approach used by task_utime and task_stime when reporting it, right ?
> >  /*
> > @@ -7939,6 +7986,40 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
> >  
> >  	return (u64) tg->shares;
> >  }
> > +

Thanks for the review.
-- 
regards,
balaji rao
