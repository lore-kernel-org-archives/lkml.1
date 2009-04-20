Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbZDTUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbZDTUQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbZDTUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:15:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:27286 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbZDTUP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:15:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,219,1239001200"; 
   d="scan'208";a="133562777"
Message-Id: <20090420200450.128993000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:02:27 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Weidong Han <weidong.han@intel.com>
Subject: [patch 1/5] x2apic, IR: cleanup X86_X2APIC and INTR_REMAP config checks
Content-Disposition: inline; filename=fix_ifdef_x2apic_intr_remap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add x2apic_supported() to cleanup CONFIG_X86_X2APIC checks.

Fix CONFIG_INTR_REMAP checks.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Weidong Han <weidong.han@intel.com>
---

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -107,8 +107,7 @@ extern u32 native_safe_apic_wait_icr_idl
 extern void native_apic_icr_write(u32 low, u32 id);
 extern u64 native_apic_icr_read(void);
 
-#define EIM_8BIT_APIC_ID	0
-#define EIM_32BIT_APIC_ID	1
+extern int x2apic_mode;
 
 #ifdef CONFIG_X86_X2APIC
 /*
@@ -166,7 +165,7 @@ static inline u64 native_x2apic_icr_read
 	return val;
 }
 
-extern int x2apic, x2apic_phys;
+extern int x2apic_phys;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
@@ -182,6 +181,8 @@ static inline int x2apic_enabled(void)
 		return 1;
 	return 0;
 }
+
+#define x2apic_supported()	(cpu_has_x2apic)
 #else
 static inline void check_x2apic(void)
 {
@@ -194,9 +195,8 @@ static inline int x2apic_enabled(void)
 	return 0;
 }
 
-#define	x2apic	0
 #define	x2apic_preenabled 0
-
+#define	x2apic_supported()	0
 #endif
 
 extern void enable_IR_x2apic(void);
Index: tip/arch/x86/include/asm/irq_remapping.h
===================================================================
--- tip.orig/arch/x86/include/asm/irq_remapping.h
+++ tip/arch/x86/include/asm/irq_remapping.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_X86_IRQ_REMAPPING_H
 #define _ASM_X86_IRQ_REMAPPING_H
 
-#define IRTE_DEST(dest) ((x2apic) ? dest : dest << 8)
+#define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
 #endif	/* _ASM_X86_IRQ_REMAPPING_H */
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -135,8 +135,8 @@ static __init int setup_apicpmtimer(char
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
+int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
-int x2apic;
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
 static int disable_x2apic;
@@ -861,7 +861,7 @@ void clear_local_APIC(void)
 	u32 v;
 
 	/* APIC hasn't been mapped yet */
-	if (!x2apic && !apic_phys)
+	if (!x2apic_mode && !apic_phys)
 		return;
 
 	maxlvt = lapic_get_maxlvt();
@@ -1334,7 +1334,7 @@ void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_preenabled = x2apic = 1;
+		x2apic_preenabled = x2apic_mode = 1;
 	}
 }
 
