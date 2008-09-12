Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbYILGhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbYILGhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 02:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYILGhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 02:37:31 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:50053 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751126AbYILGha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 02:37:30 -0400
Date: Fri, 12 Sep 2008 12:05:39 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] sched: Fix __load_balance_iterator() for cfq with only
	one task
Message-ID: <20080912063539.GB4872@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080905123004.GD6238@in.ibm.com> <1220627628.11202.16.camel@twins.programming.kicks-ass.net> <1220635424.11202.20.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220635424.11202.20.camel@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 07:23:44PM +0200, Peter Zijlstra wrote:
> On Fri, 2008-09-05 at 17:13 +0200, Peter Zijlstra wrote:
> > On Fri, 2008-09-05 at 18:00 +0530, Gautham R Shenoy wrote:
> > > sched: Fix __load_balance_iterator() for cfq with only one task.
> > > 
> > > From: Gautham R Shenoy <ego@in.ibm.com>
> > > 
> > > The __load_balance_iterator() returns a NULL when there's only one
> > > sched_entity which is a task. It is caused by the following code-path.
> > > 
> > > 
> > > 	/* Skip over entities that are not tasks */
> > > 	do {
> > > 		se = list_entry(next, struct sched_entity, group_node);
> > > 		next = next->next;
> > > 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
> > > 
> > > 	if (next == &cfs_rq->tasks)
> > > 		return NULL;
> > > 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >       This will return NULL even when se is a task.
> > > 
> > > As a side-effect, there was a regression in sched_mc behavior since 2.6.25,
> > > since iter_move_one_task() when it calls load_balance_start_fair(),
> > > would not get any tasks to move!
> > > 
> > > Fix this by checking if the last entity was a task or not.
> > 
> > Gregory did a similar fix a while ago, but that caused grief of some
> > kind..
> > 
> > Greg, can you recollect why we pulled it? I can't seem to find it.
> 
> Gregory pointed me to this thread:
> 
>   http://lkml.org/lkml/2008/8/11/81
> 
> ego, can you run sysbench to confirm?

Am planning to run it today.

Mike, with what --oltp-* mode did you run the sysbench test?

That aside, if Mike's analysis is correct regarding the client/server
pairs not running on the same CPU as buddies, shouldn't this be fixed in a
higher level routine rather than have this anomaly in
__load_balancer_iterator(), which is supposed to return the runnable
tasks in the cfs_rq ?

It's current behavior is that __load_balancer_iterator() will
return NULL even if the last entity in the list is a runnable task.

This behavior clearly hinders sched_mc powersavings from migrating
a sole remaining task from a powersavings-sched_domain in-order
to evacuate that domain and put all the CPUs of the domain into a
low-power state.

> 
> > Aside from that this patch looks fine..
> > 
> > > Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > ---
> > > 
> > >  kernel/sched_fair.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > 
> > > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > > index fb8994c..f1c96e3 100644
> > > --- a/kernel/sched_fair.c
> > > +++ b/kernel/sched_fair.c
> > > @@ -1451,7 +1451,7 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
> > >  		next = next->next;
> > >  	} while (next != &cfs_rq->tasks && !entity_is_task(se));
> > >  
> > > -	if (next == &cfs_rq->tasks)
> > > +	if (next == &cfs_rq->tasks && !entity_is_task(se))
> > >  		return NULL;
> > >  
> > >  	cfs_rq->balance_iterator = next;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Thanks and Regards
gautham
