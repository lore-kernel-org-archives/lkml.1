Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZH1SeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZH1SeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZH1SeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:34:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:43195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZH1SeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:34:21 -0400
Date: Fri, 28 Aug 2009 18:34:00 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Resolve cpu hotplug dead lock with TSC unstable
Message-ID: <tip-7285dd7fd375763bfb8ab1ac9cf3f1206f503c16@git.kernel.org>
Git-Commit-ID: 7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 18:34:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
Gitweb:     http://git.kernel.org/tip/7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 28 Aug 2009 20:25:24 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Aug 2009 20:25:24 +0200

clocksource: Resolve cpu hotplug dead lock with TSC unstable

Martin Schwidefsky analyzed it:
To register a clocksource the clocksource_mutex is acquired and if
necessary timekeeping_notify is called to install the clocksource as
the timekeeper clock. timekeeping_notify uses stop_machine which needs
to take cpu_add_remove_lock mutex.
Starting a new cpu is done with the cpu_add_remove_lock mutex held.
native_cpu_up checks the tsc of the new cpu and if the tsc is no good
clocksource_change_rating is called. Which needs the clocksource_mutex
and the deadlock is complete.

The solution is to replace the TSC via the clocksource watchdog
mechanism. Mark the TSC as unstable and schedule the watchdog work so
it gets removed in the watchdog thread context.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>


---
 arch/x86/kernel/tsc.c       |    8 +++++---
 include/linux/clocksource.h |    1 +
 kernel/time/clocksource.c   |   33 ++++++++++++++++++++++++++++++---
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9684254..fc3672a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -767,12 +767,14 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		printk("Marking TSC unstable due to %s\n", reason);
+		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
-			clocksource_change_rating(&clocksource_tsc, 0);
-		else
+			clocksource_mark_unstable(&clocksource_tsc);
+		else {
+			clocksource_tsc.flags |= CLOCK_SOURCE_UNSTABLE;
 			clocksource_tsc.rating = 0;
+		}
 	}
 }
 
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 9ea40ff..83d2fbd 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -277,6 +277,7 @@ extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
 extern struct clocksource * __init __weak clocksource_default_clock(void);
+extern void clocksource_mark_unstable(struct clocksource *cs);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e0c86ad..a0af4ff 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -149,15 +149,42 @@ static void clocksource_watchdog_work(struct work_struct *work)
 	kthread_run(clocksource_watchdog_kthread, NULL, "kwatchdog");
 }
 
-static void clocksource_unstable(struct clocksource *cs, int64_t delta)
+static void __clocksource_unstable(struct clocksource *cs)
 {
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-	       cs->name, delta);
 	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
 	cs->flags |= CLOCK_SOURCE_UNSTABLE;
 	schedule_work(&watchdog_work);
 }
 
+static void clocksource_unstable(struct clocksource *cs, int64_t delta)
+{
+	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
+	       cs->name, delta);
+	__clocksource_unstable(cs);
+}
+
+/**
+ * clocksource_mark_unstable - mark clocksource unstable via watchdog
+ * @cs:		clocksource to be marked unstable
+ *
+ * This function is called instead of clocksource_change_rating from
+ * cpu hotplug code to avoid a deadlock between the clocksource mutex
+ * and the cpu hotplug mutex. It defers the update of the clocksource
+ * to the watchdog thread.
+ */
+void clocksource_mark_unstable(struct clocksource *cs)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	if (!(cs->flags & CLOCK_SOURCE_UNSTABLE)) {
+		if (list_empty(&cs->wd_list))
+			list_add(&cs->wd_list, &watchdog_list);
+		__clocksource_unstable(cs);
+	}
+	spin_unlock_irqrestore(&watchdog_lock, flags);
+}
+
 static void clocksource_watchdog(unsigned long data)
 {
 	struct clocksource *cs;
