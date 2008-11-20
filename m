Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYKTIEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYKTIEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYKTIDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:03:53 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:57788 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbYKTIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:03:52 -0500
Date: Thu, 20 Nov 2008 13:33:44 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
	the task doesn't belong to init_task_group and when
	CONFIG_RT_GROUP_SCHED isn't set
Message-ID: <20081120080344.GA11023@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20081120061854.GA4349@in.ibm.com> <20081120075829.GA21785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120075829.GA21785@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 08:58:29AM +0100, Ingo Molnar wrote:
> 
> * Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> > Applies on 2.6.28-rc5.
> > 
> > With CONFIG_RT_GROUP_SCHED not set, don't allow a task's priority 
> > switch to realtime if the task isn't part of init_task_group.
> > 
> > A task belonging to a fair group could use 
> > sched_setscheduler/sched_setparam to become a realtime task. If such 
> > a task belongs to one of the child groups of init_task_group and if 
> > CONFIG_RT_GROUP_SCHED is not set, then it ends up getting queued in 
> > init_task_group's runqueue. So we have a situation where, a task 
> > belongs to one group (child) but ends in the runqueue of another 
> > group (init_task_group). This does not look correct.
> > 
> > Fix this by failing such priority change requests in 
> > sched_setscheduler() and sched_setparam().
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  kernel/sched.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -5206,6 +5206,13 @@ recheck:
> >  		if (rt_bandwidth_enabled() && rt_policy(policy) &&
> >  				task_group(p)->rt_bandwidth.rt_runtime == 0)
> >  			return -EPERM;
> > +#elif defined(CONFIG_FAIR_GROUP_SCHED)
> > +		/*
> > +		 * If the task doesn't belong to init_task_group, don't
> > +		 * allow priority switch to realtime. (!CONFIG_RT_GROUP_SCHED)
> > +		 */
> > +		if (rt_policy(policy) && (task_group(p) != &init_task_group))
> > +			return -EPERM;
> >  #endif
> >  
> >  		retval = security_task_setscheduler(p, policy, param);
> 
> hm, another option would be, instead of denying something (which 
> denial might not even be noticed by the app) that the app clearly has 
> enough privilege to request - to just act upon it and move the task to 
> the init_task_group?
> 
> the app cannot expect fair scheduling for this task anyway. And if we 
> want to forbid tasks from doing so - do not give them privilege to go 
> to RT priorities.
> 

I am wondering what would the right action then be if the task drops
back to CFS.

-- 
regards,
Dhaval
