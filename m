Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYIZMVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYIZMVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYIZMUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:20:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:51751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYIZMUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:20:53 -0400
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to
	include/linux/
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nicolas Pitre <nico@cam.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0809260802310.3635@xanadu.home>
References: <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
	 <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.2.00.0809260802310.3635@xanadu.home>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 14:20:35 +0200
Message-Id: <1222431635.16700.278.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 08:03 -0400, Nicolas Pitre wrote:
> On Fri, 26 Sep 2008, Peter Zijlstra wrote:
> 
> > On Wed, 2008-09-24 at 17:48 +0100, David Howells wrote:
> > > Move asm-arm/cnt32_to_63.h to include/linux/ so that MN10300 can make use of it
> > > too.
> > > 
> > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > ---
> > > 
> > >  arch/arm/mach-pxa/time.c       |    2 +
> > >  arch/arm/mach-sa1100/generic.c |    2 +
> > >  arch/arm/mach-versatile/core.c |    2 +
> > >  include/linux/cnt32_to_63.h    |   80 ++++++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 83 insertions(+), 3 deletions(-)
> > >  create mode 100644 include/linux/cnt32_to_63.h
> > 
> > Didn't you forget to remove the old one?
> > 
> > 
> > > +#define cnt32_to_63(cnt_lo) \
> > > +({ \
> > > +	static volatile u32 __m_cnt_hi; \
> > > +	union cnt32_to_63 __x; \
> > > +	__x.hi = __m_cnt_hi; \
> > > +	__x.lo = (cnt_lo); \
> > > +	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
> > > +		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
> > > +	__x.val; \
> > > +})
> > > +
> > > +#endif
> > 
> > That code is way to smart :-)
> > 
> > Better make sure that non of its users are SMP capable though.
> 
> Why would that matter?

#define cnt32_to_63(cnt_lo)
({
	static DEFINE_PER_CPU(u32, __m_cnt_hi);

       union cnt32_to_63 __x;
	u32 *__m_cnt_hi_ptr = &get_cpu_var(__m_cnt_hi);

	__x.hi = *__m_cnt_hi_ptr;
	__x.lo = (cnt_lo);

	if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
		*__m_cnt_hi_ptr = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);

	put_cpu_var(__m_cnt_hi);

	__x.val;
})

And I'm not quite sure why you had volatile in there.. but that should
be replaced by a barrier().

Also, we could probably use __get_cpu_var() and put BUG_ON(!in_atomic())
in there since if this stuff is per cpu, it'd better be atomic anyway -
you don't want to read a different cpu's counter than the one you're
using to upgrade.

