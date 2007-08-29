Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXH2MI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXH2MI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 08:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbXH2MIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 08:08:49 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:48270 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756857AbXH2MIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 08:08:47 -0400
Date: Wed, 29 Aug 2007 08:08:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       parisc-linux@parisc-linux.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [parisc-linux] [patch 15/23] Add cmpxchg_local to parisc
Message-ID: <20070829120843.GA9734@Krystal>
References: <20070812145434.520271946@polymtl.ca> <20070812145840.691277845@polymtl.ca> <20070827210432.GA22484@colo.lackof.org> <20070827211140.GB10627@Krystal> <20070828063905.GA3916@colo.lackof.org> <20070828115018.GB12241@Krystal> <20070828172745.GA19224@colo.lackof.org> <20070828183835.GB1280@Krystal> <20070829055955.GA24358@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070829055955.GA24358@colo.lackof.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:03:29 up 30 days, 12:22,  5 users,  load average: 0.32, 0.45, 0.58
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Grundler (grundler@parisc-linux.org) wrote:
> [davem: patch for you at the bottom to Documentation/atomic_ops.txt ]
> 
> On Tue, Aug 28, 2007 at 02:38:35PM -0400, Mathieu Desnoyers wrote:
> > * Grant Grundler (grundler@parisc-linux.org) wrote:
> > > On Tue, Aug 28, 2007 at 07:50:18AM -0400, Mathieu Desnoyers wrote:
> ...
> > > > So I don't expect to come with an "upper bound" about where it can be
> > > > used...
> > > 
> > > Ok...so I'll try to find one in 2.6.22.5:
> > > grundler <1855>find -name \*.c | xargs fgrep DEFINE_PER_CPU | fgrep atomic_t
> > > ./arch/s390/kernel/time.c:static DEFINE_PER_CPU(atomic_t, etr_sync_word);
> > > grundler <1856>find -name \*.c | xargs fgrep DEFINE_PER_CPU | fgrep local_t
> > > ./arch/x86_64/kernel/nmi.c:static DEFINE_PER_CPU(local_t, alert_counter);
> > > 
> > > uhm, I was expecting more than that.  Maybe there is some other systemic
> > > problem with how PER_CPU stuff is used/declared?
> > 
> > the local ops has just been standardized in 2.6.22 though a patchset I
> > did. I would not expect the code to start using them this quickly. Or
> > maybe is it just that I am doing a terrible marketing job ;)
> 
> Yeah, I didn't expect many users of local_t.
> 
> The search for atomic_t usage in DEFINE_PER_CPU was an attempt to
> find other potential candidates which could be local_t.
> Is there any other programmatic way we could look for code which
> could (or should) be using local_t?
> 

Yep.. atomic_t static variables used as counters are a perfect match:
they are updated very often and read rarely. Therefore, it is
preferable to have per cpu updates with very cheap locking and to
iterate on all of them to sum them when they should be printed. That's
just an example, but with it comes vmstat and all sorts of counters.

> > > In any case, some references to LTT usage would be quite helpful.
> > > E.g. a list of file and variable names at the end of local_ops.txt file.
> > > 
> > 
> > LTT is not mainlined (yet!) ;)
> 
> Ok...probably not such a good example then. :)
> 
> ...
> > > Sorry...the quoted text doesn't answer my question. It's a definition
> > > of semantics, not an explanation of the "mechanics".
> > > 
> > > I want to know what happens when (if?) an interrupt occurs in the
> > > middle of a read/modify/write sequence that isn't prefixed with LOCK
> > > (or something similar for other arches like "store locked conditional" ops).
> > > 
> > > Stating the semantics is a good thing - but not a substitution for
> > > describing how it works for a given architecture. Either in the code
> > > or in local_ops.txt. Otherwise people like me won't use it because
> > > we don't believe that (or understand how) it really works.
> > > 
> > 
> > Quoting Intel 64 and IA-32 Architectures Software Developer's Manual
> > 
> > 3.2 Instructions
> > LOCK - Assert LOCK# Signal Prefix
> ...
> 
> I've read this before and understand how LOCK works. This isn't helpful
> since I want a description of the behavior without LOCK.
> 
> > And if we take a look at some of the atomic primitives which are used in
> > i386 local.h:
> > 
> > add (for inc/dec/add/sub)
> > xadd
> > cmpxchg
> > 
> > All these instructions, just like any other, can be interrupted by an
> > external interrupt or cause a trap, exception, or fault. Interrupt
> > handler are executing between instructions and traps/exceptions/faults
> > will either execute instead of the faulty instruction or after is has
> > been executed. In all these cases, each instruction can be seen as
> > executing atomically wrt the local CPU. This is exactly what permits
> > asm-i386/local.h to define out the LOCK prefix for UP kernels.
> 
> I think what I'm looking for but don't know if it's true:
>     The cmpxchg (for example) at the kernel process context will not
>     clobber or be clobbered by a cmpxchg done to the same local_t
>     performed at the kernel interrupt context by the same CPU.
> 
> If that's not true, then it would be good to add that as another
> restriction to usage.
> 

