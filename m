Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbYJUBo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbYJUBo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYJUBnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:43:41 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:40102 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbYJUBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:43:39 -0400
Subject: [PATCH 3/3] x86: Improve TSC as a clocksource for VMware.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 20 Oct 2008 18:36:14 -0700
Message-Id: <1224552974.2640.95.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Improve TSC as a clocksource for VMware.

From: Alok N Kataria <akataria@vmware.com>

TSC improvements :
This patch defines a new flag tsc_reliable, this is set on systems which
are known to have a reliable TSC.

This flag is used for
1. Skipping the TSC synchronization checks :
        The TSC synchronization loop which is run whenever a new cpu is
brought up is not actually needed on systems which are known to have a
reliable TSC. TSC between 2 cpus can be off by a marginal value on such
systems and thats okay for timekeeping, since we do check for tsc going
back in read_tsc.

2. Reset the must verify flag for TSC clocksource :
        This problem is actually related to a wrap-around problem with
acpi_pm timer. The acpi_pm counter is just 24bits and this can overflow
in 4 seconds. With the NO_HZ kernels in virtualized environment, there
can be situations when the guest is descheduled for longer duration, as
a result we may miss the wrap of the acpi counter. When TSC is used as a
clocksource and acpi_pm timer is being used as the watchdog clocksource
this error in acpi_pm results in TSC being marked as unstable, and
essentially results in time dropping in chunks of 4 seconds whenever this
wrap is missed. Since the virtualized TSC is reliable on VMware, we should
always use the TSCs clocksource on VMware, so we skip the verfication at
runtime.

3. tsc_stable
	On AMD opterons tsc is usually marked as unstable, as it is not
synchronized on that hardware. In a virtualized environment even if you
are running on such a hardware the hypervisor takes care of providing a
stable TSC to the guest. So add a check for tsc_reliable in
unsynchornized_tsc routine.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
---

 arch/x86/kernel/tsc.c      |   26 +++++++++++++++++++++++++-
 arch/x86/kernel/tsc_sync.c |    8 +++++++-
 include/asm-x86/tsc.h      |    1 +
 3 files changed, 33 insertions(+), 2 deletions(-)


diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 355252f..d332252 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -33,6 +33,13 @@ static int tsc_unstable;
 static int tsc_disabled = -1;
 
 /*
+ * On some systems, TSC is known to be reliable. On such systems, we
+ * don't need the kernel checking for TSC being stable at runtime,
+ * since there maybe some false positives.
+ */
+static int tsc_reliable;
+
+/*
  * Scheduler clock - returns current time in nanosec units.
  */
 u64 native_sched_clock(void)
@@ -778,7 +785,7 @@ __cpuinit int unsynchronized_tsc(void)
 		return 1;
 #endif
 
-	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) || is_tsc_reliable())
 		return 0;
 	/*
 	 * Intel systems are normally all synchronized.
@@ -793,10 +800,26 @@ __cpuinit int unsynchronized_tsc(void)
 	return tsc_unstable;
 }
 
+static __cpuinit void check_system_tsc_reliable(void)
+{
+	if (vmware_platform())
+		tsc_reliable = 1;
+}
+
+int is_tsc_reliable(void)
+{
+	return tsc_reliable;
+}
+
 static void __init init_tsc_clocksource(void)
 {
 	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
 			clocksource_tsc.shift);
+
+	/* TSC is known to be reliable no need to verify it. */
+	if (is_tsc_reliable())
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+
 	/* lower the rating if we already know its unstable: */
 	if (check_tsc_unstable()) {
 		clocksource_tsc.rating = 0;
@@ -853,6 +876,7 @@ void __init tsc_init(void)
 	use_tsc_delay();
 	/* Check and install the TSC clocksource */
 	dmi_check_system(bad_tsc_dmi_table);
+	check_system_tsc_reliable();
 
 	if (unsynchronized_tsc())
 		mark_tsc_unstable("TSCs unsynchronized");
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9ffb01c..13f4fec 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -108,6 +108,12 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	if (unsynchronized_tsc())
 		return;
 
+	if (is_tsc_reliable()) {
+		printk(KERN_INFO "TSC synchornization check skipped: TSC "
+				"is known to be reliable on this system\n");
+		return;
+	}
+
 	printk(KERN_INFO "checking TSC synchronization [CPU#%d -> CPU#%d]:",
 			  smp_processor_id(), cpu);
 
@@ -161,7 +167,7 @@ void __cpuinit check_tsc_sync_target(void)
 {
 	int cpus = 2;
 
-	if (unsynchronized_tsc())
+	if (unsynchronized_tsc() || is_tsc_reliable())
 		return;
 
 	/*
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index ad0f5c4..1d0ceaa 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -49,6 +49,7 @@ extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 int check_tsc_unstable(void);
+int is_tsc_reliable(void);
 
 /*
  * Boot-time check whether the TSCs are synchronized across


