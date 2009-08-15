Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbZHOJDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbZHOJDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZHOJDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:03:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:55273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbZHOJDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:03:14 -0400
Date: Sat, 15 Aug 2009 09:02:22 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, dwalker@fifo99.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090814134808.627795883@de.ibm.com>
References: <20090814134808.627795883@de.ibm.com>
Subject: [tip:timers/core] clocksource: Delay clocksource watchdog highres enablement
Message-ID: <tip-8cf4e750f8459d51c2e8a035a201da4bf7aa996a@git.kernel.org>
Git-Commit-ID: 8cf4e750f8459d51c2e8a035a201da4bf7aa996a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:02:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cf4e750f8459d51c2e8a035a201da4bf7aa996a
Gitweb:     http://git.kernel.org/tip/8cf4e750f8459d51c2e8a035a201da4bf7aa996a
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:22 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:46 +0200

clocksource: Delay clocksource watchdog highres enablement

The clocksource watchdog marks a clock as highres capable before it
checked the deviation from the watchdog clocksource even for a single
time. Make sure that the deviation is at least checked once before
doing the switch to highres mode.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134808.627795883@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/time/clocksource.c |   47 +++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e91662e..76256c5 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
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
@@ -183,31 +180,31 @@ static void clocksource_watchdog(unsigned long data)
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
 
