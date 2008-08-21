Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbYHUOvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbYHUOvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYHUOve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:51:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:56713 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbYHUOvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:51:33 -0400
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4
	released
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20080821143024.GD6690@linux.vnet.ibm.com>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
	 <48AD5A21.7020801@s5r6.in-berlin.de>
	 <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
	 <200808212337.38626.nickpiggin@yahoo.com.au>
	 <1219327799.8651.134.camel@twins>
	 <20080821143024.GD6690@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 16:48:05 +0200
Message-Id: <1219330085.8651.144.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 07:30 -0700, Paul E. McKenney wrote:
> On Thu, Aug 21, 2008 at 04:09:59PM +0200, Peter Zijlstra wrote:
> > On Thu, 2008-08-21 at 23:37 +1000, Nick Piggin wrote:
> > > On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:
> > > 
> > > > I used the smp_wmb() functions.  I noted a couple of things.  a) some of
> > > > these macros just emit __asm__ __volatile__ into the code so why not just
> > > > say "volatile" to begin with
> > > 
> > > It is not the same as volatile type. What it does is tell the compiler
> > > to clobber all registers or temporaries. This something pretty well
> > > defined and hard to get wrong compared to volatile type.
> > 
> > Right, asm volatile () means that the asm may not be discarted. Very
> > different from the volatile type qualifier.
> > 
> > > > b) smp_wmb() in some cases worked and in 
> > > > other cases jut optimized away the global reference.
> > > 
> > > Linux barriers aren't going to force a load to be emitted, if it can be
> > > optimized away. If it optimized away a store, then I'd like to see a
> > > test case.
> > 
> > Not sure - I think all barrier clobber the full register and memory set.
> > So if you access a variable after a barrier it will have to issue a
> > load.
> 
> Here is one example (which might or might not be what Nick had in mind):
> 
> 	extern int v;
> 
> 	void foo(void)
> 	{
> 		do_something_with(v);
> 		barrier();
> 		do_something_else_with(v - v);
> 	}
> 
> The second set of loads from v can be optimized away unless v is
> declared volatile.  In contrast:
> 
> 	void bar(void)
> 	{
> 		do_something_with(v);
> 		barrier();
> 		do_something_else_with(v);
> 	}
> 
> Here the compiler must refetch v after the barrier.

Ah, right. But in that case:

 v-v := tmp1 = v; tmp2 = v; sub tmp1,tmp2;

Which you can of course write out more explicitly in C as well and
insert a barrier between the two reads of v, giving the same effect as
volatile.

Still, point taken.

