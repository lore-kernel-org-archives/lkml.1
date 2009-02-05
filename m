Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbZBEC0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbZBEC0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZBEC0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:26:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:35497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZBEC03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:26:29 -0500
Message-ID: <498A4DFB.7040608@kernel.org>
Date: Wed, 04 Feb 2009 18:24:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ed Swierk <eswierk@aristanetworks.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: [PATCH] x86/pci: host mmconfig detect clean up v2
References: <1233765552.16414.6.camel@localhost.localdomain> <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com> <20090204212517.GM22608@elte.hu>
In-Reply-To: <20090204212517.GM22608@elte.hu>
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

Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

---
 arch/x86/pci/mmconfig-shared.c |   98 ++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 44 deletions(-)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -24,24 +24,49 @@
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
@@ -50,13 +75,11 @@ static const char __init *pci_mmcfg_inte
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
@@ -73,28 +96,23 @@ static const char __init *pci_mmcfg_inte
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
@@ -138,18 +156,11 @@ static const char __init *pci_mmcfg_amd_
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
@@ -186,26 +197,25 @@ static int __init pci_mmcfg_check_hostbr
 
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
+	return pci_mmcfg_config_num != 0;
 }
 
 static void __init pci_mmcfg_insert_resources(void)