Each of these cmpxchg will execute atomically wrt the local CPU, so
there is no limitation there.

> > I use the same trick UP kernel are using, but I deploy it in SMP
> > context, but I require the CPU to be the only one to access the memory
> > locations written to by the local ops.
> > 
> > Basically, since the memory location is _not_ shared across CPUs for
> > writing, we can safely write to it without holding the LOCK signal.
> 
> ok.
> 
> ...
> > > Note: I already missed the one critical sentence about only the "owning"
> > > CPU can write the value....there seem to be other limitations as well
> > > with respect to interrupts.
> > > 
> > 
> > Ok, let's give a try at a clear statement:
> > 
> > - Variables touched by local ops must be per cpu variables.
> > - _Only_ the CPU owner of these variables must write to them.
> > - This CPU can use local ops from any context (process, irq, softirq, nmi, ...)
> >   to update its local_t variables.
> > - Preemption (or interrupts) must be disabled when using local ops in
> >   process context to   make sure the process won't be migrated to a
> >   different CPU between getting the per-cpu variable and doing the
> >   actual local op.
> > - When using local ops in interrupt context, no special care must be
> >   taken on a mainline kernel, since they will run on the local CPU with
> >   preemption already disabled. I suggest, however, to explicitly
> >   disable preemption anyway to make sure it will still work correctly on
> >   -rt kernels.
> > - Reading the local cpu variable will provide the current copy of the
> >   variable.
> > - Reads of these variables can be done from any CPU, because updates to
> >   "long", aligned, variables are always atomic. Since no memory
> >   synchronization is done by the writer CPU, an outdated copy of the
> >   variable can be read when reading some _other_ cpu's variables.
> 
> Perfect! Ship it! ;)
> Can you submit a patch to add the above to Documentation/local_ops.txt ?
> 

Hehe sure :) I'll prepare one.

> ...
> > > Looks fine to me. Add your "Signed-off-by" and submit to DaveM
> > > since he seems to be the maintainer of atomic_ops.txt.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> heh...I think DaveM will want it in git or universal patch form. :)
> Patch appended below.
> 
> thanks!
> grant
> 
> Add document reference and simple use example of local_t.
> 
> Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> --- linux-2.6.22.5-ORIG/Documentation/atomic_ops.txt	2007-08-22 16:23:54.000000000 -0700
> +++ linux-2.6.22.5-ggg/Documentation/atomic_ops.txt	2007-08-28 22:57:26.000000000 -0700
> @@ -7,6 +7,11 @@
>  maintainers on how to implement atomic counter, bitops, and spinlock
>  interfaces properly.
>  
> +	atomic_t should be used to provide a type with update primitives
> +executed atomically from any CPU.  If the counter is per CPU and only
> +updated by one CPU, local_t is probably more appropriate.  Please see
> +Documentation/local_ops.txt for the semantics of local_t.
> +
>  	The atomic_t type should be defined as a signed integer.
>  Also, it should be made opaque such that any kind of cast to a normal
>  C integer type will fail.  Something like the following should

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
