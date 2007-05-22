Return-Path: <linux-kernel-owner+w=401wt.eu-S1765098AbXEVIJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765098AbXEVIJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXEVIGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:25 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:47511 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbXEVIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:12 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 8/15] x86-64: Calgary - implement CalIOC2 TCE cache flush sequence
Date: Tue, 22 May 2007 04:05:57 -0400
Message-Id: <11798211673003-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <1179821167481-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com> <1179821167481-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   88 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 87 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index ee0b52c..06a5db3 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -81,6 +81,8 @@ int use_calgary __read_mostly = 0;
 
 /* CalIOC2 specific */
 #define PHB_SAVIOR_L2           0x0DB0
+#define PHB_PAGE_MIG_CTRL       0x0DA8
+#define PHB_PAGE_MIG_DEBUG      0x0DA0
 
 /* PHB_CONFIG_RW */
 #define PHB_TCE_ENABLE		0x20000000
@@ -95,6 +97,10 @@ int use_calgary __read_mostly = 0;
 #define CSR_AGENT_MASK		0xffe0ffff
 /* CCR (Calgary Configuration Register) */
 #define CCR_2SEC_TIMEOUT        0x000000000000000EUL
+/* PMCR/PMDR (Page Migration Control/Debug Registers */
+#define PMR_SOFTSTOP            0x80000000
+#define PMR_SOFTSTOPFAULT       0x40000000
+#define PMR_HARDSTOP            0x20000000
 
 #define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
 #define MAX_NUM_CHASSIS		8 /* max number of chassis */
@@ -161,6 +167,7 @@ static void calgary_handle_quirks(struct
 static void calgary_tce_cache_blast(struct iommu_table *tbl);
 
 static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
+static void calioc2_tce_cache_blast(struct iommu_table *tbl);
 
 struct cal_chipset_ops calgary_chip_ops = {
 	.handle_quirks = calgary_handle_quirks,
@@ -169,7 +176,7 @@ struct cal_chipset_ops calgary_chip_ops
 
 struct cal_chipset_ops calioc2_chip_ops = {
 	.handle_quirks = calioc2_handle_quirks,
-	.tce_cache_blast = NULL
+	.tce_cache_blast = calioc2_tce_cache_blast
 };
 
 static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
@@ -638,6 +645,85 @@ static void calgary_tce_cache_blast(stru
 	(void)readl(target); /* flush */
 }
 
+static void calioc2_tce_cache_blast(struct iommu_table *tbl)
+{
+	void __iomem *bbar = tbl->bbar;
+	void __iomem *target;
+	u64 val64;
+	u32 val;
+	int i = 0;
+	int count = 1;
+	unsigned char bus = tbl->it_busno;
+
+begin:
+	printk(KERN_DEBUG "Calgary: CalIOC2 bus 0x%x entering tce cache blast "
+	       "sequence - count %d\n", bus, count);
+
+	/* 1. using the Page Migration Control reg set SoftStop */
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_CTRL);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "1a. read 0x%x [LE] from %p\n", val, target);
+	val |= PMR_SOFTSTOP;
+	printk(KERN_DEBUG "1b. writing 0x%x [LE] to %p\n", val, target);
+	writel(cpu_to_be32(val), target);
+
+	/* 2. poll split queues until all DMA activity is done */
+	printk(KERN_DEBUG "2a. starting to poll split queues\n");
+	target = calgary_reg(bbar, split_queue_offset(bus));
+	do {
+		val64 = readq(target);
+		i++;
+	} while ((val64 & 0xff) != 0xff && i < 100);
+	if (i == 100)
+		printk(KERN_WARNING "CalIOC2: PCI bus not quiesced, "
+		       "continuing anyway\n");
+
+	/* 3. poll Page Migration DEBUG for SoftStopFault */
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_DEBUG);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "3. read 0x%x [LE] from %p\n", val, target);
+
+	/* 4. if SoftStopFault - goto (1) */
+	if (val & PMR_SOFTSTOPFAULT) {
+		if (++count < 100)
+			goto begin;
+		else {
+			printk(KERN_WARNING "CalIOC2: too many SoftStopFaults, "
+			       "aborting TCE cache flush sequence!\n");
+			return; /* pray for the best */
+		}
+	}
+
+	/* 5. Slam into HardStop by reading PHB_PAGE_MIG_CTRL */
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_CTRL);
+	printk(KERN_DEBUG "5a. slamming into HardStop by reading %p\n", target);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "5b. read 0x%x [LE] from %p\n", val, target);
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_DEBUG);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "5c. read 0x%x [LE] from %p (debug)\n", val, target);
+
+	/* 6. invalidate TCE cache */
+	printk(KERN_DEBUG "6. invalidating TCE cache\n");
+	target = calgary_reg(bbar, tar_offset(bus));
+	writeq(tbl->tar_val, target);
+
+	/* 7. Re-read PMCR */
+	printk(KERN_DEBUG "7a. Re-reading PMCR\n");
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_CTRL);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "7b. read 0x%x [LE] from %p\n", val, target);
+
+	/* 8. Remove HardStop */
+	printk(KERN_DEBUG "8a. removing HardStop from PMCR\n");
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_CTRL);
+	val = 0;
+	printk(KERN_DEBUG "8b. writing 0x%x [LE] to %p\n", val, target);
+	writel(cpu_to_be32(val), target);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "8c. read 0x%x [LE] from %p\n", val, target);
+}
+
 static void __init calgary_reserve_mem_region(struct pci_dev *dev, u64 start,
 	u64 limit)
 {
-- 
1.4.4

