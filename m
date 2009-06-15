Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbZFOIWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbZFOIWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZFOIWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:22:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53185 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZFOIWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:22:23 -0400
Message-ID: <4A3604B7.9020007@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:22:15 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/16] x86, mce: unify mce.h
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 2 headers:
	arch/x86/include/asm/mce.h
	arch/x86/kernel/cpu/mcheck/mce.h
and in the latter small header:
	#include <asm/mce.h>

This patch move all contents in the latter header into the former,
and fix all files using the latter to include the former instead.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h                |   36 +++++++++++++++++++++++++-
 arch/x86/kernel/cpu/mcheck/k7.c           |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |    1 -
 arch/x86/kernel/cpu/mcheck/mce.h          |   38 -----------------------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |    3 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 -
 arch/x86/kernel/cpu/mcheck/non-fatal.c    |    3 +-
 arch/x86/kernel/cpu/mcheck/p4.c           |    3 +-
 arch/x86/kernel/cpu/mcheck/p5.c           |    3 +-
 arch/x86/kernel/cpu/mcheck/p6.c           |    3 +-
 arch/x86/kernel/cpu/mcheck/winchip.c      |    3 +-
 arch/x86/kernel/traps.c                   |    3 +-
 12 files changed, 42 insertions(+), 59 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce.h

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 540a466..aae6fe2 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -102,10 +102,42 @@ struct mce_log {
 
 #ifdef __KERNEL__
 
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <asm/atomic.h>
+
 extern int mce_disabled;
 
-#include <asm/atomic.h>
-#include <linux/percpu.h>
+#ifdef CONFIG_X86_OLD_MCE
+void amd_mcheck_init(struct cpuinfo_x86 *c);
+void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
+void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
+#endif
+
+#ifdef CONFIG_X86_ANCIENT_MCE
+void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
+void winchip_mcheck_init(struct cpuinfo_x86 *c);
+extern int mce_p5_enable;
+static inline int mce_p5_enabled(void) { return mce_p5_enable; }
+static inline void enable_p5_mce(void) { mce_p5_enable = 1; }
+#else
+static inline void intel_p5_mcheck_init(struct cpuinfo_x86 *c) {}
+static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
+static inline int mce_p5_enabled(void) { return 0; }
+static inline void enable_p5_mce(void) { }
+#endif
+
+/* Call the installed machine check handler for this CPU setup. */
+extern void (*machine_check_vector)(struct pt_regs *, long error_code);
+
+#ifdef CONFIG_X86_OLD_MCE
+extern int nr_mce_banks;
+extern void intel_set_thermal_handler(void);
+#else
+static inline void intel_set_thermal_handler(void) { }
+#endif
+
+void intel_init_thermal(struct cpuinfo_x86 *c);
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
diff --git a/arch/x86/kernel/cpu/mcheck/k7.c b/arch/x86/kernel/cpu/mcheck/k7.c
index 89e5104..b945d5d 100644
--- a/arch/x86/kernel/cpu/mcheck/k7.c
+++ b/arch/x86/kernel/cpu/mcheck/k7.c
@@ -10,10 +10,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* Machine Check Handler For AMD Athlon/Duron: */
 static void k7_machine_check(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 6b465a6..c184dc7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -44,7 +44,6 @@
 #include <asm/msr.h>
 
 #include "mce-internal.h"
-#include "mce.h"
 
 /* Handle unconfigured int18 (should never happen) */
 static void unexpected_machine_check(struct pt_regs *regs, long error_code)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.h b/arch/x86/kernel/cpu/mcheck/mce.h
deleted file mode 100644
index 84a552b..0000000
--- a/arch/x86/kernel/cpu/mcheck/mce.h
+++ /dev/null
@@ -1,38 +0,0 @@
-#include <linux/init.h>
-#include <asm/mce.h>
-
-#ifdef CONFIG_X86_OLD_MCE
-void amd_mcheck_init(struct cpuinfo_x86 *c);
-void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
-void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
-#endif
-
-#ifdef CONFIG_X86_ANCIENT_MCE
-void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
-void winchip_mcheck_init(struct cpuinfo_x86 *c);
-extern int mce_p5_enable;
-static inline int mce_p5_enabled(void) { return mce_p5_enable; }
-static inline void enable_p5_mce(void) { mce_p5_enable = 1; }
-#else
-static inline void intel_p5_mcheck_init(struct cpuinfo_x86 *c) {}
-static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
-static inline int mce_p5_enabled(void) { return 0; }
-static inline void enable_p5_mce(void) { }
-#endif
-
-/* Call the installed machine check handler for this CPU setup. */
-extern void (*machine_check_vector)(struct pt_regs *, long error_code);
-
-#ifdef CONFIG_X86_OLD_MCE
-
-extern int nr_mce_banks;
-
-void intel_set_thermal_handler(void);
-
-#else
-
-static inline void intel_set_thermal_handler(void) { }
-
-#endif
-
-void intel_init_thermal(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 2b011d2..475478b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -11,10 +11,9 @@
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index f2ef695..c548111 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -16,8 +16,6 @@
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
 
-#include "mce.h"
-
 asmlinkage void smp_thermal_interrupt(void)
 {
 	__u64 msr_val;
diff --git a/arch/x86/kernel/cpu/mcheck/non-fatal.c b/arch/x86/kernel/cpu/mcheck/non-fatal.c
index 70b7104..f5f2d6f 100644
--- a/arch/x86/kernel/cpu/mcheck/non-fatal.c
+++ b/arch/x86/kernel/cpu/mcheck/non-fatal.c
@@ -17,10 +17,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 static int		firstbank;
 
 #define MCE_RATE	(15*HZ)	/* timer rate is 15s */
diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index 82cee10..8d3e40e 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -12,10 +12,9 @@
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* as supported by the P4/Xeon family */
 struct intel_mce_extended_msrs {
 	u32 eax;
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 015f481..747853f 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -10,10 +10,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* By default disabled */
 int		mce_p5_enable;
 
diff --git a/arch/x86/kernel/cpu/mcheck/p6.c b/arch/x86/kernel/cpu/mcheck/p6.c
index 43c24e6..01e4f81 100644
--- a/arch/x86/kernel/cpu/mcheck/p6.c
+++ b/arch/x86/kernel/cpu/mcheck/p6.c
@@ -10,10 +10,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* Machine Check Handler For PII/PIII */
 static void intel_machine_check(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 81b0248..54060f5 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -9,10 +9,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* Machine check handler for WinChip C6: */
 static void winchip_machine_check(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1e1e27b..71f9c74 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -53,6 +53,7 @@
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
+#include <asm/mce.h>
 
 #include <asm/mach_traps.h>
 
@@ -64,8 +65,6 @@
 #include <asm/setup.h>
 #include <asm/traps.h>
 
-#include "cpu/mcheck/mce.h"
-
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
-- 
1.6.3


