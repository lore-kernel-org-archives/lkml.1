Return-Path: <linux-kernel-owner+w=401wt.eu-S1759771AbYHUOay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771AbYHUOay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYHUOal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:30:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55932 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbYHUOak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:30:40 -0400
Date: Thu, 21 Aug 2008 07:30:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4
	released
Message-ID: <20080821143024.GD6690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <48AD5A21.7020801@s5r6.in-berlin.de> <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com> <200808212337.38626.nickpiggin@yahoo.com.au> <1219327799.8651.134.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219327799.8651.134.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 04:09:59PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-08-21 at 23:37 +1000, Nick Piggin wrote:
> > On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:
> > 
> > > I used the smp_wmb() functions.  I noted a couple of things.  a) some of
> > > these macros just emit __asm__ __volatile__ into the code so why not just
> > > say "volatile" to begin with
> > 
> > It is not the same as volatile type. What it does is tell the compiler
> > to clobber all registers or temporaries. This something pretty well
> > defined and hard to get wrong compared to volatile type.
> 
> Right, asm volatile () means that the asm may not be discarted. Very
> different from the volatile type qualifier.
> 
> > > b) smp_wmb() in some cases worked and in 
> > > other cases jut optimized away the global reference.
> > 
> > Linux barriers aren't going to force a load to be emitted, if it can be
> > optimized away. If it optimized away a store, then I'd like to see a
> > test case.
> 
> Not sure - I think all barrier clobber the full register and memory set.
> So if you access a variable after a barrier it will have to issue a
> load.

Here is one example (which might or might not be what Nick had in mind):

	extern int v;

	void foo(void)
	{
		do_something_with(v);
		barrier();
		do_something_else_with(v - v);
	}

The second set of loads from v can be optimized away unless v is
declared volatile.  In contrast:

	void bar(void)
	{
		do_something_with(v);
		barrier();
		do_something_else_with(v);
	}

Here the compiler must refetch v after the barrier.

> Are we talking about different things?
> 
> > > c) I can go back and 
> > > break the code again by inserting them and building broken assembler d) I
> > > ave been doing hardware and software design since the early 1980;s, I
> > > invented SMP affinity scheduling, and yes, I understand barriers and this
> > > concept of instruction score-boarding and optimization very well -- its
> > > not an excuse for a busted C compiler.
> > 
> > The point is not whether it is possible to work with volatile types, but
> > that we tend not to use them in Linux to deal with concurrency.
> > 
> > Also, barriers seem to work fine for everybody else, so I think it is
> > likely you either aren't using them correctly, or have other bugs in the
> > code.
> 
> Well, there is of course the third option, which is what Jeff claims,
> that gcc is broken. But in that case we should have more problems
> elsewhere too.

Given the amount of code in gcc, we can reasonably assume that some
aspects of it are broken.  Whether that presumed breakage is affecting
Jeff is another question altogether.  ;-)

							Thanx, Paul
