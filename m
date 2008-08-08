Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYHHTrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYHHTrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYHHTre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:47:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:53304 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYHHTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:47:34 -0400
Subject: Re: [PATCH] printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
References: <20080324122424.671168000@chello.nl>
	 <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
	 <1206382547.6437.131.camel@lappy>
	 <20080324115738.85c72bb5.akpm@linux-foundation.org>
	 <1218202249.8625.106.camel@twins>
	 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	 <1218215454.8625.133.camel@twins>
	 <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	 <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	 <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
	 <20080808121428.646a8b3c.akpm@linux-foundation.org>
	 <1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 21:47:09 +0200
Message-Id: <1218224829.29098.19.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 21:21 +0200, Peter Zijlstra wrote:

> The initial printk_tick() based implementation didn't suffer this
> problem, should we revert to that scheme?

Just in case people care..

---
Subject: printk: robustify printk

Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd
wakeup by polling from the timer tick.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/kernel.h   |    4 ++++
 kernel/printk.c          |   19 +++++++++++++++++--
 kernel/time/tick-sched.c |    2 +-
 kernel/timer.c           |    1 +
 4 files changed, 23 insertions(+), 3 deletions(-)

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
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -982,10 +982,25 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-void wake_up_klogd(void)
+static DEFINE_PER_CPU(int, printk_pending);
+
+void printk_tick(void)
 {
-	if (!oops_in_progress && waitqueue_active(&log_wait))
+	if (__get_cpu_var(printk_pending)) {
+		__get_cpu_var(printk_pending) = 0;
 		wake_up_interruptible(&log_wait);
+	}
+}
+
+int printk_needs_cpu(int cpu)
+{
+	return per_cpu(printk_pending, cpu);
+}
+
+void wake_up_klogd(void)
+{
+	if (waitqueue_active(&log_wait))
+		__get_cpu_var(printk_pending) = 1;
 }
 
 /**
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


