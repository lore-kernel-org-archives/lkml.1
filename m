Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZEHPMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZEHPMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZEHPMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:12:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49914 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbZEHPMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:12:40 -0400
Date: Fri, 8 May 2009 08:06:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090508150634.GC6788@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.1.10.0905071010170.24528@qirst.com> <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> <1241716718.6311.1531.camel@laptop> <20090507173608.GC6693@linux.vnet.ibm.com> <1241717904.6311.1558.camel@laptop> <20090507180112.GE6693@linux.vnet.ibm.com> <1241778776.6311.2585.camel@laptop> <20090508125023.GA6935@linux.vnet.ibm.com> <alpine.DEB.1.10.0905081012420.23875@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905081012420.23875@qirst.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 10:16:10AM -0400, Christoph Lameter wrote:
> On Fri, 8 May 2009, Paul E. McKenney wrote:
> 
> > > Can't you simply enter idle state after a grace period completes and
> > > finds no pending callbacks for the next period. And leave idle state at
> > > the next call_rcu()?
> >
> > If there were no RCU callbacks -globally- across all CPUs, yes.  But
> > the check at the end of rcu_irq_exit() is testing only on the current
> > CPU.  Checking across all CPUs is expensive and racy.
> >
> > So what happens instead is that there is rcu_needs_cpu(), which gates
> > entry into dynticks-idle mode.  This function returns 1 if there are
> > callbacks on the current CPU.  So, if no CPU has an RCU callback, then
> > all CPUs can enter dynticks-idle mode so that the entire system is
> > quiescent from an RCU viewpoint -- no RCU processing at all.
> 
> Did not follow RCU developments. But wasnt there a time when RCU periods
> were processor specific and a global RCU period was done when all the
> processors went through their rcu periods?

For non-realtime RCU implementations, after a given grace period starts,
once each CPU goes through a "quiescent state", then that grace period
can end.  For realtime (AKA "preemptable") RCU, the focus is on tasks
rather than CPUs, but the same general principle applies, give or take
some implementation details: after a given grace period starts, once
each task goes through a quiescent state, then that grace period can end.

> Cpu cache hotness may not be relevant to RCU since rcu involves long time
> periods in which cachelines cool down. Can the RCU callbacks all be done
> on processor 0 (or a so designated processor)? That would avoiding
> disturbances of the other processors.

This approach -might- be OK for a specially configured and protected HPC
machine.  But it is a non-starter for general-purpose machines.  For an
example of why, consider a denial-of-service attack that continually
change routing tables could saturate CPU 0 and start falling behind,
eventually OOMing the machine.

But if you would like to experiment with this, make call_rcu() be a
wrapper that causes an underlying call_rcu_cpu_0() to be executed on
CPU 0.  That won't get exactly the cache-warmth effects that you are
after, but it will let you see whether the machine would gracefully
handle various events that might dump large numbers of callbacks.

							Thanx, Paul
