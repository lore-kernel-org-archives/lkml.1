Return-Path: <linux-kernel-owner+w=401wt.eu-S936208AbXGSXy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936208AbXGSXy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbXGSXyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:54:20 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:41614 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbXGSXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:54:18 -0400
Date: Thu, 19 Jul 2007 19:49:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: jbeulich@novell.com, "S. P. Prasanna" <prasanna@in.ibm.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: new text patching for review
Message-ID: <20070719234912.GB30383@Krystal>
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal> <200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal> <p73d4yow0ys.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p73d4yow0ys.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:33:45 up 2 days, 17:07,  2 users,  load average: 0.22, 0.21, 0.22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > * Andi Kleen (ak@suse.de) wrote:
> > > 
> > > > Ewwwwwwwwwww.... you plan to run this in SMP ? So you actually go byte
> > > > by byte changing pieces of instructions non atomically and doing
> > > > non-Intel's errata friendly XMC. You are really looking for trouble
> > > > there :) Two distinct errors can occur: 
> > > 
> > > In this case it is ok because this only happens when transitioning
> > > from 1 CPU to 2 CPUs or vice versa and in both cases the other CPUs
> > > are essentially stopped.
> > > 
> > 
> > I agree that it's ok with SMP, but another problem arises: it's not only
> > a matter of being protected from SMP access, but also a matter of
> > reentrancy wrt interrupt handlers.
> > 
> > i.e.: if, as we are patching nops non atomically, we have a non maskable
> > interrupt coming which calls get_cycles_sync() which uses the
> 
> Hmm, i didn't think NMI handlers called that. e.g. nmi watchdog just
> uses jiffies.
> 
> get_cycles_sync patching happens only relatively early at boot, so oprofile
> cannot be running yet.

Actually, the nmi handler does use the get_cycles(), and also uses the
spinlock code:

arch/i386/kernel/nmi.c:
__kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
...
static DEFINE_SPINLOCK(lock);   /* Serialise the printks */
spin_lock(&lock);
printk("NMI backtrace for cpu %d\n", cpu);
...
spin_unlock(&lock);

If A - we change the spinlock code non atomically it would break.
   B - printk reads the TSC to get a timestamp, it breaks:
   it calls:
printk_clock(void) -> sched_clock(); -> get_cycles_sync() on x86_64.


> 
> > I see that IRQs are disabled in alternative_instructions(), but it does
> > not protect against NMIs, which could come at a very inappropriate
> > moment. MCE and SMIs would potentially cause the same kind of trouble.
> > 
> > So unless you can guarantee that any code from NMI handler won't call
> > basic things such as get_cycles() (nor MCE, nor SMIs), you can't insure
> > it won't execute an illegal instruction. Also, the option of temporarily
> > disabling the NMI for the duration of the update simply adds unwanted
> > latency to the NMI handler which could be unacceptable in some setups.
> 
> Ok it's a fair point.  But how would you address it ?
> 
> Even if we IPIed the other CPUs NMIs or MCEs could still happen.
> 

Yeah, that's a mess. That's why I always consider patching the code
in a way that will let the NMI handler run through it in a sane manner
_while_ the code is being patched. It implies _at least_ to do the
updates atomically with atomic aligned memory writes that keeps the site
being patched in a coherent state. Using a int3-based bypass is also
required on Intel because of the erratum regarding instruction cache.
Using these techniques, I can atomically modify the execution stream. It
would be relatively simple to re-use the framework I have done in the
Immediate Values as long as no non-relocatable instructions are
involved.

> BTW Jeremy, have you ever considered that problem with paravirt ops
> patching? 
> 
> > 
> > Another potential problem comes from preemption: if a thread is
> > preempted in the middle of the instructions you are modifying, let's say
> > we originally have 4 * 1 byte instructions that we replace with 1 * 4
> > byte instruction, a thread could iret in the middle of the new
> > instruction when it will be scheduled again, thus executing an illegal
> > instruction. This problem could be overcomed by putting the threads in
> > the freezer. See the djprobe project for details about this.
> 
> This cannot happen for the current code: 
> - full alternative patching happen only at boot when the other CPUs
> are not running

Should be checked if NMIs and MCEs are active at that moment.

> - smp lock patching only ever changes a single byte (lock prefix) of
> a single instruction

Yup, as long as we are just adding/removing a f0 prefix, it's clearly
atomic.

> - kprobes only ever change a single byte
> 

I see the mb()/rmb()/wmb() also uses alternatives, they should be
checked for boot-time racing against NMIs and MCEs.

init/main.c:start_kernel()

parse_args() (where the nmi watchdog is enabled it seems) would probably
execute the smp-alt-boot and nmi_watchdog arguments in the order in which
they are given as kernel arguments. So I guess it could race.

