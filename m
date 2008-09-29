Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYI2BnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYI2BnE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 21:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYI2Bmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 21:42:54 -0400
Received: from relais.videotron.ca ([24.201.245.36]:29683 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbYI2Bmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 21:42:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 28 Sep 2008 21:42:45 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
In-reply-to: <1222431635.16700.278.camel@lappy.programming.kicks-ass.net>
Message-id: <alpine.LFD.2.00.0809282123100.3635@xanadu.home>
References: <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
 <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.2.00.0809260802310.3635@xanadu.home>
 <1222431635.16700.278.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008, Peter Zijlstra wrote:

> On Fri, 2008-09-26 at 08:03 -0400, Nicolas Pitre wrote:
> > On Fri, 26 Sep 2008, Peter Zijlstra wrote:
> > 
> > > On Wed, 2008-09-24 at 17:48 +0100, David Howells wrote:
> > > > Move asm-arm/cnt32_to_63.h to include/linux/ so that MN10300 can make use of it
> > > > too.
> > > > 
> > > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > > ---
> > > > 
> > > >  arch/arm/mach-pxa/time.c       |    2 +
> > > >  arch/arm/mach-sa1100/generic.c |    2 +
> > > >  arch/arm/mach-versatile/core.c |    2 +
> > > >  include/linux/cnt32_to_63.h    |   80 ++++++++++++++++++++++++++++++++++++++++
> > > >  4 files changed, 83 insertions(+), 3 deletions(-)
> > > >  create mode 100644 include/linux/cnt32_to_63.h
> > > 
> > > Didn't you forget to remove the old one?
> > > 
> > > 
> > > > +#define cnt32_to_63(cnt_lo) \
> > > > +({ \
> > > > +	static volatile u32 __m_cnt_hi; \
> > > > +	union cnt32_to_63 __x; \
> > > > +	__x.hi = __m_cnt_hi; \
> > > > +	__x.lo = (cnt_lo); \
> > > > +	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
> > > > +		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
> > > > +	__x.val; \
> > > > +})
> > > > +
> > > > +#endif
> > > 
> > > That code is way to smart :-)
> > > 
> > > Better make sure that non of its users are SMP capable though.
> > 
> > Why would that matter?
> 
> #define cnt32_to_63(cnt_lo)
> ({
> 	static DEFINE_PER_CPU(u32, __m_cnt_hi);
> 
>        union cnt32_to_63 __x;
> 	u32 *__m_cnt_hi_ptr = &get_cpu_var(__m_cnt_hi);

Nope.  That disables preemption which is against the purpose of this 
code.  Disabling preemption is unneeded.

> 	__x.hi = *__m_cnt_hi_ptr;
> 	__x.lo = (cnt_lo);
> 
> 	if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
> 		*__m_cnt_hi_ptr = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);
> 
> 	put_cpu_var(__m_cnt_hi);
> 
> 	__x.val;
> })
> 
> And I'm not quite sure why you had volatile in there.. but that should
> be replaced by a barrier().

That's to ensure that __x.hi is always (re)read before __x.lo, and not 
factorized out of a possible outer loop if gcc felt like doing such an 
optimization.  However I didn't want other unrelated variables to be 
affected by an undiscriminating barrier().  But that's a weak argument 
as I suspect in most case inserting a barrier() between the 2 reads will 
generate the same code.

> Also, we could probably use __get_cpu_var() and put BUG_ON(!in_atomic())
> in there since if this stuff is per cpu, it'd better be atomic anyway -
> you don't want to read a different cpu's counter than the one you're
> using to upgrade.

But again, the original code had no such restriction.  It works with 
mixed contexts.

If the base counter is per CPU, then the static variable has to be per 
CPU of course.  But if the base counter is global then the static 
variable should be shared by all CPUs unless you can guarantee that all 
CPUs will always call this at least once per half period of the base 
counter.


Nicolas
