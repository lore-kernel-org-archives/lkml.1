Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbZHNNsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbZHNNsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbZHNNsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:48:15 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56958 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501AbZHNNsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:48:10 -0400
Message-Id: <20090814134809.110881699@de.ibm.com>
References: <20090814134717.859098725@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 15:47:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/15] clocksource watchdog refactoring
Content-Disposition: inline; filename=watchdog-refactor.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Refactor clocksource watchdog code to make it more readable. Add
clocksource_dequeue_watchdog to remove a clocksource from the
watckdog list when it is unregistered.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/time/clocksource.c |   97 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 28 deletions(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -145,6 +145,7 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
+static int watchdog_running;
 
 /*
  * Interval: 0.5sec Threshold: 0.0625s
@@ -168,6 +169,8 @@ static void clocksource_watchdog(unsigne
 	int64_t wd_nsec, cs_nsec;
 
 	spin_lock(&watchdog_lock);
+	if (!watchdog_running)
+		goto out;
 
 	wdnow = watchdog->read(watchdog);
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
@@ -217,9 +220,30 @@ static void clocksource_watchdog(unsigne
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
 		add_timer_on(&watchdog_timer, next_cpu);
 	}
+out:
 	spin_unlock(&watchdog_lock);
 }
 
+static inline void clocksource_start_watchdog(void)
+{
+	if (watchdog_running || !watchdog || list_empty(&watchdog_list))
+		return;
+	init_timer(&watchdog_timer);
+	watchdog_timer.function = clocksource_watchdog;
+	watchdog_last = watchdog->read(watchdog);
+	watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
+	add_timer_on(&watchdog_timer, cpumask_first(cpu_online_mask));
+	watchdog_running = 1;
+}
+
+static inline void clocksource_stop_watchdog(void)
+{
+	if (!watchdog_running || (watchdog && !list_empty(&watchdog_list)))
+		return;
+	del_timer(&watchdog_timer);
+	watchdog_running = 0;
+}
+
 static inline void clocksource_reset_watchdog(void)
 {
 	struct clocksource *cs;
@@ -237,55 +261,70 @@ static void clocksource_resume_watchdog(
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-static void clocksource_check_watchdog(struct clocksource *cs)
+static void clocksource_enqueue_watchdog(struct clocksource *cs)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&watchdog_lock, flags);
 	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
-		int started = !list_empty(&watchdog_list);
-
+		/* cs is a clocksource to be watched. */
 		list_add(&cs->wd_list, &watchdog_list);
-		if (!started && watchdog) {
-			watchdog_last = watchdog->read(watchdog);
-			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
-			add_timer_on(&watchdog_timer,
-				     cpumask_first(cpu_online_mask));
-		}
+		cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
 	} else {
+		/* cs is a watchdog. */
 		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-
+		/* Pick the best watchdog. */
 		if (!watchdog || cs->rating > watchdog->rating) {
-			if (watchdog)
-				del_timer(&watchdog_timer);
 			watchdog = cs;
-			init_timer(&watchdog_timer);
-			watchdog_timer.function = clocksource_watchdog;
-
 			/* Reset watchdog cycles */
 			clocksource_reset_watchdog();
-			/* Start if list is not empty */
-			if (!list_empty(&watchdog_list)) {
-				watchdog_last = watchdog->read(watchdog);
-				watchdog_timer.expires =
-					jiffies + WATCHDOG_INTERVAL;
-				add_timer_on(&watchdog_timer,
-					     cpumask_first(cpu_online_mask));
-			}
 		}
 	}
+	/* Check if the watchdog timer needs to be started. */
+	clocksource_start_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
-#else
-static void clocksource_check_watchdog(struct clocksource *cs)
+
+static void clocksource_dequeue_watchdog(struct clocksource *cs)
+{
+	struct clocksource *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
+		/* cs is a watched clocksource. */
+		list_del_init(&cs->wd_list);
+	} else if (cs == watchdog) {
+		/* Reset watchdog cycles */
+		clocksource_reset_watchdog();
+		/* Current watchdog is removed. Find an alternative. */
+		watchdog = NULL;
+		list_for_each_entry(tmp, &clocksource_list, list) {
+			if (tmp == cs || tmp->flags & CLOCK_SOURCE_MUST_VERIFY)
+				continue;
+			if (!watchdog || tmp->rating > watchdog->rating)
+				watchdog = tmp;
+		}
+	}
+	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
+	/* Check if the watchdog timer needs to be stopped. */
+	clocksource_stop_watchdog();
+	spin_unlock_irqrestore(&watchdog_lock, flags);
+}
+
+#else /* CONFIG_CLOCKSOURCE_WATCHDOG */
+
+static void clocksource_enqueue_watchdog(struct clocksource *cs)
 {
 	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 		cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
 }
 
+static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
-#endif
+
+#endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 /**
  * clocksource_resume - resume the clocksource(s)
@@ -414,14 +453,13 @@ int clocksource_register(struct clocksou
 	clocksource_enqueue(cs);
 	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
-	clocksource_check_watchdog(cs);
+	clocksource_enqueue_watchdog(cs);
 	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
 
 /**
  * clocksource_change_rating - Change the rating of a registered clocksource
- *
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
@@ -434,6 +472,7 @@ void clocksource_change_rating(struct cl
 	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
+EXPORT_SYMBOL(clocksource_change_rating);
 
 /**
  * clocksource_unregister - remove a registered clocksource
@@ -442,11 +481,13 @@ void clocksource_unregister(struct clock
 {
 	unsigned long flags;
 
+	clocksource_dequeue_watchdog(cs);
 	spin_lock_irqsave(&clocksource_lock, flags);
 	list_del(&cs->list);
 	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
+EXPORT_SYMBOL(clocksource_unregister);
 
 #ifdef CONFIG_SYSFS
 /**

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

