Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbZHOJDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbZHOJDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZHOJDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:03:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:55267 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZHOJDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:03:10 -0400
Date: Sat, 15 Aug 2009 09:02:35 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, dwalker@fifo99.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090814134808.880925790@de.ibm.com>
References: <20090814134808.880925790@de.ibm.com>
Subject: [tip:timers/core] clocksource: Simplify clocksource watchdog resume logic
Message-ID: <tip-0f8e8ef7c204988246da5a42d576b7fa5277a8e4@git.kernel.org>
Git-Commit-ID: 0f8e8ef7c204988246da5a42d576b7fa5277a8e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:02:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f8e8ef7c204988246da5a42d576b7fa5277a8e4
Gitweb:     http://git.kernel.org/tip/0f8e8ef7c204988246da5a42d576b7fa5277a8e4
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:23 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:46 +0200

clocksource: Simplify clocksource watchdog resume logic

To resume the clocksource watchdog just remove the CLOCK_SOURCE_WATCHDOG
bit from the watched clocksource.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134808.880925790@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/time/clocksource.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 76256c5..89a7b91 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -145,7 +145,6 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
-static unsigned long watchdog_resumed;
 
 /*
  * Interval: 0.5sec Threshold: 0.0625s
@@ -167,12 +166,9 @@ static void clocksource_watchdog(unsigned long data)
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
@@ -223,14 +219,26 @@ static void clocksource_watchdog(unsigned long data)
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
@@ -256,8 +264,7 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 			watchdog_timer.function = clocksource_watchdog;
 
 			/* Reset watchdog cycles */
-			list_for_each_entry(cse, &watchdog_list, wd_list)
-				cse->flags &= ~CLOCK_SOURCE_WATCHDOG;
+			clocksource_reset_watchdog();
 			/* Start if list is not empty */
 			if (!list_empty(&watchdog_list)) {
 				watchdog_last = watchdog->read(watchdog);
