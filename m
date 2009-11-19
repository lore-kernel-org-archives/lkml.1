Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZKSA6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZKSA6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbZKSA6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:58:24 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53657 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbZKSA6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:58:23 -0500
Date: Wed, 18 Nov 2009 16:58:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20091119005829.GF6683@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <20091119002826.GB28962@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119002826.GB28962@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 07:28:26PM -0500, Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> > Add text_poke_fixup() which takes a fixup address to where a processor
> > jumps if it hits the modifying address while code modifying.
> > text_poke_fixup() does following steps for this purpose.
> > 
> >  1. Setup int3 handler for fixup.
> >  2. Put a breakpoint (int3) on the first byte of modifying region,
> >     and synchronize code on all CPUs.
> >  3. Modify other bytes of modifying region, and synchronize code on all CPUs.
> >  4. Modify the first byte of modifying region, and synchronize code
> >     on all CPUs.
> >  5. Clear int3 handler.
> > 
> 
> Hi Masami,
> 
> I like the approach and the API is clean. I have intersped comments
> below.
> 
> Ingo: I raise a question about text_mutex vs on_each_cpu hangs I
> experienced recently in the message below. Might be worth having a look,
> I suspect this might have caused the hangs Paul McKenney had with his
> past TREE RCU callback migration. I think he did take a mutex in the cpu
> hotplug callbacks and might have used IPIs within that same lock.

Hello, Mathieu,

By "mutex", do you mean "mutex_lock()"?  If so, I don't do that from
within the CPU hotplug notifiers.  I do spin_lock_irqsave().

People have been known to invoke synchronize_rcu() from CPU hotplug
notifiers, however -- and this does block.  Is that what you are
getting at?

I do invoke smp_send_reschedule() with irqs disabled, which did arouse my
suspicions of late.  But this seems to bypass the smp_call_function()
code that is most definitely illegal to invoke with irqs disabled,
so no smoking gun.  All that aside, if invoking smp_send_reschedule()
with irqs disabled is in any way a bad idea, please let me know so I
can rearrange the code appropriately.

RCU is currently running reasonably well with the set of patches I have
submitted.  It the kernel is now withstanding a level of punishment that
would have reduced 2.6.28 (for example) to a steaming pile of bits, with
or without the help of rcutorture.  And I am now hitting the occasional
non-RCU bug, so I am starting to feel like RCU is approaching stability.
Approaching, but not there yet -- a few suspicious areas remain.  Time
to crank the testing up another notch or two.  ;-)

							Thanx, Paul

