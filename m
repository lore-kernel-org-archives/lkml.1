Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbYHHNbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbYHHNbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 09:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYHHNaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 09:30:55 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:16017 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbYHHNay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 09:30:54 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20080324115738.85c72bb5.akpm@linux-foundation.org>
References: <20080324122424.671168000@chello.nl>
	 <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
	 <1206382547.6437.131.camel@lappy>
	 <20080324115738.85c72bb5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 15:30:49 +0200
Message-Id: <1218202249.8625.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-24 at 11:57 -0700, Andrew Morton wrote:
> On Mon, 24 Mar 2008 19:15:47 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > How about I use the lockdep infrastructure to check if printk() is
> > invoked whole holding either xtime or rq lock, and then avoid calling
> > wake_up_klogd(). That way, we at least get sane debug output when the
> > lock debugging infrastructure is enabled?
> 
> The core problem seems to be that printk shouldn't be calling wake_up(). 
> Can we fix that?
> 
> I expect it would be acceptable to do it from the timer interrupt instead. 
> For NOHZ kernels a poll when we enter the idle loop would also be needed. 

Something along the lines of the below patch?

> But does that cover everything?  Is it possible for a CPU to run 100% busy
> while not receiving timer interrupts?  I guess so.  To receive no
> interrupts at all?  Also possible.

local_irq_disable(); while (1);

But I guess you have more pressing issues when that happens..

---
Subject: printk: robustify printk wakeup behaviour

The klogd wakeup in the printk patch can cause deadlocks when holding the
rq->lock and or xtime_lock for writing.

Avoid doing the wakeup under certain conditions and delay it to the next jiffy
tick.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kernel.h   |    4 ++++
 include/linux/seqlock.h  |    5 +++++
 kernel/printk.c          |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/time/tick-sched.c |    2 +-
 kernel/timer.c           |    1 +
 5 files changed, 57 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -200,6 +200,8 @@ extern struct ratelimit_state printk_rat
 extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
+extern void printk_tick(void);
+extern int printk_needs_cpu(int);
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
@@ -211,6 +213,8 @@ static inline int printk_ratelimit(void)
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
+static inline void printk_tick(void) { }
+static inline int printk_needs_cpu(int) { return 0; }
 #endif
 
 extern void asmlinkage __attribute__((format(printf, 1, 2)))
Index: linux-2.6/include/linux/seqlock.h
===================================================================
--- linux-2.6.orig/include/linux/seqlock.h
+++ linux-2.6/include/linux/seqlock.h
@@ -71,6 +71,11 @@ static inline void write_sequnlock(seqlo
 	spin_unlock(&sl->lock);
 }
 
+static inline int seq_is_writelocked(seqlock_t *sl)
+{
+	return spin_is_locked(&sl->lock);
+}
+
 static inline int write_tryseqlock(seqlock_t *sl)
 {
 	int ret = spin_trylock(&sl->lock);
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/time.h>
 
 #include <asm/uaccess.h>
 
@@ -982,12 +983,56 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-void wake_up_klogd(void)
+static int printk_pending;
+
+void __wake_up_klogd(void)
 {
+	if (printk_pending)
+		printk_pending = 0;
+
 	if (!oops_in_progress && waitqueue_active(&log_wait))
 		wake_up_interruptible(&log_wait);
 }
 
+int printk_needs_cpu(int cpu)
+{
+	if (!printk_pending)
+		return 0;
+
+	/*
+	 * Stop the last awake CPU from entering NOHZ state when there still
+	 * is a klogd to kick.
+	 */
+	return (cpu_weight(cpu_online_map) - cpus_weight(nohz_cpu_mask)) == 1;
+}
+
+void printk_tick(void)
+{
+	if (unlikely(printk_pending))
+		__wake_up_klogd();
+}
+
+static int printk_do_wakeup(void)
+{
+	if (irqs_disabled())
+		return 0;
+
+#ifdef CONFIG_HRTICK
+	if (seq_is_writelocked(&xtime_lock))
+		return 0;
+#endif
+
+	return 1;
+}
+
+void wake_up_klogd(void)
+{
+	if (printk_do_wakeup())
+		__wake_up_klogd();
+	else
+		printk_pending = 1;
+}
+
 /**
  * release_console_sem - unlock the console system
  *
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -255,7 +255,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	next_jiffies = get_next_timer_interrupt(last_jiffies);
 	delta_jiffies = next_jiffies - last_jiffies;
 
-	if (rcu_needs_cpu(cpu))
+	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
 		delta_jiffies = 1;
 	/*
 	 * Do not stop the tick, if we are only one off
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -978,6 +978,7 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
+	printk_tick();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }


