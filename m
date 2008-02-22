Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbYBVUXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbYBVUXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYBVUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:23:32 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43264 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYBVUXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:23:30 -0500
Date: Fri, 22 Feb 2008 12:23:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: "Bill Huey (hui)" <bill.huey@gmail.com>, Andi Kleen <ak@suse.de>,
       Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net,
       gregkh@suse.de, pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
Message-ID: <20080222202316.GF11213@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152707.4804.59177.stgit@novell1.haskins.net> <200802211741.10299.ak@suse.de> <20080222190814.GD11213@linux.vnet.ibm.com> <9810cff90802221119j23818e74g2721512a693a0a01@mail.gmail.com> <9810cff90802221121s216f69f4k4a5f39eaaf11dd7f@mail.gmail.com> <20080222194341.GE11213@linux.vnet.ibm.com> <1203710145.4772.107.camel@sven.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203710145.4772.107.camel@sven.thebigcorporation.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:55:45AM -0800, Sven-Thorsten Dietrich wrote:
> 
> On Fri, 2008-02-22 at 11:43 -0800, Paul E. McKenney wrote:
> > On Fri, Feb 22, 2008 at 11:21:14AM -0800, Bill Huey (hui) wrote:
> > > On Fri, Feb 22, 2008 at 11:19 AM, Bill Huey (hui) <bill.huey@gmail.com> wrote:
> > > >  Yeah, I'm not very keen on having a constant there without some
> > > >  contention instrumentation to see how long the spins are. It would be
> > > >  better to just let it run until either task->on_cpu is off or checking
> > > >  if the "current" in no longer matches the mutex owner for the runqueue
> > > >  in question. At that point, you know the thread isn't running.
> > > >  Spinning on something like that is just a waste of time. It's for that
> > > >  reason that doing in the spin outside of a preempt critical section
> > > >  isn't really needed
> > > 
> > > Excuse me, I meant to say "...isn't a problem".
> > 
> > The fixed-time spins are very useful in cases where the critical section
> > is almost always very short but can sometimes be very long.  In such
> > cases, you would want to spin until either ownership changes or it is
> > apparent that the current critical-section instance will be long.
> > 
> > I believe that there are locks in the Linux kernel that have this
> > "mostly short but sometimes long" hold-time property.
> 
> In regards to this "mostly short but sometimes long" question, 
> for very large SMP systems, running with some profiling enabled, might
> allow the system to adapt to varying workloads and therefore shifting
> lock contention / hold-times. 
> 
> Overall utilization despite the overhead might be lower, but this is
> tbd.
> 
> In high-contention, short-hold time situations, it may even make sense
> to have multiple CPUs with multiple waiters spinning, depending on
> hold-time vs. time to put a waiter to sleep and wake them up.
> 
> The wake-up side could also walk ahead on the queue, and bring up
> spinners from sleeping, so that they are all ready to go when the lock
> flips green for them.
> 
> But in more simple cases, there should be a simple, default timeout
> governed by context switch overhead or as defined by a derived number of
> cache misses, as you suggested.

Governing the timeout by context-switch overhead sounds even better to me.
Really easy to calibrate, and short critical sections are of much shorter
duration than are a context-switch pair.

							Thanx, Paul

> Sven
> 
> > 							Thanx, Paul
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
