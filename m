Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXLKWXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXLKWXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbXLKWWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:22:25 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38511 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755003AbXLKWWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:22:21 -0500
Date: Tue, 11 Dec 2007 23:22:22 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] calibrate_delay() must be __cpuinit
Message-ID: <20071211222222.GO14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calibrate_delay() must be __cpuinit, not __{dev,}init.

I've verified that this is correct for all users.

While doing the latter, I also did the following cleanups:
- remove pointless additional prototypes in C files
- ensure all users #include <linux/delay.h>

This patch fixes the following section mismatches with CONFIG_HOTPLUG=n, 
CONFIG_HOTPLUG_CPU=y:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x1128d): Section mismatch: reference to .init.text.1:calibrate_delay (between 'check_cx686_slop' and 'set_cx86_reorder')
WARNING: vmlinux.o(.text+0x25102): Section mismatch: reference to .init.text.1:calibrate_delay (between 'smp_callin' and 'cpu_coregroup_map')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/alpha/kernel/smp.c                      |    4 ----
 arch/frv/kernel/setup.c                      |    2 +-
 arch/ia64/kernel/smpboot.c                   |    1 -
 arch/mips/kernel/smp.c                       |    1 -
 arch/powerpc/platforms/powermac/cpufreq_32.c |    2 --
 arch/sparc/kernel/sun4d_smp.c                |    4 +---
 arch/sparc/kernel/sun4m_smp.c                |    5 ++---
 arch/sparc64/kernel/smp.c                    |    2 --
 arch/x86/kernel/cpu/cyrix.c                  |    2 --
 arch/x86/kernel/smpboot_32.c                 |    2 --
 arch/x86/mach-voyager/voyager_smp.c          |    2 --
 arch/xtensa/kernel/time.c                    |    2 +-
 drivers/s390/sysinfo.c                       |    2 +-
 init/calibrate.c                             |    6 +++---
 14 files changed, 9 insertions(+), 28 deletions(-)

dd28ad1a68b203f4588b0f88ae29fd03646a8541 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index f4ab233..63c2073 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -77,10 +77,6 @@ int smp_num_probed;		/* Internal processor count */
 int smp_num_cpus = 1;		/* Number that came online.  */
 EXPORT_SYMBOL(smp_num_cpus);
 
-extern void calibrate_delay(void);
-
-
-
 /*
  * Called by both boot and secondaries to move global data into
  *  per-processor storage.
diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index a74c087..b38ae1f 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -708,7 +708,7 @@ static void __init reserve_dma_coherent(void)
 /*
  * calibrate the delay loop
  */
