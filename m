Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZG2Nmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZG2Nmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZG2Nmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:42:32 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50080 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZG2Nmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:42:31 -0400
Message-Id: <20090729134229.762580751@de.ibm.com>
References: <20090729134125.313191633@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 15:41:28 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][patch 03/12] cleanup clocksource selection
Content-Disposition: inline; filename=clocksource-select.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Sorting the list of clocksources according to their rating is not
necessary as the clocksource selection is not performance critical.
Simplify clocksource_register and sysfs_override_clocksource,
remove clocksource_enqueue and let clocksource_select do the job.
The check in clocksource_register for double registration of the
same clocksource is removed without replacement.

To find the initial clocksource a new weak function in jiffies.c is
defined that returns the jiffies clocksource. The architecture code
can then override the weak function with a more suitable clocksource,
e.g. the TOD clock on s390.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/kernel/time.c     |    4 +
 include/linux/clocksource.h |    2 
 kernel/time/clocksource.c   |  148 ++++++++++++++------------------------------
 kernel/time/jiffies.c       |    6 +
 kernel/time/timekeeping.c   |    4 -
 5 files changed, 62 insertions(+), 102 deletions(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -21,7 +21,6 @@
  *
  * TODO WishList:
  *   o Allow clocksource drivers to be unregistered
- *   o get rid of clocksource_jiffies extern
  */
 
 #include <linux/clocksource.h>
@@ -107,9 +106,6 @@ u64 timecounter_cyc2time(struct timecoun
 }
 EXPORT_SYMBOL(timecounter_cyc2time);
 
-/* XXX - Would like a better way for initializing curr_clocksource */
-extern struct clocksource clocksource_jiffies;
-
 /*[Clocksource internal variables]---------
  * curr_clocksource:
  *	currently selected clocksource. Initialized to clocksource_jiffies.
@@ -123,9 +119,8 @@ extern struct clocksource clocksource_ji
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
@@ -339,77 +335,69 @@ struct clocksource *clocksource_get_next
 }
 
 /**
- * select_clocksource - Selects the best registered clocksource.
- *
- * Private function. Must hold clocksource_lock when called.
- *
- * Select the clocksource with the best rating, or the clocksource,
- * which is selected by userspace override.
+ * clocksource_select - Select the best clocksource available
  */
-static struct clocksource *select_clocksource(void)
+static int clocksource_select(void)
 {
-	struct clocksource *next;
-
-	if (list_empty(&clocksource_list))
-		return NULL;
-
-	if (clocksource_override)
-		next = clocksource_override;
-	else
-		next = list_entry(clocksource_list.next, struct clocksource,
-				  list);
+	struct clocksource *best, *cs;
+	int rc;
 
-	if (next == curr_clocksource)
-		return NULL;
-
-	return next;
-}
-
-/*
- * Enqueue the clocksource sorted by rating
- */
-static int clocksource_enqueue(struct clocksource *c)
-{
-	struct list_head *tmp, *entry = &clocksource_list;
-
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *cs;
-
-		cs = list_entry(tmp, struct clocksource, list);
-		if (cs == c)
-			return -EBUSY;
-		/* Keep track of the place, where to insert */
-		if (cs->rating >= c->rating)
-			entry = tmp;
+	rc = 0;
+	best = NULL;
+	list_for_each_entry(cs, &clocksource_list, list) {
+		/* Check for the override clocksource. */
+		if (strcmp(cs->name, override_name) == 0) {
+			/*
+			 * Check to make sure we don't switch to a non-highres
+			 * capable clocksource if the tick code is in oneshot
+			 * mode (highres or nohz)
+			 */
+			if ((cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) ||
+			    !tick_oneshot_mode_active()) {
+				/* Override clocksource can be used. */
+				best = cs;
+				break;
+			}
+			/* Override clocksource cannot be used. */
+			printk(KERN_WARNING "Override clocksource %s is not "
+			       "HRT compatible. Cannot switch while in "
+			       "HRT/NOHZ mode\n", cs->name);
+			override_name[0] = 0;
+		}
+		/* Check rating */
+		if (!best || cs->rating > best->rating)
+			best = cs;
 	}
-	list_add(&c->list, entry);
+	if (curr_clocksource != best)
+		next_clocksource = best;
+	return rc;
+}
 
-	if (strlen(c->name) == strlen(override_name) &&
-	    !strcmp(c->name, override_name))
-		clocksource_override = c;
+#else /* CONFIG_GENERIC_TIME */
 
+static inline int clocksource_select(void)
+{
 	return 0;
 }
 
+#endif
+
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
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
+	list_add(&cs->list, &clocksource_list);
+	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
-	if (!ret)
-		clocksource_check_watchdog(c);
-	return ret;
+	clocksource_check_watchdog(cs);
+	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
 
@@ -422,10 +410,8 @@ void clocksource_change_rating(struct cl
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	list_del(&cs->list);
 	cs->rating = rating;
-	clocksource_enqueue(cs);
-	next_clocksource = select_clocksource();
+	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 
@@ -438,9 +424,7 @@ void clocksource_unregister(struct clock
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 	list_del(&cs->list);
-	if (clocksource_override == cs)
-		clocksource_override = NULL;
-	next_clocksource = select_clocksource();
+	clocksource_select();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 
@@ -478,10 +462,6 @@ static ssize_t sysfs_override_clocksourc
 					  struct sysdev_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct clocksource *ovr = NULL;
-	size_t ret = count;
-	int len;
-
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(override_name))
 		return -EINVAL;
@@ -495,41 +475,11 @@ static ssize_t sysfs_override_clocksourc
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
 
-	return ret;
+	return count;
 }
 
 /**
Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/cache.h>
 #include <linux/timer.h>
+#include <linux/init.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
@@ -322,6 +323,7 @@ extern void clocksource_touch_watchdog(v
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
+extern struct clocksource * __init __weak clocksource_default_clock(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -269,7 +269,7 @@ static void change_clocksource(void)
 
 	new = clocksource_get_next();
 
-	if (clock == new)
+	if (!new || clock == new)
 		return;
 
 	clocksource_forward_now();
@@ -436,7 +436,7 @@ void __init timekeeping_init(void)
 
 	ntp_init();
 
-	clock = clocksource_get_next();
+	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
 	/* save mult_orig on enable */
Index: linux-2.6/kernel/time/jiffies.c
===================================================================
--- linux-2.6.orig/kernel/time/jiffies.c
+++ linux-2.6/kernel/time/jiffies.c
@@ -61,7 +61,6 @@ struct clocksource clocksource_jiffies =
 	.read		= jiffies_read,
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
-	.mult_orig	= NSEC_PER_JIFFY << JIFFIES_SHIFT,
 	.shift		= JIFFIES_SHIFT,
 };
 
@@ -71,3 +70,8 @@ static int __init init_jiffies_clocksour
 }
 
 core_initcall(init_jiffies_clocksource);
+
+struct clocksource * __init __weak clocksource_default_clock(void)
+{
+	return &clocksource_jiffies;
+}
Index: linux-2.6/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/time.c
+++ linux-2.6/arch/s390/kernel/time.c
@@ -205,6 +205,10 @@ static struct clocksource clocksource_to
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+struct clocksource * __init clocksource_default_clock(void)
+{
+	return &clocksource_tod;
+}
 
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

