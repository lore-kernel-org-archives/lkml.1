Return-Path: <linux-kernel-owner+w=401wt.eu-S1763616AbXISRkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763616AbXISRkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763300AbXISRie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:38:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53349 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763354AbXISRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:38:33 -0400
Date: Wed, 19 Sep 2007 13:38:20 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [RESEND] [PATCH 9/11] UML - Eliminate interrupts in the idle loop
Message-ID: <20070919173820.GA10520@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ The first version of this patch conflicted with the irqstack fix
  merged last night - this is the fixed version ]

Now, the idle loop now longer needs SIGALRM firing - it can just sleep
for the requisite amount of time and fake a timer interrupt when it
finishes.

Any use of ITIMER_REAL now goes away.  disable_timer only turns off
ITIMER_VIRTUAL.  switch_timers is no longer needed, so it, and all
calls, goes away.

disable_timer now returns the amount of time remaining on the timer.
default_idle uses this to tell idle_sleep how long to sleep.
idle_sleep will call alarm_handler if nanosleep returns 0, which is
the case if it didn't return early due to an interrupt.  Otherwise, it
just returns.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/os.h      |    5 +---
 arch/um/kernel/process.c  |    7 +++--
 arch/um/os-Linux/signal.c |    3 --
 arch/um/os-Linux/time.c   |   54 +++++++++-------------------------------------
 4 files changed, 17 insertions(+), 52 deletions(-)

Index: linux-2.6.20/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/time.c	2007-09-19 13:25:32.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/time.c	2007-09-19 13:25:35.000000000 -0400
@@ -12,8 +12,6 @@
 #include "os.h"
 #include "user.h"
 
-static int is_real_timer = 0;
-
 int set_interval(void)
 {
 	int usec = 1000000/UM_HZ;
@@ -53,47 +51,15 @@ static inline unsigned long long tv_to_n
 		tv->tv_usec * 1000;
 }
 
-void disable_timer(void)
+unsigned long long disable_timer(void)
 {
-	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
+	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
 
-	if ((setitimer(ITIMER_VIRTUAL, &disable, NULL) < 0) ||
-	    (setitimer(ITIMER_REAL, &disable, NULL) < 0))
+	if(setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
-}
-
-int switch_timers(int to_real)
-{
-	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
-	struct itimerval enable;
-	int old, new, old_type = is_real_timer;
-
-	if(to_real == old_type)
-		return to_real;
-
-	if (to_real) {
-		old = ITIMER_VIRTUAL;
-		new = ITIMER_REAL;
-	}
-	else {
-		old = ITIMER_REAL;
-		new = ITIMER_VIRTUAL;
-	}
-
-	if (setitimer(old, &disable, &enable) < 0)
-		printk(UM_KERN_ERR "switch_timers - setitimer disable failed, "
-		       "errno = %d\n", errno);
-
-	if((enable.it_value.tv_sec == 0) && (enable.it_value.tv_usec == 0))
-		enable.it_value = enable.it_interval;
 
-	if (setitimer(new, &enable, NULL))
-		printk(UM_KERN_ERR "switch_timers - setitimer enable failed, "
-		       "errno = %d\n", errno);
-
-	is_real_timer = to_real;
-	return old_type;
+	return tv_to_nsec(&time.it_value);
 }
 
 unsigned long long os_nsecs(void)
@@ -104,11 +70,13 @@ unsigned long long os_nsecs(void)
 	return tv_to_nsec(&tv);
 }
 
-void idle_sleep(int secs)
+extern void alarm_handler(int sig, struct sigcontext *sc);
+
+void idle_sleep(unsigned long long nsecs)
 {
-	struct timespec ts;
+	struct timespec ts = { .tv_sec	= nsecs / BILLION,
+			       .tv_nsec = nsecs % BILLION };
 
-	ts.tv_sec = secs;
-	ts.tv_nsec = 0;
-	nanosleep(&ts, NULL);
+	if (nanosleep(&ts, &ts) == 0)
+		alarm_handler(SIGVTALRM, NULL);
 }
Index: linux-2.6.20/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/signal.c	2007-09-19 13:25:29.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/signal.c	2007-09-19 13:25:51.000000000 -0400
@@ -120,7 +120,6 @@ void (*handlers[_NSIG])(int sig, struct 
 void handle_signal(int sig, struct sigcontext *sc)
 {
 	unsigned long pending = 1UL << sig;
-	int timer = switch_timers(0);
 
 	do {
 		int nested, bail;
@@ -157,8 +156,6 @@ void handle_signal(int sig, struct sigco
 		if (!nested)
 			pending = from_irq_stack(nested);
 	} while (pending);
-
-	switch_timers(timer);
 }
 
 extern void hard_handler(int sig);
Index: linux-2.6.20/arch/um/kernel/process.c
===================================================================
--- linux-2.6.20.orig/arch/um/kernel/process.c	2007-09-19 13:25:32.000000000 -0400
+++ linux-2.6.20/arch/um/kernel/process.c	2007-09-19 13:25:35.000000000 -0400
@@ -235,6 +235,8 @@ void initial_thread_cb(void (*proc)(void
 
 void default_idle(void)
 {
+	unsigned long long nsecs;
+
 	while(1) {
 		/* endless idle loop with no priority at all */
 
@@ -246,9 +248,8 @@ void default_idle(void)
 			schedule();
 
 		tick_nohz_stop_sched_tick();
-		switch_timers(1);
-		idle_sleep(10);
-		switch_timers(0);
+		nsecs = disable_timer();
+		idle_sleep(nsecs);
 		tick_nohz_restart_sched_tick();
 	}
 }
Index: linux-2.6.20/arch/um/include/os.h
===================================================================
--- linux-2.6.20.orig/arch/um/include/os.h	2007-09-19 13:25:32.000000000 -0400
+++ linux-2.6.20/arch/um/include/os.h	2007-09-19 13:25:35.000000000 -0400
@@ -251,11 +251,10 @@ extern void os_dump_core(void);
 /* time.c */
 #define BILLION (1000 * 1000 * 1000)
 
-extern int switch_timers(int to_real);
-extern void idle_sleep(int secs);
+extern void idle_sleep(unsigned long long nsecs);
 extern int set_interval(void);
 extern int timer_one_shot(int ticks);
-extern void disable_timer(void);
+extern unsigned long long disable_timer(void);
 extern void uml_idle_timer(void);
 extern unsigned long long os_nsecs(void);
 
