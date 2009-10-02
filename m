Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZJBA71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZJBA71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZJBA70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:59:26 -0400
Received: from thunk.org ([69.25.196.29]:59790 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZJBA7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:59:25 -0400
Date: Thu, 1 Oct 2009 20:59:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge
	commit
Message-ID: <20091002005907.GA7490@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	Ondrej Zary <linux@rainbow-software.org>,
	Magnus Damm <magnus.damm@gmail.com>
References: <E1MrRDa-0002WF-LO@closure.thunk.org> <200909271813.42829.rjw@sisk.pl> <20090928135109.GB17514@mit.edu> <200909282322.57824.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909282322.57824.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So as I mentioned, using the technique that Linus suggested, I
bisected it down to this commit:

commit 75c5158f70c065b9704b924503d96e8297838f79
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Fri Aug 14 15:47:30 2009 +0200

    timekeeping: Update clocksource with stop_machine
    
    update_wall_time calls change_clocksource HZ times per second to check
    if a new clock source is available. In close to 100% of all calls
    there is no new clock. Replace the tick based check by an update done
    with stop_machine.
    
    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Acked-by: John Stultz <johnstul@us.ibm.com>
    Cc: Daniel Walker <dwalker@fifo99.com>
    LKML-Reference: <20090814134810.711836357@de.ibm.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

The commit wasn't easy to undo, given how many other changes there
were, but starting with 2.6.31-git9, which exhibited the problem, I
reverted commit 75c5158, and while I'm not 100% sure I resolved the
conflicts correctly, 2.6.31-git9 will reliable not come back from the
2nd suspend, and after I apply the following patch attempting to
revert 75c5158, the problem goes away.

						- Ted

commit 8c3ee48dabee782d470cc4c7048ea64bb8b7d1cb
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Oct 1 20:39:03 2009 -0400

    Revert "timekeeping: Update clocksource with stop_machine"
    
    This reverts commit 75c5158f70c065b9704b924503d96e8297838f79.
    
    Conflicts:
    
    	kernel/time/clocksource.c

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 83d2fbd..99bb031 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -292,6 +292,4 @@ static inline void update_vsyscall_tz(void)
 }
 #endif
 
-extern void timekeeping_notify(struct clocksource *clock);
-
 #endif /* _LINUX_CLOCKSOURCE_H */
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 0911334..f6b84b2 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -110,19 +110,36 @@ EXPORT_SYMBOL(timecounter_cyc2time);
 /*[Clocksource internal variables]---------
  * curr_clocksource:
  *	currently selected clocksource.
+ * next_clocksource:
+ *	pending next selected clocksource.
  * clocksource_list:
  *	linked list with the registered clocksources
- * clocksource_mutex:
- *	protects manipulations to curr_clocksource and the clocksource_list
+ * clocksource_lock:
+ *	protects manipulations to curr_clocksource and next_clocksource
+ *	and the clocksource_list
  * override_name:
  *	Name of the user-specified clocksource.
  */
 static struct clocksource *curr_clocksource;
+static struct clocksource *next_clocksource;
 static LIST_HEAD(clocksource_list);
-static DEFINE_MUTEX(clocksource_mutex);
+static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
 static int finished_booting;
 
+/* clocksource_done_booting - Called near the end of core bootup
+ *
+ * Hack to avoid lots of clocksource churn at boot time.
+ * We use fs_initcall because we want this to start before
+ * device_initcall but after subsys_initcall.
+ */
+static int __init clocksource_done_booting(void)
+{
+	finished_booting = 1;
+	return 0;
+}
+fs_initcall(clocksource_done_booting);
+
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 static void clocksource_watchdog_work(struct work_struct *work);
 
@@ -353,7 +370,6 @@ static int clocksource_watchdog_kthread(void *data)
 	unsigned long flags;
 	LIST_HEAD(unstable);
 
-	mutex_lock(&clocksource_mutex);
 	spin_lock_irqsave(&watchdog_lock, flags);
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
@@ -369,7 +385,6 @@ static int clocksource_watchdog_kthread(void *data)
 		list_del_init(&cs->wd_list);
 		__clocksource_change_rating(cs, 0);
 	}
-	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
 
