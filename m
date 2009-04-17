Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbZDQIm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbZDQIm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759607AbZDQIle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:41:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:41767 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759112AbZDQIlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:41:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="scan'208";a="448762639"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, allen.m.kay@intel.com,
       fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Weidong Han <weidong.han@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 3/5] x86, intr-remap: enable interrupt remapping early
Date: Fri, 17 Apr 2009 16:42:14 +0800
Message-Id: <1239957736-6161-4-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when x2apic is not enabled, interrupt remapping
will be enabled in init_dmars, where is too late to remap
ioapic interrupts, that is, ioapic interrupts are really in
compatibility mode, not remappable mode.

This patch always enables interrupt remapping before ioapic
setup, it guarantees all interrupts will be remapped when
interrupt remapping is enabled. Thus it needn't to set
compatibility interrupt bit.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/include/asm/apic.h  |    7 ++--
 arch/x86/kernel/apic/apic.c  |   76 ++++++++++++++++++++----------------------
 drivers/pci/intel-iommu.c    |    9 -----
 drivers/pci/intr_remapping.c |   28 ++++++++--------
 include/linux/dmar.h         |    1 +
 5 files changed, 54 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c37af81..4bff4cb 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -169,7 +169,6 @@ static inline u64 native_x2apic_icr_read(void)
 extern int x2apic, x2apic_phys;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
-extern void enable_IR_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
 static inline int x2apic_enabled(void)
 {
@@ -190,18 +189,18 @@ static inline void check_x2apic(void)
 static inline void enable_x2apic(void)
 {
 }
-static inline void enable_IR_x2apic(void)
-{
-}
 static inline int x2apic_enabled(void)
 {
 	return 0;
 }
 
 #define	x2apic	0
+#define	x2apic_preenabled 0
 
 #endif
 
+extern void enable_IR_x2apic(void);
+
 extern int get_physical_broadcast(void);
 
 extern int lapic_get_maxlvt(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f287092..39b621c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -118,6 +118,8 @@ static int x2apic_preenabled;
 static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
+	if (x2apic_enabled())
+		panic("Bios already enabled x2apic, can't enforce nox2apic");
 	disable_x2apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
@@ -1304,6 +1306,7 @@ void enable_x2apic(void)
 		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
 	}
 }
+#endif /* CONFIG_X86_X2APIC */
 
 void __init enable_IR_x2apic(void)
 {
@@ -1312,32 +1315,21 @@ void __init enable_IR_x2apic(void)
 	unsigned long flags;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
-	if (!cpu_has_x2apic)
-		return;
-
-	if (!x2apic_preenabled && disable_x2apic) {
-		pr_info("Skipped enabling x2apic and Interrupt-remapping "
-			"because of nox2apic\n");
-		return;
+	ret = dmar_table_init();
+	if (ret) {
+		pr_debug("dmar_table_init() failed with %d:\n", ret);
+		goto ir_failed;
 	}
 
-	if (x2apic_preenabled && disable_x2apic)
-		panic("Bios already enabled x2apic, can't enforce nox2apic");
-
-	if (!x2apic_preenabled && skip_ioapic_setup) {
-		pr_info("Skipped enabling x2apic and Interrupt-remapping "
-			"because of skipping io-apic setup\n");
-		return;
+	if (!intr_remapping_supported()) {
+		pr_debug("intr-remapping not supported\n");
+		goto ir_failed;
 	}
 
-	ret = dmar_table_init();
-	if (ret) {
-		pr_info("dmar_table_init() failed with %d:\n", ret);
 
-		if (x2apic_preenabled)
-			panic("x2apic enabled by bios. But IR enabling failed");
-		else
-			pr_info("Not enabling x2apic,Intr-remapping\n");
+	if (!x2apic_preenabled && skip_ioapic_setup) {
+		pr_info("Skipped enabling intr-remap because of skipping "
+			"io-apic setup\n");
 		return;
 	}
 
@@ -1357,20 +1349,25 @@ void __init enable_IR_x2apic(void)
 	mask_IO_APIC_setup(ioapic_entries);
 	mask_8259A();
 
-	ret = enable_intr_remapping(EIM_32BIT_APIC_ID);
-
-	if (ret && x2apic_preenabled) {
-		local_irq_restore(flags);
-		panic("x2apic enabled by bios. But IR enabling failed");
-	}
+#ifdef CONFIG_X86_X2APIC
+	if (cpu_has_x2apic)
+		ret = enable_intr_remapping(EIM_32BIT_APIC_ID);
+	else
+#endif
+		ret = enable_intr_remapping(EIM_8BIT_APIC_ID);
 
 	if (ret)
 		goto end_restore;
 
-	if (!x2apic) {
+	pr_info("Enabled Interrupt-remapping\n");
+
+#ifdef CONFIG_X86_X2APIC
+	if (cpu_has_x2apic && !x2apic) {
 		x2apic = 1;
 		enable_x2apic();
+		pr_info("Enabled x2apic\n");
 	}
+#endif
 
 end_restore:
 	if (ret)
@@ -1385,30 +1382,29 @@ end_restore:
 	local_irq_restore(flags);
 
 end:
-	if (!ret) {
-		if (!x2apic_preenabled)
-			pr_info("Enabled x2apic and interrupt-remapping\n");
-		else
-			pr_info("Enabled Interrupt-remapping\n");
-	} else
-		pr_err("Failed to enable Interrupt-remapping and x2apic\n");
 	if (ioapic_entries)
 		free_ioapic_entries(ioapic_entries);
+
+	if (!ret)
+		return;
+
+ir_failed:
+	if (x2apic_preenabled)
+		panic("x2apic enabled by bios. But IR enabling failed");
+	else if (cpu_has_x2apic)
+		pr_info("Not enabling x2apic,Intr-remapping\n");
 #else
 	if (!cpu_has_x2apic)
 		return;
 
 	if (x2apic_preenabled)
 		panic("x2apic enabled prior OS handover,"
-		      " enable CONFIG_INTR_REMAP");
-
-	pr_info("Enable CONFIG_INTR_REMAP for enabling intr-remapping "
-		" and x2apic\n");
+		      " enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
 #endif
 
 	return;
 }
-#endif /* CONFIG_X86_X2APIC */
+
 
 #ifdef CONFIG_X86_64
 /*
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 001b328..9ce8f07 100644
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
index f5e0ea7..5c21426 100644
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
@@ -516,6 +502,20 @@ end:
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
+int __init intr_remapping_supported(void)
+{
+	struct dmar_drhd_unit *drhd;
+
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		if (!ecap_ir_support(iommu->ecap))
+			return 0;
+	}
+
+	return 1;
+}
+
 int __init enable_intr_remapping(int eim)
 {
 	struct dmar_drhd_unit *drhd;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index e397dc3..06f592a 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -108,6 +108,7 @@ struct irte {
 };
 #ifdef CONFIG_INTR_REMAP
 extern int intr_remapping_enabled;
+extern int intr_remapping_supported(void);
 extern int enable_intr_remapping(int);
 extern void disable_intr_remapping(void);
 extern int reenable_intr_remapping(int);
-- 
1.6.0.4

