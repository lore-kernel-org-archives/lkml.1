Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbYHKLvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbYHKLvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYHKLve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:51:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38727 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbYHKLvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:51:33 -0400
Date: Mon, 11 Aug 2008 13:51:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811115109.GB23529@elte.hu>
References: <1218215454.8625.133.camel@twins> <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <1218452640.10800.58.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218452640.10800.58.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > We could clean this up further by integrating the rcu_needs_cpu() 
> > and printk_needs_cpu() into a softirq mechanism. We already check 
> > for pending softirqs in tick-sched.c, so the above complication 
> > would go away completely.
> 
> RCU depends on the polling to advance the state machine, if you want 
> an event driven state machine, you'd have to drive it from 
> rcu_read_unlock() adding overhead there - and I'm pretty sure you 
> don't want to do that.
> 
> So while its a tad ugly to poll for these states, I'm not too worried 
> in these two cases - of course every additional poll needs good 
> justification.

ok - i guess we can declare stop_tick a slowpath as well (we are on the 
way towards idling).

> > ( But that's for a separate cleanup patch i think. )
> > 
> > No strong feelings though. Peter, which one do you prefer?
> 
> I personally prefer this printk_tick() driven one over the RCU driven 
> one because it doesn't trade deadlocks.

i've started testing it in tip/core/printk to give it some track record 
- thanks Peter.

Linus, any strong opinion against Peter's patch below (or in favor of 
the RCU patch)? Tentatively for v2.6.28 i'd say, to give people time to 
object to the async behavior.

	Ingo

----------------->
>From b845b517b5e3706a3729f6ea83b88ab85f0725b0 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 8 Aug 2008 21:47:09 +0200
Subject: [PATCH] printk: robustify printk

Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd
wakeup by polling from the timer tick.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h   |    4 ++++
 kernel/printk.c          |   19 +++++++++++++++++--
 kernel/time/tick-sched.c |    2 +-
 kernel/timer.c           |    1 +
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index aaa998f..113ac8d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -200,6 +200,8 @@ extern struct ratelimit_state printk_ratelimit_state;
 extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
+extern void printk_tick(void);
+extern int printk_needs_cpu(int);
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
@@ -211,6 +213,8 @@ static inline int printk_ratelimit(void) { return 0; }
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
+static inline void printk_tick(void) { }
+static inline int printk_needs_cpu(int) { return 0; }
 #endif
 
 extern void asmlinkage __attribute__((format(printf, 1, 2)))
diff --git a/kernel/printk.c b/kernel/printk.c
index b51b156..655cc2c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
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
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 825b4c0..c13d4f1 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -255,7 +255,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	next_jiffies = get_next_timer_interrupt(last_jiffies);
 	delta_jiffies = next_jiffies - last_jiffies;
 
-	if (rcu_needs_cpu(cpu))
+	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
 		delta_jiffies = 1;
 	/*
 	 * Do not stop the tick, if we are only one off
diff --git a/kernel/timer.c b/kernel/timer.c
index 03bc7f1..510fe69 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -978,6 +978,7 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
+	printk_tick();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
