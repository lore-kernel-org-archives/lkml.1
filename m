Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbZJGPDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbZJGPDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759429AbZJGPDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:03:36 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:51936 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759413AbZJGPDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:03:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAApHzEpMROOX/2dsb2JhbACBUtU8gjSBdgQ
Date: Wed, 7 Oct 2009 11:02:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091007150257.GA8508@Krystal>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910071039520.5671@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:56:45 up 50 days,  1:46,  3 users,  load average: 0.08, 0.22,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:
> 
> > Yes, I understood this is what he was doing, but I wonder about the
> > impact on the scheduler. If we have:
> >
> > * Jiffy 1 -- timer interrupt
> >
> > * preempt disable
> > * Jiffy 2 -- timer interrupt
> >   -> here, the scheduler is disabled, so the timer interrupt is skipped.
> >      The scheduler depends on preempt_check_resched() at preempt_enable()
> >      to execute in a bounded amount of time.
> 
> preempt disable does not disable interrupts. The timer interrupt will
> occur. The scheduler may not reschedule another job on this processor
> when the timer interrupt calls the scheduler_tick. It
> may not do load balancing.

Yes. All you say here is true. I'm concerned about the _impact_ of this
along with the preempt/irqoff dance you propose. Trimming the following
key points from my execution scenario indeed skips the problem altogether.

Usually, when preemption is disabled, the scheduler restrain from
executing. *Now the important point*: the criterion that bounds the
maximum amount of time before the scheduler will re-check for pending
preemption is when preempt_enable() will re-activate preemption.

But because you run preempt_enable with interrupts off, the scheduler
check is not done. And it's not done when interrupts are re-activated
neither.

Please go back to my complete execution scenario, you'll probably see
the light. ;)

Thanks,

Mathieu

> 
> > Also, preempt_enable here should be replaced with
> > preempt_enable_no_resched().
> 
> Used to have that in earlier incarnations but I saw a lot of these being
> removed lately.
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
