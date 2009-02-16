Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZBPTcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZBPTcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZBPTca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:32:30 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:6561 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZBPTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:32:28 -0500
Subject: Re: [RFC] [PATCH] PCI mmconfig without ACPI
From: Ed Swierk <eswierk@aristanetworks.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20090204181738.GA16174@elte.hu>
References: <1233766786.16414.26.camel@localhost.localdomain>
	 <20090204181738.GA16174@elte.hu>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 11:32:21 -0800
Message-Id: <1234812741.28801.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another attempt at decoupling the setup of memory-mapped PCI
configuration space from ACPI.  I implemented your suggestions for
moving the ACPI-specific code to a separate file.  I left the definition
of struct acpi_mcfg_allocation alone, and created a new struct
pci_mcfg_allocation.  The former is now used only for parsing the actual
ACPI MCFG table, while the latter is used to store information about
mmcfg regions regardless of where they came from.

(This is still an RFC; the code is pretty much untested.)

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
@@ -1611,7 +1611,11 @@ config PCI_DOMAINS
 
 config PCI_MMCONFIG
 	bool "Support mmconfig PCI config space access"
-	depends on X86_64 && PCI && ACPI
+	depends on X86_64 && PCI
+
+config ACPI_MMCONFIG
+	def_bool y
+	depends on PCI_MMCONFIG && ACPI
 
 config DMAR
 	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
Index: linux-2.6.27.4/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.27.4.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6.27.4/arch/x86/kernel/acpi/boot.c
@@ -155,10 +155,9 @@ char *__init __acpi_map_table(unsigned l
 	return ((unsigned char *)base + offset);
 }
 
