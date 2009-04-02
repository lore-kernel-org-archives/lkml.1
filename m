Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbZDBGrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbZDBGrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZDBGri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:47:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:46827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZDBGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:47:37 -0400
Subject: Re: [PATCH] sched_rt: fix overload bug on rt group scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <49D40DBF.8030507@novell.com>
References: <1238604015.8530.3666.camel@twins> <49D40DBF.8030507@novell.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Apr 2009 08:48:21 +0200
Message-Id: <1238654901.8530.5373.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 20:58 -0400, Gregory Haskins wrote:
> Hi Peter,
> 
> Peter Zijlstra wrote:
> > Fixes an easily triggerable BUG() when setting process affinities.
> >
> > Make sure to count the number of migratable tasks in the same place:
> > the root rt_rq. Otherwise the number doesn't make sense and we'll hit
> > the BUG in set_cpus_allowed_rt().
> >
> > Also, make sure we only count tasks, not groups (this is probably
> > already taken care of by the fact that rt_se->nr_cpus_allowed will be 0
> > for groups, but be more explicit)
> >
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Tested-by: Thomas Gleixner <tglx@linutronix.de>
> > CC: stable@kernel.org
> > ---
> >  kernel/sched_rt.c |   16 +++++++++++++++-
> >  1 files changed, 15 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> > index de4469a..c1ee8dc 100644
> > --- a/kernel/sched_rt.c
> > +++ b/kernel/sched_rt.c
> > @@ -10,6 +10,8 @@ static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
> >  
> >  #ifdef CONFIG_RT_GROUP_SCHED
> >  
> > +#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
> > +
> >  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
> >  {
> >  	return rt_rq->rq;
> > @@ -22,6 +24,8 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
> >  
> >  #else /* CONFIG_RT_GROUP_SCHED */
> >  
> > +#define rt_entity_is_task(rt_se) (1)
> > +
> >  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
> >  {
> >  	return container_of(rt_rq, struct rq, rt);
> > @@ -73,7 +77,7 @@ static inline void rt_clear_overload(struct rq *rq)
> >  
> >  static void update_rt_migration(struct rt_rq *rt_rq)
> >  {
> > -	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
> > +	if (rt_rq->rt_nr_migratory > 1) {
> >   
> 
> The rest of the patch is making sense to me, but I am a little concerned
> about this change.
> 
> The original logic was designed to catch the condition when you might
> have a non-migratory task running, and a migratory task queued.   This
> would mean nr_running == 2, and nr_migratory == 1, which is eligible for
> overload handling.  (Of course, the opposite could be true..the
> migratory is running and the non-migratory is queued...we cannot discern
> the difference here and we go into overload anyway.  This is just
> suboptimal but functionally correct).
> 
> What can happen now is you could have that above condition but we will
> not go into overload unless there is at least two migratory tasks
> queued.  This will undoubtedly allow a potential scheduling latency on
> task #2.
> 
> I think we really need to qualify overload on both running > 1 and at
> least one migratory task.  Is there a way to get this state, even if by
> other means?

Ah, yes, I missed that bit. I ripped out the rt_nr_running because I 1)
didn't think of this, and 2) rt_nr_running is accounted per rt_rq, not
per-cpu, so it doesn't match.

Since rt_nr_running is also used in a per rt_rq setting, changing that
isn't possible and we'd need to introduce another per-cpu variant is you
want to re-instate this.

