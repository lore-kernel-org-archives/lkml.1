Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbXFETCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbXFETCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXFETCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:02:06 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:43322 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393AbXFETCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:02:05 -0400
Date: Tue, 5 Jun 2007 15:02:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/9] Conditional Calls - i386 Optimization
Message-ID: <20070605190200.GB11996@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140228.349272966@polymtl.ca> <p73r6oxcd47.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p73r6oxcd47.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:40:31 up 8 days,  3:19,  6 users,  load average: 3.86, 3.38, 2.12
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > +#define cond_call_optimized(flags, name, func) \
> > +	({ \
> > +		static const char __cstrtab_name_##name[] \
> > +		__attribute__((section("__cond_call_strings"))) = #name; \
> > +		char condition; \
> > +		asm (	".section __cond_call, \"a\", @progbits;\n\t" \
> > +					".long %1, 0f, %2;\n\t" \
> > +					".previous;\n\t" \
> > +					".align 2\n\t" \
> > +					"0:\n\t" \
> > +					"movb %3,%0;\n\t" \
> > +				: "=r" (condition) \
> > +				: "m" (*__cstrtab_name_##name), \
> > +				  "m" (*(char*)flags), \
> > +				  "i" ((flags) & CF_STATIC_ENABLE)); \
> 
> Remind me what we need the flags again for? 
> 
> I would prefer to just eliminate them and always require arming.
> 

The CF_STATIC_ENABLE could be used to have a cond_call compiled as
active, and could be later desactivated dynamically. Since I don't see
much use to this, I will remove this flag.


> 
> > +		(likely(!condition)) ? \
> > +			(__typeof__(func))0 : \
> > +			(func); \
> > +	})
> > +
> > +/* cond_call macro selecting the generic or optimized version of cond_call,
> > + * depending on the flags specified. */
> > +#define _cond_call(flags, name, func) \
> > +({ \
> > +	(((flags) & CF_LOCKDEP) && ((flags) & CF_OPTIMIZED)) ? \
> 
> Similar here? unoptimized condcalls don't make much sense.
> I also don't understand what the LOCKDEP flag is good for.
> 

unoptimized condcalls will now be a simple static variable usage (since
the new condcalls will simply be an infrastructure for synchronizing a
static variable with load immediates).


> > Index: linux-2.6-lttng/arch/i386/kernel/condcall.c
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-lttng/arch/i386/kernel/condcall.c	2007-05-17 01:52:38.000000000 -0400
> > @@ -0,0 +1,140 @@
> > +/* condcall.c
> > + *
> > + * - Erratum 49 fix for Intel PIII.
> > + * - Still present on newer processors : Intel Core 2 Duo Processor for Intel
> > + *   Centrino Duo Processor Technology Specification Update, AH33.
> > + *   Unsynchronized Cross-Modifying Code Operations Can Cause Unexpected
> > + *   Instruction Execution Results.
> 
> Can you please define a generic utility function to do self modifying
> code? There are other places that do it too.
> 

If you are talking about paravirt ops, they seem to only modify code
on the 1st CPU before other CPUs are turned on. But I might be wrong.

Also, there are 2 simplifications here which do not address the general
case. Those simplifications are done so I can use the cond_calls within
the markers in as many code paths as possible.

1 - When the breakpoint is used (x86), I simply skip the load immediate
instead of single-stepping the instruction. I can do this because I know
that the only effect that the load immediate has is to populate a
register. Since I make sure that I am doing a transition 0 <-> !0, I can
afford leaving this register in an unknown state during the transition.

2 - In order to patch the code on other architectures too, I have to
provide atomic instruction modification. It heavily depends on the
instruction size and their alignment. Once again, I would have to use
breakpoints and single-stepping to replace the instructions (in every
architecture), instead of doing a simple operation replacement with
memcpy.

Because I control the alignment and size of the instructions I replace,
I do not depend on breakpoints (except on x86-like architectures), which
makes things much more solid reentrancy-wise and lets me use the
condcalls within the markers in tricky code paths.

> > +static DEFINE_MUTEX(cond_call_mutex);
> 
> All locks need a comment describing what they protect and the hierarchy if 
> any.
> 
ok

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
