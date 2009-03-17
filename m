Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbZCQAcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbZCQAcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761902AbZCQA2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:9470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760497AbZCQA2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="395024234"
Message-Id: <20090317001321.535867000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:05:05 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 13/13] dmar: use atomic allocations for QI and Intr-remapping init
Content-Disposition: inline; filename=fix_dmar_non_atomic_allocations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queued invalidation and interrupt-remapping will get initialized with
interrupts disbaled (while enabling interrupt-remapping). So use
GFP_ATOMIC instead of GFP_KERNEL for memory alloacations.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c
+++ tip/drivers/pci/dmar.c
@@ -809,20 +809,20 @@ int dmar_enable_qi(struct intel_iommu *i
 	if (iommu->qi)
 		return 0;
 
-	iommu->qi = kmalloc(sizeof(*qi), GFP_KERNEL);
+	iommu->qi = kmalloc(sizeof(*qi), GFP_ATOMIC);
 	if (!iommu->qi)
 		return -ENOMEM;
 
 	qi = iommu->qi;
 
-	qi->desc = (void *)(get_zeroed_page(GFP_KERNEL));
+	qi->desc = (void *)(get_zeroed_page(GFP_ATOMIC));
 	if (!qi->desc) {
 		kfree(qi);
 		iommu->qi = 0;
 		return -ENOMEM;
 	}
 
-	qi->desc_status = kmalloc(QI_LENGTH * sizeof(int), GFP_KERNEL);
+	qi->desc_status = kmalloc(QI_LENGTH * sizeof(int), GFP_ATOMIC);
 	if (!qi->desc_status) {
 		free_page((unsigned long) qi->desc);
 		kfree(qi);
Index: tip/drivers/pci/intr_remapping.c
===================================================================
--- tip.orig/drivers/pci/intr_remapping.c
+++ tip/drivers/pci/intr_remapping.c
@@ -447,12 +447,12 @@ static int setup_intr_remapping(struct i
 	struct page *pages;
 
 	ir_table = iommu->ir_table = kzalloc(sizeof(struct ir_table),
-					     GFP_KERNEL);
+					     GFP_ATOMIC);
 
 	if (!iommu->ir_table)
 		return -ENOMEM;
 
-	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, INTR_REMAP_PAGE_ORDER);
+	pages = alloc_pages(GFP_ATOMIC | __GFP_ZERO, INTR_REMAP_PAGE_ORDER);
 
 	if (!pages) {
 		printk(KERN_ERR "failed to allocate pages of order %d\n",

-- 

