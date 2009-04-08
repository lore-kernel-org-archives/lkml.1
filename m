Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZDHKqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZDHKqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762219AbZDHKpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:45:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:4289 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761342AbZDHKpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:45:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,344,1235980800"; 
   d="scan'208";a="446095888"
From: "Han, Weidong" <weidong.han@intel.com>
To: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 8 Apr 2009 18:44:30 +0800
Subject: [PATCH 1/2] intel-iommu: enable interrupt remapping early
Thread-Topic: [PATCH 1/2] intel-iommu: enable interrupt remapping early
Thread-Index: Acm4Nv7jWCjpMYMjSTqwr0+HrsidqQ==
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7CAF8@pdsmsx503.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt remapping is decoupled from x2apic. When x2apic is not
enabled, interrupt remapping will be enabled in init_dmars where is
late to remap io-apic interrupts, i.e. most of interrupts are in
compatibility mode, not remappable mode.

This patch early enables interrupt remapping before io-apic and x2apic
setup, then there are no compatibility interrupts when interrup remapping
is enabled. Thus it needn't to set compatibility interrupt bit.


Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/include/asm/apic.h  |    9 +++
 arch/x86/kernel/apic/apic.c  |  157 ++++++++++++++++++++++--------------------
 arch/x86/kernel/smpboot.c    |    7 ++
 drivers/pci/intel-iommu.c    |    9 ---
 drivers/pci/intr_remapping.c |   14 ----
 5 files changed, 99 insertions(+), 97 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..e60c6fa 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -202,6 +202,15 @@ static inline int x2apic_enabled(void)
 
 #endif
 
+#ifdef CONFIG_INTR_REMAP
+extern void early_enable_intr_remapping(void);
+#else
+static inline void early_enable_intr_remapping(void)
+{
+	return;
+}
+#endif
+
 extern int get_physical_broadcast(void);
 
 #ifdef CONFIG_X86_X2APIC
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 098ec84..30c857c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1276,6 +1276,71 @@ void __cpuinit end_local_APIC_setup(void)
 	apic_pm_activate();
 }
 
