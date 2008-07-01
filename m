Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbYGASou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbYGASou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYGASnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:43:39 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49504 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757412AbYGASnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:43:37 -0400
Subject: [PATCH 05/05] x86: Rename paravirtualized TSC functions
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 01 Jul 2008 11:43:36 -0700
Message-Id: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[VMware, Inc. is providing the following patch to you under the terms of the
GPL version 2 and no later version. This patch is provided as is, with no
warranties or support. VMware disclaims all liability in connection with
the use/inability to use this patch. Any use of the attached is considered
acceptance of the above.]

From:  Alok N Kataria <akataria@vmware.com>

Rename the paravirtualized calculate_cpu_khz to calibrate_tsc.
In all cases, we actually calibrate_tsc and use that as the cpu_khz value.


Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Hecht <dhecht@vmware.com>

---

 arch/x86/kernel/paravirt.c    |    2 +-
 arch/x86/kernel/tsc.c         |   18 +++++++-----------
 arch/x86/kernel/vmi_32.c      |    2 +-
 arch/x86/kernel/vmiclock_32.c |    4 ++--
 arch/x86/lguest/boot.c        |    4 ++--
 arch/x86/xen/enlighten.c      |    2 +-
 arch/x86/xen/time.c           |    4 ++--
 arch/x86/xen/xen-ops.h        |    2 +-
 include/asm-x86/paravirt.h    |    4 ++--
 include/asm-x86/timer.h       |    4 ++--
 include/asm-x86/vmi_time.h    |    2 +-
 11 files changed, 22 insertions(+), 26 deletions(-)


diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 7d37b7a..abe30e0 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -282,7 +282,7 @@ struct pv_time_ops pv_time_ops = {
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
 	.sched_clock = native_sched_clock,
-	.get_cpu_khz = native_calculate_cpu_khz,
+	.get_tsc_khz = native_calibrate_tsc,
 };
 
 struct pv_irq_ops pv_irq_ops = {
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 94c16bd..3c36f92 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -123,9 +123,9 @@ static u64 __init tsc_read_refs(u64 *pm, u64 *hpet)
 }
 
 /**
- * tsc_calibrate - calibrate the tsc on boot
+ * native_calibrate_tsc - calibrate the tsc on boot
  */
-static unsigned int __init tsc_calibrate(void)
+unsigned long native_calibrate_tsc(void)
 {
 	unsigned long flags;
 	u64 tsc1, tsc2, tr1, tr2, delta, pm1, pm2, hpet1, hpet2;
@@ -195,10 +195,6 @@ out:
 	return tsc_khz_val;
 }
 
-unsigned long native_calculate_cpu_khz(void)
-{
-	return tsc_calibrate();
-}
 
 #ifdef CONFIG_X86_32
 /* Only called from the Powernow K7 cpu freq driver */
