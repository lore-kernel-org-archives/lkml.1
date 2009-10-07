Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZJGRNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZJGRNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZJGRNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:13:20 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:35498 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752999AbZJGRNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:13:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAB9jzEpMROOX/2dsb2JhbACBUtYRhCoE
Date: Wed, 7 Oct 2009 13:12:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091007171241.GA21313@Krystal>
References: <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org> <20091007150257.GA8508@Krystal> <alpine.DEB.1.10.0910071102590.9984@gentwo.org> <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <20091007154111.GA12351@Krystal> <alpine.DEB.1.10.0910071237430.3467@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910071237430.3467@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:07:40 up 50 days,  3:57,  3 users,  load average: 0.11, 0.15,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:
> 
> > preempt_check_resched is basically:
> >
> > a test TIF_NEED_RESCHED
> >   if true, call to preempt_schedule
> 
> You did not mention the effect of incrementing the preempt counter and
> the barrier(). Adds an additional cacheline to a very hot OS path.
> Possibly register effects.
> 

What you say applies to preempt_enable(). I was describing
preempt_check_resched above, which involves no compiler barrier nor
increment whatsoever.

By the way, the barrier() you are talking about is in
preempt_enable_no_resched(), the very primitive you are considering
using to save these precious cycles.


> > I really don't see what's bothering you here. Testing a thread flag is
> > incredibly cheap. That's what is typically added to your fast path.
> 
> I am trying to get rid off all unnecessary overhead. These "incredible
> cheap" tricks en masse have caused lots of regressions. And the allocator
> hotpaths are overloaded with these "incredibly cheap" checks alreayd.
> 
> > So, correct behavior would be:
> >
> > preempt disable()
> > fast path attempt
> >   if (fast path already taken) {
> >     local_irq_save();
> >     slow path.
> >     local_irq_restore();
> >   }
> > preempt_enable()
> 
> Ok. If you have to use preempt then you have to suffer I guess..
> 

Yes. A user enabling full preemption should be aware that it has a 
performance footprint.

By the way, from what I remember of the slub allocator, you might find 
the following more suited for your needs. I remember that the slow path
sometimes need to reenable interrupts, so:

preempt disable()
fast path attempt
  if (fast path already taken) {
    local_irq_save();
    preempt_enable_no_resched();
    slow path {
      if (!flags & GFP_ATOMIC) {
        local_irq_enable();
        preempt_check_resched();
        ...
        local_irq_disable();
      }
    }
    local_irq_restore();
    preempt_check_resched();
    return;
  }
preempt_enable()

This should work, be efficient and manage to ensure scheduler RT
correctness.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
