Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbYGJSsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbYGJSsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbYGJSmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:42:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:47639 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758915AbYGJSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="589105601"
Message-Id: <20080710182236.196737000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:36 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 02/26] x64, x2apic/intr-remap: fix the need for sequential array allocation of iommus
Content-Disposition: inline; filename=cleanup_dmar_g_iommu_logic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the intel-iommu code related to deferred iommu flush logic. There is
no need to allocate all the iommu's as a sequential array.

This will be used later in the interrupt-remapping patch series to
allocate iommu much early and individually for each device remapping
hardware unit.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/drivers/pci/dmar.c
===================================================================
--- tree-x86.orig/drivers/pci/dmar.c	2008-07-10 09:51:46.000000000 -0700
+++ tree-x86/drivers/pci/dmar.c	2008-07-10 09:51:49.000000000 -0700
@@ -377,11 +377,18 @@
 	return (ACPI_SUCCESS(status) ? 1 : 0);
 }
 
-struct intel_iommu *alloc_iommu(struct intel_iommu *iommu,
-				struct dmar_drhd_unit *drhd)
+struct intel_iommu *alloc_iommu(struct dmar_drhd_unit *drhd)
 {
+	struct intel_iommu *iommu;
 	int map_size;
 	u32 ver;
+	static int iommu_allocated = 0;
+
+	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
+	if (!iommu)
+		return NULL;
+
+	iommu->seq_id = iommu_allocated++;
 
 	iommu->reg = ioremap(drhd->reg_base_addr, PAGE_SIZE_4K);
 	if (!iommu->reg) {
Index: tree-x86/drivers/pci/intel-iommu.c
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.c	2008-07-10 09:51:46.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.c	2008-07-10 09:51:49.000000000 -0700
@@ -58,8 +58,6 @@
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
 
-static struct intel_iommu *g_iommus;
-
 #define HIGH_WATER_MARK 250
 struct deferred_flush_tables {
 	int next;
@@ -1649,8 +1647,6 @@
 	 * endfor
 	 */
 	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
-			continue;
 		g_num_of_iommus++;
 		/*
 		 * lock not needed as this is only incremented in the single
@@ -1659,26 +1655,17 @@
 		 */
 	}
 
-	g_iommus = kzalloc(g_num_of_iommus * sizeof(*iommu), GFP_KERNEL);
-	if (!g_iommus) {
-		ret = -ENOMEM;
-		goto error;
-	}
-
 	deferred_flush = kzalloc(g_num_of_iommus *
 		sizeof(struct deferred_flush_tables), GFP_KERNEL);
 	if (!deferred_flush) {
-		kfree(g_iommus);
 		ret = -ENOMEM;
 		goto error;
 	}
 
-	i = 0;
 	for_each_drhd_unit(drhd) {
 		if (drhd->ignored)
 			continue;
-		iommu = alloc_iommu(&g_iommus[i], drhd);
-		i++;
+		iommu = alloc_iommu(drhd);
 		if (!iommu) {
 			ret = -ENOMEM;
 			goto error;
@@ -1770,7 +1757,6 @@
 		iommu = drhd->iommu;
 		free_iommu(iommu);
 	}
-	kfree(g_iommus);
 	return ret;
 }
 
@@ -1927,7 +1913,10 @@
 	/* just flush them all */
 	for (i = 0; i < g_num_of_iommus; i++) {
 		if (deferred_flush[i].next) {
-			iommu_flush_iotlb_global(&g_iommus[i], 0);
+			struct intel_iommu *iommu =
+				deferred_flush[i].domain[0]->iommu;
+
+			iommu_flush_iotlb_global(iommu, 0);
 			for (j = 0; j < deferred_flush[i].next; j++) {
 				__free_iova(&deferred_flush[i].domain[j]->iovad,
 						deferred_flush[i].iova[j]);
@@ -1957,7 +1946,8 @@
 	if (list_size == HIGH_WATER_MARK)
 		flush_unmaps();
 
-	iommu_id = dom->iommu - g_iommus;
+	iommu_id = dom->iommu->seq_id;
+
 	next = deferred_flush[iommu_id].next;
 	deferred_flush[iommu_id].domain[next] = dom;
 	deferred_flush[iommu_id].iova[next] = iova;
Index: tree-x86/drivers/pci/intel-iommu.h
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.h	2008-07-10 09:51:46.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.h	2008-07-10 09:51:49.000000000 -0700
@@ -182,6 +182,7 @@
 	int		seg;
 	u32		gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */
 	spinlock_t	register_lock; /* protect register handling */
+	int		seq_id;	/* sequence id of the iommu */
 
 #ifdef CONFIG_DMAR
 	unsigned long 	*domain_ids; /* bitmap of domains */
@@ -198,8 +199,7 @@
 
 extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
 
-extern struct intel_iommu *alloc_iommu(struct intel_iommu *iommu,
-				       struct dmar_drhd_unit *drhd);
+extern struct intel_iommu *alloc_iommu(struct dmar_drhd_unit *drhd);
 extern void free_iommu(struct intel_iommu *iommu);
 
 #endif

-- 

