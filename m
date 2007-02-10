Return-Path: <linux-kernel-owner+w=401wt.eu-S933393AbXBJL6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbXBJL6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933398AbXBJLvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:55787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933392AbXBJLuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:35 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Olivier Galibert <galibert@pobox.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [14/25] x86: Share what's shareable.
Message-Id: <20070210115027.074A013DA5@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Olivier Galibert <galibert@pobox.com>

i386 and x86-64 pci mmconfig code have a lot in common.  So share what's
shareable between the two.

Signed-off-by: Olivier Galibert <galibert@pobox.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/Makefile          |    2 
 arch/i386/pci/mmconfig-shared.c |   86 ++++++++++++++++++++++++++++++++++++++++
 arch/i386/pci/mmconfig.c        |   74 +---------------------------------
 arch/i386/pci/pci.h             |    6 ++
 arch/x86_64/pci/Makefile        |    3 -
 arch/x86_64/pci/mmconfig.c      |   76 +++++------------------------------
 6 files changed, 111 insertions(+), 136 deletions(-)

Index: linux/arch/i386/pci/Makefile
===================================================================
--- linux.orig/arch/i386/pci/Makefile
+++ linux/arch/i386/pci/Makefile
@@ -1,7 +1,7 @@
 obj-y				:= i386.o init.o
 
 obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
-obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig.o direct.o
+obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig.o direct.o mmconfig-shared.o
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 
 pci-y				:= fixup.o
Index: linux/arch/i386/pci/mmconfig-shared.c
===================================================================
--- /dev/null
+++ linux/arch/i386/pci/mmconfig-shared.c
@@ -0,0 +1,86 @@
+/*
+ * mmconfig-shared.c - Low-level direct PCI config space access via
+ *                     MMCONFIG - common code between i386 and x86-64.
+ *
+ * This code does:
+ * - ACPI decoding and validation
+ *
+ * Per-architecture code takes care of the mappings and accesses
+ * themselves.
+ */
+
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/bitmap.h>
+#include <asm/e820.h>
+
+#include "pci.h"
+
+/* aperture is up to 256MB but BIOS may reserve less */
+#define MMCONFIG_APER_MIN	(2 * 1024*1024)
+#define MMCONFIG_APER_MAX	(256 * 1024*1024)
+
+/* Verify the first 16 busses. We assume that systems with more busses
+   get MCFG right. */
+#define PCI_MMCFG_MAX_CHECK_BUS 16
+
+DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
+
+/* K8 systems have some devices (typically in the builtin northbridge)
+   that are only accessible using type1
+   Normally this can be expressed in the MCFG by not listing them
+   and assigning suitable _SEGs, but this isn't implemented in some BIOS.
+   Instead try to discover all devices on bus 0 that are unreachable using MM
+   and fallback for them. */
+static __init void unreachable_devices(void)
+{
+	int i, k;
+	/* Use the max bus number from ACPI here? */
+	for (k = 0; k < PCI_MMCFG_MAX_CHECK_BUS; k++) {
+		for (i = 0; i < 32; i++) {
+			u32 val1, val2;
+
+			pci_conf1_read(0, k, PCI_DEVFN(i,0), 0, 4, &val1);
+			if (val1 == 0xffffffff)
+				continue;
+
+			raw_pci_ops->read(0, k, PCI_DEVFN(i, 0), 0, 4, &val2);
+			if (val1 != val2) {
+				set_bit(i + 32*k, pci_mmcfg_fallback_slots);
+				printk(KERN_NOTICE "PCI: No mmconfig possible"
+				       " on device %02x:%02x\n", k, i);
+			}
+		}
+	}
+}
+
+void __init pci_mmcfg_init(int type)
+{
+	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
+		return;
+
+	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+
+	if ((pci_mmcfg_config_num == 0) ||
+	    (pci_mmcfg_config == NULL) ||
+	    (pci_mmcfg_config[0].address == 0))
+		return;
+
+	/* Only do this check when type 1 works. If it doesn't work
+           assume we run on a Mac and always use MCFG */
+	if (type == 1 &&
+	    !e820_all_mapped(pci_mmcfg_config[0].address,
+			     pci_mmcfg_config[0].address + MMCONFIG_APER_MIN,
+			     E820_RESERVED)) {
+		printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not E820-reserved\n",
+				pci_mmcfg_config[0].address);
+		printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
+		return;
+	}
+
+	if (pci_mmcfg_arch_init()) {
+		unreachable_devices();
+		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
+	}
+}
Index: linux/arch/i386/pci/mmconfig.c
===================================================================
--- linux.orig/arch/i386/pci/mmconfig.c
+++ linux/arch/i386/pci/mmconfig.c
@@ -15,21 +15,13 @@
 #include <asm/e820.h>
 #include "pci.h"
 
-/* aperture is up to 256MB but BIOS may reserve less */
-#define MMCONFIG_APER_MIN	(2 * 1024*1024)
-#define MMCONFIG_APER_MAX	(256 * 1024*1024)
-
 /* Assume systems with more busses have correct MCFG */
