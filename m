Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZDUIHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZDUIHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZDUIHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:07:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:45504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbZDUIHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:07:32 -0400
Date: Tue, 21 Apr 2009 08:06:49 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090420200450.128993000@linux-os.sc.intel.com>
References: <20090420200450.128993000@linux-os.sc.intel.com>
Subject: [tip:x86/apic] x86: x2apic, IR: Clean up X86_X2APIC and INTR_REMAP config checks
Message-ID: <tip-fc1edaf9e7cc4d4696f83dee495b8f158d01c4eb@git.kernel.org>
Git-Commit-ID: fc1edaf9e7cc4d4696f83dee495b8f158d01c4eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 08:06:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc1edaf9e7cc4d4696f83dee495b8f158d01c4eb
Gitweb:     http://git.kernel.org/tip/fc1edaf9e7cc4d4696f83dee495b8f158d01c4eb
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 20 Apr 2009 13:02:27 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 09:08:25 +0200

x86: x2apic, IR: Clean up X86_X2APIC and INTR_REMAP config checks

Add x2apic_supported() to clean up CONFIG_X86_X2APIC checks.

Fix CONFIG_INTR_REMAP checks.

[ Impact: cleanup ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: dwmw2@infradead.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Weidong Han <weidong.han@intel.com>
LKML-Reference: <20090420200450.128993000@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h          |   10 +++---
 arch/x86/include/asm/io_apic.h       |    2 -
 arch/x86/include/asm/irq_remapping.h |    2 +-
 arch/x86/kernel/apic/apic.c          |   49 ++++++++-------------------------
 arch/x86/kernel/apic/io_apic.c       |    2 -
 arch/x86/kernel/apic/probe_64.c      |    2 +-
 include/linux/dmar.h                 |    2 +
 7 files changed, 21 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index fbdd654..3738438 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -107,8 +107,7 @@ extern u32 native_safe_apic_wait_icr_idle(void);
 extern void native_apic_icr_write(u32 low, u32 id);
 extern u64 native_apic_icr_read(void);
 
-#define EIM_8BIT_APIC_ID	0
-#define EIM_32BIT_APIC_ID	1
+extern int x2apic_mode;
 
 #ifdef CONFIG_X86_X2APIC
 /*
@@ -166,7 +165,7 @@ static inline u64 native_x2apic_icr_read(void)
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
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9d826e4..34eaa37 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -161,7 +161,6 @@ extern int io_apic_set_pci_routing(int ioapic, int pin, int irq,
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
-#ifdef CONFIG_X86_64
 extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
 extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
 extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
@@ -169,7 +168,6 @@ extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void reinit_intr_remapped_IO_APIC(int intr_remapping,
 	struct IO_APIC_route_entry **ioapic_entries);
-#endif
 
 extern void probe_nr_irqs_gsi(void);
 
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 0396760..f275e22 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_X86_IRQ_REMAPPING_H
 #define _ASM_X86_IRQ_REMAPPING_H
 
-#define IRTE_DEST(dest) ((x2apic) ? dest : dest << 8)
+#define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
 #endif	/* _ASM_X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7b41a32..2b30e52 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -134,8 +134,8 @@ static __init int setup_apicpmtimer(char *s)
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
+int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
-int x2apic;
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
 static int disable_x2apic;
@@ -858,7 +858,7 @@ void clear_local_APIC(void)
 	u32 v;
 
 	/* APIC hasn't been mapped yet */
-	if (!x2apic && !apic_phys)
+	if (!x2apic_mode && !apic_phys)
 		return;
 
 	maxlvt = lapic_get_maxlvt();
@@ -1330,7 +1330,7 @@ void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_preenabled = x2apic = 1;
+		x2apic_preenabled = x2apic_mode = 1;
 	}
 }
 
@@ -1338,7 +1338,7 @@ void enable_x2apic(void)
 {
 	int msr, msr2;
 
-	if (!x2apic)
+	if (!x2apic_mode)
 		return;
 
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
@@ -1390,25 +1390,17 @@ void __init enable_IR_x2apic(void)
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
@@ -1576,7 +1568,7 @@ void __init early_init_lapic_mapping(void)
  */
 void __init init_apic_mappings(void)
 {
-	if (x2apic) {
+	if (x2apic_mode) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
 	}
@@ -2010,10 +2002,10 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 
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
@@ -2023,8 +2015,6 @@ static int lapic_resume(struct sys_device *dev)
 	unsigned int l, h;
 	unsigned long flags;
 	int maxlvt;
-
-#ifdef CONFIG_INTR_REMAP
 	int ret;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
@@ -2050,17 +2040,8 @@ static int lapic_resume(struct sys_device *dev)
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
@@ -2098,18 +2079,12 @@ static int lapic_resume(struct sys_device *dev)
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
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ea22a86..3a45d2e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -736,7 +736,6 @@ static int __init ioapic_pirq_setup(char *str)
 __setup("pirq=", ioapic_pirq_setup);
 #endif /* CONFIG_X86_32 */
 
-#ifdef CONFIG_INTR_REMAP
 struct IO_APIC_route_entry **alloc_ioapic_entries(void)
 {
 	int apic;
@@ -857,7 +856,6 @@ void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries)
 
 	kfree(ioapic_entries);
 }
-#endif
 
 /*
  * Find the IRQ entry number of a certain pin.
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 1783652..bc3e880 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -50,7 +50,7 @@ static struct apic *apic_probe[] __initdata = {
 void __init default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_X2APIC
-	if (x2apic && (apic != &apic_x2apic_phys &&
+	if (x2apic_mode && (apic != &apic_x2apic_phys &&
 #ifdef CONFIG_X86_UV
 		       apic != &apic_x2apic_uv_x &&
 #endif
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 06f592a..10ff5c4 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -158,6 +158,8 @@ static inline struct intel_iommu *map_ioapic_to_ir(int apic)
 }
 #define irq_remapped(irq)		(0)
 #define enable_intr_remapping(mode)	(-1)
+#define disable_intr_remapping()	(0)
+#define reenable_intr_remapping(mode)	(0)
 #define intr_remapping_enabled		(0)
 #endif
 
