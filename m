Return-Path: <linux-kernel-owner+w=401wt.eu-S935120AbYBBVmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935120AbYBBVmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYBBVmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:42:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39449 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYBBVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:42:05 -0500
Date: Sat, 2 Feb 2008 13:41:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Subject: Re: [PATCH 02/22 -v7] Add basic support for gcc profiler instrumentation
Message-ID: <20080202214124.GA28612@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080130031521.258552785@goodmis.org> <20080130031840.337019504@goodmis.org> <1201682801.28547.162.camel@lappy> <Pine.LNX.4.58.0801300806100.29020@gandalf.stny.rr.com> <Pine.LNX.4.58.0801300856330.29020@gandalf.stny.rr.com> <1201703101.28547.224.camel@lappy> <20080201223413.GB9247@linux.vnet.ibm.com> <Pine.LNX.4.58.0802012012430.13664@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0802012012430.13664@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 08:56:12PM -0500, Steven Rostedt wrote:
> 
> 
> On Fri, 1 Feb 2008, Paul E. McKenney wrote:
> 
> > > > > OK, fair enough. I'll explain it a bit more.
> > > > >
> > > > > How's this:
> > > > >
> > > > >  /*
> > > > >   * We are entering ops into the mcount_list but another
> > > > >   * CPU might be walking that list. We need to make sure
> > > > >   * the ops->next pointer is valid before another CPU sees
> > > > >   * the ops pointer included into the mcount_list.
> > > > >   */
> > > > >
> > > >
> > > > The above is my new comment. But Peter says that it's still not good
> > > > enough and that all write memory barriers need read barriers.
> > >
> > > To clarify, either: full mb, rmb or read depend.
> >
> > This is true.  A write barrier ensures that the writes remain ordered,
> > but unless the reads are also ordered, the reader can still get confused.
> > For example (assuming all variables are initially zero):
> >
> > writer:
> >
> > 	a = 1;
> > 	smp_wmb();  /* or smp_mb() */
> > 	b = 1;
> >
> > reader:
> >
> > 	tb = b;
> > 	ta = a;
> >
> > The writer will (roughly speaking) execute the assignments in order,
> > but the reader might not.  If the reader executes the assignment from
> > "a" first, it might see tb==1&&ta==0.  To prevent this, we do:
> >
> > reader:
> >
> > 	tb = b;
> > 	smp_rmb();  /* or smp_mb() */
> > 	ta = a;
> >
> > There are a lot of variations on this theme.
> 
> Yep, this is all clear, but not quite what this code does.

Yep, you have dependencies, so something like the following:

initial state:

	struct foo {
		int a;
	};
	struct foo x = { 0 };
	struct foo y = { 0 };
	struct foo *global_p = &y;
	/* other variables are appropriately declared auto variables */

	/* No kmalloc() or kfree(), hence no RCU grace periods. */
	/* In the terminology of http://lwn.net/Articles/262464/, we */
	/* are doing only publish-subscribe, nothing else. */

writer:

	x.a = 1;
	smp_wmb();  /* or smp_mb() */
	global_p = &x;

reader:

	p = global_p;
	ta = p->a;

Both Alpha and aggressive compiler optimizations can result in the reader
seeing the new value of the pointer (&x) but the old value of the field
(0).  Strange but true.  The fix is as follows:

reader:

	p = global_p;
	smp_read_barrier_depends();  /* or use rcu_dereference() */
	ta = p->a;

So how can this happen?  First note that if smp_read_barrier_depends()
was unnecessary in this case, it would be unnecessary in all cases.

Second, let's start with the compiler.  Suppose that a highly optimizing
compiler notices that in almost all cases, the reader finds p==global_p.
Suppose that this compiler also notices that one of the registers (say
r1) almost always contains this expected value of global_p, and that
cache pressure ensures that an actual load from global_p almost always
generates an expensive cache miss.  Such a compiler would be within its
rights (as defined by the C standard) to generate code assuming that r1
already had the right value, while also generating code to validate this
assumption, perhaps as follows:

	r2 = global_p;  /* high latency, other things complete meanwhile */
	ta == r1->a;
	if (r1 != r2)
		ta = r2->a;

Now consider the following sequence of events on a superscalar CPU:

	reader: r2 = global_p; /* issued, has not yet completed. */
	reader: ta = r1->a; /* which gives zero. */
	writer: x.a = 1;
	writer: smp_wmb();
	writer: global_p = &x;
	reader: r2 = global_p; /* this instruction now completes */
	reader: if (r1 != r2) /* and these are equal, so we keep bad ta! */

