Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZJBARy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZJBARy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZJBARw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:17:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:39257 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbZJBARr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:17:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,490,1249282800"; 
   d="scan'208";a="732246852"
Message-Id: <20091001230744.043037188@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 01 Oct 2009 16:06:17 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/4] dmar: Allocate queued invalidation structure using numa locality info
References: <20091001230743.949931468@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=qi_use_affinity_info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate queued invalidation descriptor structures using numa locality info.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/pci/dmar.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c
+++ tip/drivers/pci/dmar.c
@@ -1028,6 +1028,7 @@ static void __dmar_enable_qi(struct inte
 int dmar_enable_qi(struct intel_iommu *iommu)
 {
 	struct q_inval *qi;
+	struct page *desc_page;
 
 	if (!ecap_qis(iommu->ecap))
 		return -ENOENT;
@@ -1044,13 +1045,16 @@ int dmar_enable_qi(struct intel_iommu *i
 
 	qi = iommu->qi;
 
-	qi->desc = (void *)(get_zeroed_page(GFP_ATOMIC));
-	if (!qi->desc) {
+
+	desc_page = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO, 0);
+	if (!desc_page) {
 		kfree(qi);
 		iommu->qi = 0;
 		return -ENOMEM;
 	}
 
+	qi->desc = page_address(desc_page);
+
 	qi->desc_status = kmalloc(QI_LENGTH * sizeof(int), GFP_ATOMIC);
 	if (!qi->desc_status) {
 		free_page((unsigned long) qi->desc);


