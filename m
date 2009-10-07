Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbZJGPlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbZJGPlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbZJGPlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:41:50 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:37001 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbZJGPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:41:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFABZOzEpMROOX/2dsb2JhbACBUtVjhCoE
Date: Wed, 7 Oct 2009 11:41:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091007154111.GA12351@Krystal>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org> <20091007150257.GA8508@Krystal> <alpine.DEB.1.10.0910071102590.9984@gentwo.org> <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910071119450.9296@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:31:48 up 50 days,  2:21,  3 users,  load average: 0.33, 0.58,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:
> 
> > You are already calling the scheduler when ending the _fast_ path. I
> > don't see the problem with calling it when you end the slow path
> > execution.
> 
> Well yes that gives rise to the thought of using
> 
> 	preempt_enable_no_sched()
> 
> at the end of the fastpath as well. Constant calls into the scheduler
> could be a major performance issue

... but the opposite is a major RT behavior killer.

preempt_check_resched is basically:

a test TIF_NEED_RESCHED
  if true, call to preempt_schedule

So, it's not a call to the scheduler at each and every preempt_enable.
It's _only_ if an interrupt came in during the preempt off section and
the scheduler considered that it should re-schedule soon.

I really don't see what's bothering you here. Testing a thread flag is
incredibly cheap. That's what is typically added to your fast path.

So, correct behavior would be:

preempt disable()
fast path attempt
  if (fast path already taken) {
    local_irq_save();
    slow path.
    local_irq_restore();
  }
preempt_enable()


Mathieu

> . I dont notice it here since I usually
> cannot affort the preempt overhead and build kernels without support for
> it.
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