-#ifdef CONFIG_PCI_MMCONFIG
-/* The physical address of the MMCONFIG aperture.  Set from ACPI tables. */
-struct acpi_mcfg_allocation *pci_mmcfg_config;
-int pci_mmcfg_config_num;
+#ifdef CONFIG_ACPI_MMCONFIG
+extern __init int extend_mmcfg(int num);
+extern __init void fill_one_mmcfg(u64 addr, int segment, int start, int end);
 
 static int __init acpi_mcfg_oem_check(struct acpi_table_mcfg *mcfg)
 {
@@ -170,53 +169,55 @@ static int __init acpi_mcfg_oem_check(st
 
 int __init acpi_parse_mcfg(struct acpi_table_header *header)
 {
-	struct acpi_table_mcfg *mcfg;
+	struct acpi_mcfg_allocation *config;
+	int config_num;
 	unsigned long i;
-	int config_size;
 
 	if (!header)
 		return -EINVAL;
 
-	mcfg = (struct acpi_table_mcfg *)header;
-
 	/* how many config structures do we have */
-	pci_mmcfg_config_num = 0;
+	config_num = 0;
 	i = header->length - sizeof(struct acpi_table_mcfg);
 	while (i >= sizeof(struct acpi_mcfg_allocation)) {
-		++pci_mmcfg_config_num;
+		++config_num;
 		i -= sizeof(struct acpi_mcfg_allocation);
 	};
-	if (pci_mmcfg_config_num == 0) {
+	if (config_num == 0) {
 		printk(KERN_ERR PREFIX "MMCONFIG has no entries\n");
 		return -ENODEV;
 	}
 
-	config_size = pci_mmcfg_config_num * sizeof(*pci_mmcfg_config);
-	pci_mmcfg_config = kmalloc(config_size, GFP_KERNEL);
-	if (!pci_mmcfg_config) {
-		printk(KERN_WARNING PREFIX
-		       "No memory for MCFG config tables\n");
-		return -ENOMEM;
-	}
-
-	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
+	acpi_mcfg_oem_check((struct acpi_table_mcfg *)header);
 
-	acpi_mcfg_oem_check(mcfg);
+	config = (struct acpi_mcfg_allocation *)(
+		(u8 *)header + sizeof(struct acpi_table_mcfg *));
 
-	for (i = 0; i < pci_mmcfg_config_num; ++i) {
-		if ((pci_mmcfg_config[i].address > 0xFFFFFFFF) &&
+	for (i = 0; i < config_num; ++i) {
+		if ((config[i].address > 0xFFFFFFFF) &&
 		    !acpi_mcfg_64bit_base_addr) {
 			printk(KERN_ERR PREFIX
 			       "MMCONFIG not in low 4GB of memory\n");
-			kfree(pci_mmcfg_config);
-			pci_mmcfg_config_num = 0;
 			return -ENODEV;
 		}
 	}
 
+	if (!extend_mmcfg(config_num)) {
+		printk(KERN_WARNING PREFIX
+		       "No memory for MCFG config tables\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < config_num; ++i) {
+		fill_one_mmcfg(config[i].address,
+			       config[i].pci_segment,
+			       config[i].start_bus_number,
+			       config[i].end_bus_number);
+	}
+
 	return 0;
 }
-#endif				/* CONFIG_PCI_MMCONFIG */
+#endif				/* CONFIG_ACPI_MMCONFIG */
 
 #ifdef CONFIG_X86_LOCAL_APIC
 static int __init acpi_parse_madt(struct acpi_table_header *table)
Index: linux-2.6.27.4/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.27.4.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6.27.4/arch/x86/pci/mmconfig-shared.c
@@ -4,7 +4,6 @@
  *
  * This code does:
  * - known chipset handling
- * - ACPI decoding and validation
  *
  * Per-architecture code takes care of the mappings and accesses
  * themselves.
@@ -19,6 +18,9 @@
 
 #include "pci.h"
 
+struct pci_mcfg_allocation *pci_mmcfg_config;
+int pci_mmcfg_config_num;
+
 /* aperture is up to 256MB but BIOS may reserve less */
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
 #define MMCONFIG_APER_MAX	(256 * 1024*1024)
@@ -26,9 +28,9 @@
 /* Indicate if the mmcfg resources have been placed into the resource table. */
 static int __initdata pci_mmcfg_resources_inserted;
 
-static __init int extend_mmcfg(int num)
+__init int extend_mmcfg(int num)
 {
-	struct acpi_mcfg_allocation *new;
+	struct pci_mcfg_allocation *new;
 	int new_num = pci_mmcfg_config_num + num;
 
 	new = kzalloc(sizeof(pci_mmcfg_config[0]) * new_num, GFP_KERNEL);
@@ -45,7 +47,7 @@ static __init int extend_mmcfg(int num)
 	return 0;
 }
 
-static __init void fill_one_mmcfg(u64 addr, int segment, int start, int end)
+__init void fill_one_mmcfg(u64 addr, int segment, int start, int end)
 {
 	int i = pci_mmcfg_config_num;
 
@@ -187,8 +189,12 @@ static const char __init *pci_mmcfg_nvid
 	/*
 	 * do check if amd fam10h already took over
 	 */
-	if (!acpi_disabled || pci_mmcfg_config_num || mcp55_checked)
+	if (pci_mmcfg_config_num || mcp55_checked)
+		return NULL;
+#ifdef CONFIG_ACPI_MMCONFIG
+	if (!acpi_disabled)
 		return NULL;
+#endif
 
 	mcp55_checked = true;
 	for (bus = 0; bus < 256; bus++) {
@@ -346,7 +352,7 @@ static void __init pci_mmcfg_insert_reso
 
 	names = (void *)&res[pci_mmcfg_config_num];
 	for (i = 0; i < pci_mmcfg_config_num; i++, res++) {
-		struct acpi_mcfg_allocation *cfg = &pci_mmcfg_config[i];
+		struct pci_mcfg_allocation *cfg = &pci_mmcfg_config[i];
 		num_buses = cfg->end_bus_number - cfg->start_bus_number + 1;
 		res->name = names;
 		snprintf(names, PCI_MMCFG_RESOURCE_NAME_LEN,
@@ -363,165 +369,6 @@ static void __init pci_mmcfg_insert_reso
 	pci_mmcfg_resources_inserted = 1;
 }
 
-static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
-					      void *data)
-{
-	struct resource *mcfg_res = data;
-	struct acpi_resource_address64 address;
-	acpi_status status;
-
-	if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
-		struct acpi_resource_fixed_memory32 *fixmem32 =
-			&res->data.fixed_memory32;
-		if (!fixmem32)
-			return AE_OK;
-		if ((mcfg_res->start >= fixmem32->address) &&
-		    (mcfg_res->end < (fixmem32->address +
-				      fixmem32->address_length))) {
-			mcfg_res->flags = 1;
-			return AE_CTRL_TERMINATE;
-		}
-	}
-	if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
-	    (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
-		return AE_OK;
-
-	status = acpi_resource_to_address64(res, &address);
-	if (ACPI_FAILURE(status) ||
-	   (address.address_length <= 0) ||
-	   (address.resource_type != ACPI_MEMORY_RANGE))
-		return AE_OK;
-
-	if ((mcfg_res->start >= address.minimum) &&
-	    (mcfg_res->end < (address.minimum + address.address_length))) {
-		mcfg_res->flags = 1;
-		return AE_CTRL_TERMINATE;
-	}
-	return AE_OK;
-}
-
-static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
-		void *context, void **rv)
-{
-	struct resource *mcfg_res = context;
-
-	acpi_walk_resources(handle, METHOD_NAME__CRS,
-			    check_mcfg_resource, context);
-
-	if (mcfg_res->flags)
-		return AE_CTRL_TERMINATE;
-
-	return AE_OK;
-}
-
-static int __init is_acpi_reserved(u64 start, u64 end, unsigned not_used)
-{
-	struct resource mcfg_res;
-
-	mcfg_res.start = start;
-	mcfg_res.end = end;
-	mcfg_res.flags = 0;
-
-	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
-
-	if (!mcfg_res.flags)
-		acpi_get_devices("PNP0C02", find_mboard_resource, &mcfg_res,
-				 NULL);
-
-	return mcfg_res.flags;
-}
-
-typedef int (*check_reserved_t)(u64 start, u64 end, unsigned type);
-
-static int __init is_mmconf_reserved(check_reserved_t is_reserved,
-		u64 addr, u64 size, int i,
-		typeof(pci_mmcfg_config[0]) *cfg, int with_e820)
-{
-	u64 old_size = size;
-	int valid = 0;
-
-	while (!is_reserved(addr, addr + size - 1, E820_RESERVED)) {
-		size >>= 1;
-		if (size < (16UL<<20))
-			break;
-	}
-
-	if (size >= (16UL<<20) || size == old_size) {
-		printk(KERN_NOTICE
-		       "PCI: MCFG area at %Lx reserved in %s\n",
-			addr, with_e820?"E820":"ACPI motherboard resources");
-		valid = 1;
-
-		if (old_size != size) {
-			/* update end_bus_number */
-			cfg->end_bus_number = cfg->start_bus_number + ((size>>20) - 1);
-			printk(KERN_NOTICE "PCI: updated MCFG configuration %d: base %lx "
-			       "segment %hu buses %u - %u\n",
-			       i, (unsigned long)cfg->address, cfg->pci_segment,
-			       (unsigned int)cfg->start_bus_number,
-			       (unsigned int)cfg->end_bus_number);
-		}
-	}
-
-	return valid;
-}
-
-static void __init pci_mmcfg_reject_broken(int early)
-{
-	typeof(pci_mmcfg_config[0]) *cfg;
-	int i;
-
-	if ((pci_mmcfg_config_num == 0) ||
-	    (pci_mmcfg_config == NULL) ||
-	    (pci_mmcfg_config[0].address == 0))
-		return;
-
-	for (i = 0; i < pci_mmcfg_config_num; i++) {
-		int valid = 0;
-		u64 addr, size;
-
-		cfg = &pci_mmcfg_config[i];
-		addr = cfg->start_bus_number;
-		addr <<= 20;
-		addr += cfg->address;
-		size = cfg->end_bus_number + 1 - cfg->start_bus_number;
-		size <<= 20;
-		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
-		       "segment %hu buses %u - %u\n",
-		       i, (unsigned long)cfg->address, cfg->pci_segment,
-		       (unsigned int)cfg->start_bus_number,
-		       (unsigned int)cfg->end_bus_number);
-
-		if (!early)
-			valid = is_mmconf_reserved(is_acpi_reserved, addr, size, i, cfg, 0);
-
-		if (valid)
-			continue;
-
-		if (!early)
-			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
-			       " reserved in ACPI motherboard resources\n",
-			       cfg->address);
-
-		/* Don't try to do this check unless configuration
-		   type 1 is available. how about type 2 ?*/
-		if (raw_pci_ops)
-			valid = is_mmconf_reserved(e820_all_mapped, addr, size, i, cfg, 1);
-
-		if (!valid)
-			goto reject;
-	}
-
-	return;
-
-reject:
-	printk(KERN_INFO "PCI: Not using MMCONFIG.\n");
-	pci_mmcfg_arch_free();
-	kfree(pci_mmcfg_config);
-	pci_mmcfg_config = NULL;
-	pci_mmcfg_config_num = 0;
-}
-
 static int __initdata known_bridge;
 
 static void __init __pci_mmcfg_init(int early)
@@ -543,10 +390,7 @@ static void __init __pci_mmcfg_init(int 
 			known_bridge = 1;
 	}
 
-	if (!known_bridge)
-		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-
-	pci_mmcfg_reject_broken(early);
+	pci_detect_acpi_mmcfg(early);
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
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
@@ -159,3 +159,23 @@ static inline void mmio_config_writel(vo
 {
 	asm volatile("movl %%eax,(%1)" :: "a" (val), "r" (pos) : "memory");
 }
+
+#ifdef CONFIG_PCI_MMCONFIG
+
+struct pci_mcfg_allocation {
+	u64 address;		/* Base address, processor-relative */
+	u16 pci_segment;	/* PCI segment group number */
+	u8 start_bus_number;	/* Starting PCI Bus number */
+	u8 end_bus_number;	/* Final PCI Bus number */
+};
+
+extern struct pci_mcfg_allocation *pci_mmcfg_config;
+extern int pci_mmcfg_config_num;
+
+#endif
+
+#ifdef CONFIG_ACPI_MMCONFIG
+extern void __init pci_detect_acpi_mmcfg(int early);
+#else
+inline static void __init pci_detect_acpi_mmcfg(int early) { }
+#endif
Index: linux-2.6.27.4/arch/x86/pci/mmconfig_32.c
===================================================================
--- linux-2.6.27.4.orig/arch/x86/pci/mmconfig_32.c
+++ linux-2.6.27.4/arch/x86/pci/mmconfig_32.c
@@ -27,7 +27,7 @@ static int mmcfg_last_accessed_cpu;
  */
 static u32 get_base_addr(unsigned int seg, int bus, unsigned devfn)
 {
-	struct acpi_mcfg_allocation *cfg;
+	struct pci_mcfg_allocation *cfg;
 	int cfg_num;
 
 	for (cfg_num = 0; cfg_num < pci_mmcfg_config_num; cfg_num++) {
Index: linux-2.6.27.4/arch/x86/pci/mmconfig_64.c
===================================================================
--- linux-2.6.27.4.orig/arch/x86/pci/mmconfig_64.c
+++ linux-2.6.27.4/arch/x86/pci/mmconfig_64.c
@@ -7,7 +7,6 @@
 
 #include <linux/pci.h>
 #include <linux/init.h>
-#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <asm/e820.h>
 
@@ -15,14 +14,14 @@
 
 /* Static virtual mapping of the MMCONFIG aperture */
 struct mmcfg_virt {
-	struct acpi_mcfg_allocation *cfg;
+	struct pci_mcfg_allocation *cfg;
 	char __iomem *virt;
 };
 static struct mmcfg_virt *pci_mmcfg_virt;
 
 static char __iomem *get_virt(unsigned int seg, unsigned bus)
 {
-	struct acpi_mcfg_allocation *cfg;
+	struct pci_mcfg_allocation *cfg;
 	int cfg_num;
 
 	for (cfg_num = 0; cfg_num < pci_mmcfg_config_num; cfg_num++) {
@@ -110,7 +109,7 @@ static struct pci_raw_ops pci_mmcfg = {
 	.write =	pci_mmcfg_write,
 };
 
-static void __iomem * __init mcfg_ioremap(struct acpi_mcfg_allocation *cfg)
+static void __iomem * __init mcfg_ioremap(struct pci_mcfg_allocation *cfg)
 {
 	void __iomem *addr;
 	u64 start, size;
Index: linux-2.6.27.4/arch/x86/pci/mmconfig-acpi.c
===================================================================
--- /dev/null
+++ linux-2.6.27.4/arch/x86/pci/mmconfig-acpi.c
@@ -0,0 +1,173 @@
+/*
+ * mmconfig-acpi.c   - Low-level direct PCI config space access via
+ *                     MMCONFIG - setup from ACPI MCFG table.
+ *
+ * This code does:
+ * - ACPI decoding and validation
+ */
+
+#include <linux/acpi.h>
+#include <asm/e820.h>
+
+#include "pci.h"
+
+static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
+					      void *data)
+{
+	struct resource *mcfg_res = data;
+	struct acpi_resource_address64 address;
+	acpi_status status;
+
+	if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
+		struct acpi_resource_fixed_memory32 *fixmem32 =
+			&res->data.fixed_memory32;
+		if (!fixmem32)
+			return AE_OK;
+		if ((mcfg_res->start >= fixmem32->address) &&
+		    (mcfg_res->end < (fixmem32->address +
+				      fixmem32->address_length))) {
+			mcfg_res->flags = 1;
+			return AE_CTRL_TERMINATE;
+		}
+	}
+	if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
+	    (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
+		return AE_OK;
+
+	status = acpi_resource_to_address64(res, &address);
+	if (ACPI_FAILURE(status) ||
+	   (address.address_length <= 0) ||
+	   (address.resource_type != ACPI_MEMORY_RANGE))
+		return AE_OK;
+
+	if ((mcfg_res->start >= address.minimum) &&
+	    (mcfg_res->end < (address.minimum + address.address_length))) {
+		mcfg_res->flags = 1;
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
+		void *context, void **rv)
+{
+	struct resource *mcfg_res = context;
+
+	acpi_walk_resources(handle, METHOD_NAME__CRS,
+			    check_mcfg_resource, context);
+
+	if (mcfg_res->flags)
+		return AE_CTRL_TERMINATE;
+
+	return AE_OK;
+}
+
+static int __init is_acpi_reserved(u64 start, u64 end, unsigned not_used)
+{
+	struct resource mcfg_res;
+
+	mcfg_res.start = start;
+	mcfg_res.end = end;
+	mcfg_res.flags = 0;
+
+	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
+
+	if (!mcfg_res.flags)
+		acpi_get_devices("PNP0C02", find_mboard_resource, &mcfg_res,
+				 NULL);
+
+	return mcfg_res.flags;
+}
+
+typedef int (*check_reserved_t)(u64 start, u64 end, unsigned type);
+
+static int __init is_mmconf_reserved(check_reserved_t is_reserved,
+		u64 addr, u64 size, int i,
+		typeof(pci_mmcfg_config[0]) *cfg, int with_e820)
+{
+	u64 old_size = size;
+	int valid = 0;
+
+	while (!is_reserved(addr, addr + size - 1, E820_RESERVED)) {
+		size >>= 1;
+		if (size < (16UL<<20))
+			break;
+	}
+
+	if (size >= (16UL<<20) || size == old_size) {
+		printk(KERN_NOTICE
+		       "PCI: MCFG area at %Lx reserved in %s\n",
+			addr, with_e820?"E820":"ACPI motherboard resources");
+		valid = 1;
+
+		if (old_size != size) {
+			/* update end_bus_number */
+			cfg->end_bus_number = cfg->start_bus_number + ((size>>20) - 1);
+			printk(KERN_NOTICE "PCI: updated MCFG configuration %d: base %lx "
+			       "segment %hu buses %u - %u\n",
+			       i, (unsigned long)cfg->address, cfg->pci_segment,
+			       (unsigned int)cfg->start_bus_number,
+			       (unsigned int)cfg->end_bus_number);
+		}
+	}
+
+	return valid;
+}
+
+void __init pci_detect_acpi_mmcfg(int early)
+{
+	typeof(pci_mmcfg_config[0]) *cfg;
+	int i;
+
+	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+
+	if ((pci_mmcfg_config_num == 0) ||
+	    (pci_mmcfg_config == NULL) ||
+	    (pci_mmcfg_config[0].address == 0))
+		return;
+
+	for (i = 0; i < pci_mmcfg_config_num; i++) {
+		int valid = 0;
+		u64 addr, size;
+
+		cfg = &pci_mmcfg_config[i];
+		addr = cfg->start_bus_number;
+		addr <<= 20;
+		addr += cfg->address;
+		size = cfg->end_bus_number + 1 - cfg->start_bus_number;
+		size <<= 20;
+		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
+		       "segment %hu buses %u - %u\n",
+		       i, (unsigned long)cfg->address, cfg->pci_segment,
+		       (unsigned int)cfg->start_bus_number,
+		       (unsigned int)cfg->end_bus_number);
+
+		if (!early)
+			valid = is_mmconf_reserved(is_acpi_reserved, addr, size, i, cfg, 0);
+
+		if (valid)
+			continue;
+
+		if (!early)
+			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
+			       " reserved in ACPI motherboard resources\n",
+			       cfg->address);
+
+		/* Don't try to do this check unless configuration
+		   type 1 is available. how about type 2 ?*/
+		if (raw_pci_ops)
+			valid = is_mmconf_reserved(e820_all_mapped, addr, size, i, cfg, 1);
+
+		if (!valid)
+			goto reject;
+	}
+
+	return;
+
+reject:
+	printk(KERN_INFO "PCI: Not using MMCONFIG.\n");
+	pci_mmcfg_arch_free();
+	kfree(pci_mmcfg_config);
+	pci_mmcfg_config = NULL;
+	pci_mmcfg_config_num = 0;
+}


