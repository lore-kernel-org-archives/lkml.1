Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZHOJDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZHOJDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZHOJDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:03:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:55308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbZHOJDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:03:45 -0400
Date: Sat, 15 Aug 2009 09:03:01 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, dwalker@fifo99.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090814134809.354926067@de.ibm.com>
References: <20090814134809.354926067@de.ibm.com>
Subject: [tip:timers/core] clocksource: Move watchdog downgrade to a work queue thread
Message-ID: <tip-c55c87c892c1875deace0c8fc28787335277fdf2@git.kernel.org>
Git-Commit-ID: c55c87c892c1875deace0c8fc28787335277fdf2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:03:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c55c87c892c1875deace0c8fc28787335277fdf2
Gitweb:     http://git.kernel.org/tip/c55c87c892c1875deace0c8fc28787335277fdf2
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:25 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:46 +0200

clocksource: Move watchdog downgrade to a work queue thread

Move the downgrade of an unstable clocksource from the timer interrupt
context into the process context of a work queue thread. This is
needed to be able to do the clocksource switch with stop_machine.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134809.354926067@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/linux/clocksource.h |    1 +
 kernel/time/clocksource.c   |   56 ++++++++++++++++++++++++++++++-------------
 2 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index f263b3a..19ad43a 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -213,6 +213,7 @@ extern struct clocksource *clock;	/* current clocksource */
 
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
+#define CLOCK_SOURCE_UNSTABLE			0x40
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 56aaa74..f150801 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
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
@@ -158,15 +161,16 @@ static void clocksource_unstable(struct clocksource *cs, int64_t delta)
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
@@ -176,7 +180,12 @@ static void clocksource_watchdog(unsigned long data)
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
@@ -207,19 +216,15 @@ static void clocksource_watchdog(unsigned long data)
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
@@ -228,6 +233,7 @@ static inline void clocksource_start_watchdog(void)
 {
 	if (watchdog_running || !watchdog || list_empty(&watchdog_list))
 		return;
+	INIT_WORK(&watchdog_work, clocksource_watchdog_work);
 	init_timer(&watchdog_timer);
 	watchdog_timer.function = clocksource_watchdog;
 	watchdog_last = watchdog->read(watchdog);
@@ -313,6 +319,22 @@ static void clocksource_dequeue_watchdog(struct clocksource *cs)
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
