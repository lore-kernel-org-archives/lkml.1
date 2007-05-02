Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbXEBRY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbXEBRY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXEBRY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:24:57 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:49758 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbXEBRYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:24:54 -0400
Date: Wed, 2 May 2007 13:19:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070502171917.GA3460@Krystal>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070502104413.GC4392@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 13:13:41 up 89 days,  7:20,  4 users,  load average: 1.15, 1.12, 1.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen (andi@firstfloor.org) wrote:
> > It is currently used as an instrumentation infrastructure for the LTTng
> > tracer at IBM, Google, Autodesk, Sony, MontaVista and deployed in
> > WindRiver products.  The SystemTAP project also plan to use this type of
> > infrastructure to trace sites hard to instrument. The Linux Kernel
> > Markers has the support of Frank C. Eigler, author of their current
> > marker alternative (which he wishes to drop in order to adopt the
> > markers infrastructure as soon as it hits mainline).
> 
> All of the above don't use mainline kernels.
> That doesn't constitute using it.
> 

I am afraid this argument does not hold :

- These companies are not shipping their products with mainline kernels
  to make sure things have time to stabilize.
- They eventually get to the next version some time after it is not
  "head" anymore. They still want to benefit from the features of the
  newer versions.
- All these companies would be really happy to have a marker
  infrastructure in mainline so they can stop applying a separate set of
  patches to provide this functionality.
- Arguing the fact that "they apply their set of patches anyway" goes
  against the advice I have received from Greg KH, which is can be
  reworded as : please submit your patches to mainline instead of
  keeping your separate set of patches. See his various presentations
  about "mainlining" for more info about this.

Because of these 4 arguments, I think that these companies can be
considered as users and contributors of/to mainline kernels.


> > Quoting Jim Keniston <jkenisto@us.ibm.com> :
> > 
> > "kprobes remains a vital foundation for SystemTap.  But markers are
> > attactive as an alternate source of trace/debug info.  Here's why:
> > [...]"
> 
> Talk is cheap. Do they have working code to use it?
> 

LTTng has been using the markers for about 6 months now. SystemTAP is
waiting on the "it hits mainline" signal before they switch from their
STP_MARK() markers to this infrastructure. Give them a few days and they
will proceed to the change.



> >   - Allow per-architecture optimized versions which removes the need for
> >     a d-cache based branch (patch a "load immediate" instruction
> >     instead). It minimized the d-cache impact of the disabled markers.
> 
> That's a good idea in general, but should be generalized (available
> independently), not hidden in your subsystem. I know a couple of places
> who could use this successfully.
> 

I agree that an efficient hooking mechanism is useful to manyr; listing
at least security hooks and instrumentation for tracing. What other
usage scenario do you have in mind that could not fit in my marker
infrastructure ? I have tried to generalize this as much as possible,
but if you see, within this, a piece of infrastructure that could be
taken apart and used more widely, I will be happy to submit it
separately to increase its usefulness.


> >   - Accept the cost of an unlikely branch at the marker site because the
> >     gcc compiler does not give the ability to put "nops" instead of a
> >     branch generated from C code. Keep this in mind for future
> >     per-architecture optimizations.
> 
> See upcomming paravirt code for a way to do this.
> 

I have looked at the paravirt code in Andrew's 2.6.21-rc7-mm2. A few
reasons why I do not plan to use it :


1 - It requires specific arg setup for the calls to be crafted by hand,
in assembly, for each and every number of parameters and each types, for
each architecture. I use a variable argument list as a parameter to my
marker to make sure that a single macro can be used for markup in a
generic manner.

Quoting : http://lkml.org/lkml/2007/4/4/577
"+ * Unfortunately there's no way to get gcc to generate the args setup
+ * for the call, and then allow the call itself to be generated by an
+ * inline asm.  Because of this, we must do the complete arg setup and
+ * return value handling from within these macros.  This is fairly
+ * cumbersome."


2 - I also provide an architecture independent "generic" version which
does not depend on per-architecture assembly. From what I see, paravirt
is only offered for i386 and x86_64. Are there any plans to support the
other ~12 architectures ? Does it offer a architecture agnostic fallback
in the cases where it is not implemented for a given architecture ?


3 - It can only alter instructions "safely" in the UP case before the
other CPUs are turned on. See my arch/i386/marker.c code patcher for
XMC-safe instruction patching. Marker activation must be done at
runtime, when the system is fully operational.

