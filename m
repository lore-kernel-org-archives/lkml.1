Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYBAWel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYBAWel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbYBAWee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:34:34 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40949 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbYBAWed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:34:33 -0500
Date: Fri, 1 Feb 2008 14:34:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 02/22 -v7] Add basic support for gcc profiler instrumentation
Message-ID: <20080201223413.GB9247@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080130031521.258552785@goodmis.org> <20080130031840.337019504@goodmis.org> <1201682801.28547.162.camel@lappy> <Pine.LNX.4.58.0801300806100.29020@gandalf.stny.rr.com> <Pine.LNX.4.58.0801300856330.29020@gandalf.stny.rr.com> <1201703101.28547.224.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201703101.28547.224.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 03:25:00PM +0100, Peter Zijlstra wrote:
> 
> On Wed, 2008-01-30 at 09:09 -0500, Steven Rostedt wrote:
> > Paul,
> > 
> > Peter and I are having a discussion on craziness of archs and memory
> > barriers. You seem to understand crazy archs pretty well, and we would
> > like some advice. :-)

OK, let's see what we have here...

> > See below:
> > 
> > On Wed, 30 Jan 2008, Steven Rostedt wrote:
> > 
> > >
> > >
> > > On Wed, 30 Jan 2008, Peter Zijlstra wrote:
> > >
> > > >
> > > > On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:
> > > >
> > > > > +int register_mcount_function(struct mcount_ops *ops)
> > > > > +{
> > > > > +	unsigned long flags;
> > > > > +
> > > > > +	spin_lock_irqsave(&mcount_func_lock, flags);
> > > > > +	ops->next = mcount_list;
> > > > > +	/* must have next seen before we update the list pointer */
> > > > > +	smp_wmb();
> > > >
> > > > That comment does not explain which race it closes; this is esp
> > > > important as there is no paired barrier to give hints.
> > >
> > > OK, fair enough. I'll explain it a bit more.
> > >
> > > How's this:
> > >
> > >  /*
> > >   * We are entering ops into the mcount_list but another
> > >   * CPU might be walking that list. We need to make sure
> > >   * the ops->next pointer is valid before another CPU sees
> > >   * the ops pointer included into the mcount_list.
> > >   */
> > >
> > 
> > The above is my new comment. But Peter says that it's still not good
> > enough and that all write memory barriers need read barriers.
> 
> To clarify, either: full mb, rmb or read depend.

This is true.  A write barrier ensures that the writes remain ordered,
but unless the reads are also ordered, the reader can still get confused.
For example (assuming all variables are initially zero):

writer:

	a = 1;
	smp_wmb();  /* or smp_mb() */
	b = 1;

reader:

	tb = b;
	ta = a;

The writer will (roughly speaking) execute the assignments in order,
but the reader might not.  If the reader executes the assignment from
"a" first, it might see tb==1&&ta==0.  To prevent this, we do:

reader:

	tb = b;
	smp_rmb();  /* or smp_mb() */
	ta = a;

There are a lot of variations on this theme.

> > Let me explain the situation here.
> > 
> > We have a single link list called mcount_list that is walked when more
> > than one function is registered by mcount. Mcount is called at the start
> > of all C functions that are not annotated with "notrace". When more than
> > one function is registered, mcount calls a loop function that does the
> > following:
> > 
> > notrace void mcount_list_func(unsigned long ip, unsigned long parent_ip)
> > {
> >         struct mcount_ops *op = mcount_list;
> 
> When thinking RCU, this would be rcu_dereference and imply a read
> barrier.
> 
> >         while (op != &mcount_list_end) {
> >                 op->func(ip, parent_ip);
> >                 op = op->next;
> 
> Same here; the rcu_dereference() would do the read depend barrier.

Specifically:

notrace void mcount_list_func(unsigned long ip, unsigned long parent_ip)
{
        struct mcount_ops *op = rcu_dereference(mcount_list);

        while (op != &mcount_list_end) {
                op->func(ip, parent_ip);
                op = rcu_dereference(op->next);

This assumes that you are using call_rcu(), synchronize_rcu(), or
whatever to defer freeing/reuse of the ops structure.

> >         };
> > }
> > 
> > A registered function must already have a "func" filled, and the mcount
> > register code takes care of "next".  It is documented that the calling
> > function should "never" change next and always expect that the func can be
> > called after it is unregistered. That's not the issue here.
> > 
> > The issue is how to insert the ops into the list. I've done the following,
> > as you can see in the code this text is inserted between.
> > 
> >    ops->next = mcount_list;
> >    smp_wmb();
> >    mcount_list = ops;
> > 
> > The read side pair is the reading of ops to ops->next, which should imply
> > a smp_rmb() just by the logic. But Peter tells me things like alpha is
> > crazy enough to do better than that! Thus, I'm asking you.

Peter is correct when he says that Alpha does not necessarily respect data
dependencies.  See the following URL for the official story:

	http://www.openvms.compaq.com/wizard/wiz_2637.html

And I give an example hardware cache design that can result in this
situation here:

	http://www.rdrop.com/users/paulmck/scalability/paper/ordering.2007.09.19a.pdf

See the discussion starting with the "Why Reorder Memory Accesses?"
heading in the second column of the first page.

Strange, but true.  It took an Alpha architect quite some time to
convince me of this back in the late 90s.  ;-)

> > Can some arch have a reader where it receives ops->next before it received
> > ops? This seems to me to be a phsyic arch, to know where ops->next is
> > before it knows ops!

The trick is that the machine might have a split cache, with (say)
odd-numbered cache lines being processed by one half and even-numbered
lines processed by the other half.  If reading CPU has one half of the
cache extremely busy (e.g., processing invalidation requests from other
CPUs) and the other half idle, memory misordering can happen in the
receiving CPU -- if the pointer is processed by the idle half, and
the pointed-to struct by the busy half, you might see the unitialized
contents of the pointed-to structure.  The reading CPU must execute
a memory barrier to force ordering in this case.

> > Remember, that the ops that is being registered, is not viewable by any
> > other CPU until mcount_list = ops. I don't see the need for a read barrier
> > in this case. But I could very well be wrong.

And I was right there with you before my extended discussions with the
aforementioned Alpha architect!

						Thanx, Paul

> > Help!
> > 
> > -- Steve
> > 
> > 
> > >
> > > >
> > > > > +	mcount_list = ops;
> > > > > +	/*
> > > > > +	 * For one func, simply call it directly.
> > > > > +	 * For more than one func, call the chain.
> > > > > +	 */
> > > > > +	if (ops->next == &mcount_list_end)
> > > > > +		mcount_trace_function = ops->func;
> > > > > +	else
> > > > > +		mcount_trace_function = mcount_list_func;
> > > > > +	spin_unlock_irqrestore(&mcount_func_lock, flags);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > >
> > > >
> > > >
> > >
> 
