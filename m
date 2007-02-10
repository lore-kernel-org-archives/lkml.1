Return-Path: <linux-kernel-owner+w=401wt.eu-S933375AbXBJLxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbXBJLxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbXBJLv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:27 -0500
Received: from mx1.suse.de ([195.135.220.2]:50261 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388AbXBJLud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:33 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [19/25] x86: Reject a broken MCFG tables on Asus etc
Message-Id: <20070210115032.4C13A13DCE@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
This rejects a broken MCFG tables on Asus etc.
Arjan and Andi suggest this.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/pci/mmconfig-shared.c |   24 ++++++++++++++++++-
 arch/i386/pci/mmconfig.c        |    9 -------
 arch/x86_64/pci/mmconfig.c      |   50 +++++++++++-----------------------------
 3 files changed, 37 insertions(+), 46 deletions(-)

Index: linux/arch/i386/pci/mmconfig-shared.c
===================================================================
--- linux.orig/arch/i386/pci/mmconfig-shared.c
+++ linux/arch/i386/pci/mmconfig-shared.c
@@ -197,6 +197,26 @@ static __init void pci_mmcfg_insert_reso
 	}
 }
 
+static void __init pci_mmcfg_reject_broken(void)
+{
+	typeof(pci_mmcfg_config[0]) *cfg = &pci_mmcfg_config[0];
+
+	/*
+	 * Handle more broken MCFG tables on Asus etc.
+	 * They only contain a single entry for bus 0-0.
+	 */
+	if (pci_mmcfg_config_num == 1 &&
+	    cfg->pci_segment == 0 &&
+	    (cfg->start_bus_number | cfg->end_bus_number) == 0) {
+		kfree(pci_mmcfg_config);
+		pci_mmcfg_config = NULL;
+		pci_mmcfg_config_num = 0;
+
+		printk(KERN_ERR "PCI: start and end of bus number is 0. "
+		       "Rejected as broken MCFG.");
+	}
+}
+
 void __init pci_mmcfg_init(int type)
 {
 	int known_bridge = 0;
@@ -207,8 +227,10 @@ void __init pci_mmcfg_init(int type)
 	if (type == 1 && pci_mmcfg_check_hostbridge())
 		known_bridge = 1;
 
-	if (!known_bridge)
+	if (!known_bridge) {
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+		pci_mmcfg_reject_broken();
+	}
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
Index: linux/arch/i386/pci/mmconfig.c
===================================================================
--- linux.orig/arch/i386/pci/mmconfig.c
+++ linux/arch/i386/pci/mmconfig.c
@@ -47,15 +47,6 @@ static u32 get_base_addr(unsigned int se
 			return cfg->address;
 	}
 
-	/* Handle more broken MCFG tables on Asus etc.
-	   They only contain a single entry for bus 0-0. Assume
- 	   this applies to all busses. */
-	cfg = &pci_mmcfg_config[0];
-	if (pci_mmcfg_config_num == 1 &&
-		cfg->pci_segment == 0 &&
-		(cfg->start_bus_number | cfg->end_bus_number) == 0)
-		return cfg->address;
-
 	/* Fall back to type 0 */
 	return 0;
 }
Index: linux/arch/x86_64/pci/mmconfig.c
===================================================================
--- linux.orig/arch/x86_64/pci/mmconfig.c
+++ linux/arch/x86_64/pci/mmconfig.c
@@ -28,39 +28,6 @@ struct mmcfg_virt {
 };
 static struct mmcfg_virt *pci_mmcfg_virt;
 
-static inline int mcfg_broken(void)
-{
-	struct acpi_mcfg_allocation *cfg = &pci_mmcfg_config[0];
-
-	/* Handle more broken MCFG tables on Asus etc.
-	   They only contain a single entry for bus 0-0. Assume
- 	   this applies to all busses. */
-	if (pci_mmcfg_config_num == 1 &&
-	    cfg->pci_segment_group_number == 0 &&
-	    (cfg->start_bus_number | cfg->end_bus_number) == 0)
-		return 1;
-	return 0;
-}
-
-static void __iomem *mcfg_ioremap(struct acpi_mcfg_allocation *cfg)
-{
-	void __iomem *addr;
-	u32 size;
-
-	if (mcfg_broken())
-		size = 256 << 20;
-	else
-		size = (cfg->end_bus_number + 1) << 20;
-
-	addr = ioremap_nocache(cfg->base_address, size);
-	if (addr) {
-		printk(KERN_INFO "PCI: Using MMCONFIG at %x - %x\n",
-		       cfg->base_address,
-		       cfg->base_address + size - 1);
-	}
-	return addr;
-}
-
 static char __iomem *get_virt(unsigned int seg, unsigned bus)
 {
 	int cfg_num = -1;
@@ -78,9 +45,6 @@ static char __iomem *get_virt(unsigned i
 			return pci_mmcfg_virt[cfg_num].virt;
 	}
 
-	if (mcfg_broken())
-		return pci_mmcfg_virt[0].virt;
-
 	/* Fall back to type 0 */
 	return NULL;
 }
@@ -160,6 +124,20 @@ static struct pci_raw_ops pci_mmcfg = {
 	.write =	pci_mmcfg_write,
 };
 
+static void __iomem * __init mcfg_ioremap(struct acpi_mcfg_allocation *cfg)
+{
+	void __iomem *addr;
+	u32 size;
+
+	size = (cfg->end_bus_number + 1) << 20;
+	addr = ioremap_nocache(cfg->address, size);
+	if (addr) {
+		printk(KERN_INFO "PCI: Using MMCONFIG at %Lx - %Lx\n",
+		       cfg->address, cfg->address + size - 1);
+	}
+	return addr;
+}
+
 int __init pci_mmcfg_arch_init(void)
 {
 	int i;
