Return-Path: <linux-kernel-owner+w=401wt.eu-S2992735AbXCBXYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992735AbXCBXYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992736AbXCBXYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:24:11 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45914 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992735AbXCBXYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:24:09 -0500
Subject: [PATCH -mm][Take 2] clocksource init adjustments (fix bug #7426)
From: john stultz <johnstul@us.ibm.com>
To: David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, andreas.friedrich@fujitsu-siemens.com,
       tglx@linutronix.de, dwalker@mvista.com
In-Reply-To: <20070302.123202.11628478.davem@davemloft.net>
References: <1172189582.5422.26.camel@localhost.localdomain>
	 <20070302021827.7edc1a23.akpm@linux-foundation.org>
	 <1172865491.5449.13.camel@localhost.localdomain>
	 <20070302.123202.11628478.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:24:00 -0800
Message-Id: <1172877840.5449.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 12:32 -0800, David Miller wrote:
> From: john stultz <johnstul@us.ibm.com>
> Date: Fri, 02 Mar 2007 11:58:11 -0800
> 
> > Oh! Sorry! Yea, looking at it more the ioremap isn't actually necessary,
> > as we can use hpet_readl() instead of re-calculating the hpet base
> > address pointer.
> > 
> > I'll fix this up (and find an HPET enabled x86_64 box to test it on) and
> > get a patch to you shortly.
> 
> Not to pressure you John but I'd really like to see this go
> in soon, it does fix real bugs such as the Radeon FB issue
> I pointed out the other week.

Here's my second try at this. This time I caught three bugs from the
last patch (all in x86_64):
1) Calling ioremap too early in the HPET code (which is unnecessary)
2) hpet_period local variable aliasing
3) forgot to re-add call to init_tsc_clocksource()

I boot tested on two x86_64 boxes (one ACPI PM and the other HPET).
However it probably should still go through a bit of testing in -mm to
make sure all the quirks are shaken out.

thanks
-john


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

Signed-off-by: John Stultz <johnstul@us.ibm.com>

 arch/i386/kernel/hpet.c       |   80 ++++++++++++++----------------
 arch/i386/kernel/i8253.c      |    2 
 arch/i386/kernel/setup.c      |    1 
 arch/i386/kernel/time.c       |    1 
 arch/i386/kernel/tsc.c        |   83 ++++++++++++++-----------------
 arch/x86_64/kernel/hpet.c     |  109 ++++++++++++++++--------------------------
 arch/x86_64/kernel/time.c     |    2 
 arch/x86_64/kernel/tsc.c      |    7 --
 drivers/clocksource/acpi_pm.c |    5 +
 drivers/clocksource/cyclone.c |    2 
 include/asm-x86_64/tsc.h      |    1 
 kernel/time/clocksource.c     |    8 +--
 12 files changed, 135 insertions(+), 166 deletions(-)

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
index 65a0edd..8cf0b8a 100644
--- a/arch/x86_64/kernel/hpet.c
+++ b/arch/x86_64/kernel/hpet.c
@@ -12,6 +12,12 @@ #include <asm/vsyscall.h>
 #include <asm/timex.h>
 #include <asm/hpet.h>
 
+#define HPET_MASK	0xFFFFFFFF
+#define HPET_SHIFT	22
+
+/* FSEC = 10^-15 NSEC = 10^-9 */
+#define FSEC_PER_NSEC	1000000
+
 int nohpet __initdata;
 
 unsigned long hpet_address;
@@ -106,9 +112,31 @@ int hpet_timer_stop_set_go(unsigned long
 	return 0;
 }
 
+static cycle_t read_hpet(void)
+{
+	return (cycle_t)hpet_readl(HPET_COUNTER);
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
 	unsigned int id;
+	u64 tmp;
 
 	if (!hpet_address)
 		return -1;
@@ -132,6 +160,22 @@ int hpet_arch_init(void)
 
 	hpet_use_timer = (id & HPET_ID_LEGSUP);
 
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
 
@@ -444,68 +488,3 @@ static int __init nohpet_setup(char *s)
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
diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index c9addcf..75d73a9 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -358,6 +358,8 @@ void __init time_init(void)
 	set_cyc2ns_scale(cpu_khz);
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
+	init_tsc_clocksource();
+
 	setup_irq(0, &irq0);
 }
 
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
diff --git a/include/asm-x86_64/tsc.h b/include/asm-x86_64/tsc.h
index 9a0a368..26c3e98 100644
--- a/include/asm-x86_64/tsc.h
+++ b/include/asm-x86_64/tsc.h
@@ -55,6 +55,7 @@ #endif
 extern void tsc_init(void);
 extern void mark_tsc_unstable(void);
 extern int unsynchronized_tsc(void);
+extern void init_tsc_clocksource(void);
 
 /*
  * Boot-time check whether the TSCs are synchronized across
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


