Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbYACHZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbYACHZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYACHYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:24:21 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:42027 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbYACHYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:24:13 -0500
Message-Id: <20080103072227.087067007@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jan 2008 02:16:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 03/11] Annotate core code that should not be traced
Content-Disposition: inline; filename=mcount-annotate-generic-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark with "notrace" functions in core code that should not be
traced.  The "notrace" attribute will prevent gcc from adding
a call to mcount on the annotated funtions.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 drivers/clocksource/acpi_pm.c |    8 ++++----
 include/linux/preempt.h       |    4 ++--
 kernel/irq/handle.c           |    2 +-
 kernel/lockdep.c              |   27 ++++++++++++++-------------
 kernel/rcupdate.c             |    2 +-
 kernel/spinlock.c             |    2 +-
 lib/smp_processor_id.c        |    2 +-
 7 files changed, 24 insertions(+), 23 deletions(-)

Index: linux-compile.git/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-compile.git.orig/drivers/clocksource/acpi_pm.c	2007-12-20 01:00:29.000000000 -0500
+++ linux-compile.git/drivers/clocksource/acpi_pm.c	2007-12-20 01:00:48.000000000 -0500
@@ -30,13 +30,13 @@
  */
 u32 pmtmr_ioport __read_mostly;
 
-static inline u32 read_pmtmr(void)
+static inline notrace u32 read_pmtmr(void)
 {
 	/* mask the output to 24 bits */
 	return inl(pmtmr_ioport) & ACPI_PM_MASK;
 }
 
-u32 acpi_pm_read_verified(void)
+notrace u32 acpi_pm_read_verified(void)
 {
 	u32 v1 = 0, v2 = 0, v3 = 0;
 
@@ -56,12 +56,12 @@ u32 acpi_pm_read_verified(void)
 	return v2;
 }
 
-static cycle_t acpi_pm_read_slow(void)
+static notrace cycle_t acpi_pm_read_slow(void)
 {
 	return (cycle_t)acpi_pm_read_verified();
 }
 
-static cycle_t acpi_pm_read(void)
+static notrace cycle_t acpi_pm_read(void)
 {
 	return (cycle_t)read_pmtmr();
 }
Index: linux-compile.git/include/linux/preempt.h
===================================================================
--- linux-compile.git.orig/include/linux/preempt.h	2007-12-20 01:00:29.000000000 -0500
+++ linux-compile.git/include/linux/preempt.h	2007-12-20 01:00:48.000000000 -0500
@@ -11,8 +11,8 @@
 #include <linux/list.h>
 
 #ifdef CONFIG_DEBUG_PREEMPT
-  extern void fastcall add_preempt_count(int val);
-  extern void fastcall sub_preempt_count(int val);
+  extern notrace void fastcall add_preempt_count(int val);
+  extern notrace void fastcall sub_preempt_count(int val);
 #else
 # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
 # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
