Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZHYSEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZHYSEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZHYSEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:04:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33252 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbZHYSEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:04:47 -0400
Date: Tue, 25 Aug 2009 20:04:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] timer fixes
Message-ID: <20090825180434.GA31711@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Amerigo Wang (1):
      timers: Drop write permission on /proc/timer_list

Suresh Siddha (1):
      clockevent: Prevent dead lock on clockevents_lock


 arch/x86/kernel/process.c     |    6 +-----
 drivers/acpi/processor_idle.c |    6 ++++--
 kernel/time/clockevents.c     |   16 ++++++++++------
 kernel/time/tick-broadcast.c  |    7 +++----
 kernel/time/timer_list.c      |    2 +-
 5 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 994dd6a..071166a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -519,16 +519,12 @@ static void c1e_idle(void)
 		if (!cpumask_test_cpu(cpu, c1e_mask)) {
 			cpumask_set_cpu(cpu, c1e_mask);
 			/*
-			 * Force broadcast so ACPI can not interfere. Needs
-			 * to run with interrupts enabled as it uses
-			 * smp_function_call.
+			 * Force broadcast so ACPI can not interfere.
 			 */
-			local_irq_enable();
 			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
 					   &cpu);
 			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
 			       cpu);
-			local_irq_disable();
 		}
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0efa59e..66393d5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -162,8 +162,9 @@ static void lapic_timer_check_state(int state, struct acpi_processor *pr,
 		pr->power.timer_broadcast_on_state = state;
 }
 
-static void lapic_timer_propagate_broadcast(struct acpi_processor *pr)
+static void lapic_timer_propagate_broadcast(void *arg)
 {
+	struct acpi_processor *pr = (struct acpi_processor *) arg;
 	unsigned long reason;
 
 	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
@@ -635,7 +636,8 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 		working++;
 	}
 
-	lapic_timer_propagate_broadcast(pr);
+	smp_call_function_single(pr->id, lapic_timer_propagate_broadcast,
+				 pr, 1);
 
 	return (working);
 }
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index a6dcd67..620b58a 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -137,11 +137,12 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
  */
 int clockevents_register_notifier(struct notifier_block *nb)
 {
+	unsigned long flags;
 	int ret;
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 	ret = raw_notifier_chain_register(&clockevents_chain, nb);
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 
 	return ret;
 }
@@ -178,16 +179,18 @@ static void clockevents_notify_released(void)
  */
 void clockevents_register_device(struct clock_event_device *dev)
 {
+	unsigned long flags;
+
 	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 	BUG_ON(!dev->cpumask);
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 
 	list_add(&dev->list, &clockevent_devices);
 	clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
 	clockevents_notify_released();
 
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_register_device);
 
@@ -235,8 +238,9 @@ void clockevents_exchange_device(struct clock_event_device *old,
 void clockevents_notify(unsigned long reason, void *arg)
 {
 	struct list_head *node, *tmp;
+	unsigned long flags;
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
 
 	switch (reason) {
@@ -251,7 +255,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 	default:
 		break;
 	}
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 #endif
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 877dbed..c2ec250 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -205,11 +205,11 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
  */
-static void tick_do_broadcast_on_off(void *why)
+static void tick_do_broadcast_on_off(unsigned long *reason)
 {
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
-	unsigned long flags, *reason = why;
+	unsigned long flags;
 	int cpu, bc_stopped;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
@@ -276,8 +276,7 @@ void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
-		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
-					 &reason, 1);
+		tick_do_broadcast_on_off(&reason);
 }
 
 /*
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index a999b92..fddd69d 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -286,7 +286,7 @@ static int __init init_timer_list_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
+	pe = proc_create("timer_list", 0444, NULL, &timer_list_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
