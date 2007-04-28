Return-Path: <linux-kernel-owner+w=401wt.eu-S1161264AbXD1SPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161264AbXD1SPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163443AbXD1SOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:14:55 -0400
Received: from ns2.suse.de ([195.135.220.15]:38589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163293AbXD1Rwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       "Li, Shaohua" <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [3/35] x86: revert x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525
Message-Id: <20070428175227.07410151F0@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@osdl.org>

Obsoleted by Ingo's genapic stuff.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/acpi/earlyquirk.c |   21 ----------------
 arch/i386/kernel/quirks.c          |   46 ++++++++-----------------------------
 arch/i386/kernel/smpboot.c         |    6 ----
 arch/x86_64/kernel/early-quirks.c  |   13 ----------
 arch/x86_64/kernel/smpboot.c       |    8 ------
 include/asm-i386/genapic.h         |    2 -
 include/asm-i386/irq.h             |    2 -
 include/asm-x86_64/proto.h         |    1 
 8 files changed, 12 insertions(+), 87 deletions(-)

Index: linux/arch/i386/kernel/acpi/earlyquirk.c
===================================================================
--- linux.orig/arch/i386/kernel/acpi/earlyquirk.c
+++ linux/arch/i386/kernel/acpi/earlyquirk.c
@@ -10,7 +10,6 @@
 #include <asm/pci-direct.h>
 #include <asm/acpi.h>
 #include <asm/apic.h>
-#include <asm/irq.h>
 
 #ifdef CONFIG_ACPI
 
@@ -45,24 +44,6 @@ static int __init check_bridge(int vendo
 	return 0;
 }
 
-static void check_intel(void)
-{
-	u16 vendor, device;
-
-	vendor = read_pci_config_16(0, 0, 0, PCI_VENDOR_ID);
-
-	if (vendor != PCI_VENDOR_ID_INTEL)
-		return;
-
-	device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
-#ifdef CONFIG_SMP
-	if (device == PCI_DEVICE_ID_INTEL_E7320_MCH ||
-	    device == PCI_DEVICE_ID_INTEL_E7520_MCH ||
-	    device == PCI_DEVICE_ID_INTEL_E7525_MCH)
-		quirk_intel_irqbalance();
-#endif
-}
-
 void __init check_acpi_pci(void)
 {
 	int num, slot, func;
@@ -74,8 +55,6 @@ void __init check_acpi_pci(void)
 	if (!early_pci_allowed())
 		return;
 
-	check_intel();
-
 	/* Poor man's PCI discovery */
 	for (num = 0; num < 32; num++) {
 		for (slot = 0; slot < 32; slot++) {
Index: linux/arch/i386/kernel/quirks.c
===================================================================
--- linux.orig/arch/i386/kernel/quirks.c
+++ linux/arch/i386/kernel/quirks.c
@@ -3,23 +3,10 @@
  */
 #include <linux/pci.h>
 #include <linux/irq.h>
-#include <asm/pci-direct.h>
-#include <asm/genapic.h>
-#include <asm/cpu.h>
 
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
-static void __devinit verify_quirk_intel_irqbalance(struct pci_dev *dev)
-{
-#ifdef CONFIG_X86_64
-	if (genapic !=  &apic_flat)
-		panic("APIC mode must be flat on this system\n");
-#elif defined(CONFIG_X86_GENERICARCH)
-	if (genapic != &apic_default)
-		panic("APIC mode must be default(flat) on this system. Use apic=default\n");
-#endif
-}
 
-void __init quirk_intel_irqbalance(void)
+static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 {
 	u8 config, rev;
 	u32 word;
@@ -29,18 +16,18 @@ void __init quirk_intel_irqbalance(void)
 	 * based platforms.
 	 * Disable SW irqbalance/affinity on those platforms.
 	 */
-	rev = read_pci_config_byte(0, 0, 0, PCI_CLASS_REVISION);
+	pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
 	if (rev > 0x9)
 		return;
 
 	printk(KERN_INFO "Intel E7520/7320/7525 detected.");
 
-	/* enable access to config space */
-	config = read_pci_config_byte(0, 0, 0, 0xf4);
-	write_pci_config_byte(0, 0, 0, 0xf4, config|0x2);
+	/* enable access to config space*/
+	pci_read_config_byte(dev, 0xf4, &config);
+	pci_write_config_byte(dev, 0xf4, config|0x2);
 
 	/* read xTPR register */
-	word = read_pci_config_16(0, 0, 0x40, 0x4c);
+	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
 		printk(KERN_INFO "Disabling irq balancing and affinity\n");
@@ -51,24 +38,13 @@ void __init quirk_intel_irqbalance(void)
 #ifdef CONFIG_PROC_FS
 		no_irq_affinity = 1;
 #endif
-#ifdef CONFIG_HOTPLUG_CPU
-		printk(KERN_INFO "Disabling cpu hotplug control\n");
-		enable_cpu_hotplug = 0;
-#endif
-#ifdef CONFIG_X86_64
-		/* force the genapic selection to flat mode so that
-		 * interrupts can be redirected to more than one CPU.
-		 */
-		genapic_force = &apic_flat;
-#endif
 	}
 
-	/* put back the original value for config space */
+	/* put back the original value for config space*/
 	if (!(config & 0x2))
-		write_pci_config_byte(0, 0, 0, 0xf4, config);
+		pci_write_config_byte(dev, 0xf4, config);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_E7320_MCH,  verify_quirk_intel_irqbalance);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_E7525_MCH,  verify_quirk_intel_irqbalance);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_E7520_MCH,  verify_quirk_intel_irqbalance);
-
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7320_MCH,	quirk_intel_irqbalance);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7525_MCH,	quirk_intel_irqbalance);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7520_MCH,	quirk_intel_irqbalance);
 #endif
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -54,7 +54,6 @@
 #include <asm/arch_hooks.h>
 #include <asm/nmi.h>
 #include <asm/pda.h>
