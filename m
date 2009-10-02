Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZJBSHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZJBSHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbZJBSHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:07:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:41689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbZJBSHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:07:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,495,1249282800"; 
   d="scan'208";a="454070730"
Message-Id: <20091002180257.695615271@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 02 Oct 2009 11:01:22 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rdreier@cisco.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/4] dmar: Allocate queued invalidation structure using numa locality info
References: <20091002180257.600389229@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=qi_use_affinity_info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate queued invalidation descriptor structures using numa locality info.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/pci/dmar.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: iommu-2.6/drivers/pci/dmar.c
===================================================================
--- iommu-2.6.orig/drivers/pci/dmar.c
+++ iommu-2.6/drivers/pci/dmar.c
@@ -1040,6 +1040,7 @@ static void __dmar_enable_qi(struct inte
 int dmar_enable_qi(struct intel_iommu *iommu)
 {
 	struct q_inval *qi;
+	struct page *desc_page;
 
 	if (!ecap_qis(iommu->ecap))
 		return -ENOENT;
@@ -1056,13 +1057,16 @@ int dmar_enable_qi(struct intel_iommu *i
 
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


