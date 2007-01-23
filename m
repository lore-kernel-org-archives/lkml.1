Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbXAWWLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbXAWWLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965560AbXAWWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:11:47 -0500
Received: from www.osadl.org ([213.239.205.134]:35849 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933152AbXAWWA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:58 -0500
Message-Id: <20070123211205.382655000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 17/46] clocksource: Remove the update callback
Content-Disposition: inline; filename=clocksource-remove-update-callback.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The clocksource code allows direct updates of the rating
of a given clocksource now. Change TSC unstable tracking to
use this interface and remove the update callback.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/tsc.c      |   51 ++++++++++++++------------------------------
 include/linux/clocksource.h |    8 ++----
 kernel/timer.c              |    2 -
 3 files changed, 20 insertions(+), 41 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/tsc.c
@@ -60,12 +60,6 @@ static inline int check_tsc_unstable(voi
 	return tsc_unstable;
 }
 
-void mark_tsc_unstable(void)
-{
-	tsc_unstable = 1;
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
 /* Accellerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
@@ -295,7 +289,6 @@ core_initcall(cpufreq_tsc);
 /* clock source code */
 
 static unsigned long current_tsc_khz = 0;
-static int tsc_update_callback(void);
 
 static cycle_t read_tsc(void)
 {
@@ -313,38 +306,28 @@ static struct clocksource clocksource_ts
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
-	.update_callback	= tsc_update_callback,
 	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-static int tsc_update_callback(void)
+void mark_tsc_unstable(void)
 {
-	int change = 0;
-
-	/* check to see if we should switch to the safe clocksource: */
-	if (clocksource_tsc.rating != 0 && check_tsc_unstable()) {
-		clocksource_tsc.rating = 0;
-		clocksource_reselect();
-		change = 1;
-	}
-
-	/* only update if tsc_khz has changed: */
-	if (current_tsc_khz != tsc_khz) {
-		current_tsc_khz = tsc_khz;
-		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
-							clocksource_tsc.shift);
-		change = 1;
+	if (!tsc_unstable) {
+		tsc_unstable = 1;
+		/* Can be called before registration */
+		if (clocksource_tsc.mult)
+			clocksource_change_rating(&clocksource_tsc, 0);
+		else
+			clocksource_tsc.rating = 0;
 	}
-
-	return change;
 }
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init dmi_mark_tsc_unstable(struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
 		       d->ident);
-	mark_tsc_unstable();
+	tsc_unstable = 1;
 	return 0;
 }
 
@@ -416,11 +399,12 @@ __cpuinit int unsynchronized_tsc(void)
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
 	 */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
- 		return 0;
-
-	/* assume multi socket systems are not synchronized: */
- 	return num_possible_cpus() > 1;
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
+		/* assume multi socket systems are not synchronized: */
+		if (num_possible_cpus() > 1)
+			tsc_unstable = 1;
+	}
+	return tsc_unstable;
 }
 
 static int __init init_tsc_clocksource(void)
@@ -430,8 +414,7 @@ static int __init init_tsc_clocksource(v
 		/* check blacklist */
 		dmi_check_system(bad_tsc_dmi_table);
 
-		if (unsynchronized_tsc()) /* mark unstable if unsynced */
-			mark_tsc_unstable();
+		unsynchronized_tsc();
 		current_tsc_khz = tsc_khz;
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
Index: linux-2.6.20-rc4-mm1-bo/include/linux/clocksource.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/clocksource.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/clocksource.h
@@ -44,7 +44,6 @@ typedef u64 cycle_t;
  *			subtraction of non 64 bit counters
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
- * @update_callback:	called when safe to alter clocksource values
  * @flags:		flags describing special properties
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
@@ -57,7 +56,6 @@ struct clocksource {
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
-	int (*update_callback)(void);
 	unsigned long flags;
 
 	/* timekeeping specific data, ignore */
@@ -184,8 +182,8 @@ static inline void clocksource_calculate
 
 
 /* used to install a new clocksource */
-int clocksource_register(struct clocksource*);
-void clocksource_reselect(void);
-struct clocksource* clocksource_get_next(void);
+extern int clocksource_register(struct clocksource*);
+extern struct clocksource* clocksource_get_next(void);
+extern void clocksource_change_rating(struct clocksource *, int rating);
 
 #endif /* _LINUX_CLOCKSOURCE_H */
Index: linux-2.6.20-rc4-mm1-bo/kernel/timer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/timer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/timer.c
@@ -848,8 +848,6 @@ static int change_clocksource(void)
 		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
 		       clock->name);
 		return 1;
-	} else if (clock->update_callback) {
-		return clock->update_callback();
 	}
 	return 0;
 }

--

