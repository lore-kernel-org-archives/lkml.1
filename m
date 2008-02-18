Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYBRPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYBRPTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYBRPTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:19:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50967 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYBRPTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:19:13 -0500
Subject: Re: Regression with sched yield - 2.6.25-rc2-mm1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <47B99AB4.3020604@linux.vnet.ibm.com>
References: <47B9775F.1050203@linux.vnet.ibm.com>
	 <1203338377.10858.3.camel@lappy>  <47B99AB4.3020604@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 16:18:53 +0100
Message-Id: <1203347933.10858.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 20:18 +0530, Balbir Singh wrote:

> > Humm, the check that should have avoided that is:
> > 
> >         /*
> >          * Are we the only task in the tree?
> >          */
> >         if (unlikely(rq->load.weight == curr->se.load.weight))
> >                 return;
> > 
> > 
> > But I guess that overlooks rt tasks, they also increase the load.
> > So I guess something like this ought to fix it..
> > 
> 
> Peter,
> 
> I don't remember any real time tasks running on the system, so I would be
> surprised if that is indeed the case.

Various kthreads have rt prio. Notably the load_balancer_monitor().

>  Having said that, rightmost was indeed
> NULL, so I need to figure out why it was. The other question is why would a real
> time task be found by sched_yield_fair? 

Because a rt task contributes weight and would make the test above fail
because rt->load would be larger than expected.

> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index b9ade89..83eb30c 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -998,7 +998,7 @@ static void yield_task_fair(struct rq *rq)
> >  	/*
> >  	 * Already in the rightmost position?
> >  	 */
> > -	if (unlikely(rightmost->vruntime < se->vruntime))
> > +	if (unlikely(!rightmost || rightmost->vruntime < se->vruntime))
> >  		return;
> > 
> >  	/*
> > 