@@ -393,16 +408,18 @@ static inline int clocksource_watchdog_kthread(void *data) { return 0; }
 void clocksource_resume(void)
 {
 	struct clocksource *cs;
+	unsigned long flags;
 
-	mutex_lock(&clocksource_mutex);
+	spin_lock_irqsave(&clocksource_lock, flags);
 
-	list_for_each_entry(cs, &clocksource_list, list)
+	list_for_each_entry(cs, &clocksource_list, list) {
 		if (cs->resume)
 			cs->resume();
+	}
 
 	clocksource_resume_watchdog();
 
-	mutex_unlock(&clocksource_mutex);
+	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 
 /**
@@ -418,11 +435,28 @@ void clocksource_touch_watchdog(void)
 }
 
 #ifdef CONFIG_GENERIC_TIME
+/**
+ * clocksource_get_next - Returns the selected clocksource
+ *
+ */
+struct clocksource *clocksource_get_next(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+	if (next_clocksource && finished_booting) {
+		curr_clocksource = next_clocksource;
+		next_clocksource = NULL;
+	}
+	spin_unlock_irqrestore(&clocksource_lock, flags);
+
+	return curr_clocksource;
+}
 
 /**
  * clocksource_select - Select the best clocksource available
  *
- * Private function. Must hold clocksource_mutex when called.
+ * Private function. Must hold clocksource_lock when called.
  *
  * Select the clocksource with the best rating, or the clocksource,
  * which is selected by userspace override.
@@ -431,7 +465,7 @@ static void clocksource_select(void)
 {
 	struct clocksource *best, *cs;
 
-	if (!finished_booting || list_empty(&clocksource_list))
+	if (list_empty(&clocksource_list))
 		return;
 	/* First clocksource on the list has the best rating. */
 	best = list_first_entry(&clocksource_list, struct clocksource, list);
@@ -456,43 +490,17 @@ static void clocksource_select(void)
 			best = cs;
 		break;
 	}
-	if (curr_clocksource != best) {
-		printk(KERN_INFO "Switching to clocksource %s\n", best->name);
-		curr_clocksource = best;
-		timekeeping_notify(curr_clocksource);
-	}
+	if (curr_clocksource != best)
+		next_clocksource = best;
 }
 
 #else /* CONFIG_GENERIC_TIME */
 
-static inline void clocksource_select(void) { }
+static void clocksource_select(void) { }
 
 #endif
 
 /*
- * clocksource_done_booting - Called near the end of core bootup
- *
- * Hack to avoid lots of clocksource churn at boot time.
- * We use fs_initcall because we want this to start before
- * device_initcall but after subsys_initcall.
- */
-static int __init clocksource_done_booting(void)
-{
-	finished_booting = 1;
-
-	/*
-	 * Run the watchdog first to eliminate unstable clock sources
-	 */
-	clocksource_watchdog_kthread(NULL);
-
-	mutex_lock(&clocksource_mutex);
-	clocksource_select();
-	mutex_unlock(&clocksource_mutex);
-	return 0;
-}
-fs_initcall(clocksource_done_booting);
-
-/*
  * Enqueue the clocksource sorted by rating
  */
 static void clocksource_enqueue(struct clocksource *cs)
