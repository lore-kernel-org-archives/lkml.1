Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZG2Nnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZG2Nnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbZG2Nnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:43:49 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:60301 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbZG2Nnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:43:46 -0400
Message-Id: <20090729134230.234734332@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 05/12] clocksource watchdog resume logic
Content-Disposition: inline; filename=watchdog-resume.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

To resume the clocksource watchdog just remove the CLOCK_SOURCE_WATCHDOG
bit from the watched clocksource.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/time/clocksource.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -145,7 +145,6 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
-static unsigned long watchdog_resumed;
 
 /*
  * Interval: 0.5sec Threshold: 0.0625s
@@ -167,12 +166,9 @@ static void clocksource_watchdog(unsigne
 	struct clocksource *cs, *tmp;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
-	int resumed;
 
 	spin_lock(&watchdog_lock);
 
-	resumed = test_and_clear_bit(0, &watchdog_resumed);
-
 	wdnow = watchdog->read(watchdog);
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
 	watchdog_last = wdnow;
@@ -223,14 +219,26 @@ static void clocksource_watchdog(unsigne
 	}
 	spin_unlock(&watchdog_lock);
 }
+
+static inline void clocksource_reset_watchdog(void)
+{
+	struct clocksource *cs;
+
+	list_for_each_entry(cs, &watchdog_list, wd_list)
+		cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
+}
+
 static void clocksource_resume_watchdog(void)
 {
-	set_bit(0, &watchdog_resumed);
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	clocksource_reset_watchdog();
+	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
 static void clocksource_check_watchdog(struct clocksource *cs)
 {
-	struct clocksource *cse;
 	unsigned long flags;
 
 	spin_lock_irqsave(&watchdog_lock, flags);
@@ -256,8 +264,7 @@ static void clocksource_check_watchdog(s
 			watchdog_timer.function = clocksource_watchdog;
 
 			/* Reset watchdog cycles */
-			list_for_each_entry(cse, &watchdog_list, wd_list)
-				cse->flags &= ~CLOCK_SOURCE_WATCHDOG;
+			clocksource_reset_watchdog();
 			/* Start if list is not empty */
 			if (!list_empty(&watchdog_list)) {
 				watchdog_last = watchdog->read(watchdog);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

