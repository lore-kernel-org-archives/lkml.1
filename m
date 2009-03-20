Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbZCTDzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbZCTDzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZCTDzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:55:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:40224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbZCTDzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:55:44 -0400
Message-ID: <49C313B7.9060704@kernel.org>
Date: Thu, 19 Mar 2009 20:55:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/pci: host mmconfig detect clean up v3 - resend
References: <20090205181505.GB5661@elte.hu> <20090319193218.445ce0ca@hobbes.lan>
In-Reply-To: <20090319193218.445ce0ca@hobbes.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: not assume one place for mmconfig in nb

prepare for following case: amd fam10h + mcp55
CPU MSR has some range, mcp55 pci config will have another one.

also prepare for mcp55 + io55 system. every one will have one range.

if it s mcp55 detect duties to execlude range that is used by CPU MSR
aka, if CPU state bus 0-255, range in mcp55 need to be dropped.
because HW in CPU will not route that mcp55 mmconfig to handle it.

v2: fix e7520 exit path
v3: make it could support
   PCI MMCONFIG 0 [00-3f]
   PCI MMCONFIG 0 [40-7f]
   PCI MMCONFIG 0 [80-ff]

Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

---
 arch/x86/pci/mmconfig-shared.c |  161 +++++++++++++++++++++++++++--------------
 arch/x86/pci/mmconfig_64.c     |   15 ++-
 2 files changed, 118 insertions(+), 58 deletions(-)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
+#include <linux/sort.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
 
@@ -24,24 +25,49 @@
 /* Indicate if the mmcfg resources have been placed into the resource table. */
 static int __initdata pci_mmcfg_resources_inserted;
 
+static __init int extend_mmcfg(int num)
+{
+	struct acpi_mcfg_allocation *new;
+	int new_num = pci_mmcfg_config_num + num;
+
+	new = kzalloc(sizeof(pci_mmcfg_config[0]) * new_num, GFP_KERNEL);
+	if (!new)
+		return -1;
+
+	if (pci_mmcfg_config) {
+		memcpy(new, pci_mmcfg_config,
+			 sizeof(pci_mmcfg_config[0]) * new_num);
+		kfree(pci_mmcfg_config);
+	}
+	pci_mmcfg_config = new;
+
+	return 0;
+}
+
+static __init void fill_one_mmcfg(u64 addr, int segment, int start, int end)
+{
+	int i = pci_mmcfg_config_num;
+
+	pci_mmcfg_config_num++;
+	pci_mmcfg_config[i].address = addr;
+	pci_mmcfg_config[i].pci_segment = segment;
+	pci_mmcfg_config[i].start_bus_number = start;
+	pci_mmcfg_config[i].end_bus_number = end;
+}
+
 static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
 	raw_pci_ops->read(0, 0, PCI_DEVFN(0, 0), 0xce, 2, &win);
 
 	win = win & 0xf000;
-	if(win == 0x0000 || win == 0xf000)
-		pci_mmcfg_config_num = 0;
-	else {
-		pci_mmcfg_config_num = 1;
-		pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
-		if (!pci_mmcfg_config)
-			return NULL;
-		pci_mmcfg_config[0].address = win << 16;
-		pci_mmcfg_config[0].pci_segment = 0;
-		pci_mmcfg_config[0].start_bus_number = 0;
-		pci_mmcfg_config[0].end_bus_number = 255;
-	}
+	if (win == 0x0000 || win == 0xf000)
+		return NULL;
+
+	if (extend_mmcfg(1) == -1)
+		return NULL;
+
+	fill_one_mmcfg(win << 16, 0, 0, 255);
 
 	return "Intel Corporation E7520 Memory Controller Hub";
 }
