Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbZJTFDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbZJTFDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZJTFDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:03:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:60064 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752315AbZJTFDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:03:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ii0gmxkhiG4taFpf8we+HqvzsQWqAMiPedpWbou
	OeQnOTmGr+Vegb
Subject: Re: RFC [patch] sched: strengthen LAST_BUDDY and minimize buddy
 induced latencies V3
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1256012656.17774.14.camel@laptop>
References: <1255775063.32691.5.camel@marge.simson.net>
	 <1256012656.17774.14.camel@laptop>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 07:03:37 +0200
Message-Id: <1256015017.6568.32.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 06:24 +0200, Peter Zijlstra wrote:
> On Sat, 2009-10-17 at 12:24 +0200, Mike Galbraith wrote:
> > sched: strengthen LAST_BUDDY and minimize buddy induced latencies.
> > 
> > This patch restores the effectiveness of LAST_BUDDY in preventing pgsql+oltp
> > from collapsing due to wakeup preemption.  It also minimizes buddy induced
> > latencies.  x264 testcase spawns new worker threads at a high rate, and was
> > being affected badly by NEXT_BUDDY.  It turned out that CACHE_HOT_BUDDY was
> > thwarting idle balancing.  This patch ensures that the load can disperse,
> > and that buddies can't make any task excessively late.
> 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -2007,8 +2007,12 @@ task_hot(struct task_struct *p, u64 now,
> >  
> >  	/*
> >  	 * Buddy candidates are cache hot:
> > +	 *
> > +	 * Do not honor buddies if there may be nothing else to
> > +	 * prevent us from becoming idle.
> >  	 */
> >  	if (sched_feat(CACHE_HOT_BUDDY) &&
> > +			task_rq(p)->nr_running >= sched_nr_latency &&
> >  			(&p->se == cfs_rq_of(&p->se)->next ||
> >  			 &p->se == cfs_rq_of(&p->se)->last))
> >  		return 1;
> 
> I'm not sure about this. The sched_nr_latency seems arbitrary, 1 seems
> like a more natural boundary.

That's what I did first, which of course worked fine.

What I'm thinking of doing instead though is to specifically target the
only time I see the problem, ie fork/exec load wanting to disperse.  I
don't really want to see buddies being ripped away from their cache.
But as you note below, that can be a good thing iff it lands on a shared
cache. In my case, there's a 1 in 3 chance of safe landing.

> Also, one thing that arjan found was that we don't need to consider
> buddies cache hot if we're migrating them within a cache domain. So we
> need to add a SD_flag and sched_domain to properly represent the cache
> hierarchy.

Yeah, I thought about this too.  If there's any overlap time, waking CPU
affine is a loser if there's an idle shared cache next door.

	-Mike

