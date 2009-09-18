Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZIRUDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZIRUDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZIRUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:03:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:33845 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZIRUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:03:25 -0400
Subject: Re: [PATCH] Prevent immediate process rescheduling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090918195455.GC11726@elte.hu>
References: <200909181449.12311.mark.langsdorf@amd.com>
	 <20090918195455.GC11726@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 22:03:23 +0200
Message-Id: <1253304203.10538.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 21:54 +0200, Ingo Molnar wrote:

> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 652e8bd..4fad08f 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -353,11 +353,25 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >  static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
> >  {
> >  	struct rb_node *left = cfs_rq->rb_leftmost;
> > +	struct sched_entity *se, *curr;
> >  
> >  	if (!left)
> >  		return NULL;
> >  
> > -	return rb_entry(left, struct sched_entity, run_node);
> > +	se = rb_entry(left, struct sched_entity, run_node);
> > +	curr = &current->se;
> > +
> > +	/* 
> > +	 * Don't select the entity who just tried to schedule away
> > +	 * if there's another entity available.
> > +	 */
> > +	if (unlikely(se == curr && cfs_rq->nr_running > 1)) {
> > +		struct rb_node *next_node = rb_next(&curr->run_node);
> > +		if (next_node)
> > +			se = rb_entry(next_node, struct sched_entity, run_node);
> > +	}
> > +
> > +	return se;
> >  }

Really hate this change though,. doesn't seem right to not pick the same
task again if its runnable. Bad for cache footprint.

The scenario is quite common for stuff like:

CPU0                                      CPU1

set_task_state(TASK_INTERRUPTIBLE)

if (cond)
  goto out;
                                     <--- ttwu()
schedule();