the "mce" kernel argument is also parsed in parse_args(), which leads to
the same problem.

> For the immediate value patching it also cannot happen because
> you'll never modify multiple instructions and all immediate values
> can be changed atomically. 
> 

Exactly, I always make sure that the immediate value within the
instruction is aligned (so a 5 bytes movl must have an offset of +3
compared to a 4 bytes alignment).

> 
> 
> > In the end, I think the safest solution would be to limit ourselves to
> > one of these 2 solutions:
> > - If the update can be done atomically and leaves the site in a coherent
> >   state after each atomic modification, while keeping the same
> >   instruction size, it could be done on the spot.
> > - If not, care should be taken to first do a copy of the code to modify
> >   into a "bypass", making sure that instructions can be relocated, so
> >   that any context that would try to execute the site during the
> >   modification would execute a breakpoint which would execute the bypass
> >   while we modify the instructions.
> 
> kprobes does that, but to write the break point it uses text_poke() 
> with my patch.

Yes, kprobes is case 1: atomic update. And we don't even have to bother
about Intel's erratum. This one is ok. That's mainly the
alternatives/paravirt code I worry about.

> 
> > Because of the tricks that must be done to do code modification on a
> > live system (as explained above), I don't think it makes sense to
> > provide a falsely-safe infrastructure that would allow code modification
> > in a non-atomic manner.
> 
> Hmm, perhaps it would make sense to add a comment warning about
> the limitations of the current text_poke. Can you supply one?
> 

Sure, something like:

Make sure this API is used only to modify code meeting these
requirements (those are the ones I remember from the top of my head):

Case 1) Inserting/removing a breakpoint
        - Do as you please. These updates are atomic and SMP correct.
          Just don't put a breakpoint in code called from the breakpoint
          handler, please.

Boot time:
Case 2) Changing 1 byte of a larger instruction at boot time, splicing
        it in 2 instructions or leaving it as 1 instruction
        - Only one CPU must be live on the system.
        - If you plan to modify code that could be executed on top of
          you (NMI handlers, MCE, SMIs), make sure you do an atomic
          update to a "legal" instruction, or else an illegal
          instruction will be executed.  Spinlocks, memory barriers and
          rdtsc are examples of code executed by such handlers. The
          other option is to force application of alternatives before
          these interrupts are enabled. Make sure that maskable
          interrupts are disabled.
Case 3) Changing 1 byte, turning 2 instructions into one at boot time
        - Follow same conditions as 2.
        - Make sure that no threads could have been preempted in the
          instructions you are modifying.
        - Study the code to make sure no jump is targeting the middle of
          your new instruction.
Case 4) Changing more than 1 byte of an instruction at boot time
        - Same as in 2-3 (depending if you leave it as one instruction
          or splice it).
        - Make sure that the bytes you are modifying are aligned and
          that you do an atomic update. It may involve playing with the
          instruction's alignment a bit.

Live:
Case 5) Changing one instruction live on SMP (ok wrt Intel's errata about
        XMC)
        - Insert a breakpoint to run a "bypass" while you play with the
          code. This bypass will single-step the original instruction
          out of line.
        - Make sure the instructions to be copied into the bypass are
          relocatable.
        - Send an IPI to each CPU so they execute a synchronizing
          instruction (sync_core()) before you remove your breakpoint.
          Else, a CPU could see two different instructions at the same
          location without ever executing the breakpoint. The
          sync_core() makes sure we don't fall into Intel's XMC errata.
        - Think about how you plan to teardown your bypass (especially
          considering preemption within the bypass)
        - Since we use a bypass, the update does not have to be atomic,
          but keep in mind that without a bypass, it would have to.
          i.e. the bypass should not be required for AMD processors
          (AFAIK).
Case 6) Changing instructions (i.e. nops into one instruction..) live on
        SMP (ok wrt Intel's errata about XMC)
        - Use the same bypass technique as in case 5.
        - Make sure that no thread can be preempted in the nops, as they
          could iret in the middle of the new instruction. (use the
          freezer)
        - Make sure that no interrupt handler could iret in the modified
          code (start a worker thread or each CPU, wait for them to
          run.)
            However, this technique is not perfect: if an interrupt
            handler returns to the code being modified, then we get
            preempted again, schedule the worker thread, come back to
            the original thread and reexecute another interrupt handler
            with an iret within the modified instructions, it could
            return in the wrong spot. Putting every thread in the
            freezer seems to overcome this problem.
        - Don't modify code of threads that cannot be put in the freezer
          (idle thread?).
        - Make sure that no hypervisor could iret in the modified code
          (that's hard).
        - Study the code to make sure no jump is targeting the middle of
          your new instruction.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
