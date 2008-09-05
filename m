Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYIERYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYIERYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYIERX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:23:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYIERX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:23:58 -0400
Subject: Re: [PATCH] sched: Fix __load_balance_iterator() for cfq with only
 one task
From: Peter Zijlstra <peterz@infradead.org>
To: ego@in.ibm.com
Cc: Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
In-Reply-To: <1220627628.11202.16.camel@twins.programming.kicks-ass.net>
References: <20080905123004.GD6238@in.ibm.com>
	 <1220627628.11202.16.camel@twins.programming.kicks-ass.net>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 19:23:44 +0200
Message-Id: <1220635424.11202.20.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-05 at 17:13 +0200, Peter Zijlstra wrote:
> On Fri, 2008-09-05 at 18:00 +0530, Gautham R Shenoy wrote:
> > sched: Fix __load_balance_iterator() for cfq with only one task.
> > 
> > From: Gautham R Shenoy <ego@in.ibm.com>
> > 
> > The __load_balance_iterator() returns a NULL when there's only one
> > sched_entity which is a task. It is caused by the following code-path.
> > 
> > 
> > 	/* Skip over entities that are not tasks */
> > 	do {
> > 		se = list_entry(next, struct sched_entity, group_node);
> > 		next = next->next;
> > 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
> > 
> > 	if (next == &cfs_rq->tasks)
> > 		return NULL;
> > 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >       This will return NULL even when se is a task.
> > 
> > As a side-effect, there was a regression in sched_mc behavior since 2.6.25,
> > since iter_move_one_task() when it calls load_balance_start_fair(),
> > would not get any tasks to move!
> > 
> > Fix this by checking if the last entity was a task or not.
> 
> Gregory did a similar fix a while ago, but that caused grief of some
> kind..
> 
> Greg, can you recollect why we pulled it? I can't seem to find it.

Gregory pointed me to this thread:

  http://lkml.org/lkml/2008/8/11/81

ego, can you run sysbench to confirm?

> Aside from that this patch looks fine..
> 
> > Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > ---
> > 
> >  kernel/sched_fair.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index fb8994c..f1c96e3 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1451,7 +1451,7 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
> >  		next = next->next;
> >  	} while (next != &cfs_rq->tasks && !entity_is_task(se));
> >  
> > -	if (next == &cfs_rq->tasks)
> > +	if (next == &cfs_rq->tasks && !entity_is_task(se))
> >  		return NULL;
> >  
> >  	cfs_rq->balance_iterator = next;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