@@ -1342,7 +1342,7 @@ void enable_x2apic(void)
 {
 	int msr, msr2;
 
-	if (!x2apic)
+	if (!x2apic_mode)
 		return;
 
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
@@ -1394,25 +1394,17 @@ void __init enable_IR_x2apic(void)
 	mask_IO_APIC_setup(ioapic_entries);
 	mask_8259A();
 
-#ifdef CONFIG_X86_X2APIC
-	if (cpu_has_x2apic)
-		ret = enable_intr_remapping(EIM_32BIT_APIC_ID);
-	else
-#endif
-		ret = enable_intr_remapping(EIM_8BIT_APIC_ID);
-
+	ret = enable_intr_remapping(x2apic_supported());
 	if (ret)
 		goto end_restore;
 
 	pr_info("Enabled Interrupt-remapping\n");
 
-#ifdef CONFIG_X86_X2APIC
-	if (cpu_has_x2apic && !x2apic) {
-		x2apic = 1;
+	if (x2apic_supported() && !x2apic_mode) {
+		x2apic_mode = 1;
 		enable_x2apic();
 		pr_info("Enabled x2apic\n");
 	}
-#endif
 
 end_restore:
 	if (ret)
@@ -1580,7 +1572,7 @@ void __init early_init_lapic_mapping(voi
  */
 void __init init_apic_mappings(void)
 {
-	if (x2apic) {
+	if (x2apic_mode) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
 	}
@@ -2014,10 +2006,10 @@ static int lapic_suspend(struct sys_devi
 
 	local_irq_save(flags);
 	disable_local_APIC();
-#ifdef CONFIG_INTR_REMAP
+
 	if (intr_remapping_enabled)
 		disable_intr_remapping();
-#endif
+
 	local_irq_restore(flags);
 	return 0;
 }
@@ -2027,8 +2019,6 @@ static int lapic_resume(struct sys_devic
 	unsigned int l, h;
 	unsigned long flags;
 	int maxlvt;
-
-#ifdef CONFIG_INTR_REMAP
 	int ret;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
@@ -2054,17 +2044,8 @@ static int lapic_resume(struct sys_devic
 		mask_8259A();
 	}
 
-	if (x2apic)
+	if (x2apic_mode)
 		enable_x2apic();
-#else
-	if (!apic_pm_state.active)
-		return 0;
-
-	local_irq_save(flags);
-	if (x2apic)
-		enable_x2apic();
-#endif
-
 	else {
 		/*
 		 * Make sure the APICBASE points to the right address
@@ -2102,18 +2083,12 @@ static int lapic_resume(struct sys_devic
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-#ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled) {
-		if (x2apic)
-			reenable_intr_remapping(EIM_32BIT_APIC_ID);
-		else
-			reenable_intr_remapping(EIM_8BIT_APIC_ID);
-
+		reenable_intr_remapping(x2apic_mode);
 		unmask_8259A();
 		restore_IO_APIC_setup(ioapic_entries);
 		free_ioapic_entries(ioapic_entries);
 	}
-#endif
 
 	local_irq_restore(flags);
 
Index: tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/probe_64.c
+++ tip/arch/x86/kernel/apic/probe_64.c
@@ -50,7 +50,7 @@ static struct apic *apic_probe[] __initd
 void __init default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_X2APIC
-	if (x2apic && (apic != &apic_x2apic_phys &&
+	if (x2apic_mode && (apic != &apic_x2apic_phys &&
 #ifdef CONFIG_X86_UV
 		       apic != &apic_x2apic_uv_x &&
 #endif
Index: tip/include/linux/dmar.h
===================================================================
--- tip.orig/include/linux/dmar.h
+++ tip/include/linux/dmar.h
@@ -158,6 +158,8 @@ static inline struct intel_iommu *map_io
 }
 #define irq_remapped(irq)		(0)
 #define enable_intr_remapping(mode)	(-1)
+#define disable_intr_remapping()	(0)
+#define reenable_intr_remapping(mode)	(0)
 #define intr_remapping_enabled		(0)
 #endif
 
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -737,7 +737,6 @@ static int __init ioapic_pirq_setup(char
 __setup("pirq=", ioapic_pirq_setup);
 #endif /* CONFIG_X86_32 */
 
-#ifdef CONFIG_INTR_REMAP
 struct IO_APIC_route_entry **alloc_ioapic_entries(void)
 {
 	int apic;
@@ -858,7 +857,6 @@ void free_ioapic_entries(struct IO_APIC_
 
 	kfree(ioapic_entries);
 }
-#endif
 
 /*
  * Find the IRQ entry number of a certain pin.
Index: tip/arch/x86/include/asm/io_apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/io_apic.h
+++ tip/arch/x86/include/asm/io_apic.h
@@ -161,7 +161,6 @@ extern int io_apic_set_pci_routing(int i
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
-#ifdef CONFIG_X86_64
 extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
 extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
 extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
@@ -169,7 +168,6 @@ extern void mask_IO_APIC_setup(struct IO
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void reinit_intr_remapped_IO_APIC(int intr_remapping,
 	struct IO_APIC_route_entry **ioapic_entries);
-#endif
 
 extern void probe_nr_irqs_gsi(void);
 

-- 

