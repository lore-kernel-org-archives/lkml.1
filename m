Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZDOMEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZDOMEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbZDOME3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:04:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43346 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759382AbZDOME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:04:27 -0400
Date: Wed, 15 Apr 2009 14:03:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Message-ID: <20090415120307.GB17775@elte.hu>
References: <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com> <14172.1239795632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14172.1239795632@redhat.com>
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


* David Howells <dhowells@redhat.com> wrote:

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > But yeah, I didn't look at all the details. It _looked_ pretty 
> > straightforward to just move the DEFINE/DECLARE stuff up, but 
> > there may well be something subtle I'm missing.
> 
> The problem is mainly one of #include recursion.  There's way too 
> much of it.

that should be mapped and eliminated then.

> I wonder if we should replace the standard headerfile boilerplate:
> 
> 	#ifndef _THIS_HEADER_H
> 	#define _THIS_HEADER_H
> 	...
> 	#endif /* _THIS_HEADER_H */
> 
> with something a bit nastier:
> 
> 	#ifndef _THIS_HEADER_H
> 	#define _THIS_HEADER_H 1
> 	...
> 	#undef _THIS_HEADER_H
> 	#define _THIS_HEADER_H 2
> 	#elif  _THIS_HEADER_H == 1
> 	#error Recursive inclusion is not permitted
> 	#endif /* _THIS_HEADER_H */
> 
> and make people break up their header files to avoid getting this 
> error.
> 
> There are a number of problems with doing this, of course; the 
> least of which is that cpp has special code for handling the first 
> case efficiently, IIRC.

The other problem with your scheme is that this does not make much 
sense.

There is absolutely _nothing_ wrong about defining structures in a 
hierarchical way! For example task_struct does have to combine a lot 
of derived types. It can use types directly and indirectly as well. 
Hierarchical data structures are _good_.

What _is_ wrong here is to allow inline functions _combine_ 
unrelated types randomly and 'mix up' an otherwise clean and logical 
hierarchy of data types.

The solution to this is the creation of a separate data versus 
method include file hiearchy: for example mm_types.h and 
spinlock_types.h.

Without having looked very deep into this particular problem you are 
hitting, this seems to be the problem here too.

There's three too 'thick' headers: linux/percpu.h, linux/prefetch.h 
and asm/processor.h.

include/linux/percpu.h, which provides essential data types and core 
primitives, also includes:

#include <linux/preempt.h>
#include <linux/slab.h> /* For kmalloc() */
#include <linux/smp.h>
#include <linux/cpumask.h>
#include <linux/pfn.h>

Just to be able to define an inline method:

static inline void *__alloc_percpu(size_t size, size_t align)
{
        /*
         * Can't easily make larger alignment work with kmalloc.  WARN
         * on it.  Larger alignment should only be used for module
         * percpu sections on SMP for which this path isn't used.
         */
        WARN_ON_ONCE(align > SMP_CACHE_BYTES);
        return kzalloc(size, GFP_KERNEL);
}

Tada - now we've the combined 'percpu' and 'slab' spaces, on a very 
low level! These kinds of cross-dependencies quickly explode and 
create circular dependencies the moment you try to include any of 
this supposedly-simple header below the 'level' of slab.

The solution for this one?

Please create include/linux/percpu_types.h for basic data types and 
simple, self-sufficient primitives. Also have an 
include/linux/percpu_api.h or include/linux/percpu.h include file 
for convenience/speedup inlines. The latter will only be included in 
.c files, where 'combination' of type spaces is not a problem. (it 
is a virtue there.)

We did this in a number of other cases, and the concept works well. 
There are a number of details along the way, and a lot of build 
breakages and wide changes to overcome - but once the basics are in 
place that is mostly a mechanic, machine-helped spreading of the 
concept, not fragile or troublesome in any way.

The other problem is processor.h:

#include <asm/vm86.h>
#include <asm/math_emu.h>
#include <asm/segment.h>
#include <asm/types.h>
#include <asm/sigcontext.h>
#include <asm/current.h>
#include <asm/cpufeature.h>
#include <asm/system.h>
#include <asm/page.h>
#include <asm/pgtable_types.h>
#include <asm/percpu.h>
#include <asm/msr.h>
#include <asm/desc_defs.h>
#include <asm/nops.h>
#include <asm/ds.h>

#include <linux/personality.h>
#include <linux/cpumask.h>
#include <linux/cache.h>
#include <linux/threads.h>
#include <linux/init.h>

That too seems quite wide. linux/prefetch.h as well:

#include <linux/types.h>
#include <asm/processor.h>
#include <asm/cache.h>

It brings in processor.h which brings in a lot of other 
dependencies. For a supposedly simple-looking primitive - which is 
used in an inline function in processor.h.

	Ingo
