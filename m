Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYACSJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYACSJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYACSIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:08:54 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:43410 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYACSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:08:52 -0500
Date: Thu, 3 Jan 2008 13:07:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 03/11] Annotate core code that should not be traced
In-Reply-To: <20080103174250.GC30582@Krystal>
Message-ID: <Pine.LNX.4.58.0801031256240.4826@gandalf.stny.rr.com>
References: <20080103071609.478486470@goodmis.org> <20080103072227.087067007@goodmis.org>
 <20080103174250.GC30582@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 3 Jan 2008, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > Mark with "notrace" functions in core code that should not be
> > traced.  The "notrace" attribute will prevent gcc from adding
> > a call to mcount on the annotated funtions.
> >
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> >

> >
> > Index: linux-compile.git/drivers/clocksource/acpi_pm.c
> > ===================================================================
> > --- linux-compile.git.orig/drivers/clocksource/acpi_pm.c	2007-12-20 01:00:29.000000000 -0500
> > +++ linux-compile.git/drivers/clocksource/acpi_pm.c	2007-12-20 01:00:48.000000000 -0500
> > @@ -30,13 +30,13 @@
> >   */
> >  u32 pmtmr_ioport __read_mostly;
> >
> > -static inline u32 read_pmtmr(void)
> > +static inline notrace u32 read_pmtmr(void)
> >  {
> >  	/* mask the output to 24 bits */
> >  	return inl(pmtmr_ioport) & ACPI_PM_MASK;
> >  }
> >
> > -u32 acpi_pm_read_verified(void)
> > +notrace u32 acpi_pm_read_verified(void)
> >  {
> >  	u32 v1 = 0, v2 = 0, v3 = 0;
> >
> > @@ -56,12 +56,12 @@ u32 acpi_pm_read_verified(void)
> >  	return v2;
> >  }
> >
> > -static cycle_t acpi_pm_read_slow(void)
> > +static notrace cycle_t acpi_pm_read_slow(void)
> >  {
> >  	return (cycle_t)acpi_pm_read_verified();
> >  }
> >
> > -static cycle_t acpi_pm_read(void)
> > +static notrace cycle_t acpi_pm_read(void)
> >  {
> >  	return (cycle_t)read_pmtmr();
> >  }

Wow! a lot of questions in one paragraph! ;-)
>
> What precision can you get from this clock source ? How many cycles are
> required to read it ? Would it be useful to fall back on the CPU TSC
> when they are synchronized ? Does acpi_pm_read_verified read the
> timestamp atomically ? Is is a reason why you need to disable
> interrupts, and therefore cannot trace NMI handlers ?

This is taken from the RT patch, where the tracing happens on much more
than the mcount. It is used to locate latency hot spots, like timing how
long interrupts are disabled.  It uses whatever is considered the fastest
reliable clock source. Actually, for interrupts off, a simple TSC can be
used because the tracing is only per cpu. But there's also tracing of wake
up times, which can cross over CPUS.

If the TSC is syncronized then it can be used, but there's times when HPET
or ACPI is used. We add the notrace to these functions just so that we can
make them available to the tracing tool kit.  But just because they are
marked as notrace doesn't necessarily mean they have to be used.


>
> > Index: linux-compile.git/include/linux/preempt.h
> > ===================================================================
> > --- linux-compile.git.orig/include/linux/preempt.h	2007-12-20 01:00:29.000000000 -0500
> > +++ linux-compile.git/include/linux/preempt.h	2007-12-20 01:00:48.000000000 -0500
> > @@ -11,8 +11,8 @@
> >  #include <linux/list.h>
> >
> >  #ifdef CONFIG_DEBUG_PREEMPT
> > -  extern void fastcall add_preempt_count(int val);
> > -  extern void fastcall sub_preempt_count(int val);
> > +  extern notrace void fastcall add_preempt_count(int val);
> > +  extern notrace void fastcall sub_preempt_count(int val);
> >  #else
> >  # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
> >  # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
> > Index: linux-compile.git/kernel/irq/handle.c
> > ===================================================================
> > --- linux-compile.git.orig/kernel/irq/handle.c	2007-12-20 01:00:29.000000000 -0500
> > +++ linux-compile.git/kernel/irq/handle.c	2007-12-20 01:00:48.000000000 -0500
> > @@ -163,7 +163,7 @@ irqreturn_t handle_IRQ_event(unsigned in
> >   * This is the original x86 implementation which is used for every
> >   * interrupt type.
> >   */
> > -fastcall unsigned int __do_IRQ(unsigned int irq)
> > +notrace fastcall unsigned int __do_IRQ(unsigned int irq)
>
> Can you explain the notrace here ?

No.

;)

It came from the RT patch. I'll have to look deeper at these to see if
they are indeed necessary.

