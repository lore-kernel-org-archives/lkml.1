Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbXBWANR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbXBWANR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXBWANK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:13:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55208 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXBWANH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:13:07 -0500
Subject: [PATCH -mm] clocksource init adjustments (fix bug #7426)
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: lkml <linux-kernel@vger.kernel.org>, andreas.friedrich@fujitsu-siemens.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@mvista.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 16:13:02 -0800
Message-Id: <1172189582.5422.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resolves the issue found here:
http://bugme.osdl.org/show_bug.cgi?id=7426

The basic summary is:
Currently we register most of i386/x86_64 clocksources at module_init
time. Then we enable clocksource selection at late_initcall time. This
causes some problems for drivers that use gettimeofday for init
calibration routines (specifically the es1968 driver in this case),
where durring module_init, the only clocksource available is the low-res
jiffies clocksource. This may cause slight calibration errors, due to
the small sampling time used.

It should be noted that drivers that require fine grained time may not
function on architectures that do not have better then jiffies
resolution timekeeping (there are a few). However, this does not
discount the reasonable need for such fine-grained timekeeping at init
time.

Thus the solution here is to register clocksources earlier (ideally when
the hardware is being initialized), and then we enable clocksource
selection at fs_initcall (before device_initcall).

This patch should probably get some testing time in -mm, since
clocksource selection is one of the most important issues for correct
timekeeping, and I've only been able to test this on a few of my own
boxes.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>


 arch/i386/kernel/hpet.c       |   80 ++++++++++++---------------
 arch/i386/kernel/i8253.c      |    2 
 arch/i386/kernel/setup.c      |    1 
 arch/i386/kernel/time.c       |    1 
 arch/i386/kernel/tsc.c        |   83 ++++++++++++----------------
 arch/x86_64/kernel/hpet.c     |  122 +++++++++++++++++++-----------------------
 arch/x86_64/kernel/tsc.c      |    7 --
 drivers/clocksource/acpi_pm.c |    5 +
 drivers/clocksource/cyclone.c |    2 
 kernel/time/clocksource.c     |    8 +-
 10 files changed, 145 insertions(+), 166 deletions(-)

linux-2.6.21-rc1_adjust-clocksource-selection_C7.patch
============================================
diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index e1006b7..f3ab61e 100644
--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -201,12 +201,30 @@ static int hpet_next_event(unsigned long
 }
 
 /*
+ * Clock source related code
+ */
+static cycle_t read_hpet(void)
+{
+	return (cycle_t)hpet_readl(HPET_COUNTER);
+}
+
+static struct clocksource clocksource_hpet = {
+	.name		= "hpet",
+	.rating		= 250,
+	.read		= read_hpet,
+	.mask		= HPET_MASK,
+	.shift		= HPET_SHIFT,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+/*
  * Try to setup the HPET timer
  */
 int __init hpet_enable(void)
 {
 	unsigned long id;
 	uint64_t hpet_freq;
+	u64 tmp;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -253,6 +271,25 @@ #endif
 	/* Start the counter */
 	hpet_start_counter();
 
+	/* Initialize and register HPET clocksource
+	 *
+	 * hpet period is in femto seconds per cycle
+	 * so we need to convert this to ns/cyc units
+	 * aproximated by mult/2^shift
+	 *
+	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
+	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
+	 *  fsec/cyc * 2^shift * 1nsec/1000000fsec = mult
+	 *  (fsec/cyc << shift)/1000000 = mult
+	 *  (hpet_period << shift)/FSEC_PER_NSEC = mult
+	 */
+	tmp = (u64)hpet_period << HPET_SHIFT;
+	do_div(tmp, FSEC_PER_NSEC);
+	clocksource_hpet.mult = (u32)tmp;
+
+	clocksource_register(&clocksource_hpet);
+
+
 	if (id & HPET_ID_LEGSUP) {
 		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
@@ -273,49 +310,6 @@ out_nohpet:
 	return 0;
 }
 
-/*
- * Clock source related code
- */
-static cycle_t read_hpet(void)
-{
-	return (cycle_t)hpet_readl(HPET_COUNTER);
-}
-
-static struct clocksource clocksource_hpet = {
-	.name		= "hpet",
-	.rating		= 250,
-	.read		= read_hpet,
-	.mask		= HPET_MASK,
-	.shift		= HPET_SHIFT,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-static int __init init_hpet_clocksource(void)
-{
-	u64 tmp;
-
-	if (!hpet_virt_address)
-		return -ENODEV;
-
-	/*
-	 * hpet period is in femto seconds per cycle
-	 * so we need to convert this to ns/cyc units
-	 * aproximated by mult/2^shift
-	 *
-	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
-	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
-	 *  fsec/cyc * 2^shift * 1nsec/1000000fsec = mult
-	 *  (fsec/cyc << shift)/1000000 = mult
-	 *  (hpet_period << shift)/FSEC_PER_NSEC = mult
-	 */
-	tmp = (u64)hpet_period << HPET_SHIFT;
-	do_div(tmp, FSEC_PER_NSEC);
-	clocksource_hpet.mult = (u32)tmp;
-
-	return clocksource_register(&clocksource_hpet);
-}
-
-module_init(init_hpet_clocksource);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
diff --git a/arch/i386/kernel/i8253.c b/arch/i386/kernel/i8253.c
index a6bc7bb..5cbb776 100644
--- a/arch/i386/kernel/i8253.c
+++ b/arch/i386/kernel/i8253.c
@@ -195,4 +195,4 @@ static int __init init_pit_clocksource(v
 	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE, 20);
 	return clocksource_register(&clocksource_pit);
 }
-module_init(init_pit_clocksource);
+arch_initcall(init_pit_clocksource);
diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 122623d..698c24f 100644
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -657,5 +657,4 @@ #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
 #endif
-	tsc_init();
 }
diff --git a/arch/i386/kernel/time.c b/arch/i386/kernel/time.c
index a535005..5be29fb 100644
--- a/arch/i386/kernel/time.c
+++ b/arch/i386/kernel/time.c
@@ -271,5 +271,6 @@ static void __init hpet_time_init(void)
 
 void __init time_init(void)
 {
+	tsc_init();
 	late_time_init = hpet_time_init;
 }
diff --git a/arch/i386/kernel/tsc.c b/arch/i386/kernel/tsc.c
index 3082a41..757036c 100644
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -186,34 +186,6 @@ #endif
 
 EXPORT_SYMBOL(recalibrate_cpu_khz);
 
-void __init tsc_init(void)
-{
-	if (!cpu_has_tsc || tsc_disable)
-		goto out_no_tsc;
-
-	cpu_khz = calculate_cpu_khz();
-	tsc_khz = cpu_khz;
-
-	if (!cpu_khz)
-		goto out_no_tsc;
-
-	printk("Detected %lu.%03lu MHz processor.\n",
-				(unsigned long)cpu_khz / 1000,
-				(unsigned long)cpu_khz % 1000);
-
-	set_cyc2ns_scale(cpu_khz);
-	use_tsc_delay();
-	return;
-
-out_no_tsc:
-	/*
-	 * Set the tsc_disable flag if there's no TSC support, this
-	 * makes it a fast flag for the kernel to see whether it
-	 * should be using the TSC.
-	 */
-	tsc_disable = 1;
-}
-
 #ifdef CONFIG_CPU_FREQ
 
 /*
@@ -383,28 +355,47 @@ #else
 static inline void check_geode_tsc_reliable(void) { }
 #endif
 
-static int __init init_tsc_clocksource(void)
+
+void __init tsc_init(void)
 {
+	if (!cpu_has_tsc || tsc_disable)
+		goto out_no_tsc;
 
-	if (cpu_has_tsc && tsc_khz && !tsc_disable) {
-		/* check blacklist */
-		dmi_check_system(bad_tsc_dmi_table);
+	cpu_khz = calculate_cpu_khz();
+	tsc_khz = cpu_khz;
 
-		unsynchronized_tsc();
-		check_geode_tsc_reliable();
-		current_tsc_khz = tsc_khz;
-		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
-							clocksource_tsc.shift);
-		/* lower the rating if we already know its unstable: */
-		if (check_tsc_unstable()) {
-			clocksource_tsc.rating = 0;
-			clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
-		}
+	if (!cpu_khz)
+		goto out_no_tsc;
 
-		return clocksource_register(&clocksource_tsc);
+	printk("Detected %lu.%03lu MHz processor.\n",
+				(unsigned long)cpu_khz / 1000,
+				(unsigned long)cpu_khz % 1000);
+
+	set_cyc2ns_scale(cpu_khz);
+	use_tsc_delay();
+
+	/* Check and install the TSC clocksource */
+	dmi_check_system(bad_tsc_dmi_table);
+
+	unsynchronized_tsc();
+	check_geode_tsc_reliable();
+	current_tsc_khz = tsc_khz;
+	clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
+							clocksource_tsc.shift);
+	/* lower the rating if we already know its unstable: */
+	if (check_tsc_unstable()) {
+		clocksource_tsc.rating = 0;
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
+	clocksource_register(&clocksource_tsc);
 
-	return 0;
-}
+	return;
 