@@ -50,13 +76,11 @@ static const char __init *pci_mmcfg_inte
 {
 	u32 pciexbar, mask = 0, len = 0;
 
-	pci_mmcfg_config_num = 1;
-
 	raw_pci_ops->read(0, 0, PCI_DEVFN(0, 0), 0x48, 4, &pciexbar);
 
 	/* Enable bit */
 	if (!(pciexbar & 1))
-		pci_mmcfg_config_num = 0;
+		return NULL;
 
 	/* Size bits */
 	switch ((pciexbar >> 1) & 3) {
@@ -73,28 +97,23 @@ static const char __init *pci_mmcfg_inte
 		len  = 0x04000000U;
 		break;
 	default:
-		pci_mmcfg_config_num = 0;
+		return NULL;
 	}
 
 	/* Errata #2, things break when not aligned on a 256Mb boundary */
 	/* Can only happen in 64M/128M mode */
 
 	if ((pciexbar & mask) & 0x0fffffffU)
-		pci_mmcfg_config_num = 0;
+		return NULL;
 
 	/* Don't hit the APIC registers and their friends */
 	if ((pciexbar & mask) >= 0xf0000000U)
-		pci_mmcfg_config_num = 0;
+		return NULL;
 
-	if (pci_mmcfg_config_num) {
-		pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
-		if (!pci_mmcfg_config)
-			return NULL;
-		pci_mmcfg_config[0].address = pciexbar & mask;
-		pci_mmcfg_config[0].pci_segment = 0;
-		pci_mmcfg_config[0].start_bus_number = 0;
-		pci_mmcfg_config[0].end_bus_number = (len >> 20) - 1;
-	}
+	if (extend_mmcfg(1) == -1)
+		return NULL;
+
+	fill_one_mmcfg(pciexbar & mask, 0, 0, (len >> 20) - 1);
 
 	return "Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub";
 }
@@ -138,18 +157,11 @@ static const char __init *pci_mmcfg_amd_
 		busnbits = 8;
 	}
 
-	pci_mmcfg_config_num = (1 << segnbits);
-	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]) *
-				   pci_mmcfg_config_num, GFP_KERNEL);
-	if (!pci_mmcfg_config)
+	if (extend_mmcfg(1 << segnbits) == -1)
 		return NULL;
 
-	for (i = 0; i < (1 << segnbits); i++) {
-		pci_mmcfg_config[i].address = base + (1<<28) * i;
-		pci_mmcfg_config[i].pci_segment = i;
-		pci_mmcfg_config[i].start_bus_number = 0;
-		pci_mmcfg_config[i].end_bus_number = (1 << busnbits) - 1;
-	}
+	for (i = 0; i < (1 << segnbits); i++)
+		fill_one_mmcfg(base + (1<<28) * i, i, 0, (1 << busnbits) - 1);
 
 	return "AMD Family 10h NB";
 }
@@ -173,6 +185,48 @@ static struct pci_mmcfg_hostbridge_probe
 	  0x1200, pci_mmcfg_amd_fam10h },
 };
 
