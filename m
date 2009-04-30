Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbZD3MWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbZD3MWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbZD3MWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:22:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46605 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386AbZD3MWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:22:08 -0400
Date: Thu, 30 Apr 2009 14:21:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
	around
Message-ID: <20090430122159.GB32751@elte.hu>
References: <200904291221.40361.knikanth@novell.com> <200904301541.11264.knikanth@novell.com> <20090430104729.GB6769@elte.hu> <200904301738.55301.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301738.55301.knikanth@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikanth Karthikesan <knikanth@novell.com> wrote:

> On Thursday 30 April 2009 16:17:29 Ingo Molnar wrote:
> > * Nikanth Karthikesan <knikanth@novell.com> wrote:
> > > > As a generic debug helper this is not appropriate i think -
> > > > counts can easily have a meaning when going negative as well.
> > > > (we have no signed-atomic primitives)
> > >
> > > This doesn't warn when it becomes negative/positive from zero, but
> > > only when it wraps around^W^Woverflows, trying to add past INT_MAX
> > > or subtract from INT_MIN.
> >
> > ah! The small difference between INT_MAX and UINT_MAX.
> >
> > Sure, this debug check makes a lot of sense. -mm even had such
> > stuff, many years ago? Never went upstream.
> >
> > > > >  static inline void atomic_inc(atomic_t *v)
> > > > >  {
> > > > > +#if defined(CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP)
> > > > > +	WARN_ON(atomic_add_unless(v, 1, INT_MAX) == 0);
> > > > > +#else
> > > > >  	asm volatile(LOCK_PREFIX "incl %0"
> > > > >
> > > > >  		     : "+m" (v->counter));
> > > > >
> > > > > +#endif
> > > > >  }
> > > >
> > > > also looks a bit ugly - this ugly #ifdef would spread into every
> > > > architecture.
> > > >
> > > > If we want to restrict atomic_t value ranges like that then the
> > > > clean solution would be to add generic wrappers doing the debug
> > > > (once, in generic code), and renaming the arch primitives to
> > > > raw_atomic_inc() (etc), doing the lowlevel bits cleanly.
> > >
> > > Here is a patch which does it this way.
> > >
> > > Thanks
> > > Nikanth
> > >
> > > Detect and warn on atomic_inc/atomic_dec overflow.
> > >
> > > Add a debug option to detect and warn when the 32-bit atomic_t overflows
> > > during atomic_inc and atomic_dec.
> > >
> > > diff --git a/arch/x86/include/asm/atomic_32.h
> > > b/arch/x86/include/asm/atomic_32.h index 85b46fb..c6a17bb 100644
> > > --- a/arch/x86/include/asm/atomic_32.h
> > > +++ b/arch/x86/include/asm/atomic_32.h
> > > @@ -78,24 +78,24 @@ static inline int atomic_sub_and_test(int i, atomic_t
> > > *v) }
> > >
> > >  /**
> > > - * atomic_inc - increment atomic variable
> > > + * raw_atomic_inc - increment atomic variable
> > >   * @v: pointer of type atomic_t
> > >   *
> > >   * Atomically increments @v by 1.
> > >   */
> > > -static inline void atomic_inc(atomic_t *v)
> > > +static inline void raw_atomic_inc(atomic_t *v)
> > >  {
> > >  	asm volatile(LOCK_PREFIX "incl %0"
> > >
> > >  		     : "+m" (v->counter));
> > >
> > >  }
> > >
> > >  /**
> > > - * atomic_dec - decrement atomic variable
> > > + * raw_atomic_dec - decrement atomic variable
> > >   * @v: pointer of type atomic_t
> > >   *
> > >   * Atomically decrements @v by 1.
> > >   */
> > > -static inline void atomic_dec(atomic_t *v)
> > > +static inline void raw_atomic_dec(atomic_t *v)
> > >  {
> > >  	asm volatile(LOCK_PREFIX "decl %0"
> > >
> > >  		     : "+m" (v->counter));
> > >
> > > diff --git a/arch/x86/include/asm/atomic_64.h
> > > b/arch/x86/include/asm/atomic_64.h index 8c21731..1183b85 100644
> > > --- a/arch/x86/include/asm/atomic_64.h
> > > +++ b/arch/x86/include/asm/atomic_64.h
> > > @@ -77,12 +77,12 @@ static inline int atomic_sub_and_test(int i, atomic_t
> > > *v) }
> > >
> > >  /**
> > > - * atomic_inc - increment atomic variable
> > > + * raw_atomic_inc - increment atomic variable
> > >   * @v: pointer of type atomic_t
> > >   *
> > >   * Atomically increments @v by 1.
> > >   */
> > > -static inline void atomic_inc(atomic_t *v)
> > > +static inline void raw_atomic_inc(atomic_t *v)
> > >  {
> > >  	asm volatile(LOCK_PREFIX "incl %0"
> > >
> > >  		     : "=m" (v->counter)
> > >
> > > @@ -90,12 +90,12 @@ static inline void atomic_inc(atomic_t *v)
> > >  }
> > >
> > >  /**
> > > - * atomic_dec - decrement atomic variable
> > > + * raw_atomic_dec - decrement atomic variable
> > >   * @v: pointer of type atomic_t
> > >   *
> > >   * Atomically decrements @v by 1.
> > >   */
> > > -static inline void atomic_dec(atomic_t *v)
> > > +static inline void raw_atomic_dec(atomic_t *v)
> > >  {
> > >  	asm volatile(LOCK_PREFIX "decl %0"
> > >
> > >  		     : "=m" (v->counter)
> > >
> > > diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
> > > index 7abdaa9..6eda22b 100644
> > > --- a/include/asm-generic/atomic.h
> > > +++ b/include/asm-generic/atomic.h
> > > @@ -4,15 +4,52 @@
> > >   * Copyright (C) 2005 Silicon Graphics, Inc.
> > >   *	Christoph Lameter
> > >   *
> > > - * Allows to provide arch independent atomic definitions without the
> > > need to - * edit all arch specific atomic.h files.
> > >   */
> > >
> > > +#include <linux/kernel.h>
> > >  #include <asm/types.h>
> > > +#include <asm/bug.h>
> > > +
> > > +#if defined(CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP)
> >
> > #ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP

you missed this feedback :-)

	Ingo
