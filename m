Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbXGNSdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbXGNSdw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbXGNSdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:33:45 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:33277 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759305AbXGNSdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:33:44 -0400
Date: Sat, 14 Jul 2007 14:33:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -rt 3/5] asm/local.h cmpxchg
Message-ID: <20070714183342.GF6975@Krystal>
References: <20070714175733.194012000@chello.nl> <20070714175839.921317000@chello.nl> <20070714171401.GB6975@Krystal> <1184434273.5284.47.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1184434273.5284.47.camel@lappy>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:31:52 up 7 days,  8:37,  2 users,  load average: 0.26, 0.22, 0.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Sat, 2007-07-14 at 13:14 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > From: Christoph Lameter <clameter@sgi.com>
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > ---
> > >  include/asm-generic/local.h |   25 +++++++++++++++++++++++--
> > >  include/asm-i386/local.h    |   13 +++++++++++++
> > >  include/asm-x86_64/local.h  |   16 ++++++++++++++++
> > >  3 files changed, 52 insertions(+), 2 deletions(-)
> > > 
> > > Index: linux-2.6.22-rc6-mm1/include/asm-generic/local.h
> > > ===================================================================
> > > --- linux-2.6.22-rc6-mm1.orig/include/asm-generic/local.h	2007-07-12 19:44:18.000000000 -0700
> > > +++ linux-2.6.22-rc6-mm1/include/asm-generic/local.h	2007-07-12 19:44:57.000000000 -0700
> > > @@ -46,13 +46,34 @@ typedef struct
> > >  #define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
> > >  #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
> > >  
> > > -/* Non-atomic variants, ie. preemption disabled and won't be touched
> > > - * in interrupt, etc.  Some archs can optimize this case well. */
> > > +/*
> > > + * Establish a state necessary for __local_xx functions to work.
> > > + */
> > > +#define __local_begin(flags)	local_irq_disable(flags)
> > > +
> > > +static inline void __local_end(unsigned long flags)
> > > +{
> > > +	local_irq_restore(flags);
> > > +}
> > > +
> > 
> > Wouldn't it be cheaper to use preempt_disable/enable instead of irq
> > disable/enable in asm-generic to protect the __local accesses since they
> > are not supposed to be touched by interrupt context ?
> > 
> > I also think that __local_begin/end() should be changed into
> > local_begin() and local_end(). It makes sense to use this around all
> > local_t variable accesses.
> > 
> > > +/*
> > > + * Non-atomic variants, ie. within local_begin() / local_end() or
> > > + * preempt_disable / enable() and won't be touched in interrupt, etc.
> > > + * Some archs can optimize this case well.
> > > + */
> > >  #define __local_inc(l)		local_set((l), local_read(l) + 1)
> > >  #define __local_dec(l)		local_set((l), local_read(l) - 1)
> > >  #define __local_add(i,l)	local_set((l), local_read(l) + (i))
> > >  #define __local_sub(i,l)	local_set((l), local_read(l) - (i))
> > >  
> > > +#define __local_cmpxchg((v), (o), (n)) (*(v) = (n), (o))
> > 
> > Shouldn't this look like a while loop instead ? Where is the
> > comparison ? It should use local_set and local_read...
> 
> Yeah, needs more thought.
> 
> > The proper way to do this would be to take all architectures that only
> > define a atomic_cmpxchg and atomic_xchg and turn that into a cmpxchg and
> > xchg. Then, the same could be done for architectures which only have a
> > local_cmpxchg, but no cmpxchg_local.
> > 
> > Then, cmpxchg_local could be used to touch a variable in an atomic wrt
> > cpu fashion without wrapping the variable in a local_t.
> > 
> > All the local_*() functions should only touch local_t types.
> > 
> > If local_begin()/local_end() is defined as preempt disable/enable, then
> > it's ok to use this to protect __local_*() accesses. However, if you
> > turn this into a migrate_disable/enable(), then the protection against
> > other threads on the same CPU is not insured.
> 
> Yeah, the generic stuff is rather broken. For -rt begin/end should map
> to migrate_disable/enable, and the primitives could be done using
> preempt_disable/enable.
> 
> something like so:
> 
> static inline void local_begin(flags)
> {
> 	migrate_disable();
> }
> 
> static inline void local_end(flags)
> {
> 	migrate_enable();
> }
> 
> #define __local_cmpxchg(__p, __o, __n)		\
> ({	typeof(__o) o;				\
> 	preempt_disable();			\
> 	o = *(__p);				\
> 	if (o == (__o))				\
> 		*(__p) = __n;			\
> 	preempt_enable();			\
> 	o; })
> 

Nitpicking:

This should be named __cmpxchg_local(), since it does not apply to
local_t variables.

Also, it would not hurt to have __local_begin and __local_end around
__cmpxchg_local to offer an interface similar to local_begin and
local_end. Those two would map to preempt_disable/enable.

> 
> Obviously that only works for -rt.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