+static int __init cmp_mmcfg(const void *x1, const void *x2)
+{
+	const typeof(pci_mmcfg_config[0]) *m1 = x1;
+	const typeof(pci_mmcfg_config[0]) *m2 = x2;
+	int start1, start2;
+
+	start1 = m1->start_bus_number;
+	start2 = m2->start_bus_number;
+
+	return start1 - start2;
+}
+
+static void __init pci_mmcfg_check_end_bus_number(void)
+{
+	int i;
+	typeof(pci_mmcfg_config[0]) *cfg, *cfgx;
+
+	/* sort them at first */
+	sort(pci_mmcfg_config, pci_mmcfg_config_num,
+		 sizeof(pci_mmcfg_config[0]), cmp_mmcfg, NULL);
+
+	/* last one*/
+	if (pci_mmcfg_config_num > 0) {
+		i = pci_mmcfg_config_num - 1;
+		cfg = &pci_mmcfg_config[i];
+		if (cfg->end_bus_number < cfg->start_bus_number)
+			cfg->end_bus_number = 255;
+	}
+
+	/* don't overlap please */
+	for (i = 0; i < pci_mmcfg_config_num - 1; i++) {
+		cfg = &pci_mmcfg_config[i];
+		cfgx = &pci_mmcfg_config[i+1];
+
+		if (cfg->end_bus_number < cfg->start_bus_number)
+			cfg->end_bus_number = 255;
+
+		if (cfg->end_bus_number >= cfgx->start_bus_number)
+			cfg->end_bus_number = cfgx->start_bus_number - 1;
+	}
+}
+
 static int __init pci_mmcfg_check_hostbridge(void)
 {
 	u32 l;
@@ -186,31 +240,33 @@ static int __init pci_mmcfg_check_hostbr
 
 	pci_mmcfg_config_num = 0;
 	pci_mmcfg_config = NULL;
-	name = NULL;
 
-	for (i = 0; !name && i < ARRAY_SIZE(pci_mmcfg_probes); i++) {
+	for (i = 0; i < ARRAY_SIZE(pci_mmcfg_probes); i++) {
 		bus =  pci_mmcfg_probes[i].bus;
 		devfn = pci_mmcfg_probes[i].devfn;
 		raw_pci_ops->read(0, bus, devfn, 0, 4, &l);
 		vendor = l & 0xffff;
 		device = (l >> 16) & 0xffff;
 
+		name = NULL;
 		if (pci_mmcfg_probes[i].vendor == vendor &&
 		    pci_mmcfg_probes[i].device == device)
 			name = pci_mmcfg_probes[i].probe();
-	}
 
-	if (name) {
-		printk(KERN_INFO "PCI: Found %s %s MMCONFIG support.\n",
-		       name, pci_mmcfg_config_num ? "with" : "without");
+		if (name)
+			printk(KERN_INFO "PCI: Found %s with MMCONFIG support.\n",
+			       name);
 	}
 
-	return name != NULL;
+	/* some end_bus_number is crazy, fix it */
+	pci_mmcfg_check_end_bus_number();
+
+	return pci_mmcfg_config_num != 0;
 }
 
 static void __init pci_mmcfg_insert_resources(void)
 {
-#define PCI_MMCFG_RESOURCE_NAME_LEN 19
+#define PCI_MMCFG_RESOURCE_NAME_LEN 24
 	int i;
 	struct resource *res;
 	char *names;
@@ -228,9 +284,10 @@ static void __init pci_mmcfg_insert_reso
 		struct acpi_mcfg_allocation *cfg = &pci_mmcfg_config[i];
 		num_buses = cfg->end_bus_number - cfg->start_bus_number + 1;
 		res->name = names;
-		snprintf(names, PCI_MMCFG_RESOURCE_NAME_LEN, "PCI MMCONFIG %u",
-			 cfg->pci_segment);
-		res->start = cfg->address;
+		snprintf(names, PCI_MMCFG_RESOURCE_NAME_LEN,
+			 "PCI MMCONFIG %u [%02x-%02x]", cfg->pci_segment,
+			 cfg->start_bus_number, cfg->end_bus_number);
+		res->start = cfg->address + (cfg->start_bus_number << 20);
 		res->end = res->start + (num_buses << 20) - 1;
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		insert_resource(&iomem_resource, res);
@@ -354,8 +411,6 @@ static void __init pci_mmcfg_reject_brok
 	    (pci_mmcfg_config[0].address == 0))
 		return;
 
-	cfg = &pci_mmcfg_config[0];
-
 	for (i = 0; i < pci_mmcfg_config_num; i++) {
 		int valid = 0;
 		u64 addr, size;
@@ -423,10 +478,10 @@ static void __init __pci_mmcfg_init(int
 			known_bridge = 1;
 	}
 
-	if (!known_bridge) {
+	if (!known_bridge)
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-		pci_mmcfg_reject_broken(early);
-	}
+
+	pci_mmcfg_reject_broken(early);
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
Index: linux-2.6/arch/x86/pci/mmconfig_64.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig_64.c
+++ linux-2.6/arch/x86/pci/mmconfig_64.c
@@ -112,13 +112,18 @@ static struct pci_raw_ops pci_mmcfg = {
 static void __iomem * __init mcfg_ioremap(struct acpi_mcfg_allocation *cfg)
 {
 	void __iomem *addr;
-	u32 size;
+	u64 start, size;
 
-	size = (cfg->end_bus_number + 1) << 20;
-	addr = ioremap_nocache(cfg->address, size);
+	start = cfg->start_bus_number;
+	start <<= 20;
+	start += cfg->address;
+	size = cfg->end_bus_number + 1 - cfg->start_bus_number;
+	size <<= 20;
+	addr = ioremap_nocache(start, size);
 	if (addr) {
 		printk(KERN_INFO "PCI: Using MMCONFIG at %Lx - %Lx\n",
-		       cfg->address, cfg->address + size - 1);
+		       start, start + size - 1);
+		addr -= cfg->start_bus_number << 20;
 	}
 	return addr;
 }
@@ -157,7 +162,7 @@ void __init pci_mmcfg_arch_free(void)
 
 	for (i = 0; i < pci_mmcfg_config_num; ++i) {
 		if (pci_mmcfg_virt[i].virt) {
-			iounmap(pci_mmcfg_virt[i].virt);
+			iounmap(pci_mmcfg_virt[i].virt + (pci_mmcfg_virt[i].cfg->start_bus_number << 20));
 			pci_mmcfg_virt[i].virt = NULL;
 			pci_mmcfg_virt[i].cfg = NULL;
 		}
