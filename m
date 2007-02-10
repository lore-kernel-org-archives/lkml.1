Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXBJMAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXBJMAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933408AbXBJLvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:08 -0500
Received: from mail.suse.de ([195.135.220.2]:50270 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933401AbXBJLuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:39 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: OGAWA Hirofumi <hogawa@miraclelinux.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [18/25] x86_64: Fix x86_64 ioremap base_address
Message-Id: <20070210115031.3D4CE13DFB@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: OGAWA Hirofumi <hogawa@miraclelinux.com>

Current mmconfig has some problems of remapped range.

a) In the case of broken MCFG tables on Asus etc., we need to remap 256M
   range, but currently only remap 1M.

b) The base address always corresponds to bus number 0, but currently we
   are assuming it corresponds to start bus number.

This patch fixes the above problems.

(akpm: Arjan suggests that if the MCFG table is broken we just shouldn't use
it, rather than try to work around things).

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/pci/mmconfig.c |   46 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

Index: linux/arch/x86_64/pci/mmconfig.c
===================================================================
--- linux.orig/arch/x86_64/pci/mmconfig.c
+++ linux/arch/x86_64/pci/mmconfig.c
@@ -28,6 +28,39 @@ struct mmcfg_virt {
 };
 static struct mmcfg_virt *pci_mmcfg_virt;
 
+static inline int mcfg_broken(void)
+{
+	struct acpi_mcfg_allocation *cfg = &pci_mmcfg_config[0];
+
+	/* Handle more broken MCFG tables on Asus etc.
+	   They only contain a single entry for bus 0-0. Assume
+ 	   this applies to all busses. */
+	if (pci_mmcfg_config_num == 1 &&
+	    cfg->pci_segment_group_number == 0 &&
+	    (cfg->start_bus_number | cfg->end_bus_number) == 0)
+		return 1;
+	return 0;
+}
+
+static void __iomem *mcfg_ioremap(struct acpi_mcfg_allocation *cfg)
+{
+	void __iomem *addr;
+	u32 size;
+
+	if (mcfg_broken())
+		size = 256 << 20;
+	else
+		size = (cfg->end_bus_number + 1) << 20;
+
+	addr = ioremap_nocache(cfg->base_address, size);
+	if (addr) {
+		printk(KERN_INFO "PCI: Using MMCONFIG at %x - %x\n",
+		       cfg->base_address,
+		       cfg->base_address + size - 1);
+	}
+	return addr;
+}
+
 static char __iomem *get_virt(unsigned int seg, unsigned bus)
 {
 	int cfg_num = -1;
@@ -45,13 +78,7 @@ static char __iomem *get_virt(unsigned i
 			return pci_mmcfg_virt[cfg_num].virt;
 	}
 
-	/* Handle more broken MCFG tables on Asus etc.
-	   They only contain a single entry for bus 0-0. Assume
- 	   this applies to all busses. */
-	cfg = &pci_mmcfg_config[0];
-	if (pci_mmcfg_config_num == 1 &&
-		cfg->pci_segment == 0 &&
-		(cfg->start_bus_number | cfg->end_bus_number) == 0)
+	if (mcfg_broken())
 		return pci_mmcfg_virt[0].virt;
 
 	/* Fall back to type 0 */
@@ -145,16 +172,13 @@ int __init pci_mmcfg_arch_init(void)
 
 	for (i = 0; i < pci_mmcfg_config_num; ++i) {
 		pci_mmcfg_virt[i].cfg = &pci_mmcfg_config[i];
-		pci_mmcfg_virt[i].virt = ioremap_nocache(pci_mmcfg_config[i].address,
-							 MMCONFIG_APER_MAX);
+		pci_mmcfg_virt[i].virt = mcfg_ioremap(&pci_mmcfg_config[i]);
 		if (!pci_mmcfg_virt[i].virt) {
 			printk(KERN_ERR "PCI: Cannot map mmconfig aperture for "
 					"segment %d\n",
 				pci_mmcfg_config[i].pci_segment);
 			return 0;
 		}
-		printk(KERN_INFO "PCI: Using MMCONFIG at %Lx\n", 
-				pci_mmcfg_config[i].address);
 	}
 	raw_pci_ops = &pci_mmcfg;
 	return 1;
