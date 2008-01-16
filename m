Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYAPWGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYAPWGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYAPWGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:06:09 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41955 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYAPWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:06:08 -0500
Date: Wed, 16 Jan 2008 14:09:02 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/2] x86: MMCONF enable MCFG early
In-reply-to: <200801161406.38946.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801161409.02591.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801161405.17889.yinghai.lu@sun.com>
 <200801161406.38946.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: MMCONF enable MCFG early

patch
	x86: validate against ACPI motherboard resources

changed the mmconf init sequence, and init MMCONF late in acpi_init.

here change it back to old sequence
1. check hostbridge in early
2. check MCFG with e820 in early
3. if all fail, will check MCFg with acpi _CRS in acpi_init

So we can make MCONF working again when acpi=off is set if hostbridge support that.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -274,7 +274,7 @@ static int __init is_acpi_reserved(unsig
 	return mcfg_res.flags;
 }
 
-static void __init pci_mmcfg_reject_broken(void)
+static void __init pci_mmcfg_reject_broken(int type, int early)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
 	int i;
@@ -299,34 +299,43 @@ static void __init pci_mmcfg_reject_brok
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
+
+		if (!early)
 		if (is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
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
@@ -339,46 +348,37 @@ reject:
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
-
-	if (pci_mmcfg_arch_init())
-		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-}
+static int __initdata known_bridge;
 
-void __init pci_mmcfg_late_init(void)
+void __init __pci_mmcfg_init(int type, int early)
 {
-	int known_bridge = 0;
-
 	/* MMCONFIG disabled */
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
 	/* MMCONFIG already enabled */
+	if (!early)
 	if (!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
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
@@ -386,10 +386,11 @@ void __init pci_mmcfg_late_init(void)
 		return;
 
 	if (pci_mmcfg_arch_init()) {
-		if (pci_probe & PCI_PROBE_CONF1)
+		if (type == 1)
 			unreachable_devices();
 		if (known_bridge)
 			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
+
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
 	} else {
 		/*
@@ -400,6 +401,21 @@ void __init pci_mmcfg_late_init(void)
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
