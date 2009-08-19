Return-Path: <linux-kernel-owner+w=401wt.eu-S1751494AbZHSKHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbZHSKHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZHSKHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:07:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:46051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZHSKHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:07:06 -0400
Date: Wed, 19 Aug 2009 10:06:37 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, johnstul@us.ibm.com, schwidefsky@de.ibm.com,
       tglx@linutronix.de
In-Reply-To: <20090818170942.3ab80c91@skybase>
References: <20090818170942.3ab80c91@skybase>
Subject: [tip:timers/core] clocksource: Avoid clocksource watchdog circular locking dependency
Message-ID: <tip-01548f4d3e8e94caf323a4f664eb347fd34a34ab@git.kernel.org>
Git-Commit-ID: 01548f4d3e8e94caf323a4f664eb347fd34a34ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 10:06:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01548f4d3e8e94caf323a4f664eb347fd34a34ab
Gitweb:     http://git.kernel.org/tip/01548f4d3e8e94caf323a4f664eb347fd34a34ab
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Tue, 18 Aug 2009 17:09:42 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Aug 2009 12:00:56 +0200

clocksource: Avoid clocksource watchdog circular locking dependency

stop_machine from a multithreaded workqueue is not allowed because
of a circular locking dependency between cpu_down and the workqueue
execution. Use a kernel thread to do the clocksource downgrade.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: john stultz <johnstul@us.ibm.com>
LKML-Reference: <20090818170942.3ab80c91@skybase>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 kernel/time/clocksource.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c6bff11..e0c86ad 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 #include <linux/tick.h>
+#include <linux/kthread.h>
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -130,7 +131,7 @@ static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 static int watchdog_running;
 
-static void clocksource_watchdog_work(struct work_struct *work);
+static int clocksource_watchdog_kthread(void *data);
 static void __clocksource_change_rating(struct clocksource *cs, int rating);
 
 /*
@@ -139,6 +140,15 @@ static void __clocksource_change_rating(struct clocksource *cs, int rating);
 #define WATCHDOG_INTERVAL (HZ >> 1)
 #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
+static void clocksource_watchdog_work(struct work_struct *work)
+{
+	/*
+	 * If kthread_run fails the next watchdog scan over the
+	 * watchdog_list will find the unstable clock again.
+	 */
+	kthread_run(clocksource_watchdog_kthread, NULL, "kwatchdog");
+}
+
 static void clocksource_unstable(struct clocksource *cs, int64_t delta)
 {
 	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
@@ -167,8 +177,10 @@ static void clocksource_watchdog(unsigned long data)
 	list_for_each_entry(cs, &watchdog_list, wd_list) {
 
 		/* Clocksource already marked unstable? */
-		if (cs->flags & CLOCK_SOURCE_UNSTABLE)
+		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
+			schedule_work(&watchdog_work);
 			continue;
+		}
 
 		csnow = cs->read(cs);
 
@@ -304,7 +316,7 @@ static void clocksource_dequeue_watchdog(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-static void clocksource_watchdog_work(struct work_struct *work)
+static int clocksource_watchdog_kthread(void *data)
 {
 	struct clocksource *cs, *tmp;
 	unsigned long flags;
@@ -327,6 +339,7 @@ static void clocksource_watchdog_work(struct work_struct *work)
 		__clocksource_change_rating(cs, 0);
 	}
 	mutex_unlock(&clocksource_mutex);
+	return 0;
 }
 
 #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