-void __init calibrate_delay(void)
+void __cpuinit calibrate_delay(void)
 {
 	loops_per_jiffy = __delay_loops_MHz * (1000000 / HZ);
 
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index f0fc4d8..5f6f47d 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -120,7 +120,6 @@ static volatile unsigned long go[SLAVE + 1];
 
 #define DEBUG_ITC_SYNC	0
 
-extern void __devinit calibrate_delay (void);
 extern void start_ap (void);
 extern unsigned long ia64_iobase;
 
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 63989e9..75fbefa 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -53,7 +53,6 @@ int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
 EXPORT_SYMBOL(phys_cpu_present_map);
 EXPORT_SYMBOL(cpu_online_map);
 
-extern void __init calibrate_delay(void);
 extern void cpu_idle(void);
 
 /*
diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/arch/powerpc/platforms/powermac/cpufreq_32.c
index c04abcc..792d3ce 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -113,8 +113,6 @@ static inline void debug_calc_bogomips(void)
 	 * result. We backup/restore the value to avoid affecting the
 	 * core cpufreq framework's own calculation.
 	 */
-	extern void calibrate_delay(void);
-
 	unsigned long save_lpj = loops_per_jiffy;
 	calibrate_delay();
 	loops_per_jiffy = save_lpj;
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 89a6de9..0def481 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -19,12 +19,12 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/profile.h>
+#include <linux/delay.h>
 
 #include <asm/ptrace.h>
 #include <asm/atomic.h>
 #include <asm/irq_regs.h>
 
-#include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -41,8 +41,6 @@
 
 extern ctxd_t *srmmu_ctx_table_phys;
 
-extern void calibrate_delay(void);
-
 static volatile int smp_processors_ready = 0;
 static int smp_highest_cpu;
 extern volatile unsigned long cpu_callin_map[NR_CPUS];
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 730eb57..0b94072 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -16,6 +16,8 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/profile.h>
+#include <linux/delay.h>
+
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/irq_regs.h>
@@ -23,7 +25,6 @@
 #include <asm/ptrace.h>
 #include <asm/atomic.h>
 
-#include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -39,8 +40,6 @@
 
 extern ctxd_t *srmmu_ctx_table_phys;
 
-extern void calibrate_delay(void);
-
 extern volatile unsigned long cpu_callin_map[NR_CPUS];
 extern unsigned char boot_cpu_id;
 
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index 894b506..a2a7e99 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -46,8 +46,6 @@
 #include <asm/ldc.h>
 #include <asm/hypervisor.h>
 
-extern void calibrate_delay(void);
-
 int sparc64_multi_core __read_mostly;
 
 cpumask_t cpu_possible_map __read_mostly = CPU_MASK_NONE;
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 88d66fb..6c6bf23 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -82,8 +82,6 @@ static char cyrix_model_mult2[] __cpuinitdata = "12233445";
  * FIXME: our newer udelay uses the tsc. We don't need to frob with SLOP
  */
 
-extern void calibrate_delay(void) __init;
-
 static void __cpuinit check_cx686_slop(struct cpuinfo_x86 *c)
 {
 	unsigned long flags;
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index ef0f34e..383b2d1 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -213,8 +213,6 @@ valid_k7:
 	;
 }
 
-extern void calibrate_delay(void);
-
 static atomic_t init_deasserted;
 
 static void __cpuinit smp_callin(void)
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 88124dd..a6a5e0d 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -455,8 +455,6 @@ static void __init
 start_secondary(void *unused)
 {
 	__u8 cpuid = hard_smp_processor_id();
-	/* external functions not defined in the headers */
-	extern void calibrate_delay(void);
 
 	cpu_init();
 
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 60d29fe..8df1e84 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -204,7 +204,7 @@ again:
 }
 
 #ifndef CONFIG_GENERIC_CALIBRATE_DELAY
-void __devinit calibrate_delay(void)
+void __cpuinit calibrate_delay(void)
 {
 	loops_per_jiffy = CCOUNT_PER_JIFFY;
 	printk("Calibrating delay loop (skipped)... "
diff --git a/drivers/s390/sysinfo.c b/drivers/s390/sysinfo.c
index 19343f9..291ff62 100644
--- a/drivers/s390/sysinfo.c
+++ b/drivers/s390/sysinfo.c
@@ -422,7 +422,7 @@ void s390_adjust_jiffies(void)
 /*
  * calibrate the delay loop
  */
-void __init calibrate_delay(void)
+void __cpuinit calibrate_delay(void)
 {
 	s390_adjust_jiffies();
 	/* Print the good old Bogomips line .. */
diff --git a/init/calibrate.c b/init/calibrate.c
index 2d3d73b..839ec7b 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -29,7 +29,7 @@ __setup("lpj=", lpj_setup);
 #define DELAY_CALIBRATION_TICKS			((HZ < 100) ? 1 : (HZ/100))
 #define MAX_DIRECT_CALIBRATION_RETRIES		5
 
-static unsigned long __devinit calibrate_delay_direct(void)
+static unsigned long __cpuinit calibrate_delay_direct(void)
 {
 	unsigned long pre_start, start, post_start;
 	unsigned long pre_end, end, post_end;
@@ -102,7 +102,7 @@ static unsigned long __devinit calibrate_delay_direct(void)
 	return 0;
 }
 #else
-static unsigned long __devinit calibrate_delay_direct(void) {return 0;}
+static unsigned long __cpuinit calibrate_delay_direct(void) {return 0;}
 #endif
 
 /*
@@ -112,7 +112,7 @@ static unsigned long __devinit calibrate_delay_direct(void) {return 0;}
  */
 #define LPS_PREC 8
 
-void __devinit calibrate_delay(void)
+void __cpuinit calibrate_delay(void)
 {
 	unsigned long ticks, loopbit;
 	int lps_precision = LPS_PREC;
