Return-Path: <linux-kernel-owner+w=401wt.eu-S932711AbXAaDt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbXAaDt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXAaDt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:49:26 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:1670 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932711AbXAaDtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:49:24 -0500
Message-Id: <20070131033807.427331295@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:24 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 14/23] clocksource: increase initcall priority
Content-Disposition: inline; filename=clocksource_init_call.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Normal systems often have almost everything registered in
device_initcall() . Most drivers are registered there, and usually if
people add code that needs an initcall they will either use
device_initcall() or module_init() which both result in the same
initcall..

When John created the clocksource interface he did what most people
would do , and he made the clocksource registration happen in  
device_initcall with most everything else .. The effect of doing this
was the addition of the following code,

/* clocksource_done_booting - Called near the end of bootup
 *
 * Hack to avoid lots of clocksource churn at boot time
 */
static int __init clocksource_done_booting(void)
{
        finished_booting = 1;
        return 0;
}

late_initcall(clocksource_done_booting);

This is one of two initcalls in the clocksource interface , the other
one is device_initcall(init_clocksource_sysfs); ..

If I leave the clocksource initcall alone then anything that uses a
clocksource in the future would need at least one late_initcall().
Since the clocksources aren't all fully register until after 
device_initcall. 

The reason behind changing that is because it doesn't fit the usually
development flow of initialization functions which , as I said earlier,
almost always end up into device_initcall .

This change certainly isn't mandatory . I feel it would reduce the
likely hood of developers that use the clocksource interface from adding
multiple initcalls (one late_initcall, and one device_initcall). It also
better fits developers tendencies to put almost everything into
device_initcall() ..

In addition,

This patch removes a small amount of code in time keeping which existed to
detect the end of the initcall sequence then selected a clock.

As a note, arm and mips both register their clocksources during time_init()
instead of using initcalls.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/hpet.c          |    2 +-
 arch/i386/kernel/i8253.c         |    2 +-
 arch/i386/kernel/tsc.c           |    2 +-
 arch/x86_64/kernel/hpet.c        |    2 +-
 arch/x86_64/kernel/tsc.c         |    3 +--
 drivers/clocksource/acpi_pm.c    |    8 +++++++-
 drivers/clocksource/cyclone.c    |    2 +-
 drivers/clocksource/scx200_hrt.c |    2 +-
 include/linux/clocksource.h      |    6 ++++++
 kernel/time/clocksource.c        |   13 -------------
 kernel/time/jiffies.c            |    2 +-
 kernel/time/tick-sched.c         |    8 ++++++++
 kernel/time/timekeeping.c        |   15 +++++++--------
 13 files changed, 36 insertions(+), 31 deletions(-)

Index: linux-2.6.19/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.19/arch/i386/kernel/hpet.c
@@ -315,7 +315,7 @@ static int __init init_hpet_clocksource(
 	return clocksource_register(&clocksource_hpet);
 }
 
-module_init(init_hpet_clocksource);
+clocksource_initcall(init_hpet_clocksource);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
Index: linux-2.6.19/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/i8253.c
+++ linux-2.6.19/arch/i386/kernel/i8253.c
@@ -195,4 +195,4 @@ static int __init init_pit_clocksource(v
 	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE, 20);
 	return clocksource_register(&clocksource_pit);
 }
-module_init(init_pit_clocksource);
+clocksource_initcall(init_pit_clocksource);
Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -458,4 +458,4 @@ static int __init init_tsc_clocksource(v
 	return 0;
 }
 
-module_init(init_tsc_clocksource);
+clocksource_initcall(init_tsc_clocksource);
Index: linux-2.6.19/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.19/arch/x86_64/kernel/hpet.c
@@ -508,4 +508,4 @@ static int __init init_hpet_clocksource(
 	return clocksource_register(&clocksource_hpet);
 }
 
-module_init(init_hpet_clocksource);
+clocksource_initcall(init_hpet_clocksource);
Index: linux-2.6.19/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/tsc.c
+++ linux-2.6.19/arch/x86_64/kernel/tsc.c
@@ -224,5 +224,4 @@ static int __init init_tsc_clocksource(v
 	}
 	return 0;
 }
-
-module_init(init_tsc_clocksource);
+clocksource_initcall(init_tsc_clocksource);
Index: linux-2.6.19/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/acpi_pm.c
+++ linux-2.6.19/drivers/clocksource/acpi_pm.c
@@ -214,4 +214,10 @@ pm_good:
 	return clocksource_register(&clocksource_acpi_pm);
 }
 