Quoting 2.6.21 arch/i386/kernel/alternative.c
"/* Replace instructions with better alternatives for this CPU type.
   This runs before SMP is initialized to avoid SMP problems with
   self modifying code. This implies that assymetric systems where
   APs have less capabilities than the boot processor are not handled.
   Tough. Make sure you disable such features by hand. */

void apply_alternatives(struct alt_instr *start, struct alt_instr *end)"


4 - paravirt does not offer the ability to replace a branch instruction,
generated by gcc, through its mechanism. If I choose to use paravirt
mechanism, I must do the stack setup and function call by hand, which
has been argued in points (1) and (2). GCC must itself generate the
branch instruction to jump over the function call containing the
variable argument list.


> > - Instrumentation of challenging kernel sites
> >   - Instrumentation such as the one provided in the already existing
> >     Lock dependency checker (lockdep) and instrumentation of trap
> >     handlers implies being reentrant for such context. Therefore, the
> >     implementation must be lock-free and update the state in an atomic
> >     fashion (rcu-style). It must also let the programmer who describes
> >     a marker site the ability to specify what is forbidden in the probe
> >     that will be connected to the marker : can it generate a trap ? Can
> >     it call lockdep (irq disable, take any type of lock), can it call
> >     printk ? This is why flags can be passed to the _MARK() marker,
> >     while the MARK() marker has the default flags.
> 
> Why can't you just generally forbid probes from doing all of this?
> It would greatly simplify your code, wouldn't it?
> 
> Keep it simple please.
> 

An example, taken from the marker mechanism itself (no probe involved)
shows how difficult it can be to "forbid all of this" :

The optimized version patches code while the system is live. This
implies cross modifying code in SMP environment. It can be done safely
on x86 and x86_64 by using a breakpoint during the code modification to
make sure the CPU issues a serializing instruction between the moment a
given CPU speculates the code execution and actually reaches it. It
implies going though a trap, which does funny things such as enabling
interrupts, which calls into lockdep. Therefore, adding a marker into
the lockdep code cannot be done with a breakpoint-based marker on these
architectures. We have to provide an alternative way to do this, less
intrusive, which is exactly what the "generic" markers provide. The same
applies to instrumentation of the breakpoint trap handler.

I strongly doubt that _every_ users of the markers would be comfortable
with the "write your code so it does not take any lock and does
everything atomically" constraint. I have done it in LTTng so I could
have a fully reentrant tracer, but even then you can be limited by the
nature of where you want to send the data. Richard Purdie implemented a
serial port based data relay as an alternative data relay mechanism
connected to LTTng; he needed a spinlock because of the semantic of his
port, so he has to accept the limitation regarding the sites that can
and cannot be probed. Providing an explicit declaration of site
limitations make sense in this regard.

On other architectures, it is the time source which requires a read
seqlock. It is not atomic in the sense that a reader can nest over a
writer (if coming from NMI context) and spin forever.

I can list a lot of situations where we cannot _require_ the probe to
run atomically in every aspect; so generally forbidding these actions
does not seem to be a viable solution. In fact, this would be the best
way to make sure the marker infrastructure is never used by early
adopters because of the complexity level of writing probes, due to these
"rules".


> > Please tell me if I forgot to explain the rationale behind some
> > implementation detail and I will be happy to explain in more depth.
> 
> Having lots of flags to do things differently optionally normally
> starts up all warning lights of early over design. While Linux
> has this sometimes it is generally only in mature old subsystems.
> But when something is freshly merged it shouldn't be like this.
> That is because code tends to grow more complicated over its livetime
> and when it is already complicated at the beginning it will eventually
> fall over (you can study current slab as a poster child of this)
> 
> -Andi
> 

Explicitly identifying "hard to instrument" sites is nothing new. It has
been done in different manners in the past. Kprobes sprinkles
"__kprobes" declarations before function declarations all over the place
to specify which ones cannot be safely instrumented. It results in a
visually less appealing source code and it limits the sites that can be
probed.

The goal of the marker infrastructure is exactly to instrument those
sites.  Therefore, the approach "we forbid instrumentation of sites hard
to instrument" misses the point of this infrastructure. We can leverage
the fact that the marker is put in a context known by the programmer; it
makes sense to give him the ability to specify what are the restrictions
on the probes connected to this marker with some level of granularity.


Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
