Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYGOVhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYGOVhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYGOVg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:36:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYGOVgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:36:55 -0400
Date: Tue, 15 Jul 2008 17:36:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 6/7] dynamic debug v2 - convert cpufreq
Message-ID: <20080715213613.GG23331@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-convert cpufreq

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    7 ++-
 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c    |    6 ++-
 arch/x86/kernel/cpu/cpufreq/gx-suspmod.c         |    7 ++-
 arch/x86/kernel/cpu/cpufreq/longhaul.c           |    7 ++-
 arch/x86/kernel/cpu/cpufreq/longrun.c            |    6 ++-
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    7 +++
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c        |    6 ++-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    2 -
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h        |    5 ++
 arch/x86/kernel/cpu/cpufreq/sc520_freq.c         |    6 ++-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    6 ++-
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    8 ++--
 arch/x86/kernel/cpu/cpufreq/speedstep-smi.c      |    6 ++-
 drivers/cpufreq/cpufreq.c                        |   45 +++++++++++-----------
 drivers/cpufreq/cpufreq_performance.c            |    8 ++--
 drivers/cpufreq/cpufreq_powersave.c              |    7 ++-
 drivers/cpufreq/cpufreq_userspace.c              |    6 ++-
 drivers/cpufreq/freq_table.c                     |    7 ++-
 include/linux/cpufreq.h                          |   11 ++++-
 lib/dynamic_printk.c                             |    5 +-
 20 files changed, 116 insertions(+), 52 deletions(-)


diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index e2d870d..b879ddd 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -33,6 +33,7 @@
 #include <linux/cpufreq.h>
 #include <linux/compiler.h>
 #include <linux/dmi.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <linux/acpi.h>
 #include <acpi/processor.h>
@@ -44,7 +45,10 @@
 #include <asm/delay.h>
 #include <asm/uaccess.h>
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "acpi-cpufreq", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "acpi-cpufreq", msg); \
+	} while (0)
 
 MODULE_AUTHOR("Paul Diefenbaugh, Dominik Brodowski");
 MODULE_DESCRIPTION("ACPI Processor P-States Driver");
@@ -780,7 +784,6 @@ static int __init acpi_cpufreq_init(void)
 static void __exit acpi_cpufreq_exit(void)
 {
 	dprintk("acpi_cpufreq_exit\n");
-
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
 	free_percpu(acpi_perf_data);
diff --git a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
index f03e915..3e3a39c 100644
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -14,6 +14,7 @@
 #include <linux/cpufreq.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #define NFORCE2_XTAL 25
 #define NFORCE2_BOOTFSB 0x48
@@ -55,7 +56,10 @@ MODULE_PARM_DESC(fid, "CPU multiplier to use (11.5 = 115)");
 MODULE_PARM_DESC(min_fsb,
                  "Minimum FSB to use, if not defined: current FSB - 50");
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "cpufreq-nforce2", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "cpufreq-nforce2", msg); \
+	} while (0)
 
 /**
  * nforce2_calc_fsb - calculate FSB
diff --git a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
index 9d9eae8..e144095 100644
--- a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
@@ -79,6 +79,7 @@
 #include <linux/smp.h>
 #include <linux/cpufreq.h>
 #include <linux/pci.h>
+#include <linux/dynamic_debug_cpufreq.h>
 #include <asm/processor-cyrix.h>
 #include <asm/errno.h>
 
@@ -139,8 +140,10 @@ module_param (max_duration, int, 0444);
  */
 #define POLICY_MIN_DIV 20
 
-
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "gx-suspmod", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "gx-suspmod", msg); \
+	} while (0)
 
 /**
  * we can detect a core multipiler from dir0_lsb
diff --git a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
index 06fcce5..1a28f1f 100644
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/delay.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <asm/msr.h>
 #include <asm/timex.h>
@@ -78,8 +79,10 @@ static int scale_voltage;
 static int disable_acpi_c3;
 static int revid_errata;
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "longhaul", msg)
-
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "longhaul", msg); \
+	{ while (0)
 
 /* Clock ratios multiplied by 10 */
 static int clock_ratio[32];
diff --git a/arch/x86/kernel/cpu/cpufreq/longrun.c b/arch/x86/kernel/cpu/cpufreq/longrun.c
index af4a867..0f22a89 100644
--- a/arch/x86/kernel/cpu/cpufreq/longrun.c
+++ b/arch/x86/kernel/cpu/cpufreq/longrun.c
@@ -11,12 +11,16 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/cpufreq.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/timex.h>
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "longrun", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "longrun", msg); \
+	} while (0)
 
 static struct cpufreq_driver	longrun_driver;
 
diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 199e4e0..107e1b6 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -27,6 +27,7 @@
 #include <linux/cpufreq.h>
 #include <linux/slab.h>
 #include <linux/cpumask.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -35,7 +36,11 @@
 #include "speedstep-lib.h"
 
 #define PFX	"p4-clockmod: "
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "p4-clockmod", msg)
+
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "p4-clockmod", msg); \
+	} while (0)
 
 /*
  * Duty Cycle (3bits), note DC_DISABLE is not specified in
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
index 0a61159..d9cdf4a 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/dmi.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <asm/msr.h>
 #include <asm/timer.h>
@@ -101,7 +102,10 @@ static unsigned int fsb;
 static unsigned int latency;
 static char have_a0;
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "powernow-k7", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "powernow-k7", msg); \
+	} while (0)
 
 static int check_fsb(unsigned int fsbspeed)
 {
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 46d4034..f0bb7b0 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/cpumask.h>
 #include <linux/sched.h>	/* for current / set_cpus_allowed() */
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <asm/msr.h>
 #include <asm/io.h>
@@ -1306,7 +1307,6 @@ static int __cpuinit powernowk8_init(void)
 static void __exit powernowk8_exit(void)
 {
 	dprintk("exit\n");
-
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 }
 
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index ab48cfe..0683a2d 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -199,7 +199,10 @@ struct pst_s {
 	u8 vid;
 };
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "powernow-k8", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "powernow-k8", msg); \
+	} while (0)
 
 static int core_voltage_pre_transition(struct powernow_k8_data *data, u32 reqvid);
 static int core_voltage_post_transition(struct powernow_k8_data *data, u32 reqvid);
diff --git a/arch/x86/kernel/cpu/cpufreq/sc520_freq.c b/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
index 42da9bd..b5bc7fb 100644
--- a/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
+++ b/arch/x86/kernel/cpu/cpufreq/sc520_freq.c
@@ -19,6 +19,7 @@
 
 #include <linux/delay.h>
 #include <linux/cpufreq.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <asm/msr.h>
 #include <asm/timex.h>
@@ -29,7 +30,10 @@
 
 static __u8 __iomem *cpuctl;
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "sc520_freq", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "sc520_freq", msg); \
+	} while (0)
 
 static struct cpufreq_frequency_table sc520_freq_table[] = {
 	{0x01,	100000},
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index 908dd34..cb50f37 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>	/* current */
 #include <linux/delay.h>
 #include <linux/compiler.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <asm/msr.h>
 #include <asm/processor.h>
@@ -28,7 +29,10 @@
 #define PFX		"speedstep-centrino: "
 #define MAINTAINER	"cpufreq@lists.linux.org.uk"
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-centrino", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-centrino", msg); \
+	} while (0)
 
 #define INTEL_MSR_RANGE	(0xffff)
 
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 1b50244..6aee9a5 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include "speedstep-lib.h"
 
@@ -53,9 +54,10 @@ static struct cpufreq_frequency_table speedstep_freqs[] = {
 	{0,			CPUFREQ_TABLE_END},
 };
 
-
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-ich", msg)
-
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-ich", msg); \
+	} while (0)
 
 /**
  * speedstep_find_register - read the PMBASE address
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
index 8a85c93..4819908 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -19,6 +19,7 @@
 #include <linux/cpufreq.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/dynamic_debug_cpufreq.h>
 #include <asm/ist.h>
 #include <asm/io.h>
 
@@ -56,7 +57,10 @@ static struct cpufreq_frequency_table speedstep_freqs[] = {
  * of DMA activity going on? */
 #define SMI_TRIES 5
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-smi", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-smi", msg); \
+	} while (0)
 
 /**
  * speedstep_smi_ownership
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 35a26a3..b545f1e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -28,9 +28,12 @@
 #include <linux/cpu.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_CORE, \
-						"cpufreq-core", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_CORE, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_CORE, "cpufreq-core", msg); \
+	} while (0)
 
 /**
  * The "cpufreq driver" - the arch- or hardware-dependent low
@@ -176,13 +179,13 @@ void cpufreq_cpu_put(struct cpufreq_policy *data)
 EXPORT_SYMBOL_GPL(cpufreq_cpu_put);
 
 
+/* what part(s) of the CPUfreq subsystem are debugged? */
+unsigned int cpufreq_debug;
+EXPORT_SYMBOL_GPL(cpufreq_debug);
 /*********************************************************************
  *                     UNIFIED DEBUG HELPERS                         *
  *********************************************************************/
