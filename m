Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbXISRDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbXISRDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbXISRDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:03:10 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53158 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbXISRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:03:05 -0400
Date: Wed, 19 Sep 2007 13:02:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/11] UML - GENERIC_CLOCKEVENTS support
Message-ID: <20070919170225.GA10186@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable CONFIG_GENERIC_CLOCKEVENTS.

timer_irq gets its name changed to timer_handler, and becomes the
recipient of timer signals.

The clock_event_device is set up to imitate the current ticking clock,
i.e. CLOCK_EVT_FEAT_ONESHOT is not enabled yet.

disable_timer now doesn't ignore SIGALRM and SIGVTALRM because that
breaks delay calibration.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Kconfig         |    4 +
 arch/um/defconfig       |    3 +
 arch/um/kernel/time.c   |   99 ++++++++++++++++++++++--------------------------
 arch/um/os-Linux/time.c |    4 -
 4 files changed, 54 insertions(+), 56 deletions(-)

Index: linux-2.6.20/arch/um/Kconfig
===================================================================
--- linux-2.6.20.orig/arch/um/Kconfig	2007-09-19 12:25:06.000000000 -0400
+++ linux-2.6.20/arch/um/Kconfig	2007-09-19 12:25:07.000000000 -0400
@@ -59,6 +59,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
 	bool
Index: linux-2.6.20/arch/um/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/kernel/time.c	2007-09-19 12:25:06.000000000 -0400
+++ linux-2.6.20/arch/um/kernel/time.c	2007-09-19 12:25:07.000000000 -0400
@@ -3,6 +3,7 @@
  * Licensed under the GPL
  */
 
+#include "linux/clockchips.h"
 #include "linux/interrupt.h"
 #include "linux/jiffies.h"
 #include "linux/threads.h"
@@ -24,9 +25,10 @@ static unsigned long long prev_nsecs[NR_
 static long long delta[NR_CPUS];		/* Deviation per interval */
 #endif
 
-void timer_irq(struct uml_pt_regs *regs)
+void timer_handler(int sig, struct uml_pt_regs *regs)
 {
 	unsigned long long ticks = 0;
+	unsigned long flags;
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
 	int c = cpu();
 	if (prev_nsecs[c]) {
@@ -47,89 +49,82 @@ void timer_irq(struct uml_pt_regs *regs)
 #else
 	ticks = 1;
 #endif
+
+	local_irq_save(flags);
 	while (ticks > 0) {
 		do_IRQ(TIMER_IRQ, regs);
 		ticks--;
 	}
+	local_irq_restore(flags);
 }
 
-/* Protects local_offset */
-static DEFINE_SPINLOCK(timer_spinlock);
-static unsigned long long local_offset = 0;
-
-static inline unsigned long long get_time(void)
+static void itimer_set_mode(enum clock_event_mode mode,
+			    struct clock_event_device *evt)
 {
-	unsigned long long nsecs;
-	unsigned long flags;
-
-	spin_lock_irqsave(&timer_spinlock, flags);
-	nsecs = os_nsecs();
-	nsecs += local_offset;
-	spin_unlock_irqrestore(&timer_spinlock, flags);
+	switch(mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		set_interval();
+		break;
+
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		disable_timer();
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		BUG();
+		break;
 
-	return nsecs;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+	}
 }
 
-irqreturn_t um_timer(int irq, void *dev)
-{
-	unsigned long long nsecs;
-	unsigned long flags;
-
-	write_seqlock_irqsave(&xtime_lock, flags);
+static struct clock_event_device itimer_clockevent = {
+	.name		= "itimer",
+	.rating		= 250,
+	.cpumask	= CPU_MASK_ALL,
+	.features	= CLOCK_EVT_FEAT_PERIODIC,
+	.set_mode	= itimer_set_mode,
+	.set_next_event = NULL,
+	.shift		= 32,
+	.irq		= 0,
+};
 
-	do_timer(1);
-
-#ifdef CONFIG_UML_REAL_TIME_CLOCK
-	nsecs = get_time();
-#else
-	nsecs = (unsigned long long) xtime.tv_sec * BILLION + xtime.tv_nsec +
-		BILLION / HZ;
-#endif
-	xtime.tv_sec = nsecs / NSEC_PER_SEC;
-	xtime.tv_nsec = nsecs - xtime.tv_sec * NSEC_PER_SEC;
-
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+static irqreturn_t um_timer(int irq, void *dev)
+{
+	(*itimer_clockevent.event_handler)(&itimer_clockevent);
 
 	return IRQ_HANDLED;
 }
 
-static void register_timer(void)
+static void __init setup_itimer(void)
 {
 	int err;
 
-	timer_init();
-
 	err = request_irq(TIMER_IRQ, um_timer, IRQF_DISABLED, "timer", NULL);
 	if (err != 0)
 		printk(KERN_ERR "register_timer : request_irq failed - "
 		       "errno = %d\n", -err);
 
-	err = set_interval();
-	if (err != 0)
-		printk(KERN_ERR "register_timer : set_interval failed - "
-		       "errno = %d\n", -err);
+	itimer_clockevent.mult = div_sc(HZ, NSEC_PER_SEC, 32);
+	itimer_clockevent.max_delta_ns =
+		clockevent_delta2ns(60 * HZ, &itimer_clockevent);
+	itimer_clockevent.min_delta_ns =
+		clockevent_delta2ns(1, &itimer_clockevent);
+	clockevents_register_device(&itimer_clockevent);
 }
 
 extern void (*late_time_init)(void);
 
-void time_init(void)
+void __init time_init(void)
 {
 	long long nsecs;
 
+	timer_init();
+
 	nsecs = os_nsecs();
 	set_normalized_timespec(&wall_to_monotonic, -nsecs / BILLION,
 				-nsecs % BILLION);
 	set_normalized_timespec(&xtime, nsecs / BILLION, nsecs % BILLION);
-	late_time_init = register_timer;
-}
-
-void timer_handler(int sig, struct uml_pt_regs *regs)
-{
-	if (current_thread->cpu == 0)
-		timer_irq(regs);
-	local_irq_disable();
-	irq_enter();
-	update_process_times(regs->is_user);
-	irq_exit();
-	local_irq_enable();
+	late_time_init = setup_itimer;
 }
Index: linux-2.6.20/arch/um/defconfig
===================================================================
--- linux-2.6.20.orig/arch/um/defconfig	2007-09-19 12:24:52.000000000 -0400
+++ linux-2.6.20/arch/um/defconfig	2007-09-19 12:25:07.000000000 -0400
@@ -73,6 +73,9 @@ CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_TICK_ONESHOT is not set
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
 CONFIG_LD_SCRIPT_DYN=y
 CONFIG_NET=y
 CONFIG_BINFMT_ELF=y
Index: linux-2.6.20/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/os-Linux/time.c	2007-09-19 12:25:05.000000000 -0400
+++ linux-2.6.20/arch/um/os-Linux/time.c	2007-09-19 12:25:07.000000000 -0400
@@ -34,10 +34,6 @@ void disable_timer(void)
 	    (setitimer(ITIMER_REAL, &disable, NULL) < 0))
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
-
-	/* If there are signals already queued, after unblocking ignore them */
-	signal(SIGALRM, SIG_IGN);
-	signal(SIGVTALRM, SIG_IGN);
 }
 
 int switch_timers(int to_real)
