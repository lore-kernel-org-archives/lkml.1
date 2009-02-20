Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZBTOdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZBTOdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZBTOcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:32:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57765 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbZBTOcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:32:51 -0500
Date: Fri, 20 Feb 2009 11:32:33 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfd] function-graph augmentation
Message-ID: <20090220143233.GD16897@ghostprotocols.net>
References: <1235077304.4612.662.camel@laptop> <20090219212807.GA5084@nowhere> <20090220085627.GE24555@elte.hu> <20090220133011.GB16897@ghostprotocols.net> <20090220140403.GC16897@ghostprotocols.net> <1235139482.4736.34.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235139482.4736.34.camel@laptop>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 20, 2009 at 03:18:02PM +0100, Peter Zijlstra escreveu:
> On Fri, 2009-02-20 at 11:04 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Feb 20, 2009 at 10:30:11AM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Fri, Feb 20, 2009 at 09:56:27AM +0100, Ingo Molnar escreveu:
> > > > 2)
> > > > 
> > > > Another, entirely different, and i think complementary approach, 
> > > > which exciting new possibilities would be to (also) 
> > > > automatically pick up arguments from the stack, on function 
> > > > entry.
> > > > 
> > > > If there's a (read-mostly, lockless-to-read and scalable) 
> > > > function attributes hash, then we could encode the parameters 
> > > > signature of functions (or at least, of certain functions) in 
> > > > the attributes hash. Then the tracer will know how many 
> > > > arguments to pick up from the stack.
> > > > 
> > > > This approach has the advantage that we could reconstruct the 
> > > > parameters of _arbitrary_ functions, without having to touch 
> > > > those functions. We already enumerate all functions during build 
> > > > time, it would take some more dwarf2 magic to recover the 
> > > > call/parameter signature. Oh, and at that time we could also 
> > > > record the _return type_ - easing the return value.
> > > > 
> > > > Note that it does not take a full, bloated DEBUG_INFO build - we 
> > > > can build a -g object to get the dwarf2 data and then strip out 
> > > > the dwarf2 data.
> > > > 
> > > > Arnaldo, what do you think about this, how feasible would it be 
> > > > to put dwarf2 magic into scripts/recordmcount.pl?
> > > 
> > > /me reading scripts/recordmcount.pl...
> > 
> > So you want to:
> > 
> > 1. build object with -g
> > 2. just after it is built, get what we want from the DWARF sections,
> >    then strip it, stash what we collected
> > 3. what we want is:
> > 	- parameter names
> > 	- _where_ each parameter is (DWARF location expressions)
> > 	- type signature (CTF like stuff)
> > 4. allow users to ask for parameters (all? just some?) for certain functions
> >    to be collected at function entry
> > 5. at function entry check if parameters should be collected, go over
> >    each parameter DWARF location expression and collect the values,
> >    encoding them into the ring buffer
> > 6. at cat /d/tracing/trace time pretty print the parameters collected,
> >    i.e. name=value-formatting-according-to-its-type
> > 
> > Ok, base types are easy, enums are easy, what about structs? forget
> > about them and just print the pointer? i.e.:
> > 
> > 	_spin_lock(.lock=0xabcdef)
> > 
> > versus:
> > 
> > 	_spin_lock(.lock={.raw_lock={.slock=0}})
> > 
> > All members should be collected? Just some? User decides?
> 
> I would say some, with a code annotation. 
> 
> Specifically for your example, I wanted to use lockdep/stat tracepoints
> to collect the lockdep lock class name to print in locking primitives,

I was going to ask about that ;-)
 
> those are much more descriptive than either a lock pointer or a dump of
> the full structure.

Agreed, specific pretty-printers should be used when available in a lib.

> So perhaps we can do something like:
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 36faa3a..20efad1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2869,6 +2869,8 @@ EXPORT_SYMBOL(pagefault_enable);
>  int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		unsigned long address, int write_access)
>  {
> +	__trace_function_arg(address);
> +
>  	pgd_t *pgd;
>  	pud_t *pud;
>  	pmd_t *pmd;
> 
> 
> Or possibly go through tracepoint probes to collect them.

Code gets polluted, no? I.e. only before hand annotated arguments will
be collected.

Well, perhaps for really really really interesting functions this will
speed up things by almost unconditionally collecting the explicitely
annotated traceparms.
 
> Anyway, it would be grand if we can have some GCC people participate
> because things like recordmount.pl, while highly creative, utterly tank
> build times.

yes, but don't require a new compiler.

If these use cases were considered as working proofs of concept, then
hopefully in the future we would have them built into the compiler.

- Arnaldo
