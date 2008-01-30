Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbYA3OZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbYA3OZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbYA3OZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:25:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbYA3OZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:25:39 -0500
Subject: Re: [PATCH 02/22 -v7] Add basic support for gcc profiler
	instrumentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <Pine.LNX.4.58.0801300856330.29020@gandalf.stny.rr.com>
References: <20080130031521.258552785@goodmis.org>
	 <20080130031840.337019504@goodmis.org> <1201682801.28547.162.camel@lappy>
	 <Pine.LNX.4.58.0801300806100.29020@gandalf.stny.rr.com>
	 <Pine.LNX.4.58.0801300856330.29020@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 15:25:00 +0100
Message-Id: <1201703101.28547.224.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 09:09 -0500, Steven Rostedt wrote:
> Paul,
> 
> Peter and I are having a discussion on craziness of archs and memory
> barriers. You seem to understand crazy archs pretty well, and we would
> like some advice. :-)
> 
> See below:
> 
> On Wed, 30 Jan 2008, Steven Rostedt wrote:
> 
> >
> >
> > On Wed, 30 Jan 2008, Peter Zijlstra wrote:
> >
> > >
> > > On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:
> > >
> > > > +int register_mcount_function(struct mcount_ops *ops)
> > > > +{
> > > > +	unsigned long flags;
> > > > +
> > > > +	spin_lock_irqsave(&mcount_func_lock, flags);
> > > > +	ops->next = mcount_list;
> > > > +	/* must have next seen before we update the list pointer */
> > > > +	smp_wmb();
> > >
> > > That comment does not explain which race it closes; this is esp
> > > important as there is no paired barrier to give hints.
> >
> > OK, fair enough. I'll explain it a bit more.
> >
> > How's this:
> >
> >  /*
> >   * We are entering ops into the mcount_list but another
> >   * CPU might be walking that list. We need to make sure
> >   * the ops->next pointer is valid before another CPU sees
> >   * the ops pointer included into the mcount_list.
> >   */
> >
> 
> The above is my new comment. But Peter says that it's still not good
> enough and that all write memory barriers need read barriers.

To clarify, either: full mb, rmb or read depend.

> Let me explain the situation here.
> 
> We have a single link list called mcount_list that is walked when more
> than one function is registered by mcount. Mcount is called at the start
> of all C functions that are not annotated with "notrace". When more than
> one function is registered, mcount calls a loop function that does the
> following:
> 
> notrace void mcount_list_func(unsigned long ip, unsigned long parent_ip)
> {
>         struct mcount_ops *op = mcount_list;

When thinking RCU, this would be rcu_dereference and imply a read
barrier.

>         while (op != &mcount_list_end) {
>                 op->func(ip, parent_ip);
>                 op = op->next;

Same here; the rcu_dereference() would do the read depend barrier.

>         };
> }
> 
> A registered function must already have a "func" filled, and the mcount
> register code takes care of "next".  It is documented that the calling
> function should "never" change next and always expect that the func can be
> called after it is unregistered. That's not the issue here.
> 
> The issue is how to insert the ops into the list. I've done the following,
> as you can see in the code this text is inserted between.
> 
>    ops->next = mcount_list;
>    smp_wmb();
>    mcount_list = ops;
> 
> The read side pair is the reading of ops to ops->next, which should imply
> a smp_rmb() just by the logic. But Peter tells me things like alpha is
> crazy enough to do better than that! Thus, I'm asking you.
> 
> Can some arch have a reader where it receives ops->next before it received
> ops? This seems to me to be a phsyic arch, to know where ops->next is
> before it knows ops!
> 
> Remember, that the ops that is being registered, is not viewable by any
> other CPU until mcount_list = ops. I don't see the need for a read barrier
> in this case. But I could very well be wrong.
> 
> Help!
> 
> -- Steve
> 
> 
> >
> > >
> > > > +	mcount_list = ops;
> > > > +	/*
> > > > +	 * For one func, simply call it directly.
> > > > +	 * For more than one func, call the chain.
> > > > +	 */
> > > > +	if (ops->next == &mcount_list_end)
> > > > +		mcount_trace_function = ops->func;
> > > > +	else
> > > > +		mcount_trace_function = mcount_list_func;
> > > > +	spin_unlock_irqrestore(&mcount_func_lock, flags);
> > > > +
> > > > +	return 0;
> > > > +}
> > >
> > >
> > >
> >

