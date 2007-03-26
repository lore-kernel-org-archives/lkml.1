Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXC1O1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXC1O1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXC1O1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:27:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53735 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXC1O1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:27:51 -0400
Date: Mon, 26 Mar 2007 13:07:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: David Howells <dhowells@redhat.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: I/O memory barriers vs SMP memory barriers
Message-ID: <20070326200711.GA31296@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com> <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> <16051.1174657433@redhat.com> <20070325211542.GD3593@linux.vnet.ibm.com> <20070325213843.GE22126@xi.wantstofly.org> <20070326032418.GA14557@linux.vnet.ibm.com> <20070326084639.GA30291@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326084639.GA30291@xi.wantstofly.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 10:46:39AM +0200, Lennert Buytenhek wrote:
> On Sun, Mar 25, 2007 at 08:24:18PM -0700, Paul E. McKenney wrote:
> 
> > > > > > [ background: On ARM, SMP synchronisation does need barriers but device
> > > > > >   synchronisation does not.  The question is that given this, whether
> > > > > >   mb() and friends can be NOPs on ARM or not (i.e. whether mb() is
> > > > > >   supposed to sync against other CPUs or not, or whether only smp_mb()
> > > > > >   can be used for this.)  ]
> > > > > 
> > > > > Hmmmm...
> > > > > 
> > > > > [snip]
> > > > 
> > > > 3.	Orders memory accesses and device accesses, but not necessarily
> > > > 	the union of the two -- mb(), rmb(), wmb().
> > > 
> > > If mb/rmb/wmb are required to order normal memory accesses, that means
> > > that the change made in commit 9623b3732d11b0a18d9af3419f680d27ea24b014
> > > to always define mb/rmb/wmb as barrier() on ARM systems was wrong.
> > 
> > This was on UP ARM systems, right?
> 
> No.
> 
> If you look at commit 9623b3732d11b0a18d9af3419f680d27ea24b014, you can
> see that it defines mb/rmb/wmb as barrier() on both ARM UP and SMP systems.
> The UP part is obviously fine, the SMP part is what is under debate here.

Yep, looks wrong to me.

> > Assuming that ARM CPUs respect the usual CPU-self-consistency
> > semantics, and given the background that device accesses are ordered,
> > then it might well be OK to have mb/rmb/wmb be barrier() on UP ARM
> > systems.
> > 
> > Most likely not on SMP ARM systems, however.
> 
> Given the semantics above, mb/rmb/wmb can obviously be just barrier()s
> on ARM UP systems.. I don't think anyone ever disagreed about that.

Good.

> > > Does everybody agree on these semantics, though?  At least David
> > > seems to think that mb/rmb/wmb aren't required to order normal
> > > memory accesses against each other..
> > 
> > Not on UP.  On SMP, ordering is (almost certainly) required.
> 
> 'almost certainly'?  That sounds like there is a possibility that it
> wouldn't have to?  What does this depend on?

The underlying memory model of the CPU.  For sequentially consistent
systems, only compiler barriers are required.  There are very few such
systems -- MIPS and PA-RISC, if I remember correctly.  Performance
dictates otherwise.

I believe that MIPS is -not- sequentially consistent, but have not yet
purchased an architecture reference manual.

> At least David and Catalin seem to disagree with the statement
> that mb/rmb/wmb should order accesses from different CPUs.  And
> memory-barriers.txt is pretty vague about this..

mb() needs to do everything that smp_mb() does, ditto for rmb() and
wmb().  There really are cases where both I/O and memory accesses
need to be ordered, so just providing separate memory ordering and
I/O ordering is not enough.

Given that ARM device drivers are accessing MMIO locations, which are
often slow anyway, how much is ARM really gaining by dropping memory
barriers when only I/O accesses need be ordered?  Is it measurable?
If not, there is no point in adding yet another set of combinatorial
choices to the memory-barrier API.

						Thanx, Paul