-#ifdef CONFIG_CPU_FREQ_DEBUG
-
-/* what part(s) of the CPUfreq subsystem are debugged? */
-static unsigned int debug;
+#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
 
 /* is the debug output ratelimit'ed using printk_ratelimit? User can
  * set or modify this value.
@@ -224,31 +227,29 @@ void cpufreq_debug_printk(unsigned int type, const char *prefix,
 	unsigned long flags;
 
 	WARN_ON(!prefix);
-	if (type & debug) {
-		spin_lock_irqsave(&disable_ratelimit_lock, flags);
-		if (!disable_ratelimit && debug_ratelimit
-					&& !printk_ratelimit()) {
-			spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
-			return;
-		}
+	spin_lock_irqsave(&disable_ratelimit_lock, flags);
+	if (!disable_ratelimit && debug_ratelimit
+				&& !printk_ratelimit()) {
 		spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
 
-		len = snprintf(s, 256, KERN_DEBUG "%s: ", prefix);
+	len = snprintf(s, 256, KERN_DEBUG "%s: ", prefix);
 
-		va_start(args, fmt);
-		len += vsnprintf(&s[len], (256 - len), fmt, args);
-		va_end(args);
+	va_start(args, fmt);
+	len += vsnprintf(&s[len], (256 - len), fmt, args);
+	va_end(args);
 
-		printk(s);
+	printk(s);
 
-		WARN_ON(len < 5);
-	}
+	WARN_ON(len < 5);
 }
 EXPORT_SYMBOL(cpufreq_debug_printk);
 
 
-module_param(debug, uint, 0644);
-MODULE_PARM_DESC(debug, "CPUfreq debugging: add 1 to debug core,"
+module_param(cpufreq_debug, uint, 0644);
+MODULE_PARM_DESC(cpufreq_debug, "CPUfreq debugging: add 1 to debug core,"
 			" 2 to debug drivers, and 4 to debug governors.");
 
 module_param(debug_ratelimit, uint, 0644);
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index e8e1451..985ba2b 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -14,10 +14,12 @@
 #include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
-#define dprintk(msg...) \
-	cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "performance", msg)
-
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_GOVERNOR, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "performance", msg); \
+	} while (0)
 
 static int cpufreq_governor_performance(struct cpufreq_policy *policy,
 					unsigned int event)
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 13fe06b..727f8c0 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -14,9 +14,12 @@
 #include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/init.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
-#define dprintk(msg...) \
-	cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "powersave", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_GOVERNOR, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "powersave", msg); \
+	} while (0)
 
 static int cpufreq_governor_powersave(struct cpufreq_policy *policy,
 					unsigned int event)
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index cb2ac01..2b77964 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -23,6 +23,7 @@
 #include <linux/fs.h>
 #include <linux/sysfs.h>
 #include <linux/mutex.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
 #include <asm/uaccess.h>
 
@@ -39,7 +40,10 @@ static unsigned int	cpu_is_managed[NR_CPUS];
 static DEFINE_MUTEX	(userspace_mutex);
 static int cpus_using_userspace_governor;
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "userspace", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_GOVERNOR, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "userspace", msg); \
+	} while (0)
 
 /* keep track of frequency transitions */
 static int
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index ae6cd60..2f241ce 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -8,9 +8,12 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
+#include <linux/dynamic_debug_cpufreq.h>
 
-#define dprintk(msg...) \
-	cpufreq_debug_printk(CPUFREQ_DEBUG_CORE, "freq-table", msg)
+#define dprintk(msg...) do { \
+	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_CORE, cpufreq_debug)) \
+		cpufreq_debug_printk(CPUFREQ_DEBUG_CORE, "freq-table", msg); \
+	} while (0)
 
 /*********************************************************************
  *                     FREQUENCY TABLE HELPERS                       *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ddd8652..b056dfd 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -366,11 +366,18 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 #define CPUFREQ_DEBUG_DRIVER	2
 #define CPUFREQ_DEBUG_GOVERNOR	4
 
-#ifdef CONFIG_CPU_FREQ_DEBUG
+#define CPUFREQ_DEBUG_FLAGS_NUM 3
+#define CPUFREQ_DEBUG_FLAGS "CPUFREQ_DEBUG_CORE,CPUFREQ_DEBUG_DRIVER,CPUFREQ_DEBUG_GOVERNOR"
+
+extern unsigned int cpufreq_debug;
+#if defined(CONFIG_CPU_FREQ_DEBUG) && !defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define DEBUG 1
+#endif
+
+#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
 
 extern void cpufreq_debug_printk(unsigned int type, const char *prefix, 
 				 const char *fmt, ...);
-
 #else
 
 #define cpufreq_debug_printk(msg...) do { } while(0)
diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
index 326355d..1bc070f 100644
--- a/lib/dynamic_printk.c
+++ b/lib/dynamic_printk.c
@@ -209,7 +209,8 @@ int register_debug_module(char *mod_name, int type, char *share_name,
 			num_enabled++;
 		}
 	}
-	if (strcmp(mod_name, share_name)) {
+	if (strcmp(mod_name, share_name) && (!elem->parent)) {
+		printk("register_debug_module: %s :%s\n", mod_name, share_name);
 		parent = find_debug_module(share_name);
 		if (!parent) {
 			__add_debug_module(share_name);
@@ -227,7 +228,7 @@ int register_debug_module(char *mod_name, int type, char *share_name,
 		list_add_rcu(&elem->shared_list, &parent->shared_list);
 	} else
 		elem->type = type;
-	if (num_flags > 0) {
+	if (num_flags > 0 && (!elem->flags)) {
 		if ((elem->type_sharing == SHARING_MEMBER) && elem->parent)
 			elem = elem->parent;
 		elem->flags = kzalloc(sizeof(struct flags_descriptor),