-module_init(init_acpi_pm_clocksource);
+/*
+ * This clocksource is removed from the clocksource_initcall
+ * macro since it's mandatory for it to be in fs_initcall as the
+ * highest initcall level, or else it doesn't work properly with
+ * it's PCI fix ups.
+ */
+fs_initcall(init_acpi_pm_clocksource);
Index: linux-2.6.19/drivers/clocksource/cyclone.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/cyclone.c
+++ linux-2.6.19/drivers/clocksource/cyclone.c
@@ -116,4 +116,4 @@ static int __init init_cyclone_clocksour
 	return clocksource_register(&clocksource_cyclone);
 }
 
-module_init(init_cyclone_clocksource);
+clocksource_initcall(init_cyclone_clocksource);
Index: linux-2.6.19/drivers/clocksource/scx200_hrt.c
===================================================================
--- linux-2.6.19.orig/drivers/clocksource/scx200_hrt.c
+++ linux-2.6.19/drivers/clocksource/scx200_hrt.c
@@ -94,7 +94,7 @@ static int __init init_hrt_clocksource(v
 	return clocksource_register(&cs_hrt);
 }
 
-module_init(init_hrt_clocksource);
+clocksource_initcall(init_hrt_clocksource);
 
 MODULE_AUTHOR("Jim Cromie <jim.cromie@gmail.com>");
 MODULE_DESCRIPTION("clocksource on SCx200 HiRes Timer");
Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -41,6 +41,12 @@ extern struct atomic_notifier_head clock
 #define CLOCKSOURCE_NOTIFY_RATING	2
 #define CLOCKSOURCE_NOTIFY_FREQ		4
 
+/*
+ * Defined so the initcall can be changes without touching
+ * every clocksource in the system.
+ */
+#define clocksource_initcall(x)		fs_initcall(x)
+
 /**
  * clocksource_notifier_register - Registers a list change notifier
  * @nb:		pointer to a notifier block
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -38,22 +38,9 @@
  */
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
-static int finished_booting;
 
 ATOMIC_NOTIFIER_HEAD(clocksource_list_notifier);
 
-/* clocksource_done_booting - Called near the end of bootup
- *
- * Hack to avoid lots of clocksource churn at boot time
- */
-static int __init clocksource_done_booting(void)
-{
-	finished_booting = 1;
-	return 0;
-}
-
-late_initcall(clocksource_done_booting);
-
 /**
  * __is_registered - Returns a clocksource if it's registered
  * @name:		name of the clocksource to return
Index: linux-2.6.19/kernel/time/jiffies.c
===================================================================
--- linux-2.6.19.orig/kernel/time/jiffies.c
+++ linux-2.6.19/kernel/time/jiffies.c
@@ -69,4 +69,4 @@ static int __init init_jiffies_clocksour
 	return clocksource_register(&clocksource_jiffies);
 }
 
-module_init(init_jiffies_clocksource);
+clocksource_initcall(init_jiffies_clocksource);
Index: linux-2.6.19/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.19.orig/kernel/time/tick-sched.c
+++ linux-2.6.19/kernel/time/tick-sched.c
@@ -540,6 +540,14 @@ int tick_check_oneshot_change(int allow_
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
+	/*
+	 * HRT or Dynamic tick can't be started during init, but it's possible
+	 * for generic time to switch to a good clock during init. So
+	 * explicitly check that we are't still booting here.
+	 */
+	if (system_state == SYSTEM_BOOTING)
+		return 0;
+
 	if (!test_and_clear_bit(0, &ts->check_clocks))
 		return 0;
 
Index: linux-2.6.19/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.19.orig/kernel/time/timekeeping.c
+++ linux-2.6.19/kernel/time/timekeeping.c
@@ -318,14 +318,6 @@ static __init int timekeeping_init_sysfs
 device_initcall(timekeeping_init_sysfs);
 #endif /* CONFIG_SYSFS */
 
-static int __init timekeeping_early_clockswitch(void)
-{
-	atomic_inc(&clock_check);
-	return 0;
-}
-
-late_initcall(timekeeping_early_clockswitch);
-
 /**
  * boot_override_clocksource - boot clock override
  * @str:	override name
@@ -471,6 +463,13 @@ static int __init timekeeping_init_devic
 	if (!error)
 		error = sysdev_register(&device_timer);
 
+#ifdef CONFIG_GENERIC_TIME
+	/*
+	 * Now we signal to switch to a high-res clock.
+	 */
+	atomic_inc(&clock_check);
+#endif
+
 	return error;
 }
 

-- 
