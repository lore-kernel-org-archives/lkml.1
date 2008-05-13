Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbYEMDb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbYEMDb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbYEMDau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:30:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:49565 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758820AbYEMDat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Qu8Dz+Hcl1SFnhRBwRhZqXRTgDSh+KOl3+9ztkeh9daseIV1gm8HBdfzBYGsYl4gsGkOU1nfAtnM6lV0rwAjy9R83l8EQ+qdaIWQQHgxl2JSsNQc5Hi4NcSDKyG8JwzODwK4W/dYLuTobxeMcKTnOpLA2W2bx3GBrdQUlIxyJWY=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][-mm] Simple stats for cpu resource controller v4
Date: Tue, 13 May 2008 09:00:27 +0530
User-Agent: KMail/1.9.9
Cc: dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, menage@google.com, balbir@in.ibm.com,
       vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, dada1@cosmosbay.com
References: <200804052339.46632.balajirrao@gmail.com> <200805120148.37856.balajirrao@gmail.com> <20080512164833.8354abeb.akpm@linux-foundation.org>
In-Reply-To: <20080512164833.8354abeb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805130900.27492.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2008 05:18:33 am Andrew Morton wrote:
> On Mon, 12 May 2008 01:48:37 +0530
>
> Balaji Rao <balajirrao@gmail.com> wrote:
> > Hi Andrew,
> >
> > Here's a version that uses percpu_counters and which actually works. The
> > only evil it contains is the check,
> >
> > 	if (percpu_counter_ready) {
> > 		..
> > 	}
>
> There's no instance of "percpu_counter_ready" in the patch so I'm a bit
> stumped.
>
Here it is. 'stat' can tell us if percpu_counters are ready or not.

+static void __cpu_cgroup_stat_add(struct cpu_cgroup_stat *stat,
+               enum cpu_cgroup_stat_index idx, int val)
+{
+       if (stat)
+               percpu_counter_add(&stat->cpustat[idx], val);
+}
+#endif

It's here as well.

+static s64 cpu_cgroup_read_stat(struct cpu_cgroup_stat *stat,
+               enum cpu_cgroup_stat_index idx)
+{
+       if (stat)
+               return percpu_counter_read(&stat->cpustat[idx]);
+
+       return 0;
+}
+
> > @@ -3837,6 +3858,16 @@ void account_user_time(struct task_struct *p,
> > cputime_t cputime) cpustat->nice = cputime64_add(cpustat->nice, tmp);
> >  	else
> >  		cpustat->user = cputime64_add(cpustat->user, tmp);
> > +
> > +       /* Charge the task's group */
> > +#ifdef CONFIG_CGROUP_SCHED
> > +	{
> > +		struct task_group *tg;
> > +		tg = task_group(p);
> > +		__cpu_cgroup_stat_add(tg->stat, CPU_CGROUP_STAT_UTIME,
> > +				cputime_to_msecs(cputime));
> > +	}
> > +#endif
> >  }
> >
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
> > +#endif
>
> I'd suggest that the above be turned into calls to a helper function
> which is a no-op if !CONFIG_CGROUP_SCHED.

OK. Will do.

-- 
Warm Regards,

Balaji Rao
Dept. of Mechanical Engineering
NITK
