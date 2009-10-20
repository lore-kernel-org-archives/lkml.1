Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbZJTTAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbZJTTAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZJTTAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:00:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:38366 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751782AbZJTTA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:00:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18bGmMeRz0b7kmM3FnEFmNnkg5/3QgoDlE/N3+v/9
	V5eM+scB8J39iU
Subject: Re: RFC [patch] sched: strengthen LAST_BUDDY and minimize buddy
 induced latencies V3
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1256048928.8699.34.camel@marge.simson.net>
References: <1255775063.32691.5.camel@marge.simson.net>
	 <1256012656.17774.14.camel@laptop>
	 <1256048928.8699.34.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 21:00:05 +0200
Message-Id: <1256065205.9924.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 16:28 +0200, Mike Galbraith wrote: 
> On Tue, 2009-10-20 at 06:24 +0200, Peter Zijlstra wrote:
> > On Sat, 2009-10-17 at 12:24 +0200, Mike Galbraith wrote:
> > > sched: strengthen LAST_BUDDY and minimize buddy induced latencies.
> > > 
> > > This patch restores the effectiveness of LAST_BUDDY in preventing pgsql+oltp
> > > from collapsing due to wakeup preemption.  It also minimizes buddy induced
> > > latencies.  x264 testcase spawns new worker threads at a high rate, and was
> > > being affected badly by NEXT_BUDDY.  It turned out that CACHE_HOT_BUDDY was
> > > thwarting idle balancing.  This patch ensures that the load can disperse,
> > > and that buddies can't make any task excessively late.
> > 
> > > Index: linux-2.6/kernel/sched.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/sched.c
> > > +++ linux-2.6/kernel/sched.c
> > > @@ -2007,8 +2007,12 @@ task_hot(struct task_struct *p, u64 now,
> > >  
> > >  	/*
> > >  	 * Buddy candidates are cache hot:
> > > +	 *
> > > +	 * Do not honor buddies if there may be nothing else to
> > > +	 * prevent us from becoming idle.
> > >  	 */
> > >  	if (sched_feat(CACHE_HOT_BUDDY) &&
> > > +			task_rq(p)->nr_running >= sched_nr_latency &&
> > >  			(&p->se == cfs_rq_of(&p->se)->next ||
> > >  			 &p->se == cfs_rq_of(&p->se)->last))
> > >  		return 1;
> > 
> > I'm not sure about this. The sched_nr_latency seems arbitrary, 1 seems
> > like a more natural boundary.
> 
> How about the below?  I started thinking about a vmark et al, and
> figured I'd try taking LAST_BUDDY a bit further, ie try even harder to
> give the CPU back to a preempted task so it can go on it's merry way
> rightward.  Vmark likes the idea, as does mysql+oltp and of course pgsql
> +oltp is happier (preempt userland spinlock holder -> welcome to pain)
> 
> That weird little dip right after mysql+oltp peak is still present, and
> I don't understand why.  I've squabbled with that bugger before.
> 
> Full retest (pulled tip v2.6.32-rc5-1497-ga525b32)
> 
> vmark
> tip           108466 messages per second 
> tip++         121151 messages per second

This patchlet, unlike the one I showed you and Ingo offline, also passed
interactivity testing.

But...

It also displays this interesting (to me) property, as did the other,
why I now go try the same with virgin source.

When running vmark with amarok playing (light perturbation), this is the
throughput.

142077 messages per second
140138 messages per second
140264 messages per second

That's three three run averages.  Now, virgin tip.

112511 messages per second
112048 messages per second
115717 messages per second

((112511+112048+115717)/3)/108466 = 1.045
((142077+140138+140264)/3)/121151 = 1.162

Both kernels achieve better throughput with perturbation.

The unperturbed numbers are stable enough to pique my curiosity spot.
(theory baking, not gonna air it;)

	-Mike

