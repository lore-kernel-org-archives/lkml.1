Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbXGNRbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbXGNRbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbXGNRbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:31:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45573 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630AbXGNRbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:31:43 -0400
Subject: Re: [PATCH -rt 3/5] asm/local.h cmpxchg
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070714171401.GB6975@Krystal>
References: <20070714175733.194012000@chello.nl>
	 <20070714175839.921317000@chello.nl>  <20070714171401.GB6975@Krystal>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 19:31:13 +0200
Message-Id: <1184434273.5284.47.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 13:14 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > From: Christoph Lameter <clameter@sgi.com>
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  include/asm-generic/local.h |   25 +++++++++++++++++++++++--
> >  include/asm-i386/local.h    |   13 +++++++++++++
> >  include/asm-x86_64/local.h  |   16 ++++++++++++++++
> >  3 files changed, 52 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.22-rc6-mm1/include/asm-generic/local.h
> > ===================================================================
> > --- linux-2.6.22-rc6-mm1.orig/include/asm-generic/local.h	2007-07-12 19:44:18.000000000 -0700
> > +++ linux-2.6.22-rc6-mm1/include/asm-generic/local.h	2007-07-12 19:44:57.000000000 -0700
> > @@ -46,13 +46,34 @@ typedef struct
> >  #define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
> >  #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
> >  
> > -/* Non-atomic variants, ie. preemption disabled and won't be touched
> > - * in interrupt, etc.  Some archs can optimize this case well. */
> > +/*
> > + * Establish a state necessary for __local_xx functions to work.
> > + */
> > +#define __local_begin(flags)	local_irq_disable(flags)
> > +
> > +static inline void __local_end(unsigned long flags)
> > +{
> > +	local_irq_restore(flags);
> > +}
> > +
> 
> Wouldn't it be cheaper to use preempt_disable/enable instead of irq
> disable/enable in asm-generic to protect the __local accesses since they
> are not supposed to be touched by interrupt context ?
> 
> I also think that __local_begin/end() should be changed into
> local_begin() and local_end(). It makes sense to use this around all
> local_t variable accesses.
> 
> > +/*
> > + * Non-atomic variants, ie. within local_begin() / local_end() or
> > + * preempt_disable / enable() and won't be touched in interrupt, etc.
> > + * Some archs can optimize this case well.
> > + */
> >  #define __local_inc(l)		local_set((l), local_read(l) + 1)
> >  #define __local_dec(l)		local_set((l), local_read(l) - 1)
> >  #define __local_add(i,l)	local_set((l), local_read(l) + (i))
> >  #define __local_sub(i,l)	local_set((l), local_read(l) - (i))
> >  
> > +#define __local_cmpxchg((v), (o), (n)) (*(v) = (n), (o))
> 
> Shouldn't this look like a while loop instead ? Where is the
> comparison ? It should use local_set and local_read...

Yeah, needs more thought.

> The proper way to do this would be to take all architectures that only
> define a atomic_cmpxchg and atomic_xchg and turn that into a cmpxchg and
> xchg. Then, the same could be done for architectures which only have a
> local_cmpxchg, but no cmpxchg_local.
> 
> Then, cmpxchg_local could be used to touch a variable in an atomic wrt
> cpu fashion without wrapping the variable in a local_t.
> 
> All the local_*() functions should only touch local_t types.
> 
> If local_begin()/local_end() is defined as preempt disable/enable, then
> it's ok to use this to protect __local_*() accesses. However, if you
> turn this into a migrate_disable/enable(), then the protection against
> other threads on the same CPU is not insured.

Yeah, the generic stuff is rather broken. For -rt begin/end should map
to migrate_disable/enable, and the primitives could be done using
preempt_disable/enable.

something like so:

static inline void local_begin(flags)
{
	migrate_disable();
}

static inline void local_end(flags)
{
	migrate_enable();
}

#define __local_cmpxchg(__p, __o, __n)		\
({	typeof(__o) o;				\
	preempt_disable();			\
	o = *(__p);				\
	if (o == (__o))				\
		*(__p) = __n;			\
	preempt_enable();			\
	o; })


Obviously that only works for -rt.

