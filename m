Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbXGTOlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbXGTOlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbXGTOlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:41:40 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:64602 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760460AbXGTOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:41:39 -0400
Date: Fri, 20 Jul 2007 10:36:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: jbeulich@novell.com, "S. P. Prasanna" <prasanna@in.ibm.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: new text patching for review
Message-ID: <20070720143633.GB29979@Krystal>
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal> <200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal> <p73d4yow0ys.fsf@bingen.suse.de> <20070719234912.GB30383@Krystal> <20070720082833.GC19833@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070720082833.GC19833@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:13:08 up 3 days,  8:47,  3 users,  load average: 0.09, 0.80, 1.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Thu, Jul 19, 2007 at 07:49:12PM -0400, Mathieu Desnoyers wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> > > 
> > > > * Andi Kleen (ak@suse.de) wrote:
> > > > > 
> > > > > > Ewwwwwwwwwww.... you plan to run this in SMP ? So you actually go byte
> > > > > > by byte changing pieces of instructions non atomically and doing
> > > > > > non-Intel's errata friendly XMC. You are really looking for trouble
> > > > > > there :) Two distinct errors can occur: 
> > > > > 
> > > > > In this case it is ok because this only happens when transitioning
> > > > > from 1 CPU to 2 CPUs or vice versa and in both cases the other CPUs
> > > > > are essentially stopped.
> > > > > 
> > > > 
> > > > I agree that it's ok with SMP, but another problem arises: it's not only
> > > > a matter of being protected from SMP access, but also a matter of
> > > > reentrancy wrt interrupt handlers.
> > > > 
> > > > i.e.: if, as we are patching nops non atomically, we have a non maskable
> > > > interrupt coming which calls get_cycles_sync() which uses the
> > > 
> > > Hmm, i didn't think NMI handlers called that. e.g. nmi watchdog just
> > > uses jiffies.
> > > 
> > > get_cycles_sync patching happens only relatively early at boot, so oprofile
> > > cannot be running yet.
> > 
> > Actually, the nmi handler does use the get_cycles(), and also uses the
> >
> > spinlock code:
> > 
> > arch/i386/kernel/nmi.c:
> > __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
> > ...
> > static DEFINE_SPINLOCK(lock);   /* Serialise the printks */
> > spin_lock(&lock);
> > printk("NMI backtrace for cpu %d\n", cpu);
> > ...
> > spin_unlock(&lock);
> > 
> > If A - we change the spinlock code non atomically it would break.
> 
> It only has its lock prefixes twiggled, which should be ok.
> 

Yes, this is a special case where both the lock prefixed instructions
and the non lock prefixed instructions are valid, so it does not matter
if a thread is preempted right after executing the NOP turned into a
0xf0. However, if such case happens when passing from UP to SMP, a
thread could be scheduled in and try to access to a spinlock with the
non-locked instruction. There should be some kind of "teardown" to make
sure that no such case can happen.



> >    B - printk reads the TSC to get a timestamp, it breaks:
> >    it calls:
> > printk_clock(void) -> sched_clock(); -> get_cycles_sync() on x86_64.
> 
> Are we reading the same source? sched_clock has never used get_cycles_sync(),
> just ordinary get_cycles() which is not patched. In fact it mostly
> used rdtscll() directly.
> 

Yes, you are right.. I am thinking more about other clients, such as a
tracer, which could want the precision given by get_cycles_sync() and
may execute in NMI context. It does not apply to the current kernel
source. It's just that reading a timestamp counter is an operation so
common that it should not come with restrictions about which context it
could be called from due to the alternatives mechanism.

> The main problem is alternative() nopify, e.g. for prefetches which
> could hide in every list_for_each; but from a quick look the current
> early NMI code doesn't do that.

Yup.. well.. my tracer will ;) I use a list_for_each_rcu() to iterate on
active traces. That's another example of a very basic piece of
infrastructure for which we don't want to bother about alternatives
patching when using it.

> 
> > Yeah, that's a mess. That's why I always consider patching the code
> > in a way that will let the NMI handler run through it in a sane manner
> > _while_ the code is being patched. It implies _at least_ to do the
> > updates atomically with atomic aligned memory writes that keeps the site
> > being patched in a coherent state. Using a int3-based bypass is also
> > required on Intel because of the erratum regarding instruction cache.
> 
> That's only for cross modifying code, no? 
> 

No. It also applies to UP modification. Since it is hard to insure that
no unmaskable interrupt handler will run on top of you, it can help to
leave the code in a valid state at every moment.

> > > This cannot happen for the current code: 
> > > - full alternative patching happen only at boot when the other CPUs
> > > are not running
> > 
> > Should be checked if NMIs and MCEs are active at that moment.
> 
> They are probably both.
> 
> I guess we could disable them again. I will cook up a patch.
> 

I guess we could, although I wouldn't recommend doing it on a live
system, only at boot time.

> > I see the mb()/rmb()/wmb() also uses alternatives, they should be
> > checked for boot-time racing against NMIs and MCEs.
> 
> Patch above would take care of it.
> 
> > 
> > init/main.c:start_kernel()
> > 
> > parse_args() (where the nmi watchdog is enabled it seems) would probably
> > execute the smp-alt-boot and nmi_watchdog arguments in the order in which
> > they are given as kernel arguments. So I guess it could race.
> 
> Not sure I see your point here. How can arguments race?
> 

I thought parse_args() started the NMIs, but it seems to just take the
arguments and saves them for later.

> > 
> > the "mce" kernel argument is also parsed in parse_args(), which leads to
> > the same problem.
> 
> ?
> 
Same as above.

> 
> > 
> > > For the immediate value patching it also cannot happen because
> > > you'll never modify multiple instructions and all immediate values
> > > can be changed atomically. 
> > > 
> > 
> > Exactly, I always make sure that the immediate value within the
> > instruction is aligned (so a 5 bytes movl must have an offset of +3
> > compared to a 4 bytes alignment).
> 
> The x86 architecture doesn't require alignment for atomic updates.
> 

You mean for atomicity wrt the local SMP or cross-cpus ?

> > Make sure this API is used only to modify code meeting these
> > requirements (those are the ones I remember from the top of my head):
> 
> Umm, that's far too complicated. Nobody will understand it anyways.
> I'll cook up something simpler.
> 

ok :)

Mathieu

> -Andi
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
