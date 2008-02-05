Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYBEG5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYBEG5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYBEG5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:57:22 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:41661 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYBEG5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:57:21 -0500
Date: Mon, 4 Feb 2008 21:13:10 -0800
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
Message-ID: <20080205051310.GC8457@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1201682801.28547.162.camel@lappy> <Pine.LNX.4.58.0801300806100.29020@gandalf.stny.rr.com> <Pine.LNX.4.58.0801300856330.29020@gandalf.stny.rr.com> <1201703101.28547.224.camel@lappy> <20080201223413.GB9247@linux.vnet.ibm.com> <Pine.LNX.4.58.0802012012430.13664@gandalf.stny.rr.com> <20080202214124.GA28612@linux.vnet.ibm.com> <Pine.LNX.4.58.0802041153420.4119@gandalf.stny.rr.com> <20080204214023.GC29646@linux.vnet.ibm.com> <Pine.LNX.4.58.0802041650510.4454@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0802041650510.4454@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 05:03:47PM -0500, Steven Rostedt wrote:
> 
> On Mon, 4 Feb 2008, Paul E. McKenney wrote:
> > OK, will see what I can do...
> >
> > > On Sat, 2 Feb 2008, Paul E. McKenney wrote:
> > >
> > > > Yep, you have dependencies, so something like the following:
> > > >
> > > > initial state:
> > > >
> > > > 	struct foo {
> > > > 		int a;
> > > > 	};
> > > > 	struct foo x = { 0 };
> > > > 	struct foo y = { 0 };
> > > > 	struct foo *global_p = &y;
> > > > 	/* other variables are appropriately declared auto variables */
> > > >
> > > > 	/* No kmalloc() or kfree(), hence no RCU grace periods. */
> > > > 	/* In the terminology of http://lwn.net/Articles/262464/, we */
> > > > 	/* are doing only publish-subscribe, nothing else. */
> > > >
> > > > writer:
> > > >
> > > > 	x.a = 1;
> > > > 	smp_wmb();  /* or smp_mb() */
> > > > 	global_p = &x;
> > > >
> > > > reader:
> > > >
> > > > 	p = global_p;
> > > > 	ta = p->a;
> > > >
> > > > Both Alpha and aggressive compiler optimizations can result in the reader
> > > > seeing the new value of the pointer (&x) but the old value of the field
> > > > (0).  Strange but true.  The fix is as follows:
> > > >
> > > > reader:
> > > >
> > > > 	p = global_p;
> > > > 	smp_read_barrier_depends();  /* or use rcu_dereference() */
> > > > 	ta = p->a;
> > > >
> > > > So how can this happen?  First note that if smp_read_barrier_depends()
> > > > was unnecessary in this case, it would be unnecessary in all cases.
> > > >
> > > > Second, let's start with the compiler.  Suppose that a highly optimizing
> > > > compiler notices that in almost all cases, the reader finds p==global_p.
> > > > Suppose that this compiler also notices that one of the registers (say
> > > > r1) almost always contains this expected value of global_p, and that
> > > > cache pressure ensures that an actual load from global_p almost always
> > > > generates an expensive cache miss.  Such a compiler would be within its
> > > > rights (as defined by the C standard) to generate code assuming that r1
> > > > already had the right value, while also generating code to validate this
> > > > assumption, perhaps as follows:
> > > >
> > > > 	r2 = global_p;  /* high latency, other things complete meanwhile */
> > > > 	ta == r1->a;
> > > > 	if (r1 != r2)
> > > > 		ta = r2->a;
> > > >
> > > > Now consider the following sequence of events on a superscalar CPU:
> > >
> > > I think you missed one step here (causing my confusion). I don't want to
> > > assume so I'll try to put in the missing step:
> > >
> > > 	writer: r1 = p;  /* happens to use r1 to store parameter p */
> >
> > You lost me on this one...  The writer has only the following three steps:
> 
> You're right. I meant "writer:  r1 = x;"

OK, I understand.  You are correct, it would make more sense at the machine
level for the writer to do something like:

writer:

	r1 = &x;
	r1->a = 1;
	smp_wmb();  /* or smp_mb() */
	global_p = r1;

> > writer:
> >
> > 	x.a = 1;
> > 	smp_wmb();  /* or smp_mb() */
> > 	global_p = &x;
> >
> > Where did the "r1 = p" come from?  For that matter, where did "p" come
> > from?
> >
> > > > 	reader: r2 = global_p; /* issued, has not yet completed. */
> > > > 	reader: ta = r1->a; /* which gives zero. */
> > > > 	writer: x.a = 1;
> > > > 	writer: smp_wmb();
> > > > 	writer: global_p = &x;
> > > > 	reader: r2 = global_p; /* this instruction now completes */
> > > > 	reader: if (r1 != r2) /* and these are equal, so we keep bad ta! */
> > >
> > > Is that the case?
> >
> > Ah!  Please note that I am doing something unusual here in that I am
> > working with global variables, as opposed to the normal RCU practice of
> > dynamically allocating memory.  So "x" is just a global struct, not a
> > pointer to a struct.
> 
> But lets look at a simple version of my original code anyway ;-)

Fair enough!  ;-)

> Writer:
> 
> void add_op(struct myops *x) {
> 	/* x->next may be garbage here */
> 	x->next = global_p;
> 	smp_wmb();
> 	global_p = x;
> }
> 
> Reader:
> 
> void read_op(void)
> {
> 	struct myops *p = global_p;
> 
> 	while (p != NULL) {
> 		p->func();
> 		p = next;
> 		/* if p->next is garbage we crash */
> 	}
> }
> 
> 
> Here, we are missing the read_barrier_depends(). Lets look at the Alpha
> cache issue:
> 
> 
> reader reads the new version of global_p, and then reads the next
> pointer. But since the next pointer is on a different cacheline than
> global_p, it may have somehow had that in it's cache still. So it uses the
> old next pointer which contains the garbage.
> 
> Is that correct?

Indeed!  Changing the reader to be as follows should fix it:

Reader:

void read_op(void)
{
	struct myops *p = global_p;

	while (p != NULL) {
		smp_read_barrier_depends();
		p->func();
		p = next;
		/* if p->next is garbage we crash */
	}
}

> But I will have to admit, that I can't see how an aggressive compiler
> might have screwed this up. Being that x is a parameter, and the function
> add_op is not in a header file.

Ah...

Suppose that we have a compiler that uses profile-based feedback.
It compiles the kernel with profiling code that tracks the values of
pointers, whether function arguments or global variables.  All it need
do is look for repeated values, and then track the fraction of time
that the value occurs.  If a given value occurs (say) 99.999% of the
time, it might make sense for the compiler to simply guess the value
ahead of time.  Even more to the point, if the compiler determines
that an existing register already has the correct value 99.999% of
the time, we can simply use that register, then check that the value
was correct.

This might appear as follows:

	Reader:

	void read_op(void)
	{
		struct myops *p = global_p;

		while (p != NULL) {
			p->func();
			/* do stuff with r1 assuming r1==p->next. */
			r2 = p->next;
			if (r2 != r1)
				/* compensate somehow for guessing wrong. */
		}
	}

Insane?  Probably so.  But there are compiler guys who swear by it.

						Thanx, Paul
