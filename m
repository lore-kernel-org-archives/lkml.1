Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYKGIlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYKGIlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYKGIk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:40:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbYKGIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:40:58 -0500
Date: Fri, 7 Nov 2008 00:38:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-Id: <20081107003816.9b0f947a.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
References: <20081107052336.652868737@polymtl.ca>
	<20081107053349.861709786@polymtl.ca>
	<20081106220530.5b0e3a96.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811070256450.13034@xanadu.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 03:12:18 -0500 (EST) Nicolas Pitre <nico@cam.org> wrote:

> On Thu, 6 Nov 2008, Andrew Morton wrote:
> 
> > On Fri, 07 Nov 2008 00:23:44 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > >  #define cnt32_to_63(cnt_lo) \
> > >  ({ \
> > > -	static volatile u32 __m_cnt_hi; \
> > > +	static u32 __m_cnt_hi; \
> > >  	union cnt32_to_63 __x; \
> > >  	__x.hi = __m_cnt_hi; \
> > > +	smp_rmb(); 	/* read __m_cnt_hi before mmio cnt_lo */ \
> > >  	__x.lo = (cnt_lo); \
> > >  	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
> > >  		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
> > 
> > Oh dear.  We have a macro which secretly maintains
> > per-instantiation-site global state?  And doesn't even implement locking
> > to protect that state?
> 
> Please do me a favor and look for those very unfrequent posts I've sent 
> to lkml lately.

No.  Reading the kernel code (and, at a pinch, the changelogs) should
suffice.  If it does not suffice, the kernel code is in error.

>  I've explained it all at least 3 times so far, to Peter 
> Zijlstra, to David Howells, to Mathieu Desnoyers, and now to you.

If four heads have exploded (thus far) over one piece of code, perhaps
the blame doesn't lie with those heads.

> > I mean, the darned thing is called from sched_clock(), which can be
> > concurrently called on separate CPUs and which can be called from
> > interrupt context (with an arbitrary nesting level!) while it was running
> > in process context.
> 
> Yes!  And this is so on *purpose*.  Please take some time to read the 
> comment that goes along with it,

OK.

> and if you're still not convinced then 
> look for those explanation emails I've already posted.

No.

> > /*
> >  * Caller must provide locking to protect *caller_state
> >  */
> 
> NO!  This is meant to be LOCK FREE!

We have a macro which must only have a single usage in any particular
kernel build (and nothing to detect a violation of that).

We have a macro which secretly hides internal state, on a per-expansion-site
basis, no less.

It apparently tries to avoid races via ordering tricks, as long
as it is called with sufficient frequency.  But nothing guarantees
that it _is_ called sufficiently frequently?

There is absolutely no reason why the first two of these quite bad things
needed to be done.  In fact there is no reason why it needed to be
implemented as a macro at all.

As I said in the text which you deleted and ignored, this would be
better if it was implemented as a C function which requires that the
caller explicitly pass in a reference to the state storage.