I have great sympathy with the argument that this level of optimization
is simply insane, but the fact is that there are real-world compilers
that actually do this sort of thing.  In addition, there are cases where
the compiler might be able to figure out that a value is constant, thus
breaking the dependency chain.  This is most common for array references
where the compiler might be able to figure out that a given array index
is always zero, thus optimizing away the load and the dependency that
the programmer might expect to enforce ordering.  (I have an example
of this down at the end.)

This sort of misordering is also done by DEC Alpha hardware, assuming
split caches.  This can happen if the variable x is in an odd-numbered
cache line and the variable global_p is in an even-numbered cache line.
In this case, the smp_wmb() affects the memory order, but only within
the writing CPU.  The ordering can be defeated in the reading CPU as
follows:

	writer: x.a = 1;
	writer: smp_wmb();
	writer: global_p = &x;
	reader: p = global_p;
	reader: ta = p->a;

		But the reader's odd-numbered cache shard is loaded
		down with many queued cacheline invalidation requests,
		so the old cached version of x.a==0 remains in the
		reader's cache, so that the reader sees ta==0.

In contrast:

	writer: x.a = 1;
	writer: smp_wmb();
	writer: global_p = &x;
	reader: p = global_p;
	reader: smp_read_barrier_depends();

		The above barrier forces all cacheline invalidation
		requests that have arrived at the reading CPU to be
		processed  before any subsequent reads, including
		the pending invalidation request for the variable x.

	reader: ta = p->a;

		So ta is now guaranteed to be 1, as desired.

