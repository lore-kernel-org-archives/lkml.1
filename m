Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZKIMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZKIMOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZKIMOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:14:37 -0500
Received: from mga10.intel.com ([192.55.52.92]:48030 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754920AbZKIMOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:14:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,708,1249282800"; 
   d="scan'208";a="745162465"
Date: Mon, 9 Nov 2009 19:47:52 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4] x86: under bios control, restore AP's APIC_LVTTHMR to
	the BSP value
Message-ID: <20091109114752.GA3896@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v3:

Rename get_bsp_lvtthmr_init to mcheck_intel_therm_init and call it from
mcheck_init function. Make mcheck_init a non-early_initcall so that it
could execute earlier. Many thanks to Ingo for the valuable comments.

---
On platforms where bios handles the thermal monitor interrupt,
APIC_LVTTHMR on each logical CPU is programmed to generate a SMI and OS
can't touch it.

Unfortunately AP bringup sequence using INIT-SIPI-SIPI clear all
the LVT entries except the mask bit. Essentially this results in
all LVT entries including the thermal monitoring interrupt set to masked
(clearing the bios programmed value for APIC_LVTTHMR).

And this leads to kernel take over the thermal monitoring interrupt
on AP's but not on BSP (leaving the bios programmed value only on BSP).

As a result of this, we have seen system hangs when the thermal
monitoring interrupt is generated.

Fix this by reading the initial value of thermal LVT entry on BSP
and if bios has taken over the control, then program the same value
on all AP's and leave the thermal monitoring interrupt control
on all the logical cpu's to the bios.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: stable@kernel.org
---
 arch/x86/include/asm/mce.h               |    9 +++++++++
 arch/x86/kernel/cpu/mcheck/mce.c         |    5 +++--
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   27 ++++++++++++++++++++++++++-
 arch/x86/kernel/setup.c                  |    3 +++
 4 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 161485d..41d8e42 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -120,8 +120,10 @@ extern int mce_disabled;
 extern int mce_p5_enabled;
 
 #ifdef CONFIG_X86_MCE
+int mcheck_init(void);
 void mcheck_cpu_init(struct cpuinfo_x86 *c);
 #else
+static int mcheck_init(void) { return 0; }
 static inline void mcheck_cpu_init(struct cpuinfo_x86 *c) {}
 #endif
 
@@ -215,5 +217,12 @@ extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 void intel_init_thermal(struct cpuinfo_x86 *c);
 
 void mce_log_therm_throt_event(__u64 status);
+
+#ifdef CONFIG_X86_THERMAL_VECTOR
+extern void mcheck_intel_therm_init(void);
+#else
+static inline void mcheck_intel_therm_init(void) { }
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8080170..0d41020 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1655,13 +1655,14 @@ static int __init mcheck_enable(char *str)
 }
 __setup("mce", mcheck_enable);
 
-static int __init mcheck_init(void)
+int __init mcheck_init(void)
 {
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
 
+	mcheck_intel_therm_init();
+
 	return 0;
 }
-early_initcall(mcheck_init);
 
 /*
  * Sysfs support
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index b3a1dba..3faa138 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -49,6 +49,8 @@ static DEFINE_PER_CPU(struct thermal_state, thermal_state);
 
 static atomic_t therm_throt_en	= ATOMIC_INIT(0);
 
+static u32 lvtthmr_init __read_mostly;
+
 #ifdef CONFIG_SYSFS
 #define define_therm_throt_sysdev_one_ro(_name)				\
 	static SYSDEV_ATTR(_name, 0444, therm_throt_sysdev_show_##_name, NULL)
@@ -254,6 +256,16 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 }
 
+void mcheck_intel_therm_init(void)
+{
+	/*
+	 * This function is only called on boot CPU. Save the init thermal
+	 * LVT value on BSP and use that value to restore APs' thermal LVT
+	 * entry BIOS programmed later
+	 */
+	lvtthmr_init = apic_read(APIC_LVTTHMR);
+}
+
 void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
@@ -270,7 +282,20 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	 * since it might be delivered via SMI already:
 	 */
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-	h = apic_read(APIC_LVTTHMR);
+
+	/*
+	 * The initial value of thermal LVT entries on all APs always reads
+	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
+	 * sequence to them and LVT registers are reset to 0s except for
+	 * the mask bits which are set to 1s when APs receive INIT IPI.
+	 * Always restore the value that BIOS has programmed on AP based on
+	 * BSP's info we saved since BIOS is always setting the same value
+	 * for all threads/cores
+	 */
+	apic_write(APIC_LVTTHMR, lvtthmr_init);
+
+	h = lvtthmr_init;
+
 	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
 		printk(KERN_DEBUG
 		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0a64353..e6f0ef9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -110,6 +110,7 @@
 #ifdef CONFIG_X86_64
 #include <asm/numa_64.h>
 #endif
+#include <asm/mce.h>
 
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
@@ -1040,6 +1041,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 	x86_init.oem.banner();
+
+	mcheck_init();
 }
 
 #ifdef CONFIG_X86_32