@@ -208,8 +204,8 @@ int recalibrate_cpu_khz(void)
 	unsigned long cpu_khz_old = cpu_khz;
 
 	if (cpu_has_tsc) {
-		cpu_khz = calculate_cpu_khz();
-		tsc_khz = cpu_khz;
+		tsc_khz = calibrate_tsc();
+		cpu_khz = tsc_khz;
 		cpu_data(0).loops_per_jiffy =
 			cpufreq_scale(cpu_data(0).loops_per_jiffy,
 					cpu_khz_old, cpu_khz);
@@ -487,10 +483,10 @@ void __init tsc_init(void)
 	if (!cpu_has_tsc)
 		return;
 
-	cpu_khz = calculate_cpu_khz();
-	tsc_khz = cpu_khz;
+	tsc_khz = calibrate_tsc();
+	cpu_khz = tsc_khz;
 
-	if (!cpu_khz) {
+	if (!tsc_khz) {
 		mark_tsc_unstable("could not calculate TSC khz");
 		return;
 	}
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 01d687d..b11e7ac 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -934,7 +934,7 @@ static inline int __init activate_vmi(void)
 		pv_apic_ops.setup_secondary_clock = vmi_time_ap_init;
 #endif
 		pv_time_ops.sched_clock = vmi_sched_clock;
- 		pv_time_ops.get_cpu_khz = vmi_cpu_khz;
+		pv_time_ops.get_tsc_khz = vmi_tsc_khz;
 
 		/* We have true wallclock functions; disable CMOS clock sync */
 		no_sync_cmos_clock = 1;
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index ba7d19e..6953859 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -69,8 +69,8 @@ unsigned long long vmi_sched_clock(void)
 	return cycles_2_ns(vmi_timer_ops.get_cycle_counter(VMI_CYCLES_AVAILABLE));
 }
 
-/* paravirt_ops.get_cpu_khz = vmi_cpu_khz */
-unsigned long vmi_cpu_khz(void)
+/* paravirt_ops.get_tsc_khz = vmi_tsc_khz */
+unsigned long vmi_tsc_khz(void)
 {
 	unsigned long long khz;
 	khz = vmi_timer_ops.get_cycle_frequency();
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 2248848..e369cae 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -607,7 +607,7 @@ static unsigned long lguest_get_wallclock(void)
  * what speed it runs at, or 0 if it's unusable as a reliable clock source.
  * This matches what we want here: if we return 0 from this function, the x86
  * TSC clock will give up and not register itself. */
-static unsigned long lguest_cpu_khz(void)
+static unsigned long lguest_tsc_khz(void)
 {
 	return lguest_data.tsc_khz;
 }
@@ -999,7 +999,7 @@ __init void lguest_init(void)
 	/* time operations */
 	pv_time_ops.get_wallclock = lguest_get_wallclock;
 	pv_time_ops.time_init = lguest_time_init;
-	pv_time_ops.get_cpu_khz = lguest_cpu_khz;
+	pv_time_ops.get_tsc_khz = lguest_tsc_khz;
 
 	/* Now is a good time to look at the implementations of these functions
 	 * before returning to the rest of lguest_init(). */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4736d0e..fcc0f38 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1061,7 +1061,7 @@ static const struct pv_time_ops xen_time_ops __initdata = {
 
 	.set_wallclock = xen_set_wallclock,
 	.get_wallclock = xen_get_wallclock,
-	.get_cpu_khz = xen_cpu_khz,
+	.get_tsc_khz = xen_tsc_khz,
 	.sched_clock = xen_sched_clock,
 };
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 64f0038..685b774 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -197,8 +197,8 @@ unsigned long long xen_sched_clock(void)
 }
 
 
-/* Get the CPU speed from Xen */
-unsigned long xen_cpu_khz(void)
+/* Get the TSC speed from Xen */
+unsigned long xen_tsc_khz(void)
 {
 	u64 xen_khz = 1000000ULL << 32;
 	const struct pvclock_vcpu_time_info *info =
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 9a05559..d852ddb 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -32,7 +32,7 @@ void __init xen_build_dynamic_phys_to_machine(void);
 
 void xen_setup_timer(int cpu);
 void xen_setup_cpu_clockevents(void);
-unsigned long xen_cpu_khz(void);
+unsigned long xen_tsc_khz(void);
 void __init xen_time_init(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 60601d8..1d87c0d 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -84,7 +84,7 @@ struct pv_time_ops {
 	int (*set_wallclock)(unsigned long);
 
 	unsigned long long (*sched_clock)(void);
-	unsigned long (*get_cpu_khz)(void);
+	unsigned long (*get_tsc_khz)(void);
 };
 
 struct pv_cpu_ops {
@@ -734,7 +734,7 @@ static inline unsigned long long paravirt_sched_clock(void)
 {
 	return PVOP_CALL0(unsigned long long, pv_time_ops.sched_clock);
 }
-#define calculate_cpu_khz() (pv_time_ops.get_cpu_khz())
+#define calibrate_tsc() (pv_time_ops.get_tsc_khz())
 
 static inline unsigned long long paravirt_read_pmc(int counter)
 {
diff --git a/include/asm-x86/timer.h b/include/asm-x86/timer.h
index 4f6fcb0..fb2a4dd 100644
--- a/include/asm-x86/timer.h
+++ b/include/asm-x86/timer.h
@@ -7,14 +7,14 @@
 #define TICK_SIZE (tick_nsec / 1000)
 
 unsigned long long native_sched_clock(void);
-unsigned long native_calculate_cpu_khz(void);
+unsigned long native_calibrate_tsc(void);
 
 extern int timer_ack;
 extern int no_timer_check;
 extern int recalibrate_cpu_khz(void);
 
 #ifndef CONFIG_PARAVIRT
-#define calculate_cpu_khz() native_calculate_cpu_khz()
+#define calibrate_tsc() native_calibrate_tsc()
 #endif
 
 /* Accelerators for sched_clock()
diff --git a/include/asm-x86/vmi_time.h b/include/asm-x86/vmi_time.h
index 4781881..c3118c3 100644
--- a/include/asm-x86/vmi_time.h
+++ b/include/asm-x86/vmi_time.h
@@ -50,7 +50,7 @@ extern void __init vmi_time_init(void);
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
 extern unsigned long long vmi_sched_clock(void);
-extern unsigned long vmi_cpu_khz(void);
+extern unsigned long vmi_tsc_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __devinit vmi_time_bsp_init(void);


