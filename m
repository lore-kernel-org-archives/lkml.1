Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbXAaDth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbXAaDth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbXAaDth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:49:37 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:1683 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932783AbXAaDtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:49:35 -0500
Message-Id: <20070131033803.909323479@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:13 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: [PATCH 03/23] clocksource: drop clocksource-remove-the-update-callback.patch
Content-Disposition: inline; filename=drop-clocksource-remove-the-update-callback.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Drop.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/tsc.c      |   51 +++++++++++++++++++++++++++++---------------
 include/linux/clocksource.h |   11 ++++++---
 kernel/timer.c              |    3 ++
 3 files changed, 45 insertions(+), 20 deletions(-)

Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -60,6 +60,12 @@ static inline int check_tsc_unstable(voi
 	return tsc_unstable;
 }
 
+void mark_tsc_unstable(void)
+{
+	tsc_unstable = 1;
+}
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
+
 /* Accellerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
@@ -289,6 +295,7 @@ core_initcall(cpufreq_tsc);
 /* clock source code */
 
 static unsigned long current_tsc_khz = 0;
+static int tsc_update_callback(void);
 
 static cycle_t read_tsc(void)
 {
@@ -306,28 +313,38 @@ static struct clocksource clocksource_ts
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
+	.update_callback	= tsc_update_callback,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-void mark_tsc_unstable(void)
+static int tsc_update_callback(void)
 {
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
-		/* Can be called before registration */
-		if (clocksource_tsc.mult)
-			clocksource_change_rating(&clocksource_tsc, 0);
-		else
-			clocksource_tsc.rating = 0;
+	int change = 0;
+
+	/* check to see if we should switch to the safe clocksource: */
+	if (clocksource_tsc.rating != 0 && check_tsc_unstable()) {
+		clocksource_tsc.rating = 0;
+		clocksource_reselect();
+		change = 1;
+	}
+
+	/* only update if tsc_khz has changed: */
+	if (current_tsc_khz != tsc_khz) {
+		current_tsc_khz = tsc_khz;
+		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
+							clocksource_tsc.shift);
+		change = 1;
 	}
+
+	return change;
 }
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init dmi_mark_tsc_unstable(struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
 		       d->ident);
-	tsc_unstable = 1;
+	mark_tsc_unstable();
 	return 0;
 }
 
@@ -399,12 +416,11 @@ __cpuinit int unsynchronized_tsc(void)
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
 	 */
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
-		/* assume multi socket systems are not synchronized: */
-		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
-	}
-	return tsc_unstable;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+ 		return 0;
+
+	/* assume multi socket systems are not synchronized: */
+ 	return num_possible_cpus() > 1;
 }
 
 /*
@@ -433,7 +449,8 @@ static int __init init_tsc_clocksource(v
 		/* check blacklist */
 		dmi_check_system(bad_tsc_dmi_table);
 
-		unsynchronized_tsc();
+		if (unsynchronized_tsc()) /* mark unstable if unsynced */
+			mark_tsc_unstable();
 		check_geode_tsc_reliable();
 		current_tsc_khz = tsc_khz;
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -44,6 +44,7 @@ typedef u64 cycle_t;
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
+ * @update_callback:	called when safe to alter clocksource values
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
@@ -57,6 +58,7 @@ struct clocksource {
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
+	int (*update_callback)(void);
 	unsigned long flags;
 	cycle_t (*vread)(void);
 
@@ -184,9 +186,9 @@ static inline void clocksource_calculate
 
 
 /* used to install a new clocksource */
-extern int clocksource_register(struct clocksource*);
-extern struct clocksource* clocksource_get_next(void);
-extern void clocksource_change_rating(struct clocksource *cs, int rating);
+int clocksource_register(struct clocksource*);
+void clocksource_reselect(void);
+struct clocksource* clocksource_get_next(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
@@ -196,4 +198,7 @@ static inline void update_vsyscall(struc
 }
 #endif
 
+#define clocksource_reselect()	clocksource_change_rating(&clocksource_tsc, clocksource_tsc.rating)
+extern void clocksource_change_rating(struct clocksource *cs, int rating);
+
 #endif /* _LINUX_CLOCKSOURCE_H */
Index: linux-2.6.19/kernel/timer.c
===================================================================
--- linux-2.6.19.orig/kernel/timer.c
+++ linux-2.6.19/kernel/timer.c
@@ -893,6 +893,8 @@ static int change_clocksource(void)
 		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
 		       clock->name);
 		return 1;
+	} else if (clock->update_callback) {
+		return clock->update_callback();
 	}
 	return 0;
 }
@@ -959,6 +961,7 @@ void __init timekeeping_init(void)
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
+
 /* flag for if timekeeping is suspended */
 static int timekeeping_suspended;
 /* time in seconds when suspend began */

-- 
