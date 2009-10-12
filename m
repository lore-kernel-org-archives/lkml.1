Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZJLP1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZJLP1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbZJLP1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:27:06 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:55982 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105AbZJLP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:27:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAOLn0kpMROOX/2dsb2JhbACBUdVehC0E
Date: Mon, 12 Oct 2009 11:26:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091012152627.GA27835@Krystal>
References: <1254988350.26976.256.camel@twins> <alpine.DEB.1.10.0910081211050.21951@gentwo.org> <20091008171750.GA3370@Krystal> <alpine.DEB.1.10.0910081342540.7735@gentwo.org> <20091008191754.GA12729@Krystal> <alpine.DEB.1.10.0910081520210.8030@gentwo.org> <20091008203724.GA15798@Krystal> <alpine.DEB.1.10.0910081652190.8030@gentwo.org> <20091012135600.GB15605@Krystal> <alpine.DEB.1.10.0910121049580.32595@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910121049580.32595@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:25:35 up 55 days,  2:15,  4 users,  load average: 0.30, 0.23,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Mon, 12 Oct 2009, Mathieu Desnoyers wrote:
> 
> > > In the middle of the function we have determine that we have to go to the
> > > page allocator to get more memory. There is not much the compiler can do
> > > to speed that up.
> >
> > Indeed, the compiler cannot do much about it. However, the programer
> > (you) can move the preempt_enable_no_resched() part of the
> > preempt_enable() to the beginning of the function.
> 
> Ok but then we have the issue that the later irq enable in the
> slowpath will not check for preemption.
> 
> > > > I still recommend the preempt_enable_no_resched() at the beginning of
> > > > __slab_alloc(), and simply putting a check_resched() here (which saves
> > > > us the odd compiler barrier in the middle of function).
> > >
> > > Then preemption would be unnecessarily disabled for the page allocator
> > > call?
> >
> > No ?
> > preempt_enable_no_resched() enables preemption.
> 
> If I just enable interrupts there then the preempt check will not be
> done and we may miss a scheduling point.
> 

That's why you should do:

local_irq_save()
preempt_enable_no_resched()
...
local_irq_restore()
preempt_check_resched()

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
