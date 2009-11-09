Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZKIEsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZKIEsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 23:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZKIEsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 23:48:18 -0500
Received: from mga06.intel.com ([134.134.136.21]:12641 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753286AbZKIEsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 23:48:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,705,1249282800"; 
   d="scan'208";a="465525789"
Date: Mon, 9 Nov 2009 12:21:34 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] x86: under bios control, restore AP's APIC_LVTTHMR to
	the BSP value
Message-ID: <20091109042134.GA9169@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
Incorporate Ingo's comments to get BSP's thermal init value in a
'boot-CPU-only' function.

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
 arch/x86/include/asm/apic.h              |    6 ++++++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   27 ++++++++++++++++++++++++++-
 arch/x86/kernel/setup.c                  |    1 +
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 474d80d..97ea588 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -594,4 +594,10 @@ static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
 extern u8 cpu_2_logical_apicid[NR_CPUS];
 #endif
 
+#ifdef CONFIG_X86_THERMAL_VECTOR
+extern void get_bsp_lvtthmr_init(void);
+#else
+static inline void get_bsp_lvtthmr_init(void) { }
+#endif
+
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index b3a1dba..55c5995 100644
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
 
+void get_bsp_lvtthmr_init(void)
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
index e09f0e2..2323771 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1002,6 +1002,7 @@ void __init setup_arch(char **cmdline_p)
 
 	init_apic_mappings();
 	ioapic_init_mappings();
+	get_bsp_lvtthmr_init();
 
 	/* need to wait for io_apic is mapped */
 	probe_nr_irqs_gsi();
