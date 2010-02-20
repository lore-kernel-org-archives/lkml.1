Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0BTB2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 20:28:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:56035 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0BTB2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 20:28:19 -0500
Date: Sat, 20 Feb 2010 01:27:53 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80CFE@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80CFE@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86: Move pci init function to x86_init
Message-ID: <tip-b72d0db9dd41da1f2ec6274b03e8909583c64e41@git.kernel.org>
Git-Commit-ID: b72d0db9dd41da1f2ec6274b03e8909583c64e41
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Feb 2010 01:27:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b72d0db9dd41da1f2ec6274b03e8909583c64e41
Gitweb:     http://git.kernel.org/tip/b72d0db9dd41da1f2ec6274b03e8909583c64e41
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 29 Aug 2009 16:24:51 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 19 Feb 2010 16:12:29 -0800

x86: Move pci init function to x86_init

The PCI initialization in pci_subsys_init() is a mess. pci_numaq_init,
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
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80CFE@orsmsx508.amr.corp.intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/numaq.h        |    1 +
 arch/x86/include/asm/pci.h          |    9 ++++++++-
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
 15 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/numaq.h b/arch/x86/include/asm/numaq.h
index 9f0a5f5..ef6bf81 100644
--- a/arch/x86/include/asm/numaq.h
+++ b/arch/x86/include/asm/numaq.h
@@ -30,6 +30,7 @@
 
 extern int found_numaq;
 extern int get_memcfg_numaq(void);
+extern int pci_numaq_init(void);
 
 extern void *xquad_portio;
 
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index ada8c20..8bd433c 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -45,8 +45,15 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 
 #ifdef CONFIG_PCI
 extern unsigned int pcibios_assign_all_busses(void);
+extern int pci_legacy_init(void);
+# ifdef CONFIG_ACPI
+#  define x86_default_pci_init pci_acpi_init
+# else
+#  define x86_default_pci_init pci_legacy_init
+# endif
 #else
-#define pcibios_assign_all_busses()	0
+# define pcibios_assign_all_busses()	0
+# define x86_default_pci_init		NULL
 #endif
 
 extern unsigned long pci_mem_start;
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index b4bf9a9..440124f 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -82,7 +82,6 @@ struct irq_routing_table {
 
 extern unsigned int pcibios_irq_mask;
 
-extern int pcibios_scanned;
 extern spinlock_t pci_config_lock;
 
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
@@ -112,9 +111,8 @@ extern void __init dmi_check_skip_isa_align(void);
 /* some common used subsys_initcalls */
 extern int __init pci_acpi_init(void);
 extern int __init pcibios_irq_init(void);
-extern int __init pci_visws_init(void);
-extern int __init pci_numaq_init(void);
 extern int __init pcibios_init(void);
+extern int pci_legacy_init(void);
 
 /* pci-mmconfig.c */
 
@@ -182,3 +180,13 @@ static inline void mmio_config_writel(void __iomem *pos, u32 val)
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
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 18e496c..86b1506 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -37,10 +37,8 @@ void setup_bios_corruption_check(void);
 
 #ifdef CONFIG_X86_VISWS
 extern void visws_early_detect(void);
-extern int is_visws_box(void);
 #else
 static inline void visws_early_detect(void) { }
-static inline int is_visws_box(void) { return 0; }
 #endif
 
 extern unsigned long saved_video_mode;
diff --git a/arch/x86/include/asm/visws/cobalt.h b/arch/x86/include/asm/visws/cobalt.h
index 166adf6..2edb376 100644
--- a/arch/x86/include/asm/visws/cobalt.h
+++ b/arch/x86/include/asm/visws/cobalt.h
@@ -122,4 +122,6 @@ extern char visws_board_type;
 
 extern char visws_board_rev;
 
+extern int pci_visws_init(void);
+
 #endif /* _ASM_X86_VISWS_COBALT_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index ea0e8ea..f145d84 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -98,6 +98,14 @@ struct x86_init_iommu {
 	int (*iommu_init)(void);
 };
 
+ /*
+  * struct x86_init_pci - platform specific pci init functions
+ * @init:			platform specific pci init
+ */
+struct x86_init_pci {
+	int (*init)(void);
+};
+
 /**
  * struct x86_init_ops - functions for platform specific setup
  *
@@ -110,6 +118,7 @@ struct x86_init_ops {
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
 	struct x86_init_iommu		iommu;
+	struct x86_init_pci		pci;
 };
 
 /**
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0acbcdf..054a5f5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -35,6 +35,7 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 
+#include <asm/pci_x86.h>
 #include <asm/pgtable.h>
 #include <asm/io_apic.h>
 #include <asm/apic.h>
@@ -1604,6 +1605,9 @@ int __init acpi_boot_init(void)
 
 	acpi_table_parse(ACPI_SIG_HPET, acpi_parse_hpet);
 
+	if (!acpi_noirq)
+		x86_init.pci.init = pci_acpi_init;
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 98c4665..be5c4fd 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -277,6 +277,7 @@ static __init void early_check_numaq(void)
 		x86_init.mpparse.mpc_oem_pci_bus = mpc_oem_pci_bus;
 		x86_init.mpparse.mpc_oem_bus_info = mpc_oem_bus_info;
 		x86_init.timers.tsc_pre_init = numaq_tsc_init;
+		x86_init.pci.init = pci_numaq_init;
 	}
 }
 
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 34a279a..843e9d3 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
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
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ccd179d..81faa6d 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -7,6 +7,7 @@
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
+#include <asm/pci_x86.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
 #include <asm/apic.h>
@@ -70,6 +71,10 @@ struct x86_init_ops x86_init __initdata = {
 	.iommu = {
 		.iommu_init		= iommu_init_noop,
 	},
+
+	.pci = {
+		.init			= x86_default_pci_init,
+	},
 };
 
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 959e548..73b3fe9 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -282,15 +282,11 @@ int __init pci_acpi_init(void)
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
 
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index d2552c6..f5770b5 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
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
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 4061bb0..0daf264 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -35,16 +35,13 @@ static void __devinit pcibios_fixup_peer_bridges(void)
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
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 8eb295e..45c0c9e 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
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
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index bcead7a..03008f7 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -69,9 +69,6 @@ void __init pcibios_update_irq(struct pci_dev *dev, int irq)
 
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
