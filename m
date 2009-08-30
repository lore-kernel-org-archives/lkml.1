Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZH3NFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZH3NFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZH3NFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:05:43 -0400
Received: from www.tglx.de ([62.245.132.106]:56876 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbZH3NFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:05:41 -0400
Message-Id: <20090830122528.560842597@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 30 Aug 2009 13:05:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>, Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 1/4] x86: Move pci init function to x86_init
References: <20090830122225.608718729@linutronix.de>
Content-Disposition: inline; filename=move-pci-init-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI initialization in pci_subsys_init() is weird. pci_numaq_init,
pci_acpi_init, pci_visws_init and pci_legacy_init are called and each
implementation checks and eventually modifies the global variable
pcibios_scanned.

x86_init functions allow us to do this more elegant. The pci.init
function pointer is preset to pci_legacy_init. numaq, acpi and visws
can modify the pointer in their early setup functions. The functions
return 0 when they did the full initialization including bus scan. A
non zero return value indicates that pci_legacy_init needs to be
called either because the selected function failed or wants the
generic bus scan in pci_legacy_init to happen (e.g. visws).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/numaq.h        |    1 +
 arch/x86/include/asm/pci.h          |    7 +++++++
 arch/x86/include/asm/pci_x86.h      |   14 +++++++++++---
 arch/x86/include/asm/setup.h        |    2 --
 arch/x86/include/asm/visws/cobalt.h |    2 ++
 arch/x86/include/asm/x86_init.h     |    9 +++++++++
 arch/x86/kernel/acpi/boot.c         |    4 ++++
 arch/x86/kernel/apic/numaq_32.c     |    1 +
 arch/x86/kernel/visws_quirks.c      |    6 +-----
 arch/x86/kernel/x86_init.c          |    5 +++++
 arch/x86/pci/acpi.c                 |    6 +-----
 arch/x86/pci/common.c               |    6 ------
 arch/x86/pci/legacy.c               |   22 ++++++++--------------
 arch/x86/pci/numaq_32.c             |    6 ------
 arch/x86/pci/visws.c                |    6 ++----
 15 files changed, 52 insertions(+), 45 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/numaq.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/numaq.h
+++ linux-2.6-tip/arch/x86/include/asm/numaq.h
@@ -30,6 +30,7 @@
 
 extern int found_numaq;
 extern int get_memcfg_numaq(void);
+extern int pci_numaq_init(void);
 
 extern void *xquad_portio;
 
