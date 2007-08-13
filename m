Return-Path: <linux-kernel-owner+w=401wt.eu-S966503AbXHMPi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966503AbXHMPi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972403AbXHMNtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:49:12 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:33377 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031707AbXHMNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:49:08 -0400
Date: Mon, 13 Aug 2007 09:43:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, schwidefsky@de.ibm.com,
       linux390@de.ibm.com
Subject: Re: [patch 17/23] Add cmpxchg_local to s390
Message-ID: <20070813134342.GA3713@Krystal>
References: <20070812145434.520271946@polymtl.ca> <20070812145841.788824151@polymtl.ca> <20070813083501.GA30198@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070813083501.GA30198@osiris.boeblingen.de.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:30:24 up 14 days, 13:49,  2 users,  load average: 1.64, 0.95, 0.68
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Heiko Carstens (heiko.carstens@de.ibm.com) wrote:
> On Sun, Aug 12, 2007 at 10:54:51AM -0400, Mathieu Desnoyers wrote:
> > Use the standard __cmpxchg for every type that can be updated atomically.
> > Use the new generic cmpxchg_local (disables interrupt) for other types.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: clameter@sgi.com
> > CC: schwidefsky@de.ibm.com
> > CC: linux390@de.ibm.com
> > ---
> >  include/asm-s390/system.h |   34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> > 
> > Index: linux-2.6-lttng/include/asm-s390/system.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/asm-s390/system.h	2007-08-10 16:16:21.000000000 -0400
> > +++ linux-2.6-lttng/include/asm-s390/system.h	2007-08-10 19:35:46.000000000 -0400
> > @@ -353,6 +353,40 @@ __cmpxchg(volatile void *ptr, unsigned l
> > 
> >  #include <linux/irqflags.h>
> > 
> > +#include <asm-generic/cmpxchg-local.h>
> > +
> > +static inline unsigned long __cmpxchg_local(volatile void *ptr,
> > +				      unsigned long old,
> > +				      unsigned long new, int size)
> > +{
> > +	switch (size) {
> > +	case 1:
> > +	case 2:
> > +	case 4:
> > +#ifdef __s390x__
> > +	case 8:
> > +#endif
> > +		return __cmpxchg(ptr, old, new, size);
> > +	default:
> > +		return __cmpxchg_local_generic(ptr, old, new, size);
> > +	}
> > +
> > +	return old;
> > +}
> > +
> > +/*
> > + * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
> > + * them available.
> > + */
> > +#define cmpxchg_local(ptr,o,n)						\
> > +     (__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
> > +			   	 (unsigned long)(n), sizeof(*(ptr)))
> > +#ifdef __s390x__
> > +#define cmpxchg64_local(ptr,o,n) cmpxchg_local((ptr),(o),(n))
> > +#else
> > +#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
> > +#endif
> > +
> 
> What's the reason to have cmpxchg64_local on 32 bit architectures?
> Without that need all this would just be a few simple defines.

cmpxchg64_local on 32 bits architectures takes unsigned long long
parameters, but cmpxchg_local only takes longs. Since we have cmpxchg8b
to execute a 8 byte cmpxchg atomically on pentium and +, it makes sense
to provide a flavor of cmpxchg and cmpxchg_local using this instruction.

Also, for 32 bits architectures lacking the 64 bits atomic cmpxchg, it
makes sense _not_ to define cmpxchg64 while cmpxchg could still be
available.

Moreover, the fallback for cmpxchg8b on i386 for 386 and 486 is a
different case than cmpxchg (which is only required for 386). Using
different code makes this easier.

However, cmpxchg64_local will be emulated by disabling interrupts on all
architectures where it is not supported atomically.

Therefore, we *could* turn cmpxchg64_local into a cmpxchg_local, but it
would make the 386/486 fallbacks ugly, make its design different from
cmpxchg/cmpxchg64 (which really depends on atomic operations and cannot
be emulated) and require the __cmpxchg_local to be expressed as a macro
rather than an inline function so the parameters would not be fixed to
unsigned long long in every case.

So I think cmpxchg64_local makes sense there, but I am open to
suggestions.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
