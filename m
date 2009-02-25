Return-Path: <linux-kernel-owner+w=401wt.eu-S1761849AbZBYLOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761849AbZBYLOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758132AbZBYLOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:14:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922AbZBYLOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:14:08 -0500
Date: Wed, 25 Feb 2009 12:13:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: miaox@cn.fujitsu.com, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix unfairness when upgrade weight
Message-ID: <20090225111355.GD15453@elte.hu>
References: <49A4F401.30503@cn.fujitsu.com> <1235550053.4645.3035.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235550053.4645.3035.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1690,6 +1690,15 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
> >  static void prio_changed_fair(struct rq *rq, struct task_struct *p,
> >  			      int oldprio, int running)
> >  {
> > +	struct cfs_rq *cfs_rq = task_cfs_rq(p);
> > +	struct sched_entity *se = &p->se;
> > +	int on_rq = se->on_rq;
> > +
> > +	if (p->prio < oldprio && on_rq) {
> > +		dequeue_entity(cfs_rq, se, 0);
> > +		se->vruntime = cfs_rq->min_vruntime + sched_vslice(cfs_rq, se);
> > +		enqueue_entity(cfs_rq, se, 0);
> > +	}
> 
> we very likely just enqueued the thing, and now we dequeue/enqueue
> again.. not very nice.

but priority-change is a slowpath, so it shouldnt matter much, 
should it?

	Ingo
