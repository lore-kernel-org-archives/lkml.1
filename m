Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZBOK4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZBOK4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZBOK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:56:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:50977 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZBOK4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:56:10 -0500
Message-ID: <4997F4A4.9070606@kernel.org>
Date: Sun, 15 Feb 2009 02:55:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make x2apic config to be config
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: make most systems could deselect x2apic

INTR_REMAP is needed to make x2apic working,
but INTR_REMAP is experimental, so just make x2apic depends on
INTR_REMAP in config

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig             |    5 +++++
 arch/x86/include/asm/apic.h  |   18 +++++++++++++++---
 arch/x86/kernel/Makefile     |    4 ++--
 arch/x86/kernel/apic.c       |   36 +++++++++++++-----------------------
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/genapic_64.c |    4 ++++
 arch/x86/kernel/setup.c      |    3 +--
 arch/x86/kernel/smpboot.c    |    2 +-
 8 files changed, 42 insertions(+), 32 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -236,6 +236,10 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config X2APIC
+	def_bool y
+	depends on INTR_REMAP
+
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
 	depends on PCI_MSI || HT_IRQ
@@ -1835,6 +1839,7 @@ config DMAR_FLOPPY_WA
 config INTR_REMAP
 	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
 	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	select X2APIC
 	---help---
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
 	  To use x2apic mode in the CPU's which support x2APIC enhancements or
Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -112,7 +112,7 @@ static inline u32 native_apic_msr_read(u
 	return low;
 }
 
-#ifndef CONFIG_X86_32
+#ifdef CONFIG_X2APIC
 extern int x2apic;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
@@ -131,7 +131,19 @@ static inline int x2apic_enabled(void)
 	return 0;
 }
 #else
-#define x2apic_enabled()	0
+static inline void check_x2apic(void)
+{
+}
+static inline void enable_x2apic(void)
+{
+}
+static inline void enable_IR_x2apic(void)
+{
+}
+static inline int x2apic_enabled(void)
+{
+	return 0;
+}
 #endif
 
 struct apic_ops {
@@ -177,7 +189,7 @@ static inline u32 safe_apic_wait_icr_idl
 
 extern int get_physical_broadcast(void);
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X2APIC
 static inline void ack_x2APIC_irq(void)
 {
 	/* Docs say use 0 for future compatibility */
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -117,8 +117,8 @@ obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o
-        obj-y				+= genx2apic_cluster.o
-        obj-y				+= genx2apic_phys.o
+        obj-$(CONFIG_X2APIC)		+= genx2apic_cluster.o
+        obj-$(CONFIG_X2APIC)		+= genx2apic_phys.o
 	obj-$(CONFIG_X86_UV)		+= genx2apic_uv_x.o tlb_uv.o
 	obj-$(CONFIG_X86_UV)		+= bios_uv.o uv_irq.o uv_sysfs.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
Index: linux-2.6/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic.c
+++ linux-2.6/arch/x86/kernel/apic.c
@@ -113,11 +113,7 @@ static __init int setup_apicpmtimer(char
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
-#ifdef CONFIG_X86_64
-#define HAVE_X2APIC
-#endif
-
-#ifdef HAVE_X2APIC
+#ifdef CONFIG_X2APIC
 int x2apic;
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
@@ -270,7 +266,7 @@ static struct apic_ops xapic_ops = {
 struct apic_ops __read_mostly *apic_ops = &xapic_ops;
 EXPORT_SYMBOL_GPL(apic_ops);
 
-#ifdef HAVE_X2APIC
+#ifdef CONFIG_X2APIC
 static void x2apic_wait_icr_idle(void)
 {
 	/* no need to wait for icr idle in x2apic */
@@ -1324,11 +1320,14 @@ void __cpuinit end_local_APIC_setup(void
 	apic_pm_activate();
 }
 
-#ifdef HAVE_X2APIC
+#ifdef CONFIG_X2APIC
 void check_x2apic(void)
 {
 	int msr, msr2;
 
+	if (!cpu_has_x2apic)
+		return;
+
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 
 	if (msr & X2APIC_ENABLE) {
@@ -1342,6 +1341,9 @@ void enable_x2apic(void)
 {
 	int msr, msr2;
 
+	if (!x2apic)
+		return;
+
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
 		pr_info("Enabling x2apic\n");
@@ -1429,21 +1431,9 @@ end:
 			pr_info("Enabled Interrupt-remapping\n");
 	} else
 		pr_err("Failed to enable Interrupt-remapping and x2apic\n");
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
 #endif
-
-	return;
 }
-#endif /* HAVE_X2APIC */
+#endif /* CONFIG_X2APIC */
 
 #ifdef CONFIG_X86_64
 /*
@@ -1574,7 +1564,7 @@ void __init early_init_lapic_mapping(voi
  */
 void __init init_apic_mappings(void)
 {
-#ifdef HAVE_X2APIC
+#ifdef CONFIG_X2APIC
 	if (x2apic) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
@@ -1638,7 +1628,7 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
-#ifdef HAVE_X2APIC
+#ifdef CONFIG_X2APIC
 	enable_IR_x2apic();
 #endif
 #ifdef CONFIG_X86_64
@@ -2029,7 +2019,7 @@ static int lapic_resume(struct sys_devic
 
 	local_irq_save(flags);
 
-#ifdef HAVE_X2APIC
+#ifdef CONFIG_X2APIC
 	if (x2apic)
 		enable_x2apic();
 	else
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -1060,7 +1060,7 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	check_efer();
-	if (cpu != 0 && x2apic)
+	if (cpu != 0)
 		enable_x2apic();
 
 	/*
Index: linux-2.6/arch/x86/kernel/genapic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_64.c
+++ linux-2.6/arch/x86/kernel/genapic_64.c
@@ -35,8 +35,10 @@ static struct genapic *apic_probe[] __in
 #ifdef CONFIG_X86_UV
 	&apic_x2apic_uv_x,
 #endif
+#ifdef CONFIG_X2APIC
 	&apic_x2apic_phys,
 	&apic_x2apic_cluster,
+#endif
 	&apic_physflat,
 	NULL,
 };
@@ -46,10 +48,12 @@ static struct genapic *apic_probe[] __in
  */
 void __init default_setup_apic_routing(void)
 {
+#ifdef CONFIG_X2APIC
 	if (apic == &apic_x2apic_phys || apic == &apic_x2apic_cluster) {
 		if (!intr_remapping_enabled)
 			apic = &apic_flat;
 	}
+#endif
 
 	if (apic == &apic_flat) {
 		if (max_physical_apicid >= 8)
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -836,8 +836,7 @@ void __init setup_arch(char **cmdline_p)
 #else
 	num_physpages = max_pfn;
 
- 	if (cpu_has_x2apic)
- 		check_x2apic();
+	check_x2apic();
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -1128,8 +1128,8 @@ void __init native_smp_prepare_cpus(unsi
 	current_thread_info()->cpu = 0;  /* needed? */
 	set_cpu_sibling_map(0);
 
-#ifdef CONFIG_X86_64
 	enable_IR_x2apic();
+#ifdef CONFIG_X86_64
 	default_setup_apic_routing();
 #endif
 