> > Thus, if some other processor execute modifying address when step2 to step4,
> > it will be jumped to fixup code.
> > 
> > This still has many limitations for modifying multi-instructions at once.
> > However, it is enough for 'a 5 bytes nop replacing with a jump' patching,
> > because;
> >  - Replaced instruction is just one instruction, which is executed atomically.
> >  - Replacing instruction is a jump, so we can set fixup address where the jump
> >    goes to.
> > 
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > ---
> >  arch/x86/include/asm/alternative.h |   12 ++++
> >  arch/x86/include/asm/kprobes.h     |    1 +
> >  arch/x86/kernel/alternative.c      |  120 ++++++++++++++++++++++++++++++++++++
> >  kernel/kprobes.c                   |    2 +-
> >  4 files changed, 134 insertions(+), 1 deletions(-)
> > 
> 
> [snip snip]
> 
> > index de7353c..af47f12 100644
> > --- a/arch/x86/kernel/alternative.c
> > +++ b/arch/x86/kernel/alternative.c
> > @@ -4,6 +4,7 @@
> >  #include <linux/list.h>
> >  #include <linux/stringify.h>
> >  #include <linux/kprobes.h>
> > +#include <linux/kdebug.h>
> >  #include <linux/mm.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/memory.h>
> > @@ -552,3 +553,122 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> >  	local_irq_restore(flags);
> >  	return addr;
> >  }
> > +
> > +/*
> > + * On pentium series, Unsynchronized cross-modifying code
> > + * operations can cause unexpected instruction execution results.
> > + * So after code modified, we should synchronize it on each processor.
> > + */
> > +static void __kprobes __local_sync_core(void *info)
> > +{
> > +	sync_core();
> > +}
> > +
> > +void __kprobes sync_core_all(void)
> > +{
> > +	on_each_cpu(__local_sync_core, NULL, 1);
> 
> OK, so you rely on the fact that on_each_cpu has memory barriers and
> executes the remote "__local_sync_core" with the appropriate memory
> barriers underneath, am I correct ?
> 
> > +}
> > +
> > +/* Safely cross-code modifying with fixup address */
> > +static void *patch_fixup_from;
> > +static void *patch_fixup_addr;
> > +
> > +static int __kprobes patch_exceptions_notify(struct notifier_block *self,
> > +					      unsigned long val, void *data)
> > +{
> > +	struct die_args *args = data;
> > +	struct pt_regs *regs = args->regs;
> > +
> > +	if (likely(!patch_fixup_from))
> > +		return NOTIFY_DONE;
> > +
> > +	if (val != DIE_INT3 || !regs || user_mode_vm(regs) ||
> > +	    (unsigned long)patch_fixup_from != regs->ip)
> > +		return NOTIFY_DONE;
> > +
> > +	args->regs->ip = (unsigned long)patch_fixup_addr;
> > +	return NOTIFY_STOP;
> > +}
> > +
> > +/**
> > + * text_poke_fixup() -- cross-modifying kernel text with fixup address.
> > + * @addr:	Modifying address.
> > + * @opcode:	New instruction.
> > + * @len:	length of modifying bytes.
> > + * @fixup:	Fixup address.
> > + *
> > + * Note: You must backup replaced instructions before calling this,
> > + * if you need to recover it.
> > + * Note: Must be called under text_mutex.
> > + */
> > +void *__kprobes text_poke_fixup(void *addr, const void *opcode, size_t len,
> > +				void *fixup)
> > +{
> > +	static const unsigned char int3_insn = BREAKPOINT_INSTRUCTION;
> > +	static const int int3_size = sizeof(int3_insn);
> > +
> > +	/* Replacing 1 byte can be done atomically. */
> 
> I'm sure it can be done atomically, but can it be done safely though ?
> 
> (disclaimer: we're still waiting for the official answer on this
> statement): Assuming instruction trace cache effects of SMP cross-code
> modification, and that only int3 would be safe to patch, then even
> changing 1 single byte could only be done by going to an intermediate
> int3 and synchronizing all other cores.
> 
> > +	if (unlikely(len <= 1))
> > +		return text_poke(addr, opcode, len);
> > +
> > +	/* Preparing */
> > +	patch_fixup_addr = fixup;
> > +	wmb();
> 
> hrm, missing comment ?
> 
> > +	patch_fixup_from = (u8 *)addr + int3_size; /* IP address after int3 */
> > +
> > +	/* Cap by an int3 */
> > +	text_poke(addr, &int3_insn, int3_size);
> > +	sync_core_all();
> > +
> > +	/* Replace tail bytes */
> > +	text_poke((char *)addr + int3_size, (const char *)opcode + int3_size,
> > +		  len - int3_size);
> > +	sync_core_all();
> > +
> > +	/* Replace int3 with head byte */
> > +	text_poke(addr, opcode, int3_size);
> > +	sync_core_all();
> > +
> > +	/* Cleanup */
> > +	patch_fixup_from = NULL;
> > +	wmb();
> 
> missing comment here too.
> 
> > +	return addr;
> 
> Little quiz question:
> 
> When patch_fixup_from is set to NULL, what ensures that the int3
> handlers have completed their execution ?
> 
> I think it's probably OK, because the int3 is an interrupt gate, which
> therefore disables interrupts as soon as it runs, and executes the
> notifier while irqs are off. When we run sync_core_all() after replacing
> the int3 by the new 1st byte, we only return when all other cores have
> executed an interrupt, which implies that all int3 handlers previously
> running should have ended. Is it right ? It looks to me as if this 3rd
> sync_core_all() is only needed because of that. Probably that adding a
> comment would be good.
> 
> 
> Another thing: I've recently noticed that the following locking seems to
> hang the system with doing stress-testing concurrently with cpu
> hotplug/hotunplug:
> 
> mutex_lock(&text_mutex);
>   on_each_cpu(something, NULL, 1);
> 
> The hang seems to be caused by the fact that alternative.c has:
> 
> within cpu hotplug (cpu hotplug lock held)
>   mutex_lock(&text_mutex);
> 
> It might also be caused by the interaction with the stop_machine()
> performed within the cpu hotplug lock. I did not find the root cause of
> the problem, but this probably calls for lockdep improvements.
> 
> In any case, given you are dealing with the exact same locking scenario
> here, I would recomment the following stress-test:
> 
> in a loop, use text_poke_jump()
> in a loop, hotunplug all cpus, then hotplug all cpus
> 
> I had to fix this temporarily by taking get/put_online_cpus() about the
> text_mutex.
> 
> [snip snip]
> 
> > +static struct notifier_block patch_exceptions_nb = {
> > +	.notifier_call = patch_exceptions_notify,
> > +	.priority = 0x7fffffff /* we need to be notified first */
> > +};
> > +
> > +static int __init patch_init(void)
> > +{
> > +	return register_die_notifier(&patch_exceptions_nb);
> > +}
> > +
> > +arch_initcall(patch_init);
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index e5342a3..43a30d8 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -898,7 +898,7 @@ EXPORT_SYMBOL_GPL(unregister_kprobes);
> >  
> >  static struct notifier_block kprobe_exceptions_nb = {
> >  	.notifier_call = kprobe_exceptions_notify,
> > -	.priority = 0x7fffffff /* we need to be notified first */
> > +	.priority = 0x7ffffff0 /* High priority, but not first.  */
> 
> It would be good to keep all these priorities in a centralized header.
> 
> Thanks,
> 
> Mathieu
> 
> >  };
> >  
> >  unsigned long __weak arch_deref_entry_point(void *entry)
> > -- 
> > 1.6.5.1
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