-module_init(init_tsc_clocksource);
+out_no_tsc:
+	/*
+	 * Set the tsc_disable flag if there's no TSC support, this
+	 * makes it a fast flag for the kernel to see whether it
+	 * should be using the TSC.
+	 */
+	tsc_disable = 1;
+}
diff --git a/arch/x86_64/kernel/hpet.c b/arch/x86_64/kernel/hpet.c
index 65a0edd..b877325 100644
--- a/arch/x86_64/kernel/hpet.c
+++ b/arch/x86_64/kernel/hpet.c
@@ -12,6 +12,14 @@ #include <asm/vsyscall.h>
 #include <asm/timex.h>
 #include <asm/hpet.h>
 
+#define HPET_MASK	0xFFFFFFFF
+#define HPET_SHIFT	22
+
+/* FSEC = 10^-15 NSEC = 10^-9 */
+#define FSEC_PER_NSEC	1000000
+
+static void *hpet_ptr;
+
 int nohpet __initdata;
 
 unsigned long hpet_address;
@@ -106,9 +114,34 @@ int hpet_timer_stop_set_go(unsigned long
 	return 0;
 }
 
+static cycle_t read_hpet(void)
+{
+	return (cycle_t)readl(hpet_ptr);
+}
+
+static cycle_t __vsyscall_fn vread_hpet(void)
+{
+	return readl((void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+}
+
+struct clocksource clocksource_hpet = {
+	.name		= "hpet",
+	.rating		= 250,
+	.read		= read_hpet,
+	.mask		= (cycle_t)HPET_MASK,
+	.mult		= 0, /* set below */
+	.shift		= HPET_SHIFT,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.vread		= vread_hpet,
+};
+
 int hpet_arch_init(void)
 {
+	unsigned long hpet_period;
+	void __iomem *hpet_base;
 	unsigned int id;
+	u64 tmp;
+
 
 	if (!hpet_address)
 		return -1;
@@ -132,6 +165,30 @@ int hpet_arch_init(void)
 
 	hpet_use_timer = (id & HPET_ID_LEGSUP);
 
+
+	/* calculate the hpet address: */
+	hpet_base = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+	hpet_ptr = hpet_base + HPET_COUNTER;
+
+	/* calculate the frequency: */
+	hpet_period = readl(hpet_base + HPET_PERIOD);
+
+	/*
+	 * hpet period is in femto seconds per cycle
+	 * so we need to convert this to ns/cyc units
+	 * aproximated by mult/2^shift
+	 *
+	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
+	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
+	 *  fsec/cyc * 2^shift * 1nsec/1000000fsec = mult
+	 *  (fsec/cyc << shift)/1000000 = mult
+	 *  (hpet_period << shift)/FSEC_PER_NSEC = mult
+	 */
+	tmp = (u64)hpet_period << HPET_SHIFT;
+	do_div(tmp, FSEC_PER_NSEC);
+	clocksource_hpet.mult = (u32)tmp;
+	clocksource_register(&clocksource_hpet);
+
 	return hpet_timer_stop_set_go(hpet_tick);
 }
 
@@ -444,68 +501,3 @@ static int __init nohpet_setup(char *s)
 }
 
 __setup("nohpet", nohpet_setup);
-
-#define HPET_MASK	0xFFFFFFFF
-#define HPET_SHIFT	22
-
-/* FSEC = 10^-15 NSEC = 10^-9 */
-#define FSEC_PER_NSEC	1000000
-
-static void *hpet_ptr;
-
-static cycle_t read_hpet(void)
-{
-	return (cycle_t)readl(hpet_ptr);
-}
-
-static cycle_t __vsyscall_fn vread_hpet(void)
-{
-	return readl((void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
-}
-
-struct clocksource clocksource_hpet = {
-	.name		= "hpet",
-	.rating		= 250,
-	.read		= read_hpet,
-	.mask		= (cycle_t)HPET_MASK,
-	.mult		= 0, /* set below */
-	.shift		= HPET_SHIFT,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.vread		= vread_hpet,
-};
-
-static int __init init_hpet_clocksource(void)
-{
-	unsigned long hpet_period;
-	void __iomem *hpet_base;
-	u64 tmp;
-
-	if (!hpet_address)
-		return -ENODEV;
-
-	/* calculate the hpet address: */
-	hpet_base = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-	hpet_ptr = hpet_base + HPET_COUNTER;
-
-	/* calculate the frequency: */
-	hpet_period = readl(hpet_base + HPET_PERIOD);
-
-	/*
-	 * hpet period is in femto seconds per cycle
-	 * so we need to convert this to ns/cyc units
-	 * aproximated by mult/2^shift
-	 *
-	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
-	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
-	 *  fsec/cyc * 2^shift * 1nsec/1000000fsec = mult
-	 *  (fsec/cyc << shift)/1000000 = mult
-	 *  (hpet_period << shift)/FSEC_PER_NSEC = mult
-	 */
-	tmp = (u64)hpet_period << HPET_SHIFT;
-	do_div(tmp, FSEC_PER_NSEC);
-	clocksource_hpet.mult = (u32)tmp;
-
-	return clocksource_register(&clocksource_hpet);
-}
-
-module_init(init_hpet_clocksource);
diff --git a/arch/x86_64/kernel/tsc.c b/arch/x86_64/kernel/tsc.c
index 8958318..1a0edbb 100644
--- a/arch/x86_64/kernel/tsc.c
+++ b/arch/x86_64/kernel/tsc.c
@@ -210,7 +210,7 @@ void mark_tsc_unstable(void)
 }
 EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
-static int __init init_tsc_clocksource(void)
+void __init init_tsc_clocksource(void)
 {
 	if (!notsc) {
 		clocksource_tsc.mult = clocksource_khz2mult(cpu_khz,
@@ -218,9 +218,6 @@ static int __init init_tsc_clocksource(v
 		if (check_tsc_unstable())
 			clocksource_tsc.rating = 0;
 
-		return clocksource_register(&clocksource_tsc);
+		clocksource_register(&clocksource_tsc);
 	}
-	return 0;
 }
-
-module_init(init_tsc_clocksource);
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index ccaa6a3..d42060e 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -214,4 +214,7 @@ pm_good:
 	return clocksource_register(&clocksource_acpi_pm);
 }
 
-module_init(init_acpi_pm_clocksource);
+/* We use fs_initcall because we want the PCI fixups to have run
+ * but we still need to load before device_initcall
+ */
+fs_initcall(init_acpi_pm_clocksource);
diff --git a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
index 4f3925c..1bde303 100644
--- a/drivers/clocksource/cyclone.c
+++ b/drivers/clocksource/cyclone.c
@@ -116,4 +116,4 @@ static int __init init_cyclone_clocksour
 	return clocksource_register(&clocksource_cyclone);
 }
 
-module_init(init_cyclone_clocksource);
+arch_initcall(init_cyclone_clocksource);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 193a079..5b0e46b 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -55,16 +55,18 @@ static DEFINE_SPINLOCK(clocksource_lock)
 static char override_name[32];
 static int finished_booting;
 
-/* clocksource_done_booting - Called near the end of bootup
+/* clocksource_done_booting - Called near the end of core bootup
  *
- * Hack to avoid lots of clocksource churn at boot time
+ * Hack to avoid lots of clocksource churn at boot time.
+ * We use fs_initcall because we want this to start before
+ * device_initcall but after subsys_initcall.
  */
 static int __init clocksource_done_booting(void)
 {
 	finished_booting = 1;
 	return 0;
 }
-late_initcall(clocksource_done_booting);
+fs_initcall(clocksource_done_booting);
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 static LIST_HEAD(watchdog_list);


