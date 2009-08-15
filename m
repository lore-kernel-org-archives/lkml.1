Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbZHOJC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbZHOJC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZHOJC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:02:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:55244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZHOJCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:02:55 -0400
Date: Sat, 15 Aug 2009 09:02:09 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dwalker@fifo99.com, hpa@zytor.com,
       mingo@redhat.com, johnstul@us.ibm.com, schwidefsky@de.ibm.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dwalker@fifo99.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20090814134808.388024160@de.ibm.com>
References: <20090814134808.388024160@de.ibm.com>
Subject: [tip:timers/core] clocksource: Cleanup clocksource selection
Message-ID: <tip-f1b82746c1e93daf24e1ab9bfbd39bcdb2e7018b@git.kernel.org>
Git-Commit-ID: f1b82746c1e93daf24e1ab9bfbd39bcdb2e7018b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:02:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1b82746c1e93daf24e1ab9bfbd39bcdb2e7018b
Gitweb:     http://git.kernel.org/tip/f1b82746c1e93daf24e1ab9bfbd39bcdb2e7018b
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:21 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:46 +0200

clocksource: Cleanup clocksource selection

If a non high-resolution clocksource is first set as override clock
and then registered it becomes active even if the system is in one-shot
mode. Move the override check from sysfs_override_clocksource to the
clocksource selection. That fixes the bug and simplifies the code. The
check in clocksource_register for double registration of the same
clocksource is removed without replacement.

To find the initial clocksource a new weak function in jiffies.c is
defined that returns the jiffies clocksource. The architecture code
can then override the weak function with a more suitable clocksource,
e.g. the TOD clock on s390.

[ tglx: Folded in a fix from John Stultz ]

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134808.388024160@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/s390/kernel/time.c     |    4 +
 include/linux/clocksource.h |    2 +
 kernel/time/clocksource.c   |  134 ++++++++++++++++--------------------------
 kernel/time/jiffies.c       |    6 ++-
 kernel/time/timekeeping.c   |    4 +-
 5 files changed, 64 insertions(+), 86 deletions(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index d4c8e9c..afefe51 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -205,6 +205,10 @@ static struct clocksource clocksource_tod = {
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+struct clocksource * __init clocksource_default_clock(void)
+{
+	return &clocksource_tod;
+}
 
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index a1ef46f..f263b3a 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/cache.h>
 #include <linux/timer.h>
+#include <linux/init.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -322,6 +323,7 @@ extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
+extern struct clocksource * __init __weak clocksource_default_clock(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7466cb8..e91662e 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -21,7 +21,6 @@
  *
  * TODO WishList:
  *   o Allow clocksource drivers to be unregistered
- *   o get rid of clocksource_jiffies extern
  */
 
 #include <linux/clocksource.h>
@@ -107,12 +106,9 @@ u64 timecounter_cyc2time(struct timecounter *tc,
 }
 EXPORT_SYMBOL(timecounter_cyc2time);
 
-/* XXX - Would like a better way for initializing curr_clocksource */
-extern struct clocksource clocksource_jiffies;
-
 /*[Clocksource internal variables]---------
  * curr_clocksource:
- *	currently selected clocksource. Initialized to clocksource_jiffies.
+ *	currently selected clocksource.
  * next_clocksource:
  *	pending next selected clocksource.
  * clocksource_list:
@@ -123,9 +119,8 @@ extern struct clocksource clocksource_jiffies;
  * override_name:
  *	Name of the user-specified clocksource.
  */
-static struct clocksource *curr_clocksource = &clocksource_jiffies;
+static struct clocksource *curr_clocksource;
 static struct clocksource *next_clocksource;
-static struct clocksource *clocksource_override;
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
@@ -320,6 +315,7 @@ void clocksource_touch_watchdog(void)
 	clocksource_resume_watchdog();
 }
 
+#ifdef CONFIG_GENERIC_TIME
 /**
  * clocksource_get_next - Returns the selected clocksource
  *
@@ -339,56 +335,65 @@ struct clocksource *clocksource_get_next(void)
 }
 
 /**
- * select_clocksource - Selects the best registered clocksource.
+ * clocksource_select - Select the best clocksource available
  *
  * Private function. Must hold clocksource_lock when called.
  *
  * Select the clocksource with the best rating, or the clocksource,
  * which is selected by userspace override.
  */
-static struct clocksource *select_clocksource(void)
+static void clocksource_select(void)
 {
-	struct clocksource *next;
+	struct clocksource *best, *cs;
 
 	if (list_empty(&clocksource_list))
-		return NULL;
+		return;
+	/* First clocksource on the list has the best rating. */
+	best = list_first_entry(&clocksource_list, struct clocksource, list);
+	/* Check for the override clocksource. */
+	list_for_each_entry(cs, &clocksource_list, list) {
+		if (strcmp(cs->name, override_name) != 0)
+			continue;
+		/*
+		 * Check to make sure we don't switch to a non-highres
+		 * capable clocksource if the tick code is in oneshot
+		 * mode (highres or nohz)
+		 */
+		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) &&
+		    tick_oneshot_mode_active()) {
+			/* Override clocksource cannot be used. */
+			printk(KERN_WARNING "Override clocksource %s is not "
+			       "HRT compatible. Cannot switch while in "
+			       "HRT/NOHZ mode\n", cs->name);
+			override_name[0] = 0;
+		} else
+			/* Override clocksource can be used. */
+			best = cs;
+		break;
+	}
+	if (curr_clocksource != best)
+		next_clocksource = best;
+}
 
