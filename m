Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbZJHRXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbZJHRXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932821AbZJHRXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:23:08 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:56154 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932815AbZJHRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:23:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEADK3zUpMROOX/2dsb2JhbACBUtoMhCoE
Date: Thu, 8 Oct 2009 13:22:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091008172221.GB3370@Krystal>
References: <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org> <20091007150257.GA8508@Krystal> <alpine.DEB.1.10.0910071102590.9984@gentwo.org> <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <1254988350.26976.256.camel@twins> <20091008124456.GA13307@Krystal> <1255006435.26976.309.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1255006435.26976.309.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:17:58 up 51 days,  4:07,  2 users,  load average: 0.49, 0.24,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2009-10-08 at 08:44 -0400, Mathieu Desnoyers wrote:
> > Even if only done with interrupt off, and check resched is called after
> > each irq enable following this critical section ? I'd like to understand
> > the reason behind your rejection for this specific case.
> 
> No, the thing you proposed:
> 
> > preempt disable()
> > fast path attempt
> >   if (fast path already taken) {
> >     local_irq_save();
> >     preempt_enable_no_resched();
> >     slow path {
> >       if (!flags & GFP_ATOMIC) {
> >         local_irq_enable();
> >         preempt_check_resched();
> >         ...
> >         local_irq_disable();
> >       }
> >     }
> >     local_irq_restore();
> >     preempt_check_resched();
> >     return;
> >   }
> > preempt_enable()
> 
> Seems ok.
> 
> I just don't get why Christoph is getting all upset about the
> need_resched() check in preempt_enable(), its still cheaper than poking
> at the interrupt flags.

I agree with you. need_resched() check is incredibly cheap. And if
Christoph still complains about the compiler barrier in preempt
enable_no_resched/disable, then I think he should consider the fact that
the compiler does not perform cross-function optimizations, and consider
putting the preempt disable/enable statements close to function
boundaries. Therefore, the impact in terms of compiler optimization
restrictions should be minimal.

The scheme I proposed above should be OK in terms of scheduler effect
and permit to deal with re-enabling preemption in the slow path
appropriately.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
