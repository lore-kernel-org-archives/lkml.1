Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbXEVIIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbXEVIIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXEVIGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:23 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:5736 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbXEVIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:12 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 9/15] x86-64: Calgary - make dump_error_regs a chip op
Date: Tue, 22 May 2007 04:05:58 -0400
Message-Id: <11798211672822-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211673003-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com> <1179821167481-git-send-email-muli@il.ibm.com> <11798211673003-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Provide seperate versions for Calgary and CalIOC2

Also print out the PCIe Root Complex Status on CalIOC2 errors

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   43 ++++++++++++++++++++++++++++++-------
 include/asm-x86_64/calgary.h     |    1 +
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 06a5db3..57ac81b 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -83,6 +83,7 @@ int use_calgary __read_mostly = 0;
 #define PHB_SAVIOR_L2           0x0DB0
 #define PHB_PAGE_MIG_CTRL       0x0DA8
 #define PHB_PAGE_MIG_DEBUG      0x0DA0
+#define PHB_ROOT_COMPLEX_STATUS 0x0CB0
 
 /* PHB_CONFIG_RW */
 #define PHB_TCE_ENABLE		0x20000000
@@ -163,20 +164,25 @@ struct calgary_bus_info {
 	void __iomem *bbar;
 };
 
+
 static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 static void calgary_tce_cache_blast(struct iommu_table *tbl);
+static void calgary_dump_error_regs(struct iommu_table *tbl);
 
 static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 static void calioc2_tce_cache_blast(struct iommu_table *tbl);
+static void calioc2_dump_error_regs(struct iommu_table *tbl);
 
 struct cal_chipset_ops calgary_chip_ops = {
 	.handle_quirks = calgary_handle_quirks,
-	.tce_cache_blast = calgary_tce_cache_blast
+	.tce_cache_blast = calgary_tce_cache_blast,
+	.dump_error_regs = calgary_dump_error_regs
 };
 
 struct cal_chipset_ops calioc2_chip_ops = {
 	.handle_quirks = calioc2_handle_quirks,
-	.tce_cache_blast = calioc2_tce_cache_blast
+	.tce_cache_blast = calioc2_tce_cache_blast,
+	.dump_error_regs = calioc2_dump_error_regs
 };
 
 static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
@@ -896,7 +902,21 @@ static void __init calgary_free_bus(stru
 static void calgary_dump_error_regs(struct iommu_table *tbl)
 {
 	void __iomem *bbar = tbl->bbar;
-	u32 csr, csmr, plssr, mck;
+	u32 val32;
+	void __iomem *target;
+	
+	target = calgary_reg(bbar, phb_offset(tbl->it_busno) | PHB_CSR_OFFSET);
+	val32 = be32_to_cpu(readl(target));
+
+	/* If no error, the agent ID in the CSR is not valid */
+	printk(KERN_EMERG "Calgary: DMA error on Calgary PHB 0x%x, "
+	       "CSR = 0x%08x\n", tbl->it_busno, val32);
+}
+
+static void calioc2_dump_error_regs(struct iommu_table *tbl)
+{
+	void __iomem *bbar = tbl->bbar;
+	u32 csr, csmr, plssr, mck, rcstat;
 	void __iomem *target;
 	unsigned long phboff = phb_offset(tbl->it_busno);
 	unsigned long erroff;
@@ -916,8 +936,11 @@ static void calgary_dump_error_regs(stru
 	target = calgary_reg(bbar, phboff | 0x800);
 	mck = be32_to_cpu(readl(target));
 
-	printk(KERN_EMERG "Calgary: 0x%08x@CSR 0x%08x@PLSSR 0x%08x@CSMR "
-	       "0x%08x@MCK\n", csr, plssr, csmr, mck);
+	printk(KERN_EMERG "Calgary: DMA error on CalIOC2 PHB 0x%x\n",
+	       tbl->it_busno);
+
+	printk(KERN_EMERG "Calgary: 0x%08x@CSR 0x%08x@PLSSR 0x%08x@CSMR 0x%08x@MCK\n",
+	       csr, plssr, csmr, mck);
 
 	/* dump rest of error regs */
 	printk(KERN_EMERG "Calgary: ");
@@ -928,6 +951,12 @@ static void calgary_dump_error_regs(stru
 		printk("0x%08x@0x%lx ", errregs[i], erroff);
 	}
 	printk("\n");
+
+	/* root complex status */
+	target = calgary_reg(bbar, phboff | PHB_ROOT_COMPLEX_STATUS);
+	rcstat = be32_to_cpu(readl(target));
+	printk(KERN_EMERG "Calgary: 0x%08x@0x%x\n", rcstat,
+	       PHB_ROOT_COMPLEX_STATUS);
 }
 
 static void calgary_watchdog(unsigned long data)
@@ -943,9 +972,7 @@ static void calgary_watchdog(unsigned lo
 
 	/* If no error, the agent ID in the CSR is not valid */
 	if (val32 & CSR_AGENT_MASK) {
-		printk(KERN_EMERG "Calgary: DMA error on PHB %#x\n",
-		       dev->bus->number);
-		calgary_dump_error_regs(tbl);
+		tbl->chip_ops->dump_error_regs(tbl);
 
 		/* reset error */
 		writel(0, target);
diff --git a/include/asm-x86_64/calgary.h b/include/asm-x86_64/calgary.h
index 3aa8ad5..3c81436 100644
--- a/include/asm-x86_64/calgary.h
+++ b/include/asm-x86_64/calgary.h
@@ -45,6 +45,7 @@ struct iommu_table {
 struct cal_chipset_ops {
 	void (*handle_quirks)(struct iommu_table *tbl, struct pci_dev *dev);
 	void (*tce_cache_blast)(struct iommu_table *tbl);
+	void (*dump_error_regs)(struct iommu_table *tbl);
 };
 
 #define TCE_TABLE_SIZE_UNSPECIFIED	~0
-- 
1.4.4

