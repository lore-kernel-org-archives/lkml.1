Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYJYAXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYJYAXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYJYAWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:22:19 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43535 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757741AbYJYAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:22:03 -0400
Subject: [PATCH 4/4] Skip verification by the watchdog for TSC clocksource.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, Jeff Hansen <x@jeffhansen.com>,
       Chris Snook <csnook@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 24 Oct 2008 17:22:01 -0700
Message-Id: <1224894121.28224.75.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[X86] Skip verification by the watchdog for TSC clocksource.

From: Alok N Kataria <akataria@vmware.com>

This is achieved by resetting the CLOCKSOURCE_MUST_VERIFY flag.

We add a tsc=reliable commandline option to enable this.
This enables legacy hardware without HPET, LAPIC, or ACPI timers
to enter high-resolution timer mode.

Along with that have extended this to be used in virtualization environement
too. Now we also set this flag if the X86_FEATURE_TSC_RELIABLE bit is set.

This is important since there is a wrap-around problem with the acpi_pm timer.
The acpi_pm counter is just 24bits and this can overflow in ~4 seconds. With
the NO_HZ kernels in virtualized environment, there can be situations when
the guest is descheduled for longer duration, as a result we may miss the wrap
of the acpi counter. When TSC is used as a clocksource and acpi_pm timer is
being used as the watchdog clocksource this error in acpi_pm results in TSC
being marked as unstable, and essentially results in time dropping in chunks
of 4 seconds whenever this wrap is missed. Since the virtualized TSC is
reliable on VMware, we should always use the TSCs clocksource on VMware, so
we skip the verfication at runtime, by checking for the feature bit.

Since we reset the flag for mgeode systems too, i have combined
the mgeode case with the feature bit check.

Signed-off-by: Jeff Hansen <jhansen@cardaccess-inc.com>
Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Hecht <dhecht@vmware.com>
Cc: Chris Snook <csnook@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 arch/x86/kernel/tsc.c               |   33 +++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 12 deletions(-)


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d2c115b..e42b9d9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2278,6 +2278,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format:
 			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
 
+	tsc=		Disable clocksource-must-verify flag for TSC.
+			Format: <string>
+			[x86] reliable: mark tsc clocksource as reliable, this
+			disables clocksource verification at runtime.
+			Used to enable high-resolution timer mode on older
+			hardware, and in virtualized environment.
+
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
 			Format:
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 189741f..10413b4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -32,6 +32,7 @@ static int tsc_unstable;
    erroneous rdtsc usage on !cpu_has_tsc processors */
 static int tsc_disabled = -1;
 
+static int tsc_clocksource_reliable;
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
@@ -99,6 +100,15 @@ int __init notsc_setup(char *str)
 
 __setup("notsc", notsc_setup);
 
+static int __init tsc_setup(char *str)
+{
+	if (!strcmp(str, "reliable"))
+		tsc_clocksource_reliable = 1;
+	return 1;
+}
+
+__setup("tsc=", tsc_setup);
+
 #define MAX_RETRIES     5
 #define SMI_TRESHOLD    50000
 
@@ -738,24 +748,21 @@ static struct dmi_system_id __initdata bad_tsc_dmi_table[] = {
 	{}
 };
 
-/*
- * Geode_LX - the OLPC CPU has a possibly a very reliable TSC
- */
+static void __init check_system_tsc_reliable(void)
+{
 #ifdef CONFIG_MGEODE_LX
-/* RTSC counts during suspend */
+	/* RTSC counts during suspend */
 #define RTSC_SUSP 0x100
-
-static void __init check_geode_tsc_reliable(void)
-{
 	unsigned long res_low, res_high;
 
 	rdmsr_safe(MSR_GEODE_BUSCONT_CONF0, &res_low, &res_high);
+	/* Geode_LX - the OLPC CPU has a possibly a very reliable TSC */
 	if (res_low & RTSC_SUSP)
-		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
-}
-#else
-static inline void check_geode_tsc_reliable(void) { }
+		tsc_clocksource_reliable = 1;
 #endif
+	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
+		tsc_clocksource_reliable = 1;
+}
 
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
@@ -790,6 +797,8 @@ static void __init init_tsc_clocksource(void)
 {
 	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
 			clocksource_tsc.shift);
+	if (tsc_clocksource_reliable)
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
 	/* lower the rating if we already know its unstable: */
 	if (check_tsc_unstable()) {
 		clocksource_tsc.rating = 0;
@@ -850,7 +859,7 @@ void __init tsc_init(void)
 	if (unsynchronized_tsc())
 		mark_tsc_unstable("TSCs unsynchronized");
 
-	check_geode_tsc_reliable();
+	check_system_tsc_reliable();
 	init_tsc_clocksource();
 }
 


