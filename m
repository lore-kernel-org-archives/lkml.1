Return-Path: <linux-kernel-owner+w=401wt.eu-S1764975AbXEVIKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764975AbXEVIKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbXEVIG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:28 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:38695 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbXEVIGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:13 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 7/15] x86-64: Calgary - add chip_ops and a quirk function for CalIOC2
Date: Tue, 22 May 2007 04:05:56 -0400
Message-Id: <1179821167481-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211672108-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 3945437..ee0b52c 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -79,6 +79,9 @@ int use_calgary __read_mostly = 0;
 #define PHB_MEM_2_SIZE_LOW	0x02E0
 #define PHB_DOSHOLE_OFFSET	0x08E0
 
+/* CalIOC2 specific */
+#define PHB_SAVIOR_L2           0x0DB0
+
 /* PHB_CONFIG_RW */
 #define PHB_TCE_ENABLE		0x20000000
 #define PHB_SLOT_DISABLE	0x1C000000
@@ -157,11 +160,18 @@ struct calgary_bus_info {
 static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 static void calgary_tce_cache_blast(struct iommu_table *tbl);
 
+static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
+
 struct cal_chipset_ops calgary_chip_ops = {
 	.handle_quirks = calgary_handle_quirks,
 	.tce_cache_blast = calgary_tce_cache_blast
 };
 
+struct cal_chipset_ops calioc2_chip_ops = {
+	.handle_quirks = calioc2_handle_quirks,
+	.tce_cache_blast = NULL
+};
+
 static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
 
 /* enable this to stress test the chip's TCE cache */
@@ -743,7 +753,12 @@ static int __init calgary_setup_tar(stru
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
-	tbl->chip_ops = &calgary_chip_ops;
+  	if (is_calgary(dev->device))
+  		tbl->chip_ops = &calgary_chip_ops;
+	else if (is_calioc2(dev->device))
+		tbl->chip_ops = &calioc2_chip_ops;
+  	else
+  		BUG();
 
 	calgary_reserve_regions(dev);
 
@@ -894,8 +909,23 @@ static void __init calgary_set_split_com
 	readq(target); /* flush */
 }
 
-static void __init calgary_handle_quirks(struct iommu_table *tbl,
-	struct pci_dev *dev)
+static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
+{
+	unsigned char busnum = dev->bus->number;
+	void __iomem *bbar = tbl->bbar;
+	void __iomem *target;
+	u32 val;
+
+ 	/*
+ 	 * CalIOC2 designers recommend setting bit 8 in 0xnDB0 to 1
+ 	 */
+ 	target = calgary_reg(bbar, phb_offset(busnum) | PHB_SAVIOR_L2);
+ 	val = cpu_to_be32(readl(target));
+ 	val |= 0x00800000;
+ 	writel(cpu_to_be32(val), target);
+}
+
+static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
 {
 	unsigned char busnum = dev->bus->number;
 
@@ -903,7 +933,7 @@ static void __init calgary_handle_quirks
 	 * Give split completion a longer timeout on bus 1 for aic94xx
 	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
 	 */
-	if (busnum == 1)
+	if (is_calgary(dev->device) && (busnum == 1))
 		calgary_set_split_completion_timeout(tbl->bbar, busnum,
 						     CCR_2SEC_TIMEOUT);
 }
-- 
1.4.4