>
> >  {
> >  	struct irq_desc *desc = irq_desc + irq;
> >  	struct irqaction *action;
> > Index: linux-compile.git/kernel/lockdep.c
> > ===================================================================
> > --- linux-compile.git.orig/kernel/lockdep.c	2007-12-20 01:00:29.000000000 -0500
> > +++ linux-compile.git/kernel/lockdep.c	2007-12-20 01:00:48.000000000 -0500
> > @@ -270,14 +270,14 @@ static struct list_head chainhash_table[
> >  	((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
> >  	(key2))
> >
> > -void lockdep_off(void)
> > +notrace void lockdep_off(void)
> >  {
> >  	current->lockdep_recursion++;
> >  }
> >
>
> Due to interrupt disabling in your tracing code I suppose.

probably. Again, this came from the RT patch. And this stuff has been in
the patch for ages. So some of it was just plain paranoia. Others were
needed for some kind of tracing.

BTW, I'm curious? How do you handle NMIs and tracing. Do you use a
separate buffer for storing your data on NMIs or do you have some kind of
cmpxchg that can atomically reserve parts of the trace buffer?

I turn off interrupts in my tracing just to make the code simpler.

>
> >  EXPORT_SYMBOL(lockdep_off);
> >

> > -static void check_flags(unsigned long flags)
> > +static notrace void check_flags(unsigned long flags)
> >  {
> >  #if defined(CONFIG_DEBUG_LOCKDEP) && defined(CONFIG_TRACE_IRQFLAGS)
> >  	if (!debug_locks)
> > @@ -2685,8 +2685,8 @@ static void check_flags(unsigned long fl
> >   * We are not always called with irqs disabled - do that here,
> >   * and also avoid lockdep recursion:
> >   */
> > -void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> > -		  int trylock, int read, int check, unsigned long ip)
> > +notrace void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> > +			  int trylock, int read, int check, unsigned long ip)
> >  {
> >  	unsigned long flags;
> >
> > @@ -2708,7 +2708,8 @@ void lock_acquire(struct lockdep_map *lo
> >
> >  EXPORT_SYMBOL_GPL(lock_acquire);
> >
> > -void lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
> > +notrace void lock_release(struct lockdep_map *lock, int nested,
> > +			  unsigned long ip)
> >  {
> >  	unsigned long flags;
>
> Do you really use locks in your tracing code ? I thought you were using
> per cpu buffers.

No but the latency_tracer does. Again this could be just paranoid. I'm not
sure the "function trace" part of the latency trace does do this, but
other parts do. Again, I'll work on trimming down some of these "notrace"
and only add them when needed.

>
> >
> > Index: linux-compile.git/kernel/rcupdate.c
> > ===================================================================
> > --- linux-compile.git.orig/kernel/rcupdate.c	2007-12-20 01:00:29.000000000 -0500
> > +++ linux-compile.git/kernel/rcupdate.c	2007-12-20 01:00:48.000000000 -0500
> > @@ -504,7 +504,7 @@ static int __rcu_pending(struct rcu_ctrl
> >   * by the current CPU, returning 1 if so.  This function is part of the
> >   * RCU implementation; it is -not- an exported member of the RCU API.
> >   */
> > -int rcu_pending(int cpu)
> > +notrace int rcu_pending(int cpu)
> >  {
> >  	return __rcu_pending(&rcu_ctrlblk, &per_cpu(rcu_data, cpu)) ||
> >  		__rcu_pending(&rcu_bh_ctrlblk, &per_cpu(rcu_bh_data, cpu));
> > Index: linux-compile.git/kernel/spinlock.c
> > ===================================================================
> > --- linux-compile.git.orig/kernel/spinlock.c	2007-12-20 01:00:29.000000000 -0500
> > +++ linux-compile.git/kernel/spinlock.c	2007-12-20 01:00:48.000000000 -0500
> > @@ -437,7 +437,7 @@ int __lockfunc _spin_trylock_bh(spinlock
> >  }
> >  EXPORT_SYMBOL(_spin_trylock_bh);
> >
> > -int in_lock_functions(unsigned long addr)
> > +notrace int in_lock_functions(unsigned long addr)
> >  {
> >  	/* Linker adds these: start and end of __lockfunc functions */
> >  	extern char __lock_text_start[], __lock_text_end[];
> > Index: linux-compile.git/lib/smp_processor_id.c
> > ===================================================================
> > --- linux-compile.git.orig/lib/smp_processor_id.c	2007-12-20 01:00:29.000000000 -0500
> > +++ linux-compile.git/lib/smp_processor_id.c	2007-12-20 01:00:48.000000000 -0500
> > @@ -7,7 +7,7 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/sched.h>
> >
> > -unsigned int debug_smp_processor_id(void)
> > +notrace unsigned int debug_smp_processor_id(void)
> >  {
> >  	unsigned long preempt_count = preempt_count();
> >  	int this_cpu = raw_smp_processor_id();
> >
> > --

Thanks for the feedback,

-- Steve

