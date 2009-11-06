Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbZKFWGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbZKFWGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbZKFWGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:06:07 -0500
Received: from kroah.org ([198.145.64.141]:39821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759995AbZKFWGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:06:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:53 2009
Message-Id: <20091106215953.555767894@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [27/30] printk: robustify printk
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=printk-robustify-printk.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit b845b517b5e3706a3729f6ea83b88ab85f0725b0 upstream.

Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd
wakeup by polling from the timer tick.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kernel.h   |    4 ++++
 kernel/printk.c          |   19 +++++++++++++++++--
 kernel/time/tick-sched.c |    2 +-
 kernel/timer.c           |    1 +
 4 files changed, 23 insertions(+), 3 deletions(-)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
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
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -977,10 +977,25 @@ int is_console_locked(void)
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
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -261,7 +261,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	next_jiffies = get_next_timer_interrupt(last_jiffies);
 	delta_jiffies = next_jiffies - last_jiffies;
 
-	if (rcu_needs_cpu(cpu))
+	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
 		delta_jiffies = 1;
 	/*
 	 * Do not stop the tick, if we are only one off


