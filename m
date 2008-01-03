Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYACRnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYACRnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYACRm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:42:56 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:58096 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbYACRmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:42:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPusfEdMROHU/2dsb2JhbACBV6hc
Date: Thu, 3 Jan 2008 12:42:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 03/11] Annotate core code that should not be traced
Message-ID: <20080103174250.GC30582@Krystal>
References: <20080103071609.478486470@goodmis.org> <20080103072227.087067007@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080103072227.087067007@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:37:01 up 60 days, 22:42,  5 users,  load average: 0.53, 1.24,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> Mark with "notrace" functions in core code that should not be
> traced.  The "notrace" attribute will prevent gcc from adding
> a call to mcount on the annotated funtions.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> ---
>  drivers/clocksource/acpi_pm.c |    8 ++++----
>  include/linux/preempt.h       |    4 ++--
>  kernel/irq/handle.c           |    2 +-
>  kernel/lockdep.c              |   27 ++++++++++++++-------------
>  kernel/rcupdate.c             |    2 +-
>  kernel/spinlock.c             |    2 +-
>  lib/smp_processor_id.c        |    2 +-
>  7 files changed, 24 insertions(+), 23 deletions(-)
> 
> Index: linux-compile.git/drivers/clocksource/acpi_pm.c
> ===================================================================
> --- linux-compile.git.orig/drivers/clocksource/acpi_pm.c	2007-12-20 01:00:29.000000000 -0500
> +++ linux-compile.git/drivers/clocksource/acpi_pm.c	2007-12-20 01:00:48.000000000 -0500
> @@ -30,13 +30,13 @@
>   */
>  u32 pmtmr_ioport __read_mostly;
>  
> -static inline u32 read_pmtmr(void)
> +static inline notrace u32 read_pmtmr(void)
>  {
>  	/* mask the output to 24 bits */
>  	return inl(pmtmr_ioport) & ACPI_PM_MASK;
>  }
>  
> -u32 acpi_pm_read_verified(void)
> +notrace u32 acpi_pm_read_verified(void)
>  {
>  	u32 v1 = 0, v2 = 0, v3 = 0;
>  
> @@ -56,12 +56,12 @@ u32 acpi_pm_read_verified(void)
>  	return v2;
>  }
>  
> -static cycle_t acpi_pm_read_slow(void)
> +static notrace cycle_t acpi_pm_read_slow(void)
>  {
>  	return (cycle_t)acpi_pm_read_verified();
>  }
>  
> -static cycle_t acpi_pm_read(void)
> +static notrace cycle_t acpi_pm_read(void)
>  {
>  	return (cycle_t)read_pmtmr();
>  }

What precision can you get from this clock source ? How many cycles are
required to read it ? Would it be useful to fall back on the CPU TSC
when they are synchronized ? Does acpi_pm_read_verified read the
timestamp atomically ? Is is a reason why you need to disable
interrupts, and therefore cannot trace NMI handlers ?

