Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYIYV5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYIYV5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYIYV5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:57:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYIYV5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:57:30 -0400
Date: Thu, 25 Sep 2008 23:56:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925215611.GA25701@elte.hu>
References: <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org> <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925214134.GA23025@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>           <idle>-0     [001]    52.291807: ktime_get <-tick_nohz_stop_sched_tick
>           <idle>-0     [001]    52.291807: ktime_get_ts <-ktime_get
>           <idle>-0     [001]    52.291808: getnstimeofday <-ktime_get_ts
>           <idle>-0     [001]    52.291808: acpi_pm_read <-getnstimeofday
>           <idle>-0     [001]    52.291810: set_normalized_timespec <-ktime_get_ts
>           <idle>-0     [001]    52.291811: get_next_timer_interrupt <-tick_nohz_stop_sched_tick
> 
> it worked just fine in my first blind attempt.

here is the observations from my second blind attempt - this time to 
show that we can trace even lockdep internals just fine.

I applied the patch attached below: it removes all the -pg removals from 
kernel/Makefile and restores the notrace markings in kernel/lockdep.c 
that commit 1d09daa5 ("ftrace: use Makefile to remove tracing from 
lockdep") removed.

then i enabled the whole lockdep machinery (to insert as much extra code 
as possible):

 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_LOCKDEP=y
 CONFIG_LOCK_STAT=y
 CONFIG_DEBUG_LOCKDEP=y
 CONFIG_TRACE_IRQFLAGS=y

and enabled ftrace function tracing:

 CONFIG_FTRACE=y
 CONFIG_DYNAMIC_FTRACE=y
 CONFIG_FTRACE_MCOUNT_RECORD=y

[ mcount-record is a new ftrace feature for v2.6.28 ]

and rebuilt and rebooted into the kernel, and enabled ftrace.

It worked just fine this time too, and i was able to trace inside 
lockdep and lockstat internals:

          <idle>-0     [001]    71.120828: _spin_lock <-tick_do_update_jiffies64
          <idle>-0     [001]    71.120829: __lock_acquire <-lock_acquire
          <idle>-0     [001]    71.120829: lock_acquired <-_spin_lock
          <idle>-0     [001]    71.120829: print_lock_contention_bug <-lock_acquired
          <idle>-0     [001]    71.120830: do_timer <-tick_do_update_jiffies64

this wasnt done since May this year (since commit 1d09daa5).

It's absolutely not unrobust. Yes, more code will always regress more 
than no code, but it's a cost/benefit balance not a design must-have. 
And to prove me wrong i'm sure we'll have some really bad cpu_clock() 
regression within the next 24 hours ;)

Why did we do commit 1d09daa5, 6ec56232 and c349e0a0 which marked all 
these .o's notrace? Partly to address a real (meanwhile fixed) 
regression wrt. sched_clock() [and this supports your point], partly to 
remove extra unnecessary trace entries from debug infrastructure, and 
partly out of pure paranoia: i didnt want to see _any_ ftrace lockup in 
mainline, i wanted it to have the kind of almost perfect track record 
that lockdep gathered.

Maybe that was the wrong thing to do as we hide certain trace entries - 
we could certainly apply the patch below. Hm?

	Ingo

------------->
Index: linux/kernel/Makefile
===================================================================
--- linux.orig/kernel/Makefile
+++ linux/kernel/Makefile
@@ -15,13 +15,11 @@ CFLAGS_REMOVE_sched.o = -mno-spe
 
 ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files
-CFLAGS_REMOVE_lockdep.o = -pg
 CFLAGS_REMOVE_lockdep_proc.o = -pg
 CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_sched.o = -mno-spe -pg
 endif
 
 obj-$(CONFIG_PROFILING) += profile.o
Index: linux/kernel/lockdep.c
===================================================================
--- linux.orig/kernel/lockdep.c
+++ linux/kernel/lockdep.c
@@ -283,14 +283,14 @@ static struct list_head chainhash_table[
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
@@ -1136,7 +1136,7 @@ find_usage_forwards(struct lock_class *s
  * Return 1 otherwise and keep <backwards_match> unchanged.
  * Return 0 on error.
  */
-static noinline int
+static noinline notrace int
 find_usage_backwards(struct lock_class *source, unsigned int depth)
 {
 	struct lock_list *entry;
@@ -1748,7 +1748,7 @@ static inline int validate_chain(struct 
  * We are building curr_chain_key incrementally, so double-check
  * it from scratch, to make sure that it's done correctly:
  */
-static void check_chain_key(struct task_struct *curr)
+static notrace void check_chain_key(struct task_struct *curr)
 {
 #ifdef CONFIG_DEBUG_LOCKDEP
 	struct held_lock *hlock, *prev_hlock = NULL;
@@ -2122,7 +2122,7 @@ static int mark_lock_irq(struct task_str
 /*
  * Mark all held locks with a usage bit:
  */
-static int
+static notrace int
 mark_held_locks(struct task_struct *curr, int hardirq)
 {
 	enum lock_usage_bit usage_bit;
@@ -2169,7 +2169,7 @@ void early_boot_irqs_on(void)
 /*
  * Hardirqs will be enabled:
  */
-void trace_hardirqs_on_caller(unsigned long a0)
+void notrace trace_hardirqs_on_caller(unsigned long a0)
 {
 	struct task_struct *curr = current;
 	unsigned long ip;
@@ -2215,7 +2215,7 @@ void trace_hardirqs_on_caller(unsigned l
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
-void trace_hardirqs_on(void)
+void notrace trace_hardirqs_on(void)
 {
 	trace_hardirqs_on_caller(CALLER_ADDR0);
 }
@@ -2224,7 +2224,7 @@ EXPORT_SYMBOL(trace_hardirqs_on);
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off_caller(unsigned long a0)
+void notrace trace_hardirqs_off_caller(unsigned long a0)
 {
 	struct task_struct *curr = current;
 
@@ -2249,7 +2249,7 @@ void trace_hardirqs_off_caller(unsigned 
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 
-void trace_hardirqs_off(void)
+void notrace trace_hardirqs_off(void)
 {
 	trace_hardirqs_off_caller(CALLER_ADDR0);
 }
@@ -2415,7 +2415,7 @@ static inline int separate_irq_context(s
 /*
  * Mark a lock with a usage bit, and validate the state transition:
  */
-static int mark_lock(struct task_struct *curr, struct held_lock *this,
+static notrace int mark_lock(struct task_struct *curr, struct held_lock *this,
 			     enum lock_usage_bit new_bit)
 {
 	unsigned int new_mask = 1 << new_bit, ret = 1;
@@ -2869,7 +2869,7 @@ __lock_release(struct lockdep_map *lock,
 /*
  * Check whether we follow the irq-flags state precisely:
  */
-static void check_flags(unsigned long flags)
+static notrace void check_flags(unsigned long flags)
 {
 #if defined(CONFIG_PROVE_LOCKING) && defined(CONFIG_DEBUG_LOCKDEP) && \
     defined(CONFIG_TRACE_IRQFLAGS)
@@ -2927,7 +2927,7 @@ EXPORT_SYMBOL_GPL(lock_set_subclass);
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
  */
-void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
+notrace void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check,
 			  struct lockdep_map *nest_lock, unsigned long ip)
 {
@@ -2948,7 +2948,7 @@ void lock_acquire(struct lockdep_map *lo
 
 EXPORT_SYMBOL_GPL(lock_acquire);
 
-void lock_release(struct lockdep_map *lock, int nested,
+notrace void lock_release(struct lockdep_map *lock, int nested,
 			  unsigned long ip)
 {
 	unsigned long flags;
