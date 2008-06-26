Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYFZGwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYFZGwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYFZGvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:51:53 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:31501 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513AbYFZGvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:51:52 -0400
X-SourceIP: 62.163.52.83
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
	with irqs disable
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <48630420.1090102@goop.org>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	 <20080507073017.GJ32195@elte.hu>
	 <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
	 <1214241561.19392.21.camel@elijah.suse.cz>
	 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
	 <1214253593.11254.30.camel@twins>
	 <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>
	 <1214254730.11254.34.camel@twins>  <48630420.1090102@goop.org>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 08:51:00 +0200
Message-Id: <1214463060.3035.12.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 19:51 -0700, Jeremy Fitzhardinge wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-06-23 at 13:45 -0700, Christoph Lameter wrote:
> >   
> >> On Mon, 23 Jun 2008, Peter Zijlstra wrote:
> >>
> >>     
> >>>> It is good that the locks are build with _trylock and _can_lock because 
> >>>> then we can reenable interrupts while spinning.
> >>>>         
> >>> Well, good and bad, the turn side is that fairness schemes like ticket
> >>> locks are utterly defeated.
> >>>       
> >> True. But maybe we can make these fairness schemes more generic so that 
> >> they can go into core code?
> >>     
> >
> > The trouble with ticket locks is that they can't handle waiters going
> > away - or in this case getting preempted by irq handlers. The one who
> > took the ticket must pass it on, so if you're preempted it just sits
> > there being idle, until you get back to deal with the lock.
> >
> > But yeah, perhaps another fairness scheme might work in the generic
> > code..
> 
> Thomas Friebel presented results at the Xen Summit this week showing 
> that ticket locks are an absolute disaster for scalability in a virtual 
> environment, for a similar reason.  It's a bit irritating if the lock 
> holder vcpu gets preempted by the hypervisor, but its much worse when 
> they release the lock: unless the vcpu scheduler gives a cpu to the vcpu 
> with the next ticket, it can waste up to N timeslices spinning.
> 
> I'm experimenting with adding pvops hook to allow you to put in new 
> spinlock implementations on the fly.  If nothing else, it will be useful 
> for experimenting with different algorithms.  But it definitely seems 
> like the old unfair lock algorithm played much better with a virtual 
> environment, because the next cpu to get the lock is the next one the 
> scheduler gives time, rather than dictating an order - and the scheduler 
> should mitigate the unfairness that ticket locks were designed to solve.

Paravirt spinlocks sounds like a good idea anyway, that way you can make
them scheduling locks (from the host's POV) when the lock owner (vcpu)
isn't running.

Burning time spinning on !running vcpus seems like a waste to me.

As for the scheduler solving the unfairness that ticket locks solve,
that cannot be done. The ticket lock solves intra-cpu fairness for a
resource other than time. The cpu scheduler only cares about fairness in
time, and its intra-cpu fairness is on a larger scale than most spinlock
hold times - so even if time and the locked resource would overlap it
wouldn't work.

The simple scenario is running N tasks on N cpus that all pound the same
lock, cache issues will make it unlikely the lock would migrate away
from whatever cpu its on, essentially starving all the other N-1 cpus.

Ticket locks solve that exact issue, all the scheduler can do is ensure
they're all spending an equal amount of time on the cpu, whether that is
spinning for lock acquisition or getting actual work done is beyond its
scope.