> Index: linux-compile.git/include/linux/preempt.h
> ===================================================================
> --- linux-compile.git.orig/include/linux/preempt.h	2007-12-20 01:00:29.000000000 -0500
> +++ linux-compile.git/include/linux/preempt.h	2007-12-20 01:00:48.000000000 -0500
> @@ -11,8 +11,8 @@
>  #include <linux/list.h>
>  
>  #ifdef CONFIG_DEBUG_PREEMPT
> -  extern void fastcall add_preempt_count(int val);
> -  extern void fastcall sub_preempt_count(int val);
> +  extern notrace void fastcall add_preempt_count(int val);
> +  extern notrace void fastcall sub_preempt_count(int val);
>  #else
>  # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
>  # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
> Index: linux-compile.git/kernel/irq/handle.c
> ===================================================================
> --- linux-compile.git.orig/kernel/irq/handle.c	2007-12-20 01:00:29.000000000 -0500
> +++ linux-compile.git/kernel/irq/handle.c	2007-12-20 01:00:48.000000000 -0500
> @@ -163,7 +163,7 @@ irqreturn_t handle_IRQ_event(unsigned in
>   * This is the original x86 implementation which is used for every
>   * interrupt type.
>   */
> -fastcall unsigned int __do_IRQ(unsigned int irq)
> +notrace fastcall unsigned int __do_IRQ(unsigned int irq)

Can you explain the notrace here ?

>  {
>  	struct irq_desc *desc = irq_desc + irq;
>  	struct irqaction *action;
> Index: linux-compile.git/kernel/lockdep.c
> ===================================================================
> --- linux-compile.git.orig/kernel/lockdep.c	2007-12-20 01:00:29.000000000 -0500
> +++ linux-compile.git/kernel/lockdep.c	2007-12-20 01:00:48.000000000 -0500
> @@ -270,14 +270,14 @@ static struct list_head chainhash_table[
>  	((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
>  	(key2))
>  
> -void lockdep_off(void)
> +notrace void lockdep_off(void)
>  {
>  	current->lockdep_recursion++;
>  }
>  

Due to interrupt disabling in your tracing code I suppose.

>  EXPORT_SYMBOL(lockdep_off);
>  
> -void lockdep_on(void)
> +notrace void lockdep_on(void)
>  {
>  	current->lockdep_recursion--;
>  }
> @@ -1036,7 +1036,7 @@ find_usage_forwards(struct lock_class *s
>   * Return 1 otherwise and keep <backwards_match> unchanged.
>   * Return 0 on error.
>   */
> -static noinline int
> +static noinline notrace int
>  find_usage_backwards(struct lock_class *source, unsigned int depth)
>  {
>  	struct lock_list *entry;
> @@ -1586,7 +1586,7 @@ static inline int validate_chain(struct 
>   * We are building curr_chain_key incrementally, so double-check
>   * it from scratch, to make sure that it's done correctly:
>   */
> -static void check_chain_key(struct task_struct *curr)
> +static notrace void check_chain_key(struct task_struct *curr)
>  {
>  #ifdef CONFIG_DEBUG_LOCKDEP
>  	struct held_lock *hlock, *prev_hlock = NULL;
> @@ -1962,7 +1962,7 @@ static int mark_lock_irq(struct task_str
>  /*
>   * Mark all held locks with a usage bit:
>   */
> -static int
> +static notrace int
>  mark_held_locks(struct task_struct *curr, int hardirq)
>  {
>  	enum lock_usage_bit usage_bit;
> @@ -2009,7 +2009,7 @@ void early_boot_irqs_on(void)
>  /*
>   * Hardirqs will be enabled:
>   */
> -void trace_hardirqs_on(void)
> +notrace void trace_hardirqs_on(void)
>  {
>  	struct task_struct *curr = current;
>  	unsigned long ip;
> @@ -2057,7 +2057,7 @@ EXPORT_SYMBOL(trace_hardirqs_on);
>  /*
>   * Hardirqs were disabled:
>   */
> -void trace_hardirqs_off(void)
> +notrace void trace_hardirqs_off(void)
>  {
>  	struct task_struct *curr = current;
>  
> @@ -2241,8 +2241,8 @@ static inline int separate_irq_context(s
>  /*
>   * Mark a lock with a usage bit, and validate the state transition:
>   */
> -static int mark_lock(struct task_struct *curr, struct held_lock *this,
> -		     enum lock_usage_bit new_bit)
> +static notrace int mark_lock(struct task_struct *curr, struct held_lock *this,
> +			     enum lock_usage_bit new_bit)
>  {
>  	unsigned int new_mask = 1 << new_bit, ret = 1;
>  
> @@ -2648,7 +2648,7 @@ __lock_release(struct lockdep_map *lock,
>  /*
>   * Check whether we follow the irq-flags state precisely:
>   */
> -static void check_flags(unsigned long flags)
> +static notrace void check_flags(unsigned long flags)
>  {
>  #if defined(CONFIG_DEBUG_LOCKDEP) && defined(CONFIG_TRACE_IRQFLAGS)
>  	if (!debug_locks)
> @@ -2685,8 +2685,8 @@ static void check_flags(unsigned long fl
>   * We are not always called with irqs disabled - do that here,
>   * and also avoid lockdep recursion:
>   */
> -void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> -		  int trylock, int read, int check, unsigned long ip)
> +notrace void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
> +			  int trylock, int read, int check, unsigned long ip)
>  {
>  	unsigned long flags;
>  
> @@ -2708,7 +2708,8 @@ void lock_acquire(struct lockdep_map *lo
>  
>  EXPORT_SYMBOL_GPL(lock_acquire);
>  
> -void lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
> +notrace void lock_release(struct lockdep_map *lock, int nested,
> +			  unsigned long ip)
>  {
>  	unsigned long flags;

Do you really use locks in your tracing code ? I thought you were using
per cpu buffers.

>  
> Index: linux-compile.git/kernel/rcupdate.c
> ===================================================================
> --- linux-compile.git.orig/kernel/rcupdate.c	2007-12-20 01:00:29.000000000 -0500
> +++ linux-compile.git/kernel/rcupdate.c	2007-12-20 01:00:48.000000000 -0500
> @@ -504,7 +504,7 @@ static int __rcu_pending(struct rcu_ctrl
>   * by the current CPU, returning 1 if so.  This function is part of the
>   * RCU implementation; it is -not- an exported member of the RCU API.
>   */
> -int rcu_pending(int cpu)
> +notrace int rcu_pending(int cpu)
>  {
>  	return __rcu_pending(&rcu_ctrlblk, &per_cpu(rcu_data, cpu)) ||
>  		__rcu_pending(&rcu_bh_ctrlblk, &per_cpu(rcu_bh_data, cpu));
> Index: linux-compile.git/kernel/spinlock.c
> ===================================================================
> --- linux-compile.git.orig/kernel/spinlock.c	2007-12-20 01:00:29.000000000 -0500
> +++ linux-compile.git/kernel/spinlock.c	2007-12-20 01:00:48.000000000 -0500
> @@ -437,7 +437,7 @@ int __lockfunc _spin_trylock_bh(spinlock
>  }
>  EXPORT_SYMBOL(_spin_trylock_bh);
>  
> -int in_lock_functions(unsigned long addr)
> +notrace int in_lock_functions(unsigned long addr)
>  {
>  	/* Linker adds these: start and end of __lockfunc functions */
>  	extern char __lock_text_start[], __lock_text_end[];
> Index: linux-compile.git/lib/smp_processor_id.c
> ===================================================================
> --- linux-compile.git.orig/lib/smp_processor_id.c	2007-12-20 01:00:29.000000000 -0500
> +++ linux-compile.git/lib/smp_processor_id.c	2007-12-20 01:00:48.000000000 -0500
> @@ -7,7 +7,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/sched.h>
>  
> -unsigned int debug_smp_processor_id(void)
> +notrace unsigned int debug_smp_processor_id(void)
>  {
>  	unsigned long preempt_count = preempt_count();
>  	int this_cpu = raw_smp_processor_id();
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