@@ -515,11 +523,13 @@ static void clocksource_enqueue(struct clocksource *cs)
  */
 int clocksource_register(struct clocksource *cs)
 {
-	mutex_lock(&clocksource_mutex);
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
 	clocksource_enqueue(cs);
 	clocksource_select();
+	spin_unlock_irqrestore(&clocksource_lock, flags);
 	clocksource_enqueue_watchdog(cs);
-	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
 EXPORT_SYMBOL(clocksource_register);
@@ -537,9 +547,14 @@ static void __clocksource_change_rating(struct clocksource *cs, int rating)
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
-	mutex_lock(&clocksource_mutex);
-	__clocksource_change_rating(cs, rating);
-	mutex_unlock(&clocksource_mutex);
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+	list_del(&cs->list);
+	cs->rating = rating;
+	clocksource_enqueue(cs);
+	clocksource_select();
+	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 EXPORT_SYMBOL(clocksource_change_rating);
 
@@ -548,11 +563,13 @@ EXPORT_SYMBOL(clocksource_change_rating);
  */
 void clocksource_unregister(struct clocksource *cs)
 {
-	mutex_lock(&clocksource_mutex);
+	unsigned long flags;
+
 	clocksource_dequeue_watchdog(cs);
+	spin_lock_irqsave(&clocksource_lock, flags);
 	list_del(&cs->list);
 	clocksource_select();
-	mutex_unlock(&clocksource_mutex);
+	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 EXPORT_SYMBOL(clocksource_unregister);
 
@@ -570,9 +587,9 @@ sysfs_show_current_clocksources(struct sys_device *dev,
 {
 	ssize_t count = 0;
 
-	mutex_lock(&clocksource_mutex);
+	spin_lock_irq(&clocksource_lock);
 	count = snprintf(buf, PAGE_SIZE, "%s\n", curr_clocksource->name);
-	mutex_unlock(&clocksource_mutex);
+	spin_unlock_irq(&clocksource_lock);
 
 	return count;
 }
@@ -600,14 +617,14 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 	if (buf[count-1] == '\n')
 		count--;
 
-	mutex_lock(&clocksource_mutex);
+	spin_lock_irq(&clocksource_lock);
 
 	if (count > 0)
 		memcpy(override_name, buf, count);
 	override_name[count] = 0;
 	clocksource_select();
 
-	mutex_unlock(&clocksource_mutex);
+	spin_unlock_irq(&clocksource_lock);
 
 	return ret;
 }
@@ -627,7 +644,7 @@ sysfs_show_available_clocksources(struct sys_device *dev,
 	struct clocksource *src;
 	ssize_t count = 0;
 
-	mutex_lock(&clocksource_mutex);
+	spin_lock_irq(&clocksource_lock);
 	list_for_each_entry(src, &clocksource_list, list) {
 		/*
 		 * Don't show non-HRES clocksource if the tick code is
@@ -639,7 +656,7 @@ sysfs_show_available_clocksources(struct sys_device *dev,
 				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
 				  "%s ", src->name);
 	}
-	mutex_unlock(&clocksource_mutex);
+	spin_unlock_irq(&clocksource_lock);
 
 	count += snprintf(buf + count,
 			  max((ssize_t)PAGE_SIZE - count, (ssize_t)0), "\n");
@@ -694,10 +711,11 @@ device_initcall(init_clocksource_sysfs);
  */
 static int __init boot_override_clocksource(char* str)
 {
-	mutex_lock(&clocksource_mutex);
+	unsigned long flags;
+	spin_lock_irqsave(&clocksource_lock, flags);
 	if (str)
 		strlcpy(override_name, str, sizeof(override_name));
-	mutex_unlock(&clocksource_mutex);
+	spin_unlock_irqrestore(&clocksource_lock, flags);
 	return 1;
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb0f46f..74e2ca2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -18,7 +18,6 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 #include <linux/tick.h>
-#include <linux/stop_machine.h>
 
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
@@ -180,7 +179,6 @@ void timekeeping_leap_insert(int leapsecond)
 }
 
 #ifdef CONFIG_GENERIC_TIME
-
 /**
  * timekeeping_forward_now - update clock to the current time
  *
@@ -353,40 +351,31 @@ EXPORT_SYMBOL(do_settimeofday);
  *
  * Accumulates current time interval and initializes new clocksource
  */
-static int change_clocksource(void *data)
+static void change_clocksource(void)
 {
 	struct clocksource *new, *old;
 
-	new = (struct clocksource *) data;
+	new = clocksource_get_next();
+
+	if (!new || timekeeper.clock == new)
+		return;
 
 	timekeeping_forward_now();
-	if (!new->enable || new->enable(new) == 0) {
-		old = timekeeper.clock;
-		timekeeper_setup_internals(new);
-		if (old->disable)
-			old->disable(old);
-	}
-	return 0;
-}
 
-/**
- * timekeeping_notify - Install a new clock source
- * @clock:		pointer to the clock source
- *
- * This function is called from clocksource.c after a new, better clock
- * source has been registered. The caller holds the clocksource_mutex.
- */
-void timekeeping_notify(struct clocksource *clock)
-{
-	if (timekeeper.clock == clock)
+	if (new->enable && !new->enable(new))
 		return;
-	stop_machine(change_clocksource, clock, NULL);
+
+	old = timekeeper.clock;
+	timekeeper_setup_internals(new);
+
+	if (old->disable)
+		old->disable(old);
+
 	tick_clock_notify();
 }
-
 #else /* GENERIC_TIME */
-
 static inline void timekeeping_forward_now(void) { }
+static inline void change_clocksource(void) { }
 
 /**
  * ktime_get - get the monotonic time in ktime_t format
@@ -427,7 +416,6 @@ void ktime_get_ts(struct timespec *ts)
 				ts->tv_nsec + tomono.tv_nsec);
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
-
 #endif /* !GENERIC_TIME */
 
 /**
@@ -810,6 +798,7 @@ void update_wall_time(void)
 	update_xtime_cache(nsecs);
 
 	/* check to see if there is a new clocksource to use */
+	change_clocksource();
 	update_vsyscall(&xtime, timekeeper.clock);
 }
 
