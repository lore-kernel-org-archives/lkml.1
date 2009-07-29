Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbZG2Nmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbZG2Nmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbZG2Nmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:42:44 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:32977 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbZG2Nmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:42:42 -0400
Message-Id: <20090729134230.719998924@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 07/12] clocksource watchdog work
Content-Disposition: inline; filename=watchdog-work.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Move the downgrade of an unstable clocksource from the timer interrupt
context into the process context of a work queue thread. This is needed
to be able to do the clocksource switch with stop_machine.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clocksource.h |    1 
 kernel/time/clocksource.c   |   56 ++++++++++++++++++++++++++++++--------------
 2 files changed, 40 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -213,6 +213,7 @@ extern struct clocksource *clock;	/* cur
 
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
+#define CLOCK_SOURCE_UNSTABLE			0x40
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -143,10 +143,13 @@ fs_initcall(clocksource_done_booting);
 static LIST_HEAD(watchdog_list);
 static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
+static struct work_struct watchdog_work;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 static int watchdog_running;
 
+static void clocksource_watchdog_work(struct work_struct *work);
+
 /*
  * Interval: 0.5sec Threshold: 0.0625s
  */
@@ -158,15 +161,16 @@ static void clocksource_unstable(struct 
 	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
 	       cs->name, delta);
 	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
-	clocksource_change_rating(cs, 0);
-	list_del(&cs->wd_list);
+	cs->flags |= CLOCK_SOURCE_UNSTABLE;
+	schedule_work(&watchdog_work);
 }
 
 static void clocksource_watchdog(unsigned long data)
 {
-	struct clocksource *cs, *tmp;
+	struct clocksource *cs;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
+	int next_cpu;
 
 	spin_lock(&watchdog_lock);
 	if (!watchdog_running)
@@ -176,7 +180,12 @@ static void clocksource_watchdog(unsigne
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
 	watchdog_last = wdnow;
 
-	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
+	list_for_each_entry(cs, &watchdog_list, wd_list) {
+
+		/* Clocksource already marked unstable? */
+		if (cs->flags & CLOCK_SOURCE_UNSTABLE)
+			continue;
+
 		csnow = cs->read(cs);
 
 		/* Clocksource initialized ? */
@@ -207,19 +216,15 @@ static void clocksource_watchdog(unsigne
 		}
 	}
 
-	if (!list_empty(&watchdog_list)) {
-		/*
-		 * Cycle through CPUs to check if the CPUs stay
-		 * synchronized to each other.
-		 */
-		int next_cpu = cpumask_next(raw_smp_processor_id(),
-					    cpu_online_mask);
-
-		if (next_cpu >= nr_cpu_ids)
-			next_cpu = cpumask_first(cpu_online_mask);
-		watchdog_timer.expires += WATCHDOG_INTERVAL;
-		add_timer_on(&watchdog_timer, next_cpu);
-	}
+	/*
+	 * Cycle through CPUs to check if the CPUs stay synchronized
+	 * to each other.
+	 */
+	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
+	if (next_cpu >= nr_cpu_ids)
+		next_cpu = cpumask_first(cpu_online_mask);
+	watchdog_timer.expires += WATCHDOG_INTERVAL;
+	add_timer_on(&watchdog_timer, next_cpu);
 out:
 	spin_unlock(&watchdog_lock);
 }
@@ -228,6 +233,7 @@ static inline void clocksource_start_wat
 {
 	if (watchdog_running || !watchdog || list_empty(&watchdog_list))
 		return;
+	INIT_WORK(&watchdog_work, clocksource_watchdog_work);
 	init_timer(&watchdog_timer);
 	watchdog_timer.function = clocksource_watchdog;
 	watchdog_last = watchdog->read(watchdog);
@@ -312,6 +318,22 @@ static void clocksource_dequeue_watchdog
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
+static void clocksource_watchdog_work(struct work_struct *work)
+{
+	struct clocksource *cs, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
+		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
+			list_del_init(&cs->wd_list);
+			clocksource_change_rating(cs, 0);
+		}
+	/* Check if the watchdog timer needs to be stopped. */
+	clocksource_stop_watchdog();
+	spin_unlock(&watchdog_lock);
+}
+
 #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 static void clocksource_enqueue_watchdog(struct clocksource *cs)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