> > > > Let me explain the situation here.
> > > >
> > > > We have a single link list called mcount_list that is walked when more
> > > > than one function is registered by mcount. Mcount is called at the start
> > > > of all C functions that are not annotated with "notrace". When more than
> > > > one function is registered, mcount calls a loop function that does the
> > > > following:
> > > >
> > > > notrace void mcount_list_func(unsigned long ip, unsigned long parent_ip)
> > > > {
> > > >         struct mcount_ops *op = mcount_list;
> > >
> > > When thinking RCU, this would be rcu_dereference and imply a read
> > > barrier.
> > >
> > > >         while (op != &mcount_list_end) {
> > > >                 op->func(ip, parent_ip);
> > > >                 op = op->next;
> > >
> > > Same here; the rcu_dereference() would do the read depend barrier.
> >
> > Specifically:
> >
> > notrace void mcount_list_func(unsigned long ip, unsigned long parent_ip)
> > {
> >         struct mcount_ops *op = rcu_dereference(mcount_list);
> >
> >         while (op != &mcount_list_end) {
> >                 op->func(ip, parent_ip);
> >                 op = rcu_dereference(op->next);
> >
> > This assumes that you are using call_rcu(), synchronize_rcu(), or
> > whatever to defer freeing/reuse of the ops structure.
> 
> One special part of this is that the ops structure is never to be freed
> (this is documented). It should be a static read-mostly structure.
> Since it is not to be freed, I did not export the registered functions to
> keep modules from using it. I may later add an export that will cause the
> module to increment it's usage count so that it may never be freed.
> 
> There's no guarantees that prevent the func from being called after it was
> unregistered, nor should the users of this, ever touch the "next" pointer.
> 
> This makes things easy when you don't need to free ;-)

It can indeed make things easier, but it does not help in this case.
This memory-ordering problem appears even if you never free anything, as
described above.  Again, in the terminology laid out in the LWN article
at http://lwn.net/Articles/262464/, you are doing a publish-subscribe
operation, and it still must be protected.

But yes, my comment above about using call_rcu() and friends did in fact
incorrectly assume that you were freeing (or otherwise re-using) the
data structures.

> > > >         };
> > > > }
> > > >
> > > > A registered function must already have a "func" filled, and the mcount
> > > > register code takes care of "next".  It is documented that the calling
> > > > function should "never" change next and always expect that the func can be
> > > > called after it is unregistered. That's not the issue here.
> > > >
> > > > The issue is how to insert the ops into the list. I've done the following,
> > > > as you can see in the code this text is inserted between.
> > > >
> > > >    ops->next = mcount_list;
> > > >    smp_wmb();
> > > >    mcount_list = ops;
> > > >
> > > > The read side pair is the reading of ops to ops->next, which should imply
> > > > a smp_rmb() just by the logic. But Peter tells me things like alpha is
> > > > crazy enough to do better than that! Thus, I'm asking you.
> >
> > Peter is correct when he says that Alpha does not necessarily respect data
> > dependencies.  See the following URL for the official story:
> >
> > 	http://www.openvms.compaq.com/wizard/wiz_2637.html
> >
> > And I give an example hardware cache design that can result in this
> > situation here:
> >
> > 	http://www.rdrop.com/users/paulmck/scalability/paper/ordering.2007.09.19a.pdf
> >
> > See the discussion starting with the "Why Reorder Memory Accesses?"
> > heading in the second column of the first page.
> >
> > Strange, but true.  It took an Alpha architect quite some time to
> > convince me of this back in the late 90s.  ;-)
> >
> > > > Can some arch have a reader where it receives ops->next before it received
> > > > ops? This seems to me to be a phsyic arch, to know where ops->next is
> > > > before it knows ops!
> >
> > The trick is that the machine might have a split cache, with (say)
> > odd-numbered cache lines being processed by one half and even-numbered
> > lines processed by the other half.  If reading CPU has one half of the
> > cache extremely busy (e.g., processing invalidation requests from other
> > CPUs) and the other half idle, memory misordering can happen in the
> > receiving CPU -- if the pointer is processed by the idle half, and
> > the pointed-to struct by the busy half, you might see the unitialized
> > contents of the pointed-to structure.  The reading CPU must execute
> > a memory barrier to force ordering in this case.
> >
> > > > Remember, that the ops that is being registered, is not viewable by any
> > > > other CPU until mcount_list = ops. I don't see the need for a read barrier
> > > > in this case. But I could very well be wrong.
> >
> > And I was right there with you before my extended discussions with the
> > aforementioned Alpha architect!
> 
> hmm, I'm still not convinced ;-)
> 
> This is a unique situation. We don't need to worry about items being freed
> because there's too many races to allow that. The items are only to
> register functions and are not to be dynamically allocated or freed. In
> this situation we do not need to worry about deletions.
> 
> The smp_wmb is only for initialization of something that is about to enter
> the list. It is not to protect against freeing.

Similarly, the smp_read_barrier_depends() is only for initialization
of something that is about to enter the list.  As with the smp_wmb()
primitive, smp_read_barrier_depends() also is not to protect against
freeing.  Instead, it is rcu_read_lock() and rcu_read_unlock() that
protect against freeing.

> Specifically:
> 
>    ops->next = mcount_list;
>    smp_wmb();
>    mcount_list = ops;
> 
> What this is to prevent is a new item that has next = NULL being viewable
> to other CPUS before next is initalized.

Were it not for aggressive compiler optimizations and DEC Alpha, you would
be correct.  What this instead does is to do the writer's part of the job
of preventing such new items from being visible to other CPUs before ->next
is initialized.  These other CPUs must do their part as well, and that
part is smp_read_barrier_depends() -- or rcu_dereference(), whichever is
most appropriate.

> On another cpu we have (simplified by removing loop):
> 
>   op = mcount_list;
>   op->func();
>   op = op->next;
>   if (op->next != NULL)
>      op->func;
> 
> What we want to prevent is reading of the new ops before ops->next is set.

Understood.

> What you are saying is that on alpha, even though the write to ops->next
> has completed before mcount_list is set, we can still get a reversed
> order?

That is exactly what I am saying.  In addition, I am saying that
aggressive compiler optimizations can have this same effect, even on
non-Alpha CPUs.

>   ops->next = mcount_list;  -- in one cache line
>   smp_wmb();
>   mcount_list = ops;       -- in another cache line
> 
> Even though the ops->next is completed, we can have on another cpu:
> 
>    op = mcount_list; (which is the ops from above)
>    op = op->next;  -- still see the old ops->next?

Yes, this bizarre sequence of events really can happen.  The fix is to
do the following:

   op = mcount_list; (which is the ops from above)
   smp_read_barrier_depends();
   op = op->next;  -- no longer see the old ops->next

> I just want to understand this. I already put in the read_barrier_depends
> because it doesn't hurt on most archs anyway (nops).

Very good!!!

And here is the example using array indexes.

initial state:

	struct foo {
		int a;
	};
	struct foo x[ARRAY_SIZE] = { 0 };
	struct foo *global_p = &x[0];
	/* other variables are appropriately declared auto variables */

	/* No kmalloc() or kfree(), hence no RCU grace periods. */
	/* In the terminology of http://lwn.net/Articles/262464/, we */
	/* are doing only publish-subscribe, nothing else. */

writer:

	x[cur_idx].a = 1;
	smp_wmb();  /* or smp_mb() */
	global_idx = cur_idx;

reader:

	i = global_idx;
	ta = x[i].a

Suppose we have ARRAY_SIZE of 1.  Then the standard states that the
results of indexing x[] with a non-zero index are undefined.  Since they
are undefined, the compiler is within its rights to assume that the
index will always be zero, so that the reader code would be as follows:

reader:

	ta = x[0].a

No dependency, no ordering.  So this totally reasonable generated code
could see the pre-initialized value of field a.  The job of both
smp_read_barrier_depends() and rcu_dereference() is to tell both the
CPU and the compiler that such assumptions are ill-advised.

							Thanx, Paul

> Thanks,
> 
> -- Steve
> 
> 