+#ifdef CONFIG_INTR_REMAP
+void __init early_enable_intr_remapping(void)
+{
+	int ret;
+	unsigned long flags;
+	int eim;
+	int preenabled = 0;
+	struct IO_APIC_route_entry **ioapic_entries = NULL;
+
+	ret = dmar_table_init();
+	if (ret) {
+		pr_info("dmar_table_init() failed with %d:\n", ret);
+		return;
+	}
+
+	ioapic_entries = alloc_ioapic_entries();
+	if (!ioapic_entries) {
+		pr_info("Allocate ioapic_entries failed: %d\n", ret);
+		return;
+	}
+
+	ret = save_IO_APIC_setup(ioapic_entries);
+	if (ret) {
+		pr_info("Saving IO-APIC state failed: %d\n", ret);
+		goto end;
+	}
+
+	local_irq_save(flags);
+	mask_IO_APIC_setup(ioapic_entries);
+	mask_8259A();
+
+#ifdef CONFIG_X86_X2APIC
+	if (cpu_has_x2apic && !disable_x2apic && !skip_ioapic_setup)
+		eim = EIM_32BIT_APIC_ID;
+	else
+		eim = EIM_8BIT_APIC_ID;
+	ret = enable_intr_remapping(eim);
+	preenabled = x2apic_preenabled;
+#else
+	eim = EIM_8BIT_APIC_ID;
+	ret = enable_intr_remapping(eim);
+#endif
+	if (ret)
+		/*
+		 * IR enabling failed
+		 */
+		restore_IO_APIC_setup(ioapic_entries);
+	else
+		reinit_intr_remapped_IO_APIC(preenabled, ioapic_entries);
+
+	unmask_8259A();
+	local_irq_restore(flags);
+end:
+	if (!ret)
+		pr_info("Enabled Interrupt-remapping\n");
+	else
+		pr_err("Failed to enable Interrupt-remapping\n");
+
+	if (ioapic_entries)
+		free_ioapic_entries(ioapic_entries);
+
+	return;
+}
+#endif
+
 #ifdef CONFIG_X86_X2APIC
 void check_x2apic(void)
 {
@@ -1301,17 +1366,13 @@ void enable_x2apic(void)
 
 void __init enable_IR_x2apic(void)
 {
-#ifdef CONFIG_INTR_REMAP
-	int ret;
 	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	if (!cpu_has_x2apic)
 		return;
 
 	if (!x2apic_preenabled && disable_x2apic) {
-		pr_info("Skipped enabling x2apic and Interrupt-remapping "
-			"because of nox2apic\n");
+		pr_info("Skipped enabling x2apic because of nox2apic\n");
 		return;
 	}
 
@@ -1319,87 +1380,28 @@ void __init enable_IR_x2apic(void)
 		panic("Bios already enabled x2apic, can't enforce nox2apic");
 
 	if (!x2apic_preenabled && skip_ioapic_setup) {
-		pr_info("Skipped enabling x2apic and Interrupt-remapping "
-			"because of skipping io-apic setup\n");
+		pr_info("Skipped enabling x2apic because of "
+			"skipping io-apic setup\n");
 		return;
 	}
 
-	ret = dmar_table_init();
-	if (ret) {
-		pr_info("dmar_table_init() failed with %d:\n", ret);
+	if (!intr_remapping_enabled && x2apic_preenabled)
+		panic("x2apic enabled by bios. But interrup-remapping "
+		      "is not enabled successfully");
 
-		if (x2apic_preenabled)
-			panic("x2apic enabled by bios. But IR enabling failed");
-		else
-			pr_info("Not enabling x2apic,Intr-remapping\n");
+	if (!intr_remapping_enabled) {
+		pr_err("Enable CONFIG_INTR_REMAP and CONFIG_X86_X2APIC for "
+		       "enabling interrupt-remapping and x2apic\n");
 		return;
 	}
 
-	ioapic_entries = alloc_ioapic_entries();
-	if (!ioapic_entries) {
-		pr_info("Allocate ioapic_entries failed: %d\n", ret);
-		goto end;
-	}
-
-	ret = save_IO_APIC_setup(ioapic_entries);
-	if (ret) {
-		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto end;
-	}
-
-	local_irq_save(flags);
-	mask_IO_APIC_setup(ioapic_entries);
-	mask_8259A();
-
-	ret = enable_intr_remapping(EIM_32BIT_APIC_ID);
-
-	if (ret && x2apic_preenabled) {
-		local_irq_restore(flags);
-		panic("x2apic enabled by bios. But IR enabling failed");
-	}
-
-	if (ret)
-		goto end_restore;
-
 	if (!x2apic) {
+		local_irq_save(flags);
 		x2apic = 1;
 		enable_x2apic();
+		local_irq_restore(flags);
 	}
 
-end_restore:
-	if (ret)
-		/*
-		 * IR enabling failed
-		 */
-		restore_IO_APIC_setup(ioapic_entries);
-	else
-		reinit_intr_remapped_IO_APIC(x2apic_preenabled, ioapic_entries);
-
-	unmask_8259A();
-	local_irq_restore(flags);
-
-end:
-	if (!ret) {
-		if (!x2apic_preenabled)
-			pr_info("Enabled x2apic and interrupt-remapping\n");
-		else
-			pr_info("Enabled Interrupt-remapping\n");
-	} else
-		pr_err("Failed to enable Interrupt-remapping and x2apic\n");
-	if (ioapic_entries)
-		free_ioapic_entries(ioapic_entries);
-#else
-	if (!cpu_has_x2apic)
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic enabled prior OS handover,"
-		      " enable CONFIG_INTR_REMAP");
-
-	pr_info("Enable CONFIG_INTR_REMAP for enabling intr-remapping "
-		" and x2apic\n");
-#endif
-
 	return;
 }
 #endif /* CONFIG_X86_X2APIC */
@@ -1595,6 +1597,13 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
+	/*
+	 * Enable interrupt remapping before enable apic and x2apic,
+	 * then all interrupts will be set to remappable format during
+	 * interrupt setup
+	 */
+	early_enable_intr_remapping();
+
 	enable_IR_x2apic();
 #ifdef CONFIG_X86_64
 	default_setup_apic_routing();
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..b3c83b6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1062,6 +1062,13 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	set_cpu_sibling_map(0);
 
+	/*
+	 * Enable interrupt remapping before enable apic and x2apic,
+	 * then all interrupts will be set to remappable format during
+	 * interrupt setup
+	 */
+	early_enable_intr_remapping();
+
 	enable_IR_x2apic();
 #ifdef CONFIG_X86_64
 	default_setup_apic_routing();
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index dcda521..eaa1c99 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1968,15 +1968,6 @@ static int __init init_dmars(void)
 		}
 	}
 
-#ifdef CONFIG_INTR_REMAP
-	if (!intr_remapping_enabled) {
-		ret = enable_intr_remapping(0);
-		if (ret)
-			printk(KERN_ERR
-			       "IOMMU: enable interrupt remapping failed\n");
-	}
-#endif
-
 	/*
 	 * For each rmrr
 	 *   for each dev attached to rmrr
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index f5e0ea7..4af5fb4 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -423,20 +423,6 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 		      readl, (sts & DMA_GSTS_IRTPS), sts);
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 
-	if (mode == 0) {
-		spin_lock_irqsave(&iommu->register_lock, flags);
-
-		/* enable comaptiblity format interrupt pass through */
-		cmd = iommu->gcmd | DMA_GCMD_CFI;
-		iommu->gcmd |= DMA_GCMD_CFI;
-		writel(cmd, iommu->reg + DMAR_GCMD_REG);
-
-		IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
-			      readl, (sts & DMA_GSTS_CFIS), sts);
-
-		spin_unlock_irqrestore(&iommu->register_lock, flags);
-	}
-
 	/*
 	 * global invalidation of interrupt entry cache before enabling
 	 * interrupt-remapping.
-- 
1.6.0.4
