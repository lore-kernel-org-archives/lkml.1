Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbXIUVEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbXIUVEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765760AbXIUU6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:58:48 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:10218 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765750AbXIUU6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:58:47 -0400
Date: Fri, 21 Sep 2007 22:58:33 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 2/2] x86-64: Calgary - get rid of translate_phb
Message-ID: <20070921205833.GC7640@rhun.ibm.com>
References: <20070921205704.GB7640@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921205704.GB7640@rhun.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we check for translation enabled/disabled based on the
presence of the IOMMU translation table, we can get rid of
translate_phb.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 pci-calgary.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff -r c9308d0538d9 -r a7833c71f4df arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c	Sun Aug 12 11:43:49 2007 +0300
+++ b/arch/x86_64/kernel/pci-calgary.c	Sun Aug 12 11:45:29 2007 +0300
@@ -226,12 +226,6 @@ static inline int translation_enabled(st
 	return (tbl != NULL);
 }
 
-static inline int translate_phb(struct pci_dev* dev)
-{
-	int disabled = bus_info[dev->bus->number].translation_disabled;
-	return !disabled;
-}
-
 static void iommu_range_reserve(struct iommu_table *tbl,
 	unsigned long start_addr, unsigned int npages)
 {
@@ -1197,7 +1191,7 @@ static int __init calgary_init(void)
 {
 	int ret;
 	struct pci_dev *dev = NULL;
-	void *tce_space;
+	struct calgary_bus_info *info;
 
 	ret = calgary_locate_bbars();
 	if (ret)
@@ -1209,12 +1203,14 @@ static int __init calgary_init(void)
 			break;
 		if (!is_cal_pci_dev(dev->device))
 			continue;
-		if (!translate_phb(dev)) {
+
+		info = &bus_info[dev->bus->number];
+		if (info->translation_disabled) {
 			calgary_init_one_nontraslated(dev);
 			continue;
 		}
-		tce_space = bus_info[dev->bus->number].tce_space;
-		if (!tce_space && !translate_empty_slots)
+
+		if (!info->tce_space && !translate_empty_slots)
 			continue;
 
 		ret = calgary_init_one(dev);
@@ -1232,11 +1228,13 @@ error:
 			break;
 		if (!is_cal_pci_dev(dev->device))
 			continue;
-		if (!translate_phb(dev)) {
+
+		info = &bus_info[dev->bus->number];
+		if (info->translation_disabled) {
 			pci_dev_put(dev);
 			continue;
 		}
-		if (!bus_info[dev->bus->number].tce_space && !translate_empty_slots)
+		if (!info->tce_space && !translate_empty_slots)
 			continue;
 
 		calgary_disable_translation(dev);
@@ -1549,7 +1547,7 @@ static int __init calgary_fixup_tce_spac
 static int __init calgary_fixup_tce_spaces(void)
 {
 	struct pci_dev *dev = NULL;
-	void *tce_space;
+	struct calgary_bus_info *info;
 
 	if (no_iommu || swiotlb || !calgary_detected)
 		return -ENODEV;
@@ -1562,11 +1560,12 @@ static int __init calgary_fixup_tce_spac
 			break;
 		if (!is_cal_pci_dev(dev->device))
 			continue;
-		if (!translate_phb(dev))
+
+		info = &bus_info[dev->bus->number];
+		if (info->translation_disabled)
 			continue;
 
-		tce_space = bus_info[dev->bus->number].tce_space;
-		if (!tce_space)
+		if (!info->tce_space)
 			continue;
 
 		calgary_fixup_one_tce_space(dev);
