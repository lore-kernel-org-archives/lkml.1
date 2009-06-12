Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZFLEF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZFLEF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZFLEFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:05:18 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:63425 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbZFLEFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:05:16 -0400
Date: Fri, 12 Jun 2009 00:05:13 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] ACPI, PCI, x86: move MCFG parsing routine from ACPI to PCI file
Message-id: <alpine.LFD.2.00.0906120002540.4350@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Move acpi_parse_mcfg() from
arch/x86/kernel/acpi/boot.c to arch/x86/pci/mmconfig-shared.c
make it static, and re-name it to be pci_parse_mcfg().

Move associated globals and helper routine with it.

No functional change.

This code move is in preparation for SFI support,
which will allow the PCI code to find the MCFG table
on systems which do not support ACPI.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/pci_x86.h |    3 ++
 arch/x86/kernel/acpi/boot.c    |   66 ----------------------------------------
 arch/x86/pci/mmconfig-shared.c |   65 ++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi.h           |    3 --
 4 files changed, 67 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index e60fd3e..b399988 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -121,6 +121,9 @@ extern int __init pcibios_init(void);
 extern int __init pci_mmcfg_arch_init(void);
 extern void __init pci_mmcfg_arch_free(void);
 
+extern struct acpi_mcfg_allocation *pci_mmcfg_config;
+extern int pci_mmcfg_config_num;
+
 /*
  * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
  * on their northbrige except through the * %eax register. As such, you MUST
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 723989d..160439c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -121,72 +121,6 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
 	early_iounmap(map, size);
 }
 
-#ifdef CONFIG_PCI_MMCONFIG
-
-static int acpi_mcfg_64bit_base_addr __initdata = FALSE;
-
-/* The physical address of the MMCONFIG aperture.  Set from ACPI tables. */
-struct acpi_mcfg_allocation *pci_mmcfg_config;
-int pci_mmcfg_config_num;
-
-static int __init acpi_mcfg_oem_check(struct acpi_table_mcfg *mcfg)
-{
-	if (!strcmp(mcfg->header.oem_id, "SGI"))
-		acpi_mcfg_64bit_base_addr = TRUE;
-
-	return 0;
-}
-
-int __init acpi_parse_mcfg(struct acpi_table_header *header)
-{
-	struct acpi_table_mcfg *mcfg;
-	unsigned long i;
-	int config_size;
-
-	if (!header)
-		return -EINVAL;
-
-	mcfg = (struct acpi_table_mcfg *)header;
-
-	/* how many config structures do we have */
-	pci_mmcfg_config_num = 0;
-	i = header->length - sizeof(struct acpi_table_mcfg);
-	while (i >= sizeof(struct acpi_mcfg_allocation)) {
-		++pci_mmcfg_config_num;
-		i -= sizeof(struct acpi_mcfg_allocation);
-	};
-	if (pci_mmcfg_config_num == 0) {
-		printk(KERN_ERR PREFIX "MMCONFIG has no entries\n");
-		return -ENODEV;
-	}
-
-	config_size = pci_mmcfg_config_num * sizeof(*pci_mmcfg_config);
-	pci_mmcfg_config = kmalloc(config_size, GFP_KERNEL);
-	if (!pci_mmcfg_config) {
-		printk(KERN_WARNING PREFIX
-		       "No memory for MCFG config tables\n");
-		return -ENOMEM;
-	}
-
-	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
-
-	acpi_mcfg_oem_check(mcfg);
-
-	for (i = 0; i < pci_mmcfg_config_num; ++i) {
-		if ((pci_mmcfg_config[i].address > 0xFFFFFFFF) &&
-		    !acpi_mcfg_64bit_base_addr) {
-			printk(KERN_ERR PREFIX
-			       "MMCONFIG not in low 4GB of memory\n");
-			kfree(pci_mmcfg_config);
-			pci_mmcfg_config_num = 0;
-			return -ENODEV;
-		}
-	}
-
-	return 0;
-}
-#endif				/* CONFIG_PCI_MMCONFIG */
-
 #ifdef CONFIG_X86_LOCAL_APIC
 static int __init acpi_parse_madt(struct acpi_table_header *table)
 {
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 8766b0e..712443e 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -523,6 +523,69 @@ reject:
 
 static int __initdata known_bridge;
 
+static int acpi_mcfg_64bit_base_addr __initdata = FALSE;
+
+/* The physical address of the MMCONFIG aperture.  Set from ACPI tables. */
+struct acpi_mcfg_allocation *pci_mmcfg_config;
+int pci_mmcfg_config_num;
+
+static int __init acpi_mcfg_oem_check(struct acpi_table_mcfg *mcfg)
+{
+	if (!strcmp(mcfg->header.oem_id, "SGI"))
+		acpi_mcfg_64bit_base_addr = TRUE;
+
+	return 0;
+}
+
+static int __init pci_parse_mcfg(struct acpi_table_header *header)
+{
+	struct acpi_table_mcfg *mcfg;
+	unsigned long i;
+	int config_size;
+
+	if (!header)
+		return -EINVAL;
+
+	mcfg = (struct acpi_table_mcfg *)header;
+
+	/* how many config structures do we have */
+	pci_mmcfg_config_num = 0;
+	i = header->length - sizeof(struct acpi_table_mcfg);
+	while (i >= sizeof(struct acpi_mcfg_allocation)) {
+		++pci_mmcfg_config_num;
+		i -= sizeof(struct acpi_mcfg_allocation);
+	};
+	if (pci_mmcfg_config_num == 0) {
+		printk(KERN_ERR PREFIX "MMCONFIG has no entries\n");
+		return -ENODEV;
+	}
+
+	config_size = pci_mmcfg_config_num * sizeof(*pci_mmcfg_config);
+	pci_mmcfg_config = kmalloc(config_size, GFP_KERNEL);
+	if (!pci_mmcfg_config) {
+		printk(KERN_WARNING PREFIX
+		       "No memory for MCFG config tables\n");
+		return -ENOMEM;
+	}
+
+	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
+
+	acpi_mcfg_oem_check(mcfg);
+
+	for (i = 0; i < pci_mmcfg_config_num; ++i) {
+		if ((pci_mmcfg_config[i].address > 0xFFFFFFFF) &&
+		    !acpi_mcfg_64bit_base_addr) {
+			printk(KERN_ERR PREFIX
+			       "MMCONFIG not in low 4GB of memory\n");
+			kfree(pci_mmcfg_config);
+			pci_mmcfg_config_num = 0;
+			return -ENODEV;
+		}
+	}
+
+	return 0;
+}
+
 static void __init __pci_mmcfg_init(int early)
 {
 	/* MMCONFIG disabled */
@@ -543,7 +606,7 @@ static void __init __pci_mmcfg_init(int early)
 	}
 
 	if (!known_bridge)
-		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+		acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
 
 	pci_mmcfg_reject_broken(early);
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 88be890..73cb141 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -113,9 +113,6 @@ void acpi_irq_stats_init(void);
 extern u32 acpi_irq_handled;
 extern u32 acpi_irq_not_handled;
 
-extern struct acpi_mcfg_allocation *pci_mmcfg_config;
-extern int pci_mmcfg_config_num;
-
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
-- 
1.6.0.6