Index: linux-compile.git/kernel/irq/handle.c
===================================================================
--- linux-compile.git.orig/kernel/irq/handle.c	2007-12-20 01:00:29.000000000 -0500
+++ linux-compile.git/kernel/irq/handle.c	2007-12-20 01:00:48.000000000 -0500
@@ -163,7 +163,7 @@ irqreturn_t handle_IRQ_event(unsigned in
  * This is the original x86 implementation which is used for every
  * interrupt type.
  */
-fastcall unsigned int __do_IRQ(unsigned int irq)
+notrace fastcall unsigned int __do_IRQ(unsigned int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	struct irqaction *action;
Index: linux-compile.git/kernel/lockdep.c
===================================================================
--- linux-compile.git.orig/kernel/lockdep.c	2007-12-20 01:00:29.000000000 -0500
+++ linux-compile.git/kernel/lockdep.c	2007-12-20 01:00:48.000000000 -0500
@@ -270,14 +270,14 @@ static struct list_head chainhash_table[
 	((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
 	(key2))
 
-void lockdep_off(void)
+notrace void lockdep_off(void)
 {
 	current->lockdep_recursion++;
 }
 
 EXPORT_SYMBOL(lockdep_off);
 
-void lockdep_on(void)
+notrace void lockdep_on(void)
 {
 	current->lockdep_recursion--;
 }
@@ -1036,7 +1036,7 @@ find_usage_forwards(struct lock_class *s
  * Return 1 otherwise and keep <backwards_match> unchanged.
  * Return 0 on error.
  */
-static noinline int
+static noinline notrace int
 find_usage_backwards(struct lock_class *source, unsigned int depth)
 {
 	struct lock_list *entry;
@@ -1586,7 +1586,7 @@ static inline int validate_chain(struct 
  * We are building curr_chain_key incrementally, so double-check
  * it from scratch, to make sure that it's done correctly:
  */
-static void check_chain_key(struct task_struct *curr)
+static notrace void check_chain_key(struct task_struct *curr)
 {
 #ifdef CONFIG_DEBUG_LOCKDEP
 	struct held_lock *hlock, *prev_hlock = NULL;
@@ -1962,7 +1962,7 @@ static int mark_lock_irq(struct task_str
 /*
  * Mark all held locks with a usage bit:
  */
-static int
+static notrace int
 mark_held_locks(struct task_struct *curr, int hardirq)
 {
 	enum lock_usage_bit usage_bit;
@@ -2009,7 +2009,7 @@ void early_boot_irqs_on(void)
 /*
  * Hardirqs will be enabled:
  */
-void trace_hardirqs_on(void)
+notrace void trace_hardirqs_on(void)
 {
 	struct task_struct *curr = current;
 	unsigned long ip;
@@ -2057,7 +2057,7 @@ EXPORT_SYMBOL(trace_hardirqs_on);
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off(void)
+notrace void trace_hardirqs_off(void)
 {
 	struct task_struct *curr = current;
 
@@ -2241,8 +2241,8 @@ static inline int separate_irq_context(s
 /*
  * Mark a lock with a usage bit, and validate the state transition:
  */
-static int mark_lock(struct task_struct *curr, struct held_lock *this,
-		     enum lock_usage_bit new_bit)
+static notrace int mark_lock(struct task_struct *curr, struct held_lock *this,
+			     enum lock_usage_bit new_bit)
 {
 	unsigned int new_mask = 1 << new_bit, ret = 1;
 
@@ -2648,7 +2648,7 @@ __lock_release(struct lockdep_map *lock,
 /*
  * Check whether we follow the irq-flags state precisely:
  */
-static void check_flags(unsigned long flags)
+static notrace void check_flags(unsigned long flags)
 {
 #if defined(CONFIG_DEBUG_LOCKDEP) && defined(CONFIG_TRACE_IRQFLAGS)
 	if (!debug_locks)
@@ -2685,8 +2685,8 @@ static void check_flags(unsigned long fl
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
  */
-void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-		  int trylock, int read, int check, unsigned long ip)
+notrace void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
+			  int trylock, int read, int check, unsigned long ip)
 {
 	unsigned long flags;
 
@@ -2708,7 +2708,8 @@ void lock_acquire(struct lockdep_map *lo
 
 EXPORT_SYMBOL_GPL(lock_acquire);
 
-void lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
+notrace void lock_release(struct lockdep_map *lock, int nested,
+			  unsigned long ip)
 {
 	unsigned long flags;
 
Index: linux-compile.git/kernel/rcupdate.c
===================================================================
--- linux-compile.git.orig/kernel/rcupdate.c	2007-12-20 01:00:29.000000000 -0500
+++ linux-compile.git/kernel/rcupdate.c	2007-12-20 01:00:48.000000000 -0500
@@ -504,7 +504,7 @@ static int __rcu_pending(struct rcu_ctrl
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-int rcu_pending(int cpu)
+notrace int rcu_pending(int cpu)
 {
 	return __rcu_pending(&rcu_ctrlblk, &per_cpu(rcu_data, cpu)) ||
 		__rcu_pending(&rcu_bh_ctrlblk, &per_cpu(rcu_bh_data, cpu));
Index: linux-compile.git/kernel/spinlock.c
===================================================================
--- linux-compile.git.orig/kernel/spinlock.c	2007-12-20 01:00:29.000000000 -0500
+++ linux-compile.git/kernel/spinlock.c	2007-12-20 01:00:48.000000000 -0500
@@ -437,7 +437,7 @@ int __lockfunc _spin_trylock_bh(spinlock
 }
 EXPORT_SYMBOL(_spin_trylock_bh);
 
-int in_lock_functions(unsigned long addr)
+notrace int in_lock_functions(unsigned long addr)
 {
 	/* Linker adds these: start and end of __lockfunc functions */
 	extern char __lock_text_start[], __lock_text_end[];
Index: linux-compile.git/lib/smp_processor_id.c
===================================================================
--- linux-compile.git.orig/lib/smp_processor_id.c	2007-12-20 01:00:29.000000000 -0500
+++ linux-compile.git/lib/smp_processor_id.c	2007-12-20 01:00:48.000000000 -0500
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-unsigned int debug_smp_processor_id(void)
+notrace unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();

-- 
