Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZHQVf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZHQVf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZHQVf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:35:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:18204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZHQVf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,398,1246863600"; 
   d="scan'208";a="484310109"
Subject: Re: [patch] clockevents_notify() need to be called with irq's
 enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <alpine.LFD.2.00.0908172325380.2782@localhost.localdomain>
References: <1250203681.27006.10842.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0908140753370.1283@localhost.localdomain>
	 <1250234778.2965.8.camel@sbs-t61>
	 <alpine.LFD.2.00.0908141025290.1283@localhost.localdomain>
	 <1250271593.3077.8.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.0908142159480.1283@localhost.localdomain>
	 <1250544150.2709.197.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.0908172325380.2782@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 17 Aug 2009 14:34:59 -0700
Message-Id: <1250544899.2709.210.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 14:27 -0700, Thomas Gleixner wrote:
> Suresh,
> 
> On Mon, 17 Aug 2009, Suresh Siddha wrote:
> 
> > --- tip.orig/arch/x86/kernel/process.c
> > +++ tip/arch/x86/kernel/process.c
> > @@ -508,17 +508,10 @@ static void c1e_idle(void)
> >  
> >  		if (!cpumask_test_cpu(cpu, c1e_mask)) {
> >  			cpumask_set_cpu(cpu, c1e_mask);
> > -			/*
> > -			 * Force broadcast so ACPI can not interfere. Needs
> > -			 * to run with interrupts enabled as it uses
> > -			 * smp_function_call.
> > -			 */
> 
> Please keep the first sentence of the comment intact. Everything else
> looks fine.

Oops. Patch appended.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: take clockevents_lock with interrupts disabled

Currently clockevents_notify() is called with interrupts enabled at some
places and interrupts disabled at some other places.

This results in a deadlock in this scenario.

cpu A holding the clockevents_lock in clockevents_notify() with irq enabled
cpu B waiting for the clockevents_lock in clockevents_notify() with irq disabled
cpu C doing set_mtrr() which will try to rendezvous of all the cpus.

This will result in C and A come to the rendezvous point and waiting for B.
B stuck forever waiting for the spinlock and thus not reaching rendezvous
point.

Fix the clockevents code so that clockevents_lock is taken
with interrupts disabled and thus avoid the above deadlock.

Also call lapic_timer_propagate_broadcast() on the destination cpu so that
we avoid calling smp_call_function() in the clockevents notifier chain.

This issue left us wondering if we need to change the MTRR rendezvous logic to
use stop machine logic (instead of smp_call_function) or add a check
in spinlock debug code to see if there are other spinlocks which gets
taken under both interrupts enabled/disabled conditions.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---

Index: tip/arch/x86/kernel/process.c
===================================================================
--- tip.orig/arch/x86/kernel/process.c
+++ tip/arch/x86/kernel/process.c
@@ -509,16 +509,12 @@ static void c1e_idle(void)
 		if (!cpumask_test_cpu(cpu, c1e_mask)) {
 			cpumask_set_cpu(cpu, c1e_mask);
 			/*
-			 * Force broadcast so ACPI can not interfere. Needs
-			 * to run with interrupts enabled as it uses
-			 * smp_function_call.
-			 */
-			local_irq_enable();
+ 			 * Force broadcast so ACPI can not interfere.
+ 			 */
 			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
 					   &cpu);
 			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
 			       cpu);
-			local_irq_disable();
 		}
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
Index: tip/drivers/acpi/processor_idle.c
===================================================================
--- tip.orig/drivers/acpi/processor_idle.c
+++ tip/drivers/acpi/processor_idle.c
@@ -162,8 +162,9 @@ static void lapic_timer_check_state(int 
 		pr->power.timer_broadcast_on_state = state;
 }
 
-static void lapic_timer_propagate_broadcast(struct acpi_processor *pr)
+static void lapic_timer_propagate_broadcast(void *arg)
 {
+	struct acpi_processor *pr = (struct acpi_processor *) arg;
 	unsigned long reason;
 
 	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
@@ -635,7 +636,8 @@ static int acpi_processor_power_verify(s
 		working++;
 	}
 
-	lapic_timer_propagate_broadcast(pr);
+	smp_call_function_single(pr->id, lapic_timer_propagate_broadcast,
+				 pr, 1);
 
 	return (working);
 }
Index: tip/kernel/time/clockevents.c
===================================================================
--- tip.orig/kernel/time/clockevents.c
+++ tip/kernel/time/clockevents.c
@@ -137,11 +137,12 @@ int clockevents_program_event(struct clo
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
@@ -178,16 +179,18 @@ static void clockevents_notify_released(
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
 
@@ -235,8 +238,9 @@ void clockevents_exchange_device(struct 
 void clockevents_notify(unsigned long reason, void *arg)
 {
 	struct list_head *node, *tmp;
+	unsigned long flags;
 
-	spin_lock(&clockevents_lock);
+	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
 
 	switch (reason) {
@@ -251,7 +255,7 @@ void clockevents_notify(unsigned long re
 	default:
 		break;
 	}
-	spin_unlock(&clockevents_lock);
+	spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 #endif
Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -205,11 +205,11 @@ static void tick_handle_periodic_broadca
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
@@ -276,8 +276,7 @@ void tick_broadcast_on_off(unsigned long
 		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
-		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
-					 &reason, 1);
+		tick_do_broadcast_on_off(&reason);
 }
 
 /*


