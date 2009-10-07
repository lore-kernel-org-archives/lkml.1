Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbZJGMrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbZJGMrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932972AbZJGMrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:47:07 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:50424 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932936AbZJGMrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:47:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAJcnzEpMROOX/2dsb2JhbACBUtNWhCoE
Date: Wed, 7 Oct 2009 08:46:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091007124628.GB27363@Krystal>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1254906707.26976.225.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:37:18 up 49 days, 23:26,  2 users,  load average: 0.22, 0.27,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2009-10-06 at 22:54 -0400, Mathieu Desnoyers wrote:
> > > +     local_irq_save(flags);
> > > +     preempt_enable();       /* Get rid of count */
> > 
> > Ugh ? Is that legit ?
> 
> Yeah, it reads rather awkward, and the comment doesn't make it any
> better, but what he's doing is:
> 
> slab_alloc()
>   preempt_disable();
>   __slab_alloc()
>     local_irq_save(flags);
>     preempt_enable();
> 

Yes, I understood this is what he was doing, but I wonder about the
impact on the scheduler. If we have:

* Jiffy 1 -- timer interrupt

* preempt disable
* Jiffy 2 -- timer interrupt
  -> here, the scheduler is disabled, so the timer interrupt is skipped.
     The scheduler depends on preempt_check_resched() at preempt_enable()
     to execute in a bounded amount of time.
* local_irq_save
* preempt_enable
  -> interrupts are disabled, scheduler execution is skipped.
* local_irq_restore
  -> the interrupt line is low. The scheduler won't be called. There is
     no preempt_check_resched() call.

* Jiffy 3 -- timer interrupt
  -> Scheduler finally gets executed, missing a whole jiffy.

At the very least, I think an explicit preempt_check_resched should be
added after local_irq_restore().

Also, preempt_enable here should be replaced with
preempt_enable_no_resched().

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