Index: linux-2.6-tip/arch/x86/include/asm/pci.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/pci.h
+++ linux-2.6-tip/arch/x86/include/asm/pci.h
@@ -45,8 +45,15 @@ static inline int pci_proc_domain(struct
 
 #ifdef CONFIG_PCI
 extern unsigned int pcibios_assign_all_busses(void);
+extern int pci_legacy_init(void);
+# ifdef CONFIG_ACPI
+#  define x86_default_pci_init pci_acpi_init
+# else
+#  define x86_default_pci_init pci_legacy_init
+# endif
 #else
 #define pcibios_assign_all_busses()	0
+#define x86_default_pci_init		NULL
 #endif
 #define pcibios_scan_all_fns(a, b)	0
 
Index: linux-2.6-tip/arch/x86/include/asm/pci_x86.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/pci_x86.h
+++ linux-2.6-tip/arch/x86/include/asm/pci_x86.h
@@ -82,7 +82,6 @@ struct irq_routing_table {
 
 extern unsigned int pcibios_irq_mask;
 
-extern int pcibios_scanned;
 extern spinlock_t pci_config_lock;
 
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
@@ -112,9 +111,8 @@ extern void __init dmi_check_skip_isa_al
 /* some common used subsys_initcalls */
 extern int __init pci_acpi_init(void);
 extern int __init pcibios_irq_init(void);
-extern int __init pci_visws_init(void);
-extern int __init pci_numaq_init(void);
 extern int __init pcibios_init(void);
+extern int pci_legacy_init(void);
 
 /* pci-mmconfig.c */
 
@@ -166,3 +164,13 @@ static inline void mmio_config_writel(vo
 {
 	asm volatile("movl %%eax,(%1)" : : "a" (val), "r" (pos) : "memory");
 }
+
+#ifdef CONFIG_PCI
+# ifdef CONFIG_ACPI
+#  define x86_default_pci_init		pci_acpi_init
+# else
+#  define x86_default_pci_init		pci_legacy_init
+# endif
+#else
+# define x86_default_pci_init		NULL
+#endif
Index: linux-2.6-tip/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/setup.h
+++ linux-2.6-tip/arch/x86/include/asm/setup.h
@@ -37,10 +37,8 @@ void setup_bios_corruption_check(void);
 
 #ifdef CONFIG_X86_VISWS
 extern void visws_early_detect(void);
-extern int is_visws_box(void);
 #else
 static inline void visws_early_detect(void) { }
-static inline int is_visws_box(void) { return 0; }
 #endif
 
 extern unsigned long saved_video_mode;
Index: linux-2.6-tip/arch/x86/include/asm/visws/cobalt.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/visws/cobalt.h
+++ linux-2.6-tip/arch/x86/include/asm/visws/cobalt.h
@@ -122,4 +122,6 @@ extern char visws_board_type;
 
 extern char visws_board_rev;
 
+extern int pci_visws_init(void);
+
 #endif /* _ASM_X86_VISWS_COBALT_H */
Index: linux-2.6-tip/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/x86_init.h
+++ linux-2.6-tip/arch/x86/include/asm/x86_init.h
@@ -92,6 +92,14 @@ struct x86_init_timers {
 };
 
 /**
+ * struct x86_init_pci - platform specific pci init functions
+ * @init:			platform specific pci init
+ */
+struct x86_init_pci {
+	int (*init)(void);
+};
+
+/**
  * struct x86_init_ops - functions for platform specific setup
  *
  */
@@ -102,6 +110,7 @@ struct x86_init_ops {
 	struct x86_init_oem		oem;
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
+	struct x86_init_pci		pci;
 };
 
 /**
Index: linux-2.6-tip/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6-tip/arch/x86/kernel/acpi/boot.c
@@ -35,6 +35,7 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 
+#include <asm/pci_x86.h>
 #include <asm/pgtable.h>
 #include <asm/io_apic.h>
 #include <asm/apic.h>
@@ -1719,6 +1720,9 @@ int __init acpi_boot_init(void)
 
 	acpi_table_parse(ACPI_SIG_HPET, acpi_parse_hpet);
 
+	if (!acpi_noirq)
+		x86_init.pci.init = pci_acpi_init;
+
 	return 0;
 }
 
Index: linux-2.6-tip/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6-tip/arch/x86/kernel/apic/numaq_32.c
@@ -282,6 +282,7 @@ static __init void early_check_numaq(voi
 		x86_init.mpparse.mpc_oem_pci_bus = mpc_oem_pci_bus;
 		x86_init.mpparse.mpc_oem_bus_info = mpc_oem_bus_info;
 		x86_init.timers.tsc_pre_init = numaq_tsc_init;
+		x86_init.pci.init = pci_numaq_init;
 	}
 }
 
Index: linux-2.6-tip/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6-tip/arch/x86/kernel/visws_quirks.c
@@ -49,11 +49,6 @@ extern int no_broadcast;
 char visws_board_type	= -1;
 char visws_board_rev	= -1;
 
-int is_visws_box(void)
-{
-	return visws_board_type >= 0;
-}
-
 static void __init visws_time_init(void)
 {
 	printk(KERN_INFO "Starting Cobalt Timer system clock\n");
@@ -242,6 +237,7 @@ void __init visws_early_detect(void)
 	x86_init.irqs.pre_vector_init = visws_pre_intr_init;
 	x86_init.irqs.trap_init = visws_trap_init;
 	x86_init.timers.timer_init = visws_time_init;
+	x86_init.pci.init = pci_visws_init;
 
 	/*
 	 * Install reboot quirks:
Index: linux-2.6-tip/arch/x86/kernel/x86_init.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/x86_init.c
+++ linux-2.6-tip/arch/x86/kernel/x86_init.c
@@ -7,6 +7,7 @@
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
+#include <asm/pci_x86.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
 #include <asm/apic.h>
@@ -63,6 +64,10 @@ struct __initdata x86_init_ops x86_init 
 		.tsc_pre_init		= x86_init_noop,
 		.timer_init		= hpet_time_init,
 	},
+
+	.pci = {
+		.init			= x86_default_pci_init,
+	},
 };
 
 __cpuinitdata struct x86_cpuinit_ops x86_cpuinit = {
Index: linux-2.6-tip/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/acpi.c
+++ linux-2.6-tip/arch/x86/pci/acpi.c
@@ -236,15 +236,11 @@ int __init pci_acpi_init(void)
 {
 	struct pci_dev *dev = NULL;
 
-	if (pcibios_scanned)
-		return 0;
-
 	if (acpi_noirq)
-		return 0;
+		return -ENODEV;
 
 	printk(KERN_INFO "PCI: Using ACPI for IRQ routing\n");
 	acpi_irq_penalty_init();
-	pcibios_scanned++;
 	pcibios_enable_irq = acpi_pci_irq_enable;
 	pcibios_disable_irq = acpi_pci_irq_disable;
 
Index: linux-2.6-tip/arch/x86/pci/common.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/common.c
+++ linux-2.6-tip/arch/x86/pci/common.c
@@ -72,12 +72,6 @@ struct pci_ops pci_root_ops = {
 };
 
 /*
- * legacy, numa, and acpi all want to call pcibios_scan_root
- * from their initcalls. This flag prevents that.
- */
-int pcibios_scanned;
-
-/*
  * This interrupt-safe spinlock protects all accesses to PCI
  * configuration space.
  */
Index: linux-2.6-tip/arch/x86/pci/legacy.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/legacy.c
+++ linux-2.6-tip/arch/x86/pci/legacy.c
@@ -35,16 +35,13 @@ static void __devinit pcibios_fixup_peer
 	}
 }
 
-static int __init pci_legacy_init(void)
+int __init pci_legacy_init(void)
 {
 	if (!raw_pci_ops) {
 		printk("PCI: System does not support PCI\n");
 		return 0;
 	}
 
-	if (pcibios_scanned++)
-		return 0;
-
 	printk("PCI: Probing PCI hardware\n");
 	pci_root_bus = pcibios_scan_root(0);
 	if (pci_root_bus)
@@ -55,16 +52,13 @@ static int __init pci_legacy_init(void)
 
 int __init pci_subsys_init(void)
 {
-#ifdef CONFIG_X86_NUMAQ
-	pci_numaq_init();
-#endif
-#ifdef CONFIG_ACPI
-	pci_acpi_init();
-#endif
-#ifdef CONFIG_X86_VISWS
-	pci_visws_init();
-#endif
-	pci_legacy_init();
+	/*
+	 * The init function returns an non zero value when
+	 * pci_legacy_init should be invoked.
+	 */
+	if (x86_init.pci.init())
+		pci_legacy_init();
+
 	pcibios_fixup_peer_bridges();
 	pcibios_irq_init();
 	pcibios_init();
Index: linux-2.6-tip/arch/x86/pci/numaq_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/numaq_32.c
+++ linux-2.6-tip/arch/x86/pci/numaq_32.c
@@ -152,14 +152,8 @@ int __init pci_numaq_init(void)
 {
 	int quad;
 
-	if (!found_numaq)
-		return 0;
-
 	raw_pci_ops = &pci_direct_conf1_mq;
 
-	if (pcibios_scanned++)
-		return 0;
-
 	pci_root_bus = pcibios_scan_root(0);
 	if (pci_root_bus)
 		pci_bus_add_devices(pci_root_bus);
Index: linux-2.6-tip/arch/x86/pci/visws.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/pci/visws.c
+++ linux-2.6-tip/arch/x86/pci/visws.c
@@ -69,9 +69,6 @@ void __init pcibios_update_irq(struct pc
 
 int __init pci_visws_init(void)
 {
-	if (!is_visws_box())
-		return -1;
-
 	pcibios_enable_irq = &pci_visws_enable_irq;
 	pcibios_disable_irq = &pci_visws_disable_irq;
 
@@ -90,5 +87,6 @@ int __init pci_visws_init(void)
 	pci_scan_bus_with_sysdata(pci_bus1);
 	pci_fixup_irqs(pci_common_swizzle, visws_map_irq);
 	pcibios_resource_survey();
-	return 0;
+	/* Request bus scan */
+	return 1;
 }


