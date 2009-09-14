Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbZINUEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbZINUEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbZINUEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:04:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:39744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbZINUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:04:35 -0400
Date: Mon, 14 Sep 2009 20:04:16 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Delay clocksource down rating to late boot
Message-ID: <tip-54a6bc0b071c50150bc6d1da16c2cd9a963e288c@git.kernel.org>
Git-Commit-ID: 54a6bc0b071c50150bc6d1da16c2cd9a963e288c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Sep 2009 20:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54a6bc0b071c50150bc6d1da16c2cd9a963e288c
Gitweb:     http://git.kernel.org/tip/54a6bc0b071c50150bc6d1da16c2cd9a963e288c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 14 Sep 2009 19:49:02 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Sep 2009 21:59:32 +0200

clocksource: Delay clocksource down rating to late boot

The down rating of clock sources in the early boot process via the
clock source watchdog mechanism can happen way before the per cpu
event queues are initialized. This leads to a boot crash on x86 when
the TSC is marked unstable in the SMP bring up.

The selection of a clock source for time keeping happens in the late
boot process so we can safely delay the list manipulation until
clocksource_done_booting() is called.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>


---
 kernel/time/clocksource.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 2c2e5ba..0911334 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -121,6 +121,7 @@ static struct clocksource *curr_clocksource;
 static LIST_HEAD(clocksource_list);
 static DEFINE_MUTEX(clocksource_mutex);
 static char override_name[32];
+static int finished_booting;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 static void clocksource_watchdog_work(struct work_struct *work);
@@ -155,7 +156,8 @@ static void __clocksource_unstable(struct clocksource *cs)
 {
 	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
 	cs->flags |= CLOCK_SOURCE_UNSTABLE;
-	schedule_work(&watchdog_work);
+	if (finished_booting)
+		schedule_work(&watchdog_work);
 }
 
 static void clocksource_unstable(struct clocksource *cs, int64_t delta)
@@ -207,7 +209,8 @@ static void clocksource_watchdog(unsigned long data)
 
 		/* Clocksource already marked unstable? */
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
-			schedule_work(&watchdog_work);
+			if (finished_booting)
+				schedule_work(&watchdog_work);
 			continue;
 		}
 
@@ -380,6 +383,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
+static inline int clocksource_watchdog_kthread(void *data) { return 0; }
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
@@ -415,8 +419,6 @@ void clocksource_touch_watchdog(void)
 
 #ifdef CONFIG_GENERIC_TIME
 
-static int finished_booting;
-
 /**
  * clocksource_select - Select the best clocksource available
  *
@@ -461,6 +463,12 @@ static void clocksource_select(void)
 	}
 }
 
+#else /* CONFIG_GENERIC_TIME */
+
+static inline void clocksource_select(void) { }
+
+#endif
+
 /*
  * clocksource_done_booting - Called near the end of core bootup
  *
@@ -471,6 +479,12 @@ static void clocksource_select(void)
 static int __init clocksource_done_booting(void)
 {
 	finished_booting = 1;
+
+	/*
+	 * Run the watchdog first to eliminate unstable clock sources
+	 */
+	clocksource_watchdog_kthread(NULL);
+
 	mutex_lock(&clocksource_mutex);
 	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
@@ -478,12 +492,6 @@ static int __init clocksource_done_booting(void)
 }
 fs_initcall(clocksource_done_booting);
 
-#else /* CONFIG_GENERIC_TIME */
-
-static inline void clocksource_select(void) { }
-
-#endif
-
 /*
  * Enqueue the clocksource sorted by rating
  */
