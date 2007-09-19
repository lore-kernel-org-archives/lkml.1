Return-Path: <linux-kernel-owner+w=401wt.eu-S1763219AbXISRj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219AbXISRj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762732AbXISRib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:38:31 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53347 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763354AbXISRia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:38:30 -0400
Date: Wed, 19 Sep 2007 13:38:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [RESEND] [PATCH 2/11] UML - Fix timer switching
Message-ID: <20070919173819.GA10525@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ The first version of this patch conflicted with the irqstack fix
  merged last night - this is the fixed version ]

Fix up the switching between virtual and real timers.  The idle loop
sleeps, so the timer at that point must be real time.  At all other
times, the timer must be virtual.  Even when userspace is running, and
the kernel is asleep, the virtual timer is correct because the process
timer will be running and the process timer will be firing.

The timer switch used to be in the context switch and in the timer
handler code.  This is moved to the idle loop and the signal handler,
making it much more clear why it is happening.

switch_timers now returns the old timer type so that it may be
restored.  The signal handler uses this in order to restore the
previous timer type when it returns.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/os.h      |    2 +-
 arch/um/kernel/process.c  |    9 ++-------
 arch/um/os-Linux/signal.c |    9 +++------
 arch/um/os-Linux/time.c   |   27 ++++++++++++++++++++-------
 4 files changed, 26 insertions(+), 21 deletions(-)

Index: linux-2.6.20/arch/um/include/os.h
===================================================================
--- linux-2.6.20.orig/arch/um/include/os.h	2007-09-19 13:24:27.000000000 -0400
+++ linux-2.6.20/arch/um/include/os.h	2007-09-19 13:24:50.000000000 -0400
@@ -250,7 +250,7 @@ extern void os_dump_core(void);
 /* time.c */
 #define BILLION (1000 * 1000 * 1000)
 
-extern void switch_timers(int to_real);
+extern int switch_timers(int to_real);
 extern void idle_sleep(int secs);
 extern int set_interval(int is_virtual);
 extern void disable_timer(void);
Index: linux-2.6.20/arch/um/kernel/process.c
===================================================================
--- linux-2.6.20.orig/arch/um/kernel/process.c	2007-09-19 13:24:27.000000000 -0400
+++ linux-2.6.20/arch/um/kernel/process.c	2007-09-19 13:24:50.000000000 -0400
@@ -95,18 +95,11 @@ void *_switch_to(void *prev, void *next,
 	do {
 		current->thread.saved_task = NULL;
 
-		/* XXX need to check runqueues[cpu].idle */
-		if (current->pid == 0)
-			switch_timers(0);
-
 		switch_threads(&from->thread.switch_buf,
 			       &to->thread.switch_buf);
 
 		arch_switch_to(current->thread.prev_sched, current);
 
-		if (current->pid == 0)
-			switch_timers(1);
-
 		if (current->thread.saved_task)
 			show_regs(&(current->thread.regs));
 		next= current->thread.saved_task;
@@ -251,7 +244,9 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
+		switch_timers(1);
 		idle_sleep(10);
+		switch_timers(0);
 	}
 }
 
Index: linux-2.6.20/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/signal.c	2007-09-19 13:24:40.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/signal.c	2007-09-19 13:25:06.000000000 -0400
@@ -59,17 +59,11 @@ static void real_alarm_handler(int sig, 
 {
 	struct uml_pt_regs regs;
 
-	if (sig == SIGALRM)
-		switch_timers(0);
-
 	if (sc != NULL)
 		copy_sc(&regs, sc);
 	regs.is_user = 0;
 	unblock_signals();
 	timer_handler(sig, &regs);
-
-	if (sig == SIGALRM)
-		switch_timers(1);
 }
 
 void alarm_handler(int sig, struct sigcontext *sc)
@@ -116,6 +110,7 @@ void (*handlers[_NSIG])(int sig, struct 
 void handle_signal(int sig, struct sigcontext *sc)
 {
 	unsigned long pending = 1UL << sig;
+	int timer = switch_timers(0);
 
 	do {
 		int nested, bail;
@@ -152,6 +147,8 @@ void handle_signal(int sig, struct sigco
 		if (!nested)
 			pending = from_irq_stack(nested);
 	} while (pending);
+
+	switch_timers(timer);
 }
 
 extern void hard_handler(int sig);
Index: linux-2.6.20/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/time.c	2007-09-19 13:24:47.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/time.c	2007-09-19 13:24:50.000000000 -0400
@@ -12,6 +12,8 @@
 #include "os.h"
 #include "user.h"
 
+static int is_real_timer = 0;
+
 int set_interval(int is_virtual)
 {
 	int usec = 1000000/UM_HZ;
@@ -39,12 +41,14 @@ void disable_timer(void)
 	signal(SIGVTALRM, SIG_IGN);
 }
 
-void switch_timers(int to_real)
+int switch_timers(int to_real)
 {
 	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
-	struct itimerval enable = ((struct itimerval) { { 0, 1000000/UM_HZ },
-							{ 0, 1000000/UM_HZ }});
-	int old, new;
+	struct itimerval enable;
+	int old, new, old_type = is_real_timer;
+
+	if(to_real == old_type)
+		return to_real;
 
 	if (to_real) {
 		old = ITIMER_VIRTUAL;
@@ -55,10 +59,19 @@ void switch_timers(int to_real)
 		new = ITIMER_VIRTUAL;
 	}
 
-	if ((setitimer(old, &disable, NULL) < 0) ||
-	    (setitimer(new, &enable, NULL)))
-		printk(UM_KERN_ERR "switch_timers - setitimer failed, "
+	if (setitimer(old, &disable, &enable) < 0)
+		printk(UM_KERN_ERR "switch_timers - setitimer disable failed, "
+		       "errno = %d\n", errno);
+
+	if((enable.it_value.tv_sec == 0) && (enable.it_value.tv_usec == 0))
+		enable.it_value = enable.it_interval;
+
+	if (setitimer(new, &enable, NULL))
+		printk(UM_KERN_ERR "switch_timers - setitimer enable failed, "
 		       "errno = %d\n", errno);
+
+	is_real_timer = to_real;
+	return old_type;
 }
 
 unsigned long long os_nsecs(void)
