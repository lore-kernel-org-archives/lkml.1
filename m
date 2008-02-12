Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYBLApA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYBLApA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYBLAou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:44:50 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57943 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYBLAot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:44:49 -0500
Date: Mon, 11 Feb 2008 16:47:10 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/4] x86: mmconf enable mcfg early
In-reply-to: <200802111645.38984.yinghai.lu@sun.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802111647.11154.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802111643.17265.yinghai.lu@sun.com>
 <200802111645.38984.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Patch
	x86: validate against ACPI motherboard resources

changed the mmconf init sequence, and init MMCONF late in acpi_init.

here change it back to old sequence
1. check hostbridge in early
2. check MCFG with e820 in early
3. if all fail, will check MCFg with acpi _CRS in acpi_init

So we can make MCONF working again when acpi=off is set if hostbridge support
that.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/mmconfig-shared.c |  106 +++++++++++++++++--------------
 1 file changed, 61 insertions(+), 45 deletions(-)

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -241,7 +241,7 @@ static int __init is_acpi_reserved(unsig
 	return mcfg_res.flags;
 }
 
-static void __init pci_mmcfg_reject_broken(void)
+static void __init pci_mmcfg_reject_broken(int type, int early)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
 	int i;
@@ -266,34 +266,43 @@ static void __init pci_mmcfg_reject_brok
 	}
 
 	for (i = 0; i < pci_mmcfg_config_num; i++) {
+		int valid = 0;
 		u32 size = (cfg->end_bus_number + 1) << 20;
 		cfg = &pci_mmcfg_config[i];
-		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lu "
+		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
 		       "segment %hu buses %u - %u\n",
 		       i, (unsigned long)cfg->address, cfg->pci_segment,
 		       (unsigned int)cfg->start_bus_number,
 		       (unsigned int)cfg->end_bus_number);
-		if (is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
+
+		if (!early &&
+		    is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
 			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
 			       "in ACPI motherboard resources\n",
 			       cfg->address);
-		} else {
+			valid = 1;
+		}
+
+		if (valid)
+			continue;
+
+		if (!early)
 			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
 			       " reserved in ACPI motherboard resources\n",
 			       cfg->address);
-			/* Don't try to do this check unless configuration
-			   type 1 is available. */
-			if ((pci_probe & PCI_PROBE_CONF1) &&
-			    e820_all_mapped(cfg->address,
-					    cfg->address + size - 1,
-					    E820_RESERVED))
-				printk(KERN_NOTICE
-				       "PCI: MCFG area at %Lx reserved in "
-				       "E820\n",
-				       cfg->address);
-			else
-				goto reject;
+		/* Don't try to do this check unless configuration
+		   type 1 is available. */
+		if (type == 1 && e820_all_mapped(cfg->address,
+						  cfg->address + size - 1,
+						  E820_RESERVED)) {
+			printk(KERN_NOTICE
+			       "PCI: MCFG area at %Lx reserved in E820\n",
+			       cfg->address);
+			valid = 1;
 		}
+
+		if (!valid)
+			goto reject;
 	}
 
 	return;
@@ -306,46 +315,36 @@ reject:
 	pci_mmcfg_config_num = 0;
 }
 
-void __init pci_mmcfg_early_init(int type)
-{
-	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
-		return;
-
-	/* If type 1 access is available, no need to enable MMCONFIG yet, we can
-	   defer until later when the ACPI interpreter is available to better
-	   validate things. */
-	if (type == 1)
-		return;
-
-	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-
-	if ((pci_mmcfg_config_num == 0) ||
-	    (pci_mmcfg_config == NULL) ||
-	    (pci_mmcfg_config[0].address == 0))
-		return;
+static int __initdata known_bridge;
 
-	if (pci_mmcfg_arch_init())
-		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-}
-
-void __init pci_mmcfg_late_init(void)
+void __init __pci_mmcfg_init(int type, int early)
 {
-	int known_bridge = 0;
-
 	/* MMCONFIG disabled */
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
 	/* MMCONFIG already enabled */
-	if (!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
+	if (!early && !(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
 		return;
 
-	if ((pci_probe & PCI_PROBE_CONF1) && pci_mmcfg_check_hostbridge())
-		known_bridge = 1;
-	else
-		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+	/* for late to exit */
+	if (known_bridge)
+		return;
 
-	pci_mmcfg_reject_broken();
+	if (early && type == 1) {
+		if (pci_mmcfg_check_hostbridge())
+			known_bridge = 1;
+#if 0
+	/* check e820 in late? */
+		else
+			return;
+#endif
+	}
+
+	if (!known_bridge) {
+		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+		pci_mmcfg_reject_broken(type, early);
+	}
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -365,6 +364,21 @@ void __init pci_mmcfg_late_init(void)
 	}
 }
 
+void __init pci_mmcfg_early_init(int type)
+{
+	__pci_mmcfg_init(type, 1);
+}
+
+void __init pci_mmcfg_late_init(void)
+{
+	int type = 0;
+
+	if (pci_probe & PCI_PROBE_CONF1)
+		type = 1;
+
+	__pci_mmcfg_init(type, 0);
+}
+
 static int __init pci_mmcfg_late_insert_resources(void)
 {
 	/*
