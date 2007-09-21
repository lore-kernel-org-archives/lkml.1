Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbXIUUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbXIUUqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762816AbXIUUot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:32953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762567AbXIUUos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:48 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: lenb@kernel.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/45] x86: Unify i386 and x86-64 early quirks
Message-Id: <20070921204447.4E53A14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


They were already very similar; just use the same file now.

Cc: lenb@kernel.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/Makefile          |    2 
 arch/i386/kernel/acpi/Makefile     |    3 -
 arch/i386/kernel/acpi/earlyquirk.c |   84 -------------------------------------
 arch/i386/kernel/setup.c           |    4 -
 arch/x86_64/kernel/early-quirks.c  |   12 ++++-
 include/asm-i386/acpi.h            |    6 --
 include/asm-x86_64/io_apic.h       |    2 
 include/asm-x86_64/proto.h         |    2 
 8 files changed, 16 insertions(+), 99 deletions(-)

Index: linux/arch/x86_64/kernel/early-quirks.c
===================================================================
--- linux.orig/arch/x86_64/kernel/early-quirks.c
+++ linux/arch/x86_64/kernel/early-quirks.c
@@ -13,9 +13,13 @@
 #include <linux/acpi.h>
 #include <linux/pci_ids.h>
 #include <asm/pci-direct.h>
-#include <asm/proto.h>
-#include <asm/iommu.h>
 #include <asm/dma.h>
