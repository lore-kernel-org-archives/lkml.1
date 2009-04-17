Return-Path: <linux-kernel-owner+w=401wt.eu-S1761839AbZDQOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839AbZDQOvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761370AbZDQOuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:50:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:40367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761392AbZDQOuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:50:54 -0400
Date: Fri, 17 Apr 2009 14:49:14 GMT
From: tip-bot for Weidong Han <weidong.han@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1239957736-6161-4-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-4-git-send-email-weidong.han@intel.com>
Subject: [tip:x86/apic] x86, intr-remap: enable interrupt remapping early
Message-ID: <tip-dfc3c8a9ad3f633d0a3632d5bd165a2786def7c0@git.kernel.org>
Git-Commit-ID: dfc3c8a9ad3f633d0a3632d5bd165a2786def7c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 14:49:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfc3c8a9ad3f633d0a3632d5bd165a2786def7c0
Gitweb:     http://git.kernel.org/tip/dfc3c8a9ad3f633d0a3632d5bd165a2786def7c0
Author:     Weidong Han <weidong.han@intel.com>
AuthorDate: Fri, 17 Apr 2009 16:42:14 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 16:23:45 +0200

x86, intr-remap: enable interrupt remapping early

Currently, when x2apic is not enabled, interrupt remapping
will be enabled in init_dmars(), where it is too late to remap
ioapic interrupts, that is, ioapic interrupts are really in
compatibility mode, not remappable mode.

This patch always enables interrupt remapping before ioapic
setup, it guarantees all interrupts will be remapped when
interrupt remapping is enabled. Thus it doesn't need to set
the compatibility interrupt bit.

[ Impact: refactor intr-remap init sequence, enable fuller remap mode ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: dwmw2@infradead.org
Cc: allen.m.kay@intel.com
Cc: fenghua.yu@intel.com
LKML-Reference: <1239957736-6161-4-git-send-email-weidong.han@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h  |    7 ++--
 arch/x86/kernel/apic/apic.c  |   76 ++++++++++++++++++++----------------------
 drivers/pci/intel-iommu.c    |    9 -----
 drivers/pci/intr_remapping.c |   28 ++++++++--------
 include/linux/dmar.h         |    1 +
 5 files changed, 54 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d4cb7e5..fbdd654 100644
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
 
 extern void apic_disable(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 83e47fe..0cf1eea 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -141,6 +141,8 @@ static int x2apic_preenabled;
 static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
+	if (x2apic_enabled())
+		panic("Bios already enabled x2apic, can't enforce nox2apic");
 	disable_x2apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
@@ -1345,6 +1347,7 @@ void enable_x2apic(void)
 		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
 	}
 }
+#endif /* CONFIG_X86_X2APIC */
 
 void __init enable_IR_x2apic(void)
 {
@@ -1353,32 +1356,21 @@ void __init enable_IR_x2apic(void)
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
 
@@ -1398,20 +1390,25 @@ void __init enable_IR_x2apic(void)
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
@@ -1426,30 +1423,29 @@ end_restore:
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
