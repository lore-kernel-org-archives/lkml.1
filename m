Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbZG2Nnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbZG2Nnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbZG2Nmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:42:44 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:50070 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbZG2Nml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:42:41 -0400
Message-Id: <20090729134230.007201514@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 04/12] clocksource watchdog highres enablement
Content-Disposition: inline; filename=watchdog-highres.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The clocksource watchdog marks a clock as highres capable before it
checked the deviation from the watchdog clocksource even for a single
time. Make sure that the deviation is at least checked once before
doing the switch to highres mode.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/time/clocksource.c |   47 +++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -153,11 +153,8 @@ static unsigned long watchdog_resumed;
 #define WATCHDOG_INTERVAL (HZ >> 1)
 #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
-static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
+static void clocksource_unstable(struct clocksource *cs, int64_t delta)
 {
-	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
-		return;
-
 	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
 	       cs->name, delta);
 	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
@@ -183,31 +180,31 @@ static void clocksource_watchdog(unsigne
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
 		csnow = cs->read(cs);
 
-		if (unlikely(resumed)) {
+		/* Clocksource initialized ? */
+		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
+			cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = csnow;
 			continue;
 		}
 
-		/* Initialized ? */
-		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
-			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
-			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
-				cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-				/*
-				 * We just marked the clocksource as
-				 * highres-capable, notify the rest of the
-				 * system as well so that we transition
-				 * into high-res mode:
-				 */
-				tick_clock_notify();
-			}
-			cs->flags |= CLOCK_SOURCE_WATCHDOG;
-			cs->wd_last = csnow;
-		} else {
-			cs_nsec = cyc2ns(cs, (csnow - cs->wd_last) & cs->mask);
-			cs->wd_last = csnow;
-			/* Check the delta. Might remove from the list ! */
-			clocksource_ratewd(cs, cs_nsec - wd_nsec);
+		/* Check the deviation from the watchdog clocksource. */
+		cs_nsec = cyc2ns(cs, (csnow - cs->wd_last) & cs->mask);
+		cs->wd_last = csnow;
+		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
+			clocksource_unstable(cs, cs_nsec - wd_nsec);
+			continue;
+		}
+
+		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) &&
+		    (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
+		    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
+			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+			/*
+			 * We just marked the clocksource as highres-capable,
+			 * notify the rest of the system as well so that we
+			 * transition into high-res mode:
+			 */
+			tick_clock_notify();
 		}
 	}
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

