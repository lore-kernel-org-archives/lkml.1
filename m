Return-Path: <linux-kernel-owner+w=401wt.eu-S1762398AbZJODbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398AbZJODbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762389AbZJODbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:31:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43912 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762387AbZJODbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:31:07 -0400
Date: Thu, 15 Oct 2009 09:00:18 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 4/8] sched: Enforce hard limits by throttling
Message-ID: <20091015033018.GA3320@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com> <20090930125252.GE19951@in.ibm.com> <1255444020.8392.362.camel@twins> <20091014034122.GA3568@in.ibm.com> <1255511864.8392.370.camel@twins> <20091014115003.GA3540@in.ibm.com> <20091014131854.GI24787@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014131854.GI24787@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 03:18:54PM +0200, Herbert Poetzl wrote:
> On Wed, Oct 14, 2009 at 05:20:03PM +0530, Bharata B Rao wrote:
> > On Wed, Oct 14, 2009 at 11:17:44AM +0200, Peter Zijlstra wrote:
> > > On Wed, 2009-10-14 at 09:11 +0530, Bharata B Rao wrote:
> > > > On Tue, Oct 13, 2009 at 04:27:00PM +0200, Peter Zijlstra wrote:
> > > > > On Wed, 2009-09-30 at 18:22 +0530, Bharata B Rao wrote:
> > > > > 
> > > > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > > > index 0f1ea4a..77ace43 100644
> > > > > > --- a/include/linux/sched.h
> > > > > > +++ b/include/linux/sched.h
> > > > > > @@ -1024,7 +1024,7 @@ struct sched_domain;
> > > > > >  struct sched_class {
> > > > > >     const struct sched_class *next;
> > > > > >  
> > > > > > -   void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
> > > > > > +   int (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
> > > > > >     void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
> > > > > >     void (*yield_task) (struct rq *rq);
> > > > > >  
> > > > > 
> > > > > I really hate this, it uglfies all the enqueue code in a horrid way
> > > > > (which is most of this patch).
> > > > > 
> > > > > Why can't we simply enqueue the task on a throttled group just like rt?
> > > > 
> > > > We do enqueue a task to its group even if the group is throttled. However such
> > > > throttled groups are not enqueued further. In such scenarios, even though the
> > > > task enqueue to its parent group succeeded, it really didn't add any task to
> > > > the cpu runqueue (rq). So we need to identify this condition and don't
> > > > increment rq->running. That is why this return value is needed.
> > > 
> > > I would still consider those tasks running, the fact that they don't get
> > > to run is a different matter.
> 
> > Ok, that's how rt also considers them I realize. I thought that we
> > should update rq->running when tasks go off the runqueue due to
> > throttling. When a task is throttled, it is no doubt present on its
> > group's cfs_rq, but it doesn't contribute to the CPU load as the
> > throttled group entity isn't there on any cfs_rq. rq->running is used
> > to obtain a few load balancing metrics and they might go wrong if
> > rq->running isn't uptodate.
> 
> for all practical purposes throttled tasks _are_ running
> (i.e. they would like to run, but the hardware/software
> doesn't allow them to do more work) ...

Ok, I will take a re-look at this and see if I too can consider them
as running and don't touch rq->running which should simply some code.

> 
> > Do you still think we shouldn't update rq->running ? If so, I can get rid
> > of this return value change.
> 
> Linux-VServer marked throttled tasks as 'H' (on hold)
> but counted them as running, which seems to work fine
> and reflect the expected behaviour ...

So a new task state 'H' ?

Thanks for your comments.

Regards,
Bharata.