+#include <asm/io_apic.h>
+#include <asm/apic.h>
+
+#ifdef CONFIG_IOMMU
+#include <asm/iommu.h>
+#endif
 
 static void __init via_bugs(void)
 {
@@ -40,6 +44,7 @@ static int __init nvidia_hpet_check(stru
 static void __init nvidia_bugs(void)
 {
 #ifdef CONFIG_ACPI
+#ifdef CONFIG_X86_IO_APIC
 	/*
 	 * All timer overrides on Nvidia are
 	 * wrong unless HPET is enabled.
@@ -59,17 +64,20 @@ static void __init nvidia_bugs(void)
 			"try acpi_use_timer_override\n");
 	}
 #endif
+#endif
 	/* RED-PEN skip them on mptables too? */
 
 }
 
 static void __init ati_bugs(void)
 {
+#ifdef CONFIG_X86_IO_APIC
 	if (timer_over_8254 == 1) {
 		timer_over_8254 = 0;
 		printk(KERN_INFO
 	 	"ATI board detected. Disabling timer routing over 8254.\n");
 	}
+#endif
 }
 
 struct chipset {
Index: linux/arch/i386/kernel/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/Makefile
+++ linux/arch/i386/kernel/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MCA)		+= mca.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
+obj-$(CONFIG_PCI)		+= early-quirks.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o tsc_sync.o
 obj-$(CONFIG_SMP)		+= smpcommon.o
@@ -87,4 +88,5 @@ $(obj)/vsyscall-syms.o: $(src)/vsyscall.
 
 k8-y                      += ../../x86_64/kernel/k8.o
 stacktrace-y		  += ../../x86_64/kernel/stacktrace.o
+early-quirks-y		  += ../../x86_64/kernel/early-quirks.o
 
Index: linux/arch/i386/kernel/acpi/earlyquirk.c
===================================================================
--- linux.orig/arch/i386/kernel/acpi/earlyquirk.c
+++ /dev/null
@@ -1,84 +0,0 @@
-/* 
- * Do early PCI probing for bug detection when the main PCI subsystem is 
- * not up yet.
- */
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/acpi.h>
-
-#include <asm/pci-direct.h>
-#include <asm/acpi.h>
-#include <asm/apic.h>
-
-#ifdef CONFIG_ACPI
-
-static int __init nvidia_hpet_check(struct acpi_table_header *header)
-{
-	return 0;
-}
-#endif
-
-static int __init check_bridge(int vendor, int device)
-{
-#ifdef CONFIG_ACPI
-	static int warned;
-	/* According to Nvidia all timer overrides are bogus unless HPET
-	   is enabled. */
-	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {
-		if (!warned && acpi_table_parse(ACPI_SIG_HPET,
-						nvidia_hpet_check)) {
-			warned = 1;
-			acpi_skip_timer_override = 1;
-			  printk(KERN_INFO "Nvidia board "
-                       "detected. Ignoring ACPI "
-                       "timer override.\n");
-                printk(KERN_INFO "If you got timer trouble "
-			 	 "try acpi_use_timer_override\n");
-
-		}
-	}
-#endif
-	if (vendor == PCI_VENDOR_ID_ATI && timer_over_8254 == 1) {
-		timer_over_8254 = 0;
-		printk(KERN_INFO "ATI board detected. Disabling timer routing "
-				"over 8254.\n");
-	}
-	return 0;
-}
-
-void __init check_acpi_pci(void)
-{
-	int num, slot, func;
-
-	/* Assume the machine supports type 1. If not it will 
-	   always read ffffffff and should not have any side effect.
-	   Actually a few buggy systems can machine check. Allow the user
-	   to disable it by command line option at least -AK */
-	if (!early_pci_allowed())
-		return;
-
-	/* Poor man's PCI discovery */
-	for (num = 0; num < 32; num++) {
-		for (slot = 0; slot < 32; slot++) {
-			for (func = 0; func < 8; func++) {
-				u32 class;
-				u32 vendor;
-				class = read_pci_config(num, slot, func,
-							PCI_CLASS_REVISION);
-				if (class == 0xffffffff)
-					break;
-
-				if ((class >> 16) != PCI_CLASS_BRIDGE_PCI)
-					continue;
-
-				vendor = read_pci_config(num, slot, func,
-							 PCI_VENDOR_ID);
-
-				if (check_bridge(vendor & 0xffff, vendor >> 16))
-					return;
-			}
-
-		}
-	}
-}
Index: linux/arch/i386/kernel/setup.c
===================================================================
--- linux.orig/arch/i386/kernel/setup.c
+++ linux/arch/i386/kernel/setup.c
@@ -619,9 +619,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 #ifdef CONFIG_PCI
-#ifdef CONFIG_X86_IO_APIC
-	check_acpi_pci();	/* Checks more than just ACPI actually */
-#endif
+	early_quirks();
 #endif
 
 #ifdef CONFIG_ACPI
Index: linux/include/asm-i386/acpi.h
===================================================================
--- linux.orig/include/asm-i386/acpi.h
+++ linux/include/asm-i386/acpi.h
@@ -81,11 +81,7 @@ int __acpi_release_global_lock(unsigned 
         :"=r"(n_hi), "=r"(n_lo)     \
         :"0"(n_hi), "1"(n_lo))
 
-#ifdef CONFIG_X86_IO_APIC
-extern void check_acpi_pci(void);
-#else
-static inline void check_acpi_pci(void) { }
-#endif
+extern void early_quirks(void);
 
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
Index: linux/arch/i386/kernel/acpi/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/acpi/Makefile
+++ linux/arch/i386/kernel/acpi/Makefile
@@ -1,7 +1,4 @@
 obj-$(CONFIG_ACPI)		+= boot.o
-ifneq ($(CONFIG_PCI),)
-obj-$(CONFIG_X86_IO_APIC)	+= earlyquirk.o
-endif
 obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
Index: linux/include/asm-x86_64/io_apic.h
===================================================================
--- linux.orig/include/asm-x86_64/io_apic.h
+++ linux/include/asm-x86_64/io_apic.h
@@ -133,4 +133,6 @@ void enable_NMI_through_LVT0 (void * dum
 
 extern spinlock_t i8259A_lock;
 
+extern int timer_over_8254;
+
 #endif
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -86,8 +86,6 @@ extern unsigned tsc_khz;
 extern int reboot_force;
 extern int notsc_setup(char *);
 
-extern int timer_over_8254;
-
 extern int gsi_irq_sharing(int gsi);
 
 extern void smp_local_timer_interrupt(void);