-#include <asm/genapic.h>
 
 #include <mach_apic.h>
 #include <mach_wakecpu.h>
@@ -1319,11 +1318,6 @@ int __cpuinit __cpu_up(unsigned int cpu)
 		touch_nmi_watchdog();
 	}
 
-#ifdef CONFIG_X86_GENERICARCH
-	if (num_online_cpus() > 8 && genapic == &apic_default)
-		panic("Default flat APIC routing can't be used with > 8 cpus\n");
-#endif
-
 	return 0;
 }
 
Index: linux/arch/x86_64/kernel/early-quirks.c
===================================================================
--- linux.orig/arch/x86_64/kernel/early-quirks.c
+++ linux/arch/x86_64/kernel/early-quirks.c
@@ -71,18 +71,6 @@ static void __init ati_bugs(void)
 	}
 }
 
-static void intel_bugs(void)
-{
-	u16 device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
-
-#ifdef CONFIG_SMP
-	if (device == PCI_DEVICE_ID_INTEL_E7320_MCH ||
-	    device == PCI_DEVICE_ID_INTEL_E7520_MCH ||
-	    device == PCI_DEVICE_ID_INTEL_E7525_MCH)
-		quirk_intel_irqbalance();
-#endif
-}
-
 struct chipset {
 	u16 vendor;
 	void (*f)(void);
@@ -92,7 +80,6 @@ static struct chipset early_qrk[] __init
 	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
 	{ PCI_VENDOR_ID_VIA, via_bugs },
 	{ PCI_VENDOR_ID_ATI, ati_bugs },
-	{ PCI_VENDOR_ID_INTEL, intel_bugs},
 	{}
 };
 
Index: linux/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smpboot.c
+++ linux/arch/x86_64/kernel/smpboot.c
@@ -60,7 +60,6 @@
 #include <asm/irq.h>
 #include <asm/hw_irq.h>
 #include <asm/numa.h>
-#include <asm/genapic.h>
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -965,13 +964,6 @@ int __cpuinit __cpu_up(unsigned int cpu)
 
 	while (!cpu_isset(cpu, cpu_online_map))
 		cpu_relax();
-
-	if (num_online_cpus() > 8 && genapic == &apic_flat) {
-		printk(KERN_WARNING
-		       "flat APIC routing can't be used with > 8 cpus\n");
-		BUG();
-	}
-
 	err = 0;
 
 	return err;
Index: linux/include/asm-i386/genapic.h
===================================================================
--- linux.orig/include/asm-i386/genapic.h
+++ linux/include/asm-i386/genapic.h
@@ -122,6 +122,6 @@ struct genapic { 
 	APICFUNC(phys_pkg_id) \
 	}
 
-extern struct genapic *genapic, apic_default;
+extern struct genapic *genapic;
 
 #endif
Index: linux/include/asm-i386/irq.h
===================================================================
--- linux.orig/include/asm-i386/irq.h
+++ linux/include/asm-i386/irq.h
@@ -37,8 +37,6 @@ static __inline__ int irq_canonicalize(i
 extern int irqbalance_disable(char *str);
 #endif
 
-extern void quirk_intel_irqbalance(void);
-
 #ifdef CONFIG_HOTPLUG_CPU
 extern void fixup_irqs(cpumask_t map);
 #endif
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -82,7 +82,6 @@ extern void syscall32_cpu_init(void);
 extern void setup_node_bootmem(int nodeid, unsigned long start, unsigned long end);
 
 extern void early_quirks(void);
-extern void quirk_intel_irqbalance(void);
 extern void check_efer(void);
 
 extern int unhandled_signal(struct task_struct *tsk, int sig);
