Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYJHVf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYJHVf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYJHVfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:35:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:8676 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbYJHVfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:35:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,380,1220252400"; 
   d="scan'208";a="448772721"
Message-Id: <20081008210525.834190000@linux-os.sc.intel.com>
References: <20081008210101.487661000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 08 Oct 2008 14:01:02 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, youquan.song@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/4] tip, dmar: use spin_lock_irqsave() in qi_submit_sync()
Content-Disposition: inline; filename=fix_spin_lock_qi_submit_sync.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: use spin_lock_irqsave() in qi_submit_sync()

Next patch in the series will use queued invalidation interface
qi_submit_sync() for DMA-remapping aswell, which can be called from interrupt
context.

So use spin_lock_irqsave() instead of spin_lock() in qi_submit_sync().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c	2008-10-07 15:42:47.000000000 -0700
+++ tip/drivers/pci/dmar.c	2008-10-07 16:27:47.000000000 -0700
@@ -592,11 +592,11 @@
 
 	hw = qi->desc;
 
-	spin_lock(&qi->q_lock);
+	spin_lock_irqsave(&qi->q_lock, flags);
 	while (qi->free_cnt < 3) {
-		spin_unlock(&qi->q_lock);
+		spin_unlock_irqrestore(&qi->q_lock, flags);
 		cpu_relax();
-		spin_lock(&qi->q_lock);
+		spin_lock_irqsave(&qi->q_lock, flags);
 	}
 
 	index = qi->free_head;
@@ -617,15 +617,22 @@
 	qi->free_head = (qi->free_head + 2) % QI_LENGTH;
 	qi->free_cnt -= 2;
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
+	spin_lock(&iommu->register_lock);
 	/*
 	 * update the HW tail register indicating the presence of
 	 * new descriptors.
 	 */
 	writel(qi->free_head << 4, iommu->reg + DMAR_IQT_REG);
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	spin_unlock(&iommu->register_lock);
 
 	while (qi->desc_status[wait_index] != QI_DONE) {
+		/*
+		 * We will leave the interrupts disabled, to prevent interrupt
+		 * context to queue another cmd while a cmd is already submitted
+		 * and waiting for completion on this cpu. This is to avoid
+		 * a deadlock where the interrupt context can wait indefinitely
+		 * for free slots in the queue.
+		 */
 		spin_unlock(&qi->q_lock);
 		cpu_relax();
 		spin_lock(&qi->q_lock);
@@ -634,7 +641,7 @@
 	qi->desc_status[index] = QI_DONE;
 
 	reclaim_free_desc(qi);
-	spin_unlock(&qi->q_lock);
+	spin_unlock_irqrestore(&qi->q_lock, flags);
 }
 
 /*

-- 

