Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbXJLNX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbXJLNX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbXJLNXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:23:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39462 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbXJLNXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:23:18 -0400
Subject: Re: [PATCH 0/7] RT: (RFC) RT-Overload/Sched enhancements
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0710120745310.8793@gandalf.stny.rr.com>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
	 <1192184985.27435.17.camel@twins>
	 <Pine.LNX.4.58.0710120745310.8793@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 12 Oct 2007 09:20:47 -0400
Message-Id: <1192195247.4067.14.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 07:47 -0400, Steven Rostedt wrote:
> --
> 
> On Fri, 12 Oct 2007, Peter Zijlstra wrote:
> 
> >
> > And for that, steve's rq->curr_prio field seems quite suitable.
> >
> > so instead of the:
> >   for (3 tries)
> >     find lowest cpu
> >     try push
> >
> > we do:
> >
> >   cpu_hotplug_lock();
> >   cpus_and(mask, p->cpus_allowed, online_cpus);
> >   for_each_cpu_mask(i, mask) {
> >     if (cpu_rq(i)->curr_prio > p->prio && push_task(p, i))
> >       break;
> >   }
> >   cpu_hotplug_unlock();
> 

IMO we should try to logically separate the "search" and "push"
functionality (for instance, see my series).  The search is useful
outside the "push" operation for cases where we are waking a lower-task
that doesn't preempt on the current RQ.  In that case, we can try to
wake it directly on the optimal queue instead of waking locally and then
pushing away.

> The thing I'm worried about is that we pushed off a rt task that is higher
> in prio than another rt task on another cpu, and we'll cause a bunch of
> rt task bouncing.  That is what I'm trying to avoid.

I agree, though I think we will achieve that once the final 3rd part of
the algorithm is implemented.  Stay tuned for an update in that area.



