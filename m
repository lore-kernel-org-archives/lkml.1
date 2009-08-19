Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZHSQS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZHSQS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZHSQS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:18:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:59359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZHSQSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:18:55 -0400
Date: Wed, 19 Aug 2009 16:18:34 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, len.brown@intel.com
In-Reply-To: <1250544899.2709.210.camel@sbs-t61.sc.intel.com>
References: <1250544899.2709.210.camel@sbs-t61.sc.intel.com>
Subject: [tip:timers/urgent] clockevent: Prevent dead lock on clockevents_lock
Message-ID: <tip-f833bab87fca5c3ce13778421b1365845843b976@git.kernel.org>
Git-Commit-ID: f833bab87fca5c3ce13778421b1365845843b976
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 16:18:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f833bab87fca5c3ce13778421b1365845843b976
Gitweb:     http://git.kernel.org/tip/f833bab87fca5c3ce13778421b1365845843b976
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 17 Aug 2009 14:34:59 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Aug 2009 18:15:10 +0200

clockevent: Prevent dead lock on clockevents_lock

Currently clockevents_notify() is called with interrupts enabled at
some places and interrupts disabled at some other places.

This results in a deadlock in this scenario.

cpu A holds clockevents_lock in clockevents_notify() with irqs enabled
cpu B waits for clockevents_lock in clockevents_notify() with irqs disabled
cpu C doing set_mtrr() which will try to rendezvous of all the cpus.

This will result in C and A come to the rendezvous point and waiting
for B. B is stuck forever waiting for the spinlock and thus not
reaching the rendezvous point.

Fix the clockevents code so that clockevents_lock is taken with
interrupts disabled and thus avoid the above deadlock.

Also call lapic_timer_propagate_broadcast() on the destination cpu so
that we avoid calling smp_call_function() in the clockevents notifier
chain.

This issue left us wondering if we need to change the MTRR rendezvous
logic to use stop machine logic (instead of smp_call_function) or add
a check in spinlock debug code to see if there are other spinlocks
which gets taken under both interrupts enabled/disabled conditions.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: "Pallipadi Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Brown Len" <len.brown@intel.com>
LKML-Reference: <1250544899.2709.210.camel@sbs-t61.sc.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/x86/kernel/process.c     |    6 +-----
 drivers/acpi/processor_idle.c |    6 ++++--
 kernel/time/clockevents.c     |   16 ++++++++++------
 kernel/time/tick-broadcast.c  |    7 +++----
 4 files changed, 18 insertions(+), 17 deletions(-)

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
