Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYILG4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYILG4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 02:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYILG4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 02:56:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:52416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYILG4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 02:56:36 -0400
Subject: Re: [PATCH] sched: Fix __load_balance_iterator() for cfq with only
 one task
From: Peter Zijlstra <peterz@infradead.org>
To: ego@in.ibm.com
Cc: Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <20080912063539.GB4872@in.ibm.com>
References: <20080905123004.GD6238@in.ibm.com>
	 <1220627628.11202.16.camel@twins.programming.kicks-ass.net>
	 <1220635424.11202.20.camel@twins.programming.kicks-ass.net>
	 <20080912063539.GB4872@in.ibm.com>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 08:56:15 +0200
Message-Id: <1221202575.6407.2.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-12 at 12:05 +0530, Gautham R Shenoy wrote:
> On Fri, Sep 05, 2008 at 07:23:44PM +0200, Peter Zijlstra wrote:
> > On Fri, 2008-09-05 at 17:13 +0200, Peter Zijlstra wrote:
> > > On Fri, 2008-09-05 at 18:00 +0530, Gautham R Shenoy wrote:
> > > > sched: Fix __load_balance_iterator() for cfq with only one task.
> > > > 
> > > > From: Gautham R Shenoy <ego@in.ibm.com>
> > > > 
> > > > The __load_balance_iterator() returns a NULL when there's only one
> > > > sched_entity which is a task. It is caused by the following code-path.
> > > > 
> > > > 
> > > > 	/* Skip over entities that are not tasks */
> > > > 	do {
> > > > 		se = list_entry(next, struct sched_entity, group_node);
> > > > 		next = next->next;
> > > > 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
> > > > 
> > > > 	if (next == &cfs_rq->tasks)
> > > > 		return NULL;
> > > > 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > >       This will return NULL even when se is a task.
> > > > 
> > > > As a side-effect, there was a regression in sched_mc behavior since 2.6.25,
> > > > since iter_move_one_task() when it calls load_balance_start_fair(),
> > > > would not get any tasks to move!
> > > > 
> > > > Fix this by checking if the last entity was a task or not.
> > > 
> > > Gregory did a similar fix a while ago, but that caused grief of some
> > > kind..
> > > 
> > > Greg, can you recollect why we pulled it? I can't seem to find it.
> > 
> > Gregory pointed me to this thread:
> > 
> >   http://lkml.org/lkml/2008/8/11/81
> > 
> > ego, can you run sysbench to confirm?
> 
> Am planning to run it today.
> 
> Mike, with what --oltp-* mode did you run the sysbench test?
> 
> That aside, if Mike's analysis is correct regarding the client/server
> pairs not running on the same CPU as buddies, shouldn't this be fixed in a
> higher level routine rather than have this anomaly in
> __load_balancer_iterator(), which is supposed to return the runnable
> tasks in the cfs_rq ?
> 
> It's current behavior is that __load_balancer_iterator() will
> return NULL even if the last entity in the list is a runnable task.
> 
> This behavior clearly hinders sched_mc powersavings from migrating
> a sole remaining task from a powersavings-sched_domain in-order
> to evacuate that domain and put all the CPUs of the domain into a
> low-power state.

Sure - there is buddy_hot in task_hot() to avoid moving buddies, and I
think we should do something like this:

@@ -590,7 +602,7 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
                add_cfs_task_weight(cfs_rq, se->load.weight);
        cfs_rq->nr_running++;
        se->on_rq = 1;
-       list_add(&se->group_node, &cfs_rq->tasks);
+       list_add_tail(&se->group_node, &cfs_rq->tasks);
 }

 static void

(most likely whitespace damaged)



