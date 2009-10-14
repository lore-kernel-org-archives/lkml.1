Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbZJNDmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbZJNDmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbZJNDmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:42:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34907 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbZJNDmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:42:18 -0400
Date: Wed, 14 Oct 2009 09:11:22 +0530
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
Subject: Re: [RFC v2 PATCH 4/8] sched: Enforce hard limits by throttling
Message-ID: <20091014034122.GA3568@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com> <20090930125252.GE19951@in.ibm.com> <1255444020.8392.362.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255444020.8392.362.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:27:00PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-09-30 at 18:22 +0530, Bharata B Rao wrote:
> 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 0f1ea4a..77ace43 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1024,7 +1024,7 @@ struct sched_domain;
> >  struct sched_class {
> >  	const struct sched_class *next;
> >  
> > -	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
> > +	int (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
> >  	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
> >  	void (*yield_task) (struct rq *rq);
> >  
> 
> I really hate this, it uglfies all the enqueue code in a horrid way
> (which is most of this patch).
> 
> Why can't we simply enqueue the task on a throttled group just like rt?

We do enqueue a task to its group even if the group is throttled. However such
throttled groups are not enqueued further. In such scenarios, even though the
task enqueue to its parent group succeeded, it really didn't add any task to
the cpu runqueue (rq). So we need to identify this condition and don't
increment rq->running. That is why this return value is needed.

> 
> > @@ -3414,6 +3443,18 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
> >  	}
> >  
> >  	/*
> > +	 * Don't migrate the task if it belongs to a
> > +	 * - throttled group on its current cpu
> > +	 * - throttled group on this_cpu
> > +	 * - group whose hierarchy is throttled on this_cpu
> > +	 */
> > +	if (cfs_rq_throttled(cfs_rq_of(&p->se)) ||
> > +		task_group_throttled(task_group(p), this_cpu)) {
> > +		schedstat_inc(p, se.nr_failed_migrations_throttled);
> > +		return 0;
> > +	}
> > +
> > +	/*
> >  	 * Aggressive migration if:
> >  	 * 1) task is cache cold, or
> >  	 * 2) too many balance attempts have failed.
> 
> Simply don't iterate throttled groups?

We already do that by setting the h_load of the throttled cfs_rq to 0 and
not considering such a cfs_rq for iteration in load_balance_fair(). So I guess
I can remove the first check in the above code (cfs_rq_throttled(cfs_rq_of(&p->se))).

However the other check is needed because, we don't want to pull a task
(whose group is not throttled) from busiest cpu to a target cpu where its
group or any group in its hierarchy is throttled. This is what the 2nd check
does (task_group_throttled(task_group(p), this_cpu))).

Thanks for looking at the patches!

Regards,
Bharata.
