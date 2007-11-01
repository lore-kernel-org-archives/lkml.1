Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbXKAL6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbXKAL6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXKAL60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:58:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38666 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbXKAL6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:58:25 -0400
Subject: Re: [PATCH 2/6] sched: make sched_slice() group scheduling savvy
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <1193917912.27652.258.camel@twins>
References: <20071031211030.310581000@chello.nl>
	 <20071031211248.796653000@chello.nl>
	 <20071101113138.GA20788@linux.vnet.ibm.com>
	 <1193917912.27652.258.camel@twins>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 12:58:19 +0100
Message-Id: <1193918299.27652.260.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 12:51 +0100, Peter Zijlstra wrote:
> On Thu, 2007-11-01 at 17:01 +0530, Srivatsa Vaddagiri wrote:
> > On Wed, Oct 31, 2007 at 10:10:32PM +0100, Peter Zijlstra wrote:
> > > Currently the ideal slice length does not take group scheduling into account.
> > > Change it so that it properly takes all the runnable tasks on this cpu into
> > > account and caluclate the weight according to the grouping hierarchy.
> > > 
> > > Also fixes a bug in vslice which missed a factor NICE_0_LOAD.
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > > ---
> > >  kernel/sched_fair.c |   42 +++++++++++++++++++++++++++++++-----------
> > >  1 file changed, 31 insertions(+), 11 deletions(-)
> > > 
> > > Index: linux-2.6/kernel/sched_fair.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/sched_fair.c
> > > +++ linux-2.6/kernel/sched_fair.c
> > > @@ -331,10 +331,15 @@ static u64 __sched_period(unsigned long 
> > >   */
> > >  static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
> > >  {
> > > -	u64 slice = __sched_period(cfs_rq->nr_running);
> > > +	unsigned long nr_running = rq_of(cfs_rq)->nr_running;
> > > +	u64 slice = __sched_period(nr_running);
> > > 
> > > -	slice *= se->load.weight;
> > > -	do_div(slice, cfs_rq->load.weight);
> > > +	for_each_sched_entity(se) {
> > > +		cfs_rq = cfs_rq_of(se);
> > > +
> > > +		slice *= se->load.weight;
> > > +		do_div(slice, cfs_rq->load.weight);
> > > +	}
> > > 
> > >  	return slice;
> > 
> > 
> > Lets say we have two groups A and B on CPU0, of equal weight (1024).
> > 
> > Further,
> > 
> > A has 1 task (A0)
> > B has 1000 tasks (B0 .. B999) 
> > 
> > Agreed its a extreme case, but illustrates the problem I have in mind
> > for this patch.
> > 
> > All tasks of same weight=1024.
> > 
> > Before this patch
> > =================
> > 
> > 	sched_slice(grp A) = 20ms * 1/2 = 10ms
> > 	sched_slice(A0) = 20ms
> > 
> > 	sched_slice(grp B) = 20ms * 1/2 = 10ms
> > 	sched_slice(B0) = (20ms * 1000/20) * 1 / 1000 = 1ms
> > 	sched_slice(B1) = ... = sched_slice(B99) = 1 ms
> > 
> > Fairness between groups and tasks would be obtained as below:
> > 
> >     A0       B0-B9     A0    B10-B19     A0     B20-B29
> >  |--------|--------|--------|--------|--------|--------|-----//--| 
> >  0       10ms	   20ms	   30ms     40ms     50ms     60ms
> > 
> > After this patch
> > ================
> > 
> > 	sched_slice(grp A) = (20ms * 1001/20) * 1/2 ~= 500ms
> > 	sched_slice(A0) = 500ms
> 
> Hmm, right that is indeed not intended
> 
> > 	sched_slice(grp B) = 500ms
> > 	sched_slice(B0) = 0.5ms 
> 
> This 0.5 is indeed correct, whereas the previous 1ms was not
> 
> > Fairness between groups and tasks would be obtained as below:
> > 
> > 	    A0		          B0 - B99  	            A0
> >  |-----------------------|-----------------------|-----------------------|
> >  0		        500ms			1000ms 			1500ms
> > 
> > Did I get it right? If so, I don't like the fact that group A is allowed to run 
> > for a long time (500ms) before giving chance to group B.
> 
> Hmm, quite bad indeed.

hmm, then again, with 1001 tasks running, that is exactly what should
happen.

> > Can I know what real problem is being addressed by this change to
> > sched_slice()?
> 
> sched_slice() is about lantecy, its intended purpose is to ensure each
> task is ran exactly once during sched_period() - which is
> sysctl_sched_latency when nr_running <= sysctl_sched_nr_latency, and
> otherwise linearly scales latency.
> 
> 

