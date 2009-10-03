Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZJCOg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZJCOg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZJCOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:36:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:4387 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZJCOg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:36:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=G13w00n8NEtbKJVqcT6Jejq/+KauDB5s8lskZIUedSrnmpYqtrGiCmiAVuLpFt8hxi
         9YP6n/0kz8j5oJdCuzAYyfg5+7qsPtj6EzY4zTN5DHTsOA2bafpAJ1W3FJDG7pEYHVsD
         DHLH/49FBxwi4ngeFgAYcYRdFzCaI8BN+vUlM=
MIME-Version: 1.0
Date: Sat, 3 Oct 2009 07:36:30 -0700
Message-ID: <5fa495370910030736s4f2d8434y21c1b678bb4154ff@mail.gmail.com>
Subject: [PATCH] softlockup: allow checking for remote CPUs getting stuck in 
	irq
From: jia zhang <jia.zhang2008@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes softlockup be able to report the status of
remote CPUs even though they are getting stuck in irq context.
The approach is just to let each local softlockup_tick() check
for threshold timespan for all CPUs.

Signed-off-by: Jia Zhang <jia.zhang2008@gmail.com>
---
 kernel/softlockup.c |   74 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 81324d1..0e22deb 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -4,7 +4,7 @@
  * started by Ingo Molnar, Copyright (C) 2005, 2006 Red Hat, Inc.
  *
  * this code detects soft lockups: incidents in where on a CPU
- * the kernel does not reschedule for 10 seconds or more.
+ * the kernel does not reschedule for at most 60 seconds.
  */
 #include <linux/mm.h>
 #include <linux/cpu.h>
@@ -20,7 +20,7 @@

 #include <asm/irq_regs.h>

-static DEFINE_SPINLOCK(print_lock);
+static DEFINE_SPINLOCK(softlockup_lock);

 static DEFINE_PER_CPU(unsigned long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
@@ -101,31 +101,39 @@ int proc_dosoftlockup_thresh(struct ctl_table
*table, int write,
  * This callback runs from the timer interrupt, and checks
  * whether the watchdog thread has hung or not:
  */
-void softlockup_tick(void)
+static void __softlockup_tick(int cpu)
 {
-	int this_cpu = smp_processor_id();
-	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
+	int this_cpu;
+	unsigned long touch_timestamp;
 	unsigned long print_timestamp;
-	struct pt_regs *regs = get_irq_regs();
+	struct pt_regs *regs;
 	unsigned long now;
+	int cur_thresh = softlockup_thresh;

 	/* Is detection switched off? */
-	if (!per_cpu(watchdog_task, this_cpu) || softlockup_thresh <= 0) {
+	if (!per_cpu(watchdog_task, cpu) || cur_thresh <= 0) {
 		/* Be sure we don't false trigger if switched back on */
-		if (touch_timestamp)
-			per_cpu(touch_timestamp, this_cpu) = 0;
+		per_cpu(touch_timestamp, cpu) = 0;
 		return;
 	}

+	touch_timestamp = per_cpu(touch_timestamp, cpu);
 	if (touch_timestamp == 0) {
 		__touch_softlockup_watchdog();
 		return;
 	}

-	print_timestamp = per_cpu(print_timestamp, this_cpu);
+	print_timestamp = per_cpu(print_timestamp, cpu);
+	this_cpu = raw_smp_processor_id();

-	/* report at most once a second */
-	if (print_timestamp == touch_timestamp || did_panic)
+	/* report at most one time */
+	if (did_panic)
+		return;
+
+	if (cpu != this_cpu) {
+		if (print_timestamp >= touch_timestamp)
+			return;
+	} else if (print_timestamp == touch_timestamp)
 		return;

 	/* do not print during early bootup: */
@@ -134,39 +142,58 @@ void softlockup_tick(void)
 		return;
 	}

-	now = get_timestamp(this_cpu);
+	now = get_timestamp(cpu);

 	/*
 	 * Wake up the high-prio watchdog task twice per
 	 * threshold timespan.
 	 */
-	if (now > touch_timestamp + softlockup_thresh/2)
-		wake_up_process(per_cpu(watchdog_task, this_cpu));
+	if (now > touch_timestamp + cur_thresh/2)
+		wake_up_process(per_cpu(watchdog_task, cpu));

 	/* Warn about unreasonable delays: */
-	if (now <= (touch_timestamp + softlockup_thresh))
+	if (now <= (touch_timestamp + cur_thresh))
 		return;

-	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+	if (cpu != this_cpu) {
+		per_cpu(print_timestamp, cpu) = now;
+		printk(KERN_ERR "BUG: soft lockup - remote CPU#%d stuck for "
+						"at least %lus!\n", cpu, now - touch_timestamp);
+		return;
+	}

-	spin_lock(&print_lock);
-	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
+	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+	printk(KERN_ERR "BUG: soft lockup - local CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
 	print_modules();
 	print_irqtrace_events(current);
+	regs = get_irq_regs();
 	if (regs)
 		show_regs(regs);
 	else
 		dump_stack();
-	spin_unlock(&print_lock);

 	if (softlockup_panic)
 		panic("softlockup: hung tasks");
 }

+void softlockup_tick(void)
+{
+	int cpu;
+
+	if (!spin_trylock(&softlockup_lock))
+		return;
+
+	for_each_online_cpu(cpu)
+		__softlockup_tick(cpu);
+
+	spin_unlock(&softlockup_lock);
+}
+
 /*
- * The watchdog thread - runs every second and touches the timestamp.
+ * The watchdog thread - runs every half threshold timespan and
+ * touches the timestamp.
  */
 static int watchdog(void *__bind_cpu)
 {
@@ -179,8 +206,9 @@ static int watchdog(void *__bind_cpu)

 	set_current_state(TASK_INTERRUPTIBLE);
 	/*
-	 * Run briefly once per second to reset the softlockup timestamp.
-	 * If this gets delayed for more than 60 seconds then the
+	 * Run briefly once per half threshold timespan to reset the
+	 * softlockup timestamp.
+	 * If this gets delayed for more than threshold timespan then the
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
-- 
1.6.0.4
