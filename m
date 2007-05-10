Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbXEJPzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbXEJPzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXEJPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:55:09 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:64976 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779AbXEJPzH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:55:07 -0400
Date: Thu, 10 May 2007 11:55:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@muc.de>, systemtap@sources.redhat.com, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070510155501.GI22424@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.508519573@polymtl.ca> <20070510090656.GA57297@muc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070510090656.GA57297@muc.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 10:31:20 up 97 days,  4:38,  5 users,  load average: 2.07, 2.42, 2.60
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@muc.de) wrote:
> On Wed, May 09, 2007 at 09:56:00PM -0400, Mathieu Desnoyers wrote:
> > @@ -0,0 +1,99 @@
> > +/* marker.c
> > + *
> > + * Erratum 49 fix for Intel PIII and higher.
> 
> Errata are CPU specific so they can't be higher. You mean it's a P3
> erratum only?
> 
> In general you need some more description why the int3 handler is needed.
> 

>From :
Intel® Core™2 Duo Processor for
Intel® Centrino® Duo Processor
Technology
Specification Update 

AH33.
Unsynchronized Cross-Modifying Code Operations Can Cause
Unexpected Instruction Execution Results

It is therefore still relevant on newer CPUs. I can add reference to this
documentation in the header.


> > + *
> > + * Permits marker activation by XMC with correct serialization.
> 
> This doesn't follow the Intel recommended algorithm for cross modifying
> code (7.1.3 in the IA32 manual) which requires the other CPUs to spin
> during the modification.
> 
> If you used that would you really need the INT3 handler?
> 

Let's go through the excercice of applying their algorithm to a running
kernel.

You would have to do something like : 
CPU A wants to modify code; it initializes 2 completion barriers (one to
know when all other cpus are spinning and another to tell them they can
stop spinning) and sends an IPI to every other CPUs.  All other CPUs,
upon entry in the IPI handler, disable interrupts, indicate that they
are spinning in the 1st barrier and wait for the completion variable to
be reset by CPU A. When all other CPUs are ready, CPU A disables
interrupts and proceeds to the change, then removes the second memory
barrier to let the other CPUs exit their loops.

* First issue : Impact on the system. If we try to make this system
  scale, we will create very long irq disable sections. The expected
  duration is the worse case IPI latency plus the time it takes to CPU A
  to change the variable. We therefore directly grow the worse case
  system's interrupt latency.

* Second issue : irq disabling does not protect us from NMI and traps.
  We cannot use this algorithm to mark these code segments.

* Third issue : Scalability. Changing code will stop every CPU on the
  system for a while. Compared to this, the int3-based approach will run
  through the breakpoint handler "if" one of the CPU happens to execute
  this code at the wrong time. The standard case is just an IPI (to
  issue one "iret" and a synchronize_sched().

Also note that djprobes, a jump-based enhancement of kprobes, uses a
mechanism very similar to mine. I did not use their implementation
because I consider that kprobes has too much side-effects to be used in
"hard to instrument" sites (traps, nmi handlers, lockdep code). kprobes
also uses a temporary data structure to put the stepping instructions,
something I wanted to avoid. I enables me to do the teardown of the
breakpoint even when it is placed in preemptible code.

> > +static DEFINE_MUTEX(mark_mutex);
> > +static long target_eip = 0;
> > +
> > +static void mark_synchronize_core(void *info)
> > +{
> > +	sync_core();	/* use cpuid to stop speculative execution */
> > +}
> > +
> > +/* We simply skip the 2 bytes load immediate here, leaving the register in an
> > + * undefined state. We don't care about the content (0 or !0), because we are
> > + * changing the value 0->1 or 1->0. This small window of undefined value
> > + * doesn't matter.
> > + */
> > +static int mark_notifier(struct notifier_block *nb,
> > +	unsigned long val, void *data)
> > +{
> > +	enum die_val die_val = (enum die_val) val;
> > +	struct die_args *args = (struct die_args *)data;
> > +
> > +	if (!args->regs || user_mode_vm(args->regs))
> 
> I don't think regs should be ever NULL
> 

I played safe and used the same tests done in kprobes. I'll let them
explain. See

arch/i386/kernel/kprobes.c

int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
                                       unsigned long val, void *data)
{
        struct die_args *args = (struct die_args *)data;
        int ret = NOTIFY_DONE;

        if (args->regs && user_mode_vm(args->regs))
                return ret;
...


> > +		return NOTIFY_DONE;
> > +
> > +	if (die_val == DIE_INT3	&& args->regs->eip == target_eip) {
> > +		args->regs->eip += 1; /* Skip the next byte of load immediate */
> 
> In what instruction results that then? This is definitely underdocumented.
> 

Should maybe document this more :

The eip there points right after the 1 byte breakpoint. The breakpoint
replaces the 1st byte of a 2 bytes load immediate. Therefore, if I skip
the following byte (the load immediate value), I am then at the
instruction following the load immediate. As I stated in my comments,
since I check that there is a state change to the variable (0->1 or
1->0), I can afford having garbage in my registers at this point,
because it will be either the state prior to the change I am currently
doing or the new state after the change.

I hope it makes the following comment, found just over mark_notifier(),
clearer : 
/* We simply skip the 2 bytes load immediate here, leaving the register in an
 * undefined state. We don't care about the content (0 or !0), because we are
 * changing the value 0->1 or 1->0. This small window of undefined value
 * doesn't matter.
 */

I will add this paragraph prior to the existing one to make things clearer :

/* The eip value points right after the breakpoint instruction, in the second
 * byte of the movb. Incrementing it of 1 byte makes the code resume right after
 * the movb instruction, effectively skipping this instruction.

> > +int marker_optimized_set_enable(void *address, char enable)
> > +{
> > +	char saved_byte;
> > +	int ret;
> > +	char *dest = address;
> > +
> > +	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
> > +		return 0;
> 
> Wouldn't you need that inside the mutex too to avoid races?
> 

Absolutely, will fix.

> 
> > +
> > +	mutex_lock(&mark_mutex);
> > +	target_eip = (long)address + BREAKPOINT_INS_LEN;
> > +	/* register_die_notifier has memory barriers */
> > +	register_die_notifier(&mark_notify);
> > +	saved_byte = *dest;
> > +	*dest = BREAKPOINT_INSTRUCTION;
> > +	wmb();
> 
> wmb is a nop
> 

Quoting asm-i386/system.h :

 * Some non intel clones support out of order store. wmb() ceases to be
 * a nop for these.

#ifdef CONFIG_X86_OOSTORE
/* Actually there are no OOO store capable CPUs for now that do SSE, 
   but make it already an possibility. */
#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
#else
#define wmb()   __asm__ __volatile__ ("": : :"memory")
#endif

As I will soon reuse this code on x86_64, wmb() is not a nop under
CONFIG_UNORDERED_IO.

Therefore, I think I am playing safe by leaving a wmb() there.

> > +	/* Execute serializing instruction on each CPU.
> > +	 * Acts as a memory barrier. */
> > +	ret = on_each_cpu(mark_synchronize_core, NULL, 1, 1);
> > +	BUG_ON(ret != 0);
> > +
> > +	dest[1] = enable;
> > +	wmb();
> > +	*dest = saved_byte;
> > +		/* Wait for all int3 handlers to end
> > +		   (interrupts are disabled in int3).
> > +		   This CPU is clearly not in a int3 handler
> > +		   (not preemptible).
> 
> So what happens when the kernel is preemptible? 
> 

This comment may be unclear : the "(not preemptible)" applies to the
int3 handler itself. I'll arrange it.

Because the int3 handler disables interrupts, it is not preemptible.
Therefore, the CPU running this code, doing the synchronize_sched(),
cannot reschedule a int3 handler running on a preempted thread stack
waiting to be scheduled again. Since original mov instruction has been
placed back before the call to synchronize_sched(), and there is a
memory barrier in synchronize_sched, we know there is no possibility for
an int3 handler to run for this instruction on the CPU that runs
synchronize_sched(). At the end of the synchronize_sched(), we know we
have exited every currently executing non-preemptible sections, which
includes the int3 handlers of every other CPUs.


> > +		   synchronize_sched has memory barriers */
> > +	synchronize_sched();
> > +	unregister_die_notifier(&mark_notify);
> > +	/* unregister_die_notifier has memory barriers */
> > +	target_eip = 0;
> > +	mutex_unlock(&mark_mutex);
> > +	flush_icache_range(address, size);
> 
> That's a nop on x86
> 

Right, and eventually on x86_64 too. Will remove.

> > +
> > +#ifdef CONFIG_MARKERS
> > +
> > +#define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
> > +
> > +/* Optimized version of the markers */
> > +#define trace_mark_optimized(flags, name, format, args...) \
> > +	do { \
> > +		static const char __mstrtab_name_##name[] \
> > +		__attribute__((section("__markers_strings"))) \
> > +		= #name; \
> > +		static const char __mstrtab_format_##name[] \
> > +		__attribute__((section("__markers_strings"))) \
> > +		= format; \
> > +		static const char __mstrtab_args_##name[] \
> > +		__attribute__((section("__markers_strings"))) \
> > +		= #args; \
> 
> For what do you need special string sections?  
> 
> If it's something to be read by external programs the interface
> would need to be clearly defined and commented.
> If not just use normal variables.
> 

Markers, by their nature, will be declared everywhere through the kernel
code. Therefore, the strings would pollute the kernel data and use up
space in the data caches even when the markers are disabled. This is why
I think it makes sense to put this data in a separate section.


> > +		static struct __mark_marker_data __mark_data_##name \
> > +		__attribute__((section("__markers_data"))) = \
> > +		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
> > +		__mstrtab_args_##name, \
> > +		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
> > +		char condition; \
> > +		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \
> 
> The volatile is not needed because the output is used.
> 

True. Will fix. The same applies to asm-powerpc/marker.h.


> > +					".long %1, 0f;\n\t" \
> > +					".previous;\n\t" \
> > +					".align 2\n\t" \
> > +					"0:\n\t" \
> > +					"movb $0,%0;\n\t" \
> 
> This should be a generic facility in a separate include file / separate 
> macros etc so that it can be used by other code too.
> 

Yep, the split into a "conditional call" infrastructure will come soon.
I was thinking of something like cond_call(func(arg1, arg2));. If you
think of a better macro name, I am open to suggestions.

> > +				: "=r" (condition) \
> > +				: "m" (__mark_data_##name)); \
> > +		__mark_check_format(format, ## args); \
> > +		if (likely(!condition)) { \
> > +		} else { \
> > +			preempt_disable(); \
> 
> Why the preempt disable here and why can't it be in the hook?
> 

Because I want to safely disconnect hooks. And I need to issue a
synchronize_sched() after disconnection to make sure every handler
finished running before I unload the module that implements the hook
code. Therefore, I must surround the call by preempt_disable.

> > +			(*__mark_data_##name.call)(&__mark_data_##name, \
> > +						format, ## args); \
> > +			preempt_enable(); \
> > +		} \
> > +	} while (0)
> > +
> > +/* Marker macro selecting the generic or optimized version of marker, depending
> > + * on the flags specified. */
> > +#define _trace_mark(flags, format, args...) \
> > +do { \
> > +	if (((flags) & MF_LOCKDEP) && ((flags) & MF_OPTIMIZED)) \
> > +		trace_mark_optimized(flags, format, ## args); \
> > +	else \
> > +		trace_mark_generic(flags, format, ## args); \
> 
> Is there ever a good reason not to use optimized markers? 
> 

Yep, instrumentation of the breakpoint handler, and instrumentation of
anything that can be called from the breakpoint handler, namely
lockdep.c code.

> > + * bytes. */
> > +#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 1
> > +#define MARK_OPTIMIZED_ENABLE_TYPE char
> 
> unsigned char is usually safer to avoid sign extension
> 

Ok, will fix.

Thanks for the thorough review,

Mathieu

> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