-#define MAX_CHECK_BUS 16
-
 #define mmcfg_virt_addr ((void __iomem *) fix_to_virt(FIX_PCIE_MCFG))
 
 /* The base address of the last MMCONFIG device accessed */
 static u32 mmcfg_last_accessed_device;
 static int mmcfg_last_accessed_cpu;
 
-static DECLARE_BITMAP(fallback_slots, MAX_CHECK_BUS*32);
-
 /*
  * Functions for accessing PCI configuration space with MMCONFIG accesses
  */
@@ -38,8 +30,8 @@ static u32 get_base_addr(unsigned int se
 	int cfg_num = -1;
 	struct acpi_mcfg_allocation *cfg;
 
-	if (seg == 0 && bus < MAX_CHECK_BUS &&
-	    test_bit(PCI_SLOT(devfn) + 32*bus, fallback_slots))
+	if (seg == 0 && bus < PCI_MMCFG_MAX_CHECK_BUS &&
+	    test_bit(PCI_SLOT(devfn) + 32*bus, pci_mmcfg_fallback_slots))
 		return 0;
 
 	while (1) {
@@ -158,67 +150,9 @@ static struct pci_raw_ops pci_mmcfg = {
 	.write =	pci_mmcfg_write,
 };
 
-/* K8 systems have some devices (typically in the builtin northbridge)
-   that are only accessible using type1
-   Normally this can be expressed in the MCFG by not listing them
-   and assigning suitable _SEGs, but this isn't implemented in some BIOS.
-   Instead try to discover all devices on bus 0 that are unreachable using MM
-   and fallback for them. */
-static __init void unreachable_devices(void)
-{
-	int i, k;
-	unsigned long flags;
-
-	for (k = 0; k < MAX_CHECK_BUS; k++) {
-		for (i = 0; i < 32; i++) {
-			u32 val1;
-			u32 addr;
-
-			pci_conf1_read(0, k, PCI_DEVFN(i, 0), 0, 4, &val1);
-			if (val1 == 0xffffffff)
-				continue;
-
-			/* Locking probably not needed, but safer */
-			spin_lock_irqsave(&pci_config_lock, flags);
-			addr = get_base_addr(0, k, PCI_DEVFN(i, 0));
-			if (addr != 0)
-				pci_exp_set_dev_base(addr, k, PCI_DEVFN(i, 0));
-			if (addr == 0 ||
-			    readl((u32 __iomem *)mmcfg_virt_addr) != val1) {
-				set_bit(i + 32*k, fallback_slots);
-				printk(KERN_NOTICE
-			"PCI: No mmconfig possible on %x:%x\n", k, i);
-			}
-			spin_unlock_irqrestore(&pci_config_lock, flags);
-		}
-	}
-}
-
-void __init pci_mmcfg_init(int type)
+int __init pci_mmcfg_arch_init(void)
 {
-	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
-		return;
-
-	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-	if ((pci_mmcfg_config_num == 0) ||
-	    (pci_mmcfg_config == NULL) ||
-	    (pci_mmcfg_config[0].address == 0))
-		return;
-
-	/* Only do this check when type 1 works. If it doesn't work
-	   assume we run on a Mac and always use MCFG */
-	if (type == 1 && !e820_all_mapped(pci_mmcfg_config[0].address,
-			pci_mmcfg_config[0].address + MMCONFIG_APER_MIN,
-			E820_RESERVED)) {
-		printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %lx is not E820-reserved\n",
-				(unsigned long)pci_mmcfg_config[0].address);
-		printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
-		return;
-	}
-
 	printk(KERN_INFO "PCI: Using MMCONFIG\n");
 	raw_pci_ops = &pci_mmcfg;
-	pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-
-	unreachable_devices();
+	return 1;
 }
Index: linux/arch/i386/pci/pci.h
===================================================================
--- linux.orig/arch/i386/pci/pci.h
+++ linux/arch/i386/pci/pci.h
@@ -94,3 +94,9 @@ extern void pci_pcbios_init(void);
 extern void pci_mmcfg_init(int type);
 extern void pcibios_sort(void);
 
+/* pci-mmconfig.c */
+
+#define PCI_MMCFG_MAX_CHECK_BUS 16
+extern DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
+
+extern int pci_mmcfg_arch_init(void);
Index: linux/arch/x86_64/pci/Makefile
===================================================================
--- linux.orig/arch/x86_64/pci/Makefile
+++ linux/arch/x86_64/pci/Makefile
@@ -11,7 +11,7 @@ obj-y		+= fixup.o init.o
 obj-$(CONFIG_ACPI)	+= acpi.o
 obj-y			+= legacy.o irq.o common.o early.o
 # mmconfig has a 64bit special
-obj-$(CONFIG_PCI_MMCONFIG) += mmconfig.o direct.o
+obj-$(CONFIG_PCI_MMCONFIG) += mmconfig.o direct.o mmconfig-shared.o
 
 obj-$(CONFIG_NUMA)	+= k8-bus.o
 
@@ -24,3 +24,4 @@ fixup-y  += ../../i386/pci/fixup.o
 i386-y  += ../../i386/pci/i386.o
 init-y += ../../i386/pci/init.o
 early-y += ../../i386/pci/early.o
+mmconfig-shared-y += ../../i386/pci/mmconfig-shared.o
Index: linux/arch/x86_64/pci/mmconfig.c
===================================================================
--- linux.orig/arch/x86_64/pci/mmconfig.c
+++ linux/arch/x86_64/pci/mmconfig.c
@@ -19,9 +19,7 @@
 
 /* Verify the first 16 busses. We assume that systems with more busses
    get MCFG right. */
-#define MAX_CHECK_BUS 16
-
-static DECLARE_BITMAP(fallback_slots, 32*MAX_CHECK_BUS);
+#define PCI_MMCFG_MAX_CHECK_BUS 16
 
 /* Static virtual mapping of the MMCONFIG aperture */
 struct mmcfg_virt {
@@ -63,8 +61,8 @@ static char __iomem *get_virt(unsigned i
 static char __iomem *pci_dev_base(unsigned int seg, unsigned int bus, unsigned int devfn)
 {
 	char __iomem *addr;
-	if (seg == 0 && bus < MAX_CHECK_BUS &&
-		test_bit(32*bus + PCI_SLOT(devfn), fallback_slots))
+	if (seg == 0 && bus < PCI_MMCFG_MAX_CHECK_BUS &&
+		test_bit(32*bus + PCI_SLOT(devfn), pci_mmcfg_fallback_slots))
 		return NULL;
 	addr = get_virt(seg, bus);
 	if (!addr)
@@ -135,63 +133,16 @@ static struct pci_raw_ops pci_mmcfg = {
 	.write =	pci_mmcfg_write,
 };
 
-/* K8 systems have some devices (typically in the builtin northbridge)
-   that are only accessible using type1
-   Normally this can be expressed in the MCFG by not listing them
-   and assigning suitable _SEGs, but this isn't implemented in some BIOS.
-   Instead try to discover all devices on bus 0 that are unreachable using MM
-   and fallback for them. */
-static __init void unreachable_devices(void)
-{
-	int i, k;
-	/* Use the max bus number from ACPI here? */
-	for (k = 0; k < MAX_CHECK_BUS; k++) {
-		for (i = 0; i < 32; i++) {
-			u32 val1;
-			char __iomem *addr;
-
-			pci_conf1_read(0, k, PCI_DEVFN(i,0), 0, 4, &val1);
-			if (val1 == 0xffffffff)
-				continue;
-			addr = pci_dev_base(0, k, PCI_DEVFN(i, 0));
-			if (addr == NULL|| readl(addr) != val1) {
-				set_bit(i + 32*k, fallback_slots);
-				printk(KERN_NOTICE "PCI: No mmconfig possible"
-				       " on device %02x:%02x\n", k, i);
-			}
-		}
-	}
-}
-
-void __init pci_mmcfg_init(int type)
+int __init pci_mmcfg_arch_init(void)
 {
 	int i;
-
-	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
-		return;
-
-	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-	if ((pci_mmcfg_config_num == 0) ||
-	    (pci_mmcfg_config == NULL) ||
-	    (pci_mmcfg_config[0].address == 0))
-		return;
-
-	/* Only do this check when type 1 works. If it doesn't work
-           assume we run on a Mac and always use MCFG */
-	if (type == 1 && !e820_all_mapped(pci_mmcfg_config[0].address,
-			pci_mmcfg_config[0].address + MMCONFIG_APER_MIN,
-			E820_RESERVED)) {
-		printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %lx is not E820-reserved\n",
-				(unsigned long)pci_mmcfg_config[0].address);
-		printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
-		return;
-	}
-
-	pci_mmcfg_virt = kmalloc(sizeof(*pci_mmcfg_virt) * pci_mmcfg_config_num, GFP_KERNEL);
+	pci_mmcfg_virt = kmalloc(sizeof(*pci_mmcfg_virt) *
+				 pci_mmcfg_config_num, GFP_KERNEL);
 	if (pci_mmcfg_virt == NULL) {
 		printk(KERN_ERR "PCI: Can not allocate memory for mmconfig structures\n");
-		return;
+		return 0;
 	}
+
 	for (i = 0; i < pci_mmcfg_config_num; ++i) {
 		pci_mmcfg_virt[i].cfg = &pci_mmcfg_config[i];
 		pci_mmcfg_virt[i].virt = ioremap_nocache(pci_mmcfg_config[i].address,
@@ -200,14 +151,11 @@ void __init pci_mmcfg_init(int type)
 			printk(KERN_ERR "PCI: Cannot map mmconfig aperture for "
 					"segment %d\n",
 				pci_mmcfg_config[i].pci_segment);
-			return;
+			return 0;
 		}
-		printk(KERN_INFO "PCI: Using MMCONFIG at %lx\n",
-			(unsigned long)pci_mmcfg_config[i].address);
+		printk(KERN_INFO "PCI: Using MMCONFIG at %Lx\n",
+				pci_mmcfg_config[i].address);
 	}
-
-	unreachable_devices();
-
 	raw_pci_ops = &pci_mmcfg;
-	pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
+	return 1;
 }