-	if (clocksource_override)
-		next = clocksource_override;
-	else
-		next = list_entry(clocksource_list.next, struct clocksource,
-				  list);
+#else /* CONFIG_GENERIC_TIME */
 
-	if (next == curr_clocksource)
-		return NULL;
+static void clocksource_select(void) { }
 
-	return next;
-}
+#endif
 
 /*
  * Enqueue the clocksource sorted by rating
  */
-static int clocksource_enqueue(struct clocksource *c)
+static void clocksource_enqueue(struct clocksource *cs)
 {
-	struct list_head *tmp, *entry = &clocksource_list;
-
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *cs;
+	struct list_head *entry = &clocksource_list;
+	struct clocksource *tmp;
 
-		cs = list_entry(tmp, struct clocksource, list);
-		if (cs == c)
-			return -EBUSY;
+	list_for_each_entry(tmp, &clocksource_list, list)
 		/* Keep track of the place, where to insert */
-		if (cs->rating >= c->rating)
-			entry = tmp;
-	}
-	list_add(&c->list, entry);
-
-	if (strlen(c->name) == strlen(override_name) &&
-	    !strcmp(c->name, override_name))
-		clocksource_override = c;
-
-	return 0;
+		if (tmp->rating >= cs->rating)
+			entry = &tmp->list;
+	list_add(&cs->list, entry);
 }
 
 /**
@@ -397,19 +402,16 @@ static int clocksource_enqueue(struct clocksource *c)
  *
  * Returns -EBUSY if registration fails, zero otherwise.
  */
-int clocksource_register(struct clocksource *c)
+int clocksource_register(struct clocksource *cs)
 {
 	unsigned long flags;
-	int ret;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	ret = clocksource_enqueue(c);
-	if (!ret)
-		next_clocksource = select_clocksource();
+	clocksource_enqueue(cs);
+	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
-	if (!ret)
-		clocksource_check_watchdog(c);
-	return ret;
+	clocksource_check_watchdog(cs);
+	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
 
@@ -425,7 +427,7 @@ void clocksource_change_rating(struct clocksource *cs, int rating)
 	list_del(&cs->list);
 	cs->rating = rating;
 	clocksource_enqueue(cs);
-	next_clocksource = select_clocksource();
+	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 
@@ -438,9 +440,7 @@ void clocksource_unregister(struct clocksource *cs)
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 	list_del(&cs->list);
-	if (clocksource_override == cs)
-		clocksource_override = NULL;
-	next_clocksource = select_clocksource();
+	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 
@@ -478,9 +478,7 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 					  struct sysdev_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct clocksource *ovr = NULL;
 	size_t ret = count;
-	int len;
 
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(override_name))
@@ -495,37 +493,7 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 	if (count > 0)
 		memcpy(override_name, buf, count);
 	override_name[count] = 0;
-
-	len = strlen(override_name);
-	if (len) {
-		struct clocksource *cs;
-
-		ovr = clocksource_override;
-		/* try to select it: */
-		list_for_each_entry(cs, &clocksource_list, list) {
-			if (strlen(cs->name) == len &&
-			    !strcmp(cs->name, override_name))
-				ovr = cs;
-		}
-	}
-
-	/*
-	 * Check to make sure we don't switch to a non-highres capable
-	 * clocksource if the tick code is in oneshot mode (highres or nohz)
-	 */
-	if (tick_oneshot_mode_active() && ovr &&
-	    !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
-		printk(KERN_WARNING "%s clocksource is not HRT compatible. "
-			"Cannot switch while in HRT/NOHZ mode\n", ovr->name);
-		ovr = NULL;
-		override_name[0] = 0;
-	}
-
-	/* Reselect, when the override name has changed */
-	if (ovr != clocksource_override) {
-		clocksource_override = ovr;
-		next_clocksource = select_clocksource();
-	}
+	clocksource_select();
 
 	spin_unlock_irq(&clocksource_lock);
 
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index c3f6c30..5404a84 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -61,7 +61,6 @@ struct clocksource clocksource_jiffies = {
 	.read		= jiffies_read,
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
-	.mult_orig	= NSEC_PER_JIFFY << JIFFIES_SHIFT,
 	.shift		= JIFFIES_SHIFT,
 };
 
@@ -71,3 +70,8 @@ static int __init init_jiffies_clocksource(void)
 }
 
 core_initcall(init_jiffies_clocksource);
+
+struct clocksource * __init __weak clocksource_default_clock(void)
+{
+	return &clocksource_jiffies;
+}
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b567301..325a9b6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -269,7 +269,7 @@ static void change_clocksource(void)
 
 	new = clocksource_get_next();
 
-	if (clock == new)
+	if (!new || clock == new)
 		return;
 
 	clocksource_forward_now();
@@ -446,7 +446,7 @@ void __init timekeeping_init(void)
 
 	ntp_init();
 
-	clock = clocksource_get_next();
+	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
 	/* set mult_orig on enable */
