Return-Path: <linux-kernel-owner+w=401wt.eu-S1765366AbXEVILG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765366AbXEVILG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbXEVIGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:32 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:5744 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbXEVIGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:16 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 4/15] x86-64: Calgary - introduce chipset specific ops
Date: Tue, 22 May 2007 04:05:53 -0400
Message-Id: <1179821166685-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211663773-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Calgary and CalIOC2 share most of the same logic. Introduce struct
cal_chipset_ops for quirks and tce flush logic which are
different. CalIOC2 implementation to appear in a later patch.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   24 +++++++++++++++++-------
 include/asm-x86_64/calgary.h     |    8 +++++++-
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 9f6dd44..acee770 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -155,9 +155,15 @@ struct calgary_bus_info {
 	void __iomem *bbar;
 };
 
-static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
+static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
+static void calgary_tce_cache_blast(struct iommu_table *tbl);
+
+struct cal_chipset_ops calgary_chip_ops = {
+	.handle_quirks = calgary_handle_quirks,
+	.tce_cache_blast = calgary_tce_cache_blast
+};
 
-static void tce_cache_blast(struct iommu_table *tbl);
+static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
 
 /* enable this to stress test the chip's TCE cache */
 #ifdef CONFIG_IOMMU_DEBUG
@@ -243,7 +249,7 @@ static unsigned long iommu_range_alloc(s
 	offset = find_next_zero_string(tbl->it_map, tbl->it_hint,
 				       tbl->it_size, npages);
 	if (offset == ~0UL) {
-		tce_cache_blast(tbl);
+		tbl->chip_ops->tce_cache_blast(tbl);
 		offset = find_next_zero_string(tbl->it_map, 0,
 					       tbl->it_size, npages);
 		if (offset == ~0UL) {
@@ -552,7 +558,7 @@ static inline void __iomem* calgary_reg(
 	return (void __iomem*)target;
 }
 
-static void tce_cache_blast(struct iommu_table *tbl)
+static void calgary_tce_cache_blast(struct iommu_table *tbl)
 {
 	u64 val;
 	u32 aer;
@@ -698,6 +704,8 @@ static int __init calgary_setup_tar(stru
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
+	tbl->chip_ops = &calgary_chip_ops;
+
 	calgary_reserve_regions(dev);
 
 	/* set TARs for each PHB */
@@ -807,10 +815,10 @@ static void __init calgary_set_split_com
 	readq(target); /* flush */
 }
 
-static void __init calgary_handle_quirks(struct pci_dev* dev)
+static void __init calgary_handle_quirks(struct iommu_table *tbl,
+	struct pci_dev *dev)
 {
 	unsigned char busnum = dev->bus->number;
-	struct iommu_table *tbl = dev->sysdata;
 
 	/*
 	 * Give split completion a longer timeout on bus 1 for aic94xx
@@ -885,6 +893,7 @@ static void __init calgary_init_one_nont
 static int __init calgary_init_one(struct pci_dev *dev)
 {
 	void __iomem *bbar;
+	struct iommu_table *tbl;
 	int ret;
 
 	BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
@@ -897,7 +906,8 @@ static int __init calgary_init_one(struc
 	pci_dev_get(dev);
 	dev->bus->self = dev;
 
-	calgary_handle_quirks(dev);
+	tbl = dev->sysdata;
+	tbl->chip_ops->handle_quirks(tbl, dev);
 
 	calgary_enable_translation(dev);
 
diff --git a/include/asm-x86_64/calgary.h b/include/asm-x86_64/calgary.h
index 7ee9006..3aa8ad5 100644
--- a/include/asm-x86_64/calgary.h
+++ b/include/asm-x86_64/calgary.h
@@ -1,7 +1,7 @@
 /*
  * Derived from include/asm-powerpc/iommu.h
  *
- * Copyright (C) IBM Corporation, 2006
+ * Copyright IBM Corporation, 2006-2007
  *
  * Author: Jon Mason <jdmason@us.ibm.com>
  * Author: Muli Ben-Yehuda <muli@il.ibm.com>
@@ -30,6 +30,7 @@
 #include <asm/types.h>
 
 struct iommu_table {
+	struct cal_chipset_ops *chip_ops; /* chipset specific funcs */
 	unsigned long  it_base;      /* mapped address of tce table */
 	unsigned long  it_hint;      /* Hint for next alloc */
 	unsigned long *it_map;       /* A simple allocation bitmap for now */
@@ -41,6 +42,11 @@ struct iommu_table {
 	unsigned char  it_busno;     /* Bus number this table belongs to */
 };
 
+struct cal_chipset_ops {
+	void (*handle_quirks)(struct iommu_table *tbl, struct pci_dev *dev);
+	void (*tce_cache_blast)(struct iommu_table *tbl);
+};
+
 #define TCE_TABLE_SIZE_UNSPECIFIED	~0
 #define TCE_TABLE_SIZE_64K		0
 #define TCE_TABLE_SIZE_128K		1
-- 
1.4.4

