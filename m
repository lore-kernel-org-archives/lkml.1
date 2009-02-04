Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZBDRAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZBDRAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZBDQ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:59:55 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:27505 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZBDQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:59:53 -0500
Subject: [RFC] [PATCH] PCI mmconfig without ACPI
From: Ed Swierk <eswierk@aristanetworks.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Content-Type: text/plain
Date: Wed, 04 Feb 2009 08:59:46 -0800
Message-Id: <1233766786.16414.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to use memory-mapped PCI configuration space on systems
with a supported PCI host bridge without CONFIG_ACPI.

The acpi_mcfg_allocation struct serves double duty, as a template for
parsing the ACPI MCFG table and also to store the mmconfig data, which
doesn't necessarily come from ACPI.  Should I leave the struct in
acpi/actbl1.h for ACPI parsing, and create a new one for storing
mmconfig data?

---
Index: linux-2.6.27.4/arch/x86/Kconfig
===================================================================
--- linux-2.6.27.4.orig/arch/x86/Kconfig
+++ linux-2.6.27.4/arch/x86/Kconfig
@@ -1599,7 +1599,7 @@ config PCI_DIRECT
 
 config PCI_MMCONFIG
 	def_bool y
-	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
+	depends on X86_32 && PCI && (PCI_GOMMCONFIG || PCI_GOANY)
 
 config PCI_OLPC
 	def_bool y
@@ -1611,7 +1611,7 @@ config PCI_DOMAINS
 
 config PCI_MMCONFIG
 	bool "Support mmconfig PCI config space access"
-	depends on X86_64 && PCI && ACPI
+	depends on X86_64 && PCI
 
 config DMAR
 	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
Index: linux-2.6.27.4/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.27.4.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6.27.4/arch/x86/kernel/acpi/boot.c
@@ -156,10 +156,6 @@ char *__init __acpi_map_table(unsigned l
 }
 
 #ifdef CONFIG_PCI_MMCONFIG
-/* The physical address of the MMCONFIG aperture.  Set from ACPI tables. */
-struct acpi_mcfg_allocation *pci_mmcfg_config;
-int pci_mmcfg_config_num;
-
 static int __init acpi_mcfg_oem_check(struct acpi_table_mcfg *mcfg)
 {
 	if (!strcmp(mcfg->header.oem_id, "SGI"))
Index: linux-2.6.27.4/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.27.4.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6.27.4/arch/x86/pci/mmconfig-shared.c
@@ -18,6 +18,10 @@
 
 #include "pci.h"
 
+/* The physical address of the MMCONFIG aperture.  Set from ACPI tables. */
+struct acpi_mcfg_allocation *pci_mmcfg_config;
+int pci_mmcfg_config_num;
+
 /* aperture is up to 256MB but BIOS may reserve less */
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
 #define MMCONFIG_APER_MAX	(256 * 1024*1024)
@@ -264,6 +268,8 @@ static void __init pci_mmcfg_insert_reso
 	pci_mmcfg_resources_inserted = 1;
 }
 
+#ifdef CONFIG_ACPI
+
 static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
 					      void *data)
 {
@@ -425,6 +431,8 @@ reject:
 	pci_mmcfg_config_num = 0;
 }
 
+#endif
+
 static int __initdata known_bridge;
 
 static void __init __pci_mmcfg_init(int early)
@@ -446,10 +454,12 @@ static void __init __pci_mmcfg_init(int 
 			known_bridge = 1;
 	}
 
+#ifdef CONFIG_ACPI
 	if (!known_bridge) {
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
 		pci_mmcfg_reject_broken(early);
 	}
+#endif
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
Index: linux-2.6.27.4/include/acpi/actbl1.h
===================================================================
--- linux-2.6.27.4.orig/include/acpi/actbl1.h
+++ linux-2.6.27.4/include/acpi/actbl1.h
@@ -1045,16 +1045,6 @@ struct acpi_table_mcfg {
 	u8 reserved[8];
 };
 
-/* Subtable */
-
-struct acpi_mcfg_allocation {
-	u64 address;		/* Base address, processor-relative */
-	u16 pci_segment;	/* PCI segment group number */
-	u8 start_bus_number;	/* Starting PCI Bus number */
-	u8 end_bus_number;	/* Final PCI Bus number */
-	u32 reserved;
-};
-
 /*******************************************************************************
  *
  * SBST - Smart Battery Specification Table
Index: linux-2.6.27.4/include/linux/acpi.h
===================================================================
--- linux-2.6.27.4.orig/include/linux/acpi.h
+++ linux-2.6.27.4/include/linux/acpi.h
@@ -118,9 +118,6 @@ int acpi_unregister_ioapic(acpi_handle h
 void acpi_irq_stats_init(void);
 extern u32 acpi_irq_handled;
 
-extern struct acpi_mcfg_allocation *pci_mmcfg_config;
-extern int pci_mmcfg_config_num;
-
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
Index: linux-2.6.27.4/arch/x86/pci/pci.h
===================================================================
--- linux-2.6.27.4.orig/arch/x86/pci/pci.h
+++ linux-2.6.27.4/arch/x86/pci/pci.h
@@ -159,3 +159,18 @@ static inline void mmio_config_writel(vo
 {
 	asm volatile("movl %%eax,(%1)" :: "a" (val), "r" (pos) : "memory");
 }
+
+#ifdef CONFIG_PCI_MMCONFIG
+
+struct acpi_mcfg_allocation {
+	u64 address;		/* Base address, processor-relative */
+	u16 pci_segment;	/* PCI segment group number */
+	u8 start_bus_number;	/* Starting PCI Bus number */
+	u8 end_bus_number;	/* Final PCI Bus number */
+	u32 reserved;
+};
+
+extern struct acpi_mcfg_allocation *pci_mmcfg_config;
+extern int pci_mmcfg_config_num;
+
+#endif


