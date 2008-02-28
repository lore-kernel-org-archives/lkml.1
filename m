Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbYB1AbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbYB1AbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYB1Aa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:30:58 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60525 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbYB1Aa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:30:57 -0500
Date: Wed, 27 Feb 2008 16:39:52 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86 pci: remove checking type for mmconfig probe
To: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802271639.52958.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't need to check if it is type1 or type2. we can use raw_pci_ops dirctly.

also make pci_direct_conf1 static again.

anyway is there system with type 2 and mmconf support?

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 42f3e4c..739ce26 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -76,7 +76,7 @@ static int pci_conf1_write(unsigned int seg, unsigned int bus,
 
 #undef PCI_CONF1_ADDRESS
 
-struct pci_raw_ops pci_direct_conf1 = {
+static struct pci_raw_ops pci_direct_conf1 = {
 	.read =		pci_conf1_read,
 	.write =	pci_conf1_write,
 };
@@ -258,7 +258,8 @@ void __init pci_direct_init(int type)
 {
 	if (type == 0)
 		return;
-	printk(KERN_INFO "PCI: Using configuration type %d\n", type);
+	printk(KERN_INFO "PCI: Using configuration type %d for base access\n",
+		 type);
 	if (type == 1)
 		raw_pci_ops = &pci_direct_conf1;
 	else
@@ -275,8 +276,10 @@ int __init pci_direct_probe(void)
 	if (!region)
 		goto type2;
 
-	if (pci_check_type1())
+	if (pci_check_type1()) {
+		raw_pci_ops = &pci_direct_conf1;
 		return 1;
+	}
 	release_resource(region);
 
  type2:
@@ -290,7 +293,6 @@ int __init pci_direct_probe(void)
 		goto fail2;
 
 	if (pci_check_type2()) {
-		printk(KERN_INFO "PCI: Using configuration type 2\n");
 		raw_pci_ops = &pci_direct_conf2;
 		return 2;
 	}
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index 2080b04..b4083dc 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -6,12 +6,12 @@
    in the right sequence from here. */
 static __init int pci_access_init(void)
 {
-	int type __maybe_unused = 0;
-
 #ifdef CONFIG_PCI_DIRECT
+	int type = 0;
+
 	type = pci_direct_probe();
 #endif
-	pci_mmcfg_early_init(type);
+	pci_mmcfg_early_init();
 	if (raw_pci_ops)
 		return 0;
 #ifdef CONFIG_PCI_BIOS
@@ -26,7 +26,7 @@ static __init int pci_access_init(void)
 #ifdef CONFIG_PCI_DIRECT
 	pci_direct_init(type);
 #endif
-	if (!raw_pci_ops)
+	if (!raw_pci_ops && !raw_pci_ext_ops)
 		printk(KERN_ERR
 		"PCI: Fatal: No config space access function found\n");
 
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 1dbc101..16f610b 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -28,7 +28,7 @@ static int __initdata pci_mmcfg_resources_inserted;
 static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
-	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
+	raw_pci_ops->read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
 
 	win = win & 0xf000;
 	if(win == 0x0000 || win == 0xf000)
@@ -53,7 +53,7 @@ static const char __init *pci_mmcfg_intel_945(void)
 
 	pci_mmcfg_config_num = 1;
 
-	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+	raw_pci_ops->read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
 
 	/* Enable bit */
 	if (!(pciexbar & 1))
@@ -179,6 +179,9 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	int i;
 	const char *name;
 
+	if (!raw_pci_ops)
+		return 0;
+
 	pci_mmcfg_config_num = 0;
 	pci_mmcfg_config = NULL;
 	name = NULL;
@@ -186,7 +189,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	for (i = 0; !name && i < ARRAY_SIZE(pci_mmcfg_probes); i++) {
 		bus =  pci_mmcfg_probes[i].bus;
 		devfn = pci_mmcfg_probes[i].devfn;
-		pci_direct_conf1.read(0, bus, devfn, 0, 4, &l);
+		raw_pci_ops->read(0, bus, devfn, 0, 4, &l);
 		vendor = l & 0xffff;
 		device = (l >> 16) & 0xffff;
 
@@ -304,7 +307,7 @@ static int __init is_acpi_reserved(unsigned long start, unsigned long end)
 	return mcfg_res.flags;
 }
 
-static void __init pci_mmcfg_reject_broken(int type, int early)
+static void __init pci_mmcfg_reject_broken(int early)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
 	int i;
@@ -342,8 +345,8 @@ static void __init pci_mmcfg_reject_broken(int type, int early)
 			       " reserved in ACPI motherboard resources\n",
 			       cfg->address);
 		/* Don't try to do this check unless configuration
-		   type 1 is available. */
-		if (type == 1 && e820_all_mapped(cfg->address,
+		   type 1 is available. how about type 2 ?*/
+		if (raw_pci_ops && e820_all_mapped(cfg->address,
 						  cfg->address + size - 1,
 						  E820_RESERVED)) {
 			printk(KERN_NOTICE
@@ -368,7 +371,7 @@ reject:
 
 static int __initdata known_bridge;
 
-void __init __pci_mmcfg_init(int type, int early)
+void __init __pci_mmcfg_init(int early)
 {
 	/* MMCONFIG disabled */
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
@@ -382,7 +385,7 @@ void __init __pci_mmcfg_init(int type, int early)
 	if (known_bridge)
 		return;
 
-	if (early && type == 1) {
+	if (early) {
 		if (pci_mmcfg_check_hostbridge())
 			known_bridge = 1;
 #if 0
@@ -394,7 +397,7 @@ void __init __pci_mmcfg_init(int type, int early)
 
 	if (!known_bridge) {
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-		pci_mmcfg_reject_broken(type, early);
+		pci_mmcfg_reject_broken(early);
 	}
 
 	if ((pci_mmcfg_config_num == 0) ||
@@ -415,19 +418,14 @@ void __init __pci_mmcfg_init(int type, int early)
 	}
 }
 
-void __init pci_mmcfg_early_init(int type)
+void __init pci_mmcfg_early_init(void)
 {
-	__pci_mmcfg_init(type, 1);
+	__pci_mmcfg_init(1);
 }
 
 void __init pci_mmcfg_late_init(void)
 {
-	int type = 0;
-
-	if (pci_probe & PCI_PROBE_CONF1)
-		type = 1;
-
-	__pci_mmcfg_init(type, 0);
+	__pci_mmcfg_init(0);
 }
 
 static int __init pci_mmcfg_late_insert_resources(void)
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index c9fb637..d345661 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -95,8 +95,6 @@ struct pci_raw_ops {
 extern struct pci_raw_ops *raw_pci_ops;
 extern struct pci_raw_ops *raw_pci_ext_ops;
 
-extern struct pci_raw_ops pci_direct_conf1;
-
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f9ab5fe..8c76066 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1052,10 +1052,10 @@ extern unsigned long pci_cardbus_mem_size;
 extern int pcibios_add_platform_entries(struct pci_dev *dev);
 
 #ifdef CONFIG_PCI_MMCONFIG
-extern void __init pci_mmcfg_early_init(int type);
+extern void __init pci_mmcfg_early_init(void);
 extern void __init pci_mmcfg_late_init(void);
 #else
-static inline void pci_mmcfg_early_init(int type) { }
+static inline void pci_mmcfg_early_init(void) { }
 static inline void pci_mmcfg_late_init(void) { }
 #endif
 
